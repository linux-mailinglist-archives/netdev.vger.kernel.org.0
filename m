Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CD034C262
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 06:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhC2D7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 23:59:16 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14508 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhC2D60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 23:58:26 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F7zK16zGJzrc0h;
        Mon, 29 Mar 2021 11:56:21 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 11:58:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 6/9] net: hns3: add handling for xmit skb with recursive fraglist
Date:   Mon, 29 Mar 2021 11:57:50 +0800
Message-ID: <1616990273-46426-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
References: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently hns3 driver only handle the xmit skb with one level of
fraglist skb, add handling for multi level by calling hns3_tx_bd_num()
recursively when calculating bd num and calling hns3_fill_skb_to_desc()
recursively when filling tx desc.

When the skb has a fraglist level of 24, the skb is simply dropped and
stats.max_recursion_level is added to record the error. Move the stat
handling from hns3_nic_net_xmit() to hns3_nic_maybe_stop_tx() in order
to handle different error stat and add the 'max_recursion_level' and
'hw_limitation' stat.

Note that the max recursive level as 24 is chose according to below:
commit 48a1df65334b ("skbuff: return -EMSGSIZE in skb_to_sgvec to
prevent overflow").

And that we are not able to find a testcase to verify the recursive
fraglist case, so Fixes tag is not provided.

Reported-by: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 115 +++++++++++++--------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   2 +
 3 files changed, 78 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 3848009..2dbcd95 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1275,30 +1275,29 @@ static unsigned int hns3_skb_bd_num(struct sk_buff *skb, unsigned int *bd_size,
 }
 
 static unsigned int hns3_tx_bd_num(struct sk_buff *skb, unsigned int *bd_size,
-				   u8 max_non_tso_bd_num)
+				   u8 max_non_tso_bd_num, unsigned int bd_num,
+				   unsigned int recursion_level)
 {
+#define HNS3_MAX_RECURSION_LEVEL	24
+
 	struct sk_buff *frag_skb;
-	unsigned int bd_num = 0;
 
 	/* If the total len is within the max bd limit */
-	if (likely(skb->len <= HNS3_MAX_BD_SIZE && !skb_has_frag_list(skb) &&
+	if (likely(skb->len <= HNS3_MAX_BD_SIZE && !recursion_level &&
+		   !skb_has_frag_list(skb) &&
 		   skb_shinfo(skb)->nr_frags < max_non_tso_bd_num))
 		return skb_shinfo(skb)->nr_frags + 1U;
 
-	/* The below case will always be linearized, return
-	 * HNS3_MAX_BD_NUM_TSO + 1U to make sure it is linearized.
-	 */
-	if (unlikely(skb->len > HNS3_MAX_TSO_SIZE ||
-		     (!skb_is_gso(skb) && skb->len >
-		      HNS3_MAX_NON_TSO_SIZE(max_non_tso_bd_num))))
-		return HNS3_MAX_TSO_BD_NUM + 1U;
+	if (unlikely(recursion_level >= HNS3_MAX_RECURSION_LEVEL))
+		return UINT_MAX;
 
 	bd_num = hns3_skb_bd_num(skb, bd_size, bd_num);
 	if (!skb_has_frag_list(skb) || bd_num > HNS3_MAX_TSO_BD_NUM)
 		return bd_num;
 
 	skb_walk_frags(skb, frag_skb) {
-		bd_num = hns3_skb_bd_num(frag_skb, bd_size, bd_num);
+		bd_num = hns3_tx_bd_num(frag_skb, bd_size, max_non_tso_bd_num,
+					bd_num, recursion_level + 1);
 		if (bd_num > HNS3_MAX_TSO_BD_NUM)
 			return bd_num;
 	}
@@ -1358,6 +1357,43 @@ void hns3_shinfo_pack(struct skb_shared_info *shinfo, __u32 *size)
 		size[i] = skb_frag_size(&shinfo->frags[i]);
 }
 
+static int hns3_skb_linearize(struct hns3_enet_ring *ring,
+			      struct sk_buff *skb,
+			      u8 max_non_tso_bd_num,
+			      unsigned int bd_num)
+{
+	/* 'bd_num == UINT_MAX' means the skb' fraglist has a
+	 * recursion level of over HNS3_MAX_RECURSION_LEVEL.
+	 */
+	if (bd_num == UINT_MAX) {
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.over_max_recursion++;
+		u64_stats_update_end(&ring->syncp);
+		return -ENOMEM;
+	}
+
+	/* The skb->len has exceeded the hw limitation, linearization
+	 * will not help.
+	 */
+	if (skb->len > HNS3_MAX_TSO_SIZE ||
+	    (!skb_is_gso(skb) && skb->len >
+	     HNS3_MAX_NON_TSO_SIZE(max_non_tso_bd_num))) {
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.hw_limitation++;
+		u64_stats_update_end(&ring->syncp);
+		return -ENOMEM;
+	}
+
+	if (__skb_linearize(skb)) {
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.sw_err_cnt++;
+		u64_stats_update_end(&ring->syncp);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 				  struct net_device *netdev,
 				  struct sk_buff *skb)
@@ -1367,7 +1403,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 	unsigned int bd_size[HNS3_MAX_TSO_BD_NUM + 1U];
 	unsigned int bd_num;
 
-	bd_num = hns3_tx_bd_num(skb, bd_size, max_non_tso_bd_num);
+	bd_num = hns3_tx_bd_num(skb, bd_size, max_non_tso_bd_num, 0, 0);
 	if (unlikely(bd_num > max_non_tso_bd_num)) {
 		if (bd_num <= HNS3_MAX_TSO_BD_NUM && skb_is_gso(skb) &&
 		    !hns3_skb_need_linearized(skb, bd_size, bd_num,
@@ -1376,16 +1412,11 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 			goto out;
 		}
 
-		if (__skb_linearize(skb))
+		if (hns3_skb_linearize(ring, skb, max_non_tso_bd_num,
+				       bd_num))
 			return -ENOMEM;
 
 		bd_num = hns3_tx_bd_count(skb->len);
-		if ((skb_is_gso(skb) && bd_num > HNS3_MAX_TSO_BD_NUM) ||
-		    (!skb_is_gso(skb) &&
-		     bd_num > max_non_tso_bd_num)) {
-			trace_hns3_over_max_bd(skb);
-			return -ENOMEM;
-		}
 
 		u64_stats_update_begin(&ring->syncp);
 		ring->stats.tx_copy++;
@@ -1409,6 +1440,10 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 		return bd_num;
 	}
 
+	u64_stats_update_begin(&ring->syncp);
+	ring->stats.tx_busy++;
+	u64_stats_update_end(&ring->syncp);
+
 	return -EBUSY;
 }
 
@@ -1456,6 +1491,7 @@ static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
 				 struct sk_buff *skb, enum hns_desc_type type)
 {
 	unsigned int size = skb_headlen(skb);
+	struct sk_buff *frag_skb;
 	int i, ret, bd_num = 0;
 
 	if (size) {
@@ -1480,6 +1516,15 @@ static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
 		bd_num += ret;
 	}
 
+	skb_walk_frags(skb, frag_skb) {
+		ret = hns3_fill_skb_to_desc(ring, frag_skb,
+					    DESC_TYPE_FRAGLIST_SKB);
+		if (unlikely(ret < 0))
+			return ret;
+
+		bd_num += ret;
+	}
+
 	return bd_num;
 }
 
@@ -1510,8 +1555,6 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	struct hns3_enet_ring *ring = &priv->ring[skb->queue_mapping];
 	struct netdev_queue *dev_queue;
 	int pre_ntu, next_to_use_head;
-	struct sk_buff *frag_skb;
-	int bd_num = 0;
 	bool doorbell;
 	int ret;
 
@@ -1527,15 +1570,8 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	ret = hns3_nic_maybe_stop_tx(ring, netdev, skb);
 	if (unlikely(ret <= 0)) {
 		if (ret == -EBUSY) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.tx_busy++;
-			u64_stats_update_end(&ring->syncp);
 			hns3_tx_doorbell(ring, 0, true);
 			return NETDEV_TX_BUSY;
-		} else if (ret == -ENOMEM) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.sw_err_cnt++;
-			u64_stats_update_end(&ring->syncp);
 		}
 
 		hns3_rl_err(netdev, "xmit error: %d!\n", ret);
@@ -1548,21 +1584,14 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	if (unlikely(ret < 0))
 		goto fill_err;
 
+	/* 'ret < 0' means filling error, 'ret == 0' means skb->len is
+	 * zero, which is unlikely, and 'ret > 0' means how many tx desc
+	 * need to be notified to the hw.
+	 */
 	ret = hns3_fill_skb_to_desc(ring, skb, DESC_TYPE_SKB);
-	if (unlikely(ret < 0))
+	if (unlikely(ret <= 0))
 		goto fill_err;
 
-	bd_num += ret;
-
-	skb_walk_frags(skb, frag_skb) {
-		ret = hns3_fill_skb_to_desc(ring, frag_skb,
-					    DESC_TYPE_FRAGLIST_SKB);
-		if (unlikely(ret < 0))
-			goto fill_err;
-
-		bd_num += ret;
-	}
-
 	pre_ntu = ring->next_to_use ? (ring->next_to_use - 1) :
 					(ring->desc_num - 1);
 	ring->desc[pre_ntu].tx.bdtp_fe_sc_vld_ra_ri |=
@@ -1573,7 +1602,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	dev_queue = netdev_get_tx_queue(netdev, ring->queue_index);
 	doorbell = __netdev_tx_sent_queue(dev_queue, skb->len,
 					  netdev_xmit_more());
-	hns3_tx_doorbell(ring, bd_num, doorbell);
+	hns3_tx_doorbell(ring, ret, doorbell);
 
 	return NETDEV_TX_OK;
 
@@ -1745,11 +1774,15 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 			tx_drop += ring->stats.tx_l4_proto_err;
 			tx_drop += ring->stats.tx_l2l3l4_err;
 			tx_drop += ring->stats.tx_tso_err;
+			tx_drop += ring->stats.over_max_recursion;
+			tx_drop += ring->stats.hw_limitation;
 			tx_errors += ring->stats.sw_err_cnt;
 			tx_errors += ring->stats.tx_vlan_err;
 			tx_errors += ring->stats.tx_l4_proto_err;
 			tx_errors += ring->stats.tx_l2l3l4_err;
 			tx_errors += ring->stats.tx_tso_err;
+			tx_errors += ring->stats.over_max_recursion;
+			tx_errors += ring->stats.hw_limitation;
 		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
 
 		/* fetch the rx stats */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index d069b04..e44224e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -376,6 +376,8 @@ struct ring_stats {
 			u64 tx_l4_proto_err;
 			u64 tx_l2l3l4_err;
 			u64 tx_tso_err;
+			u64 over_max_recursion;
+			u64 hw_limitation;
 		};
 		struct {
 			u64 rx_pkts;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 0ae6140..b48faf7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -44,6 +44,8 @@ static const struct hns3_stats hns3_txq_stats[] = {
 	HNS3_TQP_STAT("l4_proto_err", tx_l4_proto_err),
 	HNS3_TQP_STAT("l2l3l4_err", tx_l2l3l4_err),
 	HNS3_TQP_STAT("tso_err", tx_tso_err),
+	HNS3_TQP_STAT("over_max_recursion", over_max_recursion),
+	HNS3_TQP_STAT("hw_limitation", hw_limitation),
 };
 
 #define HNS3_TXQ_STATS_COUNT ARRAY_SIZE(hns3_txq_stats)
-- 
2.7.4

