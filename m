Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155CF47F0DA
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 21:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353493AbhLXUBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 15:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353492AbhLXUBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 15:01:32 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D337C061401;
        Fri, 24 Dec 2021 12:01:32 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id t204so9124676oie.7;
        Fri, 24 Dec 2021 12:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/k6OhpL0e3iy4Zkc10zUKX8jiwNILPVxZbB6rCxTz9c=;
        b=BPN616yTBnZPKGiFBsV1RxoCPz7W4cDXPtujCXmu98MiC6KYEArt8Mhgz0lwitnuxy
         H/OHO7TdHvhrmM4NKxlK3wiD/FCodTrnh9pTsWKQgItjvvt/NPPH8Oi1QA/ey0LQFbpb
         qiOwQsQmQfjRZRj8x1IVPlYXLpduGu5pZ30yadDUduxrGCZAUfUoEKJ/bq1pga9dE5LC
         NhwXSnEj80OZqHzCRDNiQ7Yx9+lsoAuuoNScwMOsh6Y5V2QioFMfzFVz6o4lSJgn7Ylr
         JNw4WbH9uJ3zIb+SRcVby7qRz9agkRDud3ItxVyJ5lCNRnB+3oBUFHozogUzLtqGj9Hp
         nKwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/k6OhpL0e3iy4Zkc10zUKX8jiwNILPVxZbB6rCxTz9c=;
        b=D6SGYW1PUsslGvb8X7e/v509l0Cos3zqOWK839pxq1DZRsyo4W8xrlhlIDBbNCoFtJ
         yMFzy7nI/vZjncuybLDOav5YokFYFKFQk/SJE5TDygln14m6SgBo+yKGg7oh16NxJM4l
         Y8dtQF9pp/elLwvAe3YpWUqrolgpVVFhGviR8P7BcoAes8grRlIN+d2GLExuLV6TOgrg
         Zt9Y0MtzEtS9Am0p7oqJk7efOnL+R5tswRA/bQtVk60Lx6fngMDO/w03gijglHyz3lBr
         JNMQiEDqrHWeOu5Vf8gdKjNsPbVdmvBZ8Ou4iVx1gxmhym99kHzacF8rSuoIrHfUzAsq
         4KMg==
X-Gm-Message-State: AOAM532RSoYMm7ueCSdNa8veNxLXotQhbbOalsp9tii9jwHGjO9Tzsp1
        tfX8cvUopNFEniSbIprwq5bp5BJ6mWE=
X-Google-Smtp-Source: ABdhPJx3In5M+bwr44WAPvlURpFLLSqECakgU+zfP5EgpQIyHQwR4JS0GetnWZvd1dRMyEMz/WQUFA==
X-Received: by 2002:a05:6808:118a:: with SMTP id j10mr6129801oil.101.1640376091549;
        Fri, 24 Dec 2021 12:01:31 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:b326:fb0b:9894:47a6])
        by smtp.gmail.com with ESMTPSA id o2sm1865506oik.11.2021.12.24.12.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Dec 2021 12:01:31 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [RFC Patch v3 2/3] bpf: introduce skb map
Date:   Fri, 24 Dec 2021 12:00:58 -0800
Message-Id: <20211224200059.161979-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211224200059.161979-1-xiyou.wangcong@gmail.com>
References: <20211224200059.161979-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skbuff.h |   2 +
 kernel/bpf/Makefile    |   2 +-
 kernel/bpf/skb_map.c   | 244 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 247 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/skb_map.c

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6535294f6a48..d52b39f43ae9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -37,6 +37,7 @@
 #include <linux/in6.h>
 #include <linux/if_packet.h>
 #include <linux/llist.h>
+#include <linux/priority_queue.h>
 #include <net/flow.h>
 #include <net/page_pool.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -746,6 +747,7 @@ struct sk_buff {
 			};
 		};
 		struct rb_node		rbnode; /* used in netem, ip4 defrag, and tcp stack */
+		struct pq_node		pqnode; /* used in eBPF skb map */
 		struct list_head	list;
 		struct llist_node	ll_node;
 	};
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index c1a9be6a4b9f..3f736af1da9c 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -8,7 +8,7 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
-obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
+obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o skb_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
 obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
diff --git a/kernel/bpf/skb_map.c b/kernel/bpf/skb_map.c
new file mode 100644
index 000000000000..e022ade2ac61
--- /dev/null
+++ b/kernel/bpf/skb_map.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * skb_map.c: BPF skb queue map
+ *
+ * Copyright (C) 2021, Bytedance, Cong Wang <cong.wang@bytedance.com>
+ */
+#include <linux/bpf.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/capability.h>
+#include <linux/priority_queue.h>
+
+#define SKB_MAP_CREATE_FLAG_MASK \
+	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK)
+
+struct bpf_skb_map {
+	struct bpf_map map;
+	struct pq_root root;
+	raw_spinlock_t lock;
+	struct list_head list;
+	atomic_t count;
+};
+
+struct skb_map_node {
+	struct pq_node node;
+	u64 key;
+	struct sk_buff *skb;
+};
+
+static DEFINE_SPINLOCK(skb_map_lock);
+static LIST_HEAD(skb_map_list);
+
+static struct bpf_skb_map *bpf_skb_map(struct bpf_map *map)
+{
+	return container_of(map, struct bpf_skb_map, map);
+}
+
+#define SKB_MAP_MAX_SZ 1024
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
+static bool skb_map_cmp(struct pq_node *l, struct pq_node *r)
+{
+	struct skb_map_node *lnode, *rnode;
+
+	lnode = container_of(l, struct skb_map_node, node);
+	rnode = container_of(r, struct skb_map_node, node);
+
+	return lnode->key < rnode->key;
+}
+
+static struct bpf_map *skb_map_alloc(union bpf_attr *attr)
+{
+	int numa_node = bpf_map_attr_numa_node(attr);
+	struct bpf_skb_map *pq;
+
+	pq = bpf_map_area_alloc(sizeof(*pq), numa_node);
+	if (!pq)
+		return ERR_PTR(-ENOMEM);
+
+	memset(pq, 0, sizeof(*pq));
+	bpf_map_init_from_attr(&pq->map, attr);
+	raw_spin_lock_init(&pq->lock);
+	pq_root_init(&pq->root, skb_map_cmp);
+	atomic_set(&pq->count, 0);
+	spin_lock(&skb_map_lock);
+	list_add_tail_rcu(&pq->list, &skb_map_list);
+	spin_unlock(&skb_map_lock);
+	return &pq->map;
+}
+
+static void skb_flush(struct pq_node *n)
+{
+	struct sk_buff *skb = container_of(n, struct sk_buff, pqnode);
+
+	kfree_skb(skb);
+}
+
+static void skb_map_free(struct bpf_map *map)
+{
+	struct bpf_skb_map *pq = bpf_skb_map(map);
+
+	spin_lock(&skb_map_lock);
+	list_del_rcu(&pq->list);
+	spin_unlock(&skb_map_lock);
+	pq_flush(&pq->root, skb_flush);
+	bpf_map_area_free(pq);
+}
+
+static struct skb_map_node *alloc_skb_map_node(struct bpf_skb_map *pq)
+{
+	return bpf_map_kmalloc_node(&pq->map, sizeof(struct skb_map_node),
+				     GFP_ATOMIC | __GFP_NOWARN,
+				     pq->map.numa_node);
+}
+
+/* Called from syscall or from eBPF program */
+static void *skb_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	return ERR_PTR(-ENOTSUPP);
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
+	return -ENOTSUPP;
+}
+
+/* Called from syscall */
+static int skb_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
+{
+	return -ENOTSUPP;
+}
+
+static int skb_map_btf_id;
+const struct bpf_map_ops skb_queue_map_ops = {
+	.map_meta_equal = bpf_map_meta_equal,
+	.map_alloc_check = skb_map_alloc_check,
+	.map_alloc = skb_map_alloc,
+	.map_free = skb_map_free,
+	.map_lookup_elem = skb_map_lookup_elem,
+	.map_update_elem = skb_map_update_elem,
+	.map_delete_elem = skb_map_delete_elem,
+	.map_get_next_key = skb_map_get_next_key,
+	.map_btf_name = "bpf_skb_map",
+	.map_btf_id = &skb_map_btf_id,
+};
+
+int skb_map_enqueue(struct sk_buff *skb, struct bpf_map *map, u64 key)
+{
+	struct bpf_skb_map *pq = bpf_skb_map(map);
+	struct skb_map_node *n;
+	unsigned long flags;
+
+	if (atomic_inc_return(&pq->count) > pq->map.max_entries)
+		return -ENOBUFS;
+	n = alloc_skb_map_node(pq);
+	if (!n)
+		return -ENOMEM;
+	n->key = key;
+	n->skb = skb_get(skb);
+	raw_spin_lock_irqsave(&pq->lock, flags);
+	pq_push(&pq->root, &n->node);
+	raw_spin_unlock_irqrestore(&pq->lock, flags);
+	return 0;
+
+}
+
+struct sk_buff *skb_map_dequeue(struct bpf_map *map)
+{
+	struct bpf_skb_map *pq = bpf_skb_map(map);
+	struct skb_map_node *n;
+	struct pq_node *node;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&pq->lock, flags);
+	node = pq_pop(&pq->root);
+	if (!node) {
+		raw_spin_unlock_irqrestore(&pq->lock, flags);
+		return NULL;
+	}
+	raw_spin_unlock_irqrestore(&pq->lock, flags);
+	n = container_of(node, struct skb_map_node, node);
+	consume_skb(n->skb);
+	atomic_dec(&pq->count);
+	return n->skb;
+}
+
+static void skb_map_flush(struct bpf_skb_map *pq, struct net_device *dev)
+{
+	struct pq_root *root = &pq->root;
+	struct rb_node *node, *next;
+
+	for (node = rb_first(&root->rb_root.rb_root);
+	     next = node ? rb_next(node) : NULL, node != NULL;
+	     node = next) {
+		struct pq_node *pqe;
+		struct sk_buff *skb;
+
+		pqe = rb_entry(node, struct pq_node, rb_node);
+		skb = container_of(pqe, struct sk_buff, pqnode);
+		if (skb->dev == dev)
+			kfree_skb(skb);
+        }
+}
+
+static int skb_map_notification(struct notifier_block *notifier,
+				ulong event, void *ptr)
+{
+	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
+	struct bpf_skb_map *pq;
+
+        switch (event) {
+        case NETDEV_DOWN:
+		rcu_read_lock();
+		list_for_each_entry_rcu(pq, &skb_map_list, list)
+			skb_map_flush(pq, netdev);
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
2.32.0

