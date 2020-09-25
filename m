Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D2D277CE7
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgIYA3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:29:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14233 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726943AbgIYA3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:29:06 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E406C1940692410082A3;
        Fri, 25 Sep 2020 08:29:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 08:28:53 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/6] net: hns3: add debugfs of dumping pf interrupt resources
Date:   Fri, 25 Sep 2020 08:26:16 +0800
Message-ID: <1600993578-41008-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
References: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The pf's interrupt resources will be changed with the number of
enabled pf. Dumping this resource information will be helpful
for debugging.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c         |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index c6d7463..4fab82c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -264,6 +264,7 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump qs shaper [qs id]\n");
 	dev_info(&h->pdev->dev, "dump uc mac list <func id>\n");
 	dev_info(&h->pdev->dev, "dump mc mac list <func id>\n");
+	dev_info(&h->pdev->dev, "dump intr\n");
 
 	memset(printf_buf, 0, HNS3_DBG_BUF_LEN);
 	strncat(printf_buf, "dump reg [[bios common] [ssu <port_id>]",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 28be561..1ec1145 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1165,6 +1165,14 @@ static void hclge_dbg_dump_serv_info(struct hclge_dev *hdev)
 		 hdev->serv_processed_cnt);
 }
 
+static void hclge_dbg_dump_interrupt(struct hclge_dev *hdev)
+{
+	dev_info(&hdev->pdev->dev, "num_nic_msi: %u\n", hdev->num_nic_msi);
+	dev_info(&hdev->pdev->dev, "num_roce_msi: %u\n", hdev->num_roce_msi);
+	dev_info(&hdev->pdev->dev, "num_msi_used: %u\n", hdev->num_msi_used);
+	dev_info(&hdev->pdev->dev, "num_msi_left: %u\n", hdev->num_msi_left);
+}
+
 static void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
 {
 	struct hclge_desc *desc_src, *desc_tmp;
@@ -1489,6 +1497,7 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 #define DUMP_REG	"dump reg"
 #define DUMP_TM_MAP	"dump tm map"
 #define DUMP_LOOPBACK	"dump loopback"
+#define DUMP_INTERRUPT	"dump intr"
 
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
@@ -1536,6 +1545,9 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 		hclge_dbg_dump_mac_list(hdev,
 					&cmd_buf[sizeof("dump mc mac list")],
 					false);
+	} else if (strncmp(cmd_buf, DUMP_INTERRUPT,
+		   strlen(DUMP_INTERRUPT)) == 0) {
+		hclge_dbg_dump_interrupt(hdev);
 	} else {
 		dev_info(&hdev->pdev->dev, "unknown command\n");
 		return -EINVAL;
-- 
2.7.4

