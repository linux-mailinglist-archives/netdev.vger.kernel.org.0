Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E32028BBB
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388276AbfEWUms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:42:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51062 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388196AbfEWUmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:42:46 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4NKdw6I012002
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=nwRY6bB2KmFJNhIVVdEQ+lk3y+vmqoe0Io5USgS79nc=;
 b=Y7r1Jl8A6i48D6HKccrYZYoQ6mCZQB8+otaFRuAh7AsIH0Va0eebYrYLBviquPsLZpJD
 MBtMdxWGwwlgd12y1iYzL3Jf9Yjeh4gQcp3LQ9hVjL/5EI5+4Igbp5JEMBLQFxeWRRd0
 VFllrDpGJyuOUhB/8Uc3rhwVkbUFfd9DUEk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2snwyh94wg-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:44 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 May 2019 13:42:41 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id EC9BA861799; Thu, 23 May 2019 13:42:39 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 07/12] libbpf: switch btf_dedup() to hashmap for dedup table
Date:   Thu, 23 May 2019 13:42:17 -0700
Message-ID: <20190523204222.3998365-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523204222.3998365-1-andriin@fb.com>
References: <20190523204222.3998365-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize libbpf's hashmap as a multimap fof dedup_table implementation.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c | 201 +++++++++++++++++++-------------------------
 1 file changed, 85 insertions(+), 116 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 6139550810a1..b2478e98c367 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -14,6 +14,7 @@
 #include "bpf.h"
 #include "libbpf.h"
 #include "libbpf_internal.h"
+#include "hashmap.h"
 
 #define max(a, b) ((a) > (b) ? (a) : (b))
 #define min(a, b) ((a) < (b) ? (a) : (b))
@@ -1293,16 +1294,9 @@ int btf__dedup(struct btf *btf, struct btf_ext *btf_ext,
 	return err;
 }
 
-#define BTF_DEDUP_TABLE_DEFAULT_SIZE (1 << 14)
-#define BTF_DEDUP_TABLE_MAX_SIZE_LOG 31
 #define BTF_UNPROCESSED_ID ((__u32)-1)
 #define BTF_IN_PROGRESS_ID ((__u32)-2)
 
-struct btf_dedup_node {
-	struct btf_dedup_node *next;
-	__u32 type_id;
-};
-
 struct btf_dedup {
 	/* .BTF section to be deduped in-place */
 	struct btf *btf;
@@ -1318,7 +1312,7 @@ struct btf_dedup {
 	 * candidates, which is fine because we rely on subsequent
 	 * btf_xxx_equal() checks to authoritatively verify type equality.
 	 */
-	struct btf_dedup_node **dedup_table;
+	struct hashmap *dedup_table;
 	/* Canonical types map */
 	__u32 *map;
 	/* Hypothetical mapping, used during type graph equivalence checks */
@@ -1343,30 +1337,18 @@ struct btf_str_ptrs {
 	__u32 cap;
 };
 
-static inline __u32 hash_combine(__u32 h, __u32 value)
+static long hash_combine(long h, long value)
 {
-/* 2^31 + 2^29 - 2^25 + 2^22 - 2^19 - 2^16 + 1 */
-#define GOLDEN_RATIO_PRIME 0x9e370001UL
-	return h * 37 + value * GOLDEN_RATIO_PRIME;
-#undef GOLDEN_RATIO_PRIME
+	return h * 31 + value;
 }
 
-#define for_each_dedup_cand(d, hash, node) \
-	for (node = d->dedup_table[hash & (d->opts.dedup_table_size - 1)]; \
-	     node;							   \
-	     node = node->next)
+#define for_each_dedup_cand(d, node, hash) \
+	hashmap__for_each_key_entry(d->dedup_table, node, (void *)hash)
 
-static int btf_dedup_table_add(struct btf_dedup *d, __u32 hash, __u32 type_id)
+static int btf_dedup_table_add(struct btf_dedup *d, long hash, __u32 type_id)
 {
-	struct btf_dedup_node *node = malloc(sizeof(struct btf_dedup_node));
-	int bucket = hash & (d->opts.dedup_table_size - 1);
-
-	if (!node)
-		return -ENOMEM;
-	node->type_id = type_id;
-	node->next = d->dedup_table[bucket];
-	d->dedup_table[bucket] = node;
-	return 0;
+	return hashmap__append(d->dedup_table,
+			       (void *)hash, (void *)(long)type_id);
 }
 
 static int btf_dedup_hypot_map_add(struct btf_dedup *d,
@@ -1395,36 +1377,10 @@ static void btf_dedup_clear_hypot_map(struct btf_dedup *d)
 	d->hypot_cnt = 0;
 }
 
-static void btf_dedup_table_free(struct btf_dedup *d)
-{
-	struct btf_dedup_node *head, *tmp;
-	int i;
-
-	if (!d->dedup_table)
-		return;
-
-	for (i = 0; i < d->opts.dedup_table_size; i++) {
-		while (d->dedup_table[i]) {
-			tmp = d->dedup_table[i];
-			d->dedup_table[i] = tmp->next;
-			free(tmp);
-		}
-
-		head = d->dedup_table[i];
-		while (head) {
-			tmp = head;
-			head = head->next;
-			free(tmp);
-		}
-	}
-
-	free(d->dedup_table);
-	d->dedup_table = NULL;
-}
-
 static void btf_dedup_free(struct btf_dedup *d)
 {
-	btf_dedup_table_free(d);
+	hashmap__free(d->dedup_table);
+	d->dedup_table = NULL;
 
 	free(d->map);
 	d->map = NULL;
@@ -1438,40 +1394,43 @@ static void btf_dedup_free(struct btf_dedup *d)
 	free(d);
 }
 
-/* Find closest power of two >= to size, capped at 2^max_size_log */
-static __u32 roundup_pow2_max(__u32 size, int max_size_log)
+static size_t btf_dedup_identity_hash_fn(const void *key, void *ctx)
 {
-	int i;
+	return (size_t)key;
+}
 
-	for (i = 0; i < max_size_log  && (1U << i) < size;  i++)
-		;
-	return 1U << i;
+static size_t btf_dedup_collision_hash_fn(const void *key, void *ctx)
+{
+	return 0;
 }
 
+static bool btf_dedup_equal_fn(const void *k1, const void *k2, void *ctx)
+{
+	return k1 == k2;
+}
 
 static struct btf_dedup *btf_dedup_new(struct btf *btf, struct btf_ext *btf_ext,
 				       const struct btf_dedup_opts *opts)
 {
 	struct btf_dedup *d = calloc(1, sizeof(struct btf_dedup));
+	hashmap_hash_fn hash_fn = btf_dedup_identity_hash_fn;
 	int i, err = 0;
-	__u32 sz;
 
 	if (!d)
 		return ERR_PTR(-ENOMEM);
 
 	d->opts.dont_resolve_fwds = opts && opts->dont_resolve_fwds;
-	sz = opts && opts->dedup_table_size ? opts->dedup_table_size
-					    : BTF_DEDUP_TABLE_DEFAULT_SIZE;
-	sz = roundup_pow2_max(sz, BTF_DEDUP_TABLE_MAX_SIZE_LOG);
-	d->opts.dedup_table_size = sz;
+	/* dedup_table_size is now used only to force collisions in tests */
+	if (opts && opts->dedup_table_size == 1)
+		hash_fn = btf_dedup_collision_hash_fn;
 
 	d->btf = btf;
 	d->btf_ext = btf_ext;
 
-	d->dedup_table = calloc(d->opts.dedup_table_size,
-				sizeof(struct btf_dedup_node *));
-	if (!d->dedup_table) {
-		err = -ENOMEM;
+	d->dedup_table = hashmap__new(hash_fn, btf_dedup_equal_fn, NULL);
+	if (IS_ERR(d->dedup_table)) {
+		err = PTR_ERR(d->dedup_table);
+		d->dedup_table = NULL;
 		goto done;
 	}
 
@@ -1790,9 +1749,9 @@ static int btf_dedup_strings(struct btf_dedup *d)
 	return err;
 }
 
-static __u32 btf_hash_common(struct btf_type *t)
+static long btf_hash_common(struct btf_type *t)
 {
-	__u32 h;
+	long h;
 
 	h = hash_combine(0, t->name_off);
 	h = hash_combine(h, t->info);
@@ -1808,10 +1767,10 @@ static bool btf_equal_common(struct btf_type *t1, struct btf_type *t2)
 }
 
 /* Calculate type signature hash of INT. */
-static __u32 btf_hash_int(struct btf_type *t)
+static long btf_hash_int(struct btf_type *t)
 {
 	__u32 info = *(__u32 *)(t + 1);
-	__u32 h;
+	long h;
 
 	h = btf_hash_common(t);
 	h = hash_combine(h, info);
@@ -1831,9 +1790,9 @@ static bool btf_equal_int(struct btf_type *t1, struct btf_type *t2)
 }
 
 /* Calculate type signature hash of ENUM. */
-static __u32 btf_hash_enum(struct btf_type *t)
+static long btf_hash_enum(struct btf_type *t)
 {
-	__u32 h;
+	long h;
 
 	/* don't hash vlen and enum members to support enum fwd resolving */
 	h = hash_combine(0, t->name_off);
@@ -1885,11 +1844,11 @@ static bool btf_compat_enum(struct btf_type *t1, struct btf_type *t2)
  * as referenced type IDs equivalence is established separately during type
  * graph equivalence check algorithm.
  */
-static __u32 btf_hash_struct(struct btf_type *t)
+static long btf_hash_struct(struct btf_type *t)
 {
 	struct btf_member *member = (struct btf_member *)(t + 1);
 	__u32 vlen = BTF_INFO_VLEN(t->info);
-	__u32 h = btf_hash_common(t);
+	long h = btf_hash_common(t);
 	int i;
 
 	for (i = 0; i < vlen; i++) {
@@ -1932,10 +1891,10 @@ static bool btf_shallow_equal_struct(struct btf_type *t1, struct btf_type *t2)
  * under assumption that they were already resolved to canonical type IDs and
  * are not going to change.
  */
-static __u32 btf_hash_array(struct btf_type *t)
+static long btf_hash_array(struct btf_type *t)
 {
 	struct btf_array *info = (struct btf_array *)(t + 1);
-	__u32 h = btf_hash_common(t);
+	long h = btf_hash_common(t);
 
 	h = hash_combine(h, info->type);
 	h = hash_combine(h, info->index_type);
@@ -1986,11 +1945,11 @@ static bool btf_compat_array(struct btf_type *t1, struct btf_type *t2)
  * under assumption that they were already resolved to canonical type IDs and
  * are not going to change.
  */
-static inline __u32 btf_hash_fnproto(struct btf_type *t)
+static long btf_hash_fnproto(struct btf_type *t)
 {
 	struct btf_param *member = (struct btf_param *)(t + 1);
 	__u16 vlen = BTF_INFO_VLEN(t->info);
-	__u32 h = btf_hash_common(t);
+	long h = btf_hash_common(t);
 	int i;
 
 	for (i = 0; i < vlen; i++) {
@@ -2008,7 +1967,7 @@ static inline __u32 btf_hash_fnproto(struct btf_type *t)
  * This function is called during reference types deduplication to compare
  * FUNC_PROTO to potential canonical representative.
  */
-static inline bool btf_equal_fnproto(struct btf_type *t1, struct btf_type *t2)
+static bool btf_equal_fnproto(struct btf_type *t1, struct btf_type *t2)
 {
 	struct btf_param *m1, *m2;
 	__u16 vlen;
@@ -2034,7 +1993,7 @@ static inline bool btf_equal_fnproto(struct btf_type *t1, struct btf_type *t2)
  * IDs. This check is performed during type graph equivalence check and
  * referenced types equivalence is checked separately.
  */
-static inline bool btf_compat_fnproto(struct btf_type *t1, struct btf_type *t2)
+static bool btf_compat_fnproto(struct btf_type *t1, struct btf_type *t2)
 {
 	struct btf_param *m1, *m2;
 	__u16 vlen;
@@ -2065,11 +2024,12 @@ static inline bool btf_compat_fnproto(struct btf_type *t1, struct btf_type *t2)
 static int btf_dedup_prim_type(struct btf_dedup *d, __u32 type_id)
 {
 	struct btf_type *t = d->btf->types[type_id];
+	struct hashmap_entry *hash_entry;
 	struct btf_type *cand;
-	struct btf_dedup_node *cand_node;
 	/* if we don't find equivalent type, then we are canonical */
 	__u32 new_id = type_id;
-	__u32 h;
+	__u32 cand_id;
+	long h;
 
 	switch (BTF_INFO_KIND(t->info)) {
 	case BTF_KIND_CONST:
@@ -2088,10 +2048,11 @@ static int btf_dedup_prim_type(struct btf_dedup *d, __u32 type_id)
 
 	case BTF_KIND_INT:
 		h = btf_hash_int(t);
-		for_each_dedup_cand(d, h, cand_node) {
-			cand = d->btf->types[cand_node->type_id];
+		for_each_dedup_cand(d, hash_entry, h) {
+			cand_id = (__u32)(long)hash_entry->value;
+			cand = d->btf->types[cand_id];
 			if (btf_equal_int(t, cand)) {
-				new_id = cand_node->type_id;
+				new_id = cand_id;
 				break;
 			}
 		}
@@ -2099,10 +2060,11 @@ static int btf_dedup_prim_type(struct btf_dedup *d, __u32 type_id)
 
 	case BTF_KIND_ENUM:
 		h = btf_hash_enum(t);
-		for_each_dedup_cand(d, h, cand_node) {
-			cand = d->btf->types[cand_node->type_id];
+		for_each_dedup_cand(d, hash_entry, h) {
+			cand_id = (__u32)(long)hash_entry->value;
+			cand = d->btf->types[cand_id];
 			if (btf_equal_enum(t, cand)) {
-				new_id = cand_node->type_id;
+				new_id = cand_id;
 				break;
 			}
 			if (d->opts.dont_resolve_fwds)
@@ -2110,21 +2072,22 @@ static int btf_dedup_prim_type(struct btf_dedup *d, __u32 type_id)
 			if (btf_compat_enum(t, cand)) {
 				if (btf_is_enum_fwd(t)) {
 					/* resolve fwd to full enum */
-					new_id = cand_node->type_id;
+					new_id = cand_id;
 					break;
 				}
 				/* resolve canonical enum fwd to full enum */
-				d->map[cand_node->type_id] = type_id;
+				d->map[cand_id] = type_id;
 			}
 		}
 		break;
 
 	case BTF_KIND_FWD:
 		h = btf_hash_common(t);
-		for_each_dedup_cand(d, h, cand_node) {
-			cand = d->btf->types[cand_node->type_id];
+		for_each_dedup_cand(d, hash_entry, h) {
+			cand_id = (__u32)(long)hash_entry->value;
+			cand = d->btf->types[cand_id];
 			if (btf_equal_common(t, cand)) {
-				new_id = cand_node->type_id;
+				new_id = cand_id;
 				break;
 			}
 		}
@@ -2525,12 +2488,12 @@ static void btf_dedup_merge_hypot_map(struct btf_dedup *d)
  */
 static int btf_dedup_struct_type(struct btf_dedup *d, __u32 type_id)
 {
-	struct btf_dedup_node *cand_node;
 	struct btf_type *cand_type, *t;
+	struct hashmap_entry *hash_entry;
 	/* if we don't find equivalent type, then we are canonical */
 	__u32 new_id = type_id;
 	__u16 kind;
-	__u32 h;
+	long h;
 
 	/* already deduped or is in process of deduping (loop detected) */
 	if (d->map[type_id] <= BTF_MAX_NR_TYPES)
@@ -2543,7 +2506,8 @@ static int btf_dedup_struct_type(struct btf_dedup *d, __u32 type_id)
 		return 0;
 
 	h = btf_hash_struct(t);
-	for_each_dedup_cand(d, h, cand_node) {
+	for_each_dedup_cand(d, hash_entry, h) {
+		__u32 cand_id = (__u32)(long)hash_entry->value;
 		int eq;
 
 		/*
@@ -2556,17 +2520,17 @@ static int btf_dedup_struct_type(struct btf_dedup *d, __u32 type_id)
 		 * creating a loop (FWD -> STRUCT and STRUCT -> FWD), because
 		 * FWD and compatible STRUCT/UNION are considered equivalent.
 		 */
-		cand_type = d->btf->types[cand_node->type_id];
+		cand_type = d->btf->types[cand_id];
 		if (!btf_shallow_equal_struct(t, cand_type))
 			continue;
 
 		btf_dedup_clear_hypot_map(d);
-		eq = btf_dedup_is_equiv(d, type_id, cand_node->type_id);
+		eq = btf_dedup_is_equiv(d, type_id, cand_id);
 		if (eq < 0)
 			return eq;
 		if (!eq)
 			continue;
-		new_id = cand_node->type_id;
+		new_id = cand_id;
 		btf_dedup_merge_hypot_map(d);
 		break;
 	}
@@ -2616,12 +2580,12 @@ static int btf_dedup_struct_types(struct btf_dedup *d)
  */
 static int btf_dedup_ref_type(struct btf_dedup *d, __u32 type_id)
 {
-	struct btf_dedup_node *cand_node;
+	struct hashmap_entry *hash_entry;
+	__u32 new_id = type_id, cand_id;
 	struct btf_type *t, *cand;
 	/* if we don't find equivalent type, then we are representative type */
-	__u32 new_id = type_id;
 	int ref_type_id;
-	__u32 h;
+	long h;
 
 	if (d->map[type_id] == BTF_IN_PROGRESS_ID)
 		return -ELOOP;
@@ -2644,10 +2608,11 @@ static int btf_dedup_ref_type(struct btf_dedup *d, __u32 type_id)
 		t->type = ref_type_id;
 
 		h = btf_hash_common(t);
-		for_each_dedup_cand(d, h, cand_node) {
-			cand = d->btf->types[cand_node->type_id];
+		for_each_dedup_cand(d, hash_entry, h) {
+			cand_id = (__u32)(long)hash_entry->value;
+			cand = d->btf->types[cand_id];
 			if (btf_equal_common(t, cand)) {
-				new_id = cand_node->type_id;
+				new_id = cand_id;
 				break;
 			}
 		}
@@ -2667,10 +2632,11 @@ static int btf_dedup_ref_type(struct btf_dedup *d, __u32 type_id)
 		info->index_type = ref_type_id;
 
 		h = btf_hash_array(t);
-		for_each_dedup_cand(d, h, cand_node) {
-			cand = d->btf->types[cand_node->type_id];
+		for_each_dedup_cand(d, hash_entry, h) {
+			cand_id = (__u32)(long)hash_entry->value;
+			cand = d->btf->types[cand_id];
 			if (btf_equal_array(t, cand)) {
-				new_id = cand_node->type_id;
+				new_id = cand_id;
 				break;
 			}
 		}
@@ -2698,10 +2664,11 @@ static int btf_dedup_ref_type(struct btf_dedup *d, __u32 type_id)
 		}
 
 		h = btf_hash_fnproto(t);
-		for_each_dedup_cand(d, h, cand_node) {
-			cand = d->btf->types[cand_node->type_id];
+		for_each_dedup_cand(d, hash_entry, h) {
+			cand_id = (__u32)(long)hash_entry->value;
+			cand = d->btf->types[cand_id];
 			if (btf_equal_fnproto(t, cand)) {
-				new_id = cand_node->type_id;
+				new_id = cand_id;
 				break;
 			}
 		}
@@ -2728,7 +2695,9 @@ static int btf_dedup_ref_types(struct btf_dedup *d)
 		if (err < 0)
 			return err;
 	}
-	btf_dedup_table_free(d);
+	/* we won't need d->dedup_table anymore */
+	hashmap__free(d->dedup_table);
+	d->dedup_table = NULL;
 	return 0;
 }
 
-- 
2.17.1

