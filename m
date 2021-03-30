Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5796C34E9A9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhC3Nyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbhC3NyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 09:54:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CB9C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 06:54:14 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lREos-0006Q3-3h; Tue, 30 Mar 2021 15:54:10 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lREoq-0004Rb-Ol; Tue, 30 Mar 2021 15:54:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next v1 2/3] net: phy: at803x: AR8085: add loopback support
Date:   Tue, 30 Mar 2021 15:54:06 +0200
Message-Id: <20210330135407.17010-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210330135407.17010-1-o.rempel@pengutronix.de>
References: <20210330135407.17010-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY loopback is needed for the ethernet controller self test support.
This PHY was tested with the FEC sefltest.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/at803x.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index d7799beb811c..8679738cf2ab 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -326,6 +326,30 @@ static int at803x_resume(struct phy_device *phydev)
 	return phy_modify(phydev, MII_BMCR, BMCR_PDOWN | BMCR_ISOLATE, 0);
 }
 
+static int at803x_loopback(struct phy_device *phydev, bool enable)
+{
+	int ret;
+
+	if (enable)
+		ret = phy_clear_bits(phydev, MII_BMCR, BMCR_ANENABLE);
+	else
+		ret = phy_set_bits(phydev, MII_BMCR, BMCR_ANENABLE);
+
+	if (ret)
+		return ret;
+
+	ret = genphy_loopback(phydev, enable);
+
+	/*
+	 * Loop back needs some time to start transmitting packets in the loop.
+	 * Documentation says nothing about it, so I take time which seems to
+	 * work on AR8085.
+	 */
+	msleep(1);
+
+	return ret;
+}
+
 static int at803x_rgmii_reg_set_voltage_sel(struct regulator_dev *rdev,
 					    unsigned int selector)
 {
@@ -1128,6 +1152,7 @@ static struct phy_driver at803x_driver[] = {
 	.get_wol		= at803x_get_wol,
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
+	.set_loopback		= at803x_loopback,
 	/* PHY_GBIT_FEATURES */
 	.read_status		= at803x_read_status,
 	.config_intr		= at803x_config_intr,
-- 
2.29.2

