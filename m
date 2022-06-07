Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C833553FD7A
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241694AbiFGL2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238390AbiFGL2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:28:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40BE9A9A8
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 04:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PnifGKrEGjkS4qN0Qr1yGM5EHc6ud7S9i0hFtHvmjr4=; b=g6gR2edA+Gm65lmuZBYNfwsTsc
        0S4pCQub4LmCicp2OMNBMp5kPjNWT7LuGNKWmiM/mozrPojyPTWlBIBUbFPBMezcb+VjUfNJAZLjA
        QCYYs8sZWBbAAVDhYWNwwUfTo6TV865hU72o7nOm5edV8QHEJ9IhaLx0nMZgOgWRpvqQ2a8RDlNWJ
        jI5TdKgt7S1eUybD/2ZeLnLyZ91k5wwoc7t7IwiS+lppr2CYBVH2iSv2O4g2FtUmSU5zpSE/roTxF
        4qvUBbuSytyyic+8K1/r0siys3JXJ1ZFq5pgWPrlyCn68nY5xTAts84EG5P2tgCGkWjzkkD17OuAE
        3JIIOfkQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54758 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nyXO7-0003Jy-7q; Tue, 07 Jun 2022 12:28:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nyXO6-00GPyL-Jf; Tue, 07 Jun 2022 12:28:42 +0100
In-Reply-To: <Yp82TyoLon9jz6k3@shell.armlinux.org.uk>
References: <Yp82TyoLon9jz6k3@shell.armlinux.org.uk>
From:   Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Marek Beh__n" <kabel@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net 1/3] net: dsa: mv88e6xxx: use BMSR_ANEGCOMPLETE bit for
 filling an_complete
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nyXO6-00GPyL-Jf@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 07 Jun 2022 12:28:42 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>

Commit ede359d8843a ("net: dsa: mv88e6xxx: Link in pcs_get_state() if AN
is bypassed") added the ability to link if AN was bypassed, and added
filling of state->an_complete field, but set it to true if AN was
enabled in BMCR, not when AN was reported complete in BMSR.

This was done because for some reason, when I wanted to use BMSR value
to infer an_complete, I was looking at BMSR_ANEGCAPABLE bit (which was
always 1), instead of BMSR_ANEGCOMPLETE bit.

Use BMSR_ANEGCOMPLETE for filling state->an_complete.

Fixes: ede359d8843a ("net: dsa: mv88e6xxx: Link in pcs_get_state() if AN is bypassed")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 7b37d45bc9fb..1a19c5284f2c 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -50,22 +50,17 @@ static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
-					  u16 ctrl, u16 status, u16 lpa,
+					  u16 bmsr, u16 lpa, u16 status,
 					  struct phylink_link_state *state)
 {
 	state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
+	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
 
 	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
 		/* The Spped and Duplex Resolved register is 1 if AN is enabled
 		 * and complete, or if AN is disabled. So with disabled AN we
-		 * still get here on link up. But we want to set an_complete
-		 * only if AN was enabled, thus we look at BMCR_ANENABLE.
-		 * (According to 802.3-2008 section 22.2.4.2.10, we should be
-		 *  able to get this same value from BMSR_ANEGCAPABLE, but tests
-		 *  show that these Marvell PHYs don't conform to this part of
-		 *  the specificaion - BMSR_ANEGCAPABLE is simply always 1.)
+		 * still get here on link up.
 		 */
-		state->an_complete = !!(ctrl & BMCR_ANENABLE);
 		state->duplex = status &
 				MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
 			                         DUPLEX_FULL : DUPLEX_HALF;
@@ -191,12 +186,12 @@ int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state)
 {
-	u16 lpa, status, ctrl;
+	u16 bmsr, lpa, status;
 	int err;
 
-	err = mv88e6352_serdes_read(chip, MII_BMCR, &ctrl);
+	err = mv88e6352_serdes_read(chip, MII_BMSR, &bmsr);
 	if (err) {
-		dev_err(chip->dev, "can't read Serdes PHY control: %d\n", err);
+		dev_err(chip->dev, "can't read Serdes BMSR: %d\n", err);
 		return err;
 	}
 
@@ -212,7 +207,7 @@ int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, ctrl, status, lpa, state);
+	return mv88e6xxx_serdes_pcs_get_state(chip, bmsr, lpa, status, state);
 }
 
 int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
@@ -918,13 +913,13 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 	int port, int lane, struct phylink_link_state *state)
 {
-	u16 lpa, status, ctrl;
+	u16 bmsr, lpa, status;
 	int err;
 
 	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_BMCR, &ctrl);
+				    MV88E6390_SGMII_BMSR, &bmsr);
 	if (err) {
-		dev_err(chip->dev, "can't read Serdes PHY control: %d\n", err);
+		dev_err(chip->dev, "can't read Serdes PHY BMSR: %d\n", err);
 		return err;
 	}
 
@@ -942,7 +937,7 @@ static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, ctrl, status, lpa, state);
+	return mv88e6xxx_serdes_pcs_get_state(chip, bmsr, lpa, status, state);
 }
 
 static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
-- 
2.30.2

