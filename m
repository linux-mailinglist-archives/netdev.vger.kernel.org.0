Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9444136C6D
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgAJLyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:54:54 -0500
Received: from foss.arm.com ([217.140.110.172]:43218 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbgAJLyl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 06:54:41 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14F7813A1;
        Fri, 10 Jan 2020 03:54:41 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FCA23F73B;
        Fri, 10 Jan 2020 03:54:39 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: [PATCH 13/14] net: axienet: Allow DMA to beyond 4GB
Date:   Fri, 10 Jan 2020 11:54:14 +0000
Message-Id: <20200110115415.75683-14-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200110115415.75683-1-andre.przywara@arm.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With all DMA address accesses wrapped, we can actually support 64-bit
DMA if this option was chosen at IP integration time.
Since there is no way to autodetect the actual address bus width, we
make use of the existing "xlnx,addrwidth" DT property to let the driver
know about the width. The value in this property should match the
"Address Width" parameter used when synthesizing the IP.

This increases the DMA mask to let the kernel choose buffers from
memory at higher addresses.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index f7f593df0c11..e036834549b3 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1786,6 +1786,7 @@ static int axienet_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	const void *mac_addr;
 	struct resource *ethres;
+	int addr_width = 32;
 	u32 value;
 
 	ndev = alloc_etherdev(sizeof(*lp));
@@ -1915,6 +1916,8 @@ static int axienet_probe(struct platform_device *pdev)
 						     &dmares);
 		lp->rx_irq = irq_of_parse_and_map(np, 1);
 		lp->tx_irq = irq_of_parse_and_map(np, 0);
+		of_property_read_u32(np, "xlnx,addrwidth", &addr_width);
+
 		of_node_put(np);
 		lp->eth_irq = platform_get_irq(pdev, 0);
 	} else {
@@ -1944,6 +1947,9 @@ static int axienet_probe(struct platform_device *pdev)
 	 * We can detect this case by writing all 1's to one such register
 	 * and see if that sticks: when the IP is configured for 32 bits
 	 * only, those registers are RES0.
+	 * We can't autodetect the actual width this way, so we still use
+	 * a 32-bit DMA mask and rely on the xlnk,addrwidth DT property
+	 * to set this properly.
 	 * Those MSB registers were introduced in IP v7.1, which we check first.
 	 */
 	if ((axienet_ior(lp, XAE_ID_OFFSET) >> 24) >= 0x9) {
@@ -1961,6 +1967,19 @@ static int axienet_probe(struct platform_device *pdev)
 		}
 	}
 
+	if (!(lp->features & XAE_FEATURE_DMA_64BIT)) {
+		if (addr_width > 32)
+			dev_warn(&pdev->dev, "trimming DMA width from %d to 32 bits\n",
+				 addr_width);
+		addr_width = 32;
+	}
+
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(addr_width));
+	if (ret) {
+		dev_err(&pdev->dev, "No suitable DMA available\n");
+		goto free_netdev;
+	}
+
 	/* Check for Ethernet core IRQ (optional) */
 	if (lp->eth_irq <= 0)
 		dev_info(&pdev->dev, "Ethernet core IRQ not defined\n");
-- 
2.17.1

