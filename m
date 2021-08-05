Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11F73E1D42
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 22:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240844AbhHEUTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 16:19:38 -0400
Received: from smtp-32-i2.italiaonline.it ([213.209.12.32]:50291 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233384AbhHEUTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 16:19:34 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([82.60.87.158])
        by smtp-32.iol.local with ESMTPA
        id BjpbmFmMJPvRTBjplmCR7a; Thu, 05 Aug 2021 22:19:17 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1628194757; bh=O1QnmgYuLq0RV5WI5jlMHSosfYkPhTOyibvW1Bj0kS4=;
        h=From;
        b=ttNtq5jMfL2Gx7rwXoBc3nHieLUDmVjZpntzO1S6SrI/cN7Jw3zLLKj43RgAE/jPq
         YrOa9sHeh9MxaREdcpWqvq7VGAWDfLUlobGpDmkJBhgGns2X1qG6q6CHTrXobvWEpo
         yhr6QEp1b30yICI/W00+vgGCRrmV/PxosNl377jc1WCUsH06Fu6hFSmjm7a2GszM/H
         E97IKLrISlbOx24JW9YC5ILJO0lRFxoUeeqFm9zqkxDVhs/3OfN2bNo8M/Y5JuSudN
         vDBnqfVO6TREKVigSFOV9CdYiCgBb5IPLwkQBVA4QKDyBjvpdi/uAdi3d1VXfV7Foc
         uJMsl6m+2tQ9Q==
X-CNFS-Analysis: v=2.4 cv=NqgUz+RJ c=1 sm=1 tr=0 ts=610c47c5 cx=a_exe
 a=Hc/BMeSBGyun2kpB8NmEvQ==:117 a=Hc/BMeSBGyun2kpB8NmEvQ==:17
 a=ZFJuXQVxYH-b9Oyd0qwA:9 a=tJrzBPmp90lbkl8h:21 a=oRvS3CD4wq6ZzAfR:21
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
Subject: [PATCH v2 4/4] can: c_can: cache frames to operate as a true FIFO
Date:   Thu,  5 Aug 2021 22:19:00 +0200
Message-Id: <20210805201900.23146-5-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210805201900.23146-1-dariobin@libero.it>
References: <20210805201900.23146-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfMd/kipo7WS1oFEKqlxgX+Gf8PTTvmgGAO8lLxLhGsW6s/b/XUEoNz2+0lw+zLplb5i5CpGrKTicE0YYMgmahSmnCSnyzLfbp/dGYvMA9lxIx9Ny/geN
 w3OjHfp7ztFD7UsBcW137ADDGznB3gSr2vWfgTtTuPMTwUcg0Ab2HQX4VQIAVGE0SFT0Le9Kflkhy8hbL1CXIvcmkujtXwuAWrdiPTnZzDzgDHidkVahP+Rp
 oDDN/S2oqt6wVjWiz4ZHcOM/dJv8lCqjtyxVj0lCPN9hAo2VgKj01sfsQ0mKxxUxUnMd4H+qP7yIcUrE8ekfwtH/cfcJoPn6XrJfbG3u/PVIjp6Xnd4/pL/8
 TTAQjDm6TiKoPFbG1JU4yTg6KzN5hyeHdP8aLoMRHzYtH5BZG+YqB2Vr2xtPw3ogl/D5YJlGpMRSZ6SJ4zvv3ku5HCnPQIcVrw5e68K0DW3i4Btfkm8LFZ7B
 8RQOSre1PcYzTpt+UIcipmN6SRXIjw87gIeDvDQS+1yKeGfrEvavdgpz5qdEVZhNUyE8pIwhVN31rCj4gN/CqiWpPdJeUSkbVeNViLf75WM0Klbf6kDg3+mM
 piY=
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

(no changes since v1)

 drivers/net/can/c_can/c_can.h      | 12 ++----------
 drivers/net/can/c_can/c_can_main.c | 28 ++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 9b4e54c950a6..fc499a70b797 100644
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
@@ -238,16 +239,7 @@ static inline u8 c_can_get_tx_tail(const struct c_can_tx_ring *ring)
 
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
index 80a6196a8d7a..4c061fef002c 100644
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
@@ -469,7 +469,11 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
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
@@ -478,9 +482,11 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
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
@@ -725,6 +731,7 @@ static void c_can_do_tx(struct net_device *dev)
 	struct c_can_tx_ring *tx_ring = &priv->tx;
 	struct net_device_stats *stats = &dev->stats;
 	u32 idx, obj, pkts = 0, bytes = 0, pend;
+	u8 tail;
 
 	if (priv->msg_obj_tx_last > 32)
 		pend = priv->read_reg32(priv, C_CAN_INTPND3_REG);
@@ -761,6 +768,18 @@ static void c_can_do_tx(struct net_device *dev)
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
@@ -1223,6 +1242,7 @@ struct net_device *alloc_c_can_dev(int msg_obj_num)
 		return NULL;
 
 	priv = netdev_priv(dev);
+	spin_lock_init(&priv->tx_lock);
 	priv->msg_obj_num = msg_obj_num;
 	priv->msg_obj_rx_num = msg_obj_num - msg_obj_tx_num;
 	priv->msg_obj_rx_first = 1;
-- 
2.17.1

