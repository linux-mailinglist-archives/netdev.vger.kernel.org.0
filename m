Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82F246214A
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 21:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351964AbhK2UEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 15:04:02 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48436 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238261AbhK2UCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 15:02:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CDC43CE1407
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 19:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DFCC53FAD;
        Mon, 29 Nov 2021 19:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638215920;
        bh=cmVRqapduWLa1yumZyzJW0WtWufxH0Bx2ni/41EbF40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/cYkK0/Ee9g0E+PYE2L6ZGmdfEbscNOSrbtuloLOYta06h8qT+SJrlK3vdN83TJk
         zcYGX2LChqO+cw2eiw/4hYTjDt86EGQyS27SuiXhvB5aKrEZ8F+Qwc/w48Aoa7XDKG
         R8rnZGD8m2chFY+1ynOqk2drdvabRaZUfbCXgOgTzKWH6+tgSx8lsCoVjI5t26u4es
         AWCL1CwEK2+TlD61vWVWPzMWW+D80Y7LYm+oP1xn9h91MQmEiEYcPJIJkQNud5MbBU
         GJuOULz5QSKiiSB3jCL15970a+gDTilyz4KWraPYqtXXHkOUJBkY9vNQasSrnXT7v3
         dQ/T/6tFYZEcw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 6/6] net: dsa: mv88e6xxx: Link in pcs_get_state() if AN is bypassed
Date:   Mon, 29 Nov 2021 20:58:23 +0100
Message-Id: <20211129195823.11766-7-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211129195823.11766-1-kabel@kernel.org>
References: <20211129195823.11766-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function mv88e6xxx_serdes_pcs_get_state() currently does not report link
up if AN is enabled, Link bit is set, but Speed and Duplex Resolved bit
is not set, which testing shows is the case for when auto-negotiation
was bypassed (we have enabled AN but link partner does not).

An example of such link partner is Marvell 88X3310 PHY, when put into
the mode where host interface changes between 10gbase-r, 5gbase-r,
2500base-x and sgmii according to copper speed. The 88X3310 does not
enable AN in 2500base-x, and so SerDes on mv88e6xxx currently does not
link with it.

Fix this.

Fixes: a5a6858b793f ("net: dsa: mv88e6xxx: extend phylink to Serdes PHYs")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 38 +++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index d297131afe21..a145598905a5 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -50,11 +50,13 @@ static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
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
+		state->an_complete = !!(ctrl & BMCR_ANENABLE);
 		state->duplex = status &
 				MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
 			                         DUPLEX_FULL : DUPLEX_HALF;
@@ -81,6 +83,17 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
 			dev_err(chip->dev, "invalid PHY speed\n");
 			return -EINVAL;
 		}
+	} else if (state->link &&
+		   state->interface != PHY_INTERFACE_MODE_SGMII) {
+		/* The Spped and Duplex Resolved register is always 1 when AN is
+		 * disabled. If it is not set, and link is up, it means that the
+		 * SerDes PHY AN bypass feature was invoked.
+		 */
+		state->duplex = DUPLEX_FULL;
+		if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
+			state->speed = SPEED_2500;
+		else
+			state->speed = SPEED_1000;
 	} else {
 		state->link = false;
 	}
@@ -168,9 +181,15 @@ int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
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
@@ -183,7 +202,7 @@ int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, status, lpa, state);
+	return mv88e6xxx_serdes_pcs_get_state(chip, ctrl, status, lpa, state);
 }
 
 int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
@@ -883,9 +902,16 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
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
@@ -900,7 +926,7 @@ static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, status, lpa, state);
+	return mv88e6xxx_serdes_pcs_get_state(chip, ctrl, status, lpa, state);
 }
 
 static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
-- 
2.32.0

