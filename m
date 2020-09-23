Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD212753C2
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgIWIyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgIWIyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:54:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF74C0613D3
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:54:30 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kL0Xk-0000uS-2J; Wed, 23 Sep 2020 10:54:28 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, michael@walle.cc, qiangqing.zhang@nxp.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 13/20] can: flexcan: flexcan_set_bittiming(): move setup of CAN-2.0 bitiming into separate function
Date:   Wed, 23 Sep 2020 10:54:11 +0200
Message-Id: <20200923085418.2685858-14-mkl@pengutronix.de>
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

This is a patch prepares for the CAN-FD support. In a later patch the
setup for canfd bittiming will be added, with this patch the change is
easier to read.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20200922144429.2613631-14-mkl@pengutronix.de
---
 drivers/net/can/flexcan.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 35d0fa59e957..a9908deae411 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1037,7 +1037,7 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 	return handled;
 }
 
-static void flexcan_set_bittiming(struct net_device *dev)
+static void flexcan_set_bittiming_ctrl(const struct net_device *dev)
 {
 	const struct flexcan_priv *priv = netdev_priv(dev);
 	const struct can_bittiming *bt = &priv->can.bittiming;
@@ -1049,10 +1049,7 @@ static void flexcan_set_bittiming(struct net_device *dev)
 		 FLEXCAN_CTRL_RJW(0x3) |
 		 FLEXCAN_CTRL_PSEG1(0x7) |
 		 FLEXCAN_CTRL_PSEG2(0x7) |
-		 FLEXCAN_CTRL_PROPSEG(0x7) |
-		 FLEXCAN_CTRL_LPB |
-		 FLEXCAN_CTRL_SMP |
-		 FLEXCAN_CTRL_LOM);
+		 FLEXCAN_CTRL_PROPSEG(0x7));
 
 	reg |= FLEXCAN_CTRL_PRESDIV(bt->brp - 1) |
 		FLEXCAN_CTRL_PSEG1(bt->phase_seg1 - 1) |
@@ -1060,6 +1057,24 @@ static void flexcan_set_bittiming(struct net_device *dev)
 		FLEXCAN_CTRL_RJW(bt->sjw - 1) |
 		FLEXCAN_CTRL_PROPSEG(bt->prop_seg - 1);
 
+	netdev_dbg(dev, "writing ctrl=0x%08x\n", reg);
+	priv->write(reg, &regs->ctrl);
+
+	/* print chip status */
+	netdev_dbg(dev, "%s: mcr=0x%08x ctrl=0x%08x\n", __func__,
+		   priv->read(&regs->mcr), priv->read(&regs->ctrl));
+}
+
+static void flexcan_set_bittiming(struct net_device *dev)
+{
+	const struct flexcan_priv *priv = netdev_priv(dev);
+	struct flexcan_regs __iomem *regs = priv->regs;
+	u32 reg;
+
+	reg = priv->read(&regs->ctrl);
+	reg &= ~(FLEXCAN_CTRL_LPB | FLEXCAN_CTRL_SMP |
+		 FLEXCAN_CTRL_LOM);
+
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)
 		reg |= FLEXCAN_CTRL_LPB;
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
@@ -1070,9 +1085,7 @@ static void flexcan_set_bittiming(struct net_device *dev)
 	netdev_dbg(dev, "writing ctrl=0x%08x\n", reg);
 	priv->write(reg, &regs->ctrl);
 
-	/* print chip status */
-	netdev_dbg(dev, "%s: mcr=0x%08x ctrl=0x%08x\n", __func__,
-		   priv->read(&regs->mcr), priv->read(&regs->ctrl));
+	return flexcan_set_bittiming_ctrl(dev);
 }
 
 /* flexcan_chip_start
-- 
2.28.0

