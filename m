Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E442B8A81
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgKSDyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:54:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8113 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgKSDx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:53:59 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cc5Ps2GxXzLqgc;
        Thu, 19 Nov 2020 11:53:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Thu, 19 Nov 2020 11:53:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 2/2] net: hns3: add support for dynamic interrupt moderation
Date:   Thu, 19 Nov 2020 11:54:10 +0800
Message-ID: <1605758050-21061-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
References: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dynamic interrupt moderation support for the HNS3 driver,
and add ethtool support for controlling the type of adaptive.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/Kconfig             |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 87 +++++++++++++++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  7 +-
 4 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/hisilicon/Kconfig
index 44f9279..fa6025d 100644
--- a/drivers/net/ethernet/hisilicon/Kconfig
+++ b/drivers/net/ethernet/hisilicon/Kconfig
@@ -130,6 +130,7 @@ config HNS3_ENET
 	default m
 	depends on 64BIT && PCI
 	depends on INET
+	select DIMLIB
 	help
 	  This selects the Ethernet Driver for Hisilicon Network Subsystem 3 for hip08
 	  family of SoCs. This module depends upon HNAE3 driver to access the HNAE3
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 999a2aa..b08aea7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -96,6 +96,7 @@ static irqreturn_t hns3_irq_handle(int irq, void *vector)
 	struct hns3_enet_tqp_vector *tqp_vector = vector;
 
 	napi_schedule_irqoff(&tqp_vector->napi);
+	tqp_vector->event_cnt++;
 
 	return IRQ_HANDLED;
 }
@@ -199,6 +200,8 @@ static void hns3_vector_disable(struct hns3_enet_tqp_vector *tqp_vector)
 
 	disable_irq(tqp_vector->vector_irq);
 	napi_disable(&tqp_vector->napi);
+	cancel_work_sync(&tqp_vector->rx_group.dim.work);
+	cancel_work_sync(&tqp_vector->tx_group.dim.work);
 }
 
 void hns3_set_vector_coalesce_rl(struct hns3_enet_tqp_vector *tqp_vector,
@@ -3401,6 +3404,32 @@ static void hns3_update_new_int_gl(struct hns3_enet_tqp_vector *tqp_vector)
 	tqp_vector->last_jiffies = jiffies;
 }
 
+static void hns3_update_rx_int_coalesce(struct hns3_enet_tqp_vector *tqp_vector)
+{
+	struct hns3_enet_ring_group *rx_group = &tqp_vector->rx_group;
+	struct dim_sample sample = {};
+
+	if (!rx_group->coal.adapt_enable)
+		return;
+
+	dim_update_sample(tqp_vector->event_cnt, rx_group->total_packets,
+			  rx_group->total_bytes, &sample);
+	net_dim(&rx_group->dim, sample);
+}
+
+static void hns3_update_tx_int_coalesce(struct hns3_enet_tqp_vector *tqp_vector)
+{
+	struct hns3_enet_ring_group *tx_group = &tqp_vector->tx_group;
+	struct dim_sample sample = {};
+
+	if (!tx_group->coal.adapt_enable)
+		return;
+
+	dim_update_sample(tqp_vector->event_cnt, tx_group->total_packets,
+			  tx_group->total_bytes, &sample);
+	net_dim(&tx_group->dim, sample);
+}
+
 static int hns3_nic_common_poll(struct napi_struct *napi, int budget)
 {
 	struct hns3_nic_priv *priv = netdev_priv(napi->dev);
@@ -3444,7 +3473,13 @@ static int hns3_nic_common_poll(struct napi_struct *napi, int budget)
 
 	if (napi_complete(napi) &&
 	    likely(!test_bit(HNS3_NIC_STATE_DOWN, &priv->state))) {
-		hns3_update_new_int_gl(tqp_vector);
+		if (priv->dim_enable) {
+			hns3_update_rx_int_coalesce(tqp_vector);
+			hns3_update_tx_int_coalesce(tqp_vector);
+		} else {
+			hns3_update_new_int_gl(tqp_vector);
+		}
+
 		hns3_mask_vector_irq(tqp_vector, 1);
 	}
 
@@ -3575,6 +3610,54 @@ static void hns3_nic_set_cpumask(struct hns3_nic_priv *priv)
 	}
 }
 
+static void hns3_rx_dim_work(struct work_struct *work)
+{
+	struct dim *dim = container_of(work, struct dim, work);
+	struct hns3_enet_ring_group *group = container_of(dim,
+		struct hns3_enet_ring_group, dim);
+	struct hns3_enet_tqp_vector *tqp_vector = group->ring->tqp_vector;
+	struct dim_cq_moder cur_moder =
+		net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
+
+	hns3_set_vector_coalesce_rx_gl(group->ring->tqp_vector, cur_moder.usec);
+	tqp_vector->rx_group.coal.int_gl = cur_moder.usec;
+
+	if (cur_moder.pkts < tqp_vector->rx_group.coal.int_ql_max) {
+		hns3_set_vector_coalesce_rx_ql(tqp_vector, cur_moder.pkts);
+		tqp_vector->rx_group.coal.int_ql = cur_moder.pkts;
+	}
+
+	dim->state = DIM_START_MEASURE;
+}
+
+static void hns3_tx_dim_work(struct work_struct *work)
+{
+	struct dim *dim = container_of(work, struct dim, work);
+	struct hns3_enet_ring_group *group = container_of(dim,
+		struct hns3_enet_ring_group, dim);
+	struct hns3_enet_tqp_vector *tqp_vector = group->ring->tqp_vector;
+	struct dim_cq_moder cur_moder =
+		net_dim_get_tx_moderation(dim->mode, dim->profile_ix);
+
+	hns3_set_vector_coalesce_tx_gl(tqp_vector, cur_moder.usec);
+	tqp_vector->tx_group.coal.int_gl = cur_moder.usec;
+
+	if (cur_moder.pkts < tqp_vector->tx_group.coal.int_ql_max) {
+		hns3_set_vector_coalesce_tx_ql(tqp_vector, cur_moder.pkts);
+		tqp_vector->tx_group.coal.int_ql = cur_moder.pkts;
+	}
+
+	dim->state = DIM_START_MEASURE;
+}
+
+static void hns3_nic_init_dim(struct hns3_enet_tqp_vector *tqp_vector)
+{
+	INIT_WORK(&tqp_vector->rx_group.dim.work, hns3_rx_dim_work);
+	tqp_vector->rx_group.dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+	INIT_WORK(&tqp_vector->tx_group.dim.work, hns3_tx_dim_work);
+	tqp_vector->tx_group.dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+}
+
 static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 {
 	struct hnae3_ring_chain_node vector_ring_chain;
@@ -3589,6 +3672,7 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 		tqp_vector = &priv->tqp_vector[i];
 		hns3_vector_coalesce_init_hw(tqp_vector, priv);
 		tqp_vector->num_tqps = 0;
+		hns3_nic_init_dim(tqp_vector);
 	}
 
 	for (i = 0; i < h->kinfo.num_tqps; i++) {
@@ -4161,6 +4245,7 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	netdev->max_mtu = HNS3_MAX_MTU;
 
 	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
+	priv->dim_enable = 1;
 
 	if (netif_msg_drv(handle))
 		hns3_info_show(priv);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 8d33652..4af11aa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -4,6 +4,7 @@
 #ifndef __HNS3_ENET_H
 #define __HNS3_ENET_H
 
+#include <linux/dim.h>
 #include <linux/if_vlan.h>
 
 #include "hnae3.h"
@@ -449,6 +450,7 @@ struct hns3_enet_ring_group {
 	u64 total_packets;	/* total packets processed this group */
 	u16 count;
 	struct hns3_enet_coalesce coal;
+	struct dim dim;
 };
 
 struct hns3_enet_tqp_vector {
@@ -471,6 +473,7 @@ struct hns3_enet_tqp_vector {
 	char name[HNAE3_INT_NAME_LEN];
 
 	unsigned long last_jiffies;
+	u64 event_cnt;
 } ____cacheline_internodealigned_in_smp;
 
 struct hns3_nic_priv {
@@ -486,6 +489,7 @@ struct hns3_nic_priv {
 	struct hns3_enet_tqp_vector *tqp_vector;
 	u16 vector_num;
 	u8 max_non_tso_bd_num;
+	u8 dim_enable:1;
 
 	u64 tx_timeout_count;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c30d5d3..1e458a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1117,6 +1117,7 @@ static int hns3_get_coalesce_per_queue(struct net_device *netdev, u32 queue,
 
 	cmd->tx_max_coalesced_frames = tx_vector->tx_group.coal.int_ql;
 	cmd->rx_max_coalesced_frames = rx_vector->rx_group.coal.int_ql;
+	cmd->use_dim = priv->dim_enable;
 
 	return 0;
 }
@@ -1299,6 +1300,7 @@ static int hns3_set_coalesce(struct net_device *netdev,
 			     struct ethtool_coalesce *cmd)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	u16 queue_num = h->kinfo.num_tqps;
 	int ret;
 	int i;
@@ -1316,6 +1318,8 @@ static int hns3_set_coalesce(struct net_device *netdev,
 	for (i = 0; i < queue_num; i++)
 		hns3_set_coalesce_per_queue(netdev, cmd, i);
 
+	priv->dim_enable = cmd->use_dim;
+
 	return 0;
 }
 
@@ -1520,7 +1524,8 @@ static int hns3_get_module_eeprom(struct net_device *netdev,
 				 ETHTOOL_COALESCE_USE_ADAPTIVE |	\
 				 ETHTOOL_COALESCE_RX_USECS_HIGH |	\
 				 ETHTOOL_COALESCE_TX_USECS_HIGH |	\
-				 ETHTOOL_COALESCE_MAX_FRAMES)
+				 ETHTOOL_COALESCE_MAX_FRAMES |		\
+				 ETHTOOL_COALESCE_USE_DIM)
 
 static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
-- 
2.7.4

