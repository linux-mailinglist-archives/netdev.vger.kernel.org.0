Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3934854F0
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbiAEOop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241057AbiAEOoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:44:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47448C061394
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:44:27 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n57Wb-0004Uw-Jd
        for netdev@vger.kernel.org; Wed, 05 Jan 2022 15:44:25 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4FD586D1B56
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 14:44:15 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0EC606D1ACC;
        Wed,  5 Jan 2022 14:44:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a8c38642;
        Wed, 5 Jan 2022 14:44:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Jimmy Assarsson <extja@kvaser.com>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
Subject: [PATCH net-next 10/15] can: do not increase rx_bytes statistics for RTR frames
Date:   Wed,  5 Jan 2022 15:43:57 +0100
Message-Id: <20220105144402.1174191-11-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105144402.1174191-1-mkl@pengutronix.de>
References: <20220105144402.1174191-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The actual payload length of the CAN Remote Transmission Request (RTR)
frames is always 0, i.e. no payload is transmitted on the wire.
However, those RTR frames still use the DLC to indicate the length of
the requested frame.

As such, net_device_stats::rx_bytes should not be increased for the
RTR frames.

This patch fixes all the CAN drivers.

Link: https://lore.kernel.org/all/20211207121531.42941-5-mailhol.vincent@wanadoo.fr
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: Yasushi SHOJI <yashi@spacecubics.com>
Cc: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Cc: Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Stephane Grosjean <s.grosjean@peak-system.com>
Tested-by: Jimmy Assarsson <extja@kvaser.com> # kvaser
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Acked-by: Stefan Mätje <stefan.maetje@esd.eu> # esd_usb2
Tested-by: Stefan Mätje <stefan.maetje@esd.eu> # esd_usb2
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/at91_can.c                       |  4 +++-
 drivers/net/can/c_can/c_can_main.c               |  4 ++--
 drivers/net/can/cc770/cc770.c                    |  5 +++--
 drivers/net/can/dev/rx-offload.c                 |  3 ++-
 drivers/net/can/grcan.c                          |  6 +++---
 drivers/net/can/ifi_canfd/ifi_canfd.c            |  6 +++---
 drivers/net/can/janz-ican3.c                     |  3 ++-
 drivers/net/can/kvaser_pciefd.c                  | 11 ++++++-----
 drivers/net/can/m_can/m_can.c                    |  6 +++---
 drivers/net/can/mscan/mscan.c                    |  3 ++-
 drivers/net/can/pch_can.c                        |  6 +++---
 drivers/net/can/peak_canfd/peak_canfd.c          |  7 ++++---
 drivers/net/can/rcar/rcar_can.c                  |  5 +++--
 drivers/net/can/rcar/rcar_canfd.c                |  3 ++-
 drivers/net/can/sja1000/sja1000.c                |  5 +++--
 drivers/net/can/slcan.c                          |  4 +++-
 drivers/net/can/spi/hi311x.c                     |  7 ++++---
 drivers/net/can/spi/mcp251x.c                    |  5 +++--
 drivers/net/can/sun4i_can.c                      | 10 ++++++----
 drivers/net/can/usb/ems_usb.c                    |  5 +++--
 drivers/net/can/usb/esd_usb2.c                   |  5 +++--
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c    | 16 ++++++++++------
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c |  3 ++-
 drivers/net/can/usb/mcba_usb.c                   |  7 ++++---
 drivers/net/can/usb/peak_usb/pcan_usb.c          |  7 ++++---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c       |  8 ++++----
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c      | 10 ++++++----
 drivers/net/can/usb/ucan.c                       |  3 ++-
 drivers/net/can/usb/usb_8dev.c                   |  9 +++++----
 drivers/net/can/xilinx_can.c                     | 10 +++++++---
 30 files changed, 110 insertions(+), 76 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 3cd872cf9be6..97f1d08b4133 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -617,7 +617,9 @@ static void at91_read_msg(struct net_device *dev, unsigned int mb)
 	at91_read_mb(dev, mb, cf);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
+
 	netif_receive_skb(skb);
 
 	can_led_event(dev, CAN_LED_EVENT_RX);
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index 670754a12984..29e91804d81c 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -403,10 +403,10 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, u32 ctrl)
 				frame->data[i + 1] = data >> 8;
 			}
 		}
-	}
 
+		stats->rx_bytes += frame->len;
+	}
 	stats->rx_packets++;
-	stats->rx_bytes += frame->len;
 
 	netif_receive_skb(skb);
 	return 0;
diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
index a5fd8ccedec2..994073c0a2f6 100644
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -489,10 +489,11 @@ static void cc770_rx(struct net_device *dev, unsigned int mo, u8 ctrl1)
 		cf->len = can_cc_dlc2len((config & 0xf0) >> 4);
 		for (i = 0; i < cf->len; i++)
 			cf->data[i] = cc770_read_reg(priv, msgobj[mo].data[i]);
-	}
 
+		stats->rx_bytes += cf->len;
+	}
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/can/dev/rx-offload.c b/drivers/net/can/dev/rx-offload.c
index 7dbf46b9ca5d..7f80d8e1e750 100644
--- a/drivers/net/can/dev/rx-offload.c
+++ b/drivers/net/can/dev/rx-offload.c
@@ -56,7 +56,8 @@ static int can_rx_offload_napi_poll(struct napi_struct *napi, int quota)
 		work_done++;
 		if (!(cf->can_id & CAN_ERR_FLAG)) {
 			stats->rx_packets++;
-			stats->rx_bytes += cf->len;
+			if (!(cf->can_id & CAN_RTR_FLAG))
+				stats->rx_bytes += cf->len;
 		}
 		netif_receive_skb(skb);
 	}
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 78e27940b2af..1b8ef97e4139 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1211,11 +1211,11 @@ static int grcan_receive(struct net_device *dev, int budget)
 				shift = GRCAN_MSG_DATA_SHIFT(i);
 				cf->data[i] = (u8)(slot[j] >> shift);
 			}
-		}
 
-		/* Update statistics and read pointer */
+			stats->rx_bytes += cf->len;
+		}
 		stats->rx_packets++;
-		stats->rx_bytes += cf->len;
+
 		netif_receive_skb(skb);
 
 		rd = grcan_ring_add(rd, GRCAN_MSG_SIZE, dma->rx.size);
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index e8318e984bf2..b0a3473f211d 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -309,15 +309,15 @@ static void ifi_canfd_read_fifo(struct net_device *ndev)
 			*(u32 *)(cf->data + i) =
 				readl(priv->base + IFI_CANFD_RXFIFO_DATA + i);
 		}
+
+		stats->rx_bytes += cf->len;
 	}
+	stats->rx_packets++;
 
 	/* Remove the packet from FIFO */
 	writel(IFI_CANFD_RXSTCMD_REMOVE_MSG, priv->base + IFI_CANFD_RXSTCMD);
 	writel(rx_irq_mask, priv->base + IFI_CANFD_INTERRUPT);
 
-	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
-
 	netif_receive_skb(skb);
 }
 
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 32006dbf5abd..5c589aa9dff8 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1421,7 +1421,8 @@ static int ican3_recv_skb(struct ican3_dev *mod)
 
 	/* update statistics, receive the skb */
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 err_noalloc:
diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index ab672c92ab07..017f2d36ffc3 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1185,20 +1185,21 @@ static int kvaser_pciefd_handle_data_packet(struct kvaser_pciefd *pcie,
 
 	cf->len = can_fd_dlc2len(p->header[1] >> KVASER_PCIEFD_RPACKET_DLC_SHIFT);
 
-	if (p->header[0] & KVASER_PCIEFD_RPACKET_RTR)
+	if (p->header[0] & KVASER_PCIEFD_RPACKET_RTR) {
 		cf->can_id |= CAN_RTR_FLAG;
-	else
+	} else {
 		memcpy(cf->data, data, cf->len);
 
+		stats->rx_bytes += cf->len;
+	}
+	stats->rx_packets++;
+
 	shhwtstamps = skb_hwtstamps(skb);
 
 	shhwtstamps->hwtstamp =
 		ns_to_ktime(div_u64(p->timestamp * 1000,
 				    pcie->freq_to_ticks_div));
 
-	stats->rx_bytes += cf->len;
-	stats->rx_packets++;
-
 	return netif_rx(skb);
 }
 
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 30d94cb43113..ae2349420983 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -518,14 +518,14 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 				      cf->data, DIV_ROUND_UP(cf->len, 4));
 		if (err)
 			goto out_free_skb;
+
+		stats->rx_bytes += cf->len;
 	}
+	stats->rx_packets++;
 
 	/* acknowledge rx fifo 0 */
 	m_can_write(cdev, M_CAN_RXF0A, fgi);
 
-	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
-
 	timestamp = FIELD_GET(RX_BUF_RXTS_MASK, fifo_header.dlc);
 
 	m_can_receive_skb(cdev, skb, timestamp);
diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index 9e1cce0260da..59b8284d00e5 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -404,7 +404,8 @@ static int mscan_rx_poll(struct napi_struct *napi, int quota)
 		if (canrflg & MSCAN_RXF) {
 			mscan_get_rx_frame(dev, frame);
 			stats->rx_packets++;
-			stats->rx_bytes += frame->len;
+			if (!(frame->can_id & CAN_RTR_FLAG))
+				stats->rx_bytes += frame->len;
 		} else if (canrflg & MSCAN_ERR_IF) {
 			mscan_get_err_frame(dev, frame, canrflg);
 		}
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 4bf9bfc4de72..b46f9cfb9e0a 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -688,12 +688,12 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 				cf->data[i] = data_reg;
 				cf->data[i + 1] = data_reg >> 8;
 			}
-		}
 
-		rcv_pkts++;
+			stats->rx_bytes += cf->len;
+		}
 		stats->rx_packets++;
+		rcv_pkts++;
 		quota--;
-		stats->rx_bytes += cf->len;
 		netif_receive_skb(skb);
 
 		pch_fifo_thresh(priv, obj_num);
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index d5b8bc6d2980..216609198eac 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -310,12 +310,13 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
 	if (rx_msg_flags & PUCAN_MSG_EXT_ID)
 		cf->can_id |= CAN_EFF_FLAG;
 
-	if (rx_msg_flags & PUCAN_MSG_RTR)
+	if (rx_msg_flags & PUCAN_MSG_RTR) {
 		cf->can_id |= CAN_RTR_FLAG;
-	else
+	} else {
 		memcpy(cf->data, msg->d, cf->len);
 
-	stats->rx_bytes += cf->len;
+		stats->rx_bytes += cf->len;
+	}
 	stats->rx_packets++;
 
 	pucan_netif_rx(skb, msg->ts_low, msg->ts_high);
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index f408ed9a6ccd..62bbd58bfef8 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -662,12 +662,13 @@ static void rcar_can_rx_pkt(struct rcar_can_priv *priv)
 		for (dlc = 0; dlc < cf->len; dlc++)
 			cf->data[dlc] =
 			readb(&priv->regs->mb[RCAR_CAN_RX_FIFO_MBX].data[dlc]);
+
+		stats->rx_bytes += cf->len;
 	}
+	stats->rx_packets++;
 
 	can_led_event(priv->ndev, CAN_LED_EVENT_RX);
 
-	stats->rx_bytes += cf->len;
-	stats->rx_packets++;
 	netif_receive_skb(skb);
 }
 
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index db9d62874e15..b1eded2f2c5d 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1550,7 +1550,8 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 
 	can_led_event(priv->ndev, CAN_LED_EVENT_RX);
 
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	stats->rx_packets++;
 	netif_receive_skb(skb);
 }
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index a65546ca9461..4bf44d449987 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -372,15 +372,16 @@ static void sja1000_rx(struct net_device *dev)
 	} else {
 		for (i = 0; i < cf->len; i++)
 			cf->data[i] = priv->read_reg(priv, dreg++);
+
+		stats->rx_bytes += cf->len;
 	}
+	stats->rx_packets++;
 
 	cf->can_id = id;
 
 	/* release receive buffer */
 	sja1000_write_cmdreg(priv, CMD_RRB);
 
-	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	can_led_event(dev, CAN_LED_EVENT_RX);
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 9a4ebda30510..5cf03458e948 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -218,7 +218,9 @@ static void slc_bump(struct slcan *sl)
 	skb_put_data(skb, &cf, sizeof(struct can_frame));
 
 	sl->dev->stats.rx_packets++;
-	sl->dev->stats.rx_bytes += cf.len;
+	if (!(cf.can_id & CAN_RTR_FLAG))
+		sl->dev->stats.rx_bytes += cf.len;
+
 	netif_rx_ni(skb);
 }
 
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index a17641d36468..506625082b84 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -343,14 +343,15 @@ static void hi3110_hw_rx(struct spi_device *spi)
 	/* Data length */
 	frame->len = can_cc_dlc2len(buf[HI3110_FIFO_WOTIME_DLC_OFF] & 0x0F);
 
-	if (buf[HI3110_FIFO_WOTIME_ID_OFF + 3] & HI3110_FIFO_WOTIME_ID_RTR)
+	if (buf[HI3110_FIFO_WOTIME_ID_OFF + 3] & HI3110_FIFO_WOTIME_ID_RTR) {
 		frame->can_id |= CAN_RTR_FLAG;
-	else
+	} else {
 		memcpy(frame->data, buf + HI3110_FIFO_WOTIME_DAT_OFF,
 		       frame->len);
 
+		priv->net->stats.rx_bytes += frame->len;
+	}
 	priv->net->stats.rx_packets++;
-	priv->net->stats.rx_bytes += frame->len;
 
 	can_led_event(priv->net, CAN_LED_EVENT_RX);
 
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 2fa1e85fa529..0da965da32cb 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -730,11 +730,12 @@ static void mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
 	}
 	/* Data length */
 	frame->len = can_cc_dlc2len(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
-	if (!(frame->can_id & CAN_RTR_FLAG))
+	if (!(frame->can_id & CAN_RTR_FLAG)) {
 		memcpy(frame->data, buf + RXBDAT_OFF, frame->len);
 
+		priv->net->stats.rx_bytes += frame->len;
+	}
 	priv->net->stats.rx_packets++;
-	priv->net->stats.rx_bytes += frame->len;
 
 	can_led_event(priv->net, CAN_LED_EVENT_RX);
 
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index a2d8d77d11ef..e18868a43ce8 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -501,18 +501,20 @@ static void sun4i_can_rx(struct net_device *dev)
 	}
 
 	/* remote frame ? */
-	if (fi & SUN4I_MSG_RTR_FLAG)
+	if (fi & SUN4I_MSG_RTR_FLAG) {
 		id |= CAN_RTR_FLAG;
-	else
+	} else {
 		for (i = 0; i < cf->len; i++)
 			cf->data[i] = readl(priv->base + dreg + i * 4);
 
+		stats->rx_bytes += cf->len;
+	}
+	stats->rx_packets++;
+
 	cf->can_id = id;
 
 	sun4i_can_write_cmdreg(priv, SUN4I_CMD_RELEASE_RBUF);
 
-	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	can_led_event(dev, CAN_LED_EVENT_RX);
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 7cf65936d02e..c9b6adf5c1ec 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -320,10 +320,11 @@ static void ems_usb_rx_can_msg(struct ems_usb *dev, struct ems_cpc_msg *msg)
 	} else {
 		for (i = 0; i < cf->len; i++)
 			cf->data[i] = msg->msg.can_msg.msg[i];
-	}
 
+		stats->rx_bytes += cf->len;
+	}
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 5f6915a27b3d..9ac7ee44b6e3 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -332,10 +332,11 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
 		} else {
 			for (i = 0; i < cf->len; i++)
 				cf->data[i] = msg->msg.rx.data[i];
-		}
 
+			stats->rx_bytes += cf->len;
+		}
 		stats->rx_packets++;
-		stats->rx_bytes += cf->len;
+
 		netif_rx(skb);
 	}
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 60e7c5f27a5f..bc902da9c6eb 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1206,13 +1206,15 @@ static void kvaser_usb_hydra_rx_msg_std(const struct kvaser_usb *dev,
 
 	cf->len = can_cc_dlc2len(cmd->rx_can.dlc);
 
-	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME)
+	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME) {
 		cf->can_id |= CAN_RTR_FLAG;
-	else
+	} else {
 		memcpy(cf->data, cmd->rx_can.data, cf->len);
 
+		stats->rx_bytes += cf->len;
+	}
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+
 	netif_rx(skb);
 }
 
@@ -1284,13 +1286,15 @@ static void kvaser_usb_hydra_rx_msg_ext(const struct kvaser_usb *dev,
 		cf->len = can_cc_dlc2len(dlc);
 	}
 
-	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME)
+	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME) {
 		cf->can_id |= CAN_RTR_FLAG;
-	else
+	} else {
 		memcpy(cf->data, cmd->rx_can.kcan_payload, cf->len);
 
+		stats->rx_bytes += cf->len;
+	}
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index d7e8e9b8a7c3..891271af7616 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1068,7 +1068,8 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 162d2e11cadd..4d20ea860ea8 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -452,13 +452,14 @@ static void mcba_usb_process_can(struct mcba_priv *priv,
 
 	cf->len = can_cc_dlc2len(msg->dlc & MCBA_DLC_MASK);
 
-	if (msg->dlc & MCBA_DLC_RTR_MASK)
+	if (msg->dlc & MCBA_DLC_RTR_MASK) {
 		cf->can_id |= CAN_RTR_FLAG;
-	else
+	} else {
 		memcpy(cf->data, msg->data, cf->len);
 
+		stats->rx_bytes += cf->len;
+	}
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
 
 	can_led_event(priv->netdev, CAN_LED_EVENT_RX);
 	netif_rx(skb);
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index a59417827168..17dc178f555b 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -677,15 +677,16 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		/* Ignore next byte (client private id) if SRR bit is set */
 		if (can_id_flags & PCAN_USB_TX_SRR)
 			mc->ptr++;
+
+		/* update statistics */
+		mc->netdev->stats.rx_bytes += cf->len;
 	}
+	mc->netdev->stats.rx_packets++;
 
 	/* convert timestamp into kernel time */
 	hwts = skb_hwtstamps(skb);
 	peak_usb_get_ts_time(&mc->pdev->time_ref, mc->ts16, &hwts->hwtstamp);
 
-	/* update statistics */
-	mc->netdev->stats.rx_packets++;
-	mc->netdev->stats.rx_bytes += cf->len;
 	/* push the skb */
 	netif_rx(skb);
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 185f5a98d217..65487ec33566 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -507,13 +507,13 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 	if (rx_msg_flags & PUCAN_MSG_EXT_ID)
 		cfd->can_id |= CAN_EFF_FLAG;
 
-	if (rx_msg_flags & PUCAN_MSG_RTR)
+	if (rx_msg_flags & PUCAN_MSG_RTR) {
 		cfd->can_id |= CAN_RTR_FLAG;
-	else
+	} else {
 		memcpy(cfd->data, rm->d, cfd->len);
-
+		netdev->stats.rx_bytes += cfd->len;
+	}
 	netdev->stats.rx_packets++;
-	netdev->stats.rx_bytes += cfd->len;
 
 	peak_usb_netif_rx_64(skb, le32_to_cpu(rm->ts_low),
 			     le32_to_cpu(rm->ts_high));
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index f6d19879bf40..ebe087f258e3 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -536,17 +536,19 @@ static int pcan_usb_pro_handle_canmsg(struct pcan_usb_pro_interface *usb_if,
 	if (rx->flags & PCAN_USBPRO_EXT)
 		can_frame->can_id |= CAN_EFF_FLAG;
 
-	if (rx->flags & PCAN_USBPRO_RTR)
+	if (rx->flags & PCAN_USBPRO_RTR) {
 		can_frame->can_id |= CAN_RTR_FLAG;
-	else
+	} else {
 		memcpy(can_frame->data, rx->data, can_frame->len);
 
+		netdev->stats.rx_bytes += can_frame->len;
+	}
+	netdev->stats.rx_packets++;
+
 	hwts = skb_hwtstamps(skb);
 	peak_usb_get_ts_time(&usb_if->time_ref, le32_to_cpu(rx->ts32),
 			     &hwts->hwtstamp);
 
-	netdev->stats.rx_packets++;
-	netdev->stats.rx_bytes += can_frame->len;
 	netif_rx(skb);
 
 	return 0;
diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index d582c39fc8d0..388899019955 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -623,7 +623,8 @@ static void ucan_rx_can_msg(struct ucan_priv *up, struct ucan_message_in *m)
 	/* don't count error frames as real packets */
 	if (!(cf->can_id & CAN_ERR_FLAG)) {
 		stats->rx_packets++;
-		stats->rx_bytes += cf->len;
+		if (!(cf->can_id & CAN_RTR_FLAG))
+			stats->rx_bytes += cf->len;
 	}
 
 	/* pass it to Linux */
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index c81ca5e81446..d0ef1478cf0a 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -472,13 +472,14 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
 		if (msg->flags & USB_8DEV_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
-		if (msg->flags & USB_8DEV_RTR)
+		if (msg->flags & USB_8DEV_RTR) {
 			cf->can_id |= CAN_RTR_FLAG;
-		else
+		} else {
 			memcpy(cf->data, msg->data, cf->len);
-
+			stats->rx_bytes += cf->len;
+		}
 		stats->rx_packets++;
-		stats->rx_bytes += cf->len;
+
 		netif_rx(skb);
 
 		can_led_event(priv->netdev, CAN_LED_EVENT_RX);
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 275e240ab293..ffca1cd3b384 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -787,10 +787,11 @@ static int xcan_rx(struct net_device *ndev, int frame_base)
 			*(__be32 *)(cf->data) = cpu_to_be32(data[0]);
 		if (cf->len > 4)
 			*(__be32 *)(cf->data + 4) = cpu_to_be32(data[1]);
-	}
 
-	stats->rx_bytes += cf->len;
+		stats->rx_bytes += cf->len;
+	}
 	stats->rx_packets++;
+
 	netif_receive_skb(skb);
 
 	return 1;
@@ -871,8 +872,11 @@ static int xcanfd_rx(struct net_device *ndev, int frame_base)
 			*(__be32 *)(cf->data + i) = cpu_to_be32(data[0]);
 		}
 	}
-	stats->rx_bytes += cf->len;
+
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	stats->rx_packets++;
+
 	netif_receive_skb(skb);
 
 	return 1;
-- 
2.34.1


