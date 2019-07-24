Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD0A72F6C
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfGXNDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:03:35 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57761 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfGXNDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 09:03:33 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1hqGva-0006gK-Nu; Wed, 24 Jul 2019 15:03:30 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Wen Yang <wen.yang99@zte.com.cn>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4/7] can: flexcan: fix an use-after-free in flexcan_setup_stop_mode()
Date:   Wed, 24 Jul 2019 15:03:19 +0200
Message-Id: <20190724130322.31702-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724130322.31702-1-mkl@pengutronix.de>
References: <20190724130322.31702-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

The gpr_np variable is still being used in dev_dbg() after the
of_node_put() call, which may result in use-after-free.

Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: linux-stable <stable@vger.kernel.org> # >= v5.0
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index f2fe344593d5..33ce45d51e15 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1437,10 +1437,10 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 
 	priv = netdev_priv(dev);
 	priv->stm.gpr = syscon_node_to_regmap(gpr_np);
-	of_node_put(gpr_np);
 	if (IS_ERR(priv->stm.gpr)) {
 		dev_dbg(&pdev->dev, "could not find gpr regmap\n");
-		return PTR_ERR(priv->stm.gpr);
+		ret = PTR_ERR(priv->stm.gpr);
+		goto out_put_node;
 	}
 
 	priv->stm.req_gpr = out_val[1];
@@ -1455,7 +1455,9 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 
 	device_set_wakeup_capable(&pdev->dev, true);
 
-	return 0;
+out_put_node:
+	of_node_put(gpr_np);
+	return ret;
 }
 
 static const struct of_device_id flexcan_of_match[] = {
-- 
2.20.1

