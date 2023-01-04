Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00A365CB73
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 02:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238591AbjADBec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 20:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238567AbjADBeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 20:34:18 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BF1FE3
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 17:34:17 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NmsYX1jHLzJr6b;
        Wed,  4 Jan 2023 09:33:04 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 4 Jan 2023 09:34:15 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <shenjian15@huawei.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 2/2] net: hns3: support debugfs for wake on lan
Date:   Wed, 4 Jan 2023 09:34:05 +0800
Message-ID: <20230104013405.65433-3-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230104013405.65433-1-lanhao@huawei.com>
References: <20230104013405.65433-1-lanhao@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement debugfs for wake on lan to hns3. The debugfs
support verify the firmware wake on lan configuration.

Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 10 +++
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 62 +++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 312ac1cccd39..939308f8f472 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -321,6 +321,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_UMV_INFO,
 	HNAE3_DBG_CMD_PAGE_POOL_INFO,
 	HNAE3_DBG_CMD_COAL_INFO,
+	HNAE3_DBG_CMD_WOL_INFO,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 66feb23f7b7b..679a39aab801 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -357,6 +357,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN_1MB,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "wol_info",
+		.cmd = HNAE3_DBG_CMD_WOL_INFO,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -408,6 +415,9 @@ static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
 	}, {
 		.name = "support lane num",
 		.cap_bit = HNAE3_DEV_SUPPORT_LANE_NUM_B,
+	}, {
+		.name = "support wake on lan",
+		.cap_bit = HNAE3_DEV_SUPPORT_WOL_B,
 	}
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 142415c84c6b..fdbf031bcd49 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -2394,6 +2394,64 @@ static int hclge_dbg_dump_mac_mc(struct hclge_dev *hdev, char *buf, int len)
 	return 0;
 }
 
+static void hclge_dump_wol_mode(u32 mode, char *buf, int len, int *pos)
+{
+	if (mode & HCLGE_WOL_PHY)
+		*pos += scnprintf(buf + *pos, len - *pos, "  [p]phy\n");
+
+	if (mode & HCLGE_WOL_UNICAST)
+		*pos += scnprintf(buf + *pos, len - *pos, "  [u]unicast\n");
+
+	if (mode & HCLGE_WOL_MULTICAST)
+		*pos += scnprintf(buf + *pos, len - *pos, "  [m]multicast\n");
+
+	if (mode & HCLGE_WOL_BROADCAST)
+		*pos += scnprintf(buf + *pos, len - *pos, "  [b]broadcast\n");
+
+	if (mode & HCLGE_WOL_ARP)
+		*pos += scnprintf(buf + *pos, len - *pos, "  [a]arp\n");
+
+	if (mode & HCLGE_WOL_MAGIC)
+		*pos += scnprintf(buf + *pos, len - *pos, "  [g]magic\n");
+
+	if (mode & HCLGE_WOL_MAGICSECURED)
+		*pos += scnprintf(buf + *pos, len - *pos,
+				 "  [s]magic secured\n");
+
+	if (mode & HCLGE_WOL_FILTER)
+		*pos += scnprintf(buf + *pos, len - *pos, "  [f]filter\n");
+}
+
+static int hclge_dbg_dump_wol_info(struct hclge_dev *hdev, char *buf, int len)
+{
+	u32 wol_supported;
+	int pos = 0;
+	u32 mode;
+
+	if (!hnae3_ae_dev_wol_supported(hdev->ae_dev)) {
+		pos += scnprintf(buf + pos, len - pos,
+				 "wake-on-lan is unsupported\n");
+		return 0;
+	}
+
+	pos += scnprintf(buf + pos, len - pos, "wake-on-lan mode:\n");
+	pos += scnprintf(buf + pos, len - pos, " supported:\n");
+	if (hclge_get_wol_supported_mode(hdev, &wol_supported))
+		return -EINVAL;
+
+	hclge_dump_wol_mode(wol_supported, buf, len, &pos);
+
+	pos += scnprintf(buf + pos, len - pos, " current:\n");
+	if (hclge_get_wol_cfg(hdev, &mode))
+		return -EINVAL;
+	if (mode)
+		hclge_dump_wol_mode(mode, buf, len, &pos);
+	else
+		pos += scnprintf(buf + pos, len - pos, "  [d]disabled\n");
+
+	return 0;
+}
+
 static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 	{
 		.cmd = HNAE3_DBG_CMD_TM_NODES,
@@ -2543,6 +2601,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_UMV_INFO,
 		.dbg_dump = hclge_dbg_dump_umv_info,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_WOL_INFO,
+		.dbg_dump = hclge_dbg_dump_wol_info,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
-- 
2.30.0

