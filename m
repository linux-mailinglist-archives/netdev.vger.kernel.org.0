Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D50DD752
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 10:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfJSINx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 04:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfJSINw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 04:13:52 -0400
Received: from localhost.localdomain (unknown [151.66.3.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D388021D80;
        Sat, 19 Oct 2019 08:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571472831;
        bh=/x/ZLkYZ86nStsK2jvfic5sf3Njzt8Dpsu1NGEN1clE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlMooGA/gNYYpgG6AsmjT0IRIKrk/LkYa0uOLwg5oc/9no1BDohQDrUKRyCn0rR18
         B6W25ZVEPPzkZGhbFhGaCBhTYqiTRz7nLoI0bQxYgl/8/tWuNOKn+AJpNEoZ+AytGp
         nrCISMABJYW4wZTuqhAVW6d8OMWOht2wGeMS+UwE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com, jakub.kicinski@netronome.com
Subject: [PATCH v5 net-next 2/7] net: mvneta: introduce page pool API for sw buffer manager
Date:   Sat, 19 Oct 2019 10:13:22 +0200
Message-Id: <4070a7ee9ae788d8d83403d0f326c7edb7cc4183.1571472169.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571472169.git.lorenzo@kernel.org>
References: <cover.1571472169.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/marvell/mvneta.c | 83 +++++++++++++++++++++------
 2 files changed, 65 insertions(+), 19 deletions(-)

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
index 3a8110d0a5b6..cd1a59c7e9d2 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -37,6 +37,7 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/tso.h>
+#include <net/page_pool.h>
 
 /* Registers */
 #define MVNETA_RXQ_CONFIG_REG(q)                (0x1400 + ((q) << 2))
@@ -603,6 +604,10 @@ struct mvneta_rx_queue {
 	u32 pkts_coal;
 	u32 time_coal;
 
+	/* page_pool */
+	struct page_pool *page_pool;
+	struct xdp_rxq_info xdp_rxq;
+
 	/* Virtual address of the RX buffer */
 	void  **buf_virt_addr;
 
@@ -1812,23 +1817,21 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
 			    struct mvneta_rx_queue *rxq,
 			    gfp_t gfp_mask)
 {
+	enum dma_data_direction dma_dir;
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
+	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
+	dma_sync_single_for_device(pp->dev->dev.parent, phys_addr,
+				   PAGE_SIZE, dma_dir);
 	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
+
 	return 0;
 }
 
@@ -1894,10 +1897,12 @@ static void mvneta_rxq_drop_pkts(struct mvneta_port *pp,
 		if (!data || !(rx_desc->buf_phys_addr))
 			continue;
 
-		dma_unmap_page(pp->dev->dev.parent, rx_desc->buf_phys_addr,
-			       PAGE_SIZE, DMA_FROM_DEVICE);
-		__free_page(data);
+		page_pool_put_page(rxq->page_pool, data, false);
 	}
+	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
+		xdp_rxq_info_unreg(&rxq->xdp_rxq);
+	page_pool_destroy(rxq->page_pool);
+	rxq->page_pool = NULL;
 }
 
 static void
@@ -2029,8 +2034,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 				skb_add_rx_frag(rxq->skb, frag_num, page,
 						frag_offset, frag_size,
 						PAGE_SIZE);
-				dma_unmap_page(dev->dev.parent, phys_addr,
-					       PAGE_SIZE, DMA_FROM_DEVICE);
+				page_pool_release_page(rxq->page_pool, page);
 				rxq->left_size -= frag_size;
 			}
 		} else {
@@ -2060,9 +2064,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 						frag_offset, frag_size,
 						PAGE_SIZE);
 
-				dma_unmap_page(dev->dev.parent, phys_addr,
-					       PAGE_SIZE, DMA_FROM_DEVICE);
-
+				page_pool_release_page(rxq->page_pool, page);
 				rxq->left_size -= frag_size;
 			}
 		} /* Middle or Last descriptor */
@@ -2831,11 +2833,54 @@ static int mvneta_poll(struct napi_struct *napi, int budget)
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
+	int err;
+
+	rxq->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(rxq->page_pool)) {
+		err = PTR_ERR(rxq->page_pool);
+		rxq->page_pool = NULL;
+		return err;
+	}
+
+	err = xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, rxq->id);
+	if (err < 0)
+		goto err_free_pp;
+
+	err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
+					 rxq->page_pool);
+	if (err)
+		goto err_unregister_rxq;
+
+	return 0;
+
+err_unregister_rxq:
+	xdp_rxq_info_unreg(&rxq->xdp_rxq);
+err_free_pp:
+	page_pool_destroy(rxq->page_pool);
+	rxq->page_pool = NULL;
+	return err;
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

