Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D08D78370
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 04:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfG2Czm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 22:55:42 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45450 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbfG2Czk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 22:55:40 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 12DA313580EBC2B4898C;
        Mon, 29 Jul 2019 10:55:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Mon, 29 Jul 2019 10:55:28 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <saeedm@mellanox.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V4 net-next 03/10] net: hns3: remove upgrade reset level when reset fail
Date:   Mon, 29 Jul 2019 10:53:24 +0800
Message-ID: <1564368811-65492-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564368811-65492-1-git-send-email-tanhuazhong@huawei.com>
References: <1564368811-65492-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, hclge_reset_err_handle() will assert a global reset
when the failing count is smaller than MAX_RESET_FAIL_CNT, which
will affect other running functions.

So this patch removes this upgrading, and uses re-scheduling reset
task to do it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 28 +++++++---------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3fde5471..3c64d70 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3305,7 +3305,7 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 	return ret;
 }
 
-static bool hclge_reset_err_handle(struct hclge_dev *hdev, bool is_timeout)
+static bool hclge_reset_err_handle(struct hclge_dev *hdev)
 {
 #define MAX_RESET_FAIL_CNT 5
 
@@ -3322,20 +3322,11 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev, bool is_timeout)
 		return false;
 	} else if (hdev->reset_fail_cnt < MAX_RESET_FAIL_CNT) {
 		hdev->reset_fail_cnt++;
-		if (is_timeout) {
-			set_bit(hdev->reset_type, &hdev->reset_pending);
-			dev_info(&hdev->pdev->dev,
-				 "re-schedule to wait for hw reset done\n");
-			return true;
-		}
-
-		dev_info(&hdev->pdev->dev, "Upgrade reset level\n");
-		hclge_clear_reset_cause(hdev);
-		set_bit(HNAE3_GLOBAL_RESET, &hdev->default_reset_request);
-		mod_timer(&hdev->reset_timer,
-			  jiffies + HCLGE_RESET_INTERVAL);
-
-		return false;
+		set_bit(hdev->reset_type, &hdev->reset_pending);
+		dev_info(&hdev->pdev->dev,
+			 "re-schedule reset task(%d)\n",
+			 hdev->reset_fail_cnt);
+		return true;
 	}
 
 	hclge_clear_reset_cause(hdev);
@@ -3382,7 +3373,6 @@ static int hclge_reset_stack(struct hclge_dev *hdev)
 static void hclge_reset(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-	bool is_timeout = false;
 	int ret;
 
 	/* Initialize ae_dev reset status as well, in case enet layer wants to
@@ -3410,10 +3400,8 @@ static void hclge_reset(struct hclge_dev *hdev)
 	if (ret)
 		goto err_reset;
 
-	if (hclge_reset_wait(hdev)) {
-		is_timeout = true;
+	if (hclge_reset_wait(hdev))
 		goto err_reset;
-	}
 
 	hdev->rst_stats.hw_reset_done_cnt++;
 
@@ -3465,7 +3453,7 @@ static void hclge_reset(struct hclge_dev *hdev)
 err_reset_lock:
 	rtnl_unlock();
 err_reset:
-	if (hclge_reset_err_handle(hdev, is_timeout))
+	if (hclge_reset_err_handle(hdev))
 		hclge_reset_task_schedule(hdev);
 }
 
-- 
2.7.4

