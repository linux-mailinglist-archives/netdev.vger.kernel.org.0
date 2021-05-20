Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB27389B4D
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhETCXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:19 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3432 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhETCXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:17 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Flthr3nSyzCs8l;
        Thu, 20 May 2021 10:19:08 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
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
Subject: [PATCH net-next 08/15] net: hns3: refactor dump tc of debugfs
Date:   Thu, 20 May 2021 10:21:37 +0800
Message-ID: <1621477304-4495-9-git-send-email-tanhuazhong@huawei.com>
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

Currently, user gets tc schedule info by implementing debugfs command
"echo dump tc > cmd", this command will dump info in dmesg. It's
unnecessary and heavy.

To optimize it, create a single file "tc_sch_info" and use cat command
to get info. It will return info to userspace, rather than record in
dmesg.

The display style is below:
$ cat tc_sch_info
enabled tc number: 4
weight_offset: 14
TC    MODE  WEIGHT
0     dwrr     25
1     dwrr     25
2     dwrr     25
3     dwrr     25
4     dwrr      0
5     dwrr      0
6     dwrr      0
7     dwrr      0

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  8 +++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 55 ++++++++++++----------
 3 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index e783d167..dc6b8e3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -257,6 +257,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_TM_MAP,
 	HNAE3_DBG_CMD_TM_PG,
 	HNAE3_DBG_CMD_TM_PORT,
+	HNAE3_DBG_CMD_TC_SCH_INFO,
 	HNAE3_DBG_CMD_DEV_INFO,
 	HNAE3_DBG_CMD_TX_BD,
 	HNAE3_DBG_CMD_RX_BD,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 4061f1f..1719ff8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -86,6 +86,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.init = hns3_dbg_common_file_init,
 	},
 	{
+		.name = "tc_sch_info",
+		.cmd = HNAE3_DBG_CMD_TC_SCH_INFO,
+		.dentry = HNS3_DBG_DENTRY_TM,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
 		.name = "dev_info",
 		.cmd = HNAE3_DBG_CMD_DEV_INFO,
 		.dentry = HNS3_DBG_DENTRY_COMMON,
@@ -738,7 +745,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	if (!hns3_is_phys_func(h->pdev))
 		return;
 
-	dev_info(&h->pdev->dev, "dump tc\n");
 	dev_info(&h->pdev->dev, "dump qos pause cfg\n");
 	dev_info(&h->pdev->dev, "dump qos pri map\n");
 	dev_info(&h->pdev->dev, "dump qos buf cfg\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 506f0ab..bd62103 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -645,44 +645,45 @@ static int hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev,
 	return ret;
 }
 
-static void hclge_print_tc_info(struct hclge_dev *hdev, bool flag, int index)
-{
-	if (flag)
-		dev_info(&hdev->pdev->dev, "tc(%d): no sp mode weight: %u\n",
-			 index, hdev->tm_info.pg_info[0].tc_dwrr[index]);
-	else
-		dev_info(&hdev->pdev->dev, "tc(%d): sp mode\n", index);
-}
-
-static void hclge_dbg_dump_tc(struct hclge_dev *hdev)
+static int hclge_dbg_dump_tc(struct hclge_dev *hdev, char *buf, int len)
 {
 	struct hclge_ets_tc_weight_cmd *ets_weight;
 	struct hclge_desc desc;
-	int i, ret;
+	char *sch_mode_str;
+	int pos = 0;
+	int ret;
+	u8 i;
 
 	if (!hnae3_dev_dcb_supported(hdev)) {
-		dev_info(&hdev->pdev->dev,
-			 "Only DCB-supported dev supports tc\n");
-		return;
+		dev_err(&hdev->pdev->dev,
+			"Only DCB-supported dev supports tc\n");
+		return -EOPNOTSUPP;
 	}
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_ETS_TC_WEIGHT, true);
-
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
-		dev_err(&hdev->pdev->dev, "dump tc fail, ret = %d\n", ret);
-		return;
+		dev_err(&hdev->pdev->dev, "failed to get tc weight, ret = %d\n",
+			ret);
+		return ret;
 	}
 
 	ets_weight = (struct hclge_ets_tc_weight_cmd *)desc.data;
 
-	dev_info(&hdev->pdev->dev, "dump tc: %u tc enabled\n",
-		 hdev->tm_info.num_tc);
-	dev_info(&hdev->pdev->dev, "weight_offset: %u\n",
-		 ets_weight->weight_offset);
+	pos += scnprintf(buf + pos, len - pos, "enabled tc number: %u\n",
+			 hdev->tm_info.num_tc);
+	pos += scnprintf(buf + pos, len - pos, "weight_offset: %u\n",
+			 ets_weight->weight_offset);
+
+	pos += scnprintf(buf + pos, len - pos, "TC    MODE  WEIGHT\n");
+	for (i = 0; i < HNAE3_MAX_TC; i++) {
+		sch_mode_str = ets_weight->tc_weight[i] ? "dwrr" : "sp";
+		pos += scnprintf(buf + pos, len - pos, "%u     %4s    %3u\n",
+				 i, sch_mode_str,
+				 hdev->tm_info.pg_info[0].tc_dwrr[i]);
+	}
 
-	for (i = 0; i < HNAE3_MAX_TC; i++)
-		hclge_print_tc_info(hdev, ets_weight->tc_weight[i], i);
+	return 0;
 }
 
 static const struct hclge_dbg_item tm_pg_items[] = {
@@ -1893,9 +1894,7 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	if (strncmp(cmd_buf, "dump tc", 7) == 0) {
-		hclge_dbg_dump_tc(hdev);
-	} else if (strncmp(cmd_buf, "dump qos pause cfg", 18) == 0) {
+	if (strncmp(cmd_buf, "dump qos pause cfg", 18) == 0) {
 		hclge_dbg_dump_qos_pause_cfg(hdev);
 	} else if (strncmp(cmd_buf, "dump qos pri map", 16) == 0) {
 		hclge_dbg_dump_qos_pri_map(hdev);
@@ -1942,6 +1941,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.dbg_dump = hclge_dbg_dump_tm_port,
 	},
 	{
+		.cmd = HNAE3_DBG_CMD_TC_SCH_INFO,
+		.dbg_dump = hclge_dbg_dump_tc,
+	},
+	{
 		.cmd = HNAE3_DBG_CMD_MAC_UC,
 		.dbg_dump = hclge_dbg_dump_mac_uc,
 	},
-- 
2.7.4

