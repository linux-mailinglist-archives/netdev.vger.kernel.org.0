Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C1772F73
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387436AbfGXNDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:03:37 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51051 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfGXNDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 09:03:34 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1hqGvb-0006gK-C9; Wed, 24 Jul 2019 15:03:31 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH 5/7] can: flexcan: fix stop mode acknowledgment
Date:   Wed, 24 Jul 2019 15:03:20 +0200
Message-Id: <20190724130322.31702-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724130322.31702-1-mkl@pengutronix.de>
References: <20190724130322.31702-1-mkl@pengutronix.de>
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

To enter stop mode, the CPU should manually assert a global Stop Mode
request and check the acknowledgment asserted by FlexCAN. The CPU must
only consider the FlexCAN in stop mode when both request and
acknowledgment conditions are satisfied.

Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v5.0
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 33ce45d51e15..fcec8bcb53d6 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -400,9 +400,10 @@ static void flexcan_enable_wakeup_irq(struct flexcan_priv *priv, bool enable)
 	priv->write(reg_mcr, &regs->mcr);
 }
 
-static inline void flexcan_enter_stop_mode(struct flexcan_priv *priv)
+static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
+	unsigned int ackval;
 	u32 reg_mcr;
 
 	reg_mcr = priv->read(&regs->mcr);
@@ -412,20 +413,37 @@ static inline void flexcan_enter_stop_mode(struct flexcan_priv *priv)
 	/* enable stop request */
 	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 			   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
+
+	/* get stop acknowledgment */
+	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
+				     ackval, ackval & (1 << priv->stm.ack_bit),
+				     0, FLEXCAN_TIMEOUT_US))
+		return -ETIMEDOUT;
+
+	return 0;
 }
 
-static inline void flexcan_exit_stop_mode(struct flexcan_priv *priv)
+static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
+	unsigned int ackval;
 	u32 reg_mcr;
 
 	/* remove stop request */
 	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 			   1 << priv->stm.req_bit, 0);
 
+	/* get stop acknowledgment */
+	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
+				     ackval, !(ackval & (1 << priv->stm.ack_bit)),
+				     0, FLEXCAN_TIMEOUT_US))
+		return -ETIMEDOUT;
+
 	reg_mcr = priv->read(&regs->mcr);
 	reg_mcr &= ~FLEXCAN_MCR_SLF_WAK;
 	priv->write(reg_mcr, &regs->mcr);
+
+	return 0;
 }
 
 static inline void flexcan_error_irq_enable(const struct flexcan_priv *priv)
@@ -1614,7 +1632,9 @@ static int __maybe_unused flexcan_suspend(struct device *device)
 		 */
 		if (device_may_wakeup(device)) {
 			enable_irq_wake(dev->irq);
-			flexcan_enter_stop_mode(priv);
+			err = flexcan_enter_stop_mode(priv);
+			if (err)
+				return err;
 		} else {
 			err = flexcan_chip_disable(priv);
 			if (err)
@@ -1664,10 +1684,13 @@ static int __maybe_unused flexcan_noirq_resume(struct device *device)
 {
 	struct net_device *dev = dev_get_drvdata(device);
 	struct flexcan_priv *priv = netdev_priv(dev);
+	int err;
 
 	if (netif_running(dev) && device_may_wakeup(device)) {
 		flexcan_enable_wakeup_irq(priv, false);
-		flexcan_exit_stop_mode(priv);
+		err = flexcan_exit_stop_mode(priv);
+		if (err)
+			return err;
 	}
 
 	return 0;
-- 
2.20.1

