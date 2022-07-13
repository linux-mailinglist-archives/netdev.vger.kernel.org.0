Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED13573517
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbiGMLO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbiGMLOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:14:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D82C5AE553
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657710880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oNqiseiBBK1oSRPpUqEqndaBGP0dH/Mii8v0q7JzirA=;
        b=EMWqsGoqM9xYX0mA/99jmGMsg+TsRIYph9fOdcixtkeyGjOec35ISkSzPv7v3CrtMvs5l/
        PLwzyyVPV6DfvjHNcBFF14L+xyWeWCza8ZJG5PuyeTfUd81tMKYrhgm5wE4CqoNEoq7Ho0
        OPke7rQOEfjl80MZnustNZsBuPlXkV8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-EnQkAyrwOaOHhMRwaDLSkg-1; Wed, 13 Jul 2022 07:14:38 -0400
X-MC-Unique: EnQkAyrwOaOHhMRwaDLSkg-1
Received: by mail-ed1-f69.google.com with SMTP id x8-20020a056402414800b0042d8498f50aso8222570eda.23
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oNqiseiBBK1oSRPpUqEqndaBGP0dH/Mii8v0q7JzirA=;
        b=1zdoHURFqrsEO6XdraadwdyxIhUwedwn+/XpykdT+SGXnAtQqq3/EWsF1ZxYBp4obS
         uZ4moDgvEyMProocb6d22IrdwWOUQh99N7jisKtmYeuEpc2Qg3jnaRfARC+i9of5BFNi
         RWJ7IyIgHYjBu25w2lg8VGu1KCGeQQbDBiBfzUZCxzpuR7HH2EzrH9Tfl59cmVmSZG5f
         FhXzepg0QSbcnOup5oCBOA2TCnYcNsGqMpLTHizbNEC6mhn6DVBMlG4YbFzVdS1bRTTC
         6YuU7uzmWIM+2sL87h+64RxbT/WzZzBm7mGZvZMLtnlgc536RPe3mWQINpqzG5MviRWk
         tzcw==
X-Gm-Message-State: AJIora9ahLtwz7E6GJ7QBq++fWR1U88KQ8VK70R3Z2sV9/AH63THZPoB
        WtooJsgS7L4NJcoxgR408swLBx9fHLfDxlnUFX6rDe283om8ZQUPU9u/mZPxoK0TJ+ohMHfzOGq
        JmZeOtkIanVJyA2B6
X-Received: by 2002:a17:907:7604:b0:72b:4ad5:b21c with SMTP id jx4-20020a170907760400b0072b4ad5b21cmr2873194ejc.412.1657710876880;
        Wed, 13 Jul 2022 04:14:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vZjPw7WZF5b1u2shBguMk1pQ0WXo1JnnKlhAGsVYwIWrtszqcXlnLG9YSBNjmYWpMdf6NxPQ==
X-Received: by 2002:a17:907:7604:b0:72b:4ad5:b21c with SMTP id jx4-20020a170907760400b0072b4ad5b21cmr2873157ejc.412.1657710876351;
        Wed, 13 Jul 2022 04:14:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id lc25-20020a170906f91900b006ff802baf5dsm4870917ejb.54.2022.07.13.04.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:14:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 396C64D9903; Wed, 13 Jul 2022 13:14:35 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC PATCH 04/17] bpf: Add a PIFO priority queue map type
Date:   Wed, 13 Jul 2022 13:14:12 +0200
Message-Id: <20220713111430.134810-5-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PIFO (Push-In First-Out) data structure is a priority queue where
entries can be added at any point in the queue, but dequeue is always
in-order. The primary application is packet queueing, but with arbitrary
data it can also be used as a generic priority queue data structure.

This patch implements two variants of the PIFO map: A generic priority
queue and a queueing structure for XDP frames. The former is
BPF_MAP_TYPE_PIFO_GENERIC, which a generic priority queue that BPF programs
can use via the bpf_map_push_elem() and bpf_map_pop_elem() helpers to
insert and dequeue items. For pushing items, the lower 60 bits of the flags
argument of the helper is interpreted as the priority.

The BPF_MAP_TYPE_PIFO_XDP is a priority queue that stores XDP frames, which
are added to the map using the bpf_redirect_map() helper, where the map
index is used as the priority. Frames can be dequeued from a separate
dequeue program type, added in a later commit.

The two variants of the PIFO share most of their implementation. The user
selects the maximum number of entries stored in the map (using the regular
max_entries) parameter, as well as the range of valid priorities, where the
latter is expressed using the lower 32 bits of the map_extra parameter; the
range must be a power of two.

Each priority can have multiple entries queued, in which case entries are
stored in FIFO order of enqueue. The implementation uses a tree of
word-sized bitmaps as an index of which buckets contain any items. This
allows fast lookups: finding the next item to dequeue requires log_k(N)
"find first set" operations, where N is the range of the map (chosen at
setup time), and k is the number of bits in the native 'unsigned long'
type (so either 32 or 64).

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h            |  13 +
 include/linux/bpf_types.h      |   2 +
 include/net/xdp.h              |   5 +-
 include/uapi/linux/bpf.h       |  13 +
 kernel/bpf/Makefile            |   2 +-
 kernel/bpf/pifomap.c           | 581 +++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |   2 +
 kernel/bpf/verifier.c          |  10 +-
 net/core/filter.c              |   7 +
 tools/include/uapi/linux/bpf.h |  13 +
 10 files changed, 645 insertions(+), 3 deletions(-)
 create mode 100644 kernel/bpf/pifomap.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ebe6f2d95182..ea994acebb81 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1849,6 +1849,9 @@ int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf,
 int cpu_map_generic_redirect(struct bpf_cpu_map_entry *rcpu,
 			     struct sk_buff *skb);
 
+int pifo_map_enqueue(struct bpf_map *map, struct xdp_frame *xdpf, u32 index);
+struct xdp_frame *pifo_map_dequeue(struct bpf_map *map, u64 flags, u64 *rank);
+
 /* Return map's numa specified by userspace */
 static inline int bpf_map_attr_numa_node(const union bpf_attr *attr)
 {
@@ -2081,6 +2084,16 @@ static inline int cpu_map_generic_redirect(struct bpf_cpu_map_entry *rcpu,
 	return -EOPNOTSUPP;
 }
 
+static inline int pifo_map_enqueue(struct bpf_map *map, struct xdp_frame *xdp, u32 index)
+{
+	return 0;
+}
+
+static inline struct xdp_frame *pifo_map_dequeue(struct bpf_map *map, u64 flags, u64 *rank)
+{
+	return NULL;
+}
+
 static inline struct bpf_prog *bpf_prog_get_type_path(const char *name,
 				enum bpf_prog_type type)
 {
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 2b9112b80171..26ef981a8aa5 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -105,11 +105,13 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_HASH_OF_MAPS, htab_of_maps_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_INODE_STORAGE, inode_storage_map_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_TASK_STORAGE, task_storage_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_PIFO_GENERIC, pifo_generic_map_ops)
 #ifdef CONFIG_NET
 BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_CPUMAP, cpu_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_PIFO_XDP, pifo_xdp_map_ops)
 #if defined(CONFIG_XDP_SOCKETS)
 BPF_MAP_TYPE(BPF_MAP_TYPE_XSKMAP, xsk_map_ops)
 #endif
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 04c852c7a77f..7c694fb26f34 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -170,7 +170,10 @@ struct xdp_frame {
 	 * while mem info is valid on remote CPU.
 	 */
 	struct xdp_mem_info mem;
-	struct net_device *dev_rx; /* used by cpumap */
+	union {
+		struct net_device *dev_rx; /* used by cpumap */
+		struct xdp_frame *next; /* used by pifomap */
+	};
 	u32 flags; /* supported values defined in xdp_buff_flags */
 };
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index aec623f60048..f0947ddee784 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -909,6 +909,8 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_INODE_STORAGE,
 	BPF_MAP_TYPE_TASK_STORAGE,
 	BPF_MAP_TYPE_BLOOM_FILTER,
+	BPF_MAP_TYPE_PIFO_GENERIC,
+	BPF_MAP_TYPE_PIFO_XDP,
 };
 
 /* Note that tracing related programs such as
@@ -1244,6 +1246,13 @@ enum {
 /* If set, XDP frames will be transmitted after processing */
 #define BPF_F_TEST_XDP_LIVE_FRAMES	(1U << 1)
 
+/* Flags for BPF_MAP_TYPE_PIFO_* */
+
+/* Used for flags argument of bpf_map_push_elem(); reserve top four bits for
+ * actual flags, the rest is the enqueue priority
+ */
+#define BPF_PIFO_PRIO_MASK	(~0ULL >> 4)
+
 /* type for BPF_ENABLE_STATS */
 enum bpf_stats_type {
 	/* enabled run_time_ns and run_cnt */
@@ -1298,6 +1307,10 @@ union bpf_attr {
 		 * BPF_MAP_TYPE_BLOOM_FILTER - the lowest 4 bits indicate the
 		 * number of hash functions (if 0, the bloom filter will default
 		 * to using 5 hash functions).
+		 *
+		 * BPF_MAP_TYPE_PIFO_* - the lower 32 bits indicate the valid
+		 * range of priorities for entries enqueued in the map. Must be
+		 * a power of two.
 		 */
 		__u64	map_extra;
 	};
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 057ba8e01e70..e66b4d0d3135 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -7,7 +7,7 @@ endif
 CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o link_iter.o
-obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
+obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o pifomap.o
 obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
 obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
diff --git a/kernel/bpf/pifomap.c b/kernel/bpf/pifomap.c
new file mode 100644
index 000000000000..5040f532e5d8
--- /dev/null
+++ b/kernel/bpf/pifomap.c
@@ -0,0 +1,581 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/* Pifomaps queue packets
+ */
+#include <linux/spinlock.h>
+#include <linux/bpf.h>
+#include <linux/bitops.h>
+#include <linux/btf_ids.h>
+#include <net/xdp.h>
+#include <linux/filter.h>
+#include <trace/events/xdp.h>
+
+#define PIFO_CREATE_FLAG_MASK \
+	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
+
+struct bpf_pifo_element {
+	struct bpf_pifo_element *next;
+	char data[];
+};
+
+union bpf_pifo_item {
+	struct bpf_pifo_element elem;
+	struct xdp_frame frame;
+};
+
+struct bpf_pifo_element_cache {
+	u32 free_elems;
+	struct bpf_pifo_element *elements[];
+};
+
+struct bpf_pifo_bucket {
+	union bpf_pifo_item *head, *tail;
+	u32 elem_count;
+};
+
+struct bpf_pifo_queue {
+	struct bpf_pifo_bucket *buckets;
+	unsigned long *bitmap;
+	unsigned long **lvl_bitmap;
+	u64 min_rank;
+	u32 range;
+	u32 levels;
+};
+
+struct bpf_pifo_map {
+	struct bpf_map map;
+	struct bpf_pifo_queue *queue;
+	unsigned long num_queued;
+	spinlock_t lock; /* protects enqueue / dequeue */
+
+	size_t elem_size;
+	struct bpf_pifo_element_cache *elem_cache;
+	char elements[] __aligned(8);
+};
+
+static struct bpf_pifo_element *elem_cache_get(struct bpf_pifo_element_cache *cache)
+{
+	if (unlikely(!cache->free_elems))
+		return NULL;
+	return cache->elements[--cache->free_elems];
+}
+
+static void elem_cache_put(struct bpf_pifo_element_cache *cache,
+			   struct bpf_pifo_element *elem)
+{
+	cache->elements[cache->free_elems++] = elem;
+}
+
+static bool pifo_map_is_full(struct bpf_pifo_map *pifo)
+{
+	return pifo->num_queued >= pifo->map.max_entries;
+}
+
+static void pifo_queue_free(struct bpf_pifo_queue *q)
+{
+	bpf_map_area_free(q->buckets);
+	bpf_map_area_free(q->bitmap);
+	bpf_map_area_free(q->lvl_bitmap);
+	kfree(q);
+}
+
+static struct bpf_pifo_queue *pifo_queue_alloc(u32 range, int numa_node)
+{
+	u32 num_longs = 0, offset = 0, i, lvl, levels;
+	struct bpf_pifo_queue *q;
+
+	levels = __KERNEL_DIV_ROUND_UP(ilog2(range), ilog2(BITS_PER_TYPE(long)));
+	for (i = 0, lvl = 1; i < levels; i++) {
+		num_longs += lvl;
+		lvl *= BITS_PER_TYPE(long);
+	}
+
+	q = kzalloc(sizeof(*q), GFP_USER | __GFP_ACCOUNT);
+	if (!q)
+		return NULL;
+	q->buckets = bpf_map_area_alloc(sizeof(struct bpf_pifo_bucket) * range,
+					numa_node);
+	if (!q->buckets)
+		goto err;
+
+	q->bitmap = bpf_map_area_alloc(sizeof(unsigned long) * num_longs,
+				       numa_node);
+	if (!q->bitmap)
+		goto err;
+
+	q->lvl_bitmap = bpf_map_area_alloc(sizeof(unsigned long *) * levels,
+					   numa_node);
+	for (i = 0, lvl = 1; i < levels; i++) {
+		q->lvl_bitmap[i] = &q->bitmap[offset];
+		offset += lvl;
+		lvl *= BITS_PER_TYPE(long);
+	}
+	q->levels = levels;
+	q->range = range;
+	return q;
+
+err:
+	pifo_queue_free(q);
+	return NULL;
+}
+
+static int pifo_map_init_map(struct bpf_pifo_map *pifo, union bpf_attr *attr,
+			     size_t elem_size, u32 range)
+{
+	int err = -ENOMEM;
+
+	/* Packet map is special, we don't want BPF writing straight to it
+	 */
+	if (attr->map_type != BPF_MAP_TYPE_PIFO_GENERIC)
+		attr->map_flags |= BPF_F_RDONLY_PROG;
+
+	bpf_map_init_from_attr(&pifo->map, attr);
+
+	pifo->queue = pifo_queue_alloc(range, pifo->map.numa_node);
+	if (!pifo->queue)
+		return -ENOMEM;
+
+	if (attr->map_type == BPF_MAP_TYPE_PIFO_GENERIC) {
+		size_t cache_size;
+		int i;
+
+		cache_size = sizeof(void *) * attr->max_entries +
+			sizeof(struct bpf_pifo_element_cache);
+		pifo->elem_cache = bpf_map_area_alloc(cache_size,
+						      pifo->map.numa_node);
+		if (!pifo->elem_cache)
+			goto err_queue;
+
+		for (i = 0; i < attr->max_entries; i++)
+			pifo->elem_cache->elements[i] = (void *)&pifo->elements[i * elem_size];
+		pifo->elem_cache->free_elems = attr->max_entries;
+	}
+
+	return 0;
+
+err_queue:
+	pifo_queue_free(pifo->queue);
+	return err;
+}
+
+static struct bpf_map *pifo_map_alloc(union bpf_attr *attr)
+{
+	int numa_node = bpf_map_attr_numa_node(attr);
+	size_t size, elem_size = 0;
+	struct bpf_pifo_map *pifo;
+	u32 range;
+	int err;
+
+	if (!capable(CAP_NET_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	if ((attr->map_type == BPF_MAP_TYPE_PIFO_XDP && attr->value_size != 4) ||
+	    attr->key_size != 4 || attr->map_extra & ~0xFFFFFFFFULL ||
+	    attr->map_flags & ~PIFO_CREATE_FLAG_MASK)
+		return ERR_PTR(-EINVAL);
+
+	range = attr->map_extra;
+	if (!range || !is_power_of_2(range))
+		return ERR_PTR(-EINVAL);
+
+	if (attr->map_type == BPF_MAP_TYPE_PIFO_GENERIC) {
+		elem_size = (attr->value_size + sizeof(struct bpf_pifo_element));
+		if (elem_size > U32_MAX / attr->max_entries)
+			return ERR_PTR(-E2BIG);
+	}
+
+	size = sizeof(*pifo) + attr->max_entries * elem_size;
+	pifo = bpf_map_area_alloc(size, numa_node);
+	if (!pifo)
+		return ERR_PTR(-ENOMEM);
+
+	err = pifo_map_init_map(pifo, attr, elem_size, range);
+	if (err) {
+		bpf_map_area_free(pifo);
+		return ERR_PTR(err);
+	}
+
+	spin_lock_init(&pifo->lock);
+	return &pifo->map;
+}
+
+static void pifo_queue_flush(struct bpf_pifo_queue *queue)
+{
+#ifdef CONFIG_NET
+	unsigned long *bitmap = queue->lvl_bitmap[queue->levels - 1];
+	int i = 0;
+
+	/* this is only ever called in the RCU callback when freeing the map, so
+	 * no need for locking
+	 */
+	while (i < queue->range) {
+		struct bpf_pifo_bucket *bucket = &queue->buckets[i];
+		struct xdp_frame *frame = &bucket->head->frame, *next;
+
+		while (frame) {
+			next = frame->next;
+			xdp_return_frame(frame);
+			frame = next;
+		}
+		i = find_next_bit(bitmap, queue->range, i + 1);
+	}
+#endif
+}
+
+static void pifo_map_free(struct bpf_map *map)
+{
+	struct bpf_pifo_map *pifo = container_of(map, struct bpf_pifo_map, map);
+
+	/* At this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
+	 * so the programs (can be more than one that used this map) were
+	 * disconnected from events. The following synchronize_rcu() guarantees
+	 * both rcu read critical sections complete and waits for
+	 * preempt-disable regions (NAPI being the relevant context here) so we
+	 * are certain there will be no further reads against the netdev_map and
+	 * all flush operations are complete. Flush operations can only be done
+	 * from NAPI context for this reason.
+	 */
+
+	synchronize_rcu();
+
+	if (map->map_type == BPF_MAP_TYPE_PIFO_XDP)
+		pifo_queue_flush(pifo->queue);
+	pifo_queue_free(pifo->queue);
+	bpf_map_area_free(pifo->elem_cache);
+	bpf_map_area_free(pifo);
+}
+
+static int pifo_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
+{
+	struct bpf_pifo_map *pifo = container_of(map, struct bpf_pifo_map, map);
+	u32 index = key ? *(u32 *)key : U32_MAX, offset;
+	struct bpf_pifo_queue *queue = pifo->queue;
+	unsigned long idx, flags;
+	u32 *next = next_key;
+	int ret = -ENOENT;
+
+	spin_lock_irqsave(&pifo->lock, flags);
+
+	if (index == U32_MAX || index < queue->min_rank)
+		offset = 0;
+	else
+		offset = index - queue->min_rank + 1;
+
+	if (offset >= queue->range)
+		goto out;
+
+	idx = find_next_bit(queue->lvl_bitmap[queue->levels - 1],
+			    queue->range, offset);
+	if (idx == queue->range)
+		goto out;
+
+	*next = idx;
+	ret = 0;
+out:
+	spin_unlock_irqrestore(&pifo->lock, flags);
+	return ret;
+}
+
+static void pifo_set_bit(struct bpf_pifo_queue *queue, u32 rank)
+{
+	u32 i;
+
+	for (i = queue->levels; i > 0; i--) {
+		unsigned long *bitmap = queue->lvl_bitmap[i - 1];
+
+		set_bit(rank, bitmap);
+		rank /= BITS_PER_TYPE(long);
+	}
+}
+
+static void pifo_clear_bit(struct bpf_pifo_queue *queue, u32 rank)
+{
+	u32 i;
+
+	for (i = queue->levels; i > 0; i--) {
+		unsigned long *bitmap = queue->lvl_bitmap[i - 1];
+
+		clear_bit(rank, bitmap);
+		rank /= BITS_PER_TYPE(long);
+
+		// another bit is set in this word, don't clear bit in higher
+		// level
+		if (*(bitmap + rank))
+			break;
+	}
+}
+
+static void pifo_item_set_next(union bpf_pifo_item *item, void *next, bool xdp)
+{
+	if (xdp)
+		item->frame.next = next;
+	else
+		item->elem.next = next;
+}
+
+static int __pifo_map_enqueue(struct bpf_pifo_map *pifo, union bpf_pifo_item *item,
+			      u64 rank, bool xdp)
+{
+	struct bpf_pifo_queue *queue = pifo->queue;
+	struct bpf_pifo_bucket *bucket;
+	u64 q_index;
+
+	lockdep_assert_held(&pifo->lock);
+
+	if (unlikely(pifo_map_is_full(pifo)))
+		return -EOVERFLOW;
+
+	if (rank < queue->min_rank)
+		return -ERANGE;
+
+	pifo_item_set_next(item, NULL, xdp);
+
+	q_index = rank - queue->min_rank;
+	if (unlikely(q_index >= queue->range))
+		q_index = queue->range - 1;
+
+	bucket = &queue->buckets[q_index];
+	if (likely(!bucket->head)) {
+		bucket->head = item;
+		bucket->tail = item;
+		pifo_set_bit(queue, q_index);
+	} else {
+		pifo_item_set_next(bucket->tail, item, xdp);
+		bucket->tail = item;
+	}
+
+	pifo->num_queued++;
+	bucket->elem_count++;
+	return 0;
+}
+
+int pifo_map_enqueue(struct bpf_map *map, struct xdp_frame *xdpf, u32 index)
+{
+	struct bpf_pifo_map *pifo = container_of(map, struct bpf_pifo_map, map);
+	int ret;
+
+	/* called under local_bh_disable() so no need to use irqsave variant */
+	spin_lock(&pifo->lock);
+	ret = __pifo_map_enqueue(pifo, (union bpf_pifo_item *)xdpf, index, true);
+	spin_unlock(&pifo->lock);
+
+	return ret;
+}
+
+static unsigned long pifo_find_first_bucket(struct bpf_pifo_queue *queue)
+{
+	unsigned long *bitmap, bit = 0, offset = 0;
+	int i;
+
+	for (i = 0; i < queue->levels; i++) {
+		bitmap = queue->lvl_bitmap[i] + offset;
+		if (!*bitmap)
+			return -1;
+		bit = __ffs(*bitmap);
+		offset = offset * BITS_PER_TYPE(long) + bit;
+	}
+	return offset;
+}
+
+static union bpf_pifo_item *__pifo_map_dequeue(struct bpf_pifo_map *pifo,
+					       u64 flags, u64 *rank, bool xdp)
+{
+	struct bpf_pifo_queue *queue = pifo->queue;
+	struct bpf_pifo_bucket *bucket;
+	union bpf_pifo_item *item;
+	unsigned long bucket_idx;
+
+	lockdep_assert_held(&pifo->lock);
+
+	if (flags) {
+		*rank = -EINVAL;
+		return NULL;
+	}
+
+	bucket_idx = pifo_find_first_bucket(queue);
+	if (bucket_idx == -1) {
+		*rank = -ENOENT;
+		return NULL;
+	}
+	bucket = &queue->buckets[bucket_idx];
+
+	if (WARN_ON_ONCE(!bucket->tail)) {
+		*rank = -EFAULT;
+		return NULL;
+	}
+
+	item = bucket->head;
+	if (xdp)
+		bucket->head = (union bpf_pifo_item *)item->frame.next;
+	else
+		bucket->head = (union bpf_pifo_item *)item->elem.next;
+
+	if (!bucket->head) {
+		bucket->tail = NULL;
+		pifo_clear_bit(queue, bucket_idx);
+	}
+	pifo->num_queued--;
+	bucket->elem_count--;
+
+	*rank = bucket_idx + queue->min_rank;
+	return item;
+}
+
+struct xdp_frame *pifo_map_dequeue(struct bpf_map *map, u64 flags, u64 *rank)
+{
+	struct bpf_pifo_map *pifo = container_of(map, struct bpf_pifo_map, map);
+	union bpf_pifo_item *item;
+	unsigned long lflags;
+
+	spin_lock_irqsave(&pifo->lock, lflags);
+	item = __pifo_map_dequeue(pifo, flags, rank, true);
+	spin_unlock_irqrestore(&pifo->lock, lflags);
+
+	return item ? &item->frame : NULL;
+}
+
+static void *pifo_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	struct bpf_pifo_map *pifo = container_of(map, struct bpf_pifo_map, map);
+	struct bpf_pifo_queue *queue = pifo->queue;
+	struct bpf_pifo_bucket *bucket;
+	u32 rank =  *(u32 *)key, idx;
+
+	if (rank < queue->min_rank)
+		return NULL;
+
+	idx = rank - queue->min_rank;
+	if (idx >= queue->range)
+		return NULL;
+
+	bucket = &queue->buckets[idx];
+	/* FIXME: what happens if this changes while userspace is reading the
+	 * value
+	 */
+	return &bucket->elem_count;
+}
+
+static int pifo_map_push_elem(struct bpf_map *map, void *value, u64 flags)
+{
+	struct bpf_pifo_map *pifo = container_of(map, struct bpf_pifo_map, map);
+	struct bpf_pifo_element *dst;
+	unsigned long irq_flags;
+	u64 prio;
+	int ret;
+
+	/* Check if any of the actual flag bits are set */
+	if (flags & ~BPF_PIFO_PRIO_MASK)
+		return -EINVAL;
+
+	prio = flags & BPF_PIFO_PRIO_MASK;
+
+	spin_lock_irqsave(&pifo->lock, irq_flags);
+
+	dst = elem_cache_get(pifo->elem_cache);
+	if (!dst) {
+		ret = -EOVERFLOW;
+		goto out;
+	}
+
+	memcpy(&dst->data, value, pifo->map.value_size);
+
+	ret = __pifo_map_enqueue(pifo, (union bpf_pifo_item *)dst, prio, false);
+	if (ret)
+		elem_cache_put(pifo->elem_cache, dst);
+
+out:
+	spin_unlock_irqrestore(&pifo->lock, irq_flags);
+	return ret;
+}
+
+static int pifo_map_pop_elem(struct bpf_map *map, void *value)
+{
+	struct bpf_pifo_map *pifo = container_of(map, struct bpf_pifo_map, map);
+	union bpf_pifo_item *item;
+	unsigned long flags;
+	int err = 0;
+	u64 rank;
+
+	spin_lock_irqsave(&pifo->lock, flags);
+
+	item = __pifo_map_dequeue(pifo, 0, &rank, false);
+	if (!item) {
+		err = rank;
+		goto out;
+	}
+
+	memcpy(value, &item->elem.data, pifo->map.value_size);
+	elem_cache_put(pifo->elem_cache, &item->elem);
+
+out:
+	spin_unlock_irqrestore(&pifo->lock, flags);
+	return err;
+}
+
+static int pifo_map_update_elem(struct bpf_map *map, void *key, void *value,
+				u64 map_flags)
+{
+	return -EINVAL;
+}
+
+static int pifo_map_delete_elem(struct bpf_map *map, void *key)
+{
+	return -EINVAL;
+}
+
+static int pifo_map_peek_elem(struct bpf_map *map, void *value)
+{
+	return -EINVAL;
+}
+
+static int pifo_map_redirect(struct bpf_map *map, u64 index, u64 flags)
+{
+#ifdef CONFIG_NET
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	const u64 action_mask = XDP_ABORTED | XDP_DROP | XDP_PASS | XDP_TX;
+
+	/* Lower bits of the flags are used as return code on lookup failure */
+	if (unlikely(flags & ~action_mask))
+		return XDP_ABORTED;
+
+	ri->tgt_value = NULL;
+	ri->tgt_index = index;
+	ri->map_id = map->id;
+	ri->map_type = map->map_type;
+	ri->flags = flags;
+	WRITE_ONCE(ri->map, map);
+	return XDP_REDIRECT;
+#else
+	return XDP_ABORTED;
+#endif
+}
+
+BTF_ID_LIST_SINGLE(pifo_xdp_map_btf_ids, struct, bpf_pifo_map);
+const struct bpf_map_ops pifo_xdp_map_ops = {
+	.map_meta_equal = bpf_map_meta_equal,
+	.map_alloc = pifo_map_alloc,
+	.map_free = pifo_map_free,
+	.map_get_next_key = pifo_map_get_next_key,
+	.map_lookup_elem = pifo_map_lookup_elem,
+	.map_update_elem = pifo_map_update_elem,
+	.map_delete_elem = pifo_map_delete_elem,
+	.map_check_btf = map_check_no_btf,
+	.map_btf_id = &pifo_xdp_map_btf_ids[0],
+	.map_redirect = pifo_map_redirect,
+};
+
+BTF_ID_LIST_SINGLE(pifo_generic_map_btf_ids, struct, bpf_pifo_map);
+const struct bpf_map_ops pifo_generic_map_ops = {
+	.map_meta_equal = bpf_map_meta_equal,
+	.map_alloc = pifo_map_alloc,
+	.map_free = pifo_map_free,
+	.map_get_next_key = pifo_map_get_next_key,
+	.map_lookup_elem = pifo_map_lookup_elem,
+	.map_update_elem = pifo_map_update_elem,
+	.map_delete_elem = pifo_map_delete_elem,
+	.map_push_elem = pifo_map_push_elem,
+	.map_pop_elem = pifo_map_pop_elem,
+	.map_peek_elem = pifo_map_peek_elem,
+	.map_check_btf = map_check_no_btf,
+	.map_btf_id = &pifo_generic_map_btf_ids[0],
+};
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ab688d85b2c6..31899882e513 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1066,6 +1066,8 @@ static int map_create(union bpf_attr *attr)
 	}
 
 	if (attr->map_type != BPF_MAP_TYPE_BLOOM_FILTER &&
+	    attr->map_type != BPF_MAP_TYPE_PIFO_XDP &&
+	    attr->map_type != BPF_MAP_TYPE_PIFO_GENERIC &&
 	    attr->map_extra != 0)
 		return -EINVAL;
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 039f7b61c305..489ea3f368a1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6249,6 +6249,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		break;
 	case BPF_MAP_TYPE_QUEUE:
 	case BPF_MAP_TYPE_STACK:
+	case BPF_MAP_TYPE_PIFO_GENERIC:
 		if (func_id != BPF_FUNC_map_peek_elem &&
 		    func_id != BPF_FUNC_map_pop_elem &&
 		    func_id != BPF_FUNC_map_push_elem)
@@ -6274,6 +6275,10 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    func_id != BPF_FUNC_map_push_elem)
 			goto error;
 		break;
+	case BPF_MAP_TYPE_PIFO_XDP:
+		if (func_id != BPF_FUNC_redirect_map)
+			goto error;
+		break;
 	default:
 		break;
 	}
@@ -6318,6 +6323,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (map->map_type != BPF_MAP_TYPE_DEVMAP &&
 		    map->map_type != BPF_MAP_TYPE_DEVMAP_HASH &&
 		    map->map_type != BPF_MAP_TYPE_CPUMAP &&
+		    map->map_type != BPF_MAP_TYPE_PIFO_XDP &&
 		    map->map_type != BPF_MAP_TYPE_XSKMAP)
 			goto error;
 		break;
@@ -6346,13 +6352,15 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		break;
 	case BPF_FUNC_map_pop_elem:
 		if (map->map_type != BPF_MAP_TYPE_QUEUE &&
-		    map->map_type != BPF_MAP_TYPE_STACK)
+		    map->map_type != BPF_MAP_TYPE_STACK &&
+		    map->map_type != BPF_MAP_TYPE_PIFO_GENERIC)
 			goto error;
 		break;
 	case BPF_FUNC_map_peek_elem:
 	case BPF_FUNC_map_push_elem:
 		if (map->map_type != BPF_MAP_TYPE_QUEUE &&
 		    map->map_type != BPF_MAP_TYPE_STACK &&
+		    map->map_type != BPF_MAP_TYPE_PIFO_GENERIC &&
 		    map->map_type != BPF_MAP_TYPE_BLOOM_FILTER)
 			goto error;
 		break;
diff --git a/net/core/filter.c b/net/core/filter.c
index e23e53ed1b04..8e6ea17a29db 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4236,6 +4236,13 @@ static __always_inline int __xdp_do_redirect_frame(struct bpf_redirect_info *ri,
 			err = dev_map_enqueue(fwd, xdpf, dev);
 		}
 		break;
+	case BPF_MAP_TYPE_PIFO_XDP:
+		map = READ_ONCE(ri->map);
+		if (unlikely(!map))
+			err = -EINVAL;
+		else
+			err = pifo_map_enqueue(map, xdpf, ri->tgt_index);
+		break;
 	case BPF_MAP_TYPE_CPUMAP:
 		err = cpu_map_enqueue(fwd, xdpf, dev);
 		break;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 379e68fb866f..623421377f6e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -909,6 +909,8 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_INODE_STORAGE,
 	BPF_MAP_TYPE_TASK_STORAGE,
 	BPF_MAP_TYPE_BLOOM_FILTER,
+	BPF_MAP_TYPE_PIFO_GENERIC,
+	BPF_MAP_TYPE_PIFO_XDP,
 };
 
 /* Note that tracing related programs such as
@@ -1244,6 +1246,13 @@ enum {
 /* If set, XDP frames will be transmitted after processing */
 #define BPF_F_TEST_XDP_LIVE_FRAMES	(1U << 1)
 
+/* Flags for BPF_MAP_TYPE_PIFO_* */
+
+/* Used for flags argument of bpf_map_push_elem(); reserve top four bits for
+ * actual flags, the rest is the enqueue priority
+ */
+#define BPF_PIFO_PRIO_MASK	(~0ULL >> 4)
+
 /* type for BPF_ENABLE_STATS */
 enum bpf_stats_type {
 	/* enabled run_time_ns and run_cnt */
@@ -1298,6 +1307,10 @@ union bpf_attr {
 		 * BPF_MAP_TYPE_BLOOM_FILTER - the lowest 4 bits indicate the
 		 * number of hash functions (if 0, the bloom filter will default
 		 * to using 5 hash functions).
+		 *
+		 * BPF_MAP_TYPE_PIFO_* - the lower 32 bits indicate the valid
+		 * range of priorities for entries enqueued in the map. Must be
+		 * a power of two.
 		 */
 		__u64	map_extra;
 	};
-- 
2.37.0

