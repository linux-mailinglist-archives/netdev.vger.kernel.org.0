Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AEB26C0B7
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 11:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgIPJgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 05:36:53 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53820 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726722AbgIPJgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 05:36:50 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 67001740093D4D51A75E;
        Wed, 16 Sep 2020 17:36:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Wed, 16 Sep 2020 17:36:38 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>, <saeed@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 2/6] net: hns3: batch tx doorbell operation
Date:   Wed, 16 Sep 2020 17:33:46 +0800
Message-ID: <1600248830-59477-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600248830-59477-1-git-send-email-tanhuazhong@huawei.com>
References: <1600248830-59477-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Use netdev_xmit_more() to defer the tx doorbell operation when
the skb is passed to the driver continuously. By doing this we
can improve the overall xmit performance by avoid some doorbell
operations.

Also, the tx_err_cnt stat is not used, so rename it to tx_more
stat.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 47 +++++++++++++++++-----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  2 +-
 3 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 3762142..6a57c0d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1383,6 +1383,27 @@ static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
 	return bd_num;
 }
 
+static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
+			     bool doorbell)
+{
+	ring->pending_buf += num;
+
+	if (!doorbell) {
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.tx_more++;
+		u64_stats_update_end(&ring->syncp);
+		return;
+	}
+
+	if (!ring->pending_buf)
+		return;
+
+	wmb(); /* Commit all data before submit */
+
+	hnae3_queue_xmit(ring->tqp, ring->pending_buf);
+	ring->pending_buf = 0;
+}
+
 netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
@@ -1391,11 +1412,14 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	int pre_ntu, next_to_use_head;
 	struct sk_buff *frag_skb;
 	int bd_num = 0;
+	bool doorbell;
 	int ret;
 
 	/* Hardware can only handle short frames above 32 bytes */
-	if (skb_put_padto(skb, HNS3_MIN_TX_LEN))
+	if (skb_put_padto(skb, HNS3_MIN_TX_LEN)) {
+		hns3_tx_doorbell(ring, 0, !netdev_xmit_more());
 		return NETDEV_TX_OK;
+	}
 
 	/* Prefetch the data used later */
 	prefetch(skb->data);
@@ -1406,6 +1430,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 			u64_stats_update_begin(&ring->syncp);
 			ring->stats.tx_busy++;
 			u64_stats_update_end(&ring->syncp);
+			hns3_tx_doorbell(ring, 0, true);
 			return NETDEV_TX_BUSY;
 		} else if (ret == -ENOMEM) {
 			u64_stats_update_begin(&ring->syncp);
@@ -1446,11 +1471,9 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	/* Complete translate all packets */
 	dev_queue = netdev_get_tx_queue(netdev, ring->queue_index);
-	netdev_tx_sent_queue(dev_queue, skb->len);
-
-	wmb(); /* Commit all data before submit */
-
-	hnae3_queue_xmit(ring->tqp, bd_num);
+	doorbell = __netdev_tx_sent_queue(dev_queue, skb->len,
+					  netdev_xmit_more());
+	hns3_tx_doorbell(ring, bd_num, doorbell);
 
 	return NETDEV_TX_OK;
 
@@ -1459,6 +1482,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 out_err_tx_ok:
 	dev_kfree_skb_any(skb);
+	hns3_tx_doorbell(ring, 0, !netdev_xmit_more());
 	return NETDEV_TX_OK;
 }
 
@@ -1839,13 +1863,14 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 		    tx_ring->next_to_clean, napi->state);
 
 	netdev_info(ndev,
-		    "tx_pkts: %llu, tx_bytes: %llu, io_err_cnt: %llu, sw_err_cnt: %llu\n",
+		    "tx_pkts: %llu, tx_bytes: %llu, io_err_cnt: %llu, sw_err_cnt: %llu, tx_pending: %d\n",
 		    tx_ring->stats.tx_pkts, tx_ring->stats.tx_bytes,
-		    tx_ring->stats.io_err_cnt, tx_ring->stats.sw_err_cnt);
+		    tx_ring->stats.io_err_cnt, tx_ring->stats.sw_err_cnt,
+		    tx_ring->pending_buf);
 
 	netdev_info(ndev,
-		    "seg_pkt_cnt: %llu, tx_err_cnt: %llu, restart_queue: %llu, tx_busy: %llu\n",
-		    tx_ring->stats.seg_pkt_cnt, tx_ring->stats.tx_err_cnt,
+		    "seg_pkt_cnt: %llu, tx_more: %llu, restart_queue: %llu, tx_busy: %llu\n",
+		    tx_ring->stats.seg_pkt_cnt, tx_ring->stats.tx_more,
 		    tx_ring->stats.restart_queue, tx_ring->stats.tx_busy);
 
 	/* When mac received many pause frames continuous, it's unable to send
@@ -4181,6 +4206,8 @@ static void hns3_clear_tx_ring(struct hns3_enet_ring *ring)
 		hns3_free_buffer_detach(ring, ring->next_to_clean);
 		ring_ptr_move_fw(ring, next_to_clean);
 	}
+
+	ring->pending_buf = 0;
 }
 
 static int hns3_clear_rx_ring(struct hns3_enet_ring *ring)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 8f784094..f40738c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -351,7 +351,7 @@ struct ring_stats {
 		struct {
 			u64 tx_pkts;
 			u64 tx_bytes;
-			u64 tx_err_cnt;
+			u64 tx_more;
 			u64 restart_queue;
 			u64 tx_busy;
 			u64 tx_copy;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 2622e04..97ad68b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -32,7 +32,7 @@ static const struct hns3_stats hns3_txq_stats[] = {
 	HNS3_TQP_STAT("seg_pkt_cnt", seg_pkt_cnt),
 	HNS3_TQP_STAT("packets", tx_pkts),
 	HNS3_TQP_STAT("bytes", tx_bytes),
-	HNS3_TQP_STAT("errors", tx_err_cnt),
+	HNS3_TQP_STAT("more", tx_more),
 	HNS3_TQP_STAT("wake", restart_queue),
 	HNS3_TQP_STAT("busy", tx_busy),
 	HNS3_TQP_STAT("copy", tx_copy),
-- 
2.7.4

