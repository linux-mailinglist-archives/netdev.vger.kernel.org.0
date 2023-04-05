Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6946D8B0E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 01:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbjDEXWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 19:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233370AbjDEXWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 19:22:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D713B6EB7
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 16:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7254D641AB
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 23:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AECC4339E;
        Wed,  5 Apr 2023 23:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680736930;
        bh=MrxumuvKrLdkHQ+Nt7zAeSg0cKbAKAMGnjBH9cpTmTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CoRJ+VmY9y0FAUOf2/zQzBuyqxfp/P5FEwXC/LC2cw/+mj1UdGDF5UPKIJSyDRQu3
         2BNICAvcxoV06aPnXhn6yWrzHtD9Aj1NyazQTi7SGNop38uAnGDSXIYPOYzaNaEZQG
         a0yFoojNIqOFmOGwb0bWei4uX+2Xj4aWdNU4/DpW0krGABYGHIoW20nuQ93qRvg/lz
         8nZQGVxaZxGKIQWGqnK+6uW10zXEmmhJ9tuALyynTfPgRorfMtGZJUzXMBIME9orVH
         XFzBmIY99UlWA2sbz6gIW24PaMTZ64mxuwSc0scNRzPIR/KW9uB2DpO3uJAUkYjvEf
         S4OZeBCMjh6rg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next v2 2/3] page_pool: allow caching from safely localized NAPI
Date:   Wed,  5 Apr 2023 16:20:59 -0700
Message-Id: <20230405232100.103392-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405232100.103392-1-kuba@kernel.org>
References: <20230405232100.103392-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent patches to mlx5 mentioned a regression when moving from
driver local page pool to only using the generic page pool code.
Page pool has two recycling paths (1) direct one, which runs in
safe NAPI context (basically consumer context, so producing
can be lockless); and (2) via a ptr_ring, which takes a spin
lock because the freeing can happen from any CPU; producer
and consumer may run concurrently.

Since the page pool code was added, Eric introduced a revised version
of deferred skb freeing. TCP skbs are now usually returned to the CPU
which allocated them, and freed in softirq context. This places the
freeing (producing of pages back to the pool) enticingly close to
the allocation (consumer).

If we can prove that we're freeing in the same softirq context in which
the consumer NAPI will run - lockless use of the cache is perfectly fine,
no need for the lock.

Let drivers link the page pool to a NAPI instance. If the NAPI instance
is scheduled on the same CPU on which we're freeing - place the pages
in the direct cache.

With that and patched bnxt (XDP enabled to engage the page pool, sigh,
bnxt really needs page pool work :() I see a 2.6% perf boost with
a TCP stream test (app on a different physical core than softirq).

The CPU use of relevant functions decreases as expected:

  page_pool_refill_alloc_cache   1.17% -> 0%
  _raw_spin_lock                 2.41% -> 0.98%

Only consider lockless path to be safe when NAPI is scheduled
- in practice this should cover majority if not all of steady state
workloads. It's usually the NAPI kicking in that causes the skb flush.

The main case we'll miss out on is when application runs on the same
CPU as NAPI. In that case we don't use the deferred skb free path.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2:
 - plumb thru "are we in NAPI" bool rather than guessing based
   on softirq && !hardirq

CC: hawk@kernel.org
CC: ilias.apalodimas@linaro.org
---
 Documentation/networking/page_pool.rst |  1 +
 include/linux/netdevice.h              |  3 +++
 include/linux/skbuff.h                 | 20 +++++++++++++-------
 include/net/page_pool.h                |  3 ++-
 net/core/dev.c                         |  3 +++
 net/core/page_pool.c                   | 15 +++++++++++++--
 net/core/skbuff.c                      |  5 +++--
 7 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
index 30f1344e7cca..873efd97f822 100644
--- a/Documentation/networking/page_pool.rst
+++ b/Documentation/networking/page_pool.rst
@@ -165,6 +165,7 @@ Registration
     pp_params.pool_size = DESC_NUM;
     pp_params.nid = NUMA_NO_NODE;
     pp_params.dev = priv->dev;
+    pp_params.napi = napi; /* only if locking is tied to NAPI */
     pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
     page_pool = page_pool_create(&pp_params);
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a740be3bb911..64a64dc23fa0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -360,8 +360,11 @@ struct napi_struct {
 	unsigned long		gro_bitmask;
 	int			(*poll)(struct napi_struct *, int);
 #ifdef CONFIG_NETPOLL
+	/* CPU actively polling if netpoll is configured */
 	int			poll_owner;
 #endif
+	/* CPU on which NAPI has been scheduled for processing */
+	int			list_owner;
 	struct net_device	*dev;
 	struct gro_list		gro_hash[GRO_HASH_BUCKETS];
 	struct sk_buff		*skb;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 82511b2f61ea..8e7e5f9bdb77 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3386,6 +3386,18 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
 	__skb_frag_ref(&skb_shinfo(skb)->frags[f]);
 }
 
+static inline void
+napi_frag_unref(skb_frag_t *frag, bool recycle, bool in_normal_napi)
+{
+	struct page *page = skb_frag_page(frag);
+
+#ifdef CONFIG_PAGE_POOL
+	if (recycle && page_pool_return_skb_page(page, in_normal_napi))
+		return;
+#endif
+	put_page(page);
+}
+
 /**
  * __skb_frag_unref - release a reference on a paged fragment.
  * @frag: the paged fragment
@@ -3396,13 +3408,7 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
  */
 static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
 {
-	struct page *page = skb_frag_page(frag);
-
-#ifdef CONFIG_PAGE_POOL
-	if (recycle && page_pool_return_skb_page(page))
-		return;
-#endif
-	put_page(page);
+	napi_frag_unref(frag, recycle, false);
 }
 
 /**
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index ddfa0b328677..d8f2b29c99f8 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -77,6 +77,7 @@ struct page_pool_params {
 	unsigned int	pool_size;
 	int		nid;  /* Numa node id to allocate from pages from */
 	struct device	*dev; /* device, for DMA pre-mapping purposes */
+	struct napi_struct *napi; /* Sole consumer of pages, otherwise NULL */
 	enum dma_data_direction dma_dir; /* DMA mapping direction */
 	unsigned int	max_len; /* max DMA sync memory size */
 	unsigned int	offset;  /* DMA addr offset */
@@ -239,7 +240,7 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
 	return pool->p.dma_dir;
 }
 
-bool page_pool_return_skb_page(struct page *page);
+bool page_pool_return_skb_page(struct page *page, bool in_napi);
 
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 7ce5985be84b..075e607551cb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4358,6 +4358,7 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 	}
 
 	list_add_tail(&napi->poll_list, &sd->poll_list);
+	WRITE_ONCE(napi->list_owner, smp_processor_id());
 	/* If not called from net_rx_action()
 	 * we have to raise NET_RX_SOFTIRQ.
 	 */
@@ -6068,6 +6069,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		list_del_init(&n->poll_list);
 		local_irq_restore(flags);
 	}
+	WRITE_ONCE(n->list_owner, -1);
 
 	val = READ_ONCE(n->state);
 	do {
@@ -6383,6 +6385,7 @@ void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 #ifdef CONFIG_NETPOLL
 	napi->poll_owner = -1;
 #endif
+	napi->list_owner = -1;
 	set_bit(NAPI_STATE_SCHED, &napi->state);
 	set_bit(NAPI_STATE_NPSVC, &napi->state);
 	list_add_rcu(&napi->dev_list, &dev->napi_list);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 193c18799865..bbad7a0a320b 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -19,6 +19,7 @@
 #include <linux/mm.h> /* for put_page() */
 #include <linux/poison.h>
 #include <linux/ethtool.h>
+#include <linux/netdevice.h>
 
 #include <trace/events/page_pool.h>
 
@@ -874,9 +875,11 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 }
 EXPORT_SYMBOL(page_pool_update_nid);
 
-bool page_pool_return_skb_page(struct page *page)
+bool page_pool_return_skb_page(struct page *page, bool in_napi)
 {
+	struct napi_struct *napi;
 	struct page_pool *pp;
+	bool allow_direct;
 
 	page = compound_head(page);
 
@@ -892,12 +895,20 @@ bool page_pool_return_skb_page(struct page *page)
 
 	pp = page->pp;
 
+	/* Allow direct recycle if we have reasons to believe that we are
+	 * in the same context as the consumer would run, so there's
+	 * no possible race.
+	 */
+	napi = pp->p.napi;
+	allow_direct = in_napi && napi &&
+		READ_ONCE(napi->list_owner) == smp_processor_id();
+
 	/* Driver set this to memory recycling info. Reset it on recycle.
 	 * This will *not* work for NIC using a split-page memory model.
 	 * The page will be returned to the pool here regardless of the
 	 * 'flipped' fragment being in use or not.
 	 */
-	page_pool_put_full_page(pp, page, false);
+	page_pool_put_full_page(pp, page, allow_direct);
 
 	return true;
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8d5377b4112f..8e084db3b5a3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -843,7 +843,7 @@ static bool skb_pp_recycle(struct sk_buff *skb, void *data, bool in_normal_napi)
 {
 	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
 		return false;
-	return page_pool_return_skb_page(virt_to_page(data));
+	return page_pool_return_skb_page(virt_to_page(data), in_normal_napi);
 }
 
 static void skb_kfree_head(void *head, unsigned int end_offset)
@@ -889,7 +889,8 @@ static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason,
 	}
 
 	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
+		napi_frag_unref(&shinfo->frags[i], skb->pp_recycle,
+				in_normal_napi);
 
 free_head:
 	if (shinfo->frag_list)
-- 
2.39.2

