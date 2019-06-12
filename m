Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF0642405
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 13:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406894AbfFLLcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 07:32:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727352AbfFLLcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 07:32:43 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CBLhIu046645
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 07:32:41 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2xm1wr1w-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 07:32:41 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <naveen.n.rao@linux.vnet.ibm.com>;
        Wed, 12 Jun 2019 12:32:39 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 12:32:36 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CBWZpt58720314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 11:32:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37C09AE057;
        Wed, 12 Jun 2019 11:32:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAC41AE055;
        Wed, 12 Jun 2019 11:32:33 +0000 (GMT)
Received: from naverao1-tp.ibmuc.com (unknown [9.199.37.223])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jun 2019 11:32:33 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] bpf: optimize constant blinding
Date:   Wed, 12 Jun 2019 17:02:08 +0530
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19061211-0016-0000-0000-000002886A39
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061211-0017-0000-0000-000032E59F65
Message-Id: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120079
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, for constant blinding, we re-allocate the bpf program to
account for its new size and adjust all branches to accommodate the
same, for each BPF instruction that needs constant blinding. This is
inefficient and can lead to soft lockup with sufficiently large
programs, such as the new verifier scalability test (ld_dw: xor
semi-random 64 bit imms, test 5 -- with net.core.bpf_jit_harden=2)

Re-implement BPF constant blinding to instead be performed in a single
pass. We do a dry run to count the additional instructions, allocate bpf
program for the corresponding size and adjust branches at once.

Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 kernel/bpf/core.c | 232 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 168 insertions(+), 64 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 33fb292f2e30..82338b5cd98d 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -897,8 +897,16 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 			      struct bpf_insn *to_buff)
 {
 	struct bpf_insn *to = to_buff;
-	u32 imm_rnd = get_random_int();
-	s16 off;
+	u32 imm_rnd = 0;
+
+	if (to_buff)
+		imm_rnd = get_random_int();
+
+#define COPY_BPF_INSN(insn)		do {				\
+						if (to_buff)		\
+							*(to) = insn;	\
+						(to)++;			\
+					} while (0)
 
 	BUILD_BUG_ON(BPF_REG_AX  + 1 != MAX_BPF_JIT_REG);
 	BUILD_BUG_ON(MAX_BPF_REG + 1 != MAX_BPF_JIT_REG);
@@ -926,7 +934,7 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 	if (from->imm == 0 &&
 	    (from->code == (BPF_ALU   | BPF_MOV | BPF_K) ||
 	     from->code == (BPF_ALU64 | BPF_MOV | BPF_K))) {
-		*to++ = BPF_ALU64_REG(BPF_XOR, from->dst_reg, from->dst_reg);
+		COPY_BPF_INSN(BPF_ALU64_REG(BPF_XOR, from->dst_reg, from->dst_reg));
 		goto out;
 	}
 
@@ -940,9 +948,9 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 	case BPF_ALU | BPF_MOV | BPF_K:
 	case BPF_ALU | BPF_DIV | BPF_K:
 	case BPF_ALU | BPF_MOD | BPF_K:
-		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
-		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
-		*to++ = BPF_ALU32_REG(from->code, from->dst_reg, BPF_REG_AX);
+		COPY_BPF_INSN(BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm));
+		COPY_BPF_INSN(BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd));
+		COPY_BPF_INSN(BPF_ALU32_REG(from->code, from->dst_reg, BPF_REG_AX));
 		break;
 
 	case BPF_ALU64 | BPF_ADD | BPF_K:
@@ -954,9 +962,9 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 	case BPF_ALU64 | BPF_MOV | BPF_K:
 	case BPF_ALU64 | BPF_DIV | BPF_K:
 	case BPF_ALU64 | BPF_MOD | BPF_K:
-		*to++ = BPF_ALU64_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
-		*to++ = BPF_ALU64_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
-		*to++ = BPF_ALU64_REG(from->code, from->dst_reg, BPF_REG_AX);
+		COPY_BPF_INSN(BPF_ALU64_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm));
+		COPY_BPF_INSN(BPF_ALU64_IMM(BPF_XOR, BPF_REG_AX, imm_rnd));
+		COPY_BPF_INSN(BPF_ALU64_REG(from->code, from->dst_reg, BPF_REG_AX));
 		break;
 
 	case BPF_JMP | BPF_JEQ  | BPF_K:
@@ -970,13 +978,9 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 	case BPF_JMP | BPF_JSGE | BPF_K:
 	case BPF_JMP | BPF_JSLE | BPF_K:
 	case BPF_JMP | BPF_JSET | BPF_K:
-		/* Accommodate for extra offset in case of a backjump. */
-		off = from->off;
-		if (off < 0)
-			off -= 2;
-		*to++ = BPF_ALU64_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
-		*to++ = BPF_ALU64_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
-		*to++ = BPF_JMP_REG(from->code, from->dst_reg, BPF_REG_AX, off);
+		COPY_BPF_INSN(BPF_ALU64_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm));
+		COPY_BPF_INSN(BPF_ALU64_IMM(BPF_XOR, BPF_REG_AX, imm_rnd));
+		COPY_BPF_INSN(BPF_JMP_REG(from->code, from->dst_reg, BPF_REG_AX, from->off));
 		break;
 
 	case BPF_JMP32 | BPF_JEQ  | BPF_K:
@@ -990,37 +994,36 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 	case BPF_JMP32 | BPF_JSGE | BPF_K:
 	case BPF_JMP32 | BPF_JSLE | BPF_K:
 	case BPF_JMP32 | BPF_JSET | BPF_K:
-		/* Accommodate for extra offset in case of a backjump. */
-		off = from->off;
-		if (off < 0)
-			off -= 2;
-		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
-		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
-		*to++ = BPF_JMP32_REG(from->code, from->dst_reg, BPF_REG_AX,
-				      off);
+		COPY_BPF_INSN(BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm));
+		COPY_BPF_INSN(BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd));
+		COPY_BPF_INSN(BPF_JMP32_REG(from->code, from->dst_reg, BPF_REG_AX,
+				      from->off));
 		break;
 
 	case BPF_LD | BPF_IMM | BPF_DW:
-		*to++ = BPF_ALU64_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ aux[1].imm);
-		*to++ = BPF_ALU64_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
-		*to++ = BPF_ALU64_IMM(BPF_LSH, BPF_REG_AX, 32);
-		*to++ = BPF_ALU64_REG(BPF_MOV, aux[0].dst_reg, BPF_REG_AX);
+		COPY_BPF_INSN(BPF_ALU64_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ aux[1].imm));
+		COPY_BPF_INSN(BPF_ALU64_IMM(BPF_XOR, BPF_REG_AX, imm_rnd));
+		COPY_BPF_INSN(BPF_ALU64_IMM(BPF_LSH, BPF_REG_AX, 32));
+		COPY_BPF_INSN(BPF_ALU64_REG(BPF_MOV, aux[0].dst_reg, BPF_REG_AX));
 		break;
 	case 0: /* Part 2 of BPF_LD | BPF_IMM | BPF_DW. */
-		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ aux[0].imm);
-		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
-		*to++ = BPF_ALU64_REG(BPF_OR,  aux[0].dst_reg, BPF_REG_AX);
+		COPY_BPF_INSN(BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ aux[0].imm));
+		COPY_BPF_INSN(BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd));
+		COPY_BPF_INSN(BPF_ALU64_REG(BPF_OR,  aux[0].dst_reg, BPF_REG_AX));
 		break;
 
 	case BPF_ST | BPF_MEM | BPF_DW:
 	case BPF_ST | BPF_MEM | BPF_W:
 	case BPF_ST | BPF_MEM | BPF_H:
 	case BPF_ST | BPF_MEM | BPF_B:
-		*to++ = BPF_ALU64_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
-		*to++ = BPF_ALU64_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
-		*to++ = BPF_STX_MEM(from->code, from->dst_reg, BPF_REG_AX, from->off);
+		COPY_BPF_INSN(BPF_ALU64_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm));
+		COPY_BPF_INSN(BPF_ALU64_IMM(BPF_XOR, BPF_REG_AX, imm_rnd));
+		COPY_BPF_INSN(BPF_STX_MEM(from->code, from->dst_reg, BPF_REG_AX, from->off));
 		break;
 	}
+
+#undef COPY_BPF_INSN
+
 out:
 	return to - to_buff;
 }
@@ -1065,57 +1068,158 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other)
 	bpf_prog_clone_free(fp_other);
 }
 
+static int bpf_jit_blind_adj_imm_off(struct bpf_insn *insn, int prog_index,
+		int clone_index, int blnd[])
+{
+	const s64 imm_min = S32_MIN, imm_max = S32_MAX;
+	const s32 off_min = S16_MIN, off_max = S16_MAX;
+	u8 code = insn->code;
+	s64 imm;
+	s32 off;
+
+	if ((BPF_CLASS(code) != BPF_JMP && BPF_CLASS(code) != BPF_JMP32) ||
+					BPF_OP(code) == BPF_EXIT)
+		return 0;
+
+	/* Adjust offset of jmps if we cross patch boundaries. */
+	if (BPF_OP(code) == BPF_CALL) {
+		if (insn->src_reg != BPF_PSEUDO_CALL)
+			return 0;
+		imm = blnd[prog_index + insn->imm + 1] - clone_index - 1;
+		if (imm < imm_min || imm > imm_max)
+			return -ERANGE;
+		insn->imm = imm;
+	} else {
+		off = blnd[prog_index + insn->off + 1] - clone_index - 1;
+		if (off < off_min || off > off_max)
+			return -ERANGE;
+		insn->off = off;
+	}
+
+	return 0;
+}
+
 struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
 {
+	int i, j, rewritten, new_len, insn_cnt, ret = 0;
 	struct bpf_insn insn_buff[16], aux[2];
 	struct bpf_prog *clone, *tmp;
-	int insn_delta, insn_cnt;
 	struct bpf_insn *insn;
-	int i, rewritten;
+	u32 *clone_index;
 
 	if (!bpf_jit_blinding_enabled(prog) || prog->blinded)
 		return prog;
 
-	clone = bpf_prog_clone_create(prog, GFP_USER);
-	if (!clone)
+	/* Dry run to figure out the final number of instructions */
+	clone_index = vmalloc(prog->len * sizeof(u32));
+	if (!clone_index)
 		return ERR_PTR(-ENOMEM);
 
-	insn_cnt = clone->len;
-	insn = clone->insnsi;
-
+	insn_cnt = prog->len;
+	insn = prog->insnsi;
+	rewritten = 0;
 	for (i = 0; i < insn_cnt; i++, insn++) {
-		/* We temporarily need to hold the original ld64 insn
-		 * so that we can still access the first part in the
-		 * second blinding run.
-		 */
-		if (insn[0].code == (BPF_LD | BPF_IMM | BPF_DW) &&
-		    insn[1].code == 0)
-			memcpy(aux, insn, sizeof(aux));
+		clone_index[i] = bpf_jit_blind_insn(insn, 0, 0);
+		if (clone_index[i] > 1)
+			rewritten += clone_index[i] - 1;
+	}
 
-		rewritten = bpf_jit_blind_insn(insn, aux, insn_buff);
-		if (!rewritten)
-			continue;
+	if (rewritten) {
+		/* Needs new allocation, branch adjustment, et al... */
+		clone = bpf_prog_clone_create(prog, GFP_USER);
+		if (!clone) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		new_len = prog->len + rewritten;
+		tmp = bpf_prog_realloc(clone, bpf_prog_size(new_len), GFP_USER);
+		if (!tmp) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		clone = tmp;
+		clone->len = new_len;
+
+		/* rewrite instructions with constant blinding */
+		insn_cnt = prog->len;
+		insn = prog->insnsi;
+		for (i = 0, j = 0; i < insn_cnt; i++, j++, insn++) {
+			/* capture new instruction index in clone_index */
+			clone_index[i] = j;
 
-		tmp = bpf_patch_insn_single(clone, i, insn_buff, rewritten);
-		if (IS_ERR(tmp)) {
-			/* Patching may have repointed aux->prog during
-			 * realloc from the original one, so we need to
-			 * fix it up here on error.
+			/* We temporarily need to hold the original ld64 insn
+			 * so that we can still access the first part in the
+			 * second blinding run.
 			 */
-			bpf_jit_prog_release_other(prog, clone);
-			return tmp;
+			if (insn[0].code == (BPF_LD | BPF_IMM | BPF_DW) &&
+			    insn[1].code == 0)
+				memcpy(aux, insn, sizeof(aux));
+
+			rewritten = bpf_jit_blind_insn(insn, aux, insn_buff);
+			if (!rewritten) {
+				memcpy(clone->insnsi + j, insn,
+					sizeof(struct bpf_insn));
+			} else {
+				memcpy(clone->insnsi + j, insn_buff,
+					sizeof(struct bpf_insn) * rewritten);
+				j += rewritten - 1;
+			}
 		}
 
-		clone = tmp;
-		insn_delta = rewritten - 1;
+		/* adjust branches */
+		for (i = 0; i < insn_cnt; i++) {
+			int next_insn_idx = clone->len;
+
+			if (i < insn_cnt - 1)
+				next_insn_idx = clone_index[i + 1];
+
+			insn = clone->insnsi + clone_index[i];
+			for (j = clone_index[i]; j < next_insn_idx; j++, insn++) {
+				ret = bpf_jit_blind_adj_imm_off(insn, i, j, clone_index);
+				if (ret) {
+					goto err;
+				}
+			}
+		}
+
+		/* adjust linfo */
+		if (clone->aux->nr_linfo) {
+			struct bpf_line_info *linfo = clone->aux->linfo;
 
-		/* Walk new program and skip insns we just inserted. */
-		insn = clone->insnsi + i + insn_delta;
-		insn_cnt += insn_delta;
-		i        += insn_delta;
+			for (i = 0; i < clone->aux->nr_linfo; i++)
+				linfo[i].insn_off = clone_index[linfo[i].insn_off];
+		}
+	} else {
+		/* if prog length remains same, not much work to do */
+		clone = bpf_prog_clone_create(prog, GFP_USER);
+		if (!clone) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		insn_cnt = clone->len;
+		insn = clone->insnsi;
+
+		for (i = 0; i < insn_cnt; i++, insn++) {
+			if (clone_index[i]) {
+				bpf_jit_blind_insn(insn, aux, insn_buff);
+				memcpy(insn, insn_buff, sizeof(struct bpf_insn));
+			}
+		}
 	}
 
 	clone->blinded = 1;
+
+err:
+	vfree(clone_index);
+
+	if (ret) {
+		if (clone)
+			bpf_jit_prog_release_other(prog, clone);
+		return ERR_PTR(ret);
+	}
+
 	return clone;
 }
 #endif /* CONFIG_BPF_JIT */
-- 
2.21.0

