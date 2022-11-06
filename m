Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C718361E631
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 22:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiKFVHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 16:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiKFVHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 16:07:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5E311A3C;
        Sun,  6 Nov 2022 13:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667768858; x=1699304858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dda4GjcqT3Bkv68MV+0TVCyhYSee8nGRh9xescJp9Ew=;
  b=GfjHJyT2aFomWqpZKym3W0j1+xXaMUie/xlNR5i84PAg4ozLQiQBo3qS
   zBvD+JgREqpsBUKY26udulzf7mtSbHT16TWW62lm3f04vvAglth+kOOtp
   nG398A6vRc4sRpu21S/BqWSeGKGOCtL6z2pgp3PaJ0RWUmZ7gZZqJf/IA
   g9gQESxylSE4ieQJOAyqs32kPTk5gwffi/7tFXCVR+zJ41hZwrS/3lXIu
   +AZjso3XFG4zRTkgPzD3ICDnXHO6askYdW4LGq9lz3dHUgYvXIrQ4f8GM
   NPwKPnDltsuP1jCwC+CSTI5VjF6MLVc4bzLD/zIvPWulQ4pgPRnmCIqaa
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,142,1665471600"; 
   d="scan'208";a="187885516"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Nov 2022 14:07:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 6 Nov 2022 14:07:37 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 6 Nov 2022 14:07:34 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 4/4] net: lan96x: Use page_pool API
Date:   Sun, 6 Nov 2022 22:11:54 +0100
Message-ID: <20221106211154.3225784-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221106211154.3225784-1-horatiu.vultur@microchip.com>
References: <20221106211154.3225784-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the page_pool API for allocation, freeing and DMA handling instead
of dev_alloc_pages, __free_pages and dma_map_page.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Kconfig    |  1 +
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 72 ++++++++++---------
 .../ethernet/microchip/lan966x/lan966x_main.h |  3 +
 3 files changed, 43 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net/ethernet/microchip/lan966x/Kconfig
index 49e1464a43139..b7ae5ce7d3f7a 100644
--- a/drivers/net/ethernet/microchip/lan966x/Kconfig
+++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
@@ -7,5 +7,6 @@ config LAN966X_SWITCH
 	depends on BRIDGE || BRIDGE=n
 	select PHYLINK
 	select PACKING
+	select PAGE_POOL
 	help
 	  This driver supports the Lan966x network switch device.
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index fa4198c617667..822c1b053e2d0 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -10,47 +10,25 @@ static int lan966x_fdma_channel_active(struct lan966x *lan966x)
 static struct page *lan966x_fdma_rx_alloc_page(struct lan966x_rx *rx,
 					       struct lan966x_db *db)
 {
-	struct lan966x *lan966x = rx->lan966x;
-	dma_addr_t dma_addr;
 	struct page *page;
 
-	page = dev_alloc_pages(rx->page_order);
+	page = page_pool_dev_alloc_pages(rx->page_pool);
 	if (unlikely(!page))
 		return NULL;
 
-	dma_addr = dma_map_page(lan966x->dev, page, 0,
-				PAGE_SIZE << rx->page_order,
-				DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(lan966x->dev, dma_addr)))
-		goto free_page;
-
-	db->dataptr = dma_addr;
+	db->dataptr = page_pool_get_dma_addr(page);
 
 	return page;
-
-free_page:
-	__free_pages(page, rx->page_order);
-	return NULL;
 }
 
 static void lan966x_fdma_rx_free_pages(struct lan966x_rx *rx)
 {
-	struct lan966x *lan966x = rx->lan966x;
-	struct lan966x_rx_dcb *dcb;
-	struct lan966x_db *db;
 	int i, j;
 
 	for (i = 0; i < FDMA_DCB_MAX; ++i) {
-		dcb = &rx->dcbs[i];
-
-		for (j = 0; j < FDMA_RX_DCB_MAX_DBS; ++j) {
-			db = &dcb->db[j];
-			dma_unmap_single(lan966x->dev,
-					 (dma_addr_t)db->dataptr,
-					 PAGE_SIZE << rx->page_order,
-					 DMA_FROM_DEVICE);
-			__free_pages(rx->page[i][j], rx->page_order);
-		}
+		for (j = 0; j < FDMA_RX_DCB_MAX_DBS; ++j)
+			page_pool_put_full_page(rx->page_pool,
+						rx->page[i][j], false);
 	}
 }
 
@@ -62,7 +40,7 @@ static void lan966x_fdma_rx_free_page(struct lan966x_rx *rx)
 	if (unlikely(!page))
 		return;
 
-	__free_pages(page, rx->page_order);
+	page_pool_recycle_direct(rx->page_pool, page);
 }
 
 static void lan966x_fdma_rx_add_dcb(struct lan966x_rx *rx,
@@ -84,6 +62,27 @@ static void lan966x_fdma_rx_add_dcb(struct lan966x_rx *rx,
 	rx->last_entry = dcb;
 }
 
+static int lan966x_fdma_rx_alloc_page_pool(struct lan966x_rx *rx)
+{
+	struct lan966x *lan966x = rx->lan966x;
+	struct page_pool_params pp_params = {
+		.order = rx->page_order,
+		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
+		.pool_size = FDMA_DCB_MAX,
+		.nid = NUMA_NO_NODE,
+		.dev = lan966x->dev,
+		.dma_dir = DMA_FROM_DEVICE,
+		.offset = 0,
+		.max_len = PAGE_SIZE << rx->page_order,
+	};
+
+	rx->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(rx->page_pool))
+		return PTR_ERR(rx->page_pool);
+
+	return 0;
+}
+
 static int lan966x_fdma_rx_alloc(struct lan966x_rx *rx)
 {
 	struct lan966x *lan966x = rx->lan966x;
@@ -93,6 +92,9 @@ static int lan966x_fdma_rx_alloc(struct lan966x_rx *rx)
 	int i, j;
 	int size;
 
+	if (lan966x_fdma_rx_alloc_page_pool(rx))
+		return PTR_ERR(rx->page_pool);
+
 	/* calculate how many pages are needed to allocate the dcbs */
 	size = sizeof(struct lan966x_rx_dcb) * FDMA_DCB_MAX;
 	size = ALIGN(size, PAGE_SIZE);
@@ -436,10 +438,6 @@ static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
 				FDMA_DCB_STATUS_BLOCKL(db->status),
 				DMA_FROM_DEVICE);
 
-	dma_unmap_single_attrs(lan966x->dev, (dma_addr_t)db->dataptr,
-			       PAGE_SIZE << rx->page_order, DMA_FROM_DEVICE,
-			       DMA_ATTR_SKIP_CPU_SYNC);
-
 	lan966x_ifh_get_src_port(page_address(page), src_port);
 	if (WARN_ON(*src_port >= lan966x->num_phys_ports))
 		return FDMA_ERROR;
@@ -468,6 +466,8 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
 	if (unlikely(!skb))
 		goto free_page;
 
+	skb_mark_for_recycle(skb);
+
 	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
 
 	lan966x_ifh_get_timestamp(skb->data, &timestamp);
@@ -495,7 +495,7 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
 	return skb;
 
 free_page:
-	__free_pages(page, rx->page_order);
+	page_pool_recycle_direct(rx->page_pool, page);
 
 	return NULL;
 }
@@ -740,6 +740,7 @@ static int lan966x_qsys_sw_status(struct lan966x *lan966x)
 
 static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 {
+	struct page_pool *page_pool;
 	dma_addr_t rx_dma;
 	void *rx_dcbs;
 	u32 size;
@@ -748,6 +749,7 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	/* Store these for later to free them */
 	rx_dma = lan966x->rx.dma;
 	rx_dcbs = lan966x->rx.dcbs;
+	page_pool = lan966x->rx.page_pool;
 
 	napi_synchronize(&lan966x->napi);
 	napi_disable(&lan966x->napi);
@@ -765,11 +767,14 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	size = ALIGN(size, PAGE_SIZE);
 	dma_free_coherent(lan966x->dev, size, rx_dcbs, rx_dma);
 
+	page_pool_destroy(page_pool);
+
 	lan966x_fdma_wakeup_netdev(lan966x);
 	napi_enable(&lan966x->napi);
 
 	return err;
 restore:
+	lan966x->rx.page_pool = page_pool;
 	lan966x->rx.dma = rx_dma;
 	lan966x->rx.dcbs = rx_dcbs;
 	lan966x_fdma_rx_start(&lan966x->rx);
@@ -876,5 +881,6 @@ void lan966x_fdma_deinit(struct lan966x *lan966x)
 
 	lan966x_fdma_rx_free_pages(&lan966x->rx);
 	lan966x_fdma_rx_free(&lan966x->rx);
+	page_pool_destroy(lan966x->rx.page_pool);
 	lan966x_fdma_tx_free(&lan966x->tx);
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 18f727f397fd6..97652a73017a2 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -9,6 +9,7 @@
 #include <linux/phy.h>
 #include <linux/phylink.h>
 #include <linux/ptp_clock_kernel.h>
+#include <net/page_pool.h>
 #include <net/pkt_cls.h>
 #include <net/pkt_sched.h>
 #include <net/switchdev.h>
@@ -162,6 +163,8 @@ struct lan966x_rx {
 	u8 page_order;
 
 	u8 channel_id;
+
+	struct page_pool *page_pool;
 };
 
 struct lan966x_tx_dcb_buf {
-- 
2.38.0

