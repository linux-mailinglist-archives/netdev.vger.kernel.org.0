Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEB82753D4
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgIWIy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgIWIy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:54:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606B6C0613D1
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:54:28 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kL0Xi-0000uS-HS; Wed, 23 Sep 2020 10:54:26 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, michael@walle.cc, qiangqing.zhang@nxp.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 10/20] can: flexcan: flexcan_chip_stop(): add error handling and propagate error value
Date:   Wed, 23 Sep 2020 10:54:08 +0200
Message-Id: <20200923085418.2685858-11-mkl@pengutronix.de>
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

This patch implements error handling and propagates the error value of
flexcan_chip_stop(). This function will be called from flexcan_suspend()
in an upcoming patch in some SoCs which support LPSR mode.

Add a new function flexcan_chip_stop_disable_on_error() that tries to
disable the chip even in case of errors.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
[mkl: introduce flexcan_chip_stop_disable_on_error() and use it in flexcan_close()]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20200922144429.2613631-11-mkl@pengutronix.de
---
 drivers/net/can/flexcan.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 52d73115c7fd..4be73ce7518e 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1292,18 +1292,23 @@ static int flexcan_chip_start(struct net_device *dev)
 	return err;
 }
 
-/* flexcan_chip_stop
+/* __flexcan_chip_stop
  *
- * this functions is entered with clocks enabled
+ * this function is entered with clocks enabled
  */
-static void flexcan_chip_stop(struct net_device *dev)
+static int __flexcan_chip_stop(struct net_device *dev, bool disable_on_error)
 {
 	struct flexcan_priv *priv = netdev_priv(dev);
 	struct flexcan_regs __iomem *regs = priv->regs;
+	int err;
 
 	/* freeze + disable module */
-	flexcan_chip_freeze(priv);
-	flexcan_chip_disable(priv);
+	err = flexcan_chip_freeze(priv);
+	if (err && !disable_on_error)
+		return err;
+	err = flexcan_chip_disable(priv);
+	if (err && !disable_on_error)
+		goto out_chip_unfreeze;
 
 	/* Disable all interrupts */
 	priv->write(0, &regs->imask2);
@@ -1313,6 +1318,23 @@ static void flexcan_chip_stop(struct net_device *dev)
 
 	flexcan_transceiver_disable(priv);
 	priv->can.state = CAN_STATE_STOPPED;
+
+	return 0;
+
+ out_chip_unfreeze:
+	flexcan_chip_unfreeze(priv);
+
+	return err;
+}
+
+static inline int flexcan_chip_stop_disable_on_error(struct net_device *dev)
+{
+	return __flexcan_chip_stop(dev, true);
+}
+
+static inline int flexcan_chip_stop(struct net_device *dev)
+{
+	return __flexcan_chip_stop(dev, false);
 }
 
 static int flexcan_open(struct net_device *dev)
@@ -1394,7 +1416,7 @@ static int flexcan_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 	can_rx_offload_disable(&priv->offload);
-	flexcan_chip_stop(dev);
+	flexcan_chip_stop_disable_on_error(dev);
 
 	can_rx_offload_del(&priv->offload);
 	free_irq(dev->irq, dev);
-- 
2.28.0

