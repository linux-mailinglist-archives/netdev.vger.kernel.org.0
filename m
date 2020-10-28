Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577B229D571
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgJ1WC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729511AbgJ1WCZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:02:25 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD4C224800;
        Wed, 28 Oct 2020 17:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603905320;
        bh=Id1CoooLkQIG6aaDVBs3GXbLYU7CsAhw17UGJ0Qqpdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TclSE7LJDqdLP0/8CH9JVyTRZ1b9IScciLRD/lDExb/STHWmSiwLUxStlTihpgiRv
         8ivTljK5RW0HGuXdbnHNhP8arv80E08F5icL+T7ZybRTA+kngqsIw9usiSTsJUZSzQ
         VkesGyuP2HqmK8QeSSSmh0BdKioZOU/6OzFR1CCk=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, arnd@arndb.de,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 2/2] bpf: move interpreter into separate source file
Date:   Wed, 28 Oct 2020 18:15:06 +0100
Message-Id: <20201028171506.15682-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201028171506.15682-1-ardb@kernel.org>
References: <20201028171506.15682-1-ardb@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To reduce the impact of disabling certain compiler optimizations that
are only needed for the interpreter, move it into its own source file,
and apply the compiler command line override only to this file.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/filter.h |   1 +
 kernel/bpf/Makefile    |   7 +-
 kernel/bpf/core.c      | 567 ------------------
 kernel/bpf/interp.c    | 601 ++++++++++++++++++++
 4 files changed, 605 insertions(+), 571 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 72d62cbc1578..5e027cddcbea 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -841,6 +841,7 @@ static inline int sk_filter(struct sock *sk, struct sk_buff *skb)
 }
 
 struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err);
+void bpf_prog_select_func(struct bpf_prog *fp);
 void bpf_prog_free(struct bpf_prog *fp);
 
 bool bpf_opcode_in_insntable(u8 code);
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index c1b9f71ee6aa..a1573be0d94b 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -1,10 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-y := core.o
-ifneq ($(CONFIG_BPF_JIT_ALWAYS_ON),y)
+obj-y := core.o interp.o
+
 # ___bpf_prog_run() needs GCSE disabled on x86; see 3193c0836f203 for details
 cflags-nogcse-$(CONFIG_X86)$(CONFIG_CC_IS_GCC) := -fno-gcse
-endif
-CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
+CFLAGS_interp.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 55454d2278b1..81d874b85240 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -34,28 +34,6 @@
 #include <linux/log2.h>
 #include <asm/unaligned.h>
 
-/* Registers */
-#define BPF_R0	regs[BPF_REG_0]
-#define BPF_R1	regs[BPF_REG_1]
-#define BPF_R2	regs[BPF_REG_2]
-#define BPF_R3	regs[BPF_REG_3]
-#define BPF_R4	regs[BPF_REG_4]
-#define BPF_R5	regs[BPF_REG_5]
-#define BPF_R6	regs[BPF_REG_6]
-#define BPF_R7	regs[BPF_REG_7]
-#define BPF_R8	regs[BPF_REG_8]
-#define BPF_R9	regs[BPF_REG_9]
-#define BPF_R10	regs[BPF_REG_10]
-
-/* Named registers */
-#define DST	regs[insn->dst_reg]
-#define SRC	regs[insn->src_reg]
-#define FP	regs[BPF_REG_FP]
-#define AX	regs[BPF_REG_AX]
-#define ARG1	regs[BPF_REG_ARG1]
-#define CTX	regs[BPF_REG_CTX]
-#define IMM	insn->imm
-
 /* No hurry in this branch
  *
  * Exported for the bpf jit load helper.
@@ -1196,540 +1174,6 @@ noinline u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5)
 }
 EXPORT_SYMBOL_GPL(__bpf_call_base);
 
-/* All UAPI available opcodes. */
-#define BPF_INSN_MAP(INSN_2, INSN_3)		\
-	/* 32 bit ALU operations. */		\
-	/*   Register based. */			\
-	INSN_3(ALU, ADD,  X),			\
-	INSN_3(ALU, SUB,  X),			\
-	INSN_3(ALU, AND,  X),			\
-	INSN_3(ALU, OR,   X),			\
-	INSN_3(ALU, LSH,  X),			\
-	INSN_3(ALU, RSH,  X),			\
-	INSN_3(ALU, XOR,  X),			\
-	INSN_3(ALU, MUL,  X),			\
-	INSN_3(ALU, MOV,  X),			\
-	INSN_3(ALU, ARSH, X),			\
-	INSN_3(ALU, DIV,  X),			\
-	INSN_3(ALU, MOD,  X),			\
-	INSN_2(ALU, NEG),			\
-	INSN_3(ALU, END, TO_BE),		\
-	INSN_3(ALU, END, TO_LE),		\
-	/*   Immediate based. */		\
-	INSN_3(ALU, ADD,  K),			\
-	INSN_3(ALU, SUB,  K),			\
-	INSN_3(ALU, AND,  K),			\
-	INSN_3(ALU, OR,   K),			\
-	INSN_3(ALU, LSH,  K),			\
-	INSN_3(ALU, RSH,  K),			\
-	INSN_3(ALU, XOR,  K),			\
-	INSN_3(ALU, MUL,  K),			\
-	INSN_3(ALU, MOV,  K),			\
-	INSN_3(ALU, ARSH, K),			\
-	INSN_3(ALU, DIV,  K),			\
-	INSN_3(ALU, MOD,  K),			\
-	/* 64 bit ALU operations. */		\
-	/*   Register based. */			\
-	INSN_3(ALU64, ADD,  X),			\
-	INSN_3(ALU64, SUB,  X),			\
-	INSN_3(ALU64, AND,  X),			\
-	INSN_3(ALU64, OR,   X),			\
-	INSN_3(ALU64, LSH,  X),			\
-	INSN_3(ALU64, RSH,  X),			\
-	INSN_3(ALU64, XOR,  X),			\
-	INSN_3(ALU64, MUL,  X),			\
-	INSN_3(ALU64, MOV,  X),			\
-	INSN_3(ALU64, ARSH, X),			\
-	INSN_3(ALU64, DIV,  X),			\
-	INSN_3(ALU64, MOD,  X),			\
-	INSN_2(ALU64, NEG),			\
-	/*   Immediate based. */		\
-	INSN_3(ALU64, ADD,  K),			\
-	INSN_3(ALU64, SUB,  K),			\
-	INSN_3(ALU64, AND,  K),			\
-	INSN_3(ALU64, OR,   K),			\
-	INSN_3(ALU64, LSH,  K),			\
-	INSN_3(ALU64, RSH,  K),			\
-	INSN_3(ALU64, XOR,  K),			\
-	INSN_3(ALU64, MUL,  K),			\
-	INSN_3(ALU64, MOV,  K),			\
-	INSN_3(ALU64, ARSH, K),			\
-	INSN_3(ALU64, DIV,  K),			\
-	INSN_3(ALU64, MOD,  K),			\
-	/* Call instruction. */			\
-	INSN_2(JMP, CALL),			\
-	/* Exit instruction. */			\
-	INSN_2(JMP, EXIT),			\
-	/* 32-bit Jump instructions. */		\
-	/*   Register based. */			\
-	INSN_3(JMP32, JEQ,  X),			\
-	INSN_3(JMP32, JNE,  X),			\
-	INSN_3(JMP32, JGT,  X),			\
-	INSN_3(JMP32, JLT,  X),			\
-	INSN_3(JMP32, JGE,  X),			\
-	INSN_3(JMP32, JLE,  X),			\
-	INSN_3(JMP32, JSGT, X),			\
-	INSN_3(JMP32, JSLT, X),			\
-	INSN_3(JMP32, JSGE, X),			\
-	INSN_3(JMP32, JSLE, X),			\
-	INSN_3(JMP32, JSET, X),			\
-	/*   Immediate based. */		\
-	INSN_3(JMP32, JEQ,  K),			\
-	INSN_3(JMP32, JNE,  K),			\
-	INSN_3(JMP32, JGT,  K),			\
-	INSN_3(JMP32, JLT,  K),			\
-	INSN_3(JMP32, JGE,  K),			\
-	INSN_3(JMP32, JLE,  K),			\
-	INSN_3(JMP32, JSGT, K),			\
-	INSN_3(JMP32, JSLT, K),			\
-	INSN_3(JMP32, JSGE, K),			\
-	INSN_3(JMP32, JSLE, K),			\
-	INSN_3(JMP32, JSET, K),			\
-	/* Jump instructions. */		\
-	/*   Register based. */			\
-	INSN_3(JMP, JEQ,  X),			\
-	INSN_3(JMP, JNE,  X),			\
-	INSN_3(JMP, JGT,  X),			\
-	INSN_3(JMP, JLT,  X),			\
-	INSN_3(JMP, JGE,  X),			\
-	INSN_3(JMP, JLE,  X),			\
-	INSN_3(JMP, JSGT, X),			\
-	INSN_3(JMP, JSLT, X),			\
-	INSN_3(JMP, JSGE, X),			\
-	INSN_3(JMP, JSLE, X),			\
-	INSN_3(JMP, JSET, X),			\
-	/*   Immediate based. */		\
-	INSN_3(JMP, JEQ,  K),			\
-	INSN_3(JMP, JNE,  K),			\
-	INSN_3(JMP, JGT,  K),			\
-	INSN_3(JMP, JLT,  K),			\
-	INSN_3(JMP, JGE,  K),			\
-	INSN_3(JMP, JLE,  K),			\
-	INSN_3(JMP, JSGT, K),			\
-	INSN_3(JMP, JSLT, K),			\
-	INSN_3(JMP, JSGE, K),			\
-	INSN_3(JMP, JSLE, K),			\
-	INSN_3(JMP, JSET, K),			\
-	INSN_2(JMP, JA),			\
-	/* Store instructions. */		\
-	/*   Register based. */			\
-	INSN_3(STX, MEM,  B),			\
-	INSN_3(STX, MEM,  H),			\
-	INSN_3(STX, MEM,  W),			\
-	INSN_3(STX, MEM,  DW),			\
-	INSN_3(STX, XADD, W),			\
-	INSN_3(STX, XADD, DW),			\
-	/*   Immediate based. */		\
-	INSN_3(ST, MEM, B),			\
-	INSN_3(ST, MEM, H),			\
-	INSN_3(ST, MEM, W),			\
-	INSN_3(ST, MEM, DW),			\
-	/* Load instructions. */		\
-	/*   Register based. */			\
-	INSN_3(LDX, MEM, B),			\
-	INSN_3(LDX, MEM, H),			\
-	INSN_3(LDX, MEM, W),			\
-	INSN_3(LDX, MEM, DW),			\
-	/*   Immediate based. */		\
-	INSN_3(LD, IMM, DW)
-
-bool bpf_opcode_in_insntable(u8 code)
-{
-#define BPF_INSN_2_TBL(x, y)    [BPF_##x | BPF_##y] = true
-#define BPF_INSN_3_TBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = true
-	static const bool public_insntable[256] = {
-		[0 ... 255] = false,
-		/* Now overwrite non-defaults ... */
-		BPF_INSN_MAP(BPF_INSN_2_TBL, BPF_INSN_3_TBL),
-		/* UAPI exposed, but rewritten opcodes. cBPF carry-over. */
-		[BPF_LD | BPF_ABS | BPF_B] = true,
-		[BPF_LD | BPF_ABS | BPF_H] = true,
-		[BPF_LD | BPF_ABS | BPF_W] = true,
-		[BPF_LD | BPF_IND | BPF_B] = true,
-		[BPF_LD | BPF_IND | BPF_H] = true,
-		[BPF_LD | BPF_IND | BPF_W] = true,
-	};
-#undef BPF_INSN_3_TBL
-#undef BPF_INSN_2_TBL
-	return public_insntable[code];
-}
-
-#ifndef CONFIG_BPF_JIT_ALWAYS_ON
-u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
-{
-	memset(dst, 0, size);
-	return -EFAULT;
-}
-
-/**
- *	__bpf_prog_run - run eBPF program on a given context
- *	@regs: is the array of MAX_BPF_EXT_REG eBPF pseudo-registers
- *	@insn: is the array of eBPF instructions
- *	@stack: is the eBPF storage stack
- *
- * Decode and execute eBPF instructions.
- */
-static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
-{
-#define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
-#define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
-	static const void * const jumptable[256] __annotate_jump_table = {
-		[0 ... 255] = &&default_label,
-		/* Now overwrite non-defaults ... */
-		BPF_INSN_MAP(BPF_INSN_2_LBL, BPF_INSN_3_LBL),
-		/* Non-UAPI available opcodes. */
-		[BPF_JMP | BPF_CALL_ARGS] = &&JMP_CALL_ARGS,
-		[BPF_JMP | BPF_TAIL_CALL] = &&JMP_TAIL_CALL,
-		[BPF_LDX | BPF_PROBE_MEM | BPF_B] = &&LDX_PROBE_MEM_B,
-		[BPF_LDX | BPF_PROBE_MEM | BPF_H] = &&LDX_PROBE_MEM_H,
-		[BPF_LDX | BPF_PROBE_MEM | BPF_W] = &&LDX_PROBE_MEM_W,
-		[BPF_LDX | BPF_PROBE_MEM | BPF_DW] = &&LDX_PROBE_MEM_DW,
-	};
-#undef BPF_INSN_3_LBL
-#undef BPF_INSN_2_LBL
-	u32 tail_call_cnt = 0;
-
-#define CONT	 ({ insn++; goto select_insn; })
-#define CONT_JMP ({ insn++; goto select_insn; })
-
-select_insn:
-	goto *jumptable[insn->code];
-
-	/* ALU */
-#define ALU(OPCODE, OP)			\
-	ALU64_##OPCODE##_X:		\
-		DST = DST OP SRC;	\
-		CONT;			\
-	ALU_##OPCODE##_X:		\
-		DST = (u32) DST OP (u32) SRC;	\
-		CONT;			\
-	ALU64_##OPCODE##_K:		\
-		DST = DST OP IMM;		\
-		CONT;			\
-	ALU_##OPCODE##_K:		\
-		DST = (u32) DST OP (u32) IMM;	\
-		CONT;
-
-	ALU(ADD,  +)
-	ALU(SUB,  -)
-	ALU(AND,  &)
-	ALU(OR,   |)
-	ALU(LSH, <<)
-	ALU(RSH, >>)
-	ALU(XOR,  ^)
-	ALU(MUL,  *)
-#undef ALU
-	ALU_NEG:
-		DST = (u32) -DST;
-		CONT;
-	ALU64_NEG:
-		DST = -DST;
-		CONT;
-	ALU_MOV_X:
-		DST = (u32) SRC;
-		CONT;
-	ALU_MOV_K:
-		DST = (u32) IMM;
-		CONT;
-	ALU64_MOV_X:
-		DST = SRC;
-		CONT;
-	ALU64_MOV_K:
-		DST = IMM;
-		CONT;
-	LD_IMM_DW:
-		DST = (u64) (u32) insn[0].imm | ((u64) (u32) insn[1].imm) << 32;
-		insn++;
-		CONT;
-	ALU_ARSH_X:
-		DST = (u64) (u32) (((s32) DST) >> SRC);
-		CONT;
-	ALU_ARSH_K:
-		DST = (u64) (u32) (((s32) DST) >> IMM);
-		CONT;
-	ALU64_ARSH_X:
-		(*(s64 *) &DST) >>= SRC;
-		CONT;
-	ALU64_ARSH_K:
-		(*(s64 *) &DST) >>= IMM;
-		CONT;
-	ALU64_MOD_X:
-		div64_u64_rem(DST, SRC, &AX);
-		DST = AX;
-		CONT;
-	ALU_MOD_X:
-		AX = (u32) DST;
-		DST = do_div(AX, (u32) SRC);
-		CONT;
-	ALU64_MOD_K:
-		div64_u64_rem(DST, IMM, &AX);
-		DST = AX;
-		CONT;
-	ALU_MOD_K:
-		AX = (u32) DST;
-		DST = do_div(AX, (u32) IMM);
-		CONT;
-	ALU64_DIV_X:
-		DST = div64_u64(DST, SRC);
-		CONT;
-	ALU_DIV_X:
-		AX = (u32) DST;
-		do_div(AX, (u32) SRC);
-		DST = (u32) AX;
-		CONT;
-	ALU64_DIV_K:
-		DST = div64_u64(DST, IMM);
-		CONT;
-	ALU_DIV_K:
-		AX = (u32) DST;
-		do_div(AX, (u32) IMM);
-		DST = (u32) AX;
-		CONT;
-	ALU_END_TO_BE:
-		switch (IMM) {
-		case 16:
-			DST = (__force u16) cpu_to_be16(DST);
-			break;
-		case 32:
-			DST = (__force u32) cpu_to_be32(DST);
-			break;
-		case 64:
-			DST = (__force u64) cpu_to_be64(DST);
-			break;
-		}
-		CONT;
-	ALU_END_TO_LE:
-		switch (IMM) {
-		case 16:
-			DST = (__force u16) cpu_to_le16(DST);
-			break;
-		case 32:
-			DST = (__force u32) cpu_to_le32(DST);
-			break;
-		case 64:
-			DST = (__force u64) cpu_to_le64(DST);
-			break;
-		}
-		CONT;
-
-	/* CALL */
-	JMP_CALL:
-		/* Function call scratches BPF_R1-BPF_R5 registers,
-		 * preserves BPF_R6-BPF_R9, and stores return value
-		 * into BPF_R0.
-		 */
-		BPF_R0 = (__bpf_call_base + insn->imm)(BPF_R1, BPF_R2, BPF_R3,
-						       BPF_R4, BPF_R5);
-		CONT;
-
-	JMP_CALL_ARGS:
-		BPF_R0 = (__bpf_call_base_args + insn->imm)(BPF_R1, BPF_R2,
-							    BPF_R3, BPF_R4,
-							    BPF_R5,
-							    insn + insn->off + 1);
-		CONT;
-
-	JMP_TAIL_CALL: {
-		struct bpf_map *map = (struct bpf_map *) (unsigned long) BPF_R2;
-		struct bpf_array *array = container_of(map, struct bpf_array, map);
-		struct bpf_prog *prog;
-		u32 index = BPF_R3;
-
-		if (unlikely(index >= array->map.max_entries))
-			goto out;
-		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
-			goto out;
-
-		tail_call_cnt++;
-
-		prog = READ_ONCE(array->ptrs[index]);
-		if (!prog)
-			goto out;
-
-		/* ARG1 at this point is guaranteed to point to CTX from
-		 * the verifier side due to the fact that the tail call is
-		 * handled like a helper, that is, bpf_tail_call_proto,
-		 * where arg1_type is ARG_PTR_TO_CTX.
-		 */
-		insn = prog->insnsi;
-		goto select_insn;
-out:
-		CONT;
-	}
-	JMP_JA:
-		insn += insn->off;
-		CONT;
-	JMP_EXIT:
-		return BPF_R0;
-	/* JMP */
-#define COND_JMP(SIGN, OPCODE, CMP_OP)				\
-	JMP_##OPCODE##_X:					\
-		if ((SIGN##64) DST CMP_OP (SIGN##64) SRC) {	\
-			insn += insn->off;			\
-			CONT_JMP;				\
-		}						\
-		CONT;						\
-	JMP32_##OPCODE##_X:					\
-		if ((SIGN##32) DST CMP_OP (SIGN##32) SRC) {	\
-			insn += insn->off;			\
-			CONT_JMP;				\
-		}						\
-		CONT;						\
-	JMP_##OPCODE##_K:					\
-		if ((SIGN##64) DST CMP_OP (SIGN##64) IMM) {	\
-			insn += insn->off;			\
-			CONT_JMP;				\
-		}						\
-		CONT;						\
-	JMP32_##OPCODE##_K:					\
-		if ((SIGN##32) DST CMP_OP (SIGN##32) IMM) {	\
-			insn += insn->off;			\
-			CONT_JMP;				\
-		}						\
-		CONT;
-	COND_JMP(u, JEQ, ==)
-	COND_JMP(u, JNE, !=)
-	COND_JMP(u, JGT, >)
-	COND_JMP(u, JLT, <)
-	COND_JMP(u, JGE, >=)
-	COND_JMP(u, JLE, <=)
-	COND_JMP(u, JSET, &)
-	COND_JMP(s, JSGT, >)
-	COND_JMP(s, JSLT, <)
-	COND_JMP(s, JSGE, >=)
-	COND_JMP(s, JSLE, <=)
-#undef COND_JMP
-	/* STX and ST and LDX*/
-#define LDST(SIZEOP, SIZE)						\
-	STX_MEM_##SIZEOP:						\
-		*(SIZE *)(unsigned long) (DST + insn->off) = SRC;	\
-		CONT;							\
-	ST_MEM_##SIZEOP:						\
-		*(SIZE *)(unsigned long) (DST + insn->off) = IMM;	\
-		CONT;							\
-	LDX_MEM_##SIZEOP:						\
-		DST = *(SIZE *)(unsigned long) (SRC + insn->off);	\
-		CONT;
-
-	LDST(B,   u8)
-	LDST(H,  u16)
-	LDST(W,  u32)
-	LDST(DW, u64)
-#undef LDST
-#define LDX_PROBE(SIZEOP, SIZE)							\
-	LDX_PROBE_MEM_##SIZEOP:							\
-		bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->off));	\
-		CONT;
-	LDX_PROBE(B,  1)
-	LDX_PROBE(H,  2)
-	LDX_PROBE(W,  4)
-	LDX_PROBE(DW, 8)
-#undef LDX_PROBE
-
-	STX_XADD_W: /* lock xadd *(u32 *)(dst_reg + off16) += src_reg */
-		atomic_add((u32) SRC, (atomic_t *)(unsigned long)
-			   (DST + insn->off));
-		CONT;
-	STX_XADD_DW: /* lock xadd *(u64 *)(dst_reg + off16) += src_reg */
-		atomic64_add((u64) SRC, (atomic64_t *)(unsigned long)
-			     (DST + insn->off));
-		CONT;
-
-	default_label:
-		/* If we ever reach this, we have a bug somewhere. Die hard here
-		 * instead of just returning 0; we could be somewhere in a subprog,
-		 * so execution could continue otherwise which we do /not/ want.
-		 *
-		 * Note, verifier whitelists all opcodes in bpf_opcode_in_insntable().
-		 */
-		pr_warn("BPF interpreter: unknown opcode %02x\n", insn->code);
-		BUG_ON(1);
-		return 0;
-}
-
-#define PROG_NAME(stack_size) __bpf_prog_run##stack_size
-#define DEFINE_BPF_PROG_RUN(stack_size) \
-static unsigned int PROG_NAME(stack_size)(const void *ctx, const struct bpf_insn *insn) \
-{ \
-	u64 stack[stack_size / sizeof(u64)]; \
-	u64 regs[MAX_BPF_EXT_REG]; \
-\
-	FP = (u64) (unsigned long) &stack[ARRAY_SIZE(stack)]; \
-	ARG1 = (u64) (unsigned long) ctx; \
-	return ___bpf_prog_run(regs, insn, stack); \
-}
-
-#define PROG_NAME_ARGS(stack_size) __bpf_prog_run_args##stack_size
-#define DEFINE_BPF_PROG_RUN_ARGS(stack_size) \
-static u64 PROG_NAME_ARGS(stack_size)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5, \
-				      const struct bpf_insn *insn) \
-{ \
-	u64 stack[stack_size / sizeof(u64)]; \
-	u64 regs[MAX_BPF_EXT_REG]; \
-\
-	FP = (u64) (unsigned long) &stack[ARRAY_SIZE(stack)]; \
-	BPF_R1 = r1; \
-	BPF_R2 = r2; \
-	BPF_R3 = r3; \
-	BPF_R4 = r4; \
-	BPF_R5 = r5; \
-	return ___bpf_prog_run(regs, insn, stack); \
-}
-
-#define EVAL1(FN, X) FN(X)
-#define EVAL2(FN, X, Y...) FN(X) EVAL1(FN, Y)
-#define EVAL3(FN, X, Y...) FN(X) EVAL2(FN, Y)
-#define EVAL4(FN, X, Y...) FN(X) EVAL3(FN, Y)
-#define EVAL5(FN, X, Y...) FN(X) EVAL4(FN, Y)
-#define EVAL6(FN, X, Y...) FN(X) EVAL5(FN, Y)
-
-EVAL6(DEFINE_BPF_PROG_RUN, 32, 64, 96, 128, 160, 192);
-EVAL6(DEFINE_BPF_PROG_RUN, 224, 256, 288, 320, 352, 384);
-EVAL4(DEFINE_BPF_PROG_RUN, 416, 448, 480, 512);
-
-EVAL6(DEFINE_BPF_PROG_RUN_ARGS, 32, 64, 96, 128, 160, 192);
-EVAL6(DEFINE_BPF_PROG_RUN_ARGS, 224, 256, 288, 320, 352, 384);
-EVAL4(DEFINE_BPF_PROG_RUN_ARGS, 416, 448, 480, 512);
-
-#define PROG_NAME_LIST(stack_size) PROG_NAME(stack_size),
-
-static unsigned int (*interpreters[])(const void *ctx,
-				      const struct bpf_insn *insn) = {
-EVAL6(PROG_NAME_LIST, 32, 64, 96, 128, 160, 192)
-EVAL6(PROG_NAME_LIST, 224, 256, 288, 320, 352, 384)
-EVAL4(PROG_NAME_LIST, 416, 448, 480, 512)
-};
-#undef PROG_NAME_LIST
-#define PROG_NAME_LIST(stack_size) PROG_NAME_ARGS(stack_size),
-static u64 (*interpreters_args[])(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5,
-				  const struct bpf_insn *insn) = {
-EVAL6(PROG_NAME_LIST, 32, 64, 96, 128, 160, 192)
-EVAL6(PROG_NAME_LIST, 224, 256, 288, 320, 352, 384)
-EVAL4(PROG_NAME_LIST, 416, 448, 480, 512)
-};
-#undef PROG_NAME_LIST
-
-void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth)
-{
-	stack_depth = max_t(u32, stack_depth, 1);
-	insn->off = (s16) insn->imm;
-	insn->imm = interpreters_args[(round_up(stack_depth, 32) / 32) - 1] -
-		__bpf_call_base_args;
-	insn->code = BPF_JMP | BPF_CALL_ARGS;
-}
-
-#else
-static unsigned int __bpf_prog_ret0_warn(const void *ctx,
-					 const struct bpf_insn *insn)
-{
-	/* If this handler ever gets executed, then BPF_JIT_ALWAYS_ON
-	 * is not working properly, so warn about it!
-	 */
-	WARN_ON_ONCE(1);
-	return 0;
-}
-#endif
-
 bool bpf_prog_array_compatible(struct bpf_array *array,
 			       const struct bpf_prog *fp)
 {
@@ -1774,17 +1218,6 @@ static int bpf_check_tail_call(const struct bpf_prog *fp)
 	return ret;
 }
 
-static void bpf_prog_select_func(struct bpf_prog *fp)
-{
-#ifndef CONFIG_BPF_JIT_ALWAYS_ON
-	u32 stack_depth = max_t(u32, fp->aux->stack_depth, 1);
-
-	fp->bpf_func = interpreters[(round_up(stack_depth, 32) / 32) - 1];
-#else
-	fp->bpf_func = __bpf_prog_ret0_warn;
-#endif
-}
-
 /**
  *	bpf_prog_select_runtime - select exec runtime for BPF program
  *	@fp: bpf_prog populated with internal BPF program
diff --git a/kernel/bpf/interp.c b/kernel/bpf/interp.c
new file mode 100644
index 000000000000..793ab5b2d62b
--- /dev/null
+++ b/kernel/bpf/interp.c
@@ -0,0 +1,601 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Linux Socket Filter - Kernel level socket filtering
+ *
+ * Based on the design of the Berkeley Packet Filter. The new
+ * internal format has been designed by PLUMgrid:
+ *
+ *	Copyright (c) 2011 - 2014 PLUMgrid, http://plumgrid.com
+ *
+ * Authors:
+ *
+ *	Jay Schulist <jschlst@samba.org>
+ *	Alexei Starovoitov <ast@plumgrid.com>
+ *	Daniel Borkmann <dborkman@redhat.com>
+ *
+ * Andi Kleen - Fix a few bad bugs and races.
+ * Kris Katterjohn - Added many additional checks in bpf_check_classic()
+ */
+
+#include <uapi/linux/btf.h>
+#include <linux/filter.h>
+#include <linux/skbuff.h>
+#include <linux/vmalloc.h>
+#include <linux/random.h>
+#include <linux/moduleloader.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/objtool.h>
+#include <linux/rbtree_latch.h>
+#include <linux/kallsyms.h>
+#include <linux/rcupdate.h>
+#include <linux/perf_event.h>
+#include <linux/extable.h>
+#include <linux/log2.h>
+#include <asm/unaligned.h>
+
+/* Registers */
+#define BPF_R0	regs[BPF_REG_0]
+#define BPF_R1	regs[BPF_REG_1]
+#define BPF_R2	regs[BPF_REG_2]
+#define BPF_R3	regs[BPF_REG_3]
+#define BPF_R4	regs[BPF_REG_4]
+#define BPF_R5	regs[BPF_REG_5]
+#define BPF_R6	regs[BPF_REG_6]
+#define BPF_R7	regs[BPF_REG_7]
+#define BPF_R8	regs[BPF_REG_8]
+#define BPF_R9	regs[BPF_REG_9]
+#define BPF_R10	regs[BPF_REG_10]
+
+/* Named registers */
+#define DST	regs[insn->dst_reg]
+#define SRC	regs[insn->src_reg]
+#define FP	regs[BPF_REG_FP]
+#define AX	regs[BPF_REG_AX]
+#define ARG1	regs[BPF_REG_ARG1]
+#define CTX	regs[BPF_REG_CTX]
+#define IMM	insn->imm
+
+/* All UAPI available opcodes. */
+#define BPF_INSN_MAP(INSN_2, INSN_3)		\
+	/* 32 bit ALU operations. */		\
+	/*   Register based. */			\
+	INSN_3(ALU, ADD,  X),			\
+	INSN_3(ALU, SUB,  X),			\
+	INSN_3(ALU, AND,  X),			\
+	INSN_3(ALU, OR,   X),			\
+	INSN_3(ALU, LSH,  X),			\
+	INSN_3(ALU, RSH,  X),			\
+	INSN_3(ALU, XOR,  X),			\
+	INSN_3(ALU, MUL,  X),			\
+	INSN_3(ALU, MOV,  X),			\
+	INSN_3(ALU, ARSH, X),			\
+	INSN_3(ALU, DIV,  X),			\
+	INSN_3(ALU, MOD,  X),			\
+	INSN_2(ALU, NEG),			\
+	INSN_3(ALU, END, TO_BE),		\
+	INSN_3(ALU, END, TO_LE),		\
+	/*   Immediate based. */		\
+	INSN_3(ALU, ADD,  K),			\
+	INSN_3(ALU, SUB,  K),			\
+	INSN_3(ALU, AND,  K),			\
+	INSN_3(ALU, OR,   K),			\
+	INSN_3(ALU, LSH,  K),			\
+	INSN_3(ALU, RSH,  K),			\
+	INSN_3(ALU, XOR,  K),			\
+	INSN_3(ALU, MUL,  K),			\
+	INSN_3(ALU, MOV,  K),			\
+	INSN_3(ALU, ARSH, K),			\
+	INSN_3(ALU, DIV,  K),			\
+	INSN_3(ALU, MOD,  K),			\
+	/* 64 bit ALU operations. */		\
+	/*   Register based. */			\
+	INSN_3(ALU64, ADD,  X),			\
+	INSN_3(ALU64, SUB,  X),			\
+	INSN_3(ALU64, AND,  X),			\
+	INSN_3(ALU64, OR,   X),			\
+	INSN_3(ALU64, LSH,  X),			\
+	INSN_3(ALU64, RSH,  X),			\
+	INSN_3(ALU64, XOR,  X),			\
+	INSN_3(ALU64, MUL,  X),			\
+	INSN_3(ALU64, MOV,  X),			\
+	INSN_3(ALU64, ARSH, X),			\
+	INSN_3(ALU64, DIV,  X),			\
+	INSN_3(ALU64, MOD,  X),			\
+	INSN_2(ALU64, NEG),			\
+	/*   Immediate based. */		\
+	INSN_3(ALU64, ADD,  K),			\
+	INSN_3(ALU64, SUB,  K),			\
+	INSN_3(ALU64, AND,  K),			\
+	INSN_3(ALU64, OR,   K),			\
+	INSN_3(ALU64, LSH,  K),			\
+	INSN_3(ALU64, RSH,  K),			\
+	INSN_3(ALU64, XOR,  K),			\
+	INSN_3(ALU64, MUL,  K),			\
+	INSN_3(ALU64, MOV,  K),			\
+	INSN_3(ALU64, ARSH, K),			\
+	INSN_3(ALU64, DIV,  K),			\
+	INSN_3(ALU64, MOD,  K),			\
+	/* Call instruction. */			\
+	INSN_2(JMP, CALL),			\
+	/* Exit instruction. */			\
+	INSN_2(JMP, EXIT),			\
+	/* 32-bit Jump instructions. */		\
+	/*   Register based. */			\
+	INSN_3(JMP32, JEQ,  X),			\
+	INSN_3(JMP32, JNE,  X),			\
+	INSN_3(JMP32, JGT,  X),			\
+	INSN_3(JMP32, JLT,  X),			\
+	INSN_3(JMP32, JGE,  X),			\
+	INSN_3(JMP32, JLE,  X),			\
+	INSN_3(JMP32, JSGT, X),			\
+	INSN_3(JMP32, JSLT, X),			\
+	INSN_3(JMP32, JSGE, X),			\
+	INSN_3(JMP32, JSLE, X),			\
+	INSN_3(JMP32, JSET, X),			\
+	/*   Immediate based. */		\
+	INSN_3(JMP32, JEQ,  K),			\
+	INSN_3(JMP32, JNE,  K),			\
+	INSN_3(JMP32, JGT,  K),			\
+	INSN_3(JMP32, JLT,  K),			\
+	INSN_3(JMP32, JGE,  K),			\
+	INSN_3(JMP32, JLE,  K),			\
+	INSN_3(JMP32, JSGT, K),			\
+	INSN_3(JMP32, JSLT, K),			\
+	INSN_3(JMP32, JSGE, K),			\
+	INSN_3(JMP32, JSLE, K),			\
+	INSN_3(JMP32, JSET, K),			\
+	/* Jump instructions. */		\
+	/*   Register based. */			\
+	INSN_3(JMP, JEQ,  X),			\
+	INSN_3(JMP, JNE,  X),			\
+	INSN_3(JMP, JGT,  X),			\
+	INSN_3(JMP, JLT,  X),			\
+	INSN_3(JMP, JGE,  X),			\
+	INSN_3(JMP, JLE,  X),			\
+	INSN_3(JMP, JSGT, X),			\
+	INSN_3(JMP, JSLT, X),			\
+	INSN_3(JMP, JSGE, X),			\
+	INSN_3(JMP, JSLE, X),			\
+	INSN_3(JMP, JSET, X),			\
+	/*   Immediate based. */		\
+	INSN_3(JMP, JEQ,  K),			\
+	INSN_3(JMP, JNE,  K),			\
+	INSN_3(JMP, JGT,  K),			\
+	INSN_3(JMP, JLT,  K),			\
+	INSN_3(JMP, JGE,  K),			\
+	INSN_3(JMP, JLE,  K),			\
+	INSN_3(JMP, JSGT, K),			\
+	INSN_3(JMP, JSLT, K),			\
+	INSN_3(JMP, JSGE, K),			\
+	INSN_3(JMP, JSLE, K),			\
+	INSN_3(JMP, JSET, K),			\
+	INSN_2(JMP, JA),			\
+	/* Store instructions. */		\
+	/*   Register based. */			\
+	INSN_3(STX, MEM,  B),			\
+	INSN_3(STX, MEM,  H),			\
+	INSN_3(STX, MEM,  W),			\
+	INSN_3(STX, MEM,  DW),			\
+	INSN_3(STX, XADD, W),			\
+	INSN_3(STX, XADD, DW),			\
+	/*   Immediate based. */		\
+	INSN_3(ST, MEM, B),			\
+	INSN_3(ST, MEM, H),			\
+	INSN_3(ST, MEM, W),			\
+	INSN_3(ST, MEM, DW),			\
+	/* Load instructions. */		\
+	/*   Register based. */			\
+	INSN_3(LDX, MEM, B),			\
+	INSN_3(LDX, MEM, H),			\
+	INSN_3(LDX, MEM, W),			\
+	INSN_3(LDX, MEM, DW),			\
+	/*   Immediate based. */		\
+	INSN_3(LD, IMM, DW)
+
+bool bpf_opcode_in_insntable(u8 code)
+{
+#define BPF_INSN_2_TBL(x, y)    [BPF_##x | BPF_##y] = true
+#define BPF_INSN_3_TBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = true
+	static const bool public_insntable[256] = {
+		[0 ... 255] = false,
+		/* Now overwrite non-defaults ... */
+		BPF_INSN_MAP(BPF_INSN_2_TBL, BPF_INSN_3_TBL),
+		/* UAPI exposed, but rewritten opcodes. cBPF carry-over. */
+		[BPF_LD | BPF_ABS | BPF_B] = true,
+		[BPF_LD | BPF_ABS | BPF_H] = true,
+		[BPF_LD | BPF_ABS | BPF_W] = true,
+		[BPF_LD | BPF_IND | BPF_B] = true,
+		[BPF_LD | BPF_IND | BPF_H] = true,
+		[BPF_LD | BPF_IND | BPF_W] = true,
+	};
+#undef BPF_INSN_3_TBL
+#undef BPF_INSN_2_TBL
+	return public_insntable[code];
+}
+
+#ifndef CONFIG_BPF_JIT_ALWAYS_ON
+u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
+{
+	memset(dst, 0, size);
+	return -EFAULT;
+}
+
+/**
+ *	__bpf_prog_run - run eBPF program on a given context
+ *	@regs: is the array of MAX_BPF_EXT_REG eBPF pseudo-registers
+ *	@insn: is the array of eBPF instructions
+ *	@stack: is the eBPF storage stack
+ *
+ * Decode and execute eBPF instructions.
+ */
+static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
+{
+#define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
+#define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
+	static const void * const jumptable[256] __annotate_jump_table = {
+		[0 ... 255] = &&default_label,
+		/* Now overwrite non-defaults ... */
+		BPF_INSN_MAP(BPF_INSN_2_LBL, BPF_INSN_3_LBL),
+		/* Non-UAPI available opcodes. */
+		[BPF_JMP | BPF_CALL_ARGS] = &&JMP_CALL_ARGS,
+		[BPF_JMP | BPF_TAIL_CALL] = &&JMP_TAIL_CALL,
+		[BPF_LDX | BPF_PROBE_MEM | BPF_B] = &&LDX_PROBE_MEM_B,
+		[BPF_LDX | BPF_PROBE_MEM | BPF_H] = &&LDX_PROBE_MEM_H,
+		[BPF_LDX | BPF_PROBE_MEM | BPF_W] = &&LDX_PROBE_MEM_W,
+		[BPF_LDX | BPF_PROBE_MEM | BPF_DW] = &&LDX_PROBE_MEM_DW,
+	};
+#undef BPF_INSN_3_LBL
+#undef BPF_INSN_2_LBL
+	u32 tail_call_cnt = 0;
+
+#define CONT	 ({ insn++; goto select_insn; })
+#define CONT_JMP ({ insn++; goto select_insn; })
+
+select_insn:
+	goto *jumptable[insn->code];
+
+	/* ALU */
+#define ALU(OPCODE, OP)			\
+	ALU64_##OPCODE##_X:		\
+		DST = DST OP SRC;	\
+		CONT;			\
+	ALU_##OPCODE##_X:		\
+		DST = (u32) DST OP (u32) SRC;	\
+		CONT;			\
+	ALU64_##OPCODE##_K:		\
+		DST = DST OP IMM;		\
+		CONT;			\
+	ALU_##OPCODE##_K:		\
+		DST = (u32) DST OP (u32) IMM;	\
+		CONT;
+
+	ALU(ADD,  +)
+	ALU(SUB,  -)
+	ALU(AND,  &)
+	ALU(OR,   |)
+	ALU(LSH, <<)
+	ALU(RSH, >>)
+	ALU(XOR,  ^)
+	ALU(MUL,  *)
+#undef ALU
+	ALU_NEG:
+		DST = (u32) -DST;
+		CONT;
+	ALU64_NEG:
+		DST = -DST;
+		CONT;
+	ALU_MOV_X:
+		DST = (u32) SRC;
+		CONT;
+	ALU_MOV_K:
+		DST = (u32) IMM;
+		CONT;
+	ALU64_MOV_X:
+		DST = SRC;
+		CONT;
+	ALU64_MOV_K:
+		DST = IMM;
+		CONT;
+	LD_IMM_DW:
+		DST = (u64) (u32) insn[0].imm | ((u64) (u32) insn[1].imm) << 32;
+		insn++;
+		CONT;
+	ALU_ARSH_X:
+		DST = (u64) (u32) (((s32) DST) >> SRC);
+		CONT;
+	ALU_ARSH_K:
+		DST = (u64) (u32) (((s32) DST) >> IMM);
+		CONT;
+	ALU64_ARSH_X:
+		(*(s64 *) &DST) >>= SRC;
+		CONT;
+	ALU64_ARSH_K:
+		(*(s64 *) &DST) >>= IMM;
+		CONT;
+	ALU64_MOD_X:
+		div64_u64_rem(DST, SRC, &AX);
+		DST = AX;
+		CONT;
+	ALU_MOD_X:
+		AX = (u32) DST;
+		DST = do_div(AX, (u32) SRC);
+		CONT;
+	ALU64_MOD_K:
+		div64_u64_rem(DST, IMM, &AX);
+		DST = AX;
+		CONT;
+	ALU_MOD_K:
+		AX = (u32) DST;
+		DST = do_div(AX, (u32) IMM);
+		CONT;
+	ALU64_DIV_X:
+		DST = div64_u64(DST, SRC);
+		CONT;
+	ALU_DIV_X:
+		AX = (u32) DST;
+		do_div(AX, (u32) SRC);
+		DST = (u32) AX;
+		CONT;
+	ALU64_DIV_K:
+		DST = div64_u64(DST, IMM);
+		CONT;
+	ALU_DIV_K:
+		AX = (u32) DST;
+		do_div(AX, (u32) IMM);
+		DST = (u32) AX;
+		CONT;
+	ALU_END_TO_BE:
+		switch (IMM) {
+		case 16:
+			DST = (__force u16) cpu_to_be16(DST);
+			break;
+		case 32:
+			DST = (__force u32) cpu_to_be32(DST);
+			break;
+		case 64:
+			DST = (__force u64) cpu_to_be64(DST);
+			break;
+		}
+		CONT;
+	ALU_END_TO_LE:
+		switch (IMM) {
+		case 16:
+			DST = (__force u16) cpu_to_le16(DST);
+			break;
+		case 32:
+			DST = (__force u32) cpu_to_le32(DST);
+			break;
+		case 64:
+			DST = (__force u64) cpu_to_le64(DST);
+			break;
+		}
+		CONT;
+
+	/* CALL */
+	JMP_CALL:
+		/* Function call scratches BPF_R1-BPF_R5 registers,
+		 * preserves BPF_R6-BPF_R9, and stores return value
+		 * into BPF_R0.
+		 */
+		BPF_R0 = (__bpf_call_base + insn->imm)(BPF_R1, BPF_R2, BPF_R3,
+						       BPF_R4, BPF_R5);
+		CONT;
+
+	JMP_CALL_ARGS:
+		BPF_R0 = (__bpf_call_base_args + insn->imm)(BPF_R1, BPF_R2,
+							    BPF_R3, BPF_R4,
+							    BPF_R5,
+							    insn + insn->off + 1);
+		CONT;
+
+	JMP_TAIL_CALL: {
+		struct bpf_map *map = (struct bpf_map *) (unsigned long) BPF_R2;
+		struct bpf_array *array = container_of(map, struct bpf_array, map);
+		struct bpf_prog *prog;
+		u32 index = BPF_R3;
+
+		if (unlikely(index >= array->map.max_entries))
+			goto out;
+		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
+			goto out;
+
+		tail_call_cnt++;
+
+		prog = READ_ONCE(array->ptrs[index]);
+		if (!prog)
+			goto out;
+
+		/* ARG1 at this point is guaranteed to point to CTX from
+		 * the verifier side due to the fact that the tail call is
+		 * handled like a helper, that is, bpf_tail_call_proto,
+		 * where arg1_type is ARG_PTR_TO_CTX.
+		 */
+		insn = prog->insnsi;
+		goto select_insn;
+out:
+		CONT;
+	}
+	JMP_JA:
+		insn += insn->off;
+		CONT;
+	JMP_EXIT:
+		return BPF_R0;
+	/* JMP */
+#define COND_JMP(SIGN, OPCODE, CMP_OP)				\
+	JMP_##OPCODE##_X:					\
+		if ((SIGN##64) DST CMP_OP (SIGN##64) SRC) {	\
+			insn += insn->off;			\
+			CONT_JMP;				\
+		}						\
+		CONT;						\
+	JMP32_##OPCODE##_X:					\
+		if ((SIGN##32) DST CMP_OP (SIGN##32) SRC) {	\
+			insn += insn->off;			\
+			CONT_JMP;				\
+		}						\
+		CONT;						\
+	JMP_##OPCODE##_K:					\
+		if ((SIGN##64) DST CMP_OP (SIGN##64) IMM) {	\
+			insn += insn->off;			\
+			CONT_JMP;				\
+		}						\
+		CONT;						\
+	JMP32_##OPCODE##_K:					\
+		if ((SIGN##32) DST CMP_OP (SIGN##32) IMM) {	\
+			insn += insn->off;			\
+			CONT_JMP;				\
+		}						\
+		CONT;
+	COND_JMP(u, JEQ, ==)
+	COND_JMP(u, JNE, !=)
+	COND_JMP(u, JGT, >)
+	COND_JMP(u, JLT, <)
+	COND_JMP(u, JGE, >=)
+	COND_JMP(u, JLE, <=)
+	COND_JMP(u, JSET, &)
+	COND_JMP(s, JSGT, >)
+	COND_JMP(s, JSLT, <)
+	COND_JMP(s, JSGE, >=)
+	COND_JMP(s, JSLE, <=)
+#undef COND_JMP
+	/* STX and ST and LDX*/
+#define LDST(SIZEOP, SIZE)						\
+	STX_MEM_##SIZEOP:						\
+		*(SIZE *)(unsigned long) (DST + insn->off) = SRC;	\
+		CONT;							\
+	ST_MEM_##SIZEOP:						\
+		*(SIZE *)(unsigned long) (DST + insn->off) = IMM;	\
+		CONT;							\
+	LDX_MEM_##SIZEOP:						\
+		DST = *(SIZE *)(unsigned long) (SRC + insn->off);	\
+		CONT;
+
+	LDST(B,   u8)
+	LDST(H,  u16)
+	LDST(W,  u32)
+	LDST(DW, u64)
+#undef LDST
+#define LDX_PROBE(SIZEOP, SIZE)							\
+	LDX_PROBE_MEM_##SIZEOP:							\
+		bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->off));	\
+		CONT;
+	LDX_PROBE(B,  1)
+	LDX_PROBE(H,  2)
+	LDX_PROBE(W,  4)
+	LDX_PROBE(DW, 8)
+#undef LDX_PROBE
+
+	STX_XADD_W: /* lock xadd *(u32 *)(dst_reg + off16) += src_reg */
+		atomic_add((u32) SRC, (atomic_t *)(unsigned long)
+			   (DST + insn->off));
+		CONT;
+	STX_XADD_DW: /* lock xadd *(u64 *)(dst_reg + off16) += src_reg */
+		atomic64_add((u64) SRC, (atomic64_t *)(unsigned long)
+			     (DST + insn->off));
+		CONT;
+
+	default_label:
+		/* If we ever reach this, we have a bug somewhere. Die hard here
+		 * instead of just returning 0; we could be somewhere in a subprog,
+		 * so execution could continue otherwise which we do /not/ want.
+		 *
+		 * Note, verifier whitelists all opcodes in bpf_opcode_in_insntable().
+		 */
+		pr_warn("BPF interpreter: unknown opcode %02x\n", insn->code);
+		BUG_ON(1);
+		return 0;
+}
+
+#define PROG_NAME(stack_size) __bpf_prog_run##stack_size
+#define DEFINE_BPF_PROG_RUN(stack_size) \
+static unsigned int PROG_NAME(stack_size)(const void *ctx, const struct bpf_insn *insn) \
+{ \
+	u64 stack[stack_size / sizeof(u64)]; \
+	u64 regs[MAX_BPF_EXT_REG]; \
+\
+	FP = (u64) (unsigned long) &stack[ARRAY_SIZE(stack)]; \
+	ARG1 = (u64) (unsigned long) ctx; \
+	return ___bpf_prog_run(regs, insn, stack); \
+}
+
+#define PROG_NAME_ARGS(stack_size) __bpf_prog_run_args##stack_size
+#define DEFINE_BPF_PROG_RUN_ARGS(stack_size) \
+static u64 PROG_NAME_ARGS(stack_size)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5, \
+				      const struct bpf_insn *insn) \
+{ \
+	u64 stack[stack_size / sizeof(u64)]; \
+	u64 regs[MAX_BPF_EXT_REG]; \
+\
+	FP = (u64) (unsigned long) &stack[ARRAY_SIZE(stack)]; \
+	BPF_R1 = r1; \
+	BPF_R2 = r2; \
+	BPF_R3 = r3; \
+	BPF_R4 = r4; \
+	BPF_R5 = r5; \
+	return ___bpf_prog_run(regs, insn, stack); \
+}
+
+#define EVAL1(FN, X) FN(X)
+#define EVAL2(FN, X, Y...) FN(X) EVAL1(FN, Y)
+#define EVAL3(FN, X, Y...) FN(X) EVAL2(FN, Y)
+#define EVAL4(FN, X, Y...) FN(X) EVAL3(FN, Y)
+#define EVAL5(FN, X, Y...) FN(X) EVAL4(FN, Y)
+#define EVAL6(FN, X, Y...) FN(X) EVAL5(FN, Y)
+
+EVAL6(DEFINE_BPF_PROG_RUN, 32, 64, 96, 128, 160, 192);
+EVAL6(DEFINE_BPF_PROG_RUN, 224, 256, 288, 320, 352, 384);
+EVAL4(DEFINE_BPF_PROG_RUN, 416, 448, 480, 512);
+
+EVAL6(DEFINE_BPF_PROG_RUN_ARGS, 32, 64, 96, 128, 160, 192);
+EVAL6(DEFINE_BPF_PROG_RUN_ARGS, 224, 256, 288, 320, 352, 384);
+EVAL4(DEFINE_BPF_PROG_RUN_ARGS, 416, 448, 480, 512);
+
+#define PROG_NAME_LIST(stack_size) PROG_NAME(stack_size),
+
+static unsigned int (*interpreters[])(const void *ctx,
+				      const struct bpf_insn *insn) = {
+EVAL6(PROG_NAME_LIST, 32, 64, 96, 128, 160, 192)
+EVAL6(PROG_NAME_LIST, 224, 256, 288, 320, 352, 384)
+EVAL4(PROG_NAME_LIST, 416, 448, 480, 512)
+};
+#undef PROG_NAME_LIST
+#define PROG_NAME_LIST(stack_size) PROG_NAME_ARGS(stack_size),
+static u64 (*interpreters_args[])(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5,
+				  const struct bpf_insn *insn) = {
+EVAL6(PROG_NAME_LIST, 32, 64, 96, 128, 160, 192)
+EVAL6(PROG_NAME_LIST, 224, 256, 288, 320, 352, 384)
+EVAL4(PROG_NAME_LIST, 416, 448, 480, 512)
+};
+#undef PROG_NAME_LIST
+
+void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth)
+{
+	stack_depth = max_t(u32, stack_depth, 1);
+	insn->off = (s16) insn->imm;
+	insn->imm = interpreters_args[(round_up(stack_depth, 32) / 32) - 1] -
+		__bpf_call_base_args;
+	insn->code = BPF_JMP | BPF_CALL_ARGS;
+}
+#else
+static unsigned int __bpf_prog_ret0_warn(const void *ctx,
+					 const struct bpf_insn *insn)
+{
+	/* If this handler ever gets executed, then BPF_JIT_ALWAYS_ON
+	 * is not working properly, so warn about it!
+	 */
+	WARN_ON_ONCE(1);
+	return 0;
+}
+#endif
+
+void bpf_prog_select_func(struct bpf_prog *fp)
+{
+#ifndef CONFIG_BPF_JIT_ALWAYS_ON
+	u32 stack_depth = max_t(u32, fp->aux->stack_depth, 1);
+
+	fp->bpf_func = interpreters[(round_up(stack_depth, 32) / 32) - 1];
+#else
+	fp->bpf_func = __bpf_prog_ret0_warn;
+#endif
+}
-- 
2.17.1

