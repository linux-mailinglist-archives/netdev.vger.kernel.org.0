Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAFB604A3A
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiJSPA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiJSPAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:00:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5E4108DD1;
        Wed, 19 Oct 2022 07:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666191241; x=1697727241;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dmqJD4fcpIKbqeF6IrZ6qAmHqj1QWhXt8/3LbmilXiA=;
  b=m+SshWKgOaE3n3ictFRzULnMPtSZRLvQhoCin74FRoweY7blLJO07PuV
   bqiPhXM4NkxPxKFJPuR69kgyGF+NVQhYgF3Pjq7M4SxYbWQKzonjh33v9
   wysGc6M4g7GxgRQD1I2yr/4ywfLvGgu2odiVZBn1qQPckp/FIeoAFmbCf
   25skj1iiLkbub5Vy7EL3VS8Xgj42ctiI79F39frk8Q5Dek0C3xwE9DwX9
   0jOuvYbs5cgtoyUQyws11+MaspOiOCwyWp0UUTePpVfJIiX87GeOPAORY
   TX83XMHXfIMy0X1qvhwm0o5Dex+yLzPmTPvtduB8p30xgwmz9SrQ/2/2S
   w==;
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="185521599"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2022 06:46:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 19 Oct 2022 06:46:50 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 19 Oct 2022 06:46:47 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 5/5] net: lan96x: Use page_pool API
Date:   Wed, 19 Oct 2022 15:50:08 +0200
Message-ID: <20221019135008.3281743-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019135008.3281743-1-horatiu.vultur@microchip.com>
References: <20221019135008.3281743-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 74 +++++++++++--------
 .../ethernet/microchip/lan966x/lan966x_main.h |  3 +
 3 files changed, 46 insertions(+), 32 deletions(-)

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
index 4e8f7e47c5536..ba34a7b7ccd13 100644
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
@@ -431,9 +433,9 @@ static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
 	if (unlikely(!page))
 		return FDMA_RX_ERROR;
 
-	dma_unmap_single(lan966x->dev, (dma_addr_t)db->dataptr,
-			 FDMA_DCB_STATUS_BLOCKL(db->status),
-			 DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(lan966x->dev, (dma_addr_t)db->dataptr,
+				FDMA_DCB_STATUS_BLOCKL(db->status),
+				DMA_FROM_DEVICE);
 
 	lan966x_ifh_get_src_port(page_address(page), src_port);
 
@@ -464,6 +466,8 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
 	if (unlikely(!skb))
 		goto free_page;
 
+	skb_mark_for_recycle(skb);
+
 	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
 
 	lan966x_ifh_get_timestamp(skb->data, &timestamp);
@@ -491,7 +495,7 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
 	return skb;
 
 free_page:
-	__free_pages(page, rx->page_order);
+	page_pool_recycle_direct(rx->page_pool, page);
 
 	return NULL;
 }
@@ -718,6 +722,7 @@ static int lan966x_qsys_sw_status(struct lan966x *lan966x)
 static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 {
 	void *rx_dcbs, *tx_dcbs, *tx_dcbs_buf;
+	struct page_pool *page_pool;
 	dma_addr_t rx_dma, tx_dma;
 	u32 size;
 	int err;
@@ -728,6 +733,7 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	rx_dcbs = lan966x->rx.dcbs;
 	tx_dcbs = lan966x->tx.dcbs;
 	tx_dcbs_buf = lan966x->tx.dcbs_buf;
+	page_pool = lan966x->rx.page_pool;
 
 	napi_synchronize(&lan966x->napi);
 	napi_disable(&lan966x->napi);
@@ -745,6 +751,8 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	size = ALIGN(size, PAGE_SIZE);
 	dma_free_coherent(lan966x->dev, size, rx_dcbs, rx_dma);
 
+	page_pool_destroy(page_pool);
+
 	lan966x_fdma_tx_disable(&lan966x->tx);
 	err = lan966x_fdma_tx_alloc(&lan966x->tx);
 	if (err)
@@ -761,6 +769,7 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 
 	return err;
 restore:
+	lan966x->rx.page_pool = page_pool;
 	lan966x->rx.dma = rx_dma;
 	lan966x->rx.dcbs = rx_dcbs;
 	lan966x_fdma_rx_start(&lan966x->rx);
@@ -872,5 +881,6 @@ void lan966x_fdma_deinit(struct lan966x *lan966x)
 
 	lan966x_fdma_rx_free_pages(&lan966x->rx);
 	lan966x_fdma_rx_free(&lan966x->rx);
+	page_pool_destroy(lan966x->rx.page_pool);
 	lan966x_fdma_tx_free(&lan966x->tx);
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index e635e529df0d4..9abdc3fb3f7e5 100644
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
@@ -160,6 +161,8 @@ struct lan966x_rx {
 	u8 page_order;
 
 	u8 channel_id;
+
+	struct page_pool *page_pool;
 };
 
 struct lan966x_tx_dcb_buf {
-- 
2.38.0

