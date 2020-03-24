Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0064190FF5
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbgCXNYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:24:18 -0400
Received: from foss.arm.com ([217.140.110.172]:34688 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728834AbgCXNYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E206F11B3;
        Tue, 24 Mar 2020 06:24:15 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93F153F52E;
        Tue, 24 Mar 2020 06:24:14 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 14/14] net: axienet: Allow DMA to beyond 4GB
Date:   Tue, 24 Mar 2020 13:23:47 +0000
Message-Id: <20200324132347.23709-15-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324132347.23709-1-andre.przywara@arm.com>
References: <20200324132347.23709-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With all DMA address accesses wrapped, we can actually support 64-bit
DMA if this option was chosen at IP integration time.
If the IP has been configured for an address width greater than 32 bits,
we assume the full 64 bit DMA width is working. In practise this will be
limited by the actual system address bus width, which will ideally be the
same as the DMA IP address width.
If this is not the case, the actual width can still be configured using a
dma-ranges property in the parent of the MAC node.

This increases the DMA mask on those systems to let the kernel choose
buffers from memory at higher addresses.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index a54a5c754da0..fa5dc2993520 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1780,6 +1780,7 @@ static int axienet_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	const void *mac_addr;
 	struct resource *ethres;
+	int addr_width = 32;
 	u32 value;
 
 	ndev = alloc_etherdev(sizeof(*lp));
@@ -1947,6 +1948,7 @@ static int axienet_probe(struct platform_device *pdev)
 			iowrite32(0xffffffff, desc);
 			if (ioread32(desc) > 0) {
 				lp->features |= XAE_FEATURE_DMA_64BIT;
+				addr_width = 64;
 				dev_info(&pdev->dev,
 					 "autodetected 64-bit DMA range\n");
 			}
@@ -1954,6 +1956,12 @@ static int axienet_probe(struct platform_device *pdev)
 		}
 	}
 
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

