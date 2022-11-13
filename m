Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8979626F31
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 12:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbiKMLMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 06:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbiKMLM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 06:12:27 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E08913CD3;
        Sun, 13 Nov 2022 03:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668337946; x=1699873946;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bll0TqhYnoY1M4sg8gSjG9QBEcHQzOV1+03JZymwRBM=;
  b=d2OPucxO59B6bCeHl2CNEGZvOG1lwTwfJ6knzNZN6mZhNlnPdZNCEb3l
   EwHKVARj30wyISXYOrw1mentOCdXU/Tuh3cyLkpcy3mCx11B+f45MI8uv
   oimExKt1LOX4Lyiq/N3fJbGUWTvWJ4nmaDiT+5Mo0WCWZ//1VGgGV3wrX
   phaFLRcidokb8yzdK1snSo1rVGN4Ma75OsWPzFy4yc61l5lDV0/X84QrH
   M/u427vq7DsyeAYRGnqbLBp+xAWTXot78e6pCFBW9n6v/cAlPXunJ1s38
   Gi74flwErOhOca/SHU+6xbFXLOOj7iWm4Pk3hwXmClVG8Z5FTFHJpu2cW
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="183271860"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Nov 2022 04:12:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 13 Nov 2022 04:12:25 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 13 Nov 2022 04:12:22 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <alexandr.lobakin@intel.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/5] net: lan966x: Add len field to lan966x_tx_dcb_buf
Date:   Sun, 13 Nov 2022 12:15:57 +0100
Message-ID: <20221113111559.1028030-4-horatiu.vultur@microchip.com>
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

Currently when a frame was transmitted, it is required to unamp the
frame that was transmitted. The length of the frame was taken from the
transmitted skb. In the future we might not have an skb, therefore store
the length skb directly in the lan966x_tx_dcb_buf and use this one to
unamp the frame.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 5 +++--
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 0dbe620d3093f..833583f6bbfa6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -391,12 +391,12 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
 			continue;
 
 		dcb_buf->dev->stats.tx_packets++;
-		dcb_buf->dev->stats.tx_bytes += dcb_buf->skb->len;
+		dcb_buf->dev->stats.tx_bytes += dcb_buf->len;
 
 		dcb_buf->used = false;
 		dma_unmap_single(lan966x->dev,
 				 dcb_buf->dma_addr,
-				 dcb_buf->skb->len,
+				 dcb_buf->len,
 				 DMA_TO_DEVICE);
 		if (!dcb_buf->ptp)
 			dev_kfree_skb_any(dcb_buf->skb);
@@ -711,6 +711,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 	/* Fill up the buffer */
 	next_dcb_buf = &tx->dcbs_buf[next_to_use];
 	next_dcb_buf->skb = skb;
+	next_dcb_buf->len = skb->len;
 	next_dcb_buf->dma_addr = dma_addr;
 	next_dcb_buf->used = true;
 	next_dcb_buf->ptp = false;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index bc93051aa0798..7bb9098496f60 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -175,6 +175,7 @@ struct lan966x_rx {
 struct lan966x_tx_dcb_buf {
 	struct net_device *dev;
 	struct sk_buff *skb;
+	int len;
 	dma_addr_t dma_addr;
 	bool used;
 	bool ptp;
-- 
2.38.0

