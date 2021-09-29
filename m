Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA34E41C1C3
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245184AbhI2JmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:42:01 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23232 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245093AbhI2Jlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 05:41:51 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKBCn0JRjz8tYD;
        Wed, 29 Sep 2021 17:39:17 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:08 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 5/8] net: hns3: fix show wrong state when add existing uc mac address
Date:   Wed, 29 Sep 2021 17:35:53 +0800
Message-ID: <20210929093556.9146-6-huangguangbin2@huawei.com>
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

Currently, if function adds an existing unicast mac address, eventhough
driver will not add this address into hardware, but it will return 0 in
function hclge_add_uc_addr_common(). It will cause the state of this
unicast mac address is ACTIVE in driver, but it should be in TO-ADD state.

To fix this problem, function hclge_add_uc_addr_common() returns -EEXIST
if mac address is existing, and delete two error log to avoid printing
them all the time after this modification.

Fixes: 72110b567479 ("net: hns3: return 0 and print warning when hit duplicate MAC")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 47fea8985861..3391244d9d3d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8708,15 +8708,8 @@ int hclge_add_uc_addr_common(struct hclge_vport *vport,
 	}
 
 	/* check if we just hit the duplicate */
-	if (!ret) {
-		dev_warn(&hdev->pdev->dev, "VF %u mac(%pM) exists\n",
-			 vport->vport_id, addr);
-		return 0;
-	}
-
-	dev_err(&hdev->pdev->dev,
-		"PF failed to add unicast entry(%pM) in the MAC table\n",
-		addr);
+	if (!ret)
+		return -EEXIST;
 
 	return ret;
 }
@@ -8868,7 +8861,13 @@ static void hclge_sync_vport_mac_list(struct hclge_vport *vport,
 		} else {
 			set_bit(HCLGE_VPORT_STATE_MAC_TBL_CHANGE,
 				&vport->state);
-			break;
+
+			/* If one unicast mac address is existing in hardware,
+			 * we need to try whether other unicast mac addresses
+			 * are new addresses that can be added.
+			 */
+			if (ret != -EEXIST)
+				break;
 		}
 	}
 }
-- 
2.33.0

