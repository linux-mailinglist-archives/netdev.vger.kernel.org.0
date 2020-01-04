Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06C3913004C
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgADCul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:50:41 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8673 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727322AbgADCtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:40 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9EF151BE3057AB368415;
        Sat,  4 Jan 2020 10:49:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Sat, 4 Jan 2020 10:49:27 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/8] net: hns3: modify the IRQ name of misc vectors
Date:   Sat, 4 Jan 2020 10:49:28 +0800
Message-ID: <1578106171-17238-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
References: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

The misc IRQ of all the devices have the same name, so it's
hard to find the right misc IRQ of the device.

This patch modifies the misc IRQ names as "hclge/hclgevf"-misc-
"pci name". And now the IRQ name is not related to net device
name anymore, so change the HNAE3_INT_NAME_LEN to 32 bytes, and
that is enough.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h               | 3 +--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h    | 2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 4 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 1 +
 5 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 3b5e2d7..ed97bd6c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -575,8 +575,7 @@ struct hnae3_ae_algo {
 	const struct pci_device_id *pdev_id_table;
 };
 
-#define HNAE3_INT_NAME_EXT_LEN    32	 /* Max extra information length */
-#define HNAE3_INT_NAME_LEN        (IFNAMSIZ + HNAE3_INT_NAME_EXT_LEN)
+#define HNAE3_INT_NAME_LEN        32
 #define HNAE3_ITR_COUNTDOWN_START 100
 
 struct hnae3_tc_info {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index d97da67..96498d9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/io.h>
 #include <linux/etherdevice.h>
+#include "hnae3.h"
 
 #define HCLGE_CMDQ_TX_TIMEOUT		30000
 #define HCLGE_DESC_DATA_LEN		6
@@ -63,6 +64,7 @@ enum hclge_cmd_status {
 struct hclge_misc_vector {
 	u8 __iomem *addr;
 	int vector_irq;
+	char name[HNAE3_INT_NAME_LEN];
 };
 
 struct hclge_cmq {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b696127..4a15510 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3177,8 +3177,10 @@ static int hclge_misc_irq_init(struct hclge_dev *hdev)
 	hclge_get_misc_vector(hdev);
 
 	/* this would be explicitly freed in the end */
+	snprintf(hdev->misc_vector.name, HNAE3_INT_NAME_LEN, "%s-misc-%s",
+		 HCLGE_NAME, pci_name(hdev->pdev));
 	ret = request_irq(hdev->misc_vector.vector_irq, hclge_misc_irq_handle,
-			  0, "hclge_misc", hdev);
+			  0, hdev->misc_vector.name, hdev);
 	if (ret) {
 		hclge_free_vector(hdev, 0);
 		dev_err(&hdev->pdev->dev, "request misc irq(%d) fail\n",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index c33b802..cfa797e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2376,8 +2376,10 @@ static int hclgevf_misc_irq_init(struct hclgevf_dev *hdev)
 
 	hclgevf_get_misc_vector(hdev);
 
+	snprintf(hdev->misc_vector.name, HNAE3_INT_NAME_LEN, "%s-misc-%s",
+		 HCLGEVF_NAME, pci_name(hdev->pdev));
 	ret = request_irq(hdev->misc_vector.vector_irq, hclgevf_misc_irq_handle,
-			  0, "hclgevf_cmd", hdev);
+			  0, hdev->misc_vector.name, hdev);
 	if (ret) {
 		dev_err(&hdev->pdev->dev, "VF failed to request misc irq(%d)\n",
 			hdev->misc_vector.vector_irq);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 003114f..2cbc7df 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -221,6 +221,7 @@ struct hclgevf_rss_cfg {
 struct hclgevf_misc_vector {
 	u8 __iomem *addr;
 	int vector_irq;
+	char name[HNAE3_INT_NAME_LEN];
 };
 
 struct hclgevf_rst_stats {
-- 
2.7.4

