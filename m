Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDFD191A43
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgCXTqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:46:55 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45270 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgCXTqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:46:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=u0QahqTPUWO9zGbNC8yPFhrOi9Je0UEQV6GtMdFSvBQ=; b=HTxdx4W+vl2zOyFTj/eDijp/u
        qZ0BBcH9GPhIQ49FImh36pgfofUGkemDo23HyEO3BMfHLcW5TsCW/8180NJM66ZKs6/yxR9u3eTaQ
        HZrO04t8F9t4QPWApFGHA1JQE9I0jVOaV7F8d0I1WxeV7Y3SJI/mCQKf8bvaPLFWhzbPkz+SnM7Et
        wSmJsaI5E7Ugzn/esMR/g2FhfoGUoVBmtstzqfee0RqjJIu6UvHUVTcCDGjWivts3R8t9Y8Dvy6OF
        UFb27o/Lnu6oDCc7BvNVsZ/4f2brBGHtPmmCDBu/i9hTUHPS104lZaLwd8nx3OI6BziAnEQIoI4BM
        0LfPhQWCg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40862)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jGpVd-0001VJ-5R; Tue, 24 Mar 2020 19:46:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jGpVa-0001Wk-AB; Tue, 24 Mar 2020 19:46:42 +0000
Date:   Tue, 24 Mar 2020 19:46:42 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Message-ID: <20200324194642.GY25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
 <20200317163802.GZ24270@lunn.ch>
 <20200317165422.GU25745@shell.armlinux.org.uk>
 <20200319121418.GJ5827@shell.armlinux.org.uk>
 <20200319150652.GA27807@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2FkSFaIQeDFoAt0B"
Content-Disposition: inline
In-Reply-To: <20200319150652.GA27807@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2FkSFaIQeDFoAt0B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 19, 2020 at 04:06:52PM +0100, Andrew Lunn wrote:
> > Oh, I forgot to mention on the library point - that's what has already
> > been created in:
> > 
> > "net: phylink: pcs: add 802.3 clause 45 helpers"
> > "net: phylink: pcs: add 802.3 clause 22 helpers"
> > 
> > which add library implementations for the pcs_get_state(), pcs_config()
> > and pcs_an_restart() methods.
> > 
> > What remains is vendor specific - for pcs_link_up(), there is no
> > standard, since it requires fiddling with vendor specific registers to
> > program, e.g. the speed in SGMII mode when in-band is not being used.
> > The selection between different PCS is also vendor specific.
> > 
> > It would have been nice to use these helpers for Marvell DSA switches
> > too, but the complexities of DSA taking a multi-layered approach rather
> > than a library approach, plus the use of paging makes it very
> > difficult.
> > 
> > So, basically on the library point, "already considered and
> > implemented".
> 
> Hi Russell
> 
> The 6390X family of switches has two PCSs, one for 1000BaseX/SGMII and
> a second one for 10GBaseR. So at some point there is going to be a
> mux, but maybe it will be internal to mv88e6xxx and not shareable. Or
> internal to DSA, and shareable between DSA drivers. We will see.

This is what I came up with, but I'm not really able to test it with
my ZII platforms. See the attached patch and the patch below. I
haven't polished them yet - been a little otherwise occupied as I'm
sure you can imagine given the situation.

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 8cef46ee1d2f..59bd3f447386 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -631,8 +631,8 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 				      MV88E6390_SGMII_BMCR, bmcr);
 }
 
-int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				   u8 lane, struct phylink_link_state *state)
+static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
+	int port, u8 lane, struct phylink_link_state *state)
 {
 	u16 lpa, status;
 	int err;
@@ -654,6 +654,45 @@ int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_serdes_pcs_get_state(chip, status, lpa, state);
 }
 
+static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
+	int port, u8 lane, struct phylink_link_state *state)
+{
+	u16 status;
+	int err;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_10G_STAT1, &status);
+	if (err)
+		return err;
+
+	state->link = !!(status & MDIO_STAT1_LSTATUS);
+	if (state->link) {
+		state->speed = SPEED_10000;
+		state->duplex = DUPLEX_FULL;
+	}
+
+	return 0;
+}
+
+int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				   u8 lane, struct phylink_link_state *state)
+{
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return mv88e6390_serdes_pcs_get_state_sgmii(chip, port, lane,
+							    state);
+	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_RXAUI:
+		return mv88e6390_serdes_pcs_get_state_10g(chip, port, lane,
+							  state);
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
 				    u8 lane)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 12013f22df10..3af236f4b3c8 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -41,6 +41,7 @@
 
 /* 10GBASE-R and 10GBASE-X4/X2 */
 #define MV88E6390_10G_CTRL1		(0x1000 + MDIO_CTRL1)
+#define MV88E6390_10G_STAT1		(0x1000 + MDIO_STAT1)
 
 /* 1000BASE-X and SGMII */
 #define MV88E6390_SGMII_BMCR		(0x2000 + MII_BMCR)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

--2FkSFaIQeDFoAt0B
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-net-dsa-mv88e6xxx-use-generic-clause-45-definitions.patch"

From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] net: dsa: mv88e6xxx: use generic clause 45 definitions

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 12 ++++++------
 drivers/net/dsa/mv88e6xxx/serdes.h |  6 +-----
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 0a88b416ef9f..8cef46ee1d2f 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -511,21 +511,21 @@ static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
 	int err;
 
 	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_PCS_CONTROL_1, &val);
+				    MV88E6390_10G_CTRL1, &val);
 
 	if (err)
 		return err;
 
 	if (up)
-		new_val = val & ~(MV88E6390_PCS_CONTROL_1_RESET |
-				  MV88E6390_PCS_CONTROL_1_LOOPBACK |
-				  MV88E6390_PCS_CONTROL_1_PDOWN);
+		new_val = val & ~(MDIO_CTRL1_RESET |
+				  MDIO_PCS_CTRL1_LOOPBACK |
+				  MDIO_CTRL1_LPOWER);
 	else
-		new_val = val | MV88E6390_PCS_CONTROL_1_PDOWN;
+		new_val = val | MDIO_CTRL1_LPOWER;
 
 	if (val != new_val)
 		err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-					     MV88E6390_PCS_CONTROL_1, new_val);
+					     MV88E6390_10G_CTRL1, new_val);
 
 	return err;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index c92f494a276e..12013f22df10 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -40,11 +40,7 @@
 #define MV88E6390_PORT10_LANE3		0x17
 
 /* 10GBASE-R and 10GBASE-X4/X2 */
-#define MV88E6390_PCS_CONTROL_1		0x1000
-#define MV88E6390_PCS_CONTROL_1_RESET		BIT(15)
-#define MV88E6390_PCS_CONTROL_1_LOOPBACK	BIT(14)
-#define MV88E6390_PCS_CONTROL_1_SPEED		BIT(13)
-#define MV88E6390_PCS_CONTROL_1_PDOWN		BIT(11)
+#define MV88E6390_10G_CTRL1		(0x1000 + MDIO_CTRL1)
 
 /* 1000BASE-X and SGMII */
 #define MV88E6390_SGMII_BMCR		(0x2000 + MII_BMCR)
-- 
2.20.1


--2FkSFaIQeDFoAt0B--
