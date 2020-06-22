Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D358203F37
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbgFVSew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730161AbgFVSew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 14:34:52 -0400
Received: from mail.bugwerft.de (mail.bugwerft.de [IPv6:2a03:6000:1011::59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB25EC061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 11:34:51 -0700 (PDT)
Received: from zenbar.fritz.box (p57bc9787.dip0.t-ipconnect.de [87.188.151.135])
        by mail.bugwerft.de (Postfix) with ESMTPSA id 39A0042B834;
        Mon, 22 Jun 2020 18:34:49 +0000 (UTC)
From:   Daniel Mack <daniel@zonque.org>
To:     netdev@vger.kernel.org
Cc:     vivien.didelot@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@armlinux.org.uk, Daniel Mack <daniel@zonque.org>
Subject: [PATCH] net: dsa: mv88e6xxx: Allow MAC configuration for ports with internal PHY
Date:   Mon, 22 Jun 2020 20:34:43 +0200
Message-Id: <20200622183443.3355240-1-daniel@zonque.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ports with internal PHYs that are not in 'fixed-link' mode are currently
only set up once at startup with a static config. Attempts to change the
link speed or duplex settings are currently prevented by an early bail
in mv88e6xxx_mac_config(). As the default config forces the speed to
1000M, setups with reduced link speed on such ports are unsupported.

Change that, and allow the configuration of all ports with the passed
settings.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
Russell,

This changes the behaviour implemented in c9a2356f35409a ("net:
dsa: mv88e6xxx: add PHYLINK support"). Do you recall why your code
didn't touch the MLO_AN_PHY mode links in the first place?

 drivers/net/dsa/mv88e6xxx/chip.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2f993e673ec74..5452490dbe9d5 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -471,13 +471,6 @@ int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
 	return err;
 }
 
-static int mv88e6xxx_phy_is_internal(struct dsa_switch *ds, int port)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-
-	return port < chip->info->num_internal_phys;
-}
-
 static void mv88e6065_phylink_validate(struct mv88e6xxx_chip *chip, int port,
 				       unsigned long *mask,
 				       struct phylink_link_state *state)
@@ -605,23 +598,24 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int speed, duplex, link, pause, err;
 
-	if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
-		return;
+	speed = state->speed;
+	duplex = state->duplex;
+	pause = !!phylink_test(state->advertising, Pause);
 
-	if (mode == MLO_AN_FIXED) {
-		link = LINK_FORCED_UP;
-		speed = state->speed;
-		duplex = state->duplex;
-	} else if (!mv88e6xxx_phy_is_internal(ds, port)) {
+	switch (mode) {
+	case MLO_AN_PHY:
 		link = state->link;
-		speed = state->speed;
-		duplex = state->duplex;
-	} else {
+		break;
+
+	case MLO_AN_FIXED:
+		link = LINK_FORCED_UP;
+		break;
+
+	default:
 		speed = SPEED_UNFORCED;
 		duplex = DUPLEX_UNFORCED;
 		link = LINK_UNFORCED;
 	}
-	pause = !!phylink_test(state->advertising, Pause);
 
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_setup_mac(chip, port, link, speed, duplex, pause,
-- 
2.26.2

