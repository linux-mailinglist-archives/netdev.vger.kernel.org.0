Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA904C9F8
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbfFTIyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:54:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19046 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731531AbfFTIyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 04:54:38 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 77AB4BF58C76D02F5ED9;
        Thu, 20 Jun 2019 16:54:33 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 16:54:24 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 10/11] net: hns3: fixes wrong place enabling ROCE HW error when loading
Date:   Thu, 20 Jun 2019 16:52:44 +0800
Message-ID: <1561020765-14481-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
References: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ROCE HW errors should only be enabled when initializing ROCE's
client, the current code enable it no matter initializing NIC or
ROCE client.

So this patch fixes it.

Fixes: 00ea6e5fda9d ("net: hns3: delay and separate enabling of NIC and ROCE HW errors")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 53dbef9..b0a99c3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8349,6 +8349,14 @@ static int hclge_init_roce_client_instance(struct hnae3_ae_dev *ae_dev,
 		goto init_roce_err;
 	}
 
+	/* Enable roce ras interrupts */
+	ret = hclge_config_rocee_ras_interrupt(hdev, true);
+	if (ret) {
+		dev_err(&ae_dev->pdev->dev,
+			"fail(%d) to enable roce ras interrupts\n", ret);
+		goto init_roce_err;
+	}
+
 	hnae3_set_client_init_flag(client, ae_dev, 1);
 
 	return 0;
@@ -8403,12 +8411,6 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 		}
 	}
 
-	/* Enable roce ras interrupts */
-	ret = hclge_config_rocee_ras_interrupt(hdev, true);
-	if (ret)
-		dev_err(&ae_dev->pdev->dev,
-			"fail(%d) to enable roce ras interrupts\n", ret);
-
 	return ret;
 
 clear_nic:
-- 
2.7.4

