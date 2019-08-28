Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5B5A04F0
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfH1O0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:26:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5235 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726415AbfH1OZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:25:39 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 24CB7192A15C549F711C;
        Wed, 28 Aug 2019 22:25:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 22:25:29 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Zhongzhu Liu <liuzhongzhu@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 01/12] net: hns3: code optimization for debugfs related to "dump reg"
Date:   Wed, 28 Aug 2019 22:23:05 +0800
Message-ID: <1567002196-63242-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
References: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhongzhu Liu <liuzhongzhu@huawei.com>

For making the code more readable, this patch uses a array to
keep the information about the dumping register, and then uses
it to parse the parameter cmd_buf which passing into
hclge_dbg_dump_reg_cmd().

Also replaces parameter "base" of kstrtouint with 0 in the
hclge_dbg_dump_reg_common(), which makes it more flexible.

Signed-off-by: Zhongzhu Liu <liuzhongzhu@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 226 +++++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |  16 ++
 2 files changed, 132 insertions(+), 110 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 025184a..a56f388 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -4,14 +4,80 @@
 #include <linux/device.h>
 
 #include "hclge_debugfs.h"
-#include "hclge_cmd.h"
 #include "hclge_main.h"
 #include "hclge_tm.h"
 #include "hnae3.h"
 
+static struct hclge_dbg_reg_type_info hclge_dbg_reg_info[] = {
+	{ .reg_type = "bios common",
+	  .dfx_msg = &hclge_dbg_bios_common_reg[0],
+	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_bios_common_reg),
+		       .offset = HCLGE_DBG_DFX_BIOS_OFFSET,
+		       .cmd = HCLGE_OPC_DFX_BIOS_COMMON_REG } },
+	{ .reg_type = "ssu",
+	  .dfx_msg = &hclge_dbg_ssu_reg_0[0],
+	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_ssu_reg_0),
+		       .offset = HCLGE_DBG_DFX_SSU_0_OFFSET,
+		       .cmd = HCLGE_OPC_DFX_SSU_REG_0 } },
+	{ .reg_type = "ssu",
+	  .dfx_msg = &hclge_dbg_ssu_reg_1[0],
+	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_ssu_reg_1),
+		       .offset = HCLGE_DBG_DFX_SSU_1_OFFSET,
+		       .cmd = HCLGE_OPC_DFX_SSU_REG_1 } },
+	{ .reg_type = "ssu",
+	  .dfx_msg = &hclge_dbg_ssu_reg_2[0],
+	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_ssu_reg_2),
+		       .offset = HCLGE_DBG_DFX_SSU_2_OFFSET,
+		       .cmd = HCLGE_OPC_DFX_SSU_REG_2 } },
+	{ .reg_type = "igu egu",
+	  .dfx_msg = &hclge_dbg_igu_egu_reg[0],
+	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_igu_egu_reg),
+		       .offset = HCLGE_DBG_DFX_IGU_OFFSET,
+		       .cmd = HCLGE_OPC_DFX_IGU_EGU_REG } },
+	{ .reg_type = "rpu",
+	  .dfx_msg = &hclge_dbg_rpu_reg_0[0],
+	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_rpu_reg_0),
+		       .offset = HCLGE_DBG_DFX_RPU_0_OFFSET,
+		       .cmd = HCLGE_OPC_DFX_RPU_REG_0 } },
+	{ .reg_type = "rpu",
+	  .dfx_msg = &hclge_dbg_rpu_reg_1[0],
+	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_rpu_reg_1),
+		       .offset = HCLGE_DBG_DFX_RPU_1_OFFSET,
+		       .cmd = HCLGE_OPC_DFX_RPU_REG_1 } },
+	{ .reg_type = "ncsi",
+	  .dfx_msg = &hclge_dbg_ncsi_reg[0],
+	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_ncsi_reg),
+		       .offset = HCLGE_DBG_DFX_NCSI_OFFSET,
+		       .cmd = HCLGE_OPC_DFX_NCSI_REG } },
+	{ .reg_type = "rtc",
+	  .dfx_msg = &hclge_dbg_rtc_reg[0],
+	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_rtc_reg),
+		       .offset = HCLGE_DBG_DFX_RTC_OFFSET,
+		       .cmd = HCLGE_OPC_DFX_RTC_REG } },
+	{ .reg_type = "ppp",
+	  .dfx_msg = &hclge_dbg_ppp_reg[0],
+	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_ppp_reg),
+		       .offset = HCLGE_DBG_DFX_PPP_OFFSET,
+		       .cmd = HCLGE_OPC_DFX_PPP_REG } },
+	{ .reg_type = "rcb",
+	  .dfx_msg = &hclge_dbg_rcb_reg[0],
+	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_rcb_reg),
+		       .offset = HCLGE_DBG_DFX_RCB_OFFSET,
+		       .cmd = HCLGE_OPC_DFX_RCB_REG } },
+	{ .reg_type = "tqp",
+	  .dfx_msg = &hclge_dbg_tqp_reg[0],
+	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_tqp_reg),
+		       .offset = HCLGE_DBG_DFX_TQP_OFFSET,
+		       .cmd = HCLGE_OPC_DFX_TQP_REG } },
+};
+
 static int hclge_dbg_get_dfx_bd_num(struct hclge_dev *hdev, int offset)
 {
-	struct hclge_desc desc[4];
+#define HCLGE_GET_DFX_REG_TYPE_CNT	4
+
+	struct hclge_desc desc[HCLGE_GET_DFX_REG_TYPE_CNT];
+	int entries_per_desc;
+	int index;
 	int ret;
 
 	ret = hclge_query_bd_num_cmd_send(hdev, desc);
@@ -21,7 +87,9 @@ static int hclge_dbg_get_dfx_bd_num(struct hclge_dev *hdev, int offset)
 		return ret;
 	}
 
-	return (int)desc[offset / 6].data[offset % 6];
+	entries_per_desc = ARRAY_SIZE(desc[0].data);
+	index = offset % entries_per_desc;
+	return (int)desc[offset / entries_per_desc].data[index];
 }
 
 static int hclge_dbg_cmd_send(struct hclge_dev *hdev,
@@ -52,23 +120,28 @@ static int hclge_dbg_cmd_send(struct hclge_dev *hdev,
 }
 
 static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
-				      struct hclge_dbg_dfx_message *dfx_message,
-				      const char *cmd_buf, int msg_num,
-				      int offset, enum hclge_opcode_type cmd)
+				      struct hclge_dbg_reg_type_info *reg_info,
+				      const char *cmd_buf)
 {
-#define BD_DATA_NUM       6
+#define IDX_OFFSET	1
 
+	const char *s = &cmd_buf[strlen(reg_info->reg_type) + IDX_OFFSET];
+	struct hclge_dbg_dfx_message *dfx_message = reg_info->dfx_msg;
+	struct hclge_dbg_reg_common_msg *reg_msg = &reg_info->reg_msg;
 	struct hclge_desc *desc_src;
 	struct hclge_desc *desc;
+	int entries_per_desc;
 	int bd_num, buf_len;
+	int index = 0;
+	int min_num;
 	int ret, i;
-	int index;
-	int max;
 
-	ret = kstrtouint(cmd_buf, 10, &index);
-	index = (ret != 0) ? 0 : index;
+	if (*s) {
+		ret = kstrtouint(s, 0, &index);
+		index = (ret != 0) ? 0 : index;
+	}
 
-	bd_num = hclge_dbg_get_dfx_bd_num(hdev, offset);
+	bd_num = hclge_dbg_get_dfx_bd_num(hdev, reg_msg->offset);
 	if (bd_num <= 0)
 		return;
 
@@ -80,22 +153,23 @@ static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 	}
 
 	desc = desc_src;
-	ret  = hclge_dbg_cmd_send(hdev, desc, index, bd_num, cmd);
-	if (ret != HCLGE_CMD_EXEC_SUCCESS) {
+	ret  = hclge_dbg_cmd_send(hdev, desc, index, bd_num, reg_msg->cmd);
+	if (ret) {
 		kfree(desc_src);
 		return;
 	}
 
-	max = (bd_num * BD_DATA_NUM) <= msg_num ?
-		(bd_num * BD_DATA_NUM) : msg_num;
+	entries_per_desc = ARRAY_SIZE(desc->data);
+	min_num = min_t(int, bd_num * entries_per_desc, reg_msg->msg_num);
 
 	desc = desc_src;
-	for (i = 0; i < max; i++) {
-		((i > 0) && ((i % BD_DATA_NUM) == 0)) ? desc++ : desc;
+	for (i = 0; i < min_num; i++) {
+		if (i > 0 && (i % entries_per_desc) == 0)
+			desc++;
 		if (dfx_message->flag)
 			dev_info(&hdev->pdev->dev, "%s: 0x%x\n",
 				 dfx_message->message,
-				 desc->data[i % BD_DATA_NUM]);
+				 desc->data[i % entries_per_desc]);
 
 		dfx_message++;
 	}
@@ -205,95 +279,25 @@ static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
 
 static void hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev, const char *cmd_buf)
 {
-	int msg_num;
-
-	if (strncmp(&cmd_buf[9], "bios common", 11) == 0) {
-		msg_num = sizeof(hclge_dbg_bios_common_reg) /
-			  sizeof(struct hclge_dbg_dfx_message);
-		hclge_dbg_dump_reg_common(hdev, hclge_dbg_bios_common_reg,
-					  &cmd_buf[21], msg_num,
-					  HCLGE_DBG_DFX_BIOS_OFFSET,
-					  HCLGE_OPC_DFX_BIOS_COMMON_REG);
-	} else if (strncmp(&cmd_buf[9], "ssu", 3) == 0) {
-		msg_num = sizeof(hclge_dbg_ssu_reg_0) /
-			  sizeof(struct hclge_dbg_dfx_message);
-		hclge_dbg_dump_reg_common(hdev, hclge_dbg_ssu_reg_0,
-					  &cmd_buf[13], msg_num,
-					  HCLGE_DBG_DFX_SSU_0_OFFSET,
-					  HCLGE_OPC_DFX_SSU_REG_0);
-
-		msg_num = sizeof(hclge_dbg_ssu_reg_1) /
-			  sizeof(struct hclge_dbg_dfx_message);
-		hclge_dbg_dump_reg_common(hdev, hclge_dbg_ssu_reg_1,
-					  &cmd_buf[13], msg_num,
-					  HCLGE_DBG_DFX_SSU_1_OFFSET,
-					  HCLGE_OPC_DFX_SSU_REG_1);
-
-		msg_num = sizeof(hclge_dbg_ssu_reg_2) /
-			  sizeof(struct hclge_dbg_dfx_message);
-		hclge_dbg_dump_reg_common(hdev, hclge_dbg_ssu_reg_2,
-					  &cmd_buf[13], msg_num,
-					  HCLGE_DBG_DFX_SSU_2_OFFSET,
-					  HCLGE_OPC_DFX_SSU_REG_2);
-	} else if (strncmp(&cmd_buf[9], "igu egu", 7) == 0) {
-		msg_num = sizeof(hclge_dbg_igu_egu_reg) /
-			  sizeof(struct hclge_dbg_dfx_message);
-		hclge_dbg_dump_reg_common(hdev, hclge_dbg_igu_egu_reg,
-					  &cmd_buf[17], msg_num,
-					  HCLGE_DBG_DFX_IGU_OFFSET,
-					  HCLGE_OPC_DFX_IGU_EGU_REG);
-	} else if (strncmp(&cmd_buf[9], "rpu", 3) == 0) {
-		msg_num = sizeof(hclge_dbg_rpu_reg_0) /
-			  sizeof(struct hclge_dbg_dfx_message);
-		hclge_dbg_dump_reg_common(hdev, hclge_dbg_rpu_reg_0,
-					  &cmd_buf[13], msg_num,
-					  HCLGE_DBG_DFX_RPU_0_OFFSET,
-					  HCLGE_OPC_DFX_RPU_REG_0);
-
-		msg_num = sizeof(hclge_dbg_rpu_reg_1) /
-			  sizeof(struct hclge_dbg_dfx_message);
-		hclge_dbg_dump_reg_common(hdev, hclge_dbg_rpu_reg_1,
-					  &cmd_buf[13], msg_num,
-					  HCLGE_DBG_DFX_RPU_1_OFFSET,
-					  HCLGE_OPC_DFX_RPU_REG_1);
-	} else if (strncmp(&cmd_buf[9], "ncsi", 4) == 0) {
-		msg_num = sizeof(hclge_dbg_ncsi_reg) /
-			  sizeof(struct hclge_dbg_dfx_message);
-		hclge_dbg_dump_reg_common(hdev, hclge_dbg_ncsi_reg,
-					  &cmd_buf[14], msg_num,
-					  HCLGE_DBG_DFX_NCSI_OFFSET,
-					  HCLGE_OPC_DFX_NCSI_REG);
-	} else if (strncmp(&cmd_buf[9], "rtc", 3) == 0) {
-		msg_num = sizeof(hclge_dbg_rtc_reg) /
-			  sizeof(struct hclge_dbg_dfx_message);
-		hclge_dbg_dump_reg_common(hdev, hclge_dbg_rtc_reg,
-					  &cmd_buf[13], msg_num,
-					  HCLGE_DBG_DFX_RTC_OFFSET,
-					  HCLGE_OPC_DFX_RTC_REG);
-	} else if (strncmp(&cmd_buf[9], "ppp", 3) == 0) {
-		msg_num = sizeof(hclge_dbg_ppp_reg) /
-			  sizeof(struct hclge_dbg_dfx_message);
-		hclge_dbg_dump_reg_common(hdev, hclge_dbg_ppp_reg,
-					  &cmd_buf[13], msg_num,
-					  HCLGE_DBG_DFX_PPP_OFFSET,
-					  HCLGE_OPC_DFX_PPP_REG);
-	} else if (strncmp(&cmd_buf[9], "rcb", 3) == 0) {
-		msg_num = sizeof(hclge_dbg_rcb_reg) /
-			  sizeof(struct hclge_dbg_dfx_message);
-		hclge_dbg_dump_reg_common(hdev, hclge_dbg_rcb_reg,
-					  &cmd_buf[13], msg_num,
-					  HCLGE_DBG_DFX_RCB_OFFSET,
-					  HCLGE_OPC_DFX_RCB_REG);
-	} else if (strncmp(&cmd_buf[9], "tqp", 3) == 0) {
-		msg_num = sizeof(hclge_dbg_tqp_reg) /
-			  sizeof(struct hclge_dbg_dfx_message);
-		hclge_dbg_dump_reg_common(hdev, hclge_dbg_tqp_reg,
-					  &cmd_buf[13], msg_num,
-					  HCLGE_DBG_DFX_TQP_OFFSET,
-					  HCLGE_OPC_DFX_TQP_REG);
-	} else if (strncmp(&cmd_buf[9], "dcb", 3) == 0) {
-		hclge_dbg_dump_dcb(hdev, &cmd_buf[13]);
-	} else {
+	struct hclge_dbg_reg_type_info *reg_info = &hclge_dbg_reg_info[0];
+	bool has_dump = false;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hclge_dbg_reg_info); i++) {
+		reg_info = &hclge_dbg_reg_info[i];
+		if (!strncmp(cmd_buf, reg_info->reg_type,
+			     strlen(reg_info->reg_type))) {
+			hclge_dbg_dump_reg_common(hdev, reg_info, cmd_buf);
+			has_dump = true;
+		}
+	}
+
+	if (strncmp(cmd_buf, "dcb", 3) == 0) {
+		hclge_dbg_dump_dcb(hdev, &cmd_buf[sizeof("dcb")]);
+		has_dump = true;
+	}
+
+	if (!has_dump) {
 		dev_info(&hdev->pdev->dev, "unknown command\n");
 		return;
 	}
@@ -1092,6 +1096,8 @@ static void hclge_dbg_dump_mac_tnl_status(struct hclge_dev *hdev)
 
 int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 {
+#define DUMP_REG	"dump reg"
+
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
@@ -1111,8 +1117,8 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 		hclge_dbg_dump_qos_buf_cfg(hdev);
 	} else if (strncmp(cmd_buf, "dump mng tbl", 12) == 0) {
 		hclge_dbg_dump_mng_table(hdev);
-	} else if (strncmp(cmd_buf, "dump reg", 8) == 0) {
-		hclge_dbg_dump_reg_cmd(hdev, cmd_buf);
+	} else if (strncmp(cmd_buf, DUMP_REG, strlen(DUMP_REG)) == 0) {
+		hclge_dbg_dump_reg_cmd(hdev, &cmd_buf[sizeof(DUMP_REG)]);
 	} else if (strncmp(cmd_buf, "dump reset info", 15) == 0) {
 		hclge_dbg_dump_rst_info(hdev);
 	} else if (strncmp(cmd_buf, "dump m7 info", 12) == 0) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index d055fda..80e5cc2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -4,6 +4,9 @@
 #ifndef __HCLGE_DEBUGFS_H
 #define __HCLGE_DEBUGFS_H
 
+#include <linux/etherdevice.h>
+#include "hclge_cmd.h"
+
 #define HCLGE_DBG_BUF_LEN	   256
 #define HCLGE_DBG_MNG_TBL_MAX	   64
 
@@ -63,11 +66,24 @@ struct hclge_dbg_bitmap_cmd {
 	};
 };
 
+struct hclge_dbg_reg_common_msg {
+	int msg_num;
+	int offset;
+	enum hclge_opcode_type cmd;
+};
+
 struct hclge_dbg_dfx_message {
 	int flag;
 	char message[60];
 };
 
+#define HCLGE_DBG_MAC_REG_TYPE_LEN	32
+struct hclge_dbg_reg_type_info {
+	const char *reg_type;
+	struct hclge_dbg_dfx_message *dfx_msg;
+	struct hclge_dbg_reg_common_msg reg_msg;
+};
+
 #pragma pack()
 
 static struct hclge_dbg_dfx_message hclge_dbg_bios_common_reg[] = {
-- 
2.7.4

