Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA4B479E4C
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbhLRXyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:37 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25768 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbhLRXy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=6bm6GaVrFVyGxIa+u0bdAM005qCc6IHaNtcpg3n3Cis=;
        b=mNCg9gyxbFEm4t+2nZaKg+ReH6UC8hwy6iQNulY/RmrbBOhXDBTxpSbEmUItbj7ME0HA
        3wr3OJNjuLqm1gxkydD6Iv6rwXc98PBnLVXbjXUdEOGOQP01a3I64KZt03QHOMp1tge/ec
        xeKChjmf1eyLhHDfoqE0TDs2ymwL0/YRhqS55ey6fwB39h5ggAQB1zoXoWutG/DzFwYY+w
        p++3ztfxhrFkR+2kXBsolHF4+KiuO4nvFnyRZio5d35njlb7a2fwHALzw9iAMC93rbJlr+
        8rlsfJky9b9cAHm40gaCEmM+RdNofCvYQRK4ouhf2daOhcyCJ5PfRfAtA8JNI+AA==
Received: by filterdrecv-656998cfdd-tjhxw with SMTP id filterdrecv-656998cfdd-tjhxw-1-61BE74A9-3
        2021-12-18 23:54:17.157397676 +0000 UTC m=+7604817.697548777
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id 8iAXlL18QCOTQo2pL-qrTA
        Sat, 18 Dec 2021 23:54:16.971 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id BC2727013D3; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 16/23] wilc1000: switch tx queue to normal sk_buff entries
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-17-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvGe4xDYjVShlPTBTg?=
 =?us-ascii?Q?4HGK4jZy482UvybMVz1bUfniX9mYpfddjn=2F2s+u?=
 =?us-ascii?Q?oy4rGBOue5iTJzW+DOfydpHws0MdvzcRTthOctH?=
 =?us-ascii?Q?96MBguHZ77+U9TfoKiQevUNhvigt=2F0qEsO1XcGc?=
 =?us-ascii?Q?vrOxuhmw2Mm5FZvriFqgzsNAEl2+2F3IX=2FdyWI?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to the transmit path to use normal socket-buffer operations
rather than driver-specific structures and functions.

This ends up deleting a fair amount of code and otherwise mostly
consists of switching struct txq_entry_t to struct sk_buff.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../wireless/microchip/wilc1000/cfg80211.c    |  35 +--
 drivers/net/wireless/microchip/wilc1000/mon.c |  36 +--
 .../net/wireless/microchip/wilc1000/netdev.c  |  26 +-
 .../net/wireless/microchip/wilc1000/netdev.h  |   7 +-
 .../net/wireless/microchip/wilc1000/wlan.c    | 281 +++++++-----------
 .../net/wireless/microchip/wilc1000/wlan.h    |  50 +---
 6 files changed, 137 insertions(+), 298 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index be387a8abb6af..d352b7dd03283 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1038,14 +1038,6 @@ void wilc_wfi_p2p_rx(struct wilc_vif *vif, u8 *buff, u32 size)
 	cfg80211_rx_mgmt(&priv->wdev, freq, 0, buff, size, 0);
 }
 
-static void wilc_wfi_mgmt_tx_complete(void *priv, int status)
-{
-	struct wilc_p2p_mgmt_data *pv_data = priv;
-
-	kfree(pv_data->buff);
-	kfree(pv_data);
-}
-
 static void wilc_wfi_remain_on_channel_expired(void *data, u64 cookie)
 {
 	struct wilc_vif *vif = data;
@@ -1124,7 +1116,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 	const u8 *buf = params->buf;
 	size_t len = params->len;
 	const struct ieee80211_mgmt *mgmt;
-	struct wilc_p2p_mgmt_data *mgmt_tx;
+	struct sk_buff *skb;
 	struct wilc_vif *vif = netdev_priv(wdev->netdev);
 	struct wilc_priv *priv = &vif->priv;
 	struct host_if_drv *wfi_drv = priv->hif_drv;
@@ -1141,20 +1133,11 @@ static int mgmt_tx(struct wiphy *wiphy,
 	if (!ieee80211_is_mgmt(mgmt->frame_control))
 		goto out;
 
-	mgmt_tx = kmalloc(sizeof(*mgmt_tx), GFP_KERNEL);
-	if (!mgmt_tx) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	mgmt_tx->buff = kmemdup(buf, len, GFP_KERNEL);
-	if (!mgmt_tx->buff) {
-		ret = -ENOMEM;
-		kfree(mgmt_tx);
-		goto out;
-	}
+	skb = wilc_wlan_alloc_skb(vif, len);
+	if (!skb)
+		return -ENOMEM;
 
-	mgmt_tx->size = len;
+	skb_put_data(skb, buf, len);
 
 	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 		wilc_set_mac_chnl_num(vif, chan->hw_value);
@@ -1176,7 +1159,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 		goto out_set_timeout;
 
 	vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_WFA, WLAN_OUI_TYPE_WFA_P2P,
-					    mgmt_tx->buff + ie_offset,
+					    skb->data + ie_offset,
 					    len - ie_offset);
 	if (!vendor_ie)
 		goto out_set_timeout;
@@ -1189,9 +1172,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 out_txq_add_pkt:
 
-	wilc_wlan_txq_add_mgmt_pkt(wdev->netdev, mgmt_tx,
-				   mgmt_tx->buff, mgmt_tx->size,
-				   wilc_wfi_mgmt_tx_complete);
+	wilc_wlan_txq_add_mgmt_pkt(wdev->netdev, skb);
 
 out:
 
@@ -1732,7 +1713,7 @@ int wilc_cfg80211_init(struct wilc **wilc, struct device *dev, int io_type,
 	wl->hif_func = ops;
 
 	for (i = 0; i < NQUEUES; i++)
-		INIT_LIST_HEAD(&wl->txq[i].txq_head.list);
+		skb_queue_head_init(&wl->txq[i]);
 
 	INIT_LIST_HEAD(&wl->rxq_head.list);
 	INIT_LIST_HEAD(&wl->vif_list);
diff --git a/drivers/net/wireless/microchip/wilc1000/mon.c b/drivers/net/wireless/microchip/wilc1000/mon.c
index 6bd63934c2d84..0b1c4f266cca5 100644
--- a/drivers/net/wireless/microchip/wilc1000/mon.c
+++ b/drivers/net/wireless/microchip/wilc1000/mon.c
@@ -95,45 +95,21 @@ void wilc_wfi_monitor_rx(struct net_device *mon_dev, u8 *buff, u32 size)
 	netif_rx(skb);
 }
 
-struct tx_complete_mon_data {
-	int size;
-	void *buff;
-};
-
-static void mgmt_tx_complete(void *priv, int status)
-{
-	struct tx_complete_mon_data *pv_data = priv;
-	/*
-	 * in case of fully hosting mode, the freeing will be done
-	 * in response to the cfg packet
-	 */
-	kfree(pv_data->buff);
-
-	kfree(pv_data);
-}
-
 static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 {
-	struct tx_complete_mon_data *mgmt_tx = NULL;
+	struct wilc_vif *vif = netdev_priv(dev);
+	struct sk_buff *skb;
 
 	if (!dev)
 		return -EFAULT;
 
 	netif_stop_queue(dev);
-	mgmt_tx = kmalloc(sizeof(*mgmt_tx), GFP_ATOMIC);
-	if (!mgmt_tx)
-		return -ENOMEM;
-
-	mgmt_tx->buff = kmemdup(buf, len, GFP_ATOMIC);
-	if (!mgmt_tx->buff) {
-		kfree(mgmt_tx);
+	skb = wilc_wlan_alloc_skb(vif, len);
+	if (!skb)
 		return -ENOMEM;
-	}
-
-	mgmt_tx->size = len;
+	skb_put_data(skb, buf, len);
 
-	wilc_wlan_txq_add_mgmt_pkt(dev, mgmt_tx, mgmt_tx->buff, mgmt_tx->size,
-				   mgmt_tx_complete);
+	wilc_wlan_txq_add_mgmt_pkt(dev, skb);
 
 	netif_wake_queue(dev);
 	return 0;
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 3b9f5d3e65998..a766687d6ef22 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -718,19 +718,10 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		kfree(mc_list);
 }
 
-static void wilc_tx_complete(void *priv, int status)
-{
-	struct tx_complete_data *pv_data = priv;
-
-	dev_kfree_skb(pv_data->skb);
-	kfree(pv_data);
-}
-
 netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct wilc_vif *vif = netdev_priv(ndev);
 	struct wilc *wilc = vif->wilc;
-	struct tx_complete_data *tx_data = NULL;
 	int queue_count;
 
 	if (skb->dev != ndev) {
@@ -738,22 +729,9 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 		return NETDEV_TX_OK;
 	}
 
-	tx_data = kmalloc(sizeof(*tx_data), GFP_ATOMIC);
-	if (!tx_data) {
-		dev_kfree_skb(skb);
-		netif_wake_queue(ndev);
-		return NETDEV_TX_OK;
-	}
-
-	tx_data->buff = skb->data;
-	tx_data->size = skb->len;
-	tx_data->skb  = skb;
-
 	vif->netstats.tx_packets++;
-	vif->netstats.tx_bytes += tx_data->size;
-	queue_count = wilc_wlan_txq_add_net_pkt(ndev, tx_data,
-						tx_data->buff, tx_data->size,
-						wilc_tx_complete);
+	vif->netstats.tx_bytes += skb->len;
+	queue_count = wilc_wlan_txq_add_net_pkt(ndev, skb);
 
 	if (queue_count > FLOW_CONTROL_UPPER_THRESHOLD) {
 		int srcu_idx;
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index d51095ac54730..6a135b4d7e3f0 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -163,7 +163,7 @@ struct ack_session_info {
 struct pending_acks {
 	u32 ack_num;
 	u32 session_index;
-	struct txq_entry_t  *txqe;
+	struct sk_buff *txqe;
 };
 
 struct tcp_ack_filter {
@@ -244,15 +244,14 @@ struct wilc {
 
 	/* lock to protect issue of wid command to firmware */
 	struct mutex cfg_cmd_lock;
-	struct wilc_cfg_frame cfg_frame;
-	u32 cfg_frame_offset;
+	struct sk_buff *cfg_skb;
 	u8 cfg_seq_no;
 
 	u8 *rx_buffer;
 	u32 rx_buffer_offset;
 	u8 *tx_buffer;
 
-	struct txq_handle txq[NQUEUES];
+	struct sk_buff_head txq[NQUEUES];
 	atomic_t txq_entries;
 	struct txq_fw_recv_queue_stat fw[NQUEUES];
 
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 5aa7bcf82054f..f895e4dd2e73f 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -16,7 +16,7 @@
 
 static const u8 factors[NQUEUES] = {1, 1, 1, 1};
 
-static void tcp_process(struct net_device *, struct txq_entry_t *);
+static void tcp_process(struct net_device *, struct sk_buff *);
 
 static inline bool is_wilc1000(u32 id)
 {
@@ -37,48 +37,19 @@ static inline void release_bus(struct wilc *wilc, enum bus_release release)
 	mutex_unlock(&wilc->hif_cs);
 }
 
-static void wilc_wlan_txq_remove(struct wilc *wilc, u8 q_num,
-				 struct txq_entry_t *tqe)
-{
-	list_del(&tqe->list);
-	atomic_dec(&wilc->txq_entries);
-	wilc->txq[q_num].count--;
-}
-
-static struct txq_entry_t *
-wilc_wlan_txq_remove_from_head(struct wilc *wilc, u8 q_num)
-{
-	struct txq_entry_t *tqe = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&wilc->txq_spinlock, flags);
-
-	if (!list_empty(&wilc->txq[q_num].txq_head.list)) {
-		tqe = list_first_entry(&wilc->txq[q_num].txq_head.list,
-				       struct txq_entry_t, list);
-		list_del(&tqe->list);
-		atomic_dec(&wilc->txq_entries);
-		wilc->txq[q_num].count--;
-	}
-	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
-	return tqe;
-}
-
-static void init_txq_entry(struct txq_entry_t *tqe, struct wilc_vif *vif,
+static void init_txq_entry(struct sk_buff *tqe, struct wilc_vif *vif,
 			   u8 type, enum ip_pkt_priority q_num)
 {
 	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
 
-	tqe->vif = vif;
 	tx_cb->type = type;
 	tx_cb->q_num = q_num;
 	tx_cb->ack_idx = NOT_TCP_ACK;
 }
 
 static void wilc_wlan_txq_add_to_tail(struct net_device *dev, u8 type, u8 q_num,
-				      struct txq_entry_t *tqe)
+				      struct sk_buff *tqe)
 {
-	unsigned long flags;
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc = vif->wilc;
 
@@ -86,34 +57,24 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev, u8 type, u8 q_num,
 	if (type == WILC_NET_PKT && vif->ack_filter.enabled)
 		tcp_process(dev, tqe);
 
-	spin_lock_irqsave(&wilc->txq_spinlock, flags);
-
-	list_add_tail(&tqe->list, &wilc->txq[q_num].txq_head.list);
+	skb_queue_tail(&wilc->txq[q_num], tqe);
 	atomic_inc(&wilc->txq_entries);
-	wilc->txq[q_num].count++;
-
-	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
 	wake_up_interruptible(&wilc->txq_event);
 }
 
 static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif, u8 type, u8 q_num,
-				      struct txq_entry_t *tqe)
+				      struct sk_buff *tqe)
 {
-	unsigned long flags;
 	struct wilc *wilc = vif->wilc;
 
 	init_txq_entry(tqe, vif, type, q_num);
 
 	mutex_lock(&wilc->txq_add_to_head_cs);
 
-	spin_lock_irqsave(&wilc->txq_spinlock, flags);
-
-	list_add(&tqe->list, &wilc->txq[q_num].txq_head.list);
+	skb_queue_head(&wilc->txq[q_num], tqe);
 	atomic_inc(&wilc->txq_entries);
-	wilc->txq[q_num].count++;
 
-	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 	mutex_unlock(&wilc->txq_add_to_head_cs);
 	wake_up_interruptible(&wilc->txq_event);
 }
@@ -143,7 +104,7 @@ static inline void update_tcp_session(struct wilc_vif *vif, u32 index, u32 ack)
 
 static inline void add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
 				       u32 session_index,
-				       struct txq_entry_t *txqe)
+				       struct sk_buff *txqe)
 {
 	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(txqe);
 	struct tcp_ack_filter *f = &vif->ack_filter;
@@ -158,9 +119,9 @@ static inline void add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
 	}
 }
 
-static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
+static inline void tcp_process(struct net_device *dev, struct sk_buff *tqe)
 {
-	void *buffer = tqe->buffer;
+	void *buffer = tqe->data;
 	const struct ethhdr *eth_hdr_ptr = buffer;
 	int i;
 	unsigned long flags;
@@ -210,29 +171,30 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 }
 
-static void wilc_wlan_tx_packet_done(struct txq_entry_t *tqe, int status)
+static void wilc_wlan_tx_packet_done(struct sk_buff *tqe, int status)
 {
-	struct wilc_vif *vif = tqe->vif;
+	struct wilc_vif *vif = netdev_priv(tqe->dev);
 	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
 	int ack_idx = tx_cb->ack_idx;
 
-	tqe->status = status;
-	if (tqe->tx_complete_func)
-		tqe->tx_complete_func(tqe->priv, tqe->status);
 	if (ack_idx != NOT_TCP_ACK && ack_idx < MAX_PENDING_ACKS)
 		vif->ack_filter.pending_acks[ack_idx].txqe = NULL;
-	kfree(tqe);
+	if (status)
+		dev_consume_skb_any(tqe);
+	else
+		dev_kfree_skb_any(tqe);
 }
 
-static void wilc_wlan_txq_drop_net_pkt(struct txq_entry_t *tqe)
+static void wilc_wlan_txq_drop_net_pkt(struct sk_buff *tqe)
 {
-	struct wilc_vif *vif = tqe->vif;
+	struct wilc_vif *vif = netdev_priv(tqe->dev);
 	struct wilc *wilc = vif->wilc;
 	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
 
 	vif->ndev->stats.tx_dropped++;
 
-	wilc_wlan_txq_remove(wilc, tx_cb->q_num, tqe);
+	skb_unlink(tqe, &wilc->txq[tx_cb->q_num]);
+	atomic_dec(&wilc->txq_entries);
 	wilc_wlan_tx_packet_done(tqe, 1);
 }
 
@@ -261,7 +223,7 @@ static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 		bigger_ack_num = f->ack_session_info[index].bigger_ack_num;
 
 		if (f->pending_acks[i].ack_num < bigger_ack_num) {
-			struct txq_entry_t *tqe;
+			struct sk_buff *tqe;
 
 			tqe = f->pending_acks[i].txqe;
 			if (tqe)
@@ -284,30 +246,17 @@ void wilc_enable_tcp_ack_filter(struct wilc_vif *vif, bool value)
 	vif->ack_filter.enabled = value;
 }
 
-static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, u8 *buffer,
-				     u32 buffer_size)
+static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, struct sk_buff *tqe)
 {
-	struct txq_entry_t *tqe;
 	struct wilc *wilc = vif->wilc;
 
 	netdev_dbg(vif->ndev, "Adding config packet ...\n");
 	if (wilc->quit) {
 		netdev_dbg(vif->ndev, "Return due to clear function\n");
-		complete(&wilc->cfg_event);
-		return 0;
-	}
-
-	tqe = kmalloc(sizeof(*tqe), GFP_ATOMIC);
-	if (!tqe) {
-		complete(&wilc->cfg_event);
+		dev_kfree_skb_any(tqe);
 		return 0;
 	}
 
-	tqe->buffer = buffer;
-	tqe->buffer_size = buffer_size;
-	tqe->tx_complete_func = NULL;
-	tqe->priv = NULL;
-
 	wilc_wlan_txq_add_to_head(vif, WILC_CFG_PKT, AC_VO_Q, tqe);
 
 	return 1;
@@ -354,7 +303,7 @@ static bool is_ac_q_limit(struct wilc *wl, u8 q_num)
 	else
 		q_limit = (q->cnt[q_num] * FLOW_CONTROL_UPPER_THRESHOLD / q->sum) + 1;
 
-	if (wl->txq[q_num].count <= q_limit)
+	if (skb_queue_len(&wl->txq[q_num]) <= q_limit)
 		ret = true;
 
 	spin_unlock_irqrestore(&wl->txq_spinlock, flags);
@@ -442,12 +391,8 @@ static inline u8 ac_change(struct wilc *wilc, u8 *ac)
 	return 1;
 }
 
-int wilc_wlan_txq_add_net_pkt(struct net_device *dev,
-			      struct tx_complete_data *tx_data, u8 *buffer,
-			      u32 buffer_size,
-			      void (*tx_complete_fn)(void *, int))
+int wilc_wlan_txq_add_net_pkt(struct net_device *dev, struct sk_buff *tqe)
 {
-	struct txq_entry_t *tqe;
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc;
 	u8 q_num;
@@ -455,109 +400,50 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev,
 	wilc = vif->wilc;
 
 	if (wilc->quit) {
-		tx_complete_fn(tx_data, 0);
+		dev_kfree_skb_any(tqe);
 		return 0;
 	}
 
 	if (!wilc->initialized) {
-		tx_complete_fn(tx_data, 0);
+		dev_kfree_skb_any(tqe);
 		return 0;
 	}
 
-	tqe = kmalloc(sizeof(*tqe), GFP_ATOMIC);
-
-	if (!tqe) {
-		tx_complete_fn(tx_data, 0);
-		return 0;
-	}
-	tqe->buffer = buffer;
-	tqe->buffer_size = buffer_size;
-	tqe->tx_complete_func = tx_complete_fn;
-	tqe->priv = tx_data;
-
-	q_num = ac_classify(wilc, tx_data->skb);
+	q_num = ac_classify(wilc, tqe);
 	if (ac_change(wilc, &q_num)) {
-		tx_complete_fn(tx_data, 0);
-		kfree(tqe);
+		dev_kfree_skb_any(tqe);
 		return 0;
 	}
 
 	if (is_ac_q_limit(wilc, q_num)) {
 		wilc_wlan_txq_add_to_tail(dev, WILC_NET_PKT, q_num, tqe);
 	} else {
-		tx_complete_fn(tx_data, 0);
-		kfree(tqe);
+		dev_kfree_skb(tqe);
 	}
 
 	return atomic_read(&wilc->txq_entries);
 }
 
-int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
-			       u32 buffer_size,
-			       void (*tx_complete_fn)(void *, int))
+int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, struct sk_buff *tqe)
 {
-	struct txq_entry_t *tqe;
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc;
 
 	wilc = vif->wilc;
 
 	if (wilc->quit) {
-		tx_complete_fn(priv, 0);
+		dev_kfree_skb_any(tqe);
 		return 0;
 	}
 
 	if (!wilc->initialized) {
-		tx_complete_fn(priv, 0);
+		dev_kfree_skb_any(tqe);
 		return 0;
 	}
-	tqe = kmalloc(sizeof(*tqe), GFP_ATOMIC);
-
-	if (!tqe) {
-		tx_complete_fn(priv, 0);
-		return 0;
-	}
-	tqe->buffer = buffer;
-	tqe->buffer_size = buffer_size;
-	tqe->tx_complete_func = tx_complete_fn;
-	tqe->priv = priv;
 	wilc_wlan_txq_add_to_tail(dev, WILC_MGMT_PKT, AC_VO_Q, tqe);
 	return 1;
 }
 
-static struct txq_entry_t *wilc_wlan_txq_get_first(struct wilc *wilc, u8 q_num)
-{
-	struct txq_entry_t *tqe = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&wilc->txq_spinlock, flags);
-
-	if (!list_empty(&wilc->txq[q_num].txq_head.list))
-		tqe = list_first_entry(&wilc->txq[q_num].txq_head.list,
-				       struct txq_entry_t, list);
-
-	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
-
-	return tqe;
-}
-
-static struct txq_entry_t *wilc_wlan_txq_get_next(struct wilc *wilc,
-						  struct txq_entry_t *tqe,
-						  u8 q_num)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&wilc->txq_spinlock, flags);
-
-	if (!list_is_last(&tqe->list, &wilc->txq[q_num].txq_head.list))
-		tqe = list_next_entry(tqe, list);
-	else
-		tqe = NULL;
-	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
-
-	return tqe;
-}
-
 static void wilc_wlan_rxq_add(struct wilc *wilc, struct rxq_entry_t *rqe)
 {
 	if (wilc->quit)
@@ -732,7 +618,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	u32 offset = 0;
 	bool max_size_over = 0, ac_exist = 0;
 	int vmm_sz = 0;
-	struct txq_entry_t *tqe_q[NQUEUES];
+	struct sk_buff *tqe_q[NQUEUES];
 	struct wilc_skb_tx_cb *tx_cb;
 	int ret = 0;
 	int counter;
@@ -758,7 +644,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	srcu_read_unlock(&wilc->srcu, srcu_idx);
 
 	for (ac = 0; ac < NQUEUES; ac++)
-		tqe_q[ac] = wilc_wlan_txq_get_first(wilc, ac);
+		tqe_q[ac] = skb_peek(&wilc->txq[ac]);
 
 	i = 0;
 	sum = 0;
@@ -786,7 +672,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 				else
 					vmm_sz = HOST_HDR_OFFSET;
 
-				vmm_sz += tqe_q[ac]->buffer_size;
+				vmm_sz += tqe_q[ac]->len;
 				vmm_sz = ALIGN(vmm_sz, 4);
 
 				if ((sum + vmm_sz) > WILC_TX_BUFF_SIZE) {
@@ -802,9 +688,8 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 
 				i++;
 				sum += vmm_sz;
-				tqe_q[ac] = wilc_wlan_txq_get_next(wilc,
-								   tqe_q[ac],
-								   ac);
+				tqe_q[ac] = skb_peek_next(tqe_q[ac],
+							  &wilc->txq[ac]);
 			}
 		}
 		num_pkts_to_add = ac_preserve_ratio;
@@ -894,17 +779,18 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	offset = 0;
 	i = 0;
 	do {
-		struct txq_entry_t *tqe;
+		struct sk_buff *tqe;
 		u32 header, buffer_offset;
 		char *bssid;
 		u8 mgmt_ptk = 0;
 
-		tqe = wilc_wlan_txq_remove_from_head(wilc, vmm_entries_ac[i]);
+		tqe = skb_dequeue(&wilc->txq[vmm_entries_ac[i]]);
 		if (!tqe)
 			break;
 
+		atomic_dec(&wilc->txq_entries);
 		ac_pkt_num_to_chip[vmm_entries_ac[i]]++;
-		vif = tqe->vif;
+		vif = netdev_priv(tqe->dev);
 		tx_cb = WILC_SKB_TX_CB(tqe);
 		if (vmm_table[i] == 0)
 			break;
@@ -918,7 +804,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 
 		header = (FIELD_PREP(WILC_VMM_HDR_TYPE, tx_cb->type) |
 			  FIELD_PREP(WILC_VMM_HDR_MGMT_FIELD, mgmt_ptk) |
-			  FIELD_PREP(WILC_VMM_HDR_PKT_SIZE, tqe->buffer_size) |
+			  FIELD_PREP(WILC_VMM_HDR_PKT_SIZE, tqe->len) |
 			  FIELD_PREP(WILC_VMM_HDR_BUFF_SIZE, vmm_sz));
 
 		cpu_to_le32s(&header);
@@ -928,7 +814,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 		} else if (tx_cb->type == WILC_NET_PKT) {
 			int prio = tx_cb->q_num;
 
-			bssid = tqe->vif->bssid;
+			bssid = vif->bssid;
 			buffer_offset = ETH_ETHERNET_HDR_OFFSET;
 			memcpy(&txb[offset + 4], &prio, sizeof(prio));
 			memcpy(&txb[offset + 8], bssid, 6);
@@ -936,8 +822,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 			buffer_offset = HOST_HDR_OFFSET;
 		}
 
-		memcpy(&txb[offset + buffer_offset],
-		       tqe->buffer, tqe->buffer_size);
+		memcpy(&txb[offset + buffer_offset], tqe->data, tqe->len);
 		offset += vmm_sz;
 		i++;
 		wilc_wlan_tx_packet_done(tqe, 1);
@@ -1251,7 +1136,7 @@ int wilc_wlan_stop(struct wilc *wilc, struct wilc_vif *vif)
 
 void wilc_wlan_cleanup(struct net_device *dev)
 {
-	struct txq_entry_t *tqe;
+	struct sk_buff *tqe, *cfg_skb;
 	struct rxq_entry_t *rqe;
 	u8 ac;
 	struct wilc_vif *vif = netdev_priv(dev);
@@ -1259,9 +1144,15 @@ void wilc_wlan_cleanup(struct net_device *dev)
 
 	wilc->quit = 1;
 	for (ac = 0; ac < NQUEUES; ac++) {
-		while ((tqe = wilc_wlan_txq_remove_from_head(wilc, ac)))
+		while ((tqe = skb_dequeue(&wilc->txq[ac])))
 			wilc_wlan_tx_packet_done(tqe, 0);
 	}
+	atomic_set(&wilc->txq_entries, 0);
+	cfg_skb = wilc->cfg_skb;
+	if (cfg_skb) {
+		wilc->cfg_skb = NULL;
+		dev_kfree_skb_any(cfg_skb);
+	}
 
 	while ((rqe = wilc_wlan_rxq_remove(wilc)))
 		kfree(rqe);
@@ -1273,21 +1164,52 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	wilc->hif_func->hif_deinit(NULL);
 }
 
+struct sk_buff *wilc_wlan_alloc_skb(struct wilc_vif *vif, size_t len)
+{
+	size_t size, headroom;
+	struct sk_buff *skb;
+
+	headroom = vif->ndev->needed_headroom;
+	size = headroom + len + vif->ndev->needed_tailroom;
+	skb = netdev_alloc_skb(vif->ndev, size);
+	if (!skb) {
+		netdev_err(vif->ndev, "Failed to alloc skb");
+		return NULL;
+	}
+	skb_reserve(skb, headroom);
+	return skb;
+}
+
+static struct sk_buff *alloc_cfg_skb(struct wilc_vif *vif)
+{
+	struct sk_buff *skb;
+
+	skb = wilc_wlan_alloc_skb(vif, (sizeof(struct wilc_cfg_cmd_hdr)
+					+ WILC_MAX_CFG_FRAME_SIZE));
+	if (!skb)
+		return NULL;
+	skb_reserve(skb, sizeof(struct wilc_cfg_cmd_hdr));
+	return skb;
+}
+
 static int wilc_wlan_cfg_commit(struct wilc_vif *vif, int type,
 				u32 drv_handler)
 {
 	struct wilc *wilc = vif->wilc;
-	struct wilc_cfg_frame *cfg = &wilc->cfg_frame;
-	int t_len = wilc->cfg_frame_offset + sizeof(struct wilc_cfg_cmd_hdr);
 	struct wilc_cfg_cmd_hdr *hdr;
+	struct sk_buff *cfg_skb = wilc->cfg_skb;
 
-	hdr = &cfg->hdr;
+	hdr = skb_push(cfg_skb, sizeof(*hdr));
 	hdr->cmd_type = (type == WILC_CFG_SET) ? 'W' : 'Q';
 	hdr->seq_no = wilc->cfg_seq_no;
-	hdr->total_len = cpu_to_le16(t_len);
+	hdr->total_len = cpu_to_le16(cfg_skb->len);
 	hdr->driver_handler = cpu_to_le32(drv_handler);
+	/* We are about to pass ownership of cfg_skb to the tx queue
+	 * (or it'll be destroyed, in case the queue is full):
+	 */
+	wilc->cfg_skb = NULL;
 
-	if (!wilc_wlan_txq_add_cfg_pkt(vif, (u8 *)&cfg->hdr, t_len))
+	if (!wilc_wlan_txq_add_cfg_pkt(vif, cfg_skb))
 		return -1;
 
 	return 0;
@@ -1302,24 +1224,32 @@ static int wilc_wlan_cfg_apply_wid(struct wilc_vif *vif, int start, u16 wid,
 				   u8 *buffer, u32 buffer_size, int commit,
 				   u32 drv_handler, bool set)
 {
-	u32 offset;
 	int ret_size;
 	struct wilc *wilc = vif->wilc;
 
 	mutex_lock(&wilc->cfg_cmd_lock);
 
-	if (start)
-		wilc->cfg_frame_offset = 0;
+	if (start) {
+		WARN_ON(wilc->cfg_skb);
+		wilc->cfg_skb = alloc_cfg_skb(vif);
+		if (!wilc->cfg_skb) {
+			netdev_dbg(vif->ndev, "Failed to alloc cfg_skb");
+			mutex_unlock(&wilc->cfg_cmd_lock);
+			return 0;
+		}
+	}
 
-	offset = wilc->cfg_frame_offset;
 	if (set)
-		ret_size = wilc_wlan_cfg_set_wid(wilc->cfg_frame.frame, offset,
+		ret_size = wilc_wlan_cfg_set_wid(wilc->cfg_skb->tail, 0,
 						 wid, buffer, buffer_size);
 	else
-		ret_size = wilc_wlan_cfg_get_wid(wilc->cfg_frame.frame, offset,
-						 wid);
-	offset += ret_size;
-	wilc->cfg_frame_offset = offset;
+		ret_size = wilc_wlan_cfg_get_wid(wilc->cfg_skb->tail, 0, wid);
+	if (ret_size == 0)
+		netdev_dbg(vif->ndev,
+			   "Failed to add WID 0x%x to %s cfg packet\n",
+			   wid, set ? "set" : "query");
+
+	skb_put(wilc->cfg_skb, ret_size);
 
 	if (!commit) {
 		mutex_unlock(&wilc->cfg_cmd_lock);
@@ -1339,7 +1269,6 @@ static int wilc_wlan_cfg_apply_wid(struct wilc_vif *vif, int start, u16 wid,
 		ret_size = 0;
 	}
 
-	wilc->cfg_frame_offset = 0;
 	wilc->cfg_seq_no = (wilc->cfg_seq_no + 1) % 256;
 	mutex_unlock(&wilc->cfg_cmd_lock);
 
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.h b/drivers/net/wireless/microchip/wilc1000/wlan.h
index 295795a8060ac..10618327133ce 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.h
@@ -320,24 +320,19 @@ enum ip_pkt_priority {
 	AC_BK_Q = 3
 };
 
-struct txq_entry_t {
-	struct list_head list;
-	int type;
-	u8 q_num;
-	int ack_idx;
-	u8 *buffer;
-	int buffer_size;
-	void *priv;
-	int status;
-	struct wilc_vif *vif;
-	void (*tx_complete_func)(void *priv, int status);
+/* When queueing a tx packet, this info is stored in the sk_buff's
+ * control buffer (cb).
+ */
+struct wilc_skb_tx_cb {
+	u8 type;			/* one of WILC_*_PKT */
+	enum ip_pkt_priority q_num;	/* AC queue this packet is on */
+	int ack_idx;			/* TCP ack index */
 };
 
-#define wilc_skb_tx_cb	txq_entry_t
-
-static inline struct wilc_skb_tx_cb *WILC_SKB_TX_CB(struct txq_entry_t *tqe)
+static inline struct wilc_skb_tx_cb *WILC_SKB_TX_CB(struct sk_buff *skb)
 {
-	return (struct wilc_skb_tx_cb *)tqe;
+	BUILD_BUG_ON(sizeof(struct wilc_skb_tx_cb) > sizeof(skb->cb));
+	return (struct wilc_skb_tx_cb *)&skb->cb[0];
 }
 
 struct txq_fw_recv_queue_stat {
@@ -345,11 +340,6 @@ struct txq_fw_recv_queue_stat {
 	u8 count;
 };
 
-struct txq_handle {
-	struct txq_entry_t txq_head;
-	u16 count;
-};
-
 struct rxq_entry_t {
 	struct list_head list;
 	u8 *buffer;
@@ -382,12 +372,6 @@ struct wilc_hif_func {
 
 #define WILC_MAX_CFG_FRAME_SIZE		1468
 
-struct tx_complete_data {
-	int size;
-	void *buff;
-	struct sk_buff *skb;
-};
-
 struct wilc_cfg_cmd_hdr {
 	u8 cmd_type;
 	u8 seq_no;
@@ -395,11 +379,6 @@ struct wilc_cfg_cmd_hdr {
 	__le32 driver_handler;
 };
 
-struct wilc_cfg_frame {
-	struct wilc_cfg_cmd_hdr hdr;
-	u8 frame[WILC_MAX_CFG_FRAME_SIZE];
-};
-
 struct wilc_cfg_rsp {
 	u8 type;
 	u8 seq_no;
@@ -411,19 +390,16 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 				u32 buffer_size);
 int wilc_wlan_start(struct wilc *wilc);
 int wilc_wlan_stop(struct wilc *wilc, struct wilc_vif *vif);
-int wilc_wlan_txq_add_net_pkt(struct net_device *dev,
-			      struct tx_complete_data *tx_data, u8 *buffer,
-			      u32 buffer_size,
-			      void (*tx_complete_fn)(void *, int));
+int wilc_wlan_txq_add_net_pkt(struct net_device *dev, struct sk_buff *skb);
 int wilc_wlan_handle_txq(struct wilc *wl, u32 *txq_count);
 void wilc_handle_isr(struct wilc *wilc);
+struct sk_buff *wilc_wlan_alloc_skb(struct wilc_vif *vif, size_t len);
 void wilc_wlan_cleanup(struct net_device *dev);
 int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 		      u32 buffer_size, int commit, u32 drv_handler);
 int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 		      u32 drv_handler);
-int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
-			       u32 buffer_size, void (*func)(void *, int));
+int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, struct sk_buff *skb);
 void wilc_enable_tcp_ack_filter(struct wilc_vif *vif, bool value);
 int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc);
 netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
-- 
2.25.1

