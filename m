Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF33938027A
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhEND04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:26:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3676 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhEND0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:49 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhDPB1jc2z1BMPg;
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
Subject: [PATCH net-next 09/12] net: hns3: refactor dump intr of debugfs
Date:   Fri, 14 May 2021 11:25:17 +0800
Message-ID: <1620962720-62216-10-git-send-email-tanhuazhong@huawei.com>
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

Currently, the debugfs command for intr is implemented by
"echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create a single file
"interrupt_info" for it, and query it by command "cat interrupt_info",
return the result to userspace, rather than record in dmesg.

The display style is below:
$cat interrupt_info
num_nic_msi: 65
num_roce_msi: 65
num_msi_used: 2
num_msi_left: 128

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  8 ++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 26 ++++++++++++++--------
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 0a78ce2..aea6ddd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -261,6 +261,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_MAC_MC,
 	HNAE3_DBG_CMD_MNG_TBL,
 	HNAE3_DBG_CMD_LOOPBACK,
+	HNAE3_DBG_CMD_INTERRUPT_INFO,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index d2e3965..0eb5eda 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -104,6 +104,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "interrupt_info",
+		.cmd = HNAE3_DBG_CMD_INTERRUPT_INFO,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -503,7 +510,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump ncl_config <offset> <length>(in hex)\n");
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
 	dev_info(&h->pdev->dev, "dump qs shaper [qs id]\n");
-	dev_info(&h->pdev->dev, "dump intr\n");
 
 	memset(printf_buf, 0, HNS3_DBG_BUF_LEN);
 	strncat(printf_buf, "dump reg [[bios common] [ssu <port_id>]",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 7c02973..c3d84a4b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1430,12 +1430,20 @@ static void hclge_dbg_dump_serv_info(struct hclge_dev *hdev)
 		 hdev->serv_processed_cnt);
 }
 
-static void hclge_dbg_dump_interrupt(struct hclge_dev *hdev)
+static int hclge_dbg_dump_interrupt(struct hclge_dev *hdev, char *buf, int len)
 {
-	dev_info(&hdev->pdev->dev, "num_nic_msi: %u\n", hdev->num_nic_msi);
-	dev_info(&hdev->pdev->dev, "num_roce_msi: %u\n", hdev->num_roce_msi);
-	dev_info(&hdev->pdev->dev, "num_msi_used: %u\n", hdev->num_msi_used);
-	dev_info(&hdev->pdev->dev, "num_msi_left: %u\n", hdev->num_msi_left);
+	int pos = 0;
+
+	pos += scnprintf(buf + pos, len - pos, "num_nic_msi: %u\n",
+			 hdev->num_nic_msi);
+	pos += scnprintf(buf + pos, len - pos, "num_roce_msi: %u\n",
+			 hdev->num_roce_msi);
+	pos += scnprintf(buf + pos, len - pos, "num_msi_used: %u\n",
+			 hdev->num_msi_used);
+	pos += scnprintf(buf + pos, len - pos, "num_msi_left: %u\n",
+			 hdev->num_msi_left);
+
+	return 0;
 }
 
 static void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
@@ -1791,7 +1799,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 {
 #define DUMP_REG	"dump reg"
 #define DUMP_TM_MAP	"dump tm map"
-#define DUMP_INTERRUPT	"dump intr"
 
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
@@ -1826,9 +1833,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 	} else if (strncmp(cmd_buf, "dump qs shaper", 14) == 0) {
 		hclge_dbg_dump_qs_shaper(hdev,
 					 &cmd_buf[sizeof("dump qs shaper")]);
-	} else if (strncmp(cmd_buf, DUMP_INTERRUPT,
-		   strlen(DUMP_INTERRUPT)) == 0) {
-		hclge_dbg_dump_interrupt(hdev);
 	} else {
 		dev_info(&hdev->pdev->dev, "unknown command\n");
 		return -EINVAL;
@@ -1866,6 +1870,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_LOOPBACK,
 		.dbg_dump = hclge_dbg_dump_loopback,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_INTERRUPT_INFO,
+		.dbg_dump = hclge_dbg_dump_interrupt,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
-- 
2.7.4

