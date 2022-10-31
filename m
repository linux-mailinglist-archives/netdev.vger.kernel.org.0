Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484AF61380E
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 14:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiJaN3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 09:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJaN3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 09:29:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED93A186;
        Mon, 31 Oct 2022 06:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667222989; x=1698758989;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MFSrCmIz/b7aHVX9cI/boZVwdsqhtu4RlVDqw+qpvow=;
  b=sorc8kas7HODu16ElTZmwt3iPLBQyNR2kV7YB8AwJW8E6fOZ/34ZkeGR
   T1T8kByy68LW38FpXomc513YsCOsZu6GY3zD6SRUrGtmvwcHlpm+2XZE6
   ol11q/IhzYHxWMhethNlPhTuLmzXArHkEfGERsFZ3hZ2mIddSQGzgep3v
   S0xN4JZYM3ydPQk4MC2WUoFipjjcpURM03ZFxmv7WMcgPZE5OcWrb7T6j
   CCZMVi1inSi1jfFPtKB4aeBQQ5GpKn8Bo5T+xx7vs8o6EeGSHX1cwqAlh
   x84vKXxrYIXs0IdlGYxy2Te8dJQCzAJpp+sGKqKcf+SEpaMFzE8X6++iT
   w==;
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="186982879"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Oct 2022 06:29:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 31 Oct 2022 06:29:47 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 31 Oct 2022 06:29:46 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: lan966x: Fix unmapping of received frames using FDMA
Date:   Mon, 31 Oct 2022 14:34:21 +0100
Message-ID: <20221031133421.1283196-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When lan966x was receiving a frame, then it was building the skb and
after that it was calling dma_unmap_single with frame size as the
length. This actually has 2 issues:
1. It is using a length to map and a different length to unmap.
2. When the unmap was happening, the data was sync for cpu but it could
   be that this will overwrite what build_skb was initializing.

The fix for these two problems is to change the order of operations.
First to sync the frame for cpu, then to build the skb and in the end to
unmap using the correct size but without sync the frame again for cpu.

Fixes: c8349639324a ("net: lan966x: Add FDMA functionality")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c  | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index c235edd2b182a..e6948939ccc2b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -414,13 +414,15 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 	/* Get the received frame and unmap it */
 	db = &rx->dcbs[rx->dcb_index].db[rx->db_index];
 	page = rx->page[rx->dcb_index][rx->db_index];
+
+	dma_sync_single_for_cpu(lan966x->dev, (dma_addr_t)db->dataptr,
+				FDMA_DCB_STATUS_BLOCKL(db->status),
+				DMA_FROM_DEVICE);
+
 	skb = build_skb(page_address(page), PAGE_SIZE << rx->page_order);
 	if (unlikely(!skb))
 		goto unmap_page;
 
-	dma_unmap_single(lan966x->dev, (dma_addr_t)db->dataptr,
-			 FDMA_DCB_STATUS_BLOCKL(db->status),
-			 DMA_FROM_DEVICE);
 	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
 
 	lan966x_ifh_get_src_port(skb->data, &src_port);
@@ -429,6 +431,10 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 	if (WARN_ON(src_port >= lan966x->num_phys_ports))
 		goto free_skb;
 
+	dma_unmap_single_attrs(lan966x->dev, (dma_addr_t)db->dataptr,
+			       PAGE_SIZE << rx->page_order, DMA_FROM_DEVICE,
+			       DMA_ATTR_SKIP_CPU_SYNC);
+
 	skb->dev = lan966x->ports[src_port]->dev;
 	skb_pull(skb, IFH_LEN * sizeof(u32));
 
@@ -454,9 +460,9 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 free_skb:
 	kfree_skb(skb);
 unmap_page:
-	dma_unmap_page(lan966x->dev, (dma_addr_t)db->dataptr,
-		       FDMA_DCB_STATUS_BLOCKL(db->status),
-		       DMA_FROM_DEVICE);
+	dma_unmap_single_attrs(lan966x->dev, (dma_addr_t)db->dataptr,
+			       PAGE_SIZE << rx->page_order, DMA_FROM_DEVICE,
+			       DMA_ATTR_SKIP_CPU_SYNC);
 	__free_pages(page, rx->page_order);
 
 	return NULL;
-- 
2.38.0

