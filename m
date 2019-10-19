Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD08DD73B
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 10:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbfJSID3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 04:03:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33732 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727025AbfJSID2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 04:03:28 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C3D12189B368910B5368;
        Sat, 19 Oct 2019 16:03:25 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sat, 19 Oct 2019 16:03:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/8] net: hns3: remove struct hns3_nic_ring_data in hns3_enet module
Date:   Sat, 19 Oct 2019 16:03:49 +0800
Message-ID: <1571472236-17401-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571472236-17401-1-git-send-email-tanhuazhong@huawei.com>
References: <1571472236-17401-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Only the queue_index field in struct hns3_nic_ring_data is
used, other field is unused and unnecessary for hns3 driver,
so this patch removes it and move the queue_index field to
hns3_enet_ring.

This patch also removes an unused struct hns_queue declaration.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  24 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 139 +++++++--------------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  16 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  33 +++--
 4 files changed, 74 insertions(+), 138 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 28961a6..fe5bc6f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -16,15 +16,14 @@ static int hns3_dbg_queue_info(struct hnae3_handle *h,
 			       const char *cmd_buf)
 {
 	struct hns3_nic_priv *priv = h->priv;
-	struct hns3_nic_ring_data *ring_data;
 	struct hns3_enet_ring *ring;
 	u32 base_add_l, base_add_h;
 	u32 queue_num, queue_max;
 	u32 value, i = 0;
 	int cnt;
 
-	if (!priv->ring_data) {
-		dev_err(&h->pdev->dev, "ring_data is NULL\n");
+	if (!priv->ring) {
+		dev_err(&h->pdev->dev, "priv->ring is NULL\n");
 		return -EFAULT;
 	}
 
@@ -44,7 +43,6 @@ static int hns3_dbg_queue_info(struct hnae3_handle *h,
 		return -EINVAL;
 	}
 
-	ring_data = priv->ring_data;
 	for (i = queue_num; i < queue_max; i++) {
 		/* Each cycle needs to determine whether the instance is reset,
 		 * to prevent reference to invalid memory. And need to ensure
@@ -54,7 +52,7 @@ static int hns3_dbg_queue_info(struct hnae3_handle *h,
 		    test_bit(HNS3_NIC_STATE_RESETTING, &priv->state))
 			return -EPERM;
 
-		ring = ring_data[(u32)(i + h->kinfo.num_tqps)].ring;
+		ring = &priv->ring[(u32)(i + h->kinfo.num_tqps)];
 		base_add_h = readl_relaxed(ring->tqp->io_base +
 					   HNS3_RING_RX_RING_BASEADDR_H_REG);
 		base_add_l = readl_relaxed(ring->tqp->io_base +
@@ -86,7 +84,7 @@ static int hns3_dbg_queue_info(struct hnae3_handle *h,
 				      HNS3_RING_RX_RING_PKTNUM_RECORD_REG);
 		dev_info(&h->pdev->dev, "RX(%d) RING PKTNUM: %u\n", i, value);
 
-		ring = ring_data[i].ring;
+		ring = &priv->ring[i];
 		base_add_h = readl_relaxed(ring->tqp->io_base +
 					   HNS3_RING_TX_RING_BASEADDR_H_REG);
 		base_add_l = readl_relaxed(ring->tqp->io_base +
@@ -130,7 +128,6 @@ static int hns3_dbg_queue_info(struct hnae3_handle *h,
 static int hns3_dbg_queue_map(struct hnae3_handle *h)
 {
 	struct hns3_nic_priv *priv = h->priv;
-	struct hns3_nic_ring_data *ring_data;
 	int i;
 
 	if (!h->ae_algo->ops->get_global_queue_id)
@@ -143,15 +140,12 @@ static int hns3_dbg_queue_map(struct hnae3_handle *h)
 		u16 global_qid;
 
 		global_qid = h->ae_algo->ops->get_global_queue_id(h, i);
-		ring_data = &priv->ring_data[i];
-		if (!ring_data || !ring_data->ring ||
-		    !ring_data->ring->tqp_vector)
+		if (!priv->ring || !priv->ring[i].tqp_vector)
 			continue;
 
 		dev_info(&h->pdev->dev,
 			 "      %4d            %4d            %4d\n",
-			 i, global_qid,
-			 ring_data->ring->tqp_vector->vector_irq);
+			 i, global_qid, priv->ring[i].tqp_vector->vector_irq);
 	}
 
 	return 0;
@@ -160,7 +154,6 @@ static int hns3_dbg_queue_map(struct hnae3_handle *h)
 static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 {
 	struct hns3_nic_priv *priv = h->priv;
-	struct hns3_nic_ring_data *ring_data;
 	struct hns3_desc *rx_desc, *tx_desc;
 	struct device *dev = &h->pdev->dev;
 	struct hns3_enet_ring *ring;
@@ -183,8 +176,7 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 		return -EINVAL;
 	}
 
-	ring_data = priv->ring_data;
-	ring  = ring_data[q_num].ring;
+	ring  = &priv->ring[q_num];
 	value = readl_relaxed(ring->tqp->io_base + HNS3_RING_TX_RING_TAIL_REG);
 	tx_index = (cnt == 1) ? value : tx_index;
 
@@ -214,7 +206,7 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	dev_info(dev, "(TX)vld_ra_ri: %u\n", tx_desc->tx.bdtp_fe_sc_vld_ra_ri);
 	dev_info(dev, "(TX)mss: %u\n", tx_desc->tx.mss);
 
-	ring  = ring_data[q_num + h->kinfo.num_tqps].ring;
+	ring  = &priv->ring[q_num + h->kinfo.num_tqps];
 	value = readl_relaxed(ring->tqp->io_base + HNS3_RING_RX_RING_TAIL_REG);
 	rx_index = (cnt == 1) ? value : tx_index;
 	rx_desc	 = &ring->desc[rx_index];
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 6e0b261..635bdda 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -483,7 +483,7 @@ static void hns3_reset_tx_queue(struct hnae3_handle *h)
 
 	for (i = 0; i < h->kinfo.num_tqps; i++) {
 		dev_queue = netdev_get_tx_queue(ndev,
-						priv->ring_data[i].queue_index);
+						priv->ring[i].queue_index);
 		netdev_tx_reset_queue(dev_queue);
 	}
 }
@@ -1390,9 +1390,7 @@ static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
 netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
-	struct hns3_nic_ring_data *ring_data =
-		&tx_ring_data(priv, skb->queue_mapping);
-	struct hns3_enet_ring *ring = ring_data->ring;
+	struct hns3_enet_ring *ring = &priv->ring[skb->queue_mapping];
 	struct netdev_queue *dev_queue;
 	int pre_ntu, next_to_use_head;
 	struct sk_buff *frag_skb;
@@ -1444,7 +1442,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 				cpu_to_le16(BIT(HNS3_TXD_FE_B));
 
 	/* Complete translate all packets */
-	dev_queue = netdev_get_tx_queue(netdev, ring_data->queue_index);
+	dev_queue = netdev_get_tx_queue(netdev, ring->queue_index);
 	netdev_tx_sent_queue(dev_queue, skb->len);
 
 	wmb(); /* Commit all data before submit */
@@ -1461,7 +1459,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 
 out_net_tx_busy:
-	netif_stop_subqueue(netdev, ring_data->queue_index);
+	netif_stop_subqueue(netdev, ring->queue_index);
 	smp_mb(); /* Commit all data before submit */
 
 	return NETDEV_TX_BUSY;
@@ -1584,7 +1582,7 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 
 	for (idx = 0; idx < queue_num; idx++) {
 		/* fetch the tx stats */
-		ring = priv->ring_data[idx].ring;
+		ring = &priv->ring[idx];
 		do {
 			start = u64_stats_fetch_begin_irq(&ring->syncp);
 			tx_bytes += ring->stats.tx_bytes;
@@ -1602,7 +1600,7 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
 
 		/* fetch the rx stats */
-		ring = priv->ring_data[idx + queue_num].ring;
+		ring = &priv->ring[idx + queue_num];
 		do {
 			start = u64_stats_fetch_begin_irq(&ring->syncp);
 			rx_bytes += ring->stats.rx_bytes;
@@ -1807,7 +1805,7 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 
 	priv->tx_timeout_count++;
 
-	tx_ring = priv->ring_data[timeout_queue].ring;
+	tx_ring = &priv->ring[timeout_queue];
 	napi = &tx_ring->tqp_vector->napi;
 
 	netdev_info(ndev,
@@ -3484,13 +3482,13 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 		tqp_vector = &priv->tqp_vector[vector_i];
 
 		hns3_add_ring_to_group(&tqp_vector->tx_group,
-				       priv->ring_data[i].ring);
+				       &priv->ring[i]);
 
 		hns3_add_ring_to_group(&tqp_vector->rx_group,
-				       priv->ring_data[i + tqp_num].ring);
+				       &priv->ring[i + tqp_num]);
 
-		priv->ring_data[i].ring->tqp_vector = tqp_vector;
-		priv->ring_data[i + tqp_num].ring->tqp_vector = tqp_vector;
+		priv->ring[i].tqp_vector = tqp_vector;
+		priv->ring[i + tqp_num].tqp_vector = tqp_vector;
 		tqp_vector->num_tqps++;
 	}
 
@@ -3634,28 +3632,22 @@ static int hns3_nic_dealloc_vector_data(struct hns3_nic_priv *priv)
 	return 0;
 }
 
-static int hns3_ring_get_cfg(struct hnae3_queue *q, struct hns3_nic_priv *priv,
-			     unsigned int ring_type)
+static void hns3_ring_get_cfg(struct hnae3_queue *q, struct hns3_nic_priv *priv,
+			      unsigned int ring_type)
 {
-	struct hns3_nic_ring_data *ring_data = priv->ring_data;
 	int queue_num = priv->ae_handle->kinfo.num_tqps;
-	struct pci_dev *pdev = priv->ae_handle->pdev;
 	struct hns3_enet_ring *ring;
 	int desc_num;
 
-	ring = devm_kzalloc(&pdev->dev, sizeof(*ring), GFP_KERNEL);
-	if (!ring)
-		return -ENOMEM;
-
 	if (ring_type == HNAE3_RING_TYPE_TX) {
+		ring = &priv->ring[q->tqp_index];
 		desc_num = priv->ae_handle->kinfo.num_tx_desc;
-		ring_data[q->tqp_index].ring = ring;
-		ring_data[q->tqp_index].queue_index = q->tqp_index;
+		ring->queue_index = q->tqp_index;
 		ring->io_base = (u8 __iomem *)q->io_base + HNS3_TX_REG_OFFSET;
 	} else {
+		ring = &priv->ring[q->tqp_index + queue_num];
 		desc_num = priv->ae_handle->kinfo.num_rx_desc;
-		ring_data[q->tqp_index + queue_num].ring = ring;
-		ring_data[q->tqp_index + queue_num].queue_index = q->tqp_index;
+		ring->queue_index = q->tqp_index;
 		ring->io_base = q->io_base;
 	}
 
@@ -3670,76 +3662,41 @@ static int hns3_ring_get_cfg(struct hnae3_queue *q, struct hns3_nic_priv *priv,
 	ring->desc_num = desc_num;
 	ring->next_to_use = 0;
 	ring->next_to_clean = 0;
-
-	return 0;
 }
 
-static int hns3_queue_to_ring(struct hnae3_queue *tqp,
-			      struct hns3_nic_priv *priv)
+static void hns3_queue_to_ring(struct hnae3_queue *tqp,
+			       struct hns3_nic_priv *priv)
 {
-	int ret;
-
-	ret = hns3_ring_get_cfg(tqp, priv, HNAE3_RING_TYPE_TX);
-	if (ret)
-		return ret;
-
-	ret = hns3_ring_get_cfg(tqp, priv, HNAE3_RING_TYPE_RX);
-	if (ret) {
-		devm_kfree(priv->dev, priv->ring_data[tqp->tqp_index].ring);
-		return ret;
-	}
-
-	return 0;
+	hns3_ring_get_cfg(tqp, priv, HNAE3_RING_TYPE_TX);
+	hns3_ring_get_cfg(tqp, priv, HNAE3_RING_TYPE_RX);
 }
 
 static int hns3_get_ring_config(struct hns3_nic_priv *priv)
 {
 	struct hnae3_handle *h = priv->ae_handle;
 	struct pci_dev *pdev = h->pdev;
-	int i, ret;
+	int i;
 
-	priv->ring_data =  devm_kzalloc(&pdev->dev,
-					array3_size(h->kinfo.num_tqps,
-						    sizeof(*priv->ring_data),
-						    2),
-					GFP_KERNEL);
-	if (!priv->ring_data)
+	priv->ring = devm_kzalloc(&pdev->dev,
+				  array3_size(h->kinfo.num_tqps,
+					      sizeof(*priv->ring), 2),
+				  GFP_KERNEL);
+	if (!priv->ring)
 		return -ENOMEM;
 
-	for (i = 0; i < h->kinfo.num_tqps; i++) {
-		ret = hns3_queue_to_ring(h->kinfo.tqp[i], priv);
-		if (ret)
-			goto err;
-	}
+	for (i = 0; i < h->kinfo.num_tqps; i++)
+		hns3_queue_to_ring(h->kinfo.tqp[i], priv);
 
 	return 0;
-err:
-	while (i--) {
-		devm_kfree(priv->dev, priv->ring_data[i].ring);
-		devm_kfree(priv->dev,
-			   priv->ring_data[i + h->kinfo.num_tqps].ring);
-	}
-
-	devm_kfree(&pdev->dev, priv->ring_data);
-	priv->ring_data = NULL;
-	return ret;
 }
 
 static void hns3_put_ring_config(struct hns3_nic_priv *priv)
 {
-	struct hnae3_handle *h = priv->ae_handle;
-	int i;
-
-	if (!priv->ring_data)
+	if (!priv->ring)
 		return;
 
-	for (i = 0; i < h->kinfo.num_tqps; i++) {
-		devm_kfree(priv->dev, priv->ring_data[i].ring);
-		devm_kfree(priv->dev,
-			   priv->ring_data[i + h->kinfo.num_tqps].ring);
-	}
-	devm_kfree(priv->dev, priv->ring_data);
-	priv->ring_data = NULL;
+	devm_kfree(priv->dev, priv->ring);
+	priv->ring = NULL;
 }
 
 static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
@@ -3856,7 +3813,7 @@ static void hns3_init_tx_ring_tc(struct hns3_nic_priv *priv)
 		for (j = 0; j < tc_info->tqp_count; j++) {
 			struct hnae3_queue *q;
 
-			q = priv->ring_data[tc_info->tqp_offset + j].ring->tqp;
+			q = priv->ring[tc_info->tqp_offset + j].tqp;
 			hns3_write_dev(q, HNS3_RING_TX_RING_TC_REG,
 				       tc_info->tc);
 		}
@@ -3871,21 +3828,21 @@ int hns3_init_all_ring(struct hns3_nic_priv *priv)
 	int ret;
 
 	for (i = 0; i < ring_num; i++) {
-		ret = hns3_alloc_ring_memory(priv->ring_data[i].ring);
+		ret = hns3_alloc_ring_memory(&priv->ring[i]);
 		if (ret) {
 			dev_err(priv->dev,
 				"Alloc ring memory fail! ret=%d\n", ret);
 			goto out_when_alloc_ring_memory;
 		}
 
-		u64_stats_init(&priv->ring_data[i].ring->syncp);
+		u64_stats_init(&priv->ring[i].syncp);
 	}
 
 	return 0;
 
 out_when_alloc_ring_memory:
 	for (j = i - 1; j >= 0; j--)
-		hns3_fini_ring(priv->ring_data[j].ring);
+		hns3_fini_ring(&priv->ring[j]);
 
 	return -ENOMEM;
 }
@@ -3896,8 +3853,8 @@ int hns3_uninit_all_ring(struct hns3_nic_priv *priv)
 	int i;
 
 	for (i = 0; i < h->kinfo.num_tqps; i++) {
-		hns3_fini_ring(priv->ring_data[i].ring);
-		hns3_fini_ring(priv->ring_data[i + h->kinfo.num_tqps].ring);
+		hns3_fini_ring(&priv->ring[i]);
+		hns3_fini_ring(&priv->ring[i + h->kinfo.num_tqps]);
 	}
 	return 0;
 }
@@ -4058,7 +4015,7 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	ret = hns3_init_all_ring(priv);
 	if (ret) {
 		ret = -ENOMEM;
-		goto out_init_ring_data;
+		goto out_init_ring;
 	}
 
 	ret = hns3_init_phy(netdev);
@@ -4097,12 +4054,12 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	hns3_uninit_phy(netdev);
 out_init_phy:
 	hns3_uninit_all_ring(priv);
-out_init_ring_data:
+out_init_ring:
 	hns3_nic_uninit_vector_data(priv);
 out_init_vector_data:
 	hns3_nic_dealloc_vector_data(priv);
 out_alloc_vector_data:
-	priv->ring_data = NULL;
+	priv->ring = NULL;
 out_get_ring_cfg:
 	priv->ae_handle = NULL;
 	free_netdev(netdev);
@@ -4309,10 +4266,10 @@ static void hns3_clear_all_ring(struct hnae3_handle *h, bool force)
 	for (i = 0; i < h->kinfo.num_tqps; i++) {
 		struct hns3_enet_ring *ring;
 
-		ring = priv->ring_data[i].ring;
+		ring = &priv->ring[i];
 		hns3_clear_tx_ring(ring);
 
-		ring = priv->ring_data[i + h->kinfo.num_tqps].ring;
+		ring = &priv->ring[i + h->kinfo.num_tqps];
 		/* Continue to clear other rings even if clearing some
 		 * rings failed.
 		 */
@@ -4336,16 +4293,16 @@ int hns3_nic_reset_all_ring(struct hnae3_handle *h)
 		if (ret)
 			return ret;
 
-		hns3_init_ring_hw(priv->ring_data[i].ring);
+		hns3_init_ring_hw(&priv->ring[i]);
 
 		/* We need to clear tx ring here because self test will
 		 * use the ring and will not run down before up
 		 */
-		hns3_clear_tx_ring(priv->ring_data[i].ring);
-		priv->ring_data[i].ring->next_to_clean = 0;
-		priv->ring_data[i].ring->next_to_use = 0;
+		hns3_clear_tx_ring(&priv->ring[i]);
+		priv->ring[i].next_to_clean = 0;
+		priv->ring[i].next_to_use = 0;
 
-		rx_ring = priv->ring_data[i + h->kinfo.num_tqps].ring;
+		rx_ring = &priv->ring[i + h->kinfo.num_tqps];
 		hns3_init_ring_hw(rx_ring);
 		ret = hns3_clear_rx_ring(rx_ring);
 		if (ret)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index c5b7c22..3322284 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -409,6 +409,7 @@ struct hns3_enet_ring {
 	struct hns3_enet_ring *next;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	struct hnae3_queue *tqp;
+	int queue_index;
 	struct device *dev; /* will be used for DMA mapping of descriptors */
 
 	/* statistic */
@@ -436,17 +437,6 @@ struct hns3_enet_ring {
 	struct sk_buff *tail_skb;
 };
 
-struct hns_queue;
-
-struct hns3_nic_ring_data {
-	struct hns3_enet_ring *ring;
-	struct napi_struct napi;
-	int queue_index;
-	int (*poll_one)(struct hns3_nic_ring_data *, int, void *);
-	void (*ex_process)(struct hns3_nic_ring_data *, struct sk_buff *);
-	void (*fini_process)(struct hns3_nic_ring_data *);
-};
-
 enum hns3_flow_level_range {
 	HNS3_FLOW_LOW = 0,
 	HNS3_FLOW_MID = 1,
@@ -522,7 +512,7 @@ struct hns3_nic_priv {
 	 * the cb for nic to manage the ring buffer, the first half of the
 	 * array is for tx_ring and vice versa for the second half
 	 */
-	struct hns3_nic_ring_data *ring_data;
+	struct hns3_enet_ring *ring;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	u16 vector_num;
 
@@ -620,8 +610,6 @@ static inline bool hns3_nic_resetting(struct net_device *netdev)
 #define ring_to_dma_dir(ring) (HNAE3_IS_TX_RING(ring) ? \
 	DMA_TO_DEVICE : DMA_FROM_DEVICE)
 
-#define tx_ring_data(priv, idx) ((priv)->ring_data[idx])
-
 #define hns3_buf_size(_ring) ((_ring)->buf_size)
 
 static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 680c350..50b07b9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -203,7 +203,7 @@ static u32 hns3_lb_check_rx_ring(struct hns3_nic_priv *priv, u32 budget)
 
 	kinfo = &h->kinfo;
 	for (i = kinfo->num_tqps; i < kinfo->num_tqps * 2; i++) {
-		struct hns3_enet_ring *ring = priv->ring_data[i].ring;
+		struct hns3_enet_ring *ring = &priv->ring[i];
 		struct hns3_enet_ring_group *rx_group;
 		u64 pre_rx_pkt;
 
@@ -226,7 +226,7 @@ static void hns3_lb_clear_tx_ring(struct hns3_nic_priv *priv, u32 start_ringid,
 	u32 i;
 
 	for (i = start_ringid; i <= end_ringid; i++) {
-		struct hns3_enet_ring *ring = priv->ring_data[i].ring;
+		struct hns3_enet_ring *ring = &priv->ring[i];
 
 		hns3_clean_tx_ring(ring);
 	}
@@ -491,7 +491,7 @@ static u64 *hns3_get_stats_tqps(struct hnae3_handle *handle, u64 *data)
 
 	/* get stats for Tx */
 	for (i = 0; i < kinfo->num_tqps; i++) {
-		ring = nic_priv->ring_data[i].ring;
+		ring = &nic_priv->ring[i];
 		for (j = 0; j < HNS3_TXQ_STATS_COUNT; j++) {
 			stat = (u8 *)ring + hns3_txq_stats[j].stats_offset;
 			*data++ = *(u64 *)stat;
@@ -500,7 +500,7 @@ static u64 *hns3_get_stats_tqps(struct hnae3_handle *handle, u64 *data)
 
 	/* get stats for Rx */
 	for (i = 0; i < kinfo->num_tqps; i++) {
-		ring = nic_priv->ring_data[i + kinfo->num_tqps].ring;
+		ring = &nic_priv->ring[i + kinfo->num_tqps];
 		for (j = 0; j < HNS3_RXQ_STATS_COUNT; j++) {
 			stat = (u8 *)ring + hns3_rxq_stats[j].stats_offset;
 			*data++ = *(u64 *)stat;
@@ -603,8 +603,8 @@ static void hns3_get_ringparam(struct net_device *netdev,
 	param->tx_max_pending = HNS3_RING_MAX_PENDING;
 	param->rx_max_pending = HNS3_RING_MAX_PENDING;
 
-	param->tx_pending = priv->ring_data[0].ring->desc_num;
-	param->rx_pending = priv->ring_data[queue_num].ring->desc_num;
+	param->tx_pending = priv->ring[0].desc_num;
+	param->rx_pending = priv->ring[queue_num].desc_num;
 }
 
 static void hns3_get_pauseparam(struct net_device *netdev,
@@ -906,9 +906,8 @@ static void hns3_change_all_ring_bd_num(struct hns3_nic_priv *priv,
 	h->kinfo.num_rx_desc = rx_desc_num;
 
 	for (i = 0; i < h->kinfo.num_tqps; i++) {
-		priv->ring_data[i].ring->desc_num = tx_desc_num;
-		priv->ring_data[i + h->kinfo.num_tqps].ring->desc_num =
-			rx_desc_num;
+		priv->ring[i].desc_num = tx_desc_num;
+		priv->ring[i + h->kinfo.num_tqps].desc_num = rx_desc_num;
 	}
 }
 
@@ -924,7 +923,7 @@ static struct hns3_enet_ring *hns3_backup_ringparam(struct hns3_nic_priv *priv)
 		return NULL;
 
 	for (i = 0; i < handle->kinfo.num_tqps * 2; i++) {
-		memcpy(&tmp_rings[i], priv->ring_data[i].ring,
+		memcpy(&tmp_rings[i], &priv->ring[i],
 		       sizeof(struct hns3_enet_ring));
 		tmp_rings[i].skb = NULL;
 	}
@@ -972,8 +971,8 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	/* Hardware requires that its descriptors must be multiple of eight */
 	new_tx_desc_num = ALIGN(param->tx_pending, HNS3_RING_BD_MULTIPLE);
 	new_rx_desc_num = ALIGN(param->rx_pending, HNS3_RING_BD_MULTIPLE);
-	old_tx_desc_num = priv->ring_data[0].ring->desc_num;
-	old_rx_desc_num = priv->ring_data[queue_num].ring->desc_num;
+	old_tx_desc_num = priv->ring[0].desc_num;
+	old_rx_desc_num = priv->ring[queue_num].desc_num;
 	if (old_tx_desc_num == new_tx_desc_num &&
 	    old_rx_desc_num == new_rx_desc_num)
 		return 0;
@@ -1002,7 +1001,7 @@ static int hns3_set_ringparam(struct net_device *ndev,
 		hns3_change_all_ring_bd_num(priv, old_tx_desc_num,
 					    old_rx_desc_num);
 		for (i = 0; i < h->kinfo.num_tqps * 2; i++)
-			memcpy(priv->ring_data[i].ring, &tmp_rings[i],
+			memcpy(&priv->ring[i], &tmp_rings[i],
 			       sizeof(struct hns3_enet_ring));
 	} else {
 		for (i = 0; i < h->kinfo.num_tqps * 2; i++)
@@ -1103,8 +1102,8 @@ static int hns3_get_coalesce_per_queue(struct net_device *netdev, u32 queue,
 		return -EINVAL;
 	}
 
-	tx_vector = priv->ring_data[queue].ring->tqp_vector;
-	rx_vector = priv->ring_data[queue_num + queue].ring->tqp_vector;
+	tx_vector = priv->ring[queue].tqp_vector;
+	rx_vector = priv->ring[queue_num + queue].tqp_vector;
 
 	cmd->use_adaptive_tx_coalesce =
 			tx_vector->tx_group.coal.gl_adapt_enable;
@@ -1229,8 +1228,8 @@ static void hns3_set_coalesce_per_queue(struct net_device *netdev,
 	struct hnae3_handle *h = priv->ae_handle;
 	int queue_num = h->kinfo.num_tqps;
 
-	tx_vector = priv->ring_data[queue].ring->tqp_vector;
-	rx_vector = priv->ring_data[queue_num + queue].ring->tqp_vector;
+	tx_vector = priv->ring[queue].tqp_vector;
+	rx_vector = priv->ring[queue_num + queue].tqp_vector;
 
 	tx_vector->tx_group.coal.gl_adapt_enable =
 				cmd->use_adaptive_tx_coalesce;
-- 
2.7.4

