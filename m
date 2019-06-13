Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5369E439D1
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388530AbfFMPQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:16:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9441 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732204AbfFMNXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:23:46 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 926E12E97C8;
        Thu, 13 Jun 2019 13:23:45 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 692F9541F8;
        Thu, 13 Jun 2019 13:23:44 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: [PATCH 4/9] x86/bpf: Simplify prologue generation
Date:   Thu, 13 Jun 2019 08:21:01 -0500
Message-Id: <7bed1735a13ea9d9cdf0ebda6d86d69891ae0134.1560431531.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1560431531.git.jpoimboe@redhat.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 13 Jun 2019 13:23:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the BPF JIT prologue such that it more closely resembles a
typical compiler-generated prologue.  This also reduces the prologue
size quite a bit.

The frame pointer setup instructions at the beginning don't actually
accomplish anything because RBP gets clobbered anyway later in the
prologue.  So remove those instructions for now.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/net/bpf_jit_comp.c | 100 +++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 53 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index da8c988b0f0f..485692d4b163 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -186,56 +186,48 @@ struct jit_context {
 #define BPF_MAX_INSN_SIZE	128
 #define BPF_INSN_SAFETY		64
 
-#define AUX_STACK_SPACE		40 /* Space for RBX, R13, R14, R15, tailcnt */
-
-#define PROLOGUE_SIZE		37
+#define PROLOGUE_SIZE		20
 
 /*
  * Emit x86-64 prologue code for BPF program and check its size.
  * bpf_tail_call helper will skip it while jumping into another program
  */
-static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
+static void emit_prologue(u8 **pprog, u32 stack_depth)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
 
+	/* push r15 */
+	EMIT2(0x41, 0x57);
+	/* push r14 */
+	EMIT2(0x41, 0x56);
+	/* push r13 */
+	EMIT2(0x41, 0x55);
 	/* push rbp */
 	EMIT1(0x55);
+	/* push rbx */
+	EMIT1(0x53);
 
-	/* mov rbp,rsp */
-	EMIT3(0x48, 0x89, 0xE5);
-
-	/* sub rsp, rounded_stack_depth + AUX_STACK_SPACE */
-	EMIT3_off32(0x48, 0x81, 0xEC,
-		    round_up(stack_depth, 8) + AUX_STACK_SPACE);
-
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
+	 * of the program's stack area.
+	 *
+	 * mov rbp, rsp
+	 */
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
@@ -245,19 +237,22 @@ static void emit_epilogue(u8 **pprog)
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
+	/* lea rsp, [rbp+0x8] */
+	EMIT4(0x48, 0x8D, 0x65, 0x08);
+
+	/* pop rbx */
+	EMIT1(0x5B);
+	/* pop rbp */
+	EMIT1(0x5D);
+	/* pop r13 */
+	EMIT2(0x41, 0x5D);
+	/* pop r14 */
+	EMIT2(0x41, 0x5E);
+	/* pop r15 */
+	EMIT2(0x41, 0x5F);
 
-	/* add rbp, AUX_STACK_SPACE */
-	EMIT4(0x48, 0x83, 0xC5, AUX_STACK_SPACE);
-	EMIT1(0xC9); /* leave */
-	EMIT1(0xC3); /* ret */
+	/* ret */
+	EMIT1(0xC3);
 
 	*pprog = prog;
 }
@@ -295,7 +290,7 @@ static void emit_bpf_tail_call(u8 **pprog)
 	EMIT2(0x89, 0xD2);                        /* mov edx, edx */
 	EMIT3(0x39, 0x56,                         /* cmp dword ptr [rsi + 16], edx */
 	      offsetof(struct bpf_array, map.max_entries));
-#define OFFSET1 (41 + RETPOLINE_RAX_BPF_JIT_SIZE) /* Number of bytes to jump */
+#define OFFSET1 (35 + RETPOLINE_RAX_BPF_JIT_SIZE) /* Number of bytes to jump */
 	EMIT2(X86_JBE, OFFSET1);                  /* jbe out */
 	label1 = cnt;
 
@@ -303,13 +298,13 @@ static void emit_bpf_tail_call(u8 **pprog)
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
-	EMIT2_off32(0x8B, 0x85, 36);              /* mov eax, dword ptr [rbp + 36] */
+	EMIT3(0x8B, 0x45, 0x04);                  /* mov eax, dword ptr [rbp + 4] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
-#define OFFSET2 (30 + RETPOLINE_RAX_BPF_JIT_SIZE)
+#define OFFSET2 (27 + RETPOLINE_RAX_BPF_JIT_SIZE)
 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
 	label2 = cnt;
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
-	EMIT2_off32(0x89, 0x85, 36);              /* mov dword ptr [rbp + 36], eax */
+	EMIT3(0x89, 0x45, 0x04);                  /* mov dword ptr [rbp + 4], eax */
 
 	/* prog = array->ptrs[index]; */
 	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + offsetof(...)] */
@@ -437,8 +432,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 	int proglen = 0;
 	u8 *prog = temp;
 
-	emit_prologue(&prog, bpf_prog->aux->stack_depth,
-		      bpf_prog_was_classic(bpf_prog));
+	emit_prologue(&prog, bpf_prog->aux->stack_depth);
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
 		const s32 imm32 = insn->imm;
-- 
2.20.1

