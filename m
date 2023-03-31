Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFE66D1667
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 06:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjCaEjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 00:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCaEjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 00:39:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBC3C16D
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 21:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E754162321
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92808C433EF;
        Fri, 31 Mar 2023 04:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680237558;
        bh=I3vOoEMuz74PnYMvNyZ7+W9pX2gzUcuFdlUzR1+mC3c=;
        h=From:To:Cc:Subject:Date:From;
        b=ttfpFLnD5maGtFy/jkES+FmATw/zC6mBBmwK8koGcWQnOQ3LVobJpVq5rn+dwS6KV
         Q9dxvpZhHSJAHSiSNUxKkptWiiLmQ8xDrB1dgegZ1xDxFLc8jXTqKPGwMbcjELMdam
         5rFXOVXtiag3VZNVtWc0hndZGh1G810W2Va+UEFAuN8Ax6PyZG6wC/KPVslIXSMXMW
         Tu34hXWurTwyd0IGjObqU4BdOdVr3qg2xdo1DitmX4iaQQ71WjdHSxQDKs01ZEUfGH
         AdUdtQe6vuCOxay4+XaIsTeiGZ3cjjKl+cqyhNVHrl1ftjHokhxVvFDyNGCJ0RKdJo
         CA7fCl09jkT8w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, hawk@kernel.org,
        ilias.apalodimas@linaro.org
Subject: [RFC net-next 1/2] page_pool: allow caching from safely localized NAPI
Date:   Thu, 30 Mar 2023 21:39:05 -0700
Message-Id: <20230331043906.3015706-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
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
We could disable softirq one that path, too... maybe?

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: hawk@kernel.org
CC: ilias.apalodimas@linaro.org
---
 include/linux/netdevice.h |  3 +++
 include/net/page_pool.h   |  1 +
 net/core/dev.c            |  3 +++
 net/core/page_pool.c      | 16 ++++++++++++++++
 4 files changed, 23 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 62e093a6d6d1..b3c11353078b 100644
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
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index ddfa0b328677..f86cdfb51585 100644
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
diff --git a/net/core/dev.c b/net/core/dev.c
index 0c4b21291348..a6d6e5c89ce7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4360,6 +4360,7 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 	}
 
 	list_add_tail(&napi->poll_list, &sd->poll_list);
+	WRITE_ONCE(napi->list_owner, smp_processor_id());
 	/* If not called from net_rx_action()
 	 * we have to raise NET_RX_SOFTIRQ.
 	 */
@@ -6070,6 +6071,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		list_del_init(&n->poll_list);
 		local_irq_restore(flags);
 	}
+	WRITE_ONCE(n->list_owner, -1);
 
 	val = READ_ONCE(n->state);
 	do {
@@ -6385,6 +6387,7 @@ void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 #ifdef CONFIG_NETPOLL
 	napi->poll_owner = -1;
 #endif
+	napi->list_owner = -1;
 	set_bit(NAPI_STATE_SCHED, &napi->state);
 	set_bit(NAPI_STATE_NPSVC, &napi->state);
 	list_add_rcu(&napi->dev_list, &dev->napi_list);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 193c18799865..c3e2ab0c2684 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -19,6 +19,7 @@
 #include <linux/mm.h> /* for put_page() */
 #include <linux/poison.h>
 #include <linux/ethtool.h>
+#include <linux/netdevice.h>
 
 #include <trace/events/page_pool.h>
 
@@ -544,6 +545,18 @@ static bool page_pool_recycle_in_cache(struct page *page,
 	return true;
 }
 
+/* If caller didn't allow direct recycling check if we have other reasons
+ * to believe that the producer and consumer can't race.
+ *
+ * Result is only meaningful in softirq context.
+ */
+static bool page_pool_safe_producer(struct page_pool *pool)
+{
+	struct napi_struct *napi = pool->p.napi;
+
+	return napi && READ_ONCE(napi->list_owner) == smp_processor_id();
+}
+
 /* If the page refcnt == 1, this will try to recycle the page.
  * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
  * the configured size min(dma_sync_size, pool->max_len).
@@ -570,6 +583,9 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 			page_pool_dma_sync_for_device(pool, page,
 						      dma_sync_size);
 
+		if (!allow_direct)
+			allow_direct = page_pool_safe_producer(pool);
+
 		if (allow_direct && in_softirq() &&
 		    page_pool_recycle_in_cache(page, pool))
 			return NULL;
-- 
2.39.2

