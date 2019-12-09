Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F091171B9
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfLIQdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:33:06 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38963 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfLIQdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:33:05 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ieLy3-0001up-5G; Mon, 09 Dec 2019 17:33:03 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 07/13] can: flexcan: add low power enter/exit acknowledgment helper
Date:   Mon,  9 Dec 2019 17:32:50 +0100
Message-Id: <20191209163256.12000-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191209163256.12000-1-mkl@pengutronix.de>
References: <20191209163256.12000-1-mkl@pengutronix.de>
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

From: Joakim Zhang <qiangqing.zhang@nxp.com>

The MCR[LPMACK] read-only bit indicates that FlexCAN is in a lower-power
mode (Disabled mode, Doze mode, Stop mode).

The CPU can poll this bit to know when FlexCAN has actually entered low
power mode. The low power enter/exit acknowledgment helper will reduce
code duplication for disabled mode, doze mode and stop mode.

Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 46 +++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index b6f675a5e2d9..9f3a5e56fc37 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -389,6 +389,34 @@ static struct flexcan_mb __iomem *flexcan_get_mb(const struct flexcan_priv *priv
 		(&priv->regs->mb[bank][priv->mb_size * mb_index]);
 }
 
+static int flexcan_low_power_enter_ack(struct flexcan_priv *priv)
+{
+	struct flexcan_regs __iomem *regs = priv->regs;
+	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
+
+	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		udelay(10);
+
+	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int flexcan_low_power_exit_ack(struct flexcan_priv *priv)
+{
+	struct flexcan_regs __iomem *regs = priv->regs;
+	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
+
+	while (timeout-- && (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		udelay(10);
+
+	if (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
 static void flexcan_enable_wakeup_irq(struct flexcan_priv *priv, bool enable)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
@@ -506,39 +534,25 @@ static inline int flexcan_transceiver_disable(const struct flexcan_priv *priv)
 static int flexcan_chip_enable(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
-	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
 	u32 reg;
 
 	reg = priv->read(&regs->mcr);
 	reg &= ~FLEXCAN_MCR_MDIS;
 	priv->write(reg, &regs->mcr);
 
-	while (timeout-- && (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
-		udelay(10);
-
-	if (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
-		return -ETIMEDOUT;
-
-	return 0;
+	return flexcan_low_power_exit_ack(priv);
 }
 
 static int flexcan_chip_disable(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
-	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
 	u32 reg;
 
 	reg = priv->read(&regs->mcr);
 	reg |= FLEXCAN_MCR_MDIS;
 	priv->write(reg, &regs->mcr);
 
-	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
-		udelay(10);
-
-	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
-		return -ETIMEDOUT;
-
-	return 0;
+	return flexcan_low_power_enter_ack(priv);
 }
 
 static int flexcan_chip_freeze(struct flexcan_priv *priv)
-- 
2.24.0

