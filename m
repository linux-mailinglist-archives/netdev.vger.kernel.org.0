Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744382753DB
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgIWIzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIWIy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:54:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0AFC0613D9
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:54:27 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kL0Xh-0000uS-9b; Wed, 23 Sep 2020 10:54:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, michael@walle.cc, qiangqing.zhang@nxp.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 07/20] can: flexcan: flexcan_probe(): make regulator xceiver optional
Date:   Wed, 23 Sep 2020 10:54:05 +0200
Message-Id: <20200923085418.2685858-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923085418.2685858-1-mkl@pengutronix.de>
References: <20200923085418.2685858-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the transcevier regulator is optional, this patch switches from
devm_regulator_get() to devm_regulator_get_optional(). This gets rid of "using
dummy regulator" warning message from the regulator core, if no regulator is
available.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20200922144429.2613631-8-mkl@pengutronix.de
---
 drivers/net/can/flexcan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 06cddc468739..52b53ff223f4 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1579,11 +1579,13 @@ static int flexcan_probe(struct platform_device *pdev)
 	u8 clk_src = 1;
 	u32 clock_freq = 0;
 
-	reg_xceiver = devm_regulator_get(&pdev->dev, "xceiver");
+	reg_xceiver = devm_regulator_get_optional(&pdev->dev, "xceiver");
 	if (PTR_ERR(reg_xceiver) == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
-	else if (IS_ERR(reg_xceiver))
+	else if (PTR_ERR(reg_xceiver) == -ENODEV)
 		reg_xceiver = NULL;
+	else if (IS_ERR(reg_xceiver))
+		return PTR_ERR(reg_xceiver);
 
 	if (pdev->dev.of_node) {
 		of_property_read_u32(pdev->dev.of_node,
-- 
2.28.0

