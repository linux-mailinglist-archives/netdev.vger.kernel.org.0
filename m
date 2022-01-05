Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA511485465
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbiAEOZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:38 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:31144 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240696AbiAEOZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:21 -0500
Received: from kwepemi100008.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JTWsb3YDlzRhf1;
        Wed,  5 Jan 2022 22:22:43 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100008.china.huawei.com (7.221.188.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:18 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 13/15] net: hns3: refactor PF tqp stats APIs with new common tqp stats APIs
Date:   Wed, 5 Jan 2022 22:20:13 +0800
Message-ID: <20220105142015.51097-14-huangguangbin2@huawei.com>
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

This patch firstly uses new tqp struct(hclge_comm_tqp) and deletes the
old PF tqp struct(hclge_tqp). All the tqp stats members used in PF module
are modified according to the new hclge_comm_tqp.

Secondly PF tqp stats APIs are refactored to use new common tqp stats APIs.
The old tqp stats APIs in PF are deleted.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 147 ++----------------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  26 +---
 2 files changed, 17 insertions(+), 156 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4d835be1fb2c..24f7afacae02 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -611,111 +611,6 @@ int hclge_mac_update_stats(struct hclge_dev *hdev)
 		return hclge_mac_update_stats_defective(hdev);
 }
 
-static int hclge_tqps_update_stats(struct hnae3_handle *handle)
-{
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
-	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_dev *hdev = vport->back;
-	struct hnae3_queue *queue;
-	struct hclge_desc desc[1];
-	struct hclge_tqp *tqp;
-	int ret, i;
-
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		queue = handle->kinfo.tqp[i];
-		tqp = container_of(queue, struct hclge_tqp, q);
-		/* command : HCLGE_OPC_QUERY_IGU_STAT */
-		hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_QUERY_RX_STATS,
-					   true);
-
-		desc[0].data[0] = cpu_to_le32(tqp->index);
-		ret = hclge_cmd_send(&hdev->hw, desc, 1);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"Query tqp stat fail, status = %d,queue = %d\n",
-				ret, i);
-			return ret;
-		}
-		tqp->tqp_stats.rcb_rx_ring_pktnum_rcd +=
-			le32_to_cpu(desc[0].data[1]);
-	}
-
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		queue = handle->kinfo.tqp[i];
-		tqp = container_of(queue, struct hclge_tqp, q);
-		/* command : HCLGE_OPC_QUERY_IGU_STAT */
-		hclge_cmd_setup_basic_desc(&desc[0],
-					   HCLGE_OPC_QUERY_TX_STATS,
-					   true);
-
-		desc[0].data[0] = cpu_to_le32(tqp->index);
-		ret = hclge_cmd_send(&hdev->hw, desc, 1);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"Query tqp stat fail, status = %d,queue = %d\n",
-				ret, i);
-			return ret;
-		}
-		tqp->tqp_stats.rcb_tx_ring_pktnum_rcd +=
-			le32_to_cpu(desc[0].data[1]);
-	}
-
-	return 0;
-}
-
-static u64 *hclge_tqps_get_stats(struct hnae3_handle *handle, u64 *data)
-{
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
-	struct hclge_tqp *tqp;
-	u64 *buff = data;
-	int i;
-
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		tqp = container_of(kinfo->tqp[i], struct hclge_tqp, q);
-		*buff++ = tqp->tqp_stats.rcb_tx_ring_pktnum_rcd;
-	}
-
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		tqp = container_of(kinfo->tqp[i], struct hclge_tqp, q);
-		*buff++ = tqp->tqp_stats.rcb_rx_ring_pktnum_rcd;
-	}
-
-	return buff;
-}
-
-static int hclge_tqps_get_sset_count(struct hnae3_handle *handle, int stringset)
-{
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
-
-	/* each tqp has TX & RX two queues */
-	return kinfo->num_tqps * (2);
-}
-
-static u8 *hclge_tqps_get_strings(struct hnae3_handle *handle, u8 *data)
-{
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
-	u8 *buff = data;
-	int i;
-
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		struct hclge_tqp *tqp = container_of(handle->kinfo.tqp[i],
-			struct hclge_tqp, q);
-		snprintf(buff, ETH_GSTRING_LEN, "txq%u_pktnum_rcd",
-			 tqp->index);
-		buff = buff + ETH_GSTRING_LEN;
-	}
-
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		struct hclge_tqp *tqp = container_of(kinfo->tqp[i],
-			struct hclge_tqp, q);
-		snprintf(buff, ETH_GSTRING_LEN, "rxq%u_pktnum_rcd",
-			 tqp->index);
-		buff = buff + ETH_GSTRING_LEN;
-	}
-
-	return buff;
-}
-
 static int hclge_comm_get_count(struct hclge_dev *hdev,
 				const struct hclge_comm_stats_str strs[],
 				u32 size)
@@ -776,7 +671,7 @@ static void hclge_update_stats_for_all(struct hclge_dev *hdev)
 
 	handle = &hdev->vport[0].nic;
 	if (handle->client) {
-		status = hclge_tqps_update_stats(handle);
+		status = hclge_comm_tqps_update_stats(handle, &hdev->hw.hw);
 		if (status) {
 			dev_err(&hdev->pdev->dev,
 				"Update TQPS stats fail, status = %d.\n",
@@ -806,7 +701,7 @@ static void hclge_update_stats(struct hnae3_handle *handle,
 			"Update MAC stats fail, status = %d.\n",
 			status);
 
-	status = hclge_tqps_update_stats(handle);
+	status = hclge_comm_tqps_update_stats(handle, &hdev->hw.hw);
 	if (status)
 		dev_err(&hdev->pdev->dev,
 			"Update TQPS stats fail, status = %d.\n",
@@ -855,7 +750,7 @@ static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 	} else if (stringset == ETH_SS_STATS) {
 		count = hclge_comm_get_count(hdev, g_mac_stats_string,
 					     ARRAY_SIZE(g_mac_stats_string)) +
-			hclge_tqps_get_sset_count(handle, stringset);
+			hclge_comm_tqps_get_sset_count(handle);
 	}
 
 	return count;
@@ -873,7 +768,7 @@ static void hclge_get_strings(struct hnae3_handle *handle, u32 stringset,
 		size = ARRAY_SIZE(g_mac_stats_string);
 		p = hclge_comm_get_strings(hdev, stringset, g_mac_stats_string,
 					   size, p);
-		p = hclge_tqps_get_strings(handle, p);
+		p = hclge_comm_tqps_get_strings(handle, p);
 	} else if (stringset == ETH_SS_TEST) {
 		if (handle->flags & HNAE3_SUPPORT_APP_LOOPBACK) {
 			memcpy(p, hns3_nic_test_strs[HNAE3_LOOP_APP],
@@ -907,7 +802,7 @@ static void hclge_get_stats(struct hnae3_handle *handle, u64 *data)
 
 	p = hclge_comm_get_stats(hdev, g_mac_stats_string,
 				 ARRAY_SIZE(g_mac_stats_string), data);
-	p = hclge_tqps_get_stats(handle, p);
+	p = hclge_comm_tqps_get_stats(handle, p);
 }
 
 static void hclge_get_mac_stat(struct hnae3_handle *handle,
@@ -1748,11 +1643,11 @@ static int hclge_config_gro(struct hclge_dev *hdev)
 
 static int hclge_alloc_tqps(struct hclge_dev *hdev)
 {
-	struct hclge_tqp *tqp;
+	struct hclge_comm_tqp *tqp;
 	int i;
 
 	hdev->htqp = devm_kcalloc(&hdev->pdev->dev, hdev->num_tqps,
-				  sizeof(struct hclge_tqp), GFP_KERNEL);
+				  sizeof(struct hclge_comm_tqp), GFP_KERNEL);
 	if (!hdev->htqp)
 		return -ENOMEM;
 
@@ -1876,8 +1771,8 @@ static int hclge_map_tqp_to_vport(struct hclge_dev *hdev,
 
 	kinfo = &nic->kinfo;
 	for (i = 0; i < vport->alloc_tqps; i++) {
-		struct hclge_tqp *q =
-			container_of(kinfo->tqp[i], struct hclge_tqp, q);
+		struct hclge_comm_tqp *q =
+			container_of(kinfo->tqp[i], struct hclge_comm_tqp, q);
 		bool is_pf;
 		int ret;
 
@@ -7869,22 +7764,6 @@ static int hclge_set_default_loopback(struct hclge_dev *hdev)
 					 HNAE3_LOOP_PARALLEL_SERDES);
 }
 
-static void hclge_reset_tqp_stats(struct hnae3_handle *handle)
-{
-	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hnae3_knic_private_info *kinfo;
-	struct hnae3_queue *queue;
-	struct hclge_tqp *tqp;
-	int i;
-
-	kinfo = &vport->nic.kinfo;
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		queue = handle->kinfo.tqp[i];
-		tqp = container_of(queue, struct hclge_tqp, q);
-		memset(&tqp->tqp_stats, 0, sizeof(tqp->tqp_stats));
-	}
-}
-
 static void hclge_flush_link_update(struct hclge_dev *hdev)
 {
 #define HCLGE_FLUSH_LINK_TIMEOUT	100000
@@ -7926,7 +7805,7 @@ static int hclge_ae_start(struct hnae3_handle *handle)
 	hdev->hw.mac.link = 0;
 
 	/* reset tqp stats */
-	hclge_reset_tqp_stats(handle);
+	hclge_comm_reset_tqp_stats(handle);
 
 	hclge_mac_start_phy(hdev);
 
@@ -7964,7 +7843,7 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
 	hclge_mac_stop_phy(hdev);
 
 	/* reset tqp stats */
-	hclge_reset_tqp_stats(handle);
+	hclge_comm_reset_tqp_stats(handle);
 	hclge_update_link_status(hdev);
 }
 
@@ -10577,11 +10456,11 @@ static int hclge_get_reset_status(struct hclge_dev *hdev, u16 queue_id,
 
 u16 hclge_covert_handle_qid_global(struct hnae3_handle *handle, u16 queue_id)
 {
+	struct hclge_comm_tqp *tqp;
 	struct hnae3_queue *queue;
-	struct hclge_tqp *tqp;
 
 	queue = handle->kinfo.tqp[queue_id];
-	tqp = container_of(queue, struct hclge_tqp, q);
+	tqp = container_of(queue, struct hclge_comm_tqp, q);
 
 	return tqp->index;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index d4436d593350..adfb26e79262 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -14,6 +14,7 @@
 #include "hclge_ptp.h"
 #include "hnae3.h"
 #include "hclge_comm_rss.h"
+#include "hclge_comm_tqp_stats.h"
 
 #define HCLGE_MOD_VERSION "1.0"
 #define HCLGE_DRIVER_NAME "hclge"
@@ -270,26 +271,6 @@ struct hclge_hw {
 	int num_vec;
 };
 
-/* TQP stats */
-struct hlcge_tqp_stats {
-	/* query_tqp_tx_queue_statistics ,opcode id:  0x0B03 */
-	u64 rcb_tx_ring_pktnum_rcd; /* 32bit */
-	/* query_tqp_rx_queue_statistics ,opcode id:  0x0B13 */
-	u64 rcb_rx_ring_pktnum_rcd; /* 32bit */
-};
-
-struct hclge_tqp {
-	/* copy of device pointer from pci_dev,
-	 * used when perform DMA mapping
-	 */
-	struct device *dev;
-	struct hnae3_queue q;
-	struct hlcge_tqp_stats tqp_stats;
-	u16 index;	/* Global index in a NIC controller */
-
-	bool alloced;
-};
-
 enum hclge_fc_mode {
 	HCLGE_FC_NONE,
 	HCLGE_FC_RX_PAUSE,
@@ -894,7 +875,7 @@ struct hclge_dev {
 	bool cur_promisc;
 	int num_alloc_vfs;	/* Actual number of VFs allocated */
 
-	struct hclge_tqp *htqp;
+	struct hclge_comm_tqp *htqp;
 	struct hclge_vport *vport;
 
 	struct dentry *hclge_dbgfs;
@@ -1073,7 +1054,8 @@ int hclge_bind_ring_with_vector(struct hclge_vport *vport,
 
 static inline int hclge_get_queue_id(struct hnae3_queue *queue)
 {
-	struct hclge_tqp *tqp = container_of(queue, struct hclge_tqp, q);
+	struct hclge_comm_tqp *tqp =
+			container_of(queue, struct hclge_comm_tqp, q);
 
 	return tqp->index;
 }
-- 
2.33.0

