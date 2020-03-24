Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13687191085
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgCXNYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:24:01 -0400
Received: from foss.arm.com ([217.140.110.172]:34526 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728035AbgCXNYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 713EE113E;
        Tue, 24 Mar 2020 06:24:00 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2274A3F52E;
        Tue, 24 Mar 2020 06:23:59 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 04/14] net: axienet: Fix DMA descriptor cleanup path
Date:   Tue, 24 Mar 2020 13:23:37 +0000
Message-Id: <20200324132347.23709-5-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324132347.23709-1-andre.przywara@arm.com>
References: <20200324132347.23709-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When axienet_dma_bd_init() bails out during the initialisation process,
it might do so with parts of the structure already allocated and
initialised, while other parts have not been touched yet. Before
returning in this case, we call axienet_dma_bd_release(), which does not
take care of this corner case.
This is most obvious by the first loop happily dereferencing
lp->rx_bd_v, which we actually check to be non NULL *afterwards*.

Make sure we only unmap or free already allocated structures, by:
- directly returning with -ENOMEM if nothing has been allocated at all
- checking for lp->rx_bd_v to be non-NULL *before* using it
- only unmapping allocated DMA RX regions

This avoids NULL pointer dereferences when initialisation fails.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 43 ++++++++++++-------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index a25423e6fb36..415179cbdc51 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -160,24 +160,37 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 	int i;
 	struct axienet_local *lp = netdev_priv(ndev);
 
+	/* If we end up here, tx_bd_v must have been DMA allocated. */
+	dma_free_coherent(ndev->dev.parent,
+			  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
+			  lp->tx_bd_v,
+			  lp->tx_bd_p);
+
+	if (!lp->rx_bd_v)
+		return;
+
 	for (i = 0; i < lp->rx_bd_num; i++) {
-		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
-				 lp->max_frm_size, DMA_FROM_DEVICE);
+		/* A NULL skb means this descriptor has not been initialised
+		 * at all.
+		 */
+		if (!lp->rx_bd_v[i].skb)
+			break;
+
 		dev_kfree_skb(lp->rx_bd_v[i].skb);
-	}
 
-	if (lp->rx_bd_v) {
-		dma_free_coherent(ndev->dev.parent,
-				  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
-				  lp->rx_bd_v,
-				  lp->rx_bd_p);
-	}
-	if (lp->tx_bd_v) {
-		dma_free_coherent(ndev->dev.parent,
-				  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
-				  lp->tx_bd_v,
-				  lp->tx_bd_p);
+		/* For each descriptor, we programmed cntrl with the (non-zero)
+		 * descriptor size, after it had been successfully allocated.
+		 * So a non-zero value in there means we need to unmap it.
+		 */
+		if (lp->rx_bd_v[i].cntrl)
+			dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
+					 lp->max_frm_size, DMA_FROM_DEVICE);
 	}
+
+	dma_free_coherent(ndev->dev.parent,
+			  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
+			  lp->rx_bd_v,
+			  lp->rx_bd_p);
 }
 
 /**
@@ -207,7 +220,7 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 					 sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 					 &lp->tx_bd_p, GFP_KERNEL);
 	if (!lp->tx_bd_v)
-		goto out;
+		return -ENOMEM;
 
 	lp->rx_bd_v = dma_alloc_coherent(ndev->dev.parent,
 					 sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
-- 
2.17.1

