Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E87A364238
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239350AbhDSNCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239292AbhDSNBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:01:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB3BC06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 06:01:24 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lYTWa-0003tf-VR; Mon, 19 Apr 2021 15:01:12 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lYTWX-0001lz-0L; Mon, 19 Apr 2021 15:01:09 +0200
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
Subject: [PATCH net-next v3 2/6] net: phy: genphy_loopback: add link speed configuration
Date:   Mon, 19 Apr 2021 15:01:02 +0200
Message-Id: <20210419130106.6707-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210419130106.6707-1-o.rempel@pengutronix.de>
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of loopback, in most cases we need to disable autoneg support
and force some speed configuration. Otherwise, depending on currently
active auto negotiated link speed, the loopback may or may not work.

This patch was tested with following PHYs: TJA1102, KSZ8081, KSZ9031,
AT8035, AR9331.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy.c        |  3 ++-
 drivers/net/phy/phy_device.c | 28 ++++++++++++++++++++++++++--
 include/linux/phy.h          |  1 +
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index fc2e7cb5b2e5..1f0512e39c65 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -701,7 +701,7 @@ int phy_start_cable_test_tdr(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_start_cable_test_tdr);
 
-static int phy_config_aneg(struct phy_device *phydev)
+int phy_config_aneg(struct phy_device *phydev)
 {
 	if (phydev->drv->config_aneg)
 		return phydev->drv->config_aneg(phydev);
@@ -714,6 +714,7 @@ static int phy_config_aneg(struct phy_device *phydev)
 
 	return genphy_config_aneg(phydev);
 }
+EXPORT_SYMBOL(phy_config_aneg);
 
 /**
  * phy_check_link_status - check link status and set state accordingly
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 320a3e5cd10a..0a2d8bedf73d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2565,8 +2565,32 @@ EXPORT_SYMBOL(genphy_resume);
 
 int genphy_loopback(struct phy_device *phydev, bool enable)
 {
-	return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
-			  enable ? BMCR_LOOPBACK : 0);
+	if (enable) {
+		u16 val, ctl = BMCR_LOOPBACK;
+		int ret;
+
+		if (phydev->speed == SPEED_1000)
+			ctl |= BMCR_SPEED1000;
+		else if (phydev->speed == SPEED_100)
+			ctl |= BMCR_SPEED100;
+
+		if (phydev->duplex == DUPLEX_FULL)
+			ctl |= BMCR_FULLDPLX;
+
+		phy_modify(phydev, MII_BMCR, ~0, ctl);
+
+		ret = phy_read_poll_timeout(phydev, MII_BMSR, val,
+					    val & BMSR_LSTATUS,
+				    5000, 500000, true);
+		if (ret)
+			return ret;
+	} else {
+		phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
+
+		phy_config_aneg(phydev);
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL(genphy_loopback);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 98fb441dd72e..98e351bb0964 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1410,6 +1410,7 @@ void phy_disconnect(struct phy_device *phydev);
 void phy_detach(struct phy_device *phydev);
 void phy_start(struct phy_device *phydev);
 void phy_stop(struct phy_device *phydev);
+int phy_config_aneg(struct phy_device *phydev);
 int phy_start_aneg(struct phy_device *phydev);
 int phy_aneg_done(struct phy_device *phydev);
 int phy_speed_down(struct phy_device *phydev, bool sync);
-- 
2.29.2

