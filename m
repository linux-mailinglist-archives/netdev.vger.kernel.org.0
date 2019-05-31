Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A85314AC
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfEaSa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:30:29 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:25532 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbfEaSa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:30:28 -0400
X-Greylist: delayed 854 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 14:30:19 EDT
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VIGKx0017272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 12:16:20 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VIG5Dl043766
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 12:16:12 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 03/13] net: axienet: Cleanup DMA device reset and halt process
Date:   Fri, 31 May 2019 12:15:35 -0600
Message-Id: <1559326545-28825-4-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Xilinx DMA blocks each have their own reset register, but they both
reset the entire DMA engine, so only one of them needs to be reset.

Also, when stopping the device, we need to not just command the DMA
blocks to stop, but wait for them to stop, and trigger a device reset
to ensure that they are completely stopped.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  2 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 50 ++++++++++++++++-------
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index dfe0e4c..4d39164 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -83,6 +83,8 @@
 #define XAXIDMA_CR_RUNSTOP_MASK	0x00000001 /* Start/stop DMA channel */
 #define XAXIDMA_CR_RESET_MASK	0x00000004 /* Reset DMA engine */
 
+#define XAXIDMA_SR_HALT_MASK	0x00000001 /* Indicates DMA channel halted */
+
 #define XAXIDMA_BD_NDESC_OFFSET		0x00 /* Next descriptor pointer */
 #define XAXIDMA_BD_BUFA_OFFSET		0x08 /* Buffer address */
 #define XAXIDMA_BD_CTRL_LEN_OFFSET	0x18 /* Control/buffer length */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 2e69755..3b683ea 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -441,17 +441,20 @@ static void axienet_setoptions(struct net_device *ndev, u32 options)
 	lp->options |= options;
 }
 
-static void __axienet_device_reset(struct axienet_local *lp, off_t offset)
+static void __axienet_device_reset(struct axienet_local *lp)
 {
 	u32 timeout;
 	/* Reset Axi DMA. This would reset Axi Ethernet core as well. The reset
 	 * process of Axi DMA takes a while to complete as all pending
 	 * commands/transfers will be flushed or completed during this
 	 * reset process.
+	 * Note that even though both TX and RX have their own reset register,
+	 * they both reset the entire DMA core, so only one needs to be used.
 	 */
-	axienet_dma_out32(lp, offset, XAXIDMA_CR_RESET_MASK);
+	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, XAXIDMA_CR_RESET_MASK);
 	timeout = DELAY_OF_ONE_MILLISEC;
-	while (axienet_dma_in32(lp, offset) & XAXIDMA_CR_RESET_MASK) {
+	while (axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET) &
+				XAXIDMA_CR_RESET_MASK) {
 		udelay(1);
 		if (--timeout == 0) {
 			netdev_err(lp->ndev, "%s: DMA reset timeout!\n",
@@ -477,8 +480,7 @@ static void axienet_device_reset(struct net_device *ndev)
 	u32 axienet_status;
 	struct axienet_local *lp = netdev_priv(ndev);
 
-	__axienet_device_reset(lp, XAXIDMA_TX_CR_OFFSET);
-	__axienet_device_reset(lp, XAXIDMA_RX_CR_OFFSET);
+	__axienet_device_reset(lp);
 
 	lp->max_frm_size = XAE_MAX_VLAN_FRAME_SIZE;
 	lp->options |= XAE_OPTION_VLAN;
@@ -985,20 +987,41 @@ static int axienet_open(struct net_device *ndev)
  */
 static int axienet_stop(struct net_device *ndev)
 {
-	u32 cr;
+	u32 cr, sr;
+	int count;
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
 
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
-			  cr & (~XAXIDMA_CR_RUNSTOP_MASK));
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
-			  cr & (~XAXIDMA_CR_RUNSTOP_MASK));
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 
+	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
+	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
+	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
+
+	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
+	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
+	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
+
+	axienet_iow(lp, XAE_IE_OFFSET, 0);
+
+	/* Give DMAs a chance to halt gracefully */
+	sr = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
+	for (count = 0; !(sr & XAXIDMA_SR_HALT_MASK) && count < 5; ++count) {
+		msleep(20);
+		sr = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
+	}
+
+	sr = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
+	for (count = 0; !(sr & XAXIDMA_SR_HALT_MASK) && count < 5; ++count) {
+		msleep(20);
+		sr = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
+	}
+
+	/* Do a reset to ensure DMA is really stopped */
+	__axienet_device_reset(lp);
+
 	tasklet_kill(&lp->dma_err_tasklet);
 
 	free_irq(lp->tx_irq, ndev);
@@ -1328,8 +1351,7 @@ static void axienet_dma_err_handler(unsigned long data)
 	 * process is started, MDIO will be broken afterwards.
 	 */
 	axienet_mdio_disable(lp);
-	__axienet_device_reset(lp, XAXIDMA_TX_CR_OFFSET);
-	__axienet_device_reset(lp, XAXIDMA_RX_CR_OFFSET);
+	__axienet_device_reset(lp);
 	axienet_mdio_enable(lp);
 
 	for (i = 0; i < TX_BD_NUM; i++) {
-- 
1.8.3.1

