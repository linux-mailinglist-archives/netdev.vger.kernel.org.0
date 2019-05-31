Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E72314AD
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfEaSac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:30:32 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:25532 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfEaSa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:30:29 -0400
X-Greylist: delayed 854 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 14:30:19 EDT
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VIGUhg018565
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 12:16:30 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VIG5Dp043766
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 12:16:14 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 07/13] net: axienet: Add optional support for Ethernet core interrupt
Date:   Fri, 31 May 2019 12:15:39 -0600
Message-Id: <1559326545-28825-8-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously this driver only handled interrupts from the DMA RX and TX
blocks, not from the Ethernet core itself. Add optional support for
the Ethernet core interrupt, which is used to detect rx_missed and
framing errors signalled by the hardware. In order to use this
interrupt, a third interrupt needs to be specified in the device tree.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 .../devicetree/bindings/net/xilinx_axienet.txt     |  3 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  1 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 49 ++++++++++++++++++++++
 3 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 708722e..3f7b65e 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -18,7 +18,8 @@ Required properties:
 - compatible	: Must be one of "xlnx,axi-ethernet-1.00.a",
 		  "xlnx,axi-ethernet-1.01.a", "xlnx,axi-ethernet-2.01.a"
 - reg		: Address and length of the IO space.
-- interrupts	: Should be a list of two interrupt, TX and RX.
+- interrupts	: Should be a list of 2 or 3 interrupts: TX DMA, RX DMA,
+		  and optionally Ethernet core.
 - phy-handle	: Should point to the external phy device.
 		  See ethernet.txt file in the same directory.
 - xlnx,rxmem	: Set to allocated memory buffer for Rx/Tx in the hardware
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 4cd92fe..e14a6e7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -435,6 +435,7 @@ struct axienet_local {
 
 	int tx_irq;
 	int rx_irq;
+	int eth_irq;
 	phy_interface_t phy_mode;
 
 	u32 options;			/* Current options word */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 6e5613b..f2a8c5c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -509,6 +509,8 @@ static void axienet_device_reset(struct net_device *ndev)
 	axienet_status = axienet_ior(lp, XAE_IP_OFFSET);
 	if (axienet_status & XAE_INT_RXRJECT_MASK)
 		axienet_iow(lp, XAE_IS_OFFSET, XAE_INT_RXRJECT_MASK);
+	axienet_iow(lp, XAE_IE_OFFSET, lp->eth_irq > 0 ?
+		    XAE_INT_RECV_ERROR_MASK : 0);
 
 	axienet_iow(lp, XAE_FCC_OFFSET, XAE_FCC_FCRX_MASK);
 
@@ -909,6 +911,35 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 	return IRQ_HANDLED;
 }
 
+/**
+ * axienet_eth_irq - Ethernet core Isr.
+ * @irq:	irq number
+ * @_ndev:	net_device pointer
+ *
+ * Return: IRQ_HANDLED if device generated a core interrupt, IRQ_NONE otherwise.
+ *
+ * Handle miscellaneous conditions indicated by Ethernet core IRQ.
+ */
+static irqreturn_t axienet_eth_irq(int irq, void *_ndev)
+{
+	unsigned int pending;
+	struct net_device *ndev = _ndev;
+	struct axienet_local *lp = netdev_priv(ndev);
+
+	pending = axienet_ior(lp, XAE_IP_OFFSET);
+	if (!pending)
+		return IRQ_NONE;
+
+	if (pending & XAE_INT_RXFIFOOVR_MASK)
+		ndev->stats.rx_missed_errors++;
+
+	if (pending & XAE_INT_RXRJECT_MASK)
+		ndev->stats.rx_frame_errors++;
+
+	axienet_iow(lp, XAE_IS_OFFSET, pending);
+	return IRQ_HANDLED;
+}
+
 static void axienet_dma_err_handler(unsigned long data);
 
 /**
@@ -966,9 +997,18 @@ static int axienet_open(struct net_device *ndev)
 			  ndev->name, ndev);
 	if (ret)
 		goto err_rx_irq;
+	/* Enable interrupts for Axi Ethernet core (if defined) */
+	if (lp->eth_irq > 0) {
+		ret = request_irq(lp->eth_irq, axienet_eth_irq, IRQF_SHARED,
+				  ndev->name, ndev);
+		if (ret)
+			goto err_eth_irq;
+	}
 
 	return 0;
 
+err_eth_irq:
+	free_irq(lp->rx_irq, ndev);
 err_rx_irq:
 	free_irq(lp->tx_irq, ndev);
 err_tx_irq:
@@ -1028,6 +1068,8 @@ static int axienet_stop(struct net_device *ndev)
 
 	tasklet_kill(&lp->dma_err_tasklet);
 
+	if (lp->eth_irq > 0)
+		free_irq(lp->eth_irq, ndev);
 	free_irq(lp->tx_irq, ndev);
 	free_irq(lp->rx_irq, ndev);
 
@@ -1488,6 +1530,8 @@ static void axienet_dma_err_handler(unsigned long data)
 	axienet_status = axienet_ior(lp, XAE_IP_OFFSET);
 	if (axienet_status & XAE_INT_RXRJECT_MASK)
 		axienet_iow(lp, XAE_IS_OFFSET, XAE_INT_RXRJECT_MASK);
+	axienet_iow(lp, XAE_IE_OFFSET, lp->eth_irq > 0 ?
+		    XAE_INT_RECV_ERROR_MASK : 0);
 	axienet_iow(lp, XAE_FCC_OFFSET, XAE_FCC_FCRX_MASK);
 
 	/* Sync default options with HW but leave receiver and
@@ -1657,6 +1701,7 @@ static int axienet_probe(struct platform_device *pdev)
 	}
 	lp->rx_irq = irq_of_parse_and_map(np, 1);
 	lp->tx_irq = irq_of_parse_and_map(np, 0);
+	lp->eth_irq = irq_of_parse_and_map(np, 2);
 	of_node_put(np);
 	if ((lp->rx_irq <= 0) || (lp->tx_irq <= 0)) {
 		dev_err(&pdev->dev, "could not determine irqs\n");
@@ -1664,6 +1709,10 @@ static int axienet_probe(struct platform_device *pdev)
 		goto free_netdev;
 	}
 
+	/* Check for Ethernet core IRQ (optional) */
+	if (lp->eth_irq <= 0)
+		dev_info(&pdev->dev, "Ethernet core IRQ not defined\n");
+
 	/* Retrieve the MAC address */
 	mac_addr = of_get_mac_address(pdev->dev.of_node);
 	if (IS_ERR(mac_addr)) {
-- 
1.8.3.1

