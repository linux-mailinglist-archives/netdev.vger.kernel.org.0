Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41AD55EEBF
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiF1TxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiF1Tuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:55 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BE6B32;
        Tue, 28 Jun 2022 12:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445781; x=1687981781;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n8tgrMr0VAIA81agqiL4xe/2c0TDcto2yGzG790rA4Y=;
  b=kmSoO7mpN/IUIF/DLdVYQuwt4yMAMSTqQEq/K4h2Keq8hYLV5SMdz/mj
   YFcfhxoWDjPVBBjwuf72ChjjmbPXJKzMOwDdPLz0Xy9v+R9aRofslXSaX
   cA2FrRMrbqEi1/+LyC0CMk7Wpr5RLE2jOues2MHZ4ZVttyhx5i/3v7Pve
   V7g4dXJfiGtg8FRqYN7qCG7DmTB8zmbvhtFydTUa1BXr7S1nmgkj2i/Mh
   cPjB9gA2FHKJ7JzeojYHxSUdULAEalcPcYRmxzkB/RTxuDWCvqA2e/epm
   aE2bPkChXY9hoG7Dyv+59x2Uzx5av/D3aKSjq7zJXI6LmNt6bgJhTwemn
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282568232"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282568232"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="590426373"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 28 Jun 2022 12:49:35 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9U022013;
        Tue, 28 Jun 2022 20:49:34 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 30/52] net, gro: decouple GRO from the NAPI layer
Date:   Tue, 28 Jun 2022 21:47:50 +0200
Message-Id: <20220628194812.1453059-31-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In fact, these two are not tied closely to each other. The only
requirement to GRO is to use it in the BH context and have some
sane limits on the packet batches, e.g. NAPI has a limit of its
budget (64/8/etc.).
Factor out purely GRO fields into a new structure, &gro_node.
Embed it into &napi_struct and adjust all the references. ::timer
was moved because it is more tied to GRO than to NAPI as the former
relies on deciding whether to do a full or a partial flush.
This does not make GRO ready to use outside of the NAPI context
yet.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/brocade/bna/bnad.c |  1 +
 drivers/net/ethernet/cortina/gemini.c   |  1 +
 include/linux/netdevice.h               | 19 ++++---
 include/net/gro.h                       | 35 ++++++++----
 net/core/dev.c                          | 75 +++++++++++--------------
 net/core/gro.c                          | 63 ++++++++++-----------
 6 files changed, 103 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index f6fe08df568b..8bcae1616b15 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -19,6 +19,7 @@
 #include <linux/ip.h>
 #include <linux/prefetch.h>
 #include <linux/module.h>
+#include <net/gro.h>
 
 #include "bnad.h"
 #include "bna.h"
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 9e6de2f968fa..6f208ce457dd 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -40,6 +40,7 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <net/gro.h>
 
 #include "gemini.h"
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index bc2d82a3d0de..60df42b3f116 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -318,11 +318,19 @@ struct gro_list {
 };
 
 /*
- * size of gro hash buckets, must less than bit number of
- * napi_struct::gro_bitmask
+ * size of gro hash buckets, must be <= the number of bits in
+ * gro_node::bitmask
  */
 #define GRO_HASH_BUCKETS	8
 
+struct gro_node {
+	unsigned long		bitmask;	/* Mask of used buckets */
+	struct gro_list		hash[GRO_HASH_BUCKETS]; /* Pending GRO skbs */
+	struct list_head	rx_list;	/* Pending GRO_NORMAL skbs */
+	int			rx_count;	/* Length of rx_list */
+	struct hrtimer		timer;		/* Timer for deferred flush */
+};
+
 /*
  * Structure for NAPI scheduling similar to tasklet but with weighting
  */
@@ -338,17 +346,13 @@ struct napi_struct {
 	unsigned long		state;
 	int			weight;
 	int			defer_hard_irqs_count;
-	unsigned long		gro_bitmask;
 	int			(*poll)(struct napi_struct *, int);
 #ifdef CONFIG_NETPOLL
 	int			poll_owner;
 #endif
 	struct net_device	*dev;
-	struct gro_list		gro_hash[GRO_HASH_BUCKETS];
+	struct gro_node		gro;
 	struct sk_buff		*skb;
-	struct list_head	rx_list; /* Pending GRO_NORMAL skbs */
-	int			rx_count; /* length of rx_list */
-	struct hrtimer		timer;
 	struct list_head	dev_list;
 	struct hlist_node	napi_hash_node;
 	unsigned int		napi_id;
@@ -3788,7 +3792,6 @@ int netif_receive_skb_core(struct sk_buff *skb);
 void netif_receive_skb_list_internal(struct list_head *head);
 void netif_receive_skb_list(struct list_head *head);
 gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb);
-void napi_gro_flush(struct napi_struct *napi, bool flush_old);
 struct sk_buff *napi_get_frags(struct napi_struct *napi);
 gro_result_t napi_gro_frags(struct napi_struct *napi);
 struct packet_offload *gro_find_receive_by_type(__be16 type);
diff --git a/include/net/gro.h b/include/net/gro.h
index 867656b0739c..75211ebd8765 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -421,26 +421,41 @@ static inline __wsum ip6_gro_compute_pseudo(struct sk_buff *skb, int proto)
 }
 
 int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb);
+void __gro_flush(struct gro_node *gro, bool flush_old);
+
+static inline void gro_flush(struct gro_node *gro, bool flush_old)
+{
+	if (!gro->bitmask)
+		return;
+
+	__gro_flush(gro, flush_old);
+}
+
+static inline void napi_gro_flush(struct napi_struct *napi, bool flush_old)
+{
+	gro_flush(&napi->gro, flush_old);
+}
 
 /* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
-static inline void gro_normal_list(struct napi_struct *napi)
+static inline void gro_normal_list(struct gro_node *gro)
 {
-	if (!napi->rx_count)
+	if (!gro->rx_count)
 		return;
-	netif_receive_skb_list_internal(&napi->rx_list);
-	INIT_LIST_HEAD(&napi->rx_list);
-	napi->rx_count = 0;
+	netif_receive_skb_list_internal(&gro->rx_list);
+	INIT_LIST_HEAD(&gro->rx_list);
+	gro->rx_count = 0;
 }
 
 /* Queue one GRO_NORMAL SKB up for list processing. If batch size exceeded,
  * pass the whole batch up to the stack.
  */
-static inline void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb, int segs)
+static inline void gro_normal_one(struct gro_node *gro, struct sk_buff *skb,
+				  int segs)
 {
-	list_add_tail(&skb->list, &napi->rx_list);
-	napi->rx_count += segs;
-	if (napi->rx_count >= gro_normal_batch)
-		gro_normal_list(napi);
+	list_add_tail(&skb->list, &gro->rx_list);
+	gro->rx_count += segs;
+	if (gro->rx_count >= gro_normal_batch)
+		gro_normal_list(gro);
 }
 
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 52b64d24c439..8b334aa974c2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5765,7 +5765,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		return false;
 
 	if (work_done) {
-		if (n->gro_bitmask)
+		if (n->gro.bitmask)
 			timeout = READ_ONCE(n->dev->gro_flush_timeout);
 		n->defer_hard_irqs_count = READ_ONCE(n->dev->napi_defer_hard_irqs);
 	}
@@ -5775,15 +5775,13 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		if (timeout)
 			ret = false;
 	}
-	if (n->gro_bitmask) {
-		/* When the NAPI instance uses a timeout and keeps postponing
-		 * it, we need to bound somehow the time packets are kept in
-		 * the GRO layer
-		 */
-		napi_gro_flush(n, !!timeout);
-	}
 
-	gro_normal_list(n);
+	/* When the NAPI instance uses a timeout and keeps postponing
+	 * it, we need to bound somehow the time packets are kept in
+	 * the GRO layer
+	 */
+	gro_flush(&n->gro, !!timeout);
+	gro_normal_list(&n->gro);
 
 	if (unlikely(!list_empty(&n->poll_list))) {
 		/* If n->poll_list is not empty, we need to mask irqs */
@@ -5815,7 +5813,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 	}
 
 	if (timeout)
-		hrtimer_start(&n->timer, ns_to_ktime(timeout),
+		hrtimer_start(&n->gro.timer, ns_to_ktime(timeout),
 			      HRTIMER_MODE_REL_PINNED);
 	return ret;
 }
@@ -5839,19 +5837,17 @@ static struct napi_struct *napi_by_id(unsigned int napi_id)
 static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
 {
 	if (!skip_schedule) {
-		gro_normal_list(napi);
+		gro_normal_list(&napi->gro);
 		__napi_schedule(napi);
 		return;
 	}
 
-	if (napi->gro_bitmask) {
-		/* flush too old packets
-		 * If HZ < 1000, flush all packets.
-		 */
-		napi_gro_flush(napi, HZ >= 1000);
-	}
+	/* flush too old packets
+	 * If HZ < 1000, flush all packets.
+	 */
+	gro_flush(&napi->gro, HZ >= 1000);
+	gro_normal_list(&napi->gro);
 
-	gro_normal_list(napi);
 	clear_bit(NAPI_STATE_SCHED, &napi->state);
 }
 
@@ -5880,7 +5876,7 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock, bool
 		napi->defer_hard_irqs_count = READ_ONCE(napi->dev->napi_defer_hard_irqs);
 		timeout = READ_ONCE(napi->dev->gro_flush_timeout);
 		if (napi->defer_hard_irqs_count && timeout) {
-			hrtimer_start(&napi->timer, ns_to_ktime(timeout), HRTIMER_MODE_REL_PINNED);
+			hrtimer_start(&napi->gro.timer, ns_to_ktime(timeout), HRTIMER_MODE_REL_PINNED);
 			skip_schedule = true;
 		}
 	}
@@ -5947,7 +5943,7 @@ void napi_busy_loop(unsigned int napi_id,
 		}
 		work = napi_poll(napi, budget);
 		trace_napi_poll(napi, work, budget);
-		gro_normal_list(napi);
+		gro_normal_list(&napi->gro);
 count:
 		if (work > 0)
 			__NET_ADD_STATS(dev_net(napi->dev),
@@ -6015,7 +6011,7 @@ static enum hrtimer_restart napi_watchdog(struct hrtimer *timer)
 {
 	struct napi_struct *napi;
 
-	napi = container_of(timer, struct napi_struct, timer);
+	napi = container_of(timer, struct napi_struct, gro.timer);
 
 	/* Note : we use a relaxed variant of napi_schedule_prep() not setting
 	 * NAPI_STATE_MISSED, since we do not react to a device IRQ.
@@ -6034,10 +6030,10 @@ static void init_gro_hash(struct napi_struct *napi)
 	int i;
 
 	for (i = 0; i < GRO_HASH_BUCKETS; i++) {
-		INIT_LIST_HEAD(&napi->gro_hash[i].list);
-		napi->gro_hash[i].count = 0;
+		INIT_LIST_HEAD(&napi->gro.hash[i].list);
+		napi->gro.hash[i].count = 0;
 	}
-	napi->gro_bitmask = 0;
+	napi->gro.bitmask = 0;
 }
 
 int dev_set_threaded(struct net_device *dev, bool threaded)
@@ -6109,12 +6105,12 @@ void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 
 	INIT_LIST_HEAD(&napi->poll_list);
 	INIT_HLIST_NODE(&napi->napi_hash_node);
-	hrtimer_init(&napi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
-	napi->timer.function = napi_watchdog;
+	hrtimer_init(&napi->gro.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
+	napi->gro.timer.function = napi_watchdog;
 	init_gro_hash(napi);
 	napi->skb = NULL;
-	INIT_LIST_HEAD(&napi->rx_list);
-	napi->rx_count = 0;
+	INIT_LIST_HEAD(&napi->gro.rx_list);
+	napi->gro.rx_count = 0;
 	napi->poll = poll;
 	if (weight > NAPI_POLL_WEIGHT)
 		netdev_err_once(dev, "%s() called with weight %d\n", __func__,
@@ -6159,7 +6155,7 @@ void napi_disable(struct napi_struct *n)
 			break;
 	}
 
-	hrtimer_cancel(&n->timer);
+	hrtimer_cancel(&n->gro.timer);
 
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
 }
@@ -6194,9 +6190,9 @@ static void flush_gro_hash(struct napi_struct *napi)
 	for (i = 0; i < GRO_HASH_BUCKETS; i++) {
 		struct sk_buff *skb, *n;
 
-		list_for_each_entry_safe(skb, n, &napi->gro_hash[i].list, list)
+		list_for_each_entry_safe(skb, n, &napi->gro.hash[i].list, list)
 			kfree_skb(skb);
-		napi->gro_hash[i].count = 0;
+		napi->gro.hash[i].count = 0;
 	}
 }
 
@@ -6211,7 +6207,7 @@ void __netif_napi_del(struct napi_struct *napi)
 	napi_free_frags(napi);
 
 	flush_gro_hash(napi);
-	napi->gro_bitmask = 0;
+	napi->gro.bitmask = 0;
 
 	if (napi->thread) {
 		kthread_stop(napi->thread);
@@ -6268,14 +6264,11 @@ static int __napi_poll(struct napi_struct *n, bool *repoll)
 		return work;
 	}
 
-	if (n->gro_bitmask) {
-		/* flush too old packets
-		 * If HZ < 1000, flush all packets.
-		 */
-		napi_gro_flush(n, HZ >= 1000);
-	}
-
-	gro_normal_list(n);
+	/* flush too old packets
+	 * If HZ < 1000, flush all packets.
+	 */
+	gro_flush(&n->gro, HZ >= 1000);
+	gro_normal_list(&n->gro);
 
 	/* Some drivers may have called napi_schedule
 	 * prior to exhausting their budget.
@@ -10396,7 +10389,7 @@ static struct hlist_head * __net_init netdev_create_hash(void)
 static int __net_init netdev_init(struct net *net)
 {
 	BUILD_BUG_ON(GRO_HASH_BUCKETS >
-		     8 * sizeof_field(struct napi_struct, gro_bitmask));
+		     BITS_PER_BYTE * sizeof_field(struct gro_node, bitmask));
 
 	INIT_LIST_HEAD(&net->dev_base_head);
 
diff --git a/net/core/gro.c b/net/core/gro.c
index b4190eb08467..67fd587a87c9 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -278,8 +278,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	return 0;
 }
 
-
-static void napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
+static void gro_complete(struct gro_node *gro, struct sk_buff *skb)
 {
 	struct packet_offload *ptype;
 	__be16 type = skb->protocol;
@@ -312,43 +311,42 @@ static void napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 	}
 
 out:
-	gro_normal_one(napi, skb, NAPI_GRO_CB(skb)->count);
+	gro_normal_one(gro, skb, NAPI_GRO_CB(skb)->count);
 }
 
-static void __napi_gro_flush_chain(struct napi_struct *napi, u32 index,
-				   bool flush_old)
+static void __gro_flush_chain(struct gro_node *gro, u32 index, bool flush_old)
 {
-	struct list_head *head = &napi->gro_hash[index].list;
+	struct list_head *head = &gro->hash[index].list;
 	struct sk_buff *skb, *p;
 
 	list_for_each_entry_safe_reverse(skb, p, head, list) {
 		if (flush_old && NAPI_GRO_CB(skb)->age == jiffies)
 			return;
 		skb_list_del_init(skb);
-		napi_gro_complete(napi, skb);
-		napi->gro_hash[index].count--;
+		gro_complete(gro, skb);
+		gro->hash[index].count--;
 	}
 
-	if (!napi->gro_hash[index].count)
-		__clear_bit(index, &napi->gro_bitmask);
+	if (!gro->hash[index].count)
+		__clear_bit(index, &gro->bitmask);
 }
 
-/* napi->gro_hash[].list contains packets ordered by age.
+/* gro->hash[].list contains packets ordered by age.
  * youngest packets at the head of it.
  * Complete skbs in reverse order to reduce latencies.
  */
-void napi_gro_flush(struct napi_struct *napi, bool flush_old)
+void __gro_flush(struct gro_node *gro, bool flush_old)
 {
-	unsigned long bitmask = napi->gro_bitmask;
+	unsigned long bitmask = gro->bitmask;
 	unsigned int i, base = ~0U;
 
 	while ((i = ffs(bitmask)) != 0) {
 		bitmask >>= i;
 		base += i;
-		__napi_gro_flush_chain(napi, base, flush_old);
+		__gro_flush_chain(gro, base, flush_old);
 	}
 }
-EXPORT_SYMBOL(napi_gro_flush);
+EXPORT_SYMBOL(__gro_flush);
 
 static void gro_list_prepare(const struct list_head *head,
 			     const struct sk_buff *skb)
@@ -449,7 +447,7 @@ static void gro_pull_from_frag0(struct sk_buff *skb, int grow)
 	}
 }
 
-static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
+static void gro_flush_oldest(struct gro_node *gro, struct list_head *head)
 {
 	struct sk_buff *oldest;
 
@@ -465,13 +463,14 @@ static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
 	 * SKB to the chain.
 	 */
 	skb_list_del_init(oldest);
-	napi_gro_complete(napi, oldest);
+	gro_complete(gro, oldest);
 }
 
-static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
+static enum gro_result dev_gro_receive(struct gro_node *gro,
+				       struct sk_buff *skb)
 {
 	u32 bucket = skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
-	struct gro_list *gro_list = &napi->gro_hash[bucket];
+	struct gro_list *gro_list = &gro->hash[bucket];
 	struct list_head *head = &offload_base;
 	struct packet_offload *ptype;
 	__be16 type = skb->protocol;
@@ -530,7 +529,7 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 
 	if (pp) {
 		skb_list_del_init(pp);
-		napi_gro_complete(napi, pp);
+		gro_complete(gro, pp);
 		gro_list->count--;
 	}
 
@@ -541,7 +540,7 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 		goto normal;
 
 	if (unlikely(gro_list->count >= MAX_GRO_SKBS))
-		gro_flush_oldest(napi, &gro_list->list);
+		gro_flush_oldest(gro, &gro_list->list);
 	else
 		gro_list->count++;
 
@@ -558,10 +557,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 		gro_pull_from_frag0(skb, grow);
 ok:
 	if (gro_list->count) {
-		if (!test_bit(bucket, &napi->gro_bitmask))
-			__set_bit(bucket, &napi->gro_bitmask);
-	} else if (test_bit(bucket, &napi->gro_bitmask)) {
-		__clear_bit(bucket, &napi->gro_bitmask);
+		if (!test_bit(bucket, &gro->bitmask))
+			__set_bit(bucket, &gro->bitmask);
+	} else if (test_bit(bucket, &gro->bitmask)) {
+		__clear_bit(bucket, &gro->bitmask);
 	}
 
 	return ret;
@@ -599,13 +598,12 @@ struct packet_offload *gro_find_complete_by_type(__be16 type)
 }
 EXPORT_SYMBOL(gro_find_complete_by_type);
 
-static gro_result_t napi_skb_finish(struct napi_struct *napi,
-				    struct sk_buff *skb,
-				    gro_result_t ret)
+static gro_result_t gro_skb_finish(struct gro_node *gro, struct sk_buff *skb,
+				   gro_result_t ret)
 {
 	switch (ret) {
 	case GRO_NORMAL:
-		gro_normal_one(napi, skb, 1);
+		gro_normal_one(gro, skb, 1);
 		break;
 
 	case GRO_MERGED_FREE:
@@ -628,6 +626,7 @@ static gro_result_t napi_skb_finish(struct napi_struct *napi,
 
 gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
 {
+	struct gro_node *gro = &napi->gro;
 	gro_result_t ret;
 
 	skb_mark_napi_id(skb, napi);
@@ -635,7 +634,7 @@ gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
 
 	skb_gro_reset_offset(skb, 0);
 
-	ret = napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
+	ret = gro_skb_finish(gro, skb, dev_gro_receive(gro, skb));
 	trace_napi_gro_receive_exit(ret);
 
 	return ret;
@@ -695,7 +694,7 @@ static gro_result_t napi_frags_finish(struct napi_struct *napi,
 		__skb_push(skb, ETH_HLEN);
 		skb->protocol = eth_type_trans(skb, skb->dev);
 		if (ret == GRO_NORMAL)
-			gro_normal_one(napi, skb, 1);
+			gro_normal_one(&napi->gro, skb, 1);
 		break;
 
 	case GRO_MERGED_FREE:
@@ -761,7 +760,7 @@ gro_result_t napi_gro_frags(struct napi_struct *napi)
 
 	trace_napi_gro_frags_entry(skb);
 
-	ret = napi_frags_finish(napi, skb, dev_gro_receive(napi, skb));
+	ret = napi_frags_finish(napi, skb, dev_gro_receive(&napi->gro, skb));
 	trace_napi_gro_frags_exit(ret);
 
 	return ret;
-- 
2.36.1

