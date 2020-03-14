Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5F51856B0
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgCOB3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:29:06 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgCOB3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:29:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kRz4ZcqPoFczBF9uJ62HESF4a4xDBbYWnBSvi/lpH/Y=; b=SrJgXkO3vIVYIe2zLHGApFZs+m
        LPLIFJuzBlyI1mFICnr+NY5H6xefBinFXltbcVLrCu6i5iPuvkCwevRflWJCTrl1Cb7/62k9vwYRI
        3I0/lZYdxjAhKQa2RITHpBQl5wXFA4KGEzn+Q84gF9ebSq0HW6hDwS32zCUAyIW1fTUY88/SKvYRr
        zSgOgUcou/Ot03K9khipTiMZkVJW7Njn9aWA5I7yRNBtnRB91t2REnlhgKEibPIuv4kVRGZ544ZX+
        KQNwL7kvTl4mnNWEGLpMlLgr67vOTnWeypMa4DgzVWfwIWM9n8gnyIYPuC8crrJi2SoEtxnEvCLmq
        EEten+Iw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:49398 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD44n-0006MD-Vx; Sat, 14 Mar 2020 10:31:30 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD44n-0006Mq-Cc; Sat, 14 Mar 2020 10:31:29 +0000
In-Reply-To: <20200314103102.GJ25745@shell.armlinux.org.uk>
References: <20200314103102.GJ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] net: phylink: pcs: add 802.3 clause 22 helpers
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jD44n-0006Mq-Cc@rmk-PC.armlinux.org.uk>
Date:   Sat, 14 Mar 2020 10:31:29 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement helpers for PCS accessed via the MII bus using 802.3 clause
22 cycles, conforming to 802.3 clause 37 and Cisco SGMII specifications
for the advertisement word.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 206 ++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |   6 ++
 include/uapi/linux/mii.h  |   5 +
 3 files changed, 217 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a8eeaabb2d18..7ca427c46d9f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2041,4 +2041,210 @@ void phylink_helper_basex_speed(struct phylink_link_state *state)
 }
 EXPORT_SYMBOL_GPL(phylink_helper_basex_speed);
 
+static void phylink_decode_c37_word(struct phylink_link_state *state,
+				    uint16_t config_reg, int speed)
+{
+	bool tx_pause, rx_pause;
+	int fd_bit;
+
+	if (speed == SPEED_2500)
+		fd_bit = ETHTOOL_LINK_MODE_2500baseX_Full_BIT;
+	else
+		fd_bit = ETHTOOL_LINK_MODE_1000baseX_Full_BIT;
+
+	mii_lpa_mod_linkmode_x(state->lp_advertising, config_reg, fd_bit);
+
+	if (linkmode_test_bit(fd_bit, state->advertising) &&
+	    linkmode_test_bit(fd_bit, state->lp_advertising)) {
+		state->speed = speed;
+		state->duplex = DUPLEX_FULL;
+	} else {
+		/* negotiation failure */
+		state->link = false;
+	}
+
+	linkmode_resolve_pause(state->advertising, state->lp_advertising,
+			       &tx_pause, &rx_pause);
+
+	if (tx_pause)
+		state->pause |= MLO_PAUSE_TX;
+	if (rx_pause)
+		state->pause |= MLO_PAUSE_RX;
+}
+
+static void phylink_decode_sgmii_word(struct phylink_link_state *state,
+				      uint16_t config_reg)
+{
+	if (!(config_reg & LPA_SGMII_LINK)) {
+		state->link = false;
+		return;
+	}
+
+	switch (config_reg & LPA_SGMII_SPD_MASK) {
+	case LPA_SGMII_10:
+		state->speed = SPEED_10;
+		break;
+	case LPA_SGMII_100:
+		state->speed = SPEED_100;
+		break;
+	case LPA_SGMII_1000:
+		state->speed = SPEED_1000;
+		break;
+	default:
+		state->link = false;
+		return;
+	}
+	if (config_reg & LPA_SGMII_FULL_DUPLEX)
+		state->duplex = DUPLEX_FULL;
+	else
+		state->duplex = DUPLEX_HALF;
+}
+
+/**
+ * phylink_mii_c22_pcs_get_state() - read the MAC PCS state
+ * @pcs: a pointer to a &struct mdio_device.
+ * @state: a pointer to a &struct phylink_link_state.
+ *
+ * Helper for MAC PCS supporting the 802.3 clause 22 register set for
+ * clause 37 negotiation and/or SGMII control.
+ *
+ * Read the MAC PCS state from the MII device configured in @config and
+ * parse the Clause 37 or Cisco SGMII link partner negotiation word into
+ * the phylink @state structure. This is suitable to be directly plugged
+ * into the mac_pcs_get_state() member of the struct phylink_mac_ops
+ * structure.
+ */
+void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
+				   struct phylink_link_state *state)
+{
+	struct mii_bus *bus = pcs->bus;
+	int addr = pcs->addr;
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
+		phylink_decode_c37_word(state, lpa, SPEED_1000);
+		break;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		phylink_decode_c37_word(state, lpa, SPEED_2500);
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
+EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_get_state);
+
+/**
+ * phylink_mii_c22_pcs_set_advertisement() - configure the clause 37 PCS
+ *	advertisement
+ * @pcs: a pointer to a &struct mdio_device.
+ * @state: a pointer to the state being configured.
+ *
+ * Helper for MAC PCS supporting the 802.3 clause 22 register set for
+ * clause 37 negotiation and/or SGMII control.
+ *
+ * Configure the clause 37 PCS advertisement as specified by @state. This
+ * does not trigger a renegotiation; phylink will do that via the
+ * mac_an_restart() method of the struct phylink_mac_ops structure.
+ *
+ * Returns negative error code on failure to configure the advertisement,
+ * zero if no change has been made, or one if the advertisement has changed.
+ */
+int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
+					const struct phylink_link_state *state)
+{
+	struct mii_bus *bus = pcs->bus;
+	int addr = pcs->addr;
+	int val, ret;
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
+
+		val = mdiobus_read(bus, addr, MII_ADVERTISE);
+		if (val < 0)
+			return val;
+
+		if (val == adv)
+			return 0;
+
+		ret = mdiobus_write(bus, addr, MII_ADVERTISE, adv);
+		if (ret < 0)
+			return ret;
+
+		return 1;
+
+	case PHY_INTERFACE_MODE_SGMII:
+		val = mdiobus_read(bus, addr, MII_ADVERTISE);
+		if (val < 0)
+			return val;
+
+		if (val == 0x0001)
+			return 0;
+
+		ret = mdiobus_write(bus, addr, MII_ADVERTISE, 0x0001);
+		if (ret < 0)
+			return ret;
+
+		return 1;
+
+	default:
+		/* Nothing to do for other modes */
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_set_advertisement);
+
+/**
+ * phylink_mii_c22_pcs_an_restart() - restart 802.3z autonegotiation
+ * @pcs: a pointer to a &struct mdio_device.
+ *
+ * Helper for MAC PCS supporting the 802.3 clause 22 register set for
+ * clause 37 negotiation.
+ *
+ * Restart the clause 37 negotiation with the link partner. This is
+ * suitable to be directly plugged into the mac_pcs_get_state() member
+ * of the struct phylink_mac_ops structure.
+ */
+void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs)
+{
+	struct mii_bus *bus = pcs->bus;
+	int val, addr = pcs->addr;
+
+	val = mdiobus_read(bus, addr, MII_BMCR);
+	if (val >= 0) {
+		val |= BMCR_ANRESTART;
+
+		mdiobus_write(bus, addr, MII_BMCR, val);
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_an_restart);
+
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 2180eb1aa254..de591c2fb37e 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -317,4 +317,10 @@ int phylink_mii_ioctl(struct phylink *, struct ifreq *, int);
 void phylink_set_port_modes(unsigned long *bits);
 void phylink_helper_basex_speed(struct phylink_link_state *state);
 
+void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
+				   struct phylink_link_state *state);
+int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
+					const struct phylink_link_state *state);
+void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs);
+
 #endif
diff --git a/include/uapi/linux/mii.h b/include/uapi/linux/mii.h
index 0b9c3beda345..90f9b4e1ba27 100644
--- a/include/uapi/linux/mii.h
+++ b/include/uapi/linux/mii.h
@@ -134,11 +134,16 @@
 /* MAC and PHY tx_config_Reg[15:0] for SGMII in-band auto-negotiation.*/
 #define ADVERTISE_SGMII		0x0001	/* MAC can do SGMII            */
 #define LPA_SGMII		0x0001	/* PHY can do SGMII            */
+#define LPA_SGMII_SPD_MASK	0x0c00	/* SGMII speed mask            */
+#define LPA_SGMII_FULL_DUPLEX	0x1000	/* SGMII full duplex           */
 #define LPA_SGMII_DPX_SPD_MASK	0x1C00	/* SGMII duplex and speed bits */
+#define LPA_SGMII_10		0x0000	/* 10Mbps                      */
 #define LPA_SGMII_10HALF	0x0000	/* Can do 10mbps half-duplex   */
 #define LPA_SGMII_10FULL	0x1000	/* Can do 10mbps full-duplex   */
+#define LPA_SGMII_100		0x0400	/* 100Mbps                     */
 #define LPA_SGMII_100HALF	0x0400	/* Can do 100mbps half-duplex  */
 #define LPA_SGMII_100FULL	0x1400	/* Can do 100mbps full-duplex  */
+#define LPA_SGMII_1000		0x0800	/* 1000Mbps                    */
 #define LPA_SGMII_1000HALF	0x0800	/* Can do 1000mbps half-duplex */
 #define LPA_SGMII_1000FULL	0x1800	/* Can do 1000mbps full-duplex */
 #define LPA_SGMII_LINK		0x8000	/* PHY link with copper-side partner */
-- 
2.20.1

