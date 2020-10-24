Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303E4297C45
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 14:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761309AbgJXMPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 08:15:06 -0400
Received: from inva021.nxp.com ([92.121.34.21]:59912 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761244AbgJXMOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Oct 2020 08:14:42 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2B3CE200F0F;
        Sat, 24 Oct 2020 14:14:40 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1EB5F200EFA;
        Sat, 24 Oct 2020 14:14:40 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B72C5202EC;
        Sat, 24 Oct 2020 14:14:39 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [RFC net-next 5/5] net: phy: at803x: remove the use of .ack_interrupt()
Date:   Sat, 24 Oct 2020 15:14:12 +0300
Message-Id: <20201024121412.10070-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201024121412.10070-1-ioana.ciornei@nxp.com>
References: <20201024121412.10070-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of removing the .ack_interrupt() callback, we must replace
its occurrences (aka phy_clear_interrupt), from the 2 places where it is
called from (phy_enable_interrupts and phy_disable_interrupts), with
equivalent functionality.

This means that clearing interrupts now becomes something that the PHY
driver is responsible of doing, before enabling interrupts and after
clearing them. Make this driver follow the new contract.

Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Michael Walle <michael@walle.cc>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/at803x.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 106c6f53755f..aba198adf62d 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -614,6 +614,11 @@ static int at803x_config_intr(struct phy_device *phydev)
 	value = phy_read(phydev, AT803X_INTR_ENABLE);
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		/* Clear any pending interrupts */
+		err = at803x_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		value |= AT803X_INTR_ENABLE_AUTONEG_ERR;
 		value |= AT803X_INTR_ENABLE_SPEED_CHANGED;
 		value |= AT803X_INTR_ENABLE_DUPLEX_CHANGED;
@@ -621,9 +626,14 @@ static int at803x_config_intr(struct phy_device *phydev)
 		value |= AT803X_INTR_ENABLE_LINK_SUCCESS;
 
 		err = phy_write(phydev, AT803X_INTR_ENABLE, value);
-	}
-	else
+	} else {
 		err = phy_write(phydev, AT803X_INTR_ENABLE, 0);
+		if (err)
+			return err;
+
+		/* Clear any pending interrupts */
+		err = at803x_ack_interrupt(phydev);
+	}
 
 	return err;
 }
@@ -1080,7 +1090,6 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= at803x_resume,
 	/* PHY_GBIT_FEATURES */
 	.read_status		= at803x_read_status,
-	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
@@ -1101,7 +1110,6 @@ static struct phy_driver at803x_driver[] = {
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 }, {
@@ -1120,7 +1128,6 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.read_status		= at803x_read_status,
 	.aneg_done		= at803x_aneg_done,
-	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
@@ -1141,7 +1148,6 @@ static struct phy_driver at803x_driver[] = {
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
@@ -1154,7 +1160,6 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= at803x_resume,
 	.flags			= PHY_POLL_CABLE_TEST,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
-- 
2.28.0

