Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A674B2A7676
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbgKEEeT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Nov 2020 23:34:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2558 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731341AbgKEEeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:34:19 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A54Ti8s005834
        for <netdev@vger.kernel.org>; Wed, 4 Nov 2020 20:34:18 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34kg7kykak-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 20:34:18 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 20:34:13 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 74B072EC8E04; Wed,  4 Nov 2020 20:34:12 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 04/11] libbpf: implement basic split BTF support
Date:   Wed, 4 Nov 2020 20:33:54 -0800
Message-ID: <20201105043402.2530976-5-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105043402.2530976-1-andrii@kernel.org>
References: <20201105043402.2530976-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_01:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 phishscore=0 suspectscore=25 impostorscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011050032
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support split BTF operation, in which one BTF (base BTF) provides basic set of
types and strings, while another one (split BTF) builds on top of base's types
and strings and adds its own new types and strings. From API standpoint, the
fact that the split BTF is built on top of the base BTF is transparent.

Type numeration is transparent. If the base BTF had last type ID #N, then all
types in the split BTF start at type ID N+1. Any type in split BTF can
reference base BTF types, but not vice versa. Programmatically construction of
a split BTF on top of a base BTF is supported: one can create an empty split
BTF with btf__new_empty_split() and pass base BTF as an input, or pass raw
binary data to btf__new_split(), or use btf__parse_xxx_split() variants to get
initial set of split types/strings from the ELF file with .BTF section.

String offsets are similarly transparent and are a logical continuation of
base BTF's strings. When building BTF programmatically and adding a new string
(explicitly with btf__add_str() or implicitly through appending new
types/members), string-to-be-added would first be looked up from the base
BTF's string section and re-used if it's there. If not, it will be looked up
and/or added to the split BTF string section. Similarly to type IDs, types in
split BTF can refer to strings from base BTF absolutely transparently (but not
vice versa, of course, because base BTF doesn't "know" about existence of
split BTF).

Internal type index is slightly adjusted to be zero-indexed, ignoring a fake
[0] VOID type. This allows to handle split/base BTF type lookups transparently
by using btf->start_id type ID offset, which is always 1 for base/non-split
BTF and equals btf__get_nr_types(base_btf) + 1 for the split BTF.

BTF deduplication is not yet supported for split BTF and support for it will
be added in separate patch.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c      | 197 ++++++++++++++++++++++++++++++---------
 tools/lib/bpf/btf.h      |   8 ++
 tools/lib/bpf/libbpf.map |   9 ++
 3 files changed, 169 insertions(+), 45 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index fa1b147c63c6..0258cf108c0a 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -78,10 +78,32 @@ struct btf {
 	void *types_data;
 	size_t types_data_cap; /* used size stored in hdr->type_len */
 
-	/* type ID to `struct btf_type *` lookup index */
+	/* type ID to `struct btf_type *` lookup index
+	 * type_offs[0] corresponds to the first non-VOID type:
+	 *   - for base BTF it's type [1];
+	 *   - for split BTF it's the first non-base BTF type.
+	 */
 	__u32 *type_offs;
 	size_t type_offs_cap;
+	/* number of types in this BTF instance:
+	 *   - doesn't include special [0] void type;
+	 *   - for split BTF counts number of types added on top of base BTF.
+	 */
 	__u32 nr_types;
+	/* if not NULL, points to the base BTF on top of which the current
+	 * split BTF is based
+	 */
+	struct btf *base_btf;
+	/* BTF type ID of the first type in this BTF instance:
+	 *   - for base BTF it's equal to 1;
+	 *   - for split BTF it's equal to biggest type ID of base BTF plus 1.
+	 */
+	int start_id;
+	/* logical string offset of this BTF instance:
+	 *   - for base BTF it's equal to 0;
+	 *   - for split BTF it's equal to total size of base BTF's string section size.
+	 */
+	int start_str_off;
 
 	void *strs_data;
 	size_t strs_data_cap; /* used size stored in hdr->str_len */
@@ -176,7 +198,7 @@ static int btf_add_type_idx_entry(struct btf *btf, __u32 type_off)
 	__u32 *p;
 
 	p = btf_add_mem((void **)&btf->type_offs, &btf->type_offs_cap, sizeof(__u32),
-			btf->nr_types + 1, BTF_MAX_NR_TYPES, 1);
+			btf->nr_types, BTF_MAX_NR_TYPES, 1);
 	if (!p)
 		return -ENOMEM;
 
@@ -252,12 +274,16 @@ static int btf_parse_str_sec(struct btf *btf)
 	const char *start = btf->strs_data;
 	const char *end = start + btf->hdr->str_len;
 
-	if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET ||
-	    start[0] || end[-1]) {
+	if (btf->base_btf && hdr->str_len == 0)
+		return 0;
+	if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET || end[-1]) {
+		pr_debug("Invalid BTF string section\n");
+		return -EINVAL;
+	}
+	if (!btf->base_btf && start[0]) {
 		pr_debug("Invalid BTF string section\n");
 		return -EINVAL;
 	}
-
 	return 0;
 }
 
@@ -372,19 +398,9 @@ static int btf_parse_type_sec(struct btf *btf)
 	struct btf_header *hdr = btf->hdr;
 	void *next_type = btf->types_data;
 	void *end_type = next_type + hdr->type_len;
-	int err, i = 0, type_size;
-
-	/* VOID (type_id == 0) is specially handled by btf__get_type_by_id(),
-	 * so ensure we can never properly use its offset from index by
-	 * setting it to a large value
-	 */
-	err = btf_add_type_idx_entry(btf, UINT_MAX);
-	if (err)
-		return err;
+	int err, type_size;
 
 	while (next_type + sizeof(struct btf_type) <= end_type) {
-		i++;
-
 		if (btf->swapped_endian)
 			btf_bswap_type_base(next_type);
 
@@ -392,7 +408,7 @@ static int btf_parse_type_sec(struct btf *btf)
 		if (type_size < 0)
 			return type_size;
 		if (next_type + type_size > end_type) {
-			pr_warn("BTF type [%d] is malformed\n", i);
+			pr_warn("BTF type [%d] is malformed\n", btf->start_id + btf->nr_types);
 			return -EINVAL;
 		}
 
@@ -417,7 +433,7 @@ static int btf_parse_type_sec(struct btf *btf)
 
 __u32 btf__get_nr_types(const struct btf *btf)
 {
-	return btf->nr_types;
+	return btf->start_id + btf->nr_types - 1;
 }
 
 /* internal helper returning non-const pointer to a type */
@@ -425,13 +441,14 @@ static struct btf_type *btf_type_by_id(struct btf *btf, __u32 type_id)
 {
 	if (type_id == 0)
 		return &btf_void;
-
-	return btf->types_data + btf->type_offs[type_id];
+	if (type_id < btf->start_id)
+		return btf_type_by_id(btf->base_btf, type_id);
+	return btf->types_data + btf->type_offs[type_id - btf->start_id];
 }
 
 const struct btf_type *btf__type_by_id(const struct btf *btf, __u32 type_id)
 {
-	if (type_id > btf->nr_types)
+	if (type_id >= btf->start_id + btf->nr_types)
 		return NULL;
 	return btf_type_by_id((struct btf *)btf, type_id);
 }
@@ -440,9 +457,13 @@ static int determine_ptr_size(const struct btf *btf)
 {
 	const struct btf_type *t;
 	const char *name;
-	int i;
+	int i, n;
 
-	for (i = 1; i <= btf->nr_types; i++) {
+	if (btf->base_btf && btf->base_btf->ptr_sz > 0)
+		return btf->base_btf->ptr_sz;
+
+	n = btf__get_nr_types(btf);
+	for (i = 1; i <= n; i++) {
 		t = btf__type_by_id(btf, i);
 		if (!btf_is_int(t))
 			continue;
@@ -725,7 +746,7 @@ void btf__free(struct btf *btf)
 	free(btf);
 }
 
-struct btf *btf__new_empty(void)
+static struct btf *btf_new_empty(struct btf *base_btf)
 {
 	struct btf *btf;
 
@@ -733,12 +754,21 @@ struct btf *btf__new_empty(void)
 	if (!btf)
 		return ERR_PTR(-ENOMEM);
 
+	btf->nr_types = 0;
+	btf->start_id = 1;
+	btf->start_str_off = 0;
 	btf->fd = -1;
 	btf->ptr_sz = sizeof(void *);
 	btf->swapped_endian = false;
 
+	if (base_btf) {
+		btf->base_btf = base_btf;
+		btf->start_id = btf__get_nr_types(base_btf) + 1;
+		btf->start_str_off = base_btf->hdr->str_len;
+	}
+
 	/* +1 for empty string at offset 0 */
-	btf->raw_size = sizeof(struct btf_header) + 1;
+	btf->raw_size = sizeof(struct btf_header) + (base_btf ? 0 : 1);
 	btf->raw_data = calloc(1, btf->raw_size);
 	if (!btf->raw_data) {
 		free(btf);
@@ -752,12 +782,22 @@ struct btf *btf__new_empty(void)
 
 	btf->types_data = btf->raw_data + btf->hdr->hdr_len;
 	btf->strs_data = btf->raw_data + btf->hdr->hdr_len;
-	btf->hdr->str_len = 1; /* empty string at offset 0 */
+	btf->hdr->str_len = base_btf ? 0 : 1; /* empty string at offset 0 */
 
 	return btf;
 }
 
-struct btf *btf__new(const void *data, __u32 size)
+struct btf *btf__new_empty(void)
+{
+	return btf_new_empty(NULL);
+}
+
+struct btf *btf__new_empty_split(struct btf *base_btf)
+{
+	return btf_new_empty(base_btf);
+}
+
+static struct btf *btf_new(const void *data, __u32 size, struct btf *base_btf)
 {
 	struct btf *btf;
 	int err;
@@ -766,6 +806,16 @@ struct btf *btf__new(const void *data, __u32 size)
 	if (!btf)
 		return ERR_PTR(-ENOMEM);
 
+	btf->nr_types = 0;
+	btf->start_id = 1;
+	btf->start_str_off = 0;
+
+	if (base_btf) {
+		btf->base_btf = base_btf;
+		btf->start_id = btf__get_nr_types(base_btf) + 1;
+		btf->start_str_off = base_btf->hdr->str_len;
+	}
+
 	btf->raw_data = malloc(size);
 	if (!btf->raw_data) {
 		err = -ENOMEM;
@@ -798,7 +848,13 @@ struct btf *btf__new(const void *data, __u32 size)
 	return btf;
 }
 
-struct btf *btf__parse_elf(const char *path, struct btf_ext **btf_ext)
+struct btf *btf__new(const void *data, __u32 size)
+{
+	return btf_new(data, size, NULL);
+}
+
+static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
+				 struct btf_ext **btf_ext)
 {
 	Elf_Data *btf_data = NULL, *btf_ext_data = NULL;
 	int err = 0, fd = -1, idx = 0;
@@ -876,7 +932,7 @@ struct btf *btf__parse_elf(const char *path, struct btf_ext **btf_ext)
 		err = -ENOENT;
 		goto done;
 	}
-	btf = btf__new(btf_data->d_buf, btf_data->d_size);
+	btf = btf_new(btf_data->d_buf, btf_data->d_size, base_btf);
 	if (IS_ERR(btf))
 		goto done;
 
@@ -921,7 +977,17 @@ struct btf *btf__parse_elf(const char *path, struct btf_ext **btf_ext)
 	return btf;
 }
 
-struct btf *btf__parse_raw(const char *path)
+struct btf *btf__parse_elf(const char *path, struct btf_ext **btf_ext)
+{
+	return btf_parse_elf(path, NULL, btf_ext);
+}
+
+struct btf *btf__parse_elf_split(const char *path, struct btf *base_btf)
+{
+	return btf_parse_elf(path, base_btf, NULL);
+}
+
+static struct btf *btf_parse_raw(const char *path, struct btf *base_btf)
 {
 	struct btf *btf = NULL;
 	void *data = NULL;
@@ -975,7 +1041,7 @@ struct btf *btf__parse_raw(const char *path)
 	}
 
 	/* finally parse BTF data */
-	btf = btf__new(data, sz);
+	btf = btf_new(data, sz, base_btf);
 
 err_out:
 	free(data);
@@ -984,18 +1050,38 @@ struct btf *btf__parse_raw(const char *path)
 	return err ? ERR_PTR(err) : btf;
 }
 
-struct btf *btf__parse(const char *path, struct btf_ext **btf_ext)
+struct btf *btf__parse_raw(const char *path)
+{
+	return btf_parse_raw(path, NULL);
+}
+
+struct btf *btf__parse_raw_split(const char *path, struct btf *base_btf)
+{
+	return btf_parse_raw(path, base_btf);
+}
+
+static struct btf *btf_parse(const char *path, struct btf *base_btf, struct btf_ext **btf_ext)
 {
 	struct btf *btf;
 
 	if (btf_ext)
 		*btf_ext = NULL;
 
-	btf = btf__parse_raw(path);
+	btf = btf_parse_raw(path, base_btf);
 	if (!IS_ERR(btf) || PTR_ERR(btf) != -EPROTO)
 		return btf;
 
-	return btf__parse_elf(path, btf_ext);
+	return btf_parse_elf(path, base_btf, btf_ext);
+}
+
+struct btf *btf__parse(const char *path, struct btf_ext **btf_ext)
+{
+	return btf_parse(path, NULL, btf_ext);
+}
+
+struct btf *btf__parse_split(const char *path, struct btf *base_btf)
+{
+	return btf_parse(path, base_btf, NULL);
 }
 
 static int compare_vsi_off(const void *_a, const void *_b)
@@ -1179,8 +1265,8 @@ static void *btf_get_raw_data(const struct btf *btf, __u32 *size, bool swap_endi
 
 	memcpy(p, btf->types_data, hdr->type_len);
 	if (swap_endian) {
-		for (i = 1; i <= btf->nr_types; i++) {
-			t = p  + btf->type_offs[i];
+		for (i = 0; i < btf->nr_types; i++) {
+			t = p + btf->type_offs[i];
 			/* btf_bswap_type_rest() relies on native t->info, so
 			 * we swap base type info after we swapped all the
 			 * additional information
@@ -1223,8 +1309,10 @@ const void *btf__get_raw_data(const struct btf *btf_ro, __u32 *size)
 
 const char *btf__str_by_offset(const struct btf *btf, __u32 offset)
 {
-	if (offset < btf->hdr->str_len)
-		return btf->strs_data + offset;
+	if (offset < btf->start_str_off)
+		return btf__str_by_offset(btf->base_btf, offset);
+	else if (offset - btf->start_str_off < btf->hdr->str_len)
+		return btf->strs_data + (offset - btf->start_str_off);
 	else
 		return NULL;
 }
@@ -1461,7 +1549,10 @@ static int btf_ensure_modifiable(struct btf *btf)
 	/* if BTF was created from scratch, all strings are guaranteed to be
 	 * unique and deduplicated
 	 */
-	btf->strs_deduped = btf->hdr->str_len <= 1;
+	if (btf->hdr->str_len == 0)
+		btf->strs_deduped = true;
+	if (!btf->base_btf && btf->hdr->str_len == 1)
+		btf->strs_deduped = true;
 
 	/* invalidate raw_data representation */
 	btf_invalidate_raw_data(btf);
@@ -1493,6 +1584,14 @@ int btf__find_str(struct btf *btf, const char *s)
 	long old_off, new_off, len;
 	void *p;
 
+	if (btf->base_btf) {
+		int ret;
+
+		ret = btf__find_str(btf->base_btf, s);
+		if (ret != -ENOENT)
+			return ret;
+	}
+
 	/* BTF needs to be in a modifiable state to build string lookup index */
 	if (btf_ensure_modifiable(btf))
 		return -ENOMEM;
@@ -1507,7 +1606,7 @@ int btf__find_str(struct btf *btf, const char *s)
 	memcpy(p, s, len);
 
 	if (hashmap__find(btf->strs_hash, (void *)new_off, (void **)&old_off))
-		return old_off;
+		return btf->start_str_off + old_off;
 
 	return -ENOENT;
 }
@@ -1523,6 +1622,14 @@ int btf__add_str(struct btf *btf, const char *s)
 	void *p;
 	int err;
 
+	if (btf->base_btf) {
+		int ret;
+
+		ret = btf__find_str(btf->base_btf, s);
+		if (ret != -ENOENT)
+			return ret;
+	}
+
 	if (btf_ensure_modifiable(btf))
 		return -ENOMEM;
 
@@ -1549,12 +1656,12 @@ int btf__add_str(struct btf *btf, const char *s)
 	err = hashmap__insert(btf->strs_hash, (void *)new_off, (void *)new_off,
 			      HASHMAP_ADD, (const void **)&old_off, NULL);
 	if (err == -EEXIST)
-		return old_off; /* duplicated string, return existing offset */
+		return btf->start_str_off + old_off; /* duplicated string, return existing offset */
 	if (err)
 		return err;
 
 	btf->hdr->str_len += len; /* new unique string, adjust data length */
-	return new_off;
+	return btf->start_str_off + new_off;
 }
 
 static void *btf_add_type_mem(struct btf *btf, size_t add_sz)
@@ -1584,7 +1691,7 @@ static int btf_commit_type(struct btf *btf, int data_sz)
 	btf->hdr->type_len += data_sz;
 	btf->hdr->str_off += data_sz;
 	btf->nr_types++;
-	return btf->nr_types;
+	return btf->start_id + btf->nr_types - 1;
 }
 
 /*
@@ -4167,14 +4274,14 @@ static int btf_dedup_compact_types(struct btf_dedup *d)
 
 		memmove(p, btf__type_by_id(d->btf, i), len);
 		d->hypot_map[i] = next_type_id;
-		d->btf->type_offs[next_type_id] = p - d->btf->types_data;
+		d->btf->type_offs[next_type_id - 1] = p - d->btf->types_data;
 		p += len;
 		next_type_id++;
 	}
 
 	/* shrink struct btf's internal types index and update btf_header */
 	d->btf->nr_types = next_type_id - 1;
-	d->btf->type_offs_cap = d->btf->nr_types + 1;
+	d->btf->type_offs_cap = d->btf->nr_types;
 	d->btf->hdr->type_len = p - d->btf->types_data;
 	new_offs = libbpf_reallocarray(d->btf->type_offs, d->btf->type_offs_cap,
 				       sizeof(*new_offs));
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 57247240a20a..1093f6fe6800 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -31,11 +31,19 @@ enum btf_endianness {
 };
 
 LIBBPF_API void btf__free(struct btf *btf);
+
 LIBBPF_API struct btf *btf__new(const void *data, __u32 size);
+LIBBPF_API struct btf *btf__new_split(const void *data, __u32 size, struct btf *base_btf);
 LIBBPF_API struct btf *btf__new_empty(void);
+LIBBPF_API struct btf *btf__new_empty_split(struct btf *base_btf);
+
 LIBBPF_API struct btf *btf__parse(const char *path, struct btf_ext **btf_ext);
+LIBBPF_API struct btf *btf__parse_split(const char *path, struct btf *base_btf);
 LIBBPF_API struct btf *btf__parse_elf(const char *path, struct btf_ext **btf_ext);
+LIBBPF_API struct btf *btf__parse_elf_split(const char *path, struct btf *base_btf);
 LIBBPF_API struct btf *btf__parse_raw(const char *path);
+LIBBPF_API struct btf *btf__parse_raw_split(const char *path, struct btf *base_btf);
+
 LIBBPF_API int btf__finalize_data(struct bpf_object *obj, struct btf *btf);
 LIBBPF_API int btf__load(struct btf *btf);
 LIBBPF_API __s32 btf__find_by_name(const struct btf *btf,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 4ebfadf45b47..29ff4807b909 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -337,3 +337,12 @@ LIBBPF_0.2.0 {
 		perf_buffer__consume_buffer;
 		xsk_socket__create_shared;
 } LIBBPF_0.1.0;
+
+LIBBPF_0.3.0 {
+	global:
+		btf__parse_elf_split;
+		btf__parse_raw_split;
+		btf__parse_split;
+		btf__new_empty_split;
+		btf__new_split;
+} LIBBPF_0.2.0;
-- 
2.24.1

