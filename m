Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621222D7972
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392710AbgLKPc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:32:28 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:56803 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731337AbgLKPcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 10:32:03 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4CsvqW2CTMz9v0BR;
        Fri, 11 Dec 2020 16:30:15 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id LhHlD9zosI41; Fri, 11 Dec 2020 16:30:15 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4CsvqW0VbSz9v0BQ;
        Fri, 11 Dec 2020 16:30:15 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 9728D8B86D;
        Fri, 11 Dec 2020 16:30:16 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id M9jqs3NxUGs3; Fri, 11 Dec 2020 16:30:16 +0100 (CET)
Received: from po17688vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 55D628B869;
        Fri, 11 Dec 2020 16:30:14 +0100 (CET)
Received: by po17688vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 91D5865514; Fri, 11 Dec 2020 15:30:13 +0000 (UTC)
Message-Id: <ed5acd21af5e52595b1ad53ac4dc54127b1ce392.1607696754.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [RFC PATCH v1] powerpc/net: Implement eBPF on PPC32
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Fri, 11 Dec 2020 15:30:13 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This first draft of eBPF for PPC32. This is still dirty WIP.

Don't pay too much attention on comments, most of them are copied
as is from PPC64 implementation.

Test result:

	test_bpf: Summary: 378 PASSED, 0 FAILED, [332/366 JIT'ed]

Registers mapping:

	[BPF_REG_0] = r21-r22
	/* function arguments */
	[BPF_REG_1] = r3-r4
	[BPF_REG_2] = r5-r6
	[BPF_REG_3] = r7-r8
	[BPF_REG_4] = r9-r10
	[BPF_REG_5] = r11-r12
	/* non volatile registers */
	[BPF_REG_6] = r23-r24
	[BPF_REG_7] = r25-r26
	[BPF_REG_8] = r27-r28
	[BPF_REG_9] = r29-r30
	/* frame pointer aka BPF_REG_10 */
	[BPF_REG_FP] = r31
	/* eBPF jit internal registers */
	[BPF_REG_AX] = r19-r20
	[TMP_REG] = r18

r0 is also used as temporary register as much as possible. It is
referenced directly in the code in order to avoid misuse of it, as
some instructions interpret it as value 0 instead of register r0.

The following operations are not (or only partially) supported
for the time being:

		case BPF_ALU64 | BPF_DIV | BPF_X: /* dst /= src */
		case BPF_ALU64 | BPF_MOD | BPF_X: /* dst %= src */
		case BPF_ALU64 | BPF_MOD | BPF_K: /* dst %= imm */
		case BPF_ALU64 | BPF_DIV | BPF_K: /* dst /= imm */
		case BPF_ALU64 | BPF_LSH | BPF_X: /* dst <<= src; */
		case BPF_ALU64 | BPF_LSH | BPF_K: /* dst <<== imm */
		case BPF_ALU64 | BPF_RSH | BPF_X: /* dst >>= src */
		case BPF_ALU64 | BPF_RSH | BPF_K: /* dst >>= imm */
		case BPF_ALU64 | BPF_ARSH | BPF_X: /* (s64) dst >>= src */
		case BPF_ALU64 | BPF_ARSH | BPF_K: /* (s64) dst >>= imm */
		case BPF_STX | BPF_XADD | BPF_DW: /* *(u64 *)(dst + off) += src */

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/Kconfig                  |    3 +-
 arch/powerpc/include/asm/ppc-opcode.h |   11 +
 arch/powerpc/net/Makefile             |    6 +-
 arch/powerpc/net/bpf_jit32.h          |  173 ++--
 arch/powerpc/net/bpf_jit_asm.S        |  226 -----
 arch/powerpc/net/bpf_jit_comp.c       |  683 --------------
 arch/powerpc/net/bpf_jit_comp32.c     | 1177 +++++++++++++++++++++++++
 7 files changed, 1249 insertions(+), 1030 deletions(-)
 delete mode 100644 arch/powerpc/net/bpf_jit_asm.S
 delete mode 100644 arch/powerpc/net/bpf_jit_comp.c
 create mode 100644 arch/powerpc/net/bpf_jit_comp32.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9e679ba0811c..dd6ccd550230 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -190,7 +190,6 @@ config PPC
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ASM_MODVERSIONS
 	select HAVE_C_RECORDMCOUNT
-	select HAVE_CBPF_JIT			if !PPC64
 	select HAVE_STACKPROTECTOR		if PPC64 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r13)
 	select HAVE_STACKPROTECTOR		if PPC32 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r2)
 	select HAVE_CONTEXT_TRACKING		if PPC64
@@ -199,7 +198,7 @@ config PPC
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS	if MPROFILE_KERNEL
-	select HAVE_EBPF_JIT			if PPC64
+	select HAVE_EBPF_JIT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS	if !(CPU_LITTLE_ENDIAN && POWER7_CPU)
 	select HAVE_FAST_GUP
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index a6e3700c4566..0cefa1da9a1f 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -417,6 +417,7 @@
 #define PPC_RAW_LD(r, base, i)		(PPC_INST_LD | ___PPC_RT(r) | ___PPC_RA(base) | IMM_DS(i))
 #define PPC_RAW_LWZ(r, base, i)		(0x80000000 | ___PPC_RT(r) | ___PPC_RA(base) | IMM_L(i))
 #define PPC_RAW_LWZX(t, a, b)		(0x7c00002e | ___PPC_RT(t) | ___PPC_RA(a) | ___PPC_RB(b))
+#define PPC_RAW_LMW(r, base, i)		(0xb8000000 | ___PPC_RT(r) | ___PPC_RA(base) | IMM_L(i))
 #define PPC_RAW_STD(r, base, i)		(PPC_INST_STD | ___PPC_RS(r) | ___PPC_RA(base) | IMM_DS(i))
 #define PPC_RAW_STDCX(s, a, b)		(0x7c0001ad | ___PPC_RS(s) | ___PPC_RA(a) | ___PPC_RB(b))
 #define PPC_RAW_LFSX(t, a, b)		(0x7c00042e | ___PPC_RT(t) | ___PPC_RA(a) | ___PPC_RB(b))
@@ -425,6 +426,9 @@
 #define PPC_RAW_STFDX(s, a, b)		(0x7c0005ae | ___PPC_RS(s) | ___PPC_RA(a) | ___PPC_RB(b))
 #define PPC_RAW_LVX(t, a, b)		(0x7c0000ce | ___PPC_RT(t) | ___PPC_RA(a) | ___PPC_RB(b))
 #define PPC_RAW_STVX(s, a, b)		(0x7c0001ce | ___PPC_RS(s) | ___PPC_RA(a) | ___PPC_RB(b))
+#define PPC_RAW_ADDE(t, a, b)		(0x7c000114 | ___PPC_RT(t) | ___PPC_RA(a) | ___PPC_RB(b))
+#define PPC_RAW_ADDZE(t, a)		(0x7c000194 | ___PPC_RT(t) | ___PPC_RA(a))
+#define PPC_RAW_ADDME(t, a)		(0x7c0001d4 | ___PPC_RT(t) | ___PPC_RA(a))
 #define PPC_RAW_ADD(t, a, b)		(PPC_INST_ADD | ___PPC_RT(t) | ___PPC_RA(a) | ___PPC_RB(b))
 #define PPC_RAW_ADD_DOT(t, a, b)	(PPC_INST_ADD | ___PPC_RT(t) | ___PPC_RA(a) | ___PPC_RB(b) | 0x1)
 #define PPC_RAW_ADDC(t, a, b)		(0x7c000014 | ___PPC_RT(t) | ___PPC_RA(a) | ___PPC_RB(b))
@@ -443,6 +447,7 @@
 #define PPC_RAW_STDU(r, base, i)	(0xf8000001 | ___PPC_RS(r) | ___PPC_RA(base) | ((i) & 0xfffc))
 #define PPC_RAW_STW(r, base, i)		(0x90000000 | ___PPC_RS(r) | ___PPC_RA(base) | IMM_L(i))
 #define PPC_RAW_STWU(r, base, i)	(0x94000000 | ___PPC_RS(r) | ___PPC_RA(base) | IMM_L(i))
+#define PPC_RAW_STMW(r, base, i)	(0xbc000000 | ___PPC_RS(r) | ___PPC_RA(base) | IMM_L(i))
 #define PPC_RAW_STH(r, base, i)		(0xb0000000 | ___PPC_RS(r) | ___PPC_RA(base) | IMM_L(i))
 #define PPC_RAW_STB(r, base, i)		(0x98000000 | ___PPC_RS(r) | ___PPC_RA(base) | IMM_L(i))
 #define PPC_RAW_LBZ(r, base, i)		(0x88000000 | ___PPC_RT(r) | ___PPC_RA(base) | IMM_L(i))
@@ -460,6 +465,10 @@
 #define PPC_RAW_CMPLW(a, b)		(0x7c000040 | ___PPC_RA(a) | ___PPC_RB(b))
 #define PPC_RAW_CMPLD(a, b)		(0x7c200040 | ___PPC_RA(a) | ___PPC_RB(b))
 #define PPC_RAW_SUB(d, a, b)		(0x7c000050 | ___PPC_RT(d) | ___PPC_RB(a) | ___PPC_RA(b))
+#define PPC_RAW_SUBFC(d, a, b)		(0x7c000010 | ___PPC_RT(d) | ___PPC_RA(a) | ___PPC_RB(b))
+#define PPC_RAW_SUBFE(d, a, b)		(0x7c000110 | ___PPC_RT(d) | ___PPC_RA(a) | ___PPC_RB(b))
+#define PPC_RAW_SUBFIC(d, a, i)		(0x20000000 | ___PPC_RT(d) | ___PPC_RA(a) | IMM_L(i))
+#define PPC_RAW_SUBFZE(d, a)		(0x7c000190 | ___PPC_RT(d) | ___PPC_RA(a))
 #define PPC_RAW_MULD(d, a, b)		(0x7c0001d2 | ___PPC_RT(d) | ___PPC_RA(a) | ___PPC_RB(b))
 #define PPC_RAW_MULW(d, a, b)		(0x7c0001d6 | ___PPC_RT(d) | ___PPC_RA(a) | ___PPC_RB(b))
 #define PPC_RAW_MULHWU(d, a, b)		(0x7c000016 | ___PPC_RT(d) | ___PPC_RA(a) | ___PPC_RB(b))
@@ -472,11 +481,13 @@
 #define PPC_RAW_DIVDEU_DOT(t, a, b)	(0x7c000312 | ___PPC_RT(t) | ___PPC_RA(a) | ___PPC_RB(b) | 0x1)
 #define PPC_RAW_AND(d, a, b)		(0x7c000038 | ___PPC_RA(d) | ___PPC_RS(a) | ___PPC_RB(b))
 #define PPC_RAW_ANDI(d, a, i)		(0x70000000 | ___PPC_RA(d) | ___PPC_RS(a) | IMM_L(i))
+#define PPC_RAW_ANDIS(d, a, i)		(0x74000000 | ___PPC_RA(d) | ___PPC_RS(a) | IMM_L(i))
 #define PPC_RAW_AND_DOT(d, a, b)	(0x7c000039 | ___PPC_RA(d) | ___PPC_RS(a) | ___PPC_RB(b))
 #define PPC_RAW_OR(d, a, b)		(0x7c000378 | ___PPC_RA(d) | ___PPC_RS(a) | ___PPC_RB(b))
 #define PPC_RAW_MR(d, a)		PPC_RAW_OR(d, a, a)
 #define PPC_RAW_ORI(d, a, i)		(PPC_INST_ORI | ___PPC_RA(d) | ___PPC_RS(a) | IMM_L(i))
 #define PPC_RAW_ORIS(d, a, i)		(PPC_INST_ORIS | ___PPC_RA(d) | ___PPC_RS(a) | IMM_L(i))
+#define PPC_RAW_NOR(d, a, b)		(0x7c0000f8 | ___PPC_RA(d) | ___PPC_RS(a) | ___PPC_RB(b))
 #define PPC_RAW_XOR(d, a, b)		(0x7c000278 | ___PPC_RA(d) | ___PPC_RS(a) | ___PPC_RB(b))
 #define PPC_RAW_XORI(d, a, i)		(0x68000000 | ___PPC_RA(d) | ___PPC_RS(a) | IMM_L(i))
 #define PPC_RAW_XORIS(d, a, i)		(0x6c000000 | ___PPC_RA(d) | ___PPC_RS(a) | IMM_L(i))
diff --git a/arch/powerpc/net/Makefile b/arch/powerpc/net/Makefile
index c2dec3a68d4c..bfc17c54e39a 100644
--- a/arch/powerpc/net/Makefile
+++ b/arch/powerpc/net/Makefile
@@ -2,8 +2,4 @@
 #
 # Arch-specific network modules
 #
-ifdef CONFIG_PPC64
-obj-$(CONFIG_BPF_JIT) += bpf_jit_comp64.o
-else
-obj-$(CONFIG_BPF_JIT) += bpf_jit_asm.o bpf_jit_comp.o
-endif
+obj-$(CONFIG_BPF_JIT) += bpf_jit_comp$(BITS).o
diff --git a/arch/powerpc/net/bpf_jit32.h b/arch/powerpc/net/bpf_jit32.h
index 448dfd4d98e1..f6f0aa87eedf 100644
--- a/arch/powerpc/net/bpf_jit32.h
+++ b/arch/powerpc/net/bpf_jit32.h
@@ -1,139 +1,84 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * bpf_jit32.h: BPF JIT compiler for PPC
+ * bpf_jit32.h: BPF JIT compiler for PPC32
  *
- * Copyright 2011 Matt Evans <matt@ozlabs.org>, IBM Corporation
- *
- * Split from bpf_jit.h
+ * Copyright 2016 Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
+ *		  IBM Corporation
  */
 #ifndef _BPF_JIT32_H
 #define _BPF_JIT32_H
 
-#include <asm/asm-compat.h>
 #include "bpf_jit.h"
 
-#ifdef CONFIG_PPC64
-#define BPF_PPC_STACK_R3_OFF	48
-#define BPF_PPC_STACK_LOCALS	32
-#define BPF_PPC_STACK_BASIC	(48+64)
-#define BPF_PPC_STACK_SAVE	(18*8)
-#define BPF_PPC_STACKFRAME	(BPF_PPC_STACK_BASIC+BPF_PPC_STACK_LOCALS+ \
-				 BPF_PPC_STACK_SAVE)
-#define BPF_PPC_SLOWPATH_FRAME	(48+64)
-#else
-#define BPF_PPC_STACK_R3_OFF	24
-#define BPF_PPC_STACK_LOCALS	16
-#define BPF_PPC_STACK_BASIC	(24+32)
-#define BPF_PPC_STACK_SAVE	(18*4)
-#define BPF_PPC_STACKFRAME	(BPF_PPC_STACK_BASIC+BPF_PPC_STACK_LOCALS+ \
-				 BPF_PPC_STACK_SAVE)
-#define BPF_PPC_SLOWPATH_FRAME	(24+32)
-#endif
-
-#define REG_SZ         (BITS_PER_LONG/8)
-
 /*
- * Generated code register usage:
- *
- * As normal PPC C ABI (e.g. r1=sp, r2=TOC), with:
+ * Stack layout:
  *
- * skb		r3	(Entry parameter)
- * A register	r4
- * X register	r5
- * addr param	r6
- * r7-r10	scratch
- * skb->data	r14
- * skb headlen	r15	(skb->len - skb->data_len)
- * m[0]		r16
- * m[...]	...
- * m[15]	r31
+ *		[	prev sp		] <-------------
+ *		[   nv gpr save area	] 6*8		|
+ *		[    tail_call_cnt	] 8		|
+ *		[    local_tmp_var	] 8		|
+ * fp (r31) -->	[   ebpf stack space	] upto 512	|
+ *		[     frame header	] 32/112	|
+ * sp (r1) --->	[    stack pointer	] --------------
  */
-#define r_skb		3
-#define r_ret		3
-#define r_A		4
-#define r_X		5
-#define r_addr		6
-#define r_scratch1	7
-#define r_scratch2	8
-#define r_D		14
-#define r_HL		15
-#define r_M		16
-
-#ifndef __ASSEMBLY__
-
-/*
- * Assembly helpers from arch/powerpc/net/bpf_jit.S:
- */
-#define DECLARE_LOAD_FUNC(func)	\
-	extern u8 func[], func##_negative_offset[], func##_positive_offset[]
-
-DECLARE_LOAD_FUNC(sk_load_word);
-DECLARE_LOAD_FUNC(sk_load_half);
-DECLARE_LOAD_FUNC(sk_load_byte);
-DECLARE_LOAD_FUNC(sk_load_byte_msh);
 
-#define PPC_LBZ_OFFS(r, base, i) do { if ((i) < 32768) EMIT(PPC_RAW_LBZ(r, base, i));   \
-		else {	EMIT(PPC_RAW_ADDIS(r, base, IMM_HA(i)));	      \
-			EMIT(PPC_RAW_LBZ(r, r, IMM_L(i))); } } while(0)
-
-#define PPC_LD_OFFS(r, base, i) do { if ((i) < 32768) EMIT(PPC_RAW_LD(r, base, i));     \
-		else {	EMIT(PPC_RAW_ADDIS(r, base, IMM_HA(i)));			\
-			EMIT(PPC_RAW_LD(r, r, IMM_L(i))); } } while(0)
-
-#define PPC_LWZ_OFFS(r, base, i) do { if ((i) < 32768) EMIT(PPC_RAW_LWZ(r, base, i));   \
-		else {	EMIT(PPC_RAW_ADDIS(r, base, IMM_HA(i)));			\
-			EMIT(PPC_RAW_LWZ(r, r, IMM_L(i))); } } while(0)
-
-#define PPC_LHZ_OFFS(r, base, i) do { if ((i) < 32768) EMIT(PPC_RAW_LHZ(r, base, i));   \
-		else {	EMIT(PPC_RAW_ADDIS(r, base, IMM_HA(i)));			\
-			EMIT(PPC_RAW_LHZ(r, r, IMM_L(i))); } } while(0)
-
-#ifdef CONFIG_PPC64
-#define PPC_LL_OFFS(r, base, i) do { PPC_LD_OFFS(r, base, i); } while(0)
-#else
-#define PPC_LL_OFFS(r, base, i) do { PPC_LWZ_OFFS(r, base, i); } while(0)
-#endif
+/* for gpr non volatile registers BPG_REG_6 to 10 */
+#define BPF_PPC_STACK_SAVE	((17+3)*4)
+/* for bpf JIT code internal usage */
+#define BPF_PPC_STACK_LOCALS	16
+/* stack frame excluding BPF stack, ensure this is quadword aligned */
+#define BPF_PPC_STACKFRAME	(STACK_FRAME_MIN_SIZE + \
+				 BPF_PPC_STACK_LOCALS + BPF_PPC_STACK_SAVE)
 
-#ifdef CONFIG_SMP
-#ifdef CONFIG_PPC64
-#define PPC_BPF_LOAD_CPU(r)		\
-	do { BUILD_BUG_ON(sizeof_field(struct paca_struct, paca_index) != 2);	\
-		PPC_LHZ_OFFS(r, 13, offsetof(struct paca_struct, paca_index));	\
-	} while (0)
-#else
-#define PPC_BPF_LOAD_CPU(r)     \
-	do { BUILD_BUG_ON(sizeof_field(struct task_struct, cpu) != 4);		\
-		PPC_LHZ_OFFS(r, 2, offsetof(struct task_struct, cpu));		\
-	} while(0)
-#endif
-#else
-#define PPC_BPF_LOAD_CPU(r) do { EMIT(PPC_RAW_LI(r, 0)); } while(0)
-#endif
+#ifndef __ASSEMBLY__
 
-#define PPC_LHBRX_OFFS(r, base, i) \
-		do { PPC_LI32(r, i); EMIT(PPC_RAW_LHBRX(r, r, base)); } while(0)
-#ifdef __LITTLE_ENDIAN__
-#define PPC_NTOHS_OFFS(r, base, i)	PPC_LHBRX_OFFS(r, base, i)
-#else
-#define PPC_NTOHS_OFFS(r, base, i)	PPC_LHZ_OFFS(r, base, i)
-#endif
+/* BPF register usage */
+#define TMP_REG	(MAX_BPF_JIT_REG + 0)
+
+/* BPF to ppc register mappings */
+static const int b2p[] = {
+	/* function return value */
+	[BPF_REG_0] = 22,
+	/* function arguments */
+	[BPF_REG_1] = 4,
+	[BPF_REG_2] = 6,
+	[BPF_REG_3] = 8,
+	[BPF_REG_4] = 10,
+	[BPF_REG_5] = 12,
+	/* non volatile registers */
+	[BPF_REG_6] = 24,
+	[BPF_REG_7] = 26,
+	[BPF_REG_8] = 28,
+	[BPF_REG_9] = 30,
+	/* frame pointer aka BPF_REG_10 */
+	[BPF_REG_FP] = 31,
+	/* eBPF jit internal registers */
+	[BPF_REG_AX] = 20,
+	[TMP_REG] = 18,
+};
 
-#define PPC_BPF_LL(r, base, i) do { EMIT(PPC_RAW_LWZ(r, base, i)); } while(0)
-#define PPC_BPF_STL(r, base, i) do { EMIT(PPC_RAW_STW(r, base, i)); } while(0)
-#define PPC_BPF_STLU(r, base, i) do { EMIT(PPC_RAW_STWU(r, base, i)); } while(0)
+/* PPC NVR range -- update this if we ever use NVRs below r27 */
+#define BPF_PPC_NVR_MIN		18
 
-#define SEEN_DATAREF 0x10000 /* might call external helpers */
-#define SEEN_XREG    0x20000 /* X reg is used */
-#define SEEN_MEM     0x40000 /* SEEN_MEM+(1<<n) = use mem[n] for temporary
-			      * storage */
-#define SEEN_MEM_MSK 0x0ffff
+#define SEEN_FUNC	0x20000000 /* might call external helpers */
+#define SEEN_STACK	0x40000000 /* uses BPF stack */
+#define SEEN_TAILCALL	0x80000000 /* uses tail calls */
 
 struct codegen_context {
+	/*
+	 * This is used to track register usage as well
+	 * as calls to external helpers.
+	 * - register usage is tracked with corresponding
+	 *   bits (r3-r10 and r27-r31)
+	 * - rest of the bits can be used to track other
+	 *   things -- for now, we use bits 16 to 23
+	 *   encoded in SEEN_* macros above
+	 */
 	unsigned int seen;
 	unsigned int idx;
-	int pc_ret0; /* bpf index of first RET #0 instruction (if any) */
+	unsigned int stack_size;
 };
 
-#endif
+#endif /* !__ASSEMBLY__ */
 
 #endif
diff --git a/arch/powerpc/net/bpf_jit_asm.S b/arch/powerpc/net/bpf_jit_asm.S
deleted file mode 100644
index 2f5030d8383f..000000000000
--- a/arch/powerpc/net/bpf_jit_asm.S
+++ /dev/null
@@ -1,226 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/* bpf_jit.S: Packet/header access helper functions
- * for PPC64 BPF compiler.
- *
- * Copyright 2011 Matt Evans <matt@ozlabs.org>, IBM Corporation
- */
-
-#include <asm/ppc_asm.h>
-#include <asm/asm-compat.h>
-#include "bpf_jit32.h"
-
-/*
- * All of these routines are called directly from generated code,
- * whose register usage is:
- *
- * r3		skb
- * r4,r5	A,X
- * r6		*** address parameter to helper ***
- * r7-r10	scratch
- * r14		skb->data
- * r15		skb headlen
- * r16-31	M[]
- */
-
-/*
- * To consider: These helpers are so small it could be better to just
- * generate them inline.  Inline code can do the simple headlen check
- * then branch directly to slow_path_XXX if required.  (In fact, could
- * load a spare GPR with the address of slow_path_generic and pass size
- * as an argument, making the call site a mtlr, li and bllr.)
- */
-	.globl	sk_load_word
-sk_load_word:
-	PPC_LCMPI	r_addr, 0
-	blt	bpf_slow_path_word_neg
-	.globl	sk_load_word_positive_offset
-sk_load_word_positive_offset:
-	/* Are we accessing past headlen? */
-	subi	r_scratch1, r_HL, 4
-	PPC_LCMP	r_scratch1, r_addr
-	blt	bpf_slow_path_word
-	/* Nope, just hitting the header.  cr0 here is eq or gt! */
-#ifdef __LITTLE_ENDIAN__
-	lwbrx	r_A, r_D, r_addr
-#else
-	lwzx	r_A, r_D, r_addr
-#endif
-	blr	/* Return success, cr0 != LT */
-
-	.globl	sk_load_half
-sk_load_half:
-	PPC_LCMPI	r_addr, 0
-	blt	bpf_slow_path_half_neg
-	.globl	sk_load_half_positive_offset
-sk_load_half_positive_offset:
-	subi	r_scratch1, r_HL, 2
-	PPC_LCMP	r_scratch1, r_addr
-	blt	bpf_slow_path_half
-#ifdef __LITTLE_ENDIAN__
-	lhbrx	r_A, r_D, r_addr
-#else
-	lhzx	r_A, r_D, r_addr
-#endif
-	blr
-
-	.globl	sk_load_byte
-sk_load_byte:
-	PPC_LCMPI	r_addr, 0
-	blt	bpf_slow_path_byte_neg
-	.globl	sk_load_byte_positive_offset
-sk_load_byte_positive_offset:
-	PPC_LCMP	r_HL, r_addr
-	ble	bpf_slow_path_byte
-	lbzx	r_A, r_D, r_addr
-	blr
-
-/*
- * BPF_LDX | BPF_B | BPF_MSH: ldxb  4*([offset]&0xf)
- * r_addr is the offset value
- */
-	.globl sk_load_byte_msh
-sk_load_byte_msh:
-	PPC_LCMPI	r_addr, 0
-	blt	bpf_slow_path_byte_msh_neg
-	.globl sk_load_byte_msh_positive_offset
-sk_load_byte_msh_positive_offset:
-	PPC_LCMP	r_HL, r_addr
-	ble	bpf_slow_path_byte_msh
-	lbzx	r_X, r_D, r_addr
-	rlwinm	r_X, r_X, 2, 32-4-2, 31-2
-	blr
-
-/* Call out to skb_copy_bits:
- * We'll need to back up our volatile regs first; we have
- * local variable space at r1+(BPF_PPC_STACK_BASIC).
- * Allocate a new stack frame here to remain ABI-compliant in
- * stashing LR.
- */
-#define bpf_slow_path_common(SIZE)				\
-	mflr	r0;						\
-	PPC_STL	r0, PPC_LR_STKOFF(r1);					\
-	/* R3 goes in parameter space of caller's frame */	\
-	PPC_STL	r_skb, (BPF_PPC_STACKFRAME+BPF_PPC_STACK_R3_OFF)(r1);		\
-	PPC_STL	r_A, (BPF_PPC_STACK_BASIC+(0*REG_SZ))(r1);		\
-	PPC_STL	r_X, (BPF_PPC_STACK_BASIC+(1*REG_SZ))(r1);		\
-	addi	r5, r1, BPF_PPC_STACK_BASIC+(2*REG_SZ);		\
-	PPC_STLU	r1, -BPF_PPC_SLOWPATH_FRAME(r1);		\
-	/* R3 = r_skb, as passed */				\
-	mr	r4, r_addr;					\
-	li	r6, SIZE;					\
-	bl	skb_copy_bits;					\
-	nop;							\
-	/* R3 = 0 on success */					\
-	addi	r1, r1, BPF_PPC_SLOWPATH_FRAME;			\
-	PPC_LL	r0, PPC_LR_STKOFF(r1);					\
-	PPC_LL	r_A, (BPF_PPC_STACK_BASIC+(0*REG_SZ))(r1);		\
-	PPC_LL	r_X, (BPF_PPC_STACK_BASIC+(1*REG_SZ))(r1);		\
-	mtlr	r0;						\
-	PPC_LCMPI	r3, 0;						\
-	blt	bpf_error;	/* cr0 = LT */			\
-	PPC_LL	r_skb, (BPF_PPC_STACKFRAME+BPF_PPC_STACK_R3_OFF)(r1);		\
-	/* Great success! */
-
-bpf_slow_path_word:
-	bpf_slow_path_common(4)
-	/* Data value is on stack, and cr0 != LT */
-	lwz	r_A, BPF_PPC_STACK_BASIC+(2*REG_SZ)(r1)
-	blr
-
-bpf_slow_path_half:
-	bpf_slow_path_common(2)
-	lhz	r_A, BPF_PPC_STACK_BASIC+(2*8)(r1)
-	blr
-
-bpf_slow_path_byte:
-	bpf_slow_path_common(1)
-	lbz	r_A, BPF_PPC_STACK_BASIC+(2*8)(r1)
-	blr
-
-bpf_slow_path_byte_msh:
-	bpf_slow_path_common(1)
-	lbz	r_X, BPF_PPC_STACK_BASIC+(2*8)(r1)
-	rlwinm	r_X, r_X, 2, 32-4-2, 31-2
-	blr
-
-/* Call out to bpf_internal_load_pointer_neg_helper:
- * We'll need to back up our volatile regs first; we have
- * local variable space at r1+(BPF_PPC_STACK_BASIC).
- * Allocate a new stack frame here to remain ABI-compliant in
- * stashing LR.
- */
-#define sk_negative_common(SIZE)				\
-	mflr	r0;						\
-	PPC_STL	r0, PPC_LR_STKOFF(r1);					\
-	/* R3 goes in parameter space of caller's frame */	\
-	PPC_STL	r_skb, (BPF_PPC_STACKFRAME+BPF_PPC_STACK_R3_OFF)(r1);		\
-	PPC_STL	r_A, (BPF_PPC_STACK_BASIC+(0*REG_SZ))(r1);		\
-	PPC_STL	r_X, (BPF_PPC_STACK_BASIC+(1*REG_SZ))(r1);		\
-	PPC_STLU	r1, -BPF_PPC_SLOWPATH_FRAME(r1);		\
-	/* R3 = r_skb, as passed */				\
-	mr	r4, r_addr;					\
-	li	r5, SIZE;					\
-	bl	bpf_internal_load_pointer_neg_helper;		\
-	nop;							\
-	/* R3 != 0 on success */				\
-	addi	r1, r1, BPF_PPC_SLOWPATH_FRAME;			\
-	PPC_LL	r0, PPC_LR_STKOFF(r1);					\
-	PPC_LL	r_A, (BPF_PPC_STACK_BASIC+(0*REG_SZ))(r1);		\
-	PPC_LL	r_X, (BPF_PPC_STACK_BASIC+(1*REG_SZ))(r1);		\
-	mtlr	r0;						\
-	PPC_LCMPLI	r3, 0;						\
-	beq	bpf_error_slow;	/* cr0 = EQ */			\
-	mr	r_addr, r3;					\
-	PPC_LL	r_skb, (BPF_PPC_STACKFRAME+BPF_PPC_STACK_R3_OFF)(r1);		\
-	/* Great success! */
-
-bpf_slow_path_word_neg:
-	lis     r_scratch1,-32	/* SKF_LL_OFF */
-	PPC_LCMP	r_addr, r_scratch1	/* addr < SKF_* */
-	blt	bpf_error	/* cr0 = LT */
-	.globl	sk_load_word_negative_offset
-sk_load_word_negative_offset:
-	sk_negative_common(4)
-	lwz	r_A, 0(r_addr)
-	blr
-
-bpf_slow_path_half_neg:
-	lis     r_scratch1,-32	/* SKF_LL_OFF */
-	PPC_LCMP	r_addr, r_scratch1	/* addr < SKF_* */
-	blt	bpf_error	/* cr0 = LT */
-	.globl	sk_load_half_negative_offset
-sk_load_half_negative_offset:
-	sk_negative_common(2)
-	lhz	r_A, 0(r_addr)
-	blr
-
-bpf_slow_path_byte_neg:
-	lis     r_scratch1,-32	/* SKF_LL_OFF */
-	PPC_LCMP	r_addr, r_scratch1	/* addr < SKF_* */
-	blt	bpf_error	/* cr0 = LT */
-	.globl	sk_load_byte_negative_offset
-sk_load_byte_negative_offset:
-	sk_negative_common(1)
-	lbz	r_A, 0(r_addr)
-	blr
-
-bpf_slow_path_byte_msh_neg:
-	lis     r_scratch1,-32	/* SKF_LL_OFF */
-	PPC_LCMP	r_addr, r_scratch1	/* addr < SKF_* */
-	blt	bpf_error	/* cr0 = LT */
-	.globl	sk_load_byte_msh_negative_offset
-sk_load_byte_msh_negative_offset:
-	sk_negative_common(1)
-	lbz	r_X, 0(r_addr)
-	rlwinm	r_X, r_X, 2, 32-4-2, 31-2
-	blr
-
-bpf_error_slow:
-	/* fabricate a cr0 = lt */
-	li	r_scratch1, -1
-	PPC_LCMPI	r_scratch1, 0
-bpf_error:
-	/* Entered with cr0 = lt */
-	li	r3, 0
-	/* Generated code will 'blt epilogue', returning 0. */
-	blr
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
deleted file mode 100644
index e809cb5a1631..000000000000
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ /dev/null
@@ -1,683 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/* bpf_jit_comp.c: BPF JIT compiler
- *
- * Copyright 2011 Matt Evans <matt@ozlabs.org>, IBM Corporation
- *
- * Based on the x86 BPF compiler, by Eric Dumazet (eric.dumazet@gmail.com)
- * Ported to ppc32 by Denis Kirjanov <kda@linux-powerpc.org>
- */
-#include <linux/moduleloader.h>
-#include <asm/cacheflush.h>
-#include <asm/asm-compat.h>
-#include <linux/netdevice.h>
-#include <linux/filter.h>
-#include <linux/if_vlan.h>
-
-#include "bpf_jit32.h"
-
-static inline void bpf_flush_icache(void *start, void *end)
-{
-	smp_wmb();
-	flush_icache_range((unsigned long)start, (unsigned long)end);
-}
-
-static void bpf_jit_build_prologue(struct bpf_prog *fp, u32 *image,
-				   struct codegen_context *ctx)
-{
-	int i;
-	const struct sock_filter *filter = fp->insns;
-
-	if (ctx->seen & (SEEN_MEM | SEEN_DATAREF)) {
-		/* Make stackframe */
-		if (ctx->seen & SEEN_DATAREF) {
-			/* If we call any helpers (for loads), save LR */
-			EMIT(PPC_INST_MFLR | __PPC_RT(R0));
-			PPC_BPF_STL(0, 1, PPC_LR_STKOFF);
-
-			/* Back up non-volatile regs. */
-			PPC_BPF_STL(r_D, 1, -(REG_SZ*(32-r_D)));
-			PPC_BPF_STL(r_HL, 1, -(REG_SZ*(32-r_HL)));
-		}
-		if (ctx->seen & SEEN_MEM) {
-			/*
-			 * Conditionally save regs r15-r31 as some will be used
-			 * for M[] data.
-			 */
-			for (i = r_M; i < (r_M+16); i++) {
-				if (ctx->seen & (1 << (i-r_M)))
-					PPC_BPF_STL(i, 1, -(REG_SZ*(32-i)));
-			}
-		}
-		PPC_BPF_STLU(1, 1, -BPF_PPC_STACKFRAME);
-	}
-
-	if (ctx->seen & SEEN_DATAREF) {
-		/*
-		 * If this filter needs to access skb data,
-		 * prepare r_D and r_HL:
-		 *  r_HL = skb->len - skb->data_len
-		 *  r_D	 = skb->data
-		 */
-		PPC_LWZ_OFFS(r_scratch1, r_skb, offsetof(struct sk_buff,
-							 data_len));
-		PPC_LWZ_OFFS(r_HL, r_skb, offsetof(struct sk_buff, len));
-		EMIT(PPC_RAW_SUB(r_HL, r_HL, r_scratch1));
-		PPC_LL_OFFS(r_D, r_skb, offsetof(struct sk_buff, data));
-	}
-
-	if (ctx->seen & SEEN_XREG) {
-		/*
-		 * TODO: Could also detect whether first instr. sets X and
-		 * avoid this (as below, with A).
-		 */
-		EMIT(PPC_RAW_LI(r_X, 0));
-	}
-
-	/* make sure we dont leak kernel information to user */
-	if (bpf_needs_clear_a(&filter[0]))
-		EMIT(PPC_RAW_LI(r_A, 0));
-}
-
-static void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx)
-{
-	int i;
-
-	if (ctx->seen & (SEEN_MEM | SEEN_DATAREF)) {
-		EMIT(PPC_RAW_ADDI(1, 1, BPF_PPC_STACKFRAME));
-		if (ctx->seen & SEEN_DATAREF) {
-			PPC_BPF_LL(0, 1, PPC_LR_STKOFF);
-			EMIT(PPC_RAW_MTLR(0));
-			PPC_BPF_LL(r_D, 1, -(REG_SZ*(32-r_D)));
-			PPC_BPF_LL(r_HL, 1, -(REG_SZ*(32-r_HL)));
-		}
-		if (ctx->seen & SEEN_MEM) {
-			/* Restore any saved non-vol registers */
-			for (i = r_M; i < (r_M+16); i++) {
-				if (ctx->seen & (1 << (i-r_M)))
-					PPC_BPF_LL(i, 1, -(REG_SZ*(32-i)));
-			}
-		}
-	}
-	/* The RETs have left a return value in R3. */
-
-	EMIT(PPC_RAW_BLR());
-}
-
-#define CHOOSE_LOAD_FUNC(K, func) \
-	((int)K < 0 ? ((int)K >= SKF_LL_OFF ? func##_negative_offset : func) : func##_positive_offset)
-
-/* Assemble the body code between the prologue & epilogue. */
-static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
-			      struct codegen_context *ctx,
-			      unsigned int *addrs)
-{
-	const struct sock_filter *filter = fp->insns;
-	int flen = fp->len;
-	u8 *func;
-	unsigned int true_cond;
-	int i;
-
-	/* Start of epilogue code */
-	unsigned int exit_addr = addrs[flen];
-
-	for (i = 0; i < flen; i++) {
-		unsigned int K = filter[i].k;
-		u16 code = bpf_anc_helper(&filter[i]);
-
-		/*
-		 * addrs[] maps a BPF bytecode address into a real offset from
-		 * the start of the body code.
-		 */
-		addrs[i] = ctx->idx * 4;
-
-		switch (code) {
-			/*** ALU ops ***/
-		case BPF_ALU | BPF_ADD | BPF_X: /* A += X; */
-			ctx->seen |= SEEN_XREG;
-			EMIT(PPC_RAW_ADD(r_A, r_A, r_X));
-			break;
-		case BPF_ALU | BPF_ADD | BPF_K: /* A += K; */
-			if (!K)
-				break;
-			EMIT(PPC_RAW_ADDI(r_A, r_A, IMM_L(K)));
-			if (K >= 32768)
-				EMIT(PPC_RAW_ADDIS(r_A, r_A, IMM_HA(K)));
-			break;
-		case BPF_ALU | BPF_SUB | BPF_X: /* A -= X; */
-			ctx->seen |= SEEN_XREG;
-			EMIT(PPC_RAW_SUB(r_A, r_A, r_X));
-			break;
-		case BPF_ALU | BPF_SUB | BPF_K: /* A -= K */
-			if (!K)
-				break;
-			EMIT(PPC_RAW_ADDI(r_A, r_A, IMM_L(-K)));
-			if (K >= 32768)
-				EMIT(PPC_RAW_ADDIS(r_A, r_A, IMM_HA(-K)));
-			break;
-		case BPF_ALU | BPF_MUL | BPF_X: /* A *= X; */
-			ctx->seen |= SEEN_XREG;
-			EMIT(PPC_RAW_MULW(r_A, r_A, r_X));
-			break;
-		case BPF_ALU | BPF_MUL | BPF_K: /* A *= K */
-			if (K < 32768)
-				EMIT(PPC_RAW_MULI(r_A, r_A, K));
-			else {
-				PPC_LI32(r_scratch1, K);
-				EMIT(PPC_RAW_MULW(r_A, r_A, r_scratch1));
-			}
-			break;
-		case BPF_ALU | BPF_MOD | BPF_X: /* A %= X; */
-		case BPF_ALU | BPF_DIV | BPF_X: /* A /= X; */
-			ctx->seen |= SEEN_XREG;
-			EMIT(PPC_RAW_CMPWI(r_X, 0));
-			if (ctx->pc_ret0 != -1) {
-				PPC_BCC(COND_EQ, addrs[ctx->pc_ret0]);
-			} else {
-				PPC_BCC_SHORT(COND_NE, (ctx->idx*4)+12);
-				EMIT(PPC_RAW_LI(r_ret, 0));
-				PPC_JMP(exit_addr);
-			}
-			if (code == (BPF_ALU | BPF_MOD | BPF_X)) {
-				EMIT(PPC_RAW_DIVWU(r_scratch1, r_A, r_X));
-				EMIT(PPC_RAW_MULW(r_scratch1, r_X, r_scratch1));
-				EMIT(PPC_RAW_SUB(r_A, r_A, r_scratch1));
-			} else {
-				EMIT(PPC_RAW_DIVWU(r_A, r_A, r_X));
-			}
-			break;
-		case BPF_ALU | BPF_MOD | BPF_K: /* A %= K; */
-			PPC_LI32(r_scratch2, K);
-			EMIT(PPC_RAW_DIVWU(r_scratch1, r_A, r_scratch2));
-			EMIT(PPC_RAW_MULW(r_scratch1, r_scratch2, r_scratch1));
-			EMIT(PPC_RAW_SUB(r_A, r_A, r_scratch1));
-			break;
-		case BPF_ALU | BPF_DIV | BPF_K: /* A /= K */
-			if (K == 1)
-				break;
-			PPC_LI32(r_scratch1, K);
-			EMIT(PPC_RAW_DIVWU(r_A, r_A, r_scratch1));
-			break;
-		case BPF_ALU | BPF_AND | BPF_X:
-			ctx->seen |= SEEN_XREG;
-			EMIT(PPC_RAW_AND(r_A, r_A, r_X));
-			break;
-		case BPF_ALU | BPF_AND | BPF_K:
-			if (!IMM_H(K))
-				EMIT(PPC_RAW_ANDI(r_A, r_A, K));
-			else {
-				PPC_LI32(r_scratch1, K);
-				EMIT(PPC_RAW_AND(r_A, r_A, r_scratch1));
-			}
-			break;
-		case BPF_ALU | BPF_OR | BPF_X:
-			ctx->seen |= SEEN_XREG;
-			EMIT(PPC_RAW_OR(r_A, r_A, r_X));
-			break;
-		case BPF_ALU | BPF_OR | BPF_K:
-			if (IMM_L(K))
-				EMIT(PPC_RAW_ORI(r_A, r_A, IMM_L(K)));
-			if (K >= 65536)
-				EMIT(PPC_RAW_ORIS(r_A, r_A, IMM_H(K)));
-			break;
-		case BPF_ANC | SKF_AD_ALU_XOR_X:
-		case BPF_ALU | BPF_XOR | BPF_X: /* A ^= X */
-			ctx->seen |= SEEN_XREG;
-			EMIT(PPC_RAW_XOR(r_A, r_A, r_X));
-			break;
-		case BPF_ALU | BPF_XOR | BPF_K: /* A ^= K */
-			if (IMM_L(K))
-				EMIT(PPC_RAW_XORI(r_A, r_A, IMM_L(K)));
-			if (K >= 65536)
-				EMIT(PPC_RAW_XORIS(r_A, r_A, IMM_H(K)));
-			break;
-		case BPF_ALU | BPF_LSH | BPF_X: /* A <<= X; */
-			ctx->seen |= SEEN_XREG;
-			EMIT(PPC_RAW_SLW(r_A, r_A, r_X));
-			break;
-		case BPF_ALU | BPF_LSH | BPF_K:
-			if (K == 0)
-				break;
-			else
-				EMIT(PPC_RAW_SLWI(r_A, r_A, K));
-			break;
-		case BPF_ALU | BPF_RSH | BPF_X: /* A >>= X; */
-			ctx->seen |= SEEN_XREG;
-			EMIT(PPC_RAW_SRW(r_A, r_A, r_X));
-			break;
-		case BPF_ALU | BPF_RSH | BPF_K: /* A >>= K; */
-			if (K == 0)
-				break;
-			else
-				EMIT(PPC_RAW_SRWI(r_A, r_A, K));
-			break;
-		case BPF_ALU | BPF_NEG:
-			EMIT(PPC_RAW_NEG(r_A, r_A));
-			break;
-		case BPF_RET | BPF_K:
-			PPC_LI32(r_ret, K);
-			if (!K) {
-				if (ctx->pc_ret0 == -1)
-					ctx->pc_ret0 = i;
-			}
-			/*
-			 * If this isn't the very last instruction, branch to
-			 * the epilogue if we've stuff to clean up.  Otherwise,
-			 * if there's nothing to tidy, just return.  If we /are/
-			 * the last instruction, we're about to fall through to
-			 * the epilogue to return.
-			 */
-			if (i != flen - 1) {
-				/*
-				 * Note: 'seen' is properly valid only on pass
-				 * #2.	Both parts of this conditional are the
-				 * same instruction size though, meaning the
-				 * first pass will still correctly determine the
-				 * code size/addresses.
-				 */
-				if (ctx->seen)
-					PPC_JMP(exit_addr);
-				else
-					EMIT(PPC_RAW_BLR());
-			}
-			break;
-		case BPF_RET | BPF_A:
-			EMIT(PPC_RAW_MR(r_ret, r_A));
-			if (i != flen - 1) {
-				if (ctx->seen)
-					PPC_JMP(exit_addr);
-				else
-					EMIT(PPC_RAW_BLR());
-			}
-			break;
-		case BPF_MISC | BPF_TAX: /* X = A */
-			EMIT(PPC_RAW_MR(r_X, r_A));
-			break;
-		case BPF_MISC | BPF_TXA: /* A = X */
-			ctx->seen |= SEEN_XREG;
-			EMIT(PPC_RAW_MR(r_A, r_X));
-			break;
-
-			/*** Constant loads/M[] access ***/
-		case BPF_LD | BPF_IMM: /* A = K */
-			PPC_LI32(r_A, K);
-			break;
-		case BPF_LDX | BPF_IMM: /* X = K */
-			PPC_LI32(r_X, K);
-			break;
-		case BPF_LD | BPF_MEM: /* A = mem[K] */
-			EMIT(PPC_RAW_MR(r_A, r_M + (K & 0xf)));
-			ctx->seen |= SEEN_MEM | (1<<(K & 0xf));
-			break;
-		case BPF_LDX | BPF_MEM: /* X = mem[K] */
-			EMIT(PPC_RAW_MR(r_X, r_M + (K & 0xf)));
-			ctx->seen |= SEEN_MEM | (1<<(K & 0xf));
-			break;
-		case BPF_ST: /* mem[K] = A */
-			EMIT(PPC_RAW_MR(r_M + (K & 0xf), r_A));
-			ctx->seen |= SEEN_MEM | (1<<(K & 0xf));
-			break;
-		case BPF_STX: /* mem[K] = X */
-			EMIT(PPC_RAW_MR(r_M + (K & 0xf), r_X));
-			ctx->seen |= SEEN_XREG | SEEN_MEM | (1<<(K & 0xf));
-			break;
-		case BPF_LD | BPF_W | BPF_LEN: /*	A = skb->len; */
-			BUILD_BUG_ON(sizeof_field(struct sk_buff, len) != 4);
-			PPC_LWZ_OFFS(r_A, r_skb, offsetof(struct sk_buff, len));
-			break;
-		case BPF_LDX | BPF_W | BPF_ABS: /* A = *((u32 *)(seccomp_data + K)); */
-			PPC_LWZ_OFFS(r_A, r_skb, K);
-			break;
-		case BPF_LDX | BPF_W | BPF_LEN: /* X = skb->len; */
-			PPC_LWZ_OFFS(r_X, r_skb, offsetof(struct sk_buff, len));
-			break;
-
-			/*** Ancillary info loads ***/
-		case BPF_ANC | SKF_AD_PROTOCOL: /* A = ntohs(skb->protocol); */
-			BUILD_BUG_ON(sizeof_field(struct sk_buff,
-						  protocol) != 2);
-			PPC_NTOHS_OFFS(r_A, r_skb, offsetof(struct sk_buff,
-							    protocol));
-			break;
-		case BPF_ANC | SKF_AD_IFINDEX:
-		case BPF_ANC | SKF_AD_HATYPE:
-			BUILD_BUG_ON(sizeof_field(struct net_device,
-						ifindex) != 4);
-			BUILD_BUG_ON(sizeof_field(struct net_device,
-						type) != 2);
-			PPC_LL_OFFS(r_scratch1, r_skb, offsetof(struct sk_buff,
-								dev));
-			EMIT(PPC_RAW_CMPDI(r_scratch1, 0));
-			if (ctx->pc_ret0 != -1) {
-				PPC_BCC(COND_EQ, addrs[ctx->pc_ret0]);
-			} else {
-				/* Exit, returning 0; first pass hits here. */
-				PPC_BCC_SHORT(COND_NE, ctx->idx * 4 + 12);
-				EMIT(PPC_RAW_LI(r_ret, 0));
-				PPC_JMP(exit_addr);
-			}
-			if (code == (BPF_ANC | SKF_AD_IFINDEX)) {
-				PPC_LWZ_OFFS(r_A, r_scratch1,
-				     offsetof(struct net_device, ifindex));
-			} else {
-				PPC_LHZ_OFFS(r_A, r_scratch1,
-				     offsetof(struct net_device, type));
-			}
-
-			break;
-		case BPF_ANC | SKF_AD_MARK:
-			BUILD_BUG_ON(sizeof_field(struct sk_buff, mark) != 4);
-			PPC_LWZ_OFFS(r_A, r_skb, offsetof(struct sk_buff,
-							  mark));
-			break;
-		case BPF_ANC | SKF_AD_RXHASH:
-			BUILD_BUG_ON(sizeof_field(struct sk_buff, hash) != 4);
-			PPC_LWZ_OFFS(r_A, r_skb, offsetof(struct sk_buff,
-							  hash));
-			break;
-		case BPF_ANC | SKF_AD_VLAN_TAG:
-			BUILD_BUG_ON(sizeof_field(struct sk_buff, vlan_tci) != 2);
-
-			PPC_LHZ_OFFS(r_A, r_skb, offsetof(struct sk_buff,
-							  vlan_tci));
-			break;
-		case BPF_ANC | SKF_AD_VLAN_TAG_PRESENT:
-			PPC_LBZ_OFFS(r_A, r_skb, PKT_VLAN_PRESENT_OFFSET());
-			if (PKT_VLAN_PRESENT_BIT)
-				EMIT(PPC_RAW_SRWI(r_A, r_A, PKT_VLAN_PRESENT_BIT));
-			if (PKT_VLAN_PRESENT_BIT < 7)
-				EMIT(PPC_RAW_ANDI(r_A, r_A, 1));
-			break;
-		case BPF_ANC | SKF_AD_QUEUE:
-			BUILD_BUG_ON(sizeof_field(struct sk_buff,
-						  queue_mapping) != 2);
-			PPC_LHZ_OFFS(r_A, r_skb, offsetof(struct sk_buff,
-							  queue_mapping));
-			break;
-		case BPF_ANC | SKF_AD_PKTTYPE:
-			PPC_LBZ_OFFS(r_A, r_skb, PKT_TYPE_OFFSET());
-			EMIT(PPC_RAW_ANDI(r_A, r_A, PKT_TYPE_MAX));
-			EMIT(PPC_RAW_SRWI(r_A, r_A, 5));
-			break;
-		case BPF_ANC | SKF_AD_CPU:
-			PPC_BPF_LOAD_CPU(r_A);
-			break;
-			/*** Absolute loads from packet header/data ***/
-		case BPF_LD | BPF_W | BPF_ABS:
-			func = CHOOSE_LOAD_FUNC(K, sk_load_word);
-			goto common_load;
-		case BPF_LD | BPF_H | BPF_ABS:
-			func = CHOOSE_LOAD_FUNC(K, sk_load_half);
-			goto common_load;
-		case BPF_LD | BPF_B | BPF_ABS:
-			func = CHOOSE_LOAD_FUNC(K, sk_load_byte);
-		common_load:
-			/* Load from [K]. */
-			ctx->seen |= SEEN_DATAREF;
-			PPC_FUNC_ADDR(r_scratch1, func);
-			EMIT(PPC_RAW_MTLR(r_scratch1));
-			PPC_LI32(r_addr, K);
-			EMIT(PPC_RAW_BLRL());
-			/*
-			 * Helper returns 'lt' condition on error, and an
-			 * appropriate return value in r3
-			 */
-			PPC_BCC(COND_LT, exit_addr);
-			break;
-
-			/*** Indirect loads from packet header/data ***/
-		case BPF_LD | BPF_W | BPF_IND:
-			func = sk_load_word;
-			goto common_load_ind;
-		case BPF_LD | BPF_H | BPF_IND:
-			func = sk_load_half;
-			goto common_load_ind;
-		case BPF_LD | BPF_B | BPF_IND:
-			func = sk_load_byte;
-		common_load_ind:
-			/*
-			 * Load from [X + K].  Negative offsets are tested for
-			 * in the helper functions.
-			 */
-			ctx->seen |= SEEN_DATAREF | SEEN_XREG;
-			PPC_FUNC_ADDR(r_scratch1, func);
-			EMIT(PPC_RAW_MTLR(r_scratch1));
-			EMIT(PPC_RAW_ADDI(r_addr, r_X, IMM_L(K)));
-			if (K >= 32768)
-				EMIT(PPC_RAW_ADDIS(r_addr, r_addr, IMM_HA(K)));
-			EMIT(PPC_RAW_BLRL());
-			/* If error, cr0.LT set */
-			PPC_BCC(COND_LT, exit_addr);
-			break;
-
-		case BPF_LDX | BPF_B | BPF_MSH:
-			func = CHOOSE_LOAD_FUNC(K, sk_load_byte_msh);
-			goto common_load;
-			break;
-
-			/*** Jump and branches ***/
-		case BPF_JMP | BPF_JA:
-			if (K != 0)
-				PPC_JMP(addrs[i + 1 + K]);
-			break;
-
-		case BPF_JMP | BPF_JGT | BPF_K:
-		case BPF_JMP | BPF_JGT | BPF_X:
-			true_cond = COND_GT;
-			goto cond_branch;
-		case BPF_JMP | BPF_JGE | BPF_K:
-		case BPF_JMP | BPF_JGE | BPF_X:
-			true_cond = COND_GE;
-			goto cond_branch;
-		case BPF_JMP | BPF_JEQ | BPF_K:
-		case BPF_JMP | BPF_JEQ | BPF_X:
-			true_cond = COND_EQ;
-			goto cond_branch;
-		case BPF_JMP | BPF_JSET | BPF_K:
-		case BPF_JMP | BPF_JSET | BPF_X:
-			true_cond = COND_NE;
-		cond_branch:
-			/* same targets, can avoid doing the test :) */
-			if (filter[i].jt == filter[i].jf) {
-				if (filter[i].jt > 0)
-					PPC_JMP(addrs[i + 1 + filter[i].jt]);
-				break;
-			}
-
-			switch (code) {
-			case BPF_JMP | BPF_JGT | BPF_X:
-			case BPF_JMP | BPF_JGE | BPF_X:
-			case BPF_JMP | BPF_JEQ | BPF_X:
-				ctx->seen |= SEEN_XREG;
-				EMIT(PPC_RAW_CMPLW(r_A, r_X));
-				break;
-			case BPF_JMP | BPF_JSET | BPF_X:
-				ctx->seen |= SEEN_XREG;
-				EMIT(PPC_RAW_AND_DOT(r_scratch1, r_A, r_X));
-				break;
-			case BPF_JMP | BPF_JEQ | BPF_K:
-			case BPF_JMP | BPF_JGT | BPF_K:
-			case BPF_JMP | BPF_JGE | BPF_K:
-				if (K < 32768)
-					EMIT(PPC_RAW_CMPLWI(r_A, K));
-				else {
-					PPC_LI32(r_scratch1, K);
-					EMIT(PPC_RAW_CMPLW(r_A, r_scratch1));
-				}
-				break;
-			case BPF_JMP | BPF_JSET | BPF_K:
-				if (K < 32768)
-					/* PPC_ANDI is /only/ dot-form */
-					EMIT(PPC_RAW_ANDI(r_scratch1, r_A, K));
-				else {
-					PPC_LI32(r_scratch1, K);
-					EMIT(PPC_RAW_AND_DOT(r_scratch1, r_A,
-						    r_scratch1));
-				}
-				break;
-			}
-			/* Sometimes branches are constructed "backward", with
-			 * the false path being the branch and true path being
-			 * a fallthrough to the next instruction.
-			 */
-			if (filter[i].jt == 0)
-				/* Swap the sense of the branch */
-				PPC_BCC(true_cond ^ COND_CMP_TRUE,
-					addrs[i + 1 + filter[i].jf]);
-			else {
-				PPC_BCC(true_cond, addrs[i + 1 + filter[i].jt]);
-				if (filter[i].jf != 0)
-					PPC_JMP(addrs[i + 1 + filter[i].jf]);
-			}
-			break;
-		default:
-			/* The filter contains something cruel & unusual.
-			 * We don't handle it, but also there shouldn't be
-			 * anything missing from our list.
-			 */
-			if (printk_ratelimit())
-				pr_err("BPF filter opcode %04x (@%d) unsupported\n",
-				       filter[i].code, i);
-			return -ENOTSUPP;
-		}
-
-	}
-	/* Set end-of-body-code address for exit. */
-	addrs[i] = ctx->idx * 4;
-
-	return 0;
-}
-
-void bpf_jit_compile(struct bpf_prog *fp)
-{
-	unsigned int proglen;
-	unsigned int alloclen;
-	u32 *image = NULL;
-	u32 *code_base;
-	unsigned int *addrs;
-	struct codegen_context cgctx;
-	int pass;
-	int flen = fp->len;
-
-	if (!bpf_jit_enable)
-		return;
-
-	addrs = kcalloc(flen + 1, sizeof(*addrs), GFP_KERNEL);
-	if (addrs == NULL)
-		return;
-
-	/*
-	 * There are multiple assembly passes as the generated code will change
-	 * size as it settles down, figuring out the max branch offsets/exit
-	 * paths required.
-	 *
-	 * The range of standard conditional branches is +/- 32Kbytes.	Since
-	 * BPF_MAXINSNS = 4096, we can only jump from (worst case) start to
-	 * finish with 8 bytes/instruction.  Not feasible, so long jumps are
-	 * used, distinct from short branches.
-	 *
-	 * Current:
-	 *
-	 * For now, both branch types assemble to 2 words (short branches padded
-	 * with a NOP); this is less efficient, but assembly will always complete
-	 * after exactly 3 passes:
-	 *
-	 * First pass: No code buffer; Program is "faux-generated" -- no code
-	 * emitted but maximum size of output determined (and addrs[] filled
-	 * in).	 Also, we note whether we use M[], whether we use skb data, etc.
-	 * All generation choices assumed to be 'worst-case', e.g. branches all
-	 * far (2 instructions), return path code reduction not available, etc.
-	 *
-	 * Second pass: Code buffer allocated with size determined previously.
-	 * Prologue generated to support features we have seen used.  Exit paths
-	 * determined and addrs[] is filled in again, as code may be slightly
-	 * smaller as a result.
-	 *
-	 * Third pass: Code generated 'for real', and branch destinations
-	 * determined from now-accurate addrs[] map.
-	 *
-	 * Ideal:
-	 *
-	 * If we optimise this, near branches will be shorter.	On the
-	 * first assembly pass, we should err on the side of caution and
-	 * generate the biggest code.  On subsequent passes, branches will be
-	 * generated short or long and code size will reduce.  With smaller
-	 * code, more branches may fall into the short category, and code will
-	 * reduce more.
-	 *
-	 * Finally, if we see one pass generate code the same size as the
-	 * previous pass we have converged and should now generate code for
-	 * real.  Allocating at the end will also save the memory that would
-	 * otherwise be wasted by the (small) current code shrinkage.
-	 * Preferably, we should do a small number of passes (e.g. 5) and if we
-	 * haven't converged by then, get impatient and force code to generate
-	 * as-is, even if the odd branch would be left long.  The chances of a
-	 * long jump are tiny with all but the most enormous of BPF filter
-	 * inputs, so we should usually converge on the third pass.
-	 */
-
-	cgctx.idx = 0;
-	cgctx.seen = 0;
-	cgctx.pc_ret0 = -1;
-	/* Scouting faux-generate pass 0 */
-	if (bpf_jit_build_body(fp, 0, &cgctx, addrs))
-		/* We hit something illegal or unsupported. */
-		goto out;
-
-	/*
-	 * Pretend to build prologue, given the features we've seen.  This will
-	 * update ctgtx.idx as it pretends to output instructions, then we can
-	 * calculate total size from idx.
-	 */
-	bpf_jit_build_prologue(fp, 0, &cgctx);
-	bpf_jit_build_epilogue(0, &cgctx);
-
-	proglen = cgctx.idx * 4;
-	alloclen = proglen + FUNCTION_DESCR_SIZE;
-	image = module_alloc(alloclen);
-	if (!image)
-		goto out;
-
-	code_base = image + (FUNCTION_DESCR_SIZE/4);
-
-	/* Code generation passes 1-2 */
-	for (pass = 1; pass < 3; pass++) {
-		/* Now build the prologue, body code & epilogue for real. */
-		cgctx.idx = 0;
-		bpf_jit_build_prologue(fp, code_base, &cgctx);
-		bpf_jit_build_body(fp, code_base, &cgctx, addrs);
-		bpf_jit_build_epilogue(code_base, &cgctx);
-
-		if (bpf_jit_enable > 1)
-			pr_info("Pass %d: shrink = %d, seen = 0x%x\n", pass,
-				proglen - (cgctx.idx * 4), cgctx.seen);
-	}
-
-	if (bpf_jit_enable > 1)
-		/* Note that we output the base address of the code_base
-		 * rather than image, since opcodes are in code_base.
-		 */
-		bpf_jit_dump(flen, proglen, pass, code_base);
-
-	bpf_flush_icache(code_base, code_base + (proglen/4));
-
-#ifdef CONFIG_PPC64
-	/* Function descriptor nastiness: Address + TOC */
-	((u64 *)image)[0] = (u64)code_base;
-	((u64 *)image)[1] = local_paca->kernel_toc;
-#endif
-
-	fp->bpf_func = (void *)image;
-	fp->jited = 1;
-
-out:
-	kfree(addrs);
-	return;
-}
-
-void bpf_jit_free(struct bpf_prog *fp)
-{
-	if (fp->jited)
-		module_memfree(fp->bpf_func);
-
-	bpf_prog_unlock_free(fp);
-}
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
new file mode 100644
index 000000000000..909c27da71f1
--- /dev/null
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -0,0 +1,1177 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * bpf_jit_comp64.c: eBPF JIT compiler
+ *
+ * Copyright 2016 Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
+ *		  IBM Corporation
+ *
+ * Based on the powerpc classic BPF JIT compiler by Matt Evans
+ */
+#include <linux/moduleloader.h>
+#include <asm/cacheflush.h>
+#include <asm/asm-compat.h>
+#include <linux/netdevice.h>
+#include <linux/filter.h>
+#include <linux/if_vlan.h>
+#include <asm/kprobes.h>
+#include <linux/bpf.h>
+
+#include "bpf_jit32.h"
+
+static void bpf_jit_fill_ill_insns(void *area, unsigned int size)
+{
+	memset32(area, BREAKPOINT_INSTRUCTION, size/4);
+}
+
+static inline void bpf_flush_icache(void *start, void *end)
+{
+	smp_wmb();
+	flush_icache_range((unsigned long)start, (unsigned long)end);
+}
+
+static inline bool bpf_is_seen_register(struct codegen_context *ctx, int i)
+{
+	return (ctx->seen & (3 << (30 - b2p[i])));
+}
+
+static inline void bpf_set_seen_register(struct codegen_context *ctx, int i)
+{
+	ctx->seen |= (3 << (30 - b2p[i]));
+}
+
+static inline bool bpf_has_stack_frame(struct codegen_context *ctx)
+{
+	/*
+	 * We only need a stack frame if:
+	 * - we call other functions (kernel helpers), or
+	 * - the bpf program uses its stack area
+	 * The latter condition is deduced from the usage of BPF_REG_FP
+	 */
+	return true;
+}
+
+/*
+ * When not setting up our own stackframe, the redzone usage is:
+ *
+ *		[	prev sp		] <-------------
+ *		[	  ...       	] 		|
+ * sp (r1) --->	[    stack pointer	] --------------
+ *		[   nv gpr save area	] 6*8
+ *		[    tail_call_cnt	] 8
+ *		[    local_tmp_var	] 8
+ *		[   unused red zone	] 208 bytes protected
+ */
+static int bpf_jit_stack_local(struct codegen_context *ctx)
+{
+	if (bpf_has_stack_frame(ctx))
+		return STACK_FRAME_MIN_SIZE + ctx->stack_size;
+	else
+		return -(BPF_PPC_STACK_SAVE + 16);
+}
+
+static int bpf_jit_stack_tailcallcnt(struct codegen_context *ctx)
+{
+	return bpf_jit_stack_local(ctx) + 8;
+}
+
+static int bpf_jit_stack_offsetof(struct codegen_context *ctx, int reg)
+{
+	if (reg >= BPF_PPC_NVR_MIN && reg < 32)
+		return (bpf_has_stack_frame(ctx) ?
+			(BPF_PPC_STACKFRAME + ctx->stack_size) : 0)
+				- (4 * (32 - reg));
+
+	pr_err("BPF JIT is asking about unknown registers");
+	BUG();
+}
+
+static void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx)
+{
+	/*
+	 * Initialize tail_call_cnt if we do tail calls.
+	 * Otherwise, put in NOPs so that it can be skipped when we are
+	 * invoked through a tail call.
+	 */
+	if (ctx->seen & SEEN_TAILCALL) {
+		EMIT(PPC_RAW_LI(0, 0));
+		/* this goes in the redzone */
+		EMIT(PPC_RAW_STW(0, 1, -(BPF_PPC_STACK_SAVE + 8)));
+	} else {
+		EMIT(PPC_RAW_NOP());
+		EMIT(PPC_RAW_NOP());
+	}
+	EMIT(PPC_RAW_MR(b2p[BPF_REG_1], 3));
+	EMIT(PPC_RAW_LI(b2p[BPF_REG_1]-1, 0));
+
+#define BPF_TAILCALL_PROLOGUE_SIZE	16
+
+	if (bpf_is_seen_register(ctx, BPF_REG_5)) {
+		EMIT(PPC_RAW_LWZ(b2p[BPF_REG_5]-1, 1, 8));
+		EMIT(PPC_RAW_LWZ(b2p[BPF_REG_5], 1, 12));
+	}
+	/*
+	 * We need a stack frame, but we don't necessarily need to
+	 * save/restore LR unless we call other functions
+	 */
+	if (ctx->seen & SEEN_FUNC) {
+		EMIT(PPC_INST_MFLR | __PPC_RT(R0));
+		EMIT(PPC_RAW_STW(0, 1, PPC_LR_STKOFF));
+	}
+
+	EMIT(PPC_RAW_STWU(1, 1, -(BPF_PPC_STACKFRAME + ctx->stack_size)));
+
+	/*
+	 * Back up non-volatile regs -- BPF registers 6-10
+	 * If we haven't created our own stack frame, we save these
+	 * in the protected zone below the previous stack frame
+	 */
+	EMIT(PPC_RAW_STMW(18, 1, bpf_jit_stack_offsetof(ctx, 18)));
+
+	/* Setup frame pointer to point to the bpf stack area */
+	if (bpf_is_seen_register(ctx, BPF_REG_FP))
+		EMIT(PPC_RAW_ADDI(b2p[BPF_REG_FP], 1, STACK_FRAME_MIN_SIZE + ctx->stack_size));
+}
+
+static void bpf_jit_emit_common_epilogue(u32 *image, struct codegen_context *ctx)
+{
+	/* Restore NVRs */
+	EMIT(PPC_RAW_LMW(18, 1, bpf_jit_stack_offsetof(ctx, 18)));
+
+	/* Tear down our stack frame */
+	EMIT(PPC_RAW_ADDI(1, 1, BPF_PPC_STACKFRAME + ctx->stack_size));
+	if (ctx->seen & SEEN_FUNC) {
+		EMIT(PPC_RAW_LWZ(0, 1, PPC_LR_STKOFF));
+		EMIT(PPC_RAW_MTLR(0));
+	}
+}
+
+static void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx)
+{
+	EMIT(PPC_RAW_MR(3, b2p[BPF_REG_0]));
+
+	bpf_jit_emit_common_epilogue(image, ctx);
+
+	EMIT(PPC_RAW_BLR());
+}
+
+static void bpf_jit_emit_func_call(u32 *image, struct codegen_context *ctx, u64 func)
+{
+	/* Load function address into r0 */
+	PPC_LI32(0, func);
+	EMIT(PPC_RAW_MTLR(0));
+	EMIT(PPC_RAW_BLRL());
+}
+
+static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 out)
+{
+	/*
+	 * By now, the eBPF program has already setup parameters in r3, r4 and r5
+	 * r3/BPF_REG_1 - pointer to ctx -- passed as is to the next bpf program
+	 * r4/BPF_REG_2 - pointer to bpf_array
+	 * r5/BPF_REG_3 - index in bpf_array
+	 */
+	int b2p_bpf_array = b2p[BPF_REG_2];
+	int b2p_index = b2p[BPF_REG_3];
+
+	/*
+	 * if (index >= array->map.max_entries)
+	 *   goto out;
+	 */
+	EMIT(PPC_RAW_LWZ(0, b2p_bpf_array, offsetof(struct bpf_array, map.max_entries)));
+	EMIT(PPC_RAW_CMPLW(b2p_index, 0));
+	PPC_BCC(COND_GE, out);
+
+	/*
+	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 *   goto out;
+	 */
+	EMIT(PPC_RAW_LWZ(0, 1, bpf_jit_stack_tailcallcnt(ctx)));
+	EMIT(PPC_RAW_CMPLWI(0, MAX_TAIL_CALL_CNT));
+	PPC_BCC(COND_GT, out);
+
+	/*
+	 * tail_call_cnt++;
+	 */
+	EMIT(PPC_RAW_ADDI(0, 0, 1));
+	EMIT(PPC_RAW_STW(0, 1, bpf_jit_stack_tailcallcnt(ctx)));
+
+	/* prog = array->ptrs[index]; */
+	EMIT(PPC_RAW_MULI(0, b2p_index, 8));
+	EMIT(PPC_RAW_ADD(0, 0, b2p_bpf_array));
+	EMIT(PPC_RAW_LWZ(0, 0, offsetof(struct bpf_array, ptrs)));
+
+	/*
+	 * if (prog == NULL)
+	 *   goto out;
+	 */
+	EMIT(PPC_RAW_CMPLWI(0, 0));
+	PPC_BCC(COND_EQ, out);
+
+	/* goto *(prog->bpf_func + prologue_size); */
+	EMIT(PPC_RAW_LWZ(0, 0, offsetof(struct bpf_prog, bpf_func)));
+	EMIT(PPC_RAW_ADDI(0, 0, BPF_TAILCALL_PROLOGUE_SIZE));
+	EMIT(PPC_RAW_MTCTR(0));
+
+	EMIT(PPC_RAW_MR(3, b2p[BPF_REG_1]));
+
+	/* tear down stack, restore NVRs, ... */
+	bpf_jit_emit_common_epilogue(image, ctx);
+
+	EMIT(PPC_RAW_BCTR());
+	/* out: */
+}
+
+/* Assemble the body code between the prologue & epilogue */
+static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
+			      struct codegen_context *ctx,
+			      u32 *addrs, bool extra_pass)
+{
+	const struct bpf_insn *insn = fp->insnsi;
+	int flen = fp->len;
+	int i, ret;
+
+	/* Start of epilogue code - will only be valid 2nd pass onwards */
+	u32 exit_addr = addrs[flen];
+
+	for (i = 0; i < flen; i++) {
+		u32 code = insn[i].code;
+		u32 dst_reg = b2p[insn[i].dst_reg];
+		u32 dst_reg_h = dst_reg - 1;
+		u32 src_reg = b2p[insn[i].src_reg];
+		u32 src_reg_h = src_reg - 1;
+		u32 tmp_reg = b2p[TMP_REG];
+		s16 off = insn[i].off;
+		s32 imm = insn[i].imm;
+		bool func_addr_fixed;
+		u64 func_addr;
+		u32 true_cond;
+		u32 tmp_idx;
+
+		/*
+		 * addrs[] maps a BPF bytecode address into a real offset from
+		 * the start of the body code.
+		 */
+		addrs[i] = ctx->idx * 4;
+
+		/*
+		 * As an optimization, we note down which non-volatile registers
+		 * are used so that we can only save/restore those in our
+		 * prologue and epilogue. We do this here regardless of whether
+		 * the actual BPF instruction uses src/dst registers or not
+		 * (for instance, BPF_CALL does not use them). The expectation
+		 * is that those instructions will have src_reg/dst_reg set to
+		 * 0. Even otherwise, we just lose some prologue/epilogue
+		 * optimization but everything else should work without
+		 * any issues.
+		 */
+		if (dst_reg >= BPF_PPC_NVR_MIN && dst_reg < 32)
+			bpf_set_seen_register(ctx, insn[i].dst_reg);
+
+		if (src_reg >= BPF_PPC_NVR_MIN && src_reg < 32)
+			bpf_set_seen_register(ctx, insn[i].src_reg);
+
+		switch (code) {
+		/*
+		 * Arithmetic operations: ADD/SUB/MUL/DIV/MOD/NEG
+		 */
+		case BPF_ALU | BPF_ADD | BPF_X: /* (u32) dst += (u32) src */
+			EMIT(PPC_RAW_ADD(dst_reg, dst_reg, src_reg));
+			break;
+		case BPF_ALU64 | BPF_ADD | BPF_X: /* dst += src */
+			EMIT(PPC_RAW_ADDC(dst_reg, dst_reg, src_reg));
+			EMIT(PPC_RAW_ADDE(dst_reg_h, dst_reg_h, src_reg_h));
+			break;
+		case BPF_ALU | BPF_SUB | BPF_X: /* (u32) dst -= (u32) src */
+			EMIT(PPC_RAW_SUB(dst_reg, dst_reg, src_reg));
+			break;
+		case BPF_ALU64 | BPF_SUB | BPF_X: /* dst -= src */
+			EMIT(PPC_RAW_SUBFC(dst_reg, src_reg, dst_reg));
+			EMIT(PPC_RAW_SUBFE(dst_reg_h, src_reg_h, dst_reg_h));
+			break;
+		case BPF_ALU | BPF_SUB | BPF_K: /* (u32) dst -= (u32) imm */
+			imm = -imm;
+			fallthrough;
+		case BPF_ALU | BPF_ADD | BPF_K: /* (u32) dst += (u32) imm */
+			if (IMM_HA(imm) & 0xffff)
+				EMIT(PPC_RAW_ADDIS(dst_reg, dst_reg, IMM_HA(imm)));
+			if (IMM_L(imm))
+				EMIT(PPC_RAW_ADDI(dst_reg, dst_reg, IMM_L(imm)));
+			break;
+		case BPF_ALU64 | BPF_SUB | BPF_K: /* dst -= imm */
+			imm = -imm;
+			fallthrough;
+		case BPF_ALU64 | BPF_ADD | BPF_K: /* dst += imm */
+			if (imm) {
+				PPC_LI32(0, imm);
+				EMIT(PPC_RAW_ADDC(dst_reg, dst_reg, 0));
+				if (imm >= 0)
+					EMIT(PPC_RAW_ADDZE(dst_reg_h, dst_reg_h));
+				else
+					EMIT(PPC_RAW_ADDME(dst_reg_h, dst_reg_h));
+			}
+			break;
+		case BPF_ALU | BPF_MUL | BPF_X: /* (u32) dst *= (u32) src */
+			EMIT(PPC_RAW_MULW(dst_reg, dst_reg, src_reg));
+			break;
+		case BPF_ALU64 | BPF_MUL | BPF_X: /* dst *= src */
+			EMIT(PPC_RAW_MULW(0, dst_reg, src_reg_h));
+			EMIT(PPC_RAW_MULW(dst_reg_h, dst_reg_h, src_reg));
+			EMIT(PPC_RAW_MULHWU(tmp_reg, dst_reg, src_reg));
+			EMIT(PPC_RAW_MULW(dst_reg, dst_reg, src_reg));
+			EMIT(PPC_RAW_ADD(dst_reg_h, dst_reg_h, 0));
+			EMIT(PPC_RAW_ADD(dst_reg_h, dst_reg_h, tmp_reg));
+			break;
+		case BPF_ALU | BPF_MUL | BPF_K: /* (u32) dst *= (u32) imm */
+			if (imm >= -32768 && imm < 32768) {
+				EMIT(PPC_RAW_MULI(dst_reg, dst_reg, imm));
+			} else {
+				PPC_LI32(0, imm);
+				EMIT(PPC_RAW_MULW(dst_reg, dst_reg, 0));
+			}
+			break;
+		case BPF_ALU64 | BPF_MUL | BPF_K: /* dst *= imm */
+			PPC_LI32(0, imm);
+			if (imm >= 0) {
+				EMIT(PPC_RAW_MULW(dst_reg_h, dst_reg_h, 0));
+				EMIT(PPC_RAW_MULW(dst_reg, dst_reg, 0));
+				EMIT(PPC_RAW_MULHWU(0, dst_reg, 0));
+				EMIT(PPC_RAW_ADD(dst_reg_h, dst_reg_h, 0));
+			} else {
+				EMIT(PPC_RAW_MULW(dst_reg_h, dst_reg_h, 0));
+				EMIT(PPC_RAW_NEG(tmp_reg, dst_reg));
+				EMIT(PPC_RAW_ADD(dst_reg_h, dst_reg_h, tmp_reg));
+				EMIT(PPC_RAW_MULHWU(tmp_reg, dst_reg, 0));
+				EMIT(PPC_RAW_MULW(dst_reg, dst_reg, 0));
+				EMIT(PPC_RAW_ADD(dst_reg_h, dst_reg_h, tmp_reg));
+			}
+			break;
+		case BPF_ALU | BPF_DIV | BPF_X: /* (u32) dst /= (u32) src */
+			EMIT(PPC_RAW_DIVWU(dst_reg, dst_reg, src_reg));
+			break;
+		case BPF_ALU | BPF_MOD | BPF_X: /* (u32) dst %= (u32) src */
+			EMIT(PPC_RAW_DIVWU(0, dst_reg, src_reg));
+			EMIT(PPC_RAW_MULW(0, src_reg, 0));
+			EMIT(PPC_RAW_SUB(dst_reg, dst_reg, 0));
+			break;
+		case BPF_ALU64 | BPF_DIV | BPF_X: /* dst /= src */
+		case BPF_ALU64 | BPF_MOD | BPF_X: /* dst %= src */
+			return -ENOTSUPP;
+		case BPF_ALU | BPF_DIV | BPF_K: /* (u32) dst /= (u32) imm */
+			if (imm == 0)
+				return -EINVAL;
+			else if (imm == 1)
+				break;
+
+			PPC_LI32(0, imm);
+			EMIT(PPC_RAW_DIVWU(dst_reg, dst_reg, 0));
+			if (!fp->aux->verifier_zext)
+				EMIT(PPC_RAW_LI(dst_reg_h, 0));
+			break;
+		case BPF_ALU | BPF_MOD | BPF_K: /* (u32) dst %= (u32) imm */
+			if (imm == 0)
+				return -EINVAL;
+
+			PPC_LI32(tmp_reg, imm);
+			EMIT(PPC_RAW_DIVWU(0, dst_reg, tmp_reg));
+			EMIT(PPC_RAW_MULW(0, tmp_reg, 0));
+			EMIT(PPC_RAW_SUB(dst_reg, dst_reg, 0));
+			break;
+		case BPF_ALU64 | BPF_MOD | BPF_K: /* dst %= imm */
+		case BPF_ALU64 | BPF_DIV | BPF_K: /* dst /= imm */
+			return -ENOTSUPP;
+		case BPF_ALU | BPF_NEG: /* (u32) dst = -dst */
+			EMIT(PPC_RAW_NEG(dst_reg, dst_reg));
+			break;
+		case BPF_ALU64 | BPF_NEG: /* dst = -dst */
+			EMIT(PPC_RAW_SUBFIC(dst_reg, dst_reg, 0));
+			EMIT(PPC_RAW_SUBFZE(dst_reg_h, dst_reg_h));
+			break;
+
+		/*
+		 * Logical operations: AND/OR/XOR/[A]LSH/[A]RSH
+		 */
+		case BPF_ALU64 | BPF_AND | BPF_X: /* dst = dst & src */
+			EMIT(PPC_RAW_AND(dst_reg_h, dst_reg_h, src_reg_h));
+			fallthrough;
+		case BPF_ALU | BPF_AND | BPF_X: /* (u32) dst = dst & src */
+			EMIT(PPC_RAW_AND(dst_reg, dst_reg, src_reg));
+			break;
+		case BPF_ALU64 | BPF_AND | BPF_K: /* dst = dst & imm */
+			if (imm >= 0)
+				EMIT(PPC_RAW_LI(dst_reg_h, 0));
+			fallthrough;
+		case BPF_ALU | BPF_AND | BPF_K: /* (u32) dst = dst & imm */
+			if (!IMM_H(imm)) {
+				EMIT(PPC_RAW_ANDI(dst_reg, dst_reg, IMM_L(imm)));
+			} else if (!IMM_L(imm)) {
+				EMIT(PPC_RAW_ANDIS(dst_reg, dst_reg, IMM_H(imm)));
+			} else {
+				PPC_LI32(0, imm);
+				EMIT(PPC_RAW_AND(dst_reg, dst_reg, 0));
+			}
+			break;
+		case BPF_ALU64 | BPF_OR | BPF_X: /* dst = dst | src */
+			EMIT(PPC_RAW_OR(dst_reg_h, dst_reg_h, src_reg_h));
+			fallthrough;
+		case BPF_ALU | BPF_OR | BPF_X: /* dst = (u32) dst | (u32) src */
+			EMIT(PPC_RAW_OR(dst_reg, dst_reg, src_reg));
+			break;
+		case BPF_ALU64 | BPF_OR | BPF_K:/* dst = dst | imm */
+			/* Sign-extended */
+			if (imm < 0)
+				EMIT(PPC_RAW_LI(dst_reg_h, -1));
+			fallthrough;
+		case BPF_ALU | BPF_OR | BPF_K:/* dst = (u32) dst | (u32) imm */
+			if (IMM_L(imm))
+				EMIT(PPC_RAW_ORI(dst_reg, dst_reg, IMM_L(imm)));
+			if (IMM_H(imm))
+				EMIT(PPC_RAW_ORIS(dst_reg, dst_reg, IMM_H(imm)));
+			break;
+		case BPF_ALU64 | BPF_XOR | BPF_X: /* dst ^= src */
+			EMIT(PPC_RAW_XOR(dst_reg_h, dst_reg_h, src_reg_h));
+			EMIT(PPC_RAW_XOR(dst_reg, dst_reg, src_reg));
+			break;
+		case BPF_ALU | BPF_XOR | BPF_X: /* (u32) dst ^= src */
+			EMIT(PPC_RAW_XOR(dst_reg, dst_reg, src_reg));
+			break;
+		case BPF_ALU64 | BPF_XOR | BPF_K: /* dst ^= imm */
+			if (imm < 0)
+				EMIT(PPC_RAW_NOR(dst_reg_h, dst_reg_h, dst_reg_h));
+			fallthrough;
+		case BPF_ALU | BPF_XOR | BPF_K: /* (u32) dst ^= (u32) imm */
+			if (IMM_L(imm))
+				EMIT(PPC_RAW_XORI(dst_reg, dst_reg, IMM_L(imm)));
+			if (IMM_H(imm))
+				EMIT(PPC_RAW_XORIS(dst_reg, dst_reg, IMM_H(imm)));
+			break;
+		case BPF_ALU | BPF_LSH | BPF_X: /* (u32) dst <<= (u32) src */
+			EMIT(PPC_RAW_SLW(dst_reg, dst_reg, src_reg));
+			break;
+		case BPF_ALU64 | BPF_LSH | BPF_X: /* dst <<= src; */
+			return -ENOTSUPP;
+		case BPF_ALU | BPF_LSH | BPF_K: /* (u32) dst <<== (u32) imm */
+			/* with imm 0, we still need to clear top 32 bits */
+			EMIT(PPC_RAW_SLWI(dst_reg, dst_reg, imm));
+			break;
+		case BPF_ALU64 | BPF_LSH | BPF_K: /* dst <<== imm */
+			if (imm != 0)
+				return -ENOTSUPP;
+			break;
+		case BPF_ALU | BPF_RSH | BPF_X: /* (u32) dst >>= (u32) src */
+			EMIT(PPC_RAW_SRW(dst_reg, dst_reg, src_reg));
+			break;
+		case BPF_ALU64 | BPF_RSH | BPF_X: /* dst >>= src */
+			return -ENOTSUPP;
+		case BPF_ALU | BPF_RSH | BPF_K: /* (u32) dst >>= (u32) imm */
+			EMIT(PPC_RAW_SRWI(dst_reg, dst_reg, imm));
+			break;
+		case BPF_ALU64 | BPF_RSH | BPF_K: /* dst >>= imm */
+			if (imm != 0)
+				return -ENOTSUPP;
+			break;
+		case BPF_ALU | BPF_ARSH | BPF_X: /* (s32) dst >>= src */
+			EMIT(PPC_RAW_SRAW(dst_reg_h, dst_reg, src_reg));
+			break;
+		case BPF_ALU64 | BPF_ARSH | BPF_X: /* (s64) dst >>= src */
+			return -ENOTSUPP;
+		case BPF_ALU | BPF_ARSH | BPF_K: /* (s32) dst >>= imm */
+			EMIT(PPC_RAW_SRAWI(dst_reg, dst_reg, imm));
+			break;
+		case BPF_ALU64 | BPF_ARSH | BPF_K: /* (s64) dst >>= imm */
+			if (imm != 0)
+				return -ENOTSUPP;
+			break;
+
+		/*
+		 * MOV
+		 */
+		case BPF_ALU64 | BPF_MOV | BPF_X: /* dst = src */
+			if (dst_reg_h != src_reg_h)
+				EMIT(PPC_RAW_MR(dst_reg_h, src_reg_h));
+			fallthrough;
+		case BPF_ALU | BPF_MOV | BPF_X: /* (u32) dst = src */
+			if (dst_reg != src_reg)
+				EMIT(PPC_RAW_MR(dst_reg, src_reg));
+			if (imm == 1) {
+				/* special mov32 for zext */
+				EMIT(PPC_RAW_LI(dst_reg_h, 0));
+				break;
+			}
+			break;
+		case BPF_ALU64 | BPF_MOV | BPF_K: /* dst = (s64) imm */
+			PPC_LI32(dst_reg, imm);
+			EMIT(PPC_RAW_LI(dst_reg_h, imm < 0 ? -1 : 0));
+			break;
+		case BPF_ALU | BPF_MOV | BPF_K: /* (u32) dst = imm */
+			PPC_LI32(dst_reg, imm);
+			if (!fp->aux->verifier_zext)
+				EMIT(PPC_RAW_LI(dst_reg_h, 0));
+			break;
+
+		/*
+		 * BPF_FROM_BE/LE
+		 */
+		case BPF_ALU | BPF_END | BPF_FROM_LE:
+			switch (imm) {
+			case 16:
+				/* Rotate 8 bits left & mask with 0x0000ff00 */
+				EMIT(PPC_RAW_RLWINM(0, dst_reg, 8, 16, 23));
+				/* Rotate 8 bits right & insert LSB to reg */
+				EMIT(PPC_RAW_RLWIMI(0, dst_reg, 24, 24, 31));
+				/* Move result back to dst_reg_h */
+				EMIT(PPC_RAW_MR(dst_reg, 0));
+				break;
+			case 32:
+				/*
+				 * Rotate word left by 8 bits:
+				 * 2 bytes are already in their final position
+				 * -- byte 2 and 4 (of bytes 1, 2, 3 and 4)
+				 */
+				EMIT(PPC_RAW_RLWINM(0, dst_reg, 8, 0, 31));
+				/* Rotate 24 bits and insert byte 1 */
+				EMIT(PPC_RAW_RLWIMI(0, dst_reg, 24, 0, 7));
+				/* Rotate 24 bits and insert byte 3 */
+				EMIT(PPC_RAW_RLWIMI(0, dst_reg, 24, 16, 23));
+				EMIT(PPC_RAW_MR(dst_reg, 0));
+				break;
+			case 64:
+				EMIT(PPC_RAW_RLWINM(tmp_reg, dst_reg, 8, 0, 31));
+				EMIT(PPC_RAW_RLWINM(0, dst_reg_h, 8, 0, 31));
+				/* Rotate 24 bits and insert byte 1 */
+				EMIT(PPC_RAW_RLWIMI(tmp_reg, dst_reg, 24, 0, 7));
+				EMIT(PPC_RAW_RLWIMI(0, dst_reg_h, 24, 0, 7));
+				/* Rotate 24 bits and insert byte 3 */
+				EMIT(PPC_RAW_RLWIMI(tmp_reg, dst_reg, 24, 16, 23));
+				EMIT(PPC_RAW_RLWIMI(0, dst_reg_h, 24, 16, 23));
+				EMIT(PPC_RAW_MR(dst_reg, 0));
+				EMIT(PPC_RAW_MR(dst_reg_h, tmp_reg));
+				break;
+			}
+			break;
+		case BPF_ALU | BPF_END | BPF_FROM_BE:
+			switch (imm) {
+			case 16:
+				/* zero-extend 16 bits into 32 bits */
+				EMIT(PPC_RAW_RLWINM(dst_reg, dst_reg, 0, 16, 31));
+				break;
+			case 32:
+			case 64:
+				/* nop */
+				break;
+			}
+			break;
+
+		/*
+		 * BPF_ST(X)
+		 */
+		case BPF_STX | BPF_MEM | BPF_B: /* *(u8 *)(dst + off) = src */
+			EMIT(PPC_RAW_STB(src_reg, dst_reg, off));
+			break;
+		case BPF_ST | BPF_MEM | BPF_B: /* *(u8 *)(dst + off) = imm */
+			PPC_LI32(0, imm);
+			EMIT(PPC_RAW_STB(0, dst_reg, off));
+			break;
+		case BPF_STX | BPF_MEM | BPF_H: /* (u16 *)(dst + off) = src */
+			EMIT(PPC_RAW_STH(src_reg, dst_reg, off));
+			break;
+		case BPF_ST | BPF_MEM | BPF_H: /* (u16 *)(dst + off) = imm */
+			PPC_LI32(0, imm);
+			EMIT(PPC_RAW_STH(0, dst_reg, off));
+			break;
+		case BPF_STX | BPF_MEM | BPF_W: /* *(u32 *)(dst + off) = src */
+			EMIT(PPC_RAW_STW(src_reg, dst_reg, off));
+			break;
+		case BPF_ST | BPF_MEM | BPF_W: /* *(u32 *)(dst + off) = imm */
+			PPC_LI32(0, imm);
+			EMIT(PPC_RAW_STW(0, dst_reg, off));
+			break;
+		case BPF_STX | BPF_MEM | BPF_DW: /* (u64 *)(dst + off) = src */
+			EMIT(PPC_RAW_STW(src_reg_h, dst_reg, off));
+			EMIT(PPC_RAW_STW(src_reg, dst_reg, off+4));
+			break;
+		case BPF_ST | BPF_MEM | BPF_DW: /* *(u64 *)(dst + off) = imm */
+			PPC_LI32(0, imm);
+			EMIT(PPC_RAW_STW(0, dst_reg, off+4));
+			EMIT(PPC_RAW_LI(0, imm < 0 ? -1 : 0));
+			EMIT(PPC_RAW_STW(0, dst_reg, off));
+			break;
+
+		/*
+		 * BPF_STX XADD (atomic_add)
+		 */
+		/* *(u32 *)(dst + off) += src */
+		case BPF_STX | BPF_XADD | BPF_W:
+			/* Get offset into TMP_REG */
+			EMIT(PPC_RAW_LI(tmp_reg, off));
+			tmp_idx = ctx->idx * 4;
+			/* load value from memory into r0 */
+			EMIT(PPC_RAW_LWARX(0, tmp_reg, dst_reg, 0));
+			/* add value from src_reg into this */
+			EMIT(PPC_RAW_ADD(0, 0, src_reg));
+			/* store result back */
+			EMIT(PPC_RAW_STWCX(0, tmp_reg, dst_reg));
+			/* we're done if this succeeded */
+			PPC_BCC_SHORT(COND_NE, tmp_idx);
+			break;
+		/* *(u64 *)(dst + off) += src */
+		case BPF_STX | BPF_XADD | BPF_DW:
+			return -ENOTSUPP;
+
+		/*
+		 * BPF_LDX
+		 */
+		/* dst = *(u8 *)(ul) (src + off) */
+		case BPF_LDX | BPF_MEM | BPF_B:
+			EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
+			if (!fp->aux->verifier_zext)
+				EMIT(PPC_RAW_LI(dst_reg_h, 0));
+			break;
+		/* dst = *(u16 *)(ul) (src + off) */
+		case BPF_LDX | BPF_MEM | BPF_H:
+			EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
+			if (!fp->aux->verifier_zext)
+				EMIT(PPC_RAW_LI(dst_reg_h, 0));
+			break;
+		/* dst = *(u32 *)(ul) (src + off) */
+		case BPF_LDX | BPF_MEM | BPF_W:
+			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
+			if (!fp->aux->verifier_zext)
+				EMIT(PPC_RAW_LI(dst_reg_h, 0));
+			break;
+		/* dst = *(u64 *)(ul) (src + off) */
+		case BPF_LDX | BPF_MEM | BPF_DW:
+			EMIT(PPC_RAW_LWZ(dst_reg_h, src_reg, off));
+			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off+4));
+			break;
+
+		/*
+		 * Doubleword load
+		 * 16 byte instruction that uses two 'struct bpf_insn'
+		 */
+		case BPF_LD | BPF_IMM | BPF_DW: /* dst = (u64) imm */
+			PPC_LI32(dst_reg_h, (u32)insn[i + 1].imm);
+			PPC_LI32(dst_reg, (u32)insn[i].imm);
+			/* Adjust for two bpf instructions */
+			addrs[++i] = ctx->idx * 4;
+			break;
+
+		/*
+		 * Return/Exit
+		 */
+		case BPF_JMP | BPF_EXIT:
+			/*
+			 * If this isn't the very last instruction, branch to
+			 * the epilogue. If we _are_ the last instruction,
+			 * we'll just fall through to the epilogue.
+			 */
+			if (i != flen - 1)
+				PPC_JMP(exit_addr);
+			/* else fall through to the epilogue */
+			break;
+
+		/*
+		 * Call kernel helper or bpf function
+		 */
+		case BPF_JMP | BPF_CALL:
+			ctx->seen |= SEEN_FUNC;
+
+			ret = bpf_jit_get_func_addr(fp, &insn[i], extra_pass,
+						    &func_addr, &func_addr_fixed);
+			if (ret < 0)
+				return ret;
+
+			bpf_jit_emit_func_call(image, ctx, func_addr);
+
+			EMIT(PPC_RAW_MR(b2p[BPF_REG_0]-1, 3));
+			EMIT(PPC_RAW_MR(b2p[BPF_REG_0], 4));
+			break;
+
+		/*
+		 * Jumps and branches
+		 */
+		case BPF_JMP | BPF_JA:
+			PPC_JMP(addrs[i + 1 + off]);
+			break;
+
+		case BPF_JMP | BPF_JGT | BPF_K:
+		case BPF_JMP | BPF_JGT | BPF_X:
+		case BPF_JMP | BPF_JSGT | BPF_K:
+		case BPF_JMP | BPF_JSGT | BPF_X:
+		case BPF_JMP32 | BPF_JGT | BPF_K:
+		case BPF_JMP32 | BPF_JGT | BPF_X:
+		case BPF_JMP32 | BPF_JSGT | BPF_K:
+		case BPF_JMP32 | BPF_JSGT | BPF_X:
+			true_cond = COND_GT;
+			goto cond_branch;
+		case BPF_JMP | BPF_JLT | BPF_K:
+		case BPF_JMP | BPF_JLT | BPF_X:
+		case BPF_JMP | BPF_JSLT | BPF_K:
+		case BPF_JMP | BPF_JSLT | BPF_X:
+		case BPF_JMP32 | BPF_JLT | BPF_K:
+		case BPF_JMP32 | BPF_JLT | BPF_X:
+		case BPF_JMP32 | BPF_JSLT | BPF_K:
+		case BPF_JMP32 | BPF_JSLT | BPF_X:
+			true_cond = COND_LT;
+			goto cond_branch;
+		case BPF_JMP | BPF_JGE | BPF_K:
+		case BPF_JMP | BPF_JGE | BPF_X:
+		case BPF_JMP | BPF_JSGE | BPF_K:
+		case BPF_JMP | BPF_JSGE | BPF_X:
+		case BPF_JMP32 | BPF_JGE | BPF_K:
+		case BPF_JMP32 | BPF_JGE | BPF_X:
+		case BPF_JMP32 | BPF_JSGE | BPF_K:
+		case BPF_JMP32 | BPF_JSGE | BPF_X:
+			true_cond = COND_GE;
+			goto cond_branch;
+		case BPF_JMP | BPF_JLE | BPF_K:
+		case BPF_JMP | BPF_JLE | BPF_X:
+		case BPF_JMP | BPF_JSLE | BPF_K:
+		case BPF_JMP | BPF_JSLE | BPF_X:
+		case BPF_JMP32 | BPF_JLE | BPF_K:
+		case BPF_JMP32 | BPF_JLE | BPF_X:
+		case BPF_JMP32 | BPF_JSLE | BPF_K:
+		case BPF_JMP32 | BPF_JSLE | BPF_X:
+			true_cond = COND_LE;
+			goto cond_branch;
+		case BPF_JMP | BPF_JEQ | BPF_K:
+		case BPF_JMP | BPF_JEQ | BPF_X:
+		case BPF_JMP32 | BPF_JEQ | BPF_K:
+		case BPF_JMP32 | BPF_JEQ | BPF_X:
+			true_cond = COND_EQ;
+			goto cond_branch;
+		case BPF_JMP | BPF_JNE | BPF_K:
+		case BPF_JMP | BPF_JNE | BPF_X:
+		case BPF_JMP32 | BPF_JNE | BPF_K:
+		case BPF_JMP32 | BPF_JNE | BPF_X:
+			true_cond = COND_NE;
+			goto cond_branch;
+		case BPF_JMP | BPF_JSET | BPF_K:
+		case BPF_JMP | BPF_JSET | BPF_X:
+		case BPF_JMP32 | BPF_JSET | BPF_K:
+		case BPF_JMP32 | BPF_JSET | BPF_X:
+			true_cond = COND_NE;
+			/* Fall through */
+
+cond_branch:
+			switch (code) {
+			case BPF_JMP | BPF_JGT | BPF_X:
+			case BPF_JMP | BPF_JLT | BPF_X:
+			case BPF_JMP | BPF_JGE | BPF_X:
+			case BPF_JMP | BPF_JLE | BPF_X:
+			case BPF_JMP | BPF_JEQ | BPF_X:
+			case BPF_JMP | BPF_JNE | BPF_X:
+				/* unsigned comparison */
+				EMIT(PPC_RAW_CMPLW(dst_reg_h, src_reg_h));
+				PPC_BCC_SHORT(COND_NE, (ctx->idx + 2) * 4);
+				EMIT(PPC_RAW_CMPLW(dst_reg, src_reg));
+				break;
+			case BPF_JMP32 | BPF_JGT | BPF_X:
+			case BPF_JMP32 | BPF_JLT | BPF_X:
+			case BPF_JMP32 | BPF_JGE | BPF_X:
+			case BPF_JMP32 | BPF_JLE | BPF_X:
+			case BPF_JMP32 | BPF_JEQ | BPF_X:
+			case BPF_JMP32 | BPF_JNE | BPF_X:
+				/* unsigned comparison */
+				EMIT(PPC_RAW_CMPLW(dst_reg, src_reg));
+				break;
+			case BPF_JMP | BPF_JSGT | BPF_X:
+			case BPF_JMP | BPF_JSLT | BPF_X:
+			case BPF_JMP | BPF_JSGE | BPF_X:
+			case BPF_JMP | BPF_JSLE | BPF_X:
+				/* signed comparison */
+				EMIT(PPC_RAW_CMPW(dst_reg_h, src_reg_h));
+				PPC_BCC_SHORT(COND_NE, (ctx->idx + 2) * 4);
+				EMIT(PPC_RAW_CMPLW(dst_reg, src_reg));
+				break;
+			case BPF_JMP32 | BPF_JSGT | BPF_X:
+			case BPF_JMP32 | BPF_JSLT | BPF_X:
+			case BPF_JMP32 | BPF_JSGE | BPF_X:
+			case BPF_JMP32 | BPF_JSLE | BPF_X:
+				/* signed comparison */
+				EMIT(PPC_RAW_CMPW(dst_reg, src_reg));
+				break;
+			case BPF_JMP | BPF_JSET | BPF_X:
+				EMIT(PPC_RAW_AND_DOT(0, dst_reg_h, src_reg_h));
+				PPC_BCC_SHORT(COND_NE, (ctx->idx + 2) * 4);
+				EMIT(PPC_RAW_AND_DOT(0, dst_reg, src_reg));
+				break;
+			case BPF_JMP32 | BPF_JSET | BPF_X: {
+				EMIT(PPC_RAW_AND_DOT(0, dst_reg, src_reg));
+				break;
+			case BPF_JMP | BPF_JNE | BPF_K:
+			case BPF_JMP | BPF_JEQ | BPF_K:
+			case BPF_JMP | BPF_JGT | BPF_K:
+			case BPF_JMP | BPF_JLT | BPF_K:
+			case BPF_JMP | BPF_JGE | BPF_K:
+			case BPF_JMP | BPF_JLE | BPF_K:
+				/*
+				 * Need sign-extended load, so only positive
+				 * values can be used as imm in cmpldi
+				 */
+				if (imm >= 0 && imm < 32768) {
+					EMIT(PPC_RAW_CMPLWI(dst_reg_h, 0));
+					PPC_BCC_SHORT(COND_NE, (ctx->idx + 2) * 4);
+					EMIT(PPC_RAW_CMPLWI(dst_reg, imm));
+				} else {
+					/* sign-extending load ... but unsigned comparison */
+					EMIT(PPC_RAW_LI(0, imm < 0 ? -1 : 0));
+					EMIT(PPC_RAW_CMPLW(dst_reg_h, 0));
+					PPC_LI32(0, imm);
+					PPC_BCC_SHORT(COND_NE, (ctx->idx + 2) * 4);
+					EMIT(PPC_RAW_CMPLW(dst_reg, 0));
+				}
+				break;
+			case BPF_JMP32 | BPF_JNE | BPF_K:
+			case BPF_JMP32 | BPF_JEQ | BPF_K:
+			case BPF_JMP32 | BPF_JGT | BPF_K:
+			case BPF_JMP32 | BPF_JLT | BPF_K:
+			case BPF_JMP32 | BPF_JGE | BPF_K:
+			case BPF_JMP32 | BPF_JLE | BPF_K:
+				/*
+				 * Need sign-extended load, so only positive
+				 * values can be used as imm in cmpldi
+				 */
+				if (imm >= 0 && imm < 65536) {
+					EMIT(PPC_RAW_CMPLWI(dst_reg, imm));
+				} else {
+					/* sign-extending load */
+					PPC_LI32(0, imm);
+					/* ... but unsigned comparison */
+					EMIT(PPC_RAW_CMPLW(dst_reg, 0));
+				}
+				break;
+			}
+			case BPF_JMP | BPF_JSGT | BPF_K:
+			case BPF_JMP | BPF_JSLT | BPF_K:
+			case BPF_JMP | BPF_JSGE | BPF_K:
+			case BPF_JMP | BPF_JSLE | BPF_K:
+				/*
+				 * signed comparison, so any 16-bit value
+				 * can be used in cmpdi
+				 */
+				if (imm >= 0 && imm < 65536) {
+					EMIT(PPC_RAW_CMPWI(dst_reg_h, imm < 0 ? -1 : 0));
+					PPC_BCC_SHORT(COND_NE, (ctx->idx + 2) * 4);
+					EMIT(PPC_RAW_CMPLWI(dst_reg, imm));
+				} else {
+					/* sign-extending load */
+					EMIT(PPC_RAW_CMPWI(dst_reg_h, imm < 0 ? -1 : 0));
+					PPC_LI32(0, imm);
+					PPC_BCC_SHORT(COND_NE, (ctx->idx + 2) * 4);
+					EMIT(PPC_RAW_CMPLW(dst_reg, 0));
+				}
+				break;
+			case BPF_JMP32 | BPF_JSGT | BPF_K:
+			case BPF_JMP32 | BPF_JSLT | BPF_K:
+			case BPF_JMP32 | BPF_JSGE | BPF_K:
+			case BPF_JMP32 | BPF_JSLE | BPF_K:
+				/*
+				 * signed comparison, so any 16-bit value
+				 * can be used in cmpdi
+				 */
+				if (imm >= -32768 && imm < 32768) {
+					EMIT(PPC_RAW_CMPWI(dst_reg, imm));
+				} else {
+					/* sign-extending load */
+					PPC_LI32(0, imm);
+					EMIT(PPC_RAW_CMPW(dst_reg, 0));
+				}
+				break;
+			case BPF_JMP | BPF_JSET | BPF_K:
+				/* andi does not sign-extend the immediate */
+				if (imm >= 0 && imm < 32768) {
+					/* PPC_ANDI is _only/always_ dot-form */
+					EMIT(PPC_RAW_ANDI(0, dst_reg, imm));
+				} else {
+					PPC_LI32(0, imm);
+					if (imm < 0) {
+						EMIT(PPC_RAW_CMPWI(dst_reg_h, 0));
+						PPC_BCC_SHORT(COND_NE, (ctx->idx + 2) * 4);
+					}
+					EMIT(PPC_RAW_AND_DOT(0, dst_reg, 0));
+				}
+				break;
+			case BPF_JMP32 | BPF_JSET | BPF_K:
+				/* andi does not sign-extend the immediate */
+				if (imm >= -32768 && imm < 32768)
+					/* PPC_ANDI is _only/always_ dot-form */
+					EMIT(PPC_RAW_ANDI(0, dst_reg, imm));
+				else {
+					PPC_LI32(0, imm);
+					EMIT(PPC_RAW_AND_DOT(0, dst_reg, 0));
+				}
+				break;
+			}
+			PPC_BCC(true_cond, addrs[i + 1 + off]);
+			break;
+
+		/*
+		 * Tail call
+		 */
+		case BPF_JMP | BPF_TAIL_CALL:
+			ctx->seen |= SEEN_TAILCALL;
+			bpf_jit_emit_tail_call(image, ctx, addrs[i + 1]);
+			break;
+
+		default:
+			/*
+			 * The filter contains something cruel & unusual.
+			 * We don't handle it, but also there shouldn't be
+			 * anything missing from our list.
+			 */
+			pr_err_ratelimited("eBPF filter opcode %04x (@%d) unsupported\n", code, i);
+			return -ENOTSUPP;
+		}
+	}
+
+	/* Set end-of-body-code address for exit. */
+	addrs[i] = ctx->idx * 4;
+
+	return 0;
+}
+
+/* Fix the branch target addresses for subprog calls */
+static int bpf_jit_fixup_subprog_calls(struct bpf_prog *fp, u32 *image,
+				       struct codegen_context *ctx, u32 *addrs)
+{
+	const struct bpf_insn *insn = fp->insnsi;
+	bool func_addr_fixed;
+	u64 func_addr;
+	u32 tmp_idx;
+	int i, ret;
+
+	for (i = 0; i < fp->len; i++) {
+		/*
+		 * During the extra pass, only the branch target addresses for
+		 * the subprog calls need to be fixed. All other instructions
+		 * can left untouched.
+		 *
+		 * The JITed image length does not change because we already
+		 * ensure that the JITed instruction sequence for these calls
+		 * are of fixed length by padding them with NOPs.
+		 */
+		if (insn[i].code == (BPF_JMP | BPF_CALL) &&
+		    insn[i].src_reg == BPF_PSEUDO_CALL) {
+			ret = bpf_jit_get_func_addr(fp, &insn[i], true,
+						    &func_addr,
+						    &func_addr_fixed);
+			if (ret < 0)
+				return ret;
+
+			/*
+			 * Save ctx->idx as this would currently point to the
+			 * end of the JITed image and set it to the offset of
+			 * the instruction sequence corresponding to the
+			 * subprog call temporarily.
+			 */
+			tmp_idx = ctx->idx;
+			ctx->idx = addrs[i] / 4;
+			bpf_jit_emit_func_call(image, ctx, func_addr);
+
+			/*
+			 * Restore ctx->idx here. This is safe as the length
+			 * of the JITed sequence remains unchanged.
+			 */
+			ctx->idx = tmp_idx;
+		}
+	}
+
+	return 0;
+}
+
+struct powerpc64_jit_data {
+	struct bpf_binary_header *header;
+	u32 *addrs;
+	u8 *image;
+	u32 proglen;
+	struct codegen_context ctx;
+};
+
+bool bpf_jit_needs_zext(void)
+{
+	return true;
+}
+
+struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
+{
+	u32 proglen;
+	u32 alloclen;
+	u8 *image = NULL;
+	u32 *code_base;
+	u32 *addrs;
+	struct powerpc64_jit_data *jit_data;
+	struct codegen_context cgctx;
+	int pass;
+	int flen;
+	struct bpf_binary_header *bpf_hdr;
+	struct bpf_prog *org_fp = fp;
+	struct bpf_prog *tmp_fp;
+	bool bpf_blinded = false;
+	bool extra_pass = false;
+
+	if (!fp->jit_requested)
+		return org_fp;
+
+	tmp_fp = bpf_jit_blind_constants(org_fp);
+	if (IS_ERR(tmp_fp))
+		return org_fp;
+
+	if (tmp_fp != org_fp) {
+		bpf_blinded = true;
+		fp = tmp_fp;
+	}
+
+	jit_data = fp->aux->jit_data;
+	if (!jit_data) {
+		jit_data = kzalloc(sizeof(*jit_data), GFP_KERNEL);
+		if (!jit_data) {
+			fp = org_fp;
+			goto out;
+		}
+		fp->aux->jit_data = jit_data;
+	}
+
+	flen = fp->len;
+	addrs = jit_data->addrs;
+	if (addrs) {
+		cgctx = jit_data->ctx;
+		image = jit_data->image;
+		bpf_hdr = jit_data->header;
+		proglen = jit_data->proglen;
+		alloclen = proglen + FUNCTION_DESCR_SIZE;
+		extra_pass = true;
+		goto skip_init_ctx;
+	}
+
+	addrs = kcalloc(flen + 1, sizeof(*addrs), GFP_KERNEL);
+	if (addrs == NULL) {
+		fp = org_fp;
+		goto out_addrs;
+	}
+
+	memset(&cgctx, 0, sizeof(struct codegen_context));
+
+	/* Make sure that the stack is quadword aligned. */
+	cgctx.stack_size = round_up(fp->aux->stack_depth, 16);
+
+	/* Scouting faux-generate pass 0 */
+	if (bpf_jit_build_body(fp, 0, &cgctx, addrs, false)) {
+		/* We hit something illegal or unsupported. */
+		fp = org_fp;
+		goto out_addrs;
+	}
+
+	/*
+	 * If we have seen a tail call, we need a second pass.
+	 * This is because bpf_jit_emit_common_epilogue() is called
+	 * from bpf_jit_emit_tail_call() with a not yet stable ctx->seen.
+	 */
+	if (cgctx.seen & SEEN_TAILCALL) {
+		cgctx.idx = 0;
+		if (bpf_jit_build_body(fp, 0, &cgctx, addrs, false)) {
+			fp = org_fp;
+			goto out_addrs;
+		}
+	}
+
+	/*
+	 * Pretend to build prologue, given the features we've seen.  This will
+	 * update ctgtx.idx as it pretends to output instructions, then we can
+	 * calculate total size from idx.
+	 */
+	bpf_jit_build_prologue(0, &cgctx);
+	bpf_jit_build_epilogue(0, &cgctx);
+
+	proglen = cgctx.idx * 4;
+	alloclen = proglen + FUNCTION_DESCR_SIZE;
+
+	bpf_hdr = bpf_jit_binary_alloc(alloclen, &image, 4,
+			bpf_jit_fill_ill_insns);
+	if (!bpf_hdr) {
+		fp = org_fp;
+		goto out_addrs;
+	}
+
+skip_init_ctx:
+	code_base = (u32 *)(image + FUNCTION_DESCR_SIZE);
+
+	if (extra_pass) {
+		/*
+		 * Do not touch the prologue and epilogue as they will remain
+		 * unchanged. Only fix the branch target address for subprog
+		 * calls in the body.
+		 *
+		 * This does not change the offsets and lengths of the subprog
+		 * call instruction sequences and hence, the size of the JITed
+		 * image as well.
+		 */
+		bpf_jit_fixup_subprog_calls(fp, code_base, &cgctx, addrs);
+
+		/* There is no need to perform the usual passes. */
+		goto skip_codegen_passes;
+	}
+
+	/* Code generation passes 1-2 */
+	for (pass = 1; pass < 3; pass++) {
+		/* Now build the prologue, body code & epilogue for real. */
+		cgctx.idx = 0;
+		bpf_jit_build_prologue(code_base, &cgctx);
+		bpf_jit_build_body(fp, code_base, &cgctx, addrs, extra_pass);
+		bpf_jit_build_epilogue(code_base, &cgctx);
+
+		if (bpf_jit_enable > 1)
+			pr_info("Pass %d: shrink = %d, seen = 0x%x\n", pass,
+				proglen - (cgctx.idx * 4), cgctx.seen);
+	}
+
+skip_codegen_passes:
+	if (bpf_jit_enable > 1)
+		/*
+		 * Note that we output the base address of the code_base
+		 * rather than image, since opcodes are in code_base.
+		 */
+		bpf_jit_dump(flen, proglen, pass, code_base);
+
+#ifdef PPC64_ELF_ABI_v1
+	/* Function descriptor nastiness: Address + TOC */
+	((u64 *)image)[0] = (u64)code_base;
+	((u64 *)image)[1] = local_paca->kernel_toc;
+#endif
+
+	fp->bpf_func = (void *)image;
+	fp->jited = 1;
+	fp->jited_len = alloclen;
+
+	bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + (bpf_hdr->pages * PAGE_SIZE));
+	if (!fp->is_func || extra_pass) {
+		bpf_prog_fill_jited_linfo(fp, addrs);
+out_addrs:
+		kfree(addrs);
+		kfree(jit_data);
+		fp->aux->jit_data = NULL;
+	} else {
+		jit_data->addrs = addrs;
+		jit_data->ctx = cgctx;
+		jit_data->proglen = proglen;
+		jit_data->image = image;
+		jit_data->header = bpf_hdr;
+	}
+
+out:
+	if (bpf_blinded)
+		bpf_jit_prog_release_other(fp, fp == org_fp ? tmp_fp : org_fp);
+
+	return fp;
+}
+
+/* Overriding bpf_jit_free() as we don't set images read-only. */
+void bpf_jit_free(struct bpf_prog *fp)
+{
+	unsigned long addr = (unsigned long)fp->bpf_func & PAGE_MASK;
+	struct bpf_binary_header *bpf_hdr = (void *)addr;
+
+	if (fp->jited)
+		bpf_jit_binary_free(bpf_hdr);
+
+	bpf_prog_unlock_free(fp);
+}
-- 
2.25.0

