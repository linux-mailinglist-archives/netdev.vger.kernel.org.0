Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A9D61E62E
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 22:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiKFVHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 16:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiKFVHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 16:07:34 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875C91183B;
        Sun,  6 Nov 2022 13:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667768853; x=1699304853;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9EaKjxyRgL3ce9mWgRq8+a6jtQ3V00iuJxjk1OMiI84=;
  b=WCOJ1fvD3apjo+Ln6dqRzETiUblSoEOQvT4X6imaGvbiN0JZ5r2li3gL
   +FPhwjl83wMxDBk3/wYnjEZLd1qaNIEhNOH6LfQkDWKGejva7qCSudOo1
   tEQddmSaQdS96utSeM9cR7azTigG5P6DSbB6uKZ0gqsTyv8423GbI5nsZ
   bfv1GdxThJ+7Z/BDbsQuVEWfVcw3sMimq/aP9tmZvhZJgRbJXRQz+JZIR
   XgbAJ07dUAWHiWBeKrgE1AGzjm3b8M+sfkE3elZOPXo9spAvUObVpA0L8
   Fw3lMrWQcKjp0FcNK9ymvV9/Vpis7FOYctjT1xKxsngoJxQu6FHr3p5hj
   w==;
X-IronPort-AV: E=Sophos;i="5.96,142,1665471600"; 
   d="scan'208";a="122044427"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Nov 2022 14:07:32 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 6 Nov 2022 14:07:31 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 6 Nov 2022 14:07:29 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 2/4] net: lan966x: Split function lan966x_fdma_rx_get_frame
Date:   Sun, 6 Nov 2022 22:11:52 +0100
Message-ID: <20221106211154.3225784-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221106211154.3225784-1-horatiu.vultur@microchip.com>
References: <20221106211154.3225784-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function lan966x_fdma_rx_get_frame was unmapping the frame from
device and check also if the frame was received on a valid port. And
only after that it tried to generate the skb.
Move this check in a different function, in preparation for xdp
support. Such that xdp to be added here and the
lan966x_fdma_rx_get_frame to be used only when giving the skb to upper
layers.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 85 +++++++++++++------
 .../ethernet/microchip/lan966x/lan966x_main.h |  9 ++
 2 files changed, 69 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 6c102ee20f1d7..d37765ddd53ae 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -54,6 +54,17 @@ static void lan966x_fdma_rx_free_pages(struct lan966x_rx *rx)
 	}
 }
 
+static void lan966x_fdma_rx_free_page(struct lan966x_rx *rx)
+{
+	struct page *page;
+
+	page = rx->page[rx->dcb_index][rx->db_index];
+	if (unlikely(!page))
+		return;
+
+	__free_pages(page, rx->page_order);
+}
+
 static void lan966x_fdma_rx_add_dcb(struct lan966x_rx *rx,
 				    struct lan966x_rx_dcb *dcb,
 				    u64 nextptr)
@@ -116,6 +127,12 @@ static int lan966x_fdma_rx_alloc(struct lan966x_rx *rx)
 	return 0;
 }
 
+static void lan966x_fdma_rx_advance_dcb(struct lan966x_rx *rx)
+{
+	rx->dcb_index++;
+	rx->dcb_index &= FDMA_DCB_MAX - 1;
+}
+
 static void lan966x_fdma_rx_free(struct lan966x_rx *rx)
 {
 	struct lan966x *lan966x = rx->lan966x;
@@ -403,38 +420,53 @@ static bool lan966x_fdma_rx_more_frames(struct lan966x_rx *rx)
 	return true;
 }
 
-static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
+static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
 {
 	struct lan966x *lan966x = rx->lan966x;
-	u64 src_port, timestamp;
 	struct lan966x_db *db;
-	struct sk_buff *skb;
 	struct page *page;
 
-	/* Get the received frame and unmap it */
 	db = &rx->dcbs[rx->dcb_index].db[rx->db_index];
 	page = rx->page[rx->dcb_index][rx->db_index];
+	if (unlikely(!page))
+		return FDMA_ERROR;
 
 	dma_sync_single_for_cpu(lan966x->dev, (dma_addr_t)db->dataptr,
 				FDMA_DCB_STATUS_BLOCKL(db->status),
 				DMA_FROM_DEVICE);
 
+	dma_unmap_single_attrs(lan966x->dev, (dma_addr_t)db->dataptr,
+			       PAGE_SIZE << rx->page_order, DMA_FROM_DEVICE,
+			       DMA_ATTR_SKIP_CPU_SYNC);
+
+	lan966x_ifh_get_src_port(page_address(page), src_port);
+	if (WARN_ON(*src_port >= lan966x->num_phys_ports))
+		return FDMA_ERROR;
+
+	return FDMA_PASS;
+}
+
+static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
+						 u64 src_port)
+{
+	struct lan966x *lan966x = rx->lan966x;
+	struct lan966x_db *db;
+	struct sk_buff *skb;
+	struct page *page;
+	u64 timestamp;
+
+	/* Get the received frame and unmap it */
+	db = &rx->dcbs[rx->dcb_index].db[rx->db_index];
+	page = rx->page[rx->dcb_index][rx->db_index];
+
 	skb = build_skb(page_address(page), PAGE_SIZE << rx->page_order);
 	if (unlikely(!skb))
-		goto unmap_page;
+		goto free_page;
 
 	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
 
-	lan966x_ifh_get_src_port(skb->data, &src_port);
 	lan966x_ifh_get_timestamp(skb->data, &timestamp);
 
-	if (WARN_ON(src_port >= lan966x->num_phys_ports))
-		goto free_skb;
-
-	dma_unmap_single_attrs(lan966x->dev, (dma_addr_t)db->dataptr,
-			       PAGE_SIZE << rx->page_order, DMA_FROM_DEVICE,
-			       DMA_ATTR_SKIP_CPU_SYNC);
-
 	skb->dev = lan966x->ports[src_port]->dev;
 	skb_pull(skb, IFH_LEN_BYTES);
 
@@ -457,12 +489,7 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 
 	return skb;
 
-free_skb:
-	kfree_skb(skb);
-unmap_page:
-	dma_unmap_single_attrs(lan966x->dev, (dma_addr_t)db->dataptr,
-			       PAGE_SIZE << rx->page_order, DMA_FROM_DEVICE,
-			       DMA_ATTR_SKIP_CPU_SYNC);
+free_page:
 	__free_pages(page, rx->page_order);
 
 	return NULL;
@@ -478,6 +505,7 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 	struct sk_buff *skb;
 	struct page *page;
 	int counter = 0;
+	u64 src_port;
 	u64 nextptr;
 
 	lan966x_fdma_tx_clear_buf(lan966x, weight);
@@ -487,19 +515,26 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 		if (!lan966x_fdma_rx_more_frames(rx))
 			break;
 
-		skb = lan966x_fdma_rx_get_frame(rx);
+		counter++;
 
-		rx->page[rx->dcb_index][rx->db_index] = NULL;
-		rx->dcb_index++;
-		rx->dcb_index &= FDMA_DCB_MAX - 1;
+		switch (lan966x_fdma_rx_check_frame(rx, &src_port)) {
+		case FDMA_PASS:
+			break;
+		case FDMA_ERROR:
+			lan966x_fdma_rx_free_page(rx);
+			lan966x_fdma_rx_advance_dcb(rx);
+			goto allocate_new;
+		}
 
+		skb = lan966x_fdma_rx_get_frame(rx, src_port);
+		lan966x_fdma_rx_advance_dcb(rx);
 		if (!skb)
-			break;
+			goto allocate_new;
 
 		napi_gro_receive(&lan966x->napi, skb);
-		counter++;
 	}
 
+allocate_new:
 	/* Allocate new pages and map them */
 	while (dcb_reload != rx->dcb_index) {
 		db = &rx->dcbs[dcb_reload].db[rx->db_index];
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 4ec33999e4df6..464fb5e4a8ff6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -100,6 +100,15 @@ enum macaccess_entry_type {
 	ENTRYTYPE_MACV6,
 };
 
+/* FDMA return action codes for checking if the frame is valid
+ * FDMA_PASS, frame is valid and can be used
+ * FDMA_ERROR, something went wrong, stop getting more frames
+ */
+enum lan966x_fdma_action {
+	FDMA_PASS = 0,
+	FDMA_ERROR,
+};
+
 struct lan966x_port;
 
 struct lan966x_db {
-- 
2.38.0

