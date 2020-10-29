Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB8829DF32
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403952AbgJ2A7r convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Oct 2020 20:59:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20410 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403948AbgJ2A7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 20:59:38 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09T0ocC8004417
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 17:59:37 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34esepr284-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 17:59:37 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 28 Oct 2020 17:59:36 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5C8E22EC875F; Wed, 28 Oct 2020 17:59:24 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 08/11] libbpf: support BTF dedup of split BTFs
Date:   Wed, 28 Oct 2020 17:58:59 -0700
Message-ID: <20201029005902.1706310-9-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201029005902.1706310-1-andrii@kernel.org>
References: <20201029005902.1706310-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_09:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1034 priorityscore=1501
 suspectscore=25 phishscore=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for deduplication split BTFs. When deduplicating split BTF, base
BTF is considered to be immutable and can't be modified or adjusted. 99% of
BTF deduplication logic is left intact (module some type numbering adjustments).
There are only two differences.

First, each type in base BTF gets hashed (expect VAR and DATASEC, of course,
those are always considered to be self-canonical instances) and added into
a table of canonical table candidates. Hashing is a shallow, fast operation,
so mostly eliminates the overhead of having entire base BTF to be a part of
BTF dedup.

Second difference is very critical and subtle. While deduplicating split BTF
types, it is possible to discover that one of immutable base BTF BTF_KIND_FWD
types can and should be resolved to a full STRUCT/UNION type from the split
BTF part.  This is, obviously, can't happen because we can't modify the base
BTF types anymore. So because of that, any type in split BTF that directly or
indirectly references that newly-to-be-resolved FWD type can't be considered
to be equivalent to the corresponding canonical types in base BTF, because
that would result in a loss of type resolution information. So in such case,
split BTF types will be deduplicated separately and will cause some
duplication of type information, which is unavoidable.

With those two changes, the rest of the algorithm manages to deduplicate split
BTF correctly, pointing all the duplicates to their canonical counter-parts in
base BTF, but also is deduplicating whatever unique types are present in split
BTF on their own.

Also, theoretically, split BTF after deduplication could end up with either
empty type section or empty string section. This is handled by libbpf
correctly in one of previous patches in the series.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c | 218 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 165 insertions(+), 53 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 9b0ef71a03d0..c760a5809d4d 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -2722,6 +2722,7 @@ struct btf_dedup;
 static struct btf_dedup *btf_dedup_new(struct btf *btf, struct btf_ext *btf_ext,
 				       const struct btf_dedup_opts *opts);
 static void btf_dedup_free(struct btf_dedup *d);
+static int btf_dedup_prep(struct btf_dedup *d);
 static int btf_dedup_strings(struct btf_dedup *d);
 static int btf_dedup_prim_types(struct btf_dedup *d);
 static int btf_dedup_struct_types(struct btf_dedup *d);
@@ -2880,6 +2881,11 @@ int btf__dedup(struct btf *btf, struct btf_ext *btf_ext,
 	if (btf_ensure_modifiable(btf))
 		return -ENOMEM;
 
+	err = btf_dedup_prep(d);
+	if (err) {
+		pr_debug("btf_dedup_prep failed:%d\n", err);
+		goto done;
+	}
 	err = btf_dedup_strings(d);
 	if (err < 0) {
 		pr_debug("btf_dedup_strings failed:%d\n", err);
@@ -2942,6 +2948,13 @@ struct btf_dedup {
 	__u32 *hypot_list;
 	size_t hypot_cnt;
 	size_t hypot_cap;
+	/* Whether hypothethical mapping, if successful, would need to adjust
+	 * already canonicalized types (due to a new forward declaration to
+	 * concrete type resolution). In such case, during split BTF dedup
+	 * candidate type would still be considered as different, because base
+	 * BTF is considered to be immutable.
+	 */
+	bool hypot_adjust_canon;
 	/* Various option modifying behavior of algorithm */
 	struct btf_dedup_opts opts;
 	/* temporary strings deduplication state */
@@ -2989,6 +3002,7 @@ static void btf_dedup_clear_hypot_map(struct btf_dedup *d)
 	for (i = 0; i < d->hypot_cnt; i++)
 		d->hypot_map[d->hypot_list[i]] = BTF_UNPROCESSED_ID;
 	d->hypot_cnt = 0;
+	d->hypot_adjust_canon = false;
 }
 
 static void btf_dedup_free(struct btf_dedup *d)
@@ -3028,7 +3042,7 @@ static struct btf_dedup *btf_dedup_new(struct btf *btf, struct btf_ext *btf_ext,
 {
 	struct btf_dedup *d = calloc(1, sizeof(struct btf_dedup));
 	hashmap_hash_fn hash_fn = btf_dedup_identity_hash_fn;
-	int i, err = 0;
+	int i, err = 0, type_cnt;
 
 	if (!d)
 		return ERR_PTR(-ENOMEM);
@@ -3048,14 +3062,15 @@ static struct btf_dedup *btf_dedup_new(struct btf *btf, struct btf_ext *btf_ext,
 		goto done;
 	}
 
-	d->map = malloc(sizeof(__u32) * (1 + btf->nr_types));
+	type_cnt = btf__get_nr_types(btf) + 1;
+	d->map = malloc(sizeof(__u32) * type_cnt);
 	if (!d->map) {
 		err = -ENOMEM;
 		goto done;
 	}
 	/* special BTF "void" type is made canonical immediately */
 	d->map[0] = 0;
-	for (i = 1; i <= btf->nr_types; i++) {
+	for (i = 1; i < type_cnt; i++) {
 		struct btf_type *t = btf_type_by_id(d->btf, i);
 
 		/* VAR and DATASEC are never deduped and are self-canonical */
@@ -3065,12 +3080,12 @@ static struct btf_dedup *btf_dedup_new(struct btf *btf, struct btf_ext *btf_ext,
 			d->map[i] = BTF_UNPROCESSED_ID;
 	}
 
-	d->hypot_map = malloc(sizeof(__u32) * (1 + btf->nr_types));
+	d->hypot_map = malloc(sizeof(__u32) * type_cnt);
 	if (!d->hypot_map) {
 		err = -ENOMEM;
 		goto done;
 	}
-	for (i = 0; i <= btf->nr_types; i++)
+	for (i = 0; i < type_cnt; i++)
 		d->hypot_map[i] = BTF_UNPROCESSED_ID;
 
 done:
@@ -3094,8 +3109,8 @@ static int btf_for_each_str_off(struct btf_dedup *d, str_off_fn_t fn, void *ctx)
 	int i, j, r, rec_size;
 	struct btf_type *t;
 
-	for (i = 1; i <= d->btf->nr_types; i++) {
-		t = btf_type_by_id(d->btf, i);
+	for (i = 0; i < d->btf->nr_types; i++) {
+		t = btf_type_by_id(d->btf, d->btf->start_id + i);
 		r = fn(&t->name_off, ctx);
 		if (r)
 			return r;
@@ -3178,15 +3193,27 @@ static int btf_for_each_str_off(struct btf_dedup *d, str_off_fn_t fn, void *ctx)
 static int strs_dedup_remap_str_off(__u32 *str_off_ptr, void *ctx)
 {
 	struct btf_dedup *d = ctx;
+	__u32 str_off = *str_off_ptr;
 	long old_off, new_off, len;
 	const char *s;
 	void *p;
 	int err;
 
-	if (*str_off_ptr == 0)
+	/* don't touch empty string or string in main BTF */
+	if (str_off == 0 || str_off < d->btf->start_str_off)
 		return 0;
 
-	s = btf__str_by_offset(d->btf, *str_off_ptr);
+	s = btf__str_by_offset(d->btf, str_off);
+	if (d->btf->base_btf) {
+		err = btf__find_str(d->btf->base_btf, s);
+		if (err >= 0) {
+			*str_off_ptr = err;
+			return 0;
+		}
+		if (err != -ENOENT)
+			return err;
+	}
+
 	len = strlen(s) + 1;
 
 	new_off = d->strs_len;
@@ -3203,11 +3230,11 @@ static int strs_dedup_remap_str_off(__u32 *str_off_ptr, void *ctx)
 	err = hashmap__insert(d->strs_hash, (void *)new_off, (void *)new_off,
 			      HASHMAP_ADD, (const void **)&old_off, NULL);
 	if (err == -EEXIST) {
-		*str_off_ptr = old_off;
+		*str_off_ptr = d->btf->start_str_off + old_off;
 	} else if (err) {
 		return err;
 	} else {
-		*str_off_ptr = new_off;
+		*str_off_ptr = d->btf->start_str_off + new_off;
 		d->strs_len += len;
 	}
 	return 0;
@@ -3232,13 +3259,6 @@ static int btf_dedup_strings(struct btf_dedup *d)
 	if (d->btf->strs_deduped)
 		return 0;
 
-	s = btf_add_mem(&d->strs_data, &d->strs_cap, 1, d->strs_len, BTF_MAX_STR_OFFSET, 1);
-	if (!s)
-		return -ENOMEM;
-	/* initial empty string */
-	s[0] = 0;
-	d->strs_len = 1;
-
 	/* temporarily switch to use btf_dedup's strs_data for strings for hash
 	 * functions; later we'll just transfer hashmap to struct btf as is,
 	 * along the strs_data
@@ -3252,13 +3272,22 @@ static int btf_dedup_strings(struct btf_dedup *d)
 		goto err_out;
 	}
 
-	/* insert empty string; we won't be looking it up during strings
-	 * dedup, but it's good to have it for generic BTF string lookups
-	 */
-	err = hashmap__insert(d->strs_hash, (void *)0, (void *)0,
-			      HASHMAP_ADD, NULL, NULL);
-	if (err)
-		goto err_out;
+	if (!d->btf->base_btf) {
+		s = btf_add_mem(&d->strs_data, &d->strs_cap, 1, d->strs_len, BTF_MAX_STR_OFFSET, 1);
+		if (!s)
+			return -ENOMEM;
+		/* initial empty string */
+		s[0] = 0;
+		d->strs_len = 1;
+
+		/* insert empty string; we won't be looking it up during strings
+		 * dedup, but it's good to have it for generic BTF string lookups
+		 */
+		err = hashmap__insert(d->strs_hash, (void *)0, (void *)0,
+				      HASHMAP_ADD, NULL, NULL);
+		if (err)
+			goto err_out;
+	}
 
 	/* remap string offsets */
 	err = btf_for_each_str_off(d, strs_dedup_remap_str_off, d);
@@ -3553,6 +3582,63 @@ static bool btf_compat_fnproto(struct btf_type *t1, struct btf_type *t2)
 	return true;
 }
 
+static int btf_dedup_prep(struct btf_dedup *d)
+{
+	struct btf_type *t;
+	int type_id;
+	long h;
+
+	if (!d->btf->base_btf)
+		return 0;
+
+	for (type_id = 1; type_id < d->btf->start_id; type_id++)
+	{
+		t = btf_type_by_id(d->btf, type_id);
+
+		/* all base BTF types are self-canonical by definition */
+		d->map[type_id] = type_id;
+
+		switch (btf_kind(t)) {
+		case BTF_KIND_VAR:
+		case BTF_KIND_DATASEC:
+			/* VAR and DATASEC are never hash/deduplicated */
+			continue;
+		case BTF_KIND_CONST:
+		case BTF_KIND_VOLATILE:
+		case BTF_KIND_RESTRICT:
+		case BTF_KIND_PTR:
+		case BTF_KIND_FWD:
+		case BTF_KIND_TYPEDEF:
+		case BTF_KIND_FUNC:
+			h = btf_hash_common(t);
+			break;
+		case BTF_KIND_INT:
+			h = btf_hash_int(t);
+			break;
+		case BTF_KIND_ENUM:
+			h = btf_hash_enum(t);
+			break;
+		case BTF_KIND_STRUCT:
+		case BTF_KIND_UNION:
+			h = btf_hash_struct(t);
+			break;
+		case BTF_KIND_ARRAY:
+			h = btf_hash_array(t);
+			break;
+		case BTF_KIND_FUNC_PROTO:
+			h = btf_hash_fnproto(t);
+			break;
+		default:
+			pr_debug("unknown kind %d for type [%d]\n", btf_kind(t), type_id);
+			return -EINVAL;
+		}
+		if (btf_dedup_table_add(d, h, type_id))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 /*
  * Deduplicate primitive types, that can't reference other types, by calculating
  * their type signature hash and comparing them with any possible canonical
@@ -3646,8 +3732,8 @@ static int btf_dedup_prim_types(struct btf_dedup *d)
 {
 	int i, err;
 
-	for (i = 1; i <= d->btf->nr_types; i++) {
-		err = btf_dedup_prim_type(d, i);
+	for (i = 0; i < d->btf->nr_types; i++) {
+		err = btf_dedup_prim_type(d, d->btf->start_id + i);
 		if (err)
 			return err;
 	}
@@ -3837,6 +3923,9 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
 		} else {
 			real_kind = cand_kind;
 			fwd_kind = btf_fwd_kind(canon_type);
+			/* we'd need to resolve base FWD to STRUCT/UNION */
+			if (fwd_kind == real_kind && canon_id < d->btf->start_id)
+				d->hypot_adjust_canon = true;
 		}
 		return fwd_kind == real_kind;
 	}
@@ -3874,8 +3963,7 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
 			return 0;
 		cand_arr = btf_array(cand_type);
 		canon_arr = btf_array(canon_type);
-		eq = btf_dedup_is_equiv(d,
-			cand_arr->index_type, canon_arr->index_type);
+		eq = btf_dedup_is_equiv(d, cand_arr->index_type, canon_arr->index_type);
 		if (eq <= 0)
 			return eq;
 		return btf_dedup_is_equiv(d, cand_arr->type, canon_arr->type);
@@ -3958,16 +4046,16 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
  */
 static void btf_dedup_merge_hypot_map(struct btf_dedup *d)
 {
-	__u32 cand_type_id, targ_type_id;
+	__u32 canon_type_id, targ_type_id;
 	__u16 t_kind, c_kind;
 	__u32 t_id, c_id;
 	int i;
 
 	for (i = 0; i < d->hypot_cnt; i++) {
-		cand_type_id = d->hypot_list[i];
-		targ_type_id = d->hypot_map[cand_type_id];
+		canon_type_id = d->hypot_list[i];
+		targ_type_id = d->hypot_map[canon_type_id];
 		t_id = resolve_type_id(d, targ_type_id);
-		c_id = resolve_type_id(d, cand_type_id);
+		c_id = resolve_type_id(d, canon_type_id);
 		t_kind = btf_kind(btf__type_by_id(d->btf, t_id));
 		c_kind = btf_kind(btf__type_by_id(d->btf, c_id));
 		/*
@@ -3982,9 +4070,26 @@ static void btf_dedup_merge_hypot_map(struct btf_dedup *d)
 		 * stability is not a requirement for STRUCT/UNION equivalence
 		 * checks, though.
 		 */
+
+		/* if it's the split BTF case, we still need to point base FWD
+		 * to STRUCT/UNION in a split BTF, because FWDs from split BTF
+		 * will be resolved against base FWD. If we don't point base
+		 * canonical FWD to the resolved STRUCT/UNION, then all the
+		 * FWDs in split BTF won't be correctly resolved to a proper
+		 * STRUCT/UNION.
+		 */
 		if (t_kind != BTF_KIND_FWD && c_kind == BTF_KIND_FWD)
 			d->map[c_id] = t_id;
-		else if (t_kind == BTF_KIND_FWD && c_kind != BTF_KIND_FWD)
+
+		/* if graph equivalence determined that we'd need to adjust
+		 * base canonical types, then we need to only point base FWDs
+		 * to STRUCTs/UNIONs and do no more modifications. For all
+		 * other purposes the type graphs were not equivalent.
+		 */
+		if (d->hypot_adjust_canon)
+			continue;
+		
+		if (t_kind == BTF_KIND_FWD && c_kind != BTF_KIND_FWD)
 			d->map[t_id] = c_id;
 
 		if ((t_kind == BTF_KIND_STRUCT || t_kind == BTF_KIND_UNION) &&
@@ -4068,8 +4173,10 @@ static int btf_dedup_struct_type(struct btf_dedup *d, __u32 type_id)
 			return eq;
 		if (!eq)
 			continue;
-		new_id = cand_id;
 		btf_dedup_merge_hypot_map(d);
+		if (d->hypot_adjust_canon) /* not really equivalent */
+			continue;
+		new_id = cand_id;
 		break;
 	}
 
@@ -4084,8 +4191,8 @@ static int btf_dedup_struct_types(struct btf_dedup *d)
 {
 	int i, err;
 
-	for (i = 1; i <= d->btf->nr_types; i++) {
-		err = btf_dedup_struct_type(d, i);
+	for (i = 0; i < d->btf->nr_types; i++) {
+		err = btf_dedup_struct_type(d, d->btf->start_id + i);
 		if (err)
 			return err;
 	}
@@ -4228,8 +4335,8 @@ static int btf_dedup_ref_types(struct btf_dedup *d)
 {
 	int i, err;
 
-	for (i = 1; i <= d->btf->nr_types; i++) {
-		err = btf_dedup_ref_type(d, i);
+	for (i = 0; i < d->btf->nr_types; i++) {
+		err = btf_dedup_ref_type(d, d->btf->start_id + i);
 		if (err < 0)
 			return err;
 	}
@@ -4253,39 +4360,44 @@ static int btf_dedup_ref_types(struct btf_dedup *d)
 static int btf_dedup_compact_types(struct btf_dedup *d)
 {
 	__u32 *new_offs;
-	__u32 next_type_id = 1;
+	__u32 next_type_id = d->btf->start_id;
+	const struct btf_type *t;
 	void *p;
-	int i, len;
+	int i, id, len;
 
 	/* we are going to reuse hypot_map to store compaction remapping */
 	d->hypot_map[0] = 0;
-	for (i = 1; i <= d->btf->nr_types; i++)
-		d->hypot_map[i] = BTF_UNPROCESSED_ID;
+	/* base BTF types are not renumbered */
+	for (id = 1; id < d->btf->start_id; id++)
+		d->hypot_map[id] = id;
+	for (i = 0, id = d->btf->start_id; i < d->btf->nr_types; i++, id++)
+		d->hypot_map[id] = BTF_UNPROCESSED_ID;
 
 	p = d->btf->types_data;
 
-	for (i = 1; i <= d->btf->nr_types; i++) {
-		if (d->map[i] != i)
+	for (i = 0, id = d->btf->start_id; i < d->btf->nr_types; i++, id++) {
+		if (d->map[id] != id)
 			continue;
 
-		len = btf_type_size(btf__type_by_id(d->btf, i));
+		t = btf__type_by_id(d->btf, id);
+		len = btf_type_size(t);
 		if (len < 0)
 			return len;
 
-		memmove(p, btf__type_by_id(d->btf, i), len);
-		d->hypot_map[i] = next_type_id;
-		d->btf->type_offs[next_type_id - 1] = p - d->btf->types_data;
+		memmove(p, t, len);
+		d->hypot_map[id] = next_type_id;
+		d->btf->type_offs[next_type_id - d->btf->start_id] = p - d->btf->types_data;
 		p += len;
 		next_type_id++;
 	}
 
 	/* shrink struct btf's internal types index and update btf_header */
-	d->btf->nr_types = next_type_id - 1;
+	d->btf->nr_types = next_type_id - d->btf->start_id;
 	d->btf->type_offs_cap = d->btf->nr_types;
 	d->btf->hdr->type_len = p - d->btf->types_data;
 	new_offs = libbpf_reallocarray(d->btf->type_offs, d->btf->type_offs_cap,
 				       sizeof(*new_offs));
-	if (!new_offs)
+	if (d->btf->type_offs_cap && !new_offs)
 		return -ENOMEM;
 	d->btf->type_offs = new_offs;
 	d->btf->hdr->str_off = d->btf->hdr->type_len;
@@ -4417,8 +4529,8 @@ static int btf_dedup_remap_types(struct btf_dedup *d)
 {
 	int i, r;
 
-	for (i = 1; i <= d->btf->nr_types; i++) {
-		r = btf_dedup_remap_type(d, i);
+	for (i = 0; i < d->btf->nr_types; i++) {
+		r = btf_dedup_remap_type(d, d->btf->start_id + i);
 		if (r < 0)
 			return r;
 	}
-- 
2.24.1

