Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D3D314B2
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfEaSa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:30:28 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:25532 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbfEaSa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:30:26 -0400
X-Greylist: delayed 854 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 14:30:19 EDT
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VIGMup001068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 12:16:22 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VIG5Do043766
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 12:16:13 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 06/13] net: axienet: Support shared interrupts
Date:   Fri, 31 May 2019 12:15:38 -0600
Message-Id: <1559326545-28825-7-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Specify IRQF_SHARED to support shared interrupts. If the interrupt
handler is called and the device is not indicating an interrupt,
just return IRQ_NONE rather than spewing error messages.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index fad5750..6e5613b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -816,7 +816,7 @@ static void axienet_recv(struct net_device *ndev)
  * @irq:	irq number
  * @_ndev:	net_device pointer
  *
- * Return: IRQ_HANDLED for all cases.
+ * Return: IRQ_HANDLED if device generated a TX interrupt, IRQ_NONE otherwise.
  *
  * This is the Axi DMA Tx done Isr. It invokes "axienet_start_xmit_done"
  * to complete the BD processing.
@@ -835,7 +835,7 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
 		goto out;
 	}
 	if (!(status & XAXIDMA_IRQ_ALL_MASK))
-		dev_err(&ndev->dev, "No interrupts asserted in Tx path\n");
+		return IRQ_NONE;
 	if (status & XAXIDMA_IRQ_ERROR_MASK) {
 		dev_err(&ndev->dev, "DMA Tx error 0x%x\n", status);
 		dev_err(&ndev->dev, "Current BD is at: 0x%x\n",
@@ -865,7 +865,7 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
  * @irq:	irq number
  * @_ndev:	net_device pointer
  *
- * Return: IRQ_HANDLED for all cases.
+ * Return: IRQ_HANDLED if device generated a RX interrupt, IRQ_NONE otherwise.
  *
  * This is the Axi DMA Rx Isr. It invokes "axienet_recv" to complete the BD
  * processing.
@@ -884,7 +884,7 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 		goto out;
 	}
 	if (!(status & XAXIDMA_IRQ_ALL_MASK))
-		dev_err(&ndev->dev, "No interrupts asserted in Rx path\n");
+		return IRQ_NONE;
 	if (status & XAXIDMA_IRQ_ERROR_MASK) {
 		dev_err(&ndev->dev, "DMA Rx error 0x%x\n", status);
 		dev_err(&ndev->dev, "Current BD is at: 0x%x\n",
@@ -957,11 +957,13 @@ static int axienet_open(struct net_device *ndev)
 		     (unsigned long) lp);
 
 	/* Enable interrupts for Axi DMA Tx */
-	ret = request_irq(lp->tx_irq, axienet_tx_irq, 0, ndev->name, ndev);
+	ret = request_irq(lp->tx_irq, axienet_tx_irq, IRQF_SHARED,
+			  ndev->name, ndev);
 	if (ret)
 		goto err_tx_irq;
 	/* Enable interrupts for Axi DMA Rx */
-	ret = request_irq(lp->rx_irq, axienet_rx_irq, 0, ndev->name, ndev);
+	ret = request_irq(lp->rx_irq, axienet_rx_irq, IRQF_SHARED,
+			  ndev->name, ndev);
 	if (ret)
 		goto err_rx_irq;
 
-- 
1.8.3.1

