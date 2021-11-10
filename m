Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED04244C262
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhKJNuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:50:16 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:27195 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhKJNuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:50:15 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Hq5hr6q49z8vFY;
        Wed, 10 Nov 2021 21:45:48 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:25 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:24 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 3/8] net: hns3: fix pfc packet number incorrect after querying pfc parameters
Date:   Wed, 10 Nov 2021 21:42:51 +0800
Message-ID: <20211110134256.25025-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211110134256.25025-1-huangguangbin2@huawei.com>
References: <20211110134256.25025-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently, driver will send command to firmware to query pfc packet number
when user uses dcb tool to get pfc parameters. However, the periodic
service task will also periodically query and record MAC statistics,
including pfc packet number.

As the hardware registers of statistics is cleared after reading, it will
cause pfc packet number of MAC statistics are not correct after using dcb
tool to get pfc parameters.

To fix this problem, when user uses dcb tool to get pfc parameters, driver
updates MAC statistics firstly and then get pfc packet number from MAC
statistics.

Fixes: 64fd2300fcc1 ("net: hns3: add support for querying pfc puase packets statistic")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         | 18 ++---
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  4 +-
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  4 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 68 +++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |  4 +-
 5 files changed, 48 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 91cb578f56b8..90013c131e94 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -286,28 +286,24 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 
 static int hclge_ieee_getpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 {
-	u64 requests[HNAE3_MAX_TC], indications[HNAE3_MAX_TC];
 	struct hclge_vport *vport = hclge_get_vport(h);
 	struct hclge_dev *hdev = vport->back;
 	int ret;
-	u8 i;
 
 	memset(pfc, 0, sizeof(*pfc));
 	pfc->pfc_cap = hdev->pfc_max;
 	pfc->pfc_en = hdev->tm_info.pfc_en;
 
-	ret = hclge_pfc_tx_stats_get(hdev, requests);
-	if (ret)
+	ret = hclge_mac_update_stats(hdev);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to update MAC stats, ret = %d.\n", ret);
 		return ret;
+	}
 
-	ret = hclge_pfc_rx_stats_get(hdev, indications);
-	if (ret)
-		return ret;
+	hclge_pfc_tx_stats_get(hdev, pfc->requests);
+	hclge_pfc_rx_stats_get(hdev, pfc->indications);
 
-	for (i = 0; i < HCLGE_MAX_TC_NUM; i++) {
-		pfc->requests[i] = requests[i];
-		pfc->indications[i] = indications[i];
-	}
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0fc2b81f4712..21aec4e470cf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -26,8 +26,6 @@
 #include "hclge_devlink.h"
 
 #define HCLGE_NAME			"hclge"
-#define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))
-#define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
 
 #define HCLGE_BUF_SIZE_UNIT	256U
 #define HCLGE_BUF_MUL_BY	2
@@ -587,7 +585,7 @@ static int hclge_mac_query_reg_num(struct hclge_dev *hdev, u32 *reg_num)
 	return 0;
 }
 
-static int hclge_mac_update_stats(struct hclge_dev *hdev)
+int hclge_mac_update_stats(struct hclge_dev *hdev)
 {
 	/* The firmware supports the new statistics acquisition method */
 	if (hdev->ae_dev->dev_specs.mac_stats_num)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 21013776de55..3c95c957d1e3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -852,6 +852,9 @@ struct hclge_vf_vlan_cfg {
 		(y) = (_k_ ^ ~_v_) & (_k_); \
 	} while (0)
 
+#define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
+#define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))
+
 #define HCLGE_MAC_TNL_LOG_SIZE	8
 #define HCLGE_VPORT_NUM 256
 struct hclge_dev {
@@ -1166,4 +1169,5 @@ void hclge_inform_vf_promisc_info(struct hclge_vport *vport);
 int hclge_dbg_dump_rst_info(struct hclge_dev *hdev, char *buf, int len);
 int hclge_push_vf_link_status(struct hclge_vport *vport);
 int hclge_enable_vport_vlan_filter(struct hclge_vport *vport, bool request_en);
+int hclge_mac_update_stats(struct hclge_dev *hdev);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 95074e91a846..a50e2edbf4a0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -113,50 +113,50 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 	return 0;
 }
 
-static int hclge_pfc_stats_get(struct hclge_dev *hdev,
-			       enum hclge_opcode_type opcode, u64 *stats)
-{
-	struct hclge_desc desc[HCLGE_TM_PFC_PKT_GET_CMD_NUM];
-	int ret, i, j;
-
-	if (!(opcode == HCLGE_OPC_QUERY_PFC_RX_PKT_CNT ||
-	      opcode == HCLGE_OPC_QUERY_PFC_TX_PKT_CNT))
-		return -EINVAL;
-
-	for (i = 0; i < HCLGE_TM_PFC_PKT_GET_CMD_NUM - 1; i++) {
-		hclge_cmd_setup_basic_desc(&desc[i], opcode, true);
-		desc[i].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-	}
-
-	hclge_cmd_setup_basic_desc(&desc[i], opcode, true);
+static const u16 hclge_pfc_tx_stats_offset[] = {
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri0_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri1_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri2_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri3_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri4_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri5_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri6_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri7_pkt_num)
+};
 
-	ret = hclge_cmd_send(&hdev->hw, desc, HCLGE_TM_PFC_PKT_GET_CMD_NUM);
-	if (ret)
-		return ret;
+static const u16 hclge_pfc_rx_stats_offset[] = {
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri0_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri1_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri2_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri3_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri4_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri5_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri6_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri7_pkt_num)
+};
 
-	for (i = 0; i < HCLGE_TM_PFC_PKT_GET_CMD_NUM; i++) {
-		struct hclge_pfc_stats_cmd *pfc_stats =
-				(struct hclge_pfc_stats_cmd *)desc[i].data;
+static void hclge_pfc_stats_get(struct hclge_dev *hdev, bool tx, u64 *stats)
+{
+	const u16 *offset;
+	int i;
 
-		for (j = 0; j < HCLGE_TM_PFC_NUM_GET_PER_CMD; j++) {
-			u32 index = i * HCLGE_TM_PFC_PKT_GET_CMD_NUM + j;
+	if (tx)
+		offset = hclge_pfc_tx_stats_offset;
+	else
+		offset = hclge_pfc_rx_stats_offset;
 
-			if (index < HCLGE_MAX_TC_NUM)
-				stats[index] =
-					le64_to_cpu(pfc_stats->pkt_num[j]);
-		}
-	}
-	return 0;
+	for (i = 0; i < HCLGE_MAX_TC_NUM; i++)
+		stats[i] = HCLGE_STATS_READ(&hdev->mac_stats, offset[i]);
 }
 
-int hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats)
+void hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats)
 {
-	return hclge_pfc_stats_get(hdev, HCLGE_OPC_QUERY_PFC_RX_PKT_CNT, stats);
+	hclge_pfc_stats_get(hdev, false, stats);
 }
 
-int hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats)
+void hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats)
 {
-	return hclge_pfc_stats_get(hdev, HCLGE_OPC_QUERY_PFC_TX_PKT_CNT, stats);
+	hclge_pfc_stats_get(hdev, true, stats);
 }
 
 int hclge_mac_pause_en_cfg(struct hclge_dev *hdev, bool tx, bool rx)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 2ee9b795f71d..1db7f40b4525 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -228,8 +228,8 @@ int hclge_tm_dwrr_cfg(struct hclge_dev *hdev);
 int hclge_tm_init_hw(struct hclge_dev *hdev, bool init);
 int hclge_mac_pause_en_cfg(struct hclge_dev *hdev, bool tx, bool rx);
 int hclge_pause_addr_cfg(struct hclge_dev *hdev, const u8 *mac_addr);
-int hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats);
-int hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats);
+void hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats);
+void hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats);
 int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate);
 int hclge_tm_get_qset_num(struct hclge_dev *hdev, u16 *qset_num);
 int hclge_tm_get_pri_num(struct hclge_dev *hdev, u8 *pri_num);
-- 
2.33.0

