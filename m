Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E8317A581
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgCEMnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:43:12 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40036 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbgCEMnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:43:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0ByaeURdveybTpS3QkBmzqigwKpT/KhBk9VYepIopw8=; b=ONXKbh8cZrrVVVOTXMd46HSvBl
        GEo+IbsWy8X96/QNMHL/lHrn9acdpHd0Hdm70kVUk16H2OYtqLH+MZO1ScEjPPhVjPtGfedNi+KEd
        E5/1zrWOAHcUISNn/MCGVdh2uzquOhQfiTiAsLUwqNfqmZar5cIeDi/MjqnxXSq550qyZ/hsaYWsS
        Cqz3CJVTlhPPyQuOj+axvPRt/LnM9nab97I1KMOnqACHYJo6ZAODLYhP0PclR4NUf5EzCr7YQHj/f
        onBSFgWw+oDXH6nHg/S5FSeJDPrzPD3IjqPbXrSyN98J+IU6F/HCNvFDHmvC7cdZZ4nGxCjo45yu+
        EEmMEdEA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58768 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9pq2-0006SF-9W; Thu, 05 Mar 2020 12:42:54 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9pq0-00072r-5H; Thu, 05 Mar 2020 12:42:52 +0000
In-Reply-To: <20200305124139.GB25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 10/10] net: dsa: mv88e6xxx: use PHY_DETECT in
 mac_link_up/mac_link_down
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j9pq0-00072r-5H@rmk-PC.armlinux.org.uk>
Date:   Thu, 05 Mar 2020 12:42:52 +0000
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
index bdde20059c81..441865c27c28 100644
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

