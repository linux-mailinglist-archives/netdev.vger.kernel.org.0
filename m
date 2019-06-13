Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C44244603
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392923AbfFMQs3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jun 2019 12:48:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37948 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730222AbfFMErr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 00:47:47 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5D4krRv000332
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 21:47:46 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2t356222a7-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 21:47:45 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Jun 2019 21:47:45 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id C171C760C2A; Wed, 12 Jun 2019 21:47:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/9] bpf: extend is_branch_taken to registers
Date:   Wed, 12 Jun 2019 21:47:32 -0700
Message-ID: <20190613044738.3858896-4-ast@kernel.org>
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
 mlxlogscore=580 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130038
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends is_branch_taken() logic from JMP+K instructions
to JMP+X instructions.
Conditional branches are often done when src and dst registers
contain known scalars. In such case the verifier can follow
the branch that is going to be taken when program executes on CPU.
That speeds up the verification and essential feature to support
bounded loops.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a21bafd7d931..c79c09586a9e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5263,10 +5263,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	struct bpf_verifier_state *this_branch = env->cur_state;
 	struct bpf_verifier_state *other_branch;
 	struct bpf_reg_state *regs = this_branch->frame[this_branch->curframe]->regs;
-	struct bpf_reg_state *dst_reg, *other_branch_regs;
+	struct bpf_reg_state *dst_reg, *other_branch_regs, *src_reg = NULL;
 	u8 opcode = BPF_OP(insn->code);
 	bool is_jmp32;
 	int err;
+	u64 cond_val;
 
 	/* Only conditional jumps are expected to reach here. */
 	if (opcode == BPF_JA || opcode > BPF_JSLE) {
@@ -5290,6 +5291,7 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 				insn->src_reg);
 			return -EACCES;
 		}
+		src_reg = &regs[insn->src_reg];
 	} else {
 		if (insn->src_reg != BPF_REG_0) {
 			verbose(env, "BPF_JMP/JMP32 uses reserved fields\n");
@@ -5306,8 +5308,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	is_jmp32 = BPF_CLASS(insn->code) == BPF_JMP32;
 
 	if (BPF_SRC(insn->code) == BPF_K) {
-		int pred = is_branch_taken(dst_reg, insn->imm, opcode,
-					   is_jmp32);
+		int pred;
+
+		cond_val = insn->imm;
+check_taken:
+		pred = is_branch_taken(dst_reg, cond_val, opcode, is_jmp32);
 
 		if (pred == 1) {
 			 /* only follow the goto, ignore fall-through */
@@ -5319,6 +5324,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 			 */
 			return 0;
 		}
+	} else if (BPF_SRC(insn->code) == BPF_X &&
+		   src_reg->type == SCALAR_VALUE &&
+		   tnum_is_const(src_reg->var_off)) {
+		cond_val = src_reg->var_off.value;
+		goto check_taken;
 	}
 
 	other_branch = push_stack(env, *insn_idx + insn->off + 1, *insn_idx,
-- 
2.20.0

