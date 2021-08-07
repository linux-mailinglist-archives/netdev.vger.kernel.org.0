Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2BE3E3578
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 15:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhHGNJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 09:09:30 -0400
Received: from smtp-32.italiaonline.it ([213.209.10.32]:57646 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232315AbhHGNJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 09:09:27 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([82.60.87.158])
        by smtp-32.iol.local with ESMTPA
        id CM3WmQm3XPvRTCM3dmIfZb; Sat, 07 Aug 2021 15:08:09 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1628341689; bh=AckADGcKabU1CkSpV4t7qzvQ6zrVoNpS9rhgk52TYv0=;
        h=From;
        b=smRCHIBK8S6QqS7tkru9LBe/cQwDrZcfQFF6q0cP2i7unpVPIscnkqubkglJCAj+v
         uayEpMUnjl7ROMw+dIdClFEQRo9nQHmNivzpSJ8piPV7A+m7+mNBTolNcRgcNRKJAm
         ThjDkiMELzmYlcclMoyc2jCI//UsLps7yOTymwwAThH3mmfcHZjuP1mnebx9lbQimi
         kb9A48CtSve/IYVpAeKlnUgwohS/ERbKRB8QToy906rTxcNj7IYCxcQRRKnGc8ZFmj
         onpSCwyDIensMPsXKreJTDbMmnw61/2EJTVoCG/i9QE/aZ9/u41AiLmRKbgPAZyF8k
         LBUUJiV/K6s0Q==
X-CNFS-Analysis: v=2.4 cv=NqgUz+RJ c=1 sm=1 tr=0 ts=610e85b9 cx=a_exe
 a=Hc/BMeSBGyun2kpB8NmEvQ==:117 a=Hc/BMeSBGyun2kpB8NmEvQ==:17
 a=ZFJuXQVxYH-b9Oyd0qwA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Dario Binacchi <dariobin@libero.it>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 4/4] can: c_can: cache frames to operate as a true FIFO
Date:   Sat,  7 Aug 2021 15:08:00 +0200
Message-Id: <20210807130800.5246-5-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210807130800.5246-1-dariobin@libero.it>
References: <20210807130800.5246-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfGmoOd6GOqyevjfeI0zB2i24sWp8gcgfOcTme321pSFLb1391FI8sMh2uwQ33GcP7ve3oVNJSCCFK4M3gta3YFF46gmfy8mjPINjb8SgQk0sYSYElZIA
 TUeZZw2dN2t4yilSRcoCASz1cP8wYxJdheHTh2TDubSnu1KMKvrBSjixj/xAQlh0srNHUpZq+fvScR6KjwQAFKlwSshQaoJYwy8a93WutjcdeYo2sPbgEV0V
 87DlYFJcDo2CZFerCOip/5We7BHD/vePwPMkh+nQPBre0rNu3FoxEFb+8ye/JZ8mDKjJRRmD28T6Kh0UZiWhPI36l6zkOjO8mC4+LwhiACB8DVCHNmuRIIkq
 9GXLpCW9SfKZl5mbqM2ZXrytcRFlDrHH79dcWSKuL7WfTT6n7xu3r0Ja0L3ooH92rv7rphRPTAyj3gbZvdpaTUM1IOX2qCaqXGY+NgMo3LPxh3BDqUxjZqws
 FRVHuAPNt/+We5kFVbITTHpKerkDPnn+wyi99wh++3AOueuUJeInuCnWZNy7fsxx51VuNzeuHuYyg5fUgocvbcs9VefTESy0jnyFU2zj1GEkVJysMtOff9Gj
 dQo=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported by a comment in the c_can_start_xmit() this was not a FIFO.
C/D_CAN controller sends out the buffers prioritized so that the lowest
buffer number wins.

What did c_can_start_xmit() do if head was less tail in the tx ring ? It
waited until all the frames queued in the FIFO was actually transmitted
by the controller before accepting a new CAN frame to transmit, even if
the FIFO was not full, to ensure that the messages were transmitted in
the order in which they were loaded.

By storing the frames in the FIFO without requiring its transmission, we
will be able to use the full size of the FIFO even in cases such as the
one described above. The transmission interrupt will trigger their
transmission only when all the messages previously loaded but stored in
less priority positions of the buffers have been transmitted.

Suggested-by: Gianluca Falavigna <gianluca.falavigna@inwind.it>
Signed-off-by: Dario Binacchi <dariobin@libero.it>

---

Changes in v3:
- Remove the transmission spin_lock.
- Use IF_RX in c_can_do_tx().

 drivers/net/can/c_can/c_can.h      | 11 +----------
 drivers/net/can/c_can/c_can_main.c | 23 ++++++++++++++++++-----
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 9b4e54c950a6..08b6efa7a1a7 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -238,16 +238,7 @@ static inline u8 c_can_get_tx_tail(const struct c_can_tx_ring *ring)
 
 static inline u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
 {
-	u8 head = c_can_get_tx_head(ring);
-	u8 tail = c_can_get_tx_tail(ring);
-
-	/* This is not a FIFO. C/D_CAN sends out the buffers
-	 * prioritized. The lowest buffer number wins.
-	 */
-	if (head < tail)
-		return 0;
-
-	return ring->obj_num - head;
+	return ring->obj_num - (ring->head - ring->tail);
 }
 
 #endif /* C_CAN_H */
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index 80a6196a8d7a..e26b097b11ff 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -456,7 +456,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	struct can_frame *frame = (struct can_frame *)skb->data;
 	struct c_can_priv *priv = netdev_priv(dev);
 	struct c_can_tx_ring *tx_ring = &priv->tx;
-	u32 idx, obj;
+	u32 idx, obj, cmd = IF_COMM_TX;
 
 	if (can_dropped_invalid_skb(dev, skb))
 		return NETDEV_TX_OK;
@@ -469,7 +469,8 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	if (c_can_get_tx_free(tx_ring) == 0)
 		netif_stop_queue(dev);
 
-	obj = idx + priv->msg_obj_tx_first;
+	if (idx < c_can_get_tx_tail(tx_ring))
+		cmd &= ~IF_COMM_TXRQST; /* Cache the message */
 
 	/* Store the message in the interface so we can call
 	 * can_put_echo_skb(). We must do this before we enable
@@ -478,9 +479,8 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	c_can_setup_tx_object(dev, IF_TX, frame, idx);
 	priv->dlc[idx] = frame->len;
 	can_put_echo_skb(skb, dev, idx, 0);
-
-	/* Start transmission */
-	c_can_object_put(dev, IF_TX, obj, IF_COMM_TX);
+	obj = idx + priv->msg_obj_tx_first;
+	c_can_object_put(dev, IF_TX, obj, cmd);
 
 	return NETDEV_TX_OK;
 }
@@ -725,6 +725,7 @@ static void c_can_do_tx(struct net_device *dev)
 	struct c_can_tx_ring *tx_ring = &priv->tx;
 	struct net_device_stats *stats = &dev->stats;
 	u32 idx, obj, pkts = 0, bytes = 0, pend;
+	u8 tail;
 
 	if (priv->msg_obj_tx_last > 32)
 		pend = priv->read_reg32(priv, C_CAN_INTPND3_REG);
@@ -761,6 +762,18 @@ static void c_can_do_tx(struct net_device *dev)
 	stats->tx_bytes += bytes;
 	stats->tx_packets += pkts;
 	can_led_event(dev, CAN_LED_EVENT_TX);
+
+	tail = c_can_get_tx_tail(tx_ring);
+
+	if (tail == 0) {
+		u8 head = c_can_get_tx_head(tx_ring);
+
+		/* Start transmission for all cached messages */
+		for (idx = tail; idx < head; idx++) {
+			obj = idx + priv->msg_obj_tx_first;
+			c_can_object_put(dev, IF_RX, obj, IF_COMM_TXRQST);
+		}
+	}
 }
 
 /* If we have a gap in the pending bits, that means we either
-- 
2.17.1

