Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CB12611F7
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 15:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgIHNTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 09:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729876AbgIHLZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 07:25:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F98C061757
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 04:25:33 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFbka-0006xL-CB; Tue, 08 Sep 2020 13:25:24 +0200
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFbkW-0001jL-RN; Tue, 08 Sep 2020 13:25:20 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: [PATCH v2 2/5] net: phy: smsc: simplify config_init callback
Date:   Tue,  8 Sep 2020 13:25:17 +0200
Message-Id: <20200908112520.3439-3-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200908112520.3439-1-m.felsch@pengutronix.de>
References: <20200908112520.3439-1-m.felsch@pengutronix.de>
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

Exit the driver specific config_init hook early if energy detection is
disabled. We can do this because we don't need to clear the interrupt
status here. Clearing the status should be removed anyway since this is
handled by the phy_enable_interrupts().

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
v2:
- no change

 drivers/net/phy/smsc.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index fa539a867de6..79574fcbd880 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -62,19 +62,21 @@ static int smsc_phy_ack_interrupt(struct phy_device *phydev)
 static int smsc_phy_config_init(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
+	int rc;
+
+	if (!priv->energy_enable)
+		return 0;
 
-	int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
+	rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
 
 	if (rc < 0)
 		return rc;
 
-	if (priv->energy_enable) {
-		/* Enable energy detect mode for this SMSC Transceivers */
-		rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
-			       rc | MII_LAN83C185_EDPWRDOWN);
-		if (rc < 0)
-			return rc;
-	}
+	/* Enable energy detect mode for this SMSC Transceivers */
+	rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
+		       rc | MII_LAN83C185_EDPWRDOWN);
+	if (rc < 0)
+		return rc;
 
 	return smsc_phy_ack_interrupt(phydev);
 }
-- 
2.20.1

