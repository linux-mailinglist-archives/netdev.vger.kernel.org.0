Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8361BA013
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 11:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgD0Jjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 05:39:40 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44882 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726349AbgD0Jjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 05:39:40 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DAFCA895E56446193756;
        Mon, 27 Apr 2020 17:39:38 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Mon, 27 Apr 2020 17:39:32 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <michal.simek@xilinx.com>, <esben@geanix.com>, <andrew@lunn.ch>,
        <ynezz@true.cz>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: ll_temac: Fix return value check in temac_probe()
Date:   Mon, 27 Apr 2020 09:40:52 +0000
Message-ID: <20200427094052.181554-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of error, the function devm_ioremap() returns NULL pointer
not ERR_PTR(). The IS_ERR() test in the return value check should
be replaced with NULL test.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 3e313e71ae36..929244064abd 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1410,9 +1410,9 @@ static int temac_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	lp->regs = devm_ioremap(&pdev->dev, res->start,
 					resource_size(res));
-	if (IS_ERR(lp->regs)) {
+	if (!lp->regs) {
 		dev_err(&pdev->dev, "could not map TEMAC registers\n");
-		return PTR_ERR(lp->regs);
+		return -ENOMEM;
 	}
 
 	/* Select register access functions with the specified
@@ -1505,10 +1505,10 @@ static int temac_probe(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 		lp->sdma_regs = devm_ioremap(&pdev->dev, res->start,
 						     resource_size(res));
-		if (IS_ERR(lp->sdma_regs)) {
+		if (!lp->sdma_regs) {
 			dev_err(&pdev->dev,
 				"could not map DMA registers\n");
-			return PTR_ERR(lp->sdma_regs);
+			return -ENOMEM;
 		}
 		if (pdata->dma_little_endian) {
 			lp->dma_in = temac_dma_in32_le;



