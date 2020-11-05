Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47CA2A76B4
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbgKEEw0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Nov 2020 23:52:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35452 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731609AbgKEEw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:52:26 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A54mVhr026807
        for <netdev@vger.kernel.org>; Wed, 4 Nov 2020 20:52:25 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34kmux6gh6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 20:52:25 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 20:51:52 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DF2162EC8E08; Wed,  4 Nov 2020 20:51:48 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [RFC PATCH bpf-next 1/5] bpf: add in-kernel split BTF support
Date:   Wed, 4 Nov 2020 20:51:36 -0800
Message-ID: <20201105045140.2589346-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105045140.2589346-1-andrii@kernel.org>
References: <20201105045140.2589346-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_01:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 impostorscore=0 malwarescore=0 adultscore=0 suspectscore=8 mlxscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050035
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust in-kernel BTF implementation to support a split BTF mode of operation.
Changes are mostly mirroring libbpf split BTF changes, with the exception of
start_id being 0 for in-kernel implementation due to simpler read-only mode.

Otherwise, for split BTF logic, most of the logic of jumping to base BTF,
where necessary, is encapsulated in few helper functions. Type numbering and
string offset in a split BTF are logically continuing where base BTF ends, so
most of the high-level logic is kept without changes.

Type verification and size resolution is only doing an added resolution of new
split BTF types and relies on already cached size and type resolution results
in the base BTF.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/bpf/btf.c | 182 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 130 insertions(+), 52 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ed7d02e8bc93..f61944a3873b 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -204,12 +204,17 @@ struct btf {
 	const char *strings;
 	void *nohdr_data;
 	struct btf_header hdr;
-	u32 nr_types;
+	u32 nr_types; /* includes VOID for base BTF */
 	u32 types_size;
 	u32 data_size;
 	refcount_t refcnt;
 	u32 id;
 	struct rcu_head rcu;
+
+	/* split BTF support */
+	struct btf *base_btf;
+	u32 start_id; /* first type ID in this BTF (0 for base BTF) */
+	u32 start_str_off; /* first string offset (0 for base BTF) */
 };
 
 enum verifier_phase {
@@ -450,14 +455,27 @@ static bool btf_type_is_datasec(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_DATASEC;
 }
 
+static u32 btf_nr_types_total(const struct btf *btf)
+{
+	u32 total = 0;
+
+	while (btf) {
+		total += btf->nr_types;
+		btf = btf->base_btf;
+	}
+
+	return total;
+}
+
 s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kind)
 {
 	const struct btf_type *t;
 	const char *tname;
-	u32 i;
+	u32 i, total;
 
-	for (i = 1; i <= btf->nr_types; i++) {
-		t = btf->types[i];
+	total = btf_nr_types_total(btf);
+	for (i = 1; i < total; i++) {
+		t = btf_type_by_id(btf, i);
 		if (BTF_INFO_KIND(t->info) != kind)
 			continue;
 
@@ -600,8 +618,15 @@ static const struct btf_kind_operations *btf_type_ops(const struct btf_type *t)
 
 static bool btf_name_offset_valid(const struct btf *btf, u32 offset)
 {
-	return BTF_STR_OFFSET_VALID(offset) &&
-		offset < btf->hdr.str_len;
+	if (!BTF_STR_OFFSET_VALID(offset))
+		return false;
+again:
+	if (offset < btf->start_str_off) {
+		btf = btf->base_btf;
+		goto again;
+	}
+	offset -= btf->start_str_off;
+	return offset < btf->hdr.str_len;
 }
 
 static bool __btf_name_char_ok(char c, bool first, bool dot_ok)
@@ -615,10 +640,25 @@ static bool __btf_name_char_ok(char c, bool first, bool dot_ok)
 	return true;
 }
 
+static const char *btf_str_by_offset(const struct btf *btf, u32 offset)
+{
+again:
+	if (offset < btf->start_str_off) {
+		btf = btf->base_btf;
+		goto again;
+	}
+
+	offset -= btf->start_str_off;
+	if (offset < btf->hdr.str_len)
+		return &btf->strings[offset];
+
+	return NULL;
+}
+
 static bool __btf_name_valid(const struct btf *btf, u32 offset, bool dot_ok)
 {
 	/* offset must be valid */
-	const char *src = &btf->strings[offset];
+	const char *src = btf_str_by_offset(btf, offset);
 	const char *src_limit;
 
 	if (!__btf_name_char_ok(*src, true, dot_ok))
@@ -651,27 +691,31 @@ static bool btf_name_valid_section(const struct btf *btf, u32 offset)
 
 static const char *__btf_name_by_offset(const struct btf *btf, u32 offset)
 {
+	const char *name;
+
 	if (!offset)
 		return "(anon)";
-	else if (offset < btf->hdr.str_len)
-		return &btf->strings[offset];
-	else
-		return "(invalid-name-offset)";
+
+	name = btf_str_by_offset(btf, offset);
+	return name ?: "(invalid-name-offset)";
 }
 
 const char *btf_name_by_offset(const struct btf *btf, u32 offset)
 {
-	if (offset < btf->hdr.str_len)
-		return &btf->strings[offset];
-
-	return NULL;
+	return btf_str_by_offset(btf, offset);
 }
 
 const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id)
 {
-	if (type_id > btf->nr_types)
-		return NULL;
+again:
+	if (type_id < btf->start_id) {
+		btf = btf->base_btf;
+		goto again;
+	}
 
+	type_id -= btf->start_id;
+	if (type_id >= btf->nr_types)
+		return NULL;
 	return btf->types[type_id];
 }
 
@@ -1391,17 +1435,13 @@ static int btf_add_type(struct btf_verifier_env *env, struct btf_type *t)
 {
 	struct btf *btf = env->btf;
 
-	/* < 2 because +1 for btf_void which is always in btf->types[0].
-	 * btf_void is not accounted in btf->nr_types because btf_void
-	 * does not come from the BTF file.
-	 */
-	if (btf->types_size - btf->nr_types < 2) {
+	if (btf->types_size == btf->nr_types) {
 		/* Expand 'types' array */
 
 		struct btf_type **new_types;
 		u32 expand_by, new_size;
 
-		if (btf->types_size == BTF_MAX_TYPE) {
+		if (btf->start_id + btf->types_size == BTF_MAX_TYPE) {
 			btf_verifier_log(env, "Exceeded max num of types");
 			return -E2BIG;
 		}
@@ -1415,18 +1455,23 @@ static int btf_add_type(struct btf_verifier_env *env, struct btf_type *t)
 		if (!new_types)
 			return -ENOMEM;
 
-		if (btf->nr_types == 0)
-			new_types[0] = &btf_void;
-		else
+		if (btf->nr_types == 0) {
+			if (!btf->base_btf) {
+				/* lazily init VOID type */
+				new_types[0] = &btf_void;
+				btf->nr_types++;
+			}
+		} else {
 			memcpy(new_types, btf->types,
-			       sizeof(*btf->types) * (btf->nr_types + 1));
+			       sizeof(*btf->types) * btf->nr_types);
+		}
 
 		kvfree(btf->types);
 		btf->types = new_types;
 		btf->types_size = new_size;
 	}
 
-	btf->types[++(btf->nr_types)] = t;
+	btf->types[btf->nr_types++] = t;
 
 	return 0;
 }
@@ -1499,18 +1544,17 @@ static int env_resolve_init(struct btf_verifier_env *env)
 	u32 *resolved_ids = NULL;
 	u8 *visit_states = NULL;
 
-	/* +1 for btf_void */
-	resolved_sizes = kvcalloc(nr_types + 1, sizeof(*resolved_sizes),
+	resolved_sizes = kvcalloc(nr_types, sizeof(*resolved_sizes),
 				  GFP_KERNEL | __GFP_NOWARN);
 	if (!resolved_sizes)
 		goto nomem;
 
-	resolved_ids = kvcalloc(nr_types + 1, sizeof(*resolved_ids),
+	resolved_ids = kvcalloc(nr_types, sizeof(*resolved_ids),
 				GFP_KERNEL | __GFP_NOWARN);
 	if (!resolved_ids)
 		goto nomem;
 
-	visit_states = kvcalloc(nr_types + 1, sizeof(*visit_states),
+	visit_states = kvcalloc(nr_types, sizeof(*visit_states),
 				GFP_KERNEL | __GFP_NOWARN);
 	if (!visit_states)
 		goto nomem;
@@ -1562,21 +1606,27 @@ static bool env_type_is_resolve_sink(const struct btf_verifier_env *env,
 static bool env_type_is_resolved(const struct btf_verifier_env *env,
 				 u32 type_id)
 {
-	return env->visit_states[type_id] == RESOLVED;
+	/* base BTF types should be resolved by now */
+	if (type_id < env->btf->start_id)
+		return true;
+
+	return env->visit_states[type_id - env->btf->start_id] == RESOLVED;
 }
 
 static int env_stack_push(struct btf_verifier_env *env,
 			  const struct btf_type *t, u32 type_id)
 {
+	const struct btf *btf = env->btf;
 	struct resolve_vertex *v;
 
 	if (env->top_stack == MAX_RESOLVE_DEPTH)
 		return -E2BIG;
 
-	if (env->visit_states[type_id] != NOT_VISITED)
+	if (type_id < btf->start_id
+	    || env->visit_states[type_id - btf->start_id] != NOT_VISITED)
 		return -EEXIST;
 
-	env->visit_states[type_id] = VISITED;
+	env->visit_states[type_id - btf->start_id] = VISITED;
 
 	v = &env->stack[env->top_stack++];
 	v->t = t;
@@ -1606,6 +1656,7 @@ static void env_stack_pop_resolved(struct btf_verifier_env *env,
 	u32 type_id = env->stack[--(env->top_stack)].type_id;
 	struct btf *btf = env->btf;
 
+	type_id -= btf->start_id; /* adjust to local type id */
 	btf->resolved_sizes[type_id] = resolved_size;
 	btf->resolved_ids[type_id] = resolved_type_id;
 	env->visit_states[type_id] = RESOLVED;
@@ -1710,14 +1761,34 @@ btf_resolve_size(const struct btf *btf, const struct btf_type *type,
 	return __btf_resolve_size(btf, type, type_size, NULL, NULL, NULL, NULL);
 }
 
+static u32 btf_resolved_type_id(const struct btf *btf, u32 type_id)
+{
+again:
+	if (type_id < btf->start_id) {
+		btf = btf->base_btf;
+		goto again;
+	}
+	return btf->resolved_ids[type_id - btf->start_id];
+}
+
 /* The input param "type_id" must point to a needs_resolve type */
 static const struct btf_type *btf_type_id_resolve(const struct btf *btf,
 						  u32 *type_id)
 {
-	*type_id = btf->resolved_ids[*type_id];
+	*type_id = btf_resolved_type_id(btf, *type_id);
 	return btf_type_by_id(btf, *type_id);
 }
 
+static u32 btf_resolved_type_size(const struct btf *btf, u32 type_id)
+{
+again:
+	if (type_id < btf->start_id) {
+		btf = btf->base_btf;
+		goto again;
+	}
+	return btf->resolved_sizes[type_id - btf->start_id];
+}
+
 const struct btf_type *btf_type_id_size(const struct btf *btf,
 					u32 *type_id, u32 *ret_size)
 {
@@ -1732,7 +1803,7 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
 	if (btf_type_has_size(size_type)) {
 		size = size_type->size;
 	} else if (btf_type_is_array(size_type)) {
-		size = btf->resolved_sizes[size_type_id];
+		size = btf_resolved_type_size(btf, size_type_id);
 	} else if (btf_type_is_ptr(size_type)) {
 		size = sizeof(void *);
 	} else {
@@ -1740,14 +1811,14 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
 				 !btf_type_is_var(size_type)))
 			return NULL;
 
-		size_type_id = btf->resolved_ids[size_type_id];
+		size_type_id = btf_resolved_type_id(btf, size_type_id);
 		size_type = btf_type_by_id(btf, size_type_id);
 		if (btf_type_nosize_or_null(size_type))
 			return NULL;
 		else if (btf_type_has_size(size_type))
 			size = size_type->size;
 		else if (btf_type_is_array(size_type))
-			size = btf->resolved_sizes[size_type_id];
+			size = btf_resolved_type_size(btf, size_type_id);
 		else if (btf_type_is_ptr(size_type))
 			size = sizeof(void *);
 		else
@@ -3799,7 +3870,7 @@ static int btf_check_all_metas(struct btf_verifier_env *env)
 	cur = btf->nohdr_data + hdr->type_off;
 	end = cur + hdr->type_len;
 
-	env->log_type_id = 1;
+	env->log_type_id = btf->base_btf ? btf->start_id : 1;
 	while (cur < end) {
 		struct btf_type *t = cur;
 		s32 meta_size;
@@ -3826,8 +3897,8 @@ static bool btf_resolve_valid(struct btf_verifier_env *env,
 		return false;
 
 	if (btf_type_is_struct(t) || btf_type_is_datasec(t))
-		return !btf->resolved_ids[type_id] &&
-		       !btf->resolved_sizes[type_id];
+		return !btf_resolved_type_id(btf, type_id) &&
+		       !btf_resolved_type_size(btf, type_id);
 
 	if (btf_type_is_modifier(t) || btf_type_is_ptr(t) ||
 	    btf_type_is_var(t)) {
@@ -3847,7 +3918,7 @@ static bool btf_resolve_valid(struct btf_verifier_env *env,
 		elem_type = btf_type_id_size(btf, &elem_type_id, &elem_size);
 		return elem_type && !btf_type_is_modifier(elem_type) &&
 			(array->nelems * elem_size ==
-			 btf->resolved_sizes[type_id]);
+			 btf_resolved_type_size(btf, type_id));
 	}
 
 	return false;
@@ -3889,7 +3960,8 @@ static int btf_resolve(struct btf_verifier_env *env,
 static int btf_check_all_types(struct btf_verifier_env *env)
 {
 	struct btf *btf = env->btf;
-	u32 type_id;
+	const struct btf_type *t;
+	u32 type_id, i;
 	int err;
 
 	err = env_resolve_init(env);
@@ -3897,8 +3969,9 @@ static int btf_check_all_types(struct btf_verifier_env *env)
 		return err;
 
 	env->phase++;
-	for (type_id = 1; type_id <= btf->nr_types; type_id++) {
-		const struct btf_type *t = btf_type_by_id(btf, type_id);
+	for (i = btf->base_btf ? 0 : 1; i < btf->nr_types; i++) {
+		type_id = btf->start_id + i;
+		t = btf_type_by_id(btf, type_id);
 
 		env->log_type_id = type_id;
 		if (btf_type_needs_resolve(t) &&
@@ -3935,7 +4008,7 @@ static int btf_parse_type_sec(struct btf_verifier_env *env)
 		return -EINVAL;
 	}
 
-	if (!hdr->type_len) {
+	if (!env->btf->base_btf && !hdr->type_len) {
 		btf_verifier_log(env, "No type found");
 		return -EINVAL;
 	}
@@ -3962,13 +4035,18 @@ static int btf_parse_str_sec(struct btf_verifier_env *env)
 		return -EINVAL;
 	}
 
-	if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_NAME_OFFSET ||
-	    start[0] || end[-1]) {
+	btf->strings = start;
+
+	if (btf->base_btf && !hdr->str_len)
+		return 0;
+	if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_NAME_OFFSET || end[-1]) {
+		btf_verifier_log(env, "Invalid string section");
+		return -EINVAL;
+	}
+	if (!btf->base_btf && start[0]) {
 		btf_verifier_log(env, "Invalid string section");
 		return -EINVAL;
 	}
-
-	btf->strings = start;
 
 	return 0;
 }
@@ -4909,7 +4987,7 @@ static int __get_type_size(struct btf *btf, u32 btf_id,
 	while (t && btf_type_is_modifier(t))
 		t = btf_type_by_id(btf, t->type);
 	if (!t) {
-		*bad_type = btf->types[0];
+		*bad_type = btf_type_by_id(btf, 0);
 		return -EINVAL;
 	}
 	if (btf_type_is_ptr(t))
-- 
2.24.1

