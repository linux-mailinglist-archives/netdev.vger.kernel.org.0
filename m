Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67776389B50
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhETCXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4755 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhETCXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:17 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Flth14sykzpfM7;
        Thu, 20 May 2021 10:18:25 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
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
Subject: [PATCH net-next 10/15] net: hns3: refactor dump qos pri map of debugfs
Date:   Thu, 20 May 2021 10:21:39 +0800
Message-ID: <1621477304-4495-11-git-send-email-tanhuazhong@huawei.com>
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

Currently, user gets priority map by implementing debugfs command
"echo dump qos pri map > cmd", this command will dump info in dmesg.
It's unnecessary and heavy.

To optimize it, create a single file "qos_pri_map" in tm directory
and use cat command to get info. It will return info to userspace,
rather than record in dmesg.

The display style is below:
$ cat qos_pri_map
vlan_to_pri: 0
PRI    TC
0       0
1       1
2       2
3       3
4       0
5       1
6       2

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  8 +++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 45 ++++++++++++++--------
 3 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index dec3c77..16a9943 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -259,6 +259,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_TM_PORT,
 	HNAE3_DBG_CMD_TC_SCH_INFO,
 	HNAE3_DBG_CMD_QOS_PAUSE_CFG,
+	HNAE3_DBG_CMD_QOS_PRI_MAP,
 	HNAE3_DBG_CMD_DEV_INFO,
 	HNAE3_DBG_CMD_TX_BD,
 	HNAE3_DBG_CMD_RX_BD,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index be2cde9c..e59060b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -100,6 +100,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.init = hns3_dbg_common_file_init,
 	},
 	{
+		.name = "qos_pri_map",
+		.cmd = HNAE3_DBG_CMD_QOS_PRI_MAP,
+		.dentry = HNS3_DBG_DENTRY_TM,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
 		.name = "dev_info",
 		.cmd = HNAE3_DBG_CMD_DEV_INFO,
 		.dentry = HNS3_DBG_DENTRY_COMMON,
@@ -752,7 +759,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	if (!hns3_is_phys_func(h->pdev))
 		return;
 
-	dev_info(&h->pdev->dev, "dump qos pri map\n");
 	dev_info(&h->pdev->dev, "dump qos buf cfg\n");
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
 	dev_info(&h->pdev->dev, "dump qs shaper [qs id]\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index f7864f8..85129a5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1053,32 +1053,41 @@ static int hclge_dbg_dump_qos_pause_cfg(struct hclge_dev *hdev, char *buf,
 	return 0;
 }
 
-static void hclge_dbg_dump_qos_pri_map(struct hclge_dev *hdev)
+static int hclge_dbg_dump_qos_pri_map(struct hclge_dev *hdev, char *buf,
+				      int len)
 {
+#define HCLGE_DBG_TC_MASK		0x0F
+#define HCLGE_DBG_TC_BIT_WIDTH		4
+
 	struct hclge_qos_pri_map_cmd *pri_map;
 	struct hclge_desc desc;
+	int pos = 0;
+	u8 *pri_tc;
+	u8 tc, i;
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_PRI_TO_TC_MAPPING, true);
-
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"dump qos pri map fail, ret = %d\n", ret);
-		return;
+			"failed to dump qos pri map, ret = %d\n", ret);
+		return ret;
 	}
 
 	pri_map = (struct hclge_qos_pri_map_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "dump qos pri map\n");
-	dev_info(&hdev->pdev->dev, "vlan_to_pri: 0x%x\n", pri_map->vlan_pri);
-	dev_info(&hdev->pdev->dev, "pri_0_to_tc: 0x%x\n", pri_map->pri0_tc);
-	dev_info(&hdev->pdev->dev, "pri_1_to_tc: 0x%x\n", pri_map->pri1_tc);
-	dev_info(&hdev->pdev->dev, "pri_2_to_tc: 0x%x\n", pri_map->pri2_tc);
-	dev_info(&hdev->pdev->dev, "pri_3_to_tc: 0x%x\n", pri_map->pri3_tc);
-	dev_info(&hdev->pdev->dev, "pri_4_to_tc: 0x%x\n", pri_map->pri4_tc);
-	dev_info(&hdev->pdev->dev, "pri_5_to_tc: 0x%x\n", pri_map->pri5_tc);
-	dev_info(&hdev->pdev->dev, "pri_6_to_tc: 0x%x\n", pri_map->pri6_tc);
-	dev_info(&hdev->pdev->dev, "pri_7_to_tc: 0x%x\n", pri_map->pri7_tc);
+
+	pos += scnprintf(buf + pos, len - pos, "vlan_to_pri: 0x%x\n",
+			 pri_map->vlan_pri);
+	pos += scnprintf(buf + pos, len - pos, "PRI  TC\n");
+
+	pri_tc = (u8 *)pri_map;
+	for (i = 0; i < HNAE3_MAX_TC; i++) {
+		tc = pri_tc[i >> 1] >> ((i & 1) * HCLGE_DBG_TC_BIT_WIDTH);
+		tc &= HCLGE_DBG_TC_MASK;
+		pos += scnprintf(buf + pos, len - pos, "%u     %u\n", i, tc);
+	}
+
+	return 0;
 }
 
 static int hclge_dbg_dump_tx_buf_cfg(struct hclge_dev *hdev)
@@ -1896,9 +1905,7 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	if (strncmp(cmd_buf, "dump qos pri map", 16) == 0) {
-		hclge_dbg_dump_qos_pri_map(hdev);
-	} else if (strncmp(cmd_buf, "dump qos buf cfg", 16) == 0) {
+	if (strncmp(cmd_buf, "dump qos buf cfg", 16) == 0) {
 		hclge_dbg_dump_qos_buf_cfg(hdev);
 	} else if (strncmp(cmd_buf, "dump serv info", 14) == 0) {
 		hclge_dbg_dump_serv_info(hdev);
@@ -1949,6 +1956,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.dbg_dump = hclge_dbg_dump_qos_pause_cfg,
 	},
 	{
+		.cmd = HNAE3_DBG_CMD_QOS_PRI_MAP,
+		.dbg_dump = hclge_dbg_dump_qos_pri_map,
+	},
+	{
 		.cmd = HNAE3_DBG_CMD_MAC_UC,
 		.dbg_dump = hclge_dbg_dump_mac_uc,
 	},
-- 
2.7.4

