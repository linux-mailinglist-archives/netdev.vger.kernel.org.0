Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602B741C1C4
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245203AbhI2JmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:42:03 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12970 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245088AbhI2Jlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 05:41:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKBCF1Vy4zWCST;
        Wed, 29 Sep 2021 17:38:49 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:08 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:07 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 3/8] net: hns3: don't rollback when destroy mqprio fail
Date:   Wed, 29 Sep 2021 17:35:51 +0800
Message-ID: <20210929093556.9146-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929093556.9146-1-huangguangbin2@huawei.com>
References: <20210929093556.9146-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

For destroy mqprio is irreversible in stack, so it's unnecessary
to rollback the tc configuration when destroy mqprio failed.
Otherwise, it may cause the configuration being inconsistent
between driver and netstack.

As the failure is usually caused by reset, and the driver will
restore the configuration after reset, so it can keep the
configuration being consistent between driver and hardware.

Fixes: 5a5c90917467 ("net: hns3: add support for tc mqprio offload")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c  | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 96f96644abab..351b8f179a29 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -514,12 +514,17 @@ static int hclge_setup_tc(struct hnae3_handle *h,
 	return hclge_notify_init_up(hdev);
 
 err_out:
-	/* roll-back */
-	memcpy(&kinfo->tc_info, &old_tc_info, sizeof(old_tc_info));
-	if (hclge_config_tc(hdev, &kinfo->tc_info))
-		dev_err(&hdev->pdev->dev,
-			"failed to roll back tc configuration\n");
-
+	if (!tc) {
+		dev_warn(&hdev->pdev->dev,
+			 "failed to destroy mqprio, will active after reset, ret = %d\n",
+			 ret);
+	} else {
+		/* roll-back */
+		memcpy(&kinfo->tc_info, &old_tc_info, sizeof(old_tc_info));
+		if (hclge_config_tc(hdev, &kinfo->tc_info))
+			dev_err(&hdev->pdev->dev,
+				"failed to roll back tc configuration\n");
+	}
 	hclge_notify_init_up(hdev);
 
 	return ret;
-- 
2.33.0

