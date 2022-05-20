Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28D952F1DB
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352313AbiETRqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352333AbiETRqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:46:33 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C8A2558B;
        Fri, 20 May 2022 10:46:31 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id c1so7417074qkf.13;
        Fri, 20 May 2022 10:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TXuLbv6Ud795AX77Sr1OVy5bwjzT4t+80fcrTgW6BKU=;
        b=pd/S3rnTcdn5yJXkHH9w/8Q+C6c/rL2UBqTStS/toUsV3jQnsPuv6Pqap0/FEtNamf
         wnb19eJpa3NI8HT7zPrgMS9oiJImgxyLv/n0gN3PkzS7OX2HYNW2rmpufHfclKjHyWGL
         K+Y7TwkvV8NLddTxLmxyweKtp2yo4CIUbP9+3R9HPzbgtW+eeQk03AS5X1V5dooM82DM
         6C3pcFllrUz2zzomyhZ3kwcUqUNgPs7cLI6iQVFAZ5sP0xOnb0juqn11e9Ga/uVu0CxT
         I/j38F4hvVcjpLWSdJ7PkRywE0OVYtAh4RbF4oHtPf5ctg2YAcK1Ajs/xcKI/diYn9gM
         4VMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TXuLbv6Ud795AX77Sr1OVy5bwjzT4t+80fcrTgW6BKU=;
        b=aHKrwQcKDvPKrt3YLcfF/3JYkGSl1kLjDDM7Osj54aS2X60UDw+/nM0DEDHXNGcJaS
         SeG7XmIJNxZsT8SK3gv2RGRM//LYe3LCWkvEQbmymOyCsJ6Mu9NaqI2bU3techx2QRu6
         pxFbF2GHiJtXgyQVHxdws1YreeX3BQXbvGgHIF7CzlKhKYWXwN3cLQZ0Kx1SajWgiWFh
         z5ZdSRRDQzvHIFiQ568lhx7TAcarav6YRkwp17xgFWctyIJboSJhECMolAPXJqHqNT7y
         6t8UDnSq6CK9y96lGFjE+hVloNiOQ4WC8X5NamJPgnXhlKDCwrISW642La4niAk/R7fA
         jAFA==
X-Gm-Message-State: AOAM531KfK3w/cbT0r3mOttw0kx/PvE+4mKGO2QYy4Il0mz1S9xmIDVs
        3jp3Jtu9x9cZXMqDgmaJQAVhvhWMjWs=
X-Google-Smtp-Source: ABdhPJzqDoMfU3MeEMpIL2slD8UlropeGsUMbeexsnlo6hNhzeZUaX65uKSSp4OQadB7NBuko3kvQA==
X-Received: by 2002:a37:aacf:0:b0:6a3:3c4b:45b6 with SMTP id t198-20020a37aacf000000b006a33c4b45b6mr5255795qke.354.1653068790661;
        Fri, 20 May 2022 10:46:30 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2d11:2a88:f2b2:bee0])
        by smtp.gmail.com with ESMTPSA id cn4-20020a05622a248400b002f91849bf20sm62747qtb.36.2022.05.20.10.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 10:46:30 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, jiri@resnulli.us, toke@redhat.com,
        bpf@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [RFC Patch v4 1/2] bpf: introduce skb map
Date:   Fri, 20 May 2022 10:46:15 -0700
Message-Id: <20220520174616.74684-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220520174616.74684-1-xiyou.wangcong@gmail.com>
References: <20220520174616.74684-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skbuff.h |   4 +-
 kernel/bpf/Makefile    |   2 +-
 kernel/bpf/skb_map.c   | 337 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 341 insertions(+), 2 deletions(-)
 create mode 100644 kernel/bpf/skb_map.c

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dc4b3e1cf21b..7fa893008a64 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -931,7 +931,9 @@ struct sk_buff {
 				unsigned long		dev_scratch;
 			};
 		};
-		struct rb_node		rbnode; /* used in netem, ip4 defrag, and tcp stack */
+		struct rb_node		rbnode; /* used in eBPF skb map, netem, ip4 defrag, and tcp
+						 * stack
+						 */
 		struct list_head	list;
 		struct llist_node	ll_node;
 	};
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 057ba8e01e70..37183df5b3ba 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -8,7 +8,7 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o link_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
-obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
+obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o skb_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
 obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
diff --git a/kernel/bpf/skb_map.c b/kernel/bpf/skb_map.c
new file mode 100644
index 000000000000..76be35ebc463
--- /dev/null
+++ b/kernel/bpf/skb_map.c
@@ -0,0 +1,337 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * skb_map.c: BPF skb queue map
+ *
+ * Copyright (C) 2022, Bytedance, Cong Wang <cong.wang@bytedance.com>
+ */
+#include <linux/bpf.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/capability.h>
+#include <linux/rbtree.h>
+#include <linux/btf_ids.h>
+#include <linux/filter.h>
+#include <net/sch_generic.h>
+
+#define SKB_MAP_CREATE_FLAG_MASK \
+	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK)
+
+struct bpf_skb_map {
+	struct bpf_map map;
+	struct rb_root root;
+	raw_spinlock_t lock;
+	struct list_head list;
+	atomic_t count;
+};
+
+struct skb_map_cb {
+	struct qdisc_skb_cb qdisc_cb;
+	u64 rank;
+};
+
+static struct skb_map_cb *skb_map_cb(const struct sk_buff *skb)
+{
+        struct skb_map_cb *cb = (struct skb_map_cb *)skb->cb;
+
+        BUILD_BUG_ON(sizeof(*cb) > sizeof_field(struct sk_buff, cb));
+        return cb;
+}
+
+static DEFINE_SPINLOCK(skb_map_lock);
+static LIST_HEAD(skb_map_list);
+
+static struct bpf_skb_map *bpf_skb_map(struct bpf_map *map)
+{
+	return container_of(map, struct bpf_skb_map, map);
+}
+
+#define SKB_MAP_MAX_SZ 2048
+
+/* Called from syscall */
+static int skb_map_alloc_check(union bpf_attr *attr)
+{
+	if (!bpf_capable())
+		return -EPERM;
+
+	/* check sanity of attributes */
+	if (attr->max_entries == 0 || attr->key_size != 8 ||
+	    attr->value_size != 0 ||
+	    attr->map_flags & ~SKB_MAP_CREATE_FLAG_MASK ||
+	    !bpf_map_flags_access_ok(attr->map_flags))
+		return -EINVAL;
+
+	if (attr->value_size > KMALLOC_MAX_SIZE)
+		/* if value_size is bigger, the user space won't be able to
+		 * access the elements.
+		 */
+		return -E2BIG;
+
+	if (attr->max_entries > SKB_MAP_MAX_SZ)
+		return -E2BIG;
+
+	return 0;
+}
+
+static struct bpf_map *skb_map_alloc(union bpf_attr *attr)
+{
+	int numa_node = bpf_map_attr_numa_node(attr);
+	struct bpf_skb_map *rb;
+
+	rb = bpf_map_area_alloc(sizeof(*rb), numa_node);
+	if (!rb)
+		return ERR_PTR(-ENOMEM);
+
+	memset(rb, 0, sizeof(*rb));
+	bpf_map_init_from_attr(&rb->map, attr);
+	raw_spin_lock_init(&rb->lock);
+	rb->root = RB_ROOT;
+	atomic_set(&rb->count, 0);
+	spin_lock(&skb_map_lock);
+	list_add_tail_rcu(&rb->list, &skb_map_list);
+	spin_unlock(&skb_map_lock);
+	return &rb->map;
+}
+
+static void skb_map_free(struct bpf_map *map)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+
+	spin_lock(&skb_map_lock);
+	list_del_rcu(&rb->list);
+	spin_unlock(&skb_map_lock);
+	skb_rbtree_purge(&rb->root);
+	bpf_map_area_free(rb);
+}
+
+static struct sk_buff *skb_rb_find(struct rb_root *root, u64 rank)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct sk_buff *skb1;
+
+	while (*p) {
+		parent = *p;
+		skb1 = rb_to_skb(parent);
+		if (rank < skb_map_cb(skb1)->rank)
+			p = &parent->rb_left;
+		else if (rank > skb_map_cb(skb1)->rank)
+			p = &parent->rb_right;
+		else
+			return skb1;
+	}
+	return NULL;
+}
+
+/* Called from syscall */
+static void *skb_map_lookup_elem_sys(struct bpf_map *map, void *key)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+
+/* Called from eBPF program */
+static void *skb_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+	u64 rank = *(u64 *) key;
+
+	return skb_rb_find(&rb->root, rank);
+}
+
+/* Called from syscall or from eBPF program */
+static int skb_map_update_elem(struct bpf_map *map, void *key, void *value,
+			       u64 flags)
+{
+	return -ENOTSUPP;
+}
+
+/* Called from syscall or from eBPF program */
+static int skb_map_delete_elem(struct bpf_map *map, void *key)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+	u64 rank = *(u64 *) key;
+	struct sk_buff *skb;
+
+	skb = skb_rb_find(&rb->root, rank);
+	if (!skb)
+		return -ENOENT;
+	rb_erase(&skb->rbnode, &rb->root);
+	consume_skb(skb);
+	return 0;
+}
+
+/* Called from syscall */
+static int skb_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+	struct sk_buff *skb;
+	u64 rank;
+
+	if (!key) {
+		skb = skb_rb_first(&rb->root);
+		if (!skb)
+			return -ENOENT;
+	}
+	rank = *(u64 *) key;
+	skb = skb_rb_find(&rb->root, rank);
+	if (!skb)
+		return -ENOENT;
+	skb = skb_rb_next(skb);
+	if (!skb)
+		return 0;
+	*(u64 *) next_key = skb_map_cb(skb)->rank;
+	return 0;
+}
+
+static int bpf_for_each_skb_map(struct bpf_map *map, bpf_callback_t callback_fn,
+				void *callback_ctx, u64 flags)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+	struct sk_buff *skb;
+	u32 num_elems = 0;
+	u64 ret = 0;
+	u64 key;
+
+	if (flags != 0)
+		return -EINVAL;
+
+	skb_rbtree_walk(skb, &rb->root) {
+		num_elems++;
+		key = skb_map_cb(skb)->rank;
+		ret = callback_fn((u64)(long)map, (u64)(long)&key,
+				  (u64)(long)skb, (u64)(long)callback_ctx, 0);
+		/* return value: 0 - continue, 1 - stop and return */
+		if (ret)
+			break;
+	}
+
+	return num_elems;
+}
+
+BTF_ID_LIST_SINGLE(skb_map_btf_ids, struct, bpf_skb_map)
+const struct bpf_map_ops skb_map_ops = {
+	.map_meta_equal = bpf_map_meta_equal,
+	.map_alloc_check = skb_map_alloc_check,
+	.map_alloc = skb_map_alloc,
+	.map_free = skb_map_free,
+	.map_lookup_elem_sys_only = skb_map_lookup_elem_sys,
+	.map_lookup_elem = skb_map_lookup_elem,
+	.map_update_elem = skb_map_update_elem,
+	.map_delete_elem = skb_map_delete_elem,
+	.map_get_next_key = skb_map_get_next_key,
+	.map_set_for_each_callback_args = map_set_for_each_callback_args,
+	.map_for_each_callback = bpf_for_each_skb_map,
+	.map_btf_id = &skb_map_btf_ids[0],
+};
+
+static void skb_rb_push(struct rb_root *root, struct sk_buff *skb)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct sk_buff *skb1;
+
+	while (*p) {
+		parent = *p;
+		skb1 = rb_to_skb(parent);
+		if (skb_map_cb(skb)->rank < skb_map_cb(skb1)->rank)
+			p = &parent->rb_left;
+		else
+			p = &parent->rb_right;
+	}
+	rb_link_node(&skb->rbnode, parent, p);
+	rb_insert_color(&skb->rbnode, root);
+}
+
+BPF_CALL_2(bpf_skb_map_pop, struct bpf_map *, map, u64, key)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+	struct sk_buff *skb;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&rb->lock, flags);
+	skb = skb_map_lookup_elem(map, &key);
+	if (!skb) {
+		raw_spin_unlock_irqrestore(&rb->lock, flags);
+		return (unsigned long)NULL;
+	}
+	rb_erase(&skb->rbnode, &rb->root);
+	raw_spin_unlock_irqrestore(&rb->lock, flags);
+	consume_skb(skb);
+	atomic_dec(&rb->count);
+	return (unsigned long)skb;
+}
+
+static const struct bpf_func_proto bpf_skb_map_pop_proto = {
+	.func		= bpf_skb_map_pop,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_3(bpf_skb_map_push, struct bpf_map *, map, struct sk_buff *, skb, u64, key)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+	unsigned long flags;
+
+	if (atomic_inc_return(&rb->count) > rb->map.max_entries)
+		return -ENOBUFS;
+	skb = skb_get(skb);
+	skb_map_cb(skb)->rank = key;
+	raw_spin_lock_irqsave(&rb->lock, flags);
+	skb_rb_push(&rb->root, skb);
+	raw_spin_unlock_irqrestore(&rb->lock, flags);
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_skb_map_push_proto = {
+	.func		= bpf_skb_map_push,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_PTR_TO_CTX,
+	.arg3_type	= ARG_ANYTHING,
+};
+
+static void skb_map_flush(struct bpf_skb_map *rb, struct net_device *dev)
+{
+	struct rb_node *p = rb_first(&rb->root);
+
+	while (p) {
+		struct sk_buff *skb = rb_entry(p, struct sk_buff, rbnode);
+
+		p = rb_next(p);
+		if (skb->dev == dev) {
+			rb_erase(&skb->rbnode, &rb->root);
+			kfree_skb(skb);
+		}
+	}
+}
+
+static int skb_map_notification(struct notifier_block *notifier,
+				ulong event, void *ptr)
+{
+	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
+	struct bpf_skb_map *rb;
+
+        switch (event) {
+        case NETDEV_DOWN:
+		rcu_read_lock();
+		list_for_each_entry_rcu(rb, &skb_map_list, list)
+			skb_map_flush(rb, netdev);
+		rcu_read_unlock();
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block skb_map_notifier = {
+	.notifier_call = skb_map_notification,
+};
+
+static int __init skb_map_init(void)
+{
+	return register_netdevice_notifier(&skb_map_notifier);
+}
+
+subsys_initcall(skb_map_init);
-- 
2.34.1

