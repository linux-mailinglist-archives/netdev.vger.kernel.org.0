Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACDB1B6B4C
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgDXCYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:24:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2890 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbgDXCYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:24:30 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BD23EB95B492380BB2FC;
        Fri, 24 Apr 2020 10:24:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Fri, 24 Apr 2020 10:24:17 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/8] net: hns3: add support for dumping UC and MC MAC list
Date:   Fri, 24 Apr 2020 10:23:10 +0800
Message-ID: <1587694993-25183-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
References: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

This patch adds support for dumping entries of UC and MC MAC list,
which help checking whether a MAC address being added into hardware
or not.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 51 ++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index c934f32..fe7fb56 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -262,6 +262,8 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
 	dev_info(&h->pdev->dev, "dump loopback\n");
 	dev_info(&h->pdev->dev, "dump qs shaper [qs id]\n");
+	dev_info(&h->pdev->dev, "dump uc mac list <func id>\n");
+	dev_info(&h->pdev->dev, "dump mc mac list <func id>\n");
 
 	memset(printf_buf, 0, HNS3_DBG_BUF_LEN);
 	strncat(printf_buf, "dump reg [[bios common] [ssu <port_id>]",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 66c1ad3..6cfa825 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1441,6 +1441,49 @@ static void hclge_dbg_dump_qs_shaper(struct hclge_dev *hdev,
 	hclge_dbg_dump_qs_shaper_single(hdev, qsid);
 }
 
+static int hclge_dbg_dump_mac_list(struct hclge_dev *hdev, const char *cmd_buf,
+				   bool is_unicast)
+{
+	struct hclge_mac_node *mac_node, *tmp;
+	struct hclge_vport *vport;
+	struct list_head *list;
+	u32 func_id;
+	int ret;
+
+	ret = kstrtouint(cmd_buf, 0, &func_id);
+	if (ret < 0) {
+		dev_err(&hdev->pdev->dev,
+			"dump mac list: bad command string, ret = %d\n", ret);
+		return -EINVAL;
+	}
+
+	if (func_id >= hdev->num_alloc_vport) {
+		dev_err(&hdev->pdev->dev,
+			"function id(%u) is out of range(0-%u)\n", func_id,
+			hdev->num_alloc_vport - 1);
+		return -EINVAL;
+	}
+
+	vport = &hdev->vport[func_id];
+
+	list = is_unicast ? &vport->uc_mac_list : &vport->mc_mac_list;
+
+	dev_info(&hdev->pdev->dev, "vport %u %s mac list:\n",
+		 func_id, is_unicast ? "uc" : "mc");
+	dev_info(&hdev->pdev->dev, "mac address              state\n");
+
+	spin_lock_bh(&vport->mac_list_lock);
+
+	list_for_each_entry_safe(mac_node, tmp, list, node) {
+		dev_info(&hdev->pdev->dev, "%pM         %d\n",
+			 mac_node->mac_addr, mac_node->state);
+	}
+
+	spin_unlock_bh(&vport->mac_list_lock);
+
+	return 0;
+}
+
 int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 {
 #define DUMP_REG	"dump reg"
@@ -1485,6 +1528,14 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 	} else if (strncmp(cmd_buf, "dump qs shaper", 14) == 0) {
 		hclge_dbg_dump_qs_shaper(hdev,
 					 &cmd_buf[sizeof("dump qs shaper")]);
+	} else if (strncmp(cmd_buf, "dump uc mac list", 16) == 0) {
+		hclge_dbg_dump_mac_list(hdev,
+					&cmd_buf[sizeof("dump uc mac list")],
+					true);
+	} else if (strncmp(cmd_buf, "dump mc mac list", 16) == 0) {
+		hclge_dbg_dump_mac_list(hdev,
+					&cmd_buf[sizeof("dump mc mac list")],
+					false);
 	} else {
 		dev_info(&hdev->pdev->dev, "unknown command\n");
 		return -EINVAL;
-- 
2.7.4

