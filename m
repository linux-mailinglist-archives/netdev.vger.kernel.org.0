Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2309F257AC9
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 15:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgHaNs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 09:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgHaNsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 09:48:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052EDC061236
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 06:48:53 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kCkAw-0000Le-Id; Mon, 31 Aug 2020 15:48:46 +0200
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kCkAr-0005H7-2t; Mon, 31 Aug 2020 15:48:41 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 1/5] net: phy: smsc: skip ENERGYON interrupt if disabled
Date:   Mon, 31 Aug 2020 15:48:32 +0200
Message-Id: <20200831134836.20189-2-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200831134836.20189-1-m.felsch@pengutronix.de>
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
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
---
 drivers/net/phy/smsc.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 74568ae16125..fa539a867de6 100644
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
+	if (phydev->interrupts) {
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

