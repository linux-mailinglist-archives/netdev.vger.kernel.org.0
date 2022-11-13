Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EA8626F2A
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 12:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbiKMLMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 06:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbiKMLMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 06:12:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFCB12AF3;
        Sun, 13 Nov 2022 03:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668337941; x=1699873941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HZHZO0WhtkDNe6O+t1GNqVTy3ldQ1ijx80yqsva3JXA=;
  b=SPqeb664/AWGva7ef4h1O3NaDADaZ+NH//h1QYs9ssd4mIsmSbh01nRV
   BCpaROspflOLpzRhvLpCdDSaCRoEDiImBccSsG+L9hz1KtpCHaw8Yl7lk
   ihqxXbTLVYAmJwITSHYphgWsTDcdQi8CvRYYtRlx80fg4gHNh9YB4WkbA
   Dv4uxgqgYbFPKvtzUJQTmr0iM/utvsQZxITqmeXyLquJNiqvs0f+4E04J
   t1NCLexDaqGXD+Z9IhHt6qTKfZFbup31T3Z1aAb9xhMUvTQg1KjPwXilg
   tVhouNT2j6kEitwOk4LmvJ+Vi0M32fHQKrwAQyFrcHrv8kBwYTDd0KaB/
   g==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="183271854"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Nov 2022 04:12:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 13 Nov 2022 04:12:19 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 13 Nov 2022 04:12:17 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <alexandr.lobakin@intel.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/5] net: lan966x: Add XDP_PACKET_HEADROOM
Date:   Sun, 13 Nov 2022 12:15:55 +0100
Message-ID: <20221113111559.1028030-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221113111559.1028030-1-horatiu.vultur@microchip.com>
References: <20221113111559.1028030-1-horatiu.vultur@microchip.com>
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
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 22 +++++++++++++------
 .../ethernet/microchip/lan966x/lan966x_xdp.c  |  5 +++--
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 5fbbd479cfb06..dc1ac340e1fb3 100644
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
 
@@ -444,7 +448,9 @@ static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
 	if (!lan966x_xdp_port_present(port))
 		return FDMA_PASS;
 
-	return lan966x_xdp_run(port, page, FDMA_DCB_STATUS_BLOCKL(db->status));
+	return lan966x_xdp_run(port, page,
+			       FDMA_DCB_STATUS_BLOCKL(db->status) +
+			       XDP_PACKET_HEADROOM);
 }
 
 static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
@@ -466,7 +472,8 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
 
 	skb_mark_for_recycle(skb);
 
-	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
+	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status) + XDP_PACKET_HEADROOM);
+	skb_pull(skb, XDP_PACKET_HEADROOM);
 
 	lan966x_ifh_get_timestamp(skb->data, &timestamp);
 
@@ -786,7 +793,8 @@ static int lan966x_fdma_get_max_frame(struct lan966x *lan966x)
 	return lan966x_fdma_get_max_mtu(lan966x) +
 	       IFH_LEN_BYTES +
 	       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
-	       VLAN_HLEN * 2;
+	       VLAN_HLEN * 2 +
+	       XDP_PACKET_HEADROOM;
 }
 
 int lan966x_fdma_change_mtu(struct lan966x *lan966x)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
index e77d9f2aad2b4..bab447e79273f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
@@ -44,8 +44,9 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 
 	xdp_init_buff(&xdp, PAGE_SIZE << lan966x->rx.page_order,
 		      &port->xdp_rxq);
-	xdp_prepare_buff(&xdp, page_address(page), IFH_LEN_BYTES,
-			 data_len - IFH_LEN_BYTES, false);
+	xdp_prepare_buff(&xdp, page_address(page),
+			 IFH_LEN_BYTES + XDP_PACKET_HEADROOM,
+			 data_len - IFH_LEN_BYTES - XDP_PACKET_HEADROOM, false);
 	act = bpf_prog_run_xdp(xdp_prog, &xdp);
 	switch (act) {
 	case XDP_PASS:
-- 
2.38.0

