Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F72C2E03E1
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 02:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgLVBei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 20:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLVBeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 20:34:37 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857FEC061793
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 17:33:57 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id k9so2633815oop.6
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 17:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tHqaX42jQkVgwPzjhndttd23qXP2jXOpbwq71CJHK3I=;
        b=Sl/CeNDUu0UOaNuRwT3NPraPtv60tviX+49HJUzGRfkSBlzykvRsc/qbgs3FNV+FUm
         Qc7gzaUgPayzcUiuNf034/jDq1aytIf1PGBdf63mWvy5h2LC5soKZx6mVgYNTlGrHg06
         pmWUm7eAefkWq/9Z9sLmzZrfKi9yX/VvLS8WS+uwKQXuzmfXQem8YR1Q45tXG+v1h6HE
         XhNnlLJuFIs92odE7ag//BVhBwMGmy2Mjp7arGwVV/p4jjtKW2hhEloq/rwZvr5Y/6et
         ii8gWpx4wVo5JqpvPreH5Fa5XRMl0+m9PLKzJdY1t5wpS6GXyUP4WIndq5KAz7sW4y24
         4A5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tHqaX42jQkVgwPzjhndttd23qXP2jXOpbwq71CJHK3I=;
        b=ZvT6MTb7BPn9MxjnFj32UeBhTc31REApOhZguDMW6dYBBy1k+IFvlXNx+42AE1RHhp
         ykF7yZxvgKj4oWiWKYmdgeTx4MCY46Q3J7PpPO9g6nufbWX3mZZcHnk93ftUFVgnjpsr
         lDxC9Um+Oex3GLmLfP4iDAxcTCi8D8CYP9nKjLzRVqumLCSl6JAc8wJKw7rlNutupIJQ
         0L1tqWwZZhLoh/y3rPC7YwDk7Nh8ZgI+upcO6GuW9/HFk4roG4y08/oYQbJMW063VuO4
         Li/9RMS1jkhfSHqLkUwZeEkxC63iimDTH4Sr5UFXuisQEhFD7oAoHiEB8fE6DtB/P+Wi
         gYvQ==
X-Gm-Message-State: AOAM531QPQE2dJk2z5c29eRS6kO4vx4NYspTxlz8PqH6w1b9Jdm/VFoy
        EoJdJGv+w3a1OkHNg+GQc7UHbU3y/zLXAg==
X-Google-Smtp-Source: ABdhPJwQJXnlA2pMXa2+HsTrqN9dzhXit4/a7U7G/0oQ8q6lWvVmeJPuaB0hGYIm869fJbuJ6FOf0A==
X-Received: by 2002:a4a:d118:: with SMTP id k24mr13371571oor.8.1608600836667;
        Mon, 21 Dec 2020 17:33:56 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:3825:1c64:a3d3:108])
        by smtp.gmail.com with ESMTPSA id z14sm4089607oot.5.2020.12.21.17.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 17:33:55 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next v3 1/3] bpf: introduce timeout map
Date:   Mon, 21 Dec 2020 17:33:42 -0800
Message-Id: <20201222013344.795259-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222013344.795259-1-xiyou.wangcong@gmail.com>
References: <20201222013344.795259-1-xiyou.wangcong@gmail.com>
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
   we rely on the idle work to scan the whole hash table and remove
   these expired. The idle work is scheduled every 1 sec, which is also
   what conntrack uses.

2. When the timeout map is actively accessed, we could reach expired
   elements before the idle work kicks in, we can simply skip them and
   schedule another work to do the actual removal work. Thusly we avoid
   taking locks on fast path.

The timeout of each element can be set or updated via bpf_map_update_elem()
and we reuse the upper 32-bit of the 64-bit flag for the timeout value.
For now, batch ops is not supported, we can add it later iff needed.

To avoid adding memory overhead to regular map, we have to reuse some
field in struct htab_elem, that is, lru_node. Otherwise we would have to
rewrite a lot of code.

Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf_types.h      |   1 +
 include/uapi/linux/bpf.h       |   5 +-
 kernel/bpf/hashtab.c           | 252 ++++++++++++++++++++++++++++++++-
 kernel/bpf/syscall.c           |   3 +-
 tools/include/uapi/linux/bpf.h |   1 +
 5 files changed, 253 insertions(+), 9 deletions(-)

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
index 77d7c1bb2923..88507e6aaddd 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -158,6 +158,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_RINGBUF,
 	BPF_MAP_TYPE_INODE_STORAGE,
 	BPF_MAP_TYPE_TASK_STORAGE,
+	BPF_MAP_TYPE_TIMEOUT_HASH,
 };
 
 /* Note that tracing related programs such as
@@ -393,7 +394,9 @@ enum bpf_link_type {
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
index 7e848200cd26..7f59b05e46b1 100644
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
+	struct work_struct gc_work;
+	struct delayed_work gc_idle_work;
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
@@ -428,6 +438,31 @@ static int htab_map_alloc_check(union bpf_attr *attr)
 	return 0;
 }
 
+static bool htab_elem_expired(struct htab_elem *e)
+{
+	return time_after_eq64(get_jiffies_64(), e->expires);
+}
+
+/* Simply put the element in gc list, unless it is already there. */
+static void htab_gc_elem(struct bpf_htab *htab, struct htab_elem *e)
+{
+	if (atomic_fetch_or(1, &e->pending))
+		return;
+	llist_add(&e->gc_node, &htab->gc_list);
+	queue_work(system_unbound_wq, &htab->gc_work);
+}
+
+/* GC an element if it has been expired, returns whether the element is expired
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
 	bool percpu = (attr->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
@@ -729,6 +764,7 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
 static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	bool is_timeout = map->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
 	struct hlist_nulls_head *head;
 	struct htab_elem *l, *next_l;
 	u32 hash, key_size;
@@ -756,6 +792,8 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 				  struct htab_elem, hash_node);
 
 	if (next_l) {
+		if (is_timeout && htab_expire_elem(htab, next_l))
+			goto find_first_elem;
 		/* if next elem in this hash list is non-zero, just return it */
 		memcpy(next_key, next_l->key, key_size);
 		return 0;
@@ -774,6 +812,8 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 		next_l = hlist_nulls_entry_safe(rcu_dereference_raw(hlist_nulls_first_rcu(head)),
 					  struct htab_elem, hash_node);
 		if (next_l) {
+			if (is_timeout && htab_expire_elem(htab, next_l))
+				continue;
 			/* if it's not empty, just return it */
 			memcpy(next_key, next_l->key, key_size);
 			return 0;
@@ -876,6 +916,7 @@ static bool fd_htab_map_needs_adjust(const struct bpf_htab *htab)
 static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 					 void *value, u32 key_size, u32 hash,
 					 bool percpu, bool onallcpus,
+					 bool timeout_map,
 					 struct htab_elem *old_elem)
 {
 	u32 size = htab->map.value_size;
@@ -951,6 +992,8 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 			       value);
 	}
 
+	if (timeout_map)
+		atomic_set(&l_new->pending, 0);
 	l_new->hash = hash;
 	return l_new;
 dec_count:
@@ -972,18 +1015,37 @@ static int check_flags(struct bpf_htab *htab, struct htab_elem *l_old,
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
@@ -1011,6 +1073,8 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 			copy_map_value_locked(map,
 					      l_old->key + round_up(key_size, 8),
 					      value, false);
+			if (timeout_map)
+				l_old->expires = msecs_to_expire(timeout);
 			return 0;
 		}
 		/* fall through, grab the bucket lock and lookup again.
@@ -1039,26 +1103,35 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
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
 		/* all pre-allocated elements are in use or memory exhausted */
 		ret = PTR_ERR(l_new);
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
@@ -1172,7 +1245,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 				value, onallcpus);
 	} else {
 		l_new = alloc_htab_elem(htab, key, value, key_size,
-					hash, true, onallcpus, NULL);
+					hash, true, onallcpus, false, NULL);
 		if (IS_ERR(l_new)) {
 			ret = PTR_ERR(l_new);
 			goto err;
@@ -1268,6 +1341,7 @@ static int htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 static int htab_map_delete_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	bool is_timeout = map->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
 	struct hlist_nulls_head *head;
 	struct bucket *b;
 	struct htab_elem *l;
@@ -1290,8 +1364,14 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
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
@@ -2177,3 +2257,161 @@ const struct bpf_map_ops htab_of_maps_map_ops = {
 	.map_btf_name = "bpf_htab",
 	.map_btf_id = &htab_of_maps_map_btf_id,
 };
+
+static void htab_gc(struct work_struct *work)
+{
+	struct llist_node *head;
+	struct htab_elem *e, *n;
+	struct bpf_htab *htab;
+
+	htab = container_of(work, struct bpf_htab, gc_work);
+	head = llist_del_all(&htab->gc_list);
+
+	llist_for_each_entry_safe(e, n, head, gc_node) {
+		unsigned long flags;
+		struct bucket *b;
+		int ret;
+
+		b = __select_bucket(htab, e->hash);
+		ret = htab_lock_bucket(htab, b, e->hash, &flags);
+		if (ret)
+			continue;
+		hlist_nulls_del_rcu(&e->hash_node);
+		free_htab_elem(htab, e);
+		htab_unlock_bucket(htab, b, e->hash, flags);
+
+		cond_resched();
+	}
+}
+
+#define HTAB_GC_INTERVAL HZ
+
+static void htab_gc_idle(struct work_struct *work)
+{
+	struct bpf_htab *htab;
+	int i;
+
+	htab = container_of(work, struct bpf_htab, gc_idle_work.work);
+
+	for (i = 0; i < htab->n_buckets; i++) {
+		struct hlist_nulls_head *head;
+		struct hlist_nulls_node *n;
+		struct htab_elem *l;
+
+		head = select_bucket(htab, i);
+		rcu_read_lock();
+		/* We have to defer the deletions to gc_work here, otherwise
+		 * we could double free the expired elements. This is hard to
+		 * avoid, as the lookup path could schedule gc_work without
+		 * lock.
+		 */
+		hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
+			htab_expire_elem(htab, l);
+		rcu_read_unlock();
+
+		cond_resched();
+	}
+
+	queue_delayed_work(system_power_efficient_wq, &htab->gc_idle_work,
+			   HTAB_GC_INTERVAL);
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
+		INIT_WORK(&htab->gc_work, htab_gc);
+		INIT_DEFERRABLE_WORK(&htab->gc_idle_work, htab_gc_idle);
+		queue_delayed_work(system_power_efficient_wq,
+				   &htab->gc_idle_work, HTAB_GC_INTERVAL);
+	}
+
+	return map;
+}
+
+static void htab_timeout_map_free(struct bpf_map *map)
+{
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+
+	cancel_delayed_work_sync(&htab->gc_idle_work);
+	cancel_work_sync(&htab->gc_work);
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
index 287be337d5f6..9ebd2e380a57 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -778,7 +778,8 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
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
index 77d7c1bb2923..29f5d0b5147a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -158,6 +158,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_RINGBUF,
 	BPF_MAP_TYPE_INODE_STORAGE,
 	BPF_MAP_TYPE_TASK_STORAGE,
+	BPF_MAP_TYPE_TIMEOUT_HASH,
 };
 
 /* Note that tracing related programs such as
-- 
2.25.1

