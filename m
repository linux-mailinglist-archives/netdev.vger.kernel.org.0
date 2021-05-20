Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866EA389B5A
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhETCXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3434 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhETCXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:18 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Flths0M0xzCsVr;
        Thu, 20 May 2021 10:19:09 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:56 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:55 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/15] net: hns3: refactor dump qos buf cfg of debugfs
Date:   Thu, 20 May 2021 10:21:40 +0800
Message-ID: <1621477304-4495-12-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621477304-4495-1-git-send-email-tanhuazhong@huawei.com>
References: <1621477304-4495-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

Currently, user gets qos buffer config by implementing debugfs command
"echo dump qos buf cfg > cmd", this command will dump info in dmesg.
It's unnecessary and heavy.

To optimize it, create a single file "qos_buf_cfg" in tm directory
and use cat command to get info. It will return info to userspace,
rather than record in dmesg.

The display style is below:
$ cat qos_buf_cfg
tx_packet_buf_tc_0: 0x120
tx_packet_buf_tc_1: 0x120
tx_packet_buf_tc_2: 0x120
tx_packet_buf_tc_3: 0x120
tx_packet_buf_tc_4: 0x0
tx_packet_buf_tc_5: 0x0
tx_packet_buf_tc_6: 0x0
tx_packet_buf_tc_7: 0x0
......

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   8 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 186 ++++++++++++---------
 3 files changed, 115 insertions(+), 80 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 16a9943..9af1d64 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -260,6 +260,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_TC_SCH_INFO,
 	HNAE3_DBG_CMD_QOS_PAUSE_CFG,
 	HNAE3_DBG_CMD_QOS_PRI_MAP,
+	HNAE3_DBG_CMD_QOS_BUF_CFG,
 	HNAE3_DBG_CMD_DEV_INFO,
 	HNAE3_DBG_CMD_TX_BD,
 	HNAE3_DBG_CMD_RX_BD,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index e59060b..bd348c1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -107,6 +107,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.init = hns3_dbg_common_file_init,
 	},
 	{
+		.name = "qos_buf_cfg",
+		.cmd = HNAE3_DBG_CMD_QOS_BUF_CFG,
+		.dentry = HNS3_DBG_DENTRY_TM,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
 		.name = "dev_info",
 		.cmd = HNAE3_DBG_CMD_DEV_INFO,
 		.dentry = HNS3_DBG_DENTRY_COMMON,
@@ -759,7 +766,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	if (!hns3_is_phys_func(h->pdev))
 		return;
 
-	dev_info(&h->pdev->dev, "dump qos buf cfg\n");
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
 	dev_info(&h->pdev->dev, "dump qs shaper [qs id]\n");
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 85129a5..45ccb04 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1090,199 +1090,225 @@ static int hclge_dbg_dump_qos_pri_map(struct hclge_dev *hdev, char *buf,
 	return 0;
 }
 
-static int hclge_dbg_dump_tx_buf_cfg(struct hclge_dev *hdev)
+static int hclge_dbg_dump_tx_buf_cfg(struct hclge_dev *hdev, char *buf, int len)
 {
 	struct hclge_tx_buff_alloc_cmd *tx_buf_cmd;
 	struct hclge_desc desc;
+	int pos = 0;
 	int i, ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TX_BUFF_ALLOC, true);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump tx buf, ret = %d\n", ret);
 		return ret;
+	}
 
-	dev_info(&hdev->pdev->dev, "dump qos buf cfg\n");
 	tx_buf_cmd = (struct hclge_tx_buff_alloc_cmd *)desc.data;
 	for (i = 0; i < HCLGE_MAX_TC_NUM; i++)
-		dev_info(&hdev->pdev->dev, "tx_packet_buf_tc_%d: 0x%x\n", i,
-			 le16_to_cpu(tx_buf_cmd->tx_pkt_buff[i]));
+		pos += scnprintf(buf + pos, len - pos,
+				 "tx_packet_buf_tc_%d: 0x%x\n", i,
+				 le16_to_cpu(tx_buf_cmd->tx_pkt_buff[i]));
 
-	return 0;
+	return pos;
 }
 
-static int hclge_dbg_dump_rx_priv_buf_cfg(struct hclge_dev *hdev)
+static int hclge_dbg_dump_rx_priv_buf_cfg(struct hclge_dev *hdev, char *buf,
+					  int len)
 {
 	struct hclge_rx_priv_buff_cmd *rx_buf_cmd;
 	struct hclge_desc desc;
+	int pos = 0;
 	int i, ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RX_PRIV_BUFF_ALLOC, true);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump rx priv buf, ret = %d\n", ret);
 		return ret;
+	}
+
+	pos += scnprintf(buf + pos, len - pos, "\n");
 
-	dev_info(&hdev->pdev->dev, "\n");
 	rx_buf_cmd = (struct hclge_rx_priv_buff_cmd *)desc.data;
 	for (i = 0; i < HCLGE_MAX_TC_NUM; i++)
-		dev_info(&hdev->pdev->dev, "rx_packet_buf_tc_%d: 0x%x\n", i,
-			 le16_to_cpu(rx_buf_cmd->buf_num[i]));
+		pos += scnprintf(buf + pos, len - pos,
+				 "rx_packet_buf_tc_%d: 0x%x\n", i,
+				 le16_to_cpu(rx_buf_cmd->buf_num[i]));
 
-	dev_info(&hdev->pdev->dev, "rx_share_buf: 0x%x\n",
-		 le16_to_cpu(rx_buf_cmd->shared_buf));
+	pos += scnprintf(buf + pos, len - pos, "rx_share_buf: 0x%x\n",
+			 le16_to_cpu(rx_buf_cmd->shared_buf));
 
-	return 0;
+	return pos;
 }
 
-static int hclge_dbg_dump_rx_common_wl_cfg(struct hclge_dev *hdev)
+static int hclge_dbg_dump_rx_common_wl_cfg(struct hclge_dev *hdev, char *buf,
+					   int len)
 {
 	struct hclge_rx_com_wl *rx_com_wl;
 	struct hclge_desc desc;
+	int pos = 0;
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RX_COM_WL_ALLOC, true);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump rx common wl, ret = %d\n", ret);
 		return ret;
+	}
 
 	rx_com_wl = (struct hclge_rx_com_wl *)desc.data;
-	dev_info(&hdev->pdev->dev, "\n");
-	dev_info(&hdev->pdev->dev, "rx_com_wl: high: 0x%x, low: 0x%x\n",
-		 le16_to_cpu(rx_com_wl->com_wl.high),
-		 le16_to_cpu(rx_com_wl->com_wl.low));
+	pos += scnprintf(buf + pos, len - pos, "\n");
+	pos += scnprintf(buf + pos, len - pos,
+			 "rx_com_wl: high: 0x%x, low: 0x%x\n",
+			 le16_to_cpu(rx_com_wl->com_wl.high),
+			 le16_to_cpu(rx_com_wl->com_wl.low));
 
-	return 0;
+	return pos;
 }
 
-static int hclge_dbg_dump_rx_global_pkt_cnt(struct hclge_dev *hdev)
+static int hclge_dbg_dump_rx_global_pkt_cnt(struct hclge_dev *hdev, char *buf,
+					    int len)
 {
 	struct hclge_rx_com_wl *rx_packet_cnt;
 	struct hclge_desc desc;
+	int pos = 0;
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RX_GBL_PKT_CNT, true);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump rx global pkt cnt, ret = %d\n", ret);
 		return ret;
+	}
 
 	rx_packet_cnt = (struct hclge_rx_com_wl *)desc.data;
-	dev_info(&hdev->pdev->dev,
-		 "rx_global_packet_cnt: high: 0x%x, low: 0x%x\n",
-		 le16_to_cpu(rx_packet_cnt->com_wl.high),
-		 le16_to_cpu(rx_packet_cnt->com_wl.low));
+	pos += scnprintf(buf + pos, len - pos,
+			 "rx_global_packet_cnt: high: 0x%x, low: 0x%x\n",
+			 le16_to_cpu(rx_packet_cnt->com_wl.high),
+			 le16_to_cpu(rx_packet_cnt->com_wl.low));
 
-	return 0;
+	return pos;
 }
 
-static int hclge_dbg_dump_rx_priv_wl_buf_cfg(struct hclge_dev *hdev)
+static int hclge_dbg_dump_rx_priv_wl_buf_cfg(struct hclge_dev *hdev, char *buf,
+					     int len)
 {
 	struct hclge_rx_priv_wl_buf *rx_priv_wl;
 	struct hclge_desc desc[2];
+	int pos = 0;
 	int i, ret;
 
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_RX_PRIV_WL_ALLOC, true);
 	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_RX_PRIV_WL_ALLOC, true);
 	ret = hclge_cmd_send(&hdev->hw, desc, 2);
-	if (ret)
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump rx priv wl buf, ret = %d\n", ret);
 		return ret;
+	}
 
 	rx_priv_wl = (struct hclge_rx_priv_wl_buf *)desc[0].data;
 	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
-		dev_info(&hdev->pdev->dev,
+		pos += scnprintf(buf + pos, len - pos,
 			 "rx_priv_wl_tc_%d: high: 0x%x, low: 0x%x\n", i,
 			 le16_to_cpu(rx_priv_wl->tc_wl[i].high),
 			 le16_to_cpu(rx_priv_wl->tc_wl[i].low));
 
 	rx_priv_wl = (struct hclge_rx_priv_wl_buf *)desc[1].data;
 	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
-		dev_info(&hdev->pdev->dev,
+		pos += scnprintf(buf + pos, len - pos,
 			 "rx_priv_wl_tc_%d: high: 0x%x, low: 0x%x\n",
 			 i + HCLGE_TC_NUM_ONE_DESC,
 			 le16_to_cpu(rx_priv_wl->tc_wl[i].high),
 			 le16_to_cpu(rx_priv_wl->tc_wl[i].low));
 
-	return 0;
+	return pos;
 }
 
-static int hclge_dbg_dump_rx_common_threshold_cfg(struct hclge_dev *hdev)
+static int hclge_dbg_dump_rx_common_threshold_cfg(struct hclge_dev *hdev,
+						  char *buf, int len)
 {
 	struct hclge_rx_com_thrd *rx_com_thrd;
 	struct hclge_desc desc[2];
+	int pos = 0;
 	int i, ret;
 
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_RX_COM_THRD_ALLOC, true);
 	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_RX_COM_THRD_ALLOC, true);
 	ret = hclge_cmd_send(&hdev->hw, desc, 2);
-	if (ret)
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump rx common threshold, ret = %d\n", ret);
 		return ret;
+	}
 
-	dev_info(&hdev->pdev->dev, "\n");
+	pos += scnprintf(buf + pos, len - pos, "\n");
 	rx_com_thrd = (struct hclge_rx_com_thrd *)desc[0].data;
 	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
-		dev_info(&hdev->pdev->dev,
+		pos += scnprintf(buf + pos, len - pos,
 			 "rx_com_thrd_tc_%d: high: 0x%x, low: 0x%x\n", i,
 			 le16_to_cpu(rx_com_thrd->com_thrd[i].high),
 			 le16_to_cpu(rx_com_thrd->com_thrd[i].low));
 
 	rx_com_thrd = (struct hclge_rx_com_thrd *)desc[1].data;
 	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
-		dev_info(&hdev->pdev->dev,
+		pos += scnprintf(buf + pos, len - pos,
 			 "rx_com_thrd_tc_%d: high: 0x%x, low: 0x%x\n",
 			 i + HCLGE_TC_NUM_ONE_DESC,
 			 le16_to_cpu(rx_com_thrd->com_thrd[i].high),
 			 le16_to_cpu(rx_com_thrd->com_thrd[i].low));
 
-	return 0;
+	return pos;
 }
 
-static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
+static int hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev, char *buf,
+				      int len)
 {
-	enum hclge_opcode_type cmd;
+	int pos = 0;
 	int ret;
 
-	cmd = HCLGE_OPC_TX_BUFF_ALLOC;
-	ret = hclge_dbg_dump_tx_buf_cfg(hdev);
-	if (ret)
-		goto err_qos_cmd_send;
-
-	cmd = HCLGE_OPC_RX_PRIV_BUFF_ALLOC;
-	ret = hclge_dbg_dump_rx_priv_buf_cfg(hdev);
-	if (ret)
-		goto err_qos_cmd_send;
+	ret = hclge_dbg_dump_tx_buf_cfg(hdev, buf + pos, len - pos);
+	if (ret < 0)
+		return ret;
+	pos += ret;
 
-	cmd = HCLGE_OPC_RX_COM_WL_ALLOC;
-	ret = hclge_dbg_dump_rx_common_wl_cfg(hdev);
-	if (ret)
-		goto err_qos_cmd_send;
+	ret = hclge_dbg_dump_rx_priv_buf_cfg(hdev, buf + pos, len - pos);
+	if (ret < 0)
+		return ret;
+	pos += ret;
 
-	cmd = HCLGE_OPC_RX_GBL_PKT_CNT;
-	ret = hclge_dbg_dump_rx_global_pkt_cnt(hdev);
-	if (ret)
-		goto err_qos_cmd_send;
+	ret = hclge_dbg_dump_rx_common_wl_cfg(hdev, buf + pos, len - pos);
+	if (ret < 0)
+		return ret;
+	pos += ret;
 
-	dev_info(&hdev->pdev->dev, "\n");
-	if (!hnae3_dev_dcb_supported(hdev)) {
-		dev_info(&hdev->pdev->dev,
-			 "Only DCB-supported dev supports rx priv wl\n");
-		return;
-	}
+	ret = hclge_dbg_dump_rx_global_pkt_cnt(hdev, buf + pos, len - pos);
+	if (ret < 0)
+		return ret;
+	pos += ret;
 
-	cmd = HCLGE_OPC_RX_PRIV_WL_ALLOC;
-	ret = hclge_dbg_dump_rx_priv_wl_buf_cfg(hdev);
-	if (ret)
-		goto err_qos_cmd_send;
+	pos += scnprintf(buf + pos, len - pos, "\n");
+	if (!hnae3_dev_dcb_supported(hdev))
+		return 0;
 
-	cmd = HCLGE_OPC_RX_COM_THRD_ALLOC;
-	ret = hclge_dbg_dump_rx_common_threshold_cfg(hdev);
-	if (ret)
-		goto err_qos_cmd_send;
+	ret = hclge_dbg_dump_rx_priv_wl_buf_cfg(hdev, buf + pos, len - pos);
+	if (ret < 0)
+		return ret;
+	pos += ret;
 
-	return;
+	ret = hclge_dbg_dump_rx_common_threshold_cfg(hdev, buf + pos,
+						     len - pos);
+	if (ret < 0)
+		return ret;
 
-err_qos_cmd_send:
-	dev_err(&hdev->pdev->dev,
-		"dump qos buf cfg fail(0x%x), ret = %d\n", cmd, ret);
+	return 0;
 }
 
 static int hclge_dbg_dump_mng_table(struct hclge_dev *hdev, char *buf, int len)
@@ -1905,9 +1931,7 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	if (strncmp(cmd_buf, "dump qos buf cfg", 16) == 0) {
-		hclge_dbg_dump_qos_buf_cfg(hdev);
-	} else if (strncmp(cmd_buf, "dump serv info", 14) == 0) {
+	if (strncmp(cmd_buf, "dump serv info", 14) == 0) {
 		hclge_dbg_dump_serv_info(hdev);
 	} else if (strncmp(cmd_buf, "dump mac tnl status", 19) == 0) {
 		hclge_dbg_dump_mac_tnl_status(hdev);
@@ -1960,6 +1984,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.dbg_dump = hclge_dbg_dump_qos_pri_map,
 	},
 	{
+		.cmd = HNAE3_DBG_CMD_QOS_BUF_CFG,
+		.dbg_dump = hclge_dbg_dump_qos_buf_cfg,
+	},
+	{
 		.cmd = HNAE3_DBG_CMD_MAC_UC,
 		.dbg_dump = hclge_dbg_dump_mac_uc,
 	},
-- 
2.7.4

