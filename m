Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91C53690CF
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 13:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242216AbhDWLGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 07:06:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50911 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242149AbhDWLGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 07:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619175925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P5pxWWEwDPsI/lkLQ7B9CkGVVfb+v2beJFRMQPSWoOc=;
        b=EeTdZVr97oKsm75bj1IlwhgibrR7T8Yt5yv2om5b06dk7ugrW1FiQx3xbWtRjbaso0BSCq
        rz27vc3Hy1u7P7YKjVzGxSvuTMj4AROVsEKvXZ1CFBPzw4qcwvqDNevQ5owsA6SS4XsueH
        WuyP07ElVOglfbTV1Oyjvjuf6UOFhaw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-D0z2VAU9PEWRoNeRNn-gpw-1; Fri, 23 Apr 2021 07:05:23 -0400
X-MC-Unique: D0z2VAU9PEWRoNeRNn-gpw-1
Received: by mail-ed1-f71.google.com with SMTP id r14-20020a50d68e0000b0290385504d6e4eso8498850edi.7
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 04:05:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=P5pxWWEwDPsI/lkLQ7B9CkGVVfb+v2beJFRMQPSWoOc=;
        b=mSIvMQRMTNFG5S1OiqtHy/RSJYuZloyLF3zH9XjSpZs43w8akYi0Uc7mUf2n3lq5WU
         a7aiTZ2JCbIowBLde77sSyMV/OZhqpDSyGPVc4WaWYYJA7PlZ+OJ8kYe4X2TlOoW/Hxl
         k15kZfB8n0vzzV4rQttQiD7KEblhrjLY8vSCTczsxsnsNdtqUtUTHNa+qa6M2dRbMC7w
         iuqtNmsgE7rGm1KZSkrGnwkaFWE8DEPK4BMRIhypYZWTguR/MqM5Q+JfIg74PyLiN6gB
         T9dwZDDAjaVKMqVV4XrHcLVf0/xc/PNcX804hpNswGgDhBFVWe14Oxi4PYtYshAFNisN
         ToKQ==
X-Gm-Message-State: AOAM5326rPkdY1xOh4lTB6vScMEjH04a+GbjKjUAUdXIgocbuBIrFzvp
        RUOrFTrAUWkXBY0u4GE4Qs6RHXOhQ7nUK7FrMRe2t7+vFqw9cbqt2x79nd6B3mTbeHSkyZCD99u
        05/B7cS6ho9BTWrbs
X-Received: by 2002:a17:906:5585:: with SMTP id y5mr3524032ejp.129.1619175921384;
        Fri, 23 Apr 2021 04:05:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbddJ6f33AvDiRUAG56laKa8qGA6nBD1mudjJzXfoX1SlyBHctyz9o6LFxWeA9+u1+vtJ/Fg==
X-Received: by 2002:a17:906:5585:: with SMTP id y5mr3523984ejp.129.1619175920864;
        Fri, 23 Apr 2021 04:05:20 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f7sm3847587ejz.95.2021.04.23.04.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 04:05:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EB9A1180677; Fri, 23 Apr 2021 13:05:18 +0200 (CEST)
Subject: [PATCH RFC bpf-next 3/4] xdp: add proper __rcu annotations to
 redirect map entries
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Date:   Fri, 23 Apr 2021 13:05:18 +0200
Message-ID: <161917591888.102337.17261581380237633381.stgit@toke.dk>
In-Reply-To: <161917591559.102337.3558507780042453425.stgit@toke.dk>
References: <161917591559.102337.3558507780042453425.stgit@toke.dk>
User-Agent: StGit/1.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

XDP_REDIRECT works by a three-step process: the bpf_redirect() and
bpf_redirect_map() helpers will lookup the target of the redirect and store
it (along with some other metadata) in a per-CPU struct bpf_redirect_info.
Next, when the program returns the XDP_REDIRECT return code, the driver
will call xdp_do_redirect() which will use the information thus stored to
actually enqueue the frame into a bulk queue structure (that differs
slightly by map type, but shares the same principle). Finally, before
exiting its NAPI poll loop, the driver will call xdp_do_flush(), which will
flush all the different bulk queues, thus completing the redirect.

Pointers to the map entries will be kept around for this whole sequence of
steps, protected by RCU. However, there is no top-level rcu_read_lock() in
the core code; instead drivers add their own rcu_read_lock() around the XDP
portions of the code, but somewhat inconsistently as Martin discovered[0].
However, things still work because everything happens inside a single NAPI
poll sequence, which means it's between a pair of calls to
local_bh_disable()/local_bh_enable(). So Paul suggested[1] that we could
document this intention by using rcu_dereference_check() with
rcu_read_lock_bh_held() as a second parameter, thus allowing sparse and
lockdep to verify that everything is done correctly.

This patch does just that: we add an __rcu annotation to the map entry
pointers and remove the various comments explaining the NAPI poll assurance
strewn through devmap.c in favour of a longer explanation in filter.c. The
goal is to have one coherent documentation of the entire flow, and rely on
the RCU annotations as a "standard" way of communicating the flow in the
map code (which can additionally be understood by sparse and lockdep).

The RCU annotation replacements result in a fairly straight-forward
replacement where READ_ONCE() becomes rcu_dereference_check(), WRITE_ONCE()
becomes rcu_assign_pointer() and xchg() and cmpxchg() gets wrapped in the
proper constructs to cast the pointer back and forth between __rcu and
__kernel address space (for the benefit of sparse). The one complication is
that xskmap has a few constructions where double-pointers are passed back
and forth; these simply all gain __rcu annotations, and only the final
reference/dereference to the inner-most pointer gets changed.

With this, everything can be run through sparse without eliciting
complaints, and lockdep can verify correctness even without the use of
rcu_read_lock() in the drivers. Subsequent patches will clean these up from
the drivers.

[0] https://lore.kernel.org/bpf/20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com/
[1] https://lore.kernel.org/bpf/20210419165837.GA975577@paulmck-ThinkPad-P17-Gen-1/

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/xdp_sock.h |    2 +-
 kernel/bpf/cpumap.c    |   14 +++++++++----
 kernel/bpf/devmap.c    |   52 +++++++++++++++++++++---------------------------
 net/core/filter.c      |   28 ++++++++++++++++++++++++++
 net/xdp/xsk.c          |    4 ++--
 net/xdp/xsk.h          |    4 ++--
 net/xdp/xskmap.c       |   29 ++++++++++++++++-----------
 7 files changed, 83 insertions(+), 50 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 9c0722c6d7ac..fff069d2ed1b 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -37,7 +37,7 @@ struct xdp_umem {
 struct xsk_map {
 	struct bpf_map map;
 	spinlock_t lock; /* Synchronize map updates */
-	struct xdp_sock *xsk_map[];
+	struct xdp_sock __rcu *xsk_map[];
 };
 
 struct xdp_sock {
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 0cf2791d5099..5e51d939ddf5 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -74,7 +74,7 @@ struct bpf_cpu_map_entry {
 struct bpf_cpu_map {
 	struct bpf_map map;
 	/* Below members specific for map type */
-	struct bpf_cpu_map_entry **cpu_map;
+	struct bpf_cpu_map_entry __rcu **cpu_map;
 };
 
 static DEFINE_PER_CPU(struct list_head, cpu_map_flush_list);
@@ -469,7 +469,7 @@ static void __cpu_map_entry_replace(struct bpf_cpu_map *cmap,
 {
 	struct bpf_cpu_map_entry *old_rcpu;
 
-	old_rcpu = xchg(&cmap->cpu_map[key_cpu], rcpu);
+	old_rcpu = unrcu_pointer(xchg(&cmap->cpu_map[key_cpu], RCU_INITIALIZER(rcpu)));
 	if (old_rcpu) {
 		call_rcu(&old_rcpu->rcu, __cpu_map_entry_free);
 		INIT_WORK(&old_rcpu->kthread_stop_wq, cpu_map_kthread_stop);
@@ -551,7 +551,8 @@ static void cpu_map_free(struct bpf_map *map)
 	for (i = 0; i < cmap->map.max_entries; i++) {
 		struct bpf_cpu_map_entry *rcpu;
 
-		rcpu = READ_ONCE(cmap->cpu_map[i]);
+		rcpu = rcu_dereference_check(cmap->cpu_map[i],
+					     rcu_read_lock_bh_held());
 		if (!rcpu)
 			continue;
 
@@ -562,6 +563,10 @@ static void cpu_map_free(struct bpf_map *map)
 	kfree(cmap);
 }
 
+/* Elements are kept alive by RCU; either by rcu_read_lock() (from syscall) or
+ * by local_bh_disable() (from XDP calls inside NAPI). The
+ * rcu_read_lock_bh_held() below makes lockdep accept both.
+ */
 static void *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
 {
 	struct bpf_cpu_map *cmap = container_of(map, struct bpf_cpu_map, map);
@@ -570,7 +575,8 @@ static void *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
 	if (key >= map->max_entries)
 		return NULL;
 
-	rcpu = READ_ONCE(cmap->cpu_map[key]);
+	rcpu = rcu_dereference_check(cmap->cpu_map[key],
+				     rcu_read_lock_bh_held());
 	return rcpu;
 }
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index aa516472ce46..a1d2e86c8898 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -72,7 +72,7 @@ struct bpf_dtab_netdev {
 
 struct bpf_dtab {
 	struct bpf_map map;
-	struct bpf_dtab_netdev **netdev_map; /* DEVMAP type only */
+	struct bpf_dtab_netdev __rcu **netdev_map; /* DEVMAP type only */
 	struct list_head list;
 
 	/* these are only used for DEVMAP_HASH type maps */
@@ -224,7 +224,7 @@ static void dev_map_free(struct bpf_map *map)
 		for (i = 0; i < dtab->map.max_entries; i++) {
 			struct bpf_dtab_netdev *dev;
 
-			dev = dtab->netdev_map[i];
+			dev = rcu_dereference_raw(dtab->netdev_map[i]);
 			if (!dev)
 				continue;
 
@@ -257,6 +257,10 @@ static int dev_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	return 0;
 }
 
+/* Elements are kept alive by RCU; either by rcu_read_lock() (from syscall) or
+ * by local_bh_disable() (from XDP calls inside NAPI). The
+ * rcu_read_lock_bh_held() below makes lockdep accept both.
+ */
 static void *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
@@ -264,7 +268,8 @@ static void *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
 	struct bpf_dtab_netdev *dev;
 
 	hlist_for_each_entry_rcu(dev, head, index_hlist,
-				 lockdep_is_held(&dtab->index_lock))
+				 (lockdep_is_held(&dtab->index_lock) ||
+				  rcu_read_lock_bh_held()))
 		if (dev->idx == key)
 			return dev;
 
@@ -362,15 +367,9 @@ static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 	__list_del_clearprev(&bq->flush_node);
 }
 
-/* __dev_flush is called from xdp_do_flush() which _must_ be signaled
- * from the driver before returning from its napi->poll() routine. The poll()
- * routine is called either from busy_poll context or net_rx_action signaled
- * from NET_RX_SOFTIRQ. Either way the poll routine must complete before the
- * net device can be torn down. On devmap tear down we ensure the flush list
- * is empty before completing to ensure all flush operations have completed.
- * When drivers update the bpf program they may need to ensure any flush ops
- * are also complete. Using synchronize_rcu or call_rcu will suffice for this
- * because both wait for napi context to exit.
+/* __dev_flush is called from xdp_do_flush() which _must_ be signalled from the
+ * driver before returning from its napi->poll() routine. See the comment above
+ * xdp_do_flush() in filter.c.
  */
 void __dev_flush(void)
 {
@@ -381,9 +380,9 @@ void __dev_flush(void)
 		bq_xmit_all(bq, XDP_XMIT_FLUSH);
 }
 
-/* rcu_read_lock (from syscall and BPF contexts) ensures that if a delete and/or
- * update happens in parallel here a dev_put wont happen until after reading the
- * ifindex.
+/* Elements are kept alive by RCU; either by rcu_read_lock() (from syscall) or
+ * by local_bh_disable() (from XDP calls inside NAPI). The
+ * rcu_read_lock_bh_held() below makes lockdep accept both.
  */
 static void *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
 {
@@ -393,12 +392,14 @@ static void *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
 	if (key >= map->max_entries)
 		return NULL;
 
-	obj = READ_ONCE(dtab->netdev_map[key]);
+	obj = rcu_dereference_check(dtab->netdev_map[key],
+				    rcu_read_lock_bh_held());
 	return obj;
 }
 
-/* Runs under RCU-read-side, plus in softirq under NAPI protection.
- * Thus, safe percpu variable access.
+/* Runs in NAPI, i.e., softirq under local_bh_disable(). Thus, safe percpu
+ * variable access, and map elements stick around. See comment above
+ * xdp_do_flush() in filter.c.
  */
 static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 		       struct net_device *dev_rx)
@@ -538,14 +539,7 @@ static int dev_map_delete_elem(struct bpf_map *map, void *key)
 	if (k >= map->max_entries)
 		return -EINVAL;
 
-	/* Use call_rcu() here to ensure any rcu critical sections have
-	 * completed as well as any flush operations because call_rcu
-	 * will wait for preempt-disable region to complete, NAPI in this
-	 * context.  And additionally, the driver tear down ensures all
-	 * soft irqs are complete before removing the net device in the
-	 * case of dev_put equals zero.
-	 */
-	old_dev = xchg(&dtab->netdev_map[k], NULL);
+	old_dev = unrcu_pointer(xchg(&dtab->netdev_map[k], NULL));
 	if (old_dev)
 		call_rcu(&old_dev->rcu, __dev_map_entry_free);
 	return 0;
@@ -654,7 +648,7 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
 	 * Remembering the driver side flush operation will happen before the
 	 * net device is removed.
 	 */
-	old_dev = xchg(&dtab->netdev_map[i], dev);
+	old_dev = unrcu_pointer(xchg(&dtab->netdev_map[i], RCU_INITIALIZER(dev)));
 	if (old_dev)
 		call_rcu(&old_dev->rcu, __dev_map_entry_free);
 
@@ -830,10 +824,10 @@ static int dev_map_notification(struct notifier_block *notifier,
 			for (i = 0; i < dtab->map.max_entries; i++) {
 				struct bpf_dtab_netdev *dev, *odev;
 
-				dev = READ_ONCE(dtab->netdev_map[i]);
+				dev = rcu_dereference(dtab->netdev_map[i]);
 				if (!dev || netdev != dev->dev)
 					continue;
-				odev = cmpxchg(&dtab->netdev_map[i], dev, NULL);
+				odev = unrcu_pointer(cmpxchg(&dtab->netdev_map[i], RCU_INITIALIZER(dev), NULL));
 				if (dev == odev)
 					call_rcu(&dev->rcu,
 						 __dev_map_entry_free);
diff --git a/net/core/filter.c b/net/core/filter.c
index cae56d08a670..e2c0dc2b551c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3918,6 +3918,34 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+/* XDP_REDIRECT works by a three-step process, implemented in the functions
+ * below:
+ *
+ * 1. The bpf_redirect() and bpf_redirect_map() helpers will lookup the target
+ *    of the redirect and store it (along with some other metadata) in a per-CPU
+ *    struct bpf_redirect_info.
+ *
+ * 2. When the program returns the XDP_REDIRECT return code, the driver will
+ *    call xdp_do_redirect() which will use the information in struct
+ *    bpf_redirect_info to actually enqueue the frame into a map type-specific
+ *    bulk queue structure.
+ *
+ * 3. Before exiting its NAPI poll loop, the driver will call xdp_do_flush(),
+ *    which will flush all the different bulk queues, thus completing the
+ *    redirect.
+ *
+ * Pointers to the map entries will be kept around for this whole sequence of
+ * steps, protected by RCU. However, there is no top-level rcu_read_lock() in
+ * the core code; instead, the RCU protection relies on everything happening
+ * inside a single NAPI poll sequence, which means it's between a pair of calls
+ * to local_bh_disable()/local_bh_enable().
+ *
+ * The map entries are marked as __rcu and the map code makes sure to
+ * dereference those pointers with rcu_dereference_check() in a way that works
+ * for both sections that to hold an rcu_read_lock() and sections that are
+ * called from NAPI without a separate rcu_read_lock(). The code below does not
+ * use RCU annotations, but relies on those in the map code.
+ */
 void xdp_do_flush(void)
 {
 	__dev_flush();
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a71ed664da0a..f910445aad85 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -749,7 +749,7 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
 }
 
 static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
-					      struct xdp_sock ***map_entry)
+					      struct xdp_sock __rcu ***map_entry)
 {
 	struct xsk_map *map = NULL;
 	struct xsk_map_node *node;
@@ -785,7 +785,7 @@ static void xsk_delete_from_maps(struct xdp_sock *xs)
 	 * might be updates to the map between
 	 * xsk_get_map_list_entry() and xsk_map_try_sock_delete().
 	 */
-	struct xdp_sock **map_entry = NULL;
+	struct xdp_sock __rcu **map_entry = NULL;
 	struct xsk_map *map;
 
 	while ((map = xsk_get_map_list_entry(xs, &map_entry))) {
diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
index edcf249ad1f1..a4bc4749faac 100644
--- a/net/xdp/xsk.h
+++ b/net/xdp/xsk.h
@@ -31,7 +31,7 @@ struct xdp_mmap_offsets_v1 {
 struct xsk_map_node {
 	struct list_head node;
 	struct xsk_map *map;
-	struct xdp_sock **map_entry;
+	struct xdp_sock __rcu **map_entry;
 };
 
 static inline struct xdp_sock *xdp_sk(struct sock *sk)
@@ -40,7 +40,7 @@ static inline struct xdp_sock *xdp_sk(struct sock *sk)
 }
 
 void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
-			     struct xdp_sock **map_entry);
+			     struct xdp_sock __rcu **map_entry);
 void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
 int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
 			u16 queue_id);
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 67b4ce504852..b8b90abbae67 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -12,7 +12,7 @@
 #include "xsk.h"
 
 static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
-					       struct xdp_sock **map_entry)
+					       struct xdp_sock __rcu **map_entry)
 {
 	struct xsk_map_node *node;
 
@@ -42,7 +42,7 @@ static void xsk_map_sock_add(struct xdp_sock *xs, struct xsk_map_node *node)
 }
 
 static void xsk_map_sock_delete(struct xdp_sock *xs,
-				struct xdp_sock **map_entry)
+				struct xdp_sock __rcu **map_entry)
 {
 	struct xsk_map_node *n, *tmp;
 
@@ -124,6 +124,10 @@ static int xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 	return insn - insn_buf;
 }
 
+/* Elements are kept alive by RCU; either by rcu_read_lock() (from syscall) or
+ * by local_bh_disable() (from XDP calls inside NAPI). The
+ * rcu_read_lock_bh_held() below makes lockdep accept both.
+ */
 static void *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
@@ -131,12 +135,11 @@ static void *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
 	if (key >= map->max_entries)
 		return NULL;
 
-	return READ_ONCE(m->xsk_map[key]);
+	return rcu_dereference_check(m->xsk_map[key], rcu_read_lock_bh_held());
 }
 
 static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held());
 	return __xsk_map_lookup_elem(map, *(u32 *)key);
 }
 
@@ -149,7 +152,8 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 			       u64 map_flags)
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
-	struct xdp_sock *xs, *old_xs, **map_entry;
+	struct xdp_sock __rcu **map_entry;
+	struct xdp_sock *xs, *old_xs;
 	u32 i = *(u32 *)key, fd = *(u32 *)value;
 	struct xsk_map_node *node;
 	struct socket *sock;
@@ -179,7 +183,7 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 	}
 
 	spin_lock_bh(&m->lock);
-	old_xs = READ_ONCE(*map_entry);
+	old_xs = rcu_dereference_check(*map_entry, rcu_read_lock_bh_held());
 	if (old_xs == xs) {
 		err = 0;
 		goto out;
@@ -191,7 +195,7 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 		goto out;
 	}
 	xsk_map_sock_add(xs, node);
-	WRITE_ONCE(*map_entry, xs);
+	rcu_assign_pointer(*map_entry, xs);
 	if (old_xs)
 		xsk_map_sock_delete(old_xs, map_entry);
 	spin_unlock_bh(&m->lock);
@@ -208,7 +212,8 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 static int xsk_map_delete_elem(struct bpf_map *map, void *key)
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
-	struct xdp_sock *old_xs, **map_entry;
+	struct xdp_sock __rcu **map_entry;
+	struct xdp_sock *old_xs;
 	int k = *(u32 *)key;
 
 	if (k >= map->max_entries)
@@ -216,7 +221,7 @@ static int xsk_map_delete_elem(struct bpf_map *map, void *key)
 
 	spin_lock_bh(&m->lock);
 	map_entry = &m->xsk_map[k];
-	old_xs = xchg(map_entry, NULL);
+	old_xs = unrcu_pointer(xchg(map_entry, NULL));
 	if (old_xs)
 		xsk_map_sock_delete(old_xs, map_entry);
 	spin_unlock_bh(&m->lock);
@@ -230,11 +235,11 @@ static int xsk_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 }
 
 void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
-			     struct xdp_sock **map_entry)
+			     struct xdp_sock __rcu **map_entry)
 {
 	spin_lock_bh(&map->lock);
-	if (READ_ONCE(*map_entry) == xs) {
-		WRITE_ONCE(*map_entry, NULL);
+	if (rcu_dereference(*map_entry) == xs) {
+		rcu_assign_pointer(*map_entry, NULL);
 		xsk_map_sock_delete(xs, map_entry);
 	}
 	spin_unlock_bh(&map->lock);

