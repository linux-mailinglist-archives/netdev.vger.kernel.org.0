Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F1E38027F
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhEND1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:27:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2665 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhEND0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:52 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FhDPr36GzzmWBB;
        Fri, 14 May 2021 11:23:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 11:25:29 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Jiaran Zhang <zhangjiaran@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/12] net: hns3: refactor dump m7 info of debugfs
Date:   Fri, 14 May 2021 11:25:19 +0800
Message-ID: <1620962720-62216-12-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
References: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

Currently, the debugfs command for m7 info is implemented by
"echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create a single file
"imp_info" for it, and query it by command "cat imp_info",
return the result to userspace, rather than record in dmesg.

The display style is below:
$cat imp_info
offset | data
0x0000 | 0x00000000  0x00000000
0x0008 | 0x00000000  0x00000000
0x0010 | 0x00000000  0x00000001
0x0018 | 0x00000000  0x00000000
0x0020 | 0x00000000  0x00000000
0x0028 | 0x00000000  0x00000000
0x0030 | 0x00000000  0x00000000

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  8 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 10 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 81 +++++++++++++---------
 5 files changed, 64 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 455174c..7064fae 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -263,6 +263,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_LOOPBACK,
 	HNAE3_DBG_CMD_INTERRUPT_INFO,
 	HNAE3_DBG_CMD_RESET_INFO,
+	HNAE3_DBG_CMD_IMP_INFO,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 49c87c8..d91c005 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -118,6 +118,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "imp_info",
+		.cmd = HNAE3_DBG_CMD_IMP_INFO,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -512,7 +519,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump qos pause cfg\n");
 	dev_info(&h->pdev->dev, "dump qos pri map\n");
 	dev_info(&h->pdev->dev, "dump qos buf cfg\n");
-	dev_info(&h->pdev->dev, "dump m7 info\n");
 	dev_info(&h->pdev->dev, "dump ncl_config <offset> <length>(in hex)\n");
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
 	dev_info(&h->pdev->dev, "dump qs shaper [qs id]\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 0df9ca3..6aed30c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -471,7 +471,7 @@ static int hclge_firmware_compat_config(struct hclge_dev *hdev)
 	struct hclge_desc desc;
 	u32 compat = 0;
 
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_M7_COMPAT_CFG, false);
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_IMP_COMPAT_CFG, false);
 
 	req = (struct hclge_firmware_compat_cmd *)desc.data;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index c6cd273..12558aa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -267,10 +267,10 @@ enum hclge_opcode_type {
 	/* NCL config command */
 	HCLGE_OPC_QUERY_NCL_CONFIG	= 0x7011,
 
-	/* M7 stats command */
-	HCLGE_OPC_M7_STATS_BD		= 0x7012,
-	HCLGE_OPC_M7_STATS_INFO		= 0x7013,
-	HCLGE_OPC_M7_COMPAT_CFG		= 0x701A,
+	/* IMP stats command */
+	HCLGE_OPC_IMP_STATS_BD		= 0x7012,
+	HCLGE_OPC_IMP_STATS_INFO		= 0x7013,
+	HCLGE_OPC_IMP_COMPAT_CFG		= 0x701A,
 
 	/* SFP command */
 	HCLGE_OPC_GET_SFP_EEPROM	= 0x7100,
@@ -1101,7 +1101,7 @@ struct hclge_fd_user_def_cfg_cmd {
 	u8 rsv[12];
 };
 
-struct hclge_get_m7_bd_cmd {
+struct hclge_get_imp_bd_cmd {
 	__le32 bd_num;
 	u8 rsv[20];
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 736746b..d0634ba 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1456,56 +1456,73 @@ static int hclge_dbg_dump_interrupt(struct hclge_dev *hdev, char *buf, int len)
 	return 0;
 }
 
-static void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
+static void hclge_dbg_imp_info_data_print(struct hclge_desc *desc_src,
+					  char *buf, int len, u32 bd_num)
 {
-	struct hclge_desc *desc_src, *desc_tmp;
-	struct hclge_get_m7_bd_cmd *req;
+#define HCLGE_DBG_IMP_INFO_PRINT_OFFSET 0x2
+
+	struct hclge_desc *desc_index = desc_src;
+	u32 offset = 0;
+	int pos = 0;
+	u32 i, j;
+
+	pos += scnprintf(buf + pos, len - pos, "offset | data\n");
+
+	for (i = 0; i < bd_num; i++) {
+		j = 0;
+		while (j < HCLGE_DESC_DATA_LEN - 1) {
+			pos += scnprintf(buf + pos, len - pos, "0x%04x | ",
+					 offset);
+			pos += scnprintf(buf + pos, len - pos, "0x%08x  ",
+					 le32_to_cpu(desc_index->data[j++]));
+			pos += scnprintf(buf + pos, len - pos, "0x%08x\n",
+					 le32_to_cpu(desc_index->data[j++]));
+			offset += sizeof(u32) * HCLGE_DBG_IMP_INFO_PRINT_OFFSET;
+		}
+		desc_index++;
+	}
+}
+
+static int
+hclge_dbg_get_imp_stats_info(struct hclge_dev *hdev, char *buf, int len)
+{
+	struct hclge_get_imp_bd_cmd *req;
+	struct hclge_desc *desc_src;
 	struct hclge_desc desc;
-	u32 bd_num, buf_len;
-	int ret, i;
+	u32 bd_num;
+	int ret;
 
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_M7_STATS_BD, true);
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_IMP_STATS_BD, true);
 
-	req = (struct hclge_get_m7_bd_cmd *)desc.data;
+	req = (struct hclge_get_imp_bd_cmd *)desc.data;
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"get firmware statistics bd number failed, ret = %d\n",
+			"failed to get imp statistics bd number, ret = %d\n",
 			ret);
-		return;
+		return ret;
 	}
 
 	bd_num = le32_to_cpu(req->bd_num);
 
-	buf_len	 = sizeof(struct hclge_desc) * bd_num;
-	desc_src = kzalloc(buf_len, GFP_KERNEL);
+	desc_src = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
 	if (!desc_src)
-		return;
+		return -ENOMEM;
 
-	desc_tmp = desc_src;
-	ret  = hclge_dbg_cmd_send(hdev, desc_tmp, 0, bd_num,
-				  HCLGE_OPC_M7_STATS_INFO);
+	ret  = hclge_dbg_cmd_send(hdev, desc_src, 0, bd_num,
+				  HCLGE_OPC_IMP_STATS_INFO);
 	if (ret) {
 		kfree(desc_src);
 		dev_err(&hdev->pdev->dev,
-			"get firmware statistics failed, ret = %d\n", ret);
-		return;
+			"failed to get imp statistics, ret = %d\n", ret);
+		return ret;
 	}
 
-	for (i = 0; i < bd_num; i++) {
-		dev_info(&hdev->pdev->dev, "0x%08x  0x%08x  0x%08x\n",
-			 le32_to_cpu(desc_tmp->data[0]),
-			 le32_to_cpu(desc_tmp->data[1]),
-			 le32_to_cpu(desc_tmp->data[2]));
-		dev_info(&hdev->pdev->dev, "0x%08x  0x%08x  0x%08x\n",
-			 le32_to_cpu(desc_tmp->data[3]),
-			 le32_to_cpu(desc_tmp->data[4]),
-			 le32_to_cpu(desc_tmp->data[5]));
-
-		desc_tmp++;
-	}
+	hclge_dbg_imp_info_data_print(desc_src, buf, len, bd_num);
 
 	kfree(desc_src);
+
+	return 0;
 }
 
 #define HCLGE_CMD_NCL_CONFIG_BD_NUM	5
@@ -1831,8 +1848,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 		hclge_dbg_dump_reg_cmd(hdev, &cmd_buf[sizeof(DUMP_REG)]);
 	} else if (strncmp(cmd_buf, "dump serv info", 14) == 0) {
 		hclge_dbg_dump_serv_info(hdev);
-	} else if (strncmp(cmd_buf, "dump m7 info", 12) == 0) {
-		hclge_dbg_get_m7_stats_info(hdev);
 	} else if (strncmp(cmd_buf, "dump ncl_config", 15) == 0) {
 		hclge_dbg_dump_ncl_config(hdev,
 					  &cmd_buf[sizeof("dump ncl_config")]);
@@ -1886,6 +1901,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_RESET_INFO,
 		.dbg_dump = hclge_dbg_dump_rst_info,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_IMP_INFO,
+		.dbg_dump = hclge_dbg_get_imp_stats_info,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
-- 
2.7.4

