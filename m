Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B918279F2C
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbgI0HPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:15:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14248 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730331AbgI0HPr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 03:15:47 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 80729C7E5C3B3CBEFC70;
        Sun, 27 Sep 2020 15:15:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sun, 27 Sep 2020 15:15:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/10] net: hns3: add debugfs to dump device capabilities
Date:   Sun, 27 Sep 2020 15:12:44 +0800
Message-ID: <1601190768-50075-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
References: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

Adds debugfs to dump each device capability whether is supported.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 4fab82c..15333ec 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -244,6 +244,7 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "queue info <number>\n");
 	dev_info(&h->pdev->dev, "queue map\n");
 	dev_info(&h->pdev->dev, "bd info <q_num> <bd index>\n");
+	dev_info(&h->pdev->dev, "dev capability\n");
 
 	if (!hns3_is_phys_func(h->pdev))
 		return;
@@ -285,6 +286,27 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "%s", printf_buf);
 }
 
+static void hns3_dbg_dev_caps(struct hnae3_handle *h)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
+	unsigned long *caps;
+
+	caps = ae_dev->caps;
+
+	dev_info(&h->pdev->dev, "support FD: %s\n",
+		 test_bit(HNAE3_DEV_SUPPORT_FD_B, caps) ? "yes" : "no");
+	dev_info(&h->pdev->dev, "support GRO: %s\n",
+		 test_bit(HNAE3_DEV_SUPPORT_GRO_B, caps) ? "yes" : "no");
+	dev_info(&h->pdev->dev, "support FEC: %s\n",
+		 test_bit(HNAE3_DEV_SUPPORT_FEC_B, caps) ? "yes" : "no");
+	dev_info(&h->pdev->dev, "support UDP GSO: %s\n",
+		 test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, caps) ? "yes" : "no");
+	dev_info(&h->pdev->dev, "support PTP: %s\n",
+		 test_bit(HNAE3_DEV_SUPPORT_PTP_B, caps) ? "yes" : "no");
+	dev_info(&h->pdev->dev, "support INT QL: %s\n",
+		 test_bit(HNAE3_DEV_SUPPORT_INT_QL_B, caps) ? "yes" : "no");
+}
+
 static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
 				 size_t count, loff_t *ppos)
 {
@@ -360,6 +382,8 @@ static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
 		ret = hns3_dbg_queue_map(handle);
 	else if (strncmp(cmd_buf, "bd info", 7) == 0)
 		ret = hns3_dbg_bd_info(handle, cmd_buf);
+	else if (strncmp(cmd_buf, "dev capability", 14) == 0)
+		hns3_dbg_dev_caps(handle);
 	else if (handle->ae_algo->ops->dbg_run_cmd)
 		ret = handle->ae_algo->ops->dbg_run_cmd(handle, cmd_buf);
 	else
-- 
2.7.4

