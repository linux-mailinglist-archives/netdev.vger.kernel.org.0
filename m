Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2033E357A
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 15:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhHGNJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 09:09:35 -0400
Received: from smtp-32.italiaonline.it ([213.209.10.32]:42629 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232321AbhHGNJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 09:09:27 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([82.60.87.158])
        by smtp-32.iol.local with ESMTPA
        id CM3WmQm3XPvRTCM3cmIfZG; Sat, 07 Aug 2021 15:08:09 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1628341689; bh=E6M7RVWVJWpQmUiLkb81pv+TQOaxLq5ahfz354xgFLU=;
        h=From;
        b=mKTQUwVVq5mESSisyjCNpHVLxbuLvaGmt/iBPePNyO7dSew5RUP51IKI5Lmxyfmgr
         CNJhAkqwDJTD1JHlIx/Ej+s97RGkrnk6PO4R1ZZKWgWOyc1Seh5sHKltm818hp+p6Z
         djBPDkELgic/X85EaLfrfbxYJQZYzpxWMA0NBkJoYvZNDsEuQmMoay8XprtX8FslLh
         XEU0H2hfPAISNDYpH2wDgtXWzoIZGhlCSRtHdBI7245GNE1PBH94ASOkW+qxRPtLwc
         aHeO6+IqzLlMpnOkRmfpqOUxG8KNB3xMgHk4+ew7bwsj+Ut0noC5B2v+0bka+Om3DU
         iBKiYsEfvFmgg==
X-CNFS-Analysis: v=2.4 cv=NqgUz+RJ c=1 sm=1 tr=0 ts=610e85b9 cx=a_exe
 a=Hc/BMeSBGyun2kpB8NmEvQ==:117 a=Hc/BMeSBGyun2kpB8NmEvQ==:17 a=VwQbUJbxAAAA:8
 a=83yiEfbaggHBMMd4CMwA:9 a=-J8SXSngrPIHDhUm:21 a=IB70CLii7Ylv5kr1:21
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
Subject: [PATCH v3 3/4] can: c_can: support tx ring algorithm
Date:   Sat,  7 Aug 2021 15:07:59 +0200
Message-Id: <20210807130800.5246-4-dariobin@libero.it>
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

The algorithm is already used successfully by other CAN drivers
(e.g. mcp251xfd). Its implementation was kindly suggested to me by
Marc Kleine-Budde following a patch I had previously submitted. You can
find every detail at https://lore.kernel.org/patchwork/patch/1422929/.

The idea is that after this patch, it will be easier to patch the driver
to use the message object memory as a true FIFO.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Dario Binacchi <dariobin@libero.it>

---

(no changes since v2)

Changes in v2:
- Move c_can_get_tx_free() from c_can_main.c to c_can.h.

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
index fec0e3416970..80a6196a8d7a 100644
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
@@ -1206,6 +1235,10 @@ struct net_device *alloc_c_can_dev(int msg_obj_num)
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

