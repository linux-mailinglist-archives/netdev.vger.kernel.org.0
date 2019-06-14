Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74816453B6
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 06:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfFNEun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 00:50:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbfFNEun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 00:50:43 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2DEE8308FC5F;
        Fri, 14 Jun 2019 04:50:42 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EC5A67C6D;
        Fri, 14 Jun 2019 04:50:39 +0000 (UTC)
Date:   Thu, 13 Jun 2019 23:50:37 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 7/9] x86/unwind/orc: Fall back to using frame pointers
 for generated code
Message-ID: <20190614045037.zinbi2sivthcfrtg@treble>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
 <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
 <20190614013051.6gnwduy4dsygbamj@treble>
 <20190614014244.st7fbr6areazmyrb@ast-mbp.dhcp.thefacebook.com>
 <20190614015848.todgfogryjn573nd@treble>
 <20190614022848.ly4vlgsz6fa4bcbl@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190614022848.ly4vlgsz6fa4bcbl@treble>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 14 Jun 2019 04:50:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 09:28:48PM -0500, Josh Poimboeuf wrote:
> On Thu, Jun 13, 2019 at 08:58:48PM -0500, Josh Poimboeuf wrote:
> > On Thu, Jun 13, 2019 at 06:42:45PM -0700, Alexei Starovoitov wrote:
> > > On Thu, Jun 13, 2019 at 08:30:51PM -0500, Josh Poimboeuf wrote:
> > > > On Thu, Jun 13, 2019 at 03:00:55PM -0700, Alexei Starovoitov wrote:
> > > > > > @@ -392,8 +402,16 @@ bool unwind_next_frame(struct unwind_state *state)
> > > > > >  	 * calls and calls to noreturn functions.
> > > > > >  	 */
> > > > > >  	orc = orc_find(state->signal ? state->ip : state->ip - 1);
> > > > > > -	if (!orc)
> > > > > > -		goto err;
> > > > > > +	if (!orc) {
> > > > > > +		/*
> > > > > > +		 * As a fallback, try to assume this code uses a frame pointer.
> > > > > > +		 * This is useful for generated code, like BPF, which ORC
> > > > > > +		 * doesn't know about.  This is just a guess, so the rest of
> > > > > > +		 * the unwind is no longer considered reliable.
> > > > > > +		 */
> > > > > > +		orc = &orc_fp_entry;
> > > > > > +		state->error = true;
> > > > > 
> > > > > That seems fragile.
> > > > 
> > > > I don't think so.  The unwinder has sanity checks to make sure it
> > > > doesn't go off the rails.  And it works just fine.  The beauty is that
> > > > it should work for all generated code (not just BPF).
> > > > 
> > > > > Can't we populate orc_unwind tables after JIT ?
> > > > 
> > > > As I mentioned it would introduce a lot more complexity.  For each JIT
> > > > function, BPF would have to tell ORC the following:
> > > > 
> > > > - where the BPF function lives
> > > > - how big the stack frame is
> > > > - where RBP and other callee-saved regs are on the stack
> > > 
> > > that sounds like straightforward addition that ORC should have anyway.
> > > right now we're not using rbp in the jit-ed code,
> > > but one day we definitely will.
> > > Same goes for r12. It's reserved right now for 'strategic use'.
> > > We've been thinking to add another register to bpf isa.
> > > It will map to r12 on x86. arm64 and others have plenty of regs to use.
> > > The programs are getting bigger and register spill/fill starting to
> > > become a performance concern. Extra register will give us more room.
> > 
> > With CONFIG_FRAME_POINTER, RBP isn't available.  If you look at all the
> > code in the entire kernel you'll notice that BPF JIT is pretty much the
> > only one still clobbering it.
> 
> Hm.  If you wanted to eventually use R12 for other purposes, there might
> be a way to abstract BPF_REG_FP such that it doesn't actually need a
> dedicated register.  The BPF program's frame pointer will always be a
> certain constant offset away from RBP (real frame pointer), so accesses
> to BPF_REG_FP could still be based on RBP, but with an offset added to
> it.

How about something like this (based on top of patch 4)?  This fixes
frame pointers without using R12, by making BPF_REG_FP equivalent to
RBP, minus a constant offset (callee-save area + tail_call_cnt = 40).

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 485692d4b163..2f313622c741 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -104,6 +104,9 @@ static int bpf_size_to_x86_bytes(int bpf_size)
  * register in load/store instructions, it always needs an
  * extra byte of encoding and is callee saved.
  *
+ * BPF_REG_FP corresponds to x86-64 register RBP, but 40 bytes must be
+ * subtracted from it to get the BPF_REG_FP value.
+ *
  * Also x86-64 register R9 is unused. x86-64 register R10 is
  * used for blinding (if enabled).
  */
@@ -118,11 +121,18 @@ static const int reg2hex[] = {
 	[BPF_REG_7] = 5,  /* R13 callee saved */
 	[BPF_REG_8] = 6,  /* R14 callee saved */
 	[BPF_REG_9] = 7,  /* R15 callee saved */
-	[BPF_REG_FP] = 5, /* RBP readonly */
+	[BPF_REG_FP] = 5, /* (RBP - 40 bytes) readonly */
 	[BPF_REG_AX] = 2, /* R10 temp register */
 	[AUX_REG] = 3,    /* R11 temp register */
 };
 
+static s16 offset(struct bpf_insn *insn)
+{
+	if (insn->src_reg == BPF_REG_FP || insn->dst_reg == BPF_REG_FP)
+		return insn->off - 40;
+	return insn->off;
+}
+
 /*
  * is_ereg() == true if BPF register 'reg' maps to x86-64 r8..r15
  * which need extra byte of encoding.
@@ -197,14 +207,18 @@ static void emit_prologue(u8 **pprog, u32 stack_depth)
 	u8 *prog = *pprog;
 	int cnt = 0;
 
+	/* push rbp */
+	EMIT1(0x55);
+
+	/* mov rbp,rsp */
+	EMIT3(0x48, 0x89, 0xE5);
+
 	/* push r15 */
 	EMIT2(0x41, 0x57);
 	/* push r14 */
 	EMIT2(0x41, 0x56);
 	/* push r13 */
 	EMIT2(0x41, 0x55);
-	/* push rbp */
-	EMIT1(0x55);
 	/* push rbx */
 	EMIT1(0x53);
 
@@ -216,14 +230,6 @@ static void emit_prologue(u8 **pprog, u32 stack_depth)
 	 */
 	EMIT2(0x6a, 0x00);
 
-	/*
-	 * RBP is used for the BPF program's FP register.  It points to the end
-	 * of the program's stack area.
-	 *
-	 * mov rbp, rsp
-	 */
-	EMIT3(0x48, 0x89, 0xE5);
-
 	/* sub rsp, rounded_stack_depth */
 	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
 
@@ -237,19 +243,19 @@ static void emit_epilogue(u8 **pprog)
 	u8 *prog = *pprog;
 	int cnt = 0;
 
-	/* lea rsp, [rbp+0x8] */
-	EMIT4(0x48, 0x8D, 0x65, 0x08);
+	/* lea rsp, [rbp-0x20] */
+	EMIT4(0x48, 0x8D, 0x65, 0xE0);
 
 	/* pop rbx */
 	EMIT1(0x5B);
-	/* pop rbp */
-	EMIT1(0x5D);
 	/* pop r13 */
 	EMIT2(0x41, 0x5D);
 	/* pop r14 */
 	EMIT2(0x41, 0x5E);
 	/* pop r15 */
 	EMIT2(0x41, 0x5F);
+	/* pop rbp */
+	EMIT1(0x5D);
 
 	/* ret */
 	EMIT1(0xC3);
@@ -298,13 +304,13 @@ static void emit_bpf_tail_call(u8 **pprog)
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
-	EMIT3(0x8B, 0x45, 0x04);                  /* mov eax, dword ptr [rbp + 4] */
+	EMIT3(0x8B, 0x45, 0xDC);                  /* mov eax, dword ptr [rbp - 36] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
 #define OFFSET2 (27 + RETPOLINE_RAX_BPF_JIT_SIZE)
 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
 	label2 = cnt;
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
-	EMIT3(0x89, 0x45, 0x04);                  /* mov dword ptr [rbp + 4], eax */
+	EMIT3(0x89, 0x45, 0xDC);                  /* mov dword ptr [rbp - 36], eax */
 
 	/* prog = array->ptrs[index]; */
 	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + offsetof(...)] */
@@ -418,6 +424,17 @@ static void emit_mov_reg(u8 **pprog, bool is64, u32 dst_reg, u32 src_reg)
 		EMIT2(0x89, add_2reg(0xC0, dst_reg, src_reg));
 	}
 
+	if (src_reg == BPF_REG_FP) {
+		/*
+		 * If the value was copied from RBP (real frame pointer),
+		 * adjust it to the BPF program's frame pointer value.
+		 *
+		 * add dst, -40
+		 */
+		EMIT4(add_1mod(0x48, dst_reg), 0x83, add_1reg(0xC0, dst_reg),
+		      0xD8);
+	}
+
 	*pprog = prog;
 }
 
@@ -779,10 +796,10 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		case BPF_ST | BPF_MEM | BPF_DW:
 			EMIT2(add_1mod(0x48, dst_reg), 0xC7);
 
-st:			if (is_imm8(insn->off))
-				EMIT2(add_1reg(0x40, dst_reg), insn->off);
+st:			if (is_imm8(offset(insn)))
+				EMIT2(add_1reg(0x40, dst_reg), offset(insn));
 			else
-				EMIT1_off32(add_1reg(0x80, dst_reg), insn->off);
+				EMIT1_off32(add_1reg(0x80, dst_reg), offset(insn));
 
 			EMIT(imm32, bpf_size_to_x86_bytes(BPF_SIZE(insn->code)));
 			break;
@@ -811,11 +828,11 @@ st:			if (is_imm8(insn->off))
 			goto stx;
 		case BPF_STX | BPF_MEM | BPF_DW:
 			EMIT2(add_2mod(0x48, dst_reg, src_reg), 0x89);
-stx:			if (is_imm8(insn->off))
-				EMIT2(add_2reg(0x40, dst_reg, src_reg), insn->off);
+stx:			if (is_imm8(offset(insn)))
+				EMIT2(add_2reg(0x40, dst_reg, src_reg), offset(insn));
 			else
 				EMIT1_off32(add_2reg(0x80, dst_reg, src_reg),
-					    insn->off);
+					    offset(insn));
 			break;
 
 			/* LDX: dst_reg = *(u8*)(src_reg + off) */
@@ -838,15 +855,15 @@ stx:			if (is_imm8(insn->off))
 			/* Emit 'mov rax, qword ptr [rax+0x14]' */
 			EMIT2(add_2mod(0x48, src_reg, dst_reg), 0x8B);
 ldx:			/*
-			 * If insn->off == 0 we can save one extra byte, but
+			 * If offset(insn) == 0 we can save one extra byte, but
 			 * special case of x86 R13 which always needs an offset
 			 * is not worth the hassle
 			 */
-			if (is_imm8(insn->off))
-				EMIT2(add_2reg(0x40, src_reg, dst_reg), insn->off);
+			if (is_imm8(offset(insn)))
+				EMIT2(add_2reg(0x40, src_reg, dst_reg), offset(insn));
 			else
 				EMIT1_off32(add_2reg(0x80, src_reg, dst_reg),
-					    insn->off);
+					    offset(insn));
 			break;
 
 			/* STX XADD: lock *(u32*)(dst_reg + off) += src_reg */
@@ -859,11 +876,11 @@ stx:			if (is_imm8(insn->off))
 			goto xadd;
 		case BPF_STX | BPF_XADD | BPF_DW:
 			EMIT3(0xF0, add_2mod(0x48, dst_reg, src_reg), 0x01);
-xadd:			if (is_imm8(insn->off))
-				EMIT2(add_2reg(0x40, dst_reg, src_reg), insn->off);
+xadd:			if (is_imm8(offset(insn)))
+				EMIT2(add_2reg(0x40, dst_reg, src_reg), offset(insn));
 			else
 				EMIT1_off32(add_2reg(0x80, dst_reg, src_reg),
-					    insn->off);
+					    offset(insn));
 			break;
 
 			/* call */
