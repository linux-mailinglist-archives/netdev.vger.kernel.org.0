Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D1A17A574
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgCEMml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:42:41 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39976 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgCEMmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:42:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n+kKm6UfXv0DpwWW0p6IJ1ELVGWkUwrvXnojAakv0Og=; b=Zkz/xtNHjuA74ybXxIyG+A7xQp
        Z0jmYVA4nqcHIq/5Wj66nAfrLnpaym9ZVa0ICe1mj7Ffyr0KyceDQj/RXFqezfTornGBVIK+2MkyR
        Bgf8Kr6OqUKaKl00oCj2l5Rqx0XGWtcMdaZz0GBBiDas6nmHtrfxl9ZroDUSxBLpn1lvvSzl2DAgO
        YG82sxU5vpRKQcjWF7o3f4LKvPHN9ZhbvcmQmaqj4Xha2jX4dkeBeAsACKxnoCjfIEMXM7iqrGUKa
        r44av2AnJ0Mezm9t/CoaX30Y+1/pz/+ydoXABMuZTOFcctFk0Ig1My5fUGSVPLM1Zw7/SySpywzzs
        3lFbhG/g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:50622 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9ppb-0006RL-Ps; Thu, 05 Mar 2020 12:42:27 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9ppa-00072F-H6; Thu, 05 Mar 2020 12:42:26 +0000
In-Reply-To: <20200305124139.GB25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 05/10] net: dsa: mv88e6xxx: configure interface
 settings in mac_config
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j9ppa-00072F-H6@rmk-PC.armlinux.org.uk>
Date:   Thu, 05 Mar 2020 12:42:26 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only configure the interface settings in mac_config(), leaving the
speed and duplex settings to mac_link_up to deal with.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 67 +++++++++++++++++---------------
 1 file changed, 35 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 483db9d133c3..3b0643654935 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -397,6 +397,28 @@ static void mv88e6xxx_irq_poll_free(struct mv88e6xxx_chip *chip)
 	mv88e6xxx_reg_unlock(chip);
 }
 
+static int mv88e6xxx_port_config_interface(struct mv88e6xxx_chip *chip,
+					   int port, phy_interface_t interface)
+{
+	int err;
+
+	if (chip->info->ops->port_set_rgmii_delay) {
+		err = chip->info->ops->port_set_rgmii_delay(chip, port,
+							    interface);
+		if (err && err != -EOPNOTSUPP)
+			return err;
+	}
+
+	if (chip->info->ops->port_set_cmode) {
+		err = chip->info->ops->port_set_cmode(chip, port,
+						      interface);
+		if (err && err != -EOPNOTSUPP)
+			return err;
+	}
+
+	return 0;
+}
+
 int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
 			     int speed, int duplex, int pause,
 			     phy_interface_t mode)
@@ -451,19 +473,7 @@ int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
 			goto restore_link;
 	}
 
-	if (chip->info->ops->port_set_rgmii_delay) {
-		err = chip->info->ops->port_set_rgmii_delay(chip, port, mode);
-		if (err && err != -EOPNOTSUPP)
-			goto restore_link;
-	}
-
-	if (chip->info->ops->port_set_cmode) {
-		err = chip->info->ops->port_set_cmode(chip, port, mode);
-		if (err && err != -EOPNOTSUPP)
-			goto restore_link;
-	}
-
-	err = 0;
+	err = mv88e6xxx_port_config_interface(chip, port, mode);
 restore_link:
 	if (chip->info->ops->port_set_link(chip, port, link))
 		dev_err(chip->dev, "p%d: failed to restore MAC's link\n", port);
@@ -603,33 +613,26 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 				 const struct phylink_link_state *state)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	int speed, duplex, link, pause, err;
+	int err;
 
+	/* FIXME: is this the correct test? If we're in fixed mode on an
+	 * internal port, why should we process this any different from
+	 * PHY mode? On the other hand, the port may be automedia between
+	 * an internal PHY and the serdes...
+	 */
 	if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
 		return;
 
-	if (mode == MLO_AN_FIXED) {
-		link = LINK_FORCED_UP;
-		speed = state->speed;
-		duplex = state->duplex;
-	} else if (!mv88e6xxx_phy_is_internal(ds, port)) {
-		link = state->link;
-		speed = state->speed;
-		duplex = state->duplex;
-	} else {
-		speed = SPEED_UNFORCED;
-		duplex = DUPLEX_UNFORCED;
-		link = LINK_UNFORCED;
-	}
-	pause = !!phylink_test(state->advertising, Pause);
-
 	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_port_setup_mac(chip, port, link, speed, duplex, pause,
-				       state->interface);
+	/* FIXME: should we force the link down here - but if we do, how
+	 * do we restore the link force/unforce state? The driver layering
+	 * gets in the way.
+	 */
+	err = mv88e6xxx_port_config_interface(chip, port, state->interface);
 	mv88e6xxx_reg_unlock(chip);
 
 	if (err && err != -EOPNOTSUPP)
-		dev_err(ds->dev, "p%d: failed to configure MAC\n", port);
+		dev_err(ds->dev, "p%d: failed to configure MAC/PCS\n", port);
 }
 
 static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
-- 
2.20.1

