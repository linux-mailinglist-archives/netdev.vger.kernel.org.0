Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320313B3198
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhFXOma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:42:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8438 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhFXOm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:42:29 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G9jQ62lWmzZlVj;
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
Subject: [PATCH net-next 3/3] net: hns3: add support for link diagnosis info in debugfs
Date:   Thu, 24 Jun 2021 22:36:45 +0800
Message-ID: <1624545405-37050-4-git-send-email-huangguangbin2@huawei.com>
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

In order to know reason why link down, add a debugfs file
"link_diagnosis_info" to get link faults from firmware, and each bit
represents one kind of fault.

usage example:
$ cat link_diagnosis_info
Reference clock lost
SFP is absent

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  8 +++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  3 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 58 ++++++++++++++++++++++
 4 files changed, 70 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index e0b7c3c44e7b..34e5eb65c7b1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -294,6 +294,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_MAC_TNL_STATUS,
 	HNAE3_DBG_CMD_SERV_INFO,
 	HNAE3_DBG_CMD_UMV_INFO,
+	HNAE3_DBG_CMD_LINK_DIAGNOSIS_INFO,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 532523069d74..6a0385b5f80a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -337,6 +337,14 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "link_diagnosis_info",
+		.cmd = HNAE3_DBG_CMD_LINK_DIAGNOSIS_INFO,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 18bde77ef944..8e5be127909b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -316,6 +316,9 @@ enum hclge_opcode_type {
 	/* PHY command */
 	HCLGE_OPC_PHY_LINK_KSETTING	= 0x7025,
 	HCLGE_OPC_PHY_REG		= 0x7026,
+
+	/* Query link diagnosis info command */
+	HCLGE_OPC_QUERY_LINK_DIAGNOSIS	= 0x702A,
 };
 
 #define HCLGE_TQP_REG_OFFSET		0x80000
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 288788186ecc..e6d8d070711d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -2301,6 +2301,60 @@ static int hclge_dbg_dump_mac_mc(struct hclge_dev *hdev, char *buf, int len)
 	return 0;
 }
 
+/* The order of each reason is defined by firmware, so don't change the order */
+static const char * const link_down_reason[] = {
+	"Reference clock lost",
+	"SFP tx is disabled",
+	"SFP is absent",
+	"PHY power down",
+	"Serdes analog loss of signal",
+	"Auto negotiation failed",
+	"Link training failed",
+	"Remote fault",
+	"I2C bus error",
+	"BER is too high",
+};
+
+static int hclge_dbg_dump_link_diagnosis_info(struct hclge_dev *hdev, char *buf,
+					      int len)
+{
+#define HCLGE_DBG_BIT_LEN_PER_WORD		32
+
+	u16 word_index, bit_index, i;
+	struct hclge_desc desc;
+	int pos = 0;
+	u32 data;
+	int ret;
+
+	if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2) {
+		dev_err(&hdev->pdev->dev, "Operation not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_LINK_DIAGNOSIS, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to query link diagnosis info, ret = %d\n", ret);
+		return ret;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(link_down_reason); i++) {
+		word_index = i / HCLGE_DBG_BIT_LEN_PER_WORD;
+		bit_index = i % HCLGE_DBG_BIT_LEN_PER_WORD;
+
+		data = le32_to_cpu(desc.data[word_index]);
+		if (hnae3_get_bit(data, bit_index))
+			pos += scnprintf(buf + pos, len - pos, "%s\n",
+					 link_down_reason[i]);
+	}
+
+	if (!pos)
+		pos += scnprintf(buf + pos, len - pos, "No error\n");
+
+	return 0;
+}
+
 static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 	{
 		.cmd = HNAE3_DBG_CMD_TM_NODES,
@@ -2446,6 +2500,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_UMV_INFO,
 		.dbg_dump = hclge_dbg_dump_umv_info,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_LINK_DIAGNOSIS_INFO,
+		.dbg_dump = hclge_dbg_dump_link_diagnosis_info,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
-- 
2.8.1

