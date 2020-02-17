Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EC21616BE
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgBQPy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:54:27 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38422 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729403AbgBQPy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LQarTYV18UzVX2wCRcWT/h3phGOIWvEnqnwzX1jjCdw=; b=Un+Syet2vdCU494prOEQ2Ugsw2
        6jbWutzKMrWCOygGOezvSEJ3nxXD5FDcjQqXNTZ9yYlXg27PhJav0sfVjK4qubKzKvnT5WDxnS/2T
        5NATQzq2obmprvxMi/LiREVekKQTM5wnIQ9XFrQwfzw4DIxO29ajGM1cDmDTU5clkvAGTfnUJiI3x
        /vgKah4a9YSnWYqsxt8LegAgg1os37ssSpr4BnItJ9KhSEuMI5QXWAXkxf6AHoTFyu9WIqtihGGHh
        CDAYbGeoeMYV0g2zcyduxor23DwhbrrTcOHZqZW6ATAHPA7safTs1p+UB0l1yI7Jnvpvp6S1okeVU
        v/GyBEVw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:52474 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j3iiy-0001hm-TL; Mon, 17 Feb 2020 15:54:20 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j3iix-0006EK-G1; Mon, 17 Feb 2020 15:54:19 +0000
In-Reply-To: <20200217155346.GW25745@shell.armlinux.org.uk>
References: <20200217155346.GW25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: phy: marvell10g: read copper results from
 CSSR1
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j3iix-0006EK-G1@rmk-PC.armlinux.org.uk>
Date:   Mon, 17 Feb 2020 15:54:19 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Read the copper autonegotiation results from the copper specific
status register, rather than decoding the advertisements. Reading
what the link is actually doing will allow us to support downshift
modes.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 141 ++++++++++++++++++++++-------------
 1 file changed, 89 insertions(+), 52 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 64c9f3bba2cd..9a4e12a2af07 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -39,10 +39,19 @@ enum {
 	MV_PCS_BASE_R		= 0x1000,
 	MV_PCS_1000BASEX	= 0x2000,
 
-	MV_PCS_PAIRSWAP		= 0x8182,
-	MV_PCS_PAIRSWAP_MASK	= 0x0003,
-	MV_PCS_PAIRSWAP_AB	= 0x0002,
-	MV_PCS_PAIRSWAP_NONE	= 0x0003,
+	MV_PCS_CSSR1		= 0x8008,
+	MV_PCS_CSSR1_SPD1_MASK	= 0xc000,
+	MV_PCS_CSSR1_SPD1_SPD2	= 0xc000,
+	MV_PCS_CSSR1_SPD1_1000	= 0x8000,
+	MV_PCS_CSSR1_SPD1_100	= 0x4000,
+	MV_PCS_CSSR1_SPD1_10	= 0x0000,
+	MV_PCS_CSSR1_DUPLEX_FULL= BIT(13),
+	MV_PCS_CSSR1_RESOLVED	= BIT(11),
+	MV_PCS_CSSR1_MDIX	= BIT(6),
+	MV_PCS_CSSR1_SPD2_MASK	= 0x000c,
+	MV_PCS_CSSR1_SPD2_5000	= 0x0008,
+	MV_PCS_CSSR1_SPD2_2500	= 0x0004,
+	MV_PCS_CSSR1_SPD2_10000	= 0x0000,
 
 	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
 	 * registers appear to set themselves to the 0x800X when AN is
@@ -413,35 +422,18 @@ static void mv3310_update_interface(struct phy_device *phydev)
 }
 
 /* 10GBASE-ER,LR,LRM,SR do not support autonegotiation. */
-static int mv3310_read_10gbr_status(struct phy_device *phydev)
+static int mv3310_read_status_10gbaser(struct phy_device *phydev)
 {
 	phydev->link = 1;
 	phydev->speed = SPEED_10000;
 	phydev->duplex = DUPLEX_FULL;
 
-	mv3310_update_interface(phydev);
-
 	return 0;
 }
 
-static int mv3310_read_status(struct phy_device *phydev)
+static int mv3310_read_status_copper(struct phy_device *phydev)
 {
-	int val;
-
-	phydev->speed = SPEED_UNKNOWN;
-	phydev->duplex = DUPLEX_UNKNOWN;
-	linkmode_zero(phydev->lp_advertising);
-	phydev->link = 0;
-	phydev->pause = 0;
-	phydev->asym_pause = 0;
-	phydev->mdix = 0;
-
-	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_BASE_R + MDIO_STAT1);
-	if (val < 0)
-		return val;
-
-	if (val & MDIO_STAT1_LSTATUS)
-		return mv3310_read_10gbr_status(phydev);
+	int cssr1, speed, val;
 
 	val = genphy_c45_read_link(phydev);
 	if (val < 0)
@@ -451,6 +443,52 @@ static int mv3310_read_status(struct phy_device *phydev)
 	if (val < 0)
 		return val;
 
+	cssr1 = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_CSSR1);
+	if (cssr1 < 0)
+		return val;
+
+	/* If the link settings are not resolved, mark the link down */
+	if (!(cssr1 & MV_PCS_CSSR1_RESOLVED)) {
+		phydev->link = 0;
+		return 0;
+	}
+
+	/* Read the copper link settings */
+	speed = cssr1 & MV_PCS_CSSR1_SPD1_MASK;
+	if (speed == MV_PCS_CSSR1_SPD1_SPD2)
+		speed |= cssr1 & MV_PCS_CSSR1_SPD2_MASK;
+
+	switch (speed) {
+	case MV_PCS_CSSR1_SPD1_SPD2 | MV_PCS_CSSR1_SPD2_10000:
+		phydev->speed = SPEED_10000;
+		break;
+
+	case MV_PCS_CSSR1_SPD1_SPD2 | MV_PCS_CSSR1_SPD2_5000:
+		phydev->speed = SPEED_5000;
+		break;
+
+	case MV_PCS_CSSR1_SPD1_SPD2 | MV_PCS_CSSR1_SPD2_2500:
+		phydev->speed = SPEED_2500;
+		break;
+
+	case MV_PCS_CSSR1_SPD1_1000:
+		phydev->speed = SPEED_1000;
+		break;
+
+	case MV_PCS_CSSR1_SPD1_100:
+		phydev->speed = SPEED_100;
+		break;
+
+	case MV_PCS_CSSR1_SPD1_10:
+		phydev->speed = SPEED_10;
+		break;
+	}
+
+	phydev->duplex = cssr1 & MV_PCS_CSSR1_DUPLEX_FULL ?
+			 DUPLEX_FULL : DUPLEX_HALF;
+	phydev->mdix = cssr1 & MV_PCS_CSSR1_MDIX ?
+		       ETH_TP_MDI_X : ETH_TP_MDI;
+
 	if (val & MDIO_AN_STAT1_COMPLETE) {
 		val = genphy_c45_read_lpa(phydev);
 		if (val < 0)
@@ -463,39 +501,38 @@ static int mv3310_read_status(struct phy_device *phydev)
 
 		mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising, val);
 
-		if (phydev->autoneg == AUTONEG_ENABLE)
-			phy_resolve_aneg_linkmode(phydev);
+		/* Update the pause status */
+		phy_resolve_aneg_pause(phydev);
 	}
 
-	if (phydev->autoneg != AUTONEG_ENABLE) {
-		val = genphy_c45_read_pma(phydev);
-		if (val < 0)
-			return val;
-	}
+	return 0;
+}
 
-	if (phydev->speed == SPEED_10000) {
-		val = genphy_c45_read_mdix(phydev);
-		if (val < 0)
-			return val;
-	} else {
-		val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_PAIRSWAP);
-		if (val < 0)
-			return val;
+static int mv3310_read_status(struct phy_device *phydev)
+{
+	int err, val;
 
-		switch (val & MV_PCS_PAIRSWAP_MASK) {
-		case MV_PCS_PAIRSWAP_AB:
-			phydev->mdix = ETH_TP_MDI_X;
-			break;
-		case MV_PCS_PAIRSWAP_NONE:
-			phydev->mdix = ETH_TP_MDI;
-			break;
-		default:
-			phydev->mdix = ETH_TP_MDI_INVALID;
-			break;
-		}
-	}
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	linkmode_zero(phydev->lp_advertising);
+	phydev->link = 0;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+	phydev->mdix = ETH_TP_MDI_INVALID;
 
-	mv3310_update_interface(phydev);
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_BASE_R + MDIO_STAT1);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_STAT1_LSTATUS)
+		err = mv3310_read_status_10gbaser(phydev);
+	else
+		err = mv3310_read_status_copper(phydev);
+	if (err < 0)
+		return err;
+
+	if (phydev->link)
+		mv3310_update_interface(phydev);
 
 	return 0;
 }
-- 
2.20.1

