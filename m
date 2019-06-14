Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3FB0466D0
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 20:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfFNSAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 14:00:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbfFNSAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 14:00:38 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 767E38762E;
        Fri, 14 Jun 2019 18:00:38 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC8495D982;
        Fri, 14 Jun 2019 18:00:35 +0000 (UTC)
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
Subject: [PATCH v2 3/5] x86/bpf: Move epilogue generation to a dedicated function
Date:   Fri, 14 Jun 2019 12:56:42 -0500
Message-Id: <950a6d53bb000ca4cdd946ec6cfd1570c77c2df5.1560534694.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1560534694.git.jpoimboe@redhat.com>
References: <cover.1560534694.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 14 Jun 2019 18:00:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve code readability by moving the BPF JIT function epilogue
generation code to a dedicated emit_epilogue() function, analagous to
the existing emit_prologue() function.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/net/bpf_jit_comp.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 32bfab4e21eb..da8c988b0f0f 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -240,6 +240,28 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
 	*pprog = prog;
 }
 
+static void emit_epilogue(u8 **pprog)
+{
+	u8 *prog = *pprog;
+	int cnt = 0;
+
+	/* mov rbx, qword ptr [rbp+0] */
+	EMIT4(0x48, 0x8B, 0x5D, 0);
+	/* mov r13, qword ptr [rbp+8] */
+	EMIT4(0x4C, 0x8B, 0x6D, 8);
+	/* mov r14, qword ptr [rbp+16] */
+	EMIT4(0x4C, 0x8B, 0x75, 16);
+	/* mov r15, qword ptr [rbp+24] */
+	EMIT4(0x4C, 0x8B, 0x7D, 24);
+
+	/* add rbp, AUX_STACK_SPACE */
+	EMIT4(0x48, 0x83, 0xC5, AUX_STACK_SPACE);
+	EMIT1(0xC9); /* leave */
+	EMIT1(0xC3); /* ret */
+
+	*pprog = prog;
+}
+
 /*
  * Generate the following code:
  *
@@ -1036,19 +1058,8 @@ xadd:			if (is_imm8(insn->off))
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
+
+			emit_epilogue(&prog);
 			break;
 
 		default:
-- 
2.20.1

