Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077212D2053
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 02:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgLHBvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 20:51:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8721 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgLHBvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 20:51:01 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cqjm30MXpzkmnk;
        Tue,  8 Dec 2020 09:49:39 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 8 Dec 2020 09:50:09 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Esben Haabendal <esben@geanix.com>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: ll_temac: Fix potential NULL dereference in temac_probe()
Date:   Tue, 8 Dec 2020 09:53:42 +0800
Message-ID: <1607392422-20372-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

platform_get_resource() may fail and in this case a NULL dereference
will occur.

Fix it to use devm_platform_ioremap_resource() instead of calling
platform_get_resource() and devm_ioremap().

This is detected by Coccinelle semantic patch.

@@
expression pdev, res, n, t, e, e1, e2;
@@

res = \(platform_get_resource\|platform_get_resource_byname\)(pdev, t, n);
+ if (!res)
+   return -EINVAL;
... when != res == NULL
e = devm_ioremap(e1, res->start, e2);

Fixes: 8425c41d1ef7 ("net: ll_temac: Extend support to non-device-tree platforms")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 60c199f..0301853 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1351,7 +1351,6 @@ static int temac_probe(struct platform_device *pdev)
 	struct device_node *temac_np = dev_of_node(&pdev->dev), *dma_np;
 	struct temac_local *lp;
 	struct net_device *ndev;
-	struct resource *res;
 	const void *addr;
 	__be32 *p;
 	bool little_endian;
@@ -1500,13 +1499,11 @@ static int temac_probe(struct platform_device *pdev)
 		of_node_put(dma_np);
 	} else if (pdata) {
 		/* 2nd memory resource specifies DMA registers */
-		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		lp->sdma_regs = devm_ioremap(&pdev->dev, res->start,
-						     resource_size(res));
-		if (!lp->sdma_regs) {
+		lp->sdma_regs = devm_platform_ioremap_resource(pdev, 1);
+		if (IS_ERR(lp->sdma_regs)) {
 			dev_err(&pdev->dev,
 				"could not map DMA registers\n");
-			return -ENOMEM;
+			return PTR_ERR(lp->sdma_regs);
 		}
 		if (pdata->dma_little_endian) {
 			lp->dma_in = temac_dma_in32_le;
-- 
2.9.5

