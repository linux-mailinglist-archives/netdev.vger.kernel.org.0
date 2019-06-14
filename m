Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80CC146CA7
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfFNXI0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jun 2019 19:08:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57116 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726262AbfFNXI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:08:26 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5EN4CFh005678
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:08:25 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t4ds0shtp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:08:24 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 14 Jun 2019 16:08:23 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 971A5760C5E; Fri, 14 Jun 2019 16:08:21 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf, x64: fix stack layout of JITed bpf code
Date:   Fri, 14 Jun 2019 16:08:21 -0700
Message-ID: <20190614230821.3146272-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=621 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 177366bf7ceb the %rbp stopped pointing to %rbp of the
previous stack frame. That broke frame pointer based stack unwinding.
This commit is a partial revert of it.
Note that the location of tail_call_cnt is fixed, since the verifier
enforces MAX_BPF_STACK stack size for programs with tail calls.

Fixes: 177366bf7ceb ("bpf: change x86 JITed program stack layout")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
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
2.20.0

