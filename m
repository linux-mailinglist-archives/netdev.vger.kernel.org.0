Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC682BAB49
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgKTNdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgKTNdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142F9C0617A7
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:31 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XY-0006Fn-Jv; Fri, 20 Nov 2020 14:33:28 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 17/25] can: flexcan: move enabling/disabling of interrupts from flexcan_chip_{start,stop}() to callers
Date:   Fri, 20 Nov 2020 14:33:10 +0100
Message-Id: <20201120133318.3428231-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function flexcan_chip_start() first configures the CAN controller and then
enables the interrupt, flexcan_chip_stop() does the opposite.

In an upcoming patch the order of operations in flexcan_open() and
flexcan_close() are changed. This requires
flexcan_chip_start()/flexcan_chip_stop_disable_on_error() and
flexcan_chip_interrupts_{enable,disable}() to be independent of each other.

This patch moves the enabling of the interrupts from flexcan_chip_start() to
its callers flexcan_open() and flexcan_resume(). Likewise the disabling of the
interrupts is moved from __flexcan_chip_stop() to its indirect callers
flexcan_close() and flexcan_suspend().

Link: https://lore.kernel.org/r/20201119100917.3013281-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 681a4d82681c..64c174aa868b 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1598,8 +1598,6 @@ static int flexcan_chip_start(struct net_device *dev)
 
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
-	flexcan_chip_interrupts_enable(dev);
-
 	/* print chip status */
 	netdev_dbg(dev, "%s: reading mcr=0x%08x ctrl=0x%08x\n", __func__,
 		   priv->read(&regs->mcr), priv->read(&regs->ctrl));
@@ -1628,8 +1626,6 @@ static int __flexcan_chip_stop(struct net_device *dev, bool disable_on_error)
 	if (err && !disable_on_error)
 		goto out_chip_unfreeze;
 
-	flexcan_chip_interrupts_disable(dev);
-
 	priv->can.state = CAN_STATE_STOPPED;
 
 	return 0;
@@ -1719,6 +1715,8 @@ static int flexcan_open(struct net_device *dev)
 	if (err)
 		goto out_offload_del;
 
+	flexcan_chip_interrupts_enable(dev);
+
 	can_led_event(dev, CAN_LED_EVENT_OPEN);
 
 	can_rx_offload_enable(&priv->offload);
@@ -1747,6 +1745,7 @@ static int flexcan_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	can_rx_offload_disable(&priv->offload);
 	flexcan_chip_stop_disable_on_error(dev);
+	flexcan_chip_interrupts_disable(dev);
 
 	can_rx_offload_del(&priv->offload);
 	free_irq(dev->irq, dev);
@@ -1770,6 +1769,8 @@ static int flexcan_set_mode(struct net_device *dev, enum can_mode mode)
 		if (err)
 			return err;
 
+		flexcan_chip_interrupts_enable(dev);
+
 		netif_wake_queue(dev);
 		break;
 
@@ -2108,6 +2109,8 @@ static int __maybe_unused flexcan_suspend(struct device *device)
 			if (err)
 				return err;
 
+			flexcan_chip_interrupts_disable(dev);
+
 			err = pinctrl_pm_select_sleep_state(device);
 			if (err)
 				return err;
@@ -2143,6 +2146,8 @@ static int __maybe_unused flexcan_resume(struct device *device)
 			err = flexcan_chip_start(dev);
 			if (err)
 				return err;
+
+			flexcan_chip_interrupts_enable(dev);
 		}
 	}
 
-- 
2.29.2

