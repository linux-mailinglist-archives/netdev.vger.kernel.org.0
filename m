Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C40AA04CD
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfH1OZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:25:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50216 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726935AbfH1OZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:25:45 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 339BC36F8D688E6C83F0;
        Wed, 28 Aug 2019 22:25:41 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 22:25:31 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/12] net: hns3: make some reusable codes into a function
Date:   Wed, 28 Aug 2019 22:23:10 +0800
Message-ID: <1567002196-63242-7-git-send-email-tanhuazhong@huawei.com>
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

From: Yonglong Liu <liuyonglong@huawei.com>

In hclge_dcb.c, these pair of codes:
	hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
	hclge_notify_client(hdev, HNAE3_UNINIT_CLIENT);
and
	hclge_notify_client(hdev, HNAE3_INIT_CLIENT);
	hclge_notify_client(hdev, HNAE3_UP_CLIENT);
are called many times, so make them into a function.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 54 +++++++++++-----------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 814e0f0..816f920 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -198,6 +198,28 @@ static int hclge_client_setup_tc(struct hclge_dev *hdev)
 	return 0;
 }
 
+static int hclge_notify_down_uinit(struct hclge_dev *hdev)
+{
+	int ret;
+
+	ret = hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
+	if (ret)
+		return ret;
+
+	return hclge_notify_client(hdev, HNAE3_UNINIT_CLIENT);
+}
+
+static int hclge_notify_init_up(struct hclge_dev *hdev)
+{
+	int ret;
+
+	ret = hclge_notify_client(hdev, HNAE3_INIT_CLIENT);
+	if (ret)
+		return ret;
+
+	return hclge_notify_client(hdev, HNAE3_UP_CLIENT);
+}
+
 static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 {
 	struct hclge_vport *vport = hclge_get_vport(h);
@@ -218,11 +240,7 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 	if (map_changed) {
 		netif_dbg(h, drv, netdev, "set ets\n");
 
-		ret = hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
-		if (ret)
-			return ret;
-
-		ret = hclge_notify_client(hdev, HNAE3_UNINIT_CLIENT);
+		ret = hclge_notify_down_uinit(hdev);
 		if (ret)
 			return ret;
 	}
@@ -242,11 +260,7 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 		if (ret)
 			goto err_out;
 
-		ret = hclge_notify_client(hdev, HNAE3_INIT_CLIENT);
-		if (ret)
-			return ret;
-
-		ret = hclge_notify_client(hdev, HNAE3_UP_CLIENT);
+		ret = hclge_notify_init_up(hdev);
 		if (ret)
 			return ret;
 	}
@@ -257,10 +271,8 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 	if (!map_changed)
 		return ret;
 
-	if (hclge_notify_client(hdev, HNAE3_INIT_CLIENT))
-		return ret;
+	hclge_notify_init_up(hdev);
 
-	hclge_notify_client(hdev, HNAE3_UP_CLIENT);
 	return ret;
 }
 
@@ -383,11 +395,7 @@ static int hclge_setup_tc(struct hnae3_handle *h, u8 tc, u8 *prio_tc)
 	if (ret)
 		return -EINVAL;
 
-	ret = hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
-	if (ret)
-		return ret;
-
-	ret = hclge_notify_client(hdev, HNAE3_UNINIT_CLIENT);
+	ret = hclge_notify_down_uinit(hdev);
 	if (ret)
 		return ret;
 
@@ -409,17 +417,11 @@ static int hclge_setup_tc(struct hnae3_handle *h, u8 tc, u8 *prio_tc)
 	else
 		hdev->flag &= ~HCLGE_FLAG_MQPRIO_ENABLE;
 
-	ret = hclge_notify_client(hdev, HNAE3_INIT_CLIENT);
-	if (ret)
-		return ret;
-
-	return hclge_notify_client(hdev, HNAE3_UP_CLIENT);
+	return hclge_notify_init_up(hdev);
 
 err_out:
-	if (hclge_notify_client(hdev, HNAE3_INIT_CLIENT))
-		return ret;
+	hclge_notify_init_up(hdev);
 
-	hclge_notify_client(hdev, HNAE3_UP_CLIENT);
 	return ret;
 }
 
-- 
2.7.4

