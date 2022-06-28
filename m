Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80B455EE2E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiF1Tyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiF1Tuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:55 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9A5B4F;
        Tue, 28 Jun 2022 12:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445782; x=1687981782;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lpTv4+c3cx/2/djGl4KefPjDjGKGmL+71fUeHlFr2sM=;
  b=A4V9r/GMuPynOtIJJef8ffIFcwdKYG1c1nfP0lt9IgxOCHiKbLNSpDp0
   zFr5Cy66uaTFyeCjPeXceJGaKliERxKvf6Mr+llzbJ2Ww2K+aOsOaqW54
   Hkp0DhZIvhdHTDUtwXO0GxI48lDCXAQF+i0Y2iB7HCAwNIhYcCsHuhjif
   J7qlSdIhLhpDqrx4lh+USsCzPDUBKUZKE3CNE8kuBE8eswrPR0QZxmT8T
   jS5oiezxCN9FbtRR+vqahKesKX1Ma2Wz6h6GtcNWkqKKUv36Fsm7eR/23
   eLgYmRMCLc9F7PlYJtJlQuyWiRhEJqNNsU4uosHCZForskZUs5o+NnBnz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343523308"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="343523308"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="617303088"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 28 Jun 2022 12:49:37 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9V022013;
        Tue, 28 Jun 2022 20:49:35 +0100
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
Subject: [PATCH RFC bpf-next 31/52] net, gro: expose some GRO API to use outside of NAPI
Date:   Tue, 28 Jun 2022 21:47:51 +0200
Message-Id: <20220628194812.1453059-32-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make several functions global to be able to use GRO without a NAPI
instance. This includes init, cleanup, receive functions, as well
as a couple inlines to start and stop the deferred flush timer.
Taking into account already global gro_flush(), it is now fully
possible to maintain a GRO node without an aux NAPI entity.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/net/gro.h | 18 +++++++++++++++
 net/core/dev.c    | 45 ++++++-------------------------------
 net/core/gro.c    | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 38 deletions(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index 75211ebd8765..539f931e736f 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -421,6 +421,7 @@ static inline __wsum ip6_gro_compute_pseudo(struct sk_buff *skb, int proto)
 }
 
 int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb);
+void gro_receive_skb_list(struct gro_node *gro, struct list_head *list);
 void __gro_flush(struct gro_node *gro, bool flush_old);
 
 static inline void gro_flush(struct gro_node *gro, bool flush_old)
@@ -458,5 +459,22 @@ static inline void gro_normal_one(struct gro_node *gro, struct sk_buff *skb,
 		gro_normal_list(gro);
 }
 
+static inline void gro_timer_start(struct gro_node *gro, u64 timeout_ns)
+{
+	if (!timeout_ns)
+		return;
+
+	hrtimer_start(&gro->timer, ns_to_ktime(timeout_ns),
+		      HRTIMER_MODE_REL_PINNED);
+}
+
+static inline void gro_timer_cancel(struct gro_node *gro)
+{
+	hrtimer_cancel(&gro->timer);
+}
+
+void gro_init(struct gro_node *gro,
+	      enum hrtimer_restart (*timer_cb)(struct hrtimer *timer));
+void gro_cleanup(struct gro_node *gro);
 
 #endif /* _NET_IPV6_GRO_H */
diff --git a/net/core/dev.c b/net/core/dev.c
index 8b334aa974c2..62bf6ee00741 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5812,9 +5812,8 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		return false;
 	}
 
-	if (timeout)
-		hrtimer_start(&n->gro.timer, ns_to_ktime(timeout),
-			      HRTIMER_MODE_REL_PINNED);
+	gro_timer_start(&n->gro, timeout);
+
 	return ret;
 }
 EXPORT_SYMBOL(napi_complete_done);
@@ -5876,7 +5875,7 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock, bool
 		napi->defer_hard_irqs_count = READ_ONCE(napi->dev->napi_defer_hard_irqs);
 		timeout = READ_ONCE(napi->dev->gro_flush_timeout);
 		if (napi->defer_hard_irqs_count && timeout) {
-			hrtimer_start(&napi->gro.timer, ns_to_ktime(timeout), HRTIMER_MODE_REL_PINNED);
+			gro_timer_start(&napi->gro, timeout);
 			skip_schedule = true;
 		}
 	}
@@ -6025,17 +6024,6 @@ static enum hrtimer_restart napi_watchdog(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static void init_gro_hash(struct napi_struct *napi)
-{
-	int i;
-
-	for (i = 0; i < GRO_HASH_BUCKETS; i++) {
-		INIT_LIST_HEAD(&napi->gro.hash[i].list);
-		napi->gro.hash[i].count = 0;
-	}
-	napi->gro.bitmask = 0;
-}
-
 int dev_set_threaded(struct net_device *dev, bool threaded)
 {
 	struct napi_struct *napi;
@@ -6105,12 +6093,8 @@ void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 
 	INIT_LIST_HEAD(&napi->poll_list);
 	INIT_HLIST_NODE(&napi->napi_hash_node);
-	hrtimer_init(&napi->gro.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
-	napi->gro.timer.function = napi_watchdog;
-	init_gro_hash(napi);
+	gro_init(&napi->gro, napi_watchdog);
 	napi->skb = NULL;
-	INIT_LIST_HEAD(&napi->gro.rx_list);
-	napi->gro.rx_count = 0;
 	napi->poll = poll;
 	if (weight > NAPI_POLL_WEIGHT)
 		netdev_err_once(dev, "%s() called with weight %d\n", __func__,
@@ -6155,8 +6139,7 @@ void napi_disable(struct napi_struct *n)
 			break;
 	}
 
-	hrtimer_cancel(&n->gro.timer);
-
+	gro_timer_cancel(&n->gro);
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
 }
 EXPORT_SYMBOL(napi_disable);
@@ -6183,19 +6166,6 @@ void napi_enable(struct napi_struct *n)
 }
 EXPORT_SYMBOL(napi_enable);
 
-static void flush_gro_hash(struct napi_struct *napi)
-{
-	int i;
-
-	for (i = 0; i < GRO_HASH_BUCKETS; i++) {
-		struct sk_buff *skb, *n;
-
-		list_for_each_entry_safe(skb, n, &napi->gro.hash[i].list, list)
-			kfree_skb(skb);
-		napi->gro.hash[i].count = 0;
-	}
-}
-
 /* Must be called in process context */
 void __netif_napi_del(struct napi_struct *napi)
 {
@@ -6206,8 +6176,7 @@ void __netif_napi_del(struct napi_struct *napi)
 	list_del_rcu(&napi->dev_list);
 	napi_free_frags(napi);
 
-	flush_gro_hash(napi);
-	napi->gro.bitmask = 0;
+	gro_cleanup(&napi->gro);
 
 	if (napi->thread) {
 		kthread_stop(napi->thread);
@@ -10627,7 +10596,7 @@ static int __init net_dev_init(void)
 		INIT_CSD(&sd->defer_csd, trigger_rx_softirq, sd);
 		spin_lock_init(&sd->defer_lock);
 
-		init_gro_hash(&sd->backlog);
+		gro_init(&sd->backlog.gro, NULL);
 		sd->backlog.poll = process_backlog;
 		sd->backlog.weight = weight_p;
 	}
diff --git a/net/core/gro.c b/net/core/gro.c
index 67fd587a87c9..424c812abe79 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -624,6 +624,18 @@ static gro_result_t gro_skb_finish(struct gro_node *gro, struct sk_buff *skb,
 	return ret;
 }
 
+void gro_receive_skb_list(struct gro_node *gro, struct list_head *list)
+{
+	struct sk_buff *skb, *tmp;
+
+	list_for_each_entry_safe(skb, tmp, list, list) {
+		skb_list_del_init(skb);
+
+		skb_gro_reset_offset(skb, 0);
+		gro_skb_finish(gro, skb, dev_gro_receive(gro, skb));
+	}
+}
+
 gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
 {
 	struct gro_node *gro = &napi->gro;
@@ -792,3 +804,48 @@ __sum16 __skb_gro_checksum_complete(struct sk_buff *skb)
 	return sum;
 }
 EXPORT_SYMBOL(__skb_gro_checksum_complete);
+
+void gro_init(struct gro_node *gro,
+	      enum hrtimer_restart (*timer_cb)(struct hrtimer *))
+{
+	u32 i;
+
+	for (i = 0; i < GRO_HASH_BUCKETS; i++) {
+		INIT_LIST_HEAD(&gro->hash[i].list);
+		gro->hash[i].count = 0;
+	}
+
+	gro->bitmask = 0;
+
+	INIT_LIST_HEAD(&gro->rx_list);
+	gro->rx_count = 0;
+
+	if (!timer_cb)
+		return;
+
+	hrtimer_init(&gro->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
+	gro->timer.function = timer_cb;
+}
+
+void gro_cleanup(struct gro_node *gro)
+{
+	struct sk_buff *skb, *n;
+	u32 i;
+
+	gro_timer_cancel(gro);
+	memset(&gro->timer, 0, sizeof(gro->timer));
+
+	for (i = 0; i < GRO_HASH_BUCKETS; i++) {
+		list_for_each_entry_safe(skb, n, &gro->hash[i].list, list)
+			kfree_skb(skb);
+
+		gro->hash[i].count = 0;
+	}
+
+	gro->bitmask = 0;
+
+	list_for_each_entry_safe(skb, n, &gro->rx_list, list)
+		kfree_skb(skb);
+
+	gro->rx_count = 0;
+}
-- 
2.36.1

