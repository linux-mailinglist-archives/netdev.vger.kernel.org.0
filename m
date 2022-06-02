Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE6853B273
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 06:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiFBELF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 00:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiFBELB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 00:11:01 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B18A20C255;
        Wed,  1 Jun 2022 21:10:59 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id c8so2673812qtj.1;
        Wed, 01 Jun 2022 21:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CQ+ILYQP8v6I2fji3fCX+ElPtrhOrisypTW1guCWhnQ=;
        b=oByAHmsVnZHhFude9+12kUPSM3Fa/hXFcKursmMjmjk/mlSA/dUxCInnHXF5AW8ZKs
         ov6LAK7ovYfP4upECBS8kJbdzoOtTZ+ZTAEJfIpyXIZz8FK9kcLqLH3MRxAzIHWqwANV
         X9KCHWwGykpxacsaf1iyLHAuq/0u1LRSJwgsRGtJqRbTLEYIwJm8WZJgpiGMLgumGti+
         xP0TzzyU1mNtCu7AUIqe/W4/9F00Xyp9JWshWP+T62KIB1FpCBNJspfMSU1g/bsfJOWY
         rCly7/8bH4lErUNOu+r0YomfIQDZlXR7r6h2GrY7LszRJfDdo+gMlbiFGAUenNcB0u2d
         sc+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CQ+ILYQP8v6I2fji3fCX+ElPtrhOrisypTW1guCWhnQ=;
        b=hkfqzOQLGSdYG9b3YTjkqBevWglBrPZz2Gf77Q/Ofk9HqpJO3XLkhizWOHVF+DF1m0
         2oc+dWOot+Xve/0wLwhUTbWKeDOPUXZAHexBYn3RixynttgX2p7NlgAlrU3UUSNb/f/k
         lbJiLTeS9Tk6nI76SCihVuJY6nbwum4ZXd1EN1n/yF8fqdINRNv++S214DsOprBS2Xn5
         dP9e8L+hflstvZLY3RQqLJ9dRENPd7EvU6EifinGc9qHEYjdlYkzLEKo6ygUFZknGzfk
         +0GhrTNjT/gYXU8MLGI90kwW3UsK7CHfs4CnjUZoBaANH3F1dLh9Qxu7davzQ8abeWZr
         TIBg==
X-Gm-Message-State: AOAM530c8ppUImumNrdipS+CGyAGmVD073OSiqSC7Nk4oGQneyRzdmUB
        W7mig/7fvfe/GH7mApYmIGvdeQMl6/g=
X-Google-Smtp-Source: ABdhPJx7iXEIfSosdO718f9ZZpQbjMwTrNhlnpUIWC5NSm/R50aSZzOh3KccpVwFQ1EpaK1rrN7RcA==
X-Received: by 2002:ac8:7f13:0:b0:303:6d43:5f25 with SMTP id f19-20020ac87f13000000b003036d435f25mr2353161qtk.364.1654143058066;
        Wed, 01 Jun 2022 21:10:58 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:d7c6:fc22:5340:d891])
        by smtp.gmail.com with ESMTPSA id i187-20020a3786c4000000b0069fc13ce1fesm2396654qkd.47.2022.06.01.21.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 21:10:57 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [RFC Patch v5 3/5] bpf: introduce skb map and flow map
Date:   Wed,  1 Jun 2022 21:10:26 -0700
Message-Id: <20220602041028.95124-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
References: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
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

Introduce two maps: one for storing skb and one for storing skb flows,
the latter one is implemented as a map in map. The API's for two maps
are similiar, except one takes skb pointer and the other takes skb map
pointer.

Here are the API's for skb map:

1. Insert skb into skb map at position @key:
bpf_skb_push(&map, skb, key);

2. Remove the skb at position @key from skb map:
skb = bpf_skb_pop(&map, key);

3. Peek an skb by @key:
skb = bpf_map_lookup_elem(&map, &key);

4. Drop the skb at position @key:
bpf_map_delete_elem(&map, &key);

5. Iterate all the skbs in the map in order:
bpf_for_each_map_elem(&skb_map, skb_callback, key, skb);

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf.h       |   4 +
 include/linux/bpf_types.h |   2 +
 include/linux/skbuff.h    |   4 +-
 include/uapi/linux/bpf.h  |   6 +
 kernel/bpf/verifier.c     |  10 +
 net/core/Makefile         |   1 +
 net/core/skb_map.c        | 520 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 546 insertions(+), 1 deletion(-)
 create mode 100644 net/core/skb_map.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cf04ddce2c2d..43fbb45b6fc2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2274,6 +2274,10 @@ extern const struct bpf_func_proto bpf_loop_proto;
 extern const struct bpf_func_proto bpf_strncmp_proto;
 extern const struct bpf_func_proto bpf_copy_from_user_task_proto;
 extern const struct bpf_func_proto bpf_kptr_xchg_proto;
+extern const struct bpf_func_proto bpf_skb_map_push_proto;
+extern const struct bpf_func_proto bpf_skb_map_pop_proto;
+extern const struct bpf_func_proto bpf_flow_map_push_proto;
+extern const struct bpf_func_proto bpf_flow_map_pop_proto;
 
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 2b9112b80171..b1276f9f9d26 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -110,6 +110,8 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_CPUMAP, cpu_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_SKBMAP, skb_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_FLOWMAP, flow_map_ops)
 #if defined(CONFIG_XDP_SOCKETS)
 BPF_MAP_TYPE(BPF_MAP_TYPE_XSKMAP, xsk_map_ops)
 #endif
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 857fd813c1bc..fea71b4a0b9d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1017,7 +1017,9 @@ struct sk_buff {
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
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f4009dbdf62d..cd9cff0df639 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -909,6 +909,8 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_INODE_STORAGE,
 	BPF_MAP_TYPE_TASK_STORAGE,
 	BPF_MAP_TYPE_BLOOM_FILTER,
+	BPF_MAP_TYPE_SKBMAP,
+	BPF_MAP_TYPE_FLOWMAP,
 };
 
 /* Note that tracing related programs such as
@@ -5455,6 +5457,10 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(skb_map_push),		\
+	FN(skb_map_pop),		\
+	FN(flow_map_push),		\
+	FN(flow_map_pop),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index aedac2ac02b9..bc4cdb4a5176 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6264,6 +6264,16 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    func_id != BPF_FUNC_map_push_elem)
 			goto error;
 		break;
+	case BPF_MAP_TYPE_SKBMAP:
+		if (func_id != BPF_FUNC_skb_map_push &&
+		    func_id != BPF_FUNC_skb_map_pop)
+			goto error;
+		break;
+	case BPF_MAP_TYPE_FLOWMAP:
+		if (func_id != BPF_FUNC_flow_map_push &&
+		    func_id != BPF_FUNC_flow_map_pop)
+			goto error;
+		break;
 	default:
 		break;
 	}
diff --git a/net/core/Makefile b/net/core/Makefile
index a8e4f737692b..183f75e02b28 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -38,4 +38,5 @@ obj-$(CONFIG_FAILOVER) += failover.o
 obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
+obj-$(CONFIG_BPF_SYSCALL) += skb_map.o
 obj-$(CONFIG_OF)	+= of_net.o
diff --git a/net/core/skb_map.c b/net/core/skb_map.c
new file mode 100644
index 000000000000..1c4ef29de558
--- /dev/null
+++ b/net/core/skb_map.c
@@ -0,0 +1,520 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * skb_map.c: eBPF skb map based on RB tree
+ *
+ * Copyright (C) 2022, ByteDance, Cong Wang <cong.wang@bytedance.com>
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
+	struct rb_node node;
+	u64 rank;
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
+		goto found;
+	}
+	rank = *(u64 *) key;
+	skb = skb_rb_find(&rb->root, rank);
+	if (!skb)
+		return -ENOENT;
+	skb = skb_rb_next(skb);
+	if (!skb)
+		return 0;
+found:
+	*(u64 *) next_key = skb_map_cb(skb)->rank;
+	return 0;
+}
+
+static int bpf_for_each_skb_map(struct bpf_map *map, bpf_callback_t callback_fn,
+				void *callback_ctx, u64 flags)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+	struct sk_buff *skb, *tmp;
+	u32 num_elems = 0;
+	u64 ret = 0;
+	u64 key;
+
+	if (flags != 0)
+		return -EINVAL;
+
+	skb_rbtree_walk_safe(skb, tmp, &rb->root) {
+		num_elems++;
+		key = skb_map_cb(skb)->rank;
+		ret = callback_fn((u64)(long)map, key, (u64)(long)skb,
+				  (u64)(long)callback_ctx, 0);
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
+const struct bpf_func_proto bpf_skb_map_pop_proto = {
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
+const struct bpf_func_proto bpf_skb_map_push_proto = {
+	.func		= bpf_skb_map_push,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_PTR_TO_CTX,
+	.arg3_type	= ARG_ANYTHING,
+};
+
+static struct bpf_map *flow_map_alloc(union bpf_attr *attr)
+{
+	struct bpf_map *map, *inner_map_meta;
+
+	inner_map_meta = bpf_map_meta_alloc(attr->inner_map_fd);
+	if (IS_ERR(inner_map_meta))
+		return inner_map_meta;
+
+	map = skb_map_alloc(attr);
+	if (IS_ERR(map)) {
+		bpf_map_meta_free(inner_map_meta);
+		return map;
+	}
+
+	map->inner_map_meta = inner_map_meta;
+	return map;
+}
+
+#define rb_to_map(rb) rb_entry_safe(rb, struct bpf_skb_map, node)
+
+static void bpf_skb_map_purge(struct rb_root *root)
+{
+	struct rb_node *p = rb_first(root);
+
+	while (p) {
+		struct bpf_skb_map *map = rb_to_map(p);
+
+		p = rb_next(p);
+		rb_erase(&map->node, root);
+		skb_map_free(&map->map);
+	}
+}
+
+static void flow_map_free(struct bpf_map *map)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+
+	bpf_map_meta_free(map->inner_map_meta);
+	bpf_skb_map_purge(&rb->root);
+	bpf_map_area_free(rb);
+}
+
+static struct bpf_map *map_rb_find(struct rb_root *root, u64 rank)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct bpf_skb_map *map1;
+
+	while (*p) {
+		parent = *p;
+		map1 = rb_to_map(parent);
+		if (rank < map1->rank)
+			p = &parent->rb_left;
+		else if (rank > map1->rank)
+			p = &parent->rb_right;
+		else
+			return &map1->map;
+	}
+	return NULL;
+}
+
+/* Called from eBPF program */
+static void *flow_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+	u64 rank = *(u64 *) key;
+
+	return map_rb_find(&rb->root, rank);
+}
+
+/* Called from syscall or from eBPF program */
+static int flow_map_delete_elem(struct bpf_map *map, void *key)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+	struct bpf_skb_map *node;
+	u64 rank = *(u64 *) key;
+	struct bpf_map *target;
+
+	target = map_rb_find(&rb->root, rank);
+	if (!target)
+		return -ENOENT;
+	node = bpf_skb_map(target);
+	rb_erase(&node->node, &rb->root);
+	skb_map_free(target);
+	return 0;
+}
+
+static int flow_map_alloc_check(union bpf_attr *attr)
+{
+	if (attr->value_size != sizeof(u32))
+		return -EINVAL;
+	return skb_map_alloc_check(attr);
+}
+
+/* Called from syscall */
+static int flow_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
+{
+	return -ENOTSUPP; /* TODO */
+}
+
+const struct bpf_map_ops flow_map_ops = {
+	.map_alloc_check = flow_map_alloc_check,
+	.map_alloc = flow_map_alloc,
+	.map_free = flow_map_free,
+	.map_get_next_key = flow_map_get_next_key,
+	.map_lookup_elem = flow_map_lookup_elem,
+	.map_delete_elem = flow_map_delete_elem,
+	.map_check_btf = map_check_no_btf,
+	.map_btf_id = &skb_map_btf_ids[0],
+};
+
+BPF_CALL_2(bpf_flow_map_pop, struct bpf_map *, map, u64, key)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+	struct bpf_map *target;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&rb->lock, flags);
+	target = map_rb_find(&rb->root, key);
+	if (!target) {
+		raw_spin_unlock_irqrestore(&rb->lock, flags);
+		return (unsigned long)NULL;
+	}
+	rb_erase(&bpf_skb_map(target)->node, &rb->root);
+	raw_spin_unlock_irqrestore(&rb->lock, flags);
+	atomic_dec(&rb->count);
+	return (unsigned long)target;
+}
+
+const struct bpf_func_proto bpf_flow_map_pop_proto = {
+	.func		= bpf_flow_map_pop,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_ANYTHING,
+};
+
+static void map_rb_push(struct rb_root *root, struct bpf_map *map)
+{
+	struct rb_node **p = &root->rb_node;
+	struct bpf_skb_map *smap = bpf_skb_map(map);
+	struct rb_node *parent = NULL;
+	struct bpf_skb_map *map1;
+
+	while (*p) {
+		parent = *p;
+		map1 = rb_to_map(parent);
+		if (smap->rank < map1->rank)
+			p = &parent->rb_left;
+		else
+			p = &parent->rb_right;
+	}
+	rb_link_node(&smap->node, parent, p);
+	rb_insert_color(&smap->node, root);
+}
+
+BPF_CALL_3(bpf_flow_map_push, struct bpf_map *, map, struct bpf_map *, value, u64, key)
+{
+	struct bpf_skb_map *rb = bpf_skb_map(map);
+	unsigned long irq_flags;
+
+	if (atomic_inc_return(&rb->count) > rb->map.max_entries)
+		return -ENOBUFS;
+	bpf_skb_map(value)->rank = key;
+	raw_spin_lock_irqsave(&rb->lock, irq_flags);
+	map_rb_push(&rb->root, value);
+	raw_spin_unlock_irqrestore(&rb->lock, irq_flags);
+	return 0;
+}
+
+const struct bpf_func_proto bpf_flow_map_push_proto = {
+	.func		= bpf_flow_map_push,
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

