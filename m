Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81E338027D
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhEND1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:27:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3678 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbhEND0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:49 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhDPB35zMz1BMPv;
        Fri, 14 May 2021 11:22:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 11:25:28 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/12] net: hns3: refactor dump mng tbl of debugfs
Date:   Fri, 14 May 2021 11:25:15 +0800
Message-ID: <1620962720-62216-8-git-send-email-tanhuazhong@huawei.com>
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

From: Yufeng Mo <moyufeng@huawei.com>

Currently, the debugfs command for mng tbl is implemented by
"echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create a single file
"mng_tbl" for it, and query it by command "cat mng_tbl",
return the result to userspace, rather than record in dmesg.

The display style is below:
$ cat mng_tbl
entry  mac_addr          mask  ether  mask  vlan  mask  i_map ...
00     00:00:00:00:00:00 0     88cc   0     0000  1     0f    ...

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  8 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 80 ++++++++++------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |  1 -
 4 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index ce3910f..a2033cb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -259,6 +259,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_RX_BD,
 	HNAE3_DBG_CMD_MAC_UC,
 	HNAE3_DBG_CMD_MAC_MC,
+	HNAE3_DBG_CMD_MNG_TBL,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 5e02786..4af997d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -90,6 +90,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "mng_tbl",
+		.cmd = HNAE3_DBG_CMD_MNG_TBL,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -484,7 +491,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump qos pause cfg\n");
 	dev_info(&h->pdev->dev, "dump qos pri map\n");
 	dev_info(&h->pdev->dev, "dump qos buf cfg\n");
-	dev_info(&h->pdev->dev, "dump mng tbl\n");
 	dev_info(&h->pdev->dev, "dump reset info\n");
 	dev_info(&h->pdev->dev, "dump m7 info\n");
 	dev_info(&h->pdev->dev, "dump ncl_config <offset> <length>(in hex)\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index ea0d43f..613730f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1212,24 +1212,19 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 		"dump qos buf cfg fail(0x%x), ret = %d\n", cmd, ret);
 }
 
-static void hclge_dbg_dump_mng_table(struct hclge_dev *hdev)
+static int hclge_dbg_dump_mng_table(struct hclge_dev *hdev, char *buf, int len)
 {
 	struct hclge_mac_ethertype_idx_rd_cmd *req0;
-	char printf_buf[HCLGE_DBG_BUF_LEN];
 	struct hclge_desc desc;
 	u32 msg_egress_port;
+	int pos = 0;
 	int ret, i;
 
-	dev_info(&hdev->pdev->dev, "mng tab:\n");
-	memset(printf_buf, 0, HCLGE_DBG_BUF_LEN);
-	strncat(printf_buf,
-		"entry|mac_addr         |mask|ether|mask|vlan|mask",
-		HCLGE_DBG_BUF_LEN - 1);
-	strncat(printf_buf + strlen(printf_buf),
-		"|i_map|i_dir|e_type|pf_id|vf_id|q_id|drop\n",
-		HCLGE_DBG_BUF_LEN - strlen(printf_buf) - 1);
-
-	dev_info(&hdev->pdev->dev, "%s", printf_buf);
+	pos += scnprintf(buf + pos, len - pos,
+			 "entry  mac_addr          mask  ether  ");
+	pos += scnprintf(buf + pos, len - pos,
+			 "mask  vlan  mask  i_map  i_dir  e_type  ");
+	pos += scnprintf(buf + pos, len - pos, "pf_id  vf_id  q_id  drop\n");
 
 	for (i = 0; i < HCLGE_DBG_MNG_TBL_MAX; i++) {
 		hclge_cmd_setup_basic_desc(&desc, HCLGE_MAC_ETHERTYPE_IDX_RD,
@@ -1240,43 +1235,40 @@ static void hclge_dbg_dump_mng_table(struct hclge_dev *hdev)
 		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
-				"call hclge_cmd_send fail, ret = %d\n", ret);
-			return;
+				"failed to dump manage table, ret = %d\n", ret);
+			return ret;
 		}
 
 		if (!req0->resp_code)
 			continue;
 
-		memset(printf_buf, 0, HCLGE_DBG_BUF_LEN);
-		snprintf(printf_buf, HCLGE_DBG_BUF_LEN,
-			 "%02u   |%02x:%02x:%02x:%02x:%02x:%02x|",
-			 le16_to_cpu(req0->index),
-			 req0->mac_addr[0], req0->mac_addr[1],
-			 req0->mac_addr[2], req0->mac_addr[3],
-			 req0->mac_addr[4], req0->mac_addr[5]);
-
-		snprintf(printf_buf + strlen(printf_buf),
-			 HCLGE_DBG_BUF_LEN - strlen(printf_buf),
-			 "%x   |%04x |%x   |%04x|%x   |%02x   |%02x   |",
-			 !!(req0->flags & HCLGE_DBG_MNG_MAC_MASK_B),
-			 le16_to_cpu(req0->ethter_type),
-			 !!(req0->flags & HCLGE_DBG_MNG_ETHER_MASK_B),
-			 le16_to_cpu(req0->vlan_tag) & HCLGE_DBG_MNG_VLAN_TAG,
-			 !!(req0->flags & HCLGE_DBG_MNG_VLAN_MASK_B),
-			 req0->i_port_bitmap, req0->i_port_direction);
+		pos += scnprintf(buf + pos, len - pos, "%02u     %pM ",
+				 le16_to_cpu(req0->index), req0->mac_addr);
+
+		pos += scnprintf(buf + pos, len - pos,
+				 "%x     %04x   %x     %04x  ",
+				 !!(req0->flags & HCLGE_DBG_MNG_MAC_MASK_B),
+				 le16_to_cpu(req0->ethter_type),
+				 !!(req0->flags & HCLGE_DBG_MNG_ETHER_MASK_B),
+				 le16_to_cpu(req0->vlan_tag) &
+				 HCLGE_DBG_MNG_VLAN_TAG);
+
+		pos += scnprintf(buf + pos, len - pos,
+				 "%x     %02x     %02x     ",
+				 !!(req0->flags & HCLGE_DBG_MNG_VLAN_MASK_B),
+				 req0->i_port_bitmap, req0->i_port_direction);
 
 		msg_egress_port = le16_to_cpu(req0->egress_port);
-		snprintf(printf_buf + strlen(printf_buf),
-			 HCLGE_DBG_BUF_LEN - strlen(printf_buf),
-			 "%x     |%x    |%02x   |%04x|%x\n",
-			 !!(msg_egress_port & HCLGE_DBG_MNG_E_TYPE_B),
-			 msg_egress_port & HCLGE_DBG_MNG_PF_ID,
-			 (msg_egress_port >> 3) & HCLGE_DBG_MNG_VF_ID,
-			 le16_to_cpu(req0->egress_queue),
-			 !!(msg_egress_port & HCLGE_DBG_MNG_DROP_B));
-
-		dev_info(&hdev->pdev->dev, "%s", printf_buf);
+		pos += scnprintf(buf + pos, len - pos,
+				 "%x       %x      %02x     %04x  %x\n",
+				 !!(msg_egress_port & HCLGE_DBG_MNG_E_TYPE_B),
+				 msg_egress_port & HCLGE_DBG_MNG_PF_ID,
+				 (msg_egress_port >> 3) & HCLGE_DBG_MNG_VF_ID,
+				 le16_to_cpu(req0->egress_queue),
+				 !!(msg_egress_port & HCLGE_DBG_MNG_DROP_B));
 	}
+
+	return 0;
 }
 
 static int hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
@@ -1813,8 +1805,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 		hclge_dbg_dump_qos_pri_map(hdev);
 	} else if (strncmp(cmd_buf, "dump qos buf cfg", 16) == 0) {
 		hclge_dbg_dump_qos_buf_cfg(hdev);
-	} else if (strncmp(cmd_buf, "dump mng tbl", 12) == 0) {
-		hclge_dbg_dump_mng_table(hdev);
 	} else if (strncmp(cmd_buf, DUMP_REG, strlen(DUMP_REG)) == 0) {
 		hclge_dbg_dump_reg_cmd(hdev, &cmd_buf[sizeof(DUMP_REG)]);
 	} else if (strncmp(cmd_buf, "dump reset info", 15) == 0) {
@@ -1866,6 +1856,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_MAC_MC,
 		.dbg_dump = hclge_dbg_dump_mac_mc,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_MNG_TBL,
+		.dbg_dump = hclge_dbg_dump_mng_table,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index c5c18af..bf6a0ff 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -7,7 +7,6 @@
 #include <linux/etherdevice.h>
 #include "hclge_cmd.h"
 
-#define HCLGE_DBG_BUF_LEN	   256
 #define HCLGE_DBG_MNG_TBL_MAX	   64
 
 #define HCLGE_DBG_MNG_VLAN_MASK_B  BIT(0)
-- 
2.7.4

