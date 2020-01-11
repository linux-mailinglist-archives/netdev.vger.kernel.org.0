Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F8A137C61
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 09:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgAKIeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 03:34:09 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36972 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728691AbgAKIeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 03:34:06 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C317AF9CC153B2469547;
        Sat, 11 Jan 2020 16:34:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 16:33:54 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 6/7] net: hns3: modify hclge_func_reset_sync_vf()'s return type to void
Date:   Sat, 11 Jan 2020 16:33:52 +0800
Message-ID: <1578731633-10709-7-git-send-email-tanhuazhong@huawei.com>
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

When synchronizes with VFs fail before PF function reset,
PF driver should go on its function reset, otherwise it
can not run normally anymore. So, hclge_func_reset_sync_vf()
should not affect the processing of PF reset, this patch
modifies its return type to void.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 29 +++++++---------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d81c976..21ecd79 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3362,7 +3362,7 @@ static void hclge_mailbox_service_task(struct hclge_dev *hdev)
 	clear_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state);
 }
 
-static int hclge_func_reset_sync_vf(struct hclge_dev *hdev)
+static void hclge_func_reset_sync_vf(struct hclge_dev *hdev)
 {
 	struct hclge_pf_rst_sync_cmd *req;
 	struct hclge_desc desc;
@@ -3382,20 +3382,19 @@ static int hclge_func_reset_sync_vf(struct hclge_dev *hdev)
 		 */
 		if (ret == -EOPNOTSUPP) {
 			msleep(HCLGE_RESET_SYNC_TIME);
-			return 0;
+			return;
 		} else if (ret) {
-			dev_err(&hdev->pdev->dev, "sync with VF fail %d!\n",
-				ret);
-			return ret;
+			dev_warn(&hdev->pdev->dev, "sync with VF fail %d!\n",
+				 ret);
+			return;
 		} else if (req->all_vf_ready) {
-			return 0;
+			return;
 		}
 		msleep(HCLGE_PF_RESET_SYNC_TIME);
 		hclge_cmd_reuse_desc(&desc, true);
 	} while (cnt++ < HCLGE_PF_RESET_SYNC_CNT);
 
-	dev_err(&hdev->pdev->dev, "sync with VF timeout!\n");
-	return -ETIME;
+	dev_warn(&hdev->pdev->dev, "sync with VF timeout!\n");
 }
 
 void hclge_report_hw_error(struct hclge_dev *hdev,
@@ -3600,12 +3599,7 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 
 	switch (hdev->reset_type) {
 	case HNAE3_FUNC_RESET:
-		/* to confirm whether all running VF is ready
-		 * before request PF reset
-		 */
-		ret = hclge_func_reset_sync_vf(hdev);
-		if (ret)
-			return ret;
+		hclge_func_reset_sync_vf(hdev);
 
 		ret = hclge_func_reset_cmd(hdev, 0);
 		if (ret) {
@@ -3623,12 +3617,7 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 		hdev->rst_stats.pf_rst_cnt++;
 		break;
 	case HNAE3_FLR_RESET:
-		/* to confirm whether all running VF is ready
-		 * before request PF reset
-		 */
-		ret = hclge_func_reset_sync_vf(hdev);
-		if (ret)
-			return ret;
+		hclge_func_reset_sync_vf(hdev);
 		break;
 	case HNAE3_IMP_RESET:
 		hclge_handle_imp_error(hdev);
-- 
2.7.4

