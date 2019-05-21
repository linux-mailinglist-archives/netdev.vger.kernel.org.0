Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC44425AAD
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 01:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfEUXJr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 May 2019 19:09:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46294 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726218AbfEUXJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 19:09:47 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4LN919a024550
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:09:45 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2smqj20n7d-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:09:45 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 21 May 2019 16:09:44 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id CD207760BE8; Tue, 21 May 2019 16:09:43 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] selftests/bpf: adjust verifier scale test
Date:   Tue, 21 May 2019 16:09:38 -0700
Message-ID: <20190521230939.2149151-3-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190521230939.2149151-1-ast@kernel.org>
References: <20190521230939.2149151-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-21_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905210144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust scale tests to check for new jmp sequence limit.

BPF_JGT had to be changed to BPF_JEQ because the verifier was
too smart. It tracked the known safe range of R0 values
and pruned the search earlier before hitting exact 8192 limit.
bpf_semi_rand_get() was too (un)?lucky.

k = 0; was missing in bpf_fill_scale2.
It was testing a bit shorter sequence of jumps than intended.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/test_verifier.c | 31 +++++++++++----------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index ccd896b98cac..6e2fec84c929 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -210,33 +210,35 @@ static void bpf_fill_rand_ld_dw(struct bpf_test *self)
 	self->retval = (uint32_t)res;
 }
 
-/* test the sequence of 1k jumps */
+#define MAX_JMP_SEQ 8192
+
+/* test the sequence of 8k jumps */
 static void bpf_fill_scale1(struct bpf_test *self)
 {
 	struct bpf_insn *insn = self->fill_insns;
 	int i = 0, k = 0;
 
 	insn[i++] = BPF_MOV64_REG(BPF_REG_6, BPF_REG_1);
-	/* test to check that the sequence of 1024 jumps is acceptable */
-	while (k++ < 1024) {
+	/* test to check that the long sequence of jumps is acceptable */
+	while (k++ < MAX_JMP_SEQ) {
 		insn[i++] = BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
 					 BPF_FUNC_get_prandom_u32);
-		insn[i++] = BPF_JMP_IMM(BPF_JGT, BPF_REG_0, bpf_semi_rand_get(), 2);
+		insn[i++] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, bpf_semi_rand_get(), 2);
 		insn[i++] = BPF_MOV64_REG(BPF_REG_1, BPF_REG_10);
 		insn[i++] = BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
 					-8 * (k % 64 + 1));
 	}
-	/* every jump adds 1024 steps to insn_processed, so to stay exactly
-	 * within 1m limit add MAX_TEST_INSNS - 1025 MOVs and 1 EXIT
+	/* every jump adds 1 step to insn_processed, so to stay exactly
+	 * within 1m limit add MAX_TEST_INSNS - MAX_JMP_SEQ - 1 MOVs and 1 EXIT
 	 */
-	while (i < MAX_TEST_INSNS - 1025)
+	while (i < MAX_TEST_INSNS - MAX_JMP_SEQ - 1)
 		insn[i++] = BPF_ALU32_IMM(BPF_MOV, BPF_REG_0, 42);
 	insn[i] = BPF_EXIT_INSN();
 	self->prog_len = i + 1;
 	self->retval = 42;
 }
 
-/* test the sequence of 1k jumps in inner most function (function depth 8)*/
+/* test the sequence of 8k jumps in inner most function (function depth 8)*/
 static void bpf_fill_scale2(struct bpf_test *self)
 {
 	struct bpf_insn *insn = self->fill_insns;
@@ -248,19 +250,20 @@ static void bpf_fill_scale2(struct bpf_test *self)
 		insn[i++] = BPF_EXIT_INSN();
 	}
 	insn[i++] = BPF_MOV64_REG(BPF_REG_6, BPF_REG_1);
-	/* test to check that the sequence of 1024 jumps is acceptable */
-	while (k++ < 1024) {
+	/* test to check that the long sequence of jumps is acceptable */
+	k = 0;
+	while (k++ < MAX_JMP_SEQ) {
 		insn[i++] = BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
 					 BPF_FUNC_get_prandom_u32);
-		insn[i++] = BPF_JMP_IMM(BPF_JGT, BPF_REG_0, bpf_semi_rand_get(), 2);
+		insn[i++] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, bpf_semi_rand_get(), 2);
 		insn[i++] = BPF_MOV64_REG(BPF_REG_1, BPF_REG_10);
 		insn[i++] = BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
 					-8 * (k % (64 - 4 * FUNC_NEST) + 1));
 	}
-	/* every jump adds 1024 steps to insn_processed, so to stay exactly
-	 * within 1m limit add MAX_TEST_INSNS - 1025 MOVs and 1 EXIT
+	/* every jump adds 1 step to insn_processed, so to stay exactly
+	 * within 1m limit add MAX_TEST_INSNS - MAX_JMP_SEQ - 1 MOVs and 1 EXIT
 	 */
-	while (i < MAX_TEST_INSNS - 1025)
+	while (i < MAX_TEST_INSNS - MAX_JMP_SEQ - 1)
 		insn[i++] = BPF_ALU32_IMM(BPF_MOV, BPF_REG_0, 42);
 	insn[i] = BPF_EXIT_INSN();
 	self->prog_len = i + 1;
-- 
2.20.0

