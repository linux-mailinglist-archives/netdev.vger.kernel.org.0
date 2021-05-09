Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573143776A2
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 14:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhEIMwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 08:52:33 -0400
Received: from smtp-35.italiaonline.it ([213.209.10.35]:43284 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229602AbhEIMwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 May 2021 08:52:32 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 May 2021 08:52:32 EDT
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([95.244.94.151])
        by smtp-35.iol.local with ESMTPA
        id fim8lvyCKpK9wfimGlntW1; Sun, 09 May 2021 14:43:21 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1620564201; bh=Pe3TgqXzxqmUBar/+JHlhg4oqUjFu6tJPUM0b51ffMA=;
        h=From;
        b=nDkxPtlOUXzGH9lOpDYrIESQuuukxrTt5xnlCEG1Ftn2y1RzvmcpHyyNtiqGSjNq0
         NzNiYjTc5qJZ+dqI0pKfDUxGuNUgBJKPsv1aeIRFnwB++9XzvL7UV6y0fzLs6KrVTm
         GnG7SGtvwshDnWsv/sjf7WhsiTAj2FpZU9T0IYE+Bpd71F6PArCSKAzKQKbbPqZX6N
         tEEFxnyI1WpKHA5p/c0YYMds4tNNYMB/Z/Z+/WMJDQn/7dlDJQpWVlDCvpKPqlB07m
         jJEFddzOUPVmcLKi4zP5TnViVkcaynqDCNcuppWZl7YDk5m9b8XkgO7DqaeWaUI+ia
         /vmEaoOhy2Qbw==
X-CNFS-Analysis: v=2.4 cv=A9ipg4aG c=1 sm=1 tr=0 ts=6097d8e9 cx=a_exe
 a=ugxisoNCKEotYwafST++Mw==:117 a=ugxisoNCKEotYwafST++Mw==:17
 a=WWJUMVe1kfpik6qHO5oA:9 a=ZP5WlcJ4jzxDASHk:21 a=SUjYj0xwZ59NHmbF:21
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/3] can: c_can: cache frames to operate as a true FIFO
Date:   Sun,  9 May 2021 14:43:09 +0200
Message-Id: <20210509124309.30024-4-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210509124309.30024-1-dariobin@libero.it>
References: <20210509124309.30024-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfATF04/oA+Sbd+UoXu1WkXY1vwV/HmAVh2khRbjkgYUb/xv+7ye93yTImcDuBV0/rBk+ieLzMzs4Edzlv32i29GBxm8F22xTIiOoTvd4xARyske5api1
 bk7h5OE/s7JP4t58QxzX/oH0+Y6FvgzB2GZk0vXbw4pGz2ghw9E4wIg+v2n2biKdJG0vSOIuNLYNB6Y98qxmtg/KULjhnUfistnytUBXcveoQo2mte18CBzP
 35zJDfzAZm+XI/ZTSxM6QRfsKBBrXa/l72DEenOJFAFXqW6lv68A5xGN7wkdgnuqjPR6MGk8pQpJp+LIqVaQeAI04VD5riluKKCWrDvJwPfqpe31FmU6vImC
 sZirxsRaMvB27zXq2lbV4k31iIp1cWsSD7aO/+cqpdo7dDHWfXMNrZ0VV4Lsr++V2RaPotf15lgq4HiSaJh1rHDOUREIh/BTSU945NtCk5dnx1ViHtfYgdCc
 1/DvQgKIKoyBqhRx98NRfFenk61s8iAkf2vM56ObS+/y3AljE//jTl0TFeraGJaObcIwtNfypsDecpIT8VCUsaaLYQ9tyKJqFwHNSw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported by a comment in the c_can_start_xmit() this was not a FIFO.
C/D_CAN controller sends out the buffers prioritized so that the lowest
buffer number wins.

What did c_can_start_xmit() do if it found tx_active = 0x80000000 ? It
waited until the only frame of the FIFO was actually transmitted by the
controller. Only one message in the FIFO but we had to wait for it to
empty completely to ensure that the messages were transmitted in the
order in which they were loaded.

By storing the frames in the FIFO without requiring its transmission, we
will be able to use the full size of the FIFO even in cases such as the
one described above. The transmission interrupt will trigger their
transmission only when all the messages previously loaded but stored in
less priority positions of the buffers have been transmitted.

Suggested-by: Gianluca Falavigna <gianluca.falavigna@inwind.it>
Signed-off-by: Dario Binacchi <dariobin@libero.it>


---

 drivers/net/can/c_can/c_can.h      |  3 ++
 drivers/net/can/c_can/c_can_main.c | 63 ++++++++++++++++++++++++------
 2 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 4247ff80a29c..6abde6cbc0b1 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -191,6 +191,9 @@ struct c_can_priv {
 	unsigned int msg_obj_tx_last;
 	u32 msg_obj_rx_mask;
 	atomic_t tx_active;
+	atomic_t tx_cached;
+	spinlock_t tx_cached_lock;
+	atomic_t tx_avail;
 	atomic_t sie_pending;
 	unsigned long tx_dir;
 	int last_status;
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index 7588f70ca0fe..d2f44c07d47f 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -124,6 +124,9 @@
 				 IF_COMM_TXRQST |		 \
 				 IF_COMM_DATAA | IF_COMM_DATAB)
 
+#define IF_COMM_TX_FRAME	(IF_COMM_ARB | IF_COMM_CONTROL | \
+				 IF_COMM_DATAA | IF_COMM_DATAB)
+
 /* For the low buffers we clear the interrupt bit, but keep newdat */
 #define IF_COMM_RCV_LOW		(IF_COMM_MASK | IF_COMM_ARB | \
 				 IF_COMM_CONTROL | IF_COMM_CLR_INT_PND | \
@@ -432,19 +435,36 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 {
 	struct can_frame *frame = (struct can_frame *)skb->data;
 	struct c_can_priv *priv = netdev_priv(dev);
-	u32 idx, obj;
+	u32 idx, obj, tx_active, tx_cached;
 
 	if (can_dropped_invalid_skb(dev, skb))
 		return NETDEV_TX_OK;
-	/* This is not a FIFO. C/D_CAN sends out the buffers
-	 * prioritized. The lowest buffer number wins.
-	 */
-	idx = fls(atomic_read(&priv->tx_active));
-	obj = idx + priv->msg_obj_tx_first;
 
-	/* If this is the last buffer, stop the xmit queue */
-	if (idx == priv->msg_obj_tx_num - 1)
+	if (atomic_read(&priv->tx_avail) == 0)
 		netif_stop_queue(dev);
+
+	tx_active = atomic_read(&priv->tx_active);
+	tx_cached = atomic_read(&priv->tx_cached);
+	idx = fls(tx_active);
+	if (idx > priv->msg_obj_tx_num - 1) {
+		idx = fls(tx_cached);
+
+		obj = idx + priv->msg_obj_tx_first;
+		spin_lock_bh(&priv->tx_cached_lock);
+		/* prepare message object for transmission */
+		c_can_setup_tx_object(dev, IF_TX, frame, idx);
+		/* Store the message but don't ask for its transmission */
+		c_can_object_put(dev, IF_TX, obj, IF_COMM_TX_FRAME);
+		spin_unlock_bh(&priv->tx_cached_lock);
+		priv->dlc[idx] = frame->len;
+		can_put_echo_skb(skb, dev, idx, 0);
+		atomic_dec(&priv->tx_avail);
+		atomic_add(BIT(idx), &priv->tx_cached);
+		return NETDEV_TX_OK;
+	}
+
+	obj = idx + priv->msg_obj_tx_first;
+
 	/* Store the message in the interface so we can call
 	 * can_put_echo_skb(). We must do this before we enable
 	 * transmit as we might race against do_tx().
@@ -453,6 +473,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	priv->dlc[idx] = frame->len;
 	can_put_echo_skb(skb, dev, idx, 0);
 
+	atomic_dec(&priv->tx_avail);
 	/* Update the active bits */
 	atomic_add(BIT(idx), &priv->tx_active);
 	/* Start transmission */
@@ -599,6 +620,8 @@ static int c_can_chip_config(struct net_device *dev)
 
 	/* Clear all internal status */
 	atomic_set(&priv->tx_active, 0);
+	atomic_set(&priv->tx_cached, 0);
+	atomic_set(&priv->tx_avail, priv->msg_obj_tx_num);
 	priv->tx_dir = 0;
 
 	/* set bittiming params */
@@ -723,14 +746,31 @@ static void c_can_do_tx(struct net_device *dev)
 	/* Clear the bits in the tx_active mask */
 	atomic_sub(clr, &priv->tx_active);
 
-	if (clr & BIT(priv->msg_obj_tx_num - 1))
-		netif_wake_queue(dev);
-
 	if (pkts) {
+		atomic_add(pkts, &priv->tx_avail);
+
+		if (netif_queue_stopped(dev))
+			netif_wake_queue(dev);
+
 		stats->tx_bytes += bytes;
 		stats->tx_packets += pkts;
 		can_led_event(dev, CAN_LED_EVENT_TX);
 	}
+
+	if (atomic_read(&priv->tx_active) == 0) {
+		pend = atomic_read(&priv->tx_cached);
+
+		clr = pend;
+		while ((idx = ffs(pend))) {
+			idx--;
+			pend &= ~(1 << idx);
+
+			obj = idx + priv->msg_obj_tx_first;
+			c_can_object_put(dev, IF_TX, obj, IF_COMM_TXRQST);
+		}
+		atomic_sub(clr, &priv->tx_cached);
+		atomic_add(clr, &priv->tx_active);
+	}
 }
 
 /* If we have a gap in the pending bits, that means we either
@@ -1193,6 +1233,7 @@ struct net_device *alloc_c_can_dev(int msg_obj_num)
 		return NULL;
 
 	priv = netdev_priv(dev);
+	spin_lock_init(&priv->tx_cached_lock);
 	priv->msg_obj_num = msg_obj_num;
 	priv->msg_obj_rx_num = msg_obj_num - msg_obj_tx_num;
 	priv->msg_obj_rx_first = 1;
-- 
2.17.1

