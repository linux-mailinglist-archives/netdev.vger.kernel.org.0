Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230F520E166
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgF2Uzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731291AbgF2TNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:11 -0400
Received: from sym2.noone.org (sym2.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C065AC0086E8
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 02:40:37 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 49wMk85dTTzvjdX; Mon, 29 Jun 2020 11:33:36 +0200 (CEST)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wang YanQing <udknight@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, x86@kernel.org
Subject: [PATCH bpf-next 1/2] bpf, x86: Factor common x86 JIT code
Date:   Mon, 29 Jun 2020 11:33:35 +0200
Message-Id: <20200629093336.20963-2-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200629093336.20963-1-tklauser@distanz.ch>
References: <20200629093336.20963-1-tklauser@distanz.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out code common for 32-bit and 64-bit x86 BPF JITs to bpf_jit.h

Also follow other architectures and rename bpf_jit_comp.c to
bpf_jit_comp64.c to be more explicit.

Also adjust the file matching pattern in MAINTAINERS such that the
common x86 files are included for both the 32-bit and 64-bit BPF JIT
sections.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 MAINTAINERS                                   |   3 +-
 arch/x86/net/Makefile                         |   2 +-
 arch/x86/net/bpf_jit.h                        |  93 ++++++++++++
 arch/x86/net/bpf_jit_comp32.c                 | 135 ++++--------------
 .../net/{bpf_jit_comp.c => bpf_jit_comp64.c}  |  84 +----------
 5 files changed, 123 insertions(+), 194 deletions(-)
 create mode 100644 arch/x86/net/bpf_jit.h
 rename arch/x86/net/{bpf_jit_comp.c => bpf_jit_comp64.c} (96%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 301330e02bca..509e0c6a9590 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3326,7 +3326,8 @@ M:	Wang YanQing <udknight@gmail.com>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Maintained
-F:	arch/x86/net/bpf_jit_comp32.c
+F:	arch/x86/net/
+X:	arch/x86/net/bpf_jit_comp64.c
 
 BPF JIT for X86 64-BIT
 M:	Alexei Starovoitov <ast@kernel.org>
diff --git a/arch/x86/net/Makefile b/arch/x86/net/Makefile
index 383c87300b0d..bf71548fad2c 100644
--- a/arch/x86/net/Makefile
+++ b/arch/x86/net/Makefile
@@ -6,5 +6,5 @@
 ifeq ($(CONFIG_X86_32),y)
         obj-$(CONFIG_BPF_JIT) += bpf_jit_comp32.o
 else
-        obj-$(CONFIG_BPF_JIT) += bpf_jit_comp.o
+        obj-$(CONFIG_BPF_JIT) += bpf_jit_comp64.o
 endif
diff --git a/arch/x86/net/bpf_jit.h b/arch/x86/net/bpf_jit.h
new file mode 100644
index 000000000000..44cbab10962a
--- /dev/null
+++ b/arch/x86/net/bpf_jit.h
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common functionality for x86 32-bit and 64-bit BPF JIT compilers
+ */
+#ifndef _BPF_JIT_H
+#define _BPF_JIT_H
+
+#include <linux/bpf.h>
+
+static inline u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
+{
+	if (len == 1)
+		*ptr = bytes;
+	else if (len == 2)
+		*(u16 *)ptr = bytes;
+	else {
+		*(u32 *)ptr = bytes;
+		barrier();
+	}
+	return ptr + len;
+}
+
+#define EMIT(bytes, len) \
+	do { prog = emit_code(prog, bytes, len); cnt += len; } while (0)
+
+#define EMIT1(b1)		EMIT(b1, 1)
+#define EMIT2(b1, b2)		EMIT((b1) + ((b2) << 8), 2)
+#define EMIT3(b1, b2, b3)	EMIT((b1) + ((b2) << 8) + ((b3) << 16), 3)
+#define EMIT4(b1, b2, b3, b4)   EMIT((b1) + ((b2) << 8) + ((b3) << 16) + ((b4) << 24), 4)
+
+#define EMIT1_off32(b1, off) \
+	do { EMIT1(b1); EMIT(off, 4); } while (0)
+#define EMIT2_off32(b1, b2, off) \
+	do { EMIT2(b1, b2); EMIT(off, 4); } while (0)
+#define EMIT3_off32(b1, b2, b3, off) \
+	do { EMIT3(b1, b2, b3); EMIT(off, 4); } while (0)
+#define EMIT4_off32(b1, b2, b3, b4, off) \
+	do { EMIT4(b1, b2, b3, b4); EMIT(off, 4); } while (0)
+
+static inline bool is_imm8(int value)
+{
+	return value <= 127 && value >= -128;
+}
+
+static inline bool is_simm32(s64 value)
+{
+	return value == (s64)(s32)value;
+}
+
+static inline int bpf_size_to_x86_bytes(int bpf_size)
+{
+	if (bpf_size == BPF_W)
+		return 4;
+	else if (bpf_size == BPF_H)
+		return 2;
+	else if (bpf_size == BPF_B)
+		return 1;
+	else if (bpf_size == BPF_DW)
+		return 4; /* imm32 */
+	else
+		return 0;
+}
+
+/*
+ * List of x86 cond jumps opcodes (. + s8)
+ * Add 0x10 (and an extra 0x0f) to generate far jumps (. + s32)
+ */
+#define X86_JB  0x72
+#define X86_JAE 0x73
+#define X86_JE  0x74
+#define X86_JNE 0x75
+#define X86_JBE 0x76
+#define X86_JA  0x77
+#define X86_JL  0x7C
+#define X86_JGE 0x7D
+#define X86_JLE 0x7E
+#define X86_JG  0x7F
+
+/* Maximum number of bytes emitted while JITing one eBPF insn */
+#define BPF_MAX_INSN_SIZE	128
+#define BPF_INSN_SAFETY		64
+
+static inline void jit_fill_hole(void *area, unsigned int size)
+{
+	/* Fill whole space with INT3 instructions */
+	memset(area, 0xcc, size);
+}
+
+struct jit_context {
+	int cleanup_addr; /* Epilogue code offset */
+};
+
+#endif /* _BPF_JIT_H */
diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 96fde03aa987..aabb44e08737 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -16,6 +16,7 @@
 #include <asm/set_memory.h>
 #include <asm/nospec-branch.h>
 #include <linux/bpf.h>
+#include "bpf_jit.h"
 
 /*
  * eBPF prog stack layout:
@@ -47,49 +48,8 @@
  *                                low
  */
 
-static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
-{
-	if (len == 1)
-		*ptr = bytes;
-	else if (len == 2)
-		*(u16 *)ptr = bytes;
-	else {
-		*(u32 *)ptr = bytes;
-		barrier();
-	}
-	return ptr + len;
-}
-
-#define EMIT(bytes, len) \
-	do { prog = emit_code(prog, bytes, len); cnt += len; } while (0)
-
-#define EMIT1(b1)		EMIT(b1, 1)
-#define EMIT2(b1, b2)		EMIT((b1) + ((b2) << 8), 2)
-#define EMIT3(b1, b2, b3)	EMIT((b1) + ((b2) << 8) + ((b3) << 16), 3)
-#define EMIT4(b1, b2, b3, b4)   \
-	EMIT((b1) + ((b2) << 8) + ((b3) << 16) + ((b4) << 24), 4)
-
-#define EMIT1_off32(b1, off) \
-	do { EMIT1(b1); EMIT(off, 4); } while (0)
-#define EMIT2_off32(b1, b2, off) \
-	do { EMIT2(b1, b2); EMIT(off, 4); } while (0)
-#define EMIT3_off32(b1, b2, b3, off) \
-	do { EMIT3(b1, b2, b3); EMIT(off, 4); } while (0)
-#define EMIT4_off32(b1, b2, b3, b4, off) \
-	do { EMIT4(b1, b2, b3, b4); EMIT(off, 4); } while (0)
-
 #define jmp_label(label, jmp_insn_len) (label - cnt - jmp_insn_len)
 
-static bool is_imm8(int value)
-{
-	return value <= 127 && value >= -128;
-}
-
-static bool is_simm32(s64 value)
-{
-	return value == (s64) (s32) value;
-}
-
 #define STACK_OFFSET(k)	(k)
 #define TCALL_CNT	(MAX_BPF_JIT_REG + 0)	/* Tail Call Count */
 
@@ -102,21 +62,6 @@ static bool is_simm32(s64 value)
 #define IA32_EBP	(0x5)
 #define IA32_ESP	(0x4)
 
-/*
- * List of x86 cond jumps opcodes (. + s8)
- * Add 0x10 (and an extra 0x0f) to generate far jumps (. + s32)
- */
-#define IA32_JB  0x72
-#define IA32_JAE 0x73
-#define IA32_JE  0x74
-#define IA32_JNE 0x75
-#define IA32_JBE 0x76
-#define IA32_JA  0x77
-#define IA32_JL  0x7C
-#define IA32_JGE 0x7D
-#define IA32_JLE 0x7E
-#define IA32_JG  0x7F
-
 #define COND_JMP_OPCODE_INVALID	(0xFF)
 
 /*
@@ -196,12 +141,6 @@ static u8 add_2reg(u8 byte, u32 dst_reg, u32 src_reg)
 	return byte + dst_reg + (src_reg << 3);
 }
 
-static void jit_fill_hole(void *area, unsigned int size)
-{
-	/* Fill whole space with int3 instructions */
-	memset(area, 0xcc, size);
-}
-
 static inline void emit_ia32_mov_i(const u8 dst, const u32 val, bool dstk,
 				   u8 **pprog)
 {
@@ -760,7 +699,7 @@ static inline void emit_ia32_lsh_r64(const u8 dst[], const u8 src[],
 	/* cmp ecx,32 */
 	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
 	/* skip the next two instructions (4 bytes) when < 32 */
-	EMIT2(IA32_JB, 4);
+	EMIT2(X86_JB, 4);
 
 	/* mov dreg_hi,dreg_lo */
 	EMIT2(0x89, add_2reg(0xC0, dreg_hi, dreg_lo));
@@ -813,7 +752,7 @@ static inline void emit_ia32_arsh_r64(const u8 dst[], const u8 src[],
 	/* cmp ecx,32 */
 	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
 	/* skip the next two instructions (5 bytes) when < 32 */
-	EMIT2(IA32_JB, 5);
+	EMIT2(X86_JB, 5);
 
 	/* mov dreg_lo,dreg_hi */
 	EMIT2(0x89, add_2reg(0xC0, dreg_lo, dreg_hi));
@@ -866,7 +805,7 @@ static inline void emit_ia32_rsh_r64(const u8 dst[], const u8 src[], bool dstk,
 	/* cmp ecx,32 */
 	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
 	/* skip the next two instructions (4 bytes) when < 32 */
-	EMIT2(IA32_JB, 4);
+	EMIT2(X86_JB, 4);
 
 	/* mov dreg_lo,dreg_hi */
 	EMIT2(0x89, add_2reg(0xC0, dreg_lo, dreg_hi));
@@ -1168,28 +1107,6 @@ static inline void emit_ia32_mul_i64(const u8 dst[], const u32 val,
 	*pprog = prog;
 }
 
-static int bpf_size_to_x86_bytes(int bpf_size)
-{
-	if (bpf_size == BPF_W)
-		return 4;
-	else if (bpf_size == BPF_H)
-		return 2;
-	else if (bpf_size == BPF_B)
-		return 1;
-	else if (bpf_size == BPF_DW)
-		return 4; /* imm32 */
-	else
-		return 0;
-}
-
-struct jit_context {
-	int cleanup_addr; /* Epilogue code offset */
-};
-
-/* Maximum number of bytes emitted while JITing one eBPF insn */
-#define BPF_MAX_INSN_SIZE	128
-#define BPF_INSN_SAFETY		64
-
 #define PROLOGUE_SIZE 35
 
 /*
@@ -1304,7 +1221,7 @@ static void emit_bpf_tail_call(u8 **pprog)
 	EMIT3(0x39, add_2reg(0x40, IA32_EAX, IA32_EDX),
 	      offsetof(struct bpf_array, map.max_entries));
 	/* jbe out */
-	EMIT2(IA32_JBE, jmp_label(jmp_label1, 2));
+	EMIT2(X86_JBE, jmp_label(jmp_label1, 2));
 
 	/*
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
@@ -1317,12 +1234,12 @@ static void emit_bpf_tail_call(u8 **pprog)
 
 	/* cmp edx,hi */
 	EMIT3(0x83, add_1reg(0xF8, IA32_EBX), hi);
-	EMIT2(IA32_JNE, 3);
+	EMIT2(X86_JNE, 3);
 	/* cmp ecx,lo */
 	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), lo);
 
 	/* ja out */
-	EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
+	EMIT2(X86_JAE, jmp_label(jmp_label1, 2));
 
 	/* add eax,0x1 */
 	EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 0x01);
@@ -1345,7 +1262,7 @@ static void emit_bpf_tail_call(u8 **pprog)
 	/* test edx,edx */
 	EMIT2(0x85, add_2reg(0xC0, IA32_EDX, IA32_EDX));
 	/* je out */
-	EMIT2(IA32_JE, jmp_label(jmp_label1, 2));
+	EMIT2(X86_JE, jmp_label(jmp_label1, 2));
 
 	/* goto *(prog->bpf_func + prologue_size); */
 	/* mov edx, dword ptr [edx + 32] */
@@ -1397,59 +1314,59 @@ static u8 get_cond_jmp_opcode(const u8 op, bool is_cmp_lo)
 	/* Convert BPF opcode to x86 */
 	switch (op) {
 	case BPF_JEQ:
-		jmp_cond = IA32_JE;
+		jmp_cond = X86_JE;
 		break;
 	case BPF_JSET:
 	case BPF_JNE:
-		jmp_cond = IA32_JNE;
+		jmp_cond = X86_JNE;
 		break;
 	case BPF_JGT:
 		/* GT is unsigned '>', JA in x86 */
-		jmp_cond = IA32_JA;
+		jmp_cond = X86_JA;
 		break;
 	case BPF_JLT:
 		/* LT is unsigned '<', JB in x86 */
-		jmp_cond = IA32_JB;
+		jmp_cond = X86_JB;
 		break;
 	case BPF_JGE:
 		/* GE is unsigned '>=', JAE in x86 */
-		jmp_cond = IA32_JAE;
+		jmp_cond = X86_JAE;
 		break;
 	case BPF_JLE:
 		/* LE is unsigned '<=', JBE in x86 */
-		jmp_cond = IA32_JBE;
+		jmp_cond = X86_JBE;
 		break;
 	case BPF_JSGT:
 		if (!is_cmp_lo)
 			/* Signed '>', GT in x86 */
-			jmp_cond = IA32_JG;
+			jmp_cond = X86_JG;
 		else
 			/* GT is unsigned '>', JA in x86 */
-			jmp_cond = IA32_JA;
+			jmp_cond = X86_JA;
 		break;
 	case BPF_JSLT:
 		if (!is_cmp_lo)
 			/* Signed '<', LT in x86 */
-			jmp_cond = IA32_JL;
+			jmp_cond = X86_JL;
 		else
 			/* LT is unsigned '<', JB in x86 */
-			jmp_cond = IA32_JB;
+			jmp_cond = X86_JB;
 		break;
 	case BPF_JSGE:
 		if (!is_cmp_lo)
 			/* Signed '>=', GE in x86 */
-			jmp_cond = IA32_JGE;
+			jmp_cond = X86_JGE;
 		else
 			/* GE is unsigned '>=', JAE in x86 */
-			jmp_cond = IA32_JAE;
+			jmp_cond = X86_JAE;
 		break;
 	case BPF_JSLE:
 		if (!is_cmp_lo)
 			/* Signed '<=', LE in x86 */
-			jmp_cond = IA32_JLE;
+			jmp_cond = X86_JLE;
 		else
 			/* LE is unsigned '<=', JBE in x86 */
-			jmp_cond = IA32_JBE;
+			jmp_cond = X86_JBE;
 		break;
 	default: /* to silence GCC warning */
 		jmp_cond = COND_JMP_OPCODE_INVALID;
@@ -1972,7 +1889,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			if (is_jmp64) {
 				/* cmp dreg_hi,sreg_hi */
 				EMIT2(0x39, add_2reg(0xC0, dreg_hi, sreg_hi));
-				EMIT2(IA32_JNE, 2);
+				EMIT2(X86_JNE, 2);
 			}
 			/* cmp dreg_lo,sreg_lo */
 			EMIT2(0x39, add_2reg(0xC0, dreg_lo, sreg_lo));
@@ -2007,7 +1924,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 
 			/* cmp dreg_hi,sreg_hi */
 			EMIT2(0x39, add_2reg(0xC0, dreg_hi, sreg_hi));
-			EMIT2(IA32_JNE, 10);
+			EMIT2(X86_JNE, 10);
 			/* cmp dreg_lo,sreg_lo */
 			EMIT2(0x39, add_2reg(0xC0, dreg_lo, sreg_lo));
 			goto emit_cond_jmp_signed;
@@ -2139,7 +2056,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 				EMIT2_off32(0xC7, add_1reg(0xC0, IA32_EBX), hi);
 				/* cmp dreg_hi,sreg_hi */
 				EMIT2(0x39, add_2reg(0xC0, dreg_hi, sreg_hi));
-				EMIT2(IA32_JNE, 2);
+				EMIT2(X86_JNE, 2);
 			}
 			/* cmp dreg_lo,sreg_lo */
 			EMIT2(0x39, add_2reg(0xC0, dreg_lo, sreg_lo));
@@ -2184,7 +2101,7 @@ emit_cond_jmp:		jmp_cond = get_cond_jmp_opcode(BPF_OP(code), false);
 			EMIT2_off32(0xC7, add_1reg(0xC0, IA32_EBX), hi);
 			/* cmp dreg_hi,sreg_hi */
 			EMIT2(0x39, add_2reg(0xC0, dreg_hi, sreg_hi));
-			EMIT2(IA32_JNE, 10);
+			EMIT2(X86_JNE, 10);
 			/* cmp dreg_lo,sreg_lo */
 			EMIT2(0x39, add_2reg(0xC0, dreg_lo, sreg_lo));
 
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp64.c
similarity index 96%
rename from arch/x86/net/bpf_jit_comp.c
rename to arch/x86/net/bpf_jit_comp64.c
index 42b6709e6dc7..e8d0f784ab14 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp64.c
@@ -16,46 +16,7 @@
 #include <asm/nospec-branch.h>
 #include <asm/text-patching.h>
 #include <asm/asm-prototypes.h>
-
-static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
-{
-	if (len == 1)
-		*ptr = bytes;
-	else if (len == 2)
-		*(u16 *)ptr = bytes;
-	else {
-		*(u32 *)ptr = bytes;
-		barrier();
-	}
-	return ptr + len;
-}
-
-#define EMIT(bytes, len) \
-	do { prog = emit_code(prog, bytes, len); cnt += len; } while (0)
-
-#define EMIT1(b1)		EMIT(b1, 1)
-#define EMIT2(b1, b2)		EMIT((b1) + ((b2) << 8), 2)
-#define EMIT3(b1, b2, b3)	EMIT((b1) + ((b2) << 8) + ((b3) << 16), 3)
-#define EMIT4(b1, b2, b3, b4)   EMIT((b1) + ((b2) << 8) + ((b3) << 16) + ((b4) << 24), 4)
-
-#define EMIT1_off32(b1, off) \
-	do { EMIT1(b1); EMIT(off, 4); } while (0)
-#define EMIT2_off32(b1, b2, off) \
-	do { EMIT2(b1, b2); EMIT(off, 4); } while (0)
-#define EMIT3_off32(b1, b2, b3, off) \
-	do { EMIT3(b1, b2, b3); EMIT(off, 4); } while (0)
-#define EMIT4_off32(b1, b2, b3, b4, off) \
-	do { EMIT4(b1, b2, b3, b4); EMIT(off, 4); } while (0)
-
-static bool is_imm8(int value)
-{
-	return value <= 127 && value >= -128;
-}
-
-static bool is_simm32(s64 value)
-{
-	return value == (s64)(s32)value;
-}
+#include "bpf_jit.h"
 
 static bool is_uimm32(u64 value)
 {
@@ -69,35 +30,6 @@ static bool is_uimm32(u64 value)
 			EMIT3(add_2mod(0x48, DST, SRC), 0x89, add_2reg(0xC0, DST, SRC)); \
 	} while (0)
 
-static int bpf_size_to_x86_bytes(int bpf_size)
-{
-	if (bpf_size == BPF_W)
-		return 4;
-	else if (bpf_size == BPF_H)
-		return 2;
-	else if (bpf_size == BPF_B)
-		return 1;
-	else if (bpf_size == BPF_DW)
-		return 4; /* imm32 */
-	else
-		return 0;
-}
-
-/*
- * List of x86 cond jumps opcodes (. + s8)
- * Add 0x10 (and an extra 0x0f) to generate far jumps (. + s32)
- */
-#define X86_JB  0x72
-#define X86_JAE 0x73
-#define X86_JE  0x74
-#define X86_JNE 0x75
-#define X86_JBE 0x76
-#define X86_JA  0x77
-#define X86_JL  0x7C
-#define X86_JGE 0x7D
-#define X86_JLE 0x7E
-#define X86_JG  0x7F
-
 /* Pick a register outside of BPF range for JIT internal work */
 #define AUX_REG (MAX_BPF_JIT_REG + 1)
 #define X86_REG_R9 (MAX_BPF_JIT_REG + 2)
@@ -205,20 +137,6 @@ static u8 add_2reg(u8 byte, u32 dst_reg, u32 src_reg)
 	return byte + reg2hex[dst_reg] + (reg2hex[src_reg] << 3);
 }
 
-static void jit_fill_hole(void *area, unsigned int size)
-{
-	/* Fill whole space with INT3 instructions */
-	memset(area, 0xcc, size);
-}
-
-struct jit_context {
-	int cleanup_addr; /* Epilogue code offset */
-};
-
-/* Maximum number of bytes emitted while JITing one eBPF insn */
-#define BPF_MAX_INSN_SIZE	128
-#define BPF_INSN_SAFETY		64
-
 /* Number of bytes emit_patch() needs to generate instructions */
 #define X86_PATCH_SIZE		5
 
-- 
2.27.0

