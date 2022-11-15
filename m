Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72F662A44F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiKOVk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiKOVk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:40:27 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3E8659D;
        Tue, 15 Nov 2022 13:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668548426; x=1700084426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WQHtk5rD0UFDH3ezGkF35r6wv2LNLOm3eEkyD65lDDA=;
  b=zn4KHSh3fX+FUlvYxRD8CW22br+XquArMjUz4VK6VvQ1gWk1sn4neZ9h
   2rRmsEZWdHUVyy408NlAKxHMFgpZOHpX8QA+iFnvyQyFU+hUT1xdpmQt2
   gVkqS+QDy1a0S/ZMgdcZdDt7IZaZNQxA4JS7/H7FkAnmudG8gnCp8nEoX
   hM9M182QH6bppGQJanqg5BlDRKiTcPNzzlW3+Z4/VOhiYIKOrQXUjUZ8G
   xWGvVqwdlhdzgsNB8Dhym3CqDVQ+lrjG1nTwm6SMmrlJMH/S2OMz4sNie
   kP8tlFg178OSe5WEkYOmQahPIzIMS7AWnDIIIgXk06RCRLZdtCVMOj5yR
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="123588501"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Nov 2022 14:40:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 15 Nov 2022 14:40:24 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 15 Nov 2022 14:40:22 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <alexandr.lobakin@intel.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 1/5] net: lan966x: Add XDP_PACKET_HEADROOM
Date:   Tue, 15 Nov 2022 22:44:52 +0100
Message-ID: <20221115214456.1456856-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221115214456.1456856-1-horatiu.vultur@microchip.com>
References: <20221115214456.1456856-1-horatiu.vultur@microchip.com>
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

Update the page_pool params to allocate XDP_PACKET_HEADROOM space as
headroom for all received frames.
This is needed for when the XDP_TX and XDP_REDIRECT are implemented.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c    | 16 +++++++++++-----
 .../net/ethernet/microchip/lan966x/lan966x_xdp.c |  3 ++-
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 5fbbd479cfb06..3055124b4dd79 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 
+#include <linux/bpf.h>
+
 #include "lan966x_main.h"
 
 static int lan966x_fdma_channel_active(struct lan966x *lan966x)
@@ -16,7 +18,7 @@ static struct page *lan966x_fdma_rx_alloc_page(struct lan966x_rx *rx,
 	if (unlikely(!page))
 		return NULL;
 
-	db->dataptr = page_pool_get_dma_addr(page);
+	db->dataptr = page_pool_get_dma_addr(page) + XDP_PACKET_HEADROOM;
 
 	return page;
 }
@@ -72,7 +74,7 @@ static int lan966x_fdma_rx_alloc_page_pool(struct lan966x_rx *rx)
 		.nid = NUMA_NO_NODE,
 		.dev = lan966x->dev,
 		.dma_dir = DMA_FROM_DEVICE,
-		.offset = 0,
+		.offset = XDP_PACKET_HEADROOM,
 		.max_len = rx->max_mtu -
 			   SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
 	};
@@ -432,11 +434,13 @@ static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
 	if (unlikely(!page))
 		return FDMA_ERROR;
 
-	dma_sync_single_for_cpu(lan966x->dev, (dma_addr_t)db->dataptr,
+	dma_sync_single_for_cpu(lan966x->dev,
+				(dma_addr_t)db->dataptr + XDP_PACKET_HEADROOM,
 				FDMA_DCB_STATUS_BLOCKL(db->status),
 				DMA_FROM_DEVICE);
 
-	lan966x_ifh_get_src_port(page_address(page), src_port);
+	lan966x_ifh_get_src_port(page_address(page) + XDP_PACKET_HEADROOM,
+				 src_port);
 	if (WARN_ON(*src_port >= lan966x->num_phys_ports))
 		return FDMA_ERROR;
 
@@ -466,6 +470,7 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
 
 	skb_mark_for_recycle(skb);
 
+	skb_reserve(skb, XDP_PACKET_HEADROOM);
 	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
 
 	lan966x_ifh_get_timestamp(skb->data, &timestamp);
@@ -786,7 +791,8 @@ static int lan966x_fdma_get_max_frame(struct lan966x *lan966x)
 	return lan966x_fdma_get_max_mtu(lan966x) +
 	       IFH_LEN_BYTES +
 	       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
-	       VLAN_HLEN * 2;
+	       VLAN_HLEN * 2 +
+	       XDP_PACKET_HEADROOM;
 }
 
 int lan966x_fdma_change_mtu(struct lan966x *lan966x)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
index e77d9f2aad2b4..8ebde1eb6a09c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
@@ -44,7 +44,8 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 
 	xdp_init_buff(&xdp, PAGE_SIZE << lan966x->rx.page_order,
 		      &port->xdp_rxq);
-	xdp_prepare_buff(&xdp, page_address(page), IFH_LEN_BYTES,
+	xdp_prepare_buff(&xdp, page_address(page),
+			 IFH_LEN_BYTES + XDP_PACKET_HEADROOM,
 			 data_len - IFH_LEN_BYTES, false);
 	act = bpf_prog_run_xdp(xdp_prog, &xdp);
 	switch (act) {
-- 
2.38.0

