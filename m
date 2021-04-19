Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5163B364234
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239324AbhDSNCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238428AbhDSNBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:01:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D82EC061763
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 06:01:17 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lYTWa-0003te-VR; Mon, 19 Apr 2021 15:01:12 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lYTWW-0001lm-Vb; Mon, 19 Apr 2021 15:01:08 +0200
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
Subject: [PATCH net-next v3 1/6] net: phy: execute genphy_loopback() per default on all PHYs
Date:   Mon, 19 Apr 2021 15:01:01 +0200
Message-Id: <20210419130106.6707-2-o.rempel@pengutronix.de>
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

The generic loopback is really generic and is defined by the 802.3
standard, we should just mandate that drivers implement a custom
loopback if the generic one cannot work.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy_device.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 73d29fd5e03d..320a3e5cd10a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1777,6 +1777,9 @@ int phy_loopback(struct phy_device *phydev, bool enable)
 	struct phy_driver *phydrv = to_phy_driver(phydev->mdio.dev.driver);
 	int ret = 0;
 
+	if (!phydrv)
+		return -ENODEV;
+
 	mutex_lock(&phydev->lock);
 
 	if (enable && phydev->loopback_enabled) {
@@ -1789,10 +1792,10 @@ int phy_loopback(struct phy_device *phydev, bool enable)
 		goto out;
 	}
 
-	if (phydev->drv && phydrv->set_loopback)
+	if (phydrv->set_loopback)
 		ret = phydrv->set_loopback(phydev, enable);
 	else
-		ret = -EOPNOTSUPP;
+		ret = genphy_loopback(phydev, enable);
 
 	if (ret)
 		goto out;
-- 
2.29.2

