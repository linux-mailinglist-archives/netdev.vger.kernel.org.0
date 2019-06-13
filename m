Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E53439BB
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388204AbfFMPPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:15:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732209AbfFMNXx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:23:53 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95D7D80471;
        Thu, 13 Jun 2019 13:23:52 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E5FC51C66;
        Thu, 13 Jun 2019 13:23:51 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: [PATCH 8/9] x86/bpf: Convert asm comments to AT&T syntax
Date:   Thu, 13 Jun 2019 08:21:05 -0500
Message-Id: <77fe02f7d575091b06f68f8eed256da94aee653f.1560431531.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1560431531.git.jpoimboe@redhat.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 13 Jun 2019 13:23:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the BPF JIT assembly comments to AT&T syntax to reduce
confusion.  AT&T syntax is the default standard, used throughout Linux
and by the GNU assembler.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/net/bpf_jit_comp.c | 156 ++++++++++++++++++------------------
 1 file changed, 78 insertions(+), 78 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index bb1968fea50a..a92c2445441d 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -58,7 +58,7 @@ static bool is_uimm32(u64 value)
 	return value == (u64)(u32)value;
 }
 
-/* mov dst, src */
+/* mov src, dst */
 #define EMIT_mov(DST, SRC)								 \
 	do {										 \
 		if (DST != SRC)								 \
@@ -202,21 +202,21 @@ static void emit_prologue(u8 **pprog, u32 stack_depth)
 	u8 *prog = *pprog;
 	int cnt = 0;
 
-	/* push rbp */
+	/* push %rbp */
 	EMIT1(0x55);
 
-	/* mov rbp, rsp */
+	/* mov %rsp, %rbp */
 	EMIT3(0x48, 0x89, 0xE5);
 
-	/* push r15 */
+	/* push %r15 */
 	EMIT2(0x41, 0x57);
-	/* push r14 */
+	/* push %r14 */
 	EMIT2(0x41, 0x56);
-	/* push r13 */
+	/* push %r13 */
 	EMIT2(0x41, 0x55);
-	/* push r12 */
+	/* push %r12 */
 	EMIT2(0x41, 0x54);
-	/* push rbx */
+	/* push %rbx */
 	EMIT1(0x53);
 
 	/*
@@ -231,11 +231,11 @@ static void emit_prologue(u8 **pprog, u32 stack_depth)
 	 * R12 is used for the BPF program's FP register.  It points to the end
 	 * of the program's stack area.
 	 *
-	 * mov r12, rsp
+	 * mov %rsp, %r12
 	 */
 	EMIT3(0x49, 0x89, 0xE4);
 
-	/* sub rsp, rounded_stack_depth */
+	/* sub rounded_stack_depth, %rsp */
 	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
 
 	BUILD_BUG_ON(cnt != PROLOGUE_SIZE);
@@ -248,20 +248,20 @@ static void emit_epilogue(u8 **pprog)
 	u8 *prog = *pprog;
 	int cnt = 0;
 
-	/* lea rsp, [rbp-0x28] */
+	/* lea -0x28(%rbp), %rsp */
 	EMIT4(0x48, 0x8D, 0x65, 0xD8);
 
-	/* pop rbx */
+	/* pop %rbx */
 	EMIT1(0x5B);
-	/* pop r12 */
+	/* pop %r12 */
 	EMIT2(0x41, 0x5C);
-	/* pop r13 */
+	/* pop %r13 */
 	EMIT2(0x41, 0x5D);
-	/* pop r14 */
+	/* pop %r14 */
 	EMIT2(0x41, 0x5E);
-	/* pop r15 */
+	/* pop %r15 */
 	EMIT2(0x41, 0x5F);
-	/* pop rbp */
+	/* pop %rbp */
 	EMIT1(0x5D);
 
 	/* ret */
@@ -300,8 +300,8 @@ static void emit_bpf_tail_call(u8 **pprog)
 	 * if (index >= array->map.max_entries)
 	 *	goto out;
 	 */
-	EMIT2(0x89, 0xD2);                        /* mov edx, edx */
-	EMIT3(0x39, 0x56,                         /* cmp dword ptr [rsi + 16], edx */
+	EMIT2(0x89, 0xD2);                        /* mov %edx, %edx */
+	EMIT3(0x39, 0x56,                         /* cmp %edx, 0x10(%rsi) */
 	      offsetof(struct bpf_array, map.max_entries));
 #define OFFSET1 (35 + RETPOLINE_RAX_BPF_JIT_SIZE) /* Number of bytes to jump */
 	EMIT2(X86_JBE, OFFSET1);                  /* jbe out */
@@ -311,31 +311,31 @@ static void emit_bpf_tail_call(u8 **pprog)
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
-	EMIT3(0x8B, 0x45, 0xD4);                  /* mov eax, dword ptr [rbp - 44] */
-	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
+	EMIT3(0x8B, 0x45, 0xD4);                  /* mov -0x2c(%rbp), %eax */
+	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp MAX_TAIL_CALL_CNT, %eax */
 #define OFFSET2 (27 + RETPOLINE_RAX_BPF_JIT_SIZE)
 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
 	label2 = cnt;
-	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
-	EMIT3(0x89, 0x45, 0xD4);                  /* mov dword ptr [rbp - 44], eax */
+	EMIT3(0x83, 0xC0, 0x01);                  /* add $0x1, %eax */
+	EMIT3(0x89, 0x45, 0xD4);                  /* mov %eax, -0x2c(%rbp) */
 
 	/* prog = array->ptrs[index]; */
-	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + offsetof(...)] */
+	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov offsetof(ptrs)(%rsi,%rdx,8), %rax */
 		    offsetof(struct bpf_array, ptrs));
 
 	/*
 	 * if (prog == NULL)
 	 *	goto out;
 	 */
-	EMIT3(0x48, 0x85, 0xC0);		  /* test rax,rax */
+	EMIT3(0x48, 0x85, 0xC0);		  /* test %rax, %rax */
 #define OFFSET3 (8 + RETPOLINE_RAX_BPF_JIT_SIZE)
 	EMIT2(X86_JE, OFFSET3);                   /* je out */
 	label3 = cnt;
 
 	/* goto *(prog->bpf_func + prologue_size); */
-	EMIT4(0x48, 0x8B, 0x40,                   /* mov rax, qword ptr [rax + 32] */
+	EMIT4(0x48, 0x8B, 0x40,                   /* mov offsetof(bpf_func)(%rax), %rax */
 	      offsetof(struct bpf_prog, bpf_func));
-	EMIT4(0x48, 0x83, 0xC0, PROLOGUE_SIZE);   /* add rax, prologue_size */
+	EMIT4(0x48, 0x83, 0xC0, PROLOGUE_SIZE);   /* add $PROLOGUE_SIZE, %rax */
 
 	/*
 	 * Wow we're ready to jump into next BPF program
@@ -359,11 +359,11 @@ static void emit_mov_imm32(u8 **pprog, bool sign_propagate,
 	int cnt = 0;
 
 	/*
-	 * Optimization: if imm32 is positive, use 'mov %eax, imm32'
+	 * Optimization: if imm32 is positive, use 'mov imm32, %eax'
 	 * (which zero-extends imm32) to save 2 bytes.
 	 */
 	if (sign_propagate && (s32)imm32 < 0) {
-		/* 'mov %rax, imm32' sign extends imm32 */
+		/* 'mov imm32, %rax' sign extends imm32 */
 		b1 = add_1mod(0x48, dst_reg);
 		b2 = 0xC7;
 		b3 = 0xC0;
@@ -384,7 +384,7 @@ static void emit_mov_imm32(u8 **pprog, bool sign_propagate,
 		goto done;
 	}
 
-	/* mov %eax, imm32 */
+	/* mov imm32, %eax */
 	if (is_ereg(dst_reg))
 		EMIT1(add_1mod(0x40, dst_reg));
 	EMIT1_off32(add_1reg(0xB8, dst_reg), imm32);
@@ -403,11 +403,11 @@ static void emit_mov_imm64(u8 **pprog, u32 dst_reg,
 		 * For emitting plain u32, where sign bit must not be
 		 * propagated LLVM tends to load imm64 over mov32
 		 * directly, so save couple of bytes by just doing
-		 * 'mov %eax, imm32' instead.
+		 * 'mov imm32, %eax' instead.
 		 */
 		emit_mov_imm32(&prog, false, dst_reg, imm32_lo);
 	} else {
-		/* movabsq %rax, imm64 */
+		/* movabs imm64, %rax */
 		EMIT2(add_1mod(0x48, dst_reg), add_1reg(0xB8, dst_reg));
 		EMIT(imm32_lo, 4);
 		EMIT(imm32_hi, 4);
@@ -422,10 +422,10 @@ static void emit_mov_reg(u8 **pprog, bool is64, u32 dst_reg, u32 src_reg)
 	int cnt = 0;
 
 	if (is64) {
-		/* mov dst, src */
+		/* mov src, dst */
 		EMIT_mov(dst_reg, src_reg);
 	} else {
-		/* mov32 dst, src */
+		/* mov32 src, dst */
 		if (is_ereg(dst_reg) || is_ereg(src_reg))
 			EMIT1(add_2mod(0x40, dst_reg, src_reg));
 		EMIT2(0x89, add_2reg(0xC0, dst_reg, src_reg));
@@ -571,43 +571,43 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		case BPF_ALU64 | BPF_DIV | BPF_X:
 		case BPF_ALU64 | BPF_MOD | BPF_K:
 		case BPF_ALU64 | BPF_DIV | BPF_K:
-			EMIT1(0x50); /* push rax */
-			EMIT1(0x52); /* push rdx */
+			EMIT1(0x50); /* push %rax */
+			EMIT1(0x52); /* push %rdx */
 
 			if (BPF_SRC(insn->code) == BPF_X)
-				/* mov r11, src_reg */
+				/* mov src_reg, %r11 */
 				EMIT_mov(AUX_REG, src_reg);
 			else
-				/* mov r11, imm32 */
+				/* mov imm32, %r11 */
 				EMIT3_off32(0x49, 0xC7, 0xC3, imm32);
 
-			/* mov rax, dst_reg */
+			/* mov dst_reg, %rax */
 			EMIT_mov(BPF_REG_0, dst_reg);
 
 			/*
-			 * xor edx, edx
-			 * equivalent to 'xor rdx, rdx', but one byte less
+			 * xor %edx, %edx
+			 * equivalent to 'xor %rdx, %rdx', but one byte less
 			 */
 			EMIT2(0x31, 0xd2);
 
 			if (BPF_CLASS(insn->code) == BPF_ALU64)
-				/* div r11 */
+				/* div %r11 */
 				EMIT3(0x49, 0xF7, 0xF3);
 			else
-				/* div r11d */
+				/* div %r11d */
 				EMIT3(0x41, 0xF7, 0xF3);
 
 			if (BPF_OP(insn->code) == BPF_MOD)
-				/* mov r11, rdx */
+				/* mov %r11, %rdx */
 				EMIT3(0x49, 0x89, 0xD3);
 			else
-				/* mov r11, rax */
+				/* mov %r11, %rax */
 				EMIT3(0x49, 0x89, 0xC3);
 
-			EMIT1(0x5A); /* pop rdx */
-			EMIT1(0x58); /* pop rax */
+			EMIT1(0x5A); /* pop %rdx */
+			EMIT1(0x58); /* pop %rax */
 
-			/* mov dst_reg, r11 */
+			/* mov %r11, dst_reg */
 			EMIT_mov(dst_reg, AUX_REG);
 			break;
 
@@ -619,11 +619,11 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			bool is64 = BPF_CLASS(insn->code) == BPF_ALU64;
 
 			if (dst_reg != BPF_REG_0)
-				EMIT1(0x50); /* push rax */
+				EMIT1(0x50); /* push %rax */
 			if (dst_reg != BPF_REG_3)
-				EMIT1(0x52); /* push rdx */
+				EMIT1(0x52); /* push %rdx */
 
-			/* mov r11, dst_reg */
+			/* mov dst_reg, %r11 */
 			EMIT_mov(AUX_REG, dst_reg);
 
 			if (BPF_SRC(insn->code) == BPF_X)
@@ -635,15 +635,15 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 				EMIT1(add_1mod(0x48, AUX_REG));
 			else if (is_ereg(AUX_REG))
 				EMIT1(add_1mod(0x40, AUX_REG));
-			/* mul(q) r11 */
+			/* mul(q) %r11 */
 			EMIT2(0xF7, add_1reg(0xE0, AUX_REG));
 
 			if (dst_reg != BPF_REG_3)
-				EMIT1(0x5A); /* pop rdx */
+				EMIT1(0x5A); /* pop %rdx */
 			if (dst_reg != BPF_REG_0) {
-				/* mov dst_reg, rax */
+				/* mov %rax, dst_reg */
 				EMIT_mov(dst_reg, BPF_REG_0);
-				EMIT1(0x58); /* pop rax */
+				EMIT1(0x58); /* pop %rax */
 			}
 			break;
 		}
@@ -678,21 +678,21 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		case BPF_ALU64 | BPF_RSH | BPF_X:
 		case BPF_ALU64 | BPF_ARSH | BPF_X:
 
-			/* Check for bad case when dst_reg == rcx */
+			/* Check for bad case when dst_reg == %rcx */
 			if (dst_reg == BPF_REG_4) {
-				/* mov r11, dst_reg */
+				/* mov dst_reg, %r11 */
 				EMIT_mov(AUX_REG, dst_reg);
 				dst_reg = AUX_REG;
 			}
 
 			if (src_reg != BPF_REG_4) { /* common case */
-				EMIT1(0x51); /* push rcx */
+				EMIT1(0x51); /* push %rcx */
 
-				/* mov rcx, src_reg */
+				/* mov src_reg, %rcx */
 				EMIT_mov(BPF_REG_4, src_reg);
 			}
 
-			/* shl %rax, %cl | shr %rax, %cl | sar %rax, %cl */
+			/* shl %cl, %rax | shr %cl, %rax | sar %cl, %rax */
 			if (BPF_CLASS(insn->code) == BPF_ALU64)
 				EMIT1(add_1mod(0x48, dst_reg));
 			else if (is_ereg(dst_reg))
@@ -706,23 +706,23 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			EMIT2(0xD3, add_1reg(b3, dst_reg));
 
 			if (src_reg != BPF_REG_4)
-				EMIT1(0x59); /* pop rcx */
+				EMIT1(0x59); /* pop %rcx */
 
 			if (insn->dst_reg == BPF_REG_4)
-				/* mov dst_reg, r11 */
+				/* mov %r11, dst_reg */
 				EMIT_mov(insn->dst_reg, AUX_REG);
 			break;
 
 		case BPF_ALU | BPF_END | BPF_FROM_BE:
 			switch (imm32) {
 			case 16:
-				/* Emit 'ror %ax, 8' to swap lower 2 bytes */
+				/* Emit 'ror $0x8, %ax' to swap lower 2 bytes */
 				EMIT1(0x66);
 				if (is_ereg(dst_reg))
 					EMIT1(0x41);
 				EMIT3(0xC1, add_1reg(0xC8, dst_reg), 8);
 
-				/* Emit 'movzwl eax, ax' */
+				/* Emit 'movzwl %ax, %eax' */
 				if (is_ereg(dst_reg))
 					EMIT3(0x45, 0x0F, 0xB7);
 				else
@@ -730,7 +730,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 				EMIT1(add_2reg(0xC0, dst_reg, dst_reg));
 				break;
 			case 32:
-				/* Emit 'bswap eax' to swap lower 4 bytes */
+				/* Emit 'bswap %eax' to swap lower 4 bytes */
 				if (is_ereg(dst_reg))
 					EMIT2(0x41, 0x0F);
 				else
@@ -738,7 +738,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 				EMIT1(add_1reg(0xC8, dst_reg));
 				break;
 			case 64:
-				/* Emit 'bswap rax' to swap 8 bytes */
+				/* Emit 'bswap %rax' to swap 8 bytes */
 				EMIT3(add_1mod(0x48, dst_reg), 0x0F,
 				      add_1reg(0xC8, dst_reg));
 				break;
@@ -749,7 +749,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			switch (imm32) {
 			case 16:
 				/*
-				 * Emit 'movzwl eax, ax' to zero extend 16-bit
+				 * Emit 'movzwl %ax, %eax' to zero extend 16-bit
 				 * into 64 bit
 				 */
 				if (is_ereg(dst_reg))
@@ -759,7 +759,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 				EMIT1(add_2reg(0xC0, dst_reg, dst_reg));
 				break;
 			case 32:
-				/* Emit 'mov eax, eax' to clear upper 32-bits */
+				/* Emit 'mov %eax, %eax' to clear upper 32-bits */
 				if (is_ereg(dst_reg))
 					EMIT1(0x45);
 				EMIT2(0x89, add_2reg(0xC0, dst_reg, dst_reg));
@@ -811,7 +811,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 
 			/* STX: *(u8*)(dst_reg + off) = src_reg */
 		case BPF_STX | BPF_MEM | BPF_B:
-			/* Emit 'mov byte ptr [rax + off], al' */
+			/* Emit 'mov %al, off(%rax)' */
 			if (is_ereg(dst_reg) || is_ereg(src_reg) ||
 			    /* We have to add extra byte for x86 SIL, DIL regs */
 			    src_reg == BPF_REG_1 || src_reg == BPF_REG_2)
@@ -850,22 +850,22 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 
 			/* LDX: dst_reg = *(u8*)(src_reg + off) */
 		case BPF_LDX | BPF_MEM | BPF_B:
-			/* Emit 'movzx rax, byte ptr [rax + off]' */
+			/* Emit 'movzbl off(%rax), %rax' */
 			EMIT3(add_2mod(0x48, src_reg, dst_reg), 0x0F, 0xB6);
 			goto ldx;
 		case BPF_LDX | BPF_MEM | BPF_H:
-			/* Emit 'movzx rax, word ptr [rax + off]' */
+			/* Emit 'movzwl off(%rax), %rax' */
 			EMIT3(add_2mod(0x48, src_reg, dst_reg), 0x0F, 0xB7);
 			goto ldx;
 		case BPF_LDX | BPF_MEM | BPF_W:
-			/* Emit 'mov eax, dword ptr [rax+0x14]' */
+			/* Emit 'mov 0x14(%rax), %eax' */
 			if (is_ereg(dst_reg) || is_ereg(src_reg))
 				EMIT2(add_2mod(0x40, src_reg, dst_reg), 0x8B);
 			else
 				EMIT1(0x8B);
 			goto ldx;
 		case BPF_LDX | BPF_MEM | BPF_DW:
-			/* Emit 'mov rax, qword ptr [rax+0x14]' */
+			/* Emit 'mov 0x14(%rax), %rax' */
 			EMIT2(add_2mod(0x48, src_reg, dst_reg), 0x8B);
 ldx:
 			/*
@@ -889,7 +889,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 
 			/* STX XADD: lock *(u32*)(dst_reg + off) += src_reg */
 		case BPF_STX | BPF_XADD | BPF_W:
-			/* Emit 'lock add dword ptr [rax + off], eax' */
+			/* Emit 'lock add %eax, off(%rax)' */
 			if (is_ereg(dst_reg) || is_ereg(src_reg))
 				EMIT3(0xF0, add_2mod(0x40, dst_reg, src_reg), 0x01);
 			else
@@ -949,7 +949,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		case BPF_JMP32 | BPF_JSLT | BPF_X:
 		case BPF_JMP32 | BPF_JSGE | BPF_X:
 		case BPF_JMP32 | BPF_JSLE | BPF_X:
-			/* cmp dst_reg, src_reg */
+			/* cmp src_reg, dst_reg */
 			if (BPF_CLASS(insn->code) == BPF_JMP)
 				EMIT1(add_2mod(0x48, dst_reg, src_reg));
 			else if (is_ereg(dst_reg) || is_ereg(src_reg))
@@ -959,7 +959,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 
 		case BPF_JMP | BPF_JSET | BPF_X:
 		case BPF_JMP32 | BPF_JSET | BPF_X:
-			/* test dst_reg, src_reg */
+			/* test src_reg, dst_reg */
 			if (BPF_CLASS(insn->code) == BPF_JMP)
 				EMIT1(add_2mod(0x48, dst_reg, src_reg));
 			else if (is_ereg(dst_reg) || is_ereg(src_reg))
@@ -969,7 +969,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 
 		case BPF_JMP | BPF_JSET | BPF_K:
 		case BPF_JMP32 | BPF_JSET | BPF_K:
-			/* test dst_reg, imm32 */
+			/* test imm32, dst_reg */
 			if (BPF_CLASS(insn->code) == BPF_JMP)
 				EMIT1(add_1mod(0x48, dst_reg));
 			else if (is_ereg(dst_reg))
@@ -997,7 +997,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		case BPF_JMP32 | BPF_JSLT | BPF_K:
 		case BPF_JMP32 | BPF_JSGE | BPF_K:
 		case BPF_JMP32 | BPF_JSLE | BPF_K:
-			/* cmp dst_reg, imm8/32 */
+			/* cmp imm8/32, dst_reg */
 			if (BPF_CLASS(insn->code) == BPF_JMP)
 				EMIT1(add_1mod(0x48, dst_reg));
 			else if (is_ereg(dst_reg))
-- 
2.20.1

