Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E95F5F58FB
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 19:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiJERSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 13:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiJERSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 13:18:15 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E108123161;
        Wed,  5 Oct 2022 10:18:10 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id z18so10660502qvn.6;
        Wed, 05 Oct 2022 10:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=FsSSRjv1LZzNC7YhdV5TsyTM1ptg/km1D8CLdNHsHIc=;
        b=e1DpgewBP8xrzQqTnzzwJvlLJas9MMsx1ABqNgozQDUWeoX6dW9ESqVsjNzHFgmreS
         yEOE9wKJA3GyBaGMyclDPAEtdgaYjpcXGszT1Kk0oFd60faQQ0hL4xeDgdtpX6p/I3ds
         oNmHXh+Sy70OFfD6nLAnReuwgxUO6QGGQsSCfflqWKmG8fJE2qt8tcTgrZLquf29+ZjI
         HFaJxx4W7ii8nA8bXZNr9FjcgFwIFHDhOloXZURBIB5HtvmHeTMOTVzch5de++k7evn9
         Fm8LM8LHH69cFi0hyvszXIQR2nEgBjxdKJM4ZGQ83e8FgNb/uQ6jCvhMWkbDukJuoSER
         oAKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=FsSSRjv1LZzNC7YhdV5TsyTM1ptg/km1D8CLdNHsHIc=;
        b=alGNTO7En+evYGsBRZfINvGMEmDfwIeW7e7HeycEdA3oHeuGNNlNvJSNgeZbqlpIpa
         L5Ef5vRLj9LUsa/iSo4UYGPLOnGdYYsjgqADQJsZeHzhqB/dyTwZRogXsxBu3VQj/VNb
         BsJWR3qomWkjQ0d2RQUyo1de9zMxU/EEC/TgzBIa3wAFJmvqdY9WTgMo4cq17dNsP3UP
         MHbJFTL2nvODIMubB2MVA3GQX+0tLGIFb8EAaBvh5/2mrXy3rB2gkGat8GDNHP/taR5Q
         JTJ/UPmANdgAcu6vTiQxEYtTipi06rklOegsikqD41AqpXud4k+ygaQ8LPv5kDmgI1IM
         FBUg==
X-Gm-Message-State: ACrzQf1gENuwYwveiDH31BNU8q2N7KeK1b3Suv7fmFk5HAZII193vUUh
        1G81tWAih/kZe1Gm3wqk+1KqLyuY+p8=
X-Google-Smtp-Source: AMsMyM5Y8zGQsQHsJxB+5Zs1AK1nDSSCyr6J47V7ZF2Ome85bHpSuI5l3T//PkcD82TaxfZlYKGE3g==
X-Received: by 2002:ad4:5beb:0:b0:4af:96ab:21e5 with SMTP id k11-20020ad45beb000000b004af96ab21e5mr603426qvc.85.1664990261238;
        Wed, 05 Oct 2022 10:17:41 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2bd1:c1af:4b3b:4384])
        by smtp.gmail.com with ESMTPSA id m13-20020ac85b0d000000b003913996dce3sm1764552qtw.6.2022.10.05.10.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 10:17:40 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yangpeihao@sjtu.edu.cn, toke@redhat.com, jhs@mojatatu.com,
        jiri@resnulli.us, bpf@vger.kernel.org, sdf@google.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [RFC Patch v6 1/5] bpf: Introduce rbtree map
Date:   Wed,  5 Oct 2022 10:17:05 -0700
Message-Id: <20221005171709.150520-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221005171709.150520-1-xiyou.wangcong@gmail.com>
References: <20221005171709.150520-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Insert:
bpf_map_update(&map, &key, &val, flag);

Delete a specific key-val pair:
bpf_map_delete_elem(&map, &key);

Pop the minimum one:
bpf_map_pop(&map, &val);

Lookup:
val = bpf_map_lookup_elem(&map, &key);

Iterator:
bpf_for_each_map_elem(&map, callback, key, val);

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf_types.h |   1 +
 include/uapi/linux/bpf.h  |   1 +
 kernel/bpf/Makefile       |   2 +-
 kernel/bpf/rbtree.c       | 445 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 448 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/rbtree.c

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 2c6a4f2562a7..c53ba6de1613 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -127,6 +127,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_RINGBUF, ringbuf_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_BLOOM_FILTER, bloom_filter_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_USER_RINGBUF, user_ringbuf_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_RBTREE, rbtree_map_ops)
 
 BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
 BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 51b9aa640ad2..9492cd3af701 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -935,6 +935,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_TASK_STORAGE,
 	BPF_MAP_TYPE_BLOOM_FILTER,
 	BPF_MAP_TYPE_USER_RINGBUF,
+	BPF_MAP_TYPE_RBTREE,
 };
 
 /* Note that tracing related programs such as
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 341c94f208f4..e60249258c74 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -7,7 +7,7 @@ endif
 CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o link_iter.o
-obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
+obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o rbtree.o
 obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
 obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
diff --git a/kernel/bpf/rbtree.c b/kernel/bpf/rbtree.c
new file mode 100644
index 000000000000..f1a9b1c40b8b
--- /dev/null
+++ b/kernel/bpf/rbtree.c
@@ -0,0 +1,445 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * rbtree.c: eBPF rbtree map
+ *
+ * Copyright (C) 2022, ByteDance, Cong Wang <cong.wang@bytedance.com>
+ */
+#include <linux/bpf.h>
+#include <linux/slab.h>
+#include <linux/capability.h>
+#include <linux/rbtree.h>
+#include <linux/btf_ids.h>
+#include <linux/bpf_mem_alloc.h>
+#include <linux/math.h>
+#include <linux/seq_file.h>
+
+#define RBTREE_CREATE_FLAG_MASK \
+	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK)
+
+/* each rbtree element is struct rbtree_elem + key + value */
+struct rbtree_elem {
+	struct rb_node rbnode;
+	char key[] __aligned(8);
+};
+
+struct rbtree_map {
+	struct bpf_map map;
+	struct bpf_mem_alloc ma;
+	raw_spinlock_t lock;
+	struct rb_root root;
+	atomic_t nr_entries;
+};
+
+#define rb_to_elem(rb) rb_entry_safe(rb, struct rbtree_elem, rbnode)
+#define elem_rb_first(root) rb_to_elem(rb_first(root))
+#define elem_rb_last(root)  rb_to_elem(rb_last(root))
+#define elem_rb_next(e)   rb_to_elem(rb_next(&(e)->rbnode))
+#define rbtree_walk_safe(e, tmp, root)					\
+		for (e = elem_rb_first(root);				\
+		     tmp = e ? elem_rb_next(e) : NULL, (e != NULL);	\
+		     e = tmp)
+
+static struct rbtree_map *rbtree_map(struct bpf_map *map)
+{
+	return container_of(map, struct rbtree_map, map);
+}
+
+/* Called from syscall */
+static int rbtree_map_alloc_check(union bpf_attr *attr)
+{
+	if (!bpf_capable())
+		return -EPERM;
+
+	/* check sanity of attributes */
+	if (attr->max_entries == 0 ||
+	    attr->map_flags & ~RBTREE_CREATE_FLAG_MASK ||
+	    !bpf_map_flags_access_ok(attr->map_flags))
+		return -EINVAL;
+
+	if (attr->value_size > KMALLOC_MAX_SIZE)
+		/* if value_size is bigger, the user space won't be able to
+		 * access the elements.
+		 */
+		return -E2BIG;
+
+	return 0;
+}
+
+static struct bpf_map *rbtree_map_alloc(union bpf_attr *attr)
+{
+	int numa_node = bpf_map_attr_numa_node(attr);
+	struct rbtree_map *rb;
+	u32 elem_size;
+	int err;
+
+	rb = bpf_map_area_alloc(sizeof(*rb), numa_node);
+	if (!rb)
+		return ERR_PTR(-ENOMEM);
+
+	memset(rb, 0, sizeof(*rb));
+	bpf_map_init_from_attr(&rb->map, attr);
+	raw_spin_lock_init(&rb->lock);
+	rb->root = RB_ROOT;
+	atomic_set(&rb->nr_entries, 0);
+
+	elem_size = sizeof(struct rbtree_elem) +
+			  round_up(rb->map.key_size, 8);
+	elem_size += round_up(rb->map.value_size, 8);
+	err = bpf_mem_alloc_init(&rb->ma, elem_size, false);
+	if (err) {
+		bpf_map_area_free(rb);
+		return ERR_PTR(err);
+	}
+	return &rb->map;
+}
+
+static void check_and_free_fields(struct rbtree_map *rb,
+				  struct rbtree_elem *elem)
+{
+	void *map_value = elem->key + round_up(rb->map.key_size, 8);
+
+	if (map_value_has_kptrs(&rb->map))
+		bpf_map_free_kptrs(&rb->map, map_value);
+}
+
+static void rbtree_map_purge(struct bpf_map *map)
+{
+	struct rbtree_map *rb = rbtree_map(map);
+	struct rbtree_elem *e, *tmp;
+
+	rbtree_walk_safe(e, tmp, &rb->root) {
+		rb_erase(&e->rbnode, &rb->root);
+		check_and_free_fields(rb, e);
+		bpf_mem_cache_free(&rb->ma, e);
+	}
+}
+
+/* Called when map->refcnt goes to zero, either from workqueue or from syscall */
+static void rbtree_map_free(struct bpf_map *map)
+{
+	struct rbtree_map *rb = rbtree_map(map);
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&rb->lock, flags);
+	rbtree_map_purge(map);
+	raw_spin_unlock_irqrestore(&rb->lock, flags);
+	bpf_mem_alloc_destroy(&rb->ma);
+	bpf_map_area_free(rb);
+}
+
+static struct rbtree_elem *bpf_rbtree_find(struct rb_root *root, void *key, int size)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct rbtree_elem *e;
+
+	while (*p) {
+		int ret;
+
+		parent = *p;
+		e = rb_to_elem(parent);
+		ret = memcmp(key, e->key, size);
+		if (ret < 0)
+			p = &parent->rb_left;
+		else if (ret > 0)
+			p = &parent->rb_right;
+		else
+			return e;
+	}
+	return NULL;
+}
+
+/* Called from eBPF program or syscall */
+static void *rbtree_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	struct rbtree_map *rb = rbtree_map(map);
+	struct rbtree_elem *e;
+
+	e = bpf_rbtree_find(&rb->root, key, rb->map.key_size);
+	if (!e)
+		return NULL;
+	return e->key + round_up(rb->map.key_size, 8);
+}
+
+static int check_flags(struct rbtree_elem *old, u64 map_flags)
+{
+	if (old && (map_flags & ~BPF_F_LOCK) == BPF_NOEXIST)
+		/* elem already exists */
+		return -EEXIST;
+
+	if (!old && (map_flags & ~BPF_F_LOCK) == BPF_EXIST)
+		/* elem doesn't exist, cannot update it */
+		return -ENOENT;
+
+	return 0;
+}
+
+static void rbtree_map_insert(struct rbtree_map *rb, struct rbtree_elem *e)
+{
+	struct rb_root *root = &rb->root;
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct rbtree_elem *e1;
+
+	while (*p) {
+		parent = *p;
+		e1 = rb_to_elem(parent);
+		if (memcmp(e->key, e1->key, rb->map.key_size) < 0)
+			p = &parent->rb_left;
+		else
+			p = &parent->rb_right;
+	}
+	rb_link_node(&e->rbnode, parent, p);
+	rb_insert_color(&e->rbnode, root);
+}
+
+/* Called from syscall or from eBPF program */
+static int rbtree_map_update_elem(struct bpf_map *map, void *key, void *value,
+			       u64 map_flags)
+{
+	struct rbtree_map *rb = rbtree_map(map);
+	void *val = rbtree_map_lookup_elem(map, key);
+	int ret;
+
+	ret = check_flags(val, map_flags);
+	if (ret)
+		return ret;
+
+	if (!val) {
+		struct rbtree_elem *e_new;
+		unsigned long flags;
+
+		e_new = bpf_mem_cache_alloc(&rb->ma);
+		if (!e_new)
+			return -ENOMEM;
+		val = e_new->key + round_up(rb->map.key_size, 8);
+		check_and_init_map_value(&rb->map, val);
+		memcpy(e_new->key, key, rb->map.key_size);
+		raw_spin_lock_irqsave(&rb->lock, flags);
+		rbtree_map_insert(rb, e_new);
+		raw_spin_unlock_irqrestore(&rb->lock, flags);
+		atomic_inc(&rb->nr_entries);
+	}
+
+	if (map_flags & BPF_F_LOCK)
+		copy_map_value_locked(map, val, value, false);
+	else
+		copy_map_value(map, val, value);
+	return 0;
+}
+
+/* Called from syscall or from eBPF program */
+static int rbtree_map_delete_elem(struct bpf_map *map, void *key)
+{
+	struct rbtree_map *rb = rbtree_map(map);
+	struct rbtree_elem *e;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&rb->lock, flags);
+	e = bpf_rbtree_find(&rb->root, key, rb->map.key_size);
+	if (!e) {
+		raw_spin_unlock_irqrestore(&rb->lock, flags);
+		return -ENOENT;
+	}
+	rb_erase(&e->rbnode, &rb->root);
+	raw_spin_unlock_irqrestore(&rb->lock, flags);
+	check_and_free_fields(rb, e);
+	bpf_mem_cache_free(&rb->ma, e);
+	atomic_dec(&rb->nr_entries);
+	return 0;
+}
+
+/* Called from syscall or from eBPF program */
+static int rbtree_map_pop_elem(struct bpf_map *map, void *value)
+{
+	struct rbtree_map *rb = rbtree_map(map);
+	struct rbtree_elem *e = elem_rb_first(&rb->root);
+	unsigned long flags;
+	void *val;
+
+	if (!e)
+		return -ENOENT;
+	raw_spin_lock_irqsave(&rb->lock, flags);
+	rb_erase(&e->rbnode, &rb->root);
+	raw_spin_unlock_irqrestore(&rb->lock, flags);
+	val = e->key + round_up(rb->map.key_size, 8);
+	copy_map_value(map, value, val);
+	check_and_free_fields(rb, e);
+	bpf_mem_cache_free(&rb->ma, e);
+	atomic_dec(&rb->nr_entries);
+	return 0;
+}
+
+/* Called from syscall */
+static int rbtree_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
+{
+	struct rbtree_map *rb = rbtree_map(map);
+	struct rbtree_elem *e;
+
+	if (!key) {
+		e = elem_rb_first(&rb->root);
+		if (!e)
+			return -ENOENT;
+		goto found;
+	}
+	e = bpf_rbtree_find(&rb->root, key, rb->map.key_size);
+	if (!e)
+		return -ENOENT;
+	e = elem_rb_next(e);
+	if (!e)
+		return 0;
+found:
+	memcpy(next_key, e->key, map->key_size);
+	return 0;
+}
+
+static int bpf_for_each_rbtree_map(struct bpf_map *map,
+				   bpf_callback_t callback_fn,
+				   void *callback_ctx, u64 flags)
+{
+	struct rbtree_map *rb = rbtree_map(map);
+	struct rbtree_elem *e, *tmp;
+	void *key, *value;
+	u32 num_elems = 0;
+	u64 ret = 0;
+
+	if (flags != 0)
+		return -EINVAL;
+
+	rbtree_walk_safe(e, tmp, &rb->root) {
+		num_elems++;
+		key = e->key;
+		value = key + round_up(rb->map.key_size, 8);
+		ret = callback_fn((u64)(long)map, (u64)(long)key, (u64)(long)value,
+				  (u64)(long)callback_ctx, 0);
+		/* return value: 0 - continue, 1 - stop and return */
+		if (ret)
+			break;
+	}
+
+	return num_elems;
+}
+
+struct rbtree_map_seq_info {
+	struct bpf_map *map;
+	struct rbtree_map *rb;
+};
+
+static void *rbtree_map_seq_find_next(struct rbtree_map_seq_info *info,
+				      struct rbtree_elem *prev_elem)
+{
+	const struct rbtree_map *rb = info->rb;
+	struct rbtree_elem *elem;
+
+	/* try to find next elem in the same bucket */
+	if (prev_elem) {
+		elem = elem_rb_next(prev_elem);
+		if (elem)
+			return elem;
+		return NULL;
+	}
+
+	return elem_rb_first(&rb->root);
+}
+
+static void *rbtree_map_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct rbtree_map_seq_info *info = seq->private;
+
+	if (*pos == 0)
+		++*pos;
+
+	/* pairs with rbtree_map_seq_stop */
+	rcu_read_lock();
+	return rbtree_map_seq_find_next(info, NULL);
+}
+
+static void *rbtree_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct rbtree_map_seq_info *info = seq->private;
+
+	++*pos;
+	return rbtree_map_seq_find_next(info, v);
+}
+
+static int rbtree_map_seq_show(struct seq_file *seq, void *v)
+{
+	struct rbtree_map_seq_info *info = seq->private;
+	struct bpf_iter__bpf_map_elem ctx = {};
+	struct rbtree_elem *elem = v;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+
+	meta.seq = seq;
+	prog = bpf_iter_get_info(&meta, !elem);
+	if (!prog)
+		return 0;
+
+	ctx.meta = &meta;
+	ctx.map = info->map;
+	if (elem) {
+		ctx.key = elem->key;
+		ctx.value = elem->key + round_up(info->map->key_size, 8);
+	}
+
+	return bpf_iter_run_prog(prog, &ctx);
+}
+
+static void rbtree_map_seq_stop(struct seq_file *seq, void *v)
+{
+	if (!v)
+		(void)rbtree_map_seq_show(seq, NULL);
+
+	/* pairs with rbtree_map_seq_start */
+	rcu_read_unlock();
+}
+
+static const struct seq_operations rbtree_map_seq_ops = {
+	.start	= rbtree_map_seq_start,
+	.next	= rbtree_map_seq_next,
+	.stop	= rbtree_map_seq_stop,
+	.show	= rbtree_map_seq_show,
+};
+
+static int rbtree_map_init_seq_private(void *priv_data,
+				       struct bpf_iter_aux_info *aux)
+{
+	struct rbtree_map_seq_info *info = priv_data;
+
+	bpf_map_inc_with_uref(aux->map);
+	info->map = aux->map;
+	info->rb = rbtree_map(info->map);
+	return 0;
+}
+
+static void rbtree_map_fini_seq_private(void *priv_data)
+{
+	struct rbtree_map_seq_info *info = priv_data;
+
+	bpf_map_put_with_uref(info->map);
+}
+
+static const struct bpf_iter_seq_info rbtree_map_iter_seq_info = {
+	.seq_ops		= &rbtree_map_seq_ops,
+	.init_seq_private	= rbtree_map_init_seq_private,
+	.fini_seq_private	= rbtree_map_fini_seq_private,
+	.seq_priv_size		= sizeof(struct rbtree_map_seq_info),
+};
+
+BTF_ID_LIST_SINGLE(rbtree_map_btf_ids, struct, rbtree_map)
+const struct bpf_map_ops rbtree_map_ops = {
+	.map_meta_equal = bpf_map_meta_equal,
+	.map_alloc_check = rbtree_map_alloc_check,
+	.map_alloc = rbtree_map_alloc,
+	.map_free = rbtree_map_free,
+	.map_lookup_elem = rbtree_map_lookup_elem,
+	.map_update_elem = rbtree_map_update_elem,
+	.map_delete_elem = rbtree_map_delete_elem,
+	.map_pop_elem = rbtree_map_pop_elem,
+	.map_get_next_key = rbtree_map_get_next_key,
+	.map_set_for_each_callback_args = map_set_for_each_callback_args,
+	.map_for_each_callback = bpf_for_each_rbtree_map,
+	.map_btf_id = &rbtree_map_btf_ids[0],
+	.iter_seq_info = &rbtree_map_iter_seq_info,
+};
+
-- 
2.34.1

