Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A15C48546C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240686AbiAEOZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:48 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:29326 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240697AbiAEOZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:21 -0500
Received: from kwepemi500001.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JTWvw6b7zzbjpQ;
        Wed,  5 Jan 2022 22:24:44 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500001.china.huawei.com (7.221.188.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:19 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:18 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 14/15] net: hns3: refactor VF tqp stats APIs with new common tqp stats APIs
Date:   Wed, 5 Jan 2022 22:20:14 +0800
Message-ID: <20220105142015.51097-15-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220105142015.51097-1-huangguangbin2@huawei.com>
References: <20220105142015.51097-1-huangguangbin2@huawei.com>
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

From: Jie Wang <wangjie125@huawei.com>

This patch firstly uses new tqp struct(hclge_comm_tqp) and removes the
old VF tqp struct(hclgevf_tqp). All the tqp stats members used in VF module
are modified according to the new hclge_comm_tqp.

Secondly VF tqp stats APIs are refactored to use new common tqp stats APIs.
The old tqp stats APIs in VF are deleted.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 125 ++----------------
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  20 +--
 2 files changed, 11 insertions(+), 134 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 3c42ca50f590..5b2379252478 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -121,108 +121,13 @@ static struct hclgevf_dev *hclgevf_ae_get_hdev(struct hnae3_handle *handle)
 		return container_of(handle, struct hclgevf_dev, nic);
 }
 
-static int hclgevf_tqps_update_stats(struct hnae3_handle *handle)
-{
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
-	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclge_desc desc;
-	struct hclgevf_tqp *tqp;
-	int status;
-	int i;
-
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		tqp = container_of(kinfo->tqp[i], struct hclgevf_tqp, q);
-		hclgevf_cmd_setup_basic_desc(&desc,
-					     HCLGEVF_OPC_QUERY_RX_STATUS,
-					     true);
-
-		desc.data[0] = cpu_to_le32(tqp->index & 0x1ff);
-		status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
-		if (status) {
-			dev_err(&hdev->pdev->dev,
-				"Query tqp stat fail, status = %d,queue = %d\n",
-				status,	i);
-			return status;
-		}
-		tqp->tqp_stats.rcb_rx_ring_pktnum_rcd +=
-			le32_to_cpu(desc.data[1]);
-
-		hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_QUERY_TX_STATUS,
-					     true);
-
-		desc.data[0] = cpu_to_le32(tqp->index & 0x1ff);
-		status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
-		if (status) {
-			dev_err(&hdev->pdev->dev,
-				"Query tqp stat fail, status = %d,queue = %d\n",
-				status, i);
-			return status;
-		}
-		tqp->tqp_stats.rcb_tx_ring_pktnum_rcd +=
-			le32_to_cpu(desc.data[1]);
-	}
-
-	return 0;
-}
-
-static u64 *hclgevf_tqps_get_stats(struct hnae3_handle *handle, u64 *data)
-{
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
-	struct hclgevf_tqp *tqp;
-	u64 *buff = data;
-	int i;
-
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		tqp = container_of(kinfo->tqp[i], struct hclgevf_tqp, q);
-		*buff++ = tqp->tqp_stats.rcb_tx_ring_pktnum_rcd;
-	}
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		tqp = container_of(kinfo->tqp[i], struct hclgevf_tqp, q);
-		*buff++ = tqp->tqp_stats.rcb_rx_ring_pktnum_rcd;
-	}
-
-	return buff;
-}
-
-static int hclgevf_tqps_get_sset_count(struct hnae3_handle *handle, int strset)
-{
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
-
-	return kinfo->num_tqps * 2;
-}
-
-static u8 *hclgevf_tqps_get_strings(struct hnae3_handle *handle, u8 *data)
-{
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
-	u8 *buff = data;
-	int i;
-
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		struct hclgevf_tqp *tqp = container_of(kinfo->tqp[i],
-						       struct hclgevf_tqp, q);
-		snprintf(buff, ETH_GSTRING_LEN, "txq%u_pktnum_rcd",
-			 tqp->index);
-		buff += ETH_GSTRING_LEN;
-	}
-
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		struct hclgevf_tqp *tqp = container_of(kinfo->tqp[i],
-						       struct hclgevf_tqp, q);
-		snprintf(buff, ETH_GSTRING_LEN, "rxq%u_pktnum_rcd",
-			 tqp->index);
-		buff += ETH_GSTRING_LEN;
-	}
-
-	return buff;
-}
-
 static void hclgevf_update_stats(struct hnae3_handle *handle,
 				 struct net_device_stats *net_stats)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	int status;
 
-	status = hclgevf_tqps_update_stats(handle);
+	status = hclge_comm_tqps_update_stats(handle, &hdev->hw.hw);
 	if (status)
 		dev_err(&hdev->pdev->dev,
 			"VF update of TQPS stats fail, status = %d.\n",
@@ -234,7 +139,7 @@ static int hclgevf_get_sset_count(struct hnae3_handle *handle, int strset)
 	if (strset == ETH_SS_TEST)
 		return -EOPNOTSUPP;
 	else if (strset == ETH_SS_STATS)
-		return hclgevf_tqps_get_sset_count(handle, strset);
+		return hclge_comm_tqps_get_sset_count(handle);
 
 	return 0;
 }
@@ -245,12 +150,12 @@ static void hclgevf_get_strings(struct hnae3_handle *handle, u32 strset,
 	u8 *p = (char *)data;
 
 	if (strset == ETH_SS_STATS)
-		p = hclgevf_tqps_get_strings(handle, p);
+		p = hclge_comm_tqps_get_strings(handle, p);
 }
 
 static void hclgevf_get_stats(struct hnae3_handle *handle, u64 *data)
 {
-	hclgevf_tqps_get_stats(handle, data);
+	hclge_comm_tqps_get_stats(handle, data);
 }
 
 static void hclgevf_build_send_msg(struct hclge_vf_to_pf_msg *msg, u8 code,
@@ -416,11 +321,11 @@ static int hclgevf_get_pf_media_type(struct hclgevf_dev *hdev)
 
 static int hclgevf_alloc_tqps(struct hclgevf_dev *hdev)
 {
-	struct hclgevf_tqp *tqp;
+	struct hclge_comm_tqp *tqp;
 	int i;
 
 	hdev->htqp = devm_kcalloc(&hdev->pdev->dev, hdev->num_tqps,
-				  sizeof(struct hclgevf_tqp), GFP_KERNEL);
+				  sizeof(struct hclge_comm_tqp), GFP_KERNEL);
 	if (!hdev->htqp)
 		return -ENOMEM;
 
@@ -958,18 +863,6 @@ static int hclgevf_tqp_enable(struct hnae3_handle *handle, bool enable)
 	return 0;
 }
 
-static void hclgevf_reset_tqp_stats(struct hnae3_handle *handle)
-{
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
-	struct hclgevf_tqp *tqp;
-	int i;
-
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		tqp = container_of(kinfo->tqp[i], struct hclgevf_tqp, q);
-		memset(&tqp->tqp_stats, 0, sizeof(tqp->tqp_stats));
-	}
-}
-
 static int hclgevf_get_host_mac_addr(struct hclgevf_dev *hdev, u8 *p)
 {
 	struct hclge_vf_to_pf_msg send_msg;
@@ -2033,7 +1926,7 @@ static void hclgevf_periodic_service_task(struct hclgevf_dev *hdev)
 	}
 
 	if (!(hdev->serv_processed_cnt % HCLGEVF_STATS_TIMER_INTERVAL))
-		hclgevf_tqps_update_stats(handle);
+		hclge_comm_tqps_update_stats(handle, &hdev->hw.hw);
 
 	/* VF does not need to request link status when this bit is set, because
 	 * PF will push its link status to VFs when link status changed.
@@ -2332,7 +2225,7 @@ static int hclgevf_ae_start(struct hnae3_handle *handle)
 	clear_bit(HCLGEVF_STATE_DOWN, &hdev->state);
 	clear_bit(HCLGEVF_STATE_PF_PUSH_LINK_STATUS, &hdev->state);
 
-	hclgevf_reset_tqp_stats(handle);
+	hclge_comm_reset_tqp_stats(handle);
 
 	hclgevf_request_link_info(hdev);
 
@@ -2350,7 +2243,7 @@ static void hclgevf_ae_stop(struct hnae3_handle *handle)
 	if (hdev->reset_type != HNAE3_VF_RESET)
 		hclgevf_reset_tqp(handle);
 
-	hclgevf_reset_tqp_stats(handle);
+	hclge_comm_reset_tqp_stats(handle);
 	hclgevf_update_link_status(hdev, 0);
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 50e347a2ed18..502ca1ce1a90 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -11,6 +11,7 @@
 #include "hclgevf_cmd.h"
 #include "hnae3.h"
 #include "hclge_comm_rss.h"
+#include "hclge_comm_tqp_stats.h"
 
 #define HCLGEVF_MOD_VERSION "1.0"
 #define HCLGEVF_DRIVER_NAME "hclgevf"
@@ -148,23 +149,6 @@ struct hclgevf_hw {
 	struct hclgevf_mac mac;
 };
 
-/* TQP stats */
-struct hlcgevf_tqp_stats {
-	/* query_tqp_tx_queue_statistics, opcode id: 0x0B03 */
-	u64 rcb_tx_ring_pktnum_rcd; /* 32bit */
-	/* query_tqp_rx_queue_statistics, opcode id: 0x0B13 */
-	u64 rcb_rx_ring_pktnum_rcd; /* 32bit */
-};
-
-struct hclgevf_tqp {
-	struct device *dev;	/* device for DMA mapping */
-	struct hnae3_queue q;
-	struct hlcgevf_tqp_stats tqp_stats;
-	u16 index;		/* global index in a NIC controller */
-
-	bool alloced;
-};
-
 struct hclgevf_cfg {
 	u8 tc_num;
 	u16 tqp_desc_num;
@@ -270,7 +254,7 @@ struct hclgevf_dev {
 
 	struct delayed_work service_task;
 
-	struct hclgevf_tqp *htqp;
+	struct hclge_comm_tqp *htqp;
 
 	struct hnae3_handle nic;
 	struct hnae3_handle roce;
-- 
2.33.0

