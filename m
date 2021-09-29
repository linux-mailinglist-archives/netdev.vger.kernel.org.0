Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F090F41C951
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346438AbhI2QEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:14 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24133 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245167AbhI2QAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:04 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbR2Kcyz1DHMf;
        Wed, 29 Sep 2021 23:56:51 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:10 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:10 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 098/167] net: google: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:25 +0800
Message-ID: <20210929155334.12454-99-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/google/gve/gve_adminq.c |  6 ++--
 drivers/net/ethernet/google/gve/gve_main.c   | 31 ++++++++++++--------
 drivers/net/ethernet/google/gve/gve_rx.c     |  6 ++--
 drivers/net/ethernet/google/gve/gve_rx_dqo.c |  8 +++--
 4 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index f089d33dd48e..e63476be8b76 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -542,7 +542,8 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 		cmd.create_rx_queue.rx_buff_ring_size =
 			cpu_to_be16(priv->options_dqo_rda.rx_buff_ring_entries);
 		cmd.create_rx_queue.enable_rsc =
-			!!(priv->dev->features & NETIF_F_LRO);
+			netdev_feature_test_bit(NETIF_F_LRO_BIT,
+						priv->dev->features);
 	}
 
 	return gve_adminq_issue_cmd(priv, &cmd);
@@ -717,7 +718,8 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 		err = gve_set_desc_cnt(priv, descriptor);
 	} else {
 		/* DQO supports LRO. */
-		priv->dev->hw_features |= NETIF_F_LRO;
+		netdev_feature_set_bit(NETIF_F_LRO_BIT,
+				       &priv->dev->hw_features);
 		err = gve_set_desc_cnt_dqo(priv, descriptor, dev_op_dqo_rda);
 	}
 	if (err)
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index cd9df68cc01e..2a5620bc35e5 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1112,12 +1112,16 @@ static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
 static int gve_set_features(struct net_device *netdev,
 			    netdev_features_t features)
 {
-	const netdev_features_t orig_features = netdev->features;
 	struct gve_priv *priv = netdev_priv(netdev);
+	netdev_features_t orig_features;
 	int err;
 
-	if ((netdev->features & NETIF_F_LRO) != (features & NETIF_F_LRO)) {
-		netdev->features ^= NETIF_F_LRO;
+	netdev_feature_copy(&orig_features, netdev->features);
+
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features) !=
+	    netdev_feature_test_bit(NETIF_F_LRO_BIT, features)) {
+		netdev_feature_change_bit(NETIF_F_LRO_BIT, &netdev->features);
+
 		if (netif_carrier_ok(netdev)) {
 			/* To make this process as simple as possible we
 			 * teardown the device, set the new configuration,
@@ -1139,7 +1143,7 @@ static int gve_set_features(struct net_device *netdev,
 	return 0;
 err:
 	/* Reverts the change on error. */
-	netdev->features = orig_features;
+	netdev_feature_copy(&netdev->features, orig_features);
 	netif_err(priv, drv, netdev,
 		  "Set features failed! !!! DISABLING ALL QUEUES !!!\n");
 	return err;
@@ -1517,15 +1521,16 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * Features might be set in other locations as well (such as
 	 * `gve_adminq_describe_device`).
 	 */
-	dev->hw_features = NETIF_F_HIGHDMA;
-	dev->hw_features |= NETIF_F_SG;
-	dev->hw_features |= NETIF_F_HW_CSUM;
-	dev->hw_features |= NETIF_F_TSO;
-	dev->hw_features |= NETIF_F_TSO6;
-	dev->hw_features |= NETIF_F_TSO_ECN;
-	dev->hw_features |= NETIF_F_RXCSUM;
-	dev->hw_features |= NETIF_F_RXHASH;
-	dev->features = dev->hw_features;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO6_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &dev->hw_features);
+	netdev_feature_copy(&dev->features, dev->hw_features);
 	dev->watchdog_timeo = 5 * HZ;
 	dev->min_mtu = ETH_MIN_MTU;
 	netif_carrier_off(dev);
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index bb8261368250..d76e89afb329 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -428,7 +428,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 		return false;
 	}
 
-	if (likely(feat & NETIF_F_RXCSUM)) {
+	if (likely(netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, feat))) {
 		/* NIC passes up the partial sum */
 		if (rx_desc->csum)
 			skb->ip_summed = CHECKSUM_COMPLETE;
@@ -438,7 +438,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	}
 
 	/* parse flags & pass relevant info up */
-	if (likely(feat & NETIF_F_RXHASH) &&
+	if (likely(netdev_feature_test_bit(NETIF_F_RXHASH_BIT, feat)) &&
 	    gve_needs_rss(rx_desc->flags_seq))
 		skb_set_hash(skb, be32_to_cpu(rx_desc->rss_hash),
 			     gve_rss_type(rx_desc->flags_seq));
@@ -591,7 +591,7 @@ bool gve_rx_poll(struct gve_notify_block *block, int budget)
 	netdev_features_t feat;
 	bool repoll = false;
 
-	feat = block->napi.dev->features;
+	netdev_feature_copy(&feat, block->napi.dev->features);
 
 	/* If budget is 0, do all the work */
 	if (budget == 0)
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 8500621b2cd4..8e55d11daceb 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -637,10 +637,10 @@ static int gve_rx_complete_skb(struct gve_rx_ring *rx, struct napi_struct *napi,
 
 	skb_record_rx_queue(rx->skb_head, rx->q_num);
 
-	if (feat & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, feat))
 		gve_rx_skb_hash(rx->skb_head, desc, ptype);
 
-	if (feat & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, feat))
 		gve_rx_skb_csum(rx->skb_head, desc, ptype);
 
 	/* RSC packets must set gso_size otherwise the TCP stack will complain
@@ -663,7 +663,7 @@ static int gve_rx_complete_skb(struct gve_rx_ring *rx, struct napi_struct *napi,
 int gve_rx_poll_dqo(struct gve_notify_block *block, int budget)
 {
 	struct napi_struct *napi = &block->napi;
-	netdev_features_t feat = napi->dev->features;
+	netdev_features_t feat;
 
 	struct gve_rx_ring *rx = block->rx;
 	struct gve_rx_compl_queue_dqo *complq = &rx->dqo.complq;
@@ -672,6 +672,8 @@ int gve_rx_poll_dqo(struct gve_notify_block *block, int budget)
 	u64 bytes = 0;
 	int err;
 
+	netdev_feature_copy(&feat, napi->dev->features);
+
 	while (work_done < budget) {
 		struct gve_rx_compl_desc_dqo *compl_desc =
 			&complq->desc_ring[complq->head];
-- 
2.33.0

