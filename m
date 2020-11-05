Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B292A7677
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbgKEEeU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Nov 2020 23:34:20 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52604 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730705AbgKEEeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:34:18 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A54UFZF023098
        for <netdev@vger.kernel.org>; Wed, 4 Nov 2020 20:34:16 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34kbn7h97y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 20:34:16 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 20:34:15 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3D3CD2EC8E04; Wed,  4 Nov 2020 20:34:10 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 03/11] libbpf: unify and speed up BTF string deduplication
Date:   Wed, 4 Nov 2020 20:33:53 -0800
Message-ID: <20201105043402.2530976-4-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105043402.2530976-1-andrii@kernel.org>
References: <20201105043402.2530976-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_01:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 suspectscore=25
 clxscore=1015 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=633 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011050032
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

Revamp BTF dedup's string deduplication to match the approach of writable BTF
string management. This allows to transfer deduplicated strings index back to
BTF object after deduplication without expensive extra memory copying and hash
map re-construction. It also simplifies the code and speeds it up, because
hashmap-based string deduplication is faster than sort + unique approach.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c | 263 +++++++++++++++++---------------------------
 1 file changed, 98 insertions(+), 165 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 89fecfe5cb2b..fa1b147c63c6 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -90,6 +90,14 @@ struct btf {
 	struct hashmap *strs_hash;
 	/* whether strings are already deduplicated */
 	bool strs_deduped;
+	/* extra indirection layer to make strings hashmap work with stable
+	 * string offsets and ability to transparently choose between
+	 * btf->strs_data or btf_dedup->strs_data as a source of strings.
+	 * This is used for BTF strings dedup to transfer deduplicated strings
+	 * data back to struct btf without re-building strings index.
+	 */
+	void **strs_data_ptr;
+
 	/* BTF object FD, if loaded into kernel */
 	int fd;
 
@@ -1363,17 +1371,19 @@ int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 
 static size_t strs_hash_fn(const void *key, void *ctx)
 {
-	struct btf *btf = ctx;
-	const char *str = btf->strs_data + (long)key;
+	const struct btf *btf = ctx;
+	const char *strs = *btf->strs_data_ptr;
+	const char *str = strs + (long)key;
 
 	return str_hash(str);
 }
 
 static bool strs_hash_equal_fn(const void *key1, const void *key2, void *ctx)
 {
-	struct btf *btf = ctx;
-	const char *str1 = btf->strs_data + (long)key1;
-	const char *str2 = btf->strs_data + (long)key2;
+	const struct btf *btf = ctx;
+	const char *strs = *btf->strs_data_ptr;
+	const char *str1 = strs + (long)key1;
+	const char *str2 = strs + (long)key2;
 
 	return strcmp(str1, str2) == 0;
 }
@@ -1418,6 +1428,9 @@ static int btf_ensure_modifiable(struct btf *btf)
 	memcpy(types, btf->types_data, btf->hdr->type_len);
 	memcpy(strs, btf->strs_data, btf->hdr->str_len);
 
+	/* make hashmap below use btf->strs_data as a source of strings */
+	btf->strs_data_ptr = &btf->strs_data;
+
 	/* build lookup index for all strings */
 	hash = hashmap__new(strs_hash_fn, strs_hash_equal_fn, btf);
 	if (IS_ERR(hash)) {
@@ -2824,19 +2837,11 @@ struct btf_dedup {
 	size_t hypot_cap;
 	/* Various option modifying behavior of algorithm */
 	struct btf_dedup_opts opts;
-};
-
-struct btf_str_ptr {
-	const char *str;
-	__u32 new_off;
-	bool used;
-};
-
-struct btf_str_ptrs {
-	struct btf_str_ptr *ptrs;
-	const char *data;
-	__u32 cnt;
-	__u32 cap;
+	/* temporary strings deduplication state */
+	void *strs_data;
+	size_t strs_cap;
+	size_t strs_len;
+	struct hashmap* strs_hash;
 };
 
 static long hash_combine(long h, long value)
@@ -3063,64 +3068,41 @@ static int btf_for_each_str_off(struct btf_dedup *d, str_off_fn_t fn, void *ctx)
 	return 0;
 }
 
-static int str_sort_by_content(const void *a1, const void *a2)
-{
-	const struct btf_str_ptr *p1 = a1;
-	const struct btf_str_ptr *p2 = a2;
-
-	return strcmp(p1->str, p2->str);
-}
-
-static int str_sort_by_offset(const void *a1, const void *a2)
-{
-	const struct btf_str_ptr *p1 = a1;
-	const struct btf_str_ptr *p2 = a2;
-
-	if (p1->str != p2->str)
-		return p1->str < p2->str ? -1 : 1;
-	return 0;
-}
-
-static int btf_dedup_str_ptr_cmp(const void *str_ptr, const void *pelem)
-{
-	const struct btf_str_ptr *p = pelem;
-
-	if (str_ptr != p->str)
-		return (const char *)str_ptr < p->str ? -1 : 1;
-	return 0;
-}
-
-static int btf_str_mark_as_used(__u32 *str_off_ptr, void *ctx)
+static int strs_dedup_remap_str_off(__u32 *str_off_ptr, void *ctx)
 {
-	struct btf_str_ptrs *strs;
-	struct btf_str_ptr *s;
+	struct btf_dedup *d = ctx;
+	long old_off, new_off, len;
+	const char *s;
+	void *p;
+	int err;
 
 	if (*str_off_ptr == 0)
 		return 0;
 
-	strs = ctx;
-	s = bsearch(strs->data + *str_off_ptr, strs->ptrs, strs->cnt,
-		    sizeof(struct btf_str_ptr), btf_dedup_str_ptr_cmp);
-	if (!s)
-		return -EINVAL;
-	s->used = true;
-	return 0;
-}
+	s = btf__str_by_offset(d->btf, *str_off_ptr);
+	len = strlen(s) + 1;
 
-static int btf_str_remap_offset(__u32 *str_off_ptr, void *ctx)
-{
-	struct btf_str_ptrs *strs;
-	struct btf_str_ptr *s;
+	new_off = d->strs_len;
+	p = btf_add_mem(&d->strs_data, &d->strs_cap, 1, new_off, BTF_MAX_STR_OFFSET, len);
+	if (!p)
+		return -ENOMEM;
 
-	if (*str_off_ptr == 0)
-		return 0;
+	memcpy(p, s, len);
 
-	strs = ctx;
-	s = bsearch(strs->data + *str_off_ptr, strs->ptrs, strs->cnt,
-		    sizeof(struct btf_str_ptr), btf_dedup_str_ptr_cmp);
-	if (!s)
-		return -EINVAL;
-	*str_off_ptr = s->new_off;
+	/* Now attempt to add the string, but only if the string with the same
+	 * contents doesn't exist already (HASHMAP_ADD strategy). If such
+	 * string exists, we'll get its offset in old_off (that's old_key).
+	 */
+	err = hashmap__insert(d->strs_hash, (void *)new_off, (void *)new_off,
+			      HASHMAP_ADD, (const void **)&old_off, NULL);
+	if (err == -EEXIST) {
+		*str_off_ptr = old_off;
+	} else if (err) {
+		return err;
+	} else {
+		*str_off_ptr = new_off;
+		d->strs_len += len;
+	}
 	return 0;
 }
 
@@ -3137,118 +3119,69 @@ static int btf_str_remap_offset(__u32 *str_off_ptr, void *ctx)
  */
 static int btf_dedup_strings(struct btf_dedup *d)
 {
-	char *start = d->btf->strs_data;
-	char *end = start + d->btf->hdr->str_len;
-	char *p = start, *tmp_strs = NULL;
-	struct btf_str_ptrs strs = {
-		.cnt = 0,
-		.cap = 0,
-		.ptrs = NULL,
-		.data = start,
-	};
-	int i, j, err = 0, grp_idx;
-	bool grp_used;
+	char *s;
+	int err;
 
 	if (d->btf->strs_deduped)
 		return 0;
 
-	/* build index of all strings */
-	while (p < end) {
-		if (strs.cnt + 1 > strs.cap) {
-			struct btf_str_ptr *new_ptrs;
-
-			strs.cap += max(strs.cnt / 2, 16U);
-			new_ptrs = libbpf_reallocarray(strs.ptrs, strs.cap, sizeof(strs.ptrs[0]));
-			if (!new_ptrs) {
-				err = -ENOMEM;
-				goto done;
-			}
-			strs.ptrs = new_ptrs;
-		}
-
-		strs.ptrs[strs.cnt].str = p;
-		strs.ptrs[strs.cnt].used = false;
-
-		p += strlen(p) + 1;
-		strs.cnt++;
-	}
-
-	/* temporary storage for deduplicated strings */
-	tmp_strs = malloc(d->btf->hdr->str_len);
-	if (!tmp_strs) {
-		err = -ENOMEM;
-		goto done;
-	}
-
-	/* mark all used strings */
-	strs.ptrs[0].used = true;
-	err = btf_for_each_str_off(d, btf_str_mark_as_used, &strs);
-	if (err)
-		goto done;
-
-	/* sort strings by context, so that we can identify duplicates */
-	qsort(strs.ptrs, strs.cnt, sizeof(strs.ptrs[0]), str_sort_by_content);
+	s = btf_add_mem(&d->strs_data, &d->strs_cap, 1, d->strs_len, BTF_MAX_STR_OFFSET, 1);
+	if (!s)
+		return -ENOMEM;
+	/* initial empty string */
+	s[0] = 0;
+	d->strs_len = 1;
 
-	/*
-	 * iterate groups of equal strings and if any instance in a group was
-	 * referenced, emit single instance and remember new offset
+	/* temporarily switch to use btf_dedup's strs_data for strings for hash
+	 * functions; later we'll just transfer hashmap to struct btf as is,
+	 * along the strs_data
 	 */
-	p = tmp_strs;
-	grp_idx = 0;
-	grp_used = strs.ptrs[0].used;
-	/* iterate past end to avoid code duplication after loop */
-	for (i = 1; i <= strs.cnt; i++) {
-		/*
-		 * when i == strs.cnt, we want to skip string comparison and go
-		 * straight to handling last group of strings (otherwise we'd
-		 * need to handle last group after the loop w/ duplicated code)
-		 */
-		if (i < strs.cnt &&
-		    !strcmp(strs.ptrs[i].str, strs.ptrs[grp_idx].str)) {
-			grp_used = grp_used || strs.ptrs[i].used;
-			continue;
-		}
+	d->btf->strs_data_ptr = &d->strs_data;
 
-		/*
-		 * this check would have been required after the loop to handle
-		 * last group of strings, but due to <= condition in a loop
-		 * we avoid that duplication
-		 */
-		if (grp_used) {
-			int new_off = p - tmp_strs;
-			__u32 len = strlen(strs.ptrs[grp_idx].str);
-
-			memmove(p, strs.ptrs[grp_idx].str, len + 1);
-			for (j = grp_idx; j < i; j++)
-				strs.ptrs[j].new_off = new_off;
-			p += len + 1;
-		}
-
-		if (i < strs.cnt) {
-			grp_idx = i;
-			grp_used = strs.ptrs[i].used;
-		}
+	d->strs_hash = hashmap__new(strs_hash_fn, strs_hash_equal_fn, d->btf);
+	if (IS_ERR(d->strs_hash)) {
+		err = PTR_ERR(d->strs_hash);
+		d->strs_hash = NULL;
+		goto err_out;
 	}
 
-	/* replace original strings with deduped ones */
-	d->btf->hdr->str_len = p - tmp_strs;
-	memmove(start, tmp_strs, d->btf->hdr->str_len);
-	end = start + d->btf->hdr->str_len;
-
-	/* restore original order for further binary search lookups */
-	qsort(strs.ptrs, strs.cnt, sizeof(strs.ptrs[0]), str_sort_by_offset);
+	/* insert empty string; we won't be looking it up during strings
+	 * dedup, but it's good to have it for generic BTF string lookups
+	 */
+	err = hashmap__insert(d->strs_hash, (void *)0, (void *)0,
+			      HASHMAP_ADD, NULL, NULL);
+	if (err)
+		goto err_out;
 
 	/* remap string offsets */
-	err = btf_for_each_str_off(d, btf_str_remap_offset, &strs);
+	err = btf_for_each_str_off(d, strs_dedup_remap_str_off, d);
 	if (err)
-		goto done;
+		goto err_out;
 
-	d->btf->hdr->str_len = end - start;
+	/* replace BTF string data and hash with deduped ones */
+	free(d->btf->strs_data);
+	hashmap__free(d->btf->strs_hash);
+	d->btf->strs_data = d->strs_data;
+	d->btf->strs_data_cap = d->strs_cap;
+	d->btf->hdr->str_len = d->strs_len;
+	d->btf->strs_hash = d->strs_hash;
+	/* now point strs_data_ptr back to btf->strs_data */
+	d->btf->strs_data_ptr = &d->btf->strs_data;
+
+	d->strs_data = d->strs_hash = NULL;
+	d->strs_len = d->strs_cap = 0;
 	d->btf->strs_deduped = true;
+	return 0;
+
+err_out:
+	free(d->strs_data);
+	hashmap__free(d->strs_hash);
+	d->strs_data = d->strs_hash = NULL;
+	d->strs_len = d->strs_cap = 0;
+
+	/* restore strings pointer for existing d->btf->strs_hash back */
+	d->btf->strs_data_ptr = &d->strs_data;
 
-done:
-	free(tmp_strs);
-	free(strs.ptrs);
 	return err;
 }
 
-- 
2.24.1

