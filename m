Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2593A85548
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 23:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388976AbfHGVkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 17:40:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4900 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388136AbfHGVkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 17:40:13 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x77LchDE018266
        for <netdev@vger.kernel.org>; Wed, 7 Aug 2019 14:40:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=vArHqhRpJd9sMJGjyOAYYc9DpOKL/Bsm3KXL1fMyz5c=;
 b=JF3YFaOIAmA22NVLeQ6tDlJZkEBIh9qYiPB7P9BCUvNArls96fzKYkwN4V6G2naTp+Pv
 2dJ2pVz86Ydsxw7h4y7V2bauzHuIN/p5cTj5PC/7UEHSQAIqmpVOU/JxOKER2Sr3H9YW
 vg7R/lNkjGrpZpG2h88LkG2v8xTOe4ATcyY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u86j681pp-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 14:40:09 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Aug 2019 14:40:07 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 643A7861682; Wed,  7 Aug 2019 14:40:06 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v6 bpf-next 02/14] libbpf: convert libbpf code to use new btf helpers
Date:   Wed, 7 Aug 2019 14:39:49 -0700
Message-ID: <20190807214001.872988-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190807214001.872988-1-andriin@fb.com>
References: <20190807214001.872988-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify code by relying on newly added BTF helper functions.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c      | 181 ++++++++++++++++++---------------------
 tools/lib/bpf/btf_dump.c | 138 ++++++++++-------------------
 tools/lib/bpf/libbpf.c   |  60 +++++++------
 3 files changed, 158 insertions(+), 221 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 467224feb43b..1cd4e5d67158 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -19,13 +19,6 @@
 #define BTF_MAX_NR_TYPES 0x7fffffff
 #define BTF_MAX_STR_OFFSET 0x7fffffff
 
-#define IS_MODIFIER(k) (((k) == BTF_KIND_TYPEDEF) || \
-		((k) == BTF_KIND_VOLATILE) || \
-		((k) == BTF_KIND_CONST) || \
-		((k) == BTF_KIND_RESTRICT))
-
-#define IS_VAR(k) ((k) == BTF_KIND_VAR)
-
 static struct btf_type btf_void;
 
 struct btf {
@@ -192,9 +185,9 @@ static int btf_parse_str_sec(struct btf *btf)
 static int btf_type_size(struct btf_type *t)
 {
 	int base_size = sizeof(struct btf_type);
-	__u16 vlen = BTF_INFO_VLEN(t->info);
+	__u16 vlen = btf_vlen(t);
 
-	switch (BTF_INFO_KIND(t->info)) {
+	switch (btf_kind(t)) {
 	case BTF_KIND_FWD:
 	case BTF_KIND_CONST:
 	case BTF_KIND_VOLATILE:
@@ -219,7 +212,7 @@ static int btf_type_size(struct btf_type *t)
 	case BTF_KIND_DATASEC:
 		return base_size + vlen * sizeof(struct btf_var_secinfo);
 	default:
-		pr_debug("Unsupported BTF_KIND:%u\n", BTF_INFO_KIND(t->info));
+		pr_debug("Unsupported BTF_KIND:%u\n", btf_kind(t));
 		return -EINVAL;
 	}
 }
@@ -263,7 +256,7 @@ const struct btf_type *btf__type_by_id(const struct btf *btf, __u32 type_id)
 
 static bool btf_type_is_void(const struct btf_type *t)
 {
-	return t == &btf_void || BTF_INFO_KIND(t->info) == BTF_KIND_FWD;
+	return t == &btf_void || btf_is_fwd(t);
 }
 
 static bool btf_type_is_void_or_null(const struct btf_type *t)
@@ -284,7 +277,7 @@ __s64 btf__resolve_size(const struct btf *btf, __u32 type_id)
 	t = btf__type_by_id(btf, type_id);
 	for (i = 0; i < MAX_RESOLVE_DEPTH && !btf_type_is_void_or_null(t);
 	     i++) {
-		switch (BTF_INFO_KIND(t->info)) {
+		switch (btf_kind(t)) {
 		case BTF_KIND_INT:
 		case BTF_KIND_STRUCT:
 		case BTF_KIND_UNION:
@@ -303,7 +296,7 @@ __s64 btf__resolve_size(const struct btf *btf, __u32 type_id)
 			type_id = t->type;
 			break;
 		case BTF_KIND_ARRAY:
-			array = (const struct btf_array *)(t + 1);
+			array = btf_array(t);
 			if (nelems && array->nelems > UINT32_MAX / nelems)
 				return -E2BIG;
 			nelems *= array->nelems;
@@ -334,8 +327,7 @@ int btf__resolve_type(const struct btf *btf, __u32 type_id)
 	t = btf__type_by_id(btf, type_id);
 	while (depth < MAX_RESOLVE_DEPTH &&
 	       !btf_type_is_void_or_null(t) &&
-	       (IS_MODIFIER(BTF_INFO_KIND(t->info)) ||
-		IS_VAR(BTF_INFO_KIND(t->info)))) {
+	       (btf_is_mod(t) || btf_is_typedef(t) || btf_is_var(t))) {
 		type_id = t->type;
 		t = btf__type_by_id(btf, type_id);
 		depth++;
@@ -554,11 +546,11 @@ static int compare_vsi_off(const void *_a, const void *_b)
 static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
 			     struct btf_type *t)
 {
-	__u32 size = 0, off = 0, i, vars = BTF_INFO_VLEN(t->info);
+	__u32 size = 0, off = 0, i, vars = btf_vlen(t);
 	const char *name = btf__name_by_offset(btf, t->name_off);
 	const struct btf_type *t_var;
 	struct btf_var_secinfo *vsi;
-	struct btf_var *var;
+	const struct btf_var *var;
 	int ret;
 
 	if (!name) {
@@ -574,12 +566,11 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
 
 	t->size = size;
 
-	for (i = 0, vsi = (struct btf_var_secinfo *)(t + 1);
-	     i < vars; i++, vsi++) {
+	for (i = 0, vsi = btf_var_secinfos(t); i < vars; i++, vsi++) {
 		t_var = btf__type_by_id(btf, vsi->type);
-		var = (struct btf_var *)(t_var + 1);
+		var = btf_var(t_var);
 
-		if (BTF_INFO_KIND(t_var->info) != BTF_KIND_VAR) {
+		if (!btf_is_var(t_var)) {
 			pr_debug("Non-VAR type seen in section %s\n", name);
 			return -EINVAL;
 		}
@@ -595,7 +586,8 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
 
 		ret = bpf_object__variable_offset(obj, name, &off);
 		if (ret) {
-			pr_debug("No offset found in symbol table for VAR %s\n", name);
+			pr_debug("No offset found in symbol table for VAR %s\n",
+				 name);
 			return -ENOENT;
 		}
 
@@ -619,7 +611,7 @@ int btf__finalize_data(struct bpf_object *obj, struct btf *btf)
 		 * is section size and global variable offset. We use
 		 * the info from the ELF itself for this purpose.
 		 */
-		if (BTF_INFO_KIND(t->info) == BTF_KIND_DATASEC) {
+		if (btf_is_datasec(t)) {
 			err = btf_fixup_datasec(obj, btf, t);
 			if (err)
 				break;
@@ -774,14 +766,13 @@ int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 		return -EINVAL;
 	}
 
-	if (BTF_INFO_KIND(container_type->info) != BTF_KIND_STRUCT ||
-	    BTF_INFO_VLEN(container_type->info) < 2) {
+	if (!btf_is_struct(container_type) || btf_vlen(container_type) < 2) {
 		pr_warning("map:%s container_name:%s is an invalid container struct\n",
 			   map_name, container_name);
 		return -EINVAL;
 	}
 
-	key = (struct btf_member *)(container_type + 1);
+	key = btf_members(container_type);
 	value = key + 1;
 
 	key_size = btf__resolve_size(btf, key->type);
@@ -1440,10 +1431,9 @@ static struct btf_dedup *btf_dedup_new(struct btf *btf, struct btf_ext *btf_ext,
 	d->map[0] = 0;
 	for (i = 1; i <= btf->nr_types; i++) {
 		struct btf_type *t = d->btf->types[i];
-		__u16 kind = BTF_INFO_KIND(t->info);
 
 		/* VAR and DATASEC are never deduped and are self-canonical */
-		if (kind == BTF_KIND_VAR || kind == BTF_KIND_DATASEC)
+		if (btf_is_var(t) || btf_is_datasec(t))
 			d->map[i] = i;
 		else
 			d->map[i] = BTF_UNPROCESSED_ID;
@@ -1484,11 +1474,11 @@ static int btf_for_each_str_off(struct btf_dedup *d, str_off_fn_t fn, void *ctx)
 		if (r)
 			return r;
 
-		switch (BTF_INFO_KIND(t->info)) {
+		switch (btf_kind(t)) {
 		case BTF_KIND_STRUCT:
 		case BTF_KIND_UNION: {
-			struct btf_member *m = (struct btf_member *)(t + 1);
-			__u16 vlen = BTF_INFO_VLEN(t->info);
+			struct btf_member *m = btf_members(t);
+			__u16 vlen = btf_vlen(t);
 
 			for (j = 0; j < vlen; j++) {
 				r = fn(&m->name_off, ctx);
@@ -1499,8 +1489,8 @@ static int btf_for_each_str_off(struct btf_dedup *d, str_off_fn_t fn, void *ctx)
 			break;
 		}
 		case BTF_KIND_ENUM: {
-			struct btf_enum *m = (struct btf_enum *)(t + 1);
-			__u16 vlen = BTF_INFO_VLEN(t->info);
+			struct btf_enum *m = btf_enum(t);
+			__u16 vlen = btf_vlen(t);
 
 			for (j = 0; j < vlen; j++) {
 				r = fn(&m->name_off, ctx);
@@ -1511,8 +1501,8 @@ static int btf_for_each_str_off(struct btf_dedup *d, str_off_fn_t fn, void *ctx)
 			break;
 		}
 		case BTF_KIND_FUNC_PROTO: {
-			struct btf_param *m = (struct btf_param *)(t + 1);
-			__u16 vlen = BTF_INFO_VLEN(t->info);
+			struct btf_param *m = btf_params(t);
+			__u16 vlen = btf_vlen(t);
 
 			for (j = 0; j < vlen; j++) {
 				r = fn(&m->name_off, ctx);
@@ -1801,16 +1791,16 @@ static long btf_hash_enum(struct btf_type *t)
 /* Check structural equality of two ENUMs. */
 static bool btf_equal_enum(struct btf_type *t1, struct btf_type *t2)
 {
-	struct btf_enum *m1, *m2;
+	const struct btf_enum *m1, *m2;
 	__u16 vlen;
 	int i;
 
 	if (!btf_equal_common(t1, t2))
 		return false;
 
-	vlen = BTF_INFO_VLEN(t1->info);
-	m1 = (struct btf_enum *)(t1 + 1);
-	m2 = (struct btf_enum *)(t2 + 1);
+	vlen = btf_vlen(t1);
+	m1 = btf_enum(t1);
+	m2 = btf_enum(t2);
 	for (i = 0; i < vlen; i++) {
 		if (m1->name_off != m2->name_off || m1->val != m2->val)
 			return false;
@@ -1822,8 +1812,7 @@ static bool btf_equal_enum(struct btf_type *t1, struct btf_type *t2)
 
 static inline bool btf_is_enum_fwd(struct btf_type *t)
 {
-	return BTF_INFO_KIND(t->info) == BTF_KIND_ENUM &&
-	       BTF_INFO_VLEN(t->info) == 0;
+	return btf_is_enum(t) && btf_vlen(t) == 0;
 }
 
 static bool btf_compat_enum(struct btf_type *t1, struct btf_type *t2)
@@ -1843,8 +1832,8 @@ static bool btf_compat_enum(struct btf_type *t1, struct btf_type *t2)
  */
 static long btf_hash_struct(struct btf_type *t)
 {
-	struct btf_member *member = (struct btf_member *)(t + 1);
-	__u32 vlen = BTF_INFO_VLEN(t->info);
+	const struct btf_member *member = btf_members(t);
+	__u32 vlen = btf_vlen(t);
 	long h = btf_hash_common(t);
 	int i;
 
@@ -1864,16 +1853,16 @@ static long btf_hash_struct(struct btf_type *t)
  */
 static bool btf_shallow_equal_struct(struct btf_type *t1, struct btf_type *t2)
 {
-	struct btf_member *m1, *m2;
+	const struct btf_member *m1, *m2;
 	__u16 vlen;
 	int i;
 
 	if (!btf_equal_common(t1, t2))
 		return false;
 
-	vlen = BTF_INFO_VLEN(t1->info);
-	m1 = (struct btf_member *)(t1 + 1);
-	m2 = (struct btf_member *)(t2 + 1);
+	vlen = btf_vlen(t1);
+	m1 = btf_members(t1);
+	m2 = btf_members(t2);
 	for (i = 0; i < vlen; i++) {
 		if (m1->name_off != m2->name_off || m1->offset != m2->offset)
 			return false;
@@ -1890,7 +1879,7 @@ static bool btf_shallow_equal_struct(struct btf_type *t1, struct btf_type *t2)
  */
 static long btf_hash_array(struct btf_type *t)
 {
-	struct btf_array *info = (struct btf_array *)(t + 1);
+	const struct btf_array *info = btf_array(t);
 	long h = btf_hash_common(t);
 
 	h = hash_combine(h, info->type);
@@ -1908,13 +1897,13 @@ static long btf_hash_array(struct btf_type *t)
  */
 static bool btf_equal_array(struct btf_type *t1, struct btf_type *t2)
 {
-	struct btf_array *info1, *info2;
+	const struct btf_array *info1, *info2;
 
 	if (!btf_equal_common(t1, t2))
 		return false;
 
-	info1 = (struct btf_array *)(t1 + 1);
-	info2 = (struct btf_array *)(t2 + 1);
+	info1 = btf_array(t1);
+	info2 = btf_array(t2);
 	return info1->type == info2->type &&
 	       info1->index_type == info2->index_type &&
 	       info1->nelems == info2->nelems;
@@ -1927,14 +1916,10 @@ static bool btf_equal_array(struct btf_type *t1, struct btf_type *t2)
  */
 static bool btf_compat_array(struct btf_type *t1, struct btf_type *t2)
 {
-	struct btf_array *info1, *info2;
-
 	if (!btf_equal_common(t1, t2))
 		return false;
 
-	info1 = (struct btf_array *)(t1 + 1);
-	info2 = (struct btf_array *)(t2 + 1);
-	return info1->nelems == info2->nelems;
+	return btf_array(t1)->nelems == btf_array(t2)->nelems;
 }
 
 /*
@@ -1944,8 +1929,8 @@ static bool btf_compat_array(struct btf_type *t1, struct btf_type *t2)
  */
 static long btf_hash_fnproto(struct btf_type *t)
 {
-	struct btf_param *member = (struct btf_param *)(t + 1);
-	__u16 vlen = BTF_INFO_VLEN(t->info);
+	const struct btf_param *member = btf_params(t);
+	__u16 vlen = btf_vlen(t);
 	long h = btf_hash_common(t);
 	int i;
 
@@ -1966,16 +1951,16 @@ static long btf_hash_fnproto(struct btf_type *t)
  */
 static bool btf_equal_fnproto(struct btf_type *t1, struct btf_type *t2)
 {
-	struct btf_param *m1, *m2;
+	const struct btf_param *m1, *m2;
 	__u16 vlen;
 	int i;
 
 	if (!btf_equal_common(t1, t2))
 		return false;
 
-	vlen = BTF_INFO_VLEN(t1->info);
-	m1 = (struct btf_param *)(t1 + 1);
-	m2 = (struct btf_param *)(t2 + 1);
+	vlen = btf_vlen(t1);
+	m1 = btf_params(t1);
+	m2 = btf_params(t2);
 	for (i = 0; i < vlen; i++) {
 		if (m1->name_off != m2->name_off || m1->type != m2->type)
 			return false;
@@ -1992,7 +1977,7 @@ static bool btf_equal_fnproto(struct btf_type *t1, struct btf_type *t2)
  */
 static bool btf_compat_fnproto(struct btf_type *t1, struct btf_type *t2)
 {
-	struct btf_param *m1, *m2;
+	const struct btf_param *m1, *m2;
 	__u16 vlen;
 	int i;
 
@@ -2000,9 +1985,9 @@ static bool btf_compat_fnproto(struct btf_type *t1, struct btf_type *t2)
 	if (t1->name_off != t2->name_off || t1->info != t2->info)
 		return false;
 
-	vlen = BTF_INFO_VLEN(t1->info);
-	m1 = (struct btf_param *)(t1 + 1);
-	m2 = (struct btf_param *)(t2 + 1);
+	vlen = btf_vlen(t1);
+	m1 = btf_params(t1);
+	m2 = btf_params(t2);
 	for (i = 0; i < vlen; i++) {
 		if (m1->name_off != m2->name_off)
 			return false;
@@ -2028,7 +2013,7 @@ static int btf_dedup_prim_type(struct btf_dedup *d, __u32 type_id)
 	__u32 cand_id;
 	long h;
 
-	switch (BTF_INFO_KIND(t->info)) {
+	switch (btf_kind(t)) {
 	case BTF_KIND_CONST:
 	case BTF_KIND_VOLATILE:
 	case BTF_KIND_RESTRICT:
@@ -2141,13 +2126,13 @@ static uint32_t resolve_fwd_id(struct btf_dedup *d, uint32_t type_id)
 {
 	__u32 orig_type_id = type_id;
 
-	if (BTF_INFO_KIND(d->btf->types[type_id]->info) != BTF_KIND_FWD)
+	if (!btf_is_fwd(d->btf->types[type_id]))
 		return type_id;
 
 	while (is_type_mapped(d, type_id) && d->map[type_id] != type_id)
 		type_id = d->map[type_id];
 
-	if (BTF_INFO_KIND(d->btf->types[type_id]->info) != BTF_KIND_FWD)
+	if (!btf_is_fwd(d->btf->types[type_id]))
 		return type_id;
 
 	return orig_type_id;
@@ -2156,7 +2141,7 @@ static uint32_t resolve_fwd_id(struct btf_dedup *d, uint32_t type_id)
 
 static inline __u16 btf_fwd_kind(struct btf_type *t)
 {
-	return BTF_INFO_KFLAG(t->info) ? BTF_KIND_UNION : BTF_KIND_STRUCT;
+	return btf_kflag(t) ? BTF_KIND_UNION : BTF_KIND_STRUCT;
 }
 
 /*
@@ -2277,8 +2262,8 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
 
 	cand_type = d->btf->types[cand_id];
 	canon_type = d->btf->types[canon_id];
-	cand_kind = BTF_INFO_KIND(cand_type->info);
-	canon_kind = BTF_INFO_KIND(canon_type->info);
+	cand_kind = btf_kind(cand_type);
+	canon_kind = btf_kind(canon_type);
 
 	if (cand_type->name_off != canon_type->name_off)
 		return 0;
@@ -2327,12 +2312,12 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
 		return btf_dedup_is_equiv(d, cand_type->type, canon_type->type);
 
 	case BTF_KIND_ARRAY: {
-		struct btf_array *cand_arr, *canon_arr;
+		const struct btf_array *cand_arr, *canon_arr;
 
 		if (!btf_compat_array(cand_type, canon_type))
 			return 0;
-		cand_arr = (struct btf_array *)(cand_type + 1);
-		canon_arr = (struct btf_array *)(canon_type + 1);
+		cand_arr = btf_array(cand_type);
+		canon_arr = btf_array(canon_type);
 		eq = btf_dedup_is_equiv(d,
 			cand_arr->index_type, canon_arr->index_type);
 		if (eq <= 0)
@@ -2342,14 +2327,14 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
 
 	case BTF_KIND_STRUCT:
 	case BTF_KIND_UNION: {
-		struct btf_member *cand_m, *canon_m;
+		const struct btf_member *cand_m, *canon_m;
 		__u16 vlen;
 
 		if (!btf_shallow_equal_struct(cand_type, canon_type))
 			return 0;
-		vlen = BTF_INFO_VLEN(cand_type->info);
-		cand_m = (struct btf_member *)(cand_type + 1);
-		canon_m = (struct btf_member *)(canon_type + 1);
+		vlen = btf_vlen(cand_type);
+		cand_m = btf_members(cand_type);
+		canon_m = btf_members(canon_type);
 		for (i = 0; i < vlen; i++) {
 			eq = btf_dedup_is_equiv(d, cand_m->type, canon_m->type);
 			if (eq <= 0)
@@ -2362,7 +2347,7 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
 	}
 
 	case BTF_KIND_FUNC_PROTO: {
-		struct btf_param *cand_p, *canon_p;
+		const struct btf_param *cand_p, *canon_p;
 		__u16 vlen;
 
 		if (!btf_compat_fnproto(cand_type, canon_type))
@@ -2370,9 +2355,9 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
 		eq = btf_dedup_is_equiv(d, cand_type->type, canon_type->type);
 		if (eq <= 0)
 			return eq;
-		vlen = BTF_INFO_VLEN(cand_type->info);
-		cand_p = (struct btf_param *)(cand_type + 1);
-		canon_p = (struct btf_param *)(canon_type + 1);
+		vlen = btf_vlen(cand_type);
+		cand_p = btf_params(cand_type);
+		canon_p = btf_params(canon_type);
 		for (i = 0; i < vlen; i++) {
 			eq = btf_dedup_is_equiv(d, cand_p->type, canon_p->type);
 			if (eq <= 0)
@@ -2427,8 +2412,8 @@ static void btf_dedup_merge_hypot_map(struct btf_dedup *d)
 		targ_type_id = d->hypot_map[cand_type_id];
 		t_id = resolve_type_id(d, targ_type_id);
 		c_id = resolve_type_id(d, cand_type_id);
-		t_kind = BTF_INFO_KIND(d->btf->types[t_id]->info);
-		c_kind = BTF_INFO_KIND(d->btf->types[c_id]->info);
+		t_kind = btf_kind(d->btf->types[t_id]);
+		c_kind = btf_kind(d->btf->types[c_id]);
 		/*
 		 * Resolve FWD into STRUCT/UNION.
 		 * It's ok to resolve FWD into STRUCT/UNION that's not yet
@@ -2497,7 +2482,7 @@ static int btf_dedup_struct_type(struct btf_dedup *d, __u32 type_id)
 		return 0;
 
 	t = d->btf->types[type_id];
-	kind = BTF_INFO_KIND(t->info);
+	kind = btf_kind(t);
 
 	if (kind != BTF_KIND_STRUCT && kind != BTF_KIND_UNION)
 		return 0;
@@ -2592,7 +2577,7 @@ static int btf_dedup_ref_type(struct btf_dedup *d, __u32 type_id)
 	t = d->btf->types[type_id];
 	d->map[type_id] = BTF_IN_PROGRESS_ID;
 
-	switch (BTF_INFO_KIND(t->info)) {
+	switch (btf_kind(t)) {
 	case BTF_KIND_CONST:
 	case BTF_KIND_VOLATILE:
 	case BTF_KIND_RESTRICT:
@@ -2616,7 +2601,7 @@ static int btf_dedup_ref_type(struct btf_dedup *d, __u32 type_id)
 		break;
 
 	case BTF_KIND_ARRAY: {
-		struct btf_array *info = (struct btf_array *)(t + 1);
+		struct btf_array *info = btf_array(t);
 
 		ref_type_id = btf_dedup_ref_type(d, info->type);
 		if (ref_type_id < 0)
@@ -2650,8 +2635,8 @@ static int btf_dedup_ref_type(struct btf_dedup *d, __u32 type_id)
 			return ref_type_id;
 		t->type = ref_type_id;
 
-		vlen = BTF_INFO_VLEN(t->info);
-		param = (struct btf_param *)(t + 1);
+		vlen = btf_vlen(t);
+		param = btf_params(t);
 		for (i = 0; i < vlen; i++) {
 			ref_type_id = btf_dedup_ref_type(d, param->type);
 			if (ref_type_id < 0)
@@ -2791,7 +2776,7 @@ static int btf_dedup_remap_type(struct btf_dedup *d, __u32 type_id)
 	struct btf_type *t = d->btf->types[type_id];
 	int i, r;
 
-	switch (BTF_INFO_KIND(t->info)) {
+	switch (btf_kind(t)) {
 	case BTF_KIND_INT:
 	case BTF_KIND_ENUM:
 		break;
@@ -2811,7 +2796,7 @@ static int btf_dedup_remap_type(struct btf_dedup *d, __u32 type_id)
 		break;
 
 	case BTF_KIND_ARRAY: {
-		struct btf_array *arr_info = (struct btf_array *)(t + 1);
+		struct btf_array *arr_info = btf_array(t);
 
 		r = btf_dedup_remap_type_id(d, arr_info->type);
 		if (r < 0)
@@ -2826,8 +2811,8 @@ static int btf_dedup_remap_type(struct btf_dedup *d, __u32 type_id)
 
 	case BTF_KIND_STRUCT:
 	case BTF_KIND_UNION: {
-		struct btf_member *member = (struct btf_member *)(t + 1);
-		__u16 vlen = BTF_INFO_VLEN(t->info);
+		struct btf_member *member = btf_members(t);
+		__u16 vlen = btf_vlen(t);
 
 		for (i = 0; i < vlen; i++) {
 			r = btf_dedup_remap_type_id(d, member->type);
@@ -2840,8 +2825,8 @@ static int btf_dedup_remap_type(struct btf_dedup *d, __u32 type_id)
 	}
 
 	case BTF_KIND_FUNC_PROTO: {
-		struct btf_param *param = (struct btf_param *)(t + 1);
-		__u16 vlen = BTF_INFO_VLEN(t->info);
+		struct btf_param *param = btf_params(t);
+		__u16 vlen = btf_vlen(t);
 
 		r = btf_dedup_remap_type_id(d, t->type);
 		if (r < 0)
@@ -2859,8 +2844,8 @@ static int btf_dedup_remap_type(struct btf_dedup *d, __u32 type_id)
 	}
 
 	case BTF_KIND_DATASEC: {
-		struct btf_var_secinfo *var = (struct btf_var_secinfo *)(t + 1);
-		__u16 vlen = BTF_INFO_VLEN(t->info);
+		struct btf_var_secinfo *var = btf_var_secinfos(t);
+		__u16 vlen = btf_vlen(t);
 
 		for (i = 0; i < vlen; i++) {
 			r = btf_dedup_remap_type_id(d, var->type);
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 7065bb5b2752..715967762312 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -100,21 +100,6 @@ static bool str_equal_fn(const void *a, const void *b, void *ctx)
 	return strcmp(a, b) == 0;
 }
 
-static __u16 btf_kind_of(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info);
-}
-
-static __u16 btf_vlen_of(const struct btf_type *t)
-{
-	return BTF_INFO_VLEN(t->info);
-}
-
-static bool btf_kflag_of(const struct btf_type *t)
-{
-	return BTF_INFO_KFLAG(t->info);
-}
-
 static const char *btf_name_of(const struct btf_dump *d, __u32 name_off)
 {
 	return btf__name_by_offset(d->btf, name_off);
@@ -349,7 +334,7 @@ static int btf_dump_order_type(struct btf_dump *d, __u32 id, bool through_ptr)
 	 */
 	struct btf_dump_type_aux_state *tstate = &d->type_states[id];
 	const struct btf_type *t;
-	__u16 kind, vlen;
+	__u16 vlen;
 	int err, i;
 
 	/* return true, letting typedefs know that it's ok to be emitted */
@@ -357,18 +342,16 @@ static int btf_dump_order_type(struct btf_dump *d, __u32 id, bool through_ptr)
 		return 1;
 
 	t = btf__type_by_id(d->btf, id);
-	kind = btf_kind_of(t);
 
 	if (tstate->order_state == ORDERING) {
 		/* type loop, but resolvable through fwd declaration */
-		if ((kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION) &&
-		    through_ptr && t->name_off != 0)
+		if (btf_is_composite(t) && through_ptr && t->name_off != 0)
 			return 0;
 		pr_warning("unsatisfiable type cycle, id:[%u]\n", id);
 		return -ELOOP;
 	}
 
-	switch (kind) {
+	switch (btf_kind(t)) {
 	case BTF_KIND_INT:
 		tstate->order_state = ORDERED;
 		return 0;
@@ -378,14 +361,12 @@ static int btf_dump_order_type(struct btf_dump *d, __u32 id, bool through_ptr)
 		tstate->order_state = ORDERED;
 		return err;
 
-	case BTF_KIND_ARRAY: {
-		const struct btf_array *a = (void *)(t + 1);
+	case BTF_KIND_ARRAY:
+		return btf_dump_order_type(d, btf_array(t)->type, through_ptr);
 
-		return btf_dump_order_type(d, a->type, through_ptr);
-	}
 	case BTF_KIND_STRUCT:
 	case BTF_KIND_UNION: {
-		const struct btf_member *m = (void *)(t + 1);
+		const struct btf_member *m = btf_members(t);
 		/*
 		 * struct/union is part of strong link, only if it's embedded
 		 * (so no ptr in a path) or it's anonymous (so has to be
@@ -396,7 +377,7 @@ static int btf_dump_order_type(struct btf_dump *d, __u32 id, bool through_ptr)
 
 		tstate->order_state = ORDERING;
 
-		vlen = btf_vlen_of(t);
+		vlen = btf_vlen(t);
 		for (i = 0; i < vlen; i++, m++) {
 			err = btf_dump_order_type(d, m->type, false);
 			if (err < 0)
@@ -447,7 +428,7 @@ static int btf_dump_order_type(struct btf_dump *d, __u32 id, bool through_ptr)
 		return btf_dump_order_type(d, t->type, through_ptr);
 
 	case BTF_KIND_FUNC_PROTO: {
-		const struct btf_param *p = (void *)(t + 1);
+		const struct btf_param *p = btf_params(t);
 		bool is_strong;
 
 		err = btf_dump_order_type(d, t->type, through_ptr);
@@ -455,7 +436,7 @@ static int btf_dump_order_type(struct btf_dump *d, __u32 id, bool through_ptr)
 			return err;
 		is_strong = err > 0;
 
-		vlen = btf_vlen_of(t);
+		vlen = btf_vlen(t);
 		for (i = 0; i < vlen; i++, p++) {
 			err = btf_dump_order_type(d, p->type, through_ptr);
 			if (err < 0)
@@ -553,7 +534,7 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 		return;
 
 	t = btf__type_by_id(d->btf, id);
-	kind = btf_kind_of(t);
+	kind = btf_kind(t);
 
 	if (top_level_def && t->name_off == 0) {
 		pr_warning("unexpected nameless definition, id:[%u]\n", id);
@@ -618,12 +599,9 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 	case BTF_KIND_RESTRICT:
 		btf_dump_emit_type(d, t->type, cont_id);
 		break;
-	case BTF_KIND_ARRAY: {
-		const struct btf_array *a = (void *)(t + 1);
-
-		btf_dump_emit_type(d, a->type, cont_id);
+	case BTF_KIND_ARRAY:
+		btf_dump_emit_type(d, btf_array(t)->type, cont_id);
 		break;
-	}
 	case BTF_KIND_FWD:
 		btf_dump_emit_fwd_def(d, id, t);
 		btf_dump_printf(d, ";\n\n");
@@ -656,8 +634,8 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 		 * applicable
 		 */
 		if (top_level_def || t->name_off == 0) {
-			const struct btf_member *m = (void *)(t + 1);
-			__u16 vlen = btf_vlen_of(t);
+			const struct btf_member *m = btf_members(t);
+			__u16 vlen = btf_vlen(t);
 			int i, new_cont_id;
 
 			new_cont_id = t->name_off == 0 ? cont_id : id;
@@ -678,8 +656,8 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 		}
 		break;
 	case BTF_KIND_FUNC_PROTO: {
-		const struct btf_param *p = (void *)(t + 1);
-		__u16 vlen = btf_vlen_of(t);
+		const struct btf_param *p = btf_params(t);
+		__u16 vlen = btf_vlen(t);
 		int i;
 
 		btf_dump_emit_type(d, t->type, cont_id);
@@ -696,7 +674,7 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 static int btf_align_of(const struct btf *btf, __u32 id)
 {
 	const struct btf_type *t = btf__type_by_id(btf, id);
-	__u16 kind = btf_kind_of(t);
+	__u16 kind = btf_kind(t);
 
 	switch (kind) {
 	case BTF_KIND_INT:
@@ -709,15 +687,12 @@ static int btf_align_of(const struct btf *btf, __u32 id)
 	case BTF_KIND_CONST:
 	case BTF_KIND_RESTRICT:
 		return btf_align_of(btf, t->type);
-	case BTF_KIND_ARRAY: {
-		const struct btf_array *a = (void *)(t + 1);
-
-		return btf_align_of(btf, a->type);
-	}
+	case BTF_KIND_ARRAY:
+		return btf_align_of(btf, btf_array(t)->type);
 	case BTF_KIND_STRUCT:
 	case BTF_KIND_UNION: {
-		const struct btf_member *m = (void *)(t + 1);
-		__u16 vlen = btf_vlen_of(t);
+		const struct btf_member *m = btf_members(t);
+		__u16 vlen = btf_vlen(t);
 		int i, align = 1;
 
 		for (i = 0; i < vlen; i++, m++)
@@ -726,7 +701,7 @@ static int btf_align_of(const struct btf *btf, __u32 id)
 		return align;
 	}
 	default:
-		pr_warning("unsupported BTF_KIND:%u\n", btf_kind_of(t));
+		pr_warning("unsupported BTF_KIND:%u\n", btf_kind(t));
 		return 1;
 	}
 }
@@ -737,20 +712,18 @@ static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 	const struct btf_member *m;
 	int align, i, bit_sz;
 	__u16 vlen;
-	bool kflag;
 
 	align = btf_align_of(btf, id);
 	/* size of a non-packed struct has to be a multiple of its alignment*/
 	if (t->size % align)
 		return true;
 
-	m = (void *)(t + 1);
-	kflag = btf_kflag_of(t);
-	vlen = btf_vlen_of(t);
+	m = btf_members(t);
+	vlen = btf_vlen(t);
 	/* all non-bitfield fields have to be naturally aligned */
 	for (i = 0; i < vlen; i++, m++) {
 		align = btf_align_of(btf, m->type);
-		bit_sz = kflag ? BTF_MEMBER_BITFIELD_SIZE(m->offset) : 0;
+		bit_sz = btf_member_bitfield_size(t, i);
 		if (bit_sz == 0 && m->offset % (8 * align) != 0)
 			return true;
 	}
@@ -807,7 +780,7 @@ static void btf_dump_emit_struct_fwd(struct btf_dump *d, __u32 id,
 				     const struct btf_type *t)
 {
 	btf_dump_printf(d, "%s %s",
-			btf_kind_of(t) == BTF_KIND_STRUCT ? "struct" : "union",
+			btf_is_struct(t) ? "struct" : "union",
 			btf_dump_type_name(d, id));
 }
 
@@ -816,12 +789,11 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 				     const struct btf_type *t,
 				     int lvl)
 {
-	const struct btf_member *m = (void *)(t + 1);
-	bool kflag = btf_kflag_of(t), is_struct;
+	const struct btf_member *m = btf_members(t);
+	bool is_struct = btf_is_struct(t);
 	int align, i, packed, off = 0;
-	__u16 vlen = btf_vlen_of(t);
+	__u16 vlen = btf_vlen(t);
 
-	is_struct = btf_kind_of(t) == BTF_KIND_STRUCT;
 	packed = is_struct ? btf_is_struct_packed(d->btf, id, t) : 0;
 	align = packed ? 1 : btf_align_of(d->btf, id);
 
@@ -835,8 +807,8 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 		int m_off, m_sz;
 
 		fname = btf_name_of(d, m->name_off);
-		m_sz = kflag ? BTF_MEMBER_BITFIELD_SIZE(m->offset) : 0;
-		m_off = kflag ? BTF_MEMBER_BIT_OFFSET(m->offset) : m->offset;
+		m_sz = btf_member_bitfield_size(t, i);
+		m_off = btf_member_bit_offset(t, i);
 		align = packed ? 1 : btf_align_of(d->btf, m->type);
 
 		btf_dump_emit_bit_padding(d, off, m_off, m_sz, align, lvl + 1);
@@ -870,8 +842,8 @@ static void btf_dump_emit_enum_def(struct btf_dump *d, __u32 id,
 				   const struct btf_type *t,
 				   int lvl)
 {
-	const struct btf_enum *v = (void *)(t+1);
-	__u16 vlen = btf_vlen_of(t);
+	const struct btf_enum *v = btf_enum(t);
+	__u16 vlen = btf_vlen(t);
 	const char *name;
 	size_t dup_cnt;
 	int i;
@@ -905,7 +877,7 @@ static void btf_dump_emit_fwd_def(struct btf_dump *d, __u32 id,
 {
 	const char *name = btf_dump_type_name(d, id);
 
-	if (btf_kflag_of(t))
+	if (btf_kflag(t))
 		btf_dump_printf(d, "union %s", name);
 	else
 		btf_dump_printf(d, "struct %s", name);
@@ -987,7 +959,6 @@ static void btf_dump_emit_type_decl(struct btf_dump *d, __u32 id,
 	struct id_stack decl_stack;
 	const struct btf_type *t;
 	int err, stack_start;
-	__u16 kind;
 
 	stack_start = d->decl_stack_cnt;
 	for (;;) {
@@ -1008,8 +979,7 @@ static void btf_dump_emit_type_decl(struct btf_dump *d, __u32 id,
 			break;
 
 		t = btf__type_by_id(d->btf, id);
-		kind = btf_kind_of(t);
-		switch (kind) {
+		switch (btf_kind(t)) {
 		case BTF_KIND_PTR:
 		case BTF_KIND_VOLATILE:
 		case BTF_KIND_CONST:
@@ -1017,12 +987,9 @@ static void btf_dump_emit_type_decl(struct btf_dump *d, __u32 id,
 		case BTF_KIND_FUNC_PROTO:
 			id = t->type;
 			break;
-		case BTF_KIND_ARRAY: {
-			const struct btf_array *a = (void *)(t + 1);
-
-			id = a->type;
+		case BTF_KIND_ARRAY:
+			id = btf_array(t)->type;
 			break;
-		}
 		case BTF_KIND_INT:
 		case BTF_KIND_ENUM:
 		case BTF_KIND_FWD:
@@ -1032,7 +999,7 @@ static void btf_dump_emit_type_decl(struct btf_dump *d, __u32 id,
 			goto done;
 		default:
 			pr_warning("unexpected type in decl chain, kind:%u, id:[%u]\n",
-				   kind, id);
+				   btf_kind(t), id);
 			goto done;
 		}
 	}
@@ -1070,7 +1037,7 @@ static void btf_dump_emit_mods(struct btf_dump *d, struct id_stack *decl_stack)
 		id = decl_stack->ids[decl_stack->cnt - 1];
 		t = btf__type_by_id(d->btf, id);
 
-		switch (btf_kind_of(t)) {
+		switch (btf_kind(t)) {
 		case BTF_KIND_VOLATILE:
 			btf_dump_printf(d, "volatile ");
 			break;
@@ -1087,20 +1054,6 @@ static void btf_dump_emit_mods(struct btf_dump *d, struct id_stack *decl_stack)
 	}
 }
 
-static bool btf_is_mod_kind(const struct btf *btf, __u32 id)
-{
-	const struct btf_type *t = btf__type_by_id(btf, id);
-
-	switch (btf_kind_of(t)) {
-	case BTF_KIND_VOLATILE:
-	case BTF_KIND_CONST:
-	case BTF_KIND_RESTRICT:
-		return true;
-	default:
-		return false;
-	}
-}
-
 static void btf_dump_emit_name(const struct btf_dump *d,
 			       const char *name, bool last_was_ptr)
 {
@@ -1139,7 +1092,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 		}
 
 		t = btf__type_by_id(d->btf, id);
-		kind = btf_kind_of(t);
+		kind = btf_kind(t);
 
 		switch (kind) {
 		case BTF_KIND_INT:
@@ -1185,7 +1138,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 			btf_dump_printf(d, " restrict");
 			break;
 		case BTF_KIND_ARRAY: {
-			const struct btf_array *a = (void *)(t + 1);
+			const struct btf_array *a = btf_array(t);
 			const struct btf_type *next_t;
 			__u32 next_id;
 			bool multidim;
@@ -1201,7 +1154,8 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 			 */
 			while (decls->cnt) {
 				next_id = decls->ids[decls->cnt - 1];
-				if (btf_is_mod_kind(d->btf, next_id))
+				next_t = btf__type_by_id(d->btf, next_id);
+				if (btf_is_mod(next_t))
 					decls->cnt--;
 				else
 					break;
@@ -1214,7 +1168,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 			}
 
 			next_t = btf__type_by_id(d->btf, next_id);
-			multidim = btf_kind_of(next_t) == BTF_KIND_ARRAY;
+			multidim = btf_is_array(next_t);
 			/* we need space if we have named non-pointer */
 			if (fname[0] && !last_was_ptr)
 				btf_dump_printf(d, " ");
@@ -1228,8 +1182,8 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 			return;
 		}
 		case BTF_KIND_FUNC_PROTO: {
-			const struct btf_param *p = (void *)(t + 1);
-			__u16 vlen = btf_vlen_of(t);
+			const struct btf_param *p = btf_params(t);
+			__u16 vlen = btf_vlen(t);
 			int i;
 
 			btf_dump_emit_mods(d, decls);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ead915aec349..8fc62b6b1cd6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1049,9 +1049,9 @@ static bool get_map_field_int(const char *map_name, const struct btf *btf,
 	const struct btf_array *arr_info;
 	const struct btf_type *arr_t;
 
-	if (BTF_INFO_KIND(t->info) != BTF_KIND_PTR) {
+	if (!btf_is_ptr(t)) {
 		pr_warning("map '%s': attr '%s': expected PTR, got %u.\n",
-			   map_name, name, BTF_INFO_KIND(t->info));
+			   map_name, name, btf_kind(t));
 		return false;
 	}
 
@@ -1061,12 +1061,12 @@ static bool get_map_field_int(const char *map_name, const struct btf *btf,
 			   map_name, name, t->type);
 		return false;
 	}
-	if (BTF_INFO_KIND(arr_t->info) != BTF_KIND_ARRAY) {
+	if (!btf_is_array(arr_t)) {
 		pr_warning("map '%s': attr '%s': expected ARRAY, got %u.\n",
-			   map_name, name, BTF_INFO_KIND(arr_t->info));
+			   map_name, name, btf_kind(arr_t));
 		return false;
 	}
-	arr_info = (const void *)(arr_t + 1);
+	arr_info = btf_array(arr_t);
 	*res = arr_info->nelems;
 	return true;
 }
@@ -1084,11 +1084,11 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 	struct bpf_map *map;
 	int vlen, i;
 
-	vi = (const struct btf_var_secinfo *)(const void *)(sec + 1) + var_idx;
+	vi = btf_var_secinfos(sec) + var_idx;
 	var = btf__type_by_id(obj->btf, vi->type);
-	var_extra = (const void *)(var + 1);
+	var_extra = btf_var(var);
 	map_name = btf__name_by_offset(obj->btf, var->name_off);
-	vlen = BTF_INFO_VLEN(var->info);
+	vlen = btf_vlen(var);
 
 	if (map_name == NULL || map_name[0] == '\0') {
 		pr_warning("map #%d: empty name.\n", var_idx);
@@ -1098,9 +1098,9 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 		pr_warning("map '%s' BTF data is corrupted.\n", map_name);
 		return -EINVAL;
 	}
-	if (BTF_INFO_KIND(var->info) != BTF_KIND_VAR) {
+	if (!btf_is_var(var)) {
 		pr_warning("map '%s': unexpected var kind %u.\n",
-			   map_name, BTF_INFO_KIND(var->info));
+			   map_name, btf_kind(var));
 		return -EINVAL;
 	}
 	if (var_extra->linkage != BTF_VAR_GLOBAL_ALLOCATED &&
@@ -1111,9 +1111,9 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 	}
 
 	def = skip_mods_and_typedefs(obj->btf, var->type);
-	if (BTF_INFO_KIND(def->info) != BTF_KIND_STRUCT) {
+	if (!btf_is_struct(def)) {
 		pr_warning("map '%s': unexpected def kind %u.\n",
-			   map_name, BTF_INFO_KIND(var->info));
+			   map_name, btf_kind(var));
 		return -EINVAL;
 	}
 	if (def->size > vi->size) {
@@ -1136,8 +1136,8 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 	pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
 		 map_name, map->sec_idx, map->sec_offset);
 
-	vlen = BTF_INFO_VLEN(def->info);
-	m = (const void *)(def + 1);
+	vlen = btf_vlen(def);
+	m = btf_members(def);
 	for (i = 0; i < vlen; i++, m++) {
 		const char *name = btf__name_by_offset(obj->btf, m->name_off);
 
@@ -1187,9 +1187,9 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 					   map_name, m->type);
 				return -EINVAL;
 			}
-			if (BTF_INFO_KIND(t->info) != BTF_KIND_PTR) {
+			if (!btf_is_ptr(t)) {
 				pr_warning("map '%s': key spec is not PTR: %u.\n",
-					   map_name, BTF_INFO_KIND(t->info));
+					   map_name, btf_kind(t));
 				return -EINVAL;
 			}
 			sz = btf__resolve_size(obj->btf, t->type);
@@ -1230,9 +1230,9 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 					   map_name, m->type);
 				return -EINVAL;
 			}
-			if (BTF_INFO_KIND(t->info) != BTF_KIND_PTR) {
+			if (!btf_is_ptr(t)) {
 				pr_warning("map '%s': value spec is not PTR: %u.\n",
-					   map_name, BTF_INFO_KIND(t->info));
+					   map_name, btf_kind(t));
 				return -EINVAL;
 			}
 			sz = btf__resolve_size(obj->btf, t->type);
@@ -1293,7 +1293,7 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict)
 	nr_types = btf__get_nr_types(obj->btf);
 	for (i = 1; i <= nr_types; i++) {
 		t = btf__type_by_id(obj->btf, i);
-		if (BTF_INFO_KIND(t->info) != BTF_KIND_DATASEC)
+		if (!btf_is_datasec(t))
 			continue;
 		name = btf__name_by_offset(obj->btf, t->name_off);
 		if (strcmp(name, MAPS_ELF_SEC) == 0) {
@@ -1307,7 +1307,7 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict)
 		return -ENOENT;
 	}
 
-	vlen = BTF_INFO_VLEN(sec->info);
+	vlen = btf_vlen(sec);
 	for (i = 0; i < vlen; i++) {
 		err = bpf_object__init_user_btf_map(obj, sec, i,
 						    obj->efile.btf_maps_shndx,
@@ -1368,24 +1368,22 @@ static void bpf_object__sanitize_btf(struct bpf_object *obj)
 	struct btf *btf = obj->btf;
 	struct btf_type *t;
 	int i, j, vlen;
-	__u16 kind;
 
 	if (!obj->btf || (has_func && has_datasec))
 		return;
 
 	for (i = 1; i <= btf__get_nr_types(btf); i++) {
 		t = (struct btf_type *)btf__type_by_id(btf, i);
-		kind = BTF_INFO_KIND(t->info);
 
-		if (!has_datasec && kind == BTF_KIND_VAR) {
+		if (!has_datasec && btf_is_var(t)) {
 			/* replace VAR with INT */
 			t->info = BTF_INFO_ENC(BTF_KIND_INT, 0, 0);
 			t->size = sizeof(int);
-			*(int *)(t+1) = BTF_INT_ENC(0, 0, 32);
-		} else if (!has_datasec && kind == BTF_KIND_DATASEC) {
+			*(int *)(t + 1) = BTF_INT_ENC(0, 0, 32);
+		} else if (!has_datasec && btf_is_datasec(t)) {
 			/* replace DATASEC with STRUCT */
-			struct btf_var_secinfo *v = (void *)(t + 1);
-			struct btf_member *m = (void *)(t + 1);
+			const struct btf_var_secinfo *v = btf_var_secinfos(t);
+			struct btf_member *m = btf_members(t);
 			struct btf_type *vt;
 			char *name;
 
@@ -1396,7 +1394,7 @@ static void bpf_object__sanitize_btf(struct bpf_object *obj)
 				name++;
 			}
 
-			vlen = BTF_INFO_VLEN(t->info);
+			vlen = btf_vlen(t);
 			t->info = BTF_INFO_ENC(BTF_KIND_STRUCT, 0, vlen);
 			for (j = 0; j < vlen; j++, v++, m++) {
 				/* order of field assignments is important */
@@ -1406,12 +1404,12 @@ static void bpf_object__sanitize_btf(struct bpf_object *obj)
 				vt = (void *)btf__type_by_id(btf, v->type);
 				m->name_off = vt->name_off;
 			}
-		} else if (!has_func && kind == BTF_KIND_FUNC_PROTO) {
+		} else if (!has_func && btf_is_func_proto(t)) {
 			/* replace FUNC_PROTO with ENUM */
-			vlen = BTF_INFO_VLEN(t->info);
+			vlen = btf_vlen(t);
 			t->info = BTF_INFO_ENC(BTF_KIND_ENUM, 0, vlen);
 			t->size = sizeof(__u32); /* kernel enforced */
-		} else if (!has_func && kind == BTF_KIND_FUNC) {
+		} else if (!has_func && btf_is_func(t)) {
 			/* replace FUNC with TYPEDEF */
 			t->info = BTF_INFO_ENC(BTF_KIND_TYPEDEF, 0, 0);
 		}
-- 
2.17.1

