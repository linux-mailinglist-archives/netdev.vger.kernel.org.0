Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A4F340E7E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhCRTlY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Mar 2021 15:41:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5618 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232923AbhCRTky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:40:54 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IJU5sL003864
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:40:54 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs29paek-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:40:54 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 12:40:52 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9AA132ED2588; Thu, 18 Mar 2021 12:40:50 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH v4 bpf-next 04/12] libbpf: extract internal set-of-strings datastructure APIs
Date:   Thu, 18 Mar 2021 12:40:28 -0700
Message-ID: <20210318194036.3521577-5-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318194036.3521577-1-andrii@kernel.org>
References: <20210318194036.3521577-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_12:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103180139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract BTF logic for maintaining a set of strings data structure, used for
BTF strings section construction in writable mode, into separate re-usable
API. This data structure is going to be used by bpf_linker to maintains ELF
STRTAB section, which has the same layout as BTF strings section.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/Build    |   2 +-
 tools/lib/bpf/btf.c    | 255 ++++++++++-------------------------------
 tools/lib/bpf/strset.c | 176 ++++++++++++++++++++++++++++
 tools/lib/bpf/strset.h |  21 ++++
 4 files changed, 259 insertions(+), 195 deletions(-)
 create mode 100644 tools/lib/bpf/strset.c
 create mode 100644 tools/lib/bpf/strset.h

diff --git a/tools/lib/bpf/Build b/tools/lib/bpf/Build
index 190366d05588..8136186a453f 100644
--- a/tools/lib/bpf/Build
+++ b/tools/lib/bpf/Build
@@ -1,3 +1,3 @@
 libbpf-y := libbpf.o bpf.o nlattr.o btf.o libbpf_errno.o str_error.o \
 	    netlink.o bpf_prog_linfo.o libbpf_probes.o xsk.o hashmap.o \
-	    btf_dump.o ringbuf.o
+	    btf_dump.o ringbuf.o strset.o
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index c98d39710515..fe087592ad35 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -21,6 +21,7 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
 #include "hashmap.h"
+#include "strset.h"
 
 #define BTF_MAX_NR_TYPES 0x7fffffffU
 #define BTF_MAX_STR_OFFSET 0x7fffffffU
@@ -67,7 +68,7 @@ struct btf {
 	 * |             |            |
 	 * hdr           |            |
 	 * types_data----+            |
-	 * strs_data------------------+
+	 * strset__data(strs_set)-----+
 	 *
 	 *               +----------+---------+-----------+
 	 *               |  Header  |  Types  |  Strings  |
@@ -105,20 +106,15 @@ struct btf {
 	 */
 	int start_str_off;
 
+	/* only one of strs_data or strs_set can be non-NULL, depending on
+	 * whether BTF is in a modifiable state (strs_set is used) or not
+	 * (strs_data points inside raw_data)
+	 */
 	void *strs_data;
-	size_t strs_data_cap; /* used size stored in hdr->str_len */
-
-	/* lookup index for each unique string in strings section */
-	struct hashmap *strs_hash;
+	/* a set of unique strings */
+	struct strset *strs_set;
 	/* whether strings are already deduplicated */
 	bool strs_deduped;
-	/* extra indirection layer to make strings hashmap work with stable
-	 * string offsets and ability to transparently choose between
-	 * btf->strs_data or btf_dedup->strs_data as a source of strings.
-	 * This is used for BTF strings dedup to transfer deduplicated strings
-	 * data back to struct btf without re-building strings index.
-	 */
-	void **strs_data_ptr;
 
 	/* BTF object FD, if loaded into kernel */
 	int fd;
@@ -738,7 +734,7 @@ void btf__free(struct btf *btf)
 		 */
 		free(btf->hdr);
 		free(btf->types_data);
-		free(btf->strs_data);
+		strset__free(btf->strs_set);
 	}
 	free(btf->raw_data);
 	free(btf->raw_data_swapped);
@@ -1246,6 +1242,11 @@ void btf__set_fd(struct btf *btf, int fd)
 	btf->fd = fd;
 }
 
+static const void *btf_strs_data(const struct btf *btf)
+{
+	return btf->strs_data ? btf->strs_data : strset__data(btf->strs_set);
+}
+
 static void *btf_get_raw_data(const struct btf *btf, __u32 *size, bool swap_endian)
 {
 	struct btf_header *hdr = btf->hdr;
@@ -1286,7 +1287,7 @@ static void *btf_get_raw_data(const struct btf *btf, __u32 *size, bool swap_endi
 	}
 	p += hdr->type_len;
 
-	memcpy(p, btf->strs_data, hdr->str_len);
+	memcpy(p, btf_strs_data(btf), hdr->str_len);
 	p += hdr->str_len;
 
 	*size = data_sz;
@@ -1320,7 +1321,7 @@ const char *btf__str_by_offset(const struct btf *btf, __u32 offset)
 	if (offset < btf->start_str_off)
 		return btf__str_by_offset(btf->base_btf, offset);
 	else if (offset - btf->start_str_off < btf->hdr->str_len)
-		return btf->strs_data + (offset - btf->start_str_off);
+		return btf_strs_data(btf) + (offset - btf->start_str_off);
 	else
 		return NULL;
 }
@@ -1474,25 +1475,6 @@ int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 	return 0;
 }
 
-static size_t strs_hash_fn(const void *key, void *ctx)
-{
-	const struct btf *btf = ctx;
-	const char *strs = *btf->strs_data_ptr;
-	const char *str = strs + (long)key;
-
-	return str_hash(str);
-}
-
-static bool strs_hash_equal_fn(const void *key1, const void *key2, void *ctx)
-{
-	const struct btf *btf = ctx;
-	const char *strs = *btf->strs_data_ptr;
-	const char *str1 = strs + (long)key1;
-	const char *str2 = strs + (long)key2;
-
-	return strcmp(str1, str2) == 0;
-}
-
 static void btf_invalidate_raw_data(struct btf *btf)
 {
 	if (btf->raw_data) {
@@ -1511,10 +1493,9 @@ static void btf_invalidate_raw_data(struct btf *btf)
  */
 static int btf_ensure_modifiable(struct btf *btf)
 {
-	void *hdr, *types, *strs, *strs_end, *s;
-	struct hashmap *hash = NULL;
-	long off;
-	int err;
+	void *hdr, *types;
+	struct strset *set = NULL;
+	int err = -ENOMEM;
 
 	if (btf_is_modifiable(btf)) {
 		/* any BTF modification invalidates raw_data */
@@ -1525,44 +1506,25 @@ static int btf_ensure_modifiable(struct btf *btf)
 	/* split raw data into three memory regions */
 	hdr = malloc(btf->hdr->hdr_len);
 	types = malloc(btf->hdr->type_len);
-	strs = malloc(btf->hdr->str_len);
-	if (!hdr || !types || !strs)
+	if (!hdr || !types)
 		goto err_out;
 
 	memcpy(hdr, btf->hdr, btf->hdr->hdr_len);
 	memcpy(types, btf->types_data, btf->hdr->type_len);
-	memcpy(strs, btf->strs_data, btf->hdr->str_len);
-
-	/* make hashmap below use btf->strs_data as a source of strings */
-	btf->strs_data_ptr = &btf->strs_data;
 
 	/* build lookup index for all strings */
-	hash = hashmap__new(strs_hash_fn, strs_hash_equal_fn, btf);
-	if (IS_ERR(hash)) {
-		err = PTR_ERR(hash);
-		hash = NULL;
+	set = strset__new(BTF_MAX_STR_OFFSET, btf->strs_data, btf->hdr->str_len);
+	if (IS_ERR(set)) {
+		err = PTR_ERR(set);
 		goto err_out;
 	}
 
-	strs_end = strs + btf->hdr->str_len;
-	for (off = 0, s = strs; s < strs_end; off += strlen(s) + 1, s = strs + off) {
-		/* hashmap__add() returns EEXIST if string with the same
-		 * content already is in the hash map
-		 */
-		err = hashmap__add(hash, (void *)off, (void *)off);
-		if (err == -EEXIST)
-			continue; /* duplicate */
-		if (err)
-			goto err_out;
-	}
-
 	/* only when everything was successful, update internal state */
 	btf->hdr = hdr;
 	btf->types_data = types;
 	btf->types_data_cap = btf->hdr->type_len;
-	btf->strs_data = strs;
-	btf->strs_data_cap = btf->hdr->str_len;
-	btf->strs_hash = hash;
+	btf->strs_data = NULL;
+	btf->strs_set = set;
 	/* if BTF was created from scratch, all strings are guaranteed to be
 	 * unique and deduplicated
 	 */
@@ -1577,17 +1539,10 @@ static int btf_ensure_modifiable(struct btf *btf)
 	return 0;
 
 err_out:
-	hashmap__free(hash);
+	strset__free(set);
 	free(hdr);
 	free(types);
-	free(strs);
-	return -ENOMEM;
-}
-
-static void *btf_add_str_mem(struct btf *btf, size_t add_sz)
-{
-	return libbpf_add_mem(&btf->strs_data, &btf->strs_data_cap, 1,
-			      btf->hdr->str_len, BTF_MAX_STR_OFFSET, add_sz);
+	return err;
 }
 
 /* Find an offset in BTF string section that corresponds to a given string *s*.
@@ -1598,34 +1553,23 @@ static void *btf_add_str_mem(struct btf *btf, size_t add_sz)
  */
 int btf__find_str(struct btf *btf, const char *s)
 {
-	long old_off, new_off, len;
-	void *p;
+	int off;
 
 	if (btf->base_btf) {
-		int ret;
-
-		ret = btf__find_str(btf->base_btf, s);
-		if (ret != -ENOENT)
-			return ret;
+		off = btf__find_str(btf->base_btf, s);
+		if (off != -ENOENT)
+			return off;
 	}
 
 	/* BTF needs to be in a modifiable state to build string lookup index */
 	if (btf_ensure_modifiable(btf))
 		return -ENOMEM;
 
-	/* see btf__add_str() for why we do this */
-	len = strlen(s) + 1;
-	p = btf_add_str_mem(btf, len);
-	if (!p)
-		return -ENOMEM;
-
-	new_off = btf->hdr->str_len;
-	memcpy(p, s, len);
+	off = strset__find_str(btf->strs_set, s);
+	if (off < 0)
+		return off;
 
-	if (hashmap__find(btf->strs_hash, (void *)new_off, (void **)&old_off))
-		return btf->start_str_off + old_off;
-
-	return -ENOENT;
+	return btf->start_str_off + off;
 }
 
 /* Add a string s to the BTF string section.
@@ -1635,50 +1579,24 @@ int btf__find_str(struct btf *btf, const char *s)
  */
 int btf__add_str(struct btf *btf, const char *s)
 {
-	long old_off, new_off, len;
-	void *p;
-	int err;
+	int off;
 
 	if (btf->base_btf) {
-		int ret;
-
-		ret = btf__find_str(btf->base_btf, s);
-		if (ret != -ENOENT)
-			return ret;
+		off = btf__find_str(btf->base_btf, s);
+		if (off != -ENOENT)
+			return off;
 	}
 
 	if (btf_ensure_modifiable(btf))
 		return -ENOMEM;
 
-	/* Hashmap keys are always offsets within btf->strs_data, so to even
-	 * look up some string from the "outside", we need to first append it
-	 * at the end, so that it can be addressed with an offset. Luckily,
-	 * until btf->hdr->str_len is incremented, that string is just a piece
-	 * of garbage for the rest of BTF code, so no harm, no foul. On the
-	 * other hand, if the string is unique, it's already appended and
-	 * ready to be used, only a simple btf->hdr->str_len increment away.
-	 */
-	len = strlen(s) + 1;
-	p = btf_add_str_mem(btf, len);
-	if (!p)
-		return -ENOMEM;
+	off = strset__add_str(btf->strs_set, s);
+	if (off < 0)
+		return off;
 
-	new_off = btf->hdr->str_len;
-	memcpy(p, s, len);
+	btf->hdr->str_len = strset__data_size(btf->strs_set);
 
-	/* Now attempt to add the string, but only if the string with the same
-	 * contents doesn't exist already (HASHMAP_ADD strategy). If such
-	 * string exists, we'll get its offset in old_off (that's old_key).
-	 */
-	err = hashmap__insert(btf->strs_hash, (void *)new_off, (void *)new_off,
-			      HASHMAP_ADD, (const void **)&old_off, NULL);
-	if (err == -EEXIST)
-		return btf->start_str_off + old_off; /* duplicated string, return existing offset */
-	if (err)
-		return err;
-
-	btf->hdr->str_len += len; /* new unique string, adjust data length */
-	return btf->start_str_off + new_off;
+	return btf->start_str_off + off;
 }
 
 static void *btf_add_type_mem(struct btf *btf, size_t add_sz)
@@ -3016,10 +2934,7 @@ struct btf_dedup {
 	/* Various option modifying behavior of algorithm */
 	struct btf_dedup_opts opts;
 	/* temporary strings deduplication state */
-	void *strs_data;
-	size_t strs_cap;
-	size_t strs_len;
-	struct hashmap* strs_hash;
+	struct strset *strs_set;
 };
 
 static long hash_combine(long h, long value)
@@ -3185,10 +3100,8 @@ static int strs_dedup_remap_str_off(__u32 *str_off_ptr, void *ctx)
 {
 	struct btf_dedup *d = ctx;
 	__u32 str_off = *str_off_ptr;
-	long old_off, new_off, len;
 	const char *s;
-	void *p;
-	int err;
+	int off, err;
 
 	/* don't touch empty string or string in main BTF */
 	if (str_off == 0 || str_off < d->btf->start_str_off)
@@ -3205,29 +3118,11 @@ static int strs_dedup_remap_str_off(__u32 *str_off_ptr, void *ctx)
 			return err;
 	}
 
-	len = strlen(s) + 1;
+	off = strset__add_str(d->strs_set, s);
+	if (off < 0)
+		return off;
 
-	new_off = d->strs_len;
-	p = libbpf_add_mem(&d->strs_data, &d->strs_cap, 1, new_off, BTF_MAX_STR_OFFSET, len);
-	if (!p)
-		return -ENOMEM;
-
-	memcpy(p, s, len);
-
-	/* Now attempt to add the string, but only if the string with the same
-	 * contents doesn't exist already (HASHMAP_ADD strategy). If such
-	 * string exists, we'll get its offset in old_off (that's old_key).
-	 */
-	err = hashmap__insert(d->strs_hash, (void *)new_off, (void *)new_off,
-			      HASHMAP_ADD, (const void **)&old_off, NULL);
-	if (err == -EEXIST) {
-		*str_off_ptr = d->btf->start_str_off + old_off;
-	} else if (err) {
-		return err;
-	} else {
-		*str_off_ptr = d->btf->start_str_off + new_off;
-		d->strs_len += len;
-	}
+	*str_off_ptr = d->btf->start_str_off + off;
 	return 0;
 }
 
@@ -3244,39 +3139,23 @@ static int strs_dedup_remap_str_off(__u32 *str_off_ptr, void *ctx)
  */
 static int btf_dedup_strings(struct btf_dedup *d)
 {
-	char *s;
 	int err;
 
 	if (d->btf->strs_deduped)
 		return 0;
 
-	/* temporarily switch to use btf_dedup's strs_data for strings for hash
-	 * functions; later we'll just transfer hashmap to struct btf as is,
-	 * along the strs_data
-	 */
-	d->btf->strs_data_ptr = &d->strs_data;
-
-	d->strs_hash = hashmap__new(strs_hash_fn, strs_hash_equal_fn, d->btf);
-	if (IS_ERR(d->strs_hash)) {
-		err = PTR_ERR(d->strs_hash);
-		d->strs_hash = NULL;
+	d->strs_set = strset__new(BTF_MAX_STR_OFFSET, NULL, 0);
+	if (IS_ERR(d->strs_set)) {
+		err = PTR_ERR(d->strs_set);
 		goto err_out;
 	}
 
 	if (!d->btf->base_btf) {
-		s = libbpf_add_mem(&d->strs_data, &d->strs_cap, 1, d->strs_len, BTF_MAX_STR_OFFSET, 1);
-		if (!s)
-			return -ENOMEM;
-		/* initial empty string */
-		s[0] = 0;
-		d->strs_len = 1;
-
 		/* insert empty string; we won't be looking it up during strings
 		 * dedup, but it's good to have it for generic BTF string lookups
 		 */
-		err = hashmap__insert(d->strs_hash, (void *)0, (void *)0,
-				      HASHMAP_ADD, NULL, NULL);
-		if (err)
+		err = strset__add_str(d->strs_set, "");
+		if (err < 0)
 			goto err_out;
 	}
 
@@ -3286,28 +3165,16 @@ static int btf_dedup_strings(struct btf_dedup *d)
 		goto err_out;
 
 	/* replace BTF string data and hash with deduped ones */
-	free(d->btf->strs_data);
-	hashmap__free(d->btf->strs_hash);
-	d->btf->strs_data = d->strs_data;
-	d->btf->strs_data_cap = d->strs_cap;
-	d->btf->hdr->str_len = d->strs_len;
-	d->btf->strs_hash = d->strs_hash;
-	/* now point strs_data_ptr back to btf->strs_data */
-	d->btf->strs_data_ptr = &d->btf->strs_data;
-
-	d->strs_data = d->strs_hash = NULL;
-	d->strs_len = d->strs_cap = 0;
+	strset__free(d->btf->strs_set);
+	d->btf->hdr->str_len = strset__data_size(d->strs_set);
+	d->btf->strs_set = d->strs_set;
+	d->strs_set = NULL;
 	d->btf->strs_deduped = true;
 	return 0;
 
 err_out:
-	free(d->strs_data);
-	hashmap__free(d->strs_hash);
-	d->strs_data = d->strs_hash = NULL;
-	d->strs_len = d->strs_cap = 0;
-
-	/* restore strings pointer for existing d->btf->strs_hash back */
-	d->btf->strs_data_ptr = &d->strs_data;
+	strset__free(d->strs_set);
+	d->strs_set = NULL;
 
 	return err;
 }
diff --git a/tools/lib/bpf/strset.c b/tools/lib/bpf/strset.c
new file mode 100644
index 000000000000..1fb8b49de1d6
--- /dev/null
+++ b/tools/lib/bpf/strset.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+/* Copyright (c) 2021 Facebook */
+#include <stdint.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <errno.h>
+#include <linux/err.h>
+#include "hashmap.h"
+#include "libbpf_internal.h"
+#include "strset.h"
+
+struct strset {
+	void *strs_data;
+	size_t strs_data_len;
+	size_t strs_data_cap;
+	size_t strs_data_max_len;
+
+	/* lookup index for each unique string in strings set */
+	struct hashmap *strs_hash;
+};
+
+static size_t strset_hash_fn(const void *key, void *ctx)
+{
+	const struct strset *s = ctx;
+	const char *str = s->strs_data + (long)key;
+
+	return str_hash(str);
+}
+
+static bool strset_equal_fn(const void *key1, const void *key2, void *ctx)
+{
+	const struct strset *s = ctx;
+	const char *str1 = s->strs_data + (long)key1;
+	const char *str2 = s->strs_data + (long)key2;
+
+	return strcmp(str1, str2) == 0;
+}
+
+struct strset *strset__new(size_t max_data_sz, const char *init_data, size_t init_data_sz)
+{
+	struct strset *set = calloc(1, sizeof(*set));
+	struct hashmap *hash;
+	int err = -ENOMEM;
+
+	if (!set)
+		return ERR_PTR(-ENOMEM);
+
+	hash = hashmap__new(strset_hash_fn, strset_equal_fn, set);
+	if (IS_ERR(hash))
+		goto err_out;
+
+	set->strs_data_max_len = max_data_sz;
+	set->strs_hash = hash;
+
+	if (init_data) {
+		long off;
+
+		set->strs_data = malloc(init_data_sz);
+		if (!set->strs_data)
+			goto err_out;
+
+		memcpy(set->strs_data, init_data, init_data_sz);
+		set->strs_data_len = init_data_sz;
+		set->strs_data_cap = init_data_sz;
+
+		for (off = 0; off < set->strs_data_len; off += strlen(set->strs_data + off) + 1) {
+			/* hashmap__add() returns EEXIST if string with the same
+			 * content already is in the hash map
+			 */
+			err = hashmap__add(hash, (void *)off, (void *)off);
+			if (err == -EEXIST)
+				continue; /* duplicate */
+			if (err)
+				goto err_out;
+		}
+	}
+
+	return set;
+err_out:
+	strset__free(set);
+	return ERR_PTR(err);
+}
+
+void strset__free(struct strset *set)
+{
+	if (IS_ERR_OR_NULL(set))
+		return;
+
+	hashmap__free(set->strs_hash);
+	free(set->strs_data);
+}
+
+size_t strset__data_size(const struct strset *set)
+{
+	return set->strs_data_len;
+}
+
+const char *strset__data(const struct strset *set)
+{
+	return set->strs_data;
+}
+
+static void *strset_add_str_mem(struct strset *set, size_t add_sz)
+{
+	return libbpf_add_mem(&set->strs_data, &set->strs_data_cap, 1,
+			      set->strs_data_len, set->strs_data_max_len, add_sz);
+}
+
+/* Find string offset that corresponds to a given string *s*.
+ * Returns:
+ *   - >0 offset into string data, if string is found;
+ *   - -ENOENT, if string is not in the string data;
+ *   - <0, on any other error.
+ */
+int strset__find_str(struct strset *set, const char *s)
+{
+	long old_off, new_off, len;
+	void *p;
+
+	/* see strset__add_str() for why we do this */
+	len = strlen(s) + 1;
+	p = strset_add_str_mem(set, len);
+	if (!p)
+		return -ENOMEM;
+
+	new_off = set->strs_data_len;
+	memcpy(p, s, len);
+
+	if (hashmap__find(set->strs_hash, (void *)new_off, (void **)&old_off))
+		return old_off;
+
+	return -ENOENT;
+}
+
+/* Add a string s to the string data. If the string already exists, return its
+ * offset within string data.
+ * Returns:
+ *   - > 0 offset into string data, on success;
+ *   - < 0, on error.
+ */
+int strset__add_str(struct strset *set, const char *s)
+{
+	long old_off, new_off, len;
+	void *p;
+	int err;
+
+	/* Hashmap keys are always offsets within set->strs_data, so to even
+	 * look up some string from the "outside", we need to first append it
+	 * at the end, so that it can be addressed with an offset. Luckily,
+	 * until set->strs_data_len is incremented, that string is just a piece
+	 * of garbage for the rest of the code, so no harm, no foul. On the
+	 * other hand, if the string is unique, it's already appended and
+	 * ready to be used, only a simple set->strs_data_len increment away.
+	 */
+	len = strlen(s) + 1;
+	p = strset_add_str_mem(set, len);
+	if (!p)
+		return -ENOMEM;
+
+	new_off = set->strs_data_len;
+	memcpy(p, s, len);
+
+	/* Now attempt to add the string, but only if the string with the same
+	 * contents doesn't exist already (HASHMAP_ADD strategy). If such
+	 * string exists, we'll get its offset in old_off (that's old_key).
+	 */
+	err = hashmap__insert(set->strs_hash, (void *)new_off, (void *)new_off,
+			      HASHMAP_ADD, (const void **)&old_off, NULL);
+	if (err == -EEXIST)
+		return old_off; /* duplicated string, return existing offset */
+	if (err)
+		return err;
+
+	set->strs_data_len += len; /* new unique string, adjust data length */
+	return new_off;
+}
diff --git a/tools/lib/bpf/strset.h b/tools/lib/bpf/strset.h
new file mode 100644
index 000000000000..b6ddf77a83c2
--- /dev/null
+++ b/tools/lib/bpf/strset.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+
+/* Copyright (c) 2021 Facebook */
+#ifndef __LIBBPF_STRSET_H
+#define __LIBBPF_STRSET_H
+
+#include <stdbool.h>
+#include <stddef.h>
+
+struct strset;
+
+struct strset *strset__new(size_t max_data_sz, const char *init_data, size_t init_data_sz);
+void strset__free(struct strset *set);
+
+const char *strset__data(const struct strset *set);
+size_t strset__data_size(const struct strset *set);
+
+int strset__find_str(struct strset *set, const char *s);
+int strset__add_str(struct strset *set, const char *s);
+
+#endif /* __LIBBPF_STRSET_H */
-- 
2.30.2

