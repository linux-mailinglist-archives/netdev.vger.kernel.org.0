Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF47445FF
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbfFMQsV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jun 2019 12:48:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59580 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730232AbfFMEry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 00:47:54 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5D4iBYT003204
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 21:47:53 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2t353y23ch-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 21:47:53 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Jun 2019 21:47:52 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id DD503760C2A; Wed, 12 Jun 2019 21:47:50 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 6/9] selftests/bpf: fix tests
Date:   Wed, 12 Jun 2019 21:47:35 -0700
Message-ID: <20190613044738.3858896-7-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190613044738.3858896-1-ast@kernel.org>
References: <20190613044738.3858896-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130038
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix tests that assumed no loops.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/test_verifier.c  | 11 ++++------
 tools/testing/selftests/bpf/verifier/calls.c | 22 ++++++++++++--------
 tools/testing/selftests/bpf/verifier/cfg.c   | 11 ++++++----
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index cd0248c54e25..93e1d87a343a 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -237,10 +237,10 @@ static void bpf_fill_scale1(struct bpf_test *self)
 		insn[i++] = BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
 					-8 * (k % 64 + 1));
 	}
-	/* every jump adds 1 step to insn_processed, so to stay exactly
-	 * within 1m limit add MAX_TEST_INSNS - MAX_JMP_SEQ - 1 MOVs and 1 EXIT
+	/* is_state_visited() doesn't allocate state for pruning for every jump.
+	 * Hence multiply jmps by 4 to accommodate that heuristic
 	 */
-	while (i < MAX_TEST_INSNS - MAX_JMP_SEQ - 1)
+	while (i < MAX_TEST_INSNS - MAX_JMP_SEQ * 4)
 		insn[i++] = BPF_ALU64_IMM(BPF_MOV, BPF_REG_0, 42);
 	insn[i] = BPF_EXIT_INSN();
 	self->prog_len = i + 1;
@@ -269,10 +269,7 @@ static void bpf_fill_scale2(struct bpf_test *self)
 		insn[i++] = BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
 					-8 * (k % (64 - 4 * FUNC_NEST) + 1));
 	}
-	/* every jump adds 1 step to insn_processed, so to stay exactly
-	 * within 1m limit add MAX_TEST_INSNS - MAX_JMP_SEQ - 1 MOVs and 1 EXIT
-	 */
-	while (i < MAX_TEST_INSNS - MAX_JMP_SEQ - 1)
+	while (i < MAX_TEST_INSNS - MAX_JMP_SEQ * 4)
 		insn[i++] = BPF_ALU64_IMM(BPF_MOV, BPF_REG_0, 42);
 	insn[i] = BPF_EXIT_INSN();
 	self->prog_len = i + 1;
diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
index 9093a8f64dc6..2d752c4f8d9d 100644
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -215,9 +215,11 @@
 	BPF_MOV64_IMM(BPF_REG_0, 3),
 	BPF_JMP_IMM(BPF_JA, 0, 0, -6),
 	},
-	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
-	.errstr = "back-edge from insn",
-	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
+	.errstr_unpriv = "back-edge from insn",
+	.result_unpriv = REJECT,
+	.result = ACCEPT,
+	.retval = 1,
 },
 {
 	"calls: conditional call 4",
@@ -250,22 +252,24 @@
 	BPF_MOV64_IMM(BPF_REG_0, 3),
 	BPF_EXIT_INSN(),
 	},
-	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
-	.errstr = "back-edge from insn",
-	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+	.retval = 1,
 },
 {
 	"calls: conditional call 6",
 	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, 2),
-	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, -2),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, -3),
 	BPF_EXIT_INSN(),
 	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
 		    offsetof(struct __sk_buff, mark)),
 	BPF_EXIT_INSN(),
 	},
-	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
-	.errstr = "back-edge from insn",
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.errstr = "infinite loop detected",
 	.result = REJECT,
 },
 {
diff --git a/tools/testing/selftests/bpf/verifier/cfg.c b/tools/testing/selftests/bpf/verifier/cfg.c
index 349c0862fb4c..4eb76ed739ce 100644
--- a/tools/testing/selftests/bpf/verifier/cfg.c
+++ b/tools/testing/selftests/bpf/verifier/cfg.c
@@ -41,7 +41,8 @@
 	BPF_JMP_IMM(BPF_JA, 0, 0, -1),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "back-edge",
+	.errstr = "unreachable insn 1",
+	.errstr_unpriv = "back-edge",
 	.result = REJECT,
 },
 {
@@ -53,18 +54,20 @@
 	BPF_JMP_IMM(BPF_JA, 0, 0, -4),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "back-edge",
+	.errstr = "unreachable insn 4",
+	.errstr_unpriv = "back-edge",
 	.result = REJECT,
 },
 {
 	"conditional loop",
 	.insns = {
-	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_0, BPF_REG_1),
 	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
 	BPF_MOV64_REG(BPF_REG_3, BPF_REG_0),
 	BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, -3),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "back-edge",
+	.errstr = "infinite loop detected",
+	.errstr_unpriv = "back-edge",
 	.result = REJECT,
 },
-- 
2.20.0

