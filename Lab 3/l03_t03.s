/*
-------------------------------------------------------
l03_t03.s
An infinite loop program with a timer delay and
LED display.
-------------------------------------------------------
Author:  Nish Tewari 
ID:      190684430
Email:   tewa4430@mylaurier.ca
Date:    2021-02-01
-------------------------------------------------------
*/
// Constants
.equ TIMER, 0xfffec600
.equ LEDS,  0xff200000
//.equ LED_BITS, 0x0F0F0F0F
.org	0x1000	// Start at memory location 1000
.text  // Code section
.global _start
_start:

LDR     R0, =LEDS		    // LEDs base address
LDR     R1, =TIMER		  // private timer base address
LDR     R2, =LED_BITS	  // value to set LEDs
LDR     R2, [R2]
LDR     R3, =DELAY_TIME
LDR     R3, [R3]

// timeout = 1/(200 MHz) x 200x10^6 = 1 sec

STR     R3, [R1]	    	// write timeout to timer load register
MOV     R3, #0b011		  // set bits: mode = 1 (auto), enable = 1
STR     R3, [R1, #0x8]	// write to timer control register

LOOP:
STR     R2, [R0]		    // load the LEDs
WAIT:
LDR     R3, [R1, #0xC]	// read timer status
CMP     R3, #0
BEQ     WAIT			      // wait for timer to expire
STR     R3, [R1, #0xC]	// reset timer flag bit
ROR	    R2, #1			    // rotate the LED bits
B LOOP


@data section 
.data 

DELAY_TIME: .word 200000000 
LED_BITS: 	.word 0x0F0F0F0F

.end
