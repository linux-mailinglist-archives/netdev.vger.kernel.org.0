Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A06814394
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 04:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfEFCuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 22:50:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7165 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726365AbfEFCuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 22:50:22 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A017DA17872DE1077FFB;
        Mon,  6 May 2019 10:50:18 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 6 May 2019 10:50:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <nhorman@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 01/12] net: hns3: unify maybe_stop_tx for TSO and non-TSO case
Date:   Mon, 6 May 2019 10:48:41 +0800
Message-ID: <1557110932-683-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
References: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently, maybe_stop_tx ops for TSO and non-TSO case share some BD
calculation code, so this patch unifies the maybe_stop_tx by removing
the maybe_stop_tx ops. skb_is_gso() can be used to differentiate the
case between TSO and non-TSO case if there is need to handle special
case for TSO case.

This patch also add tx_copy field in "ethtool --statistics" to help
better debug the performance issue caused by calling skb_copy.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 128 ++++++++-------------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   1 +
 3 files changed, 50 insertions(+), 86 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 96272e6..06dda77 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1154,64 +1154,48 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	return 0;
 }
 
-static int hns3_nic_maybe_stop_tso(struct sk_buff **out_skb, int *bnum,
-				   struct hns3_enet_ring *ring)
+static int hns3_nic_bd_num(struct sk_buff *skb)
 {
-	struct sk_buff *skb = *out_skb;
-	struct sk_buff *new_skb = NULL;
-	struct skb_frag_struct *frag;
-	int bdnum_for_frag;
-	int frag_num;
-	int buf_num;
-	int size;
-	int i;
+	int size = skb_headlen(skb);
+	int i, bd_num;
 
-	size = skb_headlen(skb);
-	buf_num = hns3_tx_bd_count(size);
+	/* if the total len is within the max bd limit */
+	if (likely(skb->len <= HNS3_MAX_BD_SIZE))
+		return skb_shinfo(skb)->nr_frags + 1;
 
-	frag_num = skb_shinfo(skb)->nr_frags;
-	for (i = 0; i < frag_num; i++) {
-		frag = &skb_shinfo(skb)->frags[i];
-		size = skb_frag_size(frag);
-		bdnum_for_frag = hns3_tx_bd_count(size);
-		if (unlikely(bdnum_for_frag > HNS3_MAX_BD_PER_FRAG))
-			return -ENOMEM;
+	bd_num = hns3_tx_bd_count(size);
 
-		buf_num += bdnum_for_frag;
-	}
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i];
+		int frag_bd_num;
 
-	if (unlikely(buf_num > HNS3_MAX_BD_PER_FRAG)) {
-		buf_num = hns3_tx_bd_count(skb->len);
-		if (ring_space(ring) < buf_num)
-			return -EBUSY;
-		/* manual split the send packet */
-		new_skb = skb_copy(skb, GFP_ATOMIC);
-		if (!new_skb)
+		size = skb_frag_size(frag);
+		frag_bd_num = hns3_tx_bd_count(size);
+
+		if (unlikely(frag_bd_num > HNS3_MAX_BD_PER_FRAG))
 			return -ENOMEM;
-		dev_kfree_skb_any(skb);
-		*out_skb = new_skb;
-	}
 
-	if (unlikely(ring_space(ring) < buf_num))
-		return -EBUSY;
+		bd_num += frag_bd_num;
+	}
 
-	*bnum = buf_num;
-	return 0;
+	return bd_num;
 }
 
-static int hns3_nic_maybe_stop_tx(struct sk_buff **out_skb, int *bnum,
-				  struct hns3_enet_ring *ring)
+static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
+				  struct sk_buff **out_skb)
 {
 	struct sk_buff *skb = *out_skb;
-	struct sk_buff *new_skb = NULL;
-	int buf_num;
+	int bd_num;
 
-	/* No. of segments (plus a header) */
-	buf_num = skb_shinfo(skb)->nr_frags + 1;
+	bd_num = hns3_nic_bd_num(skb);
+	if (bd_num < 0)
+		return bd_num;
+
+	if (unlikely(bd_num > HNS3_MAX_BD_PER_FRAG)) {
+		struct sk_buff *new_skb;
 
-	if (unlikely(buf_num > HNS3_MAX_BD_PER_FRAG)) {
-		buf_num = hns3_tx_bd_count(skb->len);
-		if (ring_space(ring) < buf_num)
+		bd_num = hns3_tx_bd_count(skb->len);
+		if (unlikely(ring_space(ring) < bd_num))
 			return -EBUSY;
 		/* manual split the send packet */
 		new_skb = skb_copy(skb, GFP_ATOMIC);
@@ -1219,14 +1203,16 @@ static int hns3_nic_maybe_stop_tx(struct sk_buff **out_skb, int *bnum,
 			return -ENOMEM;
 		dev_kfree_skb_any(skb);
 		*out_skb = new_skb;
+
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.tx_copy++;
+		u64_stats_update_end(&ring->syncp);
 	}
 
-	if (unlikely(ring_space(ring) < buf_num))
+	if (unlikely(ring_space(ring) < bd_num))
 		return -EBUSY;
 
-	*bnum = buf_num;
-
-	return 0;
+	return bd_num;
 }
 
 static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
@@ -1277,22 +1263,23 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	/* Prefetch the data used later */
 	prefetch(skb->data);
 
-	switch (priv->ops.maybe_stop_tx(&skb, &buf_num, ring)) {
-	case -EBUSY:
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_busy++;
-		u64_stats_update_end(&ring->syncp);
+	buf_num = hns3_nic_maybe_stop_tx(ring, &skb);
+	if (unlikely(buf_num <= 0)) {
+		if (buf_num == -EBUSY) {
+			u64_stats_update_begin(&ring->syncp);
+			ring->stats.tx_busy++;
+			u64_stats_update_end(&ring->syncp);
+			goto out_net_tx_busy;
+		} else if (buf_num == -ENOMEM) {
+			u64_stats_update_begin(&ring->syncp);
+			ring->stats.sw_err_cnt++;
+			u64_stats_update_end(&ring->syncp);
+		}
 
-		goto out_net_tx_busy;
-	case -ENOMEM:
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
-		netdev_err(netdev, "no memory to xmit!\n");
+		if (net_ratelimit())
+			netdev_err(netdev, "xmit error: %d!\n", buf_num);
 
 		goto out_err_tx_ok;
-	default:
-		break;
 	}
 
 	/* No. of segments (plus a header) */
@@ -1397,13 +1384,6 @@ static int hns3_nic_set_features(struct net_device *netdev,
 	bool enable;
 	int ret;
 
-	if (changed & (NETIF_F_TSO | NETIF_F_TSO6)) {
-		if (features & (NETIF_F_TSO | NETIF_F_TSO6))
-			priv->ops.maybe_stop_tx = hns3_nic_maybe_stop_tso;
-		else
-			priv->ops.maybe_stop_tx = hns3_nic_maybe_stop_tx;
-	}
-
 	if (changed & (NETIF_F_GRO_HW) && h->ae_algo->ops->set_gro_en) {
 		enable = !!(features & NETIF_F_GRO_HW);
 		ret = h->ae_algo->ops->set_gro_en(h, enable);
@@ -3733,17 +3713,6 @@ static void hns3_del_all_fd_rules(struct net_device *netdev, bool clear_list)
 		h->ae_algo->ops->del_all_fd_entries(h, clear_list);
 }
 
-static void hns3_nic_set_priv_ops(struct net_device *netdev)
-{
-	struct hns3_nic_priv *priv = netdev_priv(netdev);
-
-	if ((netdev->features & NETIF_F_TSO) ||
-	    (netdev->features & NETIF_F_TSO6))
-		priv->ops.maybe_stop_tx = hns3_nic_maybe_stop_tso;
-	else
-		priv->ops.maybe_stop_tx = hns3_nic_maybe_stop_tx;
-}
-
 static int hns3_client_start(struct hnae3_handle *handle)
 {
 	if (!handle->ae_algo->ops->client_start)
@@ -3810,7 +3779,6 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	netdev->netdev_ops = &hns3_nic_netdev_ops;
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 	hns3_ethtool_set_ops(netdev);
-	hns3_nic_set_priv_ops(netdev);
 
 	/* Carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 2b4f5ea..f669412 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -376,6 +376,7 @@ struct ring_stats {
 			u64 tx_err_cnt;
 			u64 restart_queue;
 			u64 tx_busy;
+			u64 tx_copy;
 		};
 		struct {
 			u64 rx_pkts;
@@ -444,11 +445,6 @@ struct hns3_nic_ring_data {
 	void (*fini_process)(struct hns3_nic_ring_data *);
 };
 
-struct hns3_nic_ops {
-	int (*maybe_stop_tx)(struct sk_buff **out_skb,
-			     int *bnum, struct hns3_enet_ring *ring);
-};
-
 enum hns3_flow_level_range {
 	HNS3_FLOW_LOW = 0,
 	HNS3_FLOW_MID = 1,
@@ -538,7 +534,6 @@ struct hns3_nic_priv {
 	u32 port_id;
 	struct net_device *netdev;
 	struct device *dev;
-	struct hns3_nic_ops ops;
 
 	/**
 	 * the cb for nic to manage the ring buffer, the first half of the
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 1746943..7256ed4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -29,6 +29,7 @@ static const struct hns3_stats hns3_txq_stats[] = {
 	HNS3_TQP_STAT("errors", tx_err_cnt),
 	HNS3_TQP_STAT("wake", restart_queue),
 	HNS3_TQP_STAT("busy", tx_busy),
+	HNS3_TQP_STAT("copy", tx_copy),
 };
 
 #define HNS3_TXQ_STATS_COUNT ARRAY_SIZE(hns3_txq_stats)
-- 
2.7.4

