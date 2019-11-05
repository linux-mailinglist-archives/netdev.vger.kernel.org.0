Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4DDF02DD
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390471AbfKEQcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:32:52 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48207 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390423AbfKEQct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:49 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1l9-0002Hp-Gv; Tue, 05 Nov 2019 17:32:47 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 26/33] can: ti_hecc: properly report state changes
Date:   Tue,  5 Nov 2019 17:32:08 +0100
Message-Id: <20191105163215.30194-27-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191105163215.30194-1-mkl@pengutronix.de>
References: <20191105163215.30194-1-mkl@pengutronix.de>
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

From: Jeroen Hofstee <jhofstee@victronenergy.com>

The HECC_CANES register handles the flags specially, it only updates
the flags after a one is written to them. Since the interrupt for
frame errors is not enabled an old error can hence been seen when a
state interrupt arrives. For example if the device is not connected
to the CAN-bus the error warning interrupt will have HECC_CANES
indicating there is no ack. The error passive interrupt thereafter
will have HECC_CANES flagging that there is a warning level. And if
thereafter there is a message successfully send HECC_CANES points to
an error passive event, while in reality it became error warning
again. In summary, the state is not always reported correctly.

So handle the state changes and frame errors separately. The state
changes are now based on the interrupt flags and handled directly
when they occur. The reporting of the frame errors is still done as
before, as a side effect of another interrupt.

note: the hecc_clear_bit will do a read, modify, write. So it will
not only clear the bit, but also reset all other bits being set as
a side affect, hence it is replaced with only clearing the flags.

note: The HECC_CANMC_CCR is no longer cleared in the state change
interrupt, it is completely unrelated.

And use net_ratelimit to make checkpatch happy.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ti_hecc.c | 162 +++++++++++++++++++++-----------------
 1 file changed, 88 insertions(+), 74 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index b12fd0bd489d..4c6d3ce0e8c4 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -150,6 +150,8 @@ MODULE_VERSION(HECC_MODULE_VERSION);
 #define HECC_BUS_ERROR		(HECC_CANES_FE | HECC_CANES_BE |\
 				HECC_CANES_CRCE | HECC_CANES_SE |\
 				HECC_CANES_ACKE)
+#define HECC_CANES_FLAGS	(HECC_BUS_ERROR | HECC_CANES_BO |\
+				HECC_CANES_EP | HECC_CANES_EW)
 
 #define HECC_CANMCF_RTR		BIT(4)	/* Remote transmit request */
 
@@ -592,91 +594,69 @@ static int ti_hecc_error(struct net_device *ndev, int int_status,
 	u32 timestamp;
 	int err;
 
-	/* propagate the error condition to the can stack */
-	skb = alloc_can_err_skb(ndev, &cf);
-	if (!skb) {
-		if (printk_ratelimit())
-			netdev_err(priv->ndev,
-				   "%s: alloc_can_err_skb() failed\n",
-				   __func__);
-		return -ENOMEM;
-	}
-
-	if (int_status & HECC_CANGIF_WLIF) { /* warning level int */
-		if ((int_status & HECC_CANGIF_BOIF) == 0) {
-			priv->can.state = CAN_STATE_ERROR_WARNING;
-			++priv->can.can_stats.error_warning;
-			cf->can_id |= CAN_ERR_CRTL;
-			if (hecc_read(priv, HECC_CANTEC) > 96)
-				cf->data[1] |= CAN_ERR_CRTL_TX_WARNING;
-			if (hecc_read(priv, HECC_CANREC) > 96)
-				cf->data[1] |= CAN_ERR_CRTL_RX_WARNING;
-		}
-		hecc_set_bit(priv, HECC_CANES, HECC_CANES_EW);
-		netdev_dbg(priv->ndev, "Error Warning interrupt\n");
-		hecc_clear_bit(priv, HECC_CANMC, HECC_CANMC_CCR);
-	}
-
-	if (int_status & HECC_CANGIF_EPIF) { /* error passive int */
-		if ((int_status & HECC_CANGIF_BOIF) == 0) {
-			priv->can.state = CAN_STATE_ERROR_PASSIVE;
-			++priv->can.can_stats.error_passive;
-			cf->can_id |= CAN_ERR_CRTL;
-			if (hecc_read(priv, HECC_CANTEC) > 127)
-				cf->data[1] |= CAN_ERR_CRTL_TX_PASSIVE;
-			if (hecc_read(priv, HECC_CANREC) > 127)
-				cf->data[1] |= CAN_ERR_CRTL_RX_PASSIVE;
+	if (err_status & HECC_BUS_ERROR) {
+		/* propagate the error condition to the can stack */
+		skb = alloc_can_err_skb(ndev, &cf);
+		if (!skb) {
+			if (net_ratelimit())
+				netdev_err(priv->ndev,
+					   "%s: alloc_can_err_skb() failed\n",
+					   __func__);
+			return -ENOMEM;
 		}
-		hecc_set_bit(priv, HECC_CANES, HECC_CANES_EP);
-		netdev_dbg(priv->ndev, "Error passive interrupt\n");
-		hecc_clear_bit(priv, HECC_CANMC, HECC_CANMC_CCR);
-	}
-
-	/* Need to check busoff condition in error status register too to
-	 * ensure warning interrupts don't hog the system
-	 */
-	if ((int_status & HECC_CANGIF_BOIF) || (err_status & HECC_CANES_BO)) {
-		priv->can.state = CAN_STATE_BUS_OFF;
-		cf->can_id |= CAN_ERR_BUSOFF;
-		hecc_set_bit(priv, HECC_CANES, HECC_CANES_BO);
-		hecc_clear_bit(priv, HECC_CANMC, HECC_CANMC_CCR);
-		/* Disable all interrupts in bus-off to avoid int hog */
-		hecc_write(priv, HECC_CANGIM, 0);
-		++priv->can.can_stats.bus_off;
-		can_bus_off(ndev);
-	}
 
-	if (err_status & HECC_BUS_ERROR) {
 		++priv->can.can_stats.bus_error;
 		cf->can_id |= CAN_ERR_BUSERROR | CAN_ERR_PROT;
-		if (err_status & HECC_CANES_FE) {
-			hecc_set_bit(priv, HECC_CANES, HECC_CANES_FE);
+		if (err_status & HECC_CANES_FE)
 			cf->data[2] |= CAN_ERR_PROT_FORM;
-		}
-		if (err_status & HECC_CANES_BE) {
-			hecc_set_bit(priv, HECC_CANES, HECC_CANES_BE);
+		if (err_status & HECC_CANES_BE)
 			cf->data[2] |= CAN_ERR_PROT_BIT;
-		}
-		if (err_status & HECC_CANES_SE) {
-			hecc_set_bit(priv, HECC_CANES, HECC_CANES_SE);
+		if (err_status & HECC_CANES_SE)
 			cf->data[2] |= CAN_ERR_PROT_STUFF;
-		}
-		if (err_status & HECC_CANES_CRCE) {
-			hecc_set_bit(priv, HECC_CANES, HECC_CANES_CRCE);
+		if (err_status & HECC_CANES_CRCE)
 			cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
-		}
-		if (err_status & HECC_CANES_ACKE) {
-			hecc_set_bit(priv, HECC_CANES, HECC_CANES_ACKE);
+		if (err_status & HECC_CANES_ACKE)
 			cf->data[3] = CAN_ERR_PROT_LOC_ACK;
-		}
+
+		timestamp = hecc_read(priv, HECC_CANLNT);
+		err = can_rx_offload_queue_sorted(&priv->offload, skb,
+						  timestamp);
+		if (err)
+			ndev->stats.rx_fifo_errors++;
+	}
+
+	hecc_write(priv, HECC_CANES, HECC_CANES_FLAGS);
+
+	return 0;
+}
+
+static void ti_hecc_change_state(struct net_device *ndev,
+				 enum can_state rx_state,
+				 enum can_state tx_state)
+{
+	struct ti_hecc_priv *priv = netdev_priv(ndev);
+	struct can_frame *cf;
+	struct sk_buff *skb;
+	u32 timestamp;
+	int err;
+
+	skb = alloc_can_err_skb(priv->ndev, &cf);
+	if (unlikely(!skb)) {
+		priv->can.state = max(tx_state, rx_state);
+		return;
+	}
+
+	can_change_state(priv->ndev, cf, tx_state, rx_state);
+
+	if (max(tx_state, rx_state) != CAN_STATE_BUS_OFF) {
+		cf->data[6] = hecc_read(priv, HECC_CANTEC);
+		cf->data[7] = hecc_read(priv, HECC_CANREC);
 	}
 
 	timestamp = hecc_read(priv, HECC_CANLNT);
 	err = can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
 	if (err)
 		ndev->stats.rx_fifo_errors++;
-
-	return 0;
 }
 
 static irqreturn_t ti_hecc_interrupt(int irq, void *dev_id)
@@ -686,6 +666,7 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *dev_id)
 	struct net_device_stats *stats = &ndev->stats;
 	u32 mbxno, mbx_mask, int_status, err_status, stamp;
 	unsigned long flags, rx_pending;
+	u32 handled = 0;
 
 	int_status = hecc_read(priv,
 			       priv->use_hecc1int ?
@@ -695,10 +676,43 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	err_status = hecc_read(priv, HECC_CANES);
-	if (err_status & (HECC_BUS_ERROR | HECC_CANES_BO |
-			  HECC_CANES_EP | HECC_CANES_EW))
+	if (unlikely(err_status & HECC_CANES_FLAGS))
 		ti_hecc_error(ndev, int_status, err_status);
 
+	if (unlikely(int_status & HECC_CANGIM_DEF_MASK)) {
+		enum can_state rx_state, tx_state;
+		u32 rec = hecc_read(priv, HECC_CANREC);
+		u32 tec = hecc_read(priv, HECC_CANTEC);
+
+		if (int_status & HECC_CANGIF_WLIF) {
+			handled |= HECC_CANGIF_WLIF;
+			rx_state = rec >= tec ? CAN_STATE_ERROR_WARNING : 0;
+			tx_state = rec <= tec ? CAN_STATE_ERROR_WARNING : 0;
+			netdev_dbg(priv->ndev, "Error Warning interrupt\n");
+			ti_hecc_change_state(ndev, rx_state, tx_state);
+		}
+
+		if (int_status & HECC_CANGIF_EPIF) {
+			handled |= HECC_CANGIF_EPIF;
+			rx_state = rec >= tec ? CAN_STATE_ERROR_PASSIVE : 0;
+			tx_state = rec <= tec ? CAN_STATE_ERROR_PASSIVE : 0;
+			netdev_dbg(priv->ndev, "Error passive interrupt\n");
+			ti_hecc_change_state(ndev, rx_state, tx_state);
+		}
+
+		if (int_status & HECC_CANGIF_BOIF) {
+			handled |= HECC_CANGIF_BOIF;
+			rx_state = CAN_STATE_BUS_OFF;
+			tx_state = CAN_STATE_BUS_OFF;
+			netdev_dbg(priv->ndev, "Bus off interrupt\n");
+
+			/* Disable all interrupts */
+			hecc_write(priv, HECC_CANGIM, 0);
+			can_bus_off(ndev);
+			ti_hecc_change_state(ndev, rx_state, tx_state);
+		}
+	}
+
 	if (int_status & HECC_CANGIF_GMIF) {
 		while (priv->tx_tail - priv->tx_head > 0) {
 			mbxno = get_tx_tail_mb(priv);
@@ -734,10 +748,10 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *dev_id)
 
 	/* clear all interrupt conditions - read back to avoid spurious ints */
 	if (priv->use_hecc1int) {
-		hecc_write(priv, HECC_CANGIF1, HECC_SET_REG);
+		hecc_write(priv, HECC_CANGIF1, handled);
 		int_status = hecc_read(priv, HECC_CANGIF1);
 	} else {
-		hecc_write(priv, HECC_CANGIF0, HECC_SET_REG);
+		hecc_write(priv, HECC_CANGIF0, handled);
 		int_status = hecc_read(priv, HECC_CANGIF0);
 	}
 
-- 
2.24.0.rc1

