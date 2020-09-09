Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0FA263275
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbgIIQno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730993AbgIIQMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:12:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5074AC061385
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 06:45:19 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kG0PO-0007FY-Fu; Wed, 09 Sep 2020 15:45:10 +0200
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kG0PI-0000fG-TQ; Wed, 09 Sep 2020 15:45:04 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: [PATCH v3 1/5] net: phy: smsc: skip ENERGYON interrupt if disabled
Date:   Wed,  9 Sep 2020 15:44:57 +0200
Message-Id: <20200909134501.32529-2-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909134501.32529-1-m.felsch@pengutronix.de>
References: <20200909134501.32529-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't enable the interrupt if the platform disable the energy detection
by "smsc,disable-energy-detect".

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v3:
- Add Florian's tag
- use 'if(phydev->interrupts == PHY_INTERRUPT_ENABLED)' instead of
  'if(phydev->interrupts)'

v2:
- Add Andrew's tag

 drivers/net/phy/smsc.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 74568ae16125..16e66505575b 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -37,10 +37,17 @@ struct smsc_phy_priv {
 
 static int smsc_phy_config_intr(struct phy_device *phydev)
 {
-	int rc = phy_write (phydev, MII_LAN83C185_IM,
-			((PHY_INTERRUPT_ENABLED == phydev->interrupts)
-			? MII_LAN83C185_ISF_INT_PHYLIB_EVENTS
-			: 0));
+	struct smsc_phy_priv *priv = phydev->priv;
+	u16 intmask = 0;
+	int rc;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
+		if (priv->energy_enable)
+			intmask |= MII_LAN83C185_ISF_INT7;
+	}
+
+	rc = phy_write(phydev, MII_LAN83C185_IM, intmask);
 
 	return rc < 0 ? rc : 0;
 }
-- 
2.20.1

