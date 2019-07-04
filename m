Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50E75F9B3
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfGDOGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:06:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47472 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726817AbfGDOGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 10:06:24 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DC89B1B48A6223FCA715;
        Thu,  4 Jul 2019 22:06:21 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Thu, 4 Jul 2019 22:06:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/9] net: hns3: enable broadcast promisc mode when initializing VF
Date:   Thu, 4 Jul 2019 22:04:20 +0800
Message-ID: <1562249068-40176-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
References: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

For revision 0x20, the broadcast promisc is enabled by firmware,
it's unnecessary to enable it when initializing VF.

For revision 0x21, it's necessary to enable broadcast promisc mode
when initializing or re-initializing VF, otherwise, it will be
unable to send and receive promisc packets.

Fixes: f01f5559cac8 ("net: hns3: don't allow vf to enable promisc mode")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 42006cc..ff7e8cb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2589,6 +2589,12 @@ static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 		return ret;
 	}
 
+	if (pdev->revision >= 0x21) {
+		ret = hclgevf_set_promisc_mode(hdev, true);
+		if (ret)
+			return ret;
+	}
+
 	dev_info(&hdev->pdev->dev, "Reset done\n");
 
 	return 0;
@@ -2668,9 +2674,11 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	 * firmware makes sure broadcast packets can be accepted.
 	 * For revision 0x21, default to enable broadcast promisc mode.
 	 */
-	ret = hclgevf_set_promisc_mode(hdev, true);
-	if (ret)
-		goto err_config;
+	if (pdev->revision >= 0x21) {
+		ret = hclgevf_set_promisc_mode(hdev, true);
+		if (ret)
+			goto err_config;
+	}
 
 	/* Initialize RSS for this VF */
 	ret = hclgevf_rss_init_hw(hdev);
-- 
2.7.4

