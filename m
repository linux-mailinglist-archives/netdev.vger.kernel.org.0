Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437D4465FAA
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345771AbhLBIoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:44:08 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:28148 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345634AbhLBIoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:44:07 -0500
Received: from kwepemi500005.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J4TqX5gCLz1DJdD;
        Thu,  2 Dec 2021 16:38:00 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500005.china.huawei.com (7.221.188.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:43 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:42 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 1/9] net: hns3: extract macro to simplify ring stats update code
Date:   Thu, 2 Dec 2021 16:35:55 +0800
Message-ID: <20211202083603.25176-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202083603.25176-1-huangguangbin2@huawei.com>
References: <20211202083603.25176-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

As the code to update ring stats is alike for different ring stats
type, this patch extract macro to simplify ring stats update code.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 123 +++++-------------
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   7 +
 2 files changed, 38 insertions(+), 92 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 8c7707263f9d..d6336f803e36 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1002,9 +1002,7 @@ static bool hns3_can_use_tx_bounce(struct hns3_enet_ring *ring,
 		return false;
 
 	if (ALIGN(len, dma_get_cache_alignment()) > space) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_spare_full++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_spare_full);
 		return false;
 	}
 
@@ -1021,9 +1019,7 @@ static bool hns3_can_use_tx_sgl(struct hns3_enet_ring *ring,
 		return false;
 
 	if (space < HNS3_MAX_SGL_SIZE) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_spare_full++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_spare_full);
 		return false;
 	}
 
@@ -1562,9 +1558,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 
 	ret = hns3_handle_vtags(ring, skb);
 	if (unlikely(ret < 0)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_vlan_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_vlan_err);
 		return ret;
 	} else if (ret == HNS3_INNER_VLAN_TAG) {
 		inner_vtag = skb_vlan_tag_get(skb);
@@ -1599,9 +1593,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 
 		ret = hns3_get_l4_protocol(skb, &ol4_proto, &il4_proto);
 		if (unlikely(ret < 0)) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.tx_l4_proto_err++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, tx_l4_proto_err);
 			return ret;
 		}
 
@@ -1609,18 +1601,14 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 				      &type_cs_vlan_tso,
 				      &ol_type_vlan_len_msec);
 		if (unlikely(ret < 0)) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.tx_l2l3l4_err++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, tx_l2l3l4_err);
 			return ret;
 		}
 
 		ret = hns3_set_tso(skb, &paylen_ol4cs, &mss_hw_csum,
 				   &type_cs_vlan_tso, &desc_cb->send_bytes);
 		if (unlikely(ret < 0)) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.tx_tso_err++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, tx_tso_err);
 			return ret;
 		}
 	}
@@ -1713,9 +1701,7 @@ static int hns3_map_and_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	}
 
 	if (unlikely(dma_mapping_error(dev, dma))) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, sw_err_cnt);
 		return -ENOMEM;
 	}
 
@@ -1861,9 +1847,7 @@ static int hns3_skb_linearize(struct hns3_enet_ring *ring,
 	 * recursion level of over HNS3_MAX_RECURSION_LEVEL.
 	 */
 	if (bd_num == UINT_MAX) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.over_max_recursion++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, over_max_recursion);
 		return -ENOMEM;
 	}
 
@@ -1872,16 +1856,12 @@ static int hns3_skb_linearize(struct hns3_enet_ring *ring,
 	 */
 	if (skb->len > HNS3_MAX_TSO_SIZE ||
 	    (!skb_is_gso(skb) && skb->len > HNS3_MAX_NON_TSO_SIZE)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.hw_limitation++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, hw_limitation);
 		return -ENOMEM;
 	}
 
 	if (__skb_linearize(skb)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, sw_err_cnt);
 		return -ENOMEM;
 	}
 
@@ -1911,9 +1891,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 
 		bd_num = hns3_tx_bd_count(skb->len);
 
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_copy++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_copy);
 	}
 
 out:
@@ -1933,9 +1911,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 		return bd_num;
 	}
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.tx_busy++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, tx_busy);
 
 	return -EBUSY;
 }
@@ -2020,9 +1996,7 @@ static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
 	ring->pending_buf += num;
 
 	if (!doorbell) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_more++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_more);
 		return;
 	}
 
@@ -2072,9 +2046,7 @@ static int hns3_handle_tx_bounce(struct hns3_enet_ring *ring,
 	ret = skb_copy_bits(skb, 0, buf, size);
 	if (unlikely(ret < 0)) {
 		hns3_tx_spare_rollback(ring, cb_len);
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.copy_bits_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, copy_bits_err);
 		return ret;
 	}
 
@@ -2097,9 +2069,8 @@ static int hns3_handle_tx_bounce(struct hns3_enet_ring *ring,
 	dma_sync_single_for_device(ring_to_dev(ring), dma, size,
 				   DMA_TO_DEVICE);
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.tx_bounce++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, tx_bounce);
+
 	return bd_num;
 }
 
@@ -2129,9 +2100,7 @@ static int hns3_handle_tx_sgl(struct hns3_enet_ring *ring,
 	nents = skb_to_sgvec(skb, sgt->sgl, 0, skb->len);
 	if (unlikely(nents < 0)) {
 		hns3_tx_spare_rollback(ring, cb_len);
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.skb2sgl_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, skb2sgl_err);
 		return -ENOMEM;
 	}
 
@@ -2140,9 +2109,7 @@ static int hns3_handle_tx_sgl(struct hns3_enet_ring *ring,
 				DMA_TO_DEVICE);
 	if (unlikely(!sgt->nents)) {
 		hns3_tx_spare_rollback(ring, cb_len);
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.map_sg_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, map_sg_err);
 		return -ENOMEM;
 	}
 
@@ -2154,10 +2121,7 @@ static int hns3_handle_tx_sgl(struct hns3_enet_ring *ring,
 	for (i = 0; i < sgt->nents; i++)
 		bd_num += hns3_fill_desc(ring, sg_dma_address(sgt->sgl + i),
 					 sg_dma_len(sgt->sgl + i));
-
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.tx_sgl++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, tx_sgl);
 
 	return bd_num;
 }
@@ -2196,9 +2160,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	if (skb_put_padto(skb, HNS3_MIN_TX_LEN)) {
 		hns3_tx_doorbell(ring, 0, !netdev_xmit_more());
 
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, sw_err_cnt);
 
 		return NETDEV_TX_OK;
 	}
@@ -3522,17 +3484,13 @@ static bool hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 	for (i = 0; i < cleand_count; i++) {
 		desc_cb = &ring->desc_cb[ring->next_to_use];
 		if (desc_cb->reuse_flag) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.reuse_pg_cnt++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, reuse_pg_cnt);
 
 			hns3_reuse_buffer(ring, ring->next_to_use);
 		} else {
 			ret = hns3_alloc_and_map_buffer(ring, &res_cbs);
 			if (ret) {
-				u64_stats_update_begin(&ring->syncp);
-				ring->stats.sw_err_cnt++;
-				u64_stats_update_end(&ring->syncp);
+				hns3_ring_stats_update(ring, sw_err_cnt);
 
 				hns3_rl_err(ring_to_netdev(ring),
 					    "alloc rx buffer failed: %d\n",
@@ -3544,9 +3502,7 @@ static bool hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 			}
 			hns3_replace_buffer(ring, ring->next_to_use, &res_cbs);
 
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.non_reuse_pg++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, non_reuse_pg);
 		}
 
 		ring_ptr_move_fw(ring, next_to_use);
@@ -3573,9 +3529,7 @@ static int hns3_handle_rx_copybreak(struct sk_buff *skb, int i,
 	void *frag = napi_alloc_frag(frag_size);
 
 	if (unlikely(!frag)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.frag_alloc_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, frag_alloc_err);
 
 		hns3_rl_err(ring_to_netdev(ring),
 			    "failed to allocate rx frag\n");
@@ -3587,9 +3541,7 @@ static int hns3_handle_rx_copybreak(struct sk_buff *skb, int i,
 	skb_add_rx_frag(skb, i, virt_to_page(frag),
 			offset_in_page(frag), frag_size, frag_size);
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.frag_alloc++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, frag_alloc);
 	return 0;
 }
 
@@ -3722,9 +3674,7 @@ static bool hns3_checksum_complete(struct hns3_enet_ring *ring,
 	    hns3_rx_ptype_tbl[ptype].ip_summed != CHECKSUM_COMPLETE)
 		return false;
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.csum_complete++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, csum_complete);
 	skb->ip_summed = CHECKSUM_COMPLETE;
 	skb->csum = csum_unfold((__force __sum16)csum);
 
@@ -3798,9 +3748,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 	if (unlikely(l234info & (BIT(HNS3_RXD_L3E_B) | BIT(HNS3_RXD_L4E_B) |
 				 BIT(HNS3_RXD_OL3E_B) |
 				 BIT(HNS3_RXD_OL4E_B)))) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.l3l4_csum_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, l3l4_csum_err);
 
 		return;
 	}
@@ -3891,10 +3839,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 	skb = ring->skb;
 	if (unlikely(!skb)) {
 		hns3_rl_err(netdev, "alloc rx skb fail\n");
-
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, sw_err_cnt);
 
 		return -ENOMEM;
 	}
@@ -3925,9 +3870,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 	if (ring->page_pool)
 		skb_mark_for_recycle(skb);
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.seg_pkt_cnt++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, seg_pkt_cnt);
 
 	ring->pull_len = eth_get_headlen(netdev, va, HNS3_RX_HEAD_SIZE);
 	__skb_put(skb, ring->pull_len);
@@ -4135,9 +4078,7 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	ret = hns3_set_gro_and_checksum(ring, skb, l234info,
 					bd_base_info, ol_info, csum);
 	if (unlikely(ret)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.rx_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, rx_err_cnt);
 		return ret;
 	}
 
@@ -5347,9 +5288,7 @@ static int hns3_clear_rx_ring(struct hns3_enet_ring *ring)
 		if (!ring->desc_cb[ring->next_to_use].reuse_flag) {
 			ret = hns3_alloc_and_map_buffer(ring, &res_cbs);
 			if (ret) {
-				u64_stats_update_begin(&ring->syncp);
-				ring->stats.sw_err_cnt++;
-				u64_stats_update_end(&ring->syncp);
+				hns3_ring_stats_update(ring, sw_err_cnt);
 				/* if alloc new buffer fail, exit directly
 				 * and reclear in up flow.
 				 */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 808405cc0280..2803b2cd7f30 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -660,6 +660,13 @@ static inline bool hns3_nic_resetting(struct net_device *netdev)
 
 #define hns3_buf_size(_ring) ((_ring)->buf_size)
 
+#define hns3_ring_stats_update(ring, cnt) do { \
+	typeof(ring) (tmp) = (ring); \
+	u64_stats_update_begin(&(tmp)->syncp); \
+	((tmp)->stats.cnt)++; \
+	u64_stats_update_end(&(tmp)->syncp); \
+} while (0) \
+
 static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
 {
 #if (PAGE_SIZE < 8192)
-- 
2.33.0

