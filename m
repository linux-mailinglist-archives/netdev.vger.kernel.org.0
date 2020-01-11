Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6ECB137C62
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 09:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgAKIeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 03:34:08 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36868 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728656AbgAKIeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 03:34:06 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9548A63ECEA6E392C78E;
        Sat, 11 Jan 2020 16:34:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 16:33:53 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/7] net: hns3: split hclge_reset() into preparing and rebuilding part
Date:   Sat, 11 Jan 2020 16:33:47 +0800
Message-ID: <1578731633-10709-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578731633-10709-1-git-send-email-tanhuazhong@huawei.com>
References: <1578731633-10709-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hclge_reset() is a little bloated, and the process of PF FLR will
be separated from the reset task later. So this patch splits
hclge_reset() into hclge_reset_prepare() and hclge_reset_rebuild(),
then FLR can also reuse these two functions.

BTW, since hclge_clear_reset_cause() and hclge_reset_prepare_up()
will not affect the device, so in hclge_reset_rebuild(), these
functions are called without rtnl_lock.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 59 +++++++++++++---------
 1 file changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 8bddda7..9cbc0b6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3782,10 +3782,9 @@ static int hclge_reset_stack(struct hclge_dev *hdev)
 	return hclge_notify_client(hdev, HNAE3_RESTORE_CLIENT);
 }
 
-static void hclge_reset(struct hclge_dev *hdev)
+static int hclge_reset_prepare(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-	enum hnae3_reset_type reset_level;
 	int ret;
 
 	/* Initialize ae_dev reset status as well, in case enet layer wants to
@@ -3796,45 +3795,45 @@ static void hclge_reset(struct hclge_dev *hdev)
 	/* perform reset of the stack & ae device for a client */
 	ret = hclge_notify_roce_client(hdev, HNAE3_DOWN_CLIENT);
 	if (ret)
-		goto err_reset;
+		return ret;
 
 	ret = hclge_reset_prepare_down(hdev);
 	if (ret)
-		goto err_reset;
+		return ret;
 
 	rtnl_lock();
 	ret = hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
-	if (ret)
-		goto err_reset_lock;
-
 	rtnl_unlock();
-
-	ret = hclge_reset_prepare_wait(hdev);
 	if (ret)
-		goto err_reset;
+		return ret;
 
-	if (hclge_reset_wait(hdev))
-		goto err_reset;
+	return hclge_reset_prepare_wait(hdev);
+}
+
+static int hclge_reset_rebuild(struct hclge_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	enum hnae3_reset_type reset_level;
+	int ret;
 
 	hdev->rst_stats.hw_reset_done_cnt++;
 
 	ret = hclge_notify_roce_client(hdev, HNAE3_UNINIT_CLIENT);
 	if (ret)
-		goto err_reset;
+		return ret;
 
 	rtnl_lock();
-
 	ret = hclge_reset_stack(hdev);
+	rtnl_unlock();
 	if (ret)
-		goto err_reset_lock;
+		return ret;
 
 	hclge_clear_reset_cause(hdev);
 
 	ret = hclge_reset_prepare_up(hdev);
 	if (ret)
-		goto err_reset_lock;
+		return ret;
 
-	rtnl_unlock();
 
 	ret = hclge_notify_roce_client(hdev, HNAE3_INIT_CLIENT);
 	/* ignore RoCE notify error if it fails HCLGE_RESET_MAX_FAIL_CNT - 1
@@ -3842,19 +3841,17 @@ static void hclge_reset(struct hclge_dev *hdev)
 	 */
 	if (ret &&
 	    hdev->rst_stats.reset_fail_cnt < HCLGE_RESET_MAX_FAIL_CNT - 1)
-		goto err_reset;
+		return ret;
 
 	rtnl_lock();
-
 	ret = hclge_notify_client(hdev, HNAE3_UP_CLIENT);
-	if (ret)
-		goto err_reset_lock;
-
 	rtnl_unlock();
+	if (ret)
+		return ret;
 
 	ret = hclge_notify_roce_client(hdev, HNAE3_UP_CLIENT);
 	if (ret)
-		goto err_reset;
+		return ret;
 
 	hdev->last_reset_time = jiffies;
 	hdev->rst_stats.reset_fail_cnt = 0;
@@ -3871,10 +3868,22 @@ static void hclge_reset(struct hclge_dev *hdev)
 	if (reset_level != HNAE3_NONE_RESET)
 		set_bit(reset_level, &hdev->reset_request);
 
+	return 0;
+}
+
+static void hclge_reset(struct hclge_dev *hdev)
+{
+	if (hclge_reset_prepare(hdev))
+		goto err_reset;
+
+	if (hclge_reset_wait(hdev))
+		goto err_reset;
+
+	if (hclge_reset_rebuild(hdev))
+		goto err_reset;
+
 	return;
 
-err_reset_lock:
-	rtnl_unlock();
 err_reset:
 	if (hclge_reset_err_handle(hdev))
 		hclge_reset_task_schedule(hdev);
-- 
2.7.4

