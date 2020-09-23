Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197582753CA
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgIWIyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgIWIya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:54:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E79C0613D2
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:54:30 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kL0Xj-0000uS-M4; Wed, 23 Sep 2020 10:54:27 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, michael@walle.cc, qiangqing.zhang@nxp.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 12/20] can: flexcan: add LPSR mode support
Date:   Wed, 23 Sep 2020 10:54:10 +0200
Message-Id: <20200923085418.2685858-13-mkl@pengutronix.de>
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

On the i.MX7D in LPSR mode, the controller will be powered off and the
configuration state is lost after system resume. Upcoming i.MX8QM/QXP
will also completely power off the domain, the controller state is lost
and needs restore, too. So we need to set the pinctrl state again and
re-start chip to re-configuration after resume.

For the wakeup case, it should not set pinctrl to sleep state by
pinctrl_pm_select_sleep_state.

If the interface is down before suspend, we don't need to re-configure
it as it will be configured if the interface is brought up later.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20191204113249.3381-7-qiangqing.zhang@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index ed2ead7c21ef..35d0fa59e957 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -23,6 +23,7 @@
 #include <linux/netdevice.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
@@ -1742,7 +1743,7 @@ static int __maybe_unused flexcan_suspend(struct device *device)
 {
 	struct net_device *dev = dev_get_drvdata(device);
 	struct flexcan_priv *priv = netdev_priv(dev);
-	int err = 0;
+	int err;
 
 	if (netif_running(dev)) {
 		/* if wakeup is enabled, enter stop mode
@@ -1754,7 +1755,11 @@ static int __maybe_unused flexcan_suspend(struct device *device)
 			if (err)
 				return err;
 		} else {
-			err = flexcan_chip_disable(priv);
+			err = flexcan_chip_stop(dev);
+			if (err)
+				return err;
+
+			err = pinctrl_pm_select_sleep_state(device);
 			if (err)
 				return err;
 		}
@@ -1763,14 +1768,14 @@ static int __maybe_unused flexcan_suspend(struct device *device)
 	}
 	priv->can.state = CAN_STATE_SLEEPING;
 
-	return err;
+	return 0;
 }
 
 static int __maybe_unused flexcan_resume(struct device *device)
 {
 	struct net_device *dev = dev_get_drvdata(device);
 	struct flexcan_priv *priv = netdev_priv(dev);
-	int err = 0;
+	int err;
 
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 	if (netif_running(dev)) {
@@ -1782,11 +1787,17 @@ static int __maybe_unused flexcan_resume(struct device *device)
 			if (err)
 				return err;
 		} else {
-			err = flexcan_chip_enable(priv);
+			err = pinctrl_pm_select_default_state(device);
+			if (err)
+				return err;
+
+			err = flexcan_chip_start(dev);
+			if (err)
+				return err;
 		}
 	}
 
-	return err;
+	return 0;
 }
 
 static int __maybe_unused flexcan_runtime_suspend(struct device *device)
-- 
2.28.0

