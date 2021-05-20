Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737CB389B53
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhETCX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4545 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhETCXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:18 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Flths5ZD2zkYFm;
        Thu, 20 May 2021 10:19:09 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:55 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:55 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 09/15] net: hns3: refactor dump qos pause cfg of debugfs
Date:   Thu, 20 May 2021 10:21:38 +0800
Message-ID: <1621477304-4495-10-git-send-email-tanhuazhong@huawei.com>
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

From: Guangbin Huang <huangguangbin2@huawei.com>

Currently, user gets pause config by implementing debugfs command
"echo dump qos pause cfg > cmd", this command will dump info in dmesg.
It's unnecessary and heavy.

To optimize it, create a single file "qos_pause_cfg" in tm directory
and use cat command to get info. It will return info to userspace,
rather than record in dmesg.

The display style is below:
$ cat qos_pause_cfg
pause_trans_gap: 0x7f
pause_trans_time: 0xffff

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  8 +++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 30 ++++++++++++----------
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index dc6b8e3..dec3c77 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -258,6 +258,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_TM_PG,
 	HNAE3_DBG_CMD_TM_PORT,
 	HNAE3_DBG_CMD_TC_SCH_INFO,
+	HNAE3_DBG_CMD_QOS_PAUSE_CFG,
 	HNAE3_DBG_CMD_DEV_INFO,
 	HNAE3_DBG_CMD_TX_BD,
 	HNAE3_DBG_CMD_RX_BD,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 1719ff8..be2cde9c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -93,6 +93,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.init = hns3_dbg_common_file_init,
 	},
 	{
+		.name = "qos_pause_cfg",
+		.cmd = HNAE3_DBG_CMD_QOS_PAUSE_CFG,
+		.dentry = HNS3_DBG_DENTRY_TM,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
 		.name = "dev_info",
 		.cmd = HNAE3_DBG_CMD_DEV_INFO,
 		.dentry = HNS3_DBG_DENTRY_COMMON,
@@ -745,7 +752,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	if (!hns3_is_phys_func(h->pdev))
 		return;
 
-	dev_info(&h->pdev->dev, "dump qos pause cfg\n");
 	dev_info(&h->pdev->dev, "dump qos pri map\n");
 	dev_info(&h->pdev->dev, "dump qos buf cfg\n");
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index bd62103..f7864f8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1028,27 +1028,29 @@ static int hclge_dbg_dump_tm_qset(struct hclge_dev *hdev, char *buf, int len)
 	return 0;
 }
 
-static void hclge_dbg_dump_qos_pause_cfg(struct hclge_dev *hdev)
+static int hclge_dbg_dump_qos_pause_cfg(struct hclge_dev *hdev, char *buf,
+					int len)
 {
 	struct hclge_cfg_pause_param_cmd *pause_param;
 	struct hclge_desc desc;
+	int pos = 0;
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CFG_MAC_PARA, true);
-
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
-		dev_err(&hdev->pdev->dev, "dump checksum fail, ret = %d\n",
-			ret);
-		return;
+		dev_err(&hdev->pdev->dev,
+			"failed to dump qos pause, ret = %d\n", ret);
+		return ret;
 	}
 
 	pause_param = (struct hclge_cfg_pause_param_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "dump qos pause cfg\n");
-	dev_info(&hdev->pdev->dev, "pause_trans_gap: 0x%x\n",
-		 pause_param->pause_trans_gap);
-	dev_info(&hdev->pdev->dev, "pause_trans_time: 0x%x\n",
-		 le16_to_cpu(pause_param->pause_trans_time));
+
+	pos += scnprintf(buf + pos, len - pos, "pause_trans_gap: 0x%x\n",
+			 pause_param->pause_trans_gap);
+	pos += scnprintf(buf + pos, len - pos, "pause_trans_time: 0x%x\n",
+			 le16_to_cpu(pause_param->pause_trans_time));
+	return 0;
 }
 
 static void hclge_dbg_dump_qos_pri_map(struct hclge_dev *hdev)
@@ -1894,9 +1896,7 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	if (strncmp(cmd_buf, "dump qos pause cfg", 18) == 0) {
-		hclge_dbg_dump_qos_pause_cfg(hdev);
-	} else if (strncmp(cmd_buf, "dump qos pri map", 16) == 0) {
+	if (strncmp(cmd_buf, "dump qos pri map", 16) == 0) {
 		hclge_dbg_dump_qos_pri_map(hdev);
 	} else if (strncmp(cmd_buf, "dump qos buf cfg", 16) == 0) {
 		hclge_dbg_dump_qos_buf_cfg(hdev);
@@ -1945,6 +1945,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.dbg_dump = hclge_dbg_dump_tc,
 	},
 	{
+		.cmd = HNAE3_DBG_CMD_QOS_PAUSE_CFG,
+		.dbg_dump = hclge_dbg_dump_qos_pause_cfg,
+	},
+	{
 		.cmd = HNAE3_DBG_CMD_MAC_UC,
 		.dbg_dump = hclge_dbg_dump_mac_uc,
 	},
-- 
2.7.4

