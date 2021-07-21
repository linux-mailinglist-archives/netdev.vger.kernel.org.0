Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC903D0616
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 02:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhGTX2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 19:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbhGTX14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 19:27:56 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E401C061766;
        Tue, 20 Jul 2021 17:08:33 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gx2so642992pjb.5;
        Tue, 20 Jul 2021 17:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=23OGjKPb+9sB1yzxSNv30nOcf9KZbnh75M6FzI+C6f0=;
        b=OlArwQT2DgkZeiweg7k4hqxsftpx7bOyPPYFlaa+6Nj1i/2j5xR4Jxjv+bRZFCqBI+
         7R9AZorcsGU4+6HMwtm3i1JgGtUkuEnFtK3w72ovZ/A2kAnN5Tb7+6GNCE+FA0dED2Wt
         rNnOaqYGGyDJ2c1itabJmfb9Y8fCl19/onl6B0ozPs1fPBkKyp+FLAVnY0eGjYAUQNLM
         eLeoXYURSLoHWQDzC3ATaVuO90wTWmNT/UEtn1i7YY8W5/zKMNZ76mfty5aoaf9U++jV
         axLApWQNpOfsKcsYFsl+0radg9DNvf6sTFioyaBHMMnkALOLrPg/LXdcfM43gmYWeSC9
         wTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=23OGjKPb+9sB1yzxSNv30nOcf9KZbnh75M6FzI+C6f0=;
        b=qUhwQKzxSjwuymgdheK4hfF2q9zDltKKl8lOpbpgDKZ+fg9qnQWcLmdI8epM1d5XmM
         ZaRuLqC5UE1twwc3p66rdSq8V3Xi4t8NMyBuY02D2Mu5xEC8pjjo+QFurRGRS2siM3LX
         V1FrFjZGBvF8X5Uukw8RYNvPkQSMpA5uy523GGjeKDuXQw5I16peB2PpKfMMk0/uv5PH
         UWOLH5Er4cpVEKY6IAFyHe+KZu9abqVT/Vq4W13FgZBJKNNuUFo5aOwp5I45cqw5sIEE
         PYeTUQgUL/eYv3LE52iPJDeaO87DHFmF2jqmdWURY6Qvs63Wu68MhYIvs6sx12EKy1yV
         Gq7Q==
X-Gm-Message-State: AOAM532hy2/ouLmh8WQowfh6Tq8uOskgvRAyutfwiykdviQkzvCZZOn2
        aYLlRQbJ0W95tkbBeaIaZIa9eqK7GW0=
X-Google-Smtp-Source: ABdhPJxKMbWYQA1lwELJ980Yxt7c69izsyFmOMiXDAlTAarQwHXoQKyI6L8RY4JzJJhJoQBWKHm6LA==
X-Received: by 2002:a17:90a:1941:: with SMTP id 1mr948268pjh.217.1626826112171;
        Tue, 20 Jul 2021 17:08:32 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:500::6:4ad3])
        by smtp.gmail.com with ESMTPSA id d15sm24356841pfl.82.2021.07.20.17.08.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Jul 2021 17:08:31 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 2/4] libbpf: Split bpf_core_apply_relo() into bpf_program indepdent helper.
Date:   Tue, 20 Jul 2021 17:08:20 -0700
Message-Id: <20210721000822.40958-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210721000822.40958-1-alexei.starovoitov@gmail.com>
References: <20210721000822.40958-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

bpf_core_apply_relo() doesn't need to know bpf_program internals
and hashmap details.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/libbpf.c | 117 +++++++++++++++++++++++++----------------
 1 file changed, 71 insertions(+), 46 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 57af20574f06..4f71b4218f14 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5972,26 +5972,13 @@ static int insn_bytes_to_bpf_size(__u32 sz)
  * 5. *(T *)(rX + <off>) = rY, where T is one of {u8, u16, u32, u64};
  * 6. *(T *)(rX + <off>) = <imm>, where T is one of {u8, u16, u32, u64}.
  */
-static int bpf_core_patch_insn(struct bpf_program *prog,
-			       const struct bpf_core_relo *relo,
-			       int relo_idx,
-			       const struct bpf_core_relo_res *res)
+static int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
+			       int insn_idx, const struct bpf_core_relo *relo,
+			       int relo_idx, const struct bpf_core_relo_res *res)
 {
-	const char *prog_name = prog->name;
 	__u32 orig_val, new_val;
-	struct bpf_insn *insn;
-	int insn_idx;
 	__u8 class;
 
-	if (relo->insn_off % BPF_INSN_SZ)
-		return -EINVAL;
-	insn_idx = relo->insn_off / BPF_INSN_SZ;
-	/* adjust insn_idx from section frame of reference to the local
-	 * program's frame of reference; (sub-)program code is not yet
-	 * relocated, so it's enough to just subtract in-section offset
-	 */
-	insn_idx = insn_idx - prog->sec_insn_off;
-	insn = &prog->insns[insn_idx];
 	class = BPF_CLASS(insn->code);
 
 	if (res->poison) {
@@ -6077,7 +6064,6 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
 
 		if (!is_ldimm64_insn(insn) ||
 		    insn[0].src_reg != 0 || insn[0].off != 0 ||
-		    insn_idx + 1 >= prog->insns_cnt ||
 		    insn[1].code != 0 || insn[1].dst_reg != 0 ||
 		    insn[1].src_reg != 0 || insn[1].off != 0) {
 			pr_warn("prog '%s': relo #%d: insn #%d (LDIMM64) has unexpected form\n",
@@ -6227,19 +6213,17 @@ static void *u32_as_hash_key(__u32 x)
  *    between multiple relocations for the same type ID and is updated as some
  *    of the candidates are pruned due to structural incompatibility.
  */
-static int bpf_core_apply_relo(struct bpf_program *prog,
-			       const struct bpf_core_relo *relo,
-			       int relo_idx,
-			       const struct btf *local_btf,
-			       struct hashmap *cand_cache)
+static int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
+				    int insn_idx,
+				    const struct bpf_core_relo *relo,
+				    int relo_idx,
+				    const struct btf *local_btf,
+				    struct core_cand_list *cands)
 {
 	struct bpf_core_spec local_spec, cand_spec, targ_spec = {};
-	const void *type_key = u32_as_hash_key(relo->type_id);
 	struct bpf_core_relo_res cand_res, targ_res;
 	const struct btf_type *local_type;
 	const char *local_name;
-	struct core_cand_list *cands = NULL;
-	const char *prog_name = prog->name;
 	__u32 local_id;
 	const char *spec_str;
 	int i, j, err;
@@ -6257,12 +6241,6 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	if (str_is_empty(spec_str))
 		return -EINVAL;
 
-	if (prog->obj->gen_loader) {
-		pr_warn("// TODO core_relo: prog %td insn[%d] %s %s kind %d\n",
-			prog - prog->obj->programs, relo->insn_off / 8,
-			local_name, spec_str, relo->kind);
-		return -ENOTSUP;
-	}
 	err = bpf_core_parse_spec(local_btf, local_id, spec_str, relo->kind, &local_spec);
 	if (err) {
 		pr_warn("prog '%s': relo #%d: parsing [%d] %s %s + %s failed: %d\n",
@@ -6293,20 +6271,6 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 		return -EOPNOTSUPP;
 	}
 
-	if (!hashmap__find(cand_cache, type_key, (void **)&cands)) {
-		cands = bpf_core_find_cands(prog->obj, local_btf, local_id);
-		if (IS_ERR(cands)) {
-			pr_warn("prog '%s': relo #%d: target candidate search failed for [%d] %s %s: %ld\n",
-				prog_name, relo_idx, local_id, btf_kind_str(local_type),
-				local_name, PTR_ERR(cands));
-			return PTR_ERR(cands);
-		}
-		err = hashmap__set(cand_cache, type_key, cands, NULL, NULL);
-		if (err) {
-			bpf_core_free_cands(cands);
-			return err;
-		}
-	}
 
 	for (i = 0, j = 0; i < cands->len; i++) {
 		err = bpf_core_spec_match(&local_spec, cands->cands[i].btf,
@@ -6391,7 +6355,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 
 patch_insn:
 	/* bpf_core_patch_insn() should know how to handle missing targ_spec */
-	err = bpf_core_patch_insn(prog, relo, relo_idx, &targ_res);
+	err = bpf_core_patch_insn(prog_name, insn, insn_idx, relo, relo_idx, &targ_res);
 	if (err) {
 		pr_warn("prog '%s': relo #%d: failed to patch insn #%zu: %d\n",
 			prog_name, relo_idx, relo->insn_off / BPF_INSN_SZ, err);
@@ -6401,6 +6365,67 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	return 0;
 }
 
+static int bpf_core_apply_relo(struct bpf_program *prog,
+			       const struct bpf_core_relo *relo,
+			       int relo_idx,
+			       const struct btf *local_btf,
+			       struct hashmap *cand_cache)
+{
+	const void *type_key = u32_as_hash_key(relo->type_id);
+	struct core_cand_list *cands = NULL;
+	const char *prog_name = prog->name;
+	const struct btf_type *local_type;
+	const char *local_name;
+	__u32 local_id = relo->type_id;
+	struct bpf_insn *insn;
+	int insn_idx, err;
+
+	if (relo->insn_off % BPF_INSN_SZ)
+		return -EINVAL;
+	insn_idx = relo->insn_off / BPF_INSN_SZ;
+	/* adjust insn_idx from section frame of reference to the local
+	 * program's frame of reference; (sub-)program code is not yet
+	 * relocated, so it's enough to just subtract in-section offset
+	 */
+	insn_idx = insn_idx - prog->sec_insn_off;
+	if (insn_idx > prog->insns_cnt)
+		return -EINVAL;
+	insn = &prog->insns[insn_idx];
+
+	local_type = btf__type_by_id(local_btf, local_id);
+	if (!local_type)
+		return -EINVAL;
+
+	local_name = btf__name_by_offset(local_btf, local_type->name_off);
+	if (!local_name)
+		return -EINVAL;
+
+	if (prog->obj->gen_loader) {
+		pr_warn("// TODO core_relo: prog %td insn[%d] %s kind %d\n",
+			prog - prog->obj->programs, relo->insn_off / 8,
+			local_name, relo->kind);
+		return -ENOTSUP;
+	}
+
+	if (relo->kind != BPF_TYPE_ID_LOCAL &&
+	    !hashmap__find(cand_cache, type_key, (void **)&cands)) {
+		cands = bpf_core_find_cands(prog->obj, local_btf, local_id);
+		if (IS_ERR(cands)) {
+			pr_warn("prog '%s': relo #%d: target candidate search failed for [%d] %s %s: %ld\n",
+				prog_name, relo_idx, local_id, btf_kind_str(local_type),
+				local_name, PTR_ERR(cands));
+			return PTR_ERR(cands);
+		}
+		err = hashmap__set(cand_cache, type_key, cands, NULL, NULL);
+		if (err) {
+			bpf_core_free_cands(cands);
+			return err;
+		}
+	}
+
+	return bpf_core_apply_relo_insn(prog_name, insn, insn_idx, relo, relo_idx, local_btf, cands);
+}
+
 static int
 bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 {
-- 
2.30.2

