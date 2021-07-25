Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F86C3D4EAF
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 18:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhGYPcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 11:32:33 -0400
Received: from smtp-34-i2.italiaonline.it ([213.209.12.34]:40694 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230193AbhGYPcc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 11:32:32 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([79.45.45.231])
        by smtp-34.iol.local with ESMTPA
        id 7gjJmU9oJLCum7gjSmo2bn; Sun, 25 Jul 2021 18:12:02 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1627229522; bh=KWD/wzdaPvT0fsYgJVYpslUqQQ4hDFaggJS+tSzFXM8=;
        h=From;
        b=QliIcZ4I+F5R8H0t27EFH9yzE0ICwZGsMia4BsOnFHi5QH+RM0FmG+AXw9us5wG1a
         02VtPbFQkuL+uR2pjJNdaQgYmWUbAIcCSvbYdLBglTBpg3DLy7AsTdYrBsO1TgItZa
         Fs3ZjiwpWdFMrotiYTKerg/TZD2N3LbGMaeqjtoEaghQZfbT5DO/5ivHnTlb4IWaBX
         XwnkQnK3Rn5uY5YXzkJYzL1tmIv09HnrA3qzRKd4Q1zqHBxX6j8aVmowlOOIHgnsqD
         tcAzu9M1/kkGEe2hYL9sqyR0gisKFMFYlcCEG6Q4GI9S9j3Ny3UxBJFE7usHPCvhM8
         P42q2ajitEfSA==
X-CNFS-Analysis: v=2.4 cv=a8D1SWeF c=1 sm=1 tr=0 ts=60fd8d52 cx=a_exe
 a=TX8r+oJM0yLPAmPh5WrBoQ==:117 a=TX8r+oJM0yLPAmPh5WrBoQ==:17
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
Subject: [RESEND PATCH 4/4] can: c_can: cache frames to operate as a true FIFO
Date:   Sun, 25 Jul 2021 18:11:50 +0200
Message-Id: <20210725161150.11801-5-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210725161150.11801-1-dariobin@libero.it>
References: <20210725161150.11801-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfIdjIeQbYQxCHXI1IzDDSRX94empUNn2kdd8dI6AHTZ1bBFklhiaYMo7vYRy+DDyhS6t+/ME0UOY1G8D/po+eBY1qs8J3MY5I98L7np9Ctmcd4JIdK7m
 hBpPdwUJjASEqHRnqfKl7arzyn+XVQWQqu3nCl270SftmXUvcc2N/mSNAYxZ0vr8WpvfJdBNNaZ0npEgXBtIddt4l1j1fTe9CHOnbfDBWUCMQ7RVijfM8JPn
 sDk827U7rb4thhOkc9xeF7qvcWlO2zuw0Z6QZg0GDv3T7kNSvteyqKvr+QOgIXKZ/ATHCcR1+pL7vMlBZ7XImYzS6BGq68Zl+ij7iBOp9DgSx4dy9a670UlO
 5abUw975TL0zt46xuLyHKZZgZaYlMevW9uu9z9JqSCKhG2KQO5nUiXZLTgDEMcxWlaqPRngji74Tsvsb1M/NzCos1YbMqvHHS4PuYnIx6SOnaBntYarUTHUh
 Gk6gnmK7vKu9Mvf9mqc7Vq+ALD5cS6v371rpzQUM7Mf7z5MnUFjJ3AKbOodDfQvICxvDaJzNZhvgHVOrkPh4VHUtNVVRkeybxoRLGuGL/vmX2ArPDqNTEYIS
 /TY=
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

