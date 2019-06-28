Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8679F59973
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfF1LwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:52:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56894 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726657AbfF1LwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 07:52:21 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1360BE2155ABB8ADAEF5;
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
Subject: [PATCH net-next 08/12] net: hns3: handle empty unknown interrupt
Date:   Fri, 28 Jun 2019 19:50:14 +0800
Message-ID: <1561722618-12168-9-git-send-email-tanhuazhong@huawei.com>
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

Since some MSI-X interrupt's status may be cleared by hardware,
so when the driver receives the interrupt, reading
HCLGE_VECTOR0_PF_OTHER_INT_STS_REG register will get an empty
unknown interrupt. For this case, the irq handler should enable
vector0 interrupt. This patch also use dev_info() instead of
dev_dbg() in the hclge_check_event_cause(), since this information
will be useful for normal usage.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 896605f..62c6263 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2783,8 +2783,9 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 
 	/* check for vector0 msix event source */
 	if (msix_src_reg & HCLGE_VECTOR0_REG_MSIX_MASK) {
-		dev_dbg(&hdev->pdev->dev, "received event 0x%x\n",
-			msix_src_reg);
+		dev_info(&hdev->pdev->dev, "received event 0x%x\n",
+			 msix_src_reg);
+		*clearval = msix_src_reg;
 		return HCLGE_VECTOR0_EVENT_ERR;
 	}
 
@@ -2796,8 +2797,11 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 	}
 
 	/* print other vector0 event source */
-	dev_dbg(&hdev->pdev->dev, "cmdq_src_reg:0x%x, msix_src_reg:0x%x\n",
-		cmdq_src_reg, msix_src_reg);
+	dev_info(&hdev->pdev->dev,
+		 "CMDQ INT status:0x%x, other INT status:0x%x\n",
+		 cmdq_src_reg, msix_src_reg);
+	*clearval = msix_src_reg;
+
 	return HCLGE_VECTOR0_EVENT_OTHER;
 }
 
@@ -2876,7 +2880,8 @@ static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 	}
 
 	/* clear the source of interrupt if it is not cause by reset */
-	if (event_cause == HCLGE_VECTOR0_EVENT_MBX) {
+	if (!clearval ||
+	    event_cause == HCLGE_VECTOR0_EVENT_MBX) {
 		hclge_clear_event_cause(hdev, event_cause, clearval);
 		hclge_enable_vector(&hdev->misc_vector, true);
 	}
-- 
2.7.4

