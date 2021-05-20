Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48BA389B5B
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhETCXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4547 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhETCXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:19 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fltht0Xm2zkYCr;
        Thu, 20 May 2021 10:19:10 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
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
        <linuxarm@huawei.com>, Jiaran Zhang <zhangjiaran@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 13/15] net: hns3: refactor dump mac tnl status of debugfs
Date:   Thu, 20 May 2021 10:21:42 +0800
Message-ID: <1621477304-4495-14-git-send-email-tanhuazhong@huawei.com>
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

From: Jiaran Zhang <zhangjiaran@huawei.com>

Currently, the debugfs command for dump mac tnl status is
implemented by "echo xxxx > cmd", and record the information
in dmesg. It's unnecessary and heavy. To improve it, create
a single file "mac_tnl_status" for it, and query it by command
"cat mac_tnl_status", return the result to userspace, rather
than record in dmesg.

The display style is below:
$ cat mac_tnl_status
Recently generated mac tnl interruption:
[0111204.175437] status = 0x30
[0154120.329912] status = 0x30

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 12 ++++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 23 +++++++++++++++-------
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 9af1d64..ed06431 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -287,6 +287,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_RX_QUEUE_INFO,
 	HNAE3_DBG_CMD_TX_QUEUE_INFO,
 	HNAE3_DBG_CMD_FD_TCAM,
+	HNAE3_DBG_CMD_MAC_TNL_STATUS,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 599b405..04c19a0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -191,6 +191,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.init = hns3_dbg_common_file_init,
 	},
 	{
+		.name = "mac_tnl_status",
+		.cmd = HNAE3_DBG_CMD_MAC_TNL_STATUS,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
 		.name = "bios_common",
 		.cmd = HNAE3_DBG_CMD_REG_BIOS_COMMON,
 		.dentry = HNS3_DBG_DENTRY_REG,
@@ -762,11 +769,6 @@ static int hns3_dbg_tx_bd_info(struct hns3_dbg_data *d, char *buf, int len)
 static void hns3_dbg_help(struct hnae3_handle *h)
 {
 	dev_info(&h->pdev->dev, "available commands\n");
-
-	if (!hns3_is_phys_func(h->pdev))
-		return;
-
-	dev_info(&h->pdev->dev, "dump mac tnl status\n");
 }
 
 static void
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 2b7acf6..fe7ceab 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1807,21 +1807,28 @@ static int hclge_dbg_dump_loopback(struct hclge_dev *hdev, char *buf, int len)
 /* hclge_dbg_dump_mac_tnl_status: print message about mac tnl interrupt
  * @hdev: pointer to struct hclge_dev
  */
-static void hclge_dbg_dump_mac_tnl_status(struct hclge_dev *hdev)
+static int
+hclge_dbg_dump_mac_tnl_status(struct hclge_dev *hdev, char *buf, int len)
 {
 #define HCLGE_BILLION_NANO_SECONDS 1000000000
 
 	struct hclge_mac_tnl_stats stats;
 	unsigned long rem_nsec;
+	int pos = 0;
 
-	dev_info(&hdev->pdev->dev, "Recently generated mac tnl interruption:\n");
+	pos += scnprintf(buf + pos, len - pos,
+			 "Recently generated mac tnl interruption:\n");
 
 	while (kfifo_get(&hdev->mac_tnl_log, &stats)) {
 		rem_nsec = do_div(stats.time, HCLGE_BILLION_NANO_SECONDS);
-		dev_info(&hdev->pdev->dev, "[%07lu.%03lu] status = 0x%x\n",
-			 (unsigned long)stats.time, rem_nsec / 1000,
-			 stats.status);
+
+		pos += scnprintf(buf + pos, len - pos,
+				 "[%07lu.%03lu] status = 0x%x\n",
+				 (unsigned long)stats.time, rem_nsec / 1000,
+				 stats.status);
 	}
+
+	return 0;
 }
 
 
@@ -1895,8 +1902,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 
 	if (strncmp(cmd_buf, "dump serv info", 14) == 0) {
 		hclge_dbg_dump_serv_info(hdev);
-	} else if (strncmp(cmd_buf, "dump mac tnl status", 19) == 0) {
-		hclge_dbg_dump_mac_tnl_status(hdev);
 	} else {
 		dev_info(&hdev->pdev->dev, "unknown command\n");
 		return -EINVAL;
@@ -2026,6 +2031,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_FD_TCAM,
 		.dbg_dump = hclge_dbg_dump_fd_tcam,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_MAC_TNL_STATUS,
+		.dbg_dump = hclge_dbg_dump_mac_tnl_status,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
-- 
2.7.4

