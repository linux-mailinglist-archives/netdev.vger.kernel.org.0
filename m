Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF3557826
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfF0Ae1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727430AbfF0AeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:34:23 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 862492182B;
        Thu, 27 Jun 2019 00:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595662;
        bh=6lHAk4zJ0iSlsYDMP4HoMrYKp9CdTKIpkONXq1HGL/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TY8xWrrz1rLISxOerRnY+GB9P2kVQDveui3cVXCRhXwucdIW/LJ1Qj0xND9xdTTFL
         1tfbr4IvUYyDZ4EODGREPiBH16SwLT8uomoPKeAir/Npo/rIDklN5yM2mcWha2rWoG
         uEFSVIbpTTjv6m38IDMAUky/TgwRpt/TNwOSUPc4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 71/95] bpf, x64: fix stack layout of JITed bpf code
Date:   Wed, 26 Jun 2019 20:29:56 -0400
Message-Id: <20190627003021.19867-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit fe8d9571dc50232b569242fac7ea6332a654f186 ]

Since commit 177366bf7ceb the %rbp stopped pointing to %rbp of the
previous stack frame. That broke frame pointer based stack unwinding.
This commit is a partial revert of it.
Note that the location of tail_call_cnt is fixed, since the verifier
enforces MAX_BPF_STACK stack size for programs with tail calls.

Fixes: 177366bf7ceb ("bpf: change x86 JITed program stack layout")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 74 +++++++++++--------------------------
 1 file changed, 21 insertions(+), 53 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index afabf597c855..d88bc0935886 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -190,9 +190,7 @@ struct jit_context {
 #define BPF_MAX_INSN_SIZE	128
 #define BPF_INSN_SAFETY		64
 
-#define AUX_STACK_SPACE		40 /* Space for RBX, R13, R14, R15, tailcnt */
-
-#define PROLOGUE_SIZE		37
+#define PROLOGUE_SIZE		20
 
 /*
  * Emit x86-64 prologue code for BPF program and check its size.
@@ -203,44 +201,19 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
 	u8 *prog = *pprog;
 	int cnt = 0;
 
-	/* push rbp */
-	EMIT1(0x55);
-
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
-
+	EMIT1(0x55);             /* push rbp */
+	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
+	/* sub rsp, rounded_stack_depth */
+	EMIT3_off32(0x48, 0x81, 0xEC, round_up(stack_depth, 8));
+	EMIT1(0x53);             /* push rbx */
+	EMIT2(0x41, 0x55);       /* push r13 */
+	EMIT2(0x41, 0x56);       /* push r14 */
+	EMIT2(0x41, 0x57);       /* push r15 */
 	if (!ebpf_from_cbpf) {
-		/*
-		 * Clear the tail call counter (tail_call_cnt): for eBPF tail
-		 * calls we need to reset the counter to 0. It's done in two
-		 * instructions, resetting RAX register to 0, and moving it
-		 * to the counter location.
-		 */
-
-		/* xor eax, eax */
-		EMIT2(0x31, 0xc0);
-		/* mov qword ptr [rbp+32], rax */
-		EMIT4(0x48, 0x89, 0x45, 32);
-
+		/* zero init tail_call_cnt */
+		EMIT2(0x6a, 0x00);
 		BUILD_BUG_ON(cnt != PROLOGUE_SIZE);
 	}
-
 	*pprog = prog;
 }
 
@@ -285,13 +258,13 @@ static void emit_bpf_tail_call(u8 **pprog)
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
-	EMIT2_off32(0x8B, 0x85, 36);              /* mov eax, dword ptr [rbp + 36] */
+	EMIT2_off32(0x8B, 0x85, -36 - MAX_BPF_STACK); /* mov eax, dword ptr [rbp - 548] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
 #define OFFSET2 (30 + RETPOLINE_RAX_BPF_JIT_SIZE)
 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
 	label2 = cnt;
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
-	EMIT2_off32(0x89, 0x85, 36);              /* mov dword ptr [rbp + 36], eax */
+	EMIT2_off32(0x89, 0x85, -36 - MAX_BPF_STACK); /* mov dword ptr [rbp -548], eax */
 
 	/* prog = array->ptrs[index]; */
 	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + offsetof(...)] */
@@ -1040,19 +1013,14 @@ xadd:			if (is_imm8(insn->off))
 			seen_exit = true;
 			/* Update cleanup_addr */
 			ctx->cleanup_addr = proglen;
-			/* mov rbx, qword ptr [rbp+0] */
-			EMIT4(0x48, 0x8B, 0x5D, 0);
-			/* mov r13, qword ptr [rbp+8] */
-			EMIT4(0x4C, 0x8B, 0x6D, 8);
-			/* mov r14, qword ptr [rbp+16] */
-			EMIT4(0x4C, 0x8B, 0x75, 16);
-			/* mov r15, qword ptr [rbp+24] */
-			EMIT4(0x4C, 0x8B, 0x7D, 24);
-
-			/* add rbp, AUX_STACK_SPACE */
-			EMIT4(0x48, 0x83, 0xC5, AUX_STACK_SPACE);
-			EMIT1(0xC9); /* leave */
-			EMIT1(0xC3); /* ret */
+			if (!bpf_prog_was_classic(bpf_prog))
+				EMIT1(0x5B); /* get rid of tail_call_cnt */
+			EMIT2(0x41, 0x5F);   /* pop r15 */
+			EMIT2(0x41, 0x5E);   /* pop r14 */
+			EMIT2(0x41, 0x5D);   /* pop r13 */
+			EMIT1(0x5B);         /* pop rbx */
+			EMIT1(0xC9);         /* leave */
+			EMIT1(0xC3);         /* ret */
 			break;
 
 		default:
-- 
2.20.1

