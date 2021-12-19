Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A50479F3D
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 06:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhLSFHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 00:07:33 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:30073 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbhLSFHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 00:07:32 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JGrHF6m4zz1DJ7R;
        Sun, 19 Dec 2021 13:04:25 +0800 (CST)
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
Subject: [RFC PATCH bpf-next 1/3] bpf: factor out helpers for htab bucket and element lookup
Date:   Sun, 19 Dec 2021 13:22:43 +0800
Message-ID: <20211219052245.791605-2-houtao1@huawei.com>
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

Call to htab_map_hash() and element lookup (e.g. lookup_elem_raw())
are scattered all over the place. In order to make the change of hash
algorithm and element comparison logic easy, factor out three helpers
correspondinging to three lookup patterns in htab imlementation:

1) lookup element locklessly by key (e.g. htab_map_lookup_elem)
nolock_lookup_elem()
2) lookup element with bucket locked (e.g. htab_map_delete_elem)
lock_lookup_elem()
3) lookup bucket and lock it later (e.g. htab_map_update_elem)
lookup_bucket()

For performance reason, mark these three helpers as always_inline.

Also factor out two helpers: next_elem() and first_elem() to
make the iteration of element list more concise.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 kernel/bpf/hashtab.c | 350 ++++++++++++++++++++++---------------------
 1 file changed, 183 insertions(+), 167 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d29af9988f37..e21e27162e08 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -127,6 +127,23 @@ struct htab_elem {
 	char key[] __aligned(8);
 };
 
+struct nolock_lookup_elem_result {
+	struct htab_elem *elem;
+	u32 hash;
+};
+
+struct lock_lookup_elem_result {
+	struct bucket *bucket;
+	unsigned long flags;
+	struct htab_elem *elem;
+	u32 hash;
+};
+
+struct lookup_bucket_result {
+	struct bucket *bucket;
+	u32 hash;
+};
+
 static inline bool htab_is_prealloc(const struct bpf_htab *htab)
 {
 	return !(htab->map.map_flags & BPF_F_NO_PREALLOC);
@@ -233,6 +250,22 @@ static bool htab_has_extra_elems(struct bpf_htab *htab)
 	return !htab_is_percpu(htab) && !htab_is_lru(htab);
 }
 
+static inline struct htab_elem *next_elem(const struct htab_elem *e)
+{
+	struct hlist_nulls_node *n =
+		rcu_dereference_raw(hlist_nulls_next_rcu(&e->hash_node));
+
+	return hlist_nulls_entry_safe(n, struct htab_elem, hash_node);
+}
+
+static inline struct htab_elem *first_elem(const struct hlist_nulls_head *head)
+{
+	struct hlist_nulls_node *n =
+		rcu_dereference_raw(hlist_nulls_first_rcu(head));
+
+	return hlist_nulls_entry_safe(n, struct htab_elem, hash_node);
+}
+
 static void htab_free_prealloced_timers(struct bpf_htab *htab)
 {
 	u32 num_entries = htab->map.max_entries;
@@ -614,6 +647,59 @@ static struct htab_elem *lookup_nulls_elem_raw(struct hlist_nulls_head *head,
 	return NULL;
 }
 
+static __always_inline void
+nolock_lookup_elem(struct bpf_htab *htab, void *key,
+		   struct nolock_lookup_elem_result *e)
+{
+	struct hlist_nulls_head *head;
+	u32 key_size, hash;
+
+	key_size = htab->map.key_size;
+	hash = htab_map_hash(key, key_size, htab->hashrnd);
+	head = select_bucket(htab, hash);
+
+	e->elem = lookup_nulls_elem_raw(head, hash, key, key_size,
+					htab->n_buckets);
+	e->hash = hash;
+}
+
+static __always_inline void
+lock_lookup_elem(struct bpf_htab *htab, void *key,
+		 struct lock_lookup_elem_result *e)
+{
+	u32 key_size, hash;
+	struct bucket *b;
+	unsigned long flags;
+	int ret;
+
+	key_size = htab->map.key_size;
+	hash = htab_map_hash(key, key_size, htab->hashrnd);
+	b = __select_bucket(htab, hash);
+
+	ret = htab_lock_bucket(htab, b, hash, &flags);
+	if (ret)
+		return ret;
+
+	e->bucket = b;
+	e->flags = flags;
+	e->elem = lookup_elem_raw(&b->head, hash, key, key_size);
+	e->hash = hash;
+
+	return 0;
+}
+
+static __always_inline void
+lookup_bucket(struct bpf_htab *htab, void *key, struct lookup_bucket_result *b)
+{
+	u32 key_size, hash;
+
+	key_size = htab->map.key_size;
+	hash = htab_map_hash(key, key_size, htab->hashrnd);
+
+	b->bucket = __select_bucket(htab, hash);
+	b->hash = hash;
+}
+
 /* Called from syscall or from eBPF program directly, so
  * arguments have to match bpf_map_lookup_elem() exactly.
  * The return value is adjusted by BPF instructions
@@ -622,22 +708,14 @@ static struct htab_elem *lookup_nulls_elem_raw(struct hlist_nulls_head *head,
 static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
-	struct hlist_nulls_head *head;
-	struct htab_elem *l;
-	u32 hash, key_size;
+	struct nolock_lookup_elem_result e;
 
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	key_size = map->key_size;
-
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
+	nolock_lookup_elem(htab, key, &e);
 
-	head = select_bucket(htab, hash);
-
-	l = lookup_nulls_elem_raw(head, hash, key, key_size, htab->n_buckets);
-
-	return l;
+	return e.elem;
 }
 
 static void *htab_map_lookup_elem(struct bpf_map *map, void *key)
@@ -770,32 +848,23 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
 static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
-	struct hlist_nulls_head *head;
-	struct htab_elem *l, *next_l;
-	u32 hash, key_size;
+	struct nolock_lookup_elem_result e;
+	struct htab_elem *next_l;
+	u32 key_size;
 	int i = 0;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
 	key_size = map->key_size;
-
 	if (!key)
 		goto find_first_elem;
 
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
-
-	head = select_bucket(htab, hash);
-
-	/* lookup the key */
-	l = lookup_nulls_elem_raw(head, hash, key, key_size, htab->n_buckets);
-
-	if (!l)
+	nolock_lookup_elem(htab, key, &e);
+	if (!e.elem)
 		goto find_first_elem;
 
 	/* key was found, get next key in the same bucket */
-	next_l = hlist_nulls_entry_safe(rcu_dereference_raw(hlist_nulls_next_rcu(&l->hash_node)),
-				  struct htab_elem, hash_node);
-
+	next_l = next_elem(e.elem);
 	if (next_l) {
 		/* if next elem in this hash list is non-zero, just return it */
 		memcpy(next_key, next_l->key, key_size);
@@ -803,17 +872,16 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	}
 
 	/* no more elements in this hash list, go to the next bucket */
-	i = hash & (htab->n_buckets - 1);
+	i = e.hash & (htab->n_buckets - 1);
 	i++;
 
 find_first_elem:
 	/* iterate over buckets */
 	for (; i < htab->n_buckets; i++) {
-		head = select_bucket(htab, i);
+		struct hlist_nulls_head *head = select_bucket(htab, i);
 
 		/* pick first element in the bucket */
-		next_l = hlist_nulls_entry_safe(rcu_dereference_raw(hlist_nulls_first_rcu(head)),
-					  struct htab_elem, hash_node);
+		next_l = first_elem(head);
 		if (next_l) {
 			/* if it's not empty, just return it */
 			memcpy(next_key, next_l->key, key_size);
@@ -1020,11 +1088,11 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 				u64 map_flags)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	struct lookup_bucket_result b;
 	struct htab_elem *l_new = NULL, *l_old;
 	struct hlist_nulls_head *head;
 	unsigned long flags;
-	struct bucket *b;
-	u32 key_size, hash;
+	u32 key_size;
 	int ret;
 
 	if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
@@ -1034,18 +1102,15 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	key_size = map->key_size;
-
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
-
-	b = __select_bucket(htab, hash);
-	head = &b->head;
+	lookup_bucket(htab, key, &b);
 
+	key_size = map->key_size;
+	head = &b.bucket->head;
 	if (unlikely(map_flags & BPF_F_LOCK)) {
 		if (unlikely(!map_value_has_spin_lock(map)))
 			return -EINVAL;
 		/* find an element without taking the bucket lock */
-		l_old = lookup_nulls_elem_raw(head, hash, key, key_size,
+		l_old = lookup_nulls_elem_raw(head, b.hash, key, key_size,
 					      htab->n_buckets);
 		ret = check_flags(htab, l_old, map_flags);
 		if (ret)
@@ -1063,11 +1128,11 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		 */
 	}
 
-	ret = htab_lock_bucket(htab, b, hash, &flags);
+	ret = htab_lock_bucket(htab, b.bucket, b.hash, &flags);
 	if (ret)
 		return ret;
 
-	l_old = lookup_elem_raw(head, hash, key, key_size);
+	l_old = lookup_elem_raw(head, b.hash, key, key_size);
 
 	ret = check_flags(htab, l_old, map_flags);
 	if (ret)
@@ -1087,8 +1152,8 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		goto err;
 	}
 
-	l_new = alloc_htab_elem(htab, key, value, key_size, hash, false, false,
-				l_old);
+	l_new = alloc_htab_elem(htab, key, value, key_size, b.hash, false,
+				false, l_old);
 	if (IS_ERR(l_new)) {
 		/* all pre-allocated elements are in use or memory exhausted */
 		ret = PTR_ERR(l_new);
@@ -1108,7 +1173,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	}
 	ret = 0;
 err:
-	htab_unlock_bucket(htab, b, hash, flags);
+	htab_unlock_bucket(htab, b.bucket, b.hash, flags);
 	return ret;
 }
 
@@ -1122,11 +1187,10 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 				    u64 map_flags)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	struct lookup_bucket_result b;
 	struct htab_elem *l_new, *l_old = NULL;
 	struct hlist_nulls_head *head;
 	unsigned long flags;
-	struct bucket *b;
-	u32 key_size, hash;
 	int ret;
 
 	if (unlikely(map_flags > BPF_EXIST))
@@ -1136,29 +1200,26 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	key_size = map->key_size;
-
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
-
-	b = __select_bucket(htab, hash);
-	head = &b->head;
+	lookup_bucket(htab, key, &b);
 
 	/* For LRU, we need to alloc before taking bucket's
 	 * spinlock because getting free nodes from LRU may need
 	 * to remove older elements from htab and this removal
 	 * operation will need a bucket lock.
 	 */
-	l_new = prealloc_lru_pop(htab, key, hash);
+	l_new = prealloc_lru_pop(htab, key, b.hash);
 	if (!l_new)
 		return -ENOMEM;
+
 	copy_map_value(&htab->map,
 		       l_new->key + round_up(map->key_size, 8), value);
 
-	ret = htab_lock_bucket(htab, b, hash, &flags);
+	ret = htab_lock_bucket(htab, b.bucket, b.hash, &flags);
 	if (ret)
 		return ret;
 
-	l_old = lookup_elem_raw(head, hash, key, key_size);
+	head = &b.bucket->head;
+	l_old = lookup_elem_raw(head, b.hash, key, map->key_size);
 
 	ret = check_flags(htab, l_old, map_flags);
 	if (ret)
@@ -1175,7 +1236,7 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	ret = 0;
 
 err:
-	htab_unlock_bucket(htab, b, hash, flags);
+	htab_unlock_bucket(htab, b.bucket, b.hash, flags);
 
 	if (ret)
 		htab_lru_push_free(htab, l_new);
@@ -1190,11 +1251,9 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 					 bool onallcpus)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	struct lock_lookup_elem_result e;
 	struct htab_elem *l_new = NULL, *l_old;
-	struct hlist_nulls_head *head;
-	unsigned long flags;
-	struct bucket *b;
-	u32 key_size, hash;
+	u32 key_size;
 	int ret;
 
 	if (unlikely(map_flags > BPF_EXIST))
@@ -1204,39 +1263,32 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	key_size = map->key_size;
-
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
-
-	b = __select_bucket(htab, hash);
-	head = &b->head;
-
-	ret = htab_lock_bucket(htab, b, hash, &flags);
+	ret = lock_lookup_elem(htab, key, &e);
 	if (ret)
 		return ret;
 
-	l_old = lookup_elem_raw(head, hash, key, key_size);
-
+	l_old = e.elem;
 	ret = check_flags(htab, l_old, map_flags);
 	if (ret)
 		goto err;
 
+	key_size = map->key_size;
 	if (l_old) {
 		/* per-cpu hash map can update value in-place */
 		pcpu_copy_value(htab, htab_elem_get_ptr(l_old, key_size),
 				value, onallcpus);
 	} else {
 		l_new = alloc_htab_elem(htab, key, value, key_size,
-					hash, true, onallcpus, NULL);
+					e.hash, true, onallcpus, NULL);
 		if (IS_ERR(l_new)) {
 			ret = PTR_ERR(l_new);
 			goto err;
 		}
-		hlist_nulls_add_head_rcu(&l_new->hash_node, head);
+		hlist_nulls_add_head_rcu(&l_new->hash_node, &e.bucket->head);
 	}
 	ret = 0;
 err:
-	htab_unlock_bucket(htab, b, hash, flags);
+	htab_unlock_bucket(htab, e.bucket, e.hash, e.flags);
 	return ret;
 }
 
@@ -1245,11 +1297,11 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 					     bool onallcpus)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	struct lookup_bucket_result b;
 	struct htab_elem *l_new = NULL, *l_old;
 	struct hlist_nulls_head *head;
 	unsigned long flags;
-	struct bucket *b;
-	u32 key_size, hash;
+	u32 key_size;
 	int ret;
 
 	if (unlikely(map_flags > BPF_EXIST))
@@ -1259,12 +1311,7 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	key_size = map->key_size;
-
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
-
-	b = __select_bucket(htab, hash);
-	head = &b->head;
+	lookup_bucket(htab, key, &b);
 
 	/* For LRU, we need to alloc before taking bucket's
 	 * spinlock because LRU's elem alloc may need
@@ -1272,16 +1319,18 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 	 * operation will need a bucket lock.
 	 */
 	if (map_flags != BPF_EXIST) {
-		l_new = prealloc_lru_pop(htab, key, hash);
+		l_new = prealloc_lru_pop(htab, key, b.hash);
 		if (!l_new)
 			return -ENOMEM;
 	}
 
-	ret = htab_lock_bucket(htab, b, hash, &flags);
+	ret = htab_lock_bucket(htab, b.bucket, b.hash, &flags);
 	if (ret)
 		return ret;
 
-	l_old = lookup_elem_raw(head, hash, key, key_size);
+	head = &b.bucket->head;
+	key_size = map->key_size;
+	l_old = lookup_elem_raw(head, b.hash, key, key_size);
 
 	ret = check_flags(htab, l_old, map_flags);
 	if (ret)
@@ -1301,7 +1350,7 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 	}
 	ret = 0;
 err:
-	htab_unlock_bucket(htab, b, hash, flags);
+	htab_unlock_bucket(htab, b.bucket, b.hash, flags);
 	if (l_new)
 		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
 	return ret;
@@ -1324,72 +1373,48 @@ static int htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 static int htab_map_delete_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
-	struct hlist_nulls_head *head;
-	struct bucket *b;
-	struct htab_elem *l;
-	unsigned long flags;
-	u32 hash, key_size;
+	struct lock_lookup_elem_result e;
 	int ret;
 
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	key_size = map->key_size;
-
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
-	b = __select_bucket(htab, hash);
-	head = &b->head;
-
-	ret = htab_lock_bucket(htab, b, hash, &flags);
+	ret = lock_lookup_elem(htab, key, &e);
 	if (ret)
 		return ret;
 
-	l = lookup_elem_raw(head, hash, key, key_size);
-
-	if (l) {
-		hlist_nulls_del_rcu(&l->hash_node);
-		free_htab_elem(htab, l);
+	if (e.elem) {
+		hlist_nulls_del_rcu(&e.elem->hash_node);
+		free_htab_elem(htab, e.elem);
 	} else {
 		ret = -ENOENT;
 	}
 
-	htab_unlock_bucket(htab, b, hash, flags);
+	htab_unlock_bucket(htab, e.bucket, e.hash, e.flags);
 	return ret;
 }
 
 static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
-	struct hlist_nulls_head *head;
-	struct bucket *b;
-	struct htab_elem *l;
-	unsigned long flags;
-	u32 hash, key_size;
+	struct lock_lookup_elem_result e;
 	int ret;
 
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
-	key_size = map->key_size;
-
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
-	b = __select_bucket(htab, hash);
-	head = &b->head;
-
-	ret = htab_lock_bucket(htab, b, hash, &flags);
+	ret = lock_lookup_elem(htab, key, &e);
 	if (ret)
 		return ret;
 
-	l = lookup_elem_raw(head, hash, key, key_size);
-
-	if (l)
-		hlist_nulls_del_rcu(&l->hash_node);
+	if (e.elem)
+		hlist_nulls_del_rcu(&e.elem->hash_node);
 	else
 		ret = -ENOENT;
 
-	htab_unlock_bucket(htab, b, hash, flags);
-	if (l)
-		htab_lru_push_free(htab, l);
+	htab_unlock_bucket(htab, e.bucket, e.hash, e.flags);
+	if (e.elem)
+		htab_lru_push_free(htab, e.elem);
 	return ret;
 }
 
@@ -1492,61 +1517,53 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
 					     bool is_percpu, u64 flags)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
-	struct hlist_nulls_head *head;
-	unsigned long bflags;
-	struct htab_elem *l;
-	u32 hash, key_size;
-	struct bucket *b;
+	struct lock_lookup_elem_result e;
+	u32 key_size;
 	int ret;
 
-	key_size = map->key_size;
-
-	hash = htab_map_hash(key, key_size, htab->hashrnd);
-	b = __select_bucket(htab, hash);
-	head = &b->head;
-
-	ret = htab_lock_bucket(htab, b, hash, &bflags);
+	ret = lock_lookup_elem(htab, key, &e);
 	if (ret)
 		return ret;
 
-	l = lookup_elem_raw(head, hash, key, key_size);
-	if (!l) {
+	if (!e.elem) {
 		ret = -ENOENT;
-	} else {
-		if (is_percpu) {
-			u32 roundup_value_size = round_up(map->value_size, 8);
-			void __percpu *pptr;
-			int off = 0, cpu;
+		goto out;
+	}
 
-			pptr = htab_elem_get_ptr(l, key_size);
-			for_each_possible_cpu(cpu) {
-				bpf_long_memcpy(value + off,
-						per_cpu_ptr(pptr, cpu),
-						roundup_value_size);
-				off += roundup_value_size;
-			}
-		} else {
-			u32 roundup_key_size = round_up(map->key_size, 8);
+	key_size = map->key_size;
+	if (is_percpu) {
+		u32 roundup_value_size = round_up(map->value_size, 8);
+		void __percpu *pptr;
+		int off = 0, cpu;
 
-			if (flags & BPF_F_LOCK)
-				copy_map_value_locked(map, value, l->key +
-						      roundup_key_size,
-						      true);
-			else
-				copy_map_value(map, value, l->key +
-					       roundup_key_size);
-			check_and_init_map_value(map, value);
+		pptr = htab_elem_get_ptr(e.elem, key_size);
+		for_each_possible_cpu(cpu) {
+			bpf_long_memcpy(value + off,
+					per_cpu_ptr(pptr, cpu),
+					roundup_value_size);
+			off += roundup_value_size;
 		}
+	} else {
+		u32 roundup_key_size = round_up(map->key_size, 8);
 
-		hlist_nulls_del_rcu(&l->hash_node);
-		if (!is_lru_map)
-			free_htab_elem(htab, l);
+		if (flags & BPF_F_LOCK)
+			copy_map_value_locked(map, value, e.elem->key +
+					      roundup_key_size,
+					      true);
+		else
+			copy_map_value(map, value, e.elem->key +
+				       roundup_key_size);
+		check_and_init_map_value(map, value);
 	}
 
-	htab_unlock_bucket(htab, b, hash, bflags);
+	hlist_nulls_del_rcu(&e.elem->hash_node);
+	if (!is_lru_map)
+		free_htab_elem(htab, e.elem);
+out:
+	htab_unlock_bucket(htab, e.bucket, e.hash, e.flags);
 
-	if (is_lru_map && l)
-		htab_lru_push_free(htab, l);
+	if (is_lru_map && e.elem)
+		htab_lru_push_free(htab, e.elem);
 
 	return ret;
 }
@@ -1629,7 +1646,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 		return -ENOENT;
 
 	key_size = htab->map.key_size;
-	roundup_key_size = round_up(htab->map.key_size, 8);
+	roundup_key_size = round_up(key_size, 8);
 	value_size = htab->map.value_size;
 	size = round_up(value_size, 8);
 	if (is_percpu)
@@ -1895,8 +1912,7 @@ bpf_hash_map_seq_find_next(struct bpf_iter_seq_hash_map_info *info,
 		/* no update/deletion on this bucket, prev_elem should be still valid
 		 * and we won't skip elements.
 		 */
-		n = rcu_dereference_raw(hlist_nulls_next_rcu(&prev_elem->hash_node));
-		elem = hlist_nulls_entry_safe(n, struct htab_elem, hash_node);
+		elem = next_elem(prev_elem);
 		if (elem)
 			return elem;
 
-- 
2.29.2

