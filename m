Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B4D2BAB30
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgKTNde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728206AbgKTNdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C6EC061A04
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:31 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XZ-0006Fn-Jf; Fri, 20 Nov 2020 14:33:29 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 19/25] can: flexcan: flexcan_open(): completely initialize controller before requesting IRQ
Date:   Fri, 20 Nov 2020 14:33:12 +0100
Message-Id: <20201120133318.3428231-20-mkl@pengutronix.de>
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

This patch changes the order in which the flexcan controller is brought up
during flexcan_open(). It makes sure that the chip is completely initialized
before the IRQs are requested and finally enabled.

Link: https://lore.kernel.org/r/20201119100917.3013281-5-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 0705b6384e49..e98368be1669 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1712,32 +1712,33 @@ static int flexcan_open(struct net_device *dev)
 	if (err)
 		goto out_close;
 
-	err = request_irq(dev->irq, flexcan_irq, IRQF_SHARED, dev->name, dev);
+	err = flexcan_rx_offload_setup(dev);
 	if (err)
 		goto out_transceiver_disable;
 
-	err = flexcan_rx_offload_setup(dev);
+	err = flexcan_chip_start(dev);
 	if (err)
-		goto out_free_irq;
+		goto out_can_rx_offload_del;
 
-	/* start chip and queuing */
-	err = flexcan_chip_start(dev);
+	can_rx_offload_enable(&priv->offload);
+
+	err = request_irq(dev->irq, flexcan_irq, IRQF_SHARED, dev->name, dev);
 	if (err)
-		goto out_offload_del;
+		goto out_can_rx_offload_disable;
 
 	flexcan_chip_interrupts_enable(dev);
 
 	can_led_event(dev, CAN_LED_EVENT_OPEN);
 
-	can_rx_offload_enable(&priv->offload);
 	netif_start_queue(dev);
 
 	return 0;
 
- out_offload_del:
+ out_can_rx_offload_disable:
+	can_rx_offload_disable(&priv->offload);
+	flexcan_chip_stop(dev);
+ out_can_rx_offload_del:
 	can_rx_offload_del(&priv->offload);
- out_free_irq:
-	free_irq(dev->irq, dev);
  out_transceiver_disable:
 	flexcan_transceiver_disable(priv);
  out_close:
-- 
2.29.2

