Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B2E43E6C
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389264AbfFMPtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:49:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18152 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731698AbfFMJOT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 05:14:19 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3EA0D12B51684788EC5D;
        Thu, 13 Jun 2019 17:14:14 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 13 Jun 2019 17:14:07 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/12] net: hns3: add recovery for the H/W errors occurred before the HNS dev initialization
Date:   Thu, 13 Jun 2019 17:12:24 +0800
Message-ID: <1560417152-53050-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
References: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiju Jose <shiju.jose@huawei.com>

This patch adds the recovery for the HNS H/W errors which occurred
before the driver initialization.

Reported-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d9863c30..6761d72 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3236,6 +3236,7 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev, bool is_timeout)
 
 		dev_info(&hdev->pdev->dev, "Upgrade reset level\n");
 		hclge_clear_reset_cause(hdev);
+		set_bit(HNAE3_GLOBAL_RESET, &hdev->default_reset_request);
 		mod_timer(&hdev->reset_timer,
 			  jiffies + HCLGE_RESET_INTERVAL);
 
@@ -3430,8 +3431,7 @@ static void hclge_reset_timer(struct timer_list *t)
 	struct hclge_dev *hdev = from_timer(hdev, t, reset_timer);
 
 	dev_info(&hdev->pdev->dev,
-		 "triggering global reset in reset timer\n");
-	set_bit(HNAE3_GLOBAL_RESET, &hdev->default_reset_request);
+		 "triggering reset in reset timer\n");
 	hclge_reset_event(hdev->pdev, NULL);
 }
 
@@ -8614,6 +8614,18 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	/* Log and clear the hw errors those already occurred */
 	hclge_handle_all_hns_hw_errors(ae_dev);
 
+	/* request delayed reset for the error recovery because an immediate
+	 * global reset on a PF affecting pending initialization of other PFs
+	 */
+	if (ae_dev->hw_err_reset_req) {
+		enum hnae3_reset_type reset_level;
+
+		reset_level = hclge_get_reset_level(ae_dev,
+						    &ae_dev->hw_err_reset_req);
+		hclge_set_def_reset_request(ae_dev, reset_level);
+		mod_timer(&hdev->reset_timer, jiffies + HCLGE_RESET_INTERVAL);
+	}
+
 	/* Enable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, true);
 
-- 
2.7.4

