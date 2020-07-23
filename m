Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE24C22B50D
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 19:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbgGWRk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 13:40:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:56227 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730186AbgGWRkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 13:40:23 -0400
IronPort-SDR: Lsp41gT2sz3jpUnkrQ4+aIdRuelhkg6oHqpK0JwHr8lWqzpBr8/eZ/AEcZu1KucBPj6lPBTjCl
 bSs9c3W25rMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="212124599"
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="212124599"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 10:40:22 -0700
IronPort-SDR: zQb5hc4l14EeHIG1NpMxa9x1zMh562zMd+YtDOxNvyIMOngGuc4jr7ROqdLMGV6FsgL4pvrtTz
 sFpMp5llLilw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="462940322"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 23 Jul 2020 10:40:18 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 4/6] bpf, x64: rework pro/epilogue and tailcall handling in JIT
Date:   Thu, 23 Jul 2020 19:35:06 +0200
Message-Id: <20200723173508.62285-5-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200723173508.62285-1-maciej.fijalkowski@intel.com>
References: <20200723173508.62285-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit serves two things:
1) it optimizes BPF prologue/epilogue generation
2) it makes possible to have tailcalls within BPF subprogram

Both points are related to each other since without 1), 2) could not be
achieved.

In [1], Alexei says:
"The prologue will look like:
nop5
xor eax,eax  // two new bytes if bpf_tail_call() is used in this
             // function
push rbp
mov rbp, rsp
sub rsp, rounded_stack_depth
push rax // zero init tail_call counter
variable number of push rbx,r13,r14,r15

Then bpf_tail_call will pop variable number rbx,..
and final 'pop rax'
Then 'add rsp, size_of_current_stack_frame'
jmp to next function and skip over 'nop5; xor eax,eax; push rpb; mov
rbp, rsp'

This way new function will set its own stack size and will init tail
call
counter with whatever value the parent had.

If next function doesn't use bpf_tail_call it won't have 'xor eax,eax'.
Instead it would need to have 'nop2' in there."

Implement that suggestion.

Since the layout of stack is changed, tail call counter handling can not
rely anymore on popping it to rbx just like it have been handled for
constant prologue case and later overwrite of rbx with actual value of
rbx pushed to stack. Therefore, let's use one of the register (%rcx) that
is considered to be volatile/caller-saved and pop the value of tail call
counter in there in the epilogue.

Drop the BUILD_BUG_ON in emit_prologue and in
emit_bpf_tail_call_indirect where instruction layout is not constant
anymore.

Introduce new poke target, 'tailcall_bypass' to poke descriptor that is
dedicated for skipping the register pops and stack unwind that are
generated right before the actual jump to target program.
For case when the target program is not present, BPF program will skip
the pop instructions and nop5 dedicated for jmpq $target. An example of
such state when only R6 of callee saved registers is used by program:

ffffffffc0513aa1:       e9 0e 00 00 00          jmpq   0xffffffffc0513ab4
ffffffffc0513aa6:       5b                      pop    %rbx
ffffffffc0513aa7:       58                      pop    %rax
ffffffffc0513aa8:       48 81 c4 00 00 00 00    add    $0x0,%rsp
ffffffffc0513aaf:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
ffffffffc0513ab4:       48 89 df                mov    %rbx,%rdi

When target program is inserted, the jump that was there to skip
pops/nop5 will become the nop5, so CPU will go over pops and do the
actual tailcall.

One might ask why there simply can not be pushes after the nop5?
In the following example snippet:

ffffffffc037030c:       48 89 fb                mov    %rdi,%rbx
(...)
ffffffffc0370332:       5b                      pop    %rbx
ffffffffc0370333:       58                      pop    %rax
ffffffffc0370334:       48 81 c4 00 00 00 00    add    $0x0,%rsp
ffffffffc037033b:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
ffffffffc0370340:       48 81 ec 00 00 00 00    sub    $0x0,%rsp
ffffffffc0370347:       50                      push   %rax
ffffffffc0370348:       53                      push   %rbx
ffffffffc0370349:       48 89 df                mov    %rbx,%rdi
ffffffffc037034c:       e8 f7 21 00 00          callq  0xffffffffc0372548

There is the bpf2bpf call (at ffffffffc037034c) right after the tailcall
and jump target is not present. ctx is in %rbx register and BPF
subprogram that we will call into on ffffffffc037034c is relying on it,
e.g. it will pick ctx from there. Such code layout is therefore broken
as we would overwrite the content of %rbx with the value that was pushed
on the prologue. That is the reason for the 'bypass' approach.

Special care needs to be taken during the install/update/remove of
tailcall target. In case when target program is not present, the CPU
must not execute the pop instructions that precede the tailcall.

To address that, the following states can be defined:
A nop, unwind, nop
B nop, unwind, tail
C skip, unwind, nop
D skip, unwind, tail

A is forbidden (lead to incorrectness). The state transitions between
tailcall install/update/remove will work as follows:

First install tail call f: C->D->B(f)
 * poke the tailcall, after that get rid of the skip
Update tail call f to f': B(f)->B(f')
 * poke the tailcall (poke->tailcall_target) and do NOT touch the
   poke->tailcall_bypass
Remove tail call: B(f')->C(f')
 * poke->tailcall_bypass is poked back to jump, then we wait the RCU
   grace period so that other programs will finish its execution and
   after that we are safe to remove the poke->tailcall_target
Install new tail call (f''): C(f')->D(f'')->B(f'').
 * same as first step

This way CPU can never be exposed to "unwind, tail" state.

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

[1]: https://lore.kernel.org/bpf/20200517043227.2gpq22ifoq37ogst@ast-mbp.dhcp.thefacebook.com/

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 arch/x86/net/bpf_jit_comp.c | 221 ++++++++++++++++++++++++++++--------
 include/linux/bpf.h         |   2 +
 kernel/bpf/arraymap.c       |  47 +++++++-
 kernel/bpf/core.c           |   3 +-
 4 files changed, 220 insertions(+), 53 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 44e64d406055..880f283adb66 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -221,14 +221,48 @@ struct jit_context {
 
 /* Number of bytes emit_patch() needs to generate instructions */
 #define X86_PATCH_SIZE		5
+/* Number of bytes that will be skipped on tailcall */
+#define X86_TAIL_CALL_OFFSET	11
 
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
- * bpf_tail_call helper will skip it while jumping into another program
+ * Emit x86-64 prologue code for BPF program.
+ * bpf_tail_call helper will skip the first X86_TAIL_CALL_OFFSET bytes
+ * while jumping to another program
  */
-static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
+static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf,
+			  bool tail_call)
 {
 	u8 *prog = *pprog;
 	int cnt = X86_PATCH_SIZE;
@@ -238,19 +272,18 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
 	 */
 	memcpy(prog, ideal_nops[NOP_ATOMIC5], cnt);
 	prog += cnt;
+	if (!ebpf_from_cbpf) {
+		if (tail_call)
+			EMIT2(0x31, 0xC0); /* xor eax, eax */
+		else
+			EMIT2(0x66, 0x90); /* nop2 */
+	}
 	EMIT1(0x55);             /* push rbp */
 	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
 	/* sub rsp, rounded_stack_depth */
 	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
-	EMIT1(0x53);             /* push rbx */
-	EMIT2(0x41, 0x55);       /* push r13 */
-	EMIT2(0x41, 0x56);       /* push r14 */
-	EMIT2(0x41, 0x57);       /* push r15 */
-	if (!ebpf_from_cbpf) {
-		/* zero init tail_call_cnt */
-		EMIT2(0x6a, 0x00);
-		BUILD_BUG_ON(cnt != PROLOGUE_SIZE);
-	}
+	if (!ebpf_from_cbpf && tail_call)
+		EMIT1(0x50);         /* push rax */
 	*pprog = prog;
 }
 
@@ -314,13 +347,14 @@ static int __bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 	mutex_lock(&text_mutex);
 	if (memcmp(ip, old_insn, X86_PATCH_SIZE))
 		goto out;
+	ret = 1;
 	if (memcmp(ip, new_insn, X86_PATCH_SIZE)) {
 		if (text_live)
 			text_poke_bp(ip, new_insn, X86_PATCH_SIZE, NULL);
 		else
 			memcpy(ip, new_insn, X86_PATCH_SIZE);
+		ret = 0;
 	}
-	ret = 0;
 out:
 	mutex_unlock(&text_mutex);
 	return ret;
@@ -337,6 +371,22 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 	return __bpf_arch_text_poke(ip, t, old_addr, new_addr, true);
 }
 
+static int get_pop_bytes(bool *callee_regs_used)
+{
+	int bytes = 0;
+
+	if (callee_regs_used[3])
+		bytes += 2;
+	if (callee_regs_used[2])
+		bytes += 2;
+	if (callee_regs_used[1])
+		bytes += 2;
+	if (callee_regs_used[0])
+		bytes += 1;
+
+	return bytes;
+}
+
 /*
  * Generate the following code:
  *
@@ -351,12 +401,26 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
  *   goto *(prog->bpf_func + prologue_size);
  * out:
  */
-static void emit_bpf_tail_call_indirect(u8 **pprog)
+static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
+					u32 stack_depth)
 {
+	int tcc_off = -4 - round_up(stack_depth, 8);
 	u8 *prog = *pprog;
-	int label1, label2, label3;
+	int pop_bytes = 0;
+	int off1 = 49;
+	int off2 = 38;
+	int off3 = 16;
 	int cnt = 0;
 
+	/* count the additional bytes used for popping callee regs from stack
+	 * that need to be taken into account for each of the offsets that
+	 * are used for bailing out of the tail call
+	 */
+	pop_bytes = get_pop_bytes(callee_regs_used);
+	off1 += pop_bytes;
+	off2 += pop_bytes;
+	off3 += pop_bytes;
+
 	/*
 	 * rdi - pointer to ctx
 	 * rsi - pointer to bpf_array
@@ -370,21 +434,19 @@ static void emit_bpf_tail_call_indirect(u8 **pprog)
 	EMIT2(0x89, 0xD2);                        /* mov edx, edx */
 	EMIT3(0x39, 0x56,                         /* cmp dword ptr [rsi + 16], edx */
 	      offsetof(struct bpf_array, map.max_entries));
-#define OFFSET1 (41 + RETPOLINE_RCX_BPF_JIT_SIZE) /* Number of bytes to jump */
+#define OFFSET1 (off1 + RETPOLINE_RCX_BPF_JIT_SIZE) /* Number of bytes to jump */
 	EMIT2(X86_JBE, OFFSET1);                  /* jbe out */
-	label1 = cnt;
 
 	/*
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
-	EMIT2_off32(0x8B, 0x85, -36 - MAX_BPF_STACK); /* mov eax, dword ptr [rbp - 548] */
+	EMIT2_off32(0x8B, 0x85, tcc_off);         /* mov eax, dword ptr [rbp - tcc_off] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
-#define OFFSET2 (30 + RETPOLINE_RCX_BPF_JIT_SIZE)
+#define OFFSET2 (off2 + RETPOLINE_RCX_BPF_JIT_SIZE)
 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
-	label2 = cnt;
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
-	EMIT2_off32(0x89, 0x85, -36 - MAX_BPF_STACK); /* mov dword ptr [rbp -548], eax */
+	EMIT2_off32(0x89, 0x85, tcc_off);         /* mov dword ptr [rbp - tcc_off], eax */
 
 	/* prog = array->ptrs[index]; */
 	EMIT4_off32(0x48, 0x8B, 0x8C, 0xD6,       /* mov rcx, [rsi + rdx * 8 + offsetof(...)] */
@@ -394,48 +456,84 @@ static void emit_bpf_tail_call_indirect(u8 **pprog)
 	 * if (prog == NULL)
 	 *	goto out;
 	 */
-	EMIT3(0x48, 0x85, 0xC9);		  /* test rcx,rcx */
-#define OFFSET3 (8 + RETPOLINE_RCX_BPF_JIT_SIZE)
+	EMIT3(0x48, 0x85, 0xC9);                  /* test rcx,rcx */
+#define OFFSET3 (off3 + RETPOLINE_RCX_BPF_JIT_SIZE)
 	EMIT2(X86_JE, OFFSET3);                   /* je out */
-	label3 = cnt;
 
-	/* goto *(prog->bpf_func + prologue_size); */
+	*pprog = prog;
+	pop_callee_regs(pprog, callee_regs_used);
+	prog = *pprog;
+
+	EMIT1(0x58);                              /* pop rax */
+	EMIT3_off32(0x48, 0x81, 0xC4,             /* add rsp, sd */
+		    round_up(stack_depth, 8));
+
+	/* goto *(prog->bpf_func + X86_TAIL_CALL_OFFSET); */
 	EMIT4(0x48, 0x8B, 0x49,                   /* mov rcx, qword ptr [rcx + 32] */
 	      offsetof(struct bpf_prog, bpf_func));
-	EMIT4(0x48, 0x83, 0xC1, PROLOGUE_SIZE);   /* add rcx, prologue_size */
-
+	EMIT4(0x48, 0x83, 0xC1,                   /* add rcx, X86_TAIL_CALL_OFFSET */
+	      X86_TAIL_CALL_OFFSET);
 	/*
 	 * Now we're ready to jump into next BPF program
 	 * rdi == ctx (1st arg)
-	 * rcx == prog->bpf_func + prologue_size
+	 * rcx == prog->bpf_func + X86_TAIL_CALL_OFFSET
 	 */
 	RETPOLINE_RCX_BPF_JIT();
 
 	/* out: */
-	BUILD_BUG_ON(cnt - label1 != OFFSET1);
-	BUILD_BUG_ON(cnt - label2 != OFFSET2);
-	BUILD_BUG_ON(cnt - label3 != OFFSET3);
 	*pprog = prog;
 }
 
 static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
-				      u8 **pprog, int addr, u8 *image)
+				      u8 **pprog, int addr, u8 *image,
+				      bool *callee_regs_used, u32 stack_depth)
 {
+	int tcc_off = -4 - round_up(stack_depth, 8);
 	u8 *prog = *pprog;
+	int pop_bytes = 0;
+	int off1 = 27;
+	int poke_off;
 	int cnt = 0;
 
+	/* count the additional bytes used for popping callee regs to stack
+	 * that need to be taken into account for jump offset that is used for
+	 * bailing out from of the tail call when limit is reached
+	 */
+	pop_bytes = get_pop_bytes(callee_regs_used);
+	off1 += pop_bytes;
+
+	/*
+	 * total bytes for:
+	 * - nop5/ jmpq $off
+	 * - pop callee regs
+	 * - sub rsp, $val
+	 * - pop rax
+	 */
+	poke_off = X86_PATCH_SIZE + pop_bytes + 7 + 1;
+
 	/*
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
-	EMIT2_off32(0x8B, 0x85, -36 - MAX_BPF_STACK); /* mov eax, dword ptr [rbp - 548] */
+	EMIT2_off32(0x8B, 0x85, tcc_off);             /* mov eax, dword ptr [rbp - tcc_off] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);         /* cmp eax, MAX_TAIL_CALL_CNT */
-	EMIT2(X86_JA, 14);                            /* ja out */
+	EMIT2(X86_JA, off1);                          /* ja out */
 	EMIT3(0x83, 0xC0, 0x01);                      /* add eax, 1 */
-	EMIT2_off32(0x89, 0x85, -36 - MAX_BPF_STACK); /* mov dword ptr [rbp -548], eax */
+	EMIT2_off32(0x89, 0x85, tcc_off);             /* mov dword ptr [rbp - tcc_off], eax */
 
+	poke->tailcall_bypass = image + (addr - poke_off - X86_PATCH_SIZE);
+	poke->adj_off = X86_TAIL_CALL_OFFSET;
 	poke->tailcall_target = image + (addr - X86_PATCH_SIZE);
-	poke->adj_off = PROLOGUE_SIZE;
+	poke->bypass_addr = (u8 *)poke->tailcall_target + X86_PATCH_SIZE;
+
+	emit_jump(&prog, (u8 *)poke->tailcall_target + X86_PATCH_SIZE,
+		  poke->tailcall_bypass);
+
+	*pprog = prog;
+	pop_callee_regs(pprog, callee_regs_used);
+	prog = *pprog;
+	EMIT1(0x58);                                  /* pop rax */
+	EMIT3_off32(0x48, 0x81, 0xC4, round_up(stack_depth, 8));
 
 	memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
 	prog += X86_PATCH_SIZE;
@@ -476,6 +574,11 @@ static void bpf_tail_call_direct_fixup(struct bpf_prog *prog)
 						   (u8 *)target->bpf_func +
 						   poke->adj_off, false);
 			BUG_ON(ret < 0);
+			ret = __bpf_arch_text_poke(poke->tailcall_bypass,
+						   BPF_MOD_JUMP,
+						   (u8 *)poke->tailcall_target +
+						   X86_PATCH_SIZE, NULL, false);
+			BUG_ON(ret < 0);
 		}
 		WRITE_ONCE(poke->tailcall_target_stable, true);
 		mutex_unlock(&array->aux->poke_mutex);
@@ -654,19 +757,44 @@ static bool ex_handler_bpf(const struct exception_table_entry *x,
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
@@ -1111,9 +1239,13 @@ xadd:			if (is_imm8(insn->off))
 		case BPF_JMP | BPF_TAIL_CALL:
 			if (imm32)
 				emit_bpf_tail_call_direct(&bpf_prog->aux->poke_tab[imm32 - 1],
-							  &prog, addrs[i], image);
+							  &prog, addrs[i], image,
+							  callee_regs_used,
+							  bpf_prog->aux->stack_depth);
 			else
-				emit_bpf_tail_call_indirect(&prog);
+				emit_bpf_tail_call_indirect(&prog,
+							    callee_regs_used,
+							    bpf_prog->aux->stack_depth);
 			break;
 
 			/* cond jump */
@@ -1296,12 +1428,9 @@ xadd:			if (is_imm8(insn->off))
 			seen_exit = true;
 			/* Update cleanup_addr */
 			ctx->cleanup_addr = proglen;
-			if (!bpf_prog_was_classic(bpf_prog))
-				EMIT1(0x5B); /* get rid of tail_call_cnt */
-			EMIT2(0x41, 0x5F);   /* pop r15 */
-			EMIT2(0x41, 0x5E);   /* pop r14 */
-			EMIT2(0x41, 0x5D);   /* pop r13 */
-			EMIT1(0x5B);         /* pop rbx */
+			pop_callee_regs(&prog, callee_regs_used);
+			if (!bpf_prog_was_classic(bpf_prog) && tail_call_seen)
+				EMIT1(0x59); /* pop rcx, get rid of tail_call_cnt */
 			EMIT1(0xC9);         /* leave */
 			EMIT1(0xC3);         /* ret */
 			break;
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index aaa035519360..14b796bf35de 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -653,6 +653,8 @@ enum bpf_jit_poke_reason {
 /* Descriptor of pokes pointing /into/ the JITed image. */
 struct bpf_jit_poke_descriptor {
 	void *tailcall_target;
+	void *tailcall_bypass;
+	void *bypass_addr;
 	union {
 		struct {
 			struct bpf_map *map;
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 6fe6491fa17a..e9d62a60134b 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -750,6 +750,7 @@ static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
 				    struct bpf_prog *old,
 				    struct bpf_prog *new)
 {
+	u8 *old_addr, *new_addr, *old_bypass_addr;
 	struct prog_poke_elem *elem;
 	struct bpf_array_aux *aux;
 
@@ -800,13 +801,47 @@ static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
 			if (poke->tail_call.map != map ||
 			    poke->tail_call.key != key)
 				continue;
+			/* protect against un-updated poke descriptors since
+			 * we could fill them from subprog and the same desc
+			 * is present on main's program poke tab
+			 */
+			if (!poke->tailcall_bypass || !poke->tailcall_target ||
+			    !poke->bypass_addr)
+				continue;
 
-			ret = bpf_arch_text_poke(poke->tailcall_target, BPF_MOD_JUMP,
-						 old ? (u8 *)old->bpf_func +
-						 poke->adj_off : NULL,
-						 new ? (u8 *)new->bpf_func +
-						 poke->adj_off : NULL);
-			BUG_ON(ret < 0 && ret != -EINVAL);
+			old_bypass_addr = old ? NULL : poke->bypass_addr;
+			old_addr = old ? (u8 *)old->bpf_func + poke->adj_off : NULL;
+			new_addr = new ? (u8 *)new->bpf_func + poke->adj_off : NULL;
+
+			if (new) {
+				ret = bpf_arch_text_poke(poke->tailcall_target,
+							 BPF_MOD_JUMP,
+							 old_addr, new_addr);
+				BUG_ON(ret < 0 && ret != -EINVAL);
+				if (!old) {
+					ret = bpf_arch_text_poke(poke->tailcall_bypass,
+								 BPF_MOD_JUMP,
+								 poke->bypass_addr,
+								 NULL);
+					BUG_ON(ret < 0 && ret != -EINVAL);
+				}
+			} else {
+				ret = bpf_arch_text_poke(poke->tailcall_bypass,
+							 BPF_MOD_JUMP,
+							 old_bypass_addr,
+							 poke->bypass_addr);
+				BUG_ON(ret < 0 && ret != -EINVAL);
+				/* let other CPUs finish the execution of program
+				 * so that it will not possible to expose them
+				 * to invalid nop, stack unwind, nop state
+				 */
+				if (!ret)
+					synchronize_rcu();
+				ret = bpf_arch_text_poke(poke->tailcall_target,
+							 BPF_MOD_JUMP,
+							 old_addr, NULL);
+				BUG_ON(ret < 0 && ret != -EINVAL);
+			}
 		}
 	}
 }
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7be02e555ab9..d86a35474d7b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -773,7 +773,8 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
 
 	if (size > poke_tab_max)
 		return -ENOSPC;
-	if (poke->ip || poke->ip_stable || poke->adj_off)
+	if (poke->tailcall_target || poke->tailcall_target_stable ||
+	    poke->tailcall_bypass || poke->adj_off || poke->bypass_addr)
 		return -EINVAL;
 
 	switch (poke->reason) {
-- 
2.20.1

