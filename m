Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB974275C82
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 17:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgIWPzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 11:55:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbgIWPzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 11:55:00 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08NFesRo021876
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 08:54:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=qBylmQPCjxivvXxI1ADMP2OhWYUu+Ym2HjmF7+oRcaI=;
 b=SyrP3FJoRzlSRMWhaPkMcB2YNk+mMlXVR94ebfRXNNgjKnFWDO7iXrUmsJmLHu6dgdPc
 b9rlYohEa3mnB47/BWcWpwcFljjD+wYievYVctXy6KaOqDRzYJN+09e9bETalqAi9Wap
 lFrdLVkdveXCMIwI/iwLAmENBuQBS0iKa7c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33qsp4vb9x-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 08:54:58 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 08:54:55 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7A8312EC7442; Wed, 23 Sep 2020 08:54:48 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH bpf-next 5/9] libbpf: allow modification of BTF and add btf__add_str API
Date:   Wed, 23 Sep 2020 08:54:32 -0700
Message-ID: <20200923155436.2117661-6-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200923155436.2117661-1-andriin@fb.com>
References: <20200923155436.2117661-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_12:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=25
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009230125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow internal BTF representation to switch from default read-only mode, =
in
which raw BTF data is a single non-modifiable block of memory with BTF he=
ader,
types, and strings layed out sequentially and contiguously in memory, int=
o
a writable representation with types and strings data split out into sepa=
rate
memory regions, that can be dynamically expanded.

Such writable internal representation is transparent to users of libbpf A=
PIs,
but allows to append new types and strings at the end of BTF, which is
a typical use case when generating BTF programmatically. All the basic
guarantees of BTF types and strings layout is preserved, i.e., user can g=
et
`struct btf_type *` pointer and read it directly. Such btf_type pointers =
might
be invalidated if BTF is modified, so some care is required in such mixed
read/write scenarios.

Switch from read-only to writable configuration happens automatically the
first time when user attempts to modify BTF by either adding a new type o=
r new
string. It is still possible to get raw BTF data, which is a single piece=
 of
memory that can be persisted in ELF section or into a file as raw BTF. Su=
ch
raw data memory is also still owned by BTF and will be freed either when =
BTF
object is freed or if another modification to BTF happens, as any modific=
ation
invalidates BTF raw representation.

This patch adds the first BTF writing API: btf__add_str(), which allows t=
o
add arbitrary strings to BTF string section. All the added strings are
automatically deduplicated. This is achieved by maintaining an additional
string lookup index for all unique strings. Such index is built when BTF =
is
switched to modifiable mode. If at that time BTF strings section containe=
d
duplicate strings, they are not de-duplicated. This is done specifically =
to
not modify the existing content of BTF (types, their string offsets, etc)=
,
which can cause confusion and is especially important property if there i=
s
struct btf_ext associated with struct btf. By following this "imperfect
deduplication" process, btf_ext is kept consitent and correct. If
deduplication of strings is necessary, it can be forced by doing BTF
deduplication, at which point all the strings will be eagerly deduplicate=
d and
all string offsets both in struct btf and struct btf_ext will be updated.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c      | 230 +++++++++++++++++++++++++++++++++++++--
 tools/lib/bpf/btf.h      |   2 +
 tools/lib/bpf/libbpf.map |   1 +
 3 files changed, 225 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index f5255e2bd222..8c8f15703608 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -44,16 +44,46 @@ struct btf {
 	 * hdr        |         |
 	 * types_data-+         |
 	 * strs_data------------+
+	 *
+	 * If BTF data is later modified, e.g., due to types added or
+	 * removed, BTF deduplication performed, etc, this contiguous
+	 * representation is broken up into three independently allocated
+	 * memory regions to be able to modify them independently.
+	 * raw_data is nulled out at that point, but can be later allocated
+	 * and cached again if user calls btf__get_raw_data(), at which point
+	 * raw_data will contain a contiguous copy of header, types, and
+	 * strings:
+	 *
+	 * +----------+  +---------+  +-----------+
+	 * |  Header  |  |  Types  |  |  Strings  |
+	 * +----------+  +---------+  +-----------+
+	 * ^             ^            ^
+	 * |             |            |
+	 * hdr           |            |
+	 * types_data----+            |
+	 * strs_data------------------+
+	 *
+	 *               +----------+---------+-----------+
+	 *               |  Header  |  Types  |  Strings  |
+	 * raw_data----->+----------+---------+-----------+
 	 */
 	struct btf_header *hdr;
+
 	void *types_data;
-	void *strs_data;
+	size_t types_data_cap; /* used size stored in hdr->type_len */
=20
 	/* type ID to `struct btf_type *` lookup index */
 	__u32 *type_offs;
 	size_t type_offs_cap;
 	__u32 nr_types;
=20
+	void *strs_data;
+	size_t strs_data_cap; /* used size stored in hdr->str_len */
+
+	/* lookup index for each unique string in strings section */
+	struct hashmap *strs_hash;
+	/* whether strings are already deduplicated */
+	bool strs_deduped;
 	/* BTF object FD, if loaded into kernel */
 	int fd;
=20
@@ -506,6 +536,11 @@ __s32 btf__find_by_name_kind(const struct btf *btf, =
const char *type_name,
 	return -ENOENT;
 }
=20
+static bool btf_is_modifiable(const struct btf *btf)
+{
+	return (void *)btf->hdr !=3D btf->raw_data;
+}
+
 void btf__free(struct btf *btf)
 {
 	if (IS_ERR_OR_NULL(btf))
@@ -514,6 +549,17 @@ void btf__free(struct btf *btf)
 	if (btf->fd >=3D 0)
 		close(btf->fd);
=20
+	if (btf_is_modifiable(btf)) {
+		/* if BTF was modified after loading, it will have a split
+		 * in-memory representation for header, types, and strings
+		 * sections, so we need to free all of them individually. It
+		 * might still have a cached contiguous raw data present,
+		 * which will be unconditionally freed below.
+		 */
+		free(btf->hdr);
+		free(btf->types_data);
+		free(btf->strs_data);
+	}
 	free(btf->raw_data);
 	free(btf->type_offs);
 	free(btf);
@@ -922,8 +968,29 @@ void btf__set_fd(struct btf *btf, int fd)
 	btf->fd =3D fd;
 }
=20
-const void *btf__get_raw_data(const struct btf *btf, __u32 *size)
+const void *btf__get_raw_data(const struct btf *btf_ro, __u32 *size)
 {
+	struct btf *btf =3D (struct btf *)btf_ro;
+
+	if (!btf->raw_data) {
+		struct btf_header *hdr =3D btf->hdr;
+		void *data;
+
+		btf->raw_size =3D hdr->hdr_len + hdr->type_len + hdr->str_len;
+		btf->raw_data =3D calloc(1, btf->raw_size);
+		if (!btf->raw_data)
+			return NULL;
+		data =3D btf->raw_data;
+
+		memcpy(data, hdr, hdr->hdr_len);
+		data +=3D hdr->hdr_len;
+
+		memcpy(data, btf->types_data, hdr->type_len);
+		data +=3D hdr->type_len;
+
+		memcpy(data, btf->strs_data, hdr->str_len);
+		data +=3D hdr->str_len;
+	}
 	*size =3D btf->raw_size;
 	return btf->raw_data;
 }
@@ -1071,6 +1138,151 @@ int btf__get_map_kv_tids(const struct btf *btf, c=
onst char *map_name,
 	return 0;
 }
=20
+static size_t strs_hash_fn(const void *key, void *ctx)
+{
+	struct btf *btf =3D ctx;
+	const char *str =3D btf->strs_data + (long)key;
+
+	return str_hash(str);
+}
+
+static bool strs_hash_equal_fn(const void *key1, const void *key2, void =
*ctx)
+{
+	struct btf *btf =3D ctx;
+	const char *str1 =3D btf->strs_data + (long)key1;
+	const char *str2 =3D btf->strs_data + (long)key2;
+
+	return strcmp(str1, str2) =3D=3D 0;
+}
+
+/* Ensure BTF is ready to be modified (by splitting into a three memory
+ * regions for header, types, and strings). Also invalidate cached
+ * raw_data, if any.
+ */
+static int btf_ensure_modifiable(struct btf *btf)
+{
+	void *hdr, *types, *strs, *strs_end, *s;
+	struct hashmap *hash =3D NULL;
+	long off;
+	int err;
+
+	if (btf_is_modifiable(btf)) {
+		/* any BTF modification invalidates raw_data */
+		if (btf->raw_data) {
+			free(btf->raw_data);
+			btf->raw_data =3D NULL;
+		}
+		return 0;
+	}
+
+	/* split raw data into three memory regions */
+	hdr =3D malloc(btf->hdr->hdr_len);
+	types =3D malloc(btf->hdr->type_len);
+	strs =3D malloc(btf->hdr->str_len);
+	if (!hdr || !types || !strs)
+		goto err_out;
+
+	memcpy(hdr, btf->hdr, btf->hdr->hdr_len);
+	memcpy(types, btf->types_data, btf->hdr->type_len);
+	memcpy(strs, btf->strs_data, btf->hdr->str_len);
+
+	/* build lookup index for all strings */
+	hash =3D hashmap__new(strs_hash_fn, strs_hash_equal_fn, btf);
+	if (IS_ERR(hash)) {
+		err =3D PTR_ERR(hash);
+		hash =3D NULL;
+		goto err_out;
+	}
+
+	strs_end =3D strs + btf->hdr->str_len;
+	for (off =3D 0, s =3D strs; s < strs_end; off +=3D strlen(s) + 1, s =3D=
 strs + off) {
+		/* hashmap__add() returns EEXIST if string with the same
+		 * content already is in the hash map
+		 */
+		err =3D hashmap__add(hash, (void *)off, (void *)off);
+		if (err =3D=3D -EEXIST)
+			continue; /* duplicate */
+		if (err)
+			goto err_out;
+	}
+
+	/* only when everything was successful, update internal state */
+	btf->hdr =3D hdr;
+	btf->types_data =3D types;
+	btf->types_data_cap =3D btf->hdr->type_len;
+	btf->strs_data =3D strs;
+	btf->strs_data_cap =3D btf->hdr->str_len;
+	btf->strs_hash =3D hash;
+	/* if BTF was created from scratch, all strings are guaranteed to be
+	 * unique and deduplicated
+	 */
+	btf->strs_deduped =3D btf->hdr->str_len <=3D 1;
+
+	/* invalidate raw_data representation */
+	free(btf->raw_data);
+	btf->raw_data =3D NULL;
+
+	return 0;
+
+err_out:
+	hashmap__free(hash);
+	free(hdr);
+	free(types);
+	free(strs);
+	return -ENOMEM;
+}
+
+static void *btf_add_str_mem(struct btf *btf, size_t add_sz)
+{
+	return btf_add_mem(&btf->strs_data, &btf->strs_data_cap, 1,
+			   btf->hdr->str_len, BTF_MAX_STR_OFFSET, add_sz);
+}
+
+/* Add a string s to the BTF string section.
+ * Returns:
+ *   - > 0 offset into string section, on success;
+ *   - < 0, on error.
+ */
+int btf__add_str(struct btf *btf, const char *s)
+{
+	long old_off, new_off, len;
+	void *p;
+	int err;
+
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
+	/* Hashmap keys are always offsets within btf->strs_data, so to even
+	 * look up some string from the "outside", we need to first append it
+	 * at the end, so that it can be addressed with an offset. Luckily,
+	 * until btf->hdr->str_len is incremented, that string is just a piece
+	 * of garbage for the rest of BTF code, so no harm, no foul. On the
+	 * other hand, if the string is unique, it's already appended and
+	 * ready to be used, only a simple btf->hdr->str_len increment away.
+	 */
+	len =3D strlen(s) + 1;
+	p =3D btf_add_str_mem(btf, len);
+	if (!p)
+		return -ENOMEM;
+
+	new_off =3D btf->hdr->str_len;
+	memcpy(p, s, len);
+
+	/* Now attempt to add the string, but only if the string with the same
+	 * contents doesn't exist already (HASHMAP_ADD strategy). If such
+	 * string exists, we'll get its offset in old_off (that's old_key).
+	 */
+	err =3D hashmap__insert(btf->strs_hash, (void *)new_off, (void *)new_of=
f,
+			      HASHMAP_ADD, (const void **)&old_off, NULL);
+	if (err =3D=3D -EEXIST)
+		return old_off; /* duplicated string, return existing offset */
+	if (err)
+		return err;
+
+	btf->hdr->str_len +=3D len; /* new unique string, adjust data length */
+	return new_off;
+}
+
 struct btf_ext_sec_setup_param {
 	__u32 off;
 	__u32 len;
@@ -1537,6 +1749,9 @@ int btf__dedup(struct btf *btf, struct btf_ext *btf=
_ext,
 		return -EINVAL;
 	}
=20
+	if (btf_ensure_modifiable(btf))
+		return -ENOMEM;
+
 	err =3D btf_dedup_strings(d);
 	if (err < 0) {
 		pr_debug("btf_dedup_strings failed:%d\n", err);
@@ -1926,6 +2141,9 @@ static int btf_dedup_strings(struct btf_dedup *d)
 	int i, j, err =3D 0, grp_idx;
 	bool grp_used;
=20
+	if (d->btf->strs_deduped)
+		return 0;
+
 	/* build index of all strings */
 	while (p < end) {
 		if (strs.cnt + 1 > strs.cap) {
@@ -2018,6 +2236,7 @@ static int btf_dedup_strings(struct btf_dedup *d)
 		goto done;
=20
 	d->btf->hdr->str_len =3D end - start;
+	d->btf->strs_deduped =3D true;
=20
 done:
 	free(tmp_strs);
@@ -3021,12 +3240,7 @@ static int btf_dedup_compact_types(struct btf_dedu=
p *d)
 	if (!new_offs)
 		return -ENOMEM;
 	d->btf->type_offs =3D new_offs;
-
-	/* make sure string section follows type information without gaps */
-	d->btf->hdr->str_off =3D p - d->btf->types_data;
-	memmove(p, d->btf->strs_data, d->btf->hdr->str_len);
-	d->btf->strs_data =3D p;
-
+	d->btf->hdr->str_off =3D d->btf->hdr->type_len;
 	d->btf->raw_size =3D d->btf->hdr->hdr_len + d->btf->hdr->type_len + d->=
btf->hdr->str_len;
 	return 0;
 }
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 2a55320d87d0..84cb0502af95 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -72,6 +72,8 @@ LIBBPF_API __u32 btf_ext__line_info_rec_size(const stru=
ct btf_ext *btf_ext);
=20
 LIBBPF_API struct btf *libbpf_find_kernel_btf(void);
=20
+LIBBPF_API int btf__add_str(struct btf *btf, const char *s);
+
 struct btf_dedup_opts {
 	unsigned int dedup_table_size;
 	bool dont_resolve_fwds;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 5f054dadf082..b4274c0fdd04 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -304,6 +304,7 @@ LIBBPF_0.2.0 {
 	global:
 		bpf_prog_bind_map;
 		bpf_program__section_name;
+		btf__add_str;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;
 		perf_buffer__epoll_fd;
--=20
2.24.1

