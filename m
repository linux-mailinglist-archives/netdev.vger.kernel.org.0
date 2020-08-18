Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F4E2488BA
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgHRPIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgHRPIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 11:08:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF342C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 08:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5KIzp/cKI6hHKd1SCP8OP0Ehy1ZxRX18X+w2RZXRs0g=; b=g+EVwpD/j6qcAY4iiDIXPmNjr
        L9osIEGoJnYQqlcZRX2arbJ4emY/nsGuVEhfs/9MJzXPvJdCSwdVFkJaqK6M1SN85/wYkBsHCQp8Y
        Oi32QCNOhArs84jTYGN/kPv98PNkQN642Sz2StSfIJiEZ/rx3/6fzlqBqd62MJHbtCPtnOz7LFc5G
        7lGUQ6wIpOC3HTwna2H0hI+WDEoM8MwkUcfmkFB3YuJpKyK4Cm0qIydoEk7BipWdrDJSR6pRS7gH8
        y2KaQen0j8CfQ/XOjVdgKFmDrOsXelTcsO7cjn8zl+TId41OL1eZS2NPvo5t4e+p7JbKPwXFnixPh
        IBWsdYXGw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54100)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k83E5-0000Ys-KU; Tue, 18 Aug 2020 16:08:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k83E3-0001Uj-46; Tue, 18 Aug 2020 16:08:35 +0100
Date:   Tue, 18 Aug 2020 16:08:35 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 0/4] Support for RollBall 10G copper SFP
 modules
Message-ID: <20200818150834.GC1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
 <20200817134909.GY1551@shell.armlinux.org.uk>
 <20200818154305.2b7e191c@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200818154305.2b7e191c@dellmb.labs.office.nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 03:43:05PM +0200, Marek Behún wrote:
> On Mon, 17 Aug 2020 14:49:09 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > @@ -710,6 +738,20 @@ static int mv3310_config_init(struct phy_device
> > *phydev) if (err)
> >  		return err;
> >  
> > +	if (mac_type != -1) {
> > +		ret = phy_modify_mmd_changed(phydev, MDIO_MMD_VEND2,
> > +					     MV_V2_PORT_CTRL,
> > +
> > MV_V2_PORT_CTRL_MACTYPE, mac_type);
> > +		if (ret > 0)
> > +			ret = phy_modify_mmd(phydev, MDIO_MMD_VEND2,
> > +					     MV_V2_PORT_CTRL,
> > +					     MV_V2_PORT_CTRL_SWRST,
> > +					     MV_V2_PORT_CTRL_SWRST);
> 
> When chaning mactype you also have to issue SWRST in the same register
> write. Otherwise it did not work for me.

That's interesting - because the documentation explicitly states that
this is a two-step process.

> Otherwise it looks nice. I will test this. On what branch does this
> apply?

My unpublished tip of the universe development.  Here's a version on
the clearfog branch:

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index fe7e30c3faa8..dd282844637b 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -95,6 +95,7 @@ enum {
 	MV_V2_PORT_CTRL		= 0xf001,
 	MV_V2_PORT_CTRL_SWRST	= BIT(15),
 	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
+	MV_V2_PORT_CTRL_MACTYPE	= 7 << 0,
 	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
@@ -597,17 +598,44 @@ static bool mv3310_has_pma_ngbaset_quirk(struct phy_device *phydev)
 		MV_PHY_ALASKA_NBT_QUIRK_MASK) == MV_PHY_ALASKA_NBT_QUIRK_REV;
 }
 
+static int mv3310_select_mode(struct phy_device *phydev,
+			      unsigned long *host_interfaces)
+{
+	int mac_type = -1;
+
+	if (test_bit(PHY_INTERFACE_MODE_USXGMII, host_interfaces))
+		mac_type = 7;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, host_interfaces) &&
+		 test_bit(PHY_INTERFACE_MODE_10GBASER, host_interfaces))
+		mac_type = 4;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, host_interfaces) &&
+		 test_bit(PHY_INTERFACE_MODE_RXAUI, host_interfaces))
+		mac_type = 0;
+	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, host_interfaces))
+		mac_type = 6;
+	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, host_interfaces))
+		mac_type = 2;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, host_interfaces))
+		mac_type = 4;
+
+	return mac_type;
+}
+
 static int mv3310_config_init(struct phy_device *phydev)
 {
-	int err;
+	int ret, err, mac_type = -1;
 
 	/* Check that the PHY interface type is compatible */
-	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
-	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
-	    phydev->interface != PHY_INTERFACE_MODE_XAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_RXAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GBASER)
+	if (!phy_interface_empty(phydev->host_interfaces)) {
+		mac_type = mv3310_select_mode(phydev, phydev->host_interfaces);
+		phydev_info(phydev, "mac_type=%d\n", mac_type);
+	} else if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
+		   phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
+		   phydev->interface != PHY_INTERFACE_MODE_XAUI &&
+		   phydev->interface != PHY_INTERFACE_MODE_RXAUI &&
+		   phydev->interface != PHY_INTERFACE_MODE_10GBASER) {
 		return -ENODEV;
+	}
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
 
@@ -616,6 +644,20 @@ static int mv3310_config_init(struct phy_device *phydev)
 	if (err)
 		return err;
 
+	if (mac_type != -1) {
+		ret = phy_modify_mmd_changed(phydev, MDIO_MMD_VEND2,
+					     MV_V2_PORT_CTRL,
+					     MV_V2_PORT_CTRL_MACTYPE, mac_type);
+		if (ret > 0)
+			ret = phy_modify_mmd(phydev, MDIO_MMD_VEND2,
+					     MV_V2_PORT_CTRL,
+					     MV_V2_PORT_CTRL_SWRST,
+					     MV_V2_PORT_CTRL_SWRST);
+
+		if (ret < 0)
+			return ret;
+	}
+
 	/* Enable EDPD mode - saving 600mW */
 	err = mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
 	if (err)
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index ac44fceb84e6..ac9b1a4fe464 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2016,6 +2016,8 @@ static void phylink_sfp_detach(void *upstream, struct sfp_bus *bus)
 	pl->netdev->sfp_bus = NULL;
 }
 
+static DECLARE_PHY_INTERFACE_MASK(phylink_sfp_interfaces);
+
 static const phy_interface_t phylink_sfp_interface_preference[] = {
 	PHY_INTERFACE_MODE_USXGMII,
 	PHY_INTERFACE_MODE_10GBASER,
@@ -2025,6 +2027,18 @@ static const phy_interface_t phylink_sfp_interface_preference[] = {
 	PHY_INTERFACE_MODE_1000BASEX,
 };
 
+static int __init phylink_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(phylink_sfp_interface_preference); i++)
+		set_bit(phylink_sfp_interface_preference[i],
+			phylink_sfp_interfaces);
+
+	return 0;
+}
+module_init(phylink_init);
+
 static phy_interface_t phylink_select_interface(struct phylink *pl,
 						const unsigned long *intf,
 						const char *intf_name)
@@ -2239,6 +2253,10 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 	else
 		mode = MLO_AN_INBAND;
 
+	/* Set the PHY's host supported interfaces */
+	phy_interface_and(phy->host_interfaces, phylink_sfp_interfaces,
+			  pl->config->supported_interfaces);
+
 	if (!phy_interface_empty(phy->supported_interfaces) &&
 	    !phy_interface_empty(pl->config->supported_interfaces)) {
 		interface = phylink_select_interface(pl,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index b7a51f09dad7..9ce4b6c5ebef 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -527,6 +527,7 @@ struct phy_device {
 
 	/* bitmap of supported interfaces */
 	DECLARE_PHY_INTERFACE_MASK(supported_interfaces);
+	DECLARE_PHY_INTERFACE_MASK(host_interfaces);
 
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
