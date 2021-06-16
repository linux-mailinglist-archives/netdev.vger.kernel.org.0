Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BFA3A92E0
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhFPGma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:42:30 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7327 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhFPGli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:41:38 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G4b6C46MHz6y9v;
        Wed, 16 Jun 2021 14:35:31 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:30 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:30 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 5/7] net: hns3: support dma_map_sg() for multi frags skb
Date:   Wed, 16 Jun 2021 14:36:15 +0800
Message-ID: <1623825377-41948-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623825377-41948-1-git-send-email-huangguangbin2@huawei.com>
References: <1623825377-41948-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Using the queue based tx buffer, it is also possible to allocate a
sgl buffer, and use skb_to_sgvec() to convert the skb to the sgvec
in order to support the dma_map_sg() to decreases the overhead of
IOMMU mapping and unmapping.

Firstly, it reduces the number of buffers. For example, a tcp skb
may have a 66-byte header and 3 fragments of 4328, 32768, and 28064
bytes. With this patch, dma_map_sg() will combine them into two
buffers, 66-bytes header and one 65160-bytes fragment by using IOMMU.

Secondly, it reduces the number of dma mapping and unmapping. All the
original 4 buffers are mapped only once rather than 4 times.

The throughput improves above 10% when running single thread of iperf
using TCP when IOMMU is in strict mode.

Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 111 ++++++++++++++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   3 +
 3 files changed, 113 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index d86b3735aa9f..f60a344a6a9f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -57,6 +57,15 @@ static unsigned int tx_spare_buf_size;
 module_param(tx_spare_buf_size, uint, 0400);
 MODULE_PARM_DESC(tx_spare_buf_size, "Size used to allocate tx spare buffer");
 
+static unsigned int tx_sgl = 1;
+module_param(tx_sgl, uint, 0600);
+MODULE_PARM_DESC(tx_sgl, "Minimum number of frags when using dma_map_sg() to optimize the IOMMU mapping");
+
+#define HNS3_SGL_SIZE(nfrag)	(sizeof(struct scatterlist) * (nfrag) +	\
+				 sizeof(struct sg_table))
+#define HNS3_MAX_SGL_SIZE	ALIGN(HNS3_SGL_SIZE(HNS3_MAX_TSO_BD_NUM),\
+				      dma_get_cache_alignment())
+
 #define DEFAULT_MSG_LEVEL (NETIF_MSG_PROBE | NETIF_MSG_LINK | \
 			   NETIF_MSG_IFDOWN | NETIF_MSG_IFUP)
 
@@ -1001,6 +1010,25 @@ static bool hns3_can_use_tx_bounce(struct hns3_enet_ring *ring,
 	return true;
 }
 
+static bool hns3_can_use_tx_sgl(struct hns3_enet_ring *ring,
+				struct sk_buff *skb,
+				u32 space)
+{
+	if (skb->len <= ring->tx_copybreak || !tx_sgl ||
+	    (!skb_has_frag_list(skb) &&
+	     skb_shinfo(skb)->nr_frags < tx_sgl))
+		return false;
+
+	if (space < HNS3_MAX_SGL_SIZE) {
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.tx_spare_full++;
+		u64_stats_update_end(&ring->syncp);
+		return false;
+	}
+
+	return true;
+}
+
 static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 {
 	struct hns3_tx_spare *tx_spare;
@@ -1108,14 +1136,19 @@ static void hns3_tx_spare_reclaim_cb(struct hns3_enet_ring *ring,
 
 	/* This tx spare buffer is only really reclaimed after calling
 	 * hns3_tx_spare_update(), so it is still safe to use the info in
-	 * the tx buffer to do the dma sync after tx_spare->next_to_clean
-	 * is moved forword.
+	 * the tx buffer to do the dma sync or sg unmapping after
+	 * tx_spare->next_to_clean is moved forword.
 	 */
 	if (cb->type & (DESC_TYPE_BOUNCE_HEAD | DESC_TYPE_BOUNCE_ALL)) {
 		dma_addr_t dma = tx_spare->dma + ntc;
 
 		dma_sync_single_for_cpu(ring_to_dev(ring), dma, len,
 					DMA_TO_DEVICE);
+	} else {
+		struct sg_table *sgt = tx_spare->buf + ntc;
+
+		dma_unmap_sg(ring_to_dev(ring), sgt->sgl, sgt->orig_nents,
+			     DMA_TO_DEVICE);
 	}
 }
 
@@ -2058,6 +2091,65 @@ static int hns3_handle_tx_bounce(struct hns3_enet_ring *ring,
 	return bd_num;
 }
 
+static int hns3_handle_tx_sgl(struct hns3_enet_ring *ring,
+			      struct sk_buff *skb)
+{
+	struct hns3_desc_cb *desc_cb = &ring->desc_cb[ring->next_to_use];
+	u32 nfrag = skb_shinfo(skb)->nr_frags + 1;
+	struct sg_table *sgt;
+	int i, bd_num = 0;
+	dma_addr_t dma;
+	u32 cb_len;
+	int nents;
+
+	if (skb_has_frag_list(skb))
+		nfrag = HNS3_MAX_TSO_BD_NUM;
+
+	/* hns3_can_use_tx_sgl() is called to ensure the below
+	 * function can always return the tx buffer.
+	 */
+	sgt = hns3_tx_spare_alloc(ring, HNS3_SGL_SIZE(nfrag),
+				  &dma, &cb_len);
+
+	/* scatterlist follows by the sg table */
+	sgt->sgl = (struct scatterlist *)(sgt + 1);
+	sg_init_table(sgt->sgl, nfrag);
+	nents = skb_to_sgvec(skb, sgt->sgl, 0, skb->len);
+	if (unlikely(nents < 0)) {
+		hns3_tx_spare_rollback(ring, cb_len);
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.skb2sgl_err++;
+		u64_stats_update_end(&ring->syncp);
+		return -ENOMEM;
+	}
+
+	sgt->orig_nents = nents;
+	sgt->nents = dma_map_sg(ring_to_dev(ring), sgt->sgl, sgt->orig_nents,
+				DMA_TO_DEVICE);
+	if (unlikely(!sgt->nents)) {
+		hns3_tx_spare_rollback(ring, cb_len);
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.map_sg_err++;
+		u64_stats_update_end(&ring->syncp);
+		return -ENOMEM;
+	}
+
+	desc_cb->priv = skb;
+	desc_cb->length = cb_len;
+	desc_cb->dma = dma;
+	desc_cb->type = DESC_TYPE_SGL_SKB;
+
+	for (i = 0; i < sgt->nents; i++)
+		bd_num += hns3_fill_desc(ring, sg_dma_address(sgt->sgl + i),
+					 sg_dma_len(sgt->sgl + i));
+
+	u64_stats_update_begin(&ring->syncp);
+	ring->stats.tx_sgl++;
+	u64_stats_update_end(&ring->syncp);
+
+	return bd_num;
+}
+
 static int hns3_handle_desc_filling(struct hns3_enet_ring *ring,
 				    struct sk_buff *skb)
 {
@@ -2068,6 +2160,9 @@ static int hns3_handle_desc_filling(struct hns3_enet_ring *ring,
 
 	space = hns3_tx_spare_space(ring);
 
+	if (hns3_can_use_tx_sgl(ring, skb, space))
+		return hns3_handle_tx_sgl(ring, skb);
+
 	if (hns3_can_use_tx_bounce(ring, skb, space))
 		return hns3_handle_tx_bounce(ring, skb);
 
@@ -2324,6 +2419,8 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 			tx_drop += ring->stats.over_max_recursion;
 			tx_drop += ring->stats.hw_limitation;
 			tx_drop += ring->stats.copy_bits_err;
+			tx_drop += ring->stats.skb2sgl_err;
+			tx_drop += ring->stats.map_sg_err;
 			tx_errors += ring->stats.sw_err_cnt;
 			tx_errors += ring->stats.tx_vlan_err;
 			tx_errors += ring->stats.tx_l4_proto_err;
@@ -2332,6 +2429,8 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 			tx_errors += ring->stats.over_max_recursion;
 			tx_errors += ring->stats.hw_limitation;
 			tx_errors += ring->stats.copy_bits_err;
+			tx_errors += ring->stats.skb2sgl_err;
+			tx_errors += ring->stats.map_sg_err;
 		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
 
 		/* fetch the rx stats */
@@ -3126,7 +3225,7 @@ static void hns3_free_buffer(struct hns3_enet_ring *ring,
 			     struct hns3_desc_cb *cb, int budget)
 {
 	if (cb->type & (DESC_TYPE_SKB | DESC_TYPE_BOUNCE_HEAD |
-			DESC_TYPE_BOUNCE_ALL))
+			DESC_TYPE_BOUNCE_ALL | DESC_TYPE_SGL_SKB))
 		napi_consume_skb(cb->priv, budget);
 	else if (!HNAE3_IS_TX_RING(ring) && cb->pagecnt_bias)
 		__page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
@@ -3153,7 +3252,8 @@ static void hns3_unmap_buffer(struct hns3_enet_ring *ring,
 	else if ((cb->type & DESC_TYPE_PAGE) && cb->length)
 		dma_unmap_page(ring_to_dev(ring), cb->dma, cb->length,
 			       ring_to_dma_dir(ring));
-	else if (cb->type & (DESC_TYPE_BOUNCE_ALL | DESC_TYPE_BOUNCE_HEAD))
+	else if (cb->type & (DESC_TYPE_BOUNCE_ALL | DESC_TYPE_BOUNCE_HEAD |
+			     DESC_TYPE_SGL_SKB))
 		hns3_tx_spare_reclaim_cb(ring, cb);
 }
 
@@ -3307,7 +3407,8 @@ static bool hns3_nic_reclaim_desc(struct hns3_enet_ring *ring,
 		desc_cb = &ring->desc_cb[ntc];
 
 		if (desc_cb->type & (DESC_TYPE_SKB | DESC_TYPE_BOUNCE_ALL |
-				     DESC_TYPE_BOUNCE_HEAD)) {
+				     DESC_TYPE_BOUNCE_HEAD |
+				     DESC_TYPE_SGL_SKB)) {
 			(*pkts)++;
 			(*bytes) += desc_cb->send_bytes;
 		}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 8d147c1dab2c..22ae291471aa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -306,6 +306,7 @@ enum hns3_desc_type {
 	DESC_TYPE_PAGE			= 1 << 2,
 	DESC_TYPE_BOUNCE_ALL		= 1 << 3,
 	DESC_TYPE_BOUNCE_HEAD		= 1 << 4,
+	DESC_TYPE_SGL_SKB		= 1 << 5,
 };
 
 struct hns3_desc_cb {
@@ -410,6 +411,9 @@ struct ring_stats {
 			u64 tx_bounce;
 			u64 tx_spare_full;
 			u64 copy_bits_err;
+			u64 tx_sgl;
+			u64 skb2sgl_err;
+			u64 map_sg_err;
 		};
 		struct {
 			u64 rx_pkts;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index f306de16d73f..d7852716aaad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -49,6 +49,9 @@ static const struct hns3_stats hns3_txq_stats[] = {
 	HNS3_TQP_STAT("bounce", tx_bounce),
 	HNS3_TQP_STAT("spare_full", tx_spare_full),
 	HNS3_TQP_STAT("copy_bits_err", copy_bits_err),
+	HNS3_TQP_STAT("sgl", tx_sgl),
+	HNS3_TQP_STAT("skb2sgl_err", skb2sgl_err),
+	HNS3_TQP_STAT("map_sg_err", map_sg_err),
 };
 
 #define HNS3_TXQ_STATS_COUNT ARRAY_SIZE(hns3_txq_stats)
-- 
2.8.1

