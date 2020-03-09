Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA8E17E6A6
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbgCISTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:19:15 -0400
Received: from foss.arm.com ([217.140.110.172]:55710 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727499AbgCISTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 14:19:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30EBA1FB;
        Mon,  9 Mar 2020 11:19:12 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D6E6B3F67D;
        Mon,  9 Mar 2020 11:19:10 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 06/14] net: axienet: Factor out TX descriptor chain cleanup
Date:   Mon,  9 Mar 2020 18:18:43 +0000
Message-Id: <20200309181851.190164-7-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200309181851.190164-1-andre.przywara@arm.com>
References: <20200309181851.190164-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out the code that cleans up a number of connected TX descriptors,
as we will need it to properly roll back a failed _xmit() call.
There are subtle differences between cleaning up a successfully sent
chain (unknown number of involved descriptors, total data size needed)
and a chain that was about to set up (number of descriptors known), so
cater for those variations with some extra parameters.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 76 +++++++++++++------
 1 file changed, 54 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 77235f86d758..238b88f64da2 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -545,32 +545,43 @@ static int axienet_device_reset(struct net_device *ndev)
 }
 
 /**
- * axienet_start_xmit_done - Invoked once a transmit is completed by the
- * Axi DMA Tx channel.
+ * axienet_free_tx_chain - Clean up a series of linked TX descriptors.
  * @ndev:	Pointer to the net_device structure
+ * @first_bd:	Index of first descriptor to clean up
+ * @nr_bds:	Number of descriptors to clean up, can be -1 if unknown.
+ * @sizep:	Pointer to a u32 filled with the total sum of all bytes
+ * 		in all cleaned-up descriptors. Ignored if NULL.
  *
- * This function is invoked from the Axi DMA Tx isr to notify the completion
- * of transmit operation. It clears fields in the corresponding Tx BDs and
- * unmaps the corresponding buffer so that CPU can regain ownership of the
- * buffer. It finally invokes "netif_wake_queue" to restart transmission if
- * required.
+ * Would either be called after a successful transmit operation, or after
+ * there was an error when setting up the chain.
+ * Returns the number of descriptors handled.
  */
-static void axienet_start_xmit_done(struct net_device *ndev)
+static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
+				 int nr_bds, u32 *sizep)
 {
-	u32 size = 0;
-	u32 packets = 0;
 	struct axienet_local *lp = netdev_priv(ndev);
+	int max_bds = (nr_bds != -1) ? nr_bds : lp->tx_bd_num;
 	struct axidma_bd *cur_p;
-	unsigned int status = 0;
+	unsigned int status;
+	int i;
+
+	for (i = 0; i < max_bds; i++) {
+		cur_p = &lp->tx_bd_v[(first_bd + i) % lp->tx_bd_num];
+		status = cur_p->status;
+
+		/* If no number is given, clean up *all* descriptors that have
+		 * been completed by the MAC.
+		 */
+		if (nr_bds == -1 && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
+			break;
 
-	cur_p = &lp->tx_bd_v[lp->tx_bd_ci];
-	status = cur_p->status;
-	while (status & XAXIDMA_BD_STS_COMPLETE_MASK) {
 		dma_unmap_single(ndev->dev.parent, cur_p->phys,
 				(cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
 				DMA_TO_DEVICE);
-		if (cur_p->skb)
+
+		if (cur_p->skb && (status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			dev_consume_skb_irq(cur_p->skb);
+
 		cur_p->cntrl = 0;
 		cur_p->app0 = 0;
 		cur_p->app1 = 0;
@@ -579,15 +590,36 @@ static void axienet_start_xmit_done(struct net_device *ndev)
 		cur_p->status = 0;
 		cur_p->skb = NULL;
 
-		size += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
-		packets++;
-
-		if (++lp->tx_bd_ci >= lp->tx_bd_num)
-			lp->tx_bd_ci = 0;
-		cur_p = &lp->tx_bd_v[lp->tx_bd_ci];
-		status = cur_p->status;
+		if (sizep)
+			*sizep += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
 	}
 
+	return i;
+}
+
+/**
+ * axienet_start_xmit_done - Invoked once a transmit is completed by the
+ * Axi DMA Tx channel.
+ * @ndev:	Pointer to the net_device structure
+ *
+ * This function is invoked from the Axi DMA Tx isr to notify the completion
+ * of transmit operation. It clears fields in the corresponding Tx BDs and
+ * unmaps the corresponding buffer so that CPU can regain ownership of the
+ * buffer. It finally invokes "netif_wake_queue" to restart transmission if
+ * required.
+ */
+static void axienet_start_xmit_done(struct net_device *ndev)
+{
+	u32 size = 0;
+	u32 packets = 0;
+	struct axienet_local *lp = netdev_priv(ndev);
+
+	packets = axienet_free_tx_chain(ndev, lp->tx_bd_ci, -1, &size);
+
+	lp->tx_bd_ci += packets;
+	if (lp->tx_bd_ci >= lp->tx_bd_num)
+		lp->tx_bd_ci -= lp->tx_bd_num;
+
 	ndev->stats.tx_packets += packets;
 	ndev->stats.tx_bytes += size;
 
-- 
2.17.1

