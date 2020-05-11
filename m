Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82ABA1CDD7C
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 16:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbgEKOmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 10:42:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:53756 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgEKOmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 10:42:31 -0400
IronPort-SDR: i1RkQHREuYmcnFNh9CRqyYPPokx8fMeMnZhSeORoHog8lvN+D2TRm9aDHm6DuIYGsVyb6blSQJ
 4epwZR82wTAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 07:42:30 -0700
IronPort-SDR: LmY4llR+lcUwVSnBYci56dIryzCdg0IG52Uy5adrwxFi/kky4pmQneR7i0Bw/b7yvMzBCz/9ql
 BoxMXPHfEO9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,380,1583222400"; 
   d="scan'208";a="296964618"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 11 May 2020 07:42:28 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [RFC PATCH bpf-next 1/1] bpf, x64: optimize JIT prologue/epilogue generation
Date:   Mon, 11 May 2020 16:39:12 +0200
Message-Id: <20200511143912.34086-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200511143912.34086-1-maciej.fijalkowski@intel.com>
References: <20200511143912.34086-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Optimize the prologue and epilogue JIT sections in two ways. At first,
teach x86-64 JIT to detect whether R6-R9 are unused by program being
JITed and if so, don't emit push/pop insn pair for each particular
callee saved register. Secondly, don't initialize tail call counter on
stack when there is no tail call usage in picture.

While these changes are straight forward, taking care of tail call code
is more cumbersome.

With described optimization in place, it is not guaranteed that after
the tail call callee-saved programs would be properly restored, as the
target program can simply not use the R6-R9 registers, therefore it will
not pop them in the epilogue section.

Precede the actual tail call by popping callee saved registers. Tail
call will skip the instructions that handle rbp/rsp, but will execute
the pushes of callee-saved registers, if any.

For direct tail call case, there is one case that need special treatment
- e.g. the direct jump can be the NOP so in order to proceed with flow,
emit the instructions that will push back the R6-R9 to stack (since they
have been popped before the tail call).

In order to still be able to refer to tail call counter on stack, flip
its placement so that it appears as a first thing after subtracted rsp,
followed by callee saved registers, if any. Modify the
emit_bpf_tail_call_[in]direct routines to reflect that change, e.g. the
instructions that are picking the tail call counter from stack, bumping
it by 1 and updating the value on stack need to look at the -516 stack
offset from now on.

Since the layout of stack is changed, tail call counter handling can not
rely anymore on popping it rbx just like it have been handled for
constant prologue case and later overwrite of rbx with actual value of
rbx pushed to stack. Therefore, let's use one of the register (rcx) that
is considered to be volatile/caller-saved and pop the value of tail call
counter in there in the epilogue.

Drop a bunch of BUILD_BUG_ON in emit_prologue and in
emit_bpf_tail_call_indirect where instruction layout is not constant
anymore.

For regression checks, 'tailcalls' kselftest was executed:
$ sudo ./test_progs -t tailcalls
#64/1 tailcall_1:OK
#64/2 tailcall_2:OK
#64/3 tailcall_3:OK
#64/4 tailcall_4:OK
#64/5 tailcall_5:OK
#64 tailcalls:OK
Summary: 1/5 PASSED, 0 SKIPPED, 0 FAILED

Tail call related cases from test_verifier kselftest are also working
fine. Sample BPF programs that utilize tail calls (sockex3, tracex5)
work properly as well.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 arch/x86/net/bpf_jit_comp.c | 190 ++++++++++++++++++++++++++++--------
 1 file changed, 148 insertions(+), 42 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 5ea7c2cf7ab4..f208bcad856c 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -209,13 +209,44 @@ struct jit_context {
 /* Number of bytes emit_patch() needs to generate instructions */
 #define X86_PATCH_SIZE		5
 
-#define PROLOGUE_SIZE		25
+static void push_callee_regs(u8 **pprog, bool *callee_regs_used)
+{
+	u8 *prog = *pprog;
+	int cnt = 0;
+
+	if (callee_regs_used[0])
+		EMIT1(0x53);         /* push rbx */
+	if (callee_regs_used[1])
+		EMIT2(0x41, 0x55);   /* push r13 */
+	if (callee_regs_used[2])
+		EMIT2(0x41, 0x56);   /* push r14 */
+	if (callee_regs_used[3])
+		EMIT2(0x41, 0x57);   /* push r15 */
+	*pprog = prog;
+}
+
+static void pop_callee_regs(u8 **pprog, bool *callee_regs_used)
+{
+	u8 *prog = *pprog;
+	int cnt = 0;
+
+	if (callee_regs_used[3])
+		EMIT2(0x41, 0x5F);   /* pop r15 */
+	if (callee_regs_used[2])
+		EMIT2(0x41, 0x5E);   /* pop r14 */
+	if (callee_regs_used[1])
+		EMIT2(0x41, 0x5D);   /* pop r13 */
+	if (callee_regs_used[0])
+		EMIT1(0x5B);         /* pop rbx */
+	*pprog = prog;
+}
 
 /*
- * Emit x86-64 prologue code for BPF program and check its size.
+ * Emit x86-64 prologue code for BPF program.
  * bpf_tail_call helper will skip it while jumping into another program
  */
-static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
+static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf,
+			  bool tail_call)
 {
 	u8 *prog = *pprog;
 	int cnt = X86_PATCH_SIZE;
@@ -229,15 +260,8 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
 	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
 	/* sub rsp, rounded_stack_depth */
 	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
-	EMIT1(0x53);             /* push rbx */
-	EMIT2(0x41, 0x55);       /* push r13 */
-	EMIT2(0x41, 0x56);       /* push r14 */
-	EMIT2(0x41, 0x57);       /* push r15 */
-	if (!ebpf_from_cbpf) {
-		/* zero init tail_call_cnt */
+	if (!ebpf_from_cbpf && tail_call)
 		EMIT2(0x6a, 0x00);
-		BUILD_BUG_ON(cnt != PROLOGUE_SIZE);
-	}
 	*pprog = prog;
 }
 
@@ -338,12 +362,38 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
  *   goto *(prog->bpf_func + prologue_size);
  * out:
  */
-static void emit_bpf_tail_call_indirect(u8 **pprog)
+static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used)
 {
 	u8 *prog = *pprog;
-	int label1, label2, label3;
+	int off1 = 41;
+	int off2 = 30;
+	int off3 = 8;
 	int cnt = 0;
 
+	/* count the additional bytes used for pushing callee regs to stack
+	 * that need to be taken into account for each of the offsets that
+	 * are used for bailing out of the tail call
+	 */
+	if (callee_regs_used[3]) {
+		off1 += 2;
+		off2 += 2;
+		off3 += 2;
+	}
+	if (callee_regs_used[2]) {
+		off1 += 2;
+		off2 += 2;
+		off3 += 2;
+	}
+	if (callee_regs_used[1]) {
+		off1 += 2;
+		off2 += 2;
+		off3 += 2;
+	}
+	if (callee_regs_used[0]) {
+		off1 += 1;
+		off2 += 1;
+		off3 += 1;
+	}
 	/*
 	 * rdi - pointer to ctx
 	 * rsi - pointer to bpf_array
@@ -357,21 +407,19 @@ static void emit_bpf_tail_call_indirect(u8 **pprog)
 	EMIT2(0x89, 0xD2);                        /* mov edx, edx */
 	EMIT3(0x39, 0x56,                         /* cmp dword ptr [rsi + 16], edx */
 	      offsetof(struct bpf_array, map.max_entries));
-#define OFFSET1 (41 + RETPOLINE_RAX_BPF_JIT_SIZE) /* Number of bytes to jump */
+#define OFFSET1 (off1 + RETPOLINE_RAX_BPF_JIT_SIZE) /* Number of bytes to jump */
 	EMIT2(X86_JBE, OFFSET1);                  /* jbe out */
-	label1 = cnt;
 
 	/*
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
-	EMIT2_off32(0x8B, 0x85, -36 - MAX_BPF_STACK); /* mov eax, dword ptr [rbp - 548] */
+	EMIT2_off32(0x8B, 0x85, -4 - MAX_BPF_STACK); /* mov eax, dword ptr [rbp - 516] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
-#define OFFSET2 (30 + RETPOLINE_RAX_BPF_JIT_SIZE)
+#define OFFSET2 (off2 + RETPOLINE_RAX_BPF_JIT_SIZE)
 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
-	label2 = cnt;
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
-	EMIT2_off32(0x89, 0x85, -36 - MAX_BPF_STACK); /* mov dword ptr [rbp -548], eax */
+	EMIT2_off32(0x89, 0x85, -4 - MAX_BPF_STACK); /* mov dword ptr [rbp - 516], eax */
 
 	/* prog = array->ptrs[index]; */
 	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + offsetof(...)] */
@@ -382,14 +430,17 @@ static void emit_bpf_tail_call_indirect(u8 **pprog)
 	 *	goto out;
 	 */
 	EMIT3(0x48, 0x85, 0xC0);		  /* test rax,rax */
-#define OFFSET3 (8 + RETPOLINE_RAX_BPF_JIT_SIZE)
+#define OFFSET3 (off3 + RETPOLINE_RAX_BPF_JIT_SIZE)
 	EMIT2(X86_JE, OFFSET3);                   /* je out */
-	label3 = cnt;
+
+	*pprog = prog;
+	pop_callee_regs(pprog, callee_regs_used);
+	prog = *pprog;
 
 	/* goto *(prog->bpf_func + prologue_size); */
 	EMIT4(0x48, 0x8B, 0x40,                   /* mov rax, qword ptr [rax + 32] */
 	      offsetof(struct bpf_prog, bpf_func));
-	EMIT4(0x48, 0x83, 0xC0, PROLOGUE_SIZE);   /* add rax, prologue_size */
+	EMIT4(0x48, 0x83, 0xC0, 16);   /* add rax, prologue_size */
 
 	/*
 	 * Wow we're ready to jump into next BPF program
@@ -399,33 +450,64 @@ static void emit_bpf_tail_call_indirect(u8 **pprog)
 	RETPOLINE_RAX_BPF_JIT();
 
 	/* out: */
-	BUILD_BUG_ON(cnt - label1 != OFFSET1);
-	BUILD_BUG_ON(cnt - label2 != OFFSET2);
-	BUILD_BUG_ON(cnt - label3 != OFFSET3);
 	*pprog = prog;
 }
 
 static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
-				      u8 **pprog, int addr, u8 *image)
+				      u8 **pprog, int addr, u8 *image,
+				      bool *callee_regs_used)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
+	int off1 = 14;
+	int poke_off = 0;
 
+	/* count the additional bytes used for pushing callee regs to stack
+	 * that need to be taken into account for offset that is used for
+	 * bailing out of the tail call and the poke->ip
+	 */
+	if (callee_regs_used[3]) {
+		off1 += 4;
+		poke_off += 2;
+	}
+	if (callee_regs_used[2]) {
+		off1 += 4;
+		poke_off += 2;
+	}
+	if (callee_regs_used[1]) {
+		off1 += 4;
+		poke_off += 2;
+	}
+	if (callee_regs_used[0]) {
+		off1 += 2;
+		poke_off += 1;
+	}
 	/*
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
-	EMIT2_off32(0x8B, 0x85, -36 - MAX_BPF_STACK); /* mov eax, dword ptr [rbp - 548] */
+	EMIT2_off32(0x8B, 0x85, -4 - MAX_BPF_STACK); /* mov eax, dword ptr [rbp - 516] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);         /* cmp eax, MAX_TAIL_CALL_CNT */
-	EMIT2(X86_JA, 14);                            /* ja out */
+	EMIT2(X86_JA, off1);                            /* ja out */
 	EMIT3(0x83, 0xC0, 0x01);                      /* add eax, 1 */
-	EMIT2_off32(0x89, 0x85, -36 - MAX_BPF_STACK); /* mov dword ptr [rbp -548], eax */
+	EMIT2_off32(0x89, 0x85, -4 - MAX_BPF_STACK); /* mov dword ptr [rbp - 516], eax */
+
+	poke->ip = image + (addr - X86_PATCH_SIZE - poke_off);
+	poke->adj_off = 16;
 
-	poke->ip = image + (addr - X86_PATCH_SIZE);
-	poke->adj_off = PROLOGUE_SIZE;
+	*pprog = prog;
+	pop_callee_regs(pprog, callee_regs_used);
+	prog = *pprog;
 
 	memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
 	prog += X86_PATCH_SIZE;
+
+	/* in case of the target program being a NOP, restore the callee
+	 * registers on stack
+	 */
+	*pprog = prog;
+	push_callee_regs(pprog, callee_regs_used);
+	prog = *pprog;
 	/* out: */
 
 	*pprog = prog;
@@ -640,19 +722,44 @@ static bool ex_handler_bpf(const struct exception_table_entry *x,
 	return true;
 }
 
+static void detect_reg_usage(struct bpf_insn *insn, int insn_cnt,
+			     bool *regs_used, bool *tail_call_seen)
+{
+	int i;
+
+	for (i = 1; i <= insn_cnt; i++, insn++) {
+		if (insn->code == (BPF_JMP | BPF_TAIL_CALL))
+			*tail_call_seen = true;
+		if (insn->dst_reg == BPF_REG_6 || insn->src_reg == BPF_REG_6)
+			regs_used[0] = true;
+		if (insn->dst_reg == BPF_REG_7 || insn->src_reg == BPF_REG_7)
+			regs_used[1] = true;
+		if (insn->dst_reg == BPF_REG_8 || insn->src_reg == BPF_REG_8)
+			regs_used[2] = true;
+		if (insn->dst_reg == BPF_REG_9 || insn->src_reg == BPF_REG_9)
+			regs_used[3] = true;
+	}
+}
+
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		  int oldproglen, struct jit_context *ctx)
 {
 	struct bpf_insn *insn = bpf_prog->insnsi;
+	bool callee_regs_used[4] = {};
 	int insn_cnt = bpf_prog->len;
+	bool tail_call_seen = false;
 	bool seen_exit = false;
 	u8 temp[BPF_MAX_INSN_SIZE + BPF_INSN_SAFETY];
 	int i, cnt = 0, excnt = 0;
 	int proglen = 0;
 	u8 *prog = temp;
 
+	detect_reg_usage(insn, insn_cnt, callee_regs_used,
+			 &tail_call_seen);
+
 	emit_prologue(&prog, bpf_prog->aux->stack_depth,
-		      bpf_prog_was_classic(bpf_prog));
+		      bpf_prog_was_classic(bpf_prog), tail_call_seen);
+	push_callee_regs(&prog, callee_regs_used);
 	addrs[0] = prog - temp;
 
 	for (i = 1; i <= insn_cnt; i++, insn++) {
@@ -1097,9 +1204,11 @@ xadd:			if (is_imm8(insn->off))
 		case BPF_JMP | BPF_TAIL_CALL:
 			if (imm32)
 				emit_bpf_tail_call_direct(&bpf_prog->aux->poke_tab[imm32 - 1],
-							  &prog, addrs[i], image);
+							  &prog, addrs[i], image,
+							  callee_regs_used);
 			else
-				emit_bpf_tail_call_indirect(&prog);
+				emit_bpf_tail_call_indirect(&prog,
+							    callee_regs_used);
 			break;
 
 			/* cond jump */
@@ -1282,14 +1391,11 @@ xadd:			if (is_imm8(insn->off))
 			seen_exit = true;
 			/* Update cleanup_addr */
 			ctx->cleanup_addr = proglen;
-			if (!bpf_prog_was_classic(bpf_prog))
-				EMIT1(0x5B); /* get rid of tail_call_cnt */
-			EMIT2(0x41, 0x5F);   /* pop r15 */
-			EMIT2(0x41, 0x5E);   /* pop r14 */
-			EMIT2(0x41, 0x5D);   /* pop r13 */
-			EMIT1(0x5B);         /* pop rbx */
-			EMIT1(0xC9);         /* leave */
-			EMIT1(0xC3);         /* ret */
+			pop_callee_regs(&prog, callee_regs_used);
+			if (!bpf_prog_was_classic(bpf_prog) && tail_call_seen)
+				EMIT1(0x59);         /* pop rcx, get rid of tail_call_cnt */
+			EMIT1(0xC9);                 /* leave */
+			EMIT1(0xC3);                 /* ret */
 			break;
 
 		default:
-- 
2.20.1

