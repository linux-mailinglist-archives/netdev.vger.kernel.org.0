Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30111FAC8D
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 10:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfKMJFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 04:05:09 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:34219 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfKMJFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 04:05:07 -0500
X-Originating-IP: 86.206.246.123
Received: from localhost (lfbn-tou-1-421-123.w86-206.abo.wanadoo.fr [86.206.246.123])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 77316C0003;
        Wed, 13 Nov 2019 09:05:04 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, linux@armlinux.org.uk
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, andrew@lunn.ch,
        alexandre.belloni@bootlin.com, nicolas.ferre@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        mparab@cadence.com, piotrs@cadence.com, dkangude@cadence.com,
        ewanm@cadence.com, arthurm@cadence.com, stevenh@cadence.com
Subject: [PATCH net-next v3 1/2] net: macb: move the Tx and Rx buffer initialization into a function
Date:   Wed, 13 Nov 2019 10:00:05 +0100
Message-Id: <20191113090006.58898-2-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191113090006.58898-1-antoine.tenart@bootlin.com>
References: <20191113090006.58898-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the Tx and Rx buffer initialization into its own
function. This does not modify the behaviour of the driver and will be
helpful to convert the driver to phylink.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 39 +++++++++++++++---------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index b884cf7f339b..1b3c8d678116 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -388,6 +388,27 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	return status;
 }
 
+static void macb_init_buffers(struct macb *bp)
+{
+	struct macb_queue *queue;
+	unsigned int q;
+
+	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
+		queue_writel(queue, RBQP, lower_32_bits(queue->rx_ring_dma));
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
+			queue_writel(queue, RBQPH,
+				     upper_32_bits(queue->rx_ring_dma));
+#endif
+		queue_writel(queue, TBQP, lower_32_bits(queue->tx_ring_dma));
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
+			queue_writel(queue, TBQPH,
+				     upper_32_bits(queue->tx_ring_dma));
+#endif
+	}
+}
+
 /**
  * macb_set_tx_clk() - Set a clock to a new frequency
  * @clk		Pointer to the clock to change
@@ -1314,26 +1335,14 @@ static void macb_hresp_error_task(unsigned long data)
 	bp->macbgem_ops.mog_init_rings(bp);
 
 	/* Initialize TX and RX buffers */
-	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
-		queue_writel(queue, RBQP, lower_32_bits(queue->rx_ring_dma));
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
-			queue_writel(queue, RBQPH,
-				     upper_32_bits(queue->rx_ring_dma));
-#endif
-		queue_writel(queue, TBQP, lower_32_bits(queue->tx_ring_dma));
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
-			queue_writel(queue, TBQPH,
-				     upper_32_bits(queue->tx_ring_dma));
-#endif
+	macb_init_buffers(bp);
 
-		/* Enable interrupts */
+	/* Enable interrupts */
+	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
 		queue_writel(queue, IER,
 			     bp->rx_intr_mask |
 			     MACB_TX_INT_FLAGS |
 			     MACB_BIT(HRESP));
-	}
 
 	ctrl |= MACB_BIT(RE) | MACB_BIT(TE);
 	macb_writel(bp, NCR, ctrl);
-- 
2.23.0

