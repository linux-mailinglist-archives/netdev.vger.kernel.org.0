Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA62314B3
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfEaSal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:30:41 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:25532 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfEaSa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:30:28 -0400
X-Greylist: delayed 854 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 14:30:19 EDT
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VIGFI0022158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 12:16:16 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VIG5Du043766
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 12:16:15 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 12/13] net: axienet: make use of axistream-connected attribute optional
Date:   Fri, 31 May 2019 12:15:44 -0600
Message-Id: <1559326545-28825-13-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the axienet driver requires the use of a second devicetree
node, referenced by an axistream-connected attribute on the Ethernet
device node, which contains the resources for the AXI DMA block used by the
device. This setup is problematic for a use case we have where the Ethernet
and DMA cores are behind a PCIe to AXI bridge and the memory resources for
the nodes are injected into the platform devices using the multifunction
device subsystem - it's not easily possible for the driver to obtain the
platform-level resources from the linked device.

In order to simplify that usage model, and simplify the overall use of
this driver in general, allow for all of the resources to be kept on one
node where the resources are retrieved using platform device APIs rather
than device-tree-specific ones. The previous usage setup is still
supported if the axistream-connected attribute is specified.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 43 +++++++++++++++--------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3112724..82caf04 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1577,7 +1577,7 @@ static int axienet_probe(struct platform_device *pdev)
 	struct axienet_local *lp;
 	struct net_device *ndev;
 	const void *mac_addr;
-	struct resource *ethres, dmares;
+	struct resource *ethres;
 	u32 value;
 
 	ndev = alloc_etherdev(sizeof(*lp));
@@ -1695,28 +1695,41 @@ static int axienet_probe(struct platform_device *pdev)
 
 	/* Find the DMA node, map the DMA registers, and decode the DMA IRQs */
 	np = of_parse_phandle(pdev->dev.of_node, "axistream-connected", 0);
-	if (!np) {
-		dev_err(&pdev->dev, "could not find DMA node\n");
-		ret = -ENODEV;
-		goto free_netdev;
-	}
-	ret = of_address_to_resource(np, 0, &dmares);
-	if (ret) {
-		dev_err(&pdev->dev, "unable to get DMA resource\n");
+	if (np) {
+		struct resource dmares;
+
+		ret = of_address_to_resource(np, 0, &dmares);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"unable to get DMA resource\n");
+			of_node_put(np);
+			goto free_netdev;
+		}
+		lp->dma_regs = devm_ioremap_resource(&pdev->dev,
+						     &dmares);
+		lp->rx_irq = irq_of_parse_and_map(np, 1);
+		lp->tx_irq = irq_of_parse_and_map(np, 0);
 		of_node_put(np);
-		goto free_netdev;
+		lp->eth_irq = platform_get_irq(pdev, 0);
+	} else {
+		/* Check for these resources directly on the Ethernet node. */
+		struct resource *res = platform_get_resource(pdev,
+							     IORESOURCE_MEM, 1);
+		if (!res) {
+			dev_err(&pdev->dev, "unable to get DMA memory resource\n");
+			goto free_netdev;
+		}
+		lp->dma_regs = devm_ioremap_resource(&pdev->dev, res);
+		lp->rx_irq = platform_get_irq(pdev, 1);
+		lp->tx_irq = platform_get_irq(pdev, 0);
+		lp->eth_irq = platform_get_irq(pdev, 2);
 	}
-	lp->dma_regs = devm_ioremap_resource(&pdev->dev, &dmares);
 	if (IS_ERR(lp->dma_regs)) {
 		dev_err(&pdev->dev, "could not map DMA regs\n");
 		ret = PTR_ERR(lp->dma_regs);
 		of_node_put(np);
 		goto free_netdev;
 	}
-	lp->rx_irq = irq_of_parse_and_map(np, 1);
-	lp->tx_irq = irq_of_parse_and_map(np, 0);
-	lp->eth_irq = irq_of_parse_and_map(np, 2);
-	of_node_put(np);
 	if ((lp->rx_irq <= 0) || (lp->tx_irq <= 0)) {
 		dev_err(&pdev->dev, "could not determine irqs\n");
 		ret = -ENOMEM;
-- 
1.8.3.1

