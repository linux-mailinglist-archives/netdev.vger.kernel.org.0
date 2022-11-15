Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7644762A459
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238843AbiKOVlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbiKOVkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:40:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4F02D1FD;
        Tue, 15 Nov 2022 13:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668548439; x=1700084439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=06uf81UhcRsqU248Upd8RTcFIMaBlp2xwT4+VIGMlqQ=;
  b=doz9pgsP6tdBh+pldkoESxLPsowHQ0dMuzmR2nLyR5yHS+yZ5l0nn2Vq
   wKbSQTx9Z0YmPGqLsCC6g7xCqovo92ZwHy4MbCtzzaEs24LthyYUqFC8t
   9rsQatFlyc2VplxacpJiMsxEH2nx7axwD0AR+VVcOGNLAQSzfud4QQRFy
   neP4zoLUyCSJbAoyqMpgd6Vg6o5AcKzbwz2mimCSXn+hMQyeD8w6p5xUl
   DqsufsQJA4s5pN1ePjhcuP3Mt43Rbg+MxOaYkXCLpK0RyDBSxCE7GcPfL
   FVKuJEgks/Jpya8v78DnZoA2Zd/VllltbJQpCGjJZuGRx0frSh2LXtTLX
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="187145448"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Nov 2022 14:40:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 15 Nov 2022 14:40:30 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 15 Nov 2022 14:40:27 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <alexandr.lobakin@intel.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 3/5] net: lan966x: Add len field to lan966x_tx_dcb_buf
Date:   Tue, 15 Nov 2022 22:44:54 +0100
Message-ID: <20221115214456.1456856-4-horatiu.vultur@microchip.com>
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
index 94c720e59caee..384ed34197d58 100644
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
@@ -709,6 +709,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
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

