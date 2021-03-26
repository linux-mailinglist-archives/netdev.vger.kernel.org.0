Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A501F349EC2
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhCZBgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 21:36:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14601 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhCZBgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 21:36:22 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F64JW6NjFz19JDc;
        Fri, 26 Mar 2021 09:34:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 09:36:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 8/9] net: hns3: split function hclge_reset_rebuild()
Date:   Fri, 26 Mar 2021 09:36:27 +0800
Message-ID: <1616722588-58967-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616722588-58967-1-git-send-email-tanhuazhong@huawei.com>
References: <1616722588-58967-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

hclge_reset_rebuild() is a bit too long. So add a new function
hclge_update_reset_level() to improve readability.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 26 +++++++++++++---------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6bfaf14..d639519 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3940,6 +3940,21 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev)
 	return false;
 }
 
+static void hclge_update_reset_level(struct hclge_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	enum hnae3_reset_type reset_level;
+
+	/* if default_reset_request has a higher level reset request,
+	 * it should be handled as soon as possible. since some errors
+	 * need this kind of reset to fix.
+	 */
+	reset_level = hclge_get_reset_level(ae_dev,
+					    &hdev->default_reset_request);
+	if (reset_level != HNAE3_NONE_RESET)
+		set_bit(reset_level, &hdev->reset_request);
+}
+
 static int hclge_set_rst_done(struct hclge_dev *hdev)
 {
 	struct hclge_pf_rst_done_cmd *req;
@@ -4027,8 +4042,6 @@ static int hclge_reset_prepare(struct hclge_dev *hdev)
 
 static int hclge_reset_rebuild(struct hclge_dev *hdev)
 {
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-	enum hnae3_reset_type reset_level;
 	int ret;
 
 	hdev->rst_stats.hw_reset_done_cnt++;
@@ -4072,14 +4085,7 @@ static int hclge_reset_rebuild(struct hclge_dev *hdev)
 	hdev->rst_stats.reset_done_cnt++;
 	clear_bit(HCLGE_STATE_RST_FAIL, &hdev->state);
 
-	/* if default_reset_request has a higher level reset request,
-	 * it should be handled as soon as possible. since some errors
-	 * need this kind of reset to fix.
-	 */
-	reset_level = hclge_get_reset_level(ae_dev,
-					    &hdev->default_reset_request);
-	if (reset_level != HNAE3_NONE_RESET)
-		set_bit(reset_level, &hdev->reset_request);
+	hclge_update_reset_level(hdev);
 
 	return 0;
 }
-- 
2.7.4

