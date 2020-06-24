Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB740206D9B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 09:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389733AbgFXH1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 03:27:10 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:22094 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728858AbgFXH1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 03:27:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592983629; x=1624519629;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=RfHl3RZzpqMqVj1MJ+mYi1DQEoWb6jQu7hXLM/jKtXU=;
  b=Ut9sPa9RNquJgsMtxObDTKHXMPfpCd54EjfL2WTtKfz78zA27BinmOGd
   PhqPRXk4luUUM10SAxnoW8JFvCKuvyNbO1boer5rZkWYHa5ct2I3FhkPw
   UyvikukoZAZVuN5h/RcuFRafeKL5Pie9bpT2uiZTVC3ofcH29PQ7yyMnB
   CAQApU3JSI+l5G1k2Vm9XOKS0F0sqlex8uGd1bLLGaPthJvm1+CuBZZFc
   txKpAJQJtbgm4GLmD19uGK9/C/4SwC7N+BwaRrDXVm9hnn2g6PSaOIguU
   BJ8tFQ2Ecs+tGEKsv7ajRMV06RDMTRZyRxgHrh8Au4/K/vQuwkgsUutIy
   w==;
IronPort-SDR: hyVLhBhfdaWkThUZp2dsDp/IIFBSVCskelv8BSUcBgavOiX5vJfggrLY/w6srmGMjT8HUC3lxB
 8YM5pmgqqzuInZPRPWTyVMLD/s0Jq5fSMutV7t6lhuSk7e6B9EFPRXswW1ThQLZL0CyMO32mkB
 9WlxKI+N3f21Br4+9kFhP/Z2RwzV2naQZ2q1oxc+9cDfAR9Nio4fv33vHUbbf8WVpPuMnEGWEb
 jzlWR+qTkiMAzHVkN7X1RuxGqrTgZsdUPg1/3CyO4UJo3IQtxTAqAyCnjtP1Oo9NlzU0Hlz+O9
 0Uw=
X-IronPort-AV: E=Sophos;i="5.75,274,1589266800"; 
   d="scan'208";a="81363822"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2020 00:27:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Jun 2020 00:26:57 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 24 Jun 2020 00:26:53 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <antoine.tenart@bootlin.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH] net: macb: free resources on failure path of at91ether_open()
Date:   Wed, 24 Jun 2020 10:26:54 +0300
Message-ID: <1592983614-31485-1-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DMA buffers were not freed on failure path of at91ether_open().
Along with changes for freeing the DMA buffers the enable/disable
interrupt instructions were moved to at91ether_start()/at91ether_stop()
functions and the operations on at91ether_stop() were done in
their reverse order (compared with how is done in at91ether_start()):
before this patch the operation order on interface open path
was as follows:
1/ alloc DMA buffers
2/ enable tx, rx
3/ enable interrupts
and the order on interface close path was as follows:
1/ disable tx, rx
2/ disable interrupts
3/ free dma buffers.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 116 +++++++++++++++++++------------
 1 file changed, 73 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 5705359a3612..52582e8ed90e 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3762,15 +3762,9 @@ static int macb_init(struct platform_device *pdev)
 
 static struct sifive_fu540_macb_mgmt *mgmt;
 
-/* Initialize and start the Receiver and Transmit subsystems */
-static int at91ether_start(struct net_device *dev)
+static int at91ether_alloc_coherent(struct macb *lp)
 {
-	struct macb *lp = netdev_priv(dev);
 	struct macb_queue *q = &lp->queues[0];
-	struct macb_dma_desc *desc;
-	dma_addr_t addr;
-	u32 ctl;
-	int i;
 
 	q->rx_ring = dma_alloc_coherent(&lp->pdev->dev,
 					 (AT91ETHER_MAX_RX_DESCR *
@@ -3792,6 +3786,43 @@ static int at91ether_start(struct net_device *dev)
 		return -ENOMEM;
 	}
 
+	return 0;
+}
+
+static void at91ether_free_coherent(struct macb *lp)
+{
+	struct macb_queue *q = &lp->queues[0];
+
+	if (q->rx_ring) {
+		dma_free_coherent(&lp->pdev->dev,
+				  AT91ETHER_MAX_RX_DESCR *
+				  macb_dma_desc_get_size(lp),
+				  q->rx_ring, q->rx_ring_dma);
+		q->rx_ring = NULL;
+	}
+
+	if (q->rx_buffers) {
+		dma_free_coherent(&lp->pdev->dev,
+				  AT91ETHER_MAX_RX_DESCR *
+				  AT91ETHER_MAX_RBUFF_SZ,
+				  q->rx_buffers, q->rx_buffers_dma);
+		q->rx_buffers = NULL;
+	}
+}
+
+/* Initialize and start the Receiver and Transmit subsystems */
+static int at91ether_start(struct macb *lp)
+{
+	struct macb_queue *q = &lp->queues[0];
+	struct macb_dma_desc *desc;
+	dma_addr_t addr;
+	u32 ctl;
+	int i, ret;
+
+	ret = at91ether_alloc_coherent(lp);
+	if (ret)
+		return ret;
+
 	addr = q->rx_buffers_dma;
 	for (i = 0; i < AT91ETHER_MAX_RX_DESCR; i++) {
 		desc = macb_rx_desc(q, i);
@@ -3813,9 +3844,39 @@ static int at91ether_start(struct net_device *dev)
 	ctl = macb_readl(lp, NCR);
 	macb_writel(lp, NCR, ctl | MACB_BIT(RE) | MACB_BIT(TE));
 
+	/* Enable MAC interrupts */
+	macb_writel(lp, IER, MACB_BIT(RCOMP)	|
+			     MACB_BIT(RXUBR)	|
+			     MACB_BIT(ISR_TUND)	|
+			     MACB_BIT(ISR_RLE)	|
+			     MACB_BIT(TCOMP)	|
+			     MACB_BIT(ISR_ROVR)	|
+			     MACB_BIT(HRESP));
+
 	return 0;
 }
 
+static void at91ether_stop(struct macb *lp)
+{
+	u32 ctl;
+
+	/* Disable MAC interrupts */
+	macb_writel(lp, IDR, MACB_BIT(RCOMP)	|
+			     MACB_BIT(RXUBR)	|
+			     MACB_BIT(ISR_TUND)	|
+			     MACB_BIT(ISR_RLE)	|
+			     MACB_BIT(TCOMP)	|
+			     MACB_BIT(ISR_ROVR) |
+			     MACB_BIT(HRESP));
+
+	/* Disable Receiver and Transmitter */
+	ctl = macb_readl(lp, NCR);
+	macb_writel(lp, NCR, ctl & ~(MACB_BIT(TE) | MACB_BIT(RE)));
+
+	/* Free resources. */
+	at91ether_free_coherent(lp);
+}
+
 /* Open the ethernet interface */
 static int at91ether_open(struct net_device *dev)
 {
@@ -3835,27 +3896,20 @@ static int at91ether_open(struct net_device *dev)
 
 	macb_set_hwaddr(lp);
 
-	ret = at91ether_start(dev);
+	ret = at91ether_start(lp);
 	if (ret)
 		goto pm_exit;
 
-	/* Enable MAC interrupts */
-	macb_writel(lp, IER, MACB_BIT(RCOMP)	|
-			     MACB_BIT(RXUBR)	|
-			     MACB_BIT(ISR_TUND)	|
-			     MACB_BIT(ISR_RLE)	|
-			     MACB_BIT(TCOMP)	|
-			     MACB_BIT(ISR_ROVR)	|
-			     MACB_BIT(HRESP));
-
 	ret = macb_phylink_connect(lp);
 	if (ret)
-		goto pm_exit;
+		goto stop;
 
 	netif_start_queue(dev);
 
 	return 0;
 
+stop:
+	at91ether_stop(lp);
 pm_exit:
 	pm_runtime_put_sync(&lp->pdev->dev);
 	return ret;
@@ -3865,37 +3919,13 @@ static int at91ether_open(struct net_device *dev)
 static int at91ether_close(struct net_device *dev)
 {
 	struct macb *lp = netdev_priv(dev);
-	struct macb_queue *q = &lp->queues[0];
-	u32 ctl;
-
-	/* Disable Receiver and Transmitter */
-	ctl = macb_readl(lp, NCR);
-	macb_writel(lp, NCR, ctl & ~(MACB_BIT(TE) | MACB_BIT(RE)));
-
-	/* Disable MAC interrupts */
-	macb_writel(lp, IDR, MACB_BIT(RCOMP)	|
-			     MACB_BIT(RXUBR)	|
-			     MACB_BIT(ISR_TUND)	|
-			     MACB_BIT(ISR_RLE)	|
-			     MACB_BIT(TCOMP)	|
-			     MACB_BIT(ISR_ROVR) |
-			     MACB_BIT(HRESP));
 
 	netif_stop_queue(dev);
 
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
 
-	dma_free_coherent(&lp->pdev->dev,
-			  AT91ETHER_MAX_RX_DESCR *
-			  macb_dma_desc_get_size(lp),
-			  q->rx_ring, q->rx_ring_dma);
-	q->rx_ring = NULL;
-
-	dma_free_coherent(&lp->pdev->dev,
-			  AT91ETHER_MAX_RX_DESCR * AT91ETHER_MAX_RBUFF_SZ,
-			  q->rx_buffers, q->rx_buffers_dma);
-	q->rx_buffers = NULL;
+	at91ether_stop(lp);
 
 	return pm_runtime_put(&lp->pdev->dev);
 }
-- 
2.7.4

