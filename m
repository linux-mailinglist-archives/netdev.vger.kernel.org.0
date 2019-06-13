Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29A1439B9
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbfFMPPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:15:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732215AbfFMNXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:23:54 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E193BF9E9A;
        Thu, 13 Jun 2019 13:23:49 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1611954201;
        Thu, 13 Jun 2019 13:23:46 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: [PATCH 6/9] x86/bpf: Fix JIT frame pointer usage
Date:   Thu, 13 Jun 2019 08:21:03 -0500
Message-Id: <03ddea21a533b7b0e471c1d73ebff19dacdcf7e3.1560431531.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1560431531.git.jpoimboe@redhat.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 13 Jun 2019 13:23:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF JIT code clobbers RBP.  This breaks frame pointer convention and
thus prevents the FP unwinder from unwinding through JIT generated code.

RBP is currently used as the BPF stack frame pointer register.  The
actual register used is opaque to the user, as long as it's a
callee-saved register.  Change it to use R12 instead.

Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
Reported-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/net/bpf_jit_comp.c | 43 +++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index e649f977f8e1..bb1968fea50a 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -100,9 +100,8 @@ static int bpf_size_to_x86_bytes(int bpf_size)
 /*
  * The following table maps BPF registers to x86-64 registers.
  *
- * x86-64 register R12 is unused, since if used as base address
- * register in load/store instructions, it always needs an
- * extra byte of encoding and is callee saved.
+ * RBP isn't used; it needs to be preserved to allow the unwinder to move
+ * through generated code stacks.
  *
  * Also x86-64 register R9 is unused. x86-64 register R10 is
  * used for blinding (if enabled).
@@ -118,7 +117,7 @@ static const int reg2hex[] = {
 	[BPF_REG_7] = 5,  /* R13 callee saved */
 	[BPF_REG_8] = 6,  /* R14 callee saved */
 	[BPF_REG_9] = 7,  /* R15 callee saved */
-	[BPF_REG_FP] = 5, /* RBP readonly */
+	[BPF_REG_FP] = 4, /* R12 readonly */
 	[BPF_REG_AX] = 2, /* R10 temp register */
 	[AUX_REG] = 3,    /* R11 temp register */
 };
@@ -135,6 +134,7 @@ static bool is_ereg(u32 reg)
 			     BIT(BPF_REG_7) |
 			     BIT(BPF_REG_8) |
 			     BIT(BPF_REG_9) |
+			     BIT(BPF_REG_FP) |
 			     BIT(BPF_REG_AX));
 }
 
@@ -145,8 +145,7 @@ static bool is_axreg(u32 reg)
 
 static bool is_sib_reg(u32 reg)
 {
-	/* R12 isn't used yet */
-	false;
+	return reg == BPF_REG_FP;
 }
 
 /* Add modifiers if 'reg' maps to x86-64 registers R8..R15 */
@@ -192,7 +191,7 @@ struct jit_context {
 #define BPF_MAX_INSN_SIZE	128
 #define BPF_INSN_SAFETY		64
 
-#define PROLOGUE_SIZE		20
+#define PROLOGUE_SIZE		25
 
 /*
  * Emit x86-64 prologue code for BPF program and check its size.
@@ -203,14 +202,20 @@ static void emit_prologue(u8 **pprog, u32 stack_depth)
 	u8 *prog = *pprog;
 	int cnt = 0;
 
+	/* push rbp */
+	EMIT1(0x55);
+
+	/* mov rbp, rsp */
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
+	/* push r12 */
+	EMIT2(0x41, 0x54);
 	/* push rbx */
 	EMIT1(0x53);
 
@@ -223,12 +228,12 @@ static void emit_prologue(u8 **pprog, u32 stack_depth)
 	EMIT2(0x6a, 0x00);
 
 	/*
-	 * RBP is used for the BPF program's FP register.  It points to the end
+	 * R12 is used for the BPF program's FP register.  It points to the end
 	 * of the program's stack area.
 	 *
-	 * mov rbp, rsp
+	 * mov r12, rsp
 	 */
-	EMIT3(0x48, 0x89, 0xE5);
+	EMIT3(0x49, 0x89, 0xE4);
 
 	/* sub rsp, rounded_stack_depth */
 	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
@@ -243,19 +248,21 @@ static void emit_epilogue(u8 **pprog)
 	u8 *prog = *pprog;
 	int cnt = 0;
 
-	/* lea rsp, [rbp+0x8] */
-	EMIT4(0x48, 0x8D, 0x65, 0x08);
+	/* lea rsp, [rbp-0x28] */
+	EMIT4(0x48, 0x8D, 0x65, 0xD8);
 
 	/* pop rbx */
 	EMIT1(0x5B);
-	/* pop rbp */
-	EMIT1(0x5D);
+	/* pop r12 */
+	EMIT2(0x41, 0x5C);
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
@@ -304,13 +311,13 @@ static void emit_bpf_tail_call(u8 **pprog)
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
-	EMIT3(0x8B, 0x45, 0x04);                  /* mov eax, dword ptr [rbp + 4] */
+	EMIT3(0x8B, 0x45, 0xD4);                  /* mov eax, dword ptr [rbp - 44] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
 #define OFFSET2 (27 + RETPOLINE_RAX_BPF_JIT_SIZE)
 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
 	label2 = cnt;
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
-	EMIT3(0x89, 0x45, 0x04);                  /* mov dword ptr [rbp + 4], eax */
+	EMIT3(0x89, 0x45, 0xD4);                  /* mov dword ptr [rbp - 44], eax */
 
 	/* prog = array->ptrs[index]; */
 	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + offsetof(...)] */
-- 
2.20.1

