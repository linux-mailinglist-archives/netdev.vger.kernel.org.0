Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BEF275C83
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 17:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgIWPzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 11:55:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37560 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726732AbgIWPzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 11:55:00 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NFhCbt015632
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 08:54:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zA9ZIFcMOQeQaRu8gfwIxv62XEAU2pK/kLhPRPIDmRg=;
 b=oFobSi+bHIl2/pDz0fGuL1tBZBwK34oXfy7OSGY8ykmhS1EJHShuWg9qypu/rMVY4Bw0
 1Xd9mKiKyc9mSN6KhgFjHU53IEsW9yanEDaNcUDqiNjAx5A6tUplP7VYaMqVBOFFgZIn
 bjpC7tayZRNUNhElt9tYWF3itafBdyOEQXY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp4v9ke-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 08:54:57 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 08:54:56 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DF02E2EC7442; Wed, 23 Sep 2020 08:54:52 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH bpf-next 7/9] libbpf: add BTF writing APIs
Date:   Wed, 23 Sep 2020 08:54:34 -0700
Message-ID: <20200923155436.2117661-8-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200923155436.2117661-1-andriin@fb.com>
References: <20200923155436.2117661-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_12:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=8 bulkscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add APIs for appending new BTF types at the end of BTF object.

Each BTF kind has either one API of the form btf__append_<kind>(). For ty=
pes
that have variable amount of additional items (struct/union, enum, func_p=
roto,
datasec), additional API is provided to emit each such item. E.g., for
emitting a struct, one would use the following sequence of API calls:

btf__append_struct(...);
btf__append_field(...);
...
btf__append_field(...);

Each btf__append_field() will ensure that the last BTF type is of STRUCT =
or
UNION kind and will automatically increment that type's vlen field.

All the strings are provided as C strings (const char *), not a string of=
fset.
This significantly improves usability of BTF writer APIs. All such string=
s
will be automatically appended to string section or existing string will =
be
re-used, if such string was already added previously.

Each API attempts to do all the reasonable validations, like enforcing
non-empty names for entities with required names, proper value bounds, va=
rious
bit offset restrictions, etc.

Type ID validation is minimal because it's possible to emit a type that r=
efers
to type that will be emitted later, so libbpf has no way to enforce such
cases. User must be careful to properly emit all the necessary types and
specify type IDs that will be valid in the finally generated BTF.

Each of btf__append_<kind>() APIs return new type ID on success or negati=
ve
value on error. APIs like btf__append_field() that emit additional items
return zero on success and negative value on error.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c      | 781 +++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/btf.h      |  37 ++
 tools/lib/bpf/libbpf.map |  19 +
 3 files changed, 837 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 4d0e532d7b3d..7d50f626b823 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1311,6 +1311,787 @@ int btf__add_str(struct btf *btf, const char *s)
 	return new_off;
 }
=20
+static void *btf_add_type_mem(struct btf *btf, size_t add_sz)
+{
+	return btf_add_mem(&btf->types_data, &btf->types_data_cap, 1,
+			   btf->hdr->type_len, UINT_MAX, add_sz);
+}
+
+static __u32 btf_type_info(int kind, int vlen, int kflag)
+{
+	return (kflag << 31) | (kind << 24) | vlen;
+}
+
+static void btf_type_inc_vlen(struct btf_type *t)
+{
+	t->info =3D btf_type_info(btf_kind(t), btf_vlen(t) + 1, btf_kflag(t));
+}
+
+/*
+ * Append new BTF_KIND_INT type with:
+ *   - *name* - non-empty, non-NULL type name;
+ *   - *sz* - power-of-2 (1, 2, 4, ..) size of the type, in bytes;
+ *   - encoding is a combination of BTF_INT_SIGNED, BTF_INT_CHAR, BTF_IN=
T_BOOL.
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_int(struct btf *btf, const char *name, size_t byte_sz, i=
nt encoding)
+{
+	struct btf_type *t;
+	int sz, err, name_off;
+
+	/* non-empty name */
+	if (!name || !name[0])
+		return -EINVAL;
+	/* byte_sz must be power of 2 */
+	if (!byte_sz || (byte_sz & (byte_sz - 1)) || byte_sz > 16)
+		return -EINVAL;
+	if (encoding & ~(BTF_INT_SIGNED | BTF_INT_CHAR | BTF_INT_BOOL))
+		return -EINVAL;
+
+	/* deconstruct BTF, if necessary, and invalidate raw_data */
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	sz =3D sizeof(struct btf_type) + sizeof(int);
+	t =3D btf_add_type_mem(btf, sz);
+	if (!t)
+		return -ENOMEM;
+
+	/* if something goes wrong later, we might end up with extra an string,
+	 * but that shouldn't be a problem, because BTF can't be constructed
+	 * completely anyway and will most probably be just discarded
+	 */
+	name_off =3D btf__add_str(btf, name);
+	if (name_off < 0)
+		return name_off;
+
+	t->name_off =3D name_off;
+	t->info =3D btf_type_info(BTF_KIND_INT, 0, 0);
+	t->size =3D byte_sz;
+	/* set INT info, we don't allow setting legacy bit offset/size */
+	*(__u32 *)(t + 1) =3D (encoding << 24) | (byte_sz * 8);
+
+	err =3D btf_add_type_idx_entry(btf, btf->hdr->type_len);
+	if (err)
+		return err;
+
+	btf->hdr->type_len +=3D sz;
+	btf->hdr->str_off +=3D sz;
+	btf->nr_types++;
+	return btf->nr_types;
+}
+
+/* it's completely legal to append BTF types with type IDs pointing forw=
ard to
+ * types that haven't been appended yet, so we only make sure that id lo=
oks
+ * sane, we can't guarantee that ID will always be valid
+ */
+static int validate_type_id(int id)
+{
+	if (id < 0 || id > BTF_MAX_NR_TYPES)
+		return -EINVAL;
+	return 0;
+}
+
+/* generic append function for PTR, TYPEDEF, CONST/VOLATILE/RESTRICT */
+static int btf_append_ref_kind(struct btf *btf, int kind, const char *na=
me, int ref_type_id)
+{
+	struct btf_type *t;
+	int sz, name_off =3D 0, err;
+
+	if (validate_type_id(ref_type_id))
+		return -EINVAL;
+
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	sz =3D sizeof(struct btf_type);
+	t =3D btf_add_type_mem(btf, sz);
+	if (!t)
+		return -ENOMEM;
+
+	if (name && name[0]) {
+		name_off =3D btf__add_str(btf, name);
+		if (name_off < 0)
+			return name_off;
+	}
+
+	t->name_off =3D name_off;
+	t->info =3D btf_type_info(kind, 0, 0);
+	t->type =3D ref_type_id;
+
+	err =3D btf_add_type_idx_entry(btf, btf->hdr->type_len);
+	if (err)
+		return err;
+
+	btf->hdr->type_len +=3D sz;
+	btf->hdr->str_off +=3D sz;
+	btf->nr_types++;
+	return btf->nr_types;
+}
+
+/*
+ * Append new BTF_KIND_PTR type with:
+ *   - *ref_type_id* - referenced type ID, it might not exist yet;
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_ptr(struct btf *btf, int ref_type_id)
+{
+	return btf_append_ref_kind(btf, BTF_KIND_PTR, NULL, ref_type_id);
+}
+
+/*
+ * Append new BTF_KIND_ARRAY type with:
+ *   - *index_type_id* - type ID of the type describing array index;
+ *   - *elem_type_id* - type ID of the type describing array element;
+ *   - *nr_elems* - the size of the array;
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_array(struct btf *btf, int index_type_id, int elem_type_=
id, __u32 nr_elems)
+{
+	struct btf_type *t;
+	struct btf_array *a;
+	int sz, err;
+
+	if (validate_type_id(index_type_id) || validate_type_id(elem_type_id))
+		return -EINVAL;
+
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	sz =3D sizeof(struct btf_type) + sizeof(struct btf_array);
+	t =3D btf_add_type_mem(btf, sz);
+	if (!t)
+		return -ENOMEM;
+
+	t->name_off =3D 0;
+	t->info =3D btf_type_info(BTF_KIND_ARRAY, 0, 0);
+	t->size =3D 0;
+
+	a =3D btf_array(t);
+	a->type =3D elem_type_id;
+	a->index_type =3D index_type_id;
+	a->nelems =3D nr_elems;
+
+	err =3D btf_add_type_idx_entry(btf, btf->hdr->type_len);
+	if (err)
+		return err;
+
+	btf->hdr->type_len +=3D sz;
+	btf->hdr->str_off +=3D sz;
+	btf->nr_types++;
+	return btf->nr_types;
+}
+
+/* generic STRUCT/UNION append function */
+static int btf_append_composite(struct btf *btf, int kind, const char *n=
ame, __u32 bytes_sz)
+{
+	struct btf_type *t;
+	int sz, err, name_off =3D 0;
+
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	sz =3D sizeof(struct btf_type);
+	t =3D btf_add_type_mem(btf, sz);
+	if (!t)
+		return -ENOMEM;
+
+	if (name && name[0]) {
+		name_off =3D btf__add_str(btf, name);
+		if (name_off < 0)
+			return name_off;
+	}
+
+	/* start out with vlen=3D0 and no kflag; this will be adjusted when
+	 * adding each member
+	 */
+	t->name_off =3D name_off;
+	t->info =3D btf_type_info(kind, 0, 0);
+	t->size =3D bytes_sz;
+
+	err =3D btf_add_type_idx_entry(btf, btf->hdr->type_len);
+	if (err)
+		return err;
+
+	btf->hdr->type_len +=3D sz;
+	btf->hdr->str_off +=3D sz;
+	btf->nr_types++;
+	return btf->nr_types;
+}
+
+/*
+ * Append new BTF_KIND_STRUCT type with:
+ *   - *name* - name of the struct, can be NULL or empty for anonymous s=
tructs;
+ *   - *byte_sz* - size of the struct, in bytes;
+ *
+ * Struct initially has no fields in it. Fields can be added by
+ * btf__append_field() right after btf__append_struct() succeeds.=20
+ *
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_struct(struct btf *btf, const char *name, __u32 byte_sz)
+{
+	return btf_append_composite(btf, BTF_KIND_STRUCT, name, byte_sz);
+}
+
+/*
+ * Append new BTF_KIND_UNION type with:
+ *   - *name* - name of the union, can be NULL or empty for anonymous un=
ion;
+ *   - *byte_sz* - size of the union, in bytes;
+ *
+ * Union initially has no fields in it. Fields can be added by
+ * btf__append_field() right after btf__append_union() succeeds. All fie=
lds
+ * should have *bit_offset* of 0.
+ *
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_union(struct btf *btf, const char *name, __u32 byte_sz)
+{
+	return btf_append_composite(btf, BTF_KIND_UNION, name, byte_sz);
+}
+
+/*
+ * Append new field for the current STRUCT/UNION type with:
+ *   - *name* - name of the field, can be NULL or empty for anonymous fi=
eld;
+ *   - *type_id* - type ID for the type describing field type;
+ *   - *bit_offset* - bit offset of the start of the field within struct=
/union;
+ *   - *bit_size* - bit size of a bitfield, 0 for non-bitfield fields;
+ * Returns:
+ *   -  0, on success;
+ *   - <0, on error.
+ */
+int btf__append_field(struct btf *btf, const char *name, int type_id,
+		      __u32 bit_offset, __u32 bit_size)
+{
+	struct btf_type *t;
+	struct btf_member *m;
+	bool is_bitfield;
+	int sz, name_off =3D 0;
+
+	/* last type should be union/struct */
+	if (btf->nr_types =3D=3D 0)
+		return -EINVAL;
+	t =3D btf_type_by_id(btf, btf->nr_types);
+	if (!btf_is_composite(t))
+		return -EINVAL;
+
+	if (validate_type_id(type_id))
+		return -EINVAL;
+	/* best-effort bit field offset/size enforcement */
+	is_bitfield =3D bit_size || (bit_offset % 8 !=3D 0);
+	if (is_bitfield && (bit_size =3D=3D 0 || bit_size > 255 || bit_offset >=
 0xffffff))
+		return -EINVAL;
+
+	/* only offset 0 is allowed for unions */
+	if (btf_is_union(t) && bit_offset)
+		return -EINVAL;
+
+	/* decompose and invalidate raw data */
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	sz =3D sizeof(struct btf_member);
+	m =3D btf_add_type_mem(btf, sz);
+	if (!m)
+		return -ENOMEM;
+
+	if (name && name[0]) {
+		name_off =3D btf__add_str(btf, name);
+		if (name_off < 0)
+			return name_off;
+	}
+
+	m->name_off =3D name_off;
+	m->type =3D type_id;
+	m->offset =3D bit_offset | (bit_size << 24);
+
+	/* btf_add_type_mem can invalidate t pointer */
+	t =3D btf_type_by_id(btf, btf->nr_types);
+	/* update parent type's vlen and kflag */
+	t->info =3D btf_type_info(btf_kind(t), btf_vlen(t) + 1, is_bitfield || =
btf_kflag(t));
+
+	btf->hdr->type_len +=3D sz;
+	btf->hdr->str_off +=3D sz;
+	return 0;
+}
+
+/*
+ * Append new BTF_KIND_ENUM type with:
+ *   - *name* - name of the enum, can be NULL or empty for anonymous enu=
ms;
+ *   - *byte_sz* - size of the enum, in bytes.
+ *
+ * Enum initially has no enum values in it (and corresponds to enum forw=
ard
+ * declaration). Enumerator values can be added by btf__append_enum_valu=
e()
+ * immediately after btf__append_enum() succeeds.
+ *
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_enum(struct btf *btf, const char *name, __u32 byte_sz)
+{
+	struct btf_type *t;
+	int sz, err, name_off =3D 0;
+
+	/* byte_sz must be power of 2 */
+	if (!byte_sz || (byte_sz & (byte_sz - 1)) || byte_sz > 8)
+		return -EINVAL;
+
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	sz =3D sizeof(struct btf_type);
+	t =3D btf_add_type_mem(btf, sz);
+	if (!t)
+		return -ENOMEM;
+
+	if (name && name[0]) {
+		name_off =3D btf__add_str(btf, name);
+		if (name_off < 0)
+			return name_off;
+	}
+
+	/* start out with vlen=3D0; it will be adjusted when adding enum values=
 */
+	t->name_off =3D name_off;
+	t->info =3D btf_type_info(BTF_KIND_ENUM, 0, 0);
+	t->size =3D byte_sz;
+
+	err =3D btf_add_type_idx_entry(btf, btf->hdr->type_len);
+	if (err)
+		return err;
+
+	btf->hdr->type_len +=3D sz;
+	btf->hdr->str_off +=3D sz;
+	btf->nr_types++;
+	return btf->nr_types;
+}
+
+/*
+ * Append new enum value for the current ENUM type with:
+ *   - *name* - name of the enumerator value, can't be NULL or empty;
+ *   - *value* - integer value corresponding to enum value *name*;
+ * Returns:
+ *   -  0, on success;
+ *   - <0, on error.
+ */
+int btf__append_enum_value(struct btf *btf, const char *name, __s64 valu=
e)
+{
+	struct btf_type *t;
+	struct btf_enum *v;
+	int sz, name_off;
+
+	/* last type should be BTF_KIND_ENUM */
+	if (btf->nr_types =3D=3D 0)
+		return -EINVAL;
+	t =3D btf_type_by_id(btf, btf->nr_types);
+	if (!btf_is_enum(t))
+		return -EINVAL;
+
+	/* non-empty name */
+	if (!name || !name[0])
+		return -EINVAL;
+	if (value < INT_MIN || value > UINT_MAX)
+		return -E2BIG;
+
+	/* decompose and invalidate raw data */
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	sz =3D sizeof(struct btf_enum);
+	v =3D btf_add_type_mem(btf, sz);
+	if (!v)
+		return -ENOMEM;
+
+	name_off =3D btf__add_str(btf, name);
+	if (name_off < 0)
+		return name_off;
+
+	v->name_off =3D name_off;
+	v->val =3D value;
+
+	/* update parent type's vlen */
+	t =3D btf_type_by_id(btf, btf->nr_types);
+	btf_type_inc_vlen(t);
+
+	btf->hdr->type_len +=3D sz;
+	btf->hdr->str_off +=3D sz;
+	return 0;
+}
+
+/*
+ * Append new BTF_KIND_FWD type with:
+ *   - *name*, non-empty/non-NULL name;
+ *   - *fwd_kind*, kind of forward declaration, one of BTF_FWD_STRUCT,
+ *     BTF_FWD_UNION, or BTF_FWD_ENUM;
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_fwd(struct btf *btf, const char *name, enum btf_fwd_kind=
 fwd_kind)
+{
+	if (!name || !name[0])
+		return -EINVAL;
+
+	switch (fwd_kind) {
+	case BTF_FWD_STRUCT:
+	case BTF_FWD_UNION: {
+		struct btf_type *t;
+		int id;
+
+		id =3D btf_append_ref_kind(btf, BTF_KIND_FWD, name, 0);
+		if (id <=3D 0)
+			return id;
+		t =3D btf_type_by_id(btf, id);
+		t->info =3D btf_type_info(BTF_KIND_FWD, 0, fwd_kind =3D=3D BTF_FWD_UNI=
ON);
+		return id;
+	}
+	case BTF_FWD_ENUM:
+		/* enum forward in BTF currently is just an enum with no enum
+		 * values; we also assume a standard 4-byte size for it
+		 */
+		return btf__append_enum(btf, name, sizeof(int));
+	default:
+		return -EINVAL;
+	}
+}
+
+/*
+ * Append new BTF_KING_TYPEDEF type with:
+ *   - *name*, non-empty/non-NULL name;
+ *   - *ref_type_id* - referenced type ID, it might not exist yet;
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_typedef(struct btf *btf, const char *name, int ref_type_=
id)
+{
+	if (!name || !name[0])
+		return -EINVAL;
+
+	return btf_append_ref_kind(btf, BTF_KIND_TYPEDEF, name, ref_type_id);
+}
+
+/*
+ * Append new BTF_KIND_VOLATILE type with:
+ *   - *ref_type_id* - referenced type ID, it might not exist yet;
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_volatile(struct btf *btf, int ref_type_id)
+{
+	return btf_append_ref_kind(btf, BTF_KIND_VOLATILE, NULL, ref_type_id);
+}
+
+/*
+ * Append new BTF_KIND_CONST type with:
+ *   - *ref_type_id* - referenced type ID, it might not exist yet;
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_const(struct btf *btf, int ref_type_id)
+{
+	return btf_append_ref_kind(btf, BTF_KIND_CONST, NULL, ref_type_id);
+}
+
+/*
+ * Append new BTF_KIND_RESTRICT type with:
+ *   - *ref_type_id* - referenced type ID, it might not exist yet;
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_restrict(struct btf *btf, int ref_type_id)
+{
+	return btf_append_ref_kind(btf, BTF_KIND_RESTRICT, NULL, ref_type_id);
+}
+
+/*
+ * Append new BTF_KIND_FUNC type with:
+ *   - *name*, non-empty/non-NULL name;
+ *   - *proto_type_id* - FUNC_PROTO's type ID, it might not exist yet;
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_func(struct btf *btf, const char *name,
+		     enum btf_func_linkage linkage, int proto_type_id)
+{
+	int id;
+
+	if (!name || !name[0])
+		return -EINVAL;
+	if (linkage !=3D BTF_FUNC_STATIC && linkage !=3D BTF_FUNC_GLOBAL &&
+	    linkage !=3D BTF_FUNC_EXTERN)
+		return -EINVAL;
+
+	id =3D btf_append_ref_kind(btf, BTF_KIND_FUNC, name, proto_type_id);
+	if (id > 0) {
+		struct btf_type *t =3D btf_type_by_id(btf, id);
+
+		t->info =3D btf_type_info(BTF_KIND_FUNC, linkage, 0);
+	}
+	return id;
+}
+
+/*
+ * Append new BTF_KIND_FUNC_PROTO with:
+ *   - *ret_type_id* - type ID for return result of a function.
+ *
+ * Function prototype initially has no arguments, but they can be added =
by
+ * btf__append_func_param() one by one, immediately after
+ * btf__append_func_proto() succeeded.
+ *
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_func_proto(struct btf *btf, int ret_type_id)
+{
+	struct btf_type *t;
+	int sz, err;
+
+	if (validate_type_id(ret_type_id))
+		return -EINVAL;
+
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	sz =3D sizeof(struct btf_type);
+	t =3D btf_add_type_mem(btf, sz);
+	if (!t)
+		return -ENOMEM;
+
+	/* start out with vlen=3D0; this will be adjusted when adding enum
+	 * values, if necessary
+	 */
+	t->name_off =3D 0;
+	t->info =3D btf_type_info(BTF_KIND_FUNC_PROTO, 0, 0);
+	t->type =3D ret_type_id;
+
+	err =3D btf_add_type_idx_entry(btf, btf->hdr->type_len);
+	if (err)
+		return err;
+
+	btf->hdr->type_len +=3D sz;
+	btf->hdr->str_off +=3D sz;
+	btf->nr_types++;
+	return btf->nr_types;
+}
+
+/*
+ * Append new function parameter for current FUNC_PROTO type with:
+ *   - *name* - parameter name, can be NULL or empty;
+ *   - *type_id* - type ID describing the type of the parameter.
+ * Returns:
+ *   -  0, on success;
+ *   - <0, on error.
+ */
+int btf__append_func_param(struct btf *btf, const char *name, int type_i=
d)
+{
+	struct btf_type *t;
+	struct btf_param *p;
+	int sz, name_off =3D 0;
+
+	if (validate_type_id(type_id))
+		return -EINVAL;
+
+	/* last type should be BTF_KIND_FUNC_PROTO */
+	if (btf->nr_types =3D=3D 0)
+		return -EINVAL;
+	t =3D btf_type_by_id(btf, btf->nr_types);
+	if (!btf_is_func_proto(t))
+		return -EINVAL;
+
+	/* decompose and invalidate raw data */
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	sz =3D sizeof(struct btf_param);
+	p =3D btf_add_type_mem(btf, sz);
+	if (!p)
+		return -ENOMEM;
+
+	if (name && name[0]) {
+		name_off =3D btf__add_str(btf, name);
+		if (name_off < 0)
+			return name_off;
+	}
+
+	p->name_off =3D name_off;
+	p->type =3D type_id;
+
+	/* update parent type's vlen */
+	t =3D btf_type_by_id(btf, btf->nr_types);
+	btf_type_inc_vlen(t);
+
+	btf->hdr->type_len +=3D sz;
+	btf->hdr->str_off +=3D sz;
+	return 0;
+}
+
+/*
+ * Append new BTF_KIND_VAR type with:
+ *   - *name* - non-empty/non-NULL name;
+ *   - *linkage* - variable linkage, one of BTF_VAR_STATIC,
+ *     BTF_VAR_GLOBAL_ALLOCATED, or BTF_VAR_GLOBAL_EXTERN;
+ *   - *type_id* - type ID of the type describing the type of the variab=
le.
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_var(struct btf *btf, const char *name, int linkage, int =
type_id)
+{
+	struct btf_type *t;
+	struct btf_var *v;
+	int sz, err, name_off;
+
+	/* non-empty name */
+	if (!name || !name[0])
+		return -EINVAL;
+	if (linkage !=3D BTF_VAR_STATIC && linkage !=3D BTF_VAR_GLOBAL_ALLOCATE=
D &&
+	    linkage !=3D BTF_VAR_GLOBAL_EXTERN)
+		return -EINVAL;
+	if (validate_type_id(type_id))
+		return -EINVAL;
+
+	/* deconstruct BTF, if necessary, and invalidate raw_data */
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	sz =3D sizeof(struct btf_type) + sizeof(struct btf_var);
+	t =3D btf_add_type_mem(btf, sz);
+	if (!t)
+		return -ENOMEM;
+
+	name_off =3D btf__add_str(btf, name);
+	if (name_off < 0)
+		return name_off;
+
+	t->name_off =3D name_off;
+	t->info =3D btf_type_info(BTF_KIND_VAR, 0, 0);
+	t->type =3D type_id;
+
+	v =3D btf_var(t);
+	v->linkage =3D linkage;
+
+	err =3D btf_add_type_idx_entry(btf, btf->hdr->type_len);
+	if (err)
+		return err;
+
+	btf->hdr->type_len +=3D sz;
+	btf->hdr->str_off +=3D sz;
+	btf->nr_types++;
+	return btf->nr_types;
+}
+
+/*
+ * Append new BTF_KIND_DATASEC type with:
+ *   - *name* - non-empty/non-NULL name;
+ *   - *byte_sz* - data section size, in bytes.
+ *
+ * Data section is initially empty. Variables info can be added with
+ * btf__append_datasec_var_info() calls, after btf__append_datasec() suc=
ceeds.
+ *
+ * Returns:
+ *   - >0, type ID of newly added BTF type;
+ *   - <0, on error.
+ */
+int btf__append_datasec(struct btf *btf, const char *name, __u32 byte_sz=
)
+{
+	struct btf_type *t;
+	int sz, err, name_off;
+
+	/* non-empty name */
+	if (!name || !name[0])
+		return -EINVAL;
+
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	sz =3D sizeof(struct btf_type);
+	t =3D btf_add_type_mem(btf, sz);
+	if (!t)
+		return -ENOMEM;
+
+	name_off =3D btf__add_str(btf, name);
+	if (name_off < 0)
+		return name_off;
+
+	/* start with vlen=3D0, which will be update as var_secinfos are added =
*/
+	t->name_off =3D name_off;
+	t->info =3D btf_type_info(BTF_KIND_DATASEC, 0, 0);
+	t->size =3D byte_sz;
+
+	err =3D btf_add_type_idx_entry(btf, btf->hdr->type_len);
+	if (err)
+		return err;
+
+	btf->hdr->type_len +=3D sz;
+	btf->hdr->str_off +=3D sz;
+	btf->nr_types++;
+	return btf->nr_types;
+}
+
+/*
+ * Append new data section variable information entry for current DATASE=
C type:
+ *   - *var_type_id* - type ID, describing type of the variable;
+ *   - *offset* - variable offset within data section, in bytes;
+ *   - *byte_sz* - variable size, in bytes.
+ *
+ * Returns:
+ *   -  0, on success;
+ *   - <0, on error.
+ */
+int btf__append_datasec_var_info(struct btf *btf, int var_type_id, __u32=
 offset, __u32 byte_sz)
+{
+	struct btf_type *t;
+	struct btf_var_secinfo *v;
+	int sz;
+
+	/* last type should be BTF_KIND_DATASEC */
+	if (btf->nr_types =3D=3D 0)
+		return -EINVAL;
+	t =3D btf_type_by_id(btf, btf->nr_types);
+	if (!btf_is_datasec(t))
+		return -EINVAL;
+
+	if (validate_type_id(var_type_id))
+		return -EINVAL;
+
+	/* decompose and invalidate raw data */
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	sz =3D sizeof(struct btf_var_secinfo);
+	v =3D btf_add_type_mem(btf, sz);
+	if (!v)
+		return -ENOMEM;
+
+	v->type =3D var_type_id;
+	v->offset =3D offset;
+	v->size =3D byte_sz;
+
+	/* update parent type's vlen */
+	t =3D btf_type_by_id(btf, btf->nr_types);
+	btf_type_inc_vlen(t);
+
+	btf->hdr->type_len +=3D sz;
+	btf->hdr->str_off +=3D sz;
+	return 0;
+}
+
 struct btf_ext_sec_setup_param {
 	__u32 off;
 	__u32 len;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 830f798b9a77..32dd71eeed38 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -74,6 +74,43 @@ LIBBPF_API __u32 btf_ext__line_info_rec_size(const str=
uct btf_ext *btf_ext);
 LIBBPF_API struct btf *libbpf_find_kernel_btf(void);
=20
 LIBBPF_API int btf__add_str(struct btf *btf, const char *s);
+LIBBPF_API int btf__append_int(struct btf *btf, const char *name, size_t=
 byte_sz, int encoding);
+LIBBPF_API int btf__append_ptr(struct btf *btf, int ref_type_id);
+LIBBPF_API int btf__append_array(struct btf *btf,
+				 int index_type_id, int elem_type_id, __u32 nr_elems);
+/* struct/union construction APIs */
+LIBBPF_API int btf__append_struct(struct btf *btf, const char *name, __u=
32 sz);
+LIBBPF_API int btf__append_union(struct btf *btf, const char *name, __u3=
2 sz);
+LIBBPF_API int btf__append_field(struct btf *btf, const char *name, int =
field_type_id,
+				 __u32 bit_offset, __u32 bit_size);
+
+/* enum construction APIs */
+LIBBPF_API int btf__append_enum(struct btf *btf, const char *name, __u32=
 bytes_sz);
+LIBBPF_API int btf__append_enum_value(struct btf *btf, const char *name,=
 __s64 value);
+
+enum btf_fwd_kind {
+	BTF_FWD_STRUCT =3D 0,
+	BTF_FWD_UNION =3D 1,
+	BTF_FWD_ENUM =3D 2,
+};
+
+LIBBPF_API int btf__append_fwd(struct btf *btf, const char *name, enum b=
tf_fwd_kind fwd_kind);
+LIBBPF_API int btf__append_typedef(struct btf *btf, const char *name, in=
t ref_type_id);
+LIBBPF_API int btf__append_volatile(struct btf *btf, int ref_type_id);
+LIBBPF_API int btf__append_const(struct btf *btf, int ref_type_id);
+LIBBPF_API int btf__append_restrict(struct btf *btf, int ref_type_id);
+
+/* func and func_proto construction APIs */
+LIBBPF_API int btf__append_func(struct btf *btf, const char *name,
+				enum btf_func_linkage linkage, int proto_type_id);
+LIBBPF_API int btf__append_func_proto(struct btf *btf, int ret_type_id);
+LIBBPF_API int btf__append_func_param(struct btf *btf, const char *name,=
 int type_id);
+
+/* var & datasec construction APIs */
+LIBBPF_API int btf__append_var(struct btf *btf, const char *name, int li=
nkage, int type_id);
+LIBBPF_API int btf__append_datasec(struct btf *btf, const char *name, __=
u32 byte_sz);
+LIBBPF_API int btf__append_datasec_var_info(struct btf *btf, int var_typ=
e_id,
+					    __u32 offset, __u32 byte_sz);
=20
 struct btf_dedup_opts {
 	unsigned int dedup_table_size;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 180c871b04b6..6ef598472a50 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -305,6 +305,25 @@ LIBBPF_0.2.0 {
 		bpf_prog_bind_map;
 		bpf_program__section_name;
 		btf__add_str;
+		btf__append_array;
+		btf__append_const;
+		btf__append_enum;
+		btf__append_enum_value;
+		btf__append_datasec;
+		btf__append_datasec_var_info;
+		btf__append_field;
+		btf__append_func;
+		btf__append_func_param;
+		btf__append_func_proto;
+		btf__append_fwd;
+		btf__append_int;
+		btf__append_ptr;
+		btf__append_restrict;
+		btf__append_struct;
+		btf__append_typedef;
+		btf__append_union;
+		btf__append_var;
+		btf__append_volatile;
 		btf__new_empty;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;
--=20
2.24.1

