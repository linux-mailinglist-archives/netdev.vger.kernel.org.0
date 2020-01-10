Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D378813744E
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgAJRFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:05:10 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44690 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgAJRFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 12:05:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GW1m7aDNt8V3wz2tMHUyNfTML3DbAJB8v1NQ3l/dxuQ=; b=lyrlJXxXX7/J4lS+N5eis6wuP
        5jbnv8o2YpA45QmPBEr5nvDFnDdiWNANqkus9+StrN4doMfiHmno7Drrs0PmxNafAA3dRfAcVt2q8
        o1Ob634FzmXqJ0VcEWUW8oBQHln0bx4fPEOovcPqPoI74PLoA35C6FiTGeTQ5B2O8FYwjCYXwXZMF
        mJpzIQ7dopdfplLybMir6FvixIRxLAeyi5m61p9QewRy+dijzlPwvXES+i6yA1gAOd92smaO5ZXG5
        CBJqLuBWX9cgcrFgQ/XIVVmJ2FMu0RhxhqE4VHgIKLGlhya8rCkeTKGnP01wHcb8uI6ZLLGVdAKXl
        HxX7pGeTA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60688)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipxiY-0004N7-Br; Fri, 10 Jan 2020 17:05:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipxiT-0001fh-HO; Fri, 10 Jan 2020 17:04:57 +0000
Date:   Fri, 10 Jan 2020 17:04:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Robert Hancock <hancock@sedsystems.ca>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/14] net: axienet: Fix SGMII support
Message-ID: <20200110170457.GH25745@shell.armlinux.org.uk>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-8-andre.przywara@arm.com>
 <20200110140415.GE19739@lunn.ch>
 <20200110142038.2ed094ba@donnerap.cambridge.arm.com>
 <20200110150409.GD25745@shell.armlinux.org.uk>
 <20200110152215.GF25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110152215.GF25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 03:22:15PM +0000, Russell King - ARM Linux admin wrote:
> On Fri, Jan 10, 2020 at 03:04:09PM +0000, Russell King - ARM Linux admin wrote:
> > On Fri, Jan 10, 2020 at 02:20:38PM +0000, Andre Przywara wrote:
> > > On Fri, 10 Jan 2020 15:04:15 +0100
> > > Andrew Lunn <andrew@lunn.ch> wrote:
> > > 
> > > Hi Andrew,
> > > 
> > > > On Fri, Jan 10, 2020 at 11:54:08AM +0000, Andre Przywara wrote:
> > > > > With SGMII, the MAC and the PHY can negotiate the link speed between
> > > > > themselves, without the host needing to mediate between them.
> > > > > Linux recognises this, and will call phylink's mac_config with the speed
> > > > > member set to SPEED_UNKNOWN (-1).
> > > > > Currently the axienet driver will bail out and complain about an
> > > > > unsupported link speed.
> > > > > 
> > > > > Teach axienet's mac_config callback to leave the MAC's speed setting
> > > > > alone if the requested speed is SPEED_UNKNOWN.  
> > > > 
> > > > Hi Andre
> > > > 
> > > > Is there an interrupt when SGMII signals a change in link state? If
> > > > so, you should call phylink_mac_change().
> > > 
> > > Good point. The doc describes a "Auto-Negotiation Complete" interrupt
> > > status bit, which signal that " ... auto-negotiation of the SGMII or
> > > 1000BASE-X interface has completed."
> > 
> > It depends what they mean by "Auto-negotiation complete" in SGMII.
> > SGMII can complete the handshake, yet the config_reg word indicate
> > link down.  If such an update causes an "Auto-negotiation complete"
> > interrupt, then that's sufficient.
> > 
> > However, looking at axienet_mac_pcs_get_state(), that is just reading
> > back what the MAC was set to in axienet_mac_config(), which is not
> > how this is supposed to work.  axienet_mac_pcs_get_state() is
> > supposed to get the results of the SGMII/1000BASE-X "negotiation".
> > That also needs to be fixed.
> 
> I found "pg138-axi-ethernet.pdf" online, which I guess is this IP.
> It says for SGMII:
> 
> The results of the SGMII auto-negotiation can be read from the SGMII
> Management Auto-Negotiation Link Partner Ability Base register
> (Table 2-54). The speed of the subsystem should then be set to match.
> 
> and similar for 1000BASE-X (referencing the same register.)
> 
> However, what they give in table 2-54 is the 1000BASE-X version of
> the config_reg word, not the SGMII version (which is different.)
> 
> Hmm, I guess there's probably some scope for phylink to start
> handling an IEEE 802.3 compliant PCS accessed over MDIO rather
> than having each network driver implement this, but for now your
> axienet_mac_pcs_get_state() implementation needs to be reading
> from the register described in table 2-54 and interpreting the
> results according to whether state->interface is 802.3z or not.
> 
> Also note, don't set state->interface in axienet_mac_pcs_get_state(),
> you will be passed the currently selected interface that was last
> configured via axienet_mac_config().

Maybe something like the below will help?

Basically, use phylink_mii_pcs_get_state() instead of
axienet_mac_pcs_get_state(), and setup lp->phylink_config.pcs_mii
to point at the MII bus, and lp->phylink_config.pcs_mii_addr to
access the internal PHY (as per C_PHYADDR parameter.)

You may have some fuzz (with gnu patch) while trying to apply this,
as you won't have the context for the first and last hunks in this
patch.

This will probably not be the final version of the patch anyway;
there's some possibility to pull some of the functionality out of
phylib into a more general library which would avoid some of the
functional duplication.

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 75a74a16dc3d..44198fdb3c01 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2073,4 +2073,105 @@ phy_interface_t phylink_select_serdes_interface(unsigned long *interfaces,
 }
 EXPORT_SYMBOL_GPL(phylink_select_serdes_interface);
 
+static void phylink_decode_advertisement(struct phylink_link_state *state)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(u);
+
+	linkmode_and(u, state->lp_advertising, state->advertising);
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT, u)) {
+		state->pause = MLO_PAUSE_RX | MLO_PAUSE_TX;
+	} else if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, u)) {
+		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+				      state->lp_advertising))
+			state->pause |= MLO_PAUSE_TX;
+		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+				      state->advertising))
+			state->pause |= MLO_PAUSE_RX;
+	}
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT, u)) {
+		state->speed = SPEED_2500;
+		state->duplex = DUPLEX_FULL;
+	} else if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, u)) {
+		state->pause = SPEED_1000;
+		state->duplex = DUPLEX_FULL;
+	} else {
+		state->link = false;
+	}
+}
+
+void phylink_mii_pcs_get_state(struct phylink_config *config,
+			       struct phylink_link_state *state)
+{
+	struct mii_bus *bus = config->pcs_mii;
+	int addr = config->pcs_mii_addr;
+	int bmsr, lpa;
+
+	bmsr = mdiobus_read(bus, addr, MII_BMSR);
+	lpa = mdiobus_read(bus, addr, MII_LPA);
+	if (bmsr < 0 || lpa < 0) {
+		state->link = false;
+		return;
+	}
+
+	state->link = !!(bmsr & BMSR_LSTATUS);
+	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_1000BASEX:
+		if (lpa & LPA_1000XFULL)
+			linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+					 state->lp_advertising);
+		goto lpa_8023z;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		if (lpa & LPA_1000XFULL)
+			linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
+					 state->lp_advertising);
+	lpa_8023z:
+		if (lpa & LPA_1000XPAUSE)
+			linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+					 state->lp_advertising);
+		if (lpa & LPA_1000XPAUSE_ASYM)
+			linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+					 state->lp_advertising);
+		if (lpa & LPA_LPACK)
+			linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					 state->lp_advertising);
+		phylink_decode_advertisement(state);
+		break;
+
+	case PHY_INTERFACE_MODE_SGMII:
+		switch (lpa & 0x8c00) {
+		case 0x8000:
+			state->speed = SPEED_10;
+			break;
+		case 0x8400:
+			state->speed = SPEED_100;
+			break;
+		case 0x8800:
+			state->speed = SPEED_1000;
+			break;
+		default:
+			state->link = false;
+			break;
+		}
+		switch (lpa & 0x9000) {
+		case 0x9000:
+			state->duplex = DUPLEX_FULL;
+			break;
+		case 0x8000:
+			state->duplex = DUPLEX_HALF;
+			break;
+		}
+		break;
+
+	default:
+		state->link = false;
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_mii_pcs_get_state);
+
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 4ea76e083847..cf0fa39b4b21 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -65,6 +65,9 @@ enum phylink_op_type {
 struct phylink_config {
 	struct device *dev;
 	enum phylink_op_type type;
+
+	struct mii_bus *pcs_mii;
+	int pcs_mii_addr;
 };
 
 /**
@@ -292,4 +295,7 @@ phy_interface_t phylink_select_serdes_interface(unsigned long *interfaces,
 						const phy_interface_t *pref,
 						size_t nprefs);
 
+void phylink_mii_pcs_get_state(struct phylink_config *config,
+			       struct phylink_link_state *state);
+
 #endif

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
