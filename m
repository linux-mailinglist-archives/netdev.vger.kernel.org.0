Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BA23F1AC3
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240407AbhHSNkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240287AbhHSNk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:40:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAA0C0612A8
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:39:45 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGiGm-00059P-98
        for netdev@vger.kernel.org; Thu, 19 Aug 2021 15:39:44 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0A44D66A8A3
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:39:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 766FA66A851;
        Thu, 19 Aug 2021 13:39:29 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 07f48cf0;
        Thu, 19 Aug 2021 13:39:16 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dario Binacchi <dariobin@libero.it>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 21/22] can: c_can: support tx ring algorithm
Date:   Thu, 19 Aug 2021 15:39:12 +0200
Message-Id: <20210819133913.657715-22-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819133913.657715-1-mkl@pengutronix.de>
References: <20210819133913.657715-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dariobin@libero.it>

The algorithm is already used successfully by other CAN drivers
(e.g. mcp251xfd). Its implementation was kindly suggested to me by
Marc Kleine-Budde following a patch I had previously submitted. You can
find every detail at https://lore.kernel.org/patchwork/patch/1422929/.

The idea is that after this patch, it will be easier to patch the driver
to use the message object memory as a true FIFO.

Link: https://lore.kernel.org/r/20210807130800.5246-4-dariobin@libero.it
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Dario Binacchi <dariobin@libero.it>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.h      | 33 ++++++++++++++-
 drivers/net/can/c_can/c_can_main.c | 67 ++++++++++++++++++++++--------
 2 files changed, 82 insertions(+), 18 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 8f23e9c83c84..9b4e54c950a6 100644
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
@@ -219,4 +226,28 @@ int c_can_power_down(struct net_device *dev);
 
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
+static inline u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
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
 #endif /* C_CAN_H */
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index 1ec0ce664732..eb324fffab09 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -427,24 +427,50 @@ static void c_can_setup_receive_object(struct net_device *dev, int iface,
 	c_can_object_put(dev, iface, obj, IF_COMM_RCV_SETUP);
 }
 
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
@@ -453,8 +479,6 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	priv->dlc[idx] = frame->len;
 	can_put_echo_skb(skb, dev, idx, 0);
 
-	/* Update the active bits */
-	atomic_add(BIT(idx), &priv->tx_active);
 	/* Start transmission */
 	c_can_object_put(dev, IF_TX, obj, IF_COMM_TX);
 
@@ -567,6 +591,7 @@ static int c_can_software_reset(struct net_device *dev)
 static int c_can_chip_config(struct net_device *dev)
 {
 	struct c_can_priv *priv = netdev_priv(dev);
+	struct c_can_tx_ring *tx_ring = &priv->tx;
 	int err;
 
 	err = c_can_software_reset(dev);
@@ -598,7 +623,8 @@ static int c_can_chip_config(struct net_device *dev)
 	priv->write_reg(priv, C_CAN_STS_REG, LEC_UNUSED);
 
 	/* Clear all internal status */
-	atomic_set(&priv->tx_active, 0);
+	tx_ring->head = 0;
+	tx_ring->tail = 0;
 	priv->tx_dir = 0;
 
 	/* set bittiming params */
@@ -696,14 +722,14 @@ static int c_can_get_berr_counter(const struct net_device *dev,
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
@@ -723,11 +749,14 @@ static void c_can_do_tx(struct net_device *dev)
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
@@ -1208,6 +1237,10 @@ struct net_device *alloc_c_can_dev(int msg_obj_num)
 	priv->msg_obj_tx_last =
 		priv->msg_obj_tx_first + priv->msg_obj_tx_num - 1;
 
+	priv->tx.head = 0;
+	priv->tx.tail = 0;
+	priv->tx.obj_num = msg_obj_tx_num;
+
 	netif_napi_add(dev, &priv->napi, c_can_poll, priv->msg_obj_rx_num);
 
 	priv->dev = dev;
-- 
2.32.0


