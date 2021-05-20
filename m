Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C180A389B58
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhETCXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4546 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhETCXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:18 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fltht1s0mzkXJL;
        Thu, 20 May 2021 10:19:10 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:56 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:56 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 14/15] net: hns3: refactor dump serv info of debugfs
Date:   Thu, 20 May 2021 10:21:43 +0800
Message-ID: <1621477304-4495-15-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621477304-4495-1-git-send-email-tanhuazhong@huawei.com>
References: <1621477304-4495-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Currently, the debugfs command for serv info is implemented by
"echo xxxx > cmd", and record the inforamtion in dmesg. It's
unnecessary and heavy. To improve it, create a single file
"serv_info" for it, and query it by command "cat serv_info",
return the result to userspace, rather than record in dmesg.

The display style is below:
$ cat service_task_info
local_clock: [  114.203321]
delta: 784(ms)
last_service_task_processed: 4294918512(jiffies)
last_service_task_cnt: 4

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  7 ++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 39 ++++++++++++++--------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |  2 ++
 4 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index ed06431..09a0658 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -288,6 +288,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_TX_QUEUE_INFO,
 	HNAE3_DBG_CMD_FD_TCAM,
 	HNAE3_DBG_CMD_MAC_TNL_STATUS,
+	HNAE3_DBG_CMD_SERV_INFO,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 04c19a0..04102d7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -302,6 +302,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "service_task_info",
+		.cmd = HNAE3_DBG_CMD_SERV_INFO,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index fe7ceab..e7a043a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1590,12 +1590,26 @@ int hclge_dbg_dump_rst_info(struct hclge_dev *hdev, char *buf, int len)
 	return 0;
 }
 
-static void hclge_dbg_dump_serv_info(struct hclge_dev *hdev)
+static int hclge_dbg_dump_serv_info(struct hclge_dev *hdev, char *buf, int len)
 {
-	dev_info(&hdev->pdev->dev, "last_serv_processed: %lu\n",
-		 hdev->last_serv_processed);
-	dev_info(&hdev->pdev->dev, "last_serv_cnt: %lu\n",
-		 hdev->serv_processed_cnt);
+	unsigned long rem_nsec;
+	int pos = 0;
+	u64 lc;
+
+	lc = local_clock();
+	rem_nsec = do_div(lc, HCLGE_BILLION_NANO_SECONDS);
+
+	pos += scnprintf(buf + pos, len - pos, "local_clock: [%5lu.%06lu]\n",
+			 (unsigned long)lc, rem_nsec / 1000);
+	pos += scnprintf(buf + pos, len - pos, "delta: %u(ms)\n",
+			 jiffies_to_msecs(jiffies - hdev->last_serv_processed));
+	pos += scnprintf(buf + pos, len - pos,
+			 "last_service_task_processed: %lu(jiffies)\n",
+			 hdev->last_serv_processed);
+	pos += scnprintf(buf + pos, len - pos, "last_service_task_cnt: %lu\n",
+			 hdev->serv_processed_cnt);
+
+	return 0;
 }
 
 static int hclge_dbg_dump_interrupt(struct hclge_dev *hdev, char *buf, int len)
@@ -1810,8 +1824,6 @@ static int hclge_dbg_dump_loopback(struct hclge_dev *hdev, char *buf, int len)
 static int
 hclge_dbg_dump_mac_tnl_status(struct hclge_dev *hdev, char *buf, int len)
 {
-#define HCLGE_BILLION_NANO_SECONDS 1000000000
-
 	struct hclge_mac_tnl_stats stats;
 	unsigned long rem_nsec;
 	int pos = 0;
@@ -1900,14 +1912,9 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	if (strncmp(cmd_buf, "dump serv info", 14) == 0) {
-		hclge_dbg_dump_serv_info(hdev);
-	} else {
-		dev_info(&hdev->pdev->dev, "unknown command\n");
-		return -EINVAL;
-	}
+	dev_info(&hdev->pdev->dev, "unknown command\n");
 
-	return 0;
+	return -EINVAL;
 }
 
 static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
@@ -2035,6 +2042,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_MAC_TNL_STATUS,
 		.dbg_dump = hclge_dbg_dump_mac_tnl_status,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_SERV_INFO,
+		.dbg_dump = hclge_dbg_dump_serv_info,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index c4956e3..642752e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -740,6 +740,8 @@ static const struct hclge_dbg_dfx_message hclge_dbg_tqp_reg[] = {
 #define HCLGE_DBG_DATA_STR_LEN			32
 #define HCLGE_DBG_TM_INFO_LEN			256
 
+#define HCLGE_BILLION_NANO_SECONDS	1000000000
+
 struct hclge_dbg_item {
 	char name[HCLGE_DBG_ITEM_NAME_LEN];
 	u16 interval; /* blank numbers after the item */
-- 
2.7.4

