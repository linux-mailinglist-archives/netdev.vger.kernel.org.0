Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD162B07CA
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 15:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgKLOui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 09:50:38 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7183 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgKLOui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 09:50:38 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CX4Jw69Xbz15NgY;
        Thu, 12 Nov 2020 22:50:24 +0800 (CST)
Received: from localhost (10.174.176.180) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Nov 2020
 22:50:27 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <harini.katakam@xilinx.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] net: macb: Fix passing zero to 'PTR_ERR'
Date:   Thu, 12 Nov 2020 22:49:36 +0800
Message-ID: <20201112144936.54776-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.176.180]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check PTR_ERR with IS_ERR to fix this.

Fixes: cd5afa91f078 ("net: macb: Add null check for PCLK and HCLK")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 51f866288582..7b1d195787dc 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3711,19 +3711,13 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 	}
 
 	if (IS_ERR_OR_NULL(*pclk)) {
-		err = PTR_ERR(*pclk);
-		if (!err)
-			err = -ENODEV;
-
+		err = IS_ERR(*pclk) ? PTR_ERR(*pclk) : -ENODEV;
 		dev_err(&pdev->dev, "failed to get macb_clk (%d)\n", err);
 		return err;
 	}
 
 	if (IS_ERR_OR_NULL(*hclk)) {
-		err = PTR_ERR(*hclk);
-		if (!err)
-			err = -ENODEV;
-
+		err = IS_ERR(*hclk) ? PTR_ERR(*hclk) : -ENODEV;
 		dev_err(&pdev->dev, "failed to get hclk (%d)\n", err);
 		return err;
 	}
-- 
2.17.1

