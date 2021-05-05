Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0497737405F
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbhEEQei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234378AbhEEQdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:33:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1276613F6;
        Wed,  5 May 2021 16:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232330;
        bh=OM0pMNuF8sOqhGMzYpqTEyMPhaMa1IgpZTK6NEOwb+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7/VdCAapM7wXtraJH4rdniuFq75MaqzbfJqZmDt8brnW77pVv/C8vuDxWBTFhxPu
         Bc8Mn9+R+5291oTBmi/h5e/h10XfXp95ndXab7kfPrjpSxLm9ti7u1bJZR9CfTWtvV
         PyMKtQXiI5Nz7CXLUgOsZvmJfSqNNo14j9ea9GZwQ+AOI9xmY4MJZ/WGT/zFK0pzMm
         2tAlYXh3lo0b+/06zOGJ7X1yrNhr7S8HBSTgGY8WAjA15Gjh0/AamQM6L9fjZ+d5s2
         9bX0T5CG1JQWeJu0gYtKXPk6XyJpKYVw6jnhVAqC4+5h8VAFGd002T8iIicDZifJmE
         gsVi6Tfy7iZDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 033/116] net: hns3: add handling for xmit skb with recursive fraglist
Date:   Wed,  5 May 2021 12:30:01 -0400
Message-Id: <20210505163125.3460440-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit d5d5e0193ee8f88efbbc7f1471087255657bc19a ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 115 +++++++++++-------
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   2 +
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |   2 +
 3 files changed, 78 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index bf4302a5cf95..ca6dde6d6852 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1277,23 +1277,21 @@ static unsigned int hns3_skb_bd_num(struct sk_buff *skb, unsigned int *bd_size,
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
 
@@ -1301,7 +1299,8 @@ static unsigned int hns3_tx_bd_num(struct sk_buff *skb, unsigned int *bd_size,
 		return bd_num;
 
 	skb_walk_frags(skb, frag_skb) {
-		bd_num = hns3_skb_bd_num(frag_skb, bd_size, bd_num);
+		bd_num = hns3_tx_bd_num(frag_skb, bd_size, max_non_tso_bd_num,
+					bd_num, recursion_level + 1);
 		if (bd_num > HNS3_MAX_TSO_BD_NUM)
 			return bd_num;
 	}
@@ -1361,6 +1360,43 @@ void hns3_shinfo_pack(struct skb_shared_info *shinfo, __u32 *size)
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
@@ -1370,7 +1406,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 	unsigned int bd_size[HNS3_MAX_TSO_BD_NUM + 1U];
 	unsigned int bd_num;
 
-	bd_num = hns3_tx_bd_num(skb, bd_size, max_non_tso_bd_num);
+	bd_num = hns3_tx_bd_num(skb, bd_size, max_non_tso_bd_num, 0, 0);
 	if (unlikely(bd_num > max_non_tso_bd_num)) {
 		if (bd_num <= HNS3_MAX_TSO_BD_NUM && skb_is_gso(skb) &&
 		    !hns3_skb_need_linearized(skb, bd_size, bd_num,
@@ -1379,16 +1415,11 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
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
@@ -1412,6 +1443,10 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 		return bd_num;
 	}
 
+	u64_stats_update_begin(&ring->syncp);
+	ring->stats.tx_busy++;
+	u64_stats_update_end(&ring->syncp);
+
 	return -EBUSY;
 }
 
@@ -1459,6 +1494,7 @@ static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
 				 struct sk_buff *skb, enum hns_desc_type type)
 {
 	unsigned int size = skb_headlen(skb);
+	struct sk_buff *frag_skb;
 	int i, ret, bd_num = 0;
 
 	if (size) {
@@ -1483,6 +1519,15 @@ static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
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
 
@@ -1513,8 +1558,6 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	struct hns3_enet_ring *ring = &priv->ring[skb->queue_mapping];
 	struct netdev_queue *dev_queue;
 	int pre_ntu, next_to_use_head;
-	struct sk_buff *frag_skb;
-	int bd_num = 0;
 	bool doorbell;
 	int ret;
 
@@ -1530,15 +1573,8 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
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
@@ -1551,21 +1587,14 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
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
@@ -1576,7 +1605,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	dev_queue = netdev_get_tx_queue(netdev, ring->queue_index);
 	doorbell = __netdev_tx_sent_queue(dev_queue, skb->len,
 					  netdev_xmit_more());
-	hns3_tx_doorbell(ring, bd_num, doorbell);
+	hns3_tx_doorbell(ring, ret, doorbell);
 
 	return NETDEV_TX_OK;
 
@@ -1748,11 +1777,15 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
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
index d069b04ee587..e44224e23315 100644
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
index adcec4ea7cb9..d20f2e246017 100644
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
2.30.2

