Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F97A479F3B
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 06:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbhLSFHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 00:07:34 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16830 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbhLSFHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 00:07:33 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JGrKv2dlGz90M0;
        Sun, 19 Dec 2021 13:06:43 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Sun, 19 Dec
 2021 13:07:30 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>,
        <yunbo.xufeng@linux.alibaba.com>
Subject: [RFC PATCH bpf-next 2/3] bpf: add BPF_F_STR_KEY to support string key in htab
Date:   Sun, 19 Dec 2021 13:22:44 +0800
Message-ID: <20211219052245.791605-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211219052245.791605-1-houtao1@huawei.com>
References: <20211219052245.791605-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to use string as hash-table key, key_size must be the storage
size of longest string. If there are large differencies in string
length, the hash distribution will be sub-optimal due to the unused
zero bytes in shorter strings and the lookup will be inefficient due to
unnecessary memcpy().

Also it is possible the unused part of string key returned from bpf helper
(e.g. bpf_d_path) is not mem-zeroed and if using it directly as lookup key,
the lookup will fail with -ENOENT.

So add BPF_F_STR_KEY to support string key in hash-table. The string key
can not be empty and its storage size (includes the trailing zero byte)
must not be greater than key_size. And it doesn't care about the values
of unused bytes after the trailing zero byte.

Two changes are made to support string key. An extra field used_key_size
is added in struct htab_element to describe the storage size of the
string size. It is used in lookup_nulls_elem_raw() and lookup_elem_raw()
to check whether the string length is the same before do memcmp(). The hash
algorithm is also changed from jhash() to full_name_hash() for string key
to reduce hash collision.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/uapi/linux/bpf.h       |   3 +
 kernel/bpf/hashtab.c           | 140 ++++++++++++++++++++++++++-------
 tools/include/uapi/linux/bpf.h |   3 +
 3 files changed, 118 insertions(+), 28 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b0383d371b9a..6c0bcec38100 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1211,6 +1211,9 @@ enum {
 
 /* Create a map that is suitable to be an inner map with dynamic max entries */
 	BPF_F_INNER_MAP		= (1U << 12),
+
+/* Flag for hash map, the key is string instead of fixed-size bytes */
+	BPF_F_STR_KEY		= (1U << 13),
 };
 
 /* Flags for BPF_PROG_QUERY. */
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index e21e27162e08..4604d11abad7 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -10,13 +10,14 @@
 #include <linux/random.h>
 #include <uapi/linux/btf.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/stringhash.h>
 #include "percpu_freelist.h"
 #include "bpf_lru_list.h"
 #include "map_in_map.h"
 
 #define HTAB_CREATE_FLAG_MASK						\
 	(BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |	\
-	 BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED)
+	 BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED | BPF_F_STR_KEY)
 
 #define BATCH_OPS(_name)			\
 	.map_lookup_batch =			\
@@ -124,12 +125,19 @@ struct htab_elem {
 		struct bpf_lru_node lru_node;
 	};
 	u32 hash;
+	/*
+	 * For string key, used_key_size is in the range: [2, key_size] and
+	 * includes the trailing zero byte. For no-string key, used_key_size
+	 * is equal with key_size.
+	 */
+	u32 used_key_size;
 	char key[] __aligned(8);
 };
 
 struct nolock_lookup_elem_result {
 	struct htab_elem *elem;
 	u32 hash;
+	u32 used;
 };
 
 struct lock_lookup_elem_result {
@@ -137,11 +145,13 @@ struct lock_lookup_elem_result {
 	unsigned long flags;
 	struct htab_elem *elem;
 	u32 hash;
+	u32 used;
 };
 
 struct lookup_bucket_result {
 	struct bucket *bucket;
 	u32 hash;
+	u32 used;
 };
 
 static inline bool htab_is_prealloc(const struct bpf_htab *htab)
@@ -154,6 +164,11 @@ static inline bool htab_use_raw_lock(const struct bpf_htab *htab)
 	return (!IS_ENABLED(CONFIG_PREEMPT_RT) || htab_is_prealloc(htab));
 }
 
+static inline bool htab_is_str_key(const struct bpf_htab *htab)
+{
+	return htab->map.map_flags & BPF_F_STR_KEY;
+}
+
 static void htab_init_buckets(struct bpf_htab *htab)
 {
 	unsigned i;
@@ -596,9 +611,29 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	return ERR_PTR(err);
 }
 
-static inline u32 htab_map_hash(const void *key, u32 key_len, u32 hashrnd)
+/* Return 0 to indicate an invalid string key */
+static inline u32 htab_used_key_size(bool str_key, const void *key,
+				     u32 key_size)
 {
-	return jhash(key, key_len, hashrnd);
+	u32 used;
+
+	if (!str_key)
+		return key_size;
+
+	used = strnlen(key, key_size);
+	if (!used || used >= key_size)
+		return 0;
+
+	/* Include the trailing zero */
+	return used + 1;
+}
+
+static inline u32 htab_map_hash(bool str_key, const void *key, u32 key_len,
+				u32 hashrnd)
+{
+	if (!str_key)
+		return jhash(key, key_len, hashrnd);
+	return full_name_hash((void *)(unsigned long)hashrnd, key, key_len);
 }
 
 static inline struct bucket *__select_bucket(struct bpf_htab *htab, u32 hash)
@@ -613,13 +648,15 @@ static inline struct hlist_nulls_head *select_bucket(struct bpf_htab *htab, u32
 
 /* this lookup function can only be called with bucket lock taken */
 static struct htab_elem *lookup_elem_raw(struct hlist_nulls_head *head, u32 hash,
-					 void *key, u32 key_size)
+					 bool str_key, void *key, u32 key_size)
 {
 	struct hlist_nulls_node *n;
 	struct htab_elem *l;
 
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
-		if (l->hash == hash && !memcmp(&l->key, key, key_size))
+		if (l->hash == hash &&
+		    (!str_key || l->used_key_size == key_size) &&
+		    !memcmp(&l->key, key, key_size))
 			return l;
 
 	return NULL;
@@ -630,15 +667,18 @@ static struct htab_elem *lookup_elem_raw(struct hlist_nulls_head *head, u32 hash
  * while link list is being walked
  */
 static struct htab_elem *lookup_nulls_elem_raw(struct hlist_nulls_head *head,
-					       u32 hash, void *key,
-					       u32 key_size, u32 n_buckets)
+					       u32 hash, bool str_key,
+					       void *key, u32 key_size,
+					       u32 n_buckets)
 {
 	struct hlist_nulls_node *n;
 	struct htab_elem *l;
 
 again:
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
-		if (l->hash == hash && !memcmp(&l->key, key, key_size))
+		if (l->hash == hash &&
+		    (!str_key || l->used_key_size == key_size) &&
+		    !memcmp(&l->key, key, key_size))
 			return l;
 
 	if (unlikely(get_nulls_value(n) != (hash & (n_buckets - 1))))
@@ -647,33 +687,48 @@ static struct htab_elem *lookup_nulls_elem_raw(struct hlist_nulls_head *head,
 	return NULL;
 }
 
-static __always_inline void
+static __always_inline int
 nolock_lookup_elem(struct bpf_htab *htab, void *key,
 		   struct nolock_lookup_elem_result *e)
 {
 	struct hlist_nulls_head *head;
-	u32 key_size, hash;
+	u32 key_size, hash, used;
+	bool str_key;
 
+	str_key = htab_is_str_key(htab);
 	key_size = htab->map.key_size;
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
+	used = htab_used_key_size(str_key, key, key_size);
+	if (!used)
+		return -EINVAL;
+
+	hash = htab_map_hash(str_key, key, used, htab->hashrnd);
 	head = select_bucket(htab, hash);
 
-	e->elem = lookup_nulls_elem_raw(head, hash, key, key_size,
+	e->elem = lookup_nulls_elem_raw(head, hash, str_key, key, used,
 					htab->n_buckets);
 	e->hash = hash;
+	e->used = used;
+
+	return 0;
 }
 
-static __always_inline void
+static __always_inline int
 lock_lookup_elem(struct bpf_htab *htab, void *key,
 		 struct lock_lookup_elem_result *e)
 {
-	u32 key_size, hash;
 	struct bucket *b;
 	unsigned long flags;
+	u32 key_size, hash, used;
+	bool str_key;
 	int ret;
 
+	str_key = htab_is_str_key(htab);
 	key_size = htab->map.key_size;
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
+	used = htab_used_key_size(str_key, key, key_size);
+	if (!used)
+		return -EINVAL;
+
+	hash = htab_map_hash(str_key, key, used, htab->hashrnd);
 	b = __select_bucket(htab, hash);
 
 	ret = htab_lock_bucket(htab, b, hash, &flags);
@@ -682,22 +737,32 @@ lock_lookup_elem(struct bpf_htab *htab, void *key,
 
 	e->bucket = b;
 	e->flags = flags;
-	e->elem = lookup_elem_raw(&b->head, hash, key, key_size);
+	e->elem = lookup_elem_raw(&b->head, hash, str_key, key, used);
 	e->hash = hash;
+	e->used = used;
 
 	return 0;
 }
 
-static __always_inline void
+static __always_inline int
 lookup_bucket(struct bpf_htab *htab, void *key, struct lookup_bucket_result *b)
 {
-	u32 key_size, hash;
+	u32 key_size, hash, used;
+	bool str_key;
 
+	str_key = htab_is_str_key(htab);
 	key_size = htab->map.key_size;
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
+	used = htab_used_key_size(str_key, key, key_size);
+	if (!used)
+		return -EINVAL;
+
+	hash = htab_map_hash(str_key, key, used, htab->hashrnd);
 
 	b->bucket = __select_bucket(htab, hash);
 	b->hash = hash;
+	b->used = used;
+
+	return 0;
 }
 
 /* Called from syscall or from eBPF program directly, so
@@ -713,7 +778,8 @@ static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	nolock_lookup_elem(htab, key, &e);
+	if (nolock_lookup_elem(htab, key, &e))
+		return NULL;
 
 	return e.elem;
 }
@@ -852,6 +918,7 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	struct htab_elem *next_l;
 	u32 key_size;
 	int i = 0;
+	int err;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
@@ -859,7 +926,10 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	if (!key)
 		goto find_first_elem;
 
-	nolock_lookup_elem(htab, key, &e);
+	err = nolock_lookup_elem(htab, key, &e);
+	if (err)
+		return err;
+
 	if (!e.elem)
 		goto find_first_elem;
 
@@ -1093,6 +1163,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	struct hlist_nulls_head *head;
 	unsigned long flags;
 	u32 key_size;
+	bool str_key;
 	int ret;
 
 	if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
@@ -1102,15 +1173,18 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	lookup_bucket(htab, key, &b);
+	ret = lookup_bucket(htab, key, &b);
+	if (ret)
+		return ret;
 
+	str_key = htab_is_str_key(htab);
 	key_size = map->key_size;
 	head = &b.bucket->head;
 	if (unlikely(map_flags & BPF_F_LOCK)) {
 		if (unlikely(!map_value_has_spin_lock(map)))
 			return -EINVAL;
 		/* find an element without taking the bucket lock */
-		l_old = lookup_nulls_elem_raw(head, b.hash, key, key_size,
+		l_old = lookup_nulls_elem_raw(head, b.hash, str_key, key, b.used,
 					      htab->n_buckets);
 		ret = check_flags(htab, l_old, map_flags);
 		if (ret)
@@ -1132,7 +1206,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	if (ret)
 		return ret;
 
-	l_old = lookup_elem_raw(head, b.hash, key, key_size);
+	l_old = lookup_elem_raw(head, b.hash, str_key, key, b.used);
 
 	ret = check_flags(htab, l_old, map_flags);
 	if (ret)
@@ -1163,6 +1237,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	/* add new element to the head of the list, so that
 	 * concurrent search will find it before old elem
 	 */
+	l_new->used_key_size = b.used;
 	hlist_nulls_add_head_rcu(&l_new->hash_node, head);
 	if (l_old) {
 		hlist_nulls_del_rcu(&l_old->hash_node);
@@ -1200,7 +1275,9 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	lookup_bucket(htab, key, &b);
+	ret = lookup_bucket(htab, key, &b);
+	if (ret)
+		return ret;
 
 	/* For LRU, we need to alloc before taking bucket's
 	 * spinlock because getting free nodes from LRU may need
@@ -1211,6 +1288,7 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	if (!l_new)
 		return -ENOMEM;
 
+	l_new->used_key_size = b.used;
 	copy_map_value(&htab->map,
 		       l_new->key + round_up(map->key_size, 8), value);
 
@@ -1219,7 +1297,8 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return ret;
 
 	head = &b.bucket->head;
-	l_old = lookup_elem_raw(head, b.hash, key, map->key_size);
+	l_old = lookup_elem_raw(head, b.hash, htab_is_str_key(htab), key,
+				b.used);
 
 	ret = check_flags(htab, l_old, map_flags);
 	if (ret)
@@ -1284,6 +1363,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 			ret = PTR_ERR(l_new);
 			goto err;
 		}
+		l_new->used_key_size = e.used;
 		hlist_nulls_add_head_rcu(&l_new->hash_node, &e.bucket->head);
 	}
 	ret = 0;
@@ -1311,7 +1391,9 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	lookup_bucket(htab, key, &b);
+	ret = lookup_bucket(htab, key, &b);
+	if (ret)
+		return ret;
 
 	/* For LRU, we need to alloc before taking bucket's
 	 * spinlock because LRU's elem alloc may need
@@ -1330,7 +1412,8 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 
 	head = &b.bucket->head;
 	key_size = map->key_size;
-	l_old = lookup_elem_raw(head, b.hash, key, key_size);
+	l_old = lookup_elem_raw(head, b.hash, htab_is_str_key(htab), key,
+				b.used);
 
 	ret = check_flags(htab, l_old, map_flags);
 	if (ret)
@@ -1343,6 +1426,7 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 		pcpu_copy_value(htab, htab_elem_get_ptr(l_old, key_size),
 				value, onallcpus);
 	} else {
+		l_new->used_key_size = b.used;
 		pcpu_init_value(htab, htab_elem_get_ptr(l_new, key_size),
 				value, onallcpus);
 		hlist_nulls_add_head_rcu(&l_new->hash_node, head);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b0383d371b9a..6c0bcec38100 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1211,6 +1211,9 @@ enum {
 
 /* Create a map that is suitable to be an inner map with dynamic max entries */
 	BPF_F_INNER_MAP		= (1U << 12),
+
+/* Flag for hash map, the key is string instead of fixed-size bytes */
+	BPF_F_STR_KEY		= (1U << 13),
 };
 
 /* Flags for BPF_PROG_QUERY. */
-- 
2.29.2

