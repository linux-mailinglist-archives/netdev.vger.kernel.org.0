Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E029C1856C2
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgCOB3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:29:44 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgCOB3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YO4Xv189fHx9vd4SXY+SLUaP901+UZkXSRafGJJ5T/c=; b=FmyJhGMePIx22PG7ejCnXizBPs
        UlT4ywZN0ZasqfATbViaCFXVn6XLrNVhBXnZMzrn+LLOW+/fXAadtIcxa2JSF6OrIsfd1NKReilO9
        x1zGy5e70J9wMFpVgpjqacfsZ9bmnUci0MhDmymgT5X35FECay5NZGr/0dQyCwVjV0wCOkr6fnRVY
        guKuBfixvaKgvr1FHwW0gUUeBiXh/rsjU60tFOELyvcOPz1e5lJs9uVFdQv10RtIXVFOKdJex3aob
        DPpOtB7NBgINLrM6V67d8V0q0YetQty+cSrxdF+igcuspz0pxdtyY7eOFOS6CQpS9ONjk1JRngKmL
        RfgCZarA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57490 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD3pt-0006CO-Gf; Sat, 14 Mar 2020 10:16:05 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD3pr-0006E5-WE; Sat, 14 Mar 2020 10:16:04 +0000
In-Reply-To: <20200314101431.GF25745@shell.armlinux.org.uk>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 8/8] net: dsa: mv88e6xxx: use PHY_DETECT in
 mac_link_up/mac_link_down
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jD3pr-0006E5-WE@rmk-PC.armlinux.org.uk>
Date:   Sat, 14 Mar 2020 10:16:03 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the status of the PHY_DETECT bit to determine whether we need to
force the MAC settings in mac_link_up() and mac_link_down().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 53 +++++++++++++++++---------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 03bc15a97591..221593261e8f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -464,6 +464,22 @@ static int mv88e6xxx_phy_is_internal(struct dsa_switch *ds, int port)
 	return port < chip->info->num_internal_phys;
 }
 
+static int mv88e6xxx_port_ppu_updates(struct mv88e6xxx_chip *chip, int port)
+{
+	u16 reg;
+	int err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
+	if (err) {
+		dev_err(chip->dev,
+			"p%d: %s: failed to read port status\n",
+			port, __func__);
+		return err;
+	}
+
+	return !!(reg & MV88E6XXX_PORT_STS_PHY_DETECT);
+}
+
 static int mv88e6xxx_serdes_pcs_get_state(struct dsa_switch *ds, int port,
 					  struct phylink_link_state *state)
 {
@@ -692,20 +708,14 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
 
 	ops = chip->info->ops;
 
-	/* Internal PHYs propagate their configuration directly to the MAC.
-	 * External PHYs depend on whether the PPU is enabled for this port.
-	 * FIXME: we should be using the PPU enable state here. What about
-	 * an automedia port?
-	 */
-	if (!mv88e6xxx_phy_is_internal(ds, port) && ops->port_set_link) {
-		mv88e6xxx_reg_lock(chip);
+	mv88e6xxx_reg_lock(chip);
+	if (!mv88e6xxx_port_ppu_updates(chip, port) && ops->port_set_link)
 		err = ops->port_set_link(chip, port, LINK_FORCED_DOWN);
-		mv88e6xxx_reg_unlock(chip);
+	mv88e6xxx_reg_unlock(chip);
 
-		if (err)
-			dev_err(chip->dev,
-				"p%d: failed to force MAC link down\n", port);
-	}
+	if (err)
+		dev_err(chip->dev,
+			"p%d: failed to force MAC link down\n", port);
 }
 
 static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
@@ -720,13 +730,8 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 
 	ops = chip->info->ops;
 
-	/* Internal PHYs propagate their configuration directly to the MAC.
-	 * External PHYs depend on whether the PPU is enabled for this port.
-	 * FIXME: we should be using the PPU enable state here. What about
-	 * an automedia port?
-	 */
-	if (!mv88e6xxx_phy_is_internal(ds, port)) {
-		mv88e6xxx_reg_lock(chip);
+	mv88e6xxx_reg_lock(chip);
+	if (!mv88e6xxx_port_ppu_updates(chip, port)) {
 		/* FIXME: for an automedia port, should we force the link
 		 * down here - what if the link comes up due to "other" media
 		 * while we're bringing the port up, how is the exclusivity
@@ -747,13 +752,13 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 
 		if (ops->port_set_link)
 			err = ops->port_set_link(chip, port, LINK_FORCED_UP);
+	}
 error:
-		mv88e6xxx_reg_unlock(chip);
+	mv88e6xxx_reg_unlock(chip);
 
-		if (err && err != -EOPNOTSUPP)
-			dev_err(ds->dev,
-				"p%d: failed to configure MAC link up\n", port);
-	}
+	if (err && err != -EOPNOTSUPP)
+		dev_err(ds->dev,
+			"p%d: failed to configure MAC link up\n", port);
 }
 
 static int mv88e6xxx_stats_snapshot(struct mv88e6xxx_chip *chip, int port)
-- 
2.20.1

