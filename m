Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A053E20D3F1
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbgF2TDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730528AbgF2TCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:02:43 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E833C02A551;
        Mon, 29 Jun 2020 06:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=3zpdI8UmwBB+KQo6imlBDm+KZhNuWD0HZ+7/RXg0Qeo=; b=NJadWazrl8uT+evvJdr4n8PtH2
        nN4b5x1zFCfERhYewoAOFG4wWd05hgltRhZJ0RGPRTXLipdAAzLtI8PU9/BoDctoMat+0tzS0xzFQ
        TD793hEyiDS8nNPtuOmVPI07LqkXURV44OS9OVYTMC0afYGlKfdBTtgOeHix3ULRykZOMaA2KOmCH
        TBkXODizBHR/Whz0vP73PdKkyl66g0m6sjBpYr7cfhODudFhNyJpn4/dV5gAY+bX++GifzTFMWF0m
        S/U6RvBOjEB/pHXtjc5GMOf2jTKtkMhUVXhrdnnFbCdWNy27QVeyacAys15VwZtdrpUlgF4iREWq1
        Ea+R8kNw==;
Received: from [2001:4bb8:184:76e3:c71:f334:376b:cf5f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jptSB-0004Xt-ER; Mon, 29 Jun 2020 13:04:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] xsk: use dma_need_sync instead of reimplenting it
Date:   Mon, 29 Jun 2020 15:03:59 +0200
Message-Id: <20200629130359.2690853-5-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629130359.2690853-1-hch@lst.de>
References: <20200629130359.2690853-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the dma_need_sync helper instead of (not always entirely correctly)
poking into the dma-mapping internals.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/xdp/xsk_buff_pool.c | 50 +++--------------------------------------
 1 file changed, 3 insertions(+), 47 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 6733e2c59e4835..08b80669f64955 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -2,9 +2,6 @@
 
 #include <net/xsk_buff_pool.h>
 #include <net/xdp_sock.h>
-#include <linux/dma-direct.h>
-#include <linux/dma-noncoherent.h>
-#include <linux/swiotlb.h>
 
 #include "xsk_queue.h"
 
@@ -124,48 +121,6 @@ static void xp_check_dma_contiguity(struct xsk_buff_pool *pool)
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
@@ -179,6 +134,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 
 	pool->dev = dev;
 	pool->dma_pages_cnt = nr_pages;
+	pool->dma_need_sync = false;
 
 	for (i = 0; i < pool->dma_pages_cnt; i++) {
 		dma = dma_map_page_attrs(dev, pages[i], 0, PAGE_SIZE,
@@ -187,13 +143,13 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 			xp_dma_unmap(pool, attrs);
 			return -ENOMEM;
 		}
+		if (dma_need_sync(dev, dma))
+			pool->dma_need_sync = true;
 		pool->dma_pages[i] = dma;
 	}
 
 	if (pool->unaligned)
 		xp_check_dma_contiguity(pool);
-
-	pool->dma_need_sync = !xp_check_cheap_dma(pool);
 	return 0;
 }
 EXPORT_SYMBOL(xp_dma_map);
-- 
2.26.2

