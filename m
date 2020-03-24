Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E02190FEA
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgCXNYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:24:08 -0400
Received: from foss.arm.com ([217.140.110.172]:34596 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729554AbgCXNYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 984241045;
        Tue, 24 Mar 2020 06:24:06 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 490AD3F52E;
        Tue, 24 Mar 2020 06:24:05 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 08/14] net: axienet: Mark eth_irq as optional
Date:   Tue, 24 Mar 2020 13:23:41 +0000
Message-Id: <20200324132347.23709-9-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324132347.23709-1-andre.przywara@arm.com>
References: <20200324132347.23709-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the DT binding, the Ethernet core interrupt is optional.

Use platform_get_irq_optional() to avoid the error message when the
IRQ is not specified.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 736ac1b7a052..60c8cde365f8 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1851,7 +1851,7 @@ static int axienet_probe(struct platform_device *pdev)
 		lp->rx_irq = irq_of_parse_and_map(np, 1);
 		lp->tx_irq = irq_of_parse_and_map(np, 0);
 		of_node_put(np);
-		lp->eth_irq = platform_get_irq(pdev, 0);
+		lp->eth_irq = platform_get_irq_optional(pdev, 0);
 	} else {
 		/* Check for these resources directly on the Ethernet node. */
 		struct resource *res = platform_get_resource(pdev,
@@ -1859,7 +1859,7 @@ static int axienet_probe(struct platform_device *pdev)
 		lp->dma_regs = devm_ioremap_resource(&pdev->dev, res);
 		lp->rx_irq = platform_get_irq(pdev, 1);
 		lp->tx_irq = platform_get_irq(pdev, 0);
-		lp->eth_irq = platform_get_irq(pdev, 2);
+		lp->eth_irq = platform_get_irq_optional(pdev, 2);
 	}
 	if (IS_ERR(lp->dma_regs)) {
 		dev_err(&pdev->dev, "could not map DMA regs\n");
-- 
2.17.1

