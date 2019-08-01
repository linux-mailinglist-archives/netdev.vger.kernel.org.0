Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61997D430
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbfHAD6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:58:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3727 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729744AbfHAD54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:57:56 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8BFDFC55DA64281F1E59;
        Thu,  1 Aug 2019 11:57:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 11:57:45 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/12] net: hns3: minior error handling change for hclge_tm_schd_info_init
Date:   Thu, 1 Aug 2019 11:55:40 +0800
Message-ID: <1564631745-36733-8-git-send-email-tanhuazhong@huawei.com>
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

From: Yunsheng Lin <linyunsheng@huawei.com>

When hclge_tm_schd_info_update calls hclge_tm_schd_info_init to
initialize the schedule info, hdev->tm_info.num_pg and
hdev->tx_sch_mode is not changed, which makes the checking in
hclge_tm_schd_info_init unnecessary.

So this patch moves the hdev->tm_info.num_pg and hdev->tx_sch_mode
checking into hclge_tm_schd_init and changes the return type of
hclge_tm_schd_info_init from int to void.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 3f41fa2..f30d112 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -650,12 +650,8 @@ static void hclge_pfc_info_init(struct hclge_dev *hdev)
 	}
 }
 
-static int hclge_tm_schd_info_init(struct hclge_dev *hdev)
+static void hclge_tm_schd_info_init(struct hclge_dev *hdev)
 {
-	if ((hdev->tx_sch_mode != HCLGE_FLAG_TC_BASE_SCH_MODE) &&
-	    (hdev->tm_info.num_pg != 1))
-		return -EINVAL;
-
 	hclge_tm_pg_info_init(hdev);
 
 	hclge_tm_tc_info_init(hdev);
@@ -663,8 +659,6 @@ static int hclge_tm_schd_info_init(struct hclge_dev *hdev)
 	hclge_tm_vport_info_update(hdev);
 
 	hclge_pfc_info_init(hdev);
-
-	return 0;
 }
 
 static int hclge_tm_pg_to_pri_map(struct hclge_dev *hdev)
@@ -1428,15 +1422,15 @@ int hclge_tm_init_hw(struct hclge_dev *hdev, bool init)
 
 int hclge_tm_schd_init(struct hclge_dev *hdev)
 {
-	int ret;
-
 	/* fc_mode is HCLGE_FC_FULL on reset */
 	hdev->tm_info.fc_mode = HCLGE_FC_FULL;
 	hdev->fc_mode_last_time = hdev->tm_info.fc_mode;
 
-	ret = hclge_tm_schd_info_init(hdev);
-	if (ret)
-		return ret;
+	if (hdev->tx_sch_mode != HCLGE_FLAG_TC_BASE_SCH_MODE &&
+	    hdev->tm_info.num_pg != 1)
+		return -EINVAL;
+
+	hclge_tm_schd_info_init(hdev);
 
 	return hclge_tm_init_hw(hdev, true);
 }
-- 
2.7.4

