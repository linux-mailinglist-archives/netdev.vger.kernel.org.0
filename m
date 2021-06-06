Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5761739D155
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 22:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhFFUUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 16:20:24 -0400
Received: from smtp-35.italiaonline.it ([213.209.10.35]:51641 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230230AbhFFUUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 16:20:12 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([79.17.119.101])
        by smtp-35.iol.local with ESMTPA
        id pzCol3UwhsptipzCylruJJ; Sun, 06 Jun 2021 22:17:21 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1623010641; bh=jgd8yWy9ycdnS8FdZkmaUBTnv8/MoVE/T54CaBIExOE=;
        h=From;
        b=STQrR5ZofOrxKk16qXif3sknCfHvhRYnqPAL8GjRj4LTvV8U9ZnaUpTHcVOmWbeL2
         8XWkDsmY7uneYCl/YKgtZj6YYvz8+qr7lDiY8zeL3H6tbKQLBFO2rVhAMcKeY2wTi7
         FciCA7FeSdAs2wuVatM3xGVNR2cV97a/PQgZInq+4Tjd5CG/oB1jEpCLAXyIkbxnXv
         Y5cxWuSIpRuVBbSCawhg7cqiDlPdJxctsHkOj4tIB9zcNLvt9nYoWl0OEK5/X9LlFt
         QNJngXg4wJCQBlUu4uyBYQobBvSbTvw5p2CiiV3aU/o9HqX5Dt0/v7hno8Gw8z+bKV
         MAbI2o0dmGtcg==
X-CNFS-Analysis: v=2.4 cv=Bo1Yfab5 c=1 sm=1 tr=0 ts=60bd2d51 cx=a_exe
 a=do1bHx4A/kh2kuTIUQHSxQ==:117 a=do1bHx4A/kh2kuTIUQHSxQ==:17
 a=ci6mTl68RD0LDj9SGHYA:9 a=kqXjr2oOka_tHwkt:21 a=DlUeu6Gs4-n7kmor:21
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/3] can: c_can: cache frames to operate as a true FIFO
Date:   Sun,  6 Jun 2021 22:17:05 +0200
Message-Id: <20210606201705.31307-4-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210606201705.31307-1-dariobin@libero.it>
References: <20210606201705.31307-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfKYlXNfsIY8XQo0/VZtZ/jVxW1tFYPIL6EqmoOTPNSosmOeyx+bjOl4Al3lvymNWw0aANeu3su6pOrK/OXC4tIFiym8onyMgWzQzKcUiMp9xDBaIpOnr
 TJWpLTZJXJSVOYrySNBKi2NGWHAhGOVgx+gR9Vnu9OMQKRy9uP/TXWQXYB4OzVrE9wu6Lip0i/bGQ75DWkgM9G4AnIhQaC4X4hsSbZtBSzKsv5kzp4cqDtMi
 YKuoyAlAQukM4821j9bHcixVko/36aS6SNI9p1s/Mre/paLDQCkhPL0L++a6L1D77Tbrqb2oVB+dbLzCKeVxOfMMc+wjNaQvKO4fQdzVvJPnTkJACybGMzYd
 15KGSg8eTSa0lTOHS9sbeduWd9KtyUbSbIw5p5D8SPX9Z/FIZcQmttaXhxmhkiOK5uvDSc+/qXhU+68QyMAccHOISsjPy91Qj1BCZQmjEmE50hn9B5nIIfk0
 Jf+zssq06cqI4iTIz68EJRWXtTQ+4YI2ykgQBoAXLWTGebEXcvU4I9by675IAM+I8oHcplE8222zvFyODbODtt1QrH0l/WTrbYYRfdS6lspSqV+OaI5pWvbd
 hSaC2qqKNCnbkouEwQxIwyq38qDeFZyaH2l2nHilPCH4Y4iYBrhD+34bgXMCaYsuWIB4ftVQQiUkQFfuGfHYVHtt
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

 drivers/net/can/c_can/c_can.c | 42 ++++++++++++++++++++---------------
 drivers/net/can/c_can/c_can.h |  6 +++++
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 0548485f522d..9b809ea61094 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
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
@@ -740,6 +732,7 @@ static void c_can_do_tx(struct net_device *dev)
 	struct c_can_tx_ring *tx_ring = &priv->tx;
 	struct net_device_stats *stats = &dev->stats;
 	u32 idx, obj, pkts = 0, bytes = 0, pend;
+	u8 tail;
 
 	if (priv->msg_obj_tx_last > 32)
 		pend = priv->read_reg32(priv, C_CAN_INTPND3_REG);
@@ -776,6 +769,18 @@ static void c_can_do_tx(struct net_device *dev)
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
@@ -1238,6 +1243,7 @@ struct net_device *alloc_c_can_dev(int msg_obj_num)
 		return NULL;
 
 	priv = netdev_priv(dev);
+	spin_lock_init(&priv->tx_lock);
 	priv->msg_obj_num = msg_obj_num;
 	priv->msg_obj_rx_num = msg_obj_num - msg_obj_tx_num;
 	priv->msg_obj_rx_first = 1;
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index c72cb6a7fd37..520daa77f876 100644
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
-- 
2.17.1

