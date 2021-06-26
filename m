Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6ED3B4BC2
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 03:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhFZBGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 21:06:06 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11097 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbhFZBF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 21:05:59 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GBbC443cRzZj3r;
        Sat, 26 Jun 2021 09:00:32 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 26 Jun 2021 09:03:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 26 Jun 2021 09:03:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 2/2] net: hns3: add support for dumping MAC umv counter in debugfs
Date:   Sat, 26 Jun 2021 09:00:17 +0800
Message-ID: <1624669217-38264-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1624669217-38264-1-git-send-email-huangguangbin2@huawei.com>
References: <1624669217-38264-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

This patch adds support of dumping MAC umv counter in debugfs,
which will be helpful for debugging.

The display style is below:
$ cat umv_info
num_alloc_vport  : 2
max_umv_size     : 256
wanted_umv_size  : 256
priv_umv_size    : 85
share_umv_size   : 86
vport(0) used_umv_num : 1
vport(1) used_umv_num : 1

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  7 +++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 34 ++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a6ef67e47c8a..e0b7c3c44e7b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -293,6 +293,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_FD_COUNTER,
 	HNAE3_DBG_CMD_MAC_TNL_STATUS,
 	HNAE3_DBG_CMD_SERV_INFO,
+	HNAE3_DBG_CMD_UMV_INFO,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index b72fdb94df63..532523069d74 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -330,6 +330,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "umv_info",
+		.cmd = HNAE3_DBG_CMD_UMV_INFO,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index b69c54d365a7..288788186ecc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1927,6 +1927,36 @@ static void hclge_dbg_dump_mac_list(struct hclge_dev *hdev, char *buf, int len,
 	}
 }
 
+static int hclge_dbg_dump_umv_info(struct hclge_dev *hdev, char *buf, int len)
+{
+	u8 func_num = pci_num_vf(hdev->pdev) + 1;
+	struct hclge_vport *vport;
+	int pos = 0;
+	u8 i;
+
+	pos += scnprintf(buf, len, "num_alloc_vport   : %u\n",
+			  hdev->num_alloc_vport);
+	pos += scnprintf(buf + pos, len - pos, "max_umv_size     : %u\n",
+			 hdev->max_umv_size);
+	pos += scnprintf(buf + pos, len - pos, "wanted_umv_size  : %u\n",
+			 hdev->wanted_umv_size);
+	pos += scnprintf(buf + pos, len - pos, "priv_umv_size    : %u\n",
+			 hdev->priv_umv_size);
+
+	mutex_lock(&hdev->vport_lock);
+	pos += scnprintf(buf + pos, len - pos, "share_umv_size   : %u\n",
+			 hdev->share_umv_size);
+	for (i = 0; i < func_num; i++) {
+		vport = &hdev->vport[i];
+		pos += scnprintf(buf + pos, len - pos,
+				 "vport(%u) used_umv_num : %u\n",
+				 i, vport->used_umv_num);
+	}
+	mutex_unlock(&hdev->vport_lock);
+
+	return 0;
+}
+
 static int hclge_get_vlan_rx_offload_cfg(struct hclge_dev *hdev, u8 vf_id,
 					 struct hclge_dbg_vlan_cfg *vlan_cfg)
 {
@@ -2412,6 +2442,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_FD_COUNTER,
 		.dbg_dump = hclge_dbg_dump_fd_counter,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_UMV_INFO,
+		.dbg_dump = hclge_dbg_dump_umv_info,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
-- 
2.8.1

