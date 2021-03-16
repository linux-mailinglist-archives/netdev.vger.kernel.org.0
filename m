Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34A833CFB6
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhCPIVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbhCPIVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:21:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DF4C06175F
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 01:21:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lM4x7-0003GO-Oc
        for netdev@vger.kernel.org; Tue, 16 Mar 2021 09:21:21 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CBB6B5F6475
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 08:21:18 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C97455F642A;
        Tue, 16 Mar 2021 08:21:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3c8d1744;
        Tue, 16 Mar 2021 08:21:06 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Tong Zhang <ztong0001@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 09/11] can: c_can: move runtime PM enable/disable to c_can_platform
Date:   Tue, 16 Mar 2021 09:21:02 +0100
Message-Id: <20210316082104.4027260-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316082104.4027260-1-mkl@pengutronix.de>
References: <20210316082104.4027260-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

Currently doing modprobe c_can_pci will make the kernel complain:

    Unbalanced pm_runtime_enable!

this is caused by pm_runtime_enable() called before pm is initialized.

This fix is similar to 227619c3ff7c, move those pm_enable/disable code
to c_can_platform.

Fixes: 4cdd34b26826 ("can: c_can: Add runtime PM support to Bosch C_CAN/D_CAN controller")
Link: http://lore.kernel.org/r/20210302025542.987600-1-ztong0001@gmail.com
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c          | 24 +-----------------------
 drivers/net/can/c_can/c_can_platform.c |  6 +++++-
 2 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index ef474bae47a1..6958830cb983 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -212,18 +212,6 @@ static const struct can_bittiming_const c_can_bittiming_const = {
 	.brp_inc = 1,
 };
 
-static inline void c_can_pm_runtime_enable(const struct c_can_priv *priv)
-{
-	if (priv->device)
-		pm_runtime_enable(priv->device);
-}
-
-static inline void c_can_pm_runtime_disable(const struct c_can_priv *priv)
-{
-	if (priv->device)
-		pm_runtime_disable(priv->device);
-}
-
 static inline void c_can_pm_runtime_get_sync(const struct c_can_priv *priv)
 {
 	if (priv->device)
@@ -1335,7 +1323,6 @@ static const struct net_device_ops c_can_netdev_ops = {
 
 int register_c_can_dev(struct net_device *dev)
 {
-	struct c_can_priv *priv = netdev_priv(dev);
 	int err;
 
 	/* Deactivate pins to prevent DRA7 DCAN IP from being
@@ -1345,28 +1332,19 @@ int register_c_can_dev(struct net_device *dev)
 	 */
 	pinctrl_pm_select_sleep_state(dev->dev.parent);
 
-	c_can_pm_runtime_enable(priv);
-
 	dev->flags |= IFF_ECHO;	/* we support local echo */
 	dev->netdev_ops = &c_can_netdev_ops;
 
 	err = register_candev(dev);
-	if (err)
-		c_can_pm_runtime_disable(priv);
-	else
+	if (!err)
 		devm_can_led_init(dev);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(register_c_can_dev);
 
 void unregister_c_can_dev(struct net_device *dev)
 {
-	struct c_can_priv *priv = netdev_priv(dev);
-
 	unregister_candev(dev);
-
-	c_can_pm_runtime_disable(priv);
 }
 EXPORT_SYMBOL_GPL(unregister_c_can_dev);
 
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index 05f425ceb53a..47b251b1607c 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -29,6 +29,7 @@
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/clk.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -386,6 +387,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dev);
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
+	pm_runtime_enable(priv->device);
 	ret = register_c_can_dev(dev);
 	if (ret) {
 		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
@@ -398,6 +400,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	return 0;
 
 exit_free_device:
+	pm_runtime_disable(priv->device);
 	free_c_can_dev(dev);
 exit:
 	dev_err(&pdev->dev, "probe failed\n");
@@ -408,9 +411,10 @@ static int c_can_plat_probe(struct platform_device *pdev)
 static int c_can_plat_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
+	struct c_can_priv *priv = netdev_priv(dev);
 
 	unregister_c_can_dev(dev);
-
+	pm_runtime_disable(priv->device);
 	free_c_can_dev(dev);
 
 	return 0;
-- 
2.30.1


