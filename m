Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A97461782
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349660AbhK2OKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:10:38 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16318 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240354AbhK2OIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:08:30 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J2nCr1XJmz91SM;
        Mon, 29 Nov 2021 22:04:40 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:06 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:05 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 03/10] net: hns3: refactor two hns3 debugfs functions
Date:   Mon, 29 Nov 2021 22:00:20 +0800
Message-ID: <20211129140027.23036-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211129140027.23036-1-huangguangbin2@huawei.com>
References: <20211129140027.23036-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Use for statement to optimize some print work of function
hclge_dbg_dump_rst_info() and hclge_dbg_dump_mac_enable_status() to
improve code simplicity.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 93 +++++++++----------
 .../hisilicon/hns3/hns3pf/hclge_debugfs.h     |  5 +
 2 files changed, 48 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 4e0a8c2f7c05..65168125c42e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -258,12 +258,29 @@ hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 	return 0;
 }
 
+static const struct hclge_dbg_status_dfx_info hclge_dbg_mac_en_status[] = {
+	{HCLGE_MAC_TX_EN_B,  "mac_trans_en"},
+	{HCLGE_MAC_RX_EN_B,  "mac_rcv_en"},
+	{HCLGE_MAC_PAD_TX_B, "pad_trans_en"},
+	{HCLGE_MAC_PAD_RX_B, "pad_rcv_en"},
+	{HCLGE_MAC_1588_TX_B, "1588_trans_en"},
+	{HCLGE_MAC_1588_RX_B, "1588_rcv_en"},
+	{HCLGE_MAC_APP_LP_B,  "mac_app_loop_en"},
+	{HCLGE_MAC_LINE_LP_B, "mac_line_loop_en"},
+	{HCLGE_MAC_FCS_TX_B,  "mac_fcs_tx_en"},
+	{HCLGE_MAC_RX_OVERSIZE_TRUNCATE_B, "mac_rx_oversize_truncate_en"},
+	{HCLGE_MAC_RX_FCS_STRIP_B, "mac_rx_fcs_strip_en"},
+	{HCLGE_MAC_RX_FCS_B, "mac_rx_fcs_en"},
+	{HCLGE_MAC_TX_UNDER_MIN_ERR_B, "mac_tx_under_min_err_en"},
+	{HCLGE_MAC_TX_OVERSIZE_TRUNCATE_B, "mac_tx_oversize_truncate_en"}
+};
+
 static int  hclge_dbg_dump_mac_enable_status(struct hclge_dev *hdev, char *buf,
 					     int len, int *pos)
 {
 	struct hclge_config_mac_mode_cmd *req;
 	struct hclge_desc desc;
-	u32 loop_en;
+	u32 loop_en, i, offset;
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CONFIG_MAC_MODE, true);
@@ -278,39 +295,12 @@ static int  hclge_dbg_dump_mac_enable_status(struct hclge_dev *hdev, char *buf,
 	req = (struct hclge_config_mac_mode_cmd *)desc.data;
 	loop_en = le32_to_cpu(req->txrx_pad_fcs_loop_en);
 
-	*pos += scnprintf(buf + *pos, len - *pos, "mac_trans_en: %#x\n",
-			  hnae3_get_bit(loop_en, HCLGE_MAC_TX_EN_B));
-	*pos += scnprintf(buf + *pos, len - *pos, "mac_rcv_en: %#x\n",
-			  hnae3_get_bit(loop_en, HCLGE_MAC_RX_EN_B));
-	*pos += scnprintf(buf + *pos, len - *pos, "pad_trans_en: %#x\n",
-			  hnae3_get_bit(loop_en, HCLGE_MAC_PAD_TX_B));
-	*pos += scnprintf(buf + *pos, len - *pos, "pad_rcv_en: %#x\n",
-			  hnae3_get_bit(loop_en, HCLGE_MAC_PAD_RX_B));
-	*pos += scnprintf(buf + *pos, len - *pos, "1588_trans_en: %#x\n",
-			  hnae3_get_bit(loop_en, HCLGE_MAC_1588_TX_B));
-	*pos += scnprintf(buf + *pos, len - *pos, "1588_rcv_en: %#x\n",
-			  hnae3_get_bit(loop_en, HCLGE_MAC_1588_RX_B));
-	*pos += scnprintf(buf + *pos, len - *pos, "mac_app_loop_en: %#x\n",
-			  hnae3_get_bit(loop_en, HCLGE_MAC_APP_LP_B));
-	*pos += scnprintf(buf + *pos, len - *pos, "mac_line_loop_en: %#x\n",
-			  hnae3_get_bit(loop_en, HCLGE_MAC_LINE_LP_B));
-	*pos += scnprintf(buf + *pos, len - *pos, "mac_fcs_tx_en: %#x\n",
-			  hnae3_get_bit(loop_en, HCLGE_MAC_FCS_TX_B));
-	*pos += scnprintf(buf + *pos, len - *pos,
-			  "mac_rx_oversize_truncate_en: %#x\n",
-			  hnae3_get_bit(loop_en,
-					HCLGE_MAC_RX_OVERSIZE_TRUNCATE_B));
-	*pos += scnprintf(buf + *pos, len - *pos, "mac_rx_fcs_strip_en: %#x\n",
-			  hnae3_get_bit(loop_en, HCLGE_MAC_RX_FCS_STRIP_B));
-	*pos += scnprintf(buf + *pos, len - *pos, "mac_rx_fcs_en: %#x\n",
-			  hnae3_get_bit(loop_en, HCLGE_MAC_RX_FCS_B));
-	*pos += scnprintf(buf + *pos, len - *pos,
-			  "mac_tx_under_min_err_en: %#x\n",
-			  hnae3_get_bit(loop_en, HCLGE_MAC_TX_UNDER_MIN_ERR_B));
-	*pos += scnprintf(buf + *pos, len - *pos,
-			  "mac_tx_oversize_truncate_en: %#x\n",
-			  hnae3_get_bit(loop_en,
-					HCLGE_MAC_TX_OVERSIZE_TRUNCATE_B));
+	for (i = 0; i < ARRAY_SIZE(hclge_dbg_mac_en_status); i++) {
+		offset = hclge_dbg_mac_en_status[i].offset;
+		*pos += scnprintf(buf + *pos, len - *pos, "%s: %#x\n",
+				  hclge_dbg_mac_en_status[i].message,
+				  hnae3_get_bit(loop_en, offset));
+	}
 
 	return 0;
 }
@@ -1614,8 +1604,19 @@ static int hclge_dbg_dump_fd_counter(struct hclge_dev *hdev, char *buf, int len)
 	return 0;
 }
 
+static const struct hclge_dbg_status_dfx_info hclge_dbg_rst_info[] = {
+	{HCLGE_MISC_VECTOR_REG_BASE, "vector0 interrupt enable status"},
+	{HCLGE_MISC_RESET_STS_REG,   "reset interrupt source"},
+	{HCLGE_MISC_VECTOR_INT_STS,  "reset interrupt status"},
+	{HCLGE_RAS_PF_OTHER_INT_STS_REG, "RAS interrupt status"},
+	{HCLGE_GLOBAL_RESET_REG,  "hardware reset status"},
+	{HCLGE_NIC_CSQ_DEPTH_REG, "handshake status"},
+	{HCLGE_FUN_RST_ING, "function reset status"}
+};
+
 int hclge_dbg_dump_rst_info(struct hclge_dev *hdev, char *buf, int len)
 {
+	u32 i, offset;
 	int pos = 0;
 
 	pos += scnprintf(buf + pos, len - pos, "PF reset count: %u\n",
@@ -1634,22 +1635,14 @@ int hclge_dbg_dump_rst_info(struct hclge_dev *hdev, char *buf, int len)
 			 hdev->rst_stats.reset_cnt);
 	pos += scnprintf(buf + pos, len - pos, "reset fail count: %u\n",
 			 hdev->rst_stats.reset_fail_cnt);
-	pos += scnprintf(buf + pos, len - pos,
-			 "vector0 interrupt enable status: 0x%x\n",
-			 hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_REG_BASE));
-	pos += scnprintf(buf + pos, len - pos, "reset interrupt source: 0x%x\n",
-			 hclge_read_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG));
-	pos += scnprintf(buf + pos, len - pos, "reset interrupt status: 0x%x\n",
-			 hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS));
-	pos += scnprintf(buf + pos, len - pos, "RAS interrupt status: 0x%x\n",
-			 hclge_read_dev(&hdev->hw,
-					HCLGE_RAS_PF_OTHER_INT_STS_REG));
-	pos += scnprintf(buf + pos, len - pos, "hardware reset status: 0x%x\n",
-			 hclge_read_dev(&hdev->hw, HCLGE_GLOBAL_RESET_REG));
-	pos += scnprintf(buf + pos, len - pos, "handshake status: 0x%x\n",
-			 hclge_read_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG));
-	pos += scnprintf(buf + pos, len - pos, "function reset status: 0x%x\n",
-			 hclge_read_dev(&hdev->hw, HCLGE_FUN_RST_ING));
+
+	for (i = 0; i < ARRAY_SIZE(hclge_dbg_rst_info); i++) {
+		offset = hclge_dbg_rst_info[i].offset;
+		pos += scnprintf(buf + pos, len - pos, "%s: 0x%x\n",
+				 hclge_dbg_rst_info[i].message,
+				 hclge_read_dev(&hdev->hw, offset));
+	}
+
 	pos += scnprintf(buf + pos, len - pos, "hdev state: 0x%lx\n",
 			 hdev->state);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index 5b6018204f92..724052928b88 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -94,6 +94,11 @@ struct hclge_dbg_func {
 			    char *buf, int len);
 };
 
+struct hclge_dbg_status_dfx_info {
+	u32  offset;
+	char message[HCLGE_DBG_MAX_DFX_MSG_LEN];
+};
+
 static const struct hclge_dbg_dfx_message hclge_dbg_bios_common_reg[] = {
 	{false, "Reserved"},
 	{true,	"BP_CPU_STATE"},
-- 
2.33.0

