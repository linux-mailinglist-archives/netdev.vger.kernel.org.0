Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B989380278
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhEND0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:26:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3675 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbhEND0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:49 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhDPB2czzz1BMPq;
        Fri, 14 May 2021 11:22:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 11:25:28 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/12] net: hns3: refactor dump mac list of debugfs
Date:   Fri, 14 May 2021 11:25:14 +0800
Message-ID: <1620962720-62216-7-git-send-email-tanhuazhong@huawei.com>
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

Currently, the debugfs command for mac list info is implemented
by "echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create two files "uc" and
"mc" under directory "mac_list" for it, and query mac list info
by "cat mac_list/uc" and "mac_list/mc", return the result to
userspace, rather than record in dmesg.

The display style is below:
$ cat mac_list/uc
UC MAC_LIST:
FUNC_ID  MAC_ADDR            STATE
pf       00:18:2d:00:00:71   ACTIVE

$ cat mac_list/mc
MC MAC_LIST:
FUNC_ID  MAC_ADDR            STATE
pf       01:80:c2:00:00:21   ACTIVE

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  19 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 127 +++++++++++++++------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |   9 ++
 5 files changed, 119 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 6ec504a..ce3910f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -257,6 +257,8 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_DEV_INFO,
 	HNAE3_DBG_CMD_TX_BD,
 	HNAE3_DBG_CMD_RX_BD,
+	HNAE3_DBG_CMD_MAC_UC,
+	HNAE3_DBG_CMD_MAC_MC,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index fb3c2d4..5e02786 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -20,6 +20,9 @@ static struct hns3_dbg_dentry_info hns3_dbg_dentry[] = {
 	{
 		.name = "rx_bd_info"
 	},
+	{
+		.name = "mac_list"
+	},
 	/* keep common at the bottom and add new directory above */
 	{
 		.name = "common"
@@ -73,6 +76,20 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN_4MB,
 		.init = hns3_dbg_bd_file_init,
 	},
+	{
+		.name = "uc",
+		.cmd = HNAE3_DBG_CMD_MAC_UC,
+		.dentry = HNS3_DBG_DENTRY_MAC,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "mc",
+		.cmd = HNAE3_DBG_CMD_MAC_MC,
+		.dentry = HNS3_DBG_DENTRY_MAC,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -474,8 +491,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
 	dev_info(&h->pdev->dev, "dump loopback\n");
 	dev_info(&h->pdev->dev, "dump qs shaper [qs id]\n");
-	dev_info(&h->pdev->dev, "dump uc mac list <func id>\n");
-	dev_info(&h->pdev->dev, "dump mc mac list <func id>\n");
 	dev_info(&h->pdev->dev, "dump intr\n");
 
 	memset(printf_buf, 0, HNS3_DBG_BUF_LEN);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index 06868b6..3d2ee36 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -27,6 +27,7 @@ enum hns3_dbg_dentry_type {
 	HNS3_DBG_DENTRY_TM,
 	HNS3_DBG_DENTRY_TX_BD,
 	HNS3_DBG_DENTRY_RX_BD,
+	HNS3_DBG_DENTRY_MAC,
 	HNS3_DBG_DENTRY_COMMON,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 7f1abdf..ea0d43f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -8,6 +8,10 @@
 #include "hclge_tm.h"
 #include "hnae3.h"
 
+static const char * const hclge_mac_state_str[] = {
+	"TO_ADD", "TO_DEL", "ACTIVE"
+};
+
 static const struct hclge_dbg_reg_type_info hclge_dbg_reg_info[] = {
 	{ .reg_type = "bios common",
 	  .dfx_msg = &hclge_dbg_bios_common_reg[0],
@@ -71,6 +75,35 @@ static const struct hclge_dbg_reg_type_info hclge_dbg_reg_info[] = {
 		       .cmd = HCLGE_OPC_DFX_TQP_REG } },
 };
 
+static void hclge_dbg_fill_content(char *content, u16 len,
+				   const struct hclge_dbg_item *items,
+				   const char **result, u16 size)
+{
+	char *pos = content;
+	u16 i;
+
+	memset(content, ' ', len);
+	for (i = 0; i < size; i++) {
+		if (result)
+			strncpy(pos, result[i], strlen(result[i]));
+		else
+			strncpy(pos, items[i].name, strlen(items[i].name));
+		pos += strlen(items[i].name) + items[i].interval;
+	}
+	*pos++ = '\n';
+	*pos++ = '\0';
+}
+
+static char *hclge_dbg_get_func_id_str(char *buf, u8 id)
+{
+	if (id)
+		sprintf(buf, "vf%u", id - 1);
+	else
+		sprintf(buf, "pf");
+
+	return buf;
+}
+
 static int hclge_dbg_get_dfx_bd_num(struct hclge_dev *hdev, int offset)
 {
 	struct hclge_desc desc[HCLGE_GET_DFX_REG_TYPE_CNT];
@@ -1693,45 +1726,65 @@ static void hclge_dbg_dump_qs_shaper(struct hclge_dev *hdev,
 	hclge_dbg_dump_qs_shaper_single(hdev, qsid);
 }
 
-static int hclge_dbg_dump_mac_list(struct hclge_dev *hdev, const char *cmd_buf,
-				   bool is_unicast)
+static const struct hclge_dbg_item mac_list_items[] = {
+	{ "FUNC_ID", 2 },
+	{ "MAC_ADDR", 12 },
+	{ "STATE", 2 },
+};
+
+static void hclge_dbg_dump_mac_list(struct hclge_dev *hdev, char *buf, int len,
+				    bool is_unicast)
 {
+	char data_str[ARRAY_SIZE(mac_list_items)][HCLGE_DBG_DATA_STR_LEN];
+	char content[HCLGE_DBG_INFO_LEN], str_id[HCLGE_DBG_ID_LEN];
+	char *result[ARRAY_SIZE(mac_list_items)];
 	struct hclge_mac_node *mac_node, *tmp;
 	struct hclge_vport *vport;
 	struct list_head *list;
 	u32 func_id;
-	int ret;
-
-	ret = kstrtouint(cmd_buf, 0, &func_id);
-	if (ret < 0) {
-		dev_err(&hdev->pdev->dev,
-			"dump mac list: bad command string, ret = %d\n", ret);
-		return -EINVAL;
-	}
+	int pos = 0;
+	int i;
 
-	if (func_id >= hdev->num_alloc_vport) {
-		dev_err(&hdev->pdev->dev,
-			"function id(%u) is out of range(0-%u)\n", func_id,
-			hdev->num_alloc_vport - 1);
-		return -EINVAL;
+	for (i = 0; i < ARRAY_SIZE(mac_list_items); i++)
+		result[i] = &data_str[i][0];
+
+	pos += scnprintf(buf + pos, len - pos, "%s MAC_LIST:\n",
+			 is_unicast ? "UC" : "MC");
+	hclge_dbg_fill_content(content, sizeof(content), mac_list_items,
+			       NULL, ARRAY_SIZE(mac_list_items));
+	pos += scnprintf(buf + pos, len - pos, "%s", content);
+
+	for (func_id = 0; func_id < hdev->num_alloc_vport; func_id++) {
+		vport = &hdev->vport[func_id];
+		list = is_unicast ? &vport->uc_mac_list : &vport->mc_mac_list;
+		spin_lock_bh(&vport->mac_list_lock);
+		list_for_each_entry_safe(mac_node, tmp, list, node) {
+			i = 0;
+			result[i++] = hclge_dbg_get_func_id_str(str_id,
+								func_id);
+			sprintf(result[i++], "%pM", mac_node->mac_addr);
+			sprintf(result[i++], "%5s",
+				hclge_mac_state_str[mac_node->state]);
+			hclge_dbg_fill_content(content, sizeof(content),
+					       mac_list_items,
+					       (const char **)result,
+					       ARRAY_SIZE(mac_list_items));
+			pos += scnprintf(buf + pos, len - pos, "%s", content);
+		}
+		spin_unlock_bh(&vport->mac_list_lock);
 	}
+}
 
-	vport = &hdev->vport[func_id];
-
-	list = is_unicast ? &vport->uc_mac_list : &vport->mc_mac_list;
-
-	dev_info(&hdev->pdev->dev, "vport %u %s mac list:\n",
-		 func_id, is_unicast ? "uc" : "mc");
-	dev_info(&hdev->pdev->dev, "mac address              state\n");
-
-	spin_lock_bh(&vport->mac_list_lock);
+static int hclge_dbg_dump_mac_uc(struct hclge_dev *hdev, char *buf, int len)
+{
+	hclge_dbg_dump_mac_list(hdev, buf, len, true);
 
-	list_for_each_entry_safe(mac_node, tmp, list, node) {
-		dev_info(&hdev->pdev->dev, "%pM         %d\n",
-			 mac_node->mac_addr, mac_node->state);
-	}
+	return 0;
+}
 
-	spin_unlock_bh(&vport->mac_list_lock);
+static int hclge_dbg_dump_mac_mc(struct hclge_dev *hdev, char *buf, int len)
+{
+	hclge_dbg_dump_mac_list(hdev, buf, len, false);
 
 	return 0;
 }
@@ -1781,14 +1834,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 	} else if (strncmp(cmd_buf, "dump qs shaper", 14) == 0) {
 		hclge_dbg_dump_qs_shaper(hdev,
 					 &cmd_buf[sizeof("dump qs shaper")]);
-	} else if (strncmp(cmd_buf, "dump uc mac list", 16) == 0) {
-		hclge_dbg_dump_mac_list(hdev,
-					&cmd_buf[sizeof("dump uc mac list")],
-					true);
-	} else if (strncmp(cmd_buf, "dump mc mac list", 16) == 0) {
-		hclge_dbg_dump_mac_list(hdev,
-					&cmd_buf[sizeof("dump mc mac list")],
-					false);
 	} else if (strncmp(cmd_buf, DUMP_INTERRUPT,
 		   strlen(DUMP_INTERRUPT)) == 0) {
 		hclge_dbg_dump_interrupt(hdev);
@@ -1813,6 +1858,14 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_TM_QSET,
 		.dbg_dump = hclge_dbg_dump_tm_qset,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_MAC_UC,
+		.dbg_dump = hclge_dbg_dump_mac_uc,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_MAC_MC,
+		.dbg_dump = hclge_dbg_dump_mac_mc,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index 0c14453..c5c18af 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -728,4 +728,13 @@ static const struct hclge_dbg_dfx_message hclge_dbg_tqp_reg[] = {
 	{true, "RCB_CFG_TX_RING_EBDNUM"},
 };
 
+#define HCLGE_DBG_INFO_LEN			256
+#define HCLGE_DBG_ID_LEN			16
+#define HCLGE_DBG_ITEM_NAME_LEN			32
+#define HCLGE_DBG_DATA_STR_LEN			32
+struct hclge_dbg_item {
+	char name[HCLGE_DBG_ITEM_NAME_LEN];
+	u16 interval; /* blank numbers after the item */
+};
+
 #endif
-- 
2.7.4

