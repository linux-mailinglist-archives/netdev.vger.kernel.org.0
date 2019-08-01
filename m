Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEB7E7D427
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbfHAD6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:58:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39554 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729822AbfHAD6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:58:00 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B659D202895F335DEBBF;
        Thu,  1 Aug 2019 11:57:56 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 11:57:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 12/12] net: hns3: activate reset timer when calling reset_event
Date:   Thu, 1 Aug 2019 11:55:45 +0800
Message-ID: <1564631745-36733-13-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
References: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling hclge_reset_event() within HCLGE_RESET_INTERVAL,
it returns directly now. If no one call it again, then the
error which needs a reset to fix it can not be fixed.

So this patch activates the reset timer for this case, and
adds checking in the end of the reset procedure to make this
error fixed earlier.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c4841c3..b7399f5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3517,7 +3517,15 @@ static void hclge_reset(struct hclge_dev *hdev)
 	hdev->reset_fail_cnt = 0;
 	hdev->rst_stats.reset_done_cnt++;
 	ae_dev->reset_type = HNAE3_NONE_RESET;
-	del_timer(&hdev->reset_timer);
+
+	/* if default_reset_request has a higher level reset request,
+	 * it should be handled as soon as possible. since some errors
+	 * need this kind of reset to fix.
+	 */
+	hdev->reset_level = hclge_get_reset_level(ae_dev,
+						  &hdev->default_reset_request);
+	if (hdev->reset_level != HNAE3_NONE_RESET)
+		set_bit(hdev->reset_level, &hdev->reset_request);
 
 	return;
 
@@ -3552,9 +3560,10 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
 		handle = &hdev->vport[0].nic;
 
 	if (time_before(jiffies, (hdev->last_reset_time +
-				  HCLGE_RESET_INTERVAL)))
+				  HCLGE_RESET_INTERVAL))) {
+		mod_timer(&hdev->reset_timer, jiffies + HCLGE_RESET_INTERVAL);
 		return;
-	else if (hdev->default_reset_request)
+	} else if (hdev->default_reset_request)
 		hdev->reset_level =
 			hclge_get_reset_level(ae_dev,
 					      &hdev->default_reset_request);
@@ -3584,6 +3593,12 @@ static void hclge_reset_timer(struct timer_list *t)
 {
 	struct hclge_dev *hdev = from_timer(hdev, t, reset_timer);
 
+	/* if default_reset_request has no value, it means that this reset
+	 * request has already be handled, so just return here
+	 */
+	if (!hdev->default_reset_request)
+		return;
+
 	dev_info(&hdev->pdev->dev,
 		 "triggering reset in reset timer\n");
 	hclge_reset_event(hdev->pdev, NULL);
-- 
2.7.4

