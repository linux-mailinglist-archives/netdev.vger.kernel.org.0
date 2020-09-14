Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEFE26938E
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgINRff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:35:35 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11839 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726393AbgINM1U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 08:27:20 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E22287CA5DD0F35F7E45;
        Mon, 14 Sep 2020 20:09:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Mon, 14 Sep 2020 20:09:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/6] net: hns3: optimize the tx clean process
Date:   Mon, 14 Sep 2020 20:06:54 +0800
Message-ID: <1600085217-26245-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
References: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently HNS3_RING_TX_RING_HEAD_REG register is read to determine
how many tx desc can be cleaned. To avoid the register read operation
in the critical data path, use the valid bit in the tx desc to determine
if a specific tx desc can be cleaned.

The hns3 driver sets valid bit in the tx desc before ringing a doorbell
to the hw, and hw will only clear the valid bit of the tx desc after
corresponding packet is sent out to the wire. And because next_to_use
for tx ring is a changing variable when the driver is filling the tx
desc, so reuse the pull_len for rx ring to record the tx desc that has
notified to the hw, so that hns3_nic_reclaim_desc() can decide how many
tx desc's valid bit need checking when reclaiming tx desc.

And io_err_cnt stat is also removed for it is not used anymore.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 64 ++++++++++------------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    | 12 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  2 -
 3 files changed, 33 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 6a57c0d..2db6c03 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1402,6 +1402,7 @@ static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
 
 	hnae3_queue_xmit(ring->tqp, ring->pending_buf);
 	ring->pending_buf = 0;
+	WRITE_ONCE(ring->last_to_use, ring->next_to_use);
 }
 
 netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
@@ -1863,10 +1864,9 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 		    tx_ring->next_to_clean, napi->state);
 
 	netdev_info(ndev,
-		    "tx_pkts: %llu, tx_bytes: %llu, io_err_cnt: %llu, sw_err_cnt: %llu, tx_pending: %d\n",
+		    "tx_pkts: %llu, tx_bytes: %llu, sw_err_cnt: %llu, tx_pending: %d\n",
 		    tx_ring->stats.tx_pkts, tx_ring->stats.tx_bytes,
-		    tx_ring->stats.io_err_cnt, tx_ring->stats.sw_err_cnt,
-		    tx_ring->pending_buf);
+		    tx_ring->stats.sw_err_cnt, tx_ring->pending_buf);
 
 	netdev_info(ndev,
 		    "seg_pkt_cnt: %llu, tx_more: %llu, restart_queue: %llu, tx_busy: %llu\n",
@@ -2491,13 +2491,26 @@ static void hns3_reuse_buffer(struct hns3_enet_ring *ring, int i)
 			DMA_FROM_DEVICE);
 }
 
-static void hns3_nic_reclaim_desc(struct hns3_enet_ring *ring, int head,
+static bool hns3_nic_reclaim_desc(struct hns3_enet_ring *ring,
 				  int *bytes, int *pkts)
 {
+	/* pair with ring->last_to_use update in hns3_tx_doorbell(),
+	 * smp_store_release() is not used in hns3_tx_doorbell() because
+	 * the doorbell operation already have the needed barrier operation.
+	 */
+	int ltu = smp_load_acquire(&ring->last_to_use);
 	int ntc = ring->next_to_clean;
 	struct hns3_desc_cb *desc_cb;
+	bool reclaimed = false;
+	struct hns3_desc *desc;
+
+	while (ltu != ntc) {
+		desc = &ring->desc[ntc];
+
+		if (le16_to_cpu(desc->tx.bdtp_fe_sc_vld_ra_ri) &
+				BIT(HNS3_TXD_VLD_B))
+			break;
 
-	while (head != ntc) {
 		desc_cb = &ring->desc_cb[ntc];
 		(*pkts) += (desc_cb->type == DESC_TYPE_SKB);
 		(*bytes) += desc_cb->length;
@@ -2509,23 +2522,17 @@ static void hns3_nic_reclaim_desc(struct hns3_enet_ring *ring, int head,
 
 		/* Issue prefetch for next Tx descriptor */
 		prefetch(&ring->desc_cb[ntc]);
+		reclaimed = true;
 	}
 
+	if (unlikely(!reclaimed))
+		return false;
+
 	/* This smp_store_release() pairs with smp_load_acquire() in
 	 * ring_space called by hns3_nic_net_xmit.
 	 */
 	smp_store_release(&ring->next_to_clean, ntc);
-}
-
-static int is_valid_clean_head(struct hns3_enet_ring *ring, int h)
-{
-	int u = ring->next_to_use;
-	int c = ring->next_to_clean;
-
-	if (unlikely(h > ring->desc_num))
-		return 0;
-
-	return u > c ? (h > c && h <= u) : (h > c || h <= u);
+	return true;
 }
 
 void hns3_clean_tx_ring(struct hns3_enet_ring *ring)
@@ -2534,28 +2541,12 @@ void hns3_clean_tx_ring(struct hns3_enet_ring *ring)
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct netdev_queue *dev_queue;
 	int bytes, pkts;
-	int head;
-
-	head = readl_relaxed(ring->tqp->io_base + HNS3_RING_TX_RING_HEAD_REG);
-
-	if (is_ring_empty(ring) || head == ring->next_to_clean)
-		return; /* no data to poll */
-
-	rmb(); /* Make sure head is ready before touch any data */
-
-	if (unlikely(!is_valid_clean_head(ring, head))) {
-		hns3_rl_err(netdev, "wrong head (%d, %d-%d)\n", head,
-			    ring->next_to_use, ring->next_to_clean);
-
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.io_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
-		return;
-	}
 
 	bytes = 0;
 	pkts = 0;
-	hns3_nic_reclaim_desc(ring, head, &bytes, &pkts);
+
+	if (unlikely(!hns3_nic_reclaim_desc(ring, &bytes, &pkts)))
+		return;
 
 	ring->tqp_vector->tx_group.total_bytes += bytes;
 	ring->tqp_vector->tx_group.total_packets += pkts;
@@ -3714,6 +3705,7 @@ static void hns3_ring_get_cfg(struct hnae3_queue *q, struct hns3_nic_priv *priv,
 	ring->desc_num = desc_num;
 	ring->next_to_use = 0;
 	ring->next_to_clean = 0;
+	ring->last_to_use = 0;
 }
 
 static void hns3_queue_to_ring(struct hnae3_queue *tqp,
@@ -3793,6 +3785,7 @@ void hns3_fini_ring(struct hns3_enet_ring *ring)
 	ring->desc_cb = NULL;
 	ring->next_to_clean = 0;
 	ring->next_to_use = 0;
+	ring->last_to_use = 0;
 	ring->pending_buf = 0;
 	if (ring->skb) {
 		dev_kfree_skb_any(ring->skb);
@@ -4310,6 +4303,7 @@ int hns3_nic_reset_all_ring(struct hnae3_handle *h)
 		hns3_clear_tx_ring(&priv->ring[i]);
 		priv->ring[i].next_to_clean = 0;
 		priv->ring[i].next_to_use = 0;
+		priv->ring[i].last_to_use = 0;
 
 		rx_ring = &priv->ring[i + h->kinfo.num_tqps];
 		hns3_init_ring_hw(rx_ring);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index f40738c..876dc09 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -344,7 +344,6 @@ enum hns3_pkt_ol4type {
 };
 
 struct ring_stats {
-	u64 io_err_cnt;
 	u64 sw_err_cnt;
 	u64 seg_pkt_cnt;
 	union {
@@ -397,8 +396,10 @@ struct hns3_enet_ring {
 	 * next_to_use
 	 */
 	int next_to_clean;
-
-	u32 pull_len; /* head length for current packet */
+	union {
+		int last_to_use;	/* last idx used by xmit */
+		u32 pull_len;		/* memcpy len for current rx packet */
+	};
 	u32 frag_num;
 	void *va; /* first buffer address for current packet */
 
@@ -513,11 +514,6 @@ static inline int ring_space(struct hns3_enet_ring *ring)
 			(begin - end)) - 1;
 }
 
-static inline int is_ring_empty(struct hns3_enet_ring *ring)
-{
-	return ring->next_to_use == ring->next_to_clean;
-}
-
 static inline u32 hns3_read_reg(void __iomem *base, u32 reg)
 {
 	return readl(base + reg);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 97ad68b..f402c39 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -27,7 +27,6 @@ struct hns3_sfp_type {
 
 static const struct hns3_stats hns3_txq_stats[] = {
 	/* Tx per-queue statistics */
-	HNS3_TQP_STAT("io_err_cnt", io_err_cnt),
 	HNS3_TQP_STAT("dropped", sw_err_cnt),
 	HNS3_TQP_STAT("seg_pkt_cnt", seg_pkt_cnt),
 	HNS3_TQP_STAT("packets", tx_pkts),
@@ -46,7 +45,6 @@ static const struct hns3_stats hns3_txq_stats[] = {
 
 static const struct hns3_stats hns3_rxq_stats[] = {
 	/* Rx per-queue statistics */
-	HNS3_TQP_STAT("io_err_cnt", io_err_cnt),
 	HNS3_TQP_STAT("dropped", sw_err_cnt),
 	HNS3_TQP_STAT("seg_pkt_cnt", seg_pkt_cnt),
 	HNS3_TQP_STAT("packets", rx_pkts),
-- 
2.7.4

