;********************************************************
; PRATICA2.ASM
; Prof. Maurílio J. Inácio
; Engenharia de Sistemas
; Unimontes / 2016
;
;*************************************************
;--------------------------------------------------
; Configuração do microcontrolador
;----------------------------------------------------
	list p=18F4550 ; define o modelo do microcontrolador
	#include <p18f4550.inc> ; inclui um arquivo adicional
	CONFIG WDT=OFF ; desabilita o Watchdog Timer
	CONFIG MCLRE = ON ; define o estado do pino MCLEAR
	CONFIG DEBUG = ON ; habilita o Debug Mode
	CONFIG LVP = OFF ; desabilita o modo Low-Voltage Programming
	CONFIG FOSC = HS ; define o oscilador externo tipo HS
;-----------------------------------------------------
; Definição de rótulos
;-----------------------------------------------------
	
	
	#define BUZZER PORTC,1 ; rótulo para o Buzzer
	#define BOTAO1 PORTE,1 ; rótulo para o botão 1
	#define BOTAO2 PORTE,2 ; rótulo para o botão 2
	
	#define SEGE PORTB,3 ; ROTULO PARA 
	#define SEGD PORTB,2 ; ROTULO PARA 
	#define SEGG PORTB,1 ; ROTULO PARA 	
	#define SEGC PORTB,0 ; ROTULO PARA 	
	#define SEGF PORTC,7 ; ROTULO PARA 
	#define SEGA PORTC,6 ; ROTULO PARA 
	#define SEGB PORTD,2 ; ROTULO PARA 
	
	#define SEGEE PORTB,7 ; ROTULO PARA 
	#define SEGDD PORTB,6 ; ROTULO PARA 
	
	#define SEGCC PORTB,5 ; ROTULO PARA 
	#define SEGFF PORTD,7 ; ROTULO PARA 
	#define SEGGG PORTD,6 ; ROTULO PARA 
	#define SEGAA PORTD,5 ; ROTULO PARA 
	#define SEGBB PORTD,4 ; ROTULO PARA 

;------------------------------------------------------
; Declaração de variáveis
;----------------------------------------------
	CBLOCK 0X20
	delay_val  ; variável auxiliar
	delay_x50  ; variável auxiliar
	delay_x200 ; variável auxiliar
	ENDC
;-------------------------------------------------------
; Rotina principal
;---------------------------------------------------------
org 0x1000 ; endereço inicial do programa
;	org 0x0000 ; endereço inicial do programa

	clrf PORTC ; limpa a porta C
	clrf PORTE ; limpa a porta E
	clrf PORTB ; limpa a porta B
	clrf PORTD ; limpa a porta D
	clrf PORTA 
	movlw b'00000000' ; configura os pinos da porta B
	movwf TRISB
	movlw b'00000000' ; configura os pinos da porta D
	movwf TRISD
	movlw b'00000000' ; configura os pinos da porta C
	movwf TRISC
	movlw b'11111111' ; configura os pinos da porta B
	movwf TRISE
	movlw b'00001111' ; desativa as entradas analógicas
	movwf ADCON1
	movlw b'11111111' ; config 
	movwf TRISA
	
	
	movlw b'00001111'
	movwf ADCON1 
	;COMF
	;COMF ESTADO,1

INICIO

	bcf SEGA
	bcf SEGB
	bcf SEGC
	bcf SEGD
	bcf SEGE
	bcf SEGF
	bsf SEGG
 
	bcf BUZZER ; desliga o buzzer
	call ZEROO
	btfss BOTAO1
	GOTO INICIO 
;	CPFSEQ ESTADO
;	GOTO INICIO
	GOTO PRINCIPAL	

PRINCIPAL
	call ZEROO
	CALL ZEROS
	CALL DEZENA
	CALL UMM
	CALL DEZENA
	CALL DOISS
	CALL DEZENA
	CALL TRESS
	CALL DEZENA
	CALL QUATROO
	CALL DEZENA
	CALL CINCOO
	CALL DEZENA
	CALL SEISS
	CALL DEZENA
	CALL SETEE
	CALL DEZENA
	CALL OITOO
	CALL DEZENA
	CALL NOVEE
	CALL DEZENA
	GOTO INICIO


VERIFICA_BOTAO1
	btfss BOTAO1 ; verifica se botão1 está pressionado
	goto VERIFICA_BOTAO2 ; desvia para VERIFICA_BOTAO2 se não estiver pressionado
	bsf BUZZER ; liga o buzzer
	movlw 0x32 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	bcf BUZZER ; desliga o buzzer
	movlw 0x32 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	goto INICIO ; desvia para o início do programa

VERIFICA_BOTAO2
	btfss BOTAO2 ; verifica se o botão2 está pressionado
	goto INICIO ; desvia para INICIO se não estiver pressionado
	bsf BUZZER ; liga o buzzer
	movlw 0xC8 ; carrega W com o delay desejado (2s)
	call DELAY ; chama a sub-rotina DELAY
	bcf BUZZER ; desliga o buzzer
	movlw 0xC8 ; carrega W com o delay desejado (2s)
	call DELAY ; chama a sub-rotina DELAY
	goto INICIO ; desvia para o início do programa
;-------------------------------------------------------
; Sub-rotina DELAY
; Gera um delay entre 10ms e 2,55s aproximadamente
; O valor do delay é passado pelo registrador W (1 a 255)
; A base de tempo da sub-rotina é 0,2 us (período do clock de 20MHz/4)
;--------------------------------------------------------------
DELAY
	movwf delay_val ; carrega o valor do delay desejado
	Del_10ms ; delay de 10 mS
	movlw 0x32 ; fator de multiplicação por 50
	movwf delay_x50 ; variável auxiliar
	Del_200us ; delay de 200 us
	movlw 0xC8 ; fator de multiplicação por 200
	movwf delay_x200 ; variável auxiliar
	Loop ; início do loop
	nop ; não faz nada
	nop ; não faz nada
	decfsz delay_x200,f ; decrementa delay_x200 e desvia se for 0
	goto Loop ; se não for zero, desvia para Loop
	decfsz delay_x50,f ; decrementa delay_x50 e desvia se for 0
	goto Del_200us ; se não for zero, desvia para Del_200us
	decfsz delay_val,f ; decrementa delay_val e desvia se for 0
	goto Del_10ms ; se não for zero, desvia para Del_10ms
	return ; retorno da sub-rotina

PAUSA
	bsf BUZZER ; desliga o buzzer
	movlw 0x16 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	bcf BUZZER ; desliga o buzzer
	btfsC BOTAO1 ; se estiver apertado, faz a proxima 
	CALL PAUSA2
	bsf BUZZER ; desliga o buzzer
	movlw 0x16 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	bcf BUZZER ; desliga o buzzer
	RETURN
	
PAUSA2
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	btfsC BOTAO1
	RETURN
	GOTO PAUSA2	


DEZENA
	btfsC BOTAO1
	CALL PAUSA	
	btfsC BOTAO2
	GOTO PRINCIPAL
	call UM

	btfsC BOTAO1
	CALL PAUSA
	btfsC BOTAO2
	GOTO PRINCIPAL
	call DOIS
	
	

	btfsC BOTAO1
	CALL PAUSA
	btfsC BOTAO2
	GOTO PRINCIPAL
	call TRES
	
	

	btfsC BOTAO1
	CALL PAUSA
	btfsC BOTAO2
	GOTO PRINCIPAL
	call QUATRO
	
	
	
	btfsC BOTAO1
	CALL PAUSA
	btfsC BOTAO2
	GOTO PRINCIPAL
	call CINCO
	
	btfsC BOTAO1
	CALL PAUSA
	btfsC BOTAO2
	GOTO PRINCIPAL
	call SEIS
	
	btfsC BOTAO1
	CALL PAUSA
	btfsC BOTAO2
	GOTO PRINCIPAL
	call SETE

	btfsC BOTAO1
	CALL PAUSA
	btfsC BOTAO2
	GOTO PRINCIPAL
	call OITO


	btfsC BOTAO1
	CALL PAUSA
	btfsC BOTAO2
	GOTO PRINCIPAL
	call NOVE

	btfsC BOTAO1
	CALL PAUSA
	btfsC BOTAO2
	GOTO PRINCIPAL
	CALL ZERO

	RETURN

ZEROS
	
	bcf SEGA
	bcf SEGB
	bcf SEGC
	bcf SEGD
	bcf SEGE
	bcf SEGF
	bsf SEGG
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY


	return


ZERO
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY

	bcf SEGA
	bcf SEGB
	bcf SEGC
	bcf SEGD
	bcf SEGE
	bcf SEGF
	bsf SEGG
	return
	


UM
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY

	bsf SEGA
	bcf SEGB
	bcf SEGC
	bsf SEGD
	bsf SEGE
	bsf SEGF
	bsf SEGG
	return

DOIS

	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY

	bcf SEGA
	bcf SEGB
	bsf SEGC
	bcf SEGD
	bcf SEGE
	bsf SEGF
	bcf SEGG
	return

TRES
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY

	bcf SEGA
	bcf SEGB
	bcf SEGC
	bcf SEGD
	bsf SEGE
	bsf SEGF
	bcf SEGG
	return
	
QUATRO
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY

	bsf SEGA
	bcf SEGB
	bcf SEGC
	bsf SEGD
	bsf SEGE
	bcf SEGF
	bcf SEGG
	return

CINCO

	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY

	bcf SEGA
	bsf SEGB
	bcf SEGC
	bcf SEGD
	bsf SEGE
	bcf SEGF
	bcf SEGG
	return

SEIS
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY

	bcf SEGA
	bsf SEGB
	bcf SEGC
	bcf SEGD
	bcf SEGE
	bcf SEGF
	bcf SEGG
	return
	
SETE
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY

	bcf SEGA
	bcf SEGB
	bcf SEGC
	bsf SEGD
	bsf SEGE
	bcf SEGF
	bsf SEGG
	return
OITO
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY

	bcf SEGA
	bcf SEGB
	bcf SEGC
	bcf SEGD
	bcf SEGE
	bcf SEGF
	bcf SEGG
	return
NOVE
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY
	movlw 0x64 ; carrega W com o delay desejado (0,5s)
	call DELAY ; chama a sub-rotina DELAY

	bcf SEGA
	bcf SEGB
	bcf SEGC
	bcf SEGD
	bsf SEGE
	bcf SEGF
	bcf SEGG
	return


ZEROO
	bcf SEGAA
	bcf SEGBB
	bcf SEGCC
	bcf SEGDD
	bcf SEGEE
	bcf SEGFF
	bsf SEGGG
	return

UMM
	bsf SEGAA
	bcf SEGBB
	bcf SEGCC
	bsf SEGDD
	bsf SEGEE
	bsf SEGFF
	bsf SEGGG
	return

DOISS
	bcf SEGAA
	bcf SEGBB
	bsf SEGCC
	bcf SEGDD
	bcf SEGEE
	bsf SEGFF
	bcf SEGGG
	return

TRESS
	bcf SEGAA
	bcf SEGBB
	bcf SEGCC
	bcf SEGDD
	bsf SEGEE
	bsf SEGFF
	bcf SEGGG
	return
	
QUATROO
	bsf SEGAA
	bcf SEGBB
	bcf SEGCC
	bsf SEGDD
	bsf SEGEE
	bcf SEGFF
	bcf SEGGG
	return

CINCOO
	bcf SEGAA
	bsf SEGBB
	bcf SEGCC
	bcf SEGDD
	bsf SEGEE
	bcf SEGFF
	bcf SEGGG
	return

SEISS
	bcf SEGAA
	bsf SEGBB
	bcf SEGCC
	bcf SEGDD
	bcf SEGEE
	bcf SEGFF
	bcf SEGGG
	return
	
SETEE
	bcf SEGAA
	bcf SEGBB
	bcf SEGCC
	bsf SEGDD
	bsf SEGEE
	bcf SEGFF
	bsf SEGGG
	return

OITOO
	bcf SEGAA
	bcf SEGBB
	bcf SEGCC
	bcf SEGDD
	bcf SEGEE
	bcf SEGFF
	bcf SEGGG
	return

NOVEE
	bcf SEGAA
	bcf SEGBB
	bcf SEGCC
	bcf SEGDD
	bsf SEGEE
	bcf SEGFF
	bcf SEGGG
	return
end
