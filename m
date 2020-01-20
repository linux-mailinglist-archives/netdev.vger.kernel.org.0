Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15607142F02
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 16:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgATPqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 10:46:13 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36810 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgATPqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 10:46:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=368+lebzNRomppsG5qawHSh1PsOkjri2GRqFcFkh1tU=; b=J0o9DatRQfFOgOOYjAYPJe2Pe
        Gt9voqZ26Pz1cSKGwriSpbxIjP0jfULQ0L8gzNJQ753EVZqzJN7O+9BECs9mVKubuuhpNRC4yGN3L
        hYzAEr2p/xCRfSQ3WFY0vbxil4xfKDvXrGTxVjPohCsagX5kATq/WtbHQeVvEtZYU2mMyzTm3kGxZ
        h9cOaC9Jfr7jowm9S4lNyJfq1KIJeqLqXJ8nMMI1mbXKc0mUb8Nr0i6smAuN6cnfCB6OrF3LjnmaT
        VmVei98gCftBew8XSRvnCoKh9CuH/aQZKyQs09iyiWHvTDyldkoLo6BaXEeecxX2jipvyQjxHM1sL
        b6SlPUW+A==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:36766)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1itZFZ-0007Ep-GB; Mon, 20 Jan 2020 15:46:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1itZFS-0002xO-IF; Mon, 20 Jan 2020 15:45:54 +0000
Date:   Mon, 20 Jan 2020 15:45:54 +0000
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
Message-ID: <20200120154554.GD25745@shell.armlinux.org.uk>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-8-andre.przywara@arm.com>
 <20200110140415.GE19739@lunn.ch>
 <20200110142038.2ed094ba@donnerap.cambridge.arm.com>
 <20200110150409.GD25745@shell.armlinux.org.uk>
 <20200110152215.GF25745@shell.armlinux.org.uk>
 <20200110170457.GH25745@shell.armlinux.org.uk>
 <20200118112258.GT25745@shell.armlinux.org.uk>
 <3b28dcb4-6e52-9a48-bf9c-ddad4cf5e98a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b28dcb4-6e52-9a48-bf9c-ddad4cf5e98a@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 02:50:28PM +0000, Andre Przywara wrote:
> On 18/01/2020 11:22, Russell King - ARM Linux admin wrote:
> > On Fri, Jan 10, 2020 at 05:04:57PM +0000, Russell King - ARM Linux admin wrote:
> >> Maybe something like the below will help?
> >>
> >> Basically, use phylink_mii_pcs_get_state() instead of
> >> axienet_mac_pcs_get_state(), and setup lp->phylink_config.pcs_mii
> >> to point at the MII bus, and lp->phylink_config.pcs_mii_addr to
> >> access the internal PHY (as per C_PHYADDR parameter.)
> >>
> >> You may have some fuzz (with gnu patch) while trying to apply this,
> >> as you won't have the context for the first and last hunks in this
> >> patch.
> >>
> >> This will probably not be the final version of the patch anyway;
> >> there's some possibility to pull some of the functionality out of
> >> phylib into a more general library which would avoid some of the
> >> functional duplication.
> > 
> > Hi Andre,
> > 
> > Did you have a chance to see whether this helps?
> 
> Sorry, I needed some time to wrap my head around your reply first. Am I am still not fully finished with this process ;-)
> Anyway I observed that when I add 'managed = "in-band-status"' to the DT, it seems to work, because it actually calls axienet_mac_pcs_get_state() to learn the actual negotiated parameters. Then in turn it calls mac_config with the proper speed instead of -1:
> [  151.682532] xilinx_axienet 7fe00000.ethernet eth0: configuring for inband/sgmii link mode
> [  151.710743] axienet_mac_config(config, mode=2, speed=-1, duplex=255, pause=16)
> ...
> [  153.818568] axienet_mac_pcs_get_state(config): speed=1000, interface=4, pause=0
> [  153.842244] axienet_mac_config(config, mode=2, speed=1000, duplex=1, pause=0)
> 
> Without that DT property it never called mac_pcs_get_state(), so never learnt about the actual settings.
> But the actual MAC setting was already right (1 GBps, FD). Whether this was by chance (reset value?) or because this was set by the PHY via SGMII, I don't know.
> So in my case I think I *need* to have the managed = ... property in my DT.

I really don't like this guess-work.  The specifications are freely
available out there, so there's really no need for this.

pg051-tri-mode-eth-mac.pdf describes the ethernet controller, and
Table 2-32 therein describes the EMMC register.

Bits 31 and 30 comprise a two-bit field which indicates the speed that
has been configured.  When the Xilinx IP has been configured for a
fixed speed, it adopts a hard-coded value (in other words, it is read-
only).  When it is read-writable, it defaults to "10" - 1G speed.

So, I think this just works by coincidence, not by proper design,
and therefore your patch in this sub-thread is incorrect since it's
masking the problem.

> But I was wondering if we need this patch anyway, regardless of the proper way to check for the connection setting in this case. Because at the moment calling mac_config with speed=-1 will *delete* the current MAC speed setting and leave it as 10 Mbps (because this is encoded as 0), when speed is not one of the well-known values. I am not sure that is desired behaviour, or speed=-1 just means: don't touch the speed setting. After all we call mac_config with speed=-1 first, even when later fixing this up (see above).

Have you tested 100M and 10M speeds as well - I suspect you'll find
that, as you're relying on the IP default EMMC register setting, it
just won't work with your patches as they stand, because there is
nothing to read the in-band result.  I also don't see anything in
either pg051-tri-mode-eth-mac.pdf or pg047-gig-eth-pcs-pma.pdf which
indicates that the PCS negotiation results are passed automatically
between either IP blocks.

Therefore, I think you _will_ need something like the patch I've
proposed to make this Xilinx IP work properly.

I've augmented the patch with further 1000BASE-X support, including
adding support for configuring the advertisement in the PG047 PCS
registers.  To allow this IP to support 1000BASE-X, from what I
read in these documents, that will also be necessary.

8<===
From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] net: phylink: helpers for 802.3 clause 37/SGMII register sets

Implement helpers for PCS accessed via the MII bus using register
sets conforming to 802.3 clause 37. Advertisements for clause 37
and Cisco SGMII are supported by these helpers.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 186 ++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |   9 ++
 2 files changed, 195 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e260098d3719..ed82407240b8 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2081,4 +2081,190 @@ phy_interface_t phylink_select_serdes_interface(unsigned long *interfaces,
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
+static void phylink_decode_sgmii_word(struct phylink_link_state *state,
+				      uint16_t config_reg)
+{
+	if (!(lpa & BIT(15))) {
+		state->link = false;
+		return;
+	}
+
+	switch (lpa & 0x0c00) {
+	case 0x0000:
+		state->speed = SPEED_10;
+		state->duplex = lpa & 0x1000 ? DUPLEX_FULL : DUPLEX_HALF;
+		break;
+	case 0x0400:
+		state->speed = SPEED_100;
+		state->duplex = lpa & 0x1000 ? DUPLEX_FULL : DUPLEX_HALF;
+		break;
+	case 0x0800:
+		state->speed = SPEED_1000;
+		state->duplex = lpa & 0x1000 ? DUPLEX_FULL : DUPLEX_HALF;
+		break;
+	default:
+		state->link = false;
+		break;
+	}
+}
+
+/**
+ * phylink_mii_pcs_get_state - read the MAC PCS state
+ * @config: a pointer to a &struct phylink_config.
+ * @state: a pointer to a &struct phylink_link_state.
+ *
+ * Helper for MAC PCS supporting the 802.3 register set for clause 37
+ * negotiation and/or SGMII control.
+ *
+ * Read the MAC PCS state from the MII device configured in @config and
+ * parse the Clause 37 or Cisco SGMII link partner negotiation word into
+ * the phylink @state structure. This is suitable to be directly plugged
+ * into the mac_pcs_get_state() member of the struct phylink_mac_ops
+ * structure.
+ */
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
+	if (!state->link)
+		return;
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
+		phylink_decode_sgmii_word(state, lpa);
+		break;
+
+	default:
+		state->link = false;
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_mii_pcs_get_state);
+
+/**
+ * phylink_mii_pcs_set_advertisement - configure the clause 37 PCS advertisement
+ * @config: a pointer to a &struct phylink_config.
+ * @state: a pointer to the state being configured.
+ *
+ * Helper for MAC PCS supporting the 802.3 register set for clause 37
+ * negotiation and/or SGMII control.
+ *
+ * Configure the clause 37 PCS advertisement as specified by @state. This
+ * does not trigger a renegotiation; phylink will do that via the
+ * mac_an_restart() method of the struct phylink_mac_ops structure.
+ */
+int phylink_mii_pcs_set_advertisement(struct phylink_config *config,
+				      const struct phylink_link_state *state)
+{
+	struct mii_bus *bus = config->pcs_mii;
+	int addr = config->pcs_mii_addr;
+	u16 adv;
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		adv = ADVERTISE_1000XFULL;
+		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+				      state->advertising))
+			adv |= ADVERTISE_1000XPAUSE;
+		if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+				      state->advertising))
+			adv |= ADVERTISE_1000XPSE_ASYM;
+		return mdiobus_write(bus, addr, MII_ADVERTISE, adv);
+
+	default:
+		/* Nothing to do for other modes */
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_mii_pcs_set_advertisement);
+
+/**
+ * phylink_mii_pcs_an_restart - restart 802.3z autonegotiation
+ * @config: a pointer to a &struct phylink_config.
+ *
+ * Helper for MAC PCS supporting the 802.3 register set for clause 37
+ * negotiation.
+ *
+ * Restart the clause 37 negotiation with the link partner. This is
+ * suitable to be directly plugged into the mac_pcs_get_state() member
+ * of the struct phylink_mac_ops structure.
+ */
+void phylink_mii_pcs_an_restart(struct phylink_config *config)
+{
+	struct mii_bus *bus = config->pcs_mii;
+	int val, addr = config->pcs_mii_addr;
+
+	val = mdiobus_read(bus, addr, MII_BMCR);
+	if (val >= 0) {
+		val |= BMCR_ANRESTART;
+
+		mdiobus_write(bus, addr, MII_BMCR, val);
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_mii_pcs_an_restart);
+
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 4ea76e083847..d51f45fc5f9a 100644
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
@@ -292,4 +295,10 @@ phy_interface_t phylink_select_serdes_interface(unsigned long *interfaces,
 						const phy_interface_t *pref,
 						size_t nprefs);
 
+void phylink_mii_pcs_get_state(struct phylink_config *config,
+			       struct phylink_link_state *state);
+int phylink_mii_pcs_set_advertisement(struct phylink_config *config,
+				      const struct phylink_link_state *state);
+void phylink_mii_pcs_an_restart(struct phylink_config *config);
+
 #endif
-- 
2.20.1


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
