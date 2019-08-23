Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F26D9A745
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 07:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392179AbfHWFwk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Aug 2019 01:52:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46544 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392163AbfHWFwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 01:52:37 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7N5mPKl023614
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 22:52:36 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ujaafr0b7-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 22:52:36 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 22 Aug 2019 22:52:24 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id EAC34760BEC; Thu, 22 Aug 2019 22:52:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/4] selftests/bpf: add precision tracking test
Date:   Thu, 22 Aug 2019 22:52:15 -0700
Message-ID: <20190823055215.2658669-5-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190823055215.2658669-1-ast@kernel.org>
References: <20190823055215.2658669-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-23_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908230063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Copy-paste of existing test
"calls: cross frame pruning - liveness propagation"
but ran with different parentage chain heuristic
which stresses different path in precision tracking logic.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
This test will be failing without this fix
https://patchwork.ozlabs.org/patch/1151172/
---
 .../testing/selftests/bpf/verifier/precise.c  | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/precise.c b/tools/testing/selftests/bpf/verifier/precise.c
index a20953c23721..a455a4a71f11 100644
--- a/tools/testing/selftests/bpf/verifier/precise.c
+++ b/tools/testing/selftests/bpf/verifier/precise.c
@@ -115,3 +115,28 @@
 	regs=300 stack=0 before 17\
 	parent already had regs=0 stack=0 marks",
 },
+{
+	"precise: cross frame pruning",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_IMM(BPF_REG_8, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_MOV64_IMM(BPF_REG_8, 1),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_IMM(BPF_REG_9, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_MOV64_IMM(BPF_REG_9, 1),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, 4),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_8, 1, 1),
+	BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.flags = BPF_F_TEST_STATE_FREQ,
+	.errstr = "!read_ok",
+	.result = REJECT,
+},
-- 
2.20.0

