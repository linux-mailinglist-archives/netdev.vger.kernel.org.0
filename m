Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9DCAA48E
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 15:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfIENeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 09:34:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6227 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727791AbfIENeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 09:34:11 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AF7B8422B5911C9DDD77;
        Thu,  5 Sep 2019 21:34:09 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Sep 2019 21:34:04 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 3/7] net: hns3: fix mis-assignment to hdev->reset_level in hclge_reset
Date:   Thu, 5 Sep 2019 21:31:38 +0800
Message-ID: <1567690302-16648-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567690302-16648-1-git-send-email-tanhuazhong@huawei.com>
References: <1567690302-16648-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since hclge_get_reset_level may return HNAE3_NONE_RESET,
so hdev->reset_level can not be assigned with the return
value in the hclge_reset(), otherwise, it will cause
the use of hdev->reset_level in hclge_reset_event get
into error.

Fixes: 012fcb52f67c ("net: hns3: activate reset timer when calling reset_event")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0e1225c..76e1c84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3619,6 +3619,7 @@ static int hclge_reset_stack(struct hclge_dev *hdev)
 static void hclge_reset(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	enum hnae3_reset_type reset_level;
 	int ret;
 
 	/* Initialize ae_dev reset status as well, in case enet layer wants to
@@ -3697,10 +3698,10 @@ static void hclge_reset(struct hclge_dev *hdev)
 	 * it should be handled as soon as possible. since some errors
 	 * need this kind of reset to fix.
 	 */
-	hdev->reset_level = hclge_get_reset_level(ae_dev,
-						  &hdev->default_reset_request);
-	if (hdev->reset_level != HNAE3_NONE_RESET)
-		set_bit(hdev->reset_level, &hdev->reset_request);
+	reset_level = hclge_get_reset_level(ae_dev,
+					    &hdev->default_reset_request);
+	if (reset_level != HNAE3_NONE_RESET)
+		set_bit(reset_level, &hdev->reset_request);
 
 	return;
 
-- 
2.7.4

