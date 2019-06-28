Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9545997D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfF1LwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:52:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56890 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726928AbfF1LwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 07:52:13 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 064B6E5B56D950F33DF6;
        Fri, 28 Jun 2019 19:52:11 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 28 Jun 2019 19:52:01 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>
Subject: [PATCH net-next 07/12] net: hns3: re-schedule reset task while VF reset fail
Date:   Fri, 28 Jun 2019 19:50:13 +0800
Message-ID: <1561722618-12168-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
References: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VF reset may fail for some probabilistic reasons,
such as wait for hardware reset timeout, wait for mailbox
response timeout, so this patch tries to re-schedule the
reset task when the number of reset failing is under
HCLGEVF_RESET_MAX_FAIL_CNT. This patch also add a function
hclgevf_reset_err_handle() to handle the reset failing.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 30 ++++++++++++++++------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  1 +
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 21736e5..42006cc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -11,6 +11,8 @@
 
 #define HCLGEVF_NAME	"hclgevf"
 
+#define HCLGEVF_RESET_MAX_FAIL_CNT	5
+
 static int hclgevf_reset_hdev(struct hclgevf_dev *hdev);
 static struct hnae3_ae_algo ae_algovf;
 
@@ -1481,6 +1483,24 @@ static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 	return ret;
 }
 
+static void hclgevf_reset_err_handle(struct hclgevf_dev *hdev)
+{
+	hdev->rst_stats.rst_fail_cnt++;
+	dev_err(&hdev->pdev->dev, "failed to reset VF(%d)\n",
+		hdev->rst_stats.rst_fail_cnt);
+
+	if (hdev->rst_stats.rst_fail_cnt < HCLGEVF_RESET_MAX_FAIL_CNT)
+		set_bit(hdev->reset_type, &hdev->reset_pending);
+
+	if (hclgevf_is_reset_pending(hdev)) {
+		set_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state);
+		hclgevf_reset_task_schedule(hdev);
+	} else {
+		hclgevf_write_dev(&hdev->hw, HCLGEVF_NIC_CSQ_DEPTH_REG,
+				  HCLGEVF_NIC_CMQ_ENABLE);
+	}
+}
+
 static int hclgevf_reset(struct hclgevf_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
@@ -1537,19 +1557,13 @@ static int hclgevf_reset(struct hclgevf_dev *hdev)
 	hdev->last_reset_time = jiffies;
 	ae_dev->reset_type = HNAE3_NONE_RESET;
 	hdev->rst_stats.rst_done_cnt++;
+	hdev->rst_stats.rst_fail_cnt = 0;
 
 	return ret;
 err_reset_lock:
 	rtnl_unlock();
 err_reset:
-	/* When VF reset failed, only the higher level reset asserted by PF
-	 * can restore it, so re-initialize the command queue to receive
-	 * this higher reset event.
-	 */
-	hclgevf_cmd_init(hdev);
-	dev_err(&hdev->pdev->dev, "failed to reset VF\n");
-	if (hclgevf_is_reset_pending(hdev))
-		hclgevf_reset_task_schedule(hdev);
+	hclgevf_reset_err_handle(hdev);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index b0ee986..5a9e309 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -226,6 +226,7 @@ struct hclgevf_rst_stats {
 	u32 vf_rst_cnt;			/* the number of VF reset */
 	u32 rst_done_cnt;		/* the number of reset completed */
 	u32 hw_rst_done_cnt;		/* the number of HW reset completed */
+	u32 rst_fail_cnt;		/* the number of VF reset fail */
 };
 
 struct hclgevf_dev {
-- 
2.7.4

