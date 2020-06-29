Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0251320E174
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731408AbgF2Uz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731289AbgF2TNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:11 -0400
Received: from sym2.noone.org (sym2.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30C4C0086E9
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 02:40:37 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 49wMk91CqqzvjdY; Mon, 29 Jun 2020 11:33:36 +0200 (CEST)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wang YanQing <udknight@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, x86@kernel.org
Subject: [PATCH bpf-next 2/2] bpf, x86: Factor out get_cond_jmp_opcode and use for 64bit x86
Date:   Mon, 29 Jun 2020 11:33:36 +0200
Message-Id: <20200629093336.20963-3-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200629093336.20963-1-tklauser@distanz.ch>
References: <20200629093336.20963-1-tklauser@distanz.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out get_cond_jmp_opcode from bpf_jit_comp64.c and use it in
bpf_jit_comp64.c instead of open-coding it.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 arch/x86/net/Makefile         |  2 +
 arch/x86/net/bpf_jit.h        |  4 ++
 arch/x86/net/bpf_jit_comp32.c | 71 --------------------------------
 arch/x86/net/bpf_jit_comp64.c | 46 ++-------------------
 arch/x86/net/bpf_jit_core.c   | 76 +++++++++++++++++++++++++++++++++++
 5 files changed, 85 insertions(+), 114 deletions(-)
 create mode 100644 arch/x86/net/bpf_jit_core.c

diff --git a/arch/x86/net/Makefile b/arch/x86/net/Makefile
index bf71548fad2c..541544cab139 100644
--- a/arch/x86/net/Makefile
+++ b/arch/x86/net/Makefile
@@ -3,6 +3,8 @@
 # Arch-specific network modules
 #
 
+obj-$(CONFIG_BPF_JIT) += bpf_jit_core.o
+
 ifeq ($(CONFIG_X86_32),y)
         obj-$(CONFIG_BPF_JIT) += bpf_jit_comp32.o
 else
diff --git a/arch/x86/net/bpf_jit.h b/arch/x86/net/bpf_jit.h
index 44cbab10962a..355d96bfe9b3 100644
--- a/arch/x86/net/bpf_jit.h
+++ b/arch/x86/net/bpf_jit.h
@@ -76,6 +76,10 @@ static inline int bpf_size_to_x86_bytes(int bpf_size)
 #define X86_JLE 0x7E
 #define X86_JG  0x7F
 
+#define COND_JMP_OPCODE_INVALID	(0xFF)
+
+u8 get_cond_jmp_opcode(const u8 op, bool is_cmp_lo);
+
 /* Maximum number of bytes emitted while JITing one eBPF insn */
 #define BPF_MAX_INSN_SIZE	128
 #define BPF_INSN_SAFETY		64
diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index aabb44e08737..90738fade68e 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -62,8 +62,6 @@
 #define IA32_EBP	(0x5)
 #define IA32_ESP	(0x4)
 
-#define COND_JMP_OPCODE_INVALID	(0xFF)
-
 /*
  * Map eBPF registers to IA32 32bit registers or stack scratch space.
  *
@@ -1307,75 +1305,6 @@ static inline void emit_push_r64(const u8 src[], u8 **pprog)
 	*pprog = prog;
 }
 
-static u8 get_cond_jmp_opcode(const u8 op, bool is_cmp_lo)
-{
-	u8 jmp_cond;
-
-	/* Convert BPF opcode to x86 */
-	switch (op) {
-	case BPF_JEQ:
-		jmp_cond = X86_JE;
-		break;
-	case BPF_JSET:
-	case BPF_JNE:
-		jmp_cond = X86_JNE;
-		break;
-	case BPF_JGT:
-		/* GT is unsigned '>', JA in x86 */
-		jmp_cond = X86_JA;
-		break;
-	case BPF_JLT:
-		/* LT is unsigned '<', JB in x86 */
-		jmp_cond = X86_JB;
-		break;
-	case BPF_JGE:
-		/* GE is unsigned '>=', JAE in x86 */
-		jmp_cond = X86_JAE;
-		break;
-	case BPF_JLE:
-		/* LE is unsigned '<=', JBE in x86 */
-		jmp_cond = X86_JBE;
-		break;
-	case BPF_JSGT:
-		if (!is_cmp_lo)
-			/* Signed '>', GT in x86 */
-			jmp_cond = X86_JG;
-		else
-			/* GT is unsigned '>', JA in x86 */
-			jmp_cond = X86_JA;
-		break;
-	case BPF_JSLT:
-		if (!is_cmp_lo)
-			/* Signed '<', LT in x86 */
-			jmp_cond = X86_JL;
-		else
-			/* LT is unsigned '<', JB in x86 */
-			jmp_cond = X86_JB;
-		break;
-	case BPF_JSGE:
-		if (!is_cmp_lo)
-			/* Signed '>=', GE in x86 */
-			jmp_cond = X86_JGE;
-		else
-			/* GE is unsigned '>=', JAE in x86 */
-			jmp_cond = X86_JAE;
-		break;
-	case BPF_JSLE:
-		if (!is_cmp_lo)
-			/* Signed '<=', LE in x86 */
-			jmp_cond = X86_JLE;
-		else
-			/* LE is unsigned '<=', JBE in x86 */
-			jmp_cond = X86_JBE;
-		break;
-	default: /* to silence GCC warning */
-		jmp_cond = COND_JMP_OPCODE_INVALID;
-		break;
-	}
-
-	return jmp_cond;
-}
-
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		  int oldproglen, struct jit_context *ctx)
 {
diff --git a/arch/x86/net/bpf_jit_comp64.c b/arch/x86/net/bpf_jit_comp64.c
index e8d0f784ab14..40462fe869f6 100644
--- a/arch/x86/net/bpf_jit_comp64.c
+++ b/arch/x86/net/bpf_jit_comp64.c
@@ -1122,50 +1122,10 @@ xadd:			if (is_imm8(insn->off))
 			else
 				EMIT2_off32(0x81, add_1reg(0xF8, dst_reg), imm32);
 
-emit_cond_jmp:		/* Convert BPF opcode to x86 */
-			switch (BPF_OP(insn->code)) {
-			case BPF_JEQ:
-				jmp_cond = X86_JE;
-				break;
-			case BPF_JSET:
-			case BPF_JNE:
-				jmp_cond = X86_JNE;
-				break;
-			case BPF_JGT:
-				/* GT is unsigned '>', JA in x86 */
-				jmp_cond = X86_JA;
-				break;
-			case BPF_JLT:
-				/* LT is unsigned '<', JB in x86 */
-				jmp_cond = X86_JB;
-				break;
-			case BPF_JGE:
-				/* GE is unsigned '>=', JAE in x86 */
-				jmp_cond = X86_JAE;
-				break;
-			case BPF_JLE:
-				/* LE is unsigned '<=', JBE in x86 */
-				jmp_cond = X86_JBE;
-				break;
-			case BPF_JSGT:
-				/* Signed '>', GT in x86 */
-				jmp_cond = X86_JG;
-				break;
-			case BPF_JSLT:
-				/* Signed '<', LT in x86 */
-				jmp_cond = X86_JL;
-				break;
-			case BPF_JSGE:
-				/* Signed '>=', GE in x86 */
-				jmp_cond = X86_JGE;
-				break;
-			case BPF_JSLE:
-				/* Signed '<=', LE in x86 */
-				jmp_cond = X86_JLE;
-				break;
-			default: /* to silence GCC warning */
+emit_cond_jmp:
+			jmp_cond = get_cond_jmp_opcode(BPF_OP(insn->code), false);
+			if (jmp_cond == COND_JMP_OPCODE_INVALID)
 				return -EFAULT;
-			}
 			jmp_offset = addrs[i + insn->off] - addrs[i];
 			if (is_imm8(jmp_offset)) {
 				EMIT2(jmp_cond, jmp_offset);
diff --git a/arch/x86/net/bpf_jit_core.c b/arch/x86/net/bpf_jit_core.c
new file mode 100644
index 000000000000..a4991d36b517
--- /dev/null
+++ b/arch/x86/net/bpf_jit_core.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Common functionality for x86 32bit and 64bit BPF JIT compilers
+ */
+
+#include <linux/bpf.h>
+#include "bpf_jit.h"
+
+u8 get_cond_jmp_opcode(const u8 op, bool is_cmp_lo)
+{
+	u8 jmp_cond;
+
+	/* Convert BPF opcode to x86 */
+	switch (op) {
+	case BPF_JEQ:
+		jmp_cond = X86_JE;
+		break;
+	case BPF_JSET:
+	case BPF_JNE:
+		jmp_cond = X86_JNE;
+		break;
+	case BPF_JGT:
+		/* GT is unsigned '>', JA in x86 */
+		jmp_cond = X86_JA;
+		break;
+	case BPF_JLT:
+		/* LT is unsigned '<', JB in x86 */
+		jmp_cond = X86_JB;
+		break;
+	case BPF_JGE:
+		/* GE is unsigned '>=', JAE in x86 */
+		jmp_cond = X86_JAE;
+		break;
+	case BPF_JLE:
+		/* LE is unsigned '<=', JBE in x86 */
+		jmp_cond = X86_JBE;
+		break;
+	case BPF_JSGT:
+		if (!is_cmp_lo)
+			/* Signed '>', GT in x86 */
+			jmp_cond = X86_JG;
+		else
+			/* GT is unsigned '>', JA in x86 */
+			jmp_cond = X86_JA;
+		break;
+	case BPF_JSLT:
+		if (!is_cmp_lo)
+			/* Signed '<', LT in x86 */
+			jmp_cond = X86_JL;
+		else
+			/* LT is unsigned '<', JB in x86 */
+			jmp_cond = X86_JB;
+		break;
+	case BPF_JSGE:
+		if (!is_cmp_lo)
+			/* Signed '>=', GE in x86 */
+			jmp_cond = X86_JGE;
+		else
+			/* GE is unsigned '>=', JAE in x86 */
+			jmp_cond = X86_JAE;
+		break;
+	case BPF_JSLE:
+		if (!is_cmp_lo)
+			/* Signed '<=', LE in x86 */
+			jmp_cond = X86_JLE;
+		else
+			/* LE is unsigned '<=', JBE in x86 */
+			jmp_cond = X86_JBE;
+		break;
+	default: /* to silence GCC warning */
+		jmp_cond = COND_JMP_OPCODE_INVALID;
+		break;
+	}
+
+	return jmp_cond;
+}
-- 
2.27.0

