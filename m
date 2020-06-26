Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D827B20B2C2
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 15:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgFZNoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 09:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgFZNoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 09:44:16 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8C3C03E979;
        Fri, 26 Jun 2020 06:44:16 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id d6so4967944pjs.3;
        Fri, 26 Jun 2020 06:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=avkaKRtJK4C0IAHcq+LgUh9i3fWucO3C6govd2RCQI0=;
        b=dcJ0FJknKLnYp0ga1Ly2ebZkojK7vfLDvm1cFtpino4WqSydYNS6PifR1dp21sPuM3
         h4GMTldhYK/E2qm/UPo2mUSuHWW+HjdWwzECiZjVL7hM6GhAN3dAOpqRxGNFUX5Z+oM2
         /Af0OFiRH/V8M/P/mU5TBDt/R024f/t9PtXu91LrbfIJexhu33p+XZh/oe2PU6YEkZFc
         l37flrqK/cwCV1EohHKpLZZCOli6daX2RrzVgHICm+aFBOrA7CS0F2mvnf2vKFBkom2/
         uWbPxwR6GrpjNvAi1YGAsNb6lU5vO1D2/omYnJvWTehvt6SM+/QldpwvlW6E8emf6qtG
         w4Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=avkaKRtJK4C0IAHcq+LgUh9i3fWucO3C6govd2RCQI0=;
        b=qwQM4ShAshrev3dOW9rsyRm1b86Bpb5H/F3wn7JyMseK/YZjTirvAVN13+gxDcZJAG
         ID3EX5ZfV1lj4tAXArN7NjBpKCNwTnHCMk1Xa8FeiFGePQgdj3JaGkqHIruxJd6f5JGC
         Ct/89JeQPJ7aEeM1AgjOwx/GSKdrzKjktqHYHa3WVJSiLqBQUb5okAfhOE5Ftwi9vFOL
         qyW7MijN7ZkECQuZBRvwilNoLNsFQVqS1WV+alH5PxjQOG/3ROqy/yOA8fM0ASIWrZW8
         45Xe9AlhFEJ/jZv83Bpqru2PzM9x8ycYSFulOp09GgRwpQyMbRWox1HvIWMuYLswf7I5
         T6YA==
X-Gm-Message-State: AOAM530hQsVZxDXCi5Zapkuo+PoY57mVL+KDZxHYaA7Ph58YbPvaMnNF
        jnoiafeYQsrhfNEAa06w3UH1OD2j+tY=
X-Google-Smtp-Source: ABdhPJwXVaAP8zWzcfa3qPXnxgqZhMnY5s5cL3q4YKh0yMe6Q1AWmLz7Shr3jpNlzvRs3S7LfHl7Eg==
X-Received: by 2002:a17:90a:9606:: with SMTP id v6mr1304478pjo.110.1593179055280;
        Fri, 26 Jun 2020 06:44:15 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id k7sm15584523pgh.46.2020.06.26.06.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 06:44:14 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        hch@lst.de, davem@davemloft.net, konrad.wilk@oracle.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, maximmi@mellanox.com, bjorn.topel@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Subject: [PATCH net] xsk: remove cheap_dma optimization
Date:   Fri, 26 Jun 2020 15:43:58 +0200
Message-Id: <20200626134358.90122-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

When the AF_XDP buffer allocation API was introduced it had an
optimization, "cheap_dma". The idea was that when the umem was DMA
mapped, the pool also checked whether the mapping required a
synchronization (CPU to device, and vice versa). If not, it would be
marked as "cheap_dma" and the synchronization would be elided.

In [1] Christoph points out that the optimization above breaks the DMA
API abstraction, and should be removed. Further, Christoph points out
that optimizations like this should be done within the DMA mapping
core, and not elsewhere.

Unfortunately this has implications for the packet rate
performance. The AF_XDP rxdrop scenario shows a 9% decrease in packets
per second.

[1] https://lore.kernel.org/netdev/20200626074725.GA21790@lst.de/

Cc: Christoph Hellwig <hch@lst.de>
Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xsk_buff_pool.h | 16 +++------
 net/xdp/xsk_buff_pool.c     | 69 ++-----------------------------------
 2 files changed, 6 insertions(+), 79 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index a4ff226505c9..3ea9b9654632 100644
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
@@ -77,24 +76,17 @@ static inline dma_addr_t xp_get_frame_dma(struct xdp_buff_xsk *xskb)
 	return xskb->frame_dma;
 }
 
-void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb);
 static inline void xp_dma_sync_for_cpu(struct xdp_buff_xsk *xskb)
 {
-	if (xskb->pool->cheap_dma)
-		return;
-
-	xp_dma_sync_for_cpu_slow(xskb);
+	dma_sync_single_range_for_cpu(xskb->pool->dev, xskb->dma, 0,
+				      xskb->pool->frame_len, DMA_BIDIRECTIONAL);
 }
 
-void xp_dma_sync_for_device_slow(struct xsk_buff_pool *pool, dma_addr_t dma,
-				 size_t size);
 static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
 					  dma_addr_t dma, size_t size)
 {
-	if (pool->cheap_dma)
-		return;
-
-	xp_dma_sync_for_device_slow(pool, dma, size);
+	dma_sync_single_range_for_device(pool->dev, dma, 0,
+					 size, DMA_BIDIRECTIONAL);
 }
 
 /* Masks for xdp_umem_page flags.
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 540ed75e4482..c330e5f3aadf 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -2,9 +2,6 @@
 
 #include <net/xsk_buff_pool.h>
 #include <net/xdp_sock.h>
-#include <linux/dma-direct.h>
-#include <linux/dma-noncoherent.h>
-#include <linux/swiotlb.h>
 
 #include "xsk_queue.h"
 
@@ -55,7 +52,6 @@ struct xsk_buff_pool *xp_create(struct page **pages, u32 nr_pages, u32 chunks,
 	pool->free_heads_cnt = chunks;
 	pool->headroom = headroom;
 	pool->chunk_size = chunk_size;
-	pool->cheap_dma = true;
 	pool->unaligned = unaligned;
 	pool->frame_len = chunk_size - headroom - XDP_PACKET_HEADROOM;
 	INIT_LIST_HEAD(&pool->free_list);
@@ -125,48 +121,6 @@ static void xp_check_dma_contiguity(struct xsk_buff_pool *pool)
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
@@ -195,7 +149,6 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 		xp_check_dma_contiguity(pool);
 
 	pool->dev = dev;
-	pool->cheap_dma = xp_check_cheap_dma(pool);
 	return 0;
 }
 EXPORT_SYMBOL(xp_dma_map);
@@ -280,11 +233,8 @@ struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool)
 	xskb->xdp.data = xskb->xdp.data_hard_start + XDP_PACKET_HEADROOM;
 	xskb->xdp.data_meta = xskb->xdp.data;
 
-	if (!pool->cheap_dma) {
-		dma_sync_single_range_for_device(pool->dev, xskb->dma, 0,
-						 pool->frame_len,
-						 DMA_BIDIRECTIONAL);
-	}
+	dma_sync_single_range_for_device(pool->dev, xskb->dma, 0,
+					 pool->frame_len, DMA_BIDIRECTIONAL);
 	return &xskb->xdp;
 }
 EXPORT_SYMBOL(xp_alloc);
@@ -319,18 +269,3 @@ dma_addr_t xp_raw_get_dma(struct xsk_buff_pool *pool, u64 addr)
 		(addr & ~PAGE_MASK);
 }
 EXPORT_SYMBOL(xp_raw_get_dma);
-
-void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb)
-{
-	dma_sync_single_range_for_cpu(xskb->pool->dev, xskb->dma, 0,
-				      xskb->pool->frame_len, DMA_BIDIRECTIONAL);
-}
-EXPORT_SYMBOL(xp_dma_sync_for_cpu_slow);
-
-void xp_dma_sync_for_device_slow(struct xsk_buff_pool *pool, dma_addr_t dma,
-				 size_t size)
-{
-	dma_sync_single_range_for_device(pool->dev, dma, 0,
-					 size, DMA_BIDIRECTIONAL);
-}
-EXPORT_SYMBOL(xp_dma_sync_for_device_slow);

base-commit: 4a21185cda0fbb860580eeeb4f1a70a9cda332a4
-- 
2.25.1

