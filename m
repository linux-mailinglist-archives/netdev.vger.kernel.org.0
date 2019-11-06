Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A773DF1A7E
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731923AbfKFPzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:55:44 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:5738 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726926AbfKFPzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 10:55:43 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F2D87CAD2C235EAEBD2D;
        Wed,  6 Nov 2019 23:55:41 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 6 Nov 2019 23:55:35 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@armlinux.org.uk>,
        "Robert Hancock" <hancock@sedsystems.ca>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: axienet: Fix error return code in axienet_probe()
Date:   Wed, 6 Nov 2019 15:54:49 +0000
Message-ID: <20191106155449.107672-1-weiyongjun1@huawei.com>
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

In the DMA memory resource get failed case, the error is not
set and 0 will be returned. Fix it by reove redundant check
since devm_ioremap_resource() will handle it.

Fixes: 28ef9ebdb64c ("net: axienet: make use of axistream-connected attribute optional")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 867726d696e2..8f32db6d2c45 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1788,10 +1788,6 @@ static int axienet_probe(struct platform_device *pdev)
 		/* Check for these resources directly on the Ethernet node. */
 		struct resource *res = platform_get_resource(pdev,
 							     IORESOURCE_MEM, 1);
-		if (!res) {
-			dev_err(&pdev->dev, "unable to get DMA memory resource\n");
-			goto free_netdev;
-		}
 		lp->dma_regs = devm_ioremap_resource(&pdev->dev, res);
 		lp->rx_irq = platform_get_irq(pdev, 1);
 		lp->tx_irq = platform_get_irq(pdev, 0);



