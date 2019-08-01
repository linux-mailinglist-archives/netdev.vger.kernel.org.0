Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9DF7D432
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfHAD6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:58:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3726 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729729AbfHAD54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:57:56 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8736AE12EC4248C4A326;
        Thu,  1 Aug 2019 11:57:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 11:57:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/12] net: hns3: do not query unsupported commands in debugfs
Date:   Thu, 1 Aug 2019 11:55:36 +0800
Message-ID: <1564631745-36733-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
References: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Some commands are not supported on DCB-unsupported ports.
This patch distinguishes these commands and does not query
unsupported commands in debugfs.

This patch also fix an error in the dump "qos buf cfg"
command in debugfs.

Fixes: 2849d4e7a1be ("net: hns3: Add "tc config" info query function")
Fixes: 7d9d7f8864ba ("net: hns3: Add "qos buffer" config info query function")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 70 ++++++++++++++--------
 1 file changed, 46 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index ab625c7..e987d18 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -325,6 +325,12 @@ static void hclge_dbg_dump_tc(struct hclge_dev *hdev)
 	struct hclge_desc desc;
 	int i, ret;
 
+	if (!hnae3_dev_dcb_supported(hdev)) {
+		dev_info(&hdev->pdev->dev,
+			 "Only DCB-supported dev supports tc\n");
+		return;
+	}
+
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_ETS_TC_WEIGHT, true);
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
@@ -409,6 +415,12 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 
 	dev_info(&hdev->pdev->dev, "QS_SCH qs_id: %u\n", desc.data[0]);
 
+	if (!hnae3_dev_dcb_supported(hdev)) {
+		dev_info(&hdev->pdev->dev,
+			 "Only DCB-supported dev supports tm mapping\n");
+		return;
+	}
+
 	cmd = HCLGE_OPC_TM_BP_TO_QSET_MAPPING;
 	hclge_cmd_setup_basic_desc(&desc, cmd, true);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
@@ -590,6 +602,12 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 	dev_info(&hdev->pdev->dev, "%04d     | %04d    | %02d     | %02d\n",
 		 queue_id, qset_id, pri_id, tc_id);
 
+	if (!hnae3_dev_dcb_supported(hdev)) {
+		dev_info(&hdev->pdev->dev,
+			 "Only DCB-supported dev supports tm mapping\n");
+		return;
+	}
+
 	cmd = HCLGE_OPC_TM_BP_TO_QSET_MAPPING;
 	bp_to_qs_map_cmd = (struct hclge_bp_to_qs_map_cmd *)desc.data;
 	for (group_id = 0; group_id < 32; group_id++) {
@@ -715,6 +733,34 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 	dev_info(&hdev->pdev->dev, "rx_share_buf: 0x%x\n",
 		 rx_buf_cmd->shared_buf);
 
+	cmd = HCLGE_OPC_RX_COM_WL_ALLOC;
+	hclge_cmd_setup_basic_desc(desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, desc, 1);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	rx_com_wl = (struct hclge_rx_com_wl *)desc[0].data;
+	dev_info(&hdev->pdev->dev, "\n");
+	dev_info(&hdev->pdev->dev, "rx_com_wl: high: 0x%x, low: 0x%x\n",
+		 rx_com_wl->com_wl.high, rx_com_wl->com_wl.low);
+
+	cmd = HCLGE_OPC_RX_GBL_PKT_CNT;
+	hclge_cmd_setup_basic_desc(desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, desc, 1);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	rx_packet_cnt = (struct hclge_rx_com_wl *)desc[0].data;
+	dev_info(&hdev->pdev->dev,
+		 "rx_global_packet_cnt: high: 0x%x, low: 0x%x\n",
+		 rx_packet_cnt->com_wl.high, rx_packet_cnt->com_wl.low);
+	dev_info(&hdev->pdev->dev, "\n");
+
+	if (!hnae3_dev_dcb_supported(hdev)) {
+		dev_info(&hdev->pdev->dev,
+			 "Only DCB-supported dev supports rx priv wl\n");
+		return;
+	}
 	cmd = HCLGE_OPC_RX_PRIV_WL_ALLOC;
 	hclge_cmd_setup_basic_desc(&desc[0], cmd, true);
 	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
@@ -723,7 +769,6 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 	if (ret)
 		goto err_qos_cmd_send;
 
-	dev_info(&hdev->pdev->dev, "\n");
 	rx_priv_wl = (struct hclge_rx_priv_wl_buf *)desc[0].data;
 	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
 		dev_info(&hdev->pdev->dev,
@@ -758,29 +803,6 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 			 "rx_com_thrd_tc_%d: high: 0x%x, low: 0x%x\n", i + 4,
 			 rx_com_thrd->com_thrd[i].high,
 			 rx_com_thrd->com_thrd[i].low);
-
-	cmd = HCLGE_OPC_RX_COM_WL_ALLOC;
-	hclge_cmd_setup_basic_desc(desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, desc, 1);
-	if (ret)
-		goto err_qos_cmd_send;
-
-	rx_com_wl = (struct hclge_rx_com_wl *)desc[0].data;
-	dev_info(&hdev->pdev->dev, "\n");
-	dev_info(&hdev->pdev->dev, "rx_com_wl: high: 0x%x, low: 0x%x\n",
-		 rx_com_wl->com_wl.high, rx_com_wl->com_wl.low);
-
-	cmd = HCLGE_OPC_RX_GBL_PKT_CNT;
-	hclge_cmd_setup_basic_desc(desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, desc, 1);
-	if (ret)
-		goto err_qos_cmd_send;
-
-	rx_packet_cnt = (struct hclge_rx_com_wl *)desc[0].data;
-	dev_info(&hdev->pdev->dev,
-		 "rx_global_packet_cnt: high: 0x%x, low: 0x%x\n",
-		 rx_packet_cnt->com_wl.high, rx_packet_cnt->com_wl.low);
-
 	return;
 
 err_qos_cmd_send:
-- 
2.7.4

