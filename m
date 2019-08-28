Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EC3A04EC
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfH1O0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:26:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41772 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726397AbfH1OZn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:25:43 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 545FB1642EA358628807;
        Wed, 28 Aug 2019 22:25:41 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 22:25:32 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/12] net: hns3: check reset interrupt status when reset fails
Date:   Wed, 28 Aug 2019 22:23:15 +0800
Message-ID: <1567002196-63242-12-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
References: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the reset interrupt will be cleared firstly, so when
reset fails, if interrupt status register has reset interrupt,
it means there is a new coming reset.

Fixes: 72e2fb07997c ("net: hns3: clear reset interrupt status in hclge_irq_handle()")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 1 +
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 428f7c0..dc22b84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3536,11 +3536,10 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev)
 		dev_info(&hdev->pdev->dev, "Reset pending %lu\n",
 			 hdev->reset_pending);
 		return true;
-	} else if ((hdev->reset_type != HNAE3_IMP_RESET) &&
-		   (hclge_read_dev(&hdev->hw, HCLGE_GLOBAL_RESET_REG) &
-		    BIT(HCLGE_IMP_RESET_BIT))) {
+	} else if (hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS) &
+		   HCLGE_RESET_INT_M) {
 		dev_info(&hdev->pdev->dev,
-			 "reset failed because IMP Reset is pending\n");
+			 "reset failed because new reset interrupt\n");
 		hclge_clear_reset_cause(hdev);
 		return false;
 	} else if (hdev->reset_fail_cnt < MAX_RESET_FAIL_CNT) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index a3bc382..437a9ff 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -164,6 +164,7 @@ enum HLCGE_PORT_TYPE {
 #define HCLGE_GLOBAL_RESET_BIT		0
 #define HCLGE_CORE_RESET_BIT		1
 #define HCLGE_IMP_RESET_BIT		2
+#define HCLGE_RESET_INT_M		GENMASK(2, 0)
 #define HCLGE_FUN_RST_ING		0x20C00
 #define HCLGE_FUN_RST_ING_B		0
 
-- 
2.7.4

