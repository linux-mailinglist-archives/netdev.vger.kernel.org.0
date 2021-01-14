Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B182F5BE6
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbhANH6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbhANH61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:58:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBD2C061384
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:56:39 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kzxUj-0007Rq-HS
        for netdev@vger.kernel.org; Thu, 14 Jan 2021 08:56:37 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 27A425C367A
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 07:56:32 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9E6325C361D;
        Thu, 14 Jan 2021 07:56:21 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5d48b90c;
        Thu, 14 Jan 2021 07:56:18 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 13/17] can: dev: can_put_echo_skb(): extend to handle frame_len
Date:   Thu, 14 Jan 2021 08:56:13 +0100
Message-Id: <20210114075617.1402597-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114075617.1402597-1-mkl@pengutronix.de>
References: <20210114075617.1402597-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Add a frame_len argument to can_put_echo_skb() which is used to save length of
the CAN frame into field frame_len of struct can_skb_priv so that it can be
later used after transmission completion. Convert all users of this function,
too.

Drivers which implement BQL call can_put_echo_skb() with the output of
can_skb_get_frame_len(skb) and drivers which do not simply pass zero as an
input (in the same way that NULL would be given to can_get_echo_skb()). This
way, we have a nice symmetry between the two echo functions.

Link: https://lore.kernel.org/r/20210111061335.39983-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20210111141930.693847-13-mkl@pengutronix.de
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/at91_can.c                       | 2 +-
 drivers/net/can/c_can/c_can.c                    | 2 +-
 drivers/net/can/cc770/cc770.c                    | 2 +-
 drivers/net/can/dev/skb.c                        | 5 ++++-
 drivers/net/can/flexcan.c                        | 2 +-
 drivers/net/can/grcan.c                          | 2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c            | 2 +-
 drivers/net/can/kvaser_pciefd.c                  | 2 +-
 drivers/net/can/m_can/m_can.c                    | 4 ++--
 drivers/net/can/mscan/mscan.c                    | 2 +-
 drivers/net/can/pch_can.c                        | 2 +-
 drivers/net/can/peak_canfd/peak_canfd.c          | 2 +-
 drivers/net/can/rcar/rcar_can.c                  | 2 +-
 drivers/net/can/rcar/rcar_canfd.c                | 2 +-
 drivers/net/can/sja1000/sja1000.c                | 2 +-
 drivers/net/can/softing/softing_main.c           | 2 +-
 drivers/net/can/spi/hi311x.c                     | 2 +-
 drivers/net/can/spi/mcp251x.c                    | 2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c   | 2 +-
 drivers/net/can/sun4i_can.c                      | 2 +-
 drivers/net/can/ti_hecc.c                        | 2 +-
 drivers/net/can/usb/ems_usb.c                    | 2 +-
 drivers/net/can/usb/esd_usb2.c                   | 2 +-
 drivers/net/can/usb/gs_usb.c                     | 2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 2 +-
 drivers/net/can/usb/mcba_usb.c                   | 2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c     | 2 +-
 drivers/net/can/usb/ucan.c                       | 2 +-
 drivers/net/can/usb/usb_8dev.c                   | 2 +-
 drivers/net/can/xilinx_can.c                     | 4 ++--
 include/linux/can/skb.h                          | 2 +-
 31 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 5284f0ab3b06..90b223a80ed4 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -484,7 +484,7 @@ static netdev_tx_t at91_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	stats->tx_bytes += cf->len;
 
 	/* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
-	can_put_echo_skb(skb, dev, mb - get_mb_tx_first(priv));
+	can_put_echo_skb(skb, dev, mb - get_mb_tx_first(priv), 0);
 
 	/*
 	 * we have to stop the queue and deliver all messages in case
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 63f48b016ecd..13638954a25c 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -476,7 +476,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	 */
 	c_can_setup_tx_object(dev, IF_TX, frame, idx);
 	priv->dlc[idx] = frame->len;
-	can_put_echo_skb(skb, dev, idx);
+	can_put_echo_skb(skb, dev, idx, 0);
 
 	/* Update the active bits */
 	atomic_add((1 << idx), &priv->tx_active);
diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
index 8d9f332c35e0..e53ca338368a 100644
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -702,7 +702,7 @@ static void cc770_tx_interrupt(struct net_device *dev, unsigned int o)
 	stats->tx_bytes += cf->len;
 	stats->tx_packets++;
 
-	can_put_echo_skb(priv->tx_skb, dev, 0);
+	can_put_echo_skb(priv->tx_skb, dev, 0, 0);
 	can_get_echo_skb(dev, 0);
 	priv->tx_skb = NULL;
 
diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 24f782a23409..c184b4dce19e 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -38,7 +38,7 @@ void can_flush_echo_skb(struct net_device *dev)
  * priv->echo_skb, if necessary.
  */
 int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
-		     unsigned int idx)
+		     unsigned int idx, unsigned int frame_len)
 {
 	struct can_priv *priv = netdev_priv(dev);
 
@@ -62,6 +62,9 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 		skb->dev = dev;
 
+		/* save frame_len to reuse it when transmission is completed */
+		can_skb_prv(skb)->frame_len = frame_len;
+
 		/* save this skb for tx interrupt echo handling */
 		priv->echo_skb[idx] = skb;
 	} else {
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 7ab20a6b0d1d..202d08f8e1a4 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -815,7 +815,7 @@ static netdev_tx_t flexcan_start_xmit(struct sk_buff *skb, struct net_device *de
 		priv->write(data, &priv->tx_mb->data[i / sizeof(u32)]);
 	}
 
-	can_put_echo_skb(skb, dev, 0);
+	can_put_echo_skb(skb, dev, 0, 0);
 
 	priv->write(can_id, &priv->tx_mb->can_id);
 	priv->write(ctrl, &priv->tx_mb->can_ctrl);
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index f5d94a692576..8086cdc10000 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1448,7 +1448,7 @@ static netdev_tx_t grcan_start_xmit(struct sk_buff *skb,
 	 * taken.
 	 */
 	priv->txdlc[slotindex] = cf->len; /* Store dlc for statistics */
-	can_put_echo_skb(skb, dev, slotindex);
+	can_put_echo_skb(skb, dev, slotindex, 0);
 
 	/* Make sure everything is written before allowing hardware to
 	 * read from the memory
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index 86b0e1406a21..56ac9e1dace7 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -922,7 +922,7 @@ static netdev_tx_t ifi_canfd_start_xmit(struct sk_buff *skb,
 	writel(0, priv->base + IFI_CANFD_TXFIFO_REPEATCOUNT);
 	writel(0, priv->base + IFI_CANFD_TXFIFO_SUSPEND_US);
 
-	can_put_echo_skb(skb, ndev, 0);
+	can_put_echo_skb(skb, ndev, 0, 0);
 
 	/* Start the transmission */
 	writel(IFI_CANFD_TXSTCMD_ADD_MSG, priv->base + IFI_CANFD_TXSTCMD);
diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 969cedb9b0b6..0cf82f0646a3 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -778,7 +778,7 @@ static netdev_tx_t kvaser_pciefd_start_xmit(struct sk_buff *skb,
 	spin_lock_irqsave(&can->echo_lock, irq_flags);
 
 	/* Prepare and save echo skb in internal slot */
-	can_put_echo_skb(skb, netdev, can->echo_idx);
+	can_put_echo_skb(skb, netdev, can->echo_idx, 0);
 
 	/* Move echo index to the next slot */
 	can->echo_idx = (can->echo_idx + 1) % can->can.echo_skb_max;
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index da551fd0f502..fff7432103cb 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1483,7 +1483,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 					 M_CAN_FIFO_DATA(i / 4),
 					 *(u32 *)(cf->data + i));
 
-		can_put_echo_skb(skb, dev, 0);
+		can_put_echo_skb(skb, dev, 0, 0);
 
 		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
 			cccr = m_can_read(cdev, M_CAN_CCCR);
@@ -1554,7 +1554,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		/* Push loopback echo.
 		 * Will be looped back on TX interrupt based on message marker
 		 */
-		can_put_echo_skb(skb, dev, putidx);
+		can_put_echo_skb(skb, dev, putidx, 0);
 
 		/* Enable TX FIFO element to start transfer  */
 		m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index 5ed00a1558e1..a28fdaa411c6 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -270,7 +270,7 @@ static netdev_tx_t mscan_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	list_add_tail(&priv->tx_queue[buf_id].list, &priv->tx_head);
 
-	can_put_echo_skb(skb, dev, buf_id);
+	can_put_echo_skb(skb, dev, buf_id, 0);
 
 	/* Enable interrupt. */
 	priv->tx_active |= 1 << buf_id;
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 4f9e7ec192aa..a4c35b48d8e9 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -924,7 +924,7 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 			  &priv->regs->ifregs[1].data[i / 2]);
 	}
 
-	can_put_echo_skb(skb, ndev, tx_obj_no - PCH_RX_OBJ_END - 1);
+	can_put_echo_skb(skb, ndev, tx_obj_no - PCH_RX_OBJ_END - 1, 0);
 
 	/* Set the size of the data. Update if2_mcont */
 	iowrite32(cf->len | PCH_IF_MCONT_NEWDAT | PCH_IF_MCONT_TXRQXT |
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index c5334b0c3038..179a8e10fbb8 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -716,7 +716,7 @@ static netdev_tx_t peak_canfd_start_xmit(struct sk_buff *skb,
 	spin_lock_irqsave(&priv->echo_lock, flags);
 
 	/* prepare and save echo skb in internal slot */
-	can_put_echo_skb(skb, ndev, priv->echo_idx);
+	can_put_echo_skb(skb, ndev, priv->echo_idx, 0);
 
 	/* move echo index to the next slot */
 	priv->echo_idx = (priv->echo_idx + 1) % priv->can.echo_skb_max;
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index c803327f8f79..0b7e488bc4fe 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -617,7 +617,7 @@ static netdev_tx_t rcar_can_start_xmit(struct sk_buff *skb,
 	writeb(cf->len, &priv->regs->mb[RCAR_CAN_TX_FIFO_MBX].dlc);
 
 	priv->tx_dlc[priv->tx_head % RCAR_CAN_FIFO_DEPTH] = cf->len;
-	can_put_echo_skb(skb, ndev, priv->tx_head % RCAR_CAN_FIFO_DEPTH);
+	can_put_echo_skb(skb, ndev, priv->tx_head % RCAR_CAN_FIFO_DEPTH, 0);
 	priv->tx_head++;
 	/* Start Tx: write 0xff to the TFPCR register to increment
 	 * the CPU-side pointer for the transmit FIFO to the next
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 2778ed5c61d1..38376f29bc56 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1390,7 +1390,7 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 	}
 
 	priv->tx_len[priv->tx_head % RCANFD_FIFO_DEPTH] = cf->len;
-	can_put_echo_skb(skb, ndev, priv->tx_head % RCANFD_FIFO_DEPTH);
+	can_put_echo_skb(skb, ndev, priv->tx_head % RCANFD_FIFO_DEPTH, 0);
 
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	priv->tx_head++;
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index b6a7003c51d2..e98482c7bf33 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -318,7 +318,7 @@ static netdev_tx_t sja1000_start_xmit(struct sk_buff *skb,
 	for (i = 0; i < cf->len; i++)
 		priv->write_reg(priv, dreg++, cf->data[i]);
 
-	can_put_echo_skb(skb, dev, 0);
+	can_put_echo_skb(skb, dev, 0, 0);
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
 		cmd_reg_val |= CMD_AT;
diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index 40070c930202..a5314448c5ae 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -104,7 +104,7 @@ static netdev_tx_t softing_netdev_start_xmit(struct sk_buff *skb,
 	card->tx.last_bus = priv->index;
 	++card->tx.pending;
 	++priv->tx.pending;
-	can_put_echo_skb(skb, dev, priv->tx.echo_put);
+	can_put_echo_skb(skb, dev, priv->tx.echo_put, 0);
 	++priv->tx.echo_put;
 	if (priv->tx.echo_put >= TX_ECHO_SKB_MAX)
 		priv->tx.echo_put = 0;
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index f9455de94786..8c83a9e5a9e4 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -586,7 +586,7 @@ static void hi3110_tx_work_handler(struct work_struct *ws)
 			frame = (struct can_frame *)priv->tx_skb->data;
 			hi3110_hw_tx(spi, frame);
 			priv->tx_len = 1 + frame->len;
-			can_put_echo_skb(priv->tx_skb, net, 0);
+			can_put_echo_skb(priv->tx_skb, net, 0, 0);
 			priv->tx_skb = NULL;
 		}
 	}
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 25859d16d06f..40866754aafc 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1002,7 +1002,7 @@ static void mcp251x_tx_work_handler(struct work_struct *ws)
 				frame->len = CAN_FRAME_MAX_DATA_LEN;
 			mcp251x_hw_tx(spi, frame, 0);
 			priv->tx_len = 1 + frame->len;
-			can_put_echo_skb(priv->tx_skb, net, 0);
+			can_put_echo_skb(priv->tx_skb, net, 0, 0);
 			priv->tx_skb = NULL;
 		}
 	}
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 36235afb0bc6..95bba456a4cd 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2436,7 +2436,7 @@ static netdev_tx_t mcp251xfd_start_xmit(struct sk_buff *skb,
 	if (tx_ring->head - tx_ring->tail >= tx_ring->obj_num)
 		netif_stop_queue(ndev);
 
-	can_put_echo_skb(skb, ndev, tx_head);
+	can_put_echo_skb(skb, ndev, tx_head, 0);
 
 	err = mcp251xfd_tx_obj_write(priv, tx_obj);
 	if (err)
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index 783b63218b7b..b75175d59104 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -448,7 +448,7 @@ static netdev_tx_t sun4ican_start_xmit(struct sk_buff *skb, struct net_device *d
 
 	writel(msg_flag_n, priv->base + SUN4I_REG_BUF0_ADDR);
 
-	can_put_echo_skb(skb, dev, 0);
+	can_put_echo_skb(skb, dev, 0, 0);
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)
 		sun4i_can_write_cmdreg(priv, SUN4I_CMD_SELF_RCV_REQ);
diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index a6850ff0b55b..485c19bc98c2 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -513,7 +513,7 @@ static netdev_tx_t ti_hecc_xmit(struct sk_buff *skb, struct net_device *ndev)
 			       be32_to_cpu(*(__be32 *)(cf->data + 4)));
 	else
 		*(u32 *)(cf->data + 4) = 0;
-	can_put_echo_skb(skb, ndev, mbxno);
+	can_put_echo_skb(skb, ndev, mbxno, 0);
 
 	spin_lock_irqsave(&priv->mbx_lock, flags);
 	--priv->tx_head;
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 25eee4466364..5e5330060464 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -801,7 +801,7 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	usb_anchor_urb(urb, &dev->tx_submitted);
 
-	can_put_echo_skb(skb, netdev, context->echo_index);
+	can_put_echo_skb(skb, netdev, context->echo_index, 0);
 
 	atomic_inc(&dev->active_tx_urbs);
 
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 9eed75a4b678..68d8a85f00c4 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -783,7 +783,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 
 	usb_anchor_urb(urb, &priv->tx_submitted);
 
-	can_put_echo_skb(skb, netdev, context->echo_index);
+	can_put_echo_skb(skb, netdev, context->echo_index, 0);
 
 	atomic_inc(&priv->active_tx_jobs);
 
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 0487095e1fd0..5ce9ba5d29d6 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -525,7 +525,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	usb_anchor_urb(urb, &dev->tx_submitted);
 
-	can_put_echo_skb(skb, netdev, idx);
+	can_put_echo_skb(skb, netdev, idx, 0);
 
 	atomic_inc(&dev->active_tx_urbs);
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index e2d58846c40c..2b7efd296758 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -578,7 +578,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 
 	context->priv = priv;
 
-	can_put_echo_skb(skb, netdev, context->echo_index);
+	can_put_echo_skb(skb, netdev, context->echo_index, 0);
 
 	usb_fill_bulk_urb(urb, dev->udev,
 			  usb_sndbulkpipe(dev->udev,
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index df54eb7d4b36..5347c89992ce 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -355,7 +355,7 @@ static netdev_tx_t mcba_usb_start_xmit(struct sk_buff *skb,
 	if (cf->can_id & CAN_RTR_FLAG)
 		usb_msg.dlc |= MCBA_DLC_RTR_MASK;
 
-	can_put_echo_skb(skb, priv->netdev, ctx->ndx);
+	can_put_echo_skb(skb, priv->netdev, ctx->ndx, 0);
 
 	err = mcba_usb_xmit(priv, (struct mcba_usb_msg *)&usb_msg, ctx);
 	if (err)
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 251835ea15aa..95672750419a 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -365,7 +365,7 @@ static netdev_tx_t peak_usb_ndo_start_xmit(struct sk_buff *skb,
 
 	usb_anchor_urb(urb, &dev->tx_submitted);
 
-	can_put_echo_skb(skb, netdev, context->echo_index);
+	can_put_echo_skb(skb, netdev, context->echo_index, 0);
 
 	atomic_inc(&dev->active_tx_urbs);
 
diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 7d92da8954fe..5add27614e2b 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1137,7 +1137,7 @@ static netdev_tx_t ucan_start_xmit(struct sk_buff *skb,
 
 	/* put the skb on can loopback stack */
 	spin_lock_irqsave(&up->echo_skb_lock, flags);
-	can_put_echo_skb(skb, up->netdev, echo_index);
+	can_put_echo_skb(skb, up->netdev, echo_index, 0);
 	spin_unlock_irqrestore(&up->echo_skb_lock, flags);
 
 	/* transmit it */
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 44478304ff46..2e824d9d8167 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -664,7 +664,7 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	usb_anchor_urb(urb, &priv->tx_submitted);
 
-	can_put_echo_skb(skb, netdev, context->echo_index);
+	can_put_echo_skb(skb, netdev, context->echo_index, 0);
 
 	atomic_inc(&priv->active_tx_urbs);
 
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 3f54edee92eb..8d5132a3f2c9 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -592,9 +592,9 @@ static void xcan_write_frame(struct net_device *ndev, struct sk_buff *skb,
 
 	if (!(priv->devtype.flags & XCAN_FLAG_TX_MAILBOXES) &&
 	    (priv->devtype.flags & XCAN_FLAG_TXFEMP))
-		can_put_echo_skb(skb, ndev, priv->tx_head % priv->tx_max);
+		can_put_echo_skb(skb, ndev, priv->tx_head % priv->tx_max, 0);
 	else
-		can_put_echo_skb(skb, ndev, 0);
+		can_put_echo_skb(skb, ndev, 0, 0);
 
 	priv->tx_head++;
 
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index 5db9da30843c..eaac4a637ae0 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -18,7 +18,7 @@
 
 void can_flush_echo_skb(struct net_device *dev);
 int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
-		     unsigned int idx);
+		     unsigned int idx, unsigned int frame_len);
 struct sk_buff *__can_get_echo_skb(struct net_device *dev, unsigned int idx,
 				   u8 *len_ptr, unsigned int *frame_len_ptr);
 unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx);
-- 
2.29.2


