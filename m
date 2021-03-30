Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E385134E68C
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhC3Lqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbhC3LqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76659C061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:14 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCp3-0005i5-1p
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:13 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 95725603E04
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:08 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BEF9D603DC9;
        Tue, 30 Mar 2021 11:46:01 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2352a578;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 05/39] can: dev: can_free_echo_skb(): extend to return can frame length
Date:   Tue, 30 Mar 2021 13:45:25 +0200
Message-Id: <20210330114559.1114855-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to implement byte queue limits (bql) in CAN drivers, the
length of the CAN frame needs to be passed into the networking stack
even if the transmission failed for some reason.

To avoid to calculate this length twice, extend can_free_echo_skb() to
return that value. Convert all users of this function, too.

This patch is the natural extension of commit:

| 9420e1d495e2 ("can: dev: can_get_echo_skb(): extend to return can
|                frame length")

Link: https://lore.kernel.org/r/20210319142700.305648-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/skb.c                        | 11 +++++++++--
 drivers/net/can/grcan.c                          |  2 +-
 drivers/net/can/m_can/m_can.c                    |  2 +-
 drivers/net/can/rcar/rcar_can.c                  |  2 +-
 drivers/net/can/rcar/rcar_canfd.c                |  2 +-
 drivers/net/can/sja1000/sja1000.c                |  2 +-
 drivers/net/can/spi/hi311x.c                     |  2 +-
 drivers/net/can/spi/mcp251x.c                    |  2 +-
 drivers/net/can/usb/ems_usb.c                    |  2 +-
 drivers/net/can/usb/esd_usb2.c                   |  4 ++--
 drivers/net/can/usb/gs_usb.c                     |  2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |  2 +-
 drivers/net/can/usb/mcba_usb.c                   |  2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c     |  2 +-
 drivers/net/can/usb/ucan.c                       |  6 +++---
 drivers/net/can/usb/usb_8dev.c                   |  2 +-
 include/linux/can/skb.h                          |  3 ++-
 17 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 2256391ddbb3..387c0bc0fb9c 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -153,7 +153,8 @@ EXPORT_SYMBOL_GPL(can_get_echo_skb);
  *
  * The function is typically called when TX failed.
  */
-void can_free_echo_skb(struct net_device *dev, unsigned int idx)
+void can_free_echo_skb(struct net_device *dev, unsigned int idx,
+		       unsigned int *frame_len_ptr)
 {
 	struct can_priv *priv = netdev_priv(dev);
 
@@ -164,7 +165,13 @@ void can_free_echo_skb(struct net_device *dev, unsigned int idx)
 	}
 
 	if (priv->echo_skb[idx]) {
-		dev_kfree_skb_any(priv->echo_skb[idx]);
+		struct sk_buff *skb = priv->echo_skb[idx];
+		struct can_skb_priv *can_skb_priv = can_skb_prv(skb);
+
+		if (frame_len_ptr)
+			*frame_len_ptr = can_skb_priv->frame_len;
+
+		dev_kfree_skb_any(skb);
 		priv->echo_skb[idx] = NULL;
 	}
 }
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 4a8453290530..78e27940b2af 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -520,7 +520,7 @@ static int catch_up_echo_skb(struct net_device *dev, int budget, bool echo)
 			can_get_echo_skb(dev, i, NULL);
 		} else {
 			/* For cleanup of untransmitted messages */
-			can_free_echo_skb(dev, i);
+			can_free_echo_skb(dev, i, NULL);
 		}
 
 		priv->eskbp = grcan_ring_add(priv->eskbp, GRCAN_MSG_SIZE,
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 0c8d36bc668c..2ae3da16cbfe 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -425,7 +425,7 @@ static void m_can_clean(struct net_device *net)
 			putidx = ((m_can_read(cdev, M_CAN_TXFQS) &
 				   TXFQS_TFQPI_MASK) >> TXFQS_TFQPI_SHIFT);
 
-		can_free_echo_skb(cdev->net, putidx);
+		can_free_echo_skb(cdev->net, putidx, NULL);
 		cdev->tx_skb = NULL;
 	}
 }
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 4870c4ea190a..00e4533c8bdd 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -217,7 +217,7 @@ static void tx_failure_cleanup(struct net_device *ndev)
 	int i;
 
 	for (i = 0; i < RCAR_CAN_FIFO_DEPTH; i++)
-		can_free_echo_skb(ndev, i);
+		can_free_echo_skb(ndev, i, NULL);
 }
 
 static void rcar_can_error(struct net_device *ndev)
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index d8d233e62990..311e6ca3bdc4 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -617,7 +617,7 @@ static void rcar_canfd_tx_failure_cleanup(struct net_device *ndev)
 	u32 i;
 
 	for (i = 0; i < RCANFD_FIFO_DEPTH; i++)
-		can_free_echo_skb(ndev, i);
+		can_free_echo_skb(ndev, i, NULL);
 }
 
 static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 9e86488ba55f..3fad54646746 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -525,7 +525,7 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 			if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
 			    !(status & SR_TCS)) {
 				stats->tx_errors++;
-				can_free_echo_skb(dev, 0);
+				can_free_echo_skb(dev, 0, NULL);
 			} else {
 				/* transmission complete */
 				stats->tx_bytes +=
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index c3e020c90111..6f5d6d04a8b9 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -179,7 +179,7 @@ static void hi3110_clean(struct net_device *net)
 		net->stats.tx_errors++;
 	dev_kfree_skb(priv->tx_skb);
 	if (priv->tx_len)
-		can_free_echo_skb(priv->net, 0);
+		can_free_echo_skb(priv->net, 0, NULL);
 	priv->tx_skb = NULL;
 	priv->tx_len = 0;
 }
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index f69fb4238a65..80ab1593ca31 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -276,7 +276,7 @@ static void mcp251x_clean(struct net_device *net)
 		net->stats.tx_errors++;
 	dev_kfree_skb(priv->tx_skb);
 	if (priv->tx_len)
-		can_free_echo_skb(priv->net, 0);
+		can_free_echo_skb(priv->net, 0, NULL);
 	priv->tx_skb = NULL;
 	priv->tx_len = 0;
 }
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 18f40eb20360..5af69787d9d5 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -807,7 +807,7 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (unlikely(err)) {
-		can_free_echo_skb(netdev, context->echo_index);
+		can_free_echo_skb(netdev, context->echo_index, NULL);
 
 		usb_unanchor_urb(urb);
 		usb_free_coherent(dev->udev, size, buf, urb->transfer_dma);
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 562acbf454fd..65b58f8fc328 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -360,7 +360,7 @@ static void esd_usb2_tx_done_msg(struct esd_usb2_net_priv *priv,
 		can_get_echo_skb(netdev, context->echo_index, NULL);
 	} else {
 		stats->tx_errors++;
-		can_free_echo_skb(netdev, context->echo_index);
+		can_free_echo_skb(netdev, context->echo_index, NULL);
 	}
 
 	/* Release context */
@@ -793,7 +793,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err) {
-		can_free_echo_skb(netdev, context->echo_index);
+		can_free_echo_skb(netdev, context->echo_index, NULL);
 
 		atomic_dec(&priv->active_tx_jobs);
 		usb_unanchor_urb(urb);
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index a00dc1904415..5e892bef46b0 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -533,7 +533,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	if (unlikely(rc)) {			/* usb send failed */
 		atomic_dec(&dev->active_tx_urbs);
 
-		can_free_echo_skb(netdev, idx);
+		can_free_echo_skb(netdev, idx, NULL);
 		gs_free_tx_context(txc);
 
 		usb_unanchor_urb(urb);
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 4e97da8434ab..90ebcae13409 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -593,7 +593,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 	if (unlikely(err)) {
 		spin_lock_irqsave(&priv->tx_contexts_lock, flags);
 
-		can_free_echo_skb(netdev, context->echo_index);
+		can_free_echo_skb(netdev, context->echo_index, NULL);
 		context->echo_index = dev->max_tx_urbs;
 		--priv->active_tx_contexts;
 		netif_wake_queue(netdev);
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 1f649d178010..029e77dfa773 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -364,7 +364,7 @@ static netdev_tx_t mcba_usb_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 xmit_failed:
-	can_free_echo_skb(priv->netdev, ctx->ndx);
+	can_free_echo_skb(priv->netdev, ctx->ndx, NULL);
 	mcba_usb_free_ctx(ctx);
 	dev_kfree_skb(skb);
 	stats->tx_dropped++;
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 573b11559d73..29227b5851fe 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -371,7 +371,7 @@ static netdev_tx_t peak_usb_ndo_start_xmit(struct sk_buff *skb,
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err) {
-		can_free_echo_skb(netdev, context->echo_index);
+		can_free_echo_skb(netdev, context->echo_index, NULL);
 
 		usb_unanchor_urb(urb);
 
diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index fa403c080871..11fddedc36d4 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -675,7 +675,7 @@ static void ucan_tx_complete_msg(struct ucan_priv *up,
 			can_get_echo_skb(up->netdev, echo_index, NULL);
 		} else {
 			up->netdev->stats.tx_dropped++;
-			can_free_echo_skb(up->netdev, echo_index);
+			can_free_echo_skb(up->netdev, echo_index, NULL);
 		}
 		spin_unlock_irqrestore(&up->echo_skb_lock, flags);
 	}
@@ -843,7 +843,7 @@ static void ucan_write_bulk_callback(struct urb *urb)
 
 		/* update counters an cleanup */
 		spin_lock_irqsave(&up->echo_skb_lock, flags);
-		can_free_echo_skb(up->netdev, context - up->context_array);
+		can_free_echo_skb(up->netdev, context - up->context_array, NULL);
 		spin_unlock_irqrestore(&up->echo_skb_lock, flags);
 
 		up->netdev->stats.tx_dropped++;
@@ -1157,7 +1157,7 @@ static netdev_tx_t ucan_start_xmit(struct sk_buff *skb,
 		 * frees the skb
 		 */
 		spin_lock_irqsave(&up->echo_skb_lock, flags);
-		can_free_echo_skb(up->netdev, echo_index);
+		can_free_echo_skb(up->netdev, echo_index, NULL);
 		spin_unlock_irqrestore(&up->echo_skb_lock, flags);
 
 		if (ret == -ENODEV) {
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index e8c42430a4fc..b6e7ef0d5bc6 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -691,7 +691,7 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_BUSY;
 
 failed:
-	can_free_echo_skb(netdev, context->echo_index);
+	can_free_echo_skb(netdev, context->echo_index, NULL);
 
 	usb_unanchor_urb(urb);
 	usb_free_coherent(priv->udev, size, buf, urb->transfer_dma);
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index d438eb058069..d311bc369a39 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -23,7 +23,8 @@ struct sk_buff *__can_get_echo_skb(struct net_device *dev, unsigned int idx,
 				   u8 *len_ptr, unsigned int *frame_len_ptr);
 unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx,
 			      unsigned int *frame_len_ptr);
-void can_free_echo_skb(struct net_device *dev, unsigned int idx);
+void can_free_echo_skb(struct net_device *dev, unsigned int idx,
+		       unsigned int *frame_len_ptr);
 struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf);
 struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 				struct canfd_frame **cfd);
-- 
2.30.2


