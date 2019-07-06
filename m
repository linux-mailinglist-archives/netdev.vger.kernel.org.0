Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D25B160E9E
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 05:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfGFDky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 23:40:54 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:20010 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfGFDky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 23:40:54 -0400
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id 3FCEE1E2C435B7DB376A;
        Sat,  6 Jul 2019 11:40:49 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id x663eTXS033818;
        Sat, 6 Jul 2019 11:40:29 +0800 (GMT-8)
        (envelope-from wen.yang99@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019070611411255-2124361 ;
          Sat, 6 Jul 2019 11:41:12 +0800 
From:   Wen Yang <wen.yang99@zte.com.cn>
To:     linux-kernel@vger.kernel.org
Cc:     xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        cheng.shengyu@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] net: axienet: fix a potential double free in axienet_probe()
Date:   Sat, 6 Jul 2019 11:38:41 +0800
Message-Id: <1562384321-46727-1-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-06 11:41:12,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-06 11:40:35,
        Serialize complete at 2019-07-06 11:40:35
X-MAIL: mse-fl2.zte.com.cn x663eTXS033818
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a possible use-after-free issue in the axienet_probe():

1701:	np = of_parse_phandle(pdev->dev.of_node, "axistream-connected", 0);
1702:   if (np) {
...
1787:		of_node_put(np); ---> released here
1788:		lp->eth_irq = platform_get_irq(pdev, 0);
1789:	} else {
...
1801:	}
1802:	if (IS_ERR(lp->dma_regs)) {
...
1805:		of_node_put(np); ---> double released here
1806:		goto free_netdev;
1807:	}

We solve this problem by removing the unnecessary of_node_put().

Fixes: 28ef9ebdb64c ("net: axienet: make use of axistream-connected attribute optional")
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Anirudha Sarangi <anirudh@xilinx.com>
Cc: John Linn <John.Linn@xilinx.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Robert Hancock <hancock@sedsystems.ca>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 561e28a..4fc627f 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1802,7 +1802,6 @@ static int axienet_probe(struct platform_device *pdev)
 	if (IS_ERR(lp->dma_regs)) {
 		dev_err(&pdev->dev, "could not map DMA regs\n");
 		ret = PTR_ERR(lp->dma_regs);
-		of_node_put(np);
 		goto free_netdev;
 	}
 	if ((lp->rx_irq <= 0) || (lp->tx_irq <= 0)) {
-- 
2.9.5

