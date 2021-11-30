Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E542463C6F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244557AbhK3RFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244564AbhK3RFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:05:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AA2C061746
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 09:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2ACFB81A7C
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 17:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4ACC56749;
        Tue, 30 Nov 2021 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638291729;
        bh=ygZ7QpaFmRUlimQTUmY4mnbW76KraKy9PHA6b8sCAYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqURgfDwy9vbGvWQWkVvKhPWTWvchwyIp3+H9FjfQayI8M/gS1owbbaCEhxMftu4z
         Zpjc/WJ3o6p8subXjOZeexAZ7VngqRbJTdR7HE5E7MOL3gSfyJ3EQoOGo+21lUBgrs
         NM4tDXZLaTE9LA3IESPHqpT1yg2rSV/ButHCFH3F6ILDolSLgmsFwECr/5oAgqv1fn
         oGxpuxIWOY4eFSkzlbrD/XL723M63lBupJSycaIkPr/CJgNi01fAUpQq3cPVi30xNS
         9flAKe8T0j4gdovVcKD/K74v1/e6aXcCp4aF8UnGo1aegiVlk1QpxHwpRolPyBn1uw
         /9RmZZcRbsQzg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 6/6] net: dsa: mv88e6xxx: Link in pcs_get_state() if AN is bypassed
Date:   Tue, 30 Nov 2021 18:01:51 +0100
Message-Id: <20211130170151.7741-7-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211130170151.7741-1-kabel@kernel.org>
References: <20211130170151.7741-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function mv88e6xxx_serdes_pcs_get_state() currently does not report link
up if AN is enabled, Link bit is set, but Speed and Duplex Resolved bit
is not set, which testing shows is the case for when auto-negotiation
was bypassed (we have AN enabled but link partner does not).

An example of such link partner is Marvell 88X3310 PHY, when put into
the mode where host interface changes between 10gbase-r, 5gbase-r,
2500base-x and sgmii according to copper speed. The 88X3310 does not
enable AN in 2500base-x, and so SerDes on mv88e6xxx currently does not
link with it.

Fix this.

Fixes: a5a6858b793f ("net: dsa: mv88e6xxx: extend phylink to Serdes PHYs")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 48 ++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 6f60376b932c..55273013bfb5 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -50,11 +50,22 @@ static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
-					  u16 status, u16 lpa,
+					  u16 ctrl, u16 status, u16 lpa,
 					  struct phylink_link_state *state)
 {
+	state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
+
 	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
-		state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
+		/* The Spped and Duplex Resolved register is 1 if AN is enabled
+		 * and complete, or if AN is disabled. So with disabled AN we
+		 * still get here on link up. But we want to set an_complete
+		 * only if AN was enabled, thus we look at BMCR_ANENABLE.
+		 * (According to 802.3-2008 section 22.2.4.2.10, we should be
+		 *  able to get this same value from BMSR_ANEGCAPABLE, but tests
+		 *  show that these Marvell PHYs don't conform to this part of
+		 *  the specificaion - BMSR_ANEGCAPABLE is simply always 1.)
+		 */
+		state->an_complete = !!(ctrl & BMCR_ANENABLE);
 		state->duplex = status &
 				MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
 			                         DUPLEX_FULL : DUPLEX_HALF;
@@ -81,6 +92,18 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
 			dev_err(chip->dev, "invalid PHY speed\n");
 			return -EINVAL;
 		}
+	} else if (state->link &&
+		   state->interface != PHY_INTERFACE_MODE_SGMII) {
+		/* If Speed and Duplex Resolved register is 0 and link is up, it
+		 * means that AN was enabled, but link partner had it disabled
+		 * and the PHY invoked the Auto-Negotiation Bypass feature and
+		 * linked anyway.
+		 */
+		state->duplex = DUPLEX_FULL;
+		if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
+			state->speed = SPEED_2500;
+		else
+			state->speed = SPEED_1000;
 	} else {
 		state->link = false;
 	}
@@ -168,9 +191,15 @@ int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state)
 {
-	u16 lpa, status;
+	u16 lpa, status, ctrl;
 	int err;
 
+	err = mv88e6352_serdes_read(chip, MII_BMCR, &ctrl);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes PHY control: %d\n", err);
+		return err;
+	}
+
 	err = mv88e6352_serdes_read(chip, 0x11, &status);
 	if (err) {
 		dev_err(chip->dev, "can't read Serdes PHY status: %d\n", err);
@@ -183,7 +212,7 @@ int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, status, lpa, state);
+	return mv88e6xxx_serdes_pcs_get_state(chip, ctrl, status, lpa, state);
 }
 
 int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
@@ -883,9 +912,16 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 	int port, int lane, struct phylink_link_state *state)
 {
-	u16 lpa, status;
+	u16 lpa, status, ctrl;
 	int err;
 
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_SGMII_BMCR, &ctrl);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes PHY control: %d\n", err);
+		return err;
+	}
+
 	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
 				    MV88E6390_SGMII_PHY_STATUS, &status);
 	if (err) {
@@ -900,7 +936,7 @@ static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, status, lpa, state);
+	return mv88e6xxx_serdes_pcs_get_state(chip, ctrl, status, lpa, state);
 }
 
 static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
-- 
2.32.0

