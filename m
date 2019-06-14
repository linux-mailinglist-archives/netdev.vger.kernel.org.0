Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB39466C2
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 20:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfFNSAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 14:00:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbfFNSAl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 14:00:41 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EDAC2C01F28C;
        Fri, 14 Jun 2019 18:00:39 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 976FB5DD7A;
        Fri, 14 Jun 2019 18:00:38 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v2 4/5] x86/bpf: Fix 64-bit JIT frame pointer usage
Date:   Fri, 14 Jun 2019 12:56:43 -0500
Message-Id: <178097de8c1bd6a877342304f3469eac4067daa4.1560534694.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1560534694.git.jpoimboe@redhat.com>
References: <cover.1560534694.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 14 Jun 2019 18:00:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF JIT code clobbers RBP.  This breaks frame pointer convention and
thus prevents the FP unwinder from unwinding through JIT generated code.

Fix it by saving the new RBP value on the stack before updating it.
This effectively creates a new stack frame which the unwinder can
understand.

Also, simplify the BPF JIT prologue such that it more closely resembles
a typical compiler-generated prologue.  This also reduces the prologue
size quite a bit overall.

Suggested-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/net/bpf_jit_comp.c | 106 ++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 52 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index da8c988b0f0f..fa1fe65c4cb4 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -186,56 +186,54 @@ struct jit_context {
 #define BPF_MAX_INSN_SIZE	128
 #define BPF_INSN_SAFETY		64
 
-#define AUX_STACK_SPACE		40 /* Space for RBX, R13, R14, R15, tailcnt */
-
-#define PROLOGUE_SIZE		37
+#define PROLOGUE_SIZE		24
 
 /*
  * Emit x86-64 prologue code for BPF program and check its size.
  * bpf_tail_call helper will skip it while jumping into another program
  */
-static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
+static void emit_prologue(u8 **pprog, u32 stack_depth)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
 
 	/* push rbp */
 	EMIT1(0x55);
-
-	/* mov rbp,rsp */
+	/* mov rbp, rsp */
 	EMIT3(0x48, 0x89, 0xE5);
 
-	/* sub rsp, rounded_stack_depth + AUX_STACK_SPACE */
-	EMIT3_off32(0x48, 0x81, 0xEC,
-		    round_up(stack_depth, 8) + AUX_STACK_SPACE);
+	/* push r15 */
+	EMIT2(0x41, 0x57);
+	/* push r14 */
+	EMIT2(0x41, 0x56);
+	/* push r13 */
+	EMIT2(0x41, 0x55);
+	/* push rbx */
+	EMIT1(0x53);
 
-	/* sub rbp, AUX_STACK_SPACE */
-	EMIT4(0x48, 0x83, 0xED, AUX_STACK_SPACE);
-
-	/* mov qword ptr [rbp+0],rbx */
-	EMIT4(0x48, 0x89, 0x5D, 0);
-	/* mov qword ptr [rbp+8],r13 */
-	EMIT4(0x4C, 0x89, 0x6D, 8);
-	/* mov qword ptr [rbp+16],r14 */
-	EMIT4(0x4C, 0x89, 0x75, 16);
-	/* mov qword ptr [rbp+24],r15 */
-	EMIT4(0x4C, 0x89, 0x7D, 24);
+	/*
+	 * Push the tail call counter (tail_call_cnt) for eBPF tail calls.
+	 * Initialized to zero.
+	 *
+	 * push $0
+	 */
+	EMIT2(0x6a, 0x00);
 
-	if (!ebpf_from_cbpf) {
-		/*
-		 * Clear the tail call counter (tail_call_cnt): for eBPF tail
-		 * calls we need to reset the counter to 0. It's done in two
-		 * instructions, resetting RAX register to 0, and moving it
-		 * to the counter location.
-		 */
+	/*
+	 * RBP is used for the BPF program's FP register.  It points to the end
+	 * of the program's stack area.  Create another stack frame so the
+	 * unwinder can unwind through the generated code.  The tail_call_cnt
+	 * value doubles as an (invalid) RIP address.
+	 */
+	/* push rbp */
+	EMIT1(0x55);
+	/* mov rbp, rsp */
+	EMIT3(0x48, 0x89, 0xE5);
 
-		/* xor eax, eax */
-		EMIT2(0x31, 0xc0);
-		/* mov qword ptr [rbp+32], rax */
-		EMIT4(0x48, 0x89, 0x45, 32);
+	/* sub rsp, rounded_stack_depth */
+	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
 
-		BUILD_BUG_ON(cnt != PROLOGUE_SIZE);
-	}
+	BUILD_BUG_ON(cnt != PROLOGUE_SIZE);
 
 	*pprog = prog;
 }
@@ -245,19 +243,24 @@ static void emit_epilogue(u8 **pprog)
 	u8 *prog = *pprog;
 	int cnt = 0;
 
-	/* mov rbx, qword ptr [rbp+0] */
-	EMIT4(0x48, 0x8B, 0x5D, 0);
-	/* mov r13, qword ptr [rbp+8] */
-	EMIT4(0x4C, 0x8B, 0x6D, 8);
-	/* mov r14, qword ptr [rbp+16] */
-	EMIT4(0x4C, 0x8B, 0x75, 16);
-	/* mov r15, qword ptr [rbp+24] */
-	EMIT4(0x4C, 0x8B, 0x7D, 24);
-
-	/* add rbp, AUX_STACK_SPACE */
-	EMIT4(0x48, 0x83, 0xC5, AUX_STACK_SPACE);
-	EMIT1(0xC9); /* leave */
-	EMIT1(0xC3); /* ret */
+	/* leave (restore rsp and rbp) */
+	EMIT1(0xC9);
+	/* pop rbx (skip over tail_call_cnt) */
+	EMIT1(0x5B);
+
+	/* pop rbx */
+	EMIT1(0x5B);
+	/* pop r13 */
+	EMIT2(0x41, 0x5D);
+	/* pop r14 */
+	EMIT2(0x41, 0x5E);
+	/* pop r15 */
+	EMIT2(0x41, 0x5F);
+	/* pop rbp */
+	EMIT1(0x5D);
+
+	/* ret */
+	EMIT1(0xC3);
 
 	*pprog = prog;
 }
@@ -295,7 +298,7 @@ static void emit_bpf_tail_call(u8 **pprog)
 	EMIT2(0x89, 0xD2);                        /* mov edx, edx */
 	EMIT3(0x39, 0x56,                         /* cmp dword ptr [rsi + 16], edx */
 	      offsetof(struct bpf_array, map.max_entries));
-#define OFFSET1 (41 + RETPOLINE_RAX_BPF_JIT_SIZE) /* Number of bytes to jump */
+#define OFFSET1 (35 + RETPOLINE_RAX_BPF_JIT_SIZE) /* Number of bytes to jump */
 	EMIT2(X86_JBE, OFFSET1);                  /* jbe out */
 	label1 = cnt;
 
@@ -303,13 +306,13 @@ static void emit_bpf_tail_call(u8 **pprog)
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
-	EMIT2_off32(0x8B, 0x85, 36);              /* mov eax, dword ptr [rbp + 36] */
+	EMIT3(0x8B, 0x45, 0x0C);                  /* mov eax, dword ptr [rbp + 12] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
-#define OFFSET2 (30 + RETPOLINE_RAX_BPF_JIT_SIZE)
+#define OFFSET2 (27 + RETPOLINE_RAX_BPF_JIT_SIZE)
 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
 	label2 = cnt;
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
-	EMIT2_off32(0x89, 0x85, 36);              /* mov dword ptr [rbp + 36], eax */
+	EMIT3(0x89, 0x45, 0x0C);                  /* mov dword ptr [rbp + 12], eax */
 
 	/* prog = array->ptrs[index]; */
 	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + offsetof(...)] */
@@ -437,8 +440,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 	int proglen = 0;
 	u8 *prog = temp;
 
-	emit_prologue(&prog, bpf_prog->aux->stack_depth,
-		      bpf_prog_was_classic(bpf_prog));
+	emit_prologue(&prog, bpf_prog->aux->stack_depth);
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
 		const s32 imm32 = insn->imm;
-- 
2.20.1

