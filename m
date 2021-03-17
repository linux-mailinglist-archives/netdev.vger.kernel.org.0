Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C93533F546
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 17:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhCQQQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 12:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhCQQQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 12:16:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCC3C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 09:16:12 -0700 (PDT)
Received: from [2a0a:edc0:0:c01:1d::a2] (helo=drehscheibe.grey.stw.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lMYqB-0002yC-40; Wed, 17 Mar 2021 17:16:11 +0100
Received: from [2a0a:edc0:0:1101:1d::39] (helo=dude03.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lMYq9-0008Qx-KR; Wed, 17 Mar 2021 17:16:09 +0100
Received: from mtr by dude03.red.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lMYq9-008pYB-EQ; Wed, 17 Mar 2021 17:16:09 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net
Subject: [PATCH] net: macb: simplify clk_init with dev_err_probe
Date:   Wed, 17 Mar 2021 17:16:09 +0100
Message-Id: <20210317161609.2104738-1-m.tretter@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mtr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some platforms, e.g., the ZynqMP, devm_clk_get can return
-EPROBE_DEFER if the clock controller, which is implemented in firmware,
has not been probed yet.

As clk_init is only called during probe, use dev_err_probe to simplify
the error message and hide it for -EPROBE_DEFER.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 drivers/net/ethernet/cadence/macb_main.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e7c123aadf56..f56f3dbbc015 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3758,17 +3758,15 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 		*hclk = devm_clk_get(&pdev->dev, "hclk");
 	}
 
-	if (IS_ERR_OR_NULL(*pclk)) {
-		err = IS_ERR(*pclk) ? PTR_ERR(*pclk) : -ENODEV;
-		dev_err(&pdev->dev, "failed to get macb_clk (%d)\n", err);
-		return err;
-	}
-
-	if (IS_ERR_OR_NULL(*hclk)) {
-		err = IS_ERR(*hclk) ? PTR_ERR(*hclk) : -ENODEV;
-		dev_err(&pdev->dev, "failed to get hclk (%d)\n", err);
-		return err;
-	}
+	if (IS_ERR_OR_NULL(*pclk))
+		return dev_err_probe(&pdev->dev,
+				     IS_ERR(*pclk) ? PTR_ERR(*pclk) : -ENODEV,
+				     "failed to get pclk\n");
+
+	if (IS_ERR_OR_NULL(*hclk))
+		return dev_err_probe(&pdev->dev,
+				     IS_ERR(*hclk) ? PTR_ERR(*hclk) : -ENODEV,
+				     "failed to get hclk\n");
 
 	*tx_clk = devm_clk_get_optional(&pdev->dev, "tx_clk");
 	if (IS_ERR(*tx_clk))
-- 
2.29.2

