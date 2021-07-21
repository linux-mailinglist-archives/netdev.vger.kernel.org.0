Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4228F3D0617
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 02:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhGTX3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 19:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhGTX1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 19:27:51 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E5DC061762;
        Tue, 20 Jul 2021 17:08:29 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gx2so642943pjb.5;
        Tue, 20 Jul 2021 17:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ao0sbw+XbpENUOiDMP+160Zj5h9r3VTJ7hR/H3YRmQ=;
        b=PLJP+LZ7PnFsonaSvkM+6t8OGrMb9MMzGREYNMyE2HyeynjtdhrjFvF/pJfouUl/PJ
         LSCA7gtlfaPZW7vzXdaslm254whsJ19lkM9dwTh8xBunoGMgjWp3H36oejtBRgvDc298
         3OqvTyUFNfXL9vIV6zWCDYFENw3OfdinG2rkt5F+tb+RvuY/XF+RhegHx1warS0/MwsM
         4WKB/mAypSlZOcrMtWttVIQIGGHKIensCJDrKbs9tmqZ60OLD7wG1ZP3BOibo15yXLRR
         0q6HTJ7+RO+/0xOUCTm25Brl+O6+O7o6pPquay1wO5z/iDK9V43rRxZX9cnouwG4U3uS
         vXGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ao0sbw+XbpENUOiDMP+160Zj5h9r3VTJ7hR/H3YRmQ=;
        b=VaAt3DIvdtTmHwXg5bdoalJ4HdkFdj7iFSnAnzg3YkBCtBZ0kqAXH7Gv1zjbnb9JLl
         reacfxBC1CKYF8iRtBBq6PGjz8GZh4KUiXmZKnACh3qZZxZohshW+rbJIoV6jvIazQt3
         U+CE6XfQvXjpDgk/vcLRRomXzYGQNm8Xp0yVxRD0aqjVsIu3Avmi2+H4ZlesFwhb4lPH
         IKdfbbclDnP0sba2l/jk5fsJI1vxJipWnWMyGdpVSRqhaSIZAdenxH5N0OzHNDD1gkF5
         vH9Bz2vQUhAsvPu6BICxNEBfyeNGK258/SIJDMIy5EBlkSkhiQL2gxKR6y3TU3mmpHRS
         05hg==
X-Gm-Message-State: AOAM533YRRE3dIWVJCC6Dbg9ixU54Yx/9lP4DQp50Mv8jYwvbpwJ9gsD
        q5GNlHfa9lsiA6Sh7+FnFXTRPRJHsDY=
X-Google-Smtp-Source: ABdhPJz7gPwgDqILAD8Jh5B94ia0Lhee2CJuz8Q3rZlcVlg4OqqGosLE1AS5UijI184HT+T+LhjLvg==
X-Received: by 2002:a17:90a:fa86:: with SMTP id cu6mr1005623pjb.68.1626826108658;
        Tue, 20 Jul 2021 17:08:28 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:500::6:4ad3])
        by smtp.gmail.com with ESMTPSA id i12sm20510052pjj.9.2021.07.20.17.08.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Jul 2021 17:08:27 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 1/4] libbpf: Cleanup the layering between CORE and bpf_program.
Date:   Tue, 20 Jul 2021 17:08:19 -0700
Message-Id: <20210721000822.40958-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210721000822.40958-1-alexei.starovoitov@gmail.com>
References: <20210721000822.40958-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

CO-RE processing functions don't need to know 'struct bpf_program' details.
Cleanup the layering to eventually be able to move CO-RE logic into a separate file.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/libbpf.c | 74 ++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4c153c379989..57af20574f06 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5611,7 +5611,7 @@ static int bpf_core_spec_match(struct bpf_core_spec *local_spec,
 	return 1;
 }
 
-static int bpf_core_calc_field_relo(const struct bpf_program *prog,
+static int bpf_core_calc_field_relo(const char *prog_name,
 				    const struct bpf_core_relo *relo,
 				    const struct bpf_core_spec *spec,
 				    __u32 *val, __u32 *field_sz, __u32 *type_id,
@@ -5655,7 +5655,7 @@ static int bpf_core_calc_field_relo(const struct bpf_program *prog,
 			*val = sz;
 		} else {
 			pr_warn("prog '%s': relo %d at insn #%d can't be applied to array access\n",
-				prog->name, relo->kind, relo->insn_off / 8);
+				prog_name, relo->kind, relo->insn_off / 8);
 			return -EINVAL;
 		}
 		if (validate)
@@ -5677,7 +5677,7 @@ static int bpf_core_calc_field_relo(const struct bpf_program *prog,
 			if (byte_sz >= 8) {
 				/* bitfield can't be read with 64-bit read */
 				pr_warn("prog '%s': relo %d at insn #%d can't be satisfied for bitfield\n",
-					prog->name, relo->kind, relo->insn_off / 8);
+					prog_name, relo->kind, relo->insn_off / 8);
 				return -E2BIG;
 			}
 			byte_sz *= 2;
@@ -5827,7 +5827,7 @@ struct bpf_core_relo_res
  * with each other. Otherwise, libbpf will refuse to proceed due to ambiguity.
  * If instruction has to be poisoned, *poison will be set to true.
  */
-static int bpf_core_calc_relo(const struct bpf_program *prog,
+static int bpf_core_calc_relo(const char *prog_name,
 			      const struct bpf_core_relo *relo,
 			      int relo_idx,
 			      const struct bpf_core_spec *local_spec,
@@ -5845,10 +5845,10 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
 	res->orig_type_id = res->new_type_id = 0;
 
 	if (core_relo_is_field_based(relo->kind)) {
-		err = bpf_core_calc_field_relo(prog, relo, local_spec,
+		err = bpf_core_calc_field_relo(prog_name, relo, local_spec,
 					       &res->orig_val, &res->orig_sz,
 					       &res->orig_type_id, &res->validate);
-		err = err ?: bpf_core_calc_field_relo(prog, relo, targ_spec,
+		err = err ?: bpf_core_calc_field_relo(prog_name, relo, targ_spec,
 						      &res->new_val, &res->new_sz,
 						      &res->new_type_id, NULL);
 		if (err)
@@ -5906,7 +5906,7 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
 	} else if (err == -EOPNOTSUPP) {
 		/* EOPNOTSUPP means unknown/unsupported relocation */
 		pr_warn("prog '%s': relo #%d: unrecognized CO-RE relocation %s (%d) at insn #%d\n",
-			prog->name, relo_idx, core_relo_kind_str(relo->kind),
+			prog_name, relo_idx, core_relo_kind_str(relo->kind),
 			relo->kind, relo->insn_off / 8);
 	}
 
@@ -5917,11 +5917,11 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
  * Turn instruction for which CO_RE relocation failed into invalid one with
  * distinct signature.
  */
-static void bpf_core_poison_insn(struct bpf_program *prog, int relo_idx,
+static void bpf_core_poison_insn(const char *prog_name, int relo_idx,
 				 int insn_idx, struct bpf_insn *insn)
 {
 	pr_debug("prog '%s': relo #%d: substituting insn #%d w/ invalid insn\n",
-		 prog->name, relo_idx, insn_idx);
+		 prog_name, relo_idx, insn_idx);
 	insn->code = BPF_JMP | BPF_CALL;
 	insn->dst_reg = 0;
 	insn->src_reg = 0;
@@ -5977,6 +5977,7 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
 			       int relo_idx,
 			       const struct bpf_core_relo_res *res)
 {
+	const char *prog_name = prog->name;
 	__u32 orig_val, new_val;
 	struct bpf_insn *insn;
 	int insn_idx;
@@ -5999,8 +6000,8 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
 		 * verifier about "unknown opcode 00"
 		 */
 		if (is_ldimm64_insn(insn))
-			bpf_core_poison_insn(prog, relo_idx, insn_idx + 1, insn + 1);
-		bpf_core_poison_insn(prog, relo_idx, insn_idx, insn);
+			bpf_core_poison_insn(prog_name, relo_idx, insn_idx + 1, insn + 1);
+		bpf_core_poison_insn(prog_name, relo_idx, insn_idx, insn);
 		return 0;
 	}
 
@@ -6014,14 +6015,14 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
 			return -EINVAL;
 		if (res->validate && insn->imm != orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (ALU/ALU64) value: got %u, exp %u -> %u\n",
-				prog->name, relo_idx,
+				prog_name, relo_idx,
 				insn_idx, insn->imm, orig_val, new_val);
 			return -EINVAL;
 		}
 		orig_val = insn->imm;
 		insn->imm = new_val;
 		pr_debug("prog '%s': relo #%d: patched insn #%d (ALU/ALU64) imm %u -> %u\n",
-			 prog->name, relo_idx, insn_idx,
+			 prog_name, relo_idx, insn_idx,
 			 orig_val, new_val);
 		break;
 	case BPF_LDX:
@@ -6029,25 +6030,25 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
 	case BPF_STX:
 		if (res->validate && insn->off != orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDX/ST/STX) value: got %u, exp %u -> %u\n",
-				prog->name, relo_idx, insn_idx, insn->off, orig_val, new_val);
+				prog_name, relo_idx, insn_idx, insn->off, orig_val, new_val);
 			return -EINVAL;
 		}
 		if (new_val > SHRT_MAX) {
 			pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) value too big: %u\n",
-				prog->name, relo_idx, insn_idx, new_val);
+				prog_name, relo_idx, insn_idx, new_val);
 			return -ERANGE;
 		}
 		if (res->fail_memsz_adjust) {
 			pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) accesses field incorrectly. "
 				"Make sure you are accessing pointers, unsigned integers, or fields of matching type and size.\n",
-				prog->name, relo_idx, insn_idx);
+				prog_name, relo_idx, insn_idx);
 			goto poison;
 		}
 
 		orig_val = insn->off;
 		insn->off = new_val;
 		pr_debug("prog '%s': relo #%d: patched insn #%d (LDX/ST/STX) off %u -> %u\n",
-			 prog->name, relo_idx, insn_idx, orig_val, new_val);
+			 prog_name, relo_idx, insn_idx, orig_val, new_val);
 
 		if (res->new_sz != res->orig_sz) {
 			int insn_bytes_sz, insn_bpf_sz;
@@ -6055,20 +6056,20 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
 			insn_bytes_sz = insn_bpf_size_to_bytes(insn);
 			if (insn_bytes_sz != res->orig_sz) {
 				pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) unexpected mem size: got %d, exp %u\n",
-					prog->name, relo_idx, insn_idx, insn_bytes_sz, res->orig_sz);
+					prog_name, relo_idx, insn_idx, insn_bytes_sz, res->orig_sz);
 				return -EINVAL;
 			}
 
 			insn_bpf_sz = insn_bytes_to_bpf_size(res->new_sz);
 			if (insn_bpf_sz < 0) {
 				pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) invalid new mem size: %u\n",
-					prog->name, relo_idx, insn_idx, res->new_sz);
+					prog_name, relo_idx, insn_idx, res->new_sz);
 				return -EINVAL;
 			}
 
 			insn->code = BPF_MODE(insn->code) | insn_bpf_sz | BPF_CLASS(insn->code);
 			pr_debug("prog '%s': relo #%d: patched insn #%d (LDX/ST/STX) mem_sz %u -> %u\n",
-				 prog->name, relo_idx, insn_idx, res->orig_sz, res->new_sz);
+				 prog_name, relo_idx, insn_idx, res->orig_sz, res->new_sz);
 		}
 		break;
 	case BPF_LD: {
@@ -6080,14 +6081,14 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
 		    insn[1].code != 0 || insn[1].dst_reg != 0 ||
 		    insn[1].src_reg != 0 || insn[1].off != 0) {
 			pr_warn("prog '%s': relo #%d: insn #%d (LDIMM64) has unexpected form\n",
-				prog->name, relo_idx, insn_idx);
+				prog_name, relo_idx, insn_idx);
 			return -EINVAL;
 		}
 
 		imm = insn[0].imm + ((__u64)insn[1].imm << 32);
 		if (res->validate && imm != orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDIMM64) value: got %llu, exp %u -> %u\n",
-				prog->name, relo_idx,
+				prog_name, relo_idx,
 				insn_idx, (unsigned long long)imm,
 				orig_val, new_val);
 			return -EINVAL;
@@ -6096,13 +6097,13 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
 		insn[0].imm = new_val;
 		insn[1].imm = 0; /* currently only 32-bit values are supported */
 		pr_debug("prog '%s': relo #%d: patched insn #%d (LDIMM64) imm64 %llu -> %u\n",
-			 prog->name, relo_idx, insn_idx,
+			 prog_name, relo_idx, insn_idx,
 			 (unsigned long long)imm, new_val);
 		break;
 	}
 	default:
 		pr_warn("prog '%s': relo #%d: trying to relocate unrecognized insn #%d, code:0x%x, src:0x%x, dst:0x%x, off:0x%x, imm:0x%x\n",
-			prog->name, relo_idx, insn_idx, insn->code,
+			prog_name, relo_idx, insn_idx, insn->code,
 			insn->src_reg, insn->dst_reg, insn->off, insn->imm);
 		return -EINVAL;
 	}
@@ -6238,6 +6239,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	const struct btf_type *local_type;
 	const char *local_name;
 	struct core_cand_list *cands = NULL;
+	const char *prog_name = prog->name;
 	__u32 local_id;
 	const char *spec_str;
 	int i, j, err;
@@ -6264,13 +6266,13 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	err = bpf_core_parse_spec(local_btf, local_id, spec_str, relo->kind, &local_spec);
 	if (err) {
 		pr_warn("prog '%s': relo #%d: parsing [%d] %s %s + %s failed: %d\n",
-			prog->name, relo_idx, local_id, btf_kind_str(local_type),
+			prog_name, relo_idx, local_id, btf_kind_str(local_type),
 			str_is_empty(local_name) ? "<anon>" : local_name,
 			spec_str, err);
 		return -EINVAL;
 	}
 
-	pr_debug("prog '%s': relo #%d: kind <%s> (%d), spec is ", prog->name,
+	pr_debug("prog '%s': relo #%d: kind <%s> (%d), spec is ", prog_name,
 		 relo_idx, core_relo_kind_str(relo->kind), relo->kind);
 	bpf_core_dump_spec(LIBBPF_DEBUG, &local_spec);
 	libbpf_print(LIBBPF_DEBUG, "\n");
@@ -6287,7 +6289,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	/* libbpf doesn't support candidate search for anonymous types */
 	if (str_is_empty(spec_str)) {
 		pr_warn("prog '%s': relo #%d: <%s> (%d) relocation doesn't support anonymous types\n",
-			prog->name, relo_idx, core_relo_kind_str(relo->kind), relo->kind);
+			prog_name, relo_idx, core_relo_kind_str(relo->kind), relo->kind);
 		return -EOPNOTSUPP;
 	}
 
@@ -6295,7 +6297,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 		cands = bpf_core_find_cands(prog->obj, local_btf, local_id);
 		if (IS_ERR(cands)) {
 			pr_warn("prog '%s': relo #%d: target candidate search failed for [%d] %s %s: %ld\n",
-				prog->name, relo_idx, local_id, btf_kind_str(local_type),
+				prog_name, relo_idx, local_id, btf_kind_str(local_type),
 				local_name, PTR_ERR(cands));
 			return PTR_ERR(cands);
 		}
@@ -6311,13 +6313,13 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 					  cands->cands[i].id, &cand_spec);
 		if (err < 0) {
 			pr_warn("prog '%s': relo #%d: error matching candidate #%d ",
-				prog->name, relo_idx, i);
+				prog_name, relo_idx, i);
 			bpf_core_dump_spec(LIBBPF_WARN, &cand_spec);
 			libbpf_print(LIBBPF_WARN, ": %d\n", err);
 			return err;
 		}
 
-		pr_debug("prog '%s': relo #%d: %s candidate #%d ", prog->name,
+		pr_debug("prog '%s': relo #%d: %s candidate #%d ", prog_name,
 			 relo_idx, err == 0 ? "non-matching" : "matching", i);
 		bpf_core_dump_spec(LIBBPF_DEBUG, &cand_spec);
 		libbpf_print(LIBBPF_DEBUG, "\n");
@@ -6325,7 +6327,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 		if (err == 0)
 			continue;
 
-		err = bpf_core_calc_relo(prog, relo, relo_idx, &local_spec, &cand_spec, &cand_res);
+		err = bpf_core_calc_relo(prog_name, relo, relo_idx, &local_spec, &cand_spec, &cand_res);
 		if (err)
 			return err;
 
@@ -6337,7 +6339,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 			 * should all resolve to the same bit offset
 			 */
 			pr_warn("prog '%s': relo #%d: field offset ambiguity: %u != %u\n",
-				prog->name, relo_idx, cand_spec.bit_offset,
+				prog_name, relo_idx, cand_spec.bit_offset,
 				targ_spec.bit_offset);
 			return -EINVAL;
 		} else if (cand_res.poison != targ_res.poison || cand_res.new_val != targ_res.new_val) {
@@ -6346,7 +6348,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 			 * proceed due to ambiguity
 			 */
 			pr_warn("prog '%s': relo #%d: relocation decision ambiguity: %s %u != %s %u\n",
-				prog->name, relo_idx,
+				prog_name, relo_idx,
 				cand_res.poison ? "failure" : "success", cand_res.new_val,
 				targ_res.poison ? "failure" : "success", targ_res.new_val);
 			return -EINVAL;
@@ -6379,10 +6381,10 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	 */
 	if (j == 0) {
 		pr_debug("prog '%s': relo #%d: no matching targets found\n",
-			 prog->name, relo_idx);
+			 prog_name, relo_idx);
 
 		/* calculate single target relo result explicitly */
-		err = bpf_core_calc_relo(prog, relo, relo_idx, &local_spec, NULL, &targ_res);
+		err = bpf_core_calc_relo(prog_name, relo, relo_idx, &local_spec, NULL, &targ_res);
 		if (err)
 			return err;
 	}
@@ -6392,7 +6394,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	err = bpf_core_patch_insn(prog, relo, relo_idx, &targ_res);
 	if (err) {
 		pr_warn("prog '%s': relo #%d: failed to patch insn #%zu: %d\n",
-			prog->name, relo_idx, relo->insn_off / BPF_INSN_SZ, err);
+			prog_name, relo_idx, relo->insn_off / BPF_INSN_SZ, err);
 		return -EINVAL;
 	}
 
-- 
2.30.2

