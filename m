Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252DC47161B
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 21:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhLKUcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 15:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhLKUcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 15:32:25 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C312AC061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 12:32:24 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id k21so14242209ioh.4
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 12:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=egauge.net; s=google;
        h=message-id:subject:from:to:cc:date:organization:user-agent
         :mime-version:content-transfer-encoding;
        bh=MzbP0X9zxMTrRYpD7lf4i3PmqnWkvY6EMul/196R2Q8=;
        b=qPuSA+Uzf8pu3EQsI0cjvz1cl5HkT5Gj8RjObWhKSJKmcLEiU3qwMlQ2m1/MZGr8M7
         2ujdBNKid+ulu8Bc7evOEn8fR/u2+wWOXGRGi1B89t+Qg4kf+fQv/WrceDN04iUJSSzh
         mD9PHnY8X9ZIny4zbOP98k9UUXvs4WcgJy1rwHap2rU/HhoibnqmlzQJrcNGRMpBAcAv
         h16S4GWSiaChUeiHcANP0uqiZbzVwA2uT2CeTy78FTmaIzRRU081SZF1aGCXx+Cx0NLM
         98QeyYQDpK0e3U5iq3wg/n/Ah6L+g8wtV/i1FkXRk1FmzTIYIGu+MjnTaJ2KWyMjhrB3
         /Y9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:organization
         :user-agent:mime-version:content-transfer-encoding;
        bh=MzbP0X9zxMTrRYpD7lf4i3PmqnWkvY6EMul/196R2Q8=;
        b=5+c25zVQIvUjoi/0B0PSgDuXCunIIjz0a0Ax4EeWN7wTNq69JSkvQFbfZYy8XFdZID
         rDsc7GxLhnS7mHsCWIcXrILoCGvzVD7eK8Gc7ZdsT7N/ZpirMf5VY9K7OczYyfbE0rLc
         GjZY5frOVknGcrBg/9d//FQKOKMMjKkt/XBM9N9AoXc2X6BCqZFonAsDepa6hRRAQJ1K
         /1rAygOTeMgQo0yQimAv9uA9s5V32H0OvMDK/f4//AqYRIsNpxjbwXQMVTt0iQFhnnFA
         iEkjnHGZTw4iJc1CGjmXv5pzGN17p0kDFH2Fcv9JeBho5JdToRVHbs9AFCXdafdrgtlv
         kEFA==
X-Gm-Message-State: AOAM53225DIQqHgp6yPRnohDOUg4EjCsSgMJG73oFDc46cGM2yQEGLiH
        7bpUE5HFVDHxHvprjB/dw2jJBOWr/wxOz1w=
X-Google-Smtp-Source: ABdhPJx8zrV7rEFnD4nxDmfKo0a6A5BxqlhplD8aVECSGYQaQXkkHaaAjAFn/MCITcoDVzgjsxCUFw==
X-Received: by 2002:a05:6602:2c83:: with SMTP id i3mr27876330iow.54.1639254743750;
        Sat, 11 Dec 2021 12:32:23 -0800 (PST)
Received: from ?IPv6:2601:281:8300:4e0:2ba9:697d:eeec:13b? ([2601:281:8300:4e0:2ba9:697d:eeec:13b])
        by smtp.gmail.com with ESMTPSA id t2sm4495624iob.1.2021.12.11.12.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 12:32:23 -0800 (PST)
Message-ID: <e3502ecffe0c4c01b263ada8deed814d5135c24c.camel@egauge.net>
Subject: RFC: wilc1000: refactor TX path to use sk_buff queue
From:   David Mosberger-Tang <davidm@egauge.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Sat, 11 Dec 2021 13:32:09 -0700
Organization: eGauge Systems LLC
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'd like to propose to restructure the wilc1000 TX path to take
advantage of the existing sk_buff queuing and buffer operations rather
than using a driver-specific solution.  To me, the resulting code looks
simpler and the diffstat shows a fair amount of code-reduction:

 cfg80211.c |   35 ----
 mon.c      |   36 ----
 netdev.c   |   28 ---
 netdev.h   |   10 -
 wlan.c     |  499 ++++++++++++++++++++++++++-----------------------------------
 wlan.h     |   51 ++----
 6 files changed, 255 insertions(+), 404 deletions(-)

Performance isn't significantly affected by this patch:

   Before this patch:
   		TX [Mbps]	RX [Mbps]
     PSM off:	15.4		19.7
     PSM  on:	12.2		17.9

   With this patch:
   		TX [Mbps]	RX [Mbps]
     PSM off:      15.9		20.5
     PSM  on:	12.3		18.8

The question I have is whether something along these lines would be
even considered for merging.  The problem is that the patch is fairly
large and I don't see any obvious way of making it smaller or splitting
it into smaller pieces: once you switch the tx queue data structure,
there is just a bunch of code that needs to get updated as well in
order to get a working driver again.

Notes:

 - Don't try to apply this patch as is.  There are two other small
   but unrelated changes that this patch below depends on.

 - This patch leaves txq_spinlock in place even though its only
   remaining function is to serialize access to wilc->tx_q_limit
   and vif->ack_filter.  This obviously could be renamed in
   a separate patch.  Actually, speaking of which, is there
   no common code in the kernel to handle duplicate-ack
   elimination?

Thoughts and/or suggestions?

Thanks,

  --david

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index be387a8abb6a..d352b7dd0328 100644
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
index 6bd63934c2d8..0b1c4f266cca 100644
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
index 28e3232e1dae..0c822d441907 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -149,7 +149,7 @@ static int wilc_txq_task(void *vp)
 	complete(&wl->txq_thread_started);
 	while (1) {
 		wait_event_interruptible(wl->txq_event,
-					 (wl->txq_entries > 0 || wl->close));
+					 (atomic_read(&wl->txq_entries) > 0 || wl->close));
 
 		if (wl->close) {
 			complete(&wl->txq_thread_started);
@@ -717,19 +717,10 @@ static void wilc_set_multicast_list(struct net_device *dev)
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
@@ -737,22 +728,9 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
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
index 7ed4e9e2d149..a1f744dc47b6 100644
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
@@ -247,16 +247,16 @@ struct wilc {
 
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
-	int txq_entries;
+	atomic_t txq_entries;		/* total # of tx packets queued */
+	struct sk_buff_head txq[NQUEUES];
+	struct txq_fw_recv_queue_stat fw[NQUEUES];
 
 	struct wilc_tx_queue_status tx_q_limit;
 	struct rxq_entry_t rxq_head;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index f552f69c99d9..a3bd8f133f5e 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -11,6 +11,7 @@
 #include "wlan_cfg.h"
 
 #define WAKE_UP_TRIAL_RETRY		10000
+#define NOT_TCP_ACK			(-1)
 
 static inline bool is_wilc1000(u32 id)
 {
@@ -31,72 +32,47 @@ static inline void release_bus(struct wilc *wilc, enum bus_release release)
 	mutex_unlock(&wilc->hif_cs);
 }
 
-static void wilc_wlan_txq_remove(struct wilc *wilc, u8 q_num,
-				 struct txq_entry_t *tqe)
-{
-	list_del(&tqe->list);
-	wilc->txq_entries -= 1;
-	wilc->txq[q_num].count--;
-}
-
-static struct txq_entry_t *
-wilc_wlan_txq_remove_from_head(struct wilc *wilc, u8 q_num)
+static void wilc_set_tx_cb(struct sk_buff *tqe,
+			   u8 type, enum ip_pkt_priority q_num)
 {
-	struct txq_entry_t *tqe = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&wilc->txq_spinlock, flags);
+	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
 
-	if (!list_empty(&wilc->txq[q_num].txq_head.list)) {
-		tqe = list_first_entry(&wilc->txq[q_num].txq_head.list,
-				       struct txq_entry_t, list);
-		list_del(&tqe->list);
-		wilc->txq_entries -= 1;
-		wilc->txq[q_num].count--;
-	}
-	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
-	return tqe;
+	tx_cb->type = type;
+	tx_cb->q_num = q_num;
+	tx_cb->ack_idx = NOT_TCP_ACK;
 }
 
-static void wilc_wlan_txq_add_to_tail(struct net_device *dev, u8 q_num,
-				      struct txq_entry_t *tqe)
+static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
+				      u8 type, enum ip_pkt_priority q_num,
+				      struct sk_buff *tqe)
 {
-	unsigned long flags;
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc = vif->wilc;
 
-	spin_lock_irqsave(&wilc->txq_spinlock, flags);
+	wilc_set_tx_cb(tqe, type, q_num);
 
-	list_add_tail(&tqe->list, &wilc->txq[q_num].txq_head.list);
-	wilc->txq_entries += 1;
-	wilc->txq[q_num].count++;
-
-	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
+	skb_queue_tail(&wilc->txq[q_num], tqe);
+	atomic_inc(&wilc->txq_entries);
 
 	wake_up_interruptible(&wilc->txq_event);
 }
 
-static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif, u8 q_num,
-				      struct txq_entry_t *tqe)
+static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif, int type, u8 q_num,
+				      struct sk_buff *tqe)
 {
-	unsigned long flags;
 	struct wilc *wilc = vif->wilc;
 
-	mutex_lock(&wilc->txq_add_to_head_cs);
+	wilc_set_tx_cb(tqe, type, q_num);
 
-	spin_lock_irqsave(&wilc->txq_spinlock, flags);
+	mutex_lock(&wilc->txq_add_to_head_cs);
 
-	list_add(&tqe->list, &wilc->txq[q_num].txq_head.list);
-	wilc->txq_entries += 1;
-	wilc->txq[q_num].count++;
+	skb_queue_head(&wilc->txq[q_num], tqe);
+	atomic_inc(&wilc->txq_entries);
 
-	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 	mutex_unlock(&wilc->txq_add_to_head_cs);
 	wake_up_interruptible(&wilc->txq_event);
 }
 
-#define NOT_TCP_ACK			(-1)
-
 static inline void add_tcp_session(struct wilc_vif *vif, u32 src_prt,
 				   u32 dst_prt, u32 seq)
 {
@@ -122,8 +98,9 @@ static inline void update_tcp_session(struct wilc_vif *vif, u32 index, u32 ack)
 
 static inline void add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
 				       u32 session_index,
-				       struct txq_entry_t *txqe)
+				       struct sk_buff *txqe)
 {
+	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(txqe);
 	struct tcp_ack_filter *f = &vif->ack_filter;
 	u32 i = f->pending_base + f->pending_acks_idx;
 
@@ -131,14 +108,14 @@ static inline void add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
 		f->pending_acks[i].ack_num = ack;
 		f->pending_acks[i].txqe = txqe;
 		f->pending_acks[i].session_index = session_index;
-		txqe->ack_idx = i;
+		tx_cb->ack_idx = i;
 		f->pending_acks_idx++;
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
@@ -188,6 +165,36 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 }
 
+static void wilc_wlan_tx_packet_done(struct sk_buff *skb, int status)
+{
+	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(skb);
+	struct wilc_vif *vif = netdev_priv(skb->dev);
+	int ack_idx = tx_cb->ack_idx;
+
+	if (vif && ack_idx != NOT_TCP_ACK && ack_idx < MAX_PENDING_ACKS)
+		vif->ack_filter.pending_acks[ack_idx].txqe = NULL;
+	if (status)
+		dev_consume_skb_any(skb);
+	else
+		dev_kfree_skb_any(skb);
+}
+
+static void wilc_wlan_txq_drop_net_pkt(struct sk_buff *skb)
+{
+	struct wilc_vif *vif = netdev_priv(skb->dev);
+	struct wilc *wilc = vif->wilc;
+	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(skb);
+
+	if ((u8)tx_cb->q_num >= NQUEUES) {
+		netdev_err(vif->ndev, "Invalid AC queue number %d",
+			   tx_cb->q_num);
+		return;
+	}
+	skb_unlink(skb, &wilc->txq[tx_cb->q_num]);
+	atomic_dec(&wilc->txq_entries);
+	wilc_wlan_tx_packet_done(skb, 1);
+}
+
 static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 {
 	struct wilc_vif *vif = netdev_priv(dev);
@@ -213,17 +220,11 @@ static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 		bigger_ack_num = f->ack_session_info[index].bigger_ack_num;
 
 		if (f->pending_acks[i].ack_num < bigger_ack_num) {
-			struct txq_entry_t *tqe;
+			struct sk_buff *tqe;
 
 			tqe = f->pending_acks[i].txqe;
-			if (tqe) {
-				wilc_wlan_txq_remove(wilc, tqe->q_num, tqe);
-				tqe->status = 1;
-				if (tqe->tx_complete_func)
-					tqe->tx_complete_func(tqe->priv,
-							      tqe->status);
-				kfree(tqe);
-			}
+			if (tqe)
+				wilc_wlan_txq_drop_net_pkt(tqe);
 		}
 	}
 	f->pending_acks_idx = 0;
@@ -242,35 +243,18 @@ void wilc_enable_tcp_ack_filter(struct wilc_vif *vif, bool value)
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
 
-	tqe->type = WILC_CFG_PKT;
-	tqe->buffer = buffer;
-	tqe->buffer_size = buffer_size;
-	tqe->tx_complete_func = NULL;
-	tqe->priv = NULL;
-	tqe->q_num = AC_VO_Q;
-	tqe->ack_idx = NOT_TCP_ACK;
-	tqe->vif = vif;
-
-	wilc_wlan_txq_add_to_head(vif, AC_VO_Q, tqe);
+	wilc_wlan_txq_add_to_head(vif, WILC_CFG_PKT, AC_VO_Q, tqe);
 
 	return 1;
 }
@@ -314,7 +298,7 @@ static bool is_ac_q_limit(struct wilc *wl, u8 q_num)
 	else
 		q_limit = (q->cnt[q_num] * FLOW_CONTROL_UPPER_THRESHOLD / q->sum) + 1;
 
-	if (wl->txq[q_num].count <= q_limit)
+	if (skb_queue_len(&wl->txq[q_num]) <= q_limit)
 		ret = true;
 
 	spin_unlock_irqrestore(&wl->txq_spinlock, flags);
@@ -369,32 +353,32 @@ static inline int ac_balance(struct wilc *wl, u8 *ratio)
 		return -EINVAL;
 
 	for (i = 0; i < NQUEUES; i++)
-		if (wl->txq[i].fw.count > max_count)
-			max_count = wl->txq[i].fw.count;
+		if (wl->fw[i].count > max_count)
+			max_count = wl->fw[i].count;
 
 	for (i = 0; i < NQUEUES; i++)
-		ratio[i] = max_count - wl->txq[i].fw.count;
+		ratio[i] = max_count - wl->fw[i].count;
 
 	return 0;
 }
 
 static inline void ac_update_fw_ac_pkt_info(struct wilc *wl, u32 reg)
 {
-	wl->txq[AC_BK_Q].fw.count = FIELD_GET(BK_AC_COUNT_FIELD, reg);
-	wl->txq[AC_BE_Q].fw.count = FIELD_GET(BE_AC_COUNT_FIELD, reg);
-	wl->txq[AC_VI_Q].fw.count = FIELD_GET(VI_AC_COUNT_FIELD, reg);
-	wl->txq[AC_VO_Q].fw.count = FIELD_GET(VO_AC_COUNT_FIELD, reg);
-
-	wl->txq[AC_BK_Q].fw.acm = FIELD_GET(BK_AC_ACM_STAT_FIELD, reg);
-	wl->txq[AC_BE_Q].fw.acm = FIELD_GET(BE_AC_ACM_STAT_FIELD, reg);
-	wl->txq[AC_VI_Q].fw.acm = FIELD_GET(VI_AC_ACM_STAT_FIELD, reg);
-	wl->txq[AC_VO_Q].fw.acm = FIELD_GET(VO_AC_ACM_STAT_FIELD, reg);
+	wl->fw[AC_BK_Q].count = FIELD_GET(BK_AC_COUNT_FIELD, reg);
+	wl->fw[AC_BE_Q].count = FIELD_GET(BE_AC_COUNT_FIELD, reg);
+	wl->fw[AC_VI_Q].count = FIELD_GET(VI_AC_COUNT_FIELD, reg);
+	wl->fw[AC_VO_Q].count = FIELD_GET(VO_AC_COUNT_FIELD, reg);
+
+	wl->fw[AC_BK_Q].acm = FIELD_GET(BK_AC_ACM_STAT_FIELD, reg);
+	wl->fw[AC_BE_Q].acm = FIELD_GET(BE_AC_ACM_STAT_FIELD, reg);
+	wl->fw[AC_VI_Q].acm = FIELD_GET(VI_AC_ACM_STAT_FIELD, reg);
+	wl->fw[AC_VO_Q].acm = FIELD_GET(VO_AC_ACM_STAT_FIELD, reg);
 }
 
 static inline u8 ac_change(struct wilc *wilc, u8 *ac)
 {
 	do {
-		if (wilc->txq[*ac].fw.acm == 0)
+		if (wilc->fw[*ac].acm == 0)
 			return 0;
 		(*ac)++;
 	} while (*ac < NQUEUES);
@@ -402,132 +386,59 @@ static inline u8 ac_change(struct wilc *wilc, u8 *ac)
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
 
 	wilc = vif->wilc;
+	q_num = ac_classify(wilc, tqe);
 
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
-	tqe->type = WILC_NET_PKT;
-	tqe->buffer = buffer;
-	tqe->buffer_size = buffer_size;
-	tqe->tx_complete_func = tx_complete_fn;
-	tqe->priv = tx_data;
-	tqe->vif = vif;
-
-	q_num = ac_classify(wilc, tx_data->skb);
-	tqe->q_num = q_num;
 	if (ac_change(wilc, &q_num)) {
-		tx_complete_fn(tx_data, 0);
-		kfree(tqe);
+		dev_kfree_skb_any(tqe);
 		return 0;
 	}
 
 	if (is_ac_q_limit(wilc, q_num)) {
-		tqe->ack_idx = NOT_TCP_ACK;
 		if (vif->ack_filter.enabled)
 			tcp_process(dev, tqe);
-		wilc_wlan_txq_add_to_tail(dev, q_num, tqe);
+		wilc_wlan_txq_add_to_tail(dev, WILC_NET_PKT, q_num, tqe);
 	} else {
-		tx_complete_fn(tx_data, 0);
-		kfree(tqe);
+		dev_kfree_skb_any(tqe);
 	}
-
-	return wilc->txq_entries;
+	return atomic_read(&wilc->txq_entries);
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
-
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
-	tqe->type = WILC_MGMT_PKT;
-	tqe->buffer = buffer;
-	tqe->buffer_size = buffer_size;
-	tqe->tx_complete_func = tx_complete_fn;
-	tqe->priv = priv;
-	tqe->q_num = AC_BE_Q;
-	tqe->ack_idx = NOT_TCP_ACK;
-	tqe->vif = vif;
-	wilc_wlan_txq_add_to_tail(dev, AC_VO_Q, tqe);
+	wilc_wlan_txq_add_to_tail(dev, WILC_MGMT_PKT, AC_VO_Q, tqe);
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
@@ -702,7 +613,9 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	u32 offset = 0;
 	bool max_size_over = 0, ac_exist = 0;
 	int vmm_sz = 0;
-	struct txq_entry_t *tqe_q[NQUEUES];
+	struct sk_buff *tqe_q[NQUEUES];
+	struct wilc_skb_tx_cb *tx_cb;
+	int ack_idx;
 	int ret = 0;
 	int counter;
 	int timeout;
@@ -727,7 +640,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	srcu_read_unlock(&wilc->srcu, srcu_idx);
 
 	for (ac = 0; ac < NQUEUES; ac++)
-		tqe_q[ac] = wilc_wlan_txq_get_first(wilc, ac);
+		tqe_q[ac] = skb_peek(&wilc->txq[ac]);
 
 	i = 0;
 	sum = 0;
@@ -747,14 +660,15 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 					break;
 				}
 
-				if (tqe_q[ac]->type == WILC_CFG_PKT)
+				tx_cb = WILC_SKB_TX_CB(tqe_q[ac]);
+				if (tx_cb->type == WILC_CFG_PKT)
 					vmm_sz = ETH_CONFIG_PKT_HDR_OFFSET;
-				else if (tqe_q[ac]->type == WILC_NET_PKT)
+				else if (tx_cb->type == WILC_NET_PKT)
 					vmm_sz = ETH_ETHERNET_HDR_OFFSET;
 				else
 					vmm_sz = HOST_HDR_OFFSET;
 
-				vmm_sz += tqe_q[ac]->buffer_size;
+				vmm_sz += tqe_q[ac]->len;
 				vmm_sz = ALIGN(vmm_sz, 4);
 
 				if ((sum + vmm_sz) > WILC_TX_BUFF_SIZE) {
@@ -762,7 +676,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 					break;
 				}
 				vmm_table[i] = vmm_sz / 4;
-				if (tqe_q[ac]->type == WILC_CFG_PKT)
+				if (tx_cb->type == WILC_CFG_PKT)
 					vmm_table[i] |= BIT(10);
 
 				cpu_to_le32s(&vmm_table[i]);
@@ -770,9 +684,8 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 
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
@@ -860,17 +773,19 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
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
+		atomic_dec(&wilc->txq_entries);
+		tx_cb = WILC_SKB_TX_CB(tqe);
 		ac_pkt_num_to_chip[vmm_entries_ac[i]]++;
 		if (!tqe)
 			break;
 
-		vif = tqe->vif;
+		vif = netdev_priv(tqe->dev);
 		if (vmm_table[i] == 0)
 			break;
 
@@ -878,22 +793,22 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 		vmm_sz = FIELD_GET(WILC_VMM_BUFFER_SIZE, vmm_table[i]);
 		vmm_sz *= 4;
 
-		if (tqe->type == WILC_MGMT_PKT)
+		if (tx_cb->type == WILC_MGMT_PKT)
 			mgmt_ptk = 1;
 
-		header = (FIELD_PREP(WILC_VMM_HDR_TYPE, tqe->type) |
+		header = (FIELD_PREP(WILC_VMM_HDR_TYPE, tx_cb->type) |
 			  FIELD_PREP(WILC_VMM_HDR_MGMT_FIELD, mgmt_ptk) |
-			  FIELD_PREP(WILC_VMM_HDR_PKT_SIZE, tqe->buffer_size) |
+			  FIELD_PREP(WILC_VMM_HDR_PKT_SIZE, tqe->len) |
 			  FIELD_PREP(WILC_VMM_HDR_BUFF_SIZE, vmm_sz));
 
 		cpu_to_le32s(&header);
 		memcpy(&txb[offset], &header, 4);
-		if (tqe->type == WILC_CFG_PKT) {
+		if (tx_cb->type == WILC_CFG_PKT) {
 			buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
-		} else if (tqe->type == WILC_NET_PKT) {
-			int prio = tqe->q_num;
+		} else if (tx_cb->type == WILC_NET_PKT) {
+			int prio = tx_cb->q_num;
 
-			bssid = tqe->vif->bssid;
+			bssid = vif->bssid;
 			buffer_offset = ETH_ETHERNET_HDR_OFFSET;
 			memcpy(&txb[offset + 4], &prio, sizeof(prio));
 			memcpy(&txb[offset + 8], bssid, 6);
@@ -901,20 +816,16 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 			buffer_offset = HOST_HDR_OFFSET;
 		}
 
-		memcpy(&txb[offset + buffer_offset],
-		       tqe->buffer, tqe->buffer_size);
+		memcpy(&txb[offset + buffer_offset], tqe->data, tqe->len);
 		offset += vmm_sz;
 		i++;
-		tqe->status = 1;
-		if (tqe->tx_complete_func)
-			tqe->tx_complete_func(tqe->priv, tqe->status);
-		if (tqe->ack_idx != NOT_TCP_ACK &&
-		    tqe->ack_idx < MAX_PENDING_ACKS)
-			vif->ack_filter.pending_acks[tqe->ack_idx].txqe = NULL;
-		kfree(tqe);
+		ack_idx = tx_cb->ack_idx;
+		if (ack_idx != NOT_TCP_ACK && ack_idx < MAX_PENDING_ACKS)
+			vif->ack_filter.pending_acks[ack_idx].txqe = NULL;
+		wilc_wlan_tx_packet_done(tqe, 1);
 	} while (--entries);
 	for (i = 0; i < NQUEUES; i++)
-		wilc->txq[i].fw.count += ac_pkt_num_to_chip[i];
+		wilc->fw[i].count += ac_pkt_num_to_chip[i];
 
 	ret = func->hif_clear_int_ext(wilc, ENABLE_TX_VMM);
 	if (ret)
@@ -929,7 +840,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	mutex_unlock(&wilc->txq_add_to_head_cs);
 
 out_update_cnt:
-	*txq_count = wilc->txq_entries;
+	*txq_count = atomic_read(&wilc->txq_entries);
 	return ret;
 }
 
@@ -1220,7 +1131,7 @@ int wilc_wlan_stop(struct wilc *wilc, struct wilc_vif *vif)
 
 void wilc_wlan_cleanup(struct net_device *dev)
 {
-	struct txq_entry_t *tqe;
+	struct sk_buff *tqe, *cfg_skb;
 	struct rxq_entry_t *rqe;
 	u8 ac;
 	struct wilc_vif *vif = netdev_priv(dev);
@@ -1228,11 +1139,14 @@ void wilc_wlan_cleanup(struct net_device *dev)
 
 	wilc->quit = 1;
 	for (ac = 0; ac < NQUEUES; ac++) {
-		while ((tqe = wilc_wlan_txq_remove_from_head(wilc, ac))) {
-			if (tqe->tx_complete_func)
-				tqe->tx_complete_func(tqe->priv, 0);
-			kfree(tqe);
-		}
+		while ((tqe = skb_dequeue(&wilc->txq[ac])))
+			wilc_wlan_tx_packet_done(tqe, 0);
+		atomic_set(&wilc->txq_entries, 0);
+	}
+	cfg_skb = wilc->cfg_skb;
+	if (cfg_skb) {
+		wilc->cfg_skb = NULL;
+		dev_kfree_skb_any(cfg_skb);
 	}
 
 	while ((rqe = wilc_wlan_rxq_remove(wilc)))
@@ -1245,105 +1159,124 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	wilc->hif_func->hif_deinit(wilc);
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
-
-	if (type == WILC_CFG_SET)
-		cfg->hdr.cmd_type = 'W';
-	else
-		cfg->hdr.cmd_type = 'Q';
+	struct wilc_cfg_cmd_hdr *hdr;
+	int ret;
 
-	cfg->hdr.seq_no = wilc->cfg_seq_no % 256;
-	cfg->hdr.total_len = cpu_to_le16(t_len);
-	cfg->hdr.driver_handler = cpu_to_le32(drv_handler);
-	wilc->cfg_seq_no = cfg->hdr.seq_no;
+	hdr = skb_push(wilc->cfg_skb, sizeof(*hdr));
 
-	if (!wilc_wlan_txq_add_cfg_pkt(vif, (u8 *)&cfg->hdr, t_len))
-		return -1;
+	hdr->cmd_type = (type == WILC_CFG_SET) ? 'W' : 'Q';
+	hdr->seq_no = wilc->cfg_seq_no;
+	hdr->total_len = cpu_to_le16(wilc->cfg_skb->len);
+	hdr->driver_handler = cpu_to_le32(drv_handler);
 
-	return 0;
+	ret = wilc_wlan_txq_add_cfg_pkt(vif, wilc->cfg_skb);
+	/* packet is now either owned by tx queue or has been dropped: */
+	wilc->cfg_skb = NULL;
+	return ret == 0;
 }
 
-int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
-		      u32 buffer_size, int commit, u32 drv_handler)
+/**
+ * Add a WID set/query to the current config packet and optionally
+ * submit the resulting packet to the chip and wait for its reply.
+ * Returns 0 on failure, positive number on success.
+ */
+static int wilc_wlan_cfg_apply_wid(struct wilc_vif *vif, int start, u16 wid,
+				   u8 *buffer, u32 buffer_size, int commit,
+				   u32 drv_handler, bool set)
 {
-	u32 offset;
 	int ret_size;
 	struct wilc *wilc = vif->wilc;
 
 	mutex_lock(&wilc->cfg_cmd_lock);
 
-	if (start)
-		wilc->cfg_frame_offset = 0;
-
-	offset = wilc->cfg_frame_offset;
-	ret_size = wilc_wlan_cfg_set_wid(wilc->cfg_frame.frame, offset,
-					 wid, buffer, buffer_size);
-	offset += ret_size;
-	wilc->cfg_frame_offset = offset;
-
-	if (!commit) {
-		mutex_unlock(&wilc->cfg_cmd_lock);
-		return ret_size;
+	if (start) {
+		WARN_ON(wilc->cfg_skb);
+		wilc->cfg_skb = alloc_cfg_skb(vif);
+		if (!wilc->cfg_skb) {
+			netdev_dbg(vif->ndev, "Failed to alloc cfg_skb");
+			return 0;
+		}
 	}
 
-	netdev_dbg(vif->ndev, "%s: seqno[%d]\n", __func__, wilc->cfg_seq_no);
-
-	if (wilc_wlan_cfg_commit(vif, WILC_CFG_SET, drv_handler))
-		ret_size = 0;
+	if (set)
+		ret_size = wilc_wlan_cfg_set_wid(wilc->cfg_skb->tail, 0,
+						 wid, buffer, buffer_size);
+	else
+		ret_size = wilc_wlan_cfg_get_wid(wilc->cfg_skb->tail, 0, wid);
+
+	if (ret_size == 0)
+		netdev_dbg(vif->ndev,
+			   "Failed to add WID 0x%x to %s cfg packet\n",
+			   wid, set ? "set" : "query");
+
+	skb_put(wilc->cfg_skb, ret_size);
+
+	if (commit) {
+		if (wilc_wlan_cfg_commit(vif,
+					 set ? WILC_CFG_SET : WILC_CFG_QUERY,
+					 drv_handler)) {
+			netdev_dbg(vif->ndev, "Failed to commit cfg packet");
+			ret_size = 0;
+			goto out;
+		}
 
-	if (!wait_for_completion_timeout(&wilc->cfg_event,
-					 WILC_CFG_PKTS_TIMEOUT)) {
-		netdev_dbg(vif->ndev, "%s: Timed Out\n", __func__);
-		ret_size = 0;
+		if (!wait_for_completion_timeout(&wilc->cfg_event,
+						 WILC_CFG_PKTS_TIMEOUT)) {
+			netdev_dbg(vif->ndev, "%s: Timed Out\n", __func__);
+			ret_size = 0;
+			goto out;
+		}
+		wilc->cfg_seq_no = (wilc->cfg_seq_no + 1) % 256;
 	}
-
-	wilc->cfg_frame_offset = 0;
-	wilc->cfg_seq_no += 1;
+out:
 	mutex_unlock(&wilc->cfg_cmd_lock);
-
 	return ret_size;
 }
 
+int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
+		      u32 buffer_size, int commit, u32 drv_handler)
+{
+	return wilc_wlan_cfg_apply_wid(vif, start, wid, buffer, buffer_size,
+				       commit, drv_handler, true);
+}
+
 int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 		      u32 drv_handler)
 {
-	u32 offset;
-	int ret_size;
-	struct wilc *wilc = vif->wilc;
-
-	mutex_lock(&wilc->cfg_cmd_lock);
-
-	if (start)
-		wilc->cfg_frame_offset = 0;
-
-	offset = wilc->cfg_frame_offset;
-	ret_size = wilc_wlan_cfg_get_wid(wilc->cfg_frame.frame, offset, wid);
-	offset += ret_size;
-	wilc->cfg_frame_offset = offset;
-
-	if (!commit) {
-		mutex_unlock(&wilc->cfg_cmd_lock);
-		return ret_size;
-	}
-
-	if (wilc_wlan_cfg_commit(vif, WILC_CFG_QUERY, drv_handler))
-		ret_size = 0;
-
-	if (!wait_for_completion_timeout(&wilc->cfg_event,
-					 WILC_CFG_PKTS_TIMEOUT)) {
-		netdev_dbg(vif->ndev, "%s: Timed Out\n", __func__);
-		ret_size = 0;
-	}
-	wilc->cfg_frame_offset = 0;
-	wilc->cfg_seq_no += 1;
-	mutex_unlock(&wilc->cfg_cmd_lock);
-
-	return ret_size;
+	return wilc_wlan_cfg_apply_wid(vif, start, wid, NULL, 0,
+				       commit, drv_handler, false);
 }
 
 int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.h b/drivers/net/wireless/microchip/wilc1000/wlan.h
index eb7978166d73..10618327133c 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.h
@@ -320,30 +320,26 @@ enum ip_pkt_priority {
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
 
+static inline struct wilc_skb_tx_cb *WILC_SKB_TX_CB(struct sk_buff *skb)
+{
+	BUILD_BUG_ON(sizeof(struct wilc_skb_tx_cb) > sizeof(skb->cb));
+	return (struct wilc_skb_tx_cb *)&skb->cb[0];
+}
+
 struct txq_fw_recv_queue_stat {
 	u8 acm;
 	u8 count;
 };
 
-struct txq_handle {
-	struct txq_entry_t txq_head;
-	u16 count;
-	struct txq_fw_recv_queue_stat fw;
-};
-
 struct rxq_entry_t {
 	struct list_head list;
 	u8 *buffer;
@@ -376,12 +372,6 @@ struct wilc_hif_func {
 
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
@@ -389,11 +379,6 @@ struct wilc_cfg_cmd_hdr {
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
@@ -405,19 +390,16 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
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

