Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D594E2753C0
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgIWIym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgIWIyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:54:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95838C0613D5
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:54:31 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kL0Xl-0000uS-Be; Wed, 23 Sep 2020 10:54:29 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, michael@walle.cc, qiangqing.zhang@nxp.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 16/20] can: flexcan: add ISO CAN FD feature support
Date:   Wed, 23 Sep 2020 10:54:14 +0200
Message-Id: <20200923085418.2685858-17-mkl@pengutronix.de>
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

ISO CAN FD is introduced to increase the failture detection capability
than non-ISO CAN FD. The non-ISO CAN FD is still supported by FlexCAN so
that it can be used mainly during an intermediate phase, for evaluation
and development purposes.

Therefore, it is strongly recommended to configure FlexCAN to the ISO
CAN FD protocol by setting the ISOCANFDEN field in the CTRL2 register.

NOTE: If you only set "fd on", driver will use ISO FD mode by default.
You should set "fd-non-iso on" after setting "fd on" if you want to use
NON ISO FD mode.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20190712075926.7357-6-qiangqing.zhang@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 8dca553fa545..e3ecce80eadb 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -94,6 +94,7 @@
 #define FLEXCAN_CTRL2_MRP		BIT(18)
 #define FLEXCAN_CTRL2_RRS		BIT(17)
 #define FLEXCAN_CTRL2_EACEN		BIT(16)
+#define FLEXCAN_CTRL2_ISOCANFDEN	BIT(12)
 
 /* FLEXCAN memory error control register (MECR) bits */
 #define FLEXCAN_MECR_ECRWRDIS		BIT(31)
@@ -1165,7 +1166,7 @@ static void flexcan_set_bittiming_cbt(const struct net_device *dev)
 	priv->write(reg_cbt, &regs->cbt);
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
-		u32 reg_fdcbt;
+		u32 reg_fdcbt, reg_ctrl2;
 
 		if (bt->brp != dbt->brp)
 			netdev_warn(dev, "Data brp=%d and brp=%d don't match, this may result in a phase error. Consider using different bitrate and/or data bitrate.\n",
@@ -1184,7 +1185,14 @@ static void flexcan_set_bittiming_cbt(const struct net_device *dev)
 			dbt->phase_seg1 = 0x8;
 		}
 
-		reg_fdcbt = FIELD_PREP(FLEXCAN_FDCBT_FPRESDIV_MASK, dbt->brp - 1) |
+		reg_fdcbt = priv->read(&regs->fdcbt);
+		reg_fdcbt &= ~(FIELD_PREP(FLEXCAN_FDCBT_FPRESDIV_MASK, 0x3ff) |
+			       FIELD_PREP(FLEXCAN_FDCBT_FRJW_MASK, 0x7) |
+			       FIELD_PREP(FLEXCAN_FDCBT_FPROPSEG_MASK, 0x1f) |
+			       FIELD_PREP(FLEXCAN_FDCBT_FPSEG1_MASK, 0x7) |
+			       FIELD_PREP(FLEXCAN_FDCBT_FPSEG2_MASK, 0x7));
+
+		reg_fdcbt |= FIELD_PREP(FLEXCAN_FDCBT_FPRESDIV_MASK, dbt->brp - 1) |
 			FIELD_PREP(FLEXCAN_FDCBT_FRJW_MASK, dbt->sjw - 1) |
 			FIELD_PREP(FLEXCAN_FDCBT_FPROPSEG_MASK, dbt->prop_seg) |
 			FIELD_PREP(FLEXCAN_FDCBT_FPSEG1_MASK, dbt->phase_seg1 - 1) |
@@ -1192,6 +1200,15 @@ static void flexcan_set_bittiming_cbt(const struct net_device *dev)
 
 		netdev_dbg(dev, "writing fdcbt=0x%08x\n", reg_fdcbt);
 		priv->write(reg_fdcbt, &regs->fdcbt);
+
+		/* CTRL2 */
+		reg_ctrl2 = priv->read(&regs->ctrl2);
+		reg_ctrl2 &= ~FLEXCAN_CTRL2_ISOCANFDEN;
+		if (!(priv->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO))
+			reg_ctrl2 |= FLEXCAN_CTRL2_ISOCANFDEN;
+
+		netdev_dbg(dev, "writing ctrl2=0x%08x\n", reg_ctrl2);
+		priv->write(reg_ctrl2, &regs->ctrl2);
 	}
 
 	/* FDCTRL */
@@ -1204,11 +1221,11 @@ static void flexcan_set_bittiming_cbt(const struct net_device *dev)
 	netdev_dbg(dev, "writing fdctrl=0x%08x\n", reg_fdctrl);
 	priv->write(reg_fdctrl, &regs->fdctrl);
 
-	netdev_dbg(dev, "%s: mcr=0x%08x ctrl=0x%08x fdctrl=0x%08x cbt=0x%08x fdcbt=0x%08x\n",
+	netdev_dbg(dev, "%s: mcr=0x%08x ctrl=0x%08x ctrl2=0x%08x fdctrl=0x%08x cbt=0x%08x fdcbt=0x%08x\n",
 		   __func__,
 		   priv->read(&regs->mcr), priv->read(&regs->ctrl),
-		   priv->read(&regs->fdctrl), priv->read(&regs->cbt),
-		   priv->read(&regs->fdcbt));
+		   priv->read(&regs->ctrl2), priv->read(&regs->fdctrl),
+		   priv->read(&regs->cbt), priv->read(&regs->fdcbt));
 }
 
 static void flexcan_set_bittiming(struct net_device *dev)
@@ -1911,7 +1928,8 @@ static int flexcan_probe(struct platform_device *pdev)
 	priv->reg_xceiver = reg_xceiver;
 
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) {
-		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
+		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
+			CAN_CTRLMODE_FD_NON_ISO;
 		priv->can.bittiming_const = &flexcan_fd_bittiming_const;
 		priv->can.data_bittiming_const =
 			&flexcan_fd_data_bittiming_const;
-- 
2.28.0

