Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1BB3A92D8
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhFPGmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:42:18 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4801 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbhFPGlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:41:39 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4b533XwjzWtRx;
        Wed, 16 Jun 2021 14:34:31 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:30 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:29 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/7] net: hns3: use tx bounce buffer for small packets
Date:   Wed, 16 Jun 2021 14:36:13 +0800
Message-ID: <1623825377-41948-4-git-send-email-huangguangbin2@huawei.com>
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

when the packet or frag size is small, it causes both security and
performance issue. As dma can't map sub-page, this means some extra
kernel data is visible to devices. On the other hand, the overhead
of dma map and unmap is huge when IOMMU is on.

So add a queue based tx shared bounce buffer to memcpy the small
packet when the len of the xmitted skb is below tx_copybreak.
Add tx_spare_buf_size module param to set the size of tx spare
buffer, and add set/get_tunable to set or query the tx_copybreak.

The throughtput improves from 30 Gbps to 90+ Gbps when running 16
netperf threads with 32KB UDP message size when IOMMU is in the
strict mode(tx_copybreak = 2000 and mtu = 1500).

Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  52 ++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 289 ++++++++++++++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  43 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  51 ++++
 4 files changed, 420 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index c512a63c423b..a24a75c47cad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -392,6 +392,56 @@ static void hns3_dbg_fill_content(char *content, u16 len,
 	*pos++ = '\0';
 }
 
+static const struct hns3_dbg_item tx_spare_info_items[] = {
+	{ "QUEUE_ID", 2 },
+	{ "COPYBREAK", 2 },
+	{ "LEN", 7 },
+	{ "NTU", 4 },
+	{ "NTC", 4 },
+	{ "LTC", 4 },
+	{ "DMA", 17 },
+};
+
+static void hns3_dbg_tx_spare_info(struct hns3_enet_ring *ring, char *buf,
+				   int len, u32 ring_num, int *pos)
+{
+	char data_str[ARRAY_SIZE(tx_spare_info_items)][HNS3_DBG_DATA_STR_LEN];
+	struct hns3_tx_spare *tx_spare = ring->tx_spare;
+	char *result[ARRAY_SIZE(tx_spare_info_items)];
+	char content[HNS3_DBG_INFO_LEN];
+	u32 i, j;
+
+	if (!tx_spare) {
+		*pos += scnprintf(buf + *pos, len - *pos,
+				  "tx spare buffer is not enabled\n");
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(tx_spare_info_items); i++)
+		result[i] = &data_str[i][0];
+
+	*pos += scnprintf(buf + *pos, len - *pos, "tx spare buffer info\n");
+	hns3_dbg_fill_content(content, sizeof(content), tx_spare_info_items,
+			      NULL, ARRAY_SIZE(tx_spare_info_items));
+	*pos += scnprintf(buf + *pos, len - *pos, "%s", content);
+
+	for (i = 0; i < ring_num; i++) {
+		j = 0;
+		sprintf(result[j++], "%8u", i);
+		sprintf(result[j++], "%9u", ring->tx_copybreak);
+		sprintf(result[j++], "%3u", tx_spare->len);
+		sprintf(result[j++], "%3u", tx_spare->next_to_use);
+		sprintf(result[j++], "%3u", tx_spare->next_to_clean);
+		sprintf(result[j++], "%3u", tx_spare->last_to_clean);
+		sprintf(result[j++], "%pad", &tx_spare->dma);
+		hns3_dbg_fill_content(content, sizeof(content),
+				      tx_spare_info_items,
+				      (const char **)result,
+				      ARRAY_SIZE(tx_spare_info_items));
+		*pos += scnprintf(buf + *pos, len - *pos, "%s", content);
+	}
+}
+
 static const struct hns3_dbg_item rx_queue_info_items[] = {
 	{ "QUEUE_ID", 2 },
 	{ "BD_NUM", 2 },
@@ -593,6 +643,8 @@ static int hns3_dbg_tx_queue_info(struct hnae3_handle *h,
 		pos += scnprintf(buf + pos, len - pos, "%s", content);
 	}
 
+	hns3_dbg_tx_spare_info(ring, buf, len, h->kinfo.num_tqps, &pos);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 6fa1ed5c4098..e5466daac1c4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -53,6 +53,10 @@ static int debug = -1;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, " Network interface message level setting");
 
+static unsigned int tx_spare_buf_size;
+module_param(tx_spare_buf_size, uint, 0400);
+MODULE_PARM_DESC(tx_spare_buf_size, "Size used to allocate tx spare buffer");
+
 #define DEFAULT_MSG_LEVEL (NETIF_MSG_PROBE | NETIF_MSG_LINK | \
 			   NETIF_MSG_IFDOWN | NETIF_MSG_IFUP)
 
@@ -941,6 +945,177 @@ void hns3_request_update_promisc_mode(struct hnae3_handle *handle)
 		ops->request_update_promisc_mode(handle);
 }
 
+static u32 hns3_tx_spare_space(struct hns3_enet_ring *ring)
+{
+	struct hns3_tx_spare *tx_spare = ring->tx_spare;
+	u32 ntc, ntu;
+
+	/* This smp_load_acquire() pairs with smp_store_release() in
+	 * hns3_tx_spare_update() called in tx desc cleaning process.
+	 */
+	ntc = smp_load_acquire(&tx_spare->last_to_clean);
+	ntu = tx_spare->next_to_use;
+
+	if (ntc > ntu)
+		return ntc - ntu - 1;
+
+	/* The free tx buffer is divided into two part, so pick the
+	 * larger one.
+	 */
+	return (ntc > (tx_spare->len - ntu) ? ntc :
+			(tx_spare->len - ntu)) - 1;
+}
+
+static void hns3_tx_spare_update(struct hns3_enet_ring *ring)
+{
+	struct hns3_tx_spare *tx_spare = ring->tx_spare;
+
+	if (!tx_spare ||
+	    tx_spare->last_to_clean == tx_spare->next_to_clean)
+		return;
+
+	/* This smp_store_release() pairs with smp_load_acquire() in
+	 * hns3_tx_spare_space() called in xmit process.
+	 */
+	smp_store_release(&tx_spare->last_to_clean,
+			  tx_spare->next_to_clean);
+}
+
+static bool hns3_can_use_tx_bounce(struct hns3_enet_ring *ring,
+				   struct sk_buff *skb,
+				   u32 space)
+{
+	u32 len = skb->len <= ring->tx_copybreak ? skb->len :
+				skb_headlen(skb);
+
+	if (len > ring->tx_copybreak)
+		return false;
+
+	if (ALIGN(len, dma_get_cache_alignment()) > space) {
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.tx_spare_full++;
+		u64_stats_update_end(&ring->syncp);
+		return false;
+	}
+
+	return true;
+}
+
+static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
+{
+	struct hns3_tx_spare *tx_spare;
+	struct page *page;
+	dma_addr_t dma;
+	int order;
+
+	if (!tx_spare_buf_size)
+		return;
+
+	order = get_order(tx_spare_buf_size);
+	tx_spare = devm_kzalloc(ring_to_dev(ring), sizeof(*tx_spare),
+				GFP_KERNEL);
+	if (!tx_spare) {
+		/* The driver still work without the tx spare buffer */
+		dev_warn(ring_to_dev(ring), "failed to allocate hns3_tx_spare\n");
+		return;
+	}
+
+	page = alloc_pages_node(dev_to_node(ring_to_dev(ring)),
+				GFP_KERNEL, order);
+	if (!page) {
+		dev_warn(ring_to_dev(ring), "failed to allocate tx spare pages\n");
+		devm_kfree(ring_to_dev(ring), tx_spare);
+		return;
+	}
+
+	dma = dma_map_page(ring_to_dev(ring), page, 0,
+			   PAGE_SIZE << order, DMA_TO_DEVICE);
+	if (dma_mapping_error(ring_to_dev(ring), dma)) {
+		dev_warn(ring_to_dev(ring), "failed to map pages for tx spare\n");
+		put_page(page);
+		devm_kfree(ring_to_dev(ring), tx_spare);
+		return;
+	}
+
+	tx_spare->dma = dma;
+	tx_spare->buf = page_address(page);
+	tx_spare->len = PAGE_SIZE << order;
+	ring->tx_spare = tx_spare;
+}
+
+/* Use hns3_tx_spare_space() to make sure there is enough buffer
+ * before calling below function to allocate tx buffer.
+ */
+static void *hns3_tx_spare_alloc(struct hns3_enet_ring *ring,
+				 unsigned int size, dma_addr_t *dma,
+				 u32 *cb_len)
+{
+	struct hns3_tx_spare *tx_spare = ring->tx_spare;
+	u32 ntu = tx_spare->next_to_use;
+
+	size = ALIGN(size, dma_get_cache_alignment());
+	*cb_len = size;
+
+	/* Tx spare buffer wraps back here because the end of
+	 * freed tx buffer is not enough.
+	 */
+	if (ntu + size > tx_spare->len) {
+		*cb_len += (tx_spare->len - ntu);
+		ntu = 0;
+	}
+
+	tx_spare->next_to_use = ntu + size;
+	if (tx_spare->next_to_use == tx_spare->len)
+		tx_spare->next_to_use = 0;
+
+	*dma = tx_spare->dma + ntu;
+
+	return tx_spare->buf + ntu;
+}
+
+static void hns3_tx_spare_rollback(struct hns3_enet_ring *ring, u32 len)
+{
+	struct hns3_tx_spare *tx_spare = ring->tx_spare;
+
+	if (len > tx_spare->next_to_use) {
+		len -= tx_spare->next_to_use;
+		tx_spare->next_to_use = tx_spare->len - len;
+	} else {
+		tx_spare->next_to_use -= len;
+	}
+}
+
+static void hns3_tx_spare_reclaim_cb(struct hns3_enet_ring *ring,
+				     struct hns3_desc_cb *cb)
+{
+	struct hns3_tx_spare *tx_spare = ring->tx_spare;
+	u32 ntc = tx_spare->next_to_clean;
+	u32 len = cb->length;
+
+	tx_spare->next_to_clean += len;
+
+	if (tx_spare->next_to_clean >= tx_spare->len) {
+		tx_spare->next_to_clean -= tx_spare->len;
+
+		if (tx_spare->next_to_clean) {
+			ntc = 0;
+			len = tx_spare->next_to_clean;
+		}
+	}
+
+	/* This tx spare buffer is only really reclaimed after calling
+	 * hns3_tx_spare_update(), so it is still safe to use the info in
+	 * the tx buffer to do the dma sync after tx_spare->next_to_clean
+	 * is moved forword.
+	 */
+	if (cb->type & (DESC_TYPE_BOUNCE_HEAD | DESC_TYPE_BOUNCE_ALL)) {
+		dma_addr_t dma = tx_spare->dma + ntc;
+
+		dma_sync_single_for_cpu(ring_to_dev(ring), dma, len,
+					DMA_TO_DEVICE);
+	}
+}
+
 static int hns3_set_tso(struct sk_buff *skb, u32 *paylen_fdop_ol4cs,
 			u16 *mss, u32 *type_cs_vlan_tso, u32 *send_bytes)
 {
@@ -1471,6 +1646,11 @@ static int hns3_map_and_fill_desc(struct hns3_enet_ring *ring, void *priv,
 			return 0;
 
 		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
+	} else if (type & DESC_TYPE_BOUNCE_HEAD) {
+		/* Head data has been filled in hns3_handle_tx_bounce(),
+		 * just return 0 here.
+		 */
+		return 0;
 	} else {
 		skb_frag_t *frag = (skb_frag_t *)priv;
 
@@ -1739,6 +1919,9 @@ static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
 		if (desc_cb->type & (DESC_TYPE_SKB | DESC_TYPE_FRAGLIST_SKB))
 			dma_unmap_single(dev, desc_cb->dma, desc_cb->length,
 					 DMA_TO_DEVICE);
+		else if (desc_cb->type &
+			 (DESC_TYPE_BOUNCE_HEAD | DESC_TYPE_BOUNCE_ALL))
+			hns3_tx_spare_rollback(ring, desc_cb->length);
 		else if (desc_cb->length)
 			dma_unmap_page(dev, desc_cb->dma, desc_cb->length,
 				       DMA_TO_DEVICE);
@@ -1816,6 +1999,79 @@ static void hns3_tsyn(struct net_device *netdev, struct sk_buff *skb,
 	desc->tx.bdtp_fe_sc_vld_ra_ri |= cpu_to_le16(BIT(HNS3_TXD_TSYN_B));
 }
 
+static int hns3_handle_tx_bounce(struct hns3_enet_ring *ring,
+				 struct sk_buff *skb)
+{
+	struct hns3_desc_cb *desc_cb = &ring->desc_cb[ring->next_to_use];
+	unsigned int type = DESC_TYPE_BOUNCE_HEAD;
+	unsigned int size = skb_headlen(skb);
+	dma_addr_t dma;
+	int bd_num = 0;
+	u32 cb_len;
+	void *buf;
+	int ret;
+
+	if (skb->len <= ring->tx_copybreak) {
+		size = skb->len;
+		type = DESC_TYPE_BOUNCE_ALL;
+	}
+
+	/* hns3_can_use_tx_bounce() is called to ensure the below
+	 * function can always return the tx buffer.
+	 */
+	buf = hns3_tx_spare_alloc(ring, size, &dma, &cb_len);
+
+	ret = skb_copy_bits(skb, 0, buf, size);
+	if (unlikely(ret < 0)) {
+		hns3_tx_spare_rollback(ring, cb_len);
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.copy_bits_err++;
+		u64_stats_update_end(&ring->syncp);
+		return ret;
+	}
+
+	desc_cb->priv = skb;
+	desc_cb->length = cb_len;
+	desc_cb->dma = dma;
+	desc_cb->type = type;
+
+	bd_num += hns3_fill_desc(ring, dma, size);
+
+	if (type == DESC_TYPE_BOUNCE_HEAD) {
+		ret = hns3_fill_skb_to_desc(ring, skb,
+					    DESC_TYPE_BOUNCE_HEAD);
+		if (unlikely(ret < 0))
+			return ret;
+
+		bd_num += ret;
+	}
+
+	dma_sync_single_for_device(ring_to_dev(ring), dma, size,
+				   DMA_TO_DEVICE);
+
+	u64_stats_update_begin(&ring->syncp);
+	ring->stats.tx_bounce++;
+	u64_stats_update_end(&ring->syncp);
+	return bd_num;
+}
+
+static int hns3_handle_desc_filling(struct hns3_enet_ring *ring,
+				    struct sk_buff *skb)
+{
+	u32 space;
+
+	if (!ring->tx_spare)
+		goto out;
+
+	space = hns3_tx_spare_space(ring);
+
+	if (hns3_can_use_tx_bounce(ring, skb, space))
+		return hns3_handle_tx_bounce(ring, skb);
+
+out:
+	return hns3_fill_skb_to_desc(ring, skb, DESC_TYPE_SKB);
+}
+
 netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
@@ -1862,7 +2118,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	 * zero, which is unlikely, and 'ret > 0' means how many tx desc
 	 * need to be notified to the hw.
 	 */
-	ret = hns3_fill_skb_to_desc(ring, skb, DESC_TYPE_SKB);
+	ret = hns3_handle_desc_filling(ring, skb);
 	if (unlikely(ret <= 0))
 		goto fill_err;
 
@@ -2064,6 +2320,7 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 			tx_drop += ring->stats.tx_tso_err;
 			tx_drop += ring->stats.over_max_recursion;
 			tx_drop += ring->stats.hw_limitation;
+			tx_drop += ring->stats.copy_bits_err;
 			tx_errors += ring->stats.sw_err_cnt;
 			tx_errors += ring->stats.tx_vlan_err;
 			tx_errors += ring->stats.tx_l4_proto_err;
@@ -2071,6 +2328,7 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 			tx_errors += ring->stats.tx_tso_err;
 			tx_errors += ring->stats.over_max_recursion;
 			tx_errors += ring->stats.hw_limitation;
+			tx_errors += ring->stats.copy_bits_err;
 		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
 
 		/* fetch the rx stats */
@@ -2864,7 +3122,8 @@ static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
 static void hns3_free_buffer(struct hns3_enet_ring *ring,
 			     struct hns3_desc_cb *cb, int budget)
 {
-	if (cb->type & DESC_TYPE_SKB)
+	if (cb->type & (DESC_TYPE_SKB | DESC_TYPE_BOUNCE_HEAD |
+			DESC_TYPE_BOUNCE_ALL))
 		napi_consume_skb(cb->priv, budget);
 	else if (!HNAE3_IS_TX_RING(ring) && cb->pagecnt_bias)
 		__page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
@@ -2888,9 +3147,11 @@ static void hns3_unmap_buffer(struct hns3_enet_ring *ring,
 	if (cb->type & (DESC_TYPE_SKB | DESC_TYPE_FRAGLIST_SKB))
 		dma_unmap_single(ring_to_dev(ring), cb->dma, cb->length,
 				 ring_to_dma_dir(ring));
-	else if (cb->length)
+	else if ((cb->type & DESC_TYPE_PAGE) && cb->length)
 		dma_unmap_page(ring_to_dev(ring), cb->dma, cb->length,
 			       ring_to_dma_dir(ring));
+	else if (cb->type & (DESC_TYPE_BOUNCE_ALL | DESC_TYPE_BOUNCE_HEAD))
+		hns3_tx_spare_reclaim_cb(ring, cb);
 }
 
 static void hns3_buffer_detach(struct hns3_enet_ring *ring, int i)
@@ -3042,7 +3303,8 @@ static bool hns3_nic_reclaim_desc(struct hns3_enet_ring *ring,
 
 		desc_cb = &ring->desc_cb[ntc];
 
-		if (desc_cb->type & DESC_TYPE_SKB) {
+		if (desc_cb->type & (DESC_TYPE_SKB | DESC_TYPE_BOUNCE_ALL |
+				     DESC_TYPE_BOUNCE_HEAD)) {
 			(*pkts)++;
 			(*bytes) += desc_cb->send_bytes;
 		}
@@ -3065,6 +3327,9 @@ static bool hns3_nic_reclaim_desc(struct hns3_enet_ring *ring,
 	 * ring_space called by hns3_nic_net_xmit.
 	 */
 	smp_store_release(&ring->next_to_clean, ntc);
+
+	hns3_tx_spare_update(ring);
+
 	return true;
 }
 
@@ -4245,6 +4510,8 @@ static void hns3_ring_get_cfg(struct hnae3_queue *q, struct hns3_nic_priv *priv,
 		ring = &priv->ring[q->tqp_index];
 		desc_num = priv->ae_handle->kinfo.num_tx_desc;
 		ring->queue_index = q->tqp_index;
+		ring->tx_copybreak = priv->tx_copybreak;
+		ring->last_to_use = 0;
 	} else {
 		ring = &priv->ring[q->tqp_index + queue_num];
 		desc_num = priv->ae_handle->kinfo.num_rx_desc;
@@ -4262,7 +4529,6 @@ static void hns3_ring_get_cfg(struct hnae3_queue *q, struct hns3_nic_priv *priv,
 	ring->desc_num = desc_num;
 	ring->next_to_use = 0;
 	ring->next_to_clean = 0;
-	ring->last_to_use = 0;
 }
 
 static void hns3_queue_to_ring(struct hnae3_queue *tqp,
@@ -4322,6 +4588,8 @@ static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
 		ret = hns3_alloc_ring_buffers(ring);
 		if (ret)
 			goto out_with_desc;
+	} else {
+		hns3_init_tx_spare_buffer(ring);
 	}
 
 	return 0;
@@ -4344,9 +4612,18 @@ void hns3_fini_ring(struct hns3_enet_ring *ring)
 	ring->next_to_use = 0;
 	ring->last_to_use = 0;
 	ring->pending_buf = 0;
-	if (ring->skb) {
+	if (!HNAE3_IS_TX_RING(ring) && ring->skb) {
 		dev_kfree_skb_any(ring->skb);
 		ring->skb = NULL;
+	} else if (HNAE3_IS_TX_RING(ring) && ring->tx_spare) {
+		struct hns3_tx_spare *tx_spare = ring->tx_spare;
+
+		dma_unmap_page(ring_to_dev(ring), tx_spare->dma, tx_spare->len,
+			       DMA_TO_DEVICE);
+		free_pages((unsigned long)tx_spare->buf,
+			   get_order(tx_spare->len));
+		devm_kfree(ring_to_dev(ring), tx_spare);
+		ring->tx_spare = NULL;
 	}
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 9d18b9430b54..8d147c1dab2c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -304,6 +304,8 @@ enum hns3_desc_type {
 	DESC_TYPE_SKB			= 1 << 0,
 	DESC_TYPE_FRAGLIST_SKB		= 1 << 1,
 	DESC_TYPE_PAGE			= 1 << 2,
+	DESC_TYPE_BOUNCE_ALL		= 1 << 3,
+	DESC_TYPE_BOUNCE_HEAD		= 1 << 4,
 };
 
 struct hns3_desc_cb {
@@ -405,6 +407,9 @@ struct ring_stats {
 			u64 tx_tso_err;
 			u64 over_max_recursion;
 			u64 hw_limitation;
+			u64 tx_bounce;
+			u64 tx_spare_full;
+			u64 copy_bits_err;
 		};
 		struct {
 			u64 rx_pkts;
@@ -423,6 +428,15 @@ struct ring_stats {
 	};
 };
 
+struct hns3_tx_spare {
+	dma_addr_t dma;
+	void *buf;
+	u32 next_to_use;
+	u32 next_to_clean;
+	u32 last_to_clean;
+	u32 len;
+};
+
 struct hns3_enet_ring {
 	struct hns3_desc *desc; /* dma map address space */
 	struct hns3_desc_cb *desc_cb;
@@ -445,18 +459,28 @@ struct hns3_enet_ring {
 	 * next_to_use
 	 */
 	int next_to_clean;
-	union {
-		int last_to_use;	/* last idx used by xmit */
-		u32 pull_len;		/* memcpy len for current rx packet */
-	};
-	u32 frag_num;
-	void *va; /* first buffer address for current packet */
-
 	u32 flag;          /* ring attribute */
 
 	int pending_buf;
-	struct sk_buff *skb;
-	struct sk_buff *tail_skb;
+	union {
+		/* for Tx ring */
+		struct {
+			u32 fd_qb_tx_sample;
+			int last_to_use;        /* last idx used by xmit */
+			u32 tx_copybreak;
+			struct hns3_tx_spare *tx_spare;
+		};
+
+		/* for Rx ring */
+		struct {
+			u32 pull_len;   /* memcpy len for current rx packet */
+			u32 frag_num;
+			/* first buffer address for current packet */
+			unsigned char *va;
+			struct sk_buff *skb;
+			struct sk_buff *tail_skb;
+		};
+	};
 } ____cacheline_internodealigned_in_smp;
 
 enum hns3_flow_level_range {
@@ -540,6 +564,7 @@ struct hns3_nic_priv {
 
 	struct hns3_enet_coalesce tx_coal;
 	struct hns3_enet_coalesce rx_coal;
+	u32 tx_copybreak;
 };
 
 union l3_hdr_info {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index acef5435d7b7..f306de16d73f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -46,6 +46,9 @@ static const struct hns3_stats hns3_txq_stats[] = {
 	HNS3_TQP_STAT("tso_err", tx_tso_err),
 	HNS3_TQP_STAT("over_max_recursion", over_max_recursion),
 	HNS3_TQP_STAT("hw_limitation", hw_limitation),
+	HNS3_TQP_STAT("bounce", tx_bounce),
+	HNS3_TQP_STAT("spare_full", tx_spare_full),
+	HNS3_TQP_STAT("copy_bits_err", copy_bits_err),
 };
 
 #define HNS3_TXQ_STATS_COUNT ARRAY_SIZE(hns3_txq_stats)
@@ -1592,6 +1595,50 @@ static int hns3_set_priv_flags(struct net_device *netdev, u32 pflags)
 	return 0;
 }
 
+static int hns3_get_tunable(struct net_device *netdev,
+			    const struct ethtool_tunable *tuna,
+			    void *data)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	int ret = 0;
+
+	switch (tuna->id) {
+	case ETHTOOL_TX_COPYBREAK:
+		/* all the tx rings have the same tx_copybreak */
+		*(u32 *)data = priv->tx_copybreak;
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+static int hns3_set_tunable(struct net_device *netdev,
+			    const struct ethtool_tunable *tuna,
+			    const void *data)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hnae3_handle *h = priv->ae_handle;
+	int i, ret = 0;
+
+	switch (tuna->id) {
+	case ETHTOOL_TX_COPYBREAK:
+		priv->tx_copybreak = *(u32 *)data;
+
+		for (i = 0; i < h->kinfo.num_tqps; i++)
+			priv->ring[i].tx_copybreak = priv->tx_copybreak;
+
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
 #define HNS3_ETHTOOL_COALESCE	(ETHTOOL_COALESCE_USECS |		\
 				 ETHTOOL_COALESCE_USE_ADAPTIVE |	\
 				 ETHTOOL_COALESCE_RX_USECS_HIGH |	\
@@ -1635,6 +1682,8 @@ static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.set_msglevel = hns3_set_msglevel,
 	.get_priv_flags = hns3_get_priv_flags,
 	.set_priv_flags = hns3_set_priv_flags,
+	.get_tunable = hns3_get_tunable,
+	.set_tunable = hns3_set_tunable,
 };
 
 static const struct ethtool_ops hns3_ethtool_ops = {
@@ -1674,6 +1723,8 @@ static const struct ethtool_ops hns3_ethtool_ops = {
 	.get_priv_flags = hns3_get_priv_flags,
 	.set_priv_flags = hns3_set_priv_flags,
 	.get_ts_info = hns3_get_ts_info,
+	.get_tunable = hns3_get_tunable,
+	.set_tunable = hns3_set_tunable,
 };
 
 void hns3_ethtool_set_ops(struct net_device *netdev)
-- 
2.8.1

