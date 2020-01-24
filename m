Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11957147837
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 06:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbgAXFiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 00:38:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15212 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730375AbgAXFiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 00:38:46 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00O5YnMo001843
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 21:38:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=gpKitsC2svcScWSg6sdiyrsGYyJimxgu7wVCzGxaDJA=;
 b=ILD5YIft3i4QkbJcbaDQQsP8wf8pvlvqn6qOrOp+edEgYo4AECHVqab6q83mtsdz3xT3
 twylAo39r+kfXfHhJx8k/pqX0p1vgrAfjL//5dF2epzGRavrrcxaMc3PuPNM2I9RU45j
 5AspdJ5YWRC5m9rB/pGAj7jzNxawAIX2Tpg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xqne4121b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 21:38:45 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 21:38:43 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A38542EC1D8F; Thu, 23 Jan 2020 21:38:39 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: improve handling of failed CO-RE relocations
Date:   Thu, 23 Jan 2020 21:38:37 -0800
Message-ID: <20200124053837.2434679-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_01:2020-01-23,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 suspectscore=8 impostorscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001240043
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, if libbpf failed to resolve CO-RE relocation for some
instructions, it would either return error immediately, or, if
.relaxed_core_relocs option was set, would replace relocatable offset/imm part
of an instruction with a bogus value (-1). Neither approach is good, because
there are many possible scenarios where relocation is expected to fail (e.g.,
when some field knowingly can be missing on specific kernel versions). On the
other hand, replacing offset with invalid one can hide programmer errors, if
this relocation failue wasn't anticipated.

This patch deprecates .relaxed_core_relocs option and changes the approach to
always replacing instruction, for which relocation failed, with invalid BPF
helper call instruction. For cases where this is expected, BPF program should
already ensure that that instruction is unreachable, in which case this
invalid instruction is going to be silently ignored. But if instruction wasn't
guarded, BPF program will be rejected at verification step with verifier log
pointing precisely to the place in assembly where the problem is.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 95 +++++++++++++++++++++++++-----------------
 tools/lib/bpf/libbpf.h |  6 ++-
 2 files changed, 61 insertions(+), 40 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ae34b681ae82..39f1b7633a7c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -345,7 +345,6 @@ struct bpf_object {
 
 	bool loaded;
 	bool has_pseudo_calls;
-	bool relaxed_core_relocs;
 
 	/*
 	 * Information when doing elf related work. Only valid if fd
@@ -4238,25 +4237,38 @@ static int bpf_core_calc_field_relo(const struct bpf_program *prog,
  */
 static int bpf_core_reloc_insn(struct bpf_program *prog,
 			       const struct bpf_field_reloc *relo,
+			       int relo_idx,
 			       const struct bpf_core_spec *local_spec,
 			       const struct bpf_core_spec *targ_spec)
 {
-	bool failed = false, validate = true;
 	__u32 orig_val, new_val;
 	struct bpf_insn *insn;
+	bool validate = true;
 	int insn_idx, err;
 	__u8 class;
 
 	if (relo->insn_off % sizeof(struct bpf_insn))
 		return -EINVAL;
 	insn_idx = relo->insn_off / sizeof(struct bpf_insn);
+	insn = &prog->insns[insn_idx];
+	class = BPF_CLASS(insn->code);
 
 	if (relo->kind == BPF_FIELD_EXISTS) {
 		orig_val = 1; /* can't generate EXISTS relo w/o local field */
 		new_val = targ_spec ? 1 : 0;
 	} else if (!targ_spec) {
-		failed = true;
-		new_val = (__u32)-1;
+		pr_debug("prog '%s': relo #%d: substituting insn #%d w/ invalid insn\n",
+			 bpf_program__title(prog, false), relo_idx, insn_idx);
+		insn->code = BPF_JMP | BPF_CALL;
+		insn->dst_reg = 0;
+		insn->src_reg = 0;
+		insn->off = 0;
+		/* if this instruction is reachable (not a dead code),
+		 * verifier will complain with the following message:
+		 * invalid func unknown#195896080
+		 */
+		insn->imm = 195896080; /* => 0xbad2310 => "bad relo" */
+		return 0;
 	} else {
 		err = bpf_core_calc_field_relo(prog, relo, local_spec,
 					       &orig_val, &validate);
@@ -4268,50 +4280,47 @@ static int bpf_core_reloc_insn(struct bpf_program *prog,
 			return err;
 	}
 
-	insn = &prog->insns[insn_idx];
-	class = BPF_CLASS(insn->code);
-
 	switch (class) {
 	case BPF_ALU:
 	case BPF_ALU64:
 		if (BPF_SRC(insn->code) != BPF_K)
 			return -EINVAL;
-		if (!failed && validate && insn->imm != orig_val) {
-			pr_warn("prog '%s': unexpected insn #%d (ALU/ALU64) value: got %u, exp %u -> %u\n",
-				bpf_program__title(prog, false), insn_idx,
-				insn->imm, orig_val, new_val);
+		if (validate && insn->imm != orig_val) {
+			pr_warn("prog '%s': relo #%d: unexpected insn #%d (ALU/ALU64) value: got %u, exp %u -> %u\n",
+				bpf_program__title(prog, false), relo_idx,
+				insn_idx, insn->imm, orig_val, new_val);
 			return -EINVAL;
 		}
 		orig_val = insn->imm;
 		insn->imm = new_val;
-		pr_debug("prog '%s': patched insn #%d (ALU/ALU64)%s imm %u -> %u\n",
-			 bpf_program__title(prog, false), insn_idx,
-			 failed ? " w/ failed reloc" : "", orig_val, new_val);
+		pr_debug("prog '%s': relo #%d: patched insn #%d (ALU/ALU64) imm %u -> %u\n",
+			 bpf_program__title(prog, false), relo_idx, insn_idx,
+			 orig_val, new_val);
 		break;
 	case BPF_LDX:
 	case BPF_ST:
 	case BPF_STX:
-		if (!failed && validate && insn->off != orig_val) {
-			pr_warn("prog '%s': unexpected insn #%d (LD/LDX/ST/STX) value: got %u, exp %u -> %u\n",
-				bpf_program__title(prog, false), insn_idx,
-				insn->off, orig_val, new_val);
+		if (validate && insn->off != orig_val) {
+			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LD/LDX/ST/STX) value: got %u, exp %u -> %u\n",
+				bpf_program__title(prog, false), relo_idx,
+				insn_idx, insn->off, orig_val, new_val);
 			return -EINVAL;
 		}
 		if (new_val > SHRT_MAX) {
-			pr_warn("prog '%s': insn #%d (LD/LDX/ST/STX) value too big: %u\n",
-				bpf_program__title(prog, false), insn_idx,
-				new_val);
+			pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) value too big: %u\n",
+				bpf_program__title(prog, false), relo_idx,
+				insn_idx, new_val);
 			return -ERANGE;
 		}
 		orig_val = insn->off;
 		insn->off = new_val;
-		pr_debug("prog '%s': patched insn #%d (LD/LDX/ST/STX)%s off %u -> %u\n",
-			 bpf_program__title(prog, false), insn_idx,
-			 failed ? " w/ failed reloc" : "", orig_val, new_val);
+		pr_debug("prog '%s': relo #%d: patched insn #%d (LDX/ST/STX) off %u -> %u\n",
+			 bpf_program__title(prog, false), relo_idx, insn_idx,
+			 orig_val, new_val);
 		break;
 	default:
-		pr_warn("prog '%s': trying to relocate unrecognized insn #%d, code:%x, src:%x, dst:%x, off:%x, imm:%x\n",
-			bpf_program__title(prog, false),
+		pr_warn("prog '%s': relo #%d: trying to relocate unrecognized insn #%d, code:%x, src:%x, dst:%x, off:%x, imm:%x\n",
+			bpf_program__title(prog, false), relo_idx,
 			insn_idx, insn->code, insn->src_reg, insn->dst_reg,
 			insn->off, insn->imm);
 		return -EINVAL;
@@ -4510,24 +4519,33 @@ static int bpf_core_reloc_field(struct bpf_program *prog,
 	}
 
 	/*
-	 * For BPF_FIELD_EXISTS relo or when relaxed CO-RE reloc mode is
-	 * requested, it's expected that we might not find any candidates.
-	 * In this case, if field wasn't found in any candidate, the list of
-	 * candidates shouldn't change at all, we'll just handle relocating
-	 * appropriately, depending on relo's kind.
+	 * For BPF_FIELD_EXISTS relo or when used BPF program has field
+	 * existence checks or kernel version/config checks, it's expected
+	 * that we might not find any candidates. In this case, if field
+	 * wasn't found in any candidate, the list of candidates shouldn't
+	 * change at all, we'll just handle relocating appropriately,
+	 * depending on relo's kind.
 	 */
 	if (j > 0)
 		cand_ids->len = j;
 
-	if (j == 0 && !prog->obj->relaxed_core_relocs &&
-	    relo->kind != BPF_FIELD_EXISTS) {
-		pr_warn("prog '%s': relo #%d: no matching targets found for [%d] %s + %s\n",
-			prog_name, relo_idx, local_id, local_name, spec_str);
-		return -ESRCH;
-	}
+	/*
+	 * If no candidates were found, it might be both a programmer error,
+	 * as well as expected case, depending whether instruction w/
+	 * relocation is guarded in some way that makes it unreachable (dead
+	 * code) if relocation can't be resolved. This is handled in
+	 * bpf_core_reloc_insn() uniformly by replacing that instruction with
+	 * BPF helper call insn (using invalid helper ID). If that instruction
+	 * is indeed unreachable, then it will be ignored and eliminated by
+	 * verifier. If it was an error, then verifier will complain and point
+	 * to a specific instruction number in its log.
+	 */
+	if (j == 0)
+		pr_debug("prog '%s': relo #%d: no matching targets found for [%d] %s + %s\n",
+			 prog_name, relo_idx, local_id, local_name, spec_str);
 
 	/* bpf_core_reloc_insn should know how to handle missing targ_spec */
-	err = bpf_core_reloc_insn(prog, relo, &local_spec,
+	err = bpf_core_reloc_insn(prog, relo, relo_idx, &local_spec,
 				  j ? &targ_spec : NULL);
 	if (err) {
 		pr_warn("prog '%s': relo #%d: failed to patch insn at offset %d: %d\n",
@@ -5057,7 +5075,6 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	if (IS_ERR(obj))
 		return obj;
 
-	obj->relaxed_core_relocs = OPTS_GET(opts, relaxed_core_relocs, false);
 	kconfig = OPTS_GET(opts, kconfig, NULL);
 	if (kconfig) {
 		obj->kconfig = strdup(kconfig);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 2a5e3b087002..3fe12c9d1f92 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -77,7 +77,11 @@ struct bpf_object_open_opts {
 	const char *object_name;
 	/* parse map definitions non-strictly, allowing extra attributes/data */
 	bool relaxed_maps;
-	/* process CO-RE relocations non-strictly, allowing them to fail */
+	/* DEPRECATED: handle CO-RE relocations non-strictly, allowing failures.
+	 * Value is ignored. Relocations always are processed non-strictly.
+	 * Non-relocatable instructions are replaced with invalid ones to
+	 * prevent accidental errors.
+	 * */
 	bool relaxed_core_relocs;
 	/* maps that set the 'pinning' attribute in their definition will have
 	 * their pin_path attribute set to a file in this directory, and be
-- 
2.17.1

