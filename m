Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA9A3D4EA7
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 18:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhGYPbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 11:31:35 -0400
Received: from smtp-34-i2.italiaonline.it ([213.209.12.34]:40694 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230312AbhGYPbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 11:31:32 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([79.45.45.231])
        by smtp-34.iol.local with ESMTPA
        id 7gjJmU9oJLCum7gjRmo2bI; Sun, 25 Jul 2021 18:12:01 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1627229521; bh=VGNCFLBzeyw84IVyEb6PZZrx3WMwI604pwR2tdhmc4g=;
        h=From;
        b=VHnQzkMVCc7OEUzPRANx/n/9VZDYPiqQsk0N1hseCtEtHqzLIgMK1NV7QUgLQUN5I
         olVED7M6LBNAF3oWsGzCIkOPGl/eRZmvsacbfPK0NevWdrINa0CWqlR6cfR38jz3AE
         5QLQMrr2v91mBcmImiE3E7TTvUeIPzEMSjN1wD9SCioinTddruyMK0DLryjZKGRLXn
         ckJmT7Ala5cJOy5snKHDMCwx0p7C5joHKYoMM6z5rDguI+ryozri0dxVME6Cff//wU
         owrRSxTFo3Tr36haBNuaXSRvL7js9bFYdlc+OdXEVoCKK/BgsfoenQtOomQQ2aakKQ
         t7jg3qUt2EQfw==
X-CNFS-Analysis: v=2.4 cv=a8D1SWeF c=1 sm=1 tr=0 ts=60fd8d51 cx=a_exe
 a=TX8r+oJM0yLPAmPh5WrBoQ==:117 a=TX8r+oJM0yLPAmPh5WrBoQ==:17 a=VwQbUJbxAAAA:8
 a=83yiEfbaggHBMMd4CMwA:9 a=TlxWwjO5pACKU3_K:21 a=9s_oUIA50SGwrPgz:21
 a=AjGcO6oz07-iQ99wixmX:22
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
Subject: [RESEND PATCH 3/4] can: c_can: support tx ring algorithm
Date:   Sun, 25 Jul 2021 18:11:49 +0200
Message-Id: <20210725161150.11801-4-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210725161150.11801-1-dariobin@libero.it>
References: <20210725161150.11801-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfNA4QVyiaiFewOl+nU41eANhJeeO/BmmBM3xrAsuJNLHzhEpIjPTsVS1RaaOwvRwhsAWm2kuFXTzHAtkjweyAAr4+lyAsE+pgMd2Rv0SOeKwx3UOlPq+
 oSbBplIAsJJmE85TQT29nszBLFYKpQ7RiLmIQNf6tceSbqmoPFWIFiNAEC9Hb34WPel/70THbCMkVUxXNZgKcRWgCStBbkuUwc2LDZby2gGm3HWexmuZmRK+
 Zw+wnEcTHmmnbOqjTKpaTprWWus5aeldBKTS9e5ZXNIvZCiVNCzUk12tNvA1VOgQoPOjmerRynaugw7jSLb/SDIOoUrcfh7AMYeoOSJkGxuQvhKd+EwxWmt0
 xvVSoOAyzIjwA4SscwfFMM7A1TPb12gayNMBBkbuBTp5bwi8YVksIbbkQyE86kmwccRHkllH6kQDi8lOf3t8XvUQ5udZpOIbJStFnWJy5V26uK/KxLoSsIwW
 oiAqwTMrQq0ndFto1ri0Tp1oykBK1JmGjwgnGxTUuOMZqB68tAkltU4kBM1MBgeDsYYZr4HTHXwFXlCS8tsvGSnBPQPVm+XXJU8kPAiu3XkD02YABDMwLe8r
 wV4=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The algorithm is already used successfully by other CAN drivers
(e.g. mcp251xfd). Its implementation was kindly suggested to me by
Marc Kleine-Budde following a patch I had previously submitted. You can
find every detail at https://lore.kernel.org/patchwork/patch/1422929/.

The idea is that after this patch, it will be easier to patch the driver
to use the message object memory as a true FIFO.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

 drivers/net/can/c_can/c_can.h      | 19 ++++++-
 drivers/net/can/c_can/c_can_main.c | 81 +++++++++++++++++++++++-------
 2 files changed, 82 insertions(+), 18 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 8f23e9c83c84..8fe7e2138620 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -176,6 +176,13 @@ struct c_can_raminit {
 	bool needs_pulse;
 };
 
+/* c_can tx ring structure */
+struct c_can_tx_ring {
+	unsigned int head;
+	unsigned int tail;
+	unsigned int obj_num;
+};
+
 /* c_can private data structure */
 struct c_can_priv {
 	struct can_priv can;	/* must be the first member */
@@ -190,10 +197,10 @@ struct c_can_priv {
 	unsigned int msg_obj_tx_first;
 	unsigned int msg_obj_tx_last;
 	u32 msg_obj_rx_mask;
-	atomic_t tx_active;
 	atomic_t sie_pending;
 	unsigned long tx_dir;
 	int last_status;
+	struct c_can_tx_ring tx;
 	u16 (*read_reg)(const struct c_can_priv *priv, enum reg index);
 	void (*write_reg)(const struct c_can_priv *priv, enum reg index, u16 val);
 	u32 (*read_reg32)(const struct c_can_priv *priv, enum reg index);
@@ -219,4 +226,14 @@ int c_can_power_down(struct net_device *dev);
 
 void c_can_set_ethtool_ops(struct net_device *dev);
 
+static inline u8 c_can_get_tx_head(const struct c_can_tx_ring *ring)
+{
+	return ring->head & (ring->obj_num - 1);
+}
+
+static inline u8 c_can_get_tx_tail(const struct c_can_tx_ring *ring)
+{
+	return ring->tail & (ring->obj_num - 1);
+}
+
 #endif /* C_CAN_H */
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index fec0e3416970..451ac9a9586a 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -427,24 +427,64 @@ static void c_can_setup_receive_object(struct net_device *dev, int iface,
 	c_can_object_put(dev, iface, obj, IF_COMM_RCV_SETUP);
 }
 
+static u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
+{
+	u8 head = c_can_get_tx_head(ring);
+	u8 tail = c_can_get_tx_tail(ring);
+
+	/* This is not a FIFO. C/D_CAN sends out the buffers
+	 * prioritized. The lowest buffer number wins.
+	 */
+	if (head < tail)
+		return 0;
+
+	return ring->obj_num - head;
+}
+
+static bool c_can_tx_busy(const struct c_can_priv *priv,
+			  const struct c_can_tx_ring *tx_ring)
+{
+	if (c_can_get_tx_free(tx_ring) > 0)
+		return false;
+
+	netif_stop_queue(priv->dev);
+
+	/* Memory barrier before checking tx_free (head and tail) */
+	smp_mb();
+
+	if (c_can_get_tx_free(tx_ring) == 0) {
+		netdev_dbg(priv->dev,
+			   "Stopping tx-queue (tx_head=0x%08x, tx_tail=0x%08x, len=%d).\n",
+			   tx_ring->head, tx_ring->tail,
+			   tx_ring->head - tx_ring->tail);
+		return true;
+	}
+
+	netif_start_queue(priv->dev);
+	return false;
+}
+
 static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct can_frame *frame = (struct can_frame *)skb->data;
 	struct c_can_priv *priv = netdev_priv(dev);
+	struct c_can_tx_ring *tx_ring = &priv->tx;
 	u32 idx, obj;
 
 	if (can_dropped_invalid_skb(dev, skb))
 		return NETDEV_TX_OK;
-	/* This is not a FIFO. C/D_CAN sends out the buffers
-	 * prioritized. The lowest buffer number wins.
-	 */
-	idx = fls(atomic_read(&priv->tx_active));
-	obj = idx + priv->msg_obj_tx_first;
 
-	/* If this is the last buffer, stop the xmit queue */
-	if (idx == priv->msg_obj_tx_num - 1)
+	if (c_can_tx_busy(priv, tx_ring))
+		return NETDEV_TX_BUSY;
+
+	idx = c_can_get_tx_head(tx_ring);
+	tx_ring->head++;
+	if (c_can_get_tx_free(tx_ring) == 0)
 		netif_stop_queue(dev);
+
+	obj = idx + priv->msg_obj_tx_first;
+
 	/* Store the message in the interface so we can call
 	 * can_put_echo_skb(). We must do this before we enable
 	 * transmit as we might race against do_tx().
@@ -453,8 +493,6 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	priv->dlc[idx] = frame->len;
 	can_put_echo_skb(skb, dev, idx, 0);
 
-	/* Update the active bits */
-	atomic_add(BIT(idx), &priv->tx_active);
 	/* Start transmission */
 	c_can_object_put(dev, IF_TX, obj, IF_COMM_TX);
 
@@ -567,6 +605,7 @@ static int c_can_software_reset(struct net_device *dev)
 static int c_can_chip_config(struct net_device *dev)
 {
 	struct c_can_priv *priv = netdev_priv(dev);
+	struct c_can_tx_ring *tx_ring = &priv->tx;
 	int err;
 
 	err = c_can_software_reset(dev);
@@ -598,7 +637,8 @@ static int c_can_chip_config(struct net_device *dev)
 	priv->write_reg(priv, C_CAN_STS_REG, LEC_UNUSED);
 
 	/* Clear all internal status */
-	atomic_set(&priv->tx_active, 0);
+	tx_ring->head = 0;
+	tx_ring->tail = 0;
 	priv->tx_dir = 0;
 
 	/* set bittiming params */
@@ -696,14 +736,14 @@ static int c_can_get_berr_counter(const struct net_device *dev,
 static void c_can_do_tx(struct net_device *dev)
 {
 	struct c_can_priv *priv = netdev_priv(dev);
+	struct c_can_tx_ring *tx_ring = &priv->tx;
 	struct net_device_stats *stats = &dev->stats;
-	u32 idx, obj, pkts = 0, bytes = 0, pend, clr;
+	u32 idx, obj, pkts = 0, bytes = 0, pend;
 
 	if (priv->msg_obj_tx_last > 32)
 		pend = priv->read_reg32(priv, C_CAN_INTPND3_REG);
 	else
 		pend = priv->read_reg(priv, C_CAN_INTPND2_REG);
-	clr = pend;
 
 	while ((idx = ffs(pend))) {
 		idx--;
@@ -723,11 +763,14 @@ static void c_can_do_tx(struct net_device *dev)
 	if (!pkts)
 		return;
 
-	/* Clear the bits in the tx_active mask */
-	atomic_sub(clr, &priv->tx_active);
-
-	if (clr & BIT(priv->msg_obj_tx_num - 1))
-		netif_wake_queue(dev);
+	tx_ring->tail += pkts;
+	if (c_can_get_tx_free(tx_ring)) {
+		/* Make sure that anybody stopping the queue after
+		 * this sees the new tx_ring->tail.
+		 */
+		smp_mb();
+		netif_wake_queue(priv->dev);
+	}
 
 	stats->tx_bytes += bytes;
 	stats->tx_packets += pkts;
@@ -1206,6 +1249,10 @@ struct net_device *alloc_c_can_dev(int msg_obj_num)
 	priv->msg_obj_tx_last =
 		priv->msg_obj_tx_first + priv->msg_obj_tx_num - 1;
 
+	priv->tx.head = 0;
+	priv->tx.tail = 0;
+	priv->tx.obj_num = msg_obj_tx_num;
+
 	netif_napi_add(dev, &priv->napi, c_can_poll, priv->msg_obj_rx_num);
 
 	priv->dev = dev;
-- 
2.17.1

