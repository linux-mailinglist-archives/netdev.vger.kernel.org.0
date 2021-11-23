Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E125E45A205
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbhKWL5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:57:36 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:52755 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbhKWL5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 06:57:35 -0500
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id pUMhmyepO2lVYpUNRmeiBM; Tue, 23 Nov 2021 12:54:27 +0100
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Tue, 23 Nov 2021 12:54:27 +0100
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jimmy Assarsson <extja@kvaser.com>,
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
        Stephane Grosjean <s.grosjean@peak-system.com>
Subject: [PATCH v1 2/2] can: do not increase rx_bytes statistics for RTR frames
Date:   Tue, 23 Nov 2021 20:53:33 +0900
Message-Id: <20211123115333.624335-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123115333.624335-1-mailhol.vincent@wanadoo.fr>
References: <20211123115333.624335-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The actual payload length of the CAN Remote Transmission Request (RTR)
frames is always 0, i.e. nothing is transmitted on the wire. However,
those RTR frames still uses the DLC to indicate the length of the
requested frame.

As such, net_device_stats:rx_bytes should not be increased for the RTR
frames.

This patch fixes all the CAN drivers.

CC: Jimmy Assarsson <extja@kvaser.com>
CC: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Nicolas Ferre <nicolas.ferre@microchip.com>
CC: Alexandre Belloni <alexandre.belloni@bootlin.com>
CC: Ludovic Desroches <ludovic.desroches@microchip.com>
CC: Chandrasekar Ramakrishnan <rcsekar@samsung.com>
CC: Maxime Ripard <mripard@kernel.org>
CC: Chen-Yu Tsai <wens@csie.org>
CC: Jernej Skrabec <jernej.skrabec@gmail.com>
CC: Yasushi SHOJI <yashi@spacecubics.com>
CC: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
CC: Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>
CC: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/at91_can.c                        | 3 ++-
 drivers/net/can/c_can/c_can_main.c                | 3 ++-
 drivers/net/can/cc770/cc770.c                     | 3 ++-
 drivers/net/can/dev/rx-offload.c                  | 3 ++-
 drivers/net/can/grcan.c                           | 3 ++-
 drivers/net/can/ifi_canfd/ifi_canfd.c             | 3 ++-
 drivers/net/can/janz-ican3.c                      | 3 ++-
 drivers/net/can/kvaser_pciefd.c                   | 3 ++-
 drivers/net/can/m_can/m_can.c                     | 3 ++-
 drivers/net/can/mscan/mscan.c                     | 3 ++-
 drivers/net/can/pch_can.c                         | 3 ++-
 drivers/net/can/peak_canfd/peak_canfd.c           | 3 ++-
 drivers/net/can/rcar/rcar_can.c                   | 3 ++-
 drivers/net/can/rcar/rcar_canfd.c                 | 3 ++-
 drivers/net/can/sja1000/sja1000.c                 | 3 ++-
 drivers/net/can/slcan.c                           | 3 ++-
 drivers/net/can/spi/hi311x.c                      | 3 ++-
 drivers/net/can/spi/mcp251x.c                     | 3 ++-
 drivers/net/can/sun4i_can.c                       | 3 ++-
 drivers/net/can/usb/ems_usb.c                     | 3 ++-
 drivers/net/can/usb/esd_usb2.c                    | 3 ++-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 6 ++++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 3 ++-
 drivers/net/can/usb/mcba_usb.c                    | 3 ++-
 drivers/net/can/usb/peak_usb/pcan_usb.c           | 3 ++-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c        | 8 ++++----
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c       | 9 +++++----
 drivers/net/can/usb/ucan.c                        | 3 ++-
 drivers/net/can/usb/usb_8dev.c                    | 8 ++++----
 drivers/net/can/xilinx_can.c                      | 8 +++++---
 30 files changed, 72 insertions(+), 42 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 3cd872cf9be6..89b22c3f9a01 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -617,7 +617,8 @@ static void at91_read_msg(struct net_device *dev, unsigned int mb)
 	at91_read_mb(dev, mb, cf);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	can_led_event(dev, CAN_LED_EVENT_RX);
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index 670754a12984..f2eb9ebc875f 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -406,7 +406,8 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, u32 ctrl)
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += frame->len;
+	if (!(frame->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += frame->len;
 
 	netif_receive_skb(skb);
 	return 0;
diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
index a5fd8ccedec2..7c703bcbb433 100644
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -492,7 +492,8 @@ static void cc770_rx(struct net_device *dev, unsigned int mo, u8 ctrl1)
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/can/dev/rx-offload.c b/drivers/net/can/dev/rx-offload.c
index bb47e9a49240..b10b73e5ed87 100644
--- a/drivers/net/can/dev/rx-offload.c
+++ b/drivers/net/can/dev/rx-offload.c
@@ -56,7 +56,8 @@ static int can_rx_offload_napi_poll(struct napi_struct *napi, int quota)
 		work_done++;
 		if (!(cf->can_id & CAN_ERR_MASK)) {
 			stats->rx_packets++;
-			stats->rx_bytes += cf->len;
+			if (!(cf->can_id & CAN_RTR_FLAG))
+				stats->rx_bytes += cf->len;
 		}
 		netif_receive_skb(skb);
 	}
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 78e27940b2af..2f8a08321b41 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1215,7 +1215,8 @@ static int grcan_receive(struct net_device *dev, int budget)
 
 		/* Update statistics and read pointer */
 		stats->rx_packets++;
-		stats->rx_bytes += cf->len;
+		if (!(cf->can_id & CAN_RTR_FLAG))
+			stats->rx_bytes += cf->len;
 		netif_receive_skb(skb);
 
 		rd = grcan_ring_add(rd, GRCAN_MSG_SIZE, dma->rx.size);
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index e8318e984bf2..1f90c829321e 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -316,7 +316,8 @@ static void ifi_canfd_read_fifo(struct net_device *ndev)
 	writel(rx_irq_mask, priv->base + IFI_CANFD_INTERRUPT);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 
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
index 483fbd9e6952..88a570476500 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1193,7 +1193,8 @@ static int kvaser_pciefd_handle_data_packet(struct kvaser_pciefd *pcie,
 		ns_to_ktime(div_u64(p->timestamp * 1000,
 				    pcie->freq_to_ticks_div));
 
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	stats->rx_packets++;
 
 	return netif_rx(skb);
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index c33035e706bc..eedaf66bff31 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -524,7 +524,8 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 	m_can_write(cdev, M_CAN_RXF0A, fgi);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 
 	timestamp = FIELD_GET(RX_BUF_RXTS_MASK, fifo_header.dlc);
 
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
index 6b45840db1f9..8fbe3560216b 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -692,7 +692,8 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 		rcv_pkts++;
 		stats->rx_packets++;
 		quota--;
-		stats->rx_bytes += cf->len;
+		if (!(cf->can_id & CAN_RTR_FLAG))
+			stats->rx_bytes += cf->len;
 		netif_receive_skb(skb);
 
 		pch_fifo_thresh(priv, obj_num);
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index d5b8bc6d2980..baae39fa14fc 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -315,7 +315,8 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
 	else
 		memcpy(cf->data, msg->d, cf->len);
 
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	stats->rx_packets++;
 
 	pucan_netif_rx(skb, msg->ts_low, msg->ts_high);
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index f408ed9a6ccd..237a97cd2f78 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -666,7 +666,8 @@ static void rcar_can_rx_pkt(struct rcar_can_priv *priv)
 
 	can_led_event(priv->ndev, CAN_LED_EVENT_RX);
 
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	stats->rx_packets++;
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
index a65546ca9461..d2e444968087 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -380,7 +380,8 @@ static void sja1000_rx(struct net_device *dev)
 	sja1000_write_cmdreg(priv, CMD_RRB);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	can_led_event(dev, CAN_LED_EVENT_RX);
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 9a4ebda30510..c53ad59763e0 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -218,7 +218,8 @@ static void slc_bump(struct slcan *sl)
 	skb_put_data(skb, &cf, sizeof(struct can_frame));
 
 	sl->dev->stats.rx_packets++;
-	sl->dev->stats.rx_bytes += cf.len;
+	if (!(cf.can_id & CAN_RTR_FLAG))
+		sl->dev->stats.rx_bytes += cf.len;
 	netif_rx_ni(skb);
 }
 
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 89d9c986a229..1e2929a9521b 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -350,7 +350,8 @@ static void hi3110_hw_rx(struct spi_device *spi)
 		       frame->len);
 
 	priv->net->stats.rx_packets++;
-	priv->net->stats.rx_bytes += frame->len;
+	if (!(frame->can_id & CAN_RTR_FLAG))
+		priv->net->stats.rx_bytes += frame->len;
 
 	can_led_event(priv->net, CAN_LED_EVENT_RX);
 
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 0579ab74f728..1f47c588b69f 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -736,7 +736,8 @@ static void mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
 	memcpy(frame->data, buf + RXBDAT_OFF, frame->len);
 
 	priv->net->stats.rx_packets++;
-	priv->net->stats.rx_bytes += frame->len;
+	if (!(frame->can_id & CAN_RTR_FLAG))
+		priv->net->stats.rx_bytes += frame->len;
 
 	can_led_event(priv->net, CAN_LED_EVENT_RX);
 
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index 599174098883..cd3278e5d4f6 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -501,7 +501,8 @@ static void sun4i_can_rx(struct net_device *dev)
 	sun4i_can_write_cmdreg(priv, SUN4I_CMD_RELEASE_RBUF);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	can_led_event(dev, CAN_LED_EVENT_RX);
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 7cf65936d02e..f4288f98c006 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -323,7 +323,8 @@ static void ems_usb_rx_can_msg(struct ems_usb *dev, struct ems_cpc_msg *msg)
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 5f6915a27b3d..ac65ddfe814d 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -335,7 +335,8 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
 		}
 
 		stats->rx_packets++;
-		stats->rx_bytes += cf->len;
+		if (!(cf->can_id & CAN_RTR_FLAG))
+			stats->rx_bytes += cf->len;
 		netif_rx(skb);
 	}
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 3398da323126..adab5c2a8b99 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1206,7 +1206,8 @@ static void kvaser_usb_hydra_rx_msg_std(const struct kvaser_usb *dev,
 		memcpy(cf->data, cmd->rx_can.data, cf->len);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
@@ -1284,7 +1285,8 @@ static void kvaser_usb_hydra_rx_msg_ext(const struct kvaser_usb *dev,
 		memcpy(cf->data, cmd->rx_can.kcan_payload, cf->len);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 4aebaab9ea9c..14b445643554 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1001,7 +1001,8 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index a1a154c08b7f..372f0a5ebb9f 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -458,7 +458,8 @@ static void mcba_usb_process_can(struct mcba_priv *priv,
 	memcpy(cf->data, msg->data, cf->len);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 
 	can_led_event(priv->netdev, CAN_LED_EVENT_RX);
 	netif_rx(skb);
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 21b06a738595..d1a4f847f310 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -684,7 +684,8 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 
 	/* update statistics */
 	mc->netdev->stats.rx_packets++;
-	mc->netdev->stats.rx_bytes += cf->len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		mc->netdev->stats.rx_bytes += cf->len;
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
index f6d19879bf40..69fdddcbba98 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -536,17 +536,18 @@ static int pcan_usb_pro_handle_canmsg(struct pcan_usb_pro_interface *usb_if,
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
index 040324362b26..14ae8ed85f80 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -474,13 +474,13 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
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
 		netif_rx(skb);
 
 		can_led_event(priv->netdev, CAN_LED_EVENT_RX);
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 275e240ab293..7d7239ec9920 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -787,9 +787,9 @@ static int xcan_rx(struct net_device *ndev, int frame_base)
 			*(__be32 *)(cf->data) = cpu_to_be32(data[0]);
 		if (cf->len > 4)
 			*(__be32 *)(cf->data + 4) = cpu_to_be32(data[1]);
-	}
 
-	stats->rx_bytes += cf->len;
+		stats->rx_bytes += cf->len;
+	}
 	stats->rx_packets++;
 	netif_receive_skb(skb);
 
@@ -871,7 +871,9 @@ static int xcanfd_rx(struct net_device *ndev, int frame_base)
 			*(__be32 *)(cf->data + i) = cpu_to_be32(data[0]);
 		}
 	}
-	stats->rx_bytes += cf->len;
+
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		stats->rx_bytes += cf->len;
 	stats->rx_packets++;
 	netif_receive_skb(skb);
 
-- 
2.32.0

