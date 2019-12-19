Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F576125BBC
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfLSG5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:57:50 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:51092 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726340AbfLSG5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 01:57:49 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E02947F46256DAE7E1FA;
        Thu, 19 Dec 2019 14:57:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 19 Dec 2019 14:57:40 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 8/8] net: hns3: only print misc interrupt status when handling fails
Date:   Thu, 19 Dec 2019 14:57:47 +0800
Message-ID: <1576738667-37960-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
References: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Printing misc interrupt status of hardware error event in the
IRQ handler is unnecessary, since hclge_handle_hw_msix_error()
will print out the detail information for this hardware error
when handling success. So, this patch removes the print in
IRQ handler, and prints it when hclge_handle_hw_msix_error()
fails.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d1aafea..a510f00 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3005,8 +3005,6 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 
 	/* check for vector0 msix event source */
 	if (msix_src_reg & HCLGE_VECTOR0_REG_MSIX_MASK) {
-		dev_info(&hdev->pdev->dev, "received event 0x%x\n",
-			 msix_src_reg);
 		*clearval = msix_src_reg;
 		return HCLGE_VECTOR0_EVENT_ERR;
 	}
@@ -3505,10 +3503,15 @@ static enum hnae3_reset_type hclge_get_reset_level(struct hnae3_ae_dev *ae_dev,
 
 	/* first, resolve any unknown reset type to the known type(s) */
 	if (test_bit(HNAE3_UNKNOWN_RESET, addr)) {
+		u32 msix_sts_reg = hclge_read_dev(&hdev->hw,
+					HCLGE_VECTOR0_PF_OTHER_INT_STS_REG);
 		/* we will intentionally ignore any errors from this function
 		 *  as we will end up in *some* reset request in any case
 		 */
-		hclge_handle_hw_msix_error(hdev, addr);
+		if (hclge_handle_hw_msix_error(hdev, addr))
+			dev_info(&hdev->pdev->dev, "received msix interrupt 0x%x\n",
+				 msix_sts_reg);
+
 		clear_bit(HNAE3_UNKNOWN_RESET, addr);
 		/* We defered the clearing of the error event which caused
 		 * interrupt since it was not posssible to do that in
-- 
2.7.4

