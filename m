Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA6F461795
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243593AbhK2OM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:12:28 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16320 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242975AbhK2OK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:10:28 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J2nCr3Phsz91SS;
        Mon, 29 Nov 2021 22:04:40 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:08 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:07 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 08/10] net: hns3: split function hns3_nic_get_stats64()
Date:   Mon, 29 Nov 2021 22:00:25 +0800
Message-ID: <20211129140027.23036-9-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211129140027.23036-1-huangguangbin2@huawei.com>
References: <20211129140027.23036-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Function hns3_nic_get_stats64() is a bit too long. So add a
new function hns3_fetch_stats() to simplify code and improve
code readability.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 123 +++++++++---------
 1 file changed, 61 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index cc962e5f563b..fe1f5ead1be4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2383,90 +2383,89 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	return features;
 }
 
+static void hns3_fetch_stats(struct rtnl_link_stats64 *stats,
+			     struct hns3_enet_ring *ring, bool is_tx)
+{
+	unsigned int start;
+
+	do {
+		start = u64_stats_fetch_begin_irq(&ring->syncp);
+		if (is_tx) {
+			stats->tx_bytes += ring->stats.tx_bytes;
+			stats->tx_packets += ring->stats.tx_pkts;
+			stats->tx_dropped += ring->stats.sw_err_cnt;
+			stats->tx_dropped += ring->stats.tx_vlan_err;
+			stats->tx_dropped += ring->stats.tx_l4_proto_err;
+			stats->tx_dropped += ring->stats.tx_l2l3l4_err;
+			stats->tx_dropped += ring->stats.tx_tso_err;
+			stats->tx_dropped += ring->stats.over_max_recursion;
+			stats->tx_dropped += ring->stats.hw_limitation;
+			stats->tx_dropped += ring->stats.copy_bits_err;
+			stats->tx_dropped += ring->stats.skb2sgl_err;
+			stats->tx_dropped += ring->stats.map_sg_err;
+			stats->tx_errors += ring->stats.sw_err_cnt;
+			stats->tx_errors += ring->stats.tx_vlan_err;
+			stats->tx_errors += ring->stats.tx_l4_proto_err;
+			stats->tx_errors += ring->stats.tx_l2l3l4_err;
+			stats->tx_errors += ring->stats.tx_tso_err;
+			stats->tx_errors += ring->stats.over_max_recursion;
+			stats->tx_errors += ring->stats.hw_limitation;
+			stats->tx_errors += ring->stats.copy_bits_err;
+			stats->tx_errors += ring->stats.skb2sgl_err;
+			stats->tx_errors += ring->stats.map_sg_err;
+		} else {
+			stats->rx_bytes += ring->stats.rx_bytes;
+			stats->rx_packets += ring->stats.rx_pkts;
+			stats->rx_dropped += ring->stats.l2_err;
+			stats->rx_errors += ring->stats.l2_err;
+			stats->rx_errors += ring->stats.l3l4_csum_err;
+			stats->rx_crc_errors += ring->stats.l2_err;
+			stats->multicast += ring->stats.rx_multicast;
+			stats->rx_length_errors += ring->stats.err_pkt_len;
+		}
+	} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+}
+
 static void hns3_nic_get_stats64(struct net_device *netdev,
 				 struct rtnl_link_stats64 *stats)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	int queue_num = priv->ae_handle->kinfo.num_tqps;
 	struct hnae3_handle *handle = priv->ae_handle;
+	struct rtnl_link_stats64 ring_total_stats;
 	struct hns3_enet_ring *ring;
-	u64 rx_length_errors = 0;
-	u64 rx_crc_errors = 0;
-	u64 rx_multicast = 0;
-	unsigned int start;
-	u64 tx_errors = 0;
-	u64 rx_errors = 0;
 	unsigned int idx;
-	u64 tx_bytes = 0;
-	u64 rx_bytes = 0;
-	u64 tx_pkts = 0;
-	u64 rx_pkts = 0;
-	u64 tx_drop = 0;
-	u64 rx_drop = 0;
 
 	if (test_bit(HNS3_NIC_STATE_DOWN, &priv->state))
 		return;
 
 	handle->ae_algo->ops->update_stats(handle, &netdev->stats);
 
+	memset(&ring_total_stats, 0, sizeof(ring_total_stats));
 	for (idx = 0; idx < queue_num; idx++) {
 		/* fetch the tx stats */
 		ring = &priv->ring[idx];
-		do {
-			start = u64_stats_fetch_begin_irq(&ring->syncp);
-			tx_bytes += ring->stats.tx_bytes;
-			tx_pkts += ring->stats.tx_pkts;
-			tx_drop += ring->stats.sw_err_cnt;
-			tx_drop += ring->stats.tx_vlan_err;
-			tx_drop += ring->stats.tx_l4_proto_err;
-			tx_drop += ring->stats.tx_l2l3l4_err;
-			tx_drop += ring->stats.tx_tso_err;
-			tx_drop += ring->stats.over_max_recursion;
-			tx_drop += ring->stats.hw_limitation;
-			tx_drop += ring->stats.copy_bits_err;
-			tx_drop += ring->stats.skb2sgl_err;
-			tx_drop += ring->stats.map_sg_err;
-			tx_errors += ring->stats.sw_err_cnt;
-			tx_errors += ring->stats.tx_vlan_err;
-			tx_errors += ring->stats.tx_l4_proto_err;
-			tx_errors += ring->stats.tx_l2l3l4_err;
-			tx_errors += ring->stats.tx_tso_err;
-			tx_errors += ring->stats.over_max_recursion;
-			tx_errors += ring->stats.hw_limitation;
-			tx_errors += ring->stats.copy_bits_err;
-			tx_errors += ring->stats.skb2sgl_err;
-			tx_errors += ring->stats.map_sg_err;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		hns3_fetch_stats(&ring_total_stats, ring, true);
 
 		/* fetch the rx stats */
 		ring = &priv->ring[idx + queue_num];
-		do {
-			start = u64_stats_fetch_begin_irq(&ring->syncp);
-			rx_bytes += ring->stats.rx_bytes;
-			rx_pkts += ring->stats.rx_pkts;
-			rx_drop += ring->stats.l2_err;
-			rx_errors += ring->stats.l2_err;
-			rx_errors += ring->stats.l3l4_csum_err;
-			rx_crc_errors += ring->stats.l2_err;
-			rx_multicast += ring->stats.rx_multicast;
-			rx_length_errors += ring->stats.err_pkt_len;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
-	}
-
-	stats->tx_bytes = tx_bytes;
-	stats->tx_packets = tx_pkts;
-	stats->rx_bytes = rx_bytes;
-	stats->rx_packets = rx_pkts;
-
-	stats->rx_errors = rx_errors;
-	stats->multicast = rx_multicast;
-	stats->rx_length_errors = rx_length_errors;
-	stats->rx_crc_errors = rx_crc_errors;
+		hns3_fetch_stats(&ring_total_stats, ring, false);
+	}
+
+	stats->tx_bytes = ring_total_stats.tx_bytes;
+	stats->tx_packets = ring_total_stats.tx_packets;
+	stats->rx_bytes = ring_total_stats.rx_bytes;
+	stats->rx_packets = ring_total_stats.rx_packets;
+
+	stats->rx_errors = ring_total_stats.rx_errors;
+	stats->multicast = ring_total_stats.multicast;
+	stats->rx_length_errors = ring_total_stats.rx_length_errors;
+	stats->rx_crc_errors = ring_total_stats.rx_crc_errors;
 	stats->rx_missed_errors = netdev->stats.rx_missed_errors;
 
-	stats->tx_errors = tx_errors;
-	stats->rx_dropped = rx_drop;
-	stats->tx_dropped = tx_drop;
+	stats->tx_errors = ring_total_stats.tx_errors;
+	stats->rx_dropped = ring_total_stats.rx_dropped;
+	stats->tx_dropped = ring_total_stats.tx_dropped;
 	stats->collisions = netdev->stats.collisions;
 	stats->rx_over_errors = netdev->stats.rx_over_errors;
 	stats->rx_frame_errors = netdev->stats.rx_frame_errors;
-- 
2.33.0

