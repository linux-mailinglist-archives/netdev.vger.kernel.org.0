Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B84D471D7
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 21:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfFOTMq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 15 Jun 2019 15:12:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59222 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727064AbfFOTMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 15:12:45 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5FJC2A6015057
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 12:12:44 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2t4vbds5h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 12:12:44 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 15 Jun 2019 12:12:43 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 6C693760AA7; Sat, 15 Jun 2019 12:12:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 7/9] selftests/bpf: add basic verifier tests for loops
Date:   Sat, 15 Jun 2019 12:12:23 -0700
Message-ID: <20190615191225.2409862-8-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190615191225.2409862-1-ast@kernel.org>
References: <20190615191225.2409862-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-15_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=751 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906150182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set of tests is a rewrite of Edward's earlier tests:
https://patchwork.ozlabs.org/patch/877221/

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/verifier/loops1.c | 161 ++++++++++++++++++
 1 file changed, 161 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/verifier/loops1.c

diff --git a/tools/testing/selftests/bpf/verifier/loops1.c b/tools/testing/selftests/bpf/verifier/loops1.c
new file mode 100644
index 000000000000..5e980a5ab69d
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/loops1.c
@@ -0,0 +1,161 @@
+{
+	"bounded loop, count to 4",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 1),
+	BPF_JMP_IMM(BPF_JLT, BPF_REG_0, 4, -2),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.retval = 4,
+},
+{
+	"bounded loop, count to 20",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 3),
+	BPF_JMP_IMM(BPF_JLT, BPF_REG_0, 20, -2),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"bounded loop, count from positive unknown to 4",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_JMP_IMM(BPF_JSLT, BPF_REG_0, 0, 2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 1),
+	BPF_JMP_IMM(BPF_JLT, BPF_REG_0, 4, -2),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.retval = 4,
+},
+{
+	"bounded loop, count from totally unknown to 4",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 1),
+	BPF_JMP_IMM(BPF_JLT, BPF_REG_0, 4, -2),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"bounded loop, count to 4 with equality",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 1),
+		BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 4, -2),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"bounded loop, start in the middle",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_JMP_A(1),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 1),
+		BPF_JMP_IMM(BPF_JLT, BPF_REG_0, 4, -2),
+		BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.errstr = "back-edge",
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.retval = 4,
+},
+{
+	"bounded loop containing a forward jump",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 1),
+		BPF_JMP_REG(BPF_JEQ, BPF_REG_0, BPF_REG_0, 0),
+		BPF_JMP_IMM(BPF_JLT, BPF_REG_0, 4, -3),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.retval = 4,
+},
+{
+	"bounded loop that jumps out rather than in",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_6, 0),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, 1),
+	BPF_JMP_IMM(BPF_JGT, BPF_REG_6, 10000, 2),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_JMP_A(-4),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"infinite loop after a conditional jump",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 5),
+	BPF_JMP_IMM(BPF_JLT, BPF_REG_0, 4, 2),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 1),
+	BPF_JMP_A(-2),
+	BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.errstr = "program is too large",
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"bounded recursion",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 1),
+	BPF_MOV64_REG(BPF_REG_0, BPF_REG_1),
+	BPF_JMP_IMM(BPF_JLT, BPF_REG_1, 4, 1),
+	BPF_EXIT_INSN(),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, -5),
+	BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.errstr = "back-edge",
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"infinite loop in two jumps",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_JMP_A(0),
+	BPF_JMP_IMM(BPF_JLT, BPF_REG_0, 4, -2),
+	BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.errstr = "loop detected",
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"infinite loop: three-jump trick",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_AND, BPF_REG_0, 1),
+	BPF_JMP_IMM(BPF_JLT, BPF_REG_0, 2, 1),
+	BPF_EXIT_INSN(),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_AND, BPF_REG_0, 1),
+	BPF_JMP_IMM(BPF_JLT, BPF_REG_0, 2, 1),
+	BPF_EXIT_INSN(),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_AND, BPF_REG_0, 1),
+	BPF_JMP_IMM(BPF_JLT, BPF_REG_0, 2, -11),
+	BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.errstr = "loop detected",
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
-- 
2.20.0

