Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C9E38027B
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhEND06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:26:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3677 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbhEND0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:49 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhDPB41RHz1BMQ1;
        Fri, 14 May 2021 11:22:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 11:25:29 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Jiaran Zhang <zhangjiaran@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 10/12] net: hns3: refactor dump reset info of debugfs
Date:   Fri, 14 May 2021 11:25:18 +0800
Message-ID: <1620962720-62216-11-git-send-email-tanhuazhong@huawei.com>
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

Currently, the debugfs command for reset info is implemented by
"echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create a single file
"reset_info" for it, and query it by command "cat reset_info",
return the result to userspace, rather than record in dmesg.

The display style is below:
$cat reset_info
PF reset count: 0
FLR reset count: 0
GLOBAL reset count: 0
IMP reset count: 0
reset done count: 0
HW reset done count: 0
reset count: 0
reset fail count: 0
vector0 interrupt enable status: 0x1
reset interrupt source: 0x0
reset interrupt status: 0x0
RAS interrupt status:0x0
hardware reset status: 0x0
handshake status: 0x80
function reset status: 0x0

Change to the "hclge_show_rst_info" in the "hclge_reset_err_handle",
when the reset fails, display reset info immediately.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  8 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 76 +++++++++++++---------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 17 ++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  4 +-
 5 files changed, 71 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index aea6ddd..455174c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -262,6 +262,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_MNG_TBL,
 	HNAE3_DBG_CMD_LOOPBACK,
 	HNAE3_DBG_CMD_INTERRUPT_INFO,
+	HNAE3_DBG_CMD_RESET_INFO,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 0eb5eda..49c87c8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -111,6 +111,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "reset_info",
+		.cmd = HNAE3_DBG_CMD_RESET_INFO,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -505,7 +512,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump qos pause cfg\n");
 	dev_info(&h->pdev->dev, "dump qos pri map\n");
 	dev_info(&h->pdev->dev, "dump qos buf cfg\n");
-	dev_info(&h->pdev->dev, "dump reset info\n");
 	dev_info(&h->pdev->dev, "dump m7 info\n");
 	dev_info(&h->pdev->dev, "dump ncl_config <offset> <length>(in hex)\n");
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index c3d84a4b..736746b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -4,6 +4,7 @@
 #include <linux/device.h>
 
 #include "hclge_debugfs.h"
+#include "hclge_err.h"
 #include "hclge_main.h"
 #include "hclge_tm.h"
 #include "hnae3.h"
@@ -1389,37 +1390,46 @@ static void hclge_dbg_fd_tcam(struct hclge_dev *hdev)
 	kfree(rule_locs);
 }
 
-void hclge_dbg_dump_rst_info(struct hclge_dev *hdev)
+int hclge_dbg_dump_rst_info(struct hclge_dev *hdev, char *buf, int len)
 {
-	dev_info(&hdev->pdev->dev, "PF reset count: %u\n",
-		 hdev->rst_stats.pf_rst_cnt);
-	dev_info(&hdev->pdev->dev, "FLR reset count: %u\n",
-		 hdev->rst_stats.flr_rst_cnt);
-	dev_info(&hdev->pdev->dev, "GLOBAL reset count: %u\n",
-		 hdev->rst_stats.global_rst_cnt);
-	dev_info(&hdev->pdev->dev, "IMP reset count: %u\n",
-		 hdev->rst_stats.imp_rst_cnt);
-	dev_info(&hdev->pdev->dev, "reset done count: %u\n",
-		 hdev->rst_stats.reset_done_cnt);
-	dev_info(&hdev->pdev->dev, "HW reset done count: %u\n",
-		 hdev->rst_stats.hw_reset_done_cnt);
-	dev_info(&hdev->pdev->dev, "reset count: %u\n",
-		 hdev->rst_stats.reset_cnt);
-	dev_info(&hdev->pdev->dev, "reset fail count: %u\n",
-		 hdev->rst_stats.reset_fail_cnt);
-	dev_info(&hdev->pdev->dev, "vector0 interrupt enable status: 0x%x\n",
-		 hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_REG_BASE));
-	dev_info(&hdev->pdev->dev, "reset interrupt source: 0x%x\n",
-		 hclge_read_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG));
-	dev_info(&hdev->pdev->dev, "reset interrupt status: 0x%x\n",
-		 hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS));
-	dev_info(&hdev->pdev->dev, "hardware reset status: 0x%x\n",
-		 hclge_read_dev(&hdev->hw, HCLGE_GLOBAL_RESET_REG));
-	dev_info(&hdev->pdev->dev, "handshake status: 0x%x\n",
-		 hclge_read_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG));
-	dev_info(&hdev->pdev->dev, "function reset status: 0x%x\n",
-		 hclge_read_dev(&hdev->hw, HCLGE_FUN_RST_ING));
-	dev_info(&hdev->pdev->dev, "hdev state: 0x%lx\n", hdev->state);
+	int pos = 0;
+
+	pos += scnprintf(buf + pos, len - pos, "PF reset count: %u\n",
+			 hdev->rst_stats.pf_rst_cnt);
+	pos += scnprintf(buf + pos, len - pos, "FLR reset count: %u\n",
+			 hdev->rst_stats.flr_rst_cnt);
+	pos += scnprintf(buf + pos, len - pos, "GLOBAL reset count: %u\n",
+			 hdev->rst_stats.global_rst_cnt);
+	pos += scnprintf(buf + pos, len - pos, "IMP reset count: %u\n",
+			 hdev->rst_stats.imp_rst_cnt);
+	pos += scnprintf(buf + pos, len - pos, "reset done count: %u\n",
+			 hdev->rst_stats.reset_done_cnt);
+	pos += scnprintf(buf + pos, len - pos, "HW reset done count: %u\n",
+			 hdev->rst_stats.hw_reset_done_cnt);
+	pos += scnprintf(buf + pos, len - pos, "reset count: %u\n",
+			 hdev->rst_stats.reset_cnt);
+	pos += scnprintf(buf + pos, len - pos, "reset fail count: %u\n",
+			 hdev->rst_stats.reset_fail_cnt);
+	pos += scnprintf(buf + pos, len - pos,
+			 "vector0 interrupt enable status: 0x%x\n",
+			 hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_REG_BASE));
+	pos += scnprintf(buf + pos, len - pos, "reset interrupt source: 0x%x\n",
+			 hclge_read_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG));
+	pos += scnprintf(buf + pos, len - pos, "reset interrupt status: 0x%x\n",
+			 hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS));
+	pos += scnprintf(buf + pos, len - pos, "RAS interrupt status: 0x%x\n",
+			 hclge_read_dev(&hdev->hw,
+					HCLGE_RAS_PF_OTHER_INT_STS_REG));
+	pos += scnprintf(buf + pos, len - pos, "hardware reset status: 0x%x\n",
+			 hclge_read_dev(&hdev->hw, HCLGE_GLOBAL_RESET_REG));
+	pos += scnprintf(buf + pos, len - pos, "handshake status: 0x%x\n",
+			 hclge_read_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG));
+	pos += scnprintf(buf + pos, len - pos, "function reset status: 0x%x\n",
+			 hclge_read_dev(&hdev->hw, HCLGE_FUN_RST_ING));
+	pos += scnprintf(buf + pos, len - pos, "hdev state: 0x%lx\n",
+			 hdev->state);
+
+	return 0;
 }
 
 static void hclge_dbg_dump_serv_info(struct hclge_dev *hdev)
@@ -1819,8 +1829,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 		hclge_dbg_dump_qos_buf_cfg(hdev);
 	} else if (strncmp(cmd_buf, DUMP_REG, strlen(DUMP_REG)) == 0) {
 		hclge_dbg_dump_reg_cmd(hdev, &cmd_buf[sizeof(DUMP_REG)]);
-	} else if (strncmp(cmd_buf, "dump reset info", 15) == 0) {
-		hclge_dbg_dump_rst_info(hdev);
 	} else if (strncmp(cmd_buf, "dump serv info", 14) == 0) {
 		hclge_dbg_dump_serv_info(hdev);
 	} else if (strncmp(cmd_buf, "dump m7 info", 12) == 0) {
@@ -1874,6 +1882,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_INTERRUPT_INFO,
 		.dbg_dump = hclge_dbg_dump_interrupt,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_RESET_INFO,
+		.dbg_dump = hclge_dbg_dump_rst_info,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 55b0453..d4d3f0b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3936,6 +3936,21 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 	return ret;
 }
 
+static void hclge_show_rst_info(struct hclge_dev *hdev)
+{
+	char *buf;
+
+	buf = kzalloc(HCLGE_DBG_RESET_INFO_LEN, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	hclge_dbg_dump_rst_info(hdev, buf, HCLGE_DBG_RESET_INFO_LEN);
+
+	dev_info(&hdev->pdev->dev, "dump reset info:\n%s", buf);
+
+	kfree(buf);
+}
+
 static bool hclge_reset_err_handle(struct hclge_dev *hdev)
 {
 #define MAX_RESET_FAIL_CNT 5
@@ -3966,7 +3981,7 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev)
 
 	dev_err(&hdev->pdev->dev, "Reset fail!\n");
 
-	hclge_dbg_dump_rst_info(hdev);
+	hclge_show_rst_info(hdev);
 
 	set_bit(HCLGE_STATE_RST_FAIL, &hdev->state);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9e17c02..8bf451e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -148,6 +148,8 @@
 
 #define HCLGE_MAX_QSET_NUM		1024
 
+#define HCLGE_DBG_RESET_INFO_LEN	1024
+
 enum HLCGE_PORT_TYPE {
 	HOST_PORT,
 	NETWORK_PORT
@@ -1089,6 +1091,6 @@ int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev,
 void hclge_report_hw_error(struct hclge_dev *hdev,
 			   enum hnae3_hw_error_type type);
 void hclge_inform_vf_promisc_info(struct hclge_vport *vport);
-void hclge_dbg_dump_rst_info(struct hclge_dev *hdev);
+int hclge_dbg_dump_rst_info(struct hclge_dev *hdev, char *buf, int len);
 int hclge_push_vf_link_status(struct hclge_vport *vport);
 #endif
-- 
2.7.4

