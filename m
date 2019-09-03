Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A068A774F
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfICWvj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 Sep 2019 18:51:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43858 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727340AbfICWvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:51:39 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x83Mn7Qq011888
        for <netdev@vger.kernel.org>; Tue, 3 Sep 2019 15:51:38 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2ustcqt2xw-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:51:37 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 3 Sep 2019 15:51:35 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 3FC6D760915; Tue,  3 Sep 2019 15:51:33 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: precision tracking tests
Date:   Tue, 3 Sep 2019 15:51:33 -0700
Message-ID: <20190903225133.821243-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_05:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 clxscore=1015
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909030228
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two tests to check that stack slot marking during backtracking
doesn't trigger 'spi > allocated_stack' warning.
One test is using BPF_ST insn. Another is using BPF_STX.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
these tests depend on the fix https://patchwork.ozlabs.org/patch/1157368/
---
 .../testing/selftests/bpf/verifier/precise.c  | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/precise.c b/tools/testing/selftests/bpf/verifier/precise.c
index a455a4a71f11..02151f8c940f 100644
--- a/tools/testing/selftests/bpf/verifier/precise.c
+++ b/tools/testing/selftests/bpf/verifier/precise.c
@@ -140,3 +140,55 @@
 	.errstr = "!read_ok",
 	.result = REJECT,
 },
+{
+	"precise: ST insn causing spi > allocated_stack",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_3, BPF_REG_10),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_3, 123, 0),
+	BPF_ST_MEM(BPF_DW, BPF_REG_3, -8, 0),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_4, BPF_REG_10, -8),
+	BPF_MOV64_IMM(BPF_REG_0, -1),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_4, BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = BPF_F_TEST_STATE_FREQ,
+	.errstr = "5: (2d) if r4 > r0 goto pc+0\
+	last_idx 5 first_idx 5\
+	parent didn't have regs=10 stack=0 marks\
+	last_idx 4 first_idx 2\
+	regs=10 stack=0 before 4\
+	regs=10 stack=0 before 3\
+	regs=0 stack=1 before 2\
+	last_idx 5 first_idx 5\
+	parent didn't have regs=1 stack=0 marks",
+	.result = VERBOSE_ACCEPT,
+	.retval = -1,
+},
+{
+	"precise: STX insn causing spi > allocated_stack",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_3, BPF_REG_10),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_3, 123, 0),
+	BPF_STX_MEM(BPF_DW, BPF_REG_3, BPF_REG_0, -8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_4, BPF_REG_10, -8),
+	BPF_MOV64_IMM(BPF_REG_0, -1),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_4, BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = BPF_F_TEST_STATE_FREQ,
+	.errstr = "last_idx 6 first_idx 6\
+	parent didn't have regs=10 stack=0 marks\
+	last_idx 5 first_idx 3\
+	regs=10 stack=0 before 5\
+	regs=10 stack=0 before 4\
+	regs=0 stack=1 before 3\
+	last_idx 6 first_idx 6\
+	parent didn't have regs=1 stack=0 marks\
+	last_idx 5 first_idx 3\
+	regs=1 stack=0 before 5",
+	.result = VERBOSE_ACCEPT,
+	.retval = -1,
+},
-- 
2.20.0

