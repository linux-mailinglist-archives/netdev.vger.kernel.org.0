Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8AE38FDB2
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 11:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhEYJX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 05:23:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3941 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhEYJXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 05:23:53 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fq7nS0YxSzBwPH;
        Tue, 25 May 2021 17:19:24 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 17:22:13 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 17:22:12 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next] net: hns3: switch to dim algorithm for adaptive interrupt moderation
Date:   Tue, 25 May 2021 17:22:03 +0800
Message-ID: <1621934523-52698-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Linux kernel has support for a dynamic interrupt moderation
algorithm known as "dimlib". Replace the custom driver-specific
implementation of dynamic interrupt moderation with the kernel's
algorithm.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/Kconfig          |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 193 +++++++++---------------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |   4 +-
 3 files changed, 73 insertions(+), 125 deletions(-)

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
index aae514a..a9a813a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -368,6 +368,7 @@ static irqreturn_t hns3_irq_handle(int irq, void *vector)
 	struct hns3_enet_tqp_vector *tqp_vector = vector;
 
 	napi_schedule_irqoff(&tqp_vector->napi);
+	tqp_vector->event_cnt++;
 
 	return IRQ_HANDLED;
 }
@@ -471,6 +472,8 @@ static void hns3_vector_disable(struct hns3_enet_tqp_vector *tqp_vector)
 
 	disable_irq(tqp_vector->vector_irq);
 	napi_disable(&tqp_vector->napi);
+	cancel_work_sync(&tqp_vector->rx_group.dim.work);
+	cancel_work_sync(&tqp_vector->tx_group.dim.work);
 }
 
 void hns3_set_vector_coalesce_rl(struct hns3_enet_tqp_vector *tqp_vector,
@@ -3767,139 +3770,30 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 	return recv_pkts;
 }
 
-static bool hns3_get_new_flow_lvl(struct hns3_enet_ring_group *ring_group)
+static void hns3_update_rx_int_coalesce(struct hns3_enet_tqp_vector *tqp_vector)
 {
-#define HNS3_RX_LOW_BYTE_RATE 10000
-#define HNS3_RX_MID_BYTE_RATE 20000
-#define HNS3_RX_ULTRA_PACKET_RATE 40
-
-	enum hns3_flow_level_range new_flow_level;
-	struct hns3_enet_tqp_vector *tqp_vector;
-	int packets_per_msecs, bytes_per_msecs;
-	u32 time_passed_ms;
-
-	tqp_vector = ring_group->ring->tqp_vector;
-	time_passed_ms =
-		jiffies_to_msecs(jiffies - tqp_vector->last_jiffies);
-	if (!time_passed_ms)
-		return false;
-
-	do_div(ring_group->total_packets, time_passed_ms);
-	packets_per_msecs = ring_group->total_packets;
-
-	do_div(ring_group->total_bytes, time_passed_ms);
-	bytes_per_msecs = ring_group->total_bytes;
-
-	new_flow_level = ring_group->coal.flow_level;
-
-	/* Simple throttlerate management
-	 * 0-10MB/s   lower     (50000 ints/s)
-	 * 10-20MB/s   middle    (20000 ints/s)
-	 * 20-1249MB/s high      (18000 ints/s)
-	 * > 40000pps  ultra     (8000 ints/s)
-	 */
-	switch (new_flow_level) {
-	case HNS3_FLOW_LOW:
-		if (bytes_per_msecs > HNS3_RX_LOW_BYTE_RATE)
-			new_flow_level = HNS3_FLOW_MID;
-		break;
-	case HNS3_FLOW_MID:
-		if (bytes_per_msecs > HNS3_RX_MID_BYTE_RATE)
-			new_flow_level = HNS3_FLOW_HIGH;
-		else if (bytes_per_msecs <= HNS3_RX_LOW_BYTE_RATE)
-			new_flow_level = HNS3_FLOW_LOW;
-		break;
-	case HNS3_FLOW_HIGH:
-	case HNS3_FLOW_ULTRA:
-	default:
-		if (bytes_per_msecs <= HNS3_RX_MID_BYTE_RATE)
-			new_flow_level = HNS3_FLOW_MID;
-		break;
-	}
-
-	if (packets_per_msecs > HNS3_RX_ULTRA_PACKET_RATE &&
-	    &tqp_vector->rx_group == ring_group)
-		new_flow_level = HNS3_FLOW_ULTRA;
-
-	ring_group->total_bytes = 0;
-	ring_group->total_packets = 0;
-	ring_group->coal.flow_level = new_flow_level;
-
-	return true;
-}
-
-static bool hns3_get_new_int_gl(struct hns3_enet_ring_group *ring_group)
-{
-	struct hns3_enet_tqp_vector *tqp_vector;
-	u16 new_int_gl;
-
-	if (!ring_group->ring)
-		return false;
-
-	tqp_vector = ring_group->ring->tqp_vector;
-	if (!tqp_vector->last_jiffies)
-		return false;
-
-	if (ring_group->total_packets == 0) {
-		ring_group->coal.int_gl = HNS3_INT_GL_50K;
-		ring_group->coal.flow_level = HNS3_FLOW_LOW;
-		return true;
-	}
-
-	if (!hns3_get_new_flow_lvl(ring_group))
-		return false;
+	struct hns3_enet_ring_group *rx_group = &tqp_vector->rx_group;
+	struct dim_sample sample = {};
 
-	new_int_gl = ring_group->coal.int_gl;
-	switch (ring_group->coal.flow_level) {
-	case HNS3_FLOW_LOW:
-		new_int_gl = HNS3_INT_GL_50K;
-		break;
-	case HNS3_FLOW_MID:
-		new_int_gl = HNS3_INT_GL_20K;
-		break;
-	case HNS3_FLOW_HIGH:
-		new_int_gl = HNS3_INT_GL_18K;
-		break;
-	case HNS3_FLOW_ULTRA:
-		new_int_gl = HNS3_INT_GL_8K;
-		break;
-	default:
-		break;
-	}
+	if (!rx_group->coal.adapt_enable)
+		return;
 
-	if (new_int_gl != ring_group->coal.int_gl) {
-		ring_group->coal.int_gl = new_int_gl;
-		return true;
-	}
-	return false;
+	dim_update_sample(tqp_vector->event_cnt, rx_group->total_packets,
+			  rx_group->total_bytes, &sample);
+	net_dim(&rx_group->dim, sample);
 }
 
-static void hns3_update_new_int_gl(struct hns3_enet_tqp_vector *tqp_vector)
+static void hns3_update_tx_int_coalesce(struct hns3_enet_tqp_vector *tqp_vector)
 {
-	struct hns3_enet_ring_group *rx_group = &tqp_vector->rx_group;
 	struct hns3_enet_ring_group *tx_group = &tqp_vector->tx_group;
-	bool rx_update, tx_update;
+	struct dim_sample sample = {};
 
-	/* update param every 1000ms */
-	if (time_before(jiffies,
-			tqp_vector->last_jiffies + msecs_to_jiffies(1000)))
+	if (!tx_group->coal.adapt_enable)
 		return;
 
-	if (rx_group->coal.adapt_enable) {
-		rx_update = hns3_get_new_int_gl(rx_group);
-		if (rx_update)
-			hns3_set_vector_coalesce_rx_gl(tqp_vector,
-						       rx_group->coal.int_gl);
-	}
-
-	if (tx_group->coal.adapt_enable) {
-		tx_update = hns3_get_new_int_gl(tx_group);
-		if (tx_update)
-			hns3_set_vector_coalesce_tx_gl(tqp_vector,
-						       tx_group->coal.int_gl);
-	}
-
-	tqp_vector->last_jiffies = jiffies;
+	dim_update_sample(tqp_vector->event_cnt, tx_group->total_packets,
+			  tx_group->total_bytes, &sample);
+	net_dim(&tx_group->dim, sample);
 }
 
 static int hns3_nic_common_poll(struct napi_struct *napi, int budget)
@@ -3944,7 +3838,9 @@ static int hns3_nic_common_poll(struct napi_struct *napi, int budget)
 
 	if (napi_complete(napi) &&
 	    likely(!test_bit(HNS3_NIC_STATE_DOWN, &priv->state))) {
-		hns3_update_new_int_gl(tqp_vector);
+		hns3_update_rx_int_coalesce(tqp_vector);
+		hns3_update_tx_int_coalesce(tqp_vector);
+
 		hns3_mask_vector_irq(tqp_vector, 1);
 	}
 
@@ -4075,6 +3971,54 @@ static void hns3_nic_set_cpumask(struct hns3_nic_priv *priv)
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
 	struct hnae3_handle *h = priv->ae_handle;
@@ -4088,6 +4032,7 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 		tqp_vector = &priv->tqp_vector[i];
 		hns3_vector_coalesce_init_hw(tqp_vector, priv);
 		tqp_vector->num_tqps = 0;
+		hns3_nic_init_dim(tqp_vector);
 	}
 
 	for (i = 0; i < h->kinfo.num_tqps; i++) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 79ff2fa..b038441 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -4,6 +4,7 @@
 #ifndef __HNS3_ENET_H
 #define __HNS3_ENET_H
 
+#include <linux/dim.h>
 #include <linux/if_vlan.h>
 
 #include "hnae3.h"
@@ -482,6 +483,7 @@ struct hns3_enet_ring_group {
 	u64 total_packets;	/* total packets processed this group */
 	u16 count;
 	struct hns3_enet_coalesce coal;
+	struct dim dim;
 };
 
 struct hns3_enet_tqp_vector {
@@ -503,7 +505,7 @@ struct hns3_enet_tqp_vector {
 
 	char name[HNAE3_INT_NAME_LEN];
 
-	unsigned long last_jiffies;
+	u64 event_cnt;
 } ____cacheline_internodealigned_in_smp;
 
 struct hns3_nic_priv {
-- 
2.7.4

