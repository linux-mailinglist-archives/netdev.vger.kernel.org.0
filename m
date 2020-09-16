Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4B326C0BC
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 11:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgIPJhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 05:37:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54004 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726728AbgIPJg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 05:36:57 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8A165DABAE2F810B1659;
        Wed, 16 Sep 2020 17:36:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Wed, 16 Sep 2020 17:36:39 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>, <saeed@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 6/6] net: hns3: use napi_consume_skb() when cleaning tx desc
Date:   Wed, 16 Sep 2020 17:33:50 +0800
Message-ID: <1600248830-59477-7-git-send-email-tanhuazhong@huawei.com>
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

Use napi_consume_skb() to batch consuming skb when cleaning
tx desc in NAPI polling.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 27 +++++++++++-----------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  2 +-
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4a49a76..feeaf75 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2333,10 +2333,10 @@ static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
 }
 
 static void hns3_free_buffer(struct hns3_enet_ring *ring,
-			     struct hns3_desc_cb *cb)
+			     struct hns3_desc_cb *cb, int budget)
 {
 	if (cb->type == DESC_TYPE_SKB)
-		dev_kfree_skb_any((struct sk_buff *)cb->priv);
+		napi_consume_skb(cb->priv, budget);
 	else if (!HNAE3_IS_TX_RING(ring) && cb->pagecnt_bias)
 		__page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
 	memset(cb, 0, sizeof(*cb));
@@ -2370,7 +2370,8 @@ static void hns3_buffer_detach(struct hns3_enet_ring *ring, int i)
 	ring->desc[i].addr = 0;
 }
 
-static void hns3_free_buffer_detach(struct hns3_enet_ring *ring, int i)
+static void hns3_free_buffer_detach(struct hns3_enet_ring *ring, int i,
+				    int budget)
 {
 	struct hns3_desc_cb *cb = &ring->desc_cb[i];
 
@@ -2378,7 +2379,7 @@ static void hns3_free_buffer_detach(struct hns3_enet_ring *ring, int i)
 		return;
 
 	hns3_buffer_detach(ring, i);
-	hns3_free_buffer(ring, cb);
+	hns3_free_buffer(ring, cb, budget);
 }
 
 static void hns3_free_buffers(struct hns3_enet_ring *ring)
@@ -2386,7 +2387,7 @@ static void hns3_free_buffers(struct hns3_enet_ring *ring)
 	int i;
 
 	for (i = 0; i < ring->desc_num; i++)
-		hns3_free_buffer_detach(ring, i);
+		hns3_free_buffer_detach(ring, i, 0);
 }
 
 /* free desc along with its attached buffer */
@@ -2431,7 +2432,7 @@ static int hns3_alloc_and_map_buffer(struct hns3_enet_ring *ring,
 	return 0;
 
 out_with_buf:
-	hns3_free_buffer(ring, cb);
+	hns3_free_buffer(ring, cb, 0);
 out:
 	return ret;
 }
@@ -2463,7 +2464,7 @@ static int hns3_alloc_ring_buffers(struct hns3_enet_ring *ring)
 
 out_buffer_fail:
 	for (j = i - 1; j >= 0; j--)
-		hns3_free_buffer_detach(ring, j);
+		hns3_free_buffer_detach(ring, j, 0);
 	return ret;
 }
 
@@ -2491,7 +2492,7 @@ static void hns3_reuse_buffer(struct hns3_enet_ring *ring, int i)
 }
 
 static bool hns3_nic_reclaim_desc(struct hns3_enet_ring *ring,
-				  int *bytes, int *pkts)
+				  int *bytes, int *pkts, int budget)
 {
 	/* pair with ring->last_to_use update in hns3_tx_doorbell(),
 	 * smp_store_release() is not used in hns3_tx_doorbell() because
@@ -2514,7 +2515,7 @@ static bool hns3_nic_reclaim_desc(struct hns3_enet_ring *ring,
 		(*pkts) += (desc_cb->type == DESC_TYPE_SKB);
 		(*bytes) += desc_cb->length;
 		/* desc_cb will be cleaned, after hnae3_free_buffer_detach */
-		hns3_free_buffer_detach(ring, ntc);
+		hns3_free_buffer_detach(ring, ntc, budget);
 
 		if (++ntc == ring->desc_num)
 			ntc = 0;
@@ -2534,7 +2535,7 @@ static bool hns3_nic_reclaim_desc(struct hns3_enet_ring *ring,
 	return true;
 }
 
-void hns3_clean_tx_ring(struct hns3_enet_ring *ring)
+void hns3_clean_tx_ring(struct hns3_enet_ring *ring, int budget)
 {
 	struct net_device *netdev = ring_to_netdev(ring);
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
@@ -2544,7 +2545,7 @@ void hns3_clean_tx_ring(struct hns3_enet_ring *ring)
 	bytes = 0;
 	pkts = 0;
 
-	if (unlikely(!hns3_nic_reclaim_desc(ring, &bytes, &pkts)))
+	if (unlikely(!hns3_nic_reclaim_desc(ring, &bytes, &pkts, budget)))
 		return;
 
 	ring->tqp_vector->tx_group.total_bytes += bytes;
@@ -3351,7 +3352,7 @@ static int hns3_nic_common_poll(struct napi_struct *napi, int budget)
 	 * budget and be more aggressive about cleaning up the Tx descriptors.
 	 */
 	hns3_for_each_ring(ring, tqp_vector->tx_group)
-		hns3_clean_tx_ring(ring);
+		hns3_clean_tx_ring(ring, budget);
 
 	/* make sure rx ring budget not smaller than 1 */
 	if (tqp_vector->num_tqps > 1)
@@ -4195,7 +4196,7 @@ static void hns3_clear_tx_ring(struct hns3_enet_ring *ring)
 {
 	while (ring->next_to_clean != ring->next_to_use) {
 		ring->desc[ring->next_to_clean].tx.bdtp_fe_sc_vld_ra_ri = 0;
-		hns3_free_buffer_detach(ring, ring->next_to_clean);
+		hns3_free_buffer_detach(ring, ring->next_to_clean, 0);
 		ring_ptr_move_fw(ring, next_to_clean);
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 20e62ce..8a6c8ba 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -576,7 +576,7 @@ void hns3_ethtool_set_ops(struct net_device *netdev);
 int hns3_set_channels(struct net_device *netdev,
 		      struct ethtool_channels *ch);
 
-void hns3_clean_tx_ring(struct hns3_enet_ring *ring);
+void hns3_clean_tx_ring(struct hns3_enet_ring *ring, int budget);
 int hns3_init_all_ring(struct hns3_nic_priv *priv);
 int hns3_uninit_all_ring(struct hns3_nic_priv *priv);
 int hns3_nic_reset_all_ring(struct hnae3_handle *h);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index f402c39..52c7804 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -230,7 +230,7 @@ static void hns3_lb_clear_tx_ring(struct hns3_nic_priv *priv, u32 start_ringid,
 	for (i = start_ringid; i <= end_ringid; i++) {
 		struct hns3_enet_ring *ring = &priv->ring[i];
 
-		hns3_clean_tx_ring(ring);
+		hns3_clean_tx_ring(ring, 0);
 	}
 }
 
-- 
2.7.4

