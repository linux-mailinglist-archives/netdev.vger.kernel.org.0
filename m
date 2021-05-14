Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397A2380274
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhEND0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:26:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3671 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbhEND0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:48 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhDPB3bS8z1BMPw;
        Fri, 14 May 2021 11:22:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 11:25:29 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/12] net: hns3: refactor dump loopback of debugfs
Date:   Fri, 14 May 2021 11:25:16 +0800
Message-ID: <1620962720-62216-9-git-send-email-tanhuazhong@huawei.com>
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

Currently, the debugfs command for loopback is implemented by
"echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create a single file
"loopback" for it, and query it by command "cat loopback",
return the result to userspace, rather than record in dmesg.

The display style is below:
$ cat loopback
mac id: 0
app loopback: off
serdes serial loopback: off
serdes parallel loopback: off

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  8 +++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 44 ++++++++++++----------
 3 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a2033cb..0a78ce2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -260,6 +260,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_MAC_UC,
 	HNAE3_DBG_CMD_MAC_MC,
 	HNAE3_DBG_CMD_MNG_TBL,
+	HNAE3_DBG_CMD_LOOPBACK,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 4af997d..d2e3965 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -97,6 +97,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "loopback",
+		.cmd = HNAE3_DBG_CMD_LOOPBACK,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -495,7 +502,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump m7 info\n");
 	dev_info(&h->pdev->dev, "dump ncl_config <offset> <length>(in hex)\n");
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
-	dev_info(&h->pdev->dev, "dump loopback\n");
 	dev_info(&h->pdev->dev, "dump qs shaper [qs id]\n");
 	dev_info(&h->pdev->dev, "dump intr\n");
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 613730f..7c02973 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -8,6 +8,7 @@
 #include "hclge_tm.h"
 #include "hnae3.h"
 
+static const char * const state_str[] = { "off", "on" };
 static const char * const hclge_mac_state_str[] = {
 	"TO_ADD", "TO_DEL", "ACTIVE"
 };
@@ -1566,32 +1567,34 @@ static void hclge_dbg_dump_ncl_config(struct hclge_dev *hdev,
 	}
 }
 
-static void hclge_dbg_dump_loopback(struct hclge_dev *hdev)
+static int hclge_dbg_dump_loopback(struct hclge_dev *hdev, char *buf, int len)
 {
 	struct phy_device *phydev = hdev->hw.mac.phydev;
 	struct hclge_config_mac_mode_cmd *req_app;
 	struct hclge_common_lb_cmd *req_common;
 	struct hclge_desc desc;
 	u8 loopback_en;
+	int pos = 0;
 	int ret;
 
 	req_app = (struct hclge_config_mac_mode_cmd *)desc.data;
 	req_common = (struct hclge_common_lb_cmd *)desc.data;
 
-	dev_info(&hdev->pdev->dev, "mac id: %u\n", hdev->hw.mac.mac_id);
+	pos += scnprintf(buf + pos, len - pos, "mac id: %u\n",
+			 hdev->hw.mac.mac_id);
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CONFIG_MAC_MODE, true);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to dump app loopback status, ret = %d\n", ret);
-		return;
+		return ret;
 	}
 
 	loopback_en = hnae3_get_bit(le32_to_cpu(req_app->txrx_pad_fcs_loop_en),
 				    HCLGE_MAC_APP_LP_B);
-	dev_info(&hdev->pdev->dev, "app loopback: %s\n",
-		 loopback_en ? "on" : "off");
+	pos += scnprintf(buf + pos, len - pos, "app loopback: %s\n",
+			 state_str[loopback_en]);
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_COMMON_LOOPBACK, true);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
@@ -1599,27 +1602,30 @@ static void hclge_dbg_dump_loopback(struct hclge_dev *hdev)
 		dev_err(&hdev->pdev->dev,
 			"failed to dump common loopback status, ret = %d\n",
 			ret);
-		return;
+		return ret;
 	}
 
 	loopback_en = req_common->enable & HCLGE_CMD_SERDES_SERIAL_INNER_LOOP_B;
-	dev_info(&hdev->pdev->dev, "serdes serial loopback: %s\n",
-		 loopback_en ? "on" : "off");
+	pos += scnprintf(buf + pos, len - pos, "serdes serial loopback: %s\n",
+			 state_str[loopback_en]);
 
 	loopback_en = req_common->enable &
-			HCLGE_CMD_SERDES_PARALLEL_INNER_LOOP_B;
-	dev_info(&hdev->pdev->dev, "serdes parallel loopback: %s\n",
-		 loopback_en ? "on" : "off");
+			HCLGE_CMD_SERDES_PARALLEL_INNER_LOOP_B ? 1 : 0;
+	pos += scnprintf(buf + pos, len - pos, "serdes parallel loopback: %s\n",
+			 state_str[loopback_en]);
 
 	if (phydev) {
-		dev_info(&hdev->pdev->dev, "phy loopback: %s\n",
-			 phydev->loopback_enabled ? "on" : "off");
+		loopback_en = phydev->loopback_enabled;
+		pos += scnprintf(buf + pos, len - pos, "phy loopback: %s\n",
+				 state_str[loopback_en]);
 	} else if (hnae3_dev_phy_imp_supported(hdev)) {
 		loopback_en = req_common->enable &
 			      HCLGE_CMD_GE_PHY_INNER_LOOP_B;
-		dev_info(&hdev->pdev->dev, "phy loopback: %s\n",
-			 loopback_en ? "on" : "off");
+		pos += scnprintf(buf + pos, len - pos, "phy loopback: %s\n",
+				 state_str[loopback_en]);
 	}
+
+	return 0;
 }
 
 /* hclge_dbg_dump_mac_tnl_status: print message about mac tnl interrupt
@@ -1785,7 +1791,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 {
 #define DUMP_REG	"dump reg"
 #define DUMP_TM_MAP	"dump tm map"
-#define DUMP_LOOPBACK	"dump loopback"
 #define DUMP_INTERRUPT	"dump intr"
 
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -1818,9 +1823,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 					  &cmd_buf[sizeof("dump ncl_config")]);
 	} else if (strncmp(cmd_buf, "dump mac tnl status", 19) == 0) {
 		hclge_dbg_dump_mac_tnl_status(hdev);
-	} else if (strncmp(cmd_buf, DUMP_LOOPBACK,
-		   strlen(DUMP_LOOPBACK)) == 0) {
-		hclge_dbg_dump_loopback(hdev);
 	} else if (strncmp(cmd_buf, "dump qs shaper", 14) == 0) {
 		hclge_dbg_dump_qs_shaper(hdev,
 					 &cmd_buf[sizeof("dump qs shaper")]);
@@ -1860,6 +1862,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_MNG_TBL,
 		.dbg_dump = hclge_dbg_dump_mng_table,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_LOOPBACK,
+		.dbg_dump = hclge_dbg_dump_loopback,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
-- 
2.7.4

