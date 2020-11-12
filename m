Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6262AFF2C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgKLFcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:47 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7486 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgKLDfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 22:35:15 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CWnHN5GqDzhjqT;
        Thu, 12 Nov 2020 11:33:04 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 12 Nov 2020 11:33:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V3 net-next 05/10] net: hns3: add support for dynamic interrupt moderation
Date:   Thu, 12 Nov 2020 11:33:13 +0800
Message-ID: <1605151998-12633-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605151998-12633-1-git-send-email-tanhuazhong@huawei.com>
References: <1605151998-12633-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dynamic interrupt moderation support for the HNS3 driver.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/Kconfig          |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 87 ++++++++++++++++++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  4 ++
 3 files changed, 91 insertions(+), 1 deletion(-)

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
index 999a2aa..9e895b9 100644
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
+		if (test_bit(HNS3_NIC_STATE_DIM_ENABLE, &priv->state)) {
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
+	set_bit(HNS3_NIC_STATE_DIM_ENABLE, &priv->state);
 
 	if (netif_msg_drv(handle))
 		hns3_info_show(priv);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 8d33652..eb4e7ef 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -4,6 +4,7 @@
 #ifndef __HNS3_ENET_H
 #define __HNS3_ENET_H
 
+#include <linux/dim.h>
 #include <linux/if_vlan.h>
 
 #include "hnae3.h"
@@ -18,6 +19,7 @@ enum hns3_nic_state {
 	HNS3_NIC_STATE_SERVICE_INITED,
 	HNS3_NIC_STATE_SERVICE_SCHED,
 	HNS3_NIC_STATE2_RESET_REQUESTED,
+	HNS3_NIC_STATE_DIM_ENABLE,
 	HNS3_NIC_STATE_MAX
 };
 
@@ -449,6 +451,7 @@ struct hns3_enet_ring_group {
 	u64 total_packets;	/* total packets processed this group */
 	u16 count;
 	struct hns3_enet_coalesce coal;
+	struct dim dim;
 };
 
 struct hns3_enet_tqp_vector {
@@ -471,6 +474,7 @@ struct hns3_enet_tqp_vector {
 	char name[HNAE3_INT_NAME_LEN];
 
 	unsigned long last_jiffies;
+	u64 event_cnt;
 } ____cacheline_internodealigned_in_smp;
 
 struct hns3_nic_priv {
-- 
2.7.4

