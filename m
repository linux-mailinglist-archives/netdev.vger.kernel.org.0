Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7248046063E
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 13:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhK1Mvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 07:51:43 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:62567 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352587AbhK1Mtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 07:49:42 -0500
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id rJR2meSen2lVYrJSFmr5UF; Sun, 28 Nov 2021 13:38:56 +0100
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sun, 28 Nov 2021 13:38:56 +0100
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jimmy Assarsson <extja@kvaser.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Subject: [PATCH v3 5/5] can: do not increase tx_bytes statistics for RTR frames
Date:   Sun, 28 Nov 2021 21:37:34 +0900
Message-Id: <20211128123734.1049786-6-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211128123734.1049786-1-mailhol.vincent@wanadoo.fr>
References: <20211128123734.1049786-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The actual payload length of the CAN Remote Transmission Request (RTR)
frames is always 0, i.e. nothing is transmitted on the wire. However,
those RTR frames still use the DLC to indicate the length of the
requested frame.

As such, net_device_stats:tx_bytes should not be increased when
sending RTR frames.

The function can_get_echo_skb() already returns the correct length,
even for RTR frames (c.f. [1]). However, for historical reasons, the
drivers do not use can_get_echo_skb()'s return value and instead, most
of them store a temporary length (or dlc) in some local structure or
array. Using the return value of can_get_echo_skb() solves the
issue. After doing this, such length/dlc fields become unused and so
this patch does the adequate cleaning when needed.

This patch fixes all the CAN drivers.

Finally, can_get_echo_skb() is decorated with the __must_check
attribute in order to force future drivers to correctly use its return
value (else the compiler would emit a warning).

[1] commit ed3320cec279 ("can: dev: __can_get_echo_skb():
fix real payload length return value for RTR frames")

CC: Jimmy Assarsson <extja@kvaser.com>
CC: Nicolas Ferre <nicolas.ferre@microchip.com>
CC: Alexandre Belloni <alexandre.belloni@bootlin.com>
CC: Ludovic Desroches <ludovic.desroches@microchip.com>
CC: Maxime Ripard <mripard@kernel.org>
CC: Chen-Yu Tsai <wens@csie.org>
CC: Jernej Skrabec <jernej.skrabec@gmail.com>
CC: Yasushi SHOJI <yashi@spacecubics.com>
CC: Oliver Hartkopp <socketcan@hartkopp.net>
CC: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/at91_can.c                    |  8 ++---
 drivers/net/can/c_can/c_can.h                 |  1 -
 drivers/net/can/c_can/c_can_main.c            |  7 ++--
 drivers/net/can/cc770/cc770.c                 |  8 ++---
 drivers/net/can/janz-ican3.c                  |  3 +-
 drivers/net/can/mscan/mscan.c                 |  4 +--
 drivers/net/can/pch_can.c                     |  9 ++---
 drivers/net/can/peak_canfd/peak_canfd.c       |  3 +-
 drivers/net/can/rcar/rcar_can.c               | 11 +++---
 drivers/net/can/rcar/rcar_canfd.c             |  6 +---
 drivers/net/can/sja1000/sja1000.c             |  4 +--
 drivers/net/can/slcan.c                       |  3 +-
 drivers/net/can/softing/softing_main.c        |  8 ++---
 drivers/net/can/spi/hi311x.c                  | 24 ++++++-------
 drivers/net/can/spi/mcp251x.c                 | 25 ++++++-------
 drivers/net/can/sun4i_can.c                   |  5 +--
 drivers/net/can/usb/ems_usb.c                 |  7 ++--
 drivers/net/can/usb/esd_usb2.c                |  6 ++--
 drivers/net/can/usb/gs_usb.c                  |  7 ++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  5 ++-
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  |  2 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 36 +++++++++----------
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 13 +++----
 drivers/net/can/usb/mcba_usb.c                | 12 +++----
 drivers/net/can/usb/peak_usb/pcan_usb_core.c  | 20 +++++------
 drivers/net/can/usb/peak_usb/pcan_usb_core.h  |  1 -
 drivers/net/can/usb/ucan.c                    | 10 ++----
 drivers/net/can/usb/usb_8dev.c                |  6 +---
 drivers/net/can/vcan.c                        |  7 ++--
 drivers/net/can/vxcan.c                       |  2 +-
 include/linux/can/skb.h                       |  5 +--
 31 files changed, 110 insertions(+), 158 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 97f1d08b4133..b37d9b4f508e 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -448,7 +448,6 @@ static void at91_chip_stop(struct net_device *dev, enum can_state state)
 static netdev_tx_t at91_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct at91_priv *priv = netdev_priv(dev);
-	struct net_device_stats *stats = &dev->stats;
 	struct can_frame *cf = (struct can_frame *)skb->data;
 	unsigned int mb, prio;
 	u32 reg_mid, reg_mcr;
@@ -480,8 +479,6 @@ static netdev_tx_t at91_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* This triggers transmission */
 	at91_write(priv, AT91_MCR(mb), reg_mcr);
 
-	stats->tx_bytes += cf->len;
-
 	/* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
 	can_put_echo_skb(skb, dev, mb - get_mb_tx_first(priv), 0);
 
@@ -852,7 +849,10 @@ static void at91_irq_tx(struct net_device *dev, u32 reg_sr)
 		if (likely(reg_msr & AT91_MSR_MRDY &&
 			   ~reg_msr & AT91_MSR_MABT)) {
 			/* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
-			can_get_echo_skb(dev, mb - get_mb_tx_first(priv), NULL);
+			dev->stats.tx_bytes =
+				can_get_echo_skb(dev,
+						 mb - get_mb_tx_first(priv),
+						 NULL);
 			dev->stats.tx_packets++;
 			can_led_event(dev, CAN_LED_EVENT_TX);
 		}
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 08b6efa7a1a7..bd2f6dc01194 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -211,7 +211,6 @@ struct c_can_priv {
 	struct c_can_raminit raminit_sys;	/* RAMINIT via syscon regmap */
 	void (*raminit)(const struct c_can_priv *priv, bool enable);
 	u32 comm_rcv_high;
-	u32 dlc[];
 };
 
 struct net_device *alloc_c_can_dev(int msg_obj_num);
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index 29e91804d81c..faa217f26771 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -477,7 +477,6 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	 * transmit as we might race against do_tx().
 	 */
 	c_can_setup_tx_object(dev, IF_TX, frame, idx);
-	priv->dlc[idx] = frame->len;
 	can_put_echo_skb(skb, dev, idx, 0);
 	obj = idx + priv->msg_obj_tx_first;
 	c_can_object_put(dev, IF_TX, obj, cmd);
@@ -742,8 +741,7 @@ static void c_can_do_tx(struct net_device *dev)
 		 * NAPI. We are not transmitting.
 		 */
 		c_can_inval_tx_object(dev, IF_NAPI, obj);
-		can_get_echo_skb(dev, idx, NULL);
-		bytes += priv->dlc[idx];
+		bytes += can_get_echo_skb(dev, idx, NULL);
 		pkts++;
 	}
 
@@ -1227,8 +1225,7 @@ struct net_device *alloc_c_can_dev(int msg_obj_num)
 	struct c_can_priv *priv;
 	int msg_obj_tx_num = msg_obj_num / 2;
 
-	dev = alloc_candev(struct_size(priv, dlc, msg_obj_tx_num),
-			   msg_obj_tx_num);
+	dev = alloc_candev(sizeof(*priv), msg_obj_tx_num);
 	if (!dev)
 		return NULL;
 
diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
index 994073c0a2f6..bb7224cfc6ab 100644
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -664,7 +664,6 @@ static void cc770_tx_interrupt(struct net_device *dev, unsigned int o)
 	struct cc770_priv *priv = netdev_priv(dev);
 	struct net_device_stats *stats = &dev->stats;
 	unsigned int mo = obj2msgobj(o);
-	struct can_frame *cf;
 	u8 ctrl1;
 
 	ctrl1 = cc770_read_reg(priv, msgobj[mo].ctrl1);
@@ -696,12 +695,9 @@ static void cc770_tx_interrupt(struct net_device *dev, unsigned int o)
 		return;
 	}
 
-	cf = (struct can_frame *)priv->tx_skb->data;
-	stats->tx_bytes += cf->len;
-	stats->tx_packets++;
-
 	can_put_echo_skb(priv->tx_skb, dev, 0, 0);
-	can_get_echo_skb(dev, 0, NULL);
+	stats->tx_bytes += can_get_echo_skb(dev, 0, NULL);
+	stats->tx_packets++;
 	priv->tx_skb = NULL;
 
 	netif_wake_queue(dev);
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 5c589aa9dff8..5b677af5f2a4 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1294,7 +1294,8 @@ static unsigned int ican3_get_echo_skb(struct ican3_dev *mod)
 	}
 
 	cf = (struct can_frame *)skb->data;
-	dlc = cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		dlc = cf->len;
 
 	/* check flag whether this packet has to be looped back */
 	if (skb->pkt_type != PACKET_LOOPBACK) {
diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index 59b8284d00e5..5b5802fac772 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -448,9 +448,9 @@ static irqreturn_t mscan_isr(int irq, void *dev_id)
 				continue;
 
 			out_8(&regs->cantbsel, mask);
-			stats->tx_bytes += in_8(&regs->tx.dlr);
+			stats->tx_bytes += can_get_echo_skb(dev, entry->id,
+							    NULL);
 			stats->tx_packets++;
-			can_get_echo_skb(dev, entry->id, NULL);
 			priv->tx_active &= ~mask;
 			list_del(pos);
 		}
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index b46f9cfb9e0a..888bef03de09 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -707,16 +707,13 @@ static void pch_can_tx_complete(struct net_device *ndev, u32 int_stat)
 {
 	struct pch_can_priv *priv = netdev_priv(ndev);
 	struct net_device_stats *stats = &(priv->ndev->stats);
-	u32 dlc;
 
-	can_get_echo_skb(ndev, int_stat - PCH_RX_OBJ_END - 1, NULL);
+	stats->tx_bytes += can_get_echo_skb(ndev, int_stat - PCH_RX_OBJ_END - 1,
+					    NULL);
+	stats->tx_packets++;
 	iowrite32(PCH_CMASK_RX_TX_GET | PCH_CMASK_CLRINTPND,
 		  &priv->regs->ifregs[1].cmask);
 	pch_can_rw_msg_obj(&priv->regs->ifregs[1].creq, int_stat);
-	dlc = can_cc_dlc2len(ioread32(&priv->regs->ifregs[1].mcont) &
-			  PCH_IF_MCONT_DLC);
-	stats->tx_bytes += dlc;
-	stats->tx_packets++;
 	if (int_stat == PCH_TX_OBJ_END)
 		netif_wake_queue(ndev);
 }
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index 216609198eac..b2dea360813d 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -266,10 +266,9 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
 		unsigned long flags;
 
 		spin_lock_irqsave(&priv->echo_lock, flags);
-		can_get_echo_skb(priv->ndev, msg->client, NULL);
 
 		/* count bytes of the echo instead of skb */
-		stats->tx_bytes += cf_len;
+		stats->tx_bytes += can_get_echo_skb(priv->ndev, msg->client, NULL);
 		stats->tx_packets++;
 
 		/* restart tx queue (a slot is free) */
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 62bbd58bfef8..33e37395379d 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -94,7 +94,6 @@ struct rcar_can_priv {
 	struct rcar_can_regs __iomem *regs;
 	struct clk *clk;
 	struct clk *can_clk;
-	u8 tx_dlc[RCAR_CAN_FIFO_DEPTH];
 	u32 tx_head;
 	u32 tx_tail;
 	u8 clock_select;
@@ -379,10 +378,11 @@ static void rcar_can_tx_done(struct net_device *ndev)
 		if (priv->tx_head - priv->tx_tail <= unsent)
 			break;
 		stats->tx_packets++;
-		stats->tx_bytes += priv->tx_dlc[priv->tx_tail %
-						RCAR_CAN_FIFO_DEPTH];
-		priv->tx_dlc[priv->tx_tail % RCAR_CAN_FIFO_DEPTH] = 0;
-		can_get_echo_skb(ndev, priv->tx_tail % RCAR_CAN_FIFO_DEPTH, NULL);
+		stats->tx_bytes +=
+			can_get_echo_skb(ndev,
+					 priv->tx_tail % RCAR_CAN_FIFO_DEPTH,
+					 NULL);
+
 		priv->tx_tail++;
 		netif_wake_queue(ndev);
 	}
@@ -612,7 +612,6 @@ static netdev_tx_t rcar_can_start_xmit(struct sk_buff *skb,
 
 	writeb(cf->len, &priv->regs->mb[RCAR_CAN_TX_FIFO_MBX].dlc);
 
-	priv->tx_dlc[priv->tx_head % RCAR_CAN_FIFO_DEPTH] = cf->len;
 	can_put_echo_skb(skb, ndev, priv->tx_head % RCAR_CAN_FIFO_DEPTH, 0);
 	priv->tx_head++;
 	/* Start Tx: write 0xff to the TFPCR register to increment
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index b1eded2f2c5d..d0e795f60338 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -502,7 +502,6 @@ struct rcar_canfd_channel {
 	struct rcar_canfd_global *gpriv;	/* Controller reference */
 	void __iomem *base;			/* Register base address */
 	struct napi_struct napi;
-	u8  tx_len[RCANFD_FIFO_DEPTH];		/* For net stats */
 	u32 tx_head;				/* Incremented on xmit */
 	u32 tx_tail;				/* Incremented on xmit done */
 	u32 channel;				/* Channel number */
@@ -1049,9 +1048,7 @@ static void rcar_canfd_tx_done(struct net_device *ndev)
 
 		sent = priv->tx_tail % RCANFD_FIFO_DEPTH;
 		stats->tx_packets++;
-		stats->tx_bytes += priv->tx_len[sent];
-		priv->tx_len[sent] = 0;
-		can_get_echo_skb(ndev, sent, NULL);
+		stats->tx_bytes += can_get_echo_skb(ndev, sent, NULL);
 
 		spin_lock_irqsave(&priv->tx_lock, flags);
 		priv->tx_tail++;
@@ -1461,7 +1458,6 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 				    RCANFD_C_CFDF(ch, RCANFD_CFFIFO_IDX, 0));
 	}
 
-	priv->tx_len[priv->tx_head % RCANFD_FIFO_DEPTH] = cf->len;
 	can_put_echo_skb(skb, ndev, priv->tx_head % RCANFD_FIFO_DEPTH, 0);
 
 	spin_lock_irqsave(&priv->tx_lock, flags);
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 4bf44d449987..966316479485 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -527,10 +527,8 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 				can_free_echo_skb(dev, 0, NULL);
 			} else {
 				/* transmission complete */
-				stats->tx_bytes +=
-					priv->read_reg(priv, SJA1000_FI) & 0xf;
+				stats->tx_bytes += can_get_echo_skb(dev, 0, NULL);
 				stats->tx_packets++;
-				can_get_echo_skb(dev, 0, NULL);
 			}
 			netif_wake_queue(dev);
 			can_led_event(dev, CAN_LED_EVENT_TX);
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 5cf03458e948..53bd66e36ef5 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -306,7 +306,8 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
 	actual = sl->tty->ops->write(sl->tty, sl->xbuff, pos - sl->xbuff);
 	sl->xleft = (pos - sl->xbuff) - actual;
 	sl->xhead = sl->xbuff + actual;
-	sl->dev->stats.tx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		sl->dev->stats.tx_bytes += cf->len;
 }
 
 /* Write out any remaining transmit buffer. Scheduled when tty is writable */
diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index cfc1325aad10..d74e895bddf7 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -282,7 +282,10 @@ static int softing_handle_1(struct softing *card)
 			skb = priv->can.echo_skb[priv->tx.echo_get];
 			if (skb)
 				skb->tstamp = ktime;
-			can_get_echo_skb(netdev, priv->tx.echo_get, NULL);
+			++netdev->stats.tx_packets;
+			netdev->stats.tx_bytes +=
+				can_get_echo_skb(netdev, priv->tx.echo_get,
+						 NULL);
 			++priv->tx.echo_get;
 			if (priv->tx.echo_get >= TX_ECHO_SKB_MAX)
 				priv->tx.echo_get = 0;
@@ -290,9 +293,6 @@ static int softing_handle_1(struct softing *card)
 				--priv->tx.pending;
 			if (card->tx.pending)
 				--card->tx.pending;
-			++netdev->stats.tx_packets;
-			if (!(msg.can_id & CAN_RTR_FLAG))
-				netdev->stats.tx_bytes += msg.len;
 		} else {
 			int ret;
 
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 771a13945032..59e01c258490 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -153,7 +153,6 @@ struct hi3110_priv {
 	u8 *spi_rx_buf;
 
 	struct sk_buff *tx_skb;
-	int tx_len;
 
 	struct workqueue_struct *wq;
 	struct work_struct tx_work;
@@ -166,6 +165,8 @@ struct hi3110_priv {
 #define HI3110_AFTER_SUSPEND_POWER 4
 #define HI3110_AFTER_SUSPEND_RESTART 8
 	int restart_tx;
+	bool tx_busy;
+
 	struct regulator *power;
 	struct regulator *transceiver;
 	struct clk *clk;
@@ -175,13 +176,13 @@ static void hi3110_clean(struct net_device *net)
 {
 	struct hi3110_priv *priv = netdev_priv(net);
 
-	if (priv->tx_skb || priv->tx_len)
+	if (priv->tx_skb || priv->tx_busy)
 		net->stats.tx_errors++;
 	dev_kfree_skb(priv->tx_skb);
-	if (priv->tx_len)
+	if (priv->tx_busy)
 		can_free_echo_skb(priv->net, 0, NULL);
 	priv->tx_skb = NULL;
-	priv->tx_len = 0;
+	priv->tx_busy = false;
 }
 
 /* Note about handling of error return of hi3110_spi_trans: accessing
@@ -369,7 +370,7 @@ static netdev_tx_t hi3110_hard_start_xmit(struct sk_buff *skb,
 	struct hi3110_priv *priv = netdev_priv(net);
 	struct spi_device *spi = priv->spi;
 
-	if (priv->tx_skb || priv->tx_len) {
+	if (priv->tx_skb || priv->tx_busy) {
 		dev_err(&spi->dev, "hard_xmit called while tx busy\n");
 		return NETDEV_TX_BUSY;
 	}
@@ -586,7 +587,7 @@ static void hi3110_tx_work_handler(struct work_struct *ws)
 		} else {
 			frame = (struct can_frame *)priv->tx_skb->data;
 			hi3110_hw_tx(spi, frame);
-			priv->tx_len = 1 + frame->len;
+			priv->tx_busy = true;
 			can_put_echo_skb(priv->tx_skb, net, 0, 0);
 			priv->tx_skb = NULL;
 		}
@@ -721,14 +722,11 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
 			}
 		}
 
-		if (priv->tx_len && statf & HI3110_STAT_TXMTY) {
+		if (priv->tx_busy && statf & HI3110_STAT_TXMTY) {
 			net->stats.tx_packets++;
-			net->stats.tx_bytes += priv->tx_len - 1;
+			net->stats.tx_bytes += can_get_echo_skb(net, 0, NULL);
 			can_led_event(net, CAN_LED_EVENT_TX);
-			if (priv->tx_len) {
-				can_get_echo_skb(net, 0, NULL);
-				priv->tx_len = 0;
-			}
+			priv->tx_busy = false;
 			netif_wake_queue(net);
 		}
 
@@ -755,7 +753,7 @@ static int hi3110_open(struct net_device *net)
 
 	priv->force_quit = 0;
 	priv->tx_skb = NULL;
-	priv->tx_len = 0;
+	priv->tx_busy = false;
 
 	ret = request_threaded_irq(spi->irq, NULL, hi3110_can_ist,
 				   flags, DEVICE_NAME, priv);
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index b46516b7d39f..69a3395385d3 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -237,7 +237,6 @@ struct mcp251x_priv {
 	u8 *spi_rx_buf;
 
 	struct sk_buff *tx_skb;
-	int tx_len;
 
 	struct workqueue_struct *wq;
 	struct work_struct tx_work;
@@ -250,6 +249,8 @@ struct mcp251x_priv {
 #define AFTER_SUSPEND_POWER 4
 #define AFTER_SUSPEND_RESTART 8
 	int restart_tx;
+	bool tx_busy;
+
 	struct regulator *power;
 	struct regulator *transceiver;
 	struct clk *clk;
@@ -272,13 +273,13 @@ static void mcp251x_clean(struct net_device *net)
 {
 	struct mcp251x_priv *priv = netdev_priv(net);
 
-	if (priv->tx_skb || priv->tx_len)
+	if (priv->tx_skb || priv->tx_busy)
 		net->stats.tx_errors++;
 	dev_kfree_skb(priv->tx_skb);
-	if (priv->tx_len)
+	if (priv->tx_busy)
 		can_free_echo_skb(priv->net, 0, NULL);
 	priv->tx_skb = NULL;
-	priv->tx_len = 0;
+	priv->tx_busy = false;
 }
 
 /* Note about handling of error return of mcp251x_spi_trans: accessing
@@ -788,7 +789,7 @@ static netdev_tx_t mcp251x_hard_start_xmit(struct sk_buff *skb,
 	struct mcp251x_priv *priv = netdev_priv(net);
 	struct spi_device *spi = priv->spi;
 
-	if (priv->tx_skb || priv->tx_len) {
+	if (priv->tx_skb || priv->tx_busy) {
 		dev_warn(&spi->dev, "hard_xmit called while tx busy\n");
 		return NETDEV_TX_BUSY;
 	}
@@ -1013,7 +1014,7 @@ static void mcp251x_tx_work_handler(struct work_struct *ws)
 			if (frame->len > CAN_FRAME_MAX_DATA_LEN)
 				frame->len = CAN_FRAME_MAX_DATA_LEN;
 			mcp251x_hw_tx(spi, frame, 0);
-			priv->tx_len = 1 + frame->len;
+			priv->tx_busy = true;
 			can_put_echo_skb(priv->tx_skb, net, 0, 0);
 			priv->tx_skb = NULL;
 		}
@@ -1179,12 +1180,12 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 			break;
 
 		if (intf & CANINTF_TX) {
-			net->stats.tx_packets++;
-			net->stats.tx_bytes += priv->tx_len - 1;
 			can_led_event(net, CAN_LED_EVENT_TX);
-			if (priv->tx_len) {
-				can_get_echo_skb(net, 0, NULL);
-				priv->tx_len = 0;
+			if (priv->tx_busy) {
+				net->stats.tx_packets++;
+				net->stats.tx_bytes += can_get_echo_skb(net, 0,
+									NULL);
+				priv->tx_busy = false;
 			}
 			netif_wake_queue(net);
 		}
@@ -1211,7 +1212,7 @@ static int mcp251x_open(struct net_device *net)
 
 	priv->force_quit = 0;
 	priv->tx_skb = NULL;
-	priv->tx_len = 0;
+	priv->tx_busy = false;
 
 	if (!dev_fwnode(&spi->dev))
 		flags = IRQF_TRIGGER_FALLING;
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index 6a7d89c4648c..81884ef5ceaf 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -650,11 +650,8 @@ static irqreturn_t sun4i_can_interrupt(int irq, void *dev_id)
 
 		if (isrc & SUN4I_INT_TBUF_VLD) {
 			/* transmission complete interrupt */
-			stats->tx_bytes +=
-			    readl(priv->base +
-				  SUN4I_REG_RBUF_RBACK_START_ADDR) & 0xf;
+			stats->tx_bytes += can_get_echo_skb(dev, 0, NULL);
 			stats->tx_packets++;
-			can_get_echo_skb(dev, 0, NULL);
 			netif_wake_queue(dev);
 			can_led_event(dev, CAN_LED_EVENT_TX);
 		}
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index c9b6adf5c1ec..7bedceffdfa3 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -230,7 +230,6 @@ struct ems_tx_urb_context {
 	struct ems_usb *dev;
 
 	u32 echo_index;
-	u8 dlc;
 };
 
 struct ems_usb {
@@ -517,9 +516,8 @@ static void ems_usb_write_bulk_callback(struct urb *urb)
 
 	/* transmission complete interrupt */
 	netdev->stats.tx_packets++;
-	netdev->stats.tx_bytes += context->dlc;
-
-	can_get_echo_skb(netdev, context->echo_index, NULL);
+	netdev->stats.tx_bytes += can_get_echo_skb(netdev, context->echo_index,
+						   NULL);
 
 	/* Release context */
 	context->echo_index = MAX_TX_URBS;
@@ -805,7 +803,6 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 
 	context->dev = dev;
 	context->echo_index = i;
-	context->dlc = cf->len;
 
 	usb_fill_bulk_urb(urb, dev->udev, usb_sndbulkpipe(dev->udev, 2), buf,
 			  size, ems_usb_write_bulk_callback, context);
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 9ac7ee44b6e3..286daaaea0b8 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -183,7 +183,6 @@ struct esd_usb2_net_priv;
 struct esd_tx_urb_context {
 	struct esd_usb2_net_priv *priv;
 	u32 echo_index;
-	int len;	/* CAN payload length */
 };
 
 struct esd_usb2 {
@@ -357,8 +356,8 @@ static void esd_usb2_tx_done_msg(struct esd_usb2_net_priv *priv,
 
 	if (!msg->msg.txdone.status) {
 		stats->tx_packets++;
-		stats->tx_bytes += context->len;
-		can_get_echo_skb(netdev, context->echo_index, NULL);
+		stats->tx_bytes += can_get_echo_skb(netdev, context->echo_index,
+						    NULL);
 	} else {
 		stats->tx_errors++;
 		can_free_echo_skb(netdev, context->echo_index, NULL);
@@ -783,7 +782,6 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 
 	context->priv = priv;
 	context->echo_index = i;
-	context->len = cf->len;
 
 	/* hnd must not be 0 - MSB is stripped in txdone handling */
 	msg->msg.tx.hnd = 0x80000000 | i; /* returned in TX done message */
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 1b400de00f51..03b012963c20 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -357,9 +357,6 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 			goto resubmit_urb;
 		}
 
-		netdev->stats.tx_packets++;
-		netdev->stats.tx_bytes += hf->can_dlc;
-
 		txc = gs_get_tx_context(dev, hf->echo_id);
 
 		/* bad devices send bad echo_ids. */
@@ -370,7 +367,9 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 			goto resubmit_urb;
 		}
 
-		can_get_echo_skb(netdev, hf->echo_id, NULL);
+		netdev->stats.tx_packets++;
+		netdev->stats.tx_bytes += can_get_echo_skb(netdev, hf->echo_id,
+							   NULL);
 
 		gs_free_tx_context(txc);
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index 390b6bde883c..3a49257f9fa6 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -77,7 +77,6 @@ struct kvaser_usb_dev_card_data {
 struct kvaser_usb_tx_urb_context {
 	struct kvaser_usb_net_priv *priv;
 	u32 echo_index;
-	int dlc;
 };
 
 struct kvaser_usb {
@@ -162,8 +161,8 @@ struct kvaser_usb_dev_ops {
 	void (*dev_read_bulk_callback)(struct kvaser_usb *dev, void *buf,
 				       int len);
 	void *(*dev_frame_to_cmd)(const struct kvaser_usb_net_priv *priv,
-				  const struct sk_buff *skb, int *frame_len,
-				  int *cmd_len, u16 transid);
+				  const struct sk_buff *skb, int *cmd_len,
+				  u16 transid);
 };
 
 struct kvaser_usb_dev_cfg {
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 3e682ef43f8e..c4b4d3d0a387 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -565,7 +565,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 		goto freeurb;
 	}
 
-	buf = dev->ops->dev_frame_to_cmd(priv, skb, &context->dlc, &cmd_len,
+	buf = dev->ops->dev_frame_to_cmd(priv, skb, &cmd_len,
 					 context->echo_index);
 	if (!buf) {
 		stats->tx_dropped++;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 17fabd3d0613..9f423a5fb63f 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1113,7 +1113,7 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
 	struct kvaser_usb_net_priv *priv;
 	struct can_frame *cf;
 	unsigned long irq_flags;
-	int len;
+	unsigned int len;
 	bool one_shot_fail = false, is_err_frame = false;
 	u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);
 
@@ -1136,7 +1136,6 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
 	}
 
 	context = &priv->tx_contexts[transid % dev->max_tx_urbs];
-	len = context->dlc;
 
 	spin_lock_irqsave(&priv->tx_contexts_lock, irq_flags);
 
@@ -1144,7 +1143,8 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
 	if (cf)
 		is_err_frame = !!(cf->can_id & CAN_RTR_FLAG);
 
-	can_get_echo_skb(priv->netdev, context->echo_index, NULL);
+	len = can_get_echo_skb(priv->netdev, context->echo_index, NULL);
+
 	context->echo_index = dev->max_tx_urbs;
 	--priv->active_tx_contexts;
 	netif_wake_queue(priv->netdev);
@@ -1375,8 +1375,8 @@ static void kvaser_usb_hydra_handle_cmd(const struct kvaser_usb *dev,
 
 static void *
 kvaser_usb_hydra_frame_to_cmd_ext(const struct kvaser_usb_net_priv *priv,
-				  const struct sk_buff *skb, int *frame_len,
-				  int *cmd_len, u16 transid)
+				  const struct sk_buff *skb, int *cmd_len,
+				  u16 transid)
 {
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_cmd_ext *cmd;
@@ -1388,8 +1388,6 @@ kvaser_usb_hydra_frame_to_cmd_ext(const struct kvaser_usb_net_priv *priv,
 	u32 kcan_id;
 	u32 kcan_header;
 
-	*frame_len = nbr_of_bytes;
-
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd_ext), GFP_ATOMIC);
 	if (!cmd)
 		return NULL;
@@ -1455,8 +1453,8 @@ kvaser_usb_hydra_frame_to_cmd_ext(const struct kvaser_usb_net_priv *priv,
 
 static void *
 kvaser_usb_hydra_frame_to_cmd_std(const struct kvaser_usb_net_priv *priv,
-				  const struct sk_buff *skb, int *frame_len,
-				  int *cmd_len, u16 transid)
+				  const struct sk_buff *skb, int *cmd_len,
+				  u16 transid)
 {
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_cmd *cmd;
@@ -1464,8 +1462,6 @@ kvaser_usb_hydra_frame_to_cmd_std(const struct kvaser_usb_net_priv *priv,
 	u32 flags;
 	u32 id;
 
-	*frame_len = cf->len;
-
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_ATOMIC);
 	if (!cmd)
 		return NULL;
@@ -1493,13 +1489,13 @@ kvaser_usb_hydra_frame_to_cmd_std(const struct kvaser_usb_net_priv *priv,
 	if (cf->can_id & CAN_RTR_FLAG)
 		flags |= KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME;
 
-	flags |= (cf->can_id & CAN_ERR_FLAG ?
-		  KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME : 0);
+	if (cf->can_id & CAN_ERR_FLAG)
+		flags |= KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME;
 
 	cmd->tx_can.id = cpu_to_le32(id);
 	cmd->tx_can.flags = flags;
 
-	memcpy(cmd->tx_can.data, cf->data, *frame_len);
+	memcpy(cmd->tx_can.data, cf->data, cf->len);
 
 	return cmd;
 }
@@ -2007,17 +2003,17 @@ static void kvaser_usb_hydra_read_bulk_callback(struct kvaser_usb *dev,
 
 static void *
 kvaser_usb_hydra_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
-			      const struct sk_buff *skb, int *frame_len,
-			      int *cmd_len, u16 transid)
+			      const struct sk_buff *skb, int *cmd_len,
+			      u16 transid)
 {
 	void *buf;
 
 	if (priv->dev->card_data.capabilities & KVASER_USB_HYDRA_CAP_EXT_CMD)
-		buf = kvaser_usb_hydra_frame_to_cmd_ext(priv, skb, frame_len,
-							cmd_len, transid);
+		buf = kvaser_usb_hydra_frame_to_cmd_ext(priv, skb, cmd_len,
+							transid);
 	else
-		buf = kvaser_usb_hydra_frame_to_cmd_std(priv, skb, frame_len,
-							cmd_len, transid);
+		buf = kvaser_usb_hydra_frame_to_cmd_std(priv, skb, cmd_len,
+							transid);
 
 	return buf;
 }
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 14b445643554..47fa7f5a11c6 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -342,16 +342,14 @@ struct kvaser_usb_err_summary {
 
 static void *
 kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
-			     const struct sk_buff *skb, int *frame_len,
-			     int *cmd_len, u16 transid)
+			     const struct sk_buff *skb, int *cmd_len,
+			     u16 transid)
 {
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_cmd *cmd;
 	u8 *cmd_tx_can_flags = NULL;		/* GCC */
 	struct can_frame *cf = (struct can_frame *)skb->data;
 
-	*frame_len = cf->len;
-
 	cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
 	if (cmd) {
 		cmd->u.tx_can.tid = transid & 0xff;
@@ -587,12 +585,11 @@ static void kvaser_usb_leaf_tx_acknowledge(const struct kvaser_usb *dev,
 		priv->can.state = CAN_STATE_ERROR_ACTIVE;
 	}
 
-	stats->tx_packets++;
-	stats->tx_bytes += context->dlc;
-
 	spin_lock_irqsave(&priv->tx_contexts_lock, flags);
 
-	can_get_echo_skb(priv->netdev, context->echo_index, NULL);
+	stats->tx_packets++;
+	stats->tx_bytes += can_get_echo_skb(priv->netdev,
+					    context->echo_index, NULL);
 	context->echo_index = dev->max_tx_urbs;
 	--priv->active_tx_contexts;
 	netif_wake_queue(priv->netdev);
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 4d20ea860ea8..77bddff86252 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -64,7 +64,6 @@
 struct mcba_usb_ctx {
 	struct mcba_priv *priv;
 	u32 ndx;
-	u8 dlc;
 	bool can;
 };
 
@@ -184,13 +183,10 @@ static inline struct mcba_usb_ctx *mcba_usb_get_free_ctx(struct mcba_priv *priv,
 			ctx = &priv->tx_context[i];
 			ctx->ndx = i;
 
-			if (cf) {
+			if (cf)
 				ctx->can = true;
-				ctx->dlc = cf->len;
-			} else {
+			else
 				ctx->can = false;
-				ctx->dlc = 0;
-			}
 
 			atomic_dec(&priv->free_ctx_cnt);
 			break;
@@ -236,10 +232,10 @@ static void mcba_usb_write_bulk_callback(struct urb *urb)
 			return;
 
 		netdev->stats.tx_packets++;
-		netdev->stats.tx_bytes += ctx->dlc;
+		netdev->stats.tx_bytes += can_get_echo_skb(netdev, ctx->ndx,
+							   NULL);
 
 		can_led_event(netdev, CAN_LED_EVENT_TX);
-		can_get_echo_skb(netdev, ctx->ndx, NULL);
 	}
 
 	if (urb->status)
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 6107fef9f4a0..b850ff8fe4bd 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -291,6 +291,7 @@ static void peak_usb_write_bulk_callback(struct urb *urb)
 	struct peak_tx_urb_context *context = urb->context;
 	struct peak_usb_device *dev;
 	struct net_device *netdev;
+	int tx_bytes;
 
 	BUG_ON(!context);
 
@@ -305,10 +306,6 @@ static void peak_usb_write_bulk_callback(struct urb *urb)
 	/* check tx status */
 	switch (urb->status) {
 	case 0:
-		/* transmission complete */
-		netdev->stats.tx_packets++;
-		netdev->stats.tx_bytes += context->data_len;
-
 		/* prevent tx timeout */
 		netif_trans_update(netdev);
 		break;
@@ -327,12 +324,17 @@ static void peak_usb_write_bulk_callback(struct urb *urb)
 	}
 
 	/* should always release echo skb and corresponding context */
-	can_get_echo_skb(netdev, context->echo_index, NULL);
+	tx_bytes = can_get_echo_skb(netdev, context->echo_index, NULL);
 	context->echo_index = PCAN_USB_MAX_TX_URBS;
 
-	/* do wakeup tx queue in case of success only */
-	if (!urb->status)
+	if (!urb->status) {
+		/* transmission complete */
+		netdev->stats.tx_packets++;
+		netdev->stats.tx_bytes += tx_bytes;
+
+		/* do wakeup tx queue in case of success only */
 		netif_wake_queue(netdev);
+	}
 }
 
 /*
@@ -344,7 +346,6 @@ static netdev_tx_t peak_usb_ndo_start_xmit(struct sk_buff *skb,
 	struct peak_usb_device *dev = netdev_priv(netdev);
 	struct peak_tx_urb_context *context = NULL;
 	struct net_device_stats *stats = &netdev->stats;
-	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 	struct urb *urb;
 	u8 *obuf;
 	int i, err;
@@ -378,9 +379,6 @@ static netdev_tx_t peak_usb_ndo_start_xmit(struct sk_buff *skb,
 
 	context->echo_index = i;
 
-	/* Note: this works with CANFD frames too */
-	context->data_len = cfd->len;
-
 	usb_anchor_urb(urb, &dev->tx_submitted);
 
 	can_put_echo_skb(skb, netdev, context->echo_index, 0);
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.h b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
index daa19f57e742..f60af573a2e0 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.h
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
@@ -99,7 +99,6 @@ struct peak_time_ref {
 struct peak_tx_urb_context {
 	struct peak_usb_device *dev;
 	u32 echo_index;
-	u8 data_len;
 	struct urb *urb;
 };
 
diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 388899019955..c7c41d1fd038 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -259,7 +259,6 @@ struct ucan_priv;
 /* Context Information for transmission URBs */
 struct ucan_urb_context {
 	struct ucan_priv *up;
-	u8 dlc;
 	bool allocated;
 };
 
@@ -637,7 +636,7 @@ static void ucan_tx_complete_msg(struct ucan_priv *up,
 {
 	unsigned long flags;
 	u16 count, i;
-	u8 echo_index, dlc;
+	u8 echo_index;
 	u16 len = le16_to_cpu(m->len);
 
 	struct ucan_urb_context *context;
@@ -661,7 +660,6 @@ static void ucan_tx_complete_msg(struct ucan_priv *up,
 
 		/* gather information from the context */
 		context = &up->context_array[echo_index];
-		dlc = READ_ONCE(context->dlc);
 
 		/* Release context and restart queue if necessary.
 		 * Also check if the context was allocated
@@ -674,8 +672,8 @@ static void ucan_tx_complete_msg(struct ucan_priv *up,
 		    UCAN_TX_COMPLETE_SUCCESS) {
 			/* update statistics */
 			up->netdev->stats.tx_packets++;
-			up->netdev->stats.tx_bytes += dlc;
-			can_get_echo_skb(up->netdev, echo_index, NULL);
+			up->netdev->stats.tx_bytes +=
+				can_get_echo_skb(up->netdev, echo_index, NULL);
 		} else {
 			up->netdev->stats.tx_dropped++;
 			can_free_echo_skb(up->netdev, echo_index, NULL);
@@ -1089,8 +1087,6 @@ static struct urb *ucan_prepare_tx_urb(struct ucan_priv *up,
 	}
 	m->len = cpu_to_le16(mlen);
 
-	context->dlc = cf->len;
-
 	m->subtype = echo_index;
 
 	/* build the urb */
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 23cdc92fb007..3127a81f6c8c 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -114,7 +114,6 @@ struct usb_8dev_tx_urb_context {
 	struct usb_8dev_priv *priv;
 
 	u32 echo_index;
-	u8 dlc;
 };
 
 /* Structure to hold all of our device specific stuff */
@@ -583,9 +582,7 @@ static void usb_8dev_write_bulk_callback(struct urb *urb)
 			 urb->status);
 
 	netdev->stats.tx_packets++;
-	netdev->stats.tx_bytes += context->dlc;
-
-	can_get_echo_skb(netdev, context->echo_index, NULL);
+	netdev->stats.tx_bytes += can_get_echo_skb(netdev, context->echo_index, NULL);
 
 	can_led_event(netdev, CAN_LED_EVENT_TX);
 
@@ -656,7 +653,6 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 
 	context->priv = priv;
 	context->echo_index = i;
-	context->dlc = cf->len;
 
 	usb_fill_bulk_urb(urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, USB_8DEV_ENDP_DATA_TX),
diff --git a/drivers/net/can/vcan.c b/drivers/net/can/vcan.c
index 067705e2850b..c42f18845b02 100644
--- a/drivers/net/can/vcan.c
+++ b/drivers/net/can/vcan.c
@@ -87,13 +87,14 @@ static netdev_tx_t vcan_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 	struct net_device_stats *stats = &dev->stats;
-	int loop;
+	int loop, len;
 
 	if (can_dropped_invalid_skb(dev, skb))
 		return NETDEV_TX_OK;
 
+	len = cfd->can_id & CAN_RTR_FLAG ? 0 : cfd->len;
 	stats->tx_packets++;
-	stats->tx_bytes += cfd->len;
+	stats->tx_bytes += len;
 
 	/* set flag whether this packet has to be looped back */
 	loop = skb->pkt_type == PACKET_LOOPBACK;
@@ -105,7 +106,7 @@ static netdev_tx_t vcan_tx(struct sk_buff *skb, struct net_device *dev)
 			 * CAN core already did the echo for us
 			 */
 			stats->rx_packets++;
-			stats->rx_bytes += cfd->len;
+			stats->rx_bytes += len;
 		}
 		consume_skb(skb);
 		return NETDEV_TX_OK;
diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index 8861a7d875e7..47ccc15a3486 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -62,7 +62,7 @@ static netdev_tx_t vxcan_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb->dev        = peer;
 	skb->ip_summed  = CHECKSUM_UNNECESSARY;
 
-	len = cfd->len;
+	len = cfd->can_id & CAN_RTR_FLAG ? 0 : cfd->len;
 	if (netif_rx_ni(skb) == NET_RX_SUCCESS) {
 		srcstats->tx_packets++;
 		srcstats->tx_bytes += len;
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index d311bc369a39..fdb22b00674a 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -21,8 +21,9 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 		     unsigned int idx, unsigned int frame_len);
 struct sk_buff *__can_get_echo_skb(struct net_device *dev, unsigned int idx,
 				   u8 *len_ptr, unsigned int *frame_len_ptr);
-unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx,
-			      unsigned int *frame_len_ptr);
+unsigned int __must_check can_get_echo_skb(struct net_device *dev,
+					   unsigned int idx,
+					   unsigned int *frame_len_ptr);
 void can_free_echo_skb(struct net_device *dev, unsigned int idx,
 		       unsigned int *frame_len_ptr);
 struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf);
-- 
2.32.0

