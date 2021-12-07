Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A66246B934
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhLGKgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhLGKgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:36:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E03C061746
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 02:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IqdQ4JP3leIVHmOLMYIh3Tg0CREuovVWZSJL6ac6s5g=; b=RLioOIvIVqw/XwvqjiRKUyVVFt
        wVDw95RdhIeZKM8Z7dvFGW1GAQF1e/gkWaqiN04siJrewIjEL17jAvj9+96Pp5IELdg8da7G5XKez
        YAxE96FhZItjAR8VEz/cC0K4bIJRv2Qh7VzSWF0RftgspB8KCz/bL+CQoiC+43fB+Tlfb0uHZAd8y
        XX8T+9Ul9z6S1WvjmcjJ3vRfgv+QiWFQEdqo0mkGd10H4et6nnSi2RVqiqWszxXar+hWPnho2MhXq
        YAXxCaWJ9ZM7azWypZK3GkxKQlNd/Iud9ljpiNwfvKyTMX2MJ/78u+Xyr9Bz1AATKrfXHATQ3qJUa
        Q1xL4Puw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54590 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1muXm7-00062A-LF; Tue, 07 Dec 2021 10:32:43 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1muXm7-00EwJB-7n; Tue, 07 Dec 2021 10:32:43 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Maarten Zanders <maarten.zanders@mind.be>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org
Subject: [PATCH net] net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on
 internal PHY's"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1muXm7-00EwJB-7n@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 07 Dec 2021 10:32:43 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes a misunderstanding in commit 4a3e0aeddf09 ("net: dsa:
mv88e6xxx: don't use PHY_DETECT on internal PHY's").

For Marvell DSA switches with the PHY_DETECT bit (for non-6250 family
devices), controls whether the PPU polls the PHY to retrieve the link,
speed, duplex and pause status to update the port configuration. This
applies for both internal and external PHYs.

For some switches such as 88E6352 and 88E6390X, PHY_DETECT has an
additional function of enabling auto-media mode between the internal
PHY and SERDES blocks depending on which first gains link.

The original intention of commit 5d5b231da7ac (net: dsa: mv88e6xxx: use
PHY_DETECT in mac_link_up/mac_link_down) was to allow this bit to be
used to detect when this propagation is enabled, and allow software to
update the port configuration. This has found to be necessary for some
switches which do not automatically propagate status from the SERDES to
the port, which includes the 88E6390. However, commit 4a3e0aeddf09
("net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's") breaks
this assumption.

Maarten Zanders has confirmed that the issue he was addressing was for
an 88E6250 switch, which does not have a PHY_DETECT bit in bit 12, but
instead a link status bit. Therefore, mv88e6xxx_port_ppu_updates() does
not report correctly.

This patch resolves the above issues by reverting Maarten's change and
instead making mv88e6xxx_port_ppu_updates() indicate whether the port
is internal for the 88E6250 family of switches.

  Yes, you're right, I'm targeting the 6250 family. And yes, your
  suggestion would solve my case and is a better implementation for
  the other devices (as far as I can see).

Fixes: 4a3e0aeddf09 ("net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f00cbf5753b9..9f675464efc3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -471,6 +471,12 @@ static int mv88e6xxx_port_ppu_updates(struct mv88e6xxx_chip *chip, int port)
 	u16 reg;
 	int err;
 
+	/* The 88e6250 family does not have the PHY detect bit. Instead,
+	 * report whether the port is internal.
+	 */
+	if (chip->info->family == MV88E6XXX_FAMILY_6250)
+		return port < chip->info->num_internal_phys;
+
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
 	if (err) {
 		dev_err(chip->dev,
@@ -752,11 +758,10 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	/* Internal PHYs propagate their configuration directly to the MAC.
-	 * External PHYs depend on whether the PPU is enabled for this port.
+	/* Force the link down if we know the port may not be automatically
+	 * updated by the switch or if we are using fixed-link mode.
 	 */
-	if (((!mv88e6xxx_phy_is_internal(ds, port) &&
-	      !mv88e6xxx_port_ppu_updates(chip, port)) ||
+	if ((!mv88e6xxx_port_ppu_updates(chip, port) ||
 	     mode == MLO_AN_FIXED) && ops->port_sync_link)
 		err = ops->port_sync_link(chip, port, mode, false);
 	mv88e6xxx_reg_unlock(chip);
@@ -779,11 +784,11 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	/* Internal PHYs propagate their configuration directly to the MAC.
-	 * External PHYs depend on whether the PPU is enabled for this port.
+	/* Configure and force the link up if we know that the port may not
+	 * automatically updated by the switch or if we are using fixed-link
+	 * mode.
 	 */
-	if ((!mv88e6xxx_phy_is_internal(ds, port) &&
-	     !mv88e6xxx_port_ppu_updates(chip, port)) ||
+	if (!mv88e6xxx_port_ppu_updates(chip, port) ||
 	    mode == MLO_AN_FIXED) {
 		/* FIXME: for an automedia port, should we force the link
 		 * down here - what if the link comes up due to "other" media
-- 
2.30.2

