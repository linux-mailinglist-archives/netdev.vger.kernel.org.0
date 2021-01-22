Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357DA300E4D
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 21:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbhAVU4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 15:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730676AbhAVUzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 15:55:12 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433A8C0613D6;
        Fri, 22 Jan 2021 12:54:32 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id q25so7470318oij.10;
        Fri, 22 Jan 2021 12:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VEPUOy/OUJAWrBKpSDHDSlC9Hyb8cX8zAsEcx5M58uM=;
        b=LXDCJIbIpo4jdCYN7bvaF6X1WsGvsDBCI/llBDcN+n5+/7q9O6MBdDk/mIxuYjFNE0
         thG+6EuVO1LuW/p/LQohA1wGtQn1Rfvi/4yO6BSDIXBN3qsPB3+dmU4FN6PTNoOr8qkm
         jTnteu48wFSVfaOV1aO+CjeEQDR+E1y6SocZiQaBWGYWMzW7LyjmU0wo7I85Ihqb36oi
         4z5QpDAMybMHh9L5OTux8woDCHALo7Q8++qeFPnQLzWGUkvqfBHdAHifdESTSYNPeJqR
         m380+hGk+nPJW7rhg/rV23AqtwoVVQCoXw9WeE1Sy6ZW2wddezSzyPuq+GkzxCel8tzh
         epCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VEPUOy/OUJAWrBKpSDHDSlC9Hyb8cX8zAsEcx5M58uM=;
        b=haXO141tsOfSG0rV2ltg6OdFAqjOfqRgIAFrdXGw/QpqkWEgGic9De2O1MIZvtnjYR
         TQUqn6CBwLmO7LGbkB5xa0UE/OZfPN5Fsjd7faIYaKaB0Net9lEUYtbkur9UWKZYAtIs
         b0NY+IHH96BVhcgzpRsigz3KrvVjwry0YQ96YtofKtRPoB3sRFdHnoNIx0c88d7PeiVC
         YNXtMgDPtXMup4vbLaiFhSTLFBKaBcEOCJXCMhGOF8YRrcozi6/r5Vr+CgdLJeHIZnz5
         n4mZLz2F19Yb5JpscuAT9lMA88MgA4UY0tpAAP6FidFqmZf5otgG5d6+AvIHbJwca392
         Tf1Q==
X-Gm-Message-State: AOAM531Aox5iPpl066dNP787zoMzWskg5jG5QMzHnOK0rNT7zWiG0bgW
        9FpE0RlK/IQtqozAjsuvXsG6UGzUQ0482A==
X-Google-Smtp-Source: ABdhPJx0FkZNXUncx2zCOJH+RN/HwRNYBzE0g1BUXMj04rS+jpKirzWc2pLce6VNEeRQnTN39LHqIg==
X-Received: by 2002:aca:d586:: with SMTP id m128mr4708157oig.15.1611348871380;
        Fri, 22 Jan 2021 12:54:31 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1c14:d05:b7d:917b])
        by smtp.gmail.com with ESMTPSA id k18sm1349193otj.36.2021.01.22.12.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 12:54:30 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jhs@mojatatu.com, andrii@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next v5 1/3] bpf: introduce timeout hash map
Date:   Fri, 22 Jan 2021 12:54:13 -0800
Message-Id: <20210122205415.113822-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This borrows the idea from conntrack and will be used for conntrack in
ebpf too. Each element in a timeout map has a user-specified timeout
in msecs, after it expires it will be automatically removed from the
map. Cilium already does the same thing, it uses a regular map or LRU
map to track connections and has its own GC in user-space. This does
not scale well when we have millions of connections, as each removal
needs a syscall. Even if we could batch the operations, it still needs
to copy a lot of data between kernel and user space.

There are two cases to consider here:

1. When the timeout map is idle, i.e. no one updates or accesses it,
   we rely on the delayed work to scan the whole hash table and remove
   these expired. The delayed work is scheduled every 1 sec when idle,
   which is also what conntrack uses. It is fine to scan the whole
   table as we do not actually remove elements during this scan,
   instead we simply queue them to the lockless list and defer all the
   removals to the next schedule.

2. When the timeout map is actively accessed, we could reach expired
   elements before the idle work automatically scans them, we can
   simply skip them and schedule the delayed work immediately to do
   the actual removals. We have to avoid taking locks on fast path.

The timeout of an element can be set or updated via bpf_map_update_elem()
and we reuse the upper 32-bit of the 64-bit flag for the timeout value,
as there are only a few bits are used currently. Note, a zero timeout
means to expire immediately.

To avoid adding memory overhead to regular map, we have to reuse some
field in struct htab_elem, that is, lru_node. Otherwise we would have
to rewrite a lot of code.

For now, batch ops is not supported, we can add it later if needed.

Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf_types.h      |   1 +
 include/uapi/linux/bpf.h       |   5 +-
 kernel/bpf/hashtab.c           | 274 +++++++++++++++++++++++++++++++--
 kernel/bpf/syscall.c           |   3 +-
 tools/include/uapi/linux/bpf.h |   1 +
 5 files changed, 269 insertions(+), 15 deletions(-)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 99f7fd657d87..00a3b17b6af2 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -125,6 +125,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_RINGBUF, ringbuf_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_TIMEOUT_HASH, htab_timeout_map_ops)
 
 BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
 BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c001766adcbc..9c9d8c194b39 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -164,6 +164,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_RINGBUF,
 	BPF_MAP_TYPE_INODE_STORAGE,
 	BPF_MAP_TYPE_TASK_STORAGE,
+	BPF_MAP_TYPE_TIMEOUT_HASH,
 };
 
 /* Note that tracing related programs such as
@@ -399,7 +400,9 @@ enum bpf_link_type {
  */
 #define BPF_PSEUDO_CALL		1
 
-/* flags for BPF_MAP_UPDATE_ELEM command */
+/* flags for BPF_MAP_UPDATE_ELEM command, upper 32 bits are timeout for
+ * BPF_MAP_TYPE_TIMEOUT_HASH (in milliseconds).
+ */
 enum {
 	BPF_ANY		= 0, /* create new element or update existing */
 	BPF_NOEXIST	= 1, /* create new element if it didn't exist */
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index c1ac7f964bc9..90a899d1706f 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -8,6 +8,8 @@
 #include <linux/filter.h>
 #include <linux/rculist_nulls.h>
 #include <linux/random.h>
+#include <linux/llist.h>
+#include <linux/workqueue.h>
 #include <uapi/linux/btf.h>
 #include <linux/rcupdate_trace.h>
 #include "percpu_freelist.h"
@@ -104,6 +106,9 @@ struct bpf_htab {
 	u32 hashrnd;
 	struct lock_class_key lockdep_key;
 	int __percpu *map_locked[HASHTAB_MAP_LOCK_COUNT];
+	struct llist_head gc_list;
+	struct delayed_work gc_work;
+	u64 next_gc; /* in jiffies64 */
 };
 
 /* each htab element is struct htab_elem + key + value */
@@ -122,6 +127,11 @@ struct htab_elem {
 	union {
 		struct rcu_head rcu;
 		struct bpf_lru_node lru_node;
+		struct {
+			u64 expires; /* in jiffies64 */
+			struct llist_node gc_node;
+			atomic_t pending;
+		};
 	};
 	u32 hash;
 	char key[] __aligned(8);
@@ -429,8 +439,34 @@ static int htab_map_alloc_check(union bpf_attr *attr)
 	return 0;
 }
 
+static bool htab_elem_expired(struct htab_elem *e)
+{
+	return time_after_eq64(get_jiffies_64(), e->expires);
+}
+
+/* Schedule GC to remove an expired element, unless it is already pending. */
+static void htab_gc_elem(struct bpf_htab *htab, struct htab_elem *e)
+{
+	if (atomic_xchg(&e->pending, 1))
+		return;
+	llist_add(&e->gc_node, &htab->gc_list);
+	queue_delayed_work(system_unbound_wq, &htab->gc_work, 0);
+}
+
+/* GC an element if it has been expired, return whether the element is expired
+ * or not.
+ */
+static bool htab_expire_elem(struct bpf_htab *htab, struct htab_elem *e)
+{
+	if (!htab_elem_expired(e))
+		return false;
+	htab_gc_elem(htab, e);
+	return true;
+}
+
 static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 {
+	bool timeout_map = attr->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
 	bool percpu = (attr->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
 		       attr->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH);
 	bool lru = (attr->map_type == BPF_MAP_TYPE_LRU_HASH ||
@@ -509,7 +545,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 		if (err)
 			goto free_map_locked;
 
-		if (!percpu && !lru) {
+		if (!percpu && !lru && !timeout_map) {
 			/* lru itself can remove the least used element, so
 			 * there is no need for an extra elem during map_update.
 			 */
@@ -730,6 +766,7 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
 static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	bool is_timeout = map->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
 	struct hlist_nulls_head *head;
 	struct htab_elem *l, *next_l;
 	u32 hash, key_size;
@@ -757,6 +794,8 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 				  struct htab_elem, hash_node);
 
 	if (next_l) {
+		if (is_timeout && htab_expire_elem(htab, next_l))
+			goto find_first_elem;
 		/* if next elem in this hash list is non-zero, just return it */
 		memcpy(next_key, next_l->key, key_size);
 		return 0;
@@ -775,6 +814,8 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 		next_l = hlist_nulls_entry_safe(rcu_dereference_raw(hlist_nulls_first_rcu(head)),
 					  struct htab_elem, hash_node);
 		if (next_l) {
+			if (is_timeout && htab_expire_elem(htab, next_l))
+				continue;
 			/* if it's not empty, just return it */
 			memcpy(next_key, next_l->key, key_size);
 			return 0;
@@ -877,6 +918,7 @@ static bool fd_htab_map_needs_adjust(const struct bpf_htab *htab)
 static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 					 void *value, u32 key_size, u32 hash,
 					 bool percpu, bool onallcpus,
+					 bool timeout_map,
 					 struct htab_elem *old_elem)
 {
 	u32 size = htab->map.value_size;
@@ -885,9 +927,11 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 	void __percpu *pptr;
 
 	if (prealloc) {
-		if (old_elem) {
+		if (old_elem && !timeout_map) {
 			/* if we're updating the existing element,
-			 * use per-cpu extra elems to avoid freelist_pop/push
+			 * use per-cpu extra elems to avoid freelist_pop/push.
+			 * The timeout map is special, we can not simply put it
+			 * back for recycle without going through GC.
 			 */
 			pl_new = this_cpu_ptr(htab->extra_elems);
 			l_new = *pl_new;
@@ -897,8 +941,12 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 			struct pcpu_freelist_node *l;
 
 			l = __pcpu_freelist_pop(&htab->freelist);
-			if (!l)
-				return ERR_PTR(-E2BIG);
+			if (!l) {
+				if (timeout_map && old_elem)
+					return ERR_PTR(-EAGAIN);
+				else
+					return ERR_PTR(-E2BIG);
+			}
 			l_new = container_of(l, struct htab_elem, fnode);
 		}
 	} else {
@@ -952,6 +1000,8 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 			       value);
 	}
 
+	if (timeout_map)
+		atomic_set(&l_new->pending, 0);
 	l_new->hash = hash;
 	return l_new;
 dec_count:
@@ -973,18 +1023,37 @@ static int check_flags(struct bpf_htab *htab, struct htab_elem *l_old,
 	return 0;
 }
 
+static u64 msecs_to_expire(u32 ms)
+{
+	u64 tmp = ms * NSEC_PER_MSEC;
+
+	return nsecs_to_jiffies64(tmp) + get_jiffies_64();
+}
+
+static u32 fetch_timeout(u64 *map_flags)
+{
+	u32 timeout = (*map_flags) >> 32;
+
+	*map_flags = (*map_flags) & 0xffffffff;
+	return timeout;
+}
+
 /* Called from syscall or from eBPF program */
 static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 				u64 map_flags)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	bool timeout_map = map->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
 	struct htab_elem *l_new = NULL, *l_old;
 	struct hlist_nulls_head *head;
 	unsigned long flags;
 	struct bucket *b;
 	u32 key_size, hash;
+	u32 timeout;
 	int ret;
 
+	timeout = fetch_timeout(&map_flags);
+
 	if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
 		/* unknown flags */
 		return -EINVAL;
@@ -1012,6 +1081,8 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 			copy_map_value_locked(map,
 					      l_old->key + round_up(key_size, 8),
 					      value, false);
+			if (timeout_map)
+				l_old->expires = msecs_to_expire(timeout);
 			return 0;
 		}
 		/* fall through, grab the bucket lock and lookup again.
@@ -1020,6 +1091,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		 */
 	}
 
+again:
 	ret = htab_lock_bucket(htab, b, hash, &flags);
 	if (ret)
 		return ret;
@@ -1040,26 +1112,41 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		copy_map_value_locked(map,
 				      l_old->key + round_up(key_size, 8),
 				      value, false);
+		if (timeout_map)
+			l_old->expires = msecs_to_expire(timeout);
 		ret = 0;
 		goto err;
 	}
 
 	l_new = alloc_htab_elem(htab, key, value, key_size, hash, false, false,
-				l_old);
+				timeout_map, l_old);
 	if (IS_ERR(l_new)) {
-		/* all pre-allocated elements are in use or memory exhausted */
 		ret = PTR_ERR(l_new);
+		if (ret == -EAGAIN) {
+			htab_unlock_bucket(htab, b, hash, flags);
+			htab_gc_elem(htab, l_old);
+			mod_delayed_work(system_unbound_wq, &htab->gc_work, 0);
+			goto again;
+		}
+		/* all pre-allocated elements are in use or memory exhausted */
 		goto err;
 	}
 
+	if (timeout_map)
+		l_new->expires = msecs_to_expire(timeout);
+
 	/* add new element to the head of the list, so that
 	 * concurrent search will find it before old elem
 	 */
 	hlist_nulls_add_head_rcu(&l_new->hash_node, head);
 	if (l_old) {
-		hlist_nulls_del_rcu(&l_old->hash_node);
-		if (!htab_is_prealloc(htab))
-			free_htab_elem(htab, l_old);
+		if (timeout_map) {
+			htab_gc_elem(htab, l_old);
+		} else {
+			hlist_nulls_del_rcu(&l_old->hash_node);
+			if (!htab_is_prealloc(htab))
+				free_htab_elem(htab, l_old);
+		}
 	}
 	ret = 0;
 err:
@@ -1173,7 +1260,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 				value, onallcpus);
 	} else {
 		l_new = alloc_htab_elem(htab, key, value, key_size,
-					hash, true, onallcpus, NULL);
+					hash, true, onallcpus, false, NULL);
 		if (IS_ERR(l_new)) {
 			ret = PTR_ERR(l_new);
 			goto err;
@@ -1269,6 +1356,7 @@ static int htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 static int htab_map_delete_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	bool is_timeout = map->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
 	struct hlist_nulls_head *head;
 	struct bucket *b;
 	struct htab_elem *l;
@@ -1291,8 +1379,14 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
 	l = lookup_elem_raw(head, hash, key, key_size);
 
 	if (l) {
-		hlist_nulls_del_rcu(&l->hash_node);
-		free_htab_elem(htab, l);
+		if (is_timeout) {
+			if (htab_elem_expired(l))
+				ret = -ENOENT;
+			htab_gc_elem(htab, l);
+		} else {
+			hlist_nulls_del_rcu(&l->hash_node);
+			free_htab_elem(htab, l);
+		}
 	} else {
 		ret = -ENOENT;
 	}
@@ -2178,3 +2272,157 @@ const struct bpf_map_ops htab_of_maps_map_ops = {
 	.map_btf_name = "bpf_htab",
 	.map_btf_id = &htab_of_maps_map_btf_id,
 };
+
+#define HTAB_GC_INTERVAL HZ
+
+static void htab_gc(struct work_struct *work)
+{
+	struct htab_elem *e, *tmp;
+	struct llist_node *lhead;
+	struct bpf_htab *htab;
+	int i, count;
+
+	htab = container_of(work, struct bpf_htab, gc_work.work);
+	lhead = llist_del_all(&htab->gc_list);
+
+	llist_for_each_entry_safe(e, tmp, lhead, gc_node) {
+		unsigned long flags;
+		struct bucket *b;
+		u32 hash;
+
+		hash = e->hash;
+		b = __select_bucket(htab, hash);
+		if (htab_lock_bucket(htab, b, hash, &flags))
+			continue;
+		hlist_nulls_del_rcu(&e->hash_node);
+		atomic_set(&e->pending, 0);
+		free_htab_elem(htab, e);
+		htab_unlock_bucket(htab, b, hash, flags);
+
+		cond_resched();
+	}
+
+	if (time_after_eq64(htab->next_gc, get_jiffies_64())) {
+		queue_delayed_work(system_unbound_wq, &htab->gc_work,
+				   htab->next_gc - get_jiffies_64());
+		return;
+	}
+
+	for (count = 0, i = 0; i < htab->n_buckets; i++) {
+		struct hlist_nulls_head *head;
+		struct hlist_nulls_node *n;
+		struct htab_elem *l;
+
+		rcu_read_lock();
+		head = select_bucket(htab, i);
+		hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
+			if (htab_expire_elem(htab, l))
+				count++;
+		rcu_read_unlock();
+
+		cond_resched();
+	}
+	htab->next_gc = get_jiffies_64() + HTAB_GC_INTERVAL;
+
+	queue_delayed_work(system_unbound_wq, &htab->gc_work,
+			   count ? 0 : HTAB_GC_INTERVAL);
+}
+
+static void *__htab_timeout_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	struct htab_elem *l;
+
+	l = __htab_map_lookup_elem(map, key);
+	if (l && htab_expire_elem(htab, l))
+		l = NULL;
+
+	return l;
+}
+
+static void *htab_timeout_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	struct htab_elem *l = __htab_timeout_map_lookup_elem(map, key);
+
+	if (l)
+		return l->key + round_up(map->key_size, 8);
+	return NULL;
+}
+
+static int htab_timeout_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
+{
+	struct bpf_insn *insn = insn_buf;
+	const int ret = BPF_REG_0;
+
+	BUILD_BUG_ON(!__same_type(&__htab_timeout_map_lookup_elem,
+		     (void *(*)(struct bpf_map *map, void *key))NULL));
+	*insn++ = BPF_EMIT_CALL(BPF_CAST_CALL(__htab_timeout_map_lookup_elem));
+	*insn++ = BPF_JMP_IMM(BPF_JEQ, ret, 0, 1);
+	*insn++ = BPF_ALU64_IMM(BPF_ADD, ret,
+				offsetof(struct htab_elem, key) +
+				round_up(map->key_size, 8));
+	return insn - insn_buf;
+}
+
+static void htab_timeout_map_seq_show_elem(struct bpf_map *map, void *key,
+					   struct seq_file *m)
+{
+	void *value;
+
+	rcu_read_lock();
+
+	value = htab_timeout_map_lookup_elem(map, key);
+	if (!value) {
+		rcu_read_unlock();
+		return;
+	}
+
+	btf_type_seq_show(map->btf, map->btf_key_type_id, key, m);
+	seq_puts(m, ": ");
+	btf_type_seq_show(map->btf, map->btf_value_type_id, value, m);
+	seq_puts(m, "\n");
+
+	rcu_read_unlock();
+}
+
+static struct bpf_map *htab_timeout_map_alloc(union bpf_attr *attr)
+{
+	struct bpf_map *map = htab_map_alloc(attr);
+	struct bpf_htab *htab;
+
+	if (!IS_ERR(map)) {
+		htab = container_of(map, struct bpf_htab, map);
+		init_llist_head(&htab->gc_list);
+		INIT_DEFERRABLE_WORK(&htab->gc_work, htab_gc);
+		htab->next_gc = get_jiffies_64() + HTAB_GC_INTERVAL;
+		queue_delayed_work(system_unbound_wq, &htab->gc_work,
+				   HTAB_GC_INTERVAL);
+	}
+
+	return map;
+}
+
+static void htab_timeout_map_free(struct bpf_map *map)
+{
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+
+	cancel_delayed_work_sync(&htab->gc_work);
+	htab_map_free(map);
+}
+
+static int htab_timeout_map_btf_id;
+const struct bpf_map_ops htab_timeout_map_ops = {
+	.map_meta_equal = bpf_map_meta_equal,
+	.map_alloc_check = htab_map_alloc_check,
+	.map_alloc = htab_timeout_map_alloc,
+	.map_free = htab_timeout_map_free,
+	.map_get_next_key = htab_map_get_next_key,
+	.map_lookup_elem = htab_timeout_map_lookup_elem,
+	.map_update_elem = htab_map_update_elem,
+	.map_delete_elem = htab_map_delete_elem,
+	.map_gen_lookup = htab_timeout_map_gen_lookup,
+	.map_seq_show_elem = htab_timeout_map_seq_show_elem,
+	.map_btf_name = "bpf_htab",
+	.map_btf_id = &htab_timeout_map_btf_id,
+	.iter_seq_info = &iter_seq_info,
+};
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e5999d86c76e..f15b340d33ca 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -777,7 +777,8 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
 		    map->map_type != BPF_MAP_TYPE_CGROUP_STORAGE &&
 		    map->map_type != BPF_MAP_TYPE_SK_STORAGE &&
 		    map->map_type != BPF_MAP_TYPE_INODE_STORAGE &&
-		    map->map_type != BPF_MAP_TYPE_TASK_STORAGE)
+		    map->map_type != BPF_MAP_TYPE_TASK_STORAGE &&
+		    map->map_type != BPF_MAP_TYPE_TIMEOUT_HASH)
 			return -ENOTSUPP;
 		if (map->spin_lock_off + sizeof(struct bpf_spin_lock) >
 		    map->value_size) {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c001766adcbc..ac6ddfd7bddc 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -164,6 +164,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_RINGBUF,
 	BPF_MAP_TYPE_INODE_STORAGE,
 	BPF_MAP_TYPE_TASK_STORAGE,
+	BPF_MAP_TYPE_TIMEOUT_HASH,
 };
 
 /* Note that tracing related programs such as
-- 
2.25.1

