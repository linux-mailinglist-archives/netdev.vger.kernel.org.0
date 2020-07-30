Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B0F232C85
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 09:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgG3H0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 03:26:17 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:35796 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728724AbgG3H0R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 03:26:17 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 080F7833B26E44A6B96B;
        Thu, 30 Jul 2020 15:26:12 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Jul 2020
 15:26:01 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <michal.simek@xilinx.com>, <esben@geanix.com>, <timur@kernel.org>,
        <f.fainelli@gmail.com>, <weiyongjun1@huawei.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: ll_temac: Use devm_platform_ioremap_resource_byname()
Date:   Thu, 30 Jul 2020 15:24:19 +0800
Message-ID: <20200730072419.57030-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

platform_get_resource() may fail and return NULL, so we had better
check its return value to avoid a NULL pointer dereference a bit later
in the code. Fix it to use devm_platform_ioremap_resource_byname()
instead of calling platform_get_resource_byname() and devm_ioremap().

Fixes: 8425c41d1ef7 ("net: ll_temac: Extend support to non-device-tree platforms")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 929244064abd..9a15f14daa47 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1407,10 +1407,8 @@ static int temac_probe(struct platform_device *pdev)
 	}
 
 	/* map device registers */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	lp->regs = devm_ioremap(&pdev->dev, res->start,
-					resource_size(res));
-	if (!lp->regs) {
+	lp->regs = devm_platform_ioremap_resource_byname(pdev, 0);
+	if (IS_ERR(lp->regs)) {
 		dev_err(&pdev->dev, "could not map TEMAC registers\n");
 		return -ENOMEM;
 	}
-- 
2.17.1

