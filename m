Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309E22D6C5C
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393251AbgLKAHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 19:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392426AbgLKAHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 19:07:42 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF113C0613D6;
        Thu, 10 Dec 2020 16:07:01 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id j20so2218177otq.5;
        Thu, 10 Dec 2020 16:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=byahYWB7qjFznv1spWwK8M+hGcqi2rtCztH+uhLiY+E=;
        b=LO88xglvSrL92/K6f2/QdkZumvYwoNOOy+QkDfzyePZ+ZfQ2CoujLiFR+/9OkDAnjM
         eER882GofXyXPweNm+P+IPuUp0P3w01lh9DCMpSUDD0KcDlg23SR5OlbD/zKQ4f1/1xW
         SJpPUQV3Nw2/Lr3b3IGhM4OkStwSsGc9KW3vjyWIy+HXx78H/d9kua22wak2l690TnbT
         MdAur8hIfDjqjkc2YRI/V+CT6XRtVaDKy6XaWB8DgogVLp38Db/xdBuY6hrY1lMWwyIU
         ddgqX92hlX5x7PXsM6LlHdVpH9P+bH0clgS19ph0nF2eNv1cBGtLEUKkmTIlYzQawfBW
         bT2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=byahYWB7qjFznv1spWwK8M+hGcqi2rtCztH+uhLiY+E=;
        b=M8OvZCEVJTqIF4qRMiDzqpFrZRtPfEeQuuUIeaiWkA3TCM9Bid+vmg+E93uuzBEvKm
         ulHpnxBSubBawGF0nmA1PSgSBdELlMih1v4egGgO6jMIT+9xBxDmhGl3EKv5ZVpURXqc
         b0HxB256sxT6VasQvv58PcNOA/RG+QXY0qsCIpNNkU7Hb0kEE5XpwMUcJ5m6K4Po5JM4
         E4GZ3cG+s374umtcqfb04e69dYd9PLUymkGD5ZS8mTddVqEvvsK1SKhraXyD/gXEGE2F
         rJEK4C9QIrentVhE5ir9MGnIQ3UTkyWIxYXZeJPPDUUJCO8W6H+VqX5MLMq9X39sPdVb
         GC+w==
X-Gm-Message-State: AOAM533lmG+v/VSuxSuTKDa5db0RdSEMY9W6z54LkxvN8rgF8+jm+yW6
        dCmDiQ1hR+3lcj2Nfa9cWRJps2YEDc7hhg==
X-Google-Smtp-Source: ABdhPJwxzrPBw2VTww/661v8/B8mc0yLL5o7nYsHCaJacG/KYF55sWwJcT5j+h2zM+djhoDEImp64Q==
X-Received: by 2002:a9d:6017:: with SMTP id h23mr4619886otj.355.1607645221048;
        Thu, 10 Dec 2020 16:07:01 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4819:cc94:4d6e:dad2])
        by smtp.gmail.com with ESMTPSA id l21sm1543570otd.0.2020.12.10.16.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 16:07:00 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next 2/3] bpf: introduce timeout map
Date:   Thu, 10 Dec 2020 16:06:48 -0800
Message-Id: <20201211000649.236635-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211000649.236635-1-xiyou.wangcong@gmail.com>
References: <20201211000649.236635-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This borrows the idea from conntrack and will be used for conntrack in
bpf too. Each element in a timeout map has a user-specified timeout
in secs, after it expires it will be automatically removed from the map.

There are two cases here:

1. When the timeout map is idle, that is, no one updates or accesses it,
   we rely on the idle work to scan the whole hash table and remove
   these expired. The idle work is scheduled every 1 sec.

2. When the timeout map is actively accessed, we could reach expired
   elements before the idle work kicks in, we can simply skip them and
   schedule another work to do the actual removal work. We avoid taking
   locks on fast path.

The timeout of each element can be set or updated via bpf_map_update_elem()
and we reuse the upper 32-bit of the 64-bit flag for the timeout value.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf_types.h      |   1 +
 include/uapi/linux/bpf.h       |   3 +-
 kernel/bpf/hashtab.c           | 239 ++++++++++++++++++++++++++++++++-
 kernel/bpf/syscall.c           |   3 +-
 tools/include/uapi/linux/bpf.h |   1 +
 5 files changed, 243 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 99f7fd657d87..901c4e01d726 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -90,6 +90,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_TIMEOUT_HASH, htab_timeout_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_HASH, htab_percpu_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_LRU_HASH, htab_lru_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_LRU_PERCPU_HASH, htab_lru_percpu_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 30b477a26482..dedb47bc3f52 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -158,6 +158,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_RINGBUF,
 	BPF_MAP_TYPE_INODE_STORAGE,
 	BPF_MAP_TYPE_TASK_STORAGE,
+	BPF_MAP_TYPE_TIMEOUT_HASH,
 };
 
 /* Note that tracing related programs such as
@@ -393,7 +394,7 @@ enum bpf_link_type {
  */
 #define BPF_PSEUDO_CALL		1
 
-/* flags for BPF_MAP_UPDATE_ELEM command */
+/* flags for BPF_MAP_UPDATE_ELEM command, upper 32 bits are timeout */
 enum {
 	BPF_ANY		= 0, /* create new element or update existing */
 	BPF_NOEXIST	= 1, /* create new element if it didn't exist */
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index f0b7b54fa3a8..1f2bad82d52b 100644
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
@@ -84,6 +86,8 @@ struct bucket {
 		raw_spinlock_t raw_lock;
 		spinlock_t     lock;
 	};
+	struct llist_node gc_node;
+	atomic_t pending;
 };
 
 #define HASHTAB_MAP_LOCK_COUNT 8
@@ -104,6 +108,9 @@ struct bpf_htab {
 	u32 hashrnd;
 	struct lock_class_key lockdep_key;
 	int __percpu *map_locked[HASHTAB_MAP_LOCK_COUNT];
+	struct llist_head gc_list;
+	struct work_struct gc_work;
+	struct delayed_work gc_idle_work;
 };
 
 /* each htab element is struct htab_elem + key + value */
@@ -124,6 +131,7 @@ struct htab_elem {
 		struct bpf_lru_node lru_node;
 	};
 	u32 hash;
+	u64 expires;
 	char key[] __aligned(8);
 };
 
@@ -143,6 +151,7 @@ static void htab_init_buckets(struct bpf_htab *htab)
 
 	for (i = 0; i < htab->n_buckets; i++) {
 		INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
+		atomic_set(&htab->buckets[i].pending, 0);
 		if (htab_use_raw_lock(htab)) {
 			raw_spin_lock_init(&htab->buckets[i].raw_lock);
 			lockdep_set_class(&htab->buckets[i].raw_lock,
@@ -431,12 +440,24 @@ static int htab_map_alloc_check(union bpf_attr *attr)
 	return 0;
 }
 
+static void htab_sched_gc(struct bpf_htab *htab, struct bucket *b)
+{
+	if (atomic_fetch_or(1, &b->pending))
+		return;
+	llist_add(&b->gc_node, &htab->gc_list);
+	queue_work(system_unbound_wq, &htab->gc_work);
+}
+
+static void htab_gc(struct work_struct *work);
+static void htab_gc_idle(struct work_struct *work);
+
 static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 {
 	bool percpu = (attr->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
 		       attr->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH);
 	bool lru = (attr->map_type == BPF_MAP_TYPE_LRU_HASH ||
 		    attr->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH);
+	bool timeout = attr->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
 	/* percpu_lru means each cpu has its own LRU list.
 	 * it is different from BPF_MAP_TYPE_PERCPU_HASH where
 	 * the map's value itself is percpu.  percpu_lru has
@@ -521,6 +542,14 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 		}
 	}
 
+	if (timeout) {
+		init_llist_head(&htab->gc_list);
+		INIT_WORK(&htab->gc_work, htab_gc);
+		INIT_DEFERRABLE_WORK(&htab->gc_idle_work, htab_gc_idle);
+		queue_delayed_work(system_power_efficient_wq, &htab->gc_idle_work,
+				   HZ);
+	}
+
 	return &htab->map;
 
 free_prealloc:
@@ -732,10 +761,13 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
 static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	bool is_timeout = map->map_type == BPF_MAP_TYPE_TIMEOUT_HASH;
 	struct hlist_nulls_head *head;
 	struct htab_elem *l, *next_l;
 	u32 hash, key_size;
+	struct bucket *b;
 	int i = 0;
+	u64 now;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
@@ -746,7 +778,8 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 
 	hash = htab_map_hash(key, key_size, htab->hashrnd);
 
-	head = select_bucket(htab, hash);
+	b = __select_bucket(htab, hash);
+	head = &b->head;
 
 	/* lookup the key */
 	l = lookup_nulls_elem_raw(head, hash, key, key_size, htab->n_buckets);
@@ -759,6 +792,13 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 				  struct htab_elem, hash_node);
 
 	if (next_l) {
+		if (is_timeout) {
+			now = get_jiffies_64();
+			if (time_after_eq64(now, next_l->expires)) {
+				htab_sched_gc(htab, b);
+				goto find_first_elem;
+			}
+		}
 		/* if next elem in this hash list is non-zero, just return it */
 		memcpy(next_key, next_l->key, key_size);
 		return 0;
@@ -771,12 +811,20 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 find_first_elem:
 	/* iterate over buckets */
 	for (; i < htab->n_buckets; i++) {
-		head = select_bucket(htab, i);
+		b = __select_bucket(htab, i);
+		head = &b->head;
 
 		/* pick first element in the bucket */
 		next_l = hlist_nulls_entry_safe(rcu_dereference_raw(hlist_nulls_first_rcu(head)),
 					  struct htab_elem, hash_node);
 		if (next_l) {
+			if (is_timeout) {
+				now = get_jiffies_64();
+				if (time_after_eq64(now, next_l->expires)) {
+					htab_sched_gc(htab, b);
+					continue;
+				}
+			}
 			/* if it's not empty, just return it */
 			memcpy(next_key, next_l->key, key_size);
 			return 0;
@@ -975,18 +1023,31 @@ static int check_flags(struct bpf_htab *htab, struct htab_elem *l_old,
 	return 0;
 }
 
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
+	u64 now;
 	int ret;
 
+	timeout = fetch_timeout(&map_flags);
+
 	if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
 		/* unknown flags */
 		return -EINVAL;
@@ -1042,6 +1103,10 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		copy_map_value_locked(map,
 				      l_old->key + round_up(key_size, 8),
 				      value, false);
+		if (timeout_map) {
+			now = get_jiffies_64();
+			l_old->expires = now + HZ * timeout;
+		}
 		ret = 0;
 		goto err;
 	}
@@ -1054,6 +1119,13 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		goto err;
 	}
 
+	if (timeout_map) {
+		now = get_jiffies_64();
+		if (l_old && time_after_eq64(now, l_old->expires))
+			htab_sched_gc(htab, b);
+		l_new->expires = now + HZ * timeout;
+	}
+
 	/* add new element to the head of the list, so that
 	 * concurrent search will find it before old elem
 	 */
@@ -2180,3 +2252,166 @@ const struct bpf_map_ops htab_of_maps_map_ops = {
 	.map_btf_name = "bpf_htab",
 	.map_btf_id = &htab_of_maps_map_btf_id,
 };
+
+static void __htab_gc_bucket(struct bpf_htab *htab, struct bucket *b)
+{
+	struct hlist_nulls_head *head = &b->head;
+	struct hlist_nulls_node *n;
+	u64 now = get_jiffies_64();
+	struct htab_elem *l;
+
+	hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
+		if (time_after_eq64(now, l->expires)) {
+			hlist_nulls_del_rcu(&l->hash_node);
+			free_htab_elem(htab, l);
+		}
+	}
+}
+
+static void htab_gc(struct work_struct *work)
+{
+	struct llist_node *head;
+	struct bpf_htab *htab;
+	struct bucket *b, *n;
+
+	htab = container_of(work, struct bpf_htab, gc_work);
+	head = llist_del_all(&htab->gc_list);
+
+	llist_for_each_entry_safe(b, n, head, gc_node) {
+		unsigned long flags;
+		int ret;
+
+		ret = htab_lock_bucket(htab, b, &flags);
+		if (ret)
+			continue;
+		__htab_gc_bucket(htab, b);
+		htab_unlock_bucket(htab, b, flags);
+
+		atomic_set(&b->pending, 0);
+
+		cond_resched();
+	}
+}
+
+static void htab_gc_idle(struct work_struct *work)
+{
+	struct bpf_htab *htab;
+	int i;
+
+	htab = container_of(work, struct bpf_htab, gc_idle_work.work);
+
+	for (i = 0; i < htab->n_buckets; i++) {
+		unsigned long flags;
+		struct bucket *b;
+		int ret;
+
+		b = __select_bucket(htab, i);
+		if (hlist_nulls_empty(&b->head))
+			continue;
+		if (atomic_read(&b->pending))
+			continue;
+		ret = htab_lock_bucket(htab, b, &flags);
+		if (ret)
+			continue;
+		__htab_gc_bucket(htab, b);
+		htab_unlock_bucket(htab, b, flags);
+		cond_resched();
+	}
+
+	queue_delayed_work(system_power_efficient_wq, &htab->gc_idle_work, HZ);
+}
+
+static void *__htab_timeout_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	struct hlist_nulls_head *head;
+	struct htab_elem *l;
+	struct bucket *b;
+	u32 key_size = map->key_size;
+	u32 hash;
+
+	hash = htab_map_hash(key, key_size, htab->hashrnd);
+	b = __select_bucket(htab, hash);
+	head = &b->head;
+
+	l = lookup_nulls_elem_raw(head, hash, key, key_size, htab->n_buckets);
+	if (l && time_after_eq64(get_jiffies_64(), l->expires)) {
+		htab_sched_gc(htab, b);
+		l = NULL;
+	}
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
+static void htab_timeout_map_free(struct bpf_map *map)
+{
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+
+	cancel_work_sync(&htab->gc_work);
+	cancel_delayed_work_sync(&htab->gc_idle_work);
+
+	htab_map_free(map);
+}
+
+static int htab_timeout_map_btf_id;
+const struct bpf_map_ops htab_timeout_map_ops = {
+	.map_meta_equal = bpf_map_meta_equal,
+	.map_alloc_check = htab_map_alloc_check,
+	.map_alloc = htab_map_alloc,
+	.map_free = htab_timeout_map_free,
+	.map_get_next_key = htab_map_get_next_key,
+	.map_lookup_elem = htab_timeout_map_lookup_elem,
+	.map_update_elem = htab_map_update_elem,
+	.map_delete_elem = htab_map_delete_elem,
+	.map_gen_lookup = htab_timeout_map_gen_lookup,
+	.map_seq_show_elem = htab_timeout_map_seq_show_elem,
+	BATCH_OPS(htab),
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
index 30b477a26482..684b8011a97a 100644
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

