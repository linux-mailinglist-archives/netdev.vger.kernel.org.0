Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35BEC301F
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbfJAJY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbfJAJY5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 05:24:57 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28DCA21855;
        Tue,  1 Oct 2019 09:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569921896;
        bh=pnlI9s00oPu/3WNGIp+KJze0QmkaBf5sb8yubahTMbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtbjmJFdlk9g0lgyC9ODun1Qul0Y5Da1wZI6vcMqH9ijvKUEtLbniVVlnmdB3JZvN
         3JFHTQn2uIr9Y/blxpXz/GPpMbOlUTwPpztHj3s2ndg2DuVooPy4NpT2XyFF1iqSsm
         lC4XF4Y8pKobddJLrxHuzivxBKer1vXFPE1xlZow=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        brouer@redhat.com, mcroce@redhat.com
Subject: [RFC 1/4] net: mvneta: introduce page pool API for sw buffer manager
Date:   Tue,  1 Oct 2019 11:24:41 +0200
Message-Id: <09af2f2263d2b51be7633d7c55db23e41bb3a88c.1569920973.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1569920973.git.lorenzo@kernel.org>
References: <cover.1569920973.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the page_pool api for allocations and DMA handling instead of
__dev_alloc_page()/dma_map_page() and free_page()/dma_unmap_page().
Pages are unmapped using page_pool_release_page before packets
go into the network stack.

The page_pool API offers buffer recycling capabilities for XDP but
allocates one page per packet, unless the driver splits and manages
the allocated page.
This is a preliminary patch to add XDP support to mvneta driver

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/Kconfig  |  1 +
 drivers/net/ethernet/marvell/mvneta.c | 56 ++++++++++++++++++---------
 2 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index fb942167ee54..3d5caea096fb 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -61,6 +61,7 @@ config MVNETA
 	depends on ARCH_MVEBU || COMPILE_TEST
 	select MVMDIO
 	select PHYLINK
+	select PAGE_POOL
 	---help---
 	  This driver supports the network interface units in the
 	  Marvell ARMADA XP, ARMADA 370, ARMADA 38x and
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e49820675c8c..afd489af5aad 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -37,6 +37,7 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/tso.h>
+#include <net/page_pool.h>
 
 /* Registers */
 #define MVNETA_RXQ_CONFIG_REG(q)                (0x1400 + ((q) << 2))
@@ -603,6 +604,9 @@ struct mvneta_rx_queue {
 	u32 pkts_coal;
 	u32 time_coal;
 
+	/* page_pool */
+	struct page_pool *page_pool;
+
 	/* Virtual address of the RX buffer */
 	void  **buf_virt_addr;
 
@@ -1815,19 +1819,12 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
 	dma_addr_t phys_addr;
 	struct page *page;
 
-	page = __dev_alloc_page(gfp_mask);
+	page = page_pool_alloc_pages(rxq->page_pool,
+				     gfp_mask | __GFP_NOWARN);
 	if (!page)
 		return -ENOMEM;
 
-	/* map page for use */
-	phys_addr = dma_map_page(pp->dev->dev.parent, page, 0, PAGE_SIZE,
-				 DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(pp->dev->dev.parent, phys_addr))) {
-		__free_page(page);
-		return -ENOMEM;
-	}
-
-	phys_addr += pp->rx_offset_correction;
+	phys_addr = page_pool_get_dma_addr(page) + pp->rx_offset_correction;
 	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
 	return 0;
 }
@@ -1894,10 +1891,9 @@ static void mvneta_rxq_drop_pkts(struct mvneta_port *pp,
 		if (!data || !(rx_desc->buf_phys_addr))
 			continue;
 
-		dma_unmap_page(pp->dev->dev.parent, rx_desc->buf_phys_addr,
-			       PAGE_SIZE, DMA_FROM_DEVICE);
-		__free_page(data);
+		page_pool_put_page(rxq->page_pool, data, false);
 	}
+	page_pool_destroy(rxq->page_pool);
 }
 
 static inline
@@ -2012,8 +2008,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 				skb_add_rx_frag(rxq->skb, frag_num, page,
 						frag_offset, frag_size,
 						PAGE_SIZE);
-				dma_unmap_page(dev->dev.parent, phys_addr,
-					       PAGE_SIZE, DMA_FROM_DEVICE);
+				page_pool_release_page(rxq->page_pool, page);
 				rxq->left_size -= frag_size;
 			}
 		} else {
@@ -2043,9 +2038,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 						frag_offset, frag_size,
 						PAGE_SIZE);
 
-				dma_unmap_page(dev->dev.parent, phys_addr,
-					       PAGE_SIZE, DMA_FROM_DEVICE);
-
+				page_pool_release_page(rxq->page_pool, page);
 				rxq->left_size -= frag_size;
 			}
 		} /* Middle or Last descriptor */
@@ -2830,11 +2823,36 @@ static int mvneta_poll(struct napi_struct *napi, int budget)
 	return rx_done;
 }
 
+static int mvneta_create_page_pool(struct mvneta_port *pp,
+				   struct mvneta_rx_queue *rxq, int size)
+{
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.flags = PP_FLAG_DMA_MAP,
+		.pool_size = size,
+		.nid = cpu_to_node(0),
+		.dev = pp->dev->dev.parent,
+		.dma_dir = DMA_FROM_DEVICE,
+	};
+
+	rxq->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(rxq->page_pool)) {
+		rxq->page_pool = NULL;
+		return PTR_ERR(rxq->page_pool);
+	}
+
+	return 0;
+}
+
 /* Handle rxq fill: allocates rxq skbs; called when initializing a port */
 static int mvneta_rxq_fill(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 			   int num)
 {
-	int i;
+	int i, err;
+
+	err = mvneta_create_page_pool(pp, rxq, num);
+	if (err < 0)
+		return err;
 
 	for (i = 0; i < num; i++) {
 		memset(rxq->descs + i, 0, sizeof(struct mvneta_rx_desc));
-- 
2.21.0

