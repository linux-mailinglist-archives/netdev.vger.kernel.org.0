Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1919B3877CD
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 13:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244189AbhERLhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 07:37:45 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3010 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240895AbhERLho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 07:37:44 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fkv4l6l9pzQpwW;
        Tue, 18 May 2021 19:32:55 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 19:36:15 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 19:36:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 3/4] net: hns3: fix user's coalesce configuration lost issue
Date:   Tue, 18 May 2021 19:36:02 +0800
Message-ID: <1621337763-61946-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621337763-61946-1-git-send-email-tanhuazhong@huawei.com>
References: <1621337763-61946-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when adaptive is on, the user's coalesce configuration
may be overwritten by the dynamic one. The reason is that user's
configurations are saved in struct hns3_enet_tqp_vector whose
value maybe changed by the dynamic algorithm. To fix it, use
struct hns3_nic_priv instead of struct hns3_enet_tqp_vector to
save and get the user's configuration.

BTW, operations of storing and restoring coalesce info in the reset
process are unnecessary now, so remove them as well.

Fixes: 434776a5fae2 ("net: hns3: add ethtool_ops.set_coalesce support to PF")
Fixes: 7e96adc46633 ("net: hns3: add ethtool_ops.get_coalesce support to PF")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 84 +++++++++++-----------
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 64 ++++++-----------
 2 files changed, 63 insertions(+), 85 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index c64d188..6d6c0ac 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -264,22 +264,17 @@ static void hns3_vector_coalesce_init(struct hns3_enet_tqp_vector *tqp_vector,
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(priv->ae_handle->pdev);
 	struct hns3_enet_coalesce *tx_coal = &tqp_vector->tx_group.coal;
 	struct hns3_enet_coalesce *rx_coal = &tqp_vector->rx_group.coal;
+	struct hns3_enet_coalesce *ptx_coal = &priv->tx_coal;
+	struct hns3_enet_coalesce *prx_coal = &priv->rx_coal;
 
-	/* initialize the configuration for interrupt coalescing.
-	 * 1. GL (Interrupt Gap Limiter)
-	 * 2. RL (Interrupt Rate Limiter)
-	 * 3. QL (Interrupt Quantity Limiter)
-	 *
-	 * Default: enable interrupt coalescing self-adaptive and GL
-	 */
-	tx_coal->adapt_enable = 1;
-	rx_coal->adapt_enable = 1;
+	tx_coal->adapt_enable = ptx_coal->adapt_enable;
+	rx_coal->adapt_enable = prx_coal->adapt_enable;
 
-	tx_coal->int_gl = HNS3_INT_GL_50K;
-	rx_coal->int_gl = HNS3_INT_GL_50K;
+	tx_coal->int_gl = ptx_coal->int_gl;
+	rx_coal->int_gl = prx_coal->int_gl;
 
-	rx_coal->flow_level = HNS3_FLOW_LOW;
-	tx_coal->flow_level = HNS3_FLOW_LOW;
+	rx_coal->flow_level = prx_coal->flow_level;
+	tx_coal->flow_level = ptx_coal->flow_level;
 
 	/* device version above V3(include V3), GL can configure 1us
 	 * unit, so uses 1us unit.
@@ -294,8 +289,8 @@ static void hns3_vector_coalesce_init(struct hns3_enet_tqp_vector *tqp_vector,
 		rx_coal->ql_enable = 1;
 		tx_coal->int_ql_max = ae_dev->dev_specs.int_ql_max;
 		rx_coal->int_ql_max = ae_dev->dev_specs.int_ql_max;
-		tx_coal->int_ql = HNS3_INT_QL_DEFAULT_CFG;
-		rx_coal->int_ql = HNS3_INT_QL_DEFAULT_CFG;
+		tx_coal->int_ql = ptx_coal->int_ql;
+		rx_coal->int_ql = prx_coal->int_ql;
 	}
 }
 
@@ -3844,6 +3839,34 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 	return ret;
 }
 
+static void hns3_nic_init_coal_cfg(struct hns3_nic_priv *priv)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(priv->ae_handle->pdev);
+	struct hns3_enet_coalesce *tx_coal = &priv->tx_coal;
+	struct hns3_enet_coalesce *rx_coal = &priv->rx_coal;
+
+	/* initialize the configuration for interrupt coalescing.
+	 * 1. GL (Interrupt Gap Limiter)
+	 * 2. RL (Interrupt Rate Limiter)
+	 * 3. QL (Interrupt Quantity Limiter)
+	 *
+	 * Default: enable interrupt coalescing self-adaptive and GL
+	 */
+	tx_coal->adapt_enable = 1;
+	rx_coal->adapt_enable = 1;
+
+	tx_coal->int_gl = HNS3_INT_GL_50K;
+	rx_coal->int_gl = HNS3_INT_GL_50K;
+
+	rx_coal->flow_level = HNS3_FLOW_LOW;
+	tx_coal->flow_level = HNS3_FLOW_LOW;
+
+	if (ae_dev->dev_specs.int_ql_max) {
+		tx_coal->int_ql = HNS3_INT_QL_DEFAULT_CFG;
+		rx_coal->int_ql = HNS3_INT_QL_DEFAULT_CFG;
+	}
+}
+
 static int hns3_nic_alloc_vector_data(struct hns3_nic_priv *priv)
 {
 	struct hnae3_handle *h = priv->ae_handle;
@@ -4295,6 +4318,8 @@ static int hns3_client_init(struct hnae3_handle *handle)
 		goto out_get_ring_cfg;
 	}
 
+	hns3_nic_init_coal_cfg(priv);
+
 	ret = hns3_nic_alloc_vector_data(priv);
 	if (ret) {
 		ret = -ENOMEM;
@@ -4571,31 +4596,6 @@ int hns3_nic_reset_all_ring(struct hnae3_handle *h)
 	return 0;
 }
 
-static void hns3_store_coal(struct hns3_nic_priv *priv)
-{
-	/* ethtool only support setting and querying one coal
-	 * configuration for now, so save the vector 0' coal
-	 * configuration here in order to restore it.
-	 */
-	memcpy(&priv->tx_coal, &priv->tqp_vector[0].tx_group.coal,
-	       sizeof(struct hns3_enet_coalesce));
-	memcpy(&priv->rx_coal, &priv->tqp_vector[0].rx_group.coal,
-	       sizeof(struct hns3_enet_coalesce));
-}
-
-static void hns3_restore_coal(struct hns3_nic_priv *priv)
-{
-	u16 vector_num = priv->vector_num;
-	int i;
-
-	for (i = 0; i < vector_num; i++) {
-		memcpy(&priv->tqp_vector[i].tx_group.coal, &priv->tx_coal,
-		       sizeof(struct hns3_enet_coalesce));
-		memcpy(&priv->tqp_vector[i].rx_group.coal, &priv->rx_coal,
-		       sizeof(struct hns3_enet_coalesce));
-	}
-}
-
 static int hns3_reset_notify_down_enet(struct hnae3_handle *handle)
 {
 	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
@@ -4654,8 +4654,6 @@ static int hns3_reset_notify_init_enet(struct hnae3_handle *handle)
 	if (ret)
 		goto err_put_ring;
 
-	hns3_restore_coal(priv);
-
 	ret = hns3_nic_init_vector_data(priv);
 	if (ret)
 		goto err_dealloc_vector;
@@ -4721,8 +4719,6 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 
 	hns3_nic_uninit_vector_data(priv);
 
-	hns3_store_coal(priv);
-
 	hns3_nic_dealloc_vector_data(priv);
 
 	hns3_uninit_all_ring(priv);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index b48faf7..c1ea403 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1134,50 +1134,32 @@ static void hns3_get_channels(struct net_device *netdev,
 		h->ae_algo->ops->get_channels(h, ch);
 }
 
-static int hns3_get_coalesce_per_queue(struct net_device *netdev, u32 queue,
-				       struct ethtool_coalesce *cmd)
+static int hns3_get_coalesce(struct net_device *netdev,
+			     struct ethtool_coalesce *cmd)
 {
-	struct hns3_enet_tqp_vector *tx_vector, *rx_vector;
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hns3_enet_coalesce *tx_coal = &priv->tx_coal;
+	struct hns3_enet_coalesce *rx_coal = &priv->rx_coal;
 	struct hnae3_handle *h = priv->ae_handle;
-	u16 queue_num = h->kinfo.num_tqps;
 
 	if (hns3_nic_resetting(netdev))
 		return -EBUSY;
 
-	if (queue >= queue_num) {
-		netdev_err(netdev,
-			   "Invalid queue value %u! Queue max id=%u\n",
-			   queue, queue_num - 1);
-		return -EINVAL;
-	}
-
-	tx_vector = priv->ring[queue].tqp_vector;
-	rx_vector = priv->ring[queue_num + queue].tqp_vector;
+	cmd->use_adaptive_tx_coalesce = tx_coal->adapt_enable;
+	cmd->use_adaptive_rx_coalesce = rx_coal->adapt_enable;
 
-	cmd->use_adaptive_tx_coalesce =
-			tx_vector->tx_group.coal.adapt_enable;
-	cmd->use_adaptive_rx_coalesce =
-			rx_vector->rx_group.coal.adapt_enable;
-
-	cmd->tx_coalesce_usecs = tx_vector->tx_group.coal.int_gl;
-	cmd->rx_coalesce_usecs = rx_vector->rx_group.coal.int_gl;
+	cmd->tx_coalesce_usecs = tx_coal->int_gl;
+	cmd->rx_coalesce_usecs = rx_coal->int_gl;
 
 	cmd->tx_coalesce_usecs_high = h->kinfo.int_rl_setting;
 	cmd->rx_coalesce_usecs_high = h->kinfo.int_rl_setting;
 
-	cmd->tx_max_coalesced_frames = tx_vector->tx_group.coal.int_ql;
-	cmd->rx_max_coalesced_frames = rx_vector->rx_group.coal.int_ql;
+	cmd->tx_max_coalesced_frames = tx_coal->int_ql;
+	cmd->rx_max_coalesced_frames = rx_coal->int_ql;
 
 	return 0;
 }
 
-static int hns3_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *cmd)
-{
-	return hns3_get_coalesce_per_queue(netdev, 0, cmd);
-}
-
 static int hns3_check_gl_coalesce_para(struct net_device *netdev,
 				       struct ethtool_coalesce *cmd)
 {
@@ -1292,19 +1274,7 @@ static int hns3_check_coalesce_para(struct net_device *netdev,
 		return ret;
 	}
 
-	ret = hns3_check_ql_coalesce_param(netdev, cmd);
-	if (ret)
-		return ret;
-
-	if (cmd->use_adaptive_tx_coalesce == 1 ||
-	    cmd->use_adaptive_rx_coalesce == 1) {
-		netdev_info(netdev,
-			    "adaptive-tx=%u and adaptive-rx=%u, tx_usecs or rx_usecs will changed dynamically.\n",
-			    cmd->use_adaptive_tx_coalesce,
-			    cmd->use_adaptive_rx_coalesce);
-	}
-
-	return 0;
+	return hns3_check_ql_coalesce_param(netdev, cmd);
 }
 
 static void hns3_set_coalesce_per_queue(struct net_device *netdev,
@@ -1350,6 +1320,9 @@ static int hns3_set_coalesce(struct net_device *netdev,
 			     struct ethtool_coalesce *cmd)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hns3_enet_coalesce *tx_coal = &priv->tx_coal;
+	struct hns3_enet_coalesce *rx_coal = &priv->rx_coal;
 	u16 queue_num = h->kinfo.num_tqps;
 	int ret;
 	int i;
@@ -1364,6 +1337,15 @@ static int hns3_set_coalesce(struct net_device *netdev,
 	h->kinfo.int_rl_setting =
 		hns3_rl_round_down(cmd->rx_coalesce_usecs_high);
 
+	tx_coal->adapt_enable = cmd->use_adaptive_tx_coalesce;
+	rx_coal->adapt_enable = cmd->use_adaptive_rx_coalesce;
+
+	tx_coal->int_gl = cmd->tx_coalesce_usecs;
+	rx_coal->int_gl = cmd->rx_coalesce_usecs;
+
+	tx_coal->int_ql = cmd->tx_max_coalesced_frames;
+	rx_coal->int_ql = cmd->rx_max_coalesced_frames;
+
 	for (i = 0; i < queue_num; i++)
 		hns3_set_coalesce_per_queue(netdev, cmd, i);
 
-- 
2.7.4

