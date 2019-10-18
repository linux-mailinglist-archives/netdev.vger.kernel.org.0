Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA6EDC6FE
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439654AbfJROLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:11:50 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53901 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439192AbfJROLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:11:50 -0400
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.lab.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1iLSyp-0004dK-38; Fri, 18 Oct 2019 16:11:47 +0200
Received: from mtr by dude02.lab.pengutronix.de with local (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1iLSyn-0006R5-GX; Fri, 18 Oct 2019 16:11:45 +0200
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     nicolas.ferre@microchip.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH] macb: propagate errors when getting optional clocks
Date:   Fri, 18 Oct 2019 16:11:43 +0200
Message-Id: <20191018141143.24148-1-m.tretter@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mtr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tx_clk, rx_clk, and tsu_clk are optional. Currently the macb driver
marks clock as not available if it receives an error when trying to get
a clock. This is wrong, because a clock controller might return
-EPROBE_DEFER if a clock is not available, but will eventually become
available.

In these cases, the driver would probe successfully but will never be
able to adjust the clocks, because the clocks were not available during
probe, but became available later.

For example, the clock controller for the ZynqMP is implemented in the
PMU firmware and the clocks are only available after the firmware driver
has been probed.

Use devm_clk_get_optional() in instead of devm_clk_get() to get the
optional clock and propagate all errors to the calling function.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 drivers/net/ethernet/cadence/macb_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 8e8d557901a9..1e1b774e1953 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3405,17 +3405,17 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 		return err;
 	}
 
-	*tx_clk = devm_clk_get(&pdev->dev, "tx_clk");
+	*tx_clk = devm_clk_get_optional(&pdev->dev, "tx_clk");
 	if (IS_ERR(*tx_clk))
-		*tx_clk = NULL;
+		return PTR_ERR(*tx_clk);
 
-	*rx_clk = devm_clk_get(&pdev->dev, "rx_clk");
+	*rx_clk = devm_clk_get_optional(&pdev->dev, "rx_clk");
 	if (IS_ERR(*rx_clk))
-		*rx_clk = NULL;
+		return PTR_ERR(*rx_clk);
 
-	*tsu_clk = devm_clk_get(&pdev->dev, "tsu_clk");
+	*tsu_clk = devm_clk_get_optional(&pdev->dev, "tsu_clk");
 	if (IS_ERR(*tsu_clk))
-		*tsu_clk = NULL;
+		return PTR_ERR(*tsu_clk);
 
 	err = clk_prepare_enable(*pclk);
 	if (err) {
-- 
2.20.1

