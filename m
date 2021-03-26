Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5E3349EC9
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhCZBg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 21:36:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14607 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhCZBgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 21:36:23 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F64JW75jQz19JFH;
        Fri, 26 Mar 2021 09:34:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 09:36:11 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/9] net: hns3: remove redundant query in hclge_config_tm_hw_err_int()
Date:   Fri, 26 Mar 2021 09:36:22 +0800
Message-ID: <1616722588-58967-4-git-send-email-tanhuazhong@huawei.com>
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

From: Jiaran Zhang <zhangjiaran@huawei.com>

According to the HW manual, the query operation is unnecessary
when the TM QCN error event is enabled, so remove it.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 7389fe9..d252919 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -865,13 +865,7 @@ static int hclge_config_tm_hw_err_int(struct hclge_dev *hdev, bool en)
 	}
 
 	/* configure TM QCN hw errors */
-	ret = hclge_cmd_query_error(hdev, &desc, HCLGE_TM_QCN_MEM_INT_CFG, 0);
-	if (ret) {
-		dev_err(dev, "fail(%d) to read TM QCN CFG status\n", ret);
-		return ret;
-	}
-
-	hclge_cmd_reuse_desc(&desc, false);
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_TM_QCN_MEM_INT_CFG, false);
 	if (en)
 		desc.data[1] = cpu_to_le32(HCLGE_TM_QCN_MEM_ERR_INT_EN);
 
-- 
2.7.4

