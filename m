Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E98380280
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhEND1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:27:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2664 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbhEND0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:52 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FhDPr2rd2zmW9x;
        Fri, 14 May 2021 11:23:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 11:25:30 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Jiaran Zhang <zhangjiaran@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 12/12] net: hns3: refactor dump ncl config of debugfs
Date:   Fri, 14 May 2021 11:25:20 +0800
Message-ID: <1620962720-62216-13-git-send-email-tanhuazhong@huawei.com>
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

Currently, the debugfs command for ncl config is implemented by
"echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create a single file
"ncl_config" for it, and query it by command "cat ncl_config",
return the result to userspace, rather than record in dmesg.

The display style is below:
$cat ncl_config
offset | data
0x0000 | 0x00000028
0x0004 | 0x00000400
0x0008 | 0x08040201
0x000c | 0x00000000
0x0010 | 0x00040004
0x0014 | 0x00040004
0x0018 | 0x00000000
0x001c | 0x00000000
0x0020 | 0x00040004

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  8 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 78 +++++++++-------------
 4 files changed, 40 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 7064fae..d1cdb74 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -264,6 +264,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_INTERRUPT_INFO,
 	HNAE3_DBG_CMD_RESET_INFO,
 	HNAE3_DBG_CMD_IMP_INFO,
+	HNAE3_DBG_CMD_NCL_CONFIG,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index d91c005..ba4ee8c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -125,6 +125,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "ncl_config",
+		.cmd = HNAE3_DBG_CMD_NCL_CONFIG,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN_128KB,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -519,7 +526,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump qos pause cfg\n");
 	dev_info(&h->pdev->dev, "dump qos pri map\n");
 	dev_info(&h->pdev->dev, "dump qos buf cfg\n");
-	dev_info(&h->pdev->dev, "dump ncl_config <offset> <length>(in hex)\n");
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
 	dev_info(&h->pdev->dev, "dump qs shaper [qs id]\n");
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index 3d2ee36..a7af927 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -5,6 +5,7 @@
 #define __HNS3_DEBUGFS_H
 
 #define HNS3_DBG_READ_LEN	65536
+#define HNS3_DBG_READ_LEN_128KB	0x20000
 #define HNS3_DBG_READ_LEN_4MB	0x400000
 #define HNS3_DBG_WRITE_LEN	1024
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index d0634ba..8a92ab4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1526,80 +1526,63 @@ hclge_dbg_get_imp_stats_info(struct hclge_dev *hdev, char *buf, int len)
 }
 
 #define HCLGE_CMD_NCL_CONFIG_BD_NUM	5
+#define HCLGE_MAX_NCL_CONFIG_LENGTH	16384
 
-static void hclge_ncl_config_data_print(struct hclge_dev *hdev,
-					struct hclge_desc *desc, int *offset,
-					int *length)
+static void hclge_ncl_config_data_print(struct hclge_desc *desc, int *index,
+					char *buf, int *len, int *pos)
 {
 #define HCLGE_CMD_DATA_NUM		6
 
-	int i;
-	int j;
+	int offset = HCLGE_MAX_NCL_CONFIG_LENGTH - *index;
+	int i, j;
 
 	for (i = 0; i < HCLGE_CMD_NCL_CONFIG_BD_NUM; i++) {
 		for (j = 0; j < HCLGE_CMD_DATA_NUM; j++) {
 			if (i == 0 && j == 0)
 				continue;
 
-			dev_info(&hdev->pdev->dev, "0x%04x | 0x%08x\n",
-				 *offset,
-				 le32_to_cpu(desc[i].data[j]));
-			*offset += sizeof(u32);
-			*length -= sizeof(u32);
-			if (*length <= 0)
+			*pos += scnprintf(buf + *pos, *len - *pos,
+					  "0x%04x | 0x%08x\n", offset,
+					  le32_to_cpu(desc[i].data[j]));
+
+			offset += sizeof(u32);
+			*index -= sizeof(u32);
+
+			if (*index <= 0)
 				return;
 		}
 	}
 }
 
-/* hclge_dbg_dump_ncl_config: print specified range of NCL_CONFIG file
- * @hdev: pointer to struct hclge_dev
- * @cmd_buf: string that contains offset and length
- */
-static void hclge_dbg_dump_ncl_config(struct hclge_dev *hdev,
-				      const char *cmd_buf)
+static int
+hclge_dbg_dump_ncl_config(struct hclge_dev *hdev, char *buf, int len)
 {
-#define HCLGE_MAX_NCL_CONFIG_OFFSET	4096
 #define HCLGE_NCL_CONFIG_LENGTH_IN_EACH_CMD	(20 + 24 * 4)
-#define HCLGE_NCL_CONFIG_PARAM_NUM	2
 
 	struct hclge_desc desc[HCLGE_CMD_NCL_CONFIG_BD_NUM];
 	int bd_num = HCLGE_CMD_NCL_CONFIG_BD_NUM;
-	int offset;
-	int length;
-	int data0;
+	int index = HCLGE_MAX_NCL_CONFIG_LENGTH;
+	int pos = 0;
+	u32 data0;
 	int ret;
 
-	ret = sscanf(cmd_buf, "%x %x", &offset, &length);
-	if (ret != HCLGE_NCL_CONFIG_PARAM_NUM) {
-		dev_err(&hdev->pdev->dev,
-			"Too few parameters, num = %d.\n", ret);
-		return;
-	}
-
-	if (offset < 0 || offset >= HCLGE_MAX_NCL_CONFIG_OFFSET ||
-	    length <= 0 || length > HCLGE_MAX_NCL_CONFIG_OFFSET - offset) {
-		dev_err(&hdev->pdev->dev,
-			"Invalid input, offset = %d, length = %d.\n",
-			offset, length);
-		return;
-	}
-
-	dev_info(&hdev->pdev->dev, "offset |    data\n");
+	pos += scnprintf(buf + pos, len - pos, "offset | data\n");
 
-	while (length > 0) {
-		data0 = offset;
-		if (length >= HCLGE_NCL_CONFIG_LENGTH_IN_EACH_CMD)
+	while (index > 0) {
+		data0 = HCLGE_MAX_NCL_CONFIG_LENGTH - index;
+		if (index >= HCLGE_NCL_CONFIG_LENGTH_IN_EACH_CMD)
 			data0 |= HCLGE_NCL_CONFIG_LENGTH_IN_EACH_CMD << 16;
 		else
-			data0 |= length << 16;
+			data0 |= (u32)index << 16;
 		ret = hclge_dbg_cmd_send(hdev, desc, data0, bd_num,
 					 HCLGE_OPC_QUERY_NCL_CONFIG);
 		if (ret)
-			return;
+			return ret;
 
-		hclge_ncl_config_data_print(hdev, desc, &offset, &length);
+		hclge_ncl_config_data_print(desc, &index, buf, &len, &pos);
 	}
+
+	return 0;
 }
 
 static int hclge_dbg_dump_loopback(struct hclge_dev *hdev, char *buf, int len)
@@ -1848,9 +1831,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 		hclge_dbg_dump_reg_cmd(hdev, &cmd_buf[sizeof(DUMP_REG)]);
 	} else if (strncmp(cmd_buf, "dump serv info", 14) == 0) {
 		hclge_dbg_dump_serv_info(hdev);
-	} else if (strncmp(cmd_buf, "dump ncl_config", 15) == 0) {
-		hclge_dbg_dump_ncl_config(hdev,
-					  &cmd_buf[sizeof("dump ncl_config")]);
 	} else if (strncmp(cmd_buf, "dump mac tnl status", 19) == 0) {
 		hclge_dbg_dump_mac_tnl_status(hdev);
 	} else if (strncmp(cmd_buf, "dump qs shaper", 14) == 0) {
@@ -1905,6 +1885,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_IMP_INFO,
 		.dbg_dump = hclge_dbg_get_imp_stats_info,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_NCL_CONFIG,
+		.dbg_dump = hclge_dbg_dump_ncl_config,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
-- 
2.7.4

