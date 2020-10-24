Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3235297C3F
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 14:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761284AbgJXMOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 08:14:45 -0400
Received: from inva021.nxp.com ([92.121.34.21]:59896 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761242AbgJXMOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Oct 2020 08:14:42 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B4D5F200F06;
        Sat, 24 Oct 2020 14:14:39 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A8875200EFA;
        Sat, 24 Oct 2020 14:14:39 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4CE93202EC;
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
Subject: [RFC net-next 4/5] net: phy: at803x: implement generic .handle_interrupt() callback
Date:   Sat, 24 Oct 2020 15:14:11 +0300
Message-Id: <20201024121412.10070-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201024121412.10070-1-ioana.ciornei@nxp.com>
References: <20201024121412.10070-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In an attempt to actually support shared IRQs in phylib, we now move the
responsibility of triggering the phylib state machine or just returning
IRQ_NONE, based on the IRQ status register, to the PHY driver. Having
3 different IRQ handling callbacks (.handle_interrupt(),
.did_interrupt() and .ack_interrupt() ) is confusing so let the PHY
driver implement directly an IRQ handler like any other device driver.
Make this driver follow the new convention.

Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Michael Walle <michael@walle.cc>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/at803x.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index ed601a7e46a0..106c6f53755f 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -628,6 +628,24 @@ static int at803x_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+static irqreturn_t at803x_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, AT803X_INTR_STATUS);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (irq_status == 0)
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static void at803x_link_change_notify(struct phy_device *phydev)
 {
 	/*
@@ -1064,6 +1082,7 @@ static struct phy_driver at803x_driver[] = {
 	.read_status		= at803x_read_status,
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
 	.cable_test_start	= at803x_cable_test_start,
@@ -1084,6 +1103,7 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 }, {
 	/* Qualcomm Atheros AR8031/AR8033 */
 	PHY_ID_MATCH_EXACT(ATH8031_PHY_ID),
@@ -1102,6 +1122,7 @@ static struct phy_driver at803x_driver[] = {
 	.aneg_done		= at803x_aneg_done,
 	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
 	.cable_test_start	= at803x_cable_test_start,
@@ -1122,6 +1143,7 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
 }, {
@@ -1134,6 +1156,7 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
 	.read_status		= at803x_read_status,
-- 
2.28.0

