Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057583B52CA
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 12:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhF0KSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 06:18:34 -0400
Received: from perseus.uberspace.de ([95.143.172.134]:39776 "EHLO
        perseus.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhF0KSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 06:18:30 -0400
Received: (qmail 29836 invoked from network); 27 Jun 2021 10:16:04 -0000
Received: from localhost (HELO localhost) (127.0.0.1)
  by perseus.uberspace.de with SMTP; 27 Jun 2021 10:16:04 -0000
From:   David Bauer <mail@david-bauer.net>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: phy: at803x: mask 1000 Base-X link mode
Date:   Sun, 27 Jun 2021 12:16:07 +0200
Message-Id: <20210627101607.79604-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AR8031/AR8033 have different status registers for copper
and fiber operation. However, the extended status register
is the same for both operation modes.

As a result of that, ESTATUS_1000_XFULL is set to 1 even when
operating in copper TP mode.

Remove this mode from the supported link modes, as this driver
currently only supports copper operation.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 drivers/net/phy/at803x.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 32af52dd5aed..d797c2c9ae3f 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -610,6 +610,34 @@ static void at803x_remove(struct phy_device *phydev)
 		regulator_disable(priv->vddio);
 }
 
+static int at803x_get_features(struct phy_device *phydev)
+{
+	int err;
+
+	err = genphy_read_abilities(phydev);
+	if (err)
+		return err;
+
+	if (!at803x_match_phy_id(phydev, ATH8031_PHY_ID))
+		return 0;
+
+	/* AR8031/AR8033 have different status registers
+	 * for copper and fiber operation. However, the
+	 * extended status register is the same for both
+	 * operation modes.
+	 *
+	 * As a result of that, ESTATUS_1000_XFULL is set
+	 * to 1 even when operating in copper TP mode.
+	 *
+	 * Remove this mode from the supported link modes,
+	 * as this driver currently only supports copper
+	 * operation.
+	 */
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+			   phydev->supported);
+	return 0;
+}
+
 static int at803x_smarteee_config(struct phy_device *phydev)
 {
 	struct at803x_priv *priv = phydev->priv;
@@ -1225,7 +1253,7 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= at803x_resume,
 	.read_page		= at803x_read_page,
 	.write_page		= at803x_write_page,
-	/* PHY_GBIT_FEATURES */
+	.get_features		= at803x_get_features,
 	.read_status		= at803x_read_status,
 	.config_intr		= &at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
-- 
2.32.0

