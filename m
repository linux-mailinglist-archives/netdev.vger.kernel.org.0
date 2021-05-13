Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E395837F80F
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 14:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhEMMi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 08:38:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2721 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbhEMMiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 08:38:19 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fgrh05h7Tz16PD7;
        Thu, 13 May 2021 20:34:24 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 13 May 2021 20:36:59 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Mike Rapoport <rppt@kernel.org>,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net] net: korina: Fix return value check in korina_probe()
Date:   Thu, 13 May 2021 12:46:21 +0000
Message-ID: <20210513124621.2361806-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of error, the function devm_platform_ioremap_resource_byname()
returns ERR_PTR() and never returns NULL. The NULL test in the return
value check should be replaced with IS_ERR().

Fixes: b4cd249a8cc0 ("net: korina: Use devres functions")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/korina.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 6f987a7ffcb3..b30a45725374 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1315,23 +1315,23 @@ static int korina_probe(struct platform_device *pdev)
 	lp->tx_irq = platform_get_irq_byname(pdev, "tx");
 
 	p = devm_platform_ioremap_resource_byname(pdev, "emac");
-	if (!p) {
+	if (IS_ERR(p)) {
 		printk(KERN_ERR DRV_NAME ": cannot remap registers\n");
-		return -ENOMEM;
+		return PTR_ERR(p);
 	}
 	lp->eth_regs = p;
 
 	p = devm_platform_ioremap_resource_byname(pdev, "dma_rx");
-	if (!p) {
+	if (IS_ERR(p)) {
 		printk(KERN_ERR DRV_NAME ": cannot remap Rx DMA registers\n");
-		return -ENOMEM;
+		return PTR_ERR(p);
 	}
 	lp->rx_dma_regs = p;
 
 	p = devm_platform_ioremap_resource_byname(pdev, "dma_tx");
-	if (!p) {
+	if (IS_ERR(p)) {
 		printk(KERN_ERR DRV_NAME ": cannot remap Tx DMA registers\n");
-		return -ENOMEM;
+		return PTR_ERR(p);
 	}
 	lp->tx_dma_regs = p;
 

