Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4F0137C6B
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 09:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgAKIel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 03:34:41 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36888 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728644AbgAKIeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 03:34:03 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9F54151FA746232671C5;
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
Subject: [PATCH net-next 2/7] net: hns3: split hclgevf_reset() into preparing and rebuilding part
Date:   Sat, 11 Jan 2020 16:33:48 +0800
Message-ID: <1578731633-10709-3-git-send-email-tanhuazhong@huawei.com>
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

hclgevf_reset() is a little bloated, and the process of VF FLR will
be separated from the reset task later. So this patch splits
hclgevf_reset() into hclgevf_reset_prepare() and hclge_reset_rebuild(),
then FLR can also reuse these two functions. Also moves HNAE3_UP_CLIENT
into hclgevf_reset_stack().

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 81 +++++++++++-----------
 1 file changed, 39 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index cfa797e..02b44d3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1523,7 +1523,8 @@ static int hclgevf_reset_stack(struct hclgevf_dev *hdev)
 	/* clear handshake status with IMP */
 	hclgevf_reset_handshake(hdev, false);
 
-	return 0;
+	/* bring up the nic to enable TX/RX again */
+	return hclgevf_notify_client(hdev, HNAE3_UP_CLIENT);
 }
 
 static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
@@ -1603,7 +1604,7 @@ static void hclgevf_reset_err_handle(struct hclgevf_dev *hdev)
 	}
 }
 
-static int hclgevf_reset(struct hclgevf_dev *hdev)
+static int hclgevf_reset_prepare(struct hclgevf_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	int ret;
@@ -1613,62 +1614,64 @@ static int hclgevf_reset(struct hclgevf_dev *hdev)
 	 */
 	ae_dev->reset_type = hdev->reset_type;
 	hdev->rst_stats.rst_cnt++;
-	rtnl_lock();
 
+	rtnl_lock();
 	/* bring down the nic to stop any ongoing TX/RX */
 	ret = hclgevf_notify_client(hdev, HNAE3_DOWN_CLIENT);
-	if (ret)
-		goto err_reset_lock;
-
 	rtnl_unlock();
-
-	ret = hclgevf_reset_prepare_wait(hdev);
 	if (ret)
-		goto err_reset;
+		return ret;
 
-	/* check if VF could successfully fetch the hardware reset completion
-	 * status from the hardware
-	 */
-	ret = hclgevf_reset_wait(hdev);
-	if (ret) {
-		/* can't do much in this situation, will disable VF */
-		dev_err(&hdev->pdev->dev,
-			"VF failed(=%d) to fetch H/W reset completion status\n",
-			ret);
-		goto err_reset;
-	}
+	return hclgevf_reset_prepare_wait(hdev);
+}
+
+static int hclgevf_reset_rebuild(struct hclgevf_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	int ret;
 
 	hdev->rst_stats.hw_rst_done_cnt++;
 
 	rtnl_lock();
-
 	/* now, re-initialize the nic client and ae device */
 	ret = hclgevf_reset_stack(hdev);
+	rtnl_unlock();
 	if (ret) {
 		dev_err(&hdev->pdev->dev, "failed to reset VF stack\n");
-		goto err_reset_lock;
+		return ret;
 	}
 
-	/* bring up the nic to enable TX/RX again */
-	ret = hclgevf_notify_client(hdev, HNAE3_UP_CLIENT);
-	if (ret)
-		goto err_reset_lock;
-
-	rtnl_unlock();
-
 	hdev->last_reset_time = jiffies;
 	ae_dev->reset_type = HNAE3_NONE_RESET;
 	hdev->rst_stats.rst_done_cnt++;
 	hdev->rst_stats.rst_fail_cnt = 0;
 	clear_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state);
 
-	return ret;
-err_reset_lock:
-	rtnl_unlock();
+	return 0;
+}
+
+static void hclgevf_reset(struct hclgevf_dev *hdev)
+{
+	if (hclgevf_reset_prepare(hdev))
+		goto err_reset;
+
+	/* check if VF could successfully fetch the hardware reset completion
+	 * status from the hardware
+	 */
+	if (hclgevf_reset_wait(hdev)) {
+		/* can't do much in this situation, will disable VF */
+		dev_err(&hdev->pdev->dev,
+			"failed to fetch H/W reset completion status\n");
+		goto err_reset;
+	}
+
+	if (hclgevf_reset_rebuild(hdev))
+		goto err_reset;
+
+	return;
+
 err_reset:
 	hclgevf_reset_err_handle(hdev);
-
-	return ret;
 }
 
 static enum hnae3_reset_type hclgevf_get_reset_level(struct hclgevf_dev *hdev,
@@ -1802,8 +1805,6 @@ static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
 {
 #define	HCLGEVF_MAX_RESET_ATTEMPTS_CNT	3
 
-	int ret;
-
 	if (!test_and_clear_bit(HCLGEVF_STATE_RST_SERVICE_SCHED, &hdev->state))
 		return;
 
@@ -1822,12 +1823,8 @@ static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
 		hdev->last_reset_time = jiffies;
 		while ((hdev->reset_type =
 			hclgevf_get_reset_level(hdev, &hdev->reset_pending))
-		       != HNAE3_NONE_RESET) {
-			ret = hclgevf_reset(hdev);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"VF stack reset failed %d.\n", ret);
-		}
+		       != HNAE3_NONE_RESET)
+			hclgevf_reset(hdev);
 	} else if (test_and_clear_bit(HCLGEVF_RESET_REQUESTED,
 				      &hdev->reset_state)) {
 		/* we could be here when either of below happens:
-- 
2.7.4

