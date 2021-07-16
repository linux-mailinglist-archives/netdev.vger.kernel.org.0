Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FE43CBAD4
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 18:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhGPRA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 13:00:56 -0400
Received: from smtp-33-i2.italiaonline.it ([213.209.12.33]:43699 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230191AbhGPRAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 13:00:54 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it ([79.54.92.92])
        by smtp-33.iol.local with ESMTPA
        id 4R8tmKNNmS6GM4R91mO7bu; Fri, 16 Jul 2021 18:56:59 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1626454619; bh=KWD/wzdaPvT0fsYgJVYpslUqQQ4hDFaggJS+tSzFXM8=;
        h=From;
        b=M5p9z9KnI4apX914fitNQ6VTd5iC/2725NNtm0KExszlYW/EtJ/Jg/3bFgeBBGGTb
         ROajGgDwxxtrR3NDGzTtroByIS/GkxkbRc1RB5+un0hyD/1Xgfy1rFxu9cCf9hUIro
         URIcibzf96D9iFb5OlP7y015nwBKVAjlhhBVFPXvTHBCOLgsFqA29KWD8Z9KATBSfA
         gj/Z14yuJT8/CVeAPKMFLl3M0c01We7eyQ0EM7w0UhoT9uOALFzU+S7H61KWd5SbXA
         hKEiXjluPAu6CclG+1OVqfxXiHb7qW5oRgGCYWzeRHti/WE4uOh8WD4wrE6xJFSIAW
         l9L0eZrSrg/IQ==
X-CNFS-Analysis: v=2.4 cv=AcF0o1bG c=1 sm=1 tr=0 ts=60f1ba5b cx=a_exe
 a=eKwsI+FXzXP/Nc4oRbpalQ==:117 a=eKwsI+FXzXP/Nc4oRbpalQ==:17
 a=ci6mTl68RD0LDj9SGHYA:9 a=zPaA-w0dnRgsZjSy:21 a=aeJ6SaH8bT6bZ-aJ:21
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
Subject: [PATCH 4/4] can: c_can: cache frames to operate as a true FIFO
Date:   Fri, 16 Jul 2021 18:56:23 +0200
Message-Id: <20210716165623.19677-5-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716165623.19677-1-dariobin@libero.it>
References: <20210716165623.19677-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfJwJslVA2cb60Nx41WhPUMCgwwFuMvrWlgOPnh7OBeEkiIb5GpdEvI4dVbdUaD3iUexMwIQ+3DDGlWch5+pFyKLUTcctcoU0N9eU6WYtl26gBxorS/6j
 ZZhsuH8DU+qEQR37f9emL2YbBfAEplXbJsyWpFoe2VmTFM/6uOEIBxWv19SL67bBJ+dEiQTu3hCzbPv5Ycg8r7Qvy2W4F5/ITgsTrSLOSqQG/XvwzAMztK7I
 7NI+8ZjAP7QVdVOAt8MYUT6Tv1MDKp1s109ef9SCNAvTpX1RG0TabzqNdTHq9K9JmHu83XiQxfGbyQv40N24mQ4U4owIXntQOdmXtLoiKAYT9uqhO6QbwMQG
 uMLdQCKk0EvI6HznNJYIyrMAhVCMKKuGQKYMOG1sDFU5jnQIjYP/4xgbPB4tM0FFKv9A2JTBBgPnn1eQH+G1bLmw9Bn9BQb5tRjB/V2SKjG0htVAuVF9A2YU
 nm9Oepz55WPIHc19XR6mvXb+GqLvikWf03Hf6w7Chu4eYxPBK6ii0m8cVXBGAcUZMwPk3Snl1W5cJ+g1d4q34V2vj2zxCR31lF0myycRze1YsTsvG/S3Wpmj
 ccw=
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

 drivers/net/can/c_can/c_can.h      |  6 +++++
 drivers/net/can/c_can/c_can_main.c | 42 +++++++++++++++++-------------
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 8fe7e2138620..fc499a70b797 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -200,6 +200,7 @@ struct c_can_priv {
 	atomic_t sie_pending;
 	unsigned long tx_dir;
 	int last_status;
+	spinlock_t tx_lock;
 	struct c_can_tx_ring tx;
 	u16 (*read_reg)(const struct c_can_priv *priv, enum reg index);
 	void (*write_reg)(const struct c_can_priv *priv, enum reg index, u16 val);
@@ -236,4 +237,9 @@ static inline u8 c_can_get_tx_tail(const struct c_can_tx_ring *ring)
 	return ring->tail & (ring->obj_num - 1);
 }
 
+static inline u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
+{
+	return ring->obj_num - (ring->head - ring->tail);
+}
+
 #endif /* C_CAN_H */
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index 451ac9a9586a..4c061fef002c 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -427,20 +427,6 @@ static void c_can_setup_receive_object(struct net_device *dev, int iface,
 	c_can_object_put(dev, iface, obj, IF_COMM_RCV_SETUP);
 }
 
-static u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
-{
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
-}
-
 static bool c_can_tx_busy(const struct c_can_priv *priv,
 			  const struct c_can_tx_ring *tx_ring)
 {
@@ -470,7 +456,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	struct can_frame *frame = (struct can_frame *)skb->data;
 	struct c_can_priv *priv = netdev_priv(dev);
 	struct c_can_tx_ring *tx_ring = &priv->tx;
-	u32 idx, obj;
+	u32 idx, obj, cmd = IF_COMM_TX;
 
 	if (can_dropped_invalid_skb(dev, skb))
 		return NETDEV_TX_OK;
@@ -483,7 +469,11 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	if (c_can_get_tx_free(tx_ring) == 0)
 		netif_stop_queue(dev);
 
-	obj = idx + priv->msg_obj_tx_first;
+	spin_lock_bh(&priv->tx_lock);
+	if (idx < c_can_get_tx_tail(tx_ring))
+		cmd &= ~IF_COMM_TXRQST; /* Cache the message */
+	else
+		spin_unlock_bh(&priv->tx_lock);
 
 	/* Store the message in the interface so we can call
 	 * can_put_echo_skb(). We must do this before we enable
@@ -492,9 +482,11 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	c_can_setup_tx_object(dev, IF_TX, frame, idx);
 	priv->dlc[idx] = frame->len;
 	can_put_echo_skb(skb, dev, idx, 0);
+	obj = idx + priv->msg_obj_tx_first;
+	c_can_object_put(dev, IF_TX, obj, cmd);
 
-	/* Start transmission */
-	c_can_object_put(dev, IF_TX, obj, IF_COMM_TX);
+	if (spin_is_locked(&priv->tx_lock))
+		spin_unlock_bh(&priv->tx_lock);
 
 	return NETDEV_TX_OK;
 }
@@ -739,6 +731,7 @@ static void c_can_do_tx(struct net_device *dev)
 	struct c_can_tx_ring *tx_ring = &priv->tx;
 	struct net_device_stats *stats = &dev->stats;
 	u32 idx, obj, pkts = 0, bytes = 0, pend;
+	u8 tail;
 
 	if (priv->msg_obj_tx_last > 32)
 		pend = priv->read_reg32(priv, C_CAN_INTPND3_REG);
@@ -775,6 +768,18 @@ static void c_can_do_tx(struct net_device *dev)
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
+			c_can_object_put(dev, IF_TX, obj, IF_COMM_TXRQST);
+		}
+	}
 }
 
 /* If we have a gap in the pending bits, that means we either
@@ -1237,6 +1242,7 @@ struct net_device *alloc_c_can_dev(int msg_obj_num)
 		return NULL;
 
 	priv = netdev_priv(dev);
+	spin_lock_init(&priv->tx_lock);
 	priv->msg_obj_num = msg_obj_num;
 	priv->msg_obj_rx_num = msg_obj_num - msg_obj_tx_num;
 	priv->msg_obj_rx_first = 1;
-- 
2.17.1

