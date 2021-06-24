Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4303B319B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhFXOmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:42:33 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8439 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhFXOma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:42:30 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G9jQ61kyTzZl9r;
        Thu, 24 Jun 2021 22:37:02 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 24 Jun 2021 22:40:04 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 24 Jun 2021 22:40:03 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/3] net: hns3: add support for FD counter in debugfs
Date:   Thu, 24 Jun 2021 22:36:43 +0800
Message-ID: <1624545405-37050-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1624545405-37050-1-git-send-email-huangguangbin2@huawei.com>
References: <1624545405-37050-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Previously, the flow director counter is not enabled. To improve the
maintainability for chechking whether flow director hit or not, enable
flow director counter for each function, and add debugfs query inerface
to query the counters for each function.

The debugfs command is below:
cat fd_counter
func_id    hit_times
pf         0
vf0        0
vf1        0

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  7 ++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  9 ++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 37 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 10 ++++--
 5 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 0b202f4def83..a6ef67e47c8a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -290,6 +290,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_RX_QUEUE_INFO,
 	HNAE3_DBG_CMD_TX_QUEUE_INFO,
 	HNAE3_DBG_CMD_FD_TCAM,
+	HNAE3_DBG_CMD_FD_COUNTER,
 	HNAE3_DBG_CMD_MAC_TNL_STATUS,
 	HNAE3_DBG_CMD_SERV_INFO,
 	HNAE3_DBG_CMD_UNKNOWN,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 34b6cd904a1a..b72fdb94df63 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -323,6 +323,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "fd_counter",
+		.cmd = HNAE3_DBG_CMD_FD_COUNTER,
+		.dentry = HNS3_DBG_DENTRY_FD,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index a322dfeba5cf..18bde77ef944 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -248,6 +248,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_FD_KEY_CONFIG		= 0x1202,
 	HCLGE_OPC_FD_TCAM_OP		= 0x1203,
 	HCLGE_OPC_FD_AD_OP		= 0x1204,
+	HCLGE_OPC_FD_CNT_OP		= 0x1205,
 	HCLGE_OPC_FD_USER_DEF_OP	= 0x1207,
 
 	/* MDIO command */
@@ -1109,6 +1110,14 @@ struct hclge_fd_ad_config_cmd {
 	u8 rsv2[8];
 };
 
+struct hclge_fd_ad_cnt_read_cmd {
+	u8 rsv0[4];
+	__le16 index;
+	u8 rsv1[2];
+	__le64 cnt;
+	u8 rsv2[8];
+};
+
 #define HCLGE_FD_USER_DEF_OFT_S		0
 #define HCLGE_FD_USER_DEF_OFT_M		GENMASK(14, 0)
 #define HCLGE_FD_USER_DEF_EN_B		15
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 6fc50d09b9db..b69c54d365a7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1549,6 +1549,39 @@ static int hclge_dbg_dump_fd_tcam(struct hclge_dev *hdev, char *buf, int len)
 	return ret;
 }
 
+static int hclge_dbg_dump_fd_counter(struct hclge_dev *hdev, char *buf, int len)
+{
+	u8 func_num = pci_num_vf(hdev->pdev) + 1; /* pf and enabled vf num */
+	struct hclge_fd_ad_cnt_read_cmd *req;
+	char str_id[HCLGE_DBG_ID_LEN];
+	struct hclge_desc desc;
+	int pos = 0;
+	int ret;
+	u64 cnt;
+	u8 i;
+
+	pos += scnprintf(buf + pos, len - pos,
+			 "func_id\thit_times\n");
+
+	for (i = 0; i < func_num; i++) {
+		hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_FD_CNT_OP, true);
+		req = (struct hclge_fd_ad_cnt_read_cmd *)desc.data;
+		req->index = cpu_to_le16(i);
+		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+		if (ret) {
+			dev_err(&hdev->pdev->dev, "failed to get fd counter, ret = %d\n",
+				ret);
+			return ret;
+		}
+		cnt = le64_to_cpu(req->cnt);
+		hclge_dbg_get_func_id_str(str_id, i);
+		pos += scnprintf(buf + pos, len - pos,
+				 "%s\t%llu\n", str_id, cnt);
+	}
+
+	return 0;
+}
+
 int hclge_dbg_dump_rst_info(struct hclge_dev *hdev, char *buf, int len)
 {
 	int pos = 0;
@@ -2375,6 +2408,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_VLAN_CONFIG,
 		.dbg_dump = hclge_dbg_dump_vlan_config,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_FD_COUNTER,
+		.dbg_dump = hclge_dbg_dump_fd_counter,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f3e482ab3c71..dd3354a57c62 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6000,8 +6000,14 @@ static int hclge_config_action(struct hclge_dev *hdev, u8 stage,
 		ad_data.queue_id = rule->queue_id;
 	}
 
-	ad_data.use_counter = false;
-	ad_data.counter_id = 0;
+	if (hdev->fd_cfg.cnt_num[HCLGE_FD_STAGE_1]) {
+		ad_data.use_counter = true;
+		ad_data.counter_id = rule->vf_id %
+				     hdev->fd_cfg.cnt_num[HCLGE_FD_STAGE_1];
+	} else {
+		ad_data.use_counter = false;
+		ad_data.counter_id = 0;
+	}
 
 	ad_data.use_next_stage = false;
 	ad_data.next_input_key = 0;
-- 
2.8.1

