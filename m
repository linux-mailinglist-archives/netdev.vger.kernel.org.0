Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C21F45638
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 09:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfFNH0J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jun 2019 03:26:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58482 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726442AbfFNH0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 03:26:09 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5E7N9Mq018516
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 00:26:08 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t3uh0a1x5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 00:26:08 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 14 Jun 2019 00:26:06 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 64E2F760F47; Fri, 14 Jun 2019 00:26:03 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/9] bpf: extend is_branch_taken to registers
Date:   Fri, 14 Jun 2019 00:25:51 -0700
Message-ID: <20190614072557.196239-4-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190614072557.196239-1-ast@kernel.org>
References: <20190614072557.196239-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=594 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140058
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends is_branch_taken() logic from JMP+K instructions
to JMP+X instructions.
Conditional branches are often done when src and dst registers
contain known scalars. In such case the verifier can follow
the branch that is going to be taken when program executes.
That speeds up the verification and is essential feature to support
bounded loops.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6c13d86569a6..8d3a4ef1d969 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5266,9 +5266,10 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	struct bpf_verifier_state *this_branch = env->cur_state;
 	struct bpf_verifier_state *other_branch;
 	struct bpf_reg_state *regs = this_branch->frame[this_branch->curframe]->regs;
-	struct bpf_reg_state *dst_reg, *other_branch_regs;
+	struct bpf_reg_state *dst_reg, *other_branch_regs, *src_reg = NULL;
 	u8 opcode = BPF_OP(insn->code);
 	bool is_jmp32;
+	int pred = -1;
 	int err;
 
 	/* Only conditional jumps are expected to reach here. */
@@ -5293,6 +5294,7 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 				insn->src_reg);
 			return -EACCES;
 		}
+		src_reg = &regs[insn->src_reg];
 	} else {
 		if (insn->src_reg != BPF_REG_0) {
 			verbose(env, "BPF_JMP/JMP32 uses reserved fields\n");
@@ -5308,20 +5310,22 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	dst_reg = &regs[insn->dst_reg];
 	is_jmp32 = BPF_CLASS(insn->code) == BPF_JMP32;
 
-	if (BPF_SRC(insn->code) == BPF_K) {
-		int pred = is_branch_taken(dst_reg, insn->imm, opcode,
-					   is_jmp32);
-
-		if (pred == 1) {
-			 /* only follow the goto, ignore fall-through */
-			*insn_idx += insn->off;
-			return 0;
-		} else if (pred == 0) {
-			/* only follow fall-through branch, since
-			 * that's where the program will go
-			 */
-			return 0;
-		}
+	if (BPF_SRC(insn->code) == BPF_K)
+		pred = is_branch_taken(dst_reg, insn->imm,
+				       opcode, is_jmp32);
+	else if (src_reg->type == SCALAR_VALUE &&
+		 tnum_is_const(src_reg->var_off))
+		pred = is_branch_taken(dst_reg, src_reg->var_off.value,
+				       opcode, is_jmp32);
+	if (pred == 1) {
+		/* only follow the goto, ignore fall-through */
+		*insn_idx += insn->off;
+		return 0;
+	} else if (pred == 0) {
+		/* only follow fall-through branch, since
+		 * that's where the program will go
+		 */
+		return 0;
 	}
 
 	other_branch = push_stack(env, *insn_idx + insn->off + 1, *insn_idx,
-- 
2.20.0

