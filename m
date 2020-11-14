Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8CE2B2CD9
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 12:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgKNLNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 06:13:30 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7192 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgKNLNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 06:13:30 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CYCPS22RPz15Vlr;
        Sat, 14 Nov 2020 19:13:16 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Sat, 14 Nov 2020
 19:13:25 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] can: ti_hecc: Fix memleak in ti_hecc_probe
Date:   Sat, 14 Nov 2020 19:17:08 +0800
Message-ID: <20201114111708.3465543-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the error handling, we should goto the probe_exit_candev
to free ndev to prevent memory leak.

Fixes: dabf54dd1c63 ("can: ti_hecc: Convert TI HECC driver to DT only driver")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/net/can/ti_hecc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 9913f5458279..2c22f40e12bd 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -881,7 +881,8 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	priv->base = devm_platform_ioremap_resource_byname(pdev, "hecc");
 	if (IS_ERR(priv->base)) {
 		dev_err(&pdev->dev, "hecc ioremap failed\n");
-		return PTR_ERR(priv->base);
+		err = PTR_ERR(priv->base);
+		goto probe_exit_candev;
 	}
 
 	/* handle hecc-ram memory */
@@ -889,20 +890,22 @@ static int ti_hecc_probe(struct platform_device *pdev)
 							       "hecc-ram");
 	if (IS_ERR(priv->hecc_ram)) {
 		dev_err(&pdev->dev, "hecc-ram ioremap failed\n");
-		return PTR_ERR(priv->hecc_ram);
+		err = PTR_ERR(priv->hecc_ram);
+		goto probe_exit_candev;
 	}
 
 	/* handle mbx memory */
 	priv->mbx = devm_platform_ioremap_resource_byname(pdev, "mbx");
 	if (IS_ERR(priv->mbx)) {
 		dev_err(&pdev->dev, "mbx ioremap failed\n");
-		return PTR_ERR(priv->mbx);
+		err = PTR_ERR(priv->mbx);
+		goto probe_exit_candev;
 	}
 
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!irq) {
 		dev_err(&pdev->dev, "No irq resource\n");
-		goto probe_exit;
+		goto probe_exit_candev;
 	}
 
 	priv->ndev = ndev;
@@ -966,7 +969,7 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	clk_put(priv->clk);
 probe_exit_candev:
 	free_candev(ndev);
-probe_exit:
+
 	return err;
 }
 
-- 
2.25.4

