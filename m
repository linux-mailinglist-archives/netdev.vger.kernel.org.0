Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8D02D5204
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbgLJDt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:49:56 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9420 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730793AbgLJDn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:43:27 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cs08x5d8tz7CB7;
        Thu, 10 Dec 2020 11:42:09 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 11:42:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <huangdaode@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/7] net: hns3: refine the struct hane3_tc_info
Date:   Thu, 10 Dec 2020 11:42:06 +0800
Message-ID: <1607571732-24219-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, there are multiple members related to tc information
in struct hnae3_knic_private_info. Merge them into a new struct
hnae3_tc_info.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        | 17 ++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 33 +++++++--------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  4 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 49 ++++++++++------------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 21 +++++-----
 8 files changed, 64 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 1a09b1f..0cb80ef 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -659,15 +659,16 @@ struct hnae3_ae_algo {
 #define HNAE3_INT_NAME_LEN        32
 #define HNAE3_ITR_COUNTDOWN_START 100
 
+#define HNAE3_MAX_TC		8
+#define HNAE3_MAX_USER_PRIO	8
 struct hnae3_tc_info {
-	u16	tqp_offset;	/* TQP offset from base TQP */
-	u16	tqp_count;	/* Total TQPs */
-	u8	tc;		/* TC index */
-	bool	enable;		/* If this TC is enable or not */
+	u8 prio_tc[HNAE3_MAX_USER_PRIO]; /* TC indexed by prio */
+	u16 tqp_count[HNAE3_MAX_TC];
+	u16 tqp_offset[HNAE3_MAX_TC];
+	unsigned long tc_en; /* bitmap of TC enabled */
+	u8 num_tc; /* Total number of enabled TCs */
 };
 
-#define HNAE3_MAX_TC		8
-#define HNAE3_MAX_USER_PRIO	8
 struct hnae3_knic_private_info {
 	struct net_device *netdev; /* Set by KNIC client when init instance */
 	u16 rss_size;		   /* Allocated RSS queues */
@@ -676,9 +677,7 @@ struct hnae3_knic_private_info {
 	u16 num_tx_desc;
 	u16 num_rx_desc;
 
-	u8 num_tc;		   /* Total number of enabled TCs */
-	u8 prio_tc[HNAE3_MAX_USER_PRIO];  /* TC indexed by prio */
-	struct hnae3_tc_info tc_info[HNAE3_MAX_TC]; /* Idx of array is HW TC */
+	struct hnae3_tc_info tc_info;
 
 	u16 num_tqps;		  /* total number of TQPs in this handle */
 	struct hnae3_queue **tqp;  /* array base of all TQPs in this instance */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index cb26742..9d4e9c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -385,7 +385,8 @@ static void hns3_dbg_dev_specs(struct hnae3_handle *h)
 	dev_info(priv->dev, "RX buffer length: %u\n", kinfo->rx_buf_len);
 	dev_info(priv->dev, "Desc num per TX queue: %u\n", kinfo->num_tx_desc);
 	dev_info(priv->dev, "Desc num per RX queue: %u\n", kinfo->num_rx_desc);
-	dev_info(priv->dev, "Total number of enabled TCs: %u\n", kinfo->num_tc);
+	dev_info(priv->dev, "Total number of enabled TCs: %u\n",
+		 kinfo->tc_info.num_tc);
 	dev_info(priv->dev, "MAX INT QL: %u\n", dev_specs->int_ql_max);
 	dev_info(priv->dev, "MAX INT GL: %u\n", dev_specs->max_int_gl);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4c2fb86..36e74ad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -323,13 +323,14 @@ static int hns3_nic_set_real_num_queue(struct net_device *netdev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct hnae3_knic_private_info *kinfo = &h->kinfo;
-	unsigned int queue_size = kinfo->rss_size * kinfo->num_tc;
+	struct hnae3_tc_info *tc_info = &kinfo->tc_info;
+	unsigned int queue_size = kinfo->rss_size * tc_info->num_tc;
 	int i, ret;
 
-	if (kinfo->num_tc <= 1) {
+	if (tc_info->num_tc <= 1) {
 		netdev_reset_tc(netdev);
 	} else {
-		ret = netdev_set_num_tc(netdev, kinfo->num_tc);
+		ret = netdev_set_num_tc(netdev, tc_info->num_tc);
 		if (ret) {
 			netdev_err(netdev,
 				   "netdev_set_num_tc fail, ret=%d!\n", ret);
@@ -337,13 +338,11 @@ static int hns3_nic_set_real_num_queue(struct net_device *netdev)
 		}
 
 		for (i = 0; i < HNAE3_MAX_TC; i++) {
-			if (!kinfo->tc_info[i].enable)
+			if (!test_bit(i, &tc_info->tc_en))
 				continue;
 
-			netdev_set_tc_queue(netdev,
-					    kinfo->tc_info[i].tc,
-					    kinfo->tc_info[i].tqp_count,
-					    kinfo->tc_info[i].tqp_offset);
+			netdev_set_tc_queue(netdev, i, tc_info->tqp_count[i],
+					    tc_info->tqp_offset[i]);
 		}
 	}
 
@@ -369,7 +368,7 @@ static u16 hns3_get_max_available_channels(struct hnae3_handle *h)
 	u16 alloc_tqps, max_rss_size, rss_size;
 
 	h->ae_algo->ops->get_tqps_and_rss_info(h, &alloc_tqps, &max_rss_size);
-	rss_size = alloc_tqps / h->kinfo.num_tc;
+	rss_size = alloc_tqps / h->kinfo.tc_info.num_tc;
 
 	return min_t(u16, rss_size, max_rss_size);
 }
@@ -508,7 +507,7 @@ static int hns3_nic_net_open(struct net_device *netdev)
 
 	kinfo = &h->kinfo;
 	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++)
-		netdev_set_prio_tc_map(netdev, i, kinfo->prio_tc[i]);
+		netdev_set_prio_tc_map(netdev, i, kinfo->tc_info.prio_tc[i]);
 
 	if (h->ae_algo->ops->set_timer_task)
 		h->ae_algo->ops->set_timer_task(priv->ae_handle, true);
@@ -3980,21 +3979,20 @@ static void hns3_init_ring_hw(struct hns3_enet_ring *ring)
 static void hns3_init_tx_ring_tc(struct hns3_nic_priv *priv)
 {
 	struct hnae3_knic_private_info *kinfo = &priv->ae_handle->kinfo;
+	struct hnae3_tc_info *tc_info = &kinfo->tc_info;
 	int i;
 
 	for (i = 0; i < HNAE3_MAX_TC; i++) {
-		struct hnae3_tc_info *tc_info = &kinfo->tc_info[i];
 		int j;
 
-		if (!tc_info->enable)
+		if (!test_bit(i, &tc_info->tc_en))
 			continue;
 
-		for (j = 0; j < tc_info->tqp_count; j++) {
+		for (j = 0; j < tc_info->tqp_count[i]; j++) {
 			struct hnae3_queue *q;
 
-			q = priv->ring[tc_info->tqp_offset + j].tqp;
-			hns3_write_dev(q, HNS3_RING_TX_RING_TC_REG,
-				       tc_info->tc);
+			q = priv->ring[tc_info->tqp_offset[i] + j].tqp;
+			hns3_write_dev(q, HNS3_RING_TX_RING_TC_REG, i);
 		}
 	}
 }
@@ -4121,7 +4119,8 @@ static void hns3_info_show(struct hns3_nic_priv *priv)
 	dev_info(priv->dev, "RX buffer length: %u\n", kinfo->rx_buf_len);
 	dev_info(priv->dev, "Desc num per TX queue: %u\n", kinfo->num_tx_desc);
 	dev_info(priv->dev, "Desc num per RX queue: %u\n", kinfo->num_rx_desc);
-	dev_info(priv->dev, "Total number of enabled TCs: %u\n", kinfo->num_tc);
+	dev_info(priv->dev, "Total number of enabled TCs: %u\n",
+		 kinfo->tc_info.num_tc);
 	dev_info(priv->dev, "Max mtu size: %u\n", priv->netdev->max_mtu);
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index bedbc11..8f6dea5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1454,7 +1454,7 @@ static void hclge_dbg_dump_qs_shaper_all(struct hclge_dev *hdev)
 
 		dev_info(&hdev->pdev->dev, "qs cfg of vport%d:\n", vport_id);
 
-		for (i = 0; i < kinfo->num_tc; i++) {
+		for (i = 0; i < kinfo->tc_info.num_tc; i++) {
 			u16 qsid = vport->qs_offset + i;
 
 			hclge_dbg_dump_qs_shaper_single(hdev, qsid);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 92cd444..8bf1027 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10699,7 +10699,7 @@ static u32 hclge_get_max_channels(struct hnae3_handle *handle)
 	struct hclge_dev *hdev = vport->back;
 
 	return min_t(u32, hdev->rss_size_max,
-		     vport->alloc_tqps / kinfo->num_tc);
+		     vport->alloc_tqps / kinfo->tc_info.num_tc);
 }
 
 static void hclge_get_channels(struct hnae3_handle *handle,
@@ -10786,7 +10786,7 @@ static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 		dev_info(&hdev->pdev->dev,
 			 "Channels changed, rss_size from %u to %u, tqps from %u to %u",
 			 cur_rss_size, kinfo->rss_size,
-			 cur_tqps, kinfo->rss_size * kinfo->num_tc);
+			 cur_tqps, kinfo->rss_size * kinfo->tc_info.num_tc);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 0f6626b..754c09a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -414,7 +414,7 @@ static void hclge_get_vf_tcinfo(struct hclge_vport *vport,
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
 	unsigned int i;
 
-	for (i = 0; i < kinfo->num_tc; i++)
+	for (i = 0; i < kinfo->tc_info.num_tc; i++)
 		resp_msg->data[0] |= BIT(i);
 
 	resp_msg->len = sizeof(u8);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index b1026cd..dd2b100 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -565,7 +565,7 @@ int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate)
 						 HCLGE_SHAPER_BS_U_DEF,
 						 HCLGE_SHAPER_BS_S_DEF);
 
-	for (i = 0; i < kinfo->num_tc; i++) {
+	for (i = 0; i < kinfo->tc_info.num_tc; i++) {
 		hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QCN_SHAPPING_CFG,
 					   false);
 
@@ -599,13 +599,13 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 	/* TC configuration is shared by PF/VF in one port, only allow
 	 * one tc for VF for simplicity. VF's vport_id is non zero.
 	 */
-	kinfo->num_tc = vport->vport_id ? 1 :
+	kinfo->tc_info.num_tc = vport->vport_id ? 1 :
 			min_t(u16, vport->alloc_tqps, hdev->tm_info.num_tc);
 	vport->qs_offset = (vport->vport_id ? HNAE3_MAX_TC : 0) +
 				(vport->vport_id ? (vport->vport_id - 1) : 0);
 
 	max_rss_size = min_t(u16, hdev->rss_size_max,
-			     vport->alloc_tqps / kinfo->num_tc);
+			     vport->alloc_tqps / kinfo->tc_info.num_tc);
 
 	/* Set to user value, no larger than max_rss_size. */
 	if (kinfo->req_rss_size != kinfo->rss_size && kinfo->req_rss_size &&
@@ -622,34 +622,32 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 		if (!kinfo->req_rss_size)
 			max_rss_size = min_t(u16, max_rss_size,
 					     (hdev->num_nic_msi - 1) /
-					     kinfo->num_tc);
+					     kinfo->tc_info.num_tc);
 
 		/* Set to the maximum specification value (max_rss_size). */
 		kinfo->rss_size = max_rss_size;
 	}
 
-	kinfo->num_tqps = kinfo->num_tc * kinfo->rss_size;
+	kinfo->num_tqps = kinfo->tc_info.num_tc * kinfo->rss_size;
 	vport->dwrr = 100;  /* 100 percent as init */
 	vport->alloc_rss_size = kinfo->rss_size;
 	vport->bw_limit = hdev->tm_info.pg_info[0].bw_limit;
 
 	for (i = 0; i < HNAE3_MAX_TC; i++) {
-		if (hdev->hw_tc_map & BIT(i) && i < kinfo->num_tc) {
-			kinfo->tc_info[i].enable = true;
-			kinfo->tc_info[i].tqp_offset = i * kinfo->rss_size;
-			kinfo->tc_info[i].tqp_count = kinfo->rss_size;
-			kinfo->tc_info[i].tc = i;
+		if (hdev->hw_tc_map & BIT(i) && i < kinfo->tc_info.num_tc) {
+			set_bit(i, &kinfo->tc_info.tc_en);
+			kinfo->tc_info.tqp_offset[i] = i * kinfo->rss_size;
+			kinfo->tc_info.tqp_count[i] = kinfo->rss_size;
 		} else {
 			/* Set to default queue if TC is disable */
-			kinfo->tc_info[i].enable = false;
-			kinfo->tc_info[i].tqp_offset = 0;
-			kinfo->tc_info[i].tqp_count = 1;
-			kinfo->tc_info[i].tc = 0;
+			clear_bit(i, &kinfo->tc_info.tc_en);
+			kinfo->tc_info.tqp_offset[i] = 0;
+			kinfo->tc_info.tqp_count[i] = 1;
 		}
 	}
 
-	memcpy(kinfo->prio_tc, hdev->tm_info.prio_tc,
-	       sizeof_field(struct hnae3_knic_private_info, prio_tc));
+	memcpy(kinfo->tc_info.prio_tc, hdev->tm_info.prio_tc,
+	       sizeof_field(struct hnae3_tc_info, prio_tc));
 }
 
 static void hclge_tm_vport_info_update(struct hclge_dev *hdev)
@@ -854,15 +852,14 @@ static int hclge_vport_q_to_qs_map(struct hclge_dev *hdev,
 				   struct hclge_vport *vport)
 {
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
+	struct hnae3_tc_info *tc_info = &kinfo->tc_info;
 	struct hnae3_queue **tqp = kinfo->tqp;
-	struct hnae3_tc_info *v_tc_info;
 	u32 i, j;
 	int ret;
 
-	for (i = 0; i < kinfo->num_tc; i++) {
-		v_tc_info = &kinfo->tc_info[i];
-		for (j = 0; j < v_tc_info->tqp_count; j++) {
-			struct hnae3_queue *q = tqp[v_tc_info->tqp_offset + j];
+	for (i = 0; i < tc_info->num_tc; i++) {
+		for (j = 0; j < tc_info->tqp_count[i]; j++) {
+			struct hnae3_queue *q = tqp[tc_info->tqp_offset[i] + j];
 
 			ret = hclge_tm_q_to_qs_map_cfg(hdev,
 						       hclge_get_queue_id(q),
@@ -887,7 +884,7 @@ static int hclge_tm_pri_q_qs_cfg(struct hclge_dev *hdev)
 			struct hnae3_knic_private_info *kinfo =
 				&vport[k].nic.kinfo;
 
-			for (i = 0; i < kinfo->num_tc; i++) {
+			for (i = 0; i < kinfo->tc_info.num_tc; i++) {
 				ret = hclge_tm_qs_to_pri_map_cfg(
 					hdev, vport[k].qs_offset + i, i);
 				if (ret)
@@ -1001,7 +998,7 @@ static int hclge_tm_pri_vnet_base_shaper_qs_cfg(struct hclge_vport *vport)
 	u32 i;
 	int ret;
 
-	for (i = 0; i < kinfo->num_tc; i++) {
+	for (i = 0; i < kinfo->tc_info.num_tc; i++) {
 		ret = hclge_shaper_para_calc(hdev->tm_info.tc_info[i].bw_limit,
 					     HCLGE_SHAPER_LVL_QSET,
 					     &ir_para, max_tm_rate);
@@ -1123,7 +1120,7 @@ static int hclge_tm_pri_vnet_base_dwrr_pri_cfg(struct hclge_vport *vport)
 		return ret;
 
 	/* Qset dwrr */
-	for (i = 0; i < kinfo->num_tc; i++) {
+	for (i = 0; i < kinfo->tc_info.num_tc; i++) {
 		ret = hclge_tm_qs_weight_cfg(
 			hdev, vport->qs_offset + i,
 			hdev->tm_info.pg_info[0].tc_dwrr[i]);
@@ -1254,7 +1251,7 @@ static int hclge_tm_schd_mode_vnet_base_cfg(struct hclge_vport *vport)
 	if (ret)
 		return ret;
 
-	for (i = 0; i < kinfo->num_tc; i++) {
+	for (i = 0; i < kinfo->tc_info.num_tc; i++) {
 		u8 sch_mode = hdev->tm_info.tc_info[i].tc_sch_mode;
 
 		ret = hclge_tm_qs_schd_mode_cfg(hdev, vport->qs_offset + i,
@@ -1484,7 +1481,7 @@ void hclge_tm_prio_tc_info_update(struct hclge_dev *hdev, u8 *prio_tc)
 
 		for (k = 0;  k < hdev->num_alloc_vport; k++) {
 			kinfo = &vport[k].nic.kinfo;
-			kinfo->prio_tc[i] = prio_tc[i];
+			kinfo->tc_info.prio_tc[i] = prio_tc[i];
 		}
 	}
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index b142ae6..145757c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -433,19 +433,20 @@ static int hclgevf_knic_setup(struct hclgevf_dev *hdev)
 	struct hnae3_knic_private_info *kinfo;
 	u16 new_tqps = hdev->num_tqps;
 	unsigned int i;
+	u8 num_tc = 0;
 
 	kinfo = &nic->kinfo;
-	kinfo->num_tc = 0;
 	kinfo->num_tx_desc = hdev->num_tx_desc;
 	kinfo->num_rx_desc = hdev->num_rx_desc;
 	kinfo->rx_buf_len = hdev->rx_buf_len;
 	for (i = 0; i < HCLGEVF_MAX_TC_NUM; i++)
 		if (hdev->hw_tc_map & BIT(i))
-			kinfo->num_tc++;
+			num_tc++;
 
-	kinfo->rss_size
-		= min_t(u16, hdev->rss_size_max, new_tqps / kinfo->num_tc);
-	new_tqps = kinfo->rss_size * kinfo->num_tc;
+	num_tc = num_tc ? num_tc : 1;
+	kinfo->tc_info.num_tc = num_tc;
+	kinfo->rss_size = min_t(u16, hdev->rss_size_max, new_tqps / num_tc);
+	new_tqps = kinfo->rss_size * num_tc;
 	kinfo->num_tqps = min(new_tqps, hdev->num_tqps);
 
 	kinfo->tqp = devm_kcalloc(&hdev->pdev->dev, kinfo->num_tqps,
@@ -463,7 +464,7 @@ static int hclgevf_knic_setup(struct hclgevf_dev *hdev)
 	 * and rss size with the actual vector numbers
 	 */
 	kinfo->num_tqps = min_t(u16, hdev->num_nic_msix - 1, kinfo->num_tqps);
-	kinfo->rss_size = min_t(u16, kinfo->num_tqps / kinfo->num_tc,
+	kinfo->rss_size = min_t(u16, kinfo->num_tqps / num_tc,
 				kinfo->rss_size);
 
 	return 0;
@@ -3360,7 +3361,7 @@ static u32 hclgevf_get_max_channels(struct hclgevf_dev *hdev)
 	struct hnae3_knic_private_info *kinfo = &nic->kinfo;
 
 	return min_t(u32, hdev->rss_size_max,
-		     hdev->num_tqps / kinfo->num_tc);
+		     hdev->num_tqps / kinfo->tc_info.num_tc);
 }
 
 /**
@@ -3403,7 +3404,7 @@ static void hclgevf_update_rss_size(struct hnae3_handle *handle,
 	kinfo->req_rss_size = new_tqps_num;
 
 	max_rss_size = min_t(u16, hdev->rss_size_max,
-			     hdev->num_tqps / kinfo->num_tc);
+			     hdev->num_tqps / kinfo->tc_info.num_tc);
 
 	/* Use the user's configuration when it is not larger than
 	 * max_rss_size, otherwise, use the maximum specification value.
@@ -3415,7 +3416,7 @@ static void hclgevf_update_rss_size(struct hnae3_handle *handle,
 		 (!kinfo->req_rss_size && kinfo->rss_size < max_rss_size))
 		kinfo->rss_size = max_rss_size;
 
-	kinfo->num_tqps = kinfo->num_tc * kinfo->rss_size;
+	kinfo->num_tqps = kinfo->tc_info.num_tc * kinfo->rss_size;
 }
 
 static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
@@ -3461,7 +3462,7 @@ static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 		dev_info(&hdev->pdev->dev,
 			 "Channels changed, rss_size from %u to %u, tqps from %u to %u",
 			 cur_rss_size, kinfo->rss_size,
-			 cur_tqps, kinfo->rss_size * kinfo->num_tc);
+			 cur_tqps, kinfo->rss_size * kinfo->tc_info.num_tc);
 
 	return ret;
 }
-- 
2.7.4

