Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03553479475
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240467AbhLQS5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240567AbhLQS5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 13:57:05 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C0FC06173F
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 10:57:05 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id a14so6222609uak.0
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 10:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=igWWpEe5MAQvcBbmdLN5vO3AN2tXnobBBKMBqsURkL4=;
        b=bLaUqUKw5cpQ7ZnRNiuguWiqsSLk7bUF7lxRma0UDh+DTwXpEN4ZOOKJZK8wW2uJQ2
         6XduWaqSUkbycqO3gLq5OyZVNrOZYrtMtYHeA6KSmCWWXFJFvDy0yZ/EQcgaoc5+VWtD
         XDY8D/5zOKEswZM4505lDoGtcCfrAvjNw752U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=igWWpEe5MAQvcBbmdLN5vO3AN2tXnobBBKMBqsURkL4=;
        b=DN0qbkSbnKm4l3pKvJg3R5w0UJEhqW9rvAMrHegmfzvL4jDPhKJRqhw8r8ssJAdR8J
         LIJTW6y4sfseReBXUCkuvmj+qoltX7ZvMDjvD0nCYW3WBTEjyfEjfj+poMexxz7MDYVD
         LZ2tcdolHJMKMFJiL6qw3shtmDIrcx/gY94Jy5XA3Lxh8qVjFpkPwcR6hHKyNTyuOt6u
         d6oDOCKoO+gTJyRRH96eeafRGjiBkuttlvb8W7CbpDNwpa2dL8n2KJ71xNIKGVJzTs1r
         v8AqEfQo8d+lpajiekFNcmg37+kedFaj0j93y7LT6uNqw9MD+SX1tN7ulbS6WB54e1sz
         fLDA==
X-Gm-Message-State: AOAM530opLiUqWab7YcDhiVkXtxxzv6WSKOC1ETWi+CFGl6QMfSEfgcS
        OaqXL8PVx5RVGqhn7gEP87jSIPWkNHsIWhfXIqZJMgumME8KRYwTaU8v1vmtRC2SZc0qx6vS/9J
        WF8zTYlPSq3PQ0K8lpt+Wn+whFqWSoSzd5IhuRVsI3cEE3GgLFfUkhBJJGN4B0zw6XG0iaA==
X-Google-Smtp-Source: ABdhPJwzHi0uO/EaSJ9HgWYbGJ7ordqs0D4gI6+b8G3fsnin7TsZf/OrdEY4tQPJgCWlvzJA/k1mAA==
X-Received: by 2002:ab0:15af:: with SMTP id i44mr1745086uae.17.1639767421492;
        Fri, 17 Dec 2021 10:57:01 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id l125sm1382575vke.40.2021.12.17.10.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 10:57:01 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v3 1/3] libbpf: split bpf_core_apply_relo()
Date:   Fri, 17 Dec 2021 13:56:52 -0500
Message-Id: <20211217185654.311609-2-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211217185654.311609-1-mauricio@kinvolk.io>
References: <20211217185654.311609-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTFGen needs to run the core relocation logic in order to understand
what are the types in the target BTF that involved in a given
relocation.

Currently bpf_core_apply_relo() calculates and **applies** a relocation
to an instruction. Having both operations in the same function makes it
difficult to only calculate the relocation without patching the
instruction. This commit splits that logic in two different phases: (1)
calculate the relocation and (2) patch the instruction.

For the first phase bpf_core_apply_relo() is renamed to
bpf_core_calc_relo_res() who is now only on charge of calculating the
relocation, the second phase uses the already existing
bpf_core_patch_insn(). bpf_object__relocate_core() uses both of them and
the BTFGen will use only bpf_core_calc_relo_res().

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 kernel/bpf/btf.c          | 11 +++++-
 tools/lib/bpf/libbpf.c    | 54 ++++++++++++++++-----------
 tools/lib/bpf/relo_core.c | 77 +++++++++++----------------------------
 tools/lib/bpf/relo_core.h | 42 ++++++++++++++++++---
 4 files changed, 99 insertions(+), 85 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index a17de71abd2e..5a8f6ef6a341 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6734,6 +6734,7 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *relo,
 {
 	bool need_cands = relo->kind != BPF_CORE_TYPE_ID_LOCAL;
 	struct bpf_core_cand_list cands = {};
+	struct bpf_core_relo_res targ_res;
 	struct bpf_core_spec *specs;
 	int err;
 
@@ -6778,8 +6779,14 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *relo,
 		 */
 	}
 
-	err = bpf_core_apply_relo_insn((void *)ctx->log, insn, relo->insn_off / 8,
-				       relo, relo_idx, ctx->btf, &cands, specs);
+	err = bpf_core_calc_relo_insn((void *)ctx->log, relo, relo_idx, ctx->btf, &cands, specs,
+				      &targ_res);
+	if (err)
+		goto out;
+
+	err = bpf_core_patch_insn((void *)ctx->log, insn, relo->insn_off / 8, relo, relo_idx,
+				  &targ_res);
+
 out:
 	kfree(specs);
 	if (need_cands) {
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index cf862a19222b..77e2df13715a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5498,11 +5498,12 @@ static int record_relo_core(struct bpf_program *prog,
 	return 0;
 }
 
-static int bpf_core_apply_relo(struct bpf_program *prog,
-			       const struct bpf_core_relo *relo,
-			       int relo_idx,
-			       const struct btf *local_btf,
-			       struct hashmap *cand_cache)
+static int bpf_core_calc_relo_res(struct bpf_program *prog,
+				  const struct bpf_core_relo *relo,
+				  int relo_idx,
+				  const struct btf *local_btf,
+				  struct hashmap *cand_cache,
+				  struct bpf_core_relo_res *targ_res)
 {
 	struct bpf_core_spec specs_scratch[3] = {};
 	const void *type_key = u32_as_hash_key(relo->type_id);
@@ -5511,20 +5512,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	const struct btf_type *local_type;
 	const char *local_name;
 	__u32 local_id = relo->type_id;
-	struct bpf_insn *insn;
-	int insn_idx, err;
-
-	if (relo->insn_off % BPF_INSN_SZ)
-		return -EINVAL;
-	insn_idx = relo->insn_off / BPF_INSN_SZ;
-	/* adjust insn_idx from section frame of reference to the local
-	 * program's frame of reference; (sub-)program code is not yet
-	 * relocated, so it's enough to just subtract in-section offset
-	 */
-	insn_idx = insn_idx - prog->sec_insn_off;
-	if (insn_idx >= prog->insns_cnt)
-		return -EINVAL;
-	insn = &prog->insns[insn_idx];
+	int err;
 
 	local_type = btf__type_by_id(local_btf, local_id);
 	if (!local_type)
@@ -5536,6 +5524,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 
 	if (prog->obj->gen_loader) {
 		const char *spec_str = btf__name_by_offset(local_btf, relo->access_str_off);
+		int insn_idx = relo->insn_off / BPF_INSN_SZ;
 
 		pr_debug("record_relo_core: prog %td insn[%d] %s %s %s final insn_idx %d\n",
 			prog - prog->obj->programs, relo->insn_off / 8,
@@ -5559,19 +5548,21 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 		}
 	}
 
-	return bpf_core_apply_relo_insn(prog_name, insn, insn_idx, relo,
-					relo_idx, local_btf, cands, specs_scratch);
+	return bpf_core_calc_relo_insn(prog_name, relo, relo_idx, local_btf, cands,
+				       specs_scratch, targ_res);
 }
 
 static int
 bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 {
 	const struct btf_ext_info_sec *sec;
+	struct bpf_core_relo_res targ_res;
 	const struct bpf_core_relo *rec;
 	const struct btf_ext_info *seg;
 	struct hashmap_entry *entry;
 	struct hashmap *cand_cache = NULL;
 	struct bpf_program *prog;
+	struct bpf_insn *insn;
 	const char *sec_name;
 	int i, err = 0, insn_idx, sec_idx;
 
@@ -5636,12 +5627,31 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 			if (!prog->load)
 				continue;
 
-			err = bpf_core_apply_relo(prog, rec, i, obj->btf, cand_cache);
+			err = bpf_core_calc_relo_res(prog, rec, i, obj->btf, cand_cache, &targ_res);
 			if (err) {
 				pr_warn("prog '%s': relo #%d: failed to relocate: %d\n",
 					prog->name, i, err);
 				goto out;
 			}
+
+			if (rec->insn_off % BPF_INSN_SZ)
+				return -EINVAL;
+			insn_idx = rec->insn_off / BPF_INSN_SZ;
+			/* adjust insn_idx from section frame of reference to the local
+			 * program's frame of reference; (sub-)program code is not yet
+			 * relocated, so it's enough to just subtract in-section offset
+			 */
+			insn_idx = insn_idx - prog->sec_insn_off;
+			if (insn_idx >= prog->insns_cnt)
+				return -EINVAL;
+			insn = &prog->insns[insn_idx];
+
+			err = bpf_core_patch_insn(prog->name, insn, insn_idx, rec, i, &targ_res);
+			if (err) {
+				pr_warn("prog '%s': relo #%d: failed to patch insn #%u: %d\n",
+					prog->name, i, insn_idx, err);
+				goto out;
+			}
 		}
 	}
 
diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
index 910865e29edc..4f3552468624 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -775,31 +775,6 @@ static int bpf_core_calc_enumval_relo(const struct bpf_core_relo *relo,
 	return 0;
 }
 
-struct bpf_core_relo_res
-{
-	/* expected value in the instruction, unless validate == false */
-	__u32 orig_val;
-	/* new value that needs to be patched up to */
-	__u32 new_val;
-	/* relocation unsuccessful, poison instruction, but don't fail load */
-	bool poison;
-	/* some relocations can't be validated against orig_val */
-	bool validate;
-	/* for field byte offset relocations or the forms:
-	 *     *(T *)(rX + <off>) = rY
-	 *     rX = *(T *)(rY + <off>),
-	 * we remember original and resolved field size to adjust direct
-	 * memory loads of pointers and integers; this is necessary for 32-bit
-	 * host kernel architectures, but also allows to automatically
-	 * relocate fields that were resized from, e.g., u32 to u64, etc.
-	 */
-	bool fail_memsz_adjust;
-	__u32 orig_sz;
-	__u32 orig_type_id;
-	__u32 new_sz;
-	__u32 new_type_id;
-};
-
 /* Calculate original and target relocation values, given local and target
  * specs and relocation kind. These values are calculated for each candidate.
  * If there are multiple candidates, resulting values should all be consistent
@@ -951,9 +926,9 @@ static int insn_bytes_to_bpf_size(__u32 sz)
  * 5. *(T *)(rX + <off>) = rY, where T is one of {u8, u16, u32, u64};
  * 6. *(T *)(rX + <off>) = <imm>, where T is one of {u8, u16, u32, u64}.
  */
-static int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
-			       int insn_idx, const struct bpf_core_relo *relo,
-			       int relo_idx, const struct bpf_core_relo_res *res)
+int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
+			int insn_idx, const struct bpf_core_relo *relo,
+			int relo_idx, const struct bpf_core_relo_res *res)
 {
 	__u32 orig_val, new_val;
 	__u8 class;
@@ -1177,18 +1152,18 @@ static void bpf_core_dump_spec(const char *prog_name, int level, const struct bp
  *    between multiple relocations for the same type ID and is updated as some
  *    of the candidates are pruned due to structural incompatibility.
  */
-int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
-			     int insn_idx,
-			     const struct bpf_core_relo *relo,
-			     int relo_idx,
-			     const struct btf *local_btf,
-			     struct bpf_core_cand_list *cands,
-			     struct bpf_core_spec *specs_scratch)
+int bpf_core_calc_relo_insn(const char *prog_name,
+			    const struct bpf_core_relo *relo,
+			    int relo_idx,
+			    const struct btf *local_btf,
+			    struct bpf_core_cand_list *cands,
+			    struct bpf_core_spec *specs_scratch,
+			    struct bpf_core_relo_res *targ_res)
 {
 	struct bpf_core_spec *local_spec = &specs_scratch[0];
 	struct bpf_core_spec *cand_spec = &specs_scratch[1];
 	struct bpf_core_spec *targ_spec = &specs_scratch[2];
-	struct bpf_core_relo_res cand_res, targ_res;
+	struct bpf_core_relo_res cand_res;
 	const struct btf_type *local_type;
 	const char *local_name;
 	__u32 local_id;
@@ -1223,12 +1198,12 @@ int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
 	/* TYPE_ID_LOCAL relo is special and doesn't need candidate search */
 	if (relo->kind == BPF_CORE_TYPE_ID_LOCAL) {
 		/* bpf_insn's imm value could get out of sync during linking */
-		memset(&targ_res, 0, sizeof(targ_res));
-		targ_res.validate = false;
-		targ_res.poison = false;
-		targ_res.orig_val = local_spec->root_type_id;
-		targ_res.new_val = local_spec->root_type_id;
-		goto patch_insn;
+		memset(targ_res, 0, sizeof(*targ_res));
+		targ_res->validate = true;
+		targ_res->poison = false;
+		targ_res->orig_val = local_spec->root_type_id;
+		targ_res->new_val = local_spec->root_type_id;
+		return 0;
 	}
 
 	/* libbpf doesn't support candidate search for anonymous types */
@@ -1262,7 +1237,7 @@ int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
 			return err;
 
 		if (j == 0) {
-			targ_res = cand_res;
+			*targ_res = cand_res;
 			*targ_spec = *cand_spec;
 		} else if (cand_spec->bit_offset != targ_spec->bit_offset) {
 			/* if there are many field relo candidates, they
@@ -1272,7 +1247,8 @@ int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
 				prog_name, relo_idx, cand_spec->bit_offset,
 				targ_spec->bit_offset);
 			return -EINVAL;
-		} else if (cand_res.poison != targ_res.poison || cand_res.new_val != targ_res.new_val) {
+		} else if (cand_res.poison != targ_res->poison ||
+			   cand_res.new_val != targ_res->new_val) {
 			/* all candidates should result in the same relocation
 			 * decision and value, otherwise it's dangerous to
 			 * proceed due to ambiguity
@@ -1280,7 +1256,7 @@ int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
 			pr_warn("prog '%s': relo #%d: relocation decision ambiguity: %s %u != %s %u\n",
 				prog_name, relo_idx,
 				cand_res.poison ? "failure" : "success", cand_res.new_val,
-				targ_res.poison ? "failure" : "success", targ_res.new_val);
+				targ_res->poison ? "failure" : "success", targ_res->new_val);
 			return -EINVAL;
 		}
 
@@ -1314,19 +1290,10 @@ int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
 			 prog_name, relo_idx);
 
 		/* calculate single target relo result explicitly */
-		err = bpf_core_calc_relo(prog_name, relo, relo_idx, local_spec, NULL, &targ_res);
+		err = bpf_core_calc_relo(prog_name, relo, relo_idx, local_spec, NULL, targ_res);
 		if (err)
 			return err;
 	}
 
-patch_insn:
-	/* bpf_core_patch_insn() should know how to handle missing targ_spec */
-	err = bpf_core_patch_insn(prog_name, insn, insn_idx, relo, relo_idx, &targ_res);
-	if (err) {
-		pr_warn("prog '%s': relo #%d: failed to patch insn #%u: %d\n",
-			prog_name, relo_idx, relo->insn_off / 8, err);
-		return -EINVAL;
-	}
-
 	return 0;
 }
diff --git a/tools/lib/bpf/relo_core.h b/tools/lib/bpf/relo_core.h
index 17799819ad7c..a28bf3711ce2 100644
--- a/tools/lib/bpf/relo_core.h
+++ b/tools/lib/bpf/relo_core.h
@@ -44,14 +44,44 @@ struct bpf_core_spec {
 	__u32 bit_offset;
 };
 
-int bpf_core_apply_relo_insn(const char *prog_name,
-			     struct bpf_insn *insn, int insn_idx,
-			     const struct bpf_core_relo *relo, int relo_idx,
-			     const struct btf *local_btf,
-			     struct bpf_core_cand_list *cands,
-			     struct bpf_core_spec *specs_scratch);
+struct bpf_core_relo_res {
+	/* expected value in the instruction, unless validate == false */
+	__u32 orig_val;
+	/* new value that needs to be patched up to */
+	__u32 new_val;
+	/* relocation unsuccessful, poison instruction, but don't fail load */
+	bool poison;
+	/* some relocations can't be validated against orig_val */
+	bool validate;
+	/* for field byte offset relocations or the forms:
+	 *     *(T *)(rX + <off>) = rY
+	 *     rX = *(T *)(rY + <off>),
+	 * we remember original and resolved field size to adjust direct
+	 * memory loads of pointers and integers; this is necessary for 32-bit
+	 * host kernel architectures, but also allows to automatically
+	 * relocate fields that were resized from, e.g., u32 to u64, etc.
+	 */
+	bool fail_memsz_adjust;
+	__u32 orig_sz;
+	__u32 orig_type_id;
+	__u32 new_sz;
+	__u32 new_type_id;
+};
+
 int bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id,
 			      const struct btf *targ_btf, __u32 targ_id);
 
 size_t bpf_core_essential_name_len(const char *name);
+
+int bpf_core_calc_relo_insn(const char *prog_name,
+			    const struct bpf_core_relo *relo, int relo_idx,
+			    const struct btf *local_btf,
+			    struct bpf_core_cand_list *cands,
+			    struct bpf_core_spec *specs_scratch,
+			    struct bpf_core_relo_res *targ_res);
+
+int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
+			int insn_idx, const struct bpf_core_relo *relo,
+			int relo_idx, const struct bpf_core_relo_res *res);
+
 #endif
-- 
2.25.1

