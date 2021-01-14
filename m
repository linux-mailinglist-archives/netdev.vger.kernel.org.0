Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8F72F5893
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbhANClz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:41:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbhANClq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 21:41:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0F6723406;
        Thu, 14 Jan 2021 02:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610592065;
        bh=Y50oEmR3jXSGSBKVL7V5sEGWPK8s2Fa7mR13tRQ5xW0=;
        h=From:To:Cc:Subject:Date:From;
        b=tfz9ZAM2Dtbb3V+8H9wjqpaMa8gj2T7BAvRW1vYSXA7Jt2AWFFXBswqo92V+6Gv5H
         EUQkz3YOOZzS+nQFYcuC1PEEGQfFhvwAXtTCEfnTFtQHE/ot/0B1HjR0CmElSLZ0GQ
         qcfAJlijfq3HK0s6SkoCqlDGyIXTs00ifuj1r99e/2a9Occ4h6dp+c42IrLxo3YL+6
         HARBjNWXDtt3VDhmouWwHT/MZSAUcEBEWkvpG2DL5bYS3dGcdLlMi1KtpAvCH4b0wg
         y6XefBoDxaReBKNHn/rW9yrDIf5rI4oA4Ka8uoqsSRdYiBVfPhcpyEd6vaTCwop5Rl
         lkgNsVyV+DPDA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net] net: dsa: mv88e6xxx: do not allow inband AN for 2500base-x mode
Date:   Thu, 14 Jan 2021 03:40:55 +0100
Message-Id: <20210114024055.17602-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a5a6858b793ff ("net: dsa: mv88e6xxx: extend phylink to Serdes
PHYs") introduced method mv88e6390_serdes_pcs_config(), which is called
(indirectly) by phylink to configure the PCS.

This method enables inband AN if requested by phylink.

It seems though that for 2500base-x mode some of these switches (at
least Amethyst) do not support inband AN on Serdes.

Moreover the above mentioned commit causes a regression when the Serdes
of the switch is connected to a Marvell 88X3310 PHY in 2500base-x mode,
because this PHY does not enable inband AN when it self-switches to
2500base-x (nor does it seem to work if manually enabling AN by writing
the register), and it seems that 88E6390 devices won't link on
2500base-x mode if AN is enabled on the switch and disabled on the peer.

Since it seems that 2500base-x mode has no definitive documentation of
what exactly it is, and that Marvell devices disable inband AN when
switching to this mode, this patch disables inband AN when configuring
for 2500base-x in the mv88e6390_serdes_pcs_config() function and prints
a warning if such mode is requested. mv88e6xxx_serdes_pcs_get_state is
edited accordingly.

We may need to refactor phylink code to not request inband AN for
2500base-x at all, but until then we need at least to fix this
regression.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: a5a6858b793ff ("net: dsa: mv88e6xxx: extend phylink to Serdes PHYs")
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 3195936dc5be..b8241820679e 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -55,9 +55,20 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
 {
 	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
 		state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
+
+		if (state->interface == PHY_INTERFACE_MODE_2500BASEX) {
+			if (state->link) {
+				state->speed = SPEED_2500;
+				state->duplex = DUPLEX_FULL;
+			}
+
+			return 0;
+		}
+
+		state->an_complete = 1;
 		state->duplex = status &
 				MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
-			                         DUPLEX_FULL : DUPLEX_HALF;
+						DUPLEX_FULL : DUPLEX_HALF;
 
 		if (status & MV88E6390_SGMII_PHY_STATUS_TX_PAUSE)
 			state->pause |= MLO_PAUSE_TX;
@@ -66,10 +77,7 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
 
 		switch (status & MV88E6390_SGMII_PHY_STATUS_SPEED_MASK) {
 		case MV88E6390_SGMII_PHY_STATUS_SPEED_1000:
-			if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
-				state->speed = SPEED_2500;
-			else
-				state->speed = SPEED_1000;
+			state->speed = SPEED_1000;
 			break;
 		case MV88E6390_SGMII_PHY_STATUS_SPEED_100:
 			state->speed = SPEED_100;
@@ -85,10 +93,7 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
 		state->link = false;
 	}
 
-	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
-		mii_lpa_mod_linkmode_x(state->lp_advertising, lpa,
-				       ETHTOOL_LINK_MODE_2500baseX_Full_BIT);
-	else if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
+	if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
 		mii_lpa_mod_linkmode_x(state->lp_advertising, lpa,
 				       ETHTOOL_LINK_MODE_1000baseX_Full_BIT);
 
@@ -820,9 +825,10 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 		break;
 
 	case PHY_INTERFACE_MODE_2500BASEX:
-		adv = linkmode_adv_to_mii_adv_x(advertise,
-					ETHTOOL_LINK_MODE_2500baseX_Full_BIT);
-		break;
+		if (phylink_autoneg_inband(mode))
+			dev_warn(chip->dev,
+				 "inband AN unsupported on 2500base-x mode\n");
+		return 0;
 
 	default:
 		return 0;

base-commit: f50e2f9f791647aa4e5b19d0064f5cabf630bf6e
-- 
2.26.2

