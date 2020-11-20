Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359412BAB46
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgKTNdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbgKTNdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FABC061A47
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:31 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XY-0006Fn-8c; Fri, 20 Nov 2020 14:33:28 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 16/25] can: flexcan: factor out enabling and disabling of interrupts into separate function
Date:   Fri, 20 Nov 2020 14:33:09 +0100
Message-Id: <20201120133318.3428231-17-mkl@pengutronix.de>
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

The upcoming patches are going to move the enabling and disabling of the
interrupts. Introduce convenience functions to make these patches simpler.

Link: https://lore.kernel.org/r/20201119100917.3013281-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 41 ++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 56a6bcc6d9d7..681a4d82681c 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1346,6 +1346,31 @@ static void flexcan_ram_init(struct net_device *dev)
 	priv->write(reg_ctrl2, &regs->ctrl2);
 }
 
+static void flexcan_chip_interrupts_enable(const struct net_device *dev)
+{
+	const struct flexcan_priv *priv = netdev_priv(dev);
+	struct flexcan_regs __iomem *regs = priv->regs;
+	u64 reg_imask;
+
+	disable_irq(dev->irq);
+	priv->write(priv->reg_ctrl_default, &regs->ctrl);
+	reg_imask = priv->rx_mask | priv->tx_mask;
+	priv->write(upper_32_bits(reg_imask), &regs->imask2);
+	priv->write(lower_32_bits(reg_imask), &regs->imask1);
+	enable_irq(dev->irq);
+}
+
+static void flexcan_chip_interrupts_disable(const struct net_device *dev)
+{
+	const struct flexcan_priv *priv = netdev_priv(dev);
+	struct flexcan_regs __iomem *regs = priv->regs;
+
+	priv->write(0, &regs->imask2);
+	priv->write(0, &regs->imask1);
+	priv->write(priv->reg_ctrl_default & ~FLEXCAN_CTRL_ERR_ALL,
+		    &regs->ctrl);
+}
+
 /* flexcan_chip_start
  *
  * this functions is entered with clocks enabled
@@ -1356,7 +1381,6 @@ static int flexcan_chip_start(struct net_device *dev)
 	struct flexcan_priv *priv = netdev_priv(dev);
 	struct flexcan_regs __iomem *regs = priv->regs;
 	u32 reg_mcr, reg_ctrl, reg_ctrl2, reg_mecr;
-	u64 reg_imask;
 	int err, i;
 	struct flexcan_mb __iomem *mb;
 
@@ -1574,13 +1598,7 @@ static int flexcan_chip_start(struct net_device *dev)
 
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
-	/* enable interrupts atomically */
-	disable_irq(dev->irq);
-	priv->write(priv->reg_ctrl_default, &regs->ctrl);
-	reg_imask = priv->rx_mask | priv->tx_mask;
-	priv->write(upper_32_bits(reg_imask), &regs->imask2);
-	priv->write(lower_32_bits(reg_imask), &regs->imask1);
-	enable_irq(dev->irq);
+	flexcan_chip_interrupts_enable(dev);
 
 	/* print chip status */
 	netdev_dbg(dev, "%s: reading mcr=0x%08x ctrl=0x%08x\n", __func__,
@@ -1600,7 +1618,6 @@ static int flexcan_chip_start(struct net_device *dev)
 static int __flexcan_chip_stop(struct net_device *dev, bool disable_on_error)
 {
 	struct flexcan_priv *priv = netdev_priv(dev);
-	struct flexcan_regs __iomem *regs = priv->regs;
 	int err;
 
 	/* freeze + disable module */
@@ -1611,11 +1628,7 @@ static int __flexcan_chip_stop(struct net_device *dev, bool disable_on_error)
 	if (err && !disable_on_error)
 		goto out_chip_unfreeze;
 
-	/* Disable all interrupts */
-	priv->write(0, &regs->imask2);
-	priv->write(0, &regs->imask1);
-	priv->write(priv->reg_ctrl_default & ~FLEXCAN_CTRL_ERR_ALL,
-		    &regs->ctrl);
+	flexcan_chip_interrupts_disable(dev);
 
 	priv->can.state = CAN_STATE_STOPPED;
 
-- 
2.29.2

