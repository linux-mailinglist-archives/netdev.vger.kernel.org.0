Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63BE10FBF3
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfLCKrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:47:11 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33995 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfLCKrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:47:10 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ic5i0-0001BG-PD; Tue, 03 Dec 2019 11:47:08 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6/6] can: xilinx_can: Fix usage of skb memory
Date:   Tue,  3 Dec 2019 11:47:03 +0100
Message-Id: <20191203104703.14620-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203104703.14620-1-mkl@pengutronix.de>
References: <20191203104703.14620-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srinivas Neeli <srinivas.neeli@xilinx.com>

As per linux can framework, driver not allowed to touch the skb memory
after can_put_echo_skb() call.
This patch fixes the same.
https://www.spinics.net/lists/linux-can/msg02199.html

Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Reviewed-by: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/xilinx_can.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index c5f05b994435..464af939cd8a 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -542,16 +542,17 @@ static int xcan_do_set_mode(struct net_device *ndev, enum can_mode mode)
 
 /**
  * xcan_write_frame - Write a frame to HW
- * @priv:		Driver private data structure
+ * @ndev:		Pointer to net_device structure
  * @skb:		sk_buff pointer that contains data to be Txed
  * @frame_offset:	Register offset to write the frame to
  */
-static void xcan_write_frame(struct xcan_priv *priv, struct sk_buff *skb,
+static void xcan_write_frame(struct net_device *ndev, struct sk_buff *skb,
 			     int frame_offset)
 {
 	u32 id, dlc, data[2] = {0, 0};
 	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
 	u32 ramoff, dwindex = 0, i;
+	struct xcan_priv *priv = netdev_priv(ndev);
 
 	/* Watch carefully on the bit sequence */
 	if (cf->can_id & CAN_EFF_FLAG) {
@@ -587,6 +588,14 @@ static void xcan_write_frame(struct xcan_priv *priv, struct sk_buff *skb,
 		dlc |= XCAN_DLCR_EDL_MASK;
 	}
 
+	if (!(priv->devtype.flags & XCAN_FLAG_TX_MAILBOXES) &&
+	    (priv->devtype.flags & XCAN_FLAG_TXFEMP))
+		can_put_echo_skb(skb, ndev, priv->tx_head % priv->tx_max);
+	else
+		can_put_echo_skb(skb, ndev, 0);
+
+	priv->tx_head++;
+
 	priv->write_reg(priv, XCAN_FRAME_ID_OFFSET(frame_offset), id);
 	/* If the CAN frame is RTR frame this write triggers transmission
 	 * (not on CAN FD)
@@ -638,13 +647,9 @@ static int xcan_start_xmit_fifo(struct sk_buff *skb, struct net_device *ndev)
 			XCAN_SR_TXFLL_MASK))
 		return -ENOSPC;
 
-	can_put_echo_skb(skb, ndev, priv->tx_head % priv->tx_max);
-
 	spin_lock_irqsave(&priv->tx_lock, flags);
 
-	priv->tx_head++;
-
-	xcan_write_frame(priv, skb, XCAN_TXFIFO_OFFSET);
+	xcan_write_frame(ndev, skb, XCAN_TXFIFO_OFFSET);
 
 	/* Clear TX-FIFO-empty interrupt for xcan_tx_interrupt() */
 	if (priv->tx_max > 1)
@@ -675,13 +680,9 @@ static int xcan_start_xmit_mailbox(struct sk_buff *skb, struct net_device *ndev)
 		     BIT(XCAN_TX_MAILBOX_IDX)))
 		return -ENOSPC;
 
-	can_put_echo_skb(skb, ndev, 0);
-
 	spin_lock_irqsave(&priv->tx_lock, flags);
 
-	priv->tx_head++;
-
-	xcan_write_frame(priv, skb,
+	xcan_write_frame(ndev, skb,
 			 XCAN_TXMSG_FRAME_OFFSET(XCAN_TX_MAILBOX_IDX));
 
 	/* Mark buffer as ready for transmit */
-- 
2.24.0

