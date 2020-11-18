Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61D12B8173
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgKRQEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgKRQEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:04:21 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C760C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:04:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kfPwR-0001km-8g; Wed, 18 Nov 2020 17:04:19 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 3/4] can: flexcan: flexcan_chip_start(): fix erroneous flexcan_transceiver_enable() during bus-off recovery
Date:   Wed, 18 Nov 2020 17:04:13 +0100
Message-Id: <20201118160414.2731659-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118160414.2731659-1-mkl@pengutronix.de>
References: <20201118160414.2731659-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the CAN controller goes into bus off, the do_set_mode() callback with
CAN_MODE_START can be used to recover the controller, which then calls
flexcan_chip_start(). If configured, this is done automatically by the
framework or manually by the user.

In flexcan_chip_start() there is an explicit call to
flexcan_transceiver_enable(), which does a regulator_enable() on the
transceiver regulator. This results in a net usage counter increase, as there
is no corresponding flexcan_transceiver_disable() in the bus off code path.
This further leads to the transceiver stuck enabled, even if the CAN interface
is shut down.

To fix this problem the
flexcan_transceiver_enable()/flexcan_transceiver_disable() are moved out of
flexcan_chip_start()/flexcan_chip_stop() into flexcan_open()/flexcan_close().

Fixes: e955cead0311 ("CAN: Add Flexcan CAN controller driver")
Link: https://lore.kernel.org/r/20201118150148.2664024-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index d6a9cf0e9b60..99e5f272205d 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1567,14 +1567,10 @@ static int flexcan_chip_start(struct net_device *dev)
 		priv->write(reg_ctrl2, &regs->ctrl2);
 	}
 
-	err = flexcan_transceiver_enable(priv);
-	if (err)
-		goto out_chip_disable;
-
 	/* synchronize with the can bus */
 	err = flexcan_chip_unfreeze(priv);
 	if (err)
-		goto out_transceiver_disable;
+		goto out_chip_disable;
 
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
@@ -1592,8 +1588,6 @@ static int flexcan_chip_start(struct net_device *dev)
 
 	return 0;
 
- out_transceiver_disable:
-	flexcan_transceiver_disable(priv);
  out_chip_disable:
 	flexcan_chip_disable(priv);
 	return err;
@@ -1623,7 +1617,6 @@ static int __flexcan_chip_stop(struct net_device *dev, bool disable_on_error)
 	priv->write(priv->reg_ctrl_default & ~FLEXCAN_CTRL_ERR_ALL,
 		    &regs->ctrl);
 
-	flexcan_transceiver_disable(priv);
 	priv->can.state = CAN_STATE_STOPPED;
 
 	return 0;
@@ -1665,10 +1658,14 @@ static int flexcan_open(struct net_device *dev)
 	if (err)
 		goto out_runtime_put;
 
-	err = request_irq(dev->irq, flexcan_irq, IRQF_SHARED, dev->name, dev);
+	err = flexcan_transceiver_enable(priv);
 	if (err)
 		goto out_close;
 
+	err = request_irq(dev->irq, flexcan_irq, IRQF_SHARED, dev->name, dev);
+	if (err)
+		goto out_transceiver_disable;
+
 	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
 		priv->mb_size = sizeof(struct flexcan_mb) + CANFD_MAX_DLEN;
 	else
@@ -1720,6 +1717,8 @@ static int flexcan_open(struct net_device *dev)
 	can_rx_offload_del(&priv->offload);
  out_free_irq:
 	free_irq(dev->irq, dev);
+ out_transceiver_disable:
+	flexcan_transceiver_disable(priv);
  out_close:
 	close_candev(dev);
  out_runtime_put:
@@ -1738,6 +1737,7 @@ static int flexcan_close(struct net_device *dev)
 
 	can_rx_offload_del(&priv->offload);
 	free_irq(dev->irq, dev);
+	flexcan_transceiver_disable(priv);
 
 	close_candev(dev);
 	pm_runtime_put(priv->dev);
-- 
2.29.2

