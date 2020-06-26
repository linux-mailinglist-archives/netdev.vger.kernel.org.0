Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD4120B153
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 14:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgFZMWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 08:22:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:27900 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbgFZMWq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 08:22:46 -0400
IronPort-SDR: /E2UnzCPnldibGEv0Cn1dcKnJb8gseUfN0kMsTZYvAL3XPVBDGs5//RCijy0SxxHyicENW7uA6
 gGNqWwaDWwvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="145368538"
X-IronPort-AV: E=Sophos;i="5.75,283,1589266800"; 
   d="scan'208";a="145368538"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 05:22:46 -0700
IronPort-SDR: F5eHo2m2CFQpkNJaLvMJixEf0mOWgyXmWSFNR0ssn6jmoARey1jsvDfPfsk2m3B9/kk+8TIjqL
 8AK8eNcG2bhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,283,1589266800"; 
   d="scan'208";a="301047902"
Received: from swallace-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.52.84])
  by orsmga007.jf.intel.com with ESMTP; 26 Jun 2020 05:22:42 -0700
Subject: Re: the XSK buffer pool needs be to reverted
To:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
References: <20200626074725.GA21790@lst.de>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <f1512c3e-79eb-ba75-6f38-ca09795973c1@intel.com>
Date:   Fri, 26 Jun 2020 14:22:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200626074725.GA21790@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-26 09:47, Christoph Hellwig wrote:
> Hi Björn,
> 
> you addition of the xsk_buff_pool.c APIs in commit 2b43470add8c
> ("xsk: Introduce AF_XDP buffer allocation API") is unfortunately rather
> broken by making lots of assumptions and poking into dma-direct and
> swiotlb internals that are of no business to outside users and clearly
> marked as such.   I'd be glad to work with your doing something proper
> for pools, but that needs proper APIs and probably live in the dma
> mapping core, but for that you'd actually need to contact the relevant
> maintainers before poking into internals.
>

Christoph,

Thanks for clarifying that. Let's work on a solution that can reside in
the dma mapping core.

> The commit seems to have a long dove tail of commits depending on it
> despite only being a month old, so maybe you can do the revert for now?
>

Reverting the whole series sounds a bit too much. Let's focus on the
part that breaks the dma api abstraction. I'm assuming that you're
referring to the

   static bool xp_check_cheap_dma(struct xsk_buff_pool *pool)

function (and related functions called from that)?

> Note that this is somewhat urgent, as various of the APIs that the code
> is abusing are slated to go away for Linux 5.9, so this addition comes
> at a really bad time.
> 

Understood. Wdyt about something in the lines of the diff below? It's
build tested only, but removes all non-dma API usage ("poking
internals"). Would that be a way forward, and then as a next step work
on a solution that would give similar benefits, but something that would
live in the dma mapping core?

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index a4ff226505c9..003b172ce0d2 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -40,7 +40,6 @@ struct xsk_buff_pool {
  	u32 headroom;
  	u32 chunk_size;
  	u32 frame_len;
-	bool cheap_dma;
  	bool unaligned;
  	void *addrs;
  	struct device *dev;
@@ -80,9 +79,6 @@ static inline dma_addr_t xp_get_frame_dma(struct 
xdp_buff_xsk *xskb)
  void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb);
  static inline void xp_dma_sync_for_cpu(struct xdp_buff_xsk *xskb)
  {
-	if (xskb->pool->cheap_dma)
-		return;
-
  	xp_dma_sync_for_cpu_slow(xskb);
  }

@@ -91,9 +87,6 @@ void xp_dma_sync_for_device_slow(struct xsk_buff_pool 
*pool, dma_addr_t dma,
  static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
  					  dma_addr_t dma, size_t size)
  {
-	if (pool->cheap_dma)
-		return;
-
  	xp_dma_sync_for_device_slow(pool, dma, size);
  }

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 540ed75e4482..5714f3711381 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -2,9 +2,6 @@

  #include <net/xsk_buff_pool.h>
  #include <net/xdp_sock.h>
-#include <linux/dma-direct.h>
-#include <linux/dma-noncoherent.h>
-#include <linux/swiotlb.h>

  #include "xsk_queue.h"

@@ -55,7 +52,6 @@ struct xsk_buff_pool *xp_create(struct page **pages, 
u32 nr_pages, u32 chunks,
  	pool->free_heads_cnt = chunks;
  	pool->headroom = headroom;
  	pool->chunk_size = chunk_size;
-	pool->cheap_dma = true;
  	pool->unaligned = unaligned;
  	pool->frame_len = chunk_size - headroom - XDP_PACKET_HEADROOM;
  	INIT_LIST_HEAD(&pool->free_list);
@@ -125,48 +121,6 @@ static void xp_check_dma_contiguity(struct 
xsk_buff_pool *pool)
  	}
  }

-static bool __maybe_unused xp_check_swiotlb_dma(struct xsk_buff_pool *pool)
-{
-#if defined(CONFIG_SWIOTLB)
-	phys_addr_t paddr;
-	u32 i;
-
-	for (i = 0; i < pool->dma_pages_cnt; i++) {
-		paddr = dma_to_phys(pool->dev, pool->dma_pages[i]);
-		if (is_swiotlb_buffer(paddr))
-			return false;
-	}
-#endif
-	return true;
-}
-
-static bool xp_check_cheap_dma(struct xsk_buff_pool *pool)
-{
-#if defined(CONFIG_HAS_DMA)
-	const struct dma_map_ops *ops = get_dma_ops(pool->dev);
-
-	if (ops) {
-		return !ops->sync_single_for_cpu &&
-			!ops->sync_single_for_device;
-	}
-
-	if (!dma_is_direct(ops))
-		return false;
-
-	if (!xp_check_swiotlb_dma(pool))
-		return false;
-
-	if (!dev_is_dma_coherent(pool->dev)) {
-#if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU) ||		\
-	defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL) ||	\
-	defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE)
-		return false;
-#endif
-	}
-#endif
-	return true;
-}
-
  int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
  	       unsigned long attrs, struct page **pages, u32 nr_pages)
  {
@@ -195,7 +149,6 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct 
device *dev,
  		xp_check_dma_contiguity(pool);

  	pool->dev = dev;
-	pool->cheap_dma = xp_check_cheap_dma(pool);
  	return 0;
  }
  EXPORT_SYMBOL(xp_dma_map);
@@ -280,11 +233,9 @@ struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool)
  	xskb->xdp.data = xskb->xdp.data_hard_start + XDP_PACKET_HEADROOM;
  	xskb->xdp.data_meta = xskb->xdp.data;

-	if (!pool->cheap_dma) {
-		dma_sync_single_range_for_device(pool->dev, xskb->dma, 0,
-						 pool->frame_len,
-						 DMA_BIDIRECTIONAL);
-	}
+	dma_sync_single_range_for_device(pool->dev, xskb->dma, 0,
+					 pool->frame_len,
+					 DMA_BIDIRECTIONAL);
  	return &xskb->xdp;
  }
  EXPORT_SYMBOL(xp_alloc);
