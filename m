Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE524B4DEE
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350773AbiBNLS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:18:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350685AbiBNLST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:18:19 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFBA66215;
        Mon, 14 Feb 2022 02:51:31 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Jy1G845N8zccyN;
        Mon, 14 Feb 2022 18:50:24 +0800 (CST)
Received: from huawei.com (10.175.112.60) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 14 Feb
 2022 18:51:28 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next v2 1/3] bpf: add support for string in hash table key
Date:   Mon, 14 Feb 2022 19:13:35 +0800
Message-ID: <20220214111337.3539-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20220214111337.3539-1-houtao1@huawei.com>
References: <20220214111337.3539-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.60]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to use string as hash-table key, key_size must be the storage
size of longest string. If there are large differencies in string
length, the hash distribution will be sub-optimal due to the unused
zero bytes in shorter strings and the lookup will be inefficient due to
unnecessary memcmp().

Also it is possible the unused part of string key returned from bpf helper
(e.g. bpf_d_path) is not mem-zeroed and if using it directly as lookup key,
the lookup will fail with -ENOENT.

Three changes are made to support string in key. Enforce the layout of hash
key struct through btf to place strings togerther and to compare the string
length and string hash firstly before the comparison of string content. The
layout of hash key struct needs to be as follow:

	>the start of hash key
	...
	[struct bpf_str_key_desc m;]
	...
	[struct bpf_str_key_desc n;]
	...
	struct bpf_str_key_stor z;
	unsigned char raw[N];
	>the end of hash key

String or concatenation of strings is placed in the trailing char array.
bpf_str_key_stor saves the length and hash of string. And bpf_str_key_desc
describes the offset and length of string if there are multiple strings in
hash key.

The second change is that change the hash algorithm for string content from
jhash() to full_name_hash() to reduce hash collision for string and the
string hash in bpf_str_key_stor will be used in hash of the whole key when
the string is not the only key in hash key. The last change is only compare
the used part in the trailing char array for comparison of string content.

A new flag BPF_F_STR_IN_KEY is added to enable above three changes and to
support strings in hash table key.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/btf.h            |   3 +
 include/uapi/linux/bpf.h       |  19 ++++
 kernel/bpf/btf.c               |  39 ++++++++
 kernel/bpf/hashtab.c           | 162 ++++++++++++++++++++++++++++-----
 tools/include/uapi/linux/bpf.h |  19 ++++
 5 files changed, 217 insertions(+), 25 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 36bc09b8e890..270f5e3329bd 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -123,6 +123,9 @@ bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 			   u32 expected_offset, u32 expected_size);
 int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t);
 int btf_find_timer(const struct btf *btf, const struct btf_type *t);
+int btf_find_str_key_stor(const struct btf *btf, const struct btf_type *t);
+int btf_find_array_at(const struct btf *btf, const struct btf_type *t,
+		      unsigned int at, unsigned int nelems);
 bool btf_type_is_void(const struct btf_type *t);
 s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kind);
 const struct btf_type *btf_type_skip_modifiers(const struct btf *btf,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index afe3d0d7f5f2..c764a82d79cd 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1218,6 +1218,9 @@ enum {
 
 /* Create a map that is suitable to be an inner map with dynamic max entries */
 	BPF_F_INNER_MAP		= (1U << 12),
+
+/* Flag for hash_map, there is string in hash key */
+	BPF_F_STR_IN_KEY	= (1U << 13),
 };
 
 /* Flags for BPF_PROG_QUERY. */
@@ -6565,4 +6568,20 @@ struct bpf_core_relo {
 	enum bpf_core_relo_kind kind;
 };
 
+struct bpf_str_key_desc {
+	/* the relative offset of string */
+	__u32 offset;
+	/* the length of string (include the trailing zero) */
+	__u32 len;
+};
+
+struct bpf_str_key_stor {
+	/* the total length of string */
+	__u32 len;
+	/* the hash of string */
+	__u32 hash;
+	/* the content of string */
+	unsigned char raw[0];
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 11740b300de9..c57eb6c12ef2 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3187,6 +3187,16 @@ static int btf_find_field(const struct btf *btf, const struct btf_type *t,
 	return -EINVAL;
 }
 
+int btf_find_str_key_stor(const struct btf *btf, const struct btf_type *t)
+{
+	if (!__btf_type_is_struct(t))
+		return -EINVAL;
+
+	return btf_find_struct_field(btf, t, "bpf_str_key_stor",
+				     sizeof(struct bpf_str_key_stor),
+				     __alignof__(struct bpf_str_key_stor));
+}
+
 /* find 'struct bpf_spin_lock' in map value.
  * return >= 0 offset if found
  * and < 0 in case of error
@@ -7281,3 +7291,32 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *relo,
 	}
 	return err;
 }
+
+int btf_find_array_at(const struct btf *btf, const struct btf_type *t,
+		      unsigned int at, unsigned int nelems)
+{
+	const struct btf_member *member;
+	u32 i, off;
+
+	for_each_member(i, t, member) {
+		const struct btf_type *member_type = btf_type_by_id(btf, member->type);
+		const struct btf_array *array;
+
+		if (!btf_type_is_array(member_type))
+			continue;
+
+		off = __btf_member_bit_offset(t, member);
+		if (off % 8)
+			return -EINVAL;
+		off /= 8;
+		if (off != at)
+			continue;
+
+		array = btf_type_array(member_type);
+		if (array->nelems == nelems)
+			return off;
+		break;
+	}
+
+	return -ENOENT;
+}
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d29af9988f37..ab2f95212a9c 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -16,7 +16,7 @@
 
 #define HTAB_CREATE_FLAG_MASK						\
 	(BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |	\
-	 BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED)
+	 BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED | BPF_F_STR_IN_KEY)
 
 #define BATCH_OPS(_name)			\
 	.map_lookup_batch =			\
@@ -93,6 +93,8 @@ struct bpf_htab {
 	struct bpf_map map;
 	struct bucket *buckets;
 	void *elems;
+	u32 hash_key_size;
+	int str_stor_off;
 	union {
 		struct pcpu_freelist freelist;
 		struct bpf_lru lru;
@@ -137,6 +139,61 @@ static inline bool htab_use_raw_lock(const struct bpf_htab *htab)
 	return (!IS_ENABLED(CONFIG_PREEMPT_RT) || htab_is_prealloc(htab));
 }
 
+static inline u32 htab_map_hash(const void *key, u32 key_len, u32 hashrnd)
+{
+	return jhash(key, key_len, hashrnd);
+}
+
+static inline bool htab_str_in_key(const struct bpf_htab *htab)
+{
+	return htab->map.map_flags & BPF_F_STR_IN_KEY;
+}
+
+static inline bool htab_valid_str_in_key(const struct bpf_htab *htab, void *key)
+{
+	struct bpf_str_key_stor *str;
+
+	if (!htab_str_in_key(htab))
+		return true;
+
+	str = key + htab->str_stor_off;
+	return str->len > 0 &&
+	       str->len <= htab->map.key_size - htab->hash_key_size;
+}
+
+static inline bool htab_compared_key_size(const struct bpf_htab *htab, void *key)
+{
+	struct bpf_str_key_stor *str;
+
+	if (!htab_str_in_key(htab))
+		return htab->map.key_size;
+
+	str = key + htab->str_stor_off;
+	return htab->hash_key_size + str->len;
+}
+
+static inline u32 htab_map_calc_hash(const struct bpf_htab *htab, void *key)
+{
+	struct bpf_str_key_stor *str;
+
+	if (!htab_str_in_key(htab))
+		return htab_map_hash(key, htab->map.key_size, htab->hashrnd);
+
+	str = key + htab->str_stor_off;
+	if (!str->hash) {
+		str->hash = full_name_hash((void *)(unsigned long)htab->hashrnd,
+					   str->raw, str->len);
+		if (!str->hash)
+			str->hash = htab->n_buckets > 1 ? htab->n_buckets - 1 : 1;
+	}
+
+	/* String key only */
+	if (!htab->str_stor_off)
+		return str->hash;
+
+	return htab_map_hash(key, htab->hash_key_size, htab->hashrnd);
+}
+
 static void htab_init_buckets(struct bpf_htab *htab)
 {
 	unsigned i;
@@ -410,6 +467,7 @@ static int htab_map_alloc_check(union bpf_attr *attr)
 	bool percpu_lru = (attr->map_flags & BPF_F_NO_COMMON_LRU);
 	bool prealloc = !(attr->map_flags & BPF_F_NO_PREALLOC);
 	bool zero_seed = (attr->map_flags & BPF_F_ZERO_SEED);
+	bool str_in_key = (attr->map_flags & BPF_F_STR_IN_KEY);
 	int numa_node = bpf_map_attr_numa_node(attr);
 
 	BUILD_BUG_ON(offsetof(struct htab_elem, htab) !=
@@ -440,6 +498,10 @@ static int htab_map_alloc_check(union bpf_attr *attr)
 	if (numa_node != NUMA_NO_NODE && (percpu || percpu_lru))
 		return -EINVAL;
 
+	/* string in key needs key btf info */
+	if (str_in_key && !attr->btf_key_type_id)
+		return -EINVAL;
+
 	/* check sanity of attributes.
 	 * value_size == 0 may be allowed in the future to use map as a set
 	 */
@@ -563,11 +625,6 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	return ERR_PTR(err);
 }
 
-static inline u32 htab_map_hash(const void *key, u32 key_len, u32 hashrnd)
-{
-	return jhash(key, key_len, hashrnd);
-}
-
 static inline struct bucket *__select_bucket(struct bpf_htab *htab, u32 hash)
 {
 	return &htab->buckets[hash & (htab->n_buckets - 1)];
@@ -624,18 +681,20 @@ static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 	struct hlist_nulls_head *head;
 	struct htab_elem *l;
-	u32 hash, key_size;
+	u32 hash, cmp_size;
 
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	key_size = map->key_size;
+	if (!htab_valid_str_in_key(htab, key))
+		return NULL;
 
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
+	hash = htab_map_calc_hash(htab, key);
 
 	head = select_bucket(htab, hash);
 
-	l = lookup_nulls_elem_raw(head, hash, key, key_size, htab->n_buckets);
+	cmp_size = htab_compared_key_size(htab, key);
+	l = lookup_nulls_elem_raw(head, hash, key, cmp_size, htab->n_buckets);
 
 	return l;
 }
@@ -676,6 +735,45 @@ static int htab_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 	return insn - insn_buf;
 }
 
+static int htab_check_btf(const struct bpf_map *map, const struct btf *btf,
+			  const struct btf_type *key_type,
+			  const struct btf_type *value_type)
+{
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	int offset;
+	int next;
+
+	if (!htab_str_in_key(htab))
+		return 0;
+
+	/*
+	 * The layout of string in hash key must be as follows:
+	 *
+	 *   >the start of hash key
+	 *   ...
+	 *   [struct bpf_str_key_desc m;]
+	 *   ...
+	 *   [struct bpf_str_key_desc n;]
+	 *   ...
+	 *   struct bpf_str_key_stor z;
+	 *   unsigned char s[N];
+	 *   >the end of hash key
+	 */
+	offset = btf_find_str_key_stor(btf, key_type);
+	if (offset < 0)
+		return offset;
+
+	next = offset + sizeof(struct bpf_str_key_stor);
+	if (next >= map->key_size ||
+	    btf_find_array_at(btf, key_type, next, map->key_size - next) < 0)
+		return -EINVAL;
+
+	htab->hash_key_size = next;
+	htab->str_stor_off = offset;
+
+	return 0;
+}
+
 static __always_inline void *__htab_lru_map_lookup_elem(struct bpf_map *map,
 							void *key, const bool mark)
 {
@@ -772,7 +870,7 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 	struct hlist_nulls_head *head;
 	struct htab_elem *l, *next_l;
-	u32 hash, key_size;
+	u32 hash, key_size, cmp_size;
 	int i = 0;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
@@ -782,12 +880,16 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	if (!key)
 		goto find_first_elem;
 
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
+	if (!htab_valid_str_in_key(htab, key))
+		return -EINVAL;
+
+	hash = htab_map_calc_hash(htab, key);
 
 	head = select_bucket(htab, hash);
 
 	/* lookup the key */
-	l = lookup_nulls_elem_raw(head, hash, key, key_size, htab->n_buckets);
+	cmp_size = htab_compared_key_size(htab, key);
+	l = lookup_nulls_elem_raw(head, hash, key, cmp_size, htab->n_buckets);
 
 	if (!l)
 		goto find_first_elem;
@@ -1024,19 +1126,22 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	struct hlist_nulls_head *head;
 	unsigned long flags;
 	struct bucket *b;
-	u32 key_size, hash;
+	u32 key_size, hash, cmp_size;
 	int ret;
 
 	if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
 		/* unknown flags */
 		return -EINVAL;
+	if (!htab_valid_str_in_key(htab, key))
+		return -EINVAL;
 
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
 	key_size = map->key_size;
+	cmp_size = htab_compared_key_size(htab, key);
 
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
+	hash = htab_map_calc_hash(htab, key);
 
 	b = __select_bucket(htab, hash);
 	head = &b->head;
@@ -1045,7 +1150,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		if (unlikely(!map_value_has_spin_lock(map)))
 			return -EINVAL;
 		/* find an element without taking the bucket lock */
-		l_old = lookup_nulls_elem_raw(head, hash, key, key_size,
+		l_old = lookup_nulls_elem_raw(head, hash, key, cmp_size,
 					      htab->n_buckets);
 		ret = check_flags(htab, l_old, map_flags);
 		if (ret)
@@ -1067,7 +1172,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	if (ret)
 		return ret;
 
-	l_old = lookup_elem_raw(head, hash, key, key_size);
+	l_old = lookup_elem_raw(head, hash, key, cmp_size);
 
 	ret = check_flags(htab, l_old, map_flags);
 	if (ret)
@@ -1328,15 +1433,16 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
 	struct bucket *b;
 	struct htab_elem *l;
 	unsigned long flags;
-	u32 hash, key_size;
+	u32 hash, cmp_size;
 	int ret;
 
+	if (!htab_valid_str_in_key(htab, key))
+		return -EINVAL;
+
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	key_size = map->key_size;
-
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
+	hash = htab_map_calc_hash(htab, key);
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
@@ -1344,7 +1450,8 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
 	if (ret)
 		return ret;
 
-	l = lookup_elem_raw(head, hash, key, key_size);
+	cmp_size = htab_compared_key_size(htab, key);
+	l = lookup_elem_raw(head, hash, key, cmp_size);
 
 	if (l) {
 		hlist_nulls_del_rcu(&l->hash_node);
@@ -1495,13 +1602,16 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
 	struct hlist_nulls_head *head;
 	unsigned long bflags;
 	struct htab_elem *l;
-	u32 hash, key_size;
 	struct bucket *b;
+	u32 hash, key_size, cmp_size;
 	int ret;
 
+	if (!htab_valid_str_in_key(htab, key))
+		return -EINVAL;
+
 	key_size = map->key_size;
 
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
+	hash = htab_map_calc_hash(htab, key);
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
@@ -1509,7 +1619,8 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
 	if (ret)
 		return ret;
 
-	l = lookup_elem_raw(head, hash, key, key_size);
+	cmp_size = htab_compared_key_size(htab, key);
+	l = lookup_elem_raw(head, hash, key, cmp_size);
 	if (!l) {
 		ret = -ENOENT;
 	} else {
@@ -2118,6 +2229,7 @@ const struct bpf_map_ops htab_map_ops = {
 	.map_update_elem = htab_map_update_elem,
 	.map_delete_elem = htab_map_delete_elem,
 	.map_gen_lookup = htab_map_gen_lookup,
+	.map_check_btf = htab_check_btf,
 	.map_seq_show_elem = htab_map_seq_show_elem,
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_hash_elem,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index afe3d0d7f5f2..c764a82d79cd 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1218,6 +1218,9 @@ enum {
 
 /* Create a map that is suitable to be an inner map with dynamic max entries */
 	BPF_F_INNER_MAP		= (1U << 12),
+
+/* Flag for hash_map, there is string in hash key */
+	BPF_F_STR_IN_KEY	= (1U << 13),
 };
 
 /* Flags for BPF_PROG_QUERY. */
@@ -6565,4 +6568,20 @@ struct bpf_core_relo {
 	enum bpf_core_relo_kind kind;
 };
 
+struct bpf_str_key_desc {
+	/* the relative offset of string */
+	__u32 offset;
+	/* the length of string (include the trailing zero) */
+	__u32 len;
+};
+
+struct bpf_str_key_stor {
+	/* the total length of string */
+	__u32 len;
+	/* the hash of string */
+	__u32 hash;
+	/* the content of string */
+	unsigned char raw[0];
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.25.4

