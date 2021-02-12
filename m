Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690DE3198BA
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhBLDX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:23:28 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12517 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhBLDXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:23:10 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DcJfP5cQMzjMHj;
        Fri, 12 Feb 2021 11:20:29 +0800 (CST)
Received: from SZA170332453E.china.huawei.com (10.46.104.160) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Feb 2021 11:21:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 08/13] net: hns3: split out hclge_dbg_dump_qos_buf_cfg()
Date:   Fri, 12 Feb 2021 11:21:08 +0800
Message-ID: <20210212032113.5384-9-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20210212032113.5384-1-tanhuazhong@huawei.com>
References: <20210212032113.5384-1-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.46.104.160]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

hclge_dbg_dump_qos_buf_cfg() is bloated, so split it into
separate functions for readability and maintainability.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 158 +++++++++++++-----
 1 file changed, 115 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index a0a33c02ce25..6b1d197df881 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -984,39 +984,39 @@ static void hclge_dbg_dump_qos_pri_map(struct hclge_dev *hdev)
 	dev_info(&hdev->pdev->dev, "pri_7_to_tc: 0x%x\n", pri_map->pri7_tc);
 }
 
-static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
+static int hclge_dbg_dump_tx_buf_cfg(struct hclge_dev *hdev)
 {
 	struct hclge_tx_buff_alloc_cmd *tx_buf_cmd;
-	struct hclge_rx_priv_buff_cmd *rx_buf_cmd;
-	struct hclge_rx_priv_wl_buf *rx_priv_wl;
-	struct hclge_rx_com_wl *rx_packet_cnt;
-	struct hclge_rx_com_thrd *rx_com_thrd;
-	struct hclge_rx_com_wl *rx_com_wl;
-	enum hclge_opcode_type cmd;
-	struct hclge_desc desc[2];
+	struct hclge_desc desc;
 	int i, ret;
 
-	cmd = HCLGE_OPC_TX_BUFF_ALLOC;
-	hclge_cmd_setup_basic_desc(desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, desc, 1);
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TX_BUFF_ALLOC, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
-		goto err_qos_cmd_send;
+		return ret;
 
 	dev_info(&hdev->pdev->dev, "dump qos buf cfg\n");
-
-	tx_buf_cmd = (struct hclge_tx_buff_alloc_cmd *)desc[0].data;
+	tx_buf_cmd = (struct hclge_tx_buff_alloc_cmd *)desc.data;
 	for (i = 0; i < HCLGE_MAX_TC_NUM; i++)
 		dev_info(&hdev->pdev->dev, "tx_packet_buf_tc_%d: 0x%x\n", i,
 			 le16_to_cpu(tx_buf_cmd->tx_pkt_buff[i]));
 
-	cmd = HCLGE_OPC_RX_PRIV_BUFF_ALLOC;
-	hclge_cmd_setup_basic_desc(desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, desc, 1);
+	return 0;
+}
+
+static int hclge_dbg_dump_rx_priv_buf_cfg(struct hclge_dev *hdev)
+{
+	struct hclge_rx_priv_buff_cmd *rx_buf_cmd;
+	struct hclge_desc desc;
+	int i, ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RX_PRIV_BUFF_ALLOC, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
-		goto err_qos_cmd_send;
+		return ret;
 
 	dev_info(&hdev->pdev->dev, "\n");
-	rx_buf_cmd = (struct hclge_rx_priv_buff_cmd *)desc[0].data;
+	rx_buf_cmd = (struct hclge_rx_priv_buff_cmd *)desc.data;
 	for (i = 0; i < HCLGE_MAX_TC_NUM; i++)
 		dev_info(&hdev->pdev->dev, "rx_packet_buf_tc_%d: 0x%x\n", i,
 			 le16_to_cpu(rx_buf_cmd->buf_num[i]));
@@ -1024,43 +1024,61 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 	dev_info(&hdev->pdev->dev, "rx_share_buf: 0x%x\n",
 		 le16_to_cpu(rx_buf_cmd->shared_buf));
 
-	cmd = HCLGE_OPC_RX_COM_WL_ALLOC;
-	hclge_cmd_setup_basic_desc(desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, desc, 1);
+	return 0;
+}
+
+static int hclge_dbg_dump_rx_common_wl_cfg(struct hclge_dev *hdev)
+{
+	struct hclge_rx_com_wl *rx_com_wl;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RX_COM_WL_ALLOC, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
-		goto err_qos_cmd_send;
+		return ret;
 
-	rx_com_wl = (struct hclge_rx_com_wl *)desc[0].data;
+	rx_com_wl = (struct hclge_rx_com_wl *)desc.data;
 	dev_info(&hdev->pdev->dev, "\n");
 	dev_info(&hdev->pdev->dev, "rx_com_wl: high: 0x%x, low: 0x%x\n",
 		 le16_to_cpu(rx_com_wl->com_wl.high),
 		 le16_to_cpu(rx_com_wl->com_wl.low));
 
-	cmd = HCLGE_OPC_RX_GBL_PKT_CNT;
-	hclge_cmd_setup_basic_desc(desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, desc, 1);
+	return 0;
+}
+
+static int hclge_dbg_dump_rx_global_pkt_cnt(struct hclge_dev *hdev)
+{
+	struct hclge_rx_com_wl *rx_packet_cnt;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RX_GBL_PKT_CNT, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
-		goto err_qos_cmd_send;
+		return ret;
 
-	rx_packet_cnt = (struct hclge_rx_com_wl *)desc[0].data;
+	rx_packet_cnt = (struct hclge_rx_com_wl *)desc.data;
 	dev_info(&hdev->pdev->dev,
 		 "rx_global_packet_cnt: high: 0x%x, low: 0x%x\n",
 		 le16_to_cpu(rx_packet_cnt->com_wl.high),
 		 le16_to_cpu(rx_packet_cnt->com_wl.low));
-	dev_info(&hdev->pdev->dev, "\n");
 
-	if (!hnae3_dev_dcb_supported(hdev)) {
-		dev_info(&hdev->pdev->dev,
-			 "Only DCB-supported dev supports rx priv wl\n");
-		return;
-	}
-	cmd = HCLGE_OPC_RX_PRIV_WL_ALLOC;
-	hclge_cmd_setup_basic_desc(&desc[0], cmd, true);
+	return 0;
+}
+
+static int hclge_dbg_dump_rx_priv_wl_buf_cfg(struct hclge_dev *hdev)
+{
+	struct hclge_rx_priv_wl_buf *rx_priv_wl;
+	struct hclge_desc desc[2];
+	int i, ret;
+
+	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_RX_PRIV_WL_ALLOC, true);
 	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-	hclge_cmd_setup_basic_desc(&desc[1], cmd, true);
+	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_RX_PRIV_WL_ALLOC, true);
 	ret = hclge_cmd_send(&hdev->hw, desc, 2);
 	if (ret)
-		goto err_qos_cmd_send;
+		return ret;
 
 	rx_priv_wl = (struct hclge_rx_priv_wl_buf *)desc[0].data;
 	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
@@ -1077,13 +1095,21 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 			 le16_to_cpu(rx_priv_wl->tc_wl[i].high),
 			 le16_to_cpu(rx_priv_wl->tc_wl[i].low));
 
-	cmd = HCLGE_OPC_RX_COM_THRD_ALLOC;
-	hclge_cmd_setup_basic_desc(&desc[0], cmd, true);
+	return 0;
+}
+
+static int hclge_dbg_dump_rx_common_threshold_cfg(struct hclge_dev *hdev)
+{
+	struct hclge_rx_com_thrd *rx_com_thrd;
+	struct hclge_desc desc[2];
+	int i, ret;
+
+	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_RX_COM_THRD_ALLOC, true);
 	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-	hclge_cmd_setup_basic_desc(&desc[1], cmd, true);
+	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_RX_COM_THRD_ALLOC, true);
 	ret = hclge_cmd_send(&hdev->hw, desc, 2);
 	if (ret)
-		goto err_qos_cmd_send;
+		return ret;
 
 	dev_info(&hdev->pdev->dev, "\n");
 	rx_com_thrd = (struct hclge_rx_com_thrd *)desc[0].data;
@@ -1100,6 +1126,52 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 			 i + HCLGE_TC_NUM_ONE_DESC,
 			 le16_to_cpu(rx_com_thrd->com_thrd[i].high),
 			 le16_to_cpu(rx_com_thrd->com_thrd[i].low));
+
+	return 0;
+}
+
+static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
+{
+	enum hclge_opcode_type cmd;
+	int ret;
+
+	cmd = HCLGE_OPC_TX_BUFF_ALLOC;
+	ret = hclge_dbg_dump_tx_buf_cfg(hdev);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	cmd = HCLGE_OPC_RX_PRIV_BUFF_ALLOC;
+	ret = hclge_dbg_dump_rx_priv_buf_cfg(hdev);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	cmd = HCLGE_OPC_RX_COM_WL_ALLOC;
+	ret = hclge_dbg_dump_rx_common_wl_cfg(hdev);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	cmd = HCLGE_OPC_RX_GBL_PKT_CNT;
+	ret = hclge_dbg_dump_rx_global_pkt_cnt(hdev);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	dev_info(&hdev->pdev->dev, "\n");
+	if (!hnae3_dev_dcb_supported(hdev)) {
+		dev_info(&hdev->pdev->dev,
+			 "Only DCB-supported dev supports rx priv wl\n");
+		return;
+	}
+
+	cmd = HCLGE_OPC_RX_PRIV_WL_ALLOC;
+	ret = hclge_dbg_dump_rx_priv_wl_buf_cfg(hdev);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	cmd = HCLGE_OPC_RX_COM_THRD_ALLOC;
+	ret = hclge_dbg_dump_rx_common_threshold_cfg(hdev);
+	if (ret)
+		goto err_qos_cmd_send;
+
 	return;
 
 err_qos_cmd_send:
-- 
2.25.1

