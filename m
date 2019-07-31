Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7D57B7AA
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 03:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfGaBig convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Jul 2019 21:38:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45194 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726628AbfGaBif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 21:38:35 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6V1ZIlB015088
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 18:38:34 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2wkkrs27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 18:38:34 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 30 Jul 2019 18:38:32 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id C47A9760C3C; Tue, 30 Jul 2019 18:38:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 2/2] selftests/bpf: tests for jmp to 1st insn
Date:   Tue, 30 Jul 2019 18:38:27 -0700
Message-ID: <20190731013827.2445262-3-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190731013827.2445262-1-ast@kernel.org>
References: <20190731013827.2445262-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 2 tests that check JIT code generation to jumps to 1st insn.
1st test is similar to syzbot reproducer.
The backwards branch is never taken at runtime.
2nd test has branch to 1st insn that executes.
The test is written as two bpf functions, since it's not possible
to construct valid single bpf program that jumps to 1st insn.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/verifier/loops1.c | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/loops1.c b/tools/testing/selftests/bpf/verifier/loops1.c
index 5e980a5ab69d..1fc4e61e9f9f 100644
--- a/tools/testing/selftests/bpf/verifier/loops1.c
+++ b/tools/testing/selftests/bpf/verifier/loops1.c
@@ -159,3 +159,31 @@
 	.errstr = "loop detected",
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
+{
+	"not-taken loop with back jump to 1st insn",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 123),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 4, -2),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.retval = 123,
+},
+{
+	"taken loop with back jump to 1st insn",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_1, 10),
+	BPF_MOV64_IMM(BPF_REG_2, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1),
+	BPF_ALU64_IMM(BPF_SUB, BPF_REG_1, 1),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, -3),
+	BPF_MOV64_REG(BPF_REG_0, BPF_REG_2),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.retval = 55,
+},
-- 
2.20.0

