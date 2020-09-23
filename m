Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906BA2753B7
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgIWIyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgIWIya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:54:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD71BC061755
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:54:29 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kL0Xj-0000uS-9B; Wed, 23 Sep 2020 10:54:27 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, michael@walle.cc, qiangqing.zhang@nxp.com,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 11/20] can: flexcan: disable clocks during stop mode
Date:   Wed, 23 Sep 2020 10:54:09 +0200
Message-Id: <20200923085418.2685858-12-mkl@pengutronix.de>
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

From: Joakim Zhang <qiangqing.zhang@nxp.com>

Disable clocks while CAN core is in stop mode.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20191210085721.9853-2-qiangqing.zhang@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 4be73ce7518e..ed2ead7c21ef 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1757,8 +1757,6 @@ static int __maybe_unused flexcan_suspend(struct device *device)
 			err = flexcan_chip_disable(priv);
 			if (err)
 				return err;
-
-			err = pm_runtime_force_suspend(device);
 		}
 		netif_stop_queue(dev);
 		netif_device_detach(dev);
@@ -1784,10 +1782,6 @@ static int __maybe_unused flexcan_resume(struct device *device)
 			if (err)
 				return err;
 		} else {
-			err = pm_runtime_force_resume(device);
-			if (err)
-				return err;
-
 			err = flexcan_chip_enable(priv);
 		}
 	}
@@ -1818,8 +1812,16 @@ static int __maybe_unused flexcan_noirq_suspend(struct device *device)
 	struct net_device *dev = dev_get_drvdata(device);
 	struct flexcan_priv *priv = netdev_priv(dev);
 
-	if (netif_running(dev) && device_may_wakeup(device))
-		flexcan_enable_wakeup_irq(priv, true);
+	if (netif_running(dev)) {
+		int err;
+
+		if (device_may_wakeup(device))
+			flexcan_enable_wakeup_irq(priv, true);
+
+		err = pm_runtime_force_suspend(device);
+		if (err)
+			return err;
+	}
 
 	return 0;
 }
@@ -1829,8 +1831,16 @@ static int __maybe_unused flexcan_noirq_resume(struct device *device)
 	struct net_device *dev = dev_get_drvdata(device);
 	struct flexcan_priv *priv = netdev_priv(dev);
 
-	if (netif_running(dev) && device_may_wakeup(device))
-		flexcan_enable_wakeup_irq(priv, false);
+	if (netif_running(dev)) {
+		int err;
+
+		err = pm_runtime_force_resume(device);
+		if (err)
+			return err;
+
+		if (device_may_wakeup(device))
+			flexcan_enable_wakeup_irq(priv, false);
+	}
 
 	return 0;
 }
-- 
2.28.0

