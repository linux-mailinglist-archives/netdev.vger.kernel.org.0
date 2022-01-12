Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDEB48C603
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354141AbiALO1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354142AbiALO10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:27:26 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8458C061759
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:19 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id r6so3009362qvr.13
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PfmuJw27ywHGMnAziBtAcdW8JUYG26YbVQvs7RPESqA=;
        b=JxTPNB7xmt0fYznh/lpG4tQ8IeL8uQol+Hhk+lecLxJrhNgp8PeBqENGa+kKCN3jHZ
         PJR6hXcz+FsZU6XL23rRWSoEuATFWduP/hQSKlXMqOQJ9ZiSv1L5qp5edCfdPTB0NBaX
         um+H3p8mbcPAGo9pTWwbmswoHMlzy14qEn5II=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PfmuJw27ywHGMnAziBtAcdW8JUYG26YbVQvs7RPESqA=;
        b=RE4LE+5AoRanamh8OULMF1KadCX9lxOVNyJUW4HeEhElQX9L/1x0daKc3DCK8x+yUd
         NXsLJkB/mNVMuSbt8dunm8Et967ejd4tGrvRj16gqj7mZjpIK76bpTw6Y27i/NoUXbKv
         SDXGIQZlY680ghxqHU1wTopt++t7JxJGP4Tx4aYTb1CqdnFrJivSdcoZnMIiH2GgB5jm
         S2Abo8qPzs4uhWVlRQQYu+mkZJqet9SX7OXb9Cldn4DHEmnzvCmazwPOUmY9t/8UE+23
         epz6lY3yg+oa4emPpT+XOe4e9h8qX7S6Y4nDcfFsKjFu8sGVi9vuIrCv5a7j209Qnq3M
         YbzQ==
X-Gm-Message-State: AOAM532SO6VwgJEwRY/n898ktj6yyQdNNtCbmZD7lolCWqjyghU7JGb6
        z3k7kyEYPSMTEmyuZCCKc96i330zOJRzfK74BE8O7/oXPgGWB9GtQuQSl1Ih/k7OGoiSOD47Hqw
        amvk+5Lsc26BwhNXX/on7/AP6pUUKLqhHR1lvK4Q/+vhP8GaBqAL38N+gVgMTZbP2CuQxwM2i
X-Google-Smtp-Source: ABdhPJwZm84YgW++tJYWvFZYFOgxHpMVNz/bGle3GXO4PXyM/bs3Nsgy1byEo0TqaUmA2oRWOPio9Q==
X-Received: by 2002:a05:6214:f25:: with SMTP id iw5mr8118464qvb.72.1641997636887;
        Wed, 12 Jan 2022 06:27:16 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id h11sm8776690qko.59.2022.01.12.06.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 06:27:16 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v4 1/8] libbpf: split bpf_core_apply_relo()
Date:   Wed, 12 Jan 2022 09:27:02 -0500
Message-Id: <20220112142709.102423-2-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220112142709.102423-1-mauricio@kinvolk.io>
References: <20220112142709.102423-1-mauricio@kinvolk.io>
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
 kernel/bpf/btf.c          | 13 ++++--
 tools/lib/bpf/libbpf.c    | 84 ++++++++++++++++++++++++---------------
 tools/lib/bpf/relo_core.c | 79 +++++++++++-------------------------
 tools/lib/bpf/relo_core.h | 42 +++++++++++++++++---
 4 files changed, 122 insertions(+), 96 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 33bb8ae4a804..9e86830a4316 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6788,6 +6788,7 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *relo,
 {
 	bool need_cands = relo->kind != BPF_CORE_TYPE_ID_LOCAL;
 	struct bpf_core_cand_list cands = {};
+	struct bpf_core_relo_res targ_res;
 	struct bpf_core_spec *specs;
 	int err;
 
@@ -6827,13 +6828,19 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *relo,
 		cands.len = cc->cnt;
 		/* cand_cache_mutex needs to span the cache lookup and
 		 * copy of btf pointer into bpf_core_cand_list,
-		 * since module can be unloaded while bpf_core_apply_relo_insn
+		 * since module can be unloaded while bpf_core_calc_relo_insn
 		 * is working with module's btf.
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
index fdb3536afa7d..4959c03a46f4 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5523,11 +5523,12 @@ static int record_relo_core(struct bpf_program *prog,
 	return 0;
 }
 
-static int bpf_core_apply_relo(struct bpf_program *prog,
-			       const struct bpf_core_relo *relo,
-			       int relo_idx,
-			       const struct btf *local_btf,
-			       struct hashmap *cand_cache)
+static int bpf_core_resolve_relo(struct bpf_program *prog,
+				 const struct bpf_core_relo *relo,
+				 int relo_idx,
+				 const struct btf *local_btf,
+				 struct hashmap *cand_cache,
+				 struct bpf_core_relo_res *targ_res)
 {
 	struct bpf_core_spec specs_scratch[3] = {};
 	const void *type_key = u32_as_hash_key(relo->type_id);
@@ -5536,20 +5537,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
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
@@ -5559,15 +5547,6 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	if (!local_name)
 		return -EINVAL;
 
-	if (prog->obj->gen_loader) {
-		const char *spec_str = btf__name_by_offset(local_btf, relo->access_str_off);
-
-		pr_debug("record_relo_core: prog %td insn[%d] %s %s %s final insn_idx %d\n",
-			prog - prog->obj->programs, relo->insn_off / 8,
-			btf_kind_str(local_type), local_name, spec_str, insn_idx);
-		return record_relo_core(prog, relo, insn_idx);
-	}
-
 	if (relo->kind != BPF_CORE_TYPE_ID_LOCAL &&
 	    !hashmap__find(cand_cache, type_key, (void **)&cands)) {
 		cands = bpf_core_find_cands(prog->obj, local_btf, local_id);
@@ -5584,19 +5563,21 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 		}
 	}
 
-	return bpf_core_apply_relo_insn(prog_name, insn, insn_idx, relo,
-					relo_idx, local_btf, cands, specs_scratch);
+	return bpf_core_calc_relo_insn(prog_name, relo, relo_idx, local_btf, cands, specs_scratch,
+				       targ_res);
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
 
@@ -5661,12 +5642,53 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 			if (!prog->load)
 				continue;
 
-			err = bpf_core_apply_relo(prog, rec, i, obj->btf, cand_cache);
+			if (prog->obj->gen_loader) {
+				const struct btf_type *local_type;
+				const char *local_name, *spec_str;
+
+				spec_str = btf__name_by_offset(obj->btf, rec->access_str_off);
+				if (!spec_str)
+					return -EINVAL;
+
+				local_type = btf__type_by_id(obj->btf, rec->type_id);
+				if (!local_type)
+					return -EINVAL;
+
+				local_name = btf__name_by_offset(obj->btf, local_type->name_off);
+				if (!local_name)
+					return -EINVAL;
+
+				pr_debug("record_relo_core: prog %td insn[%d] %s %s %s final insn_idx %d\n",
+					prog - prog->obj->programs, insn_idx,
+					btf_kind_str(local_type), local_name, spec_str, insn_idx);
+				return record_relo_core(prog, rec, insn_idx);
+			}
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
+			err = bpf_core_resolve_relo(prog, rec, i, obj->btf, cand_cache, &targ_res);
 			if (err) {
 				pr_warn("prog '%s': relo #%d: failed to relocate: %d\n",
 					prog->name, i, err);
 				goto out;
 			}
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
index 910865e29edc..f946f23eab20 100644
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
@@ -1128,7 +1103,7 @@ static void bpf_core_dump_spec(const char *prog_name, int level, const struct bp
 }
 
 /*
- * CO-RE relocate single instruction.
+ * Calculate CO-RE relocation target result.
  *
  * The outline and important points of the algorithm:
  * 1. For given local type, find corresponding candidate target types.
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
+		targ_res->validate = false;
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

