Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9DD2C9606
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 04:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbgLADsF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Nov 2020 22:48:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64906 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727787AbgLADsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 22:48:04 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B13joH2004021
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 19:47:23 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 354hsyfkee-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 19:47:23 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 19:47:22 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7CAE82ECA628; Mon, 30 Nov 2020 19:47:18 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH v3 bpf-next 3/7] libbpf: refactor CO-RE relocs to not assume a single BTF object
Date:   Mon, 30 Nov 2020 19:47:04 -0800
Message-ID: <20201201034709.2918694-4-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201034709.2918694-1-andrii@kernel.org>
References: <20201201034709.2918694-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=29 mlxlogscore=999
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012010025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor CO-RE relocation candidate search to not expect a single BTF, rather
return all candidate types with their corresponding BTF objects. This will
allow to extend CO-RE relocations to accommodate kernel module BTFs.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 187 ++++++++++++++++++++++++-----------------
 1 file changed, 111 insertions(+), 76 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 313034117070..c4a49e8eb7b5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -462,11 +462,14 @@ struct bpf_object {
 	struct list_head list;
 
 	struct btf *btf;
+	struct btf_ext *btf_ext;
+
 	/* Parse and load BTF vmlinux if any of the programs in the object need
 	 * it at load time.
 	 */
 	struct btf *btf_vmlinux;
-	struct btf_ext *btf_ext;
+	/* vmlinux BTF override for CO-RE relocations */
+	struct btf *btf_vmlinux_override;
 
 	void *priv;
 	bpf_object_clear_priv_t clear_priv;
@@ -4600,46 +4603,43 @@ static size_t bpf_core_essential_name_len(const char *name)
 	return n;
 }
 
-/* dynamically sized list of type IDs */
-struct ids_vec {
-	__u32 *data;
+struct core_cand
+{
+	const struct btf *btf;
+	const struct btf_type *t;
+	const char *name;
+	__u32 id;
+};
+
+/* dynamically sized list of type IDs and its associated struct btf */
+struct core_cand_list {
+	struct core_cand *cands;
 	int len;
 };
 
-static void bpf_core_free_cands(struct ids_vec *cand_ids)
+static void bpf_core_free_cands(struct core_cand_list *cands)
 {
-	free(cand_ids->data);
-	free(cand_ids);
+	free(cands->cands);
+	free(cands);
 }
 
-static struct ids_vec *bpf_core_find_cands(const struct btf *local_btf,
-					   __u32 local_type_id,
-					   const struct btf *targ_btf)
+static int bpf_core_add_cands(struct core_cand *local_cand,
+			      size_t local_essent_len,
+			      const struct btf *targ_btf,
+			      const char *targ_btf_name,
+			      int targ_start_id,
+			      struct core_cand_list *cands)
 {
-	size_t local_essent_len, targ_essent_len;
-	const char *local_name, *targ_name;
-	const struct btf_type *t, *local_t;
-	struct ids_vec *cand_ids;
-	__u32 *new_ids;
-	int i, err, n;
-
-	local_t = btf__type_by_id(local_btf, local_type_id);
-	if (!local_t)
-		return ERR_PTR(-EINVAL);
-
-	local_name = btf__name_by_offset(local_btf, local_t->name_off);
-	if (str_is_empty(local_name))
-		return ERR_PTR(-EINVAL);
-	local_essent_len = bpf_core_essential_name_len(local_name);
-
-	cand_ids = calloc(1, sizeof(*cand_ids));
-	if (!cand_ids)
-		return ERR_PTR(-ENOMEM);
+	struct core_cand *new_cands, *cand;
+	const struct btf_type *t;
+	const char *targ_name;
+	size_t targ_essent_len;
+	int n, i;
 
 	n = btf__get_nr_types(targ_btf);
-	for (i = 1; i <= n; i++) {
+	for (i = targ_start_id; i <= n; i++) {
 		t = btf__type_by_id(targ_btf, i);
-		if (btf_kind(t) != btf_kind(local_t))
+		if (btf_kind(t) != btf_kind(local_cand->t))
 			continue;
 
 		targ_name = btf__name_by_offset(targ_btf, t->name_off);
@@ -4650,25 +4650,62 @@ static struct ids_vec *bpf_core_find_cands(const struct btf *local_btf,
 		if (targ_essent_len != local_essent_len)
 			continue;
 
-		if (strncmp(local_name, targ_name, local_essent_len) == 0) {
-			pr_debug("CO-RE relocating [%d] %s %s: found target candidate [%d] %s %s\n",
-				 local_type_id, btf_kind_str(local_t),
-				 local_name, i, btf_kind_str(t), targ_name);
-			new_ids = libbpf_reallocarray(cand_ids->data,
-						      cand_ids->len + 1,
-						      sizeof(*cand_ids->data));
-			if (!new_ids) {
-				err = -ENOMEM;
-				goto err_out;
-			}
-			cand_ids->data = new_ids;
-			cand_ids->data[cand_ids->len++] = i;
-		}
+		if (strncmp(local_cand->name, targ_name, local_essent_len) != 0)
+			continue;
+
+		pr_debug("CO-RE relocating [%d] %s %s: found target candidate [%d] %s %s in [%s]\n",
+			 local_cand->id, btf_kind_str(local_cand->t),
+			 local_cand->name, i, btf_kind_str(t), targ_name,
+			 targ_btf_name);
+		new_cands = libbpf_reallocarray(cands->cands, cands->len + 1,
+					      sizeof(*cands->cands));
+		if (!new_cands)
+			return -ENOMEM;
+
+		cand = &new_cands[cands->len];
+		cand->btf = targ_btf;
+		cand->t = t;
+		cand->name = targ_name;
+		cand->id = i;
+
+		cands->cands = new_cands;
+		cands->len++;
 	}
-	return cand_ids;
-err_out:
-	bpf_core_free_cands(cand_ids);
-	return ERR_PTR(err);
+	return 0;
+}
+
+static struct core_cand_list *
+bpf_core_find_cands(struct bpf_object *obj, const struct btf *local_btf, __u32 local_type_id)
+{
+	struct core_cand local_cand = {};
+	struct core_cand_list *cands;
+	size_t local_essent_len;
+	int err;
+
+	local_cand.btf = local_btf;
+	local_cand.t = btf__type_by_id(local_btf, local_type_id);
+	if (!local_cand.t)
+		return ERR_PTR(-EINVAL);
+
+	local_cand.name = btf__name_by_offset(local_btf, local_cand.t->name_off);
+	if (str_is_empty(local_cand.name))
+		return ERR_PTR(-EINVAL);
+	local_essent_len = bpf_core_essential_name_len(local_cand.name);
+
+	cands = calloc(1, sizeof(*cands));
+	if (!cands)
+		return ERR_PTR(-ENOMEM);
+
+	/* Attempt to find target candidates in vmlinux BTF first */
+	err = bpf_core_add_cands(&local_cand, local_essent_len,
+				 obj->btf_vmlinux_override ?: obj->btf_vmlinux,
+				 "vmlinux", 1, cands);
+	if (err) {
+		bpf_core_free_cands(cands);
+		return ERR_PTR(err);
+	}
+
+	return cands;
 }
 
 /* Check two types for compatibility for the purpose of field access
@@ -5661,7 +5698,6 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 			       const struct bpf_core_relo *relo,
 			       int relo_idx,
 			       const struct btf *local_btf,
-			       const struct btf *targ_btf,
 			       struct hashmap *cand_cache)
 {
 	struct bpf_core_spec local_spec, cand_spec, targ_spec = {};
@@ -5669,8 +5705,8 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	struct bpf_core_relo_res cand_res, targ_res;
 	const struct btf_type *local_type;
 	const char *local_name;
-	struct ids_vec *cand_ids;
-	__u32 local_id, cand_id;
+	struct core_cand_list *cands = NULL;
+	__u32 local_id;
 	const char *spec_str;
 	int i, j, err;
 
@@ -5717,24 +5753,24 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 		return -EOPNOTSUPP;
 	}
 
-	if (!hashmap__find(cand_cache, type_key, (void **)&cand_ids)) {
-		cand_ids = bpf_core_find_cands(local_btf, local_id, targ_btf);
-		if (IS_ERR(cand_ids)) {
+	if (!hashmap__find(cand_cache, type_key, (void **)&cands)) {
+		cands = bpf_core_find_cands(prog->obj, local_btf, local_id);
+		if (IS_ERR(cands)) {
 			pr_warn("prog '%s': relo #%d: target candidate search failed for [%d] %s %s: %ld",
 				prog->name, relo_idx, local_id, btf_kind_str(local_type),
-				local_name, PTR_ERR(cand_ids));
-			return PTR_ERR(cand_ids);
+				local_name, PTR_ERR(cands));
+			return PTR_ERR(cands);
 		}
-		err = hashmap__set(cand_cache, type_key, cand_ids, NULL, NULL);
+		err = hashmap__set(cand_cache, type_key, cands, NULL, NULL);
 		if (err) {
-			bpf_core_free_cands(cand_ids);
+			bpf_core_free_cands(cands);
 			return err;
 		}
 	}
 
-	for (i = 0, j = 0; i < cand_ids->len; i++) {
-		cand_id = cand_ids->data[i];
-		err = bpf_core_spec_match(&local_spec, targ_btf, cand_id, &cand_spec);
+	for (i = 0, j = 0; i < cands->len; i++) {
+		err = bpf_core_spec_match(&local_spec, cands->cands[i].btf,
+					  cands->cands[i].id, &cand_spec);
 		if (err < 0) {
 			pr_warn("prog '%s': relo #%d: error matching candidate #%d ",
 				prog->name, relo_idx, i);
@@ -5778,7 +5814,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 			return -EINVAL;
 		}
 
-		cand_ids->data[j++] = cand_spec.root_type_id;
+		cands->cands[j++] = cands->cands[i];
 	}
 
 	/*
@@ -5790,7 +5826,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	 * depending on relo's kind.
 	 */
 	if (j > 0)
-		cand_ids->len = j;
+		cands->len = j;
 
 	/*
 	 * If no candidates were found, it might be both a programmer error,
@@ -5834,20 +5870,19 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 	struct hashmap_entry *entry;
 	struct hashmap *cand_cache = NULL;
 	struct bpf_program *prog;
-	struct btf *targ_btf;
 	const char *sec_name;
 	int i, err = 0, insn_idx, sec_idx;
 
 	if (obj->btf_ext->core_relo_info.len == 0)
 		return 0;
 
-	if (targ_btf_path)
-		targ_btf = btf__parse(targ_btf_path, NULL);
-	else
-		targ_btf = obj->btf_vmlinux;
-	if (IS_ERR_OR_NULL(targ_btf)) {
-		pr_warn("failed to get target BTF: %ld\n", PTR_ERR(targ_btf));
-		return PTR_ERR(targ_btf);
+	if (targ_btf_path) {
+		obj->btf_vmlinux_override = btf__parse(targ_btf_path, NULL);
+		if (IS_ERR_OR_NULL(obj->btf_vmlinux_override)) {
+			err = PTR_ERR(obj->btf_vmlinux_override);
+			pr_warn("failed to parse target BTF: %d\n", err);
+			return err;
+		}
 	}
 
 	cand_cache = hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, NULL);
@@ -5899,8 +5934,7 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 			if (!prog->load)
 				continue;
 
-			err = bpf_core_apply_relo(prog, rec, i, obj->btf,
-						  targ_btf, cand_cache);
+			err = bpf_core_apply_relo(prog, rec, i, obj->btf, cand_cache);
 			if (err) {
 				pr_warn("prog '%s': relo #%d: failed to relocate: %d\n",
 					prog->name, i, err);
@@ -5911,8 +5945,9 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 
 out:
 	/* obj->btf_vmlinux is freed at the end of object load phase */
-	if (targ_btf != obj->btf_vmlinux)
-		btf__free(targ_btf);
+	btf__free(obj->btf_vmlinux_override);
+	obj->btf_vmlinux_override = NULL;
+
 	if (!IS_ERR_OR_NULL(cand_cache)) {
 		hashmap__for_each_entry(cand_cache, entry, i) {
 			bpf_core_free_cands(entry->value);
-- 
2.24.1

