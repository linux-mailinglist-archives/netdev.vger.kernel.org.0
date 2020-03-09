Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B97EB17E6B5
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbgCIST0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:19:26 -0400
Received: from foss.arm.com ([217.140.110.172]:55836 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727578AbgCISTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 14:19:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D04B106F;
        Mon,  9 Mar 2020 11:19:24 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E98F3F67D;
        Mon,  9 Mar 2020 11:19:23 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 14/14] net: axienet: Allow DMA to beyond 4GB
Date:   Mon,  9 Mar 2020 18:18:51 +0000
Message-Id: <20200309181851.190164-15-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200309181851.190164-1-andre.przywara@arm.com>
References: <20200309181851.190164-1-andre.przywara@arm.com>
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
index 8c0887b1c009..c6fa7158b6bd 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1797,6 +1797,7 @@ static int axienet_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	const void *mac_addr;
 	struct resource *ethres;
+	int addr_width = 32;
 	u32 value;
 
 	ndev = alloc_etherdev(sizeof(*lp));
@@ -1964,6 +1965,7 @@ static int axienet_probe(struct platform_device *pdev)
 			iowrite32(0xffffffff, desc);
 			if (ioread32(desc) > 0) {
 				lp->features |= XAE_FEATURE_DMA_64BIT;
+				addr_width = 64;
 				dev_info(&pdev->dev,
 					 "autodetected 64-bit DMA range\n");
 			}
@@ -1971,6 +1973,12 @@ static int axienet_probe(struct platform_device *pdev)
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

