Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE9D19107A
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgCXN2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:28:47 -0400
Received: from foss.arm.com ([217.140.110.172]:34642 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729593AbgCXNYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:11 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3611E1045;
        Tue, 24 Mar 2020 06:24:11 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC1FF3F52E;
        Tue, 24 Mar 2020 06:24:09 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 11/14] net: axienet: Wrap DMA pointer writes to prepare for 64 bit
Date:   Tue, 24 Mar 2020 13:23:44 +0000
Message-Id: <20200324132347.23709-12-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324132347.23709-1-andre.przywara@arm.com>
References: <20200324132347.23709-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer versions of the Xilink DMA IP support busses with more than 32
address bits, by introducing an MSB word for the registers holding DMA
pointers (tail/current, RX/TX descriptor addresses).
On IP configured for more than 32 bits, it is also *required* to write
both words, to let the IP recognise this as a start condition for an
MM2S request, for instance.

Wrap the DMA pointer writes with a separate function, to add this
functionality later. For now we stick to the lower 32 bits.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 26 ++++++++++++-------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index dc533d7a090c..e7469eb241ad 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -147,6 +147,12 @@ static inline void axienet_dma_out32(struct axienet_local *lp,
 	iowrite32(value, lp->dma_regs + reg);
 }
 
+static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
+				 dma_addr_t addr)
+{
+	axienet_dma_out32(lp, reg, lower_32_bits(addr));
+}
+
 /**
  * axienet_dma_bd_release - Release buffer descriptor rings
  * @ndev:	Pointer to the net_device structure
@@ -285,18 +291,18 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
 	 * halted state. This will make the Rx side ready for reception.
 	 */
-	axienet_dma_out32(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
+	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
 	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
-	axienet_dma_out32(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			  (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
+	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
+			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
 
 	/* Write to the RS (Run-stop) bit in the Tx channel control register.
 	 * Tx channel is now ready to run. But only after we write to the
 	 * tail pointer register that the Tx channel will start transmitting.
 	 */
-	axienet_dma_out32(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
+	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
 	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
@@ -757,7 +763,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	/* Start the transfer */
-	axienet_dma_out32(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
+	axienet_dma_out_addr(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
 	if (++lp->tx_bd_tail >= lp->tx_bd_num)
 		lp->tx_bd_tail = 0;
 
@@ -849,7 +855,7 @@ static void axienet_recv(struct net_device *ndev)
 	ndev->stats.rx_bytes += size;
 
 	if (tail_p)
-		axienet_dma_out32(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
+		axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
 }
 
 /**
@@ -1671,18 +1677,18 @@ static void axienet_dma_err_handler(struct work_struct *work)
 	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
 	 * halted state. This will make the Rx side ready for reception.
 	 */
-	axienet_dma_out32(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
+	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
 	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
-	axienet_dma_out32(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			  (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
+	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
+			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
 
 	/* Write to the RS (Run-stop) bit in the Tx channel control register.
 	 * Tx channel is now ready to run. But only after we write to the
 	 * tail pointer register that the Tx channel will start transmitting
 	 */
-	axienet_dma_out32(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
+	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
 	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
-- 
2.17.1

