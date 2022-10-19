Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849D76048C3
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbiJSOIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiJSOHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:07:22 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55786888F;
        Wed, 19 Oct 2022 06:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666187384; x=1697723384;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jCuqHZfOvxY7kIZx6uTkH9sGBO4CT3qm5M3fduho0PI=;
  b=uMbvJyqD344930NQFHDgvkcaXx5Mx2qvE0hK7vZhTxrsqtOuGOY6yw3t
   NxL879CbC57/42dkXSUvgtPY2l2VRJfNeFrWUhh5T+EYrs6TQooYTqAcl
   9LU9cRISQEZ76jJFDrBaITeRcGwFwv/Ol6SJ+PcN+k4S/xZKe3oqb3XfE
   XAVvBF1FZRkHvREkLOEVfKTHBSEpKDJmkuldlRugMbdxwE+8AO6RxykeY
   wJiXL9FIKTkEa8zrRiLII12yscMxiT310OI0/nYHEi09nW5EwKtVxYgqM
   iIT/XrOSyse8amFFnNnX/bqPlryYvqZHCJc+kJiWezYb35tfRpYnFmI9m
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="196129575"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2022 06:46:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 19 Oct 2022 06:46:44 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 19 Oct 2022 06:46:41 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/5] net: lan966x: Split function lan966x_fdma_rx_get_frame
Date:   Wed, 19 Oct 2022 15:50:06 +0200
Message-ID: <20221019135008.3281743-4-horatiu.vultur@microchip.com>
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

The function lan966x_fdma_rx_get_frame was unmapping the frame from
device and check also if the frame was received on a valid port. And
only after that it tried to generate the skb.
Move this check in a different function, in preparation for xdp
support. Such that xdp to be added here and the
lan966x_fdma_rx_get_frame to be used only when giving the skb to upper
layers.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 86 ++++++++++++++-----
 .../ethernet/microchip/lan966x/lan966x_main.h |  9 ++
 2 files changed, 72 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index e0b9cd289994f..6b6baf6a3d1ee 100644
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
@@ -402,32 +419,50 @@ static bool lan966x_fdma_rx_more_frames(struct lan966x_rx *rx)
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
-	skb = build_skb(page_address(page), PAGE_SIZE << rx->page_order);
-	if (unlikely(!skb))
-		goto unmap_page;
+	if (unlikely(!page))
+		return FDMA_RX_ERROR;
 
 	dma_unmap_single(lan966x->dev, (dma_addr_t)db->dataptr,
 			 FDMA_DCB_STATUS_BLOCKL(db->status),
 			 DMA_FROM_DEVICE);
+
+	lan966x_ifh_get_src_port(page_address(page), src_port);
+
+	if (WARN_ON(*src_port >= lan966x->num_phys_ports))
+		return FDMA_RX_ERROR;
+
+	return FDMA_RX_OK;
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
+	/* Get the received frame */
+	db = &rx->dcbs[rx->dcb_index].db[rx->db_index];
+	page = rx->page[rx->dcb_index][rx->db_index];
+
+	skb = build_skb(page_address(page), PAGE_SIZE << rx->page_order);
+	if (unlikely(!skb))
+		goto free_page;
+
 	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
 
-	lan966x_ifh_get_src_port(skb->data, &src_port);
 	lan966x_ifh_get_timestamp(skb->data, &timestamp);
 
-	if (WARN_ON(src_port >= lan966x->num_phys_ports))
-		goto free_skb;
-
 	skb->dev = lan966x->ports[src_port]->dev;
 	skb_pull(skb, IFH_LEN_BYTES);
 
@@ -450,12 +485,7 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 
 	return skb;
 
-free_skb:
-	kfree_skb(skb);
-unmap_page:
-	dma_unmap_page(lan966x->dev, (dma_addr_t)db->dataptr,
-		       FDMA_DCB_STATUS_BLOCKL(db->status),
-		       DMA_FROM_DEVICE);
+free_page:
 	__free_pages(page, rx->page_order);
 
 	return NULL;
@@ -467,10 +497,12 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 	struct lan966x_rx *rx = &lan966x->rx;
 	int dcb_reload = rx->dcb_index;
 	struct lan966x_rx_dcb *old_dcb;
+	enum lan966x_fdma_rx_error err;
 	struct lan966x_db *db;
 	struct sk_buff *skb;
 	struct page *page;
 	int counter = 0;
+	u64 src_port;
 	u64 nextptr;
 
 	lan966x_fdma_tx_clear_buf(lan966x, weight);
@@ -480,19 +512,27 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 		if (!lan966x_fdma_rx_more_frames(rx))
 			break;
 
-		skb = lan966x_fdma_rx_get_frame(rx);
+		counter++;
 
-		rx->page[rx->dcb_index][rx->db_index] = NULL;
-		rx->dcb_index++;
-		rx->dcb_index &= FDMA_DCB_MAX - 1;
+		err = lan966x_fdma_rx_check_frame(rx, &src_port);
+		switch (err) {
+		case FDMA_RX_OK:
+			break;
+		case FDMA_RX_ERROR:
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
index e05036841f825..608e2cb81b095 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -98,6 +98,15 @@ enum macaccess_entry_type {
 	ENTRYTYPE_MACV6,
 };
 
+/* FDMA rx error codes for checking if the frame is valid
+ * FDMA_RX_OK, frame is valid and can be used
+ * FDMA_RX_ERROR, something went wrong, stop getting more frames
+ */
+enum lan966x_fdma_rx_error {
+	FDMA_RX_OK = 0,
+	FDMA_RX_ERROR,
+};
+
 struct lan966x_port;
 
 struct lan966x_db {
-- 
2.38.0

