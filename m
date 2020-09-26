Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84F62795DA
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 03:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbgIZBOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 21:14:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13316 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729847AbgIZBOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 21:14:36 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q15OrV032302
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:14:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UA2cG1J5MM2Azc1CIUOv85uZMzdKrle0FBjMYoQ2yfI=;
 b=OGPt97ZouVGGQ3/4QlmqYtmdrh3nf/4tAMVTaPEbR1afLV0TmdTv5ASqDA4BxvjgYa7k
 i09w/KMGDrwcBHEE8tFG1L4TvQdxWP5Wq2Au0tjeGn1qRyGq7j8RYGO7higQB2m/YghQ
 paxwamqxqBPkibF6nNNvGKs4ONfTUs8tdps= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33s8su57k2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:14:33 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 18:14:32 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DA15D2EC75B0; Fri, 25 Sep 2020 18:14:25 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v2 bpf-next 1/9] libbpf: refactor internals of BTF type index
Date:   Fri, 25 Sep 2020 18:13:49 -0700
Message-ID: <20200926011357.2366158-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200926011357.2366158-1-andriin@fb.com>
References: <20200926011357.2366158-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_19:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 suspectscore=25
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor implementation of internal BTF type index to not use direct poin=
ters.
Instead it uses offset relative to the start of types data section. This
allows for types data to be reallocatable, enabling implementation of
modifiable BTF.

As now getting type by ID has an extra indirection step, convert all inte=
rnal
type lookups to a new helper btf_type_id(), that returns non-const pointe=
r to
a type by its ID.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c | 139 ++++++++++++++++++++++++--------------------
 1 file changed, 75 insertions(+), 64 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index a3d259e614b0..7c9957893ef2 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -31,11 +31,12 @@ struct btf {
 		struct btf_header *hdr;
 		void *data;
 	};
-	struct btf_type **types;
+	__u32 *type_offs;
+	__u32 type_offs_cap;
 	const char *strings;
 	void *nohdr_data;
+	void *types_data;
 	__u32 nr_types;
-	__u32 types_size;
 	__u32 data_size;
 	int fd;
 	int ptr_sz;
@@ -46,30 +47,30 @@ static inline __u64 ptr_to_u64(const void *ptr)
 	return (__u64) (unsigned long) ptr;
 }
=20
-static int btf_add_type(struct btf *btf, struct btf_type *t)
+static int btf_add_type_idx_entry(struct btf *btf, __u32 type_off)
 {
-	if (btf->types_size - btf->nr_types < 2) {
-		struct btf_type **new_types;
+	/* nr_types is 1-based, so N types means we need N+1-sized array */
+	if (btf->nr_types + 2 > btf->type_offs_cap) {
+		__u32 *new_offs;
 		__u32 expand_by, new_size;
=20
-		if (btf->types_size =3D=3D BTF_MAX_NR_TYPES)
+		if (btf->type_offs_cap =3D=3D BTF_MAX_NR_TYPES)
 			return -E2BIG;
=20
-		expand_by =3D max(btf->types_size >> 2, 16U);
-		new_size =3D min(BTF_MAX_NR_TYPES, btf->types_size + expand_by);
+		expand_by =3D max(btf->type_offs_cap / 4, 16U);
+		new_size =3D min(BTF_MAX_NR_TYPES, btf->type_offs_cap + expand_by);
=20
-		new_types =3D libbpf_reallocarray(btf->types, new_size, sizeof(*new_ty=
pes));
-		if (!new_types)
+		new_offs =3D libbpf_reallocarray(btf->type_offs, new_size, sizeof(*new=
_offs));
+		if (!new_offs)
 			return -ENOMEM;
=20
-		if (btf->nr_types =3D=3D 0)
-			new_types[0] =3D &btf_void;
+		new_offs[0] =3D UINT_MAX; /* VOID is specially handled */
=20
-		btf->types =3D new_types;
-		btf->types_size =3D new_size;
+		btf->type_offs =3D new_offs;
+		btf->type_offs_cap =3D new_size;
 	}
=20
-	btf->types[++(btf->nr_types)] =3D t;
+	btf->type_offs[btf->nr_types + 1] =3D type_off;
=20
 	return 0;
 }
@@ -147,7 +148,7 @@ static int btf_parse_str_sec(struct btf *btf)
 	return 0;
 }
=20
-static int btf_type_size(struct btf_type *t)
+static int btf_type_size(const struct btf_type *t)
 {
 	int base_size =3D sizeof(struct btf_type);
 	__u16 vlen =3D btf_vlen(t);
@@ -185,22 +186,25 @@ static int btf_type_size(struct btf_type *t)
 static int btf_parse_type_sec(struct btf *btf)
 {
 	struct btf_header *hdr =3D btf->hdr;
-	void *nohdr_data =3D btf->nohdr_data;
-	void *next_type =3D nohdr_data + hdr->type_off;
-	void *end_type =3D nohdr_data + hdr->str_off;
+	void *next_type =3D btf->nohdr_data + hdr->type_off;
+	void *end_type =3D next_type + hdr->type_len;
+
+	btf->types_data =3D next_type;
=20
 	while (next_type < end_type) {
-		struct btf_type *t =3D next_type;
 		int type_size;
 		int err;
=20
-		type_size =3D btf_type_size(t);
+		err =3D btf_add_type_idx_entry(btf, next_type - btf->types_data);
+		if (err)
+			return err;
+
+		type_size =3D btf_type_size(next_type);
 		if (type_size < 0)
 			return type_size;
+
 		next_type +=3D type_size;
-		err =3D btf_add_type(btf, t);
-		if (err)
-			return err;
+		btf->nr_types++;
 	}
=20
 	return 0;
@@ -211,12 +215,20 @@ __u32 btf__get_nr_types(const struct btf *btf)
 	return btf->nr_types;
 }
=20
+/* internal helper returning non-const pointer to a type */
+static struct btf_type *btf_type_by_id(struct btf *btf, __u32 type_id)
+{
+	if (type_id =3D=3D 0)
+		return &btf_void;
+
+	return btf->types_data + btf->type_offs[type_id];
+}
+
 const struct btf_type *btf__type_by_id(const struct btf *btf, __u32 type=
_id)
 {
 	if (type_id > btf->nr_types)
 		return NULL;
-
-	return btf->types[type_id];
+	return btf_type_by_id((struct btf *)btf, type_id);
 }
=20
 static int determine_ptr_size(const struct btf *btf)
@@ -414,7 +426,7 @@ __s32 btf__find_by_name(const struct btf *btf, const =
char *type_name)
 		return 0;
=20
 	for (i =3D 1; i <=3D btf->nr_types; i++) {
-		const struct btf_type *t =3D btf->types[i];
+		const struct btf_type *t =3D btf__type_by_id(btf, i);
 		const char *name =3D btf__name_by_offset(btf, t->name_off);
=20
 		if (name && !strcmp(type_name, name))
@@ -433,7 +445,7 @@ __s32 btf__find_by_name_kind(const struct btf *btf, c=
onst char *type_name,
 		return 0;
=20
 	for (i =3D 1; i <=3D btf->nr_types; i++) {
-		const struct btf_type *t =3D btf->types[i];
+		const struct btf_type *t =3D btf__type_by_id(btf, i);
 		const char *name;
=20
 		if (btf_kind(t) !=3D kind)
@@ -455,7 +467,7 @@ void btf__free(struct btf *btf)
 		close(btf->fd);
=20
 	free(btf->data);
-	free(btf->types);
+	free(btf->type_offs);
 	free(btf);
 }
=20
@@ -789,7 +801,7 @@ int btf__finalize_data(struct bpf_object *obj, struct=
 btf *btf)
 	__u32 i;
=20
 	for (i =3D 1; i <=3D btf->nr_types; i++) {
-		struct btf_type *t =3D btf->types[i];
+		struct btf_type *t =3D btf_type_by_id(btf, i);
=20
 		/* Loader needs to fix up some of the things compiler
 		 * couldn't get its hands on while emitting BTF. This
@@ -1655,7 +1667,7 @@ static struct btf_dedup *btf_dedup_new(struct btf *=
btf, struct btf_ext *btf_ext,
 	/* special BTF "void" type is made canonical immediately */
 	d->map[0] =3D 0;
 	for (i =3D 1; i <=3D btf->nr_types; i++) {
-		struct btf_type *t =3D d->btf->types[i];
+		struct btf_type *t =3D btf_type_by_id(d->btf, i);
=20
 		/* VAR and DATASEC are never deduped and are self-canonical */
 		if (btf_is_var(t) || btf_is_datasec(t))
@@ -1694,7 +1706,7 @@ static int btf_for_each_str_off(struct btf_dedup *d=
, str_off_fn_t fn, void *ctx)
 	struct btf_type *t;
=20
 	for (i =3D 1; i <=3D d->btf->nr_types; i++) {
-		t =3D d->btf->types[i];
+		t =3D btf_type_by_id(d->btf, i);
 		r =3D fn(&t->name_off, ctx);
 		if (r)
 			return r;
@@ -2229,7 +2241,7 @@ static bool btf_compat_fnproto(struct btf_type *t1,=
 struct btf_type *t2)
  */
 static int btf_dedup_prim_type(struct btf_dedup *d, __u32 type_id)
 {
-	struct btf_type *t =3D d->btf->types[type_id];
+	struct btf_type *t =3D btf_type_by_id(d->btf, type_id);
 	struct hashmap_entry *hash_entry;
 	struct btf_type *cand;
 	/* if we don't find equivalent type, then we are canonical */
@@ -2256,7 +2268,7 @@ static int btf_dedup_prim_type(struct btf_dedup *d,=
 __u32 type_id)
 		h =3D btf_hash_int(t);
 		for_each_dedup_cand(d, hash_entry, h) {
 			cand_id =3D (__u32)(long)hash_entry->value;
-			cand =3D d->btf->types[cand_id];
+			cand =3D btf_type_by_id(d->btf, cand_id);
 			if (btf_equal_int(t, cand)) {
 				new_id =3D cand_id;
 				break;
@@ -2268,7 +2280,7 @@ static int btf_dedup_prim_type(struct btf_dedup *d,=
 __u32 type_id)
 		h =3D btf_hash_enum(t);
 		for_each_dedup_cand(d, hash_entry, h) {
 			cand_id =3D (__u32)(long)hash_entry->value;
-			cand =3D d->btf->types[cand_id];
+			cand =3D btf_type_by_id(d->btf, cand_id);
 			if (btf_equal_enum(t, cand)) {
 				new_id =3D cand_id;
 				break;
@@ -2291,7 +2303,7 @@ static int btf_dedup_prim_type(struct btf_dedup *d,=
 __u32 type_id)
 		h =3D btf_hash_common(t);
 		for_each_dedup_cand(d, hash_entry, h) {
 			cand_id =3D (__u32)(long)hash_entry->value;
-			cand =3D d->btf->types[cand_id];
+			cand =3D btf_type_by_id(d->btf, cand_id);
 			if (btf_equal_common(t, cand)) {
 				new_id =3D cand_id;
 				break;
@@ -2350,13 +2362,13 @@ static uint32_t resolve_fwd_id(struct btf_dedup *=
d, uint32_t type_id)
 {
 	__u32 orig_type_id =3D type_id;
=20
-	if (!btf_is_fwd(d->btf->types[type_id]))
+	if (!btf_is_fwd(btf__type_by_id(d->btf, type_id)))
 		return type_id;
=20
 	while (is_type_mapped(d, type_id) && d->map[type_id] !=3D type_id)
 		type_id =3D d->map[type_id];
=20
-	if (!btf_is_fwd(d->btf->types[type_id]))
+	if (!btf_is_fwd(btf__type_by_id(d->btf, type_id)))
 		return type_id;
=20
 	return orig_type_id;
@@ -2484,8 +2496,8 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, =
__u32 cand_id,
 	if (btf_dedup_hypot_map_add(d, canon_id, cand_id))
 		return -ENOMEM;
=20
-	cand_type =3D d->btf->types[cand_id];
-	canon_type =3D d->btf->types[canon_id];
+	cand_type =3D btf_type_by_id(d->btf, cand_id);
+	canon_type =3D btf_type_by_id(d->btf, canon_id);
 	cand_kind =3D btf_kind(cand_type);
 	canon_kind =3D btf_kind(canon_type);
=20
@@ -2636,8 +2648,8 @@ static void btf_dedup_merge_hypot_map(struct btf_de=
dup *d)
 		targ_type_id =3D d->hypot_map[cand_type_id];
 		t_id =3D resolve_type_id(d, targ_type_id);
 		c_id =3D resolve_type_id(d, cand_type_id);
-		t_kind =3D btf_kind(d->btf->types[t_id]);
-		c_kind =3D btf_kind(d->btf->types[c_id]);
+		t_kind =3D btf_kind(btf__type_by_id(d->btf, t_id));
+		c_kind =3D btf_kind(btf__type_by_id(d->btf, c_id));
 		/*
 		 * Resolve FWD into STRUCT/UNION.
 		 * It's ok to resolve FWD into STRUCT/UNION that's not yet
@@ -2705,7 +2717,7 @@ static int btf_dedup_struct_type(struct btf_dedup *=
d, __u32 type_id)
 	if (d->map[type_id] <=3D BTF_MAX_NR_TYPES)
 		return 0;
=20
-	t =3D d->btf->types[type_id];
+	t =3D btf_type_by_id(d->btf, type_id);
 	kind =3D btf_kind(t);
=20
 	if (kind !=3D BTF_KIND_STRUCT && kind !=3D BTF_KIND_UNION)
@@ -2726,7 +2738,7 @@ static int btf_dedup_struct_type(struct btf_dedup *=
d, __u32 type_id)
 		 * creating a loop (FWD -> STRUCT and STRUCT -> FWD), because
 		 * FWD and compatible STRUCT/UNION are considered equivalent.
 		 */
-		cand_type =3D d->btf->types[cand_id];
+		cand_type =3D btf_type_by_id(d->btf, cand_id);
 		if (!btf_shallow_equal_struct(t, cand_type))
 			continue;
=20
@@ -2798,7 +2810,7 @@ static int btf_dedup_ref_type(struct btf_dedup *d, =
__u32 type_id)
 	if (d->map[type_id] <=3D BTF_MAX_NR_TYPES)
 		return resolve_type_id(d, type_id);
=20
-	t =3D d->btf->types[type_id];
+	t =3D btf_type_by_id(d->btf, type_id);
 	d->map[type_id] =3D BTF_IN_PROGRESS_ID;
=20
 	switch (btf_kind(t)) {
@@ -2816,7 +2828,7 @@ static int btf_dedup_ref_type(struct btf_dedup *d, =
__u32 type_id)
 		h =3D btf_hash_common(t);
 		for_each_dedup_cand(d, hash_entry, h) {
 			cand_id =3D (__u32)(long)hash_entry->value;
-			cand =3D d->btf->types[cand_id];
+			cand =3D btf_type_by_id(d->btf, cand_id);
 			if (btf_equal_common(t, cand)) {
 				new_id =3D cand_id;
 				break;
@@ -2840,7 +2852,7 @@ static int btf_dedup_ref_type(struct btf_dedup *d, =
__u32 type_id)
 		h =3D btf_hash_array(t);
 		for_each_dedup_cand(d, hash_entry, h) {
 			cand_id =3D (__u32)(long)hash_entry->value;
-			cand =3D d->btf->types[cand_id];
+			cand =3D btf_type_by_id(d->btf, cand_id);
 			if (btf_equal_array(t, cand)) {
 				new_id =3D cand_id;
 				break;
@@ -2872,7 +2884,7 @@ static int btf_dedup_ref_type(struct btf_dedup *d, =
__u32 type_id)
 		h =3D btf_hash_fnproto(t);
 		for_each_dedup_cand(d, hash_entry, h) {
 			cand_id =3D (__u32)(long)hash_entry->value;
-			cand =3D d->btf->types[cand_id];
+			cand =3D btf_type_by_id(d->btf, cand_id);
 			if (btf_equal_fnproto(t, cand)) {
 				new_id =3D cand_id;
 				break;
@@ -2920,9 +2932,9 @@ static int btf_dedup_ref_types(struct btf_dedup *d)
  */
 static int btf_dedup_compact_types(struct btf_dedup *d)
 {
-	struct btf_type **new_types;
+	__u32 *new_offs;
 	__u32 next_type_id =3D 1;
-	char *types_start, *p;
+	void *p;
 	int i, len;
=20
 	/* we are going to reuse hypot_map to store compaction remapping */
@@ -2930,41 +2942,40 @@ static int btf_dedup_compact_types(struct btf_ded=
up *d)
 	for (i =3D 1; i <=3D d->btf->nr_types; i++)
 		d->hypot_map[i] =3D BTF_UNPROCESSED_ID;
=20
-	types_start =3D d->btf->nohdr_data + d->btf->hdr->type_off;
-	p =3D types_start;
+	p =3D d->btf->types_data;
=20
 	for (i =3D 1; i <=3D d->btf->nr_types; i++) {
 		if (d->map[i] !=3D i)
 			continue;
=20
-		len =3D btf_type_size(d->btf->types[i]);
+		len =3D btf_type_size(btf__type_by_id(d->btf, i));
 		if (len < 0)
 			return len;
=20
-		memmove(p, d->btf->types[i], len);
+		memmove(p, btf__type_by_id(d->btf, i), len);
 		d->hypot_map[i] =3D next_type_id;
-		d->btf->types[next_type_id] =3D (struct btf_type *)p;
+		d->btf->type_offs[next_type_id] =3D p - d->btf->types_data;
 		p +=3D len;
 		next_type_id++;
 	}
=20
 	/* shrink struct btf's internal types index and update btf_header */
 	d->btf->nr_types =3D next_type_id - 1;
-	d->btf->types_size =3D d->btf->nr_types;
-	d->btf->hdr->type_len =3D p - types_start;
-	new_types =3D libbpf_reallocarray(d->btf->types, (1 + d->btf->nr_types)=
,
-					sizeof(struct btf_type *));
-	if (!new_types)
+	d->btf->type_offs_cap =3D d->btf->nr_types + 1;
+	d->btf->hdr->type_len =3D p - d->btf->types_data;
+	new_offs =3D libbpf_reallocarray(d->btf->type_offs, d->btf->type_offs_c=
ap,
+				       sizeof(*new_offs));
+	if (!new_offs)
 		return -ENOMEM;
-	d->btf->types =3D new_types;
+	d->btf->type_offs =3D new_offs;
=20
 	/* make sure string section follows type information without gaps */
-	d->btf->hdr->str_off =3D p - (char *)d->btf->nohdr_data;
+	d->btf->hdr->str_off =3D p - d->btf->nohdr_data;
 	memmove(p, d->btf->strings, d->btf->hdr->str_len);
 	d->btf->strings =3D p;
 	p +=3D d->btf->hdr->str_len;
=20
-	d->btf->data_size =3D p - (char *)d->btf->data;
+	d->btf->data_size =3D p - d->btf->data;
 	return 0;
 }
=20
@@ -2997,7 +3008,7 @@ static int btf_dedup_remap_type_id(struct btf_dedup=
 *d, __u32 type_id)
  */
 static int btf_dedup_remap_type(struct btf_dedup *d, __u32 type_id)
 {
-	struct btf_type *t =3D d->btf->types[type_id];
+	struct btf_type *t =3D btf_type_by_id(d->btf, type_id);
 	int i, r;
=20
 	switch (btf_kind(t)) {
--=20
2.24.1

