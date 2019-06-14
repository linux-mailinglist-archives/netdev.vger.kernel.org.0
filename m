Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE404593C
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfFNJuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:50:23 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35072 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfFNJuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 05:50:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+df3yx3bDRXtOD30qscQJty54hbRKLhevNm/s7Duk6c=; b=ZhKpaUZsprT1IETGypUOXBBQv
        O5r/647blx/K1cxgqRyU6ckEmA287XHg+tDiz7y4Gj3BBkbI4vndQ9Ss1kXHN8DKgnwONl1o3+LKe
        c2zh8JMnvPdgChQ5gD0lAPLckfc5bBY0oF5V4qujCI2fExUNv5FGP/33DTPoIrCYtOyGXm672jXlx
        IxKvHedz8ZGabXxjNWqkCVBxepDDePzl4hfFFM7ih4iC/Rskf3I2o1qOTvtXgBAaWh9cn+zk1cdni
        OwjMB+udyRK6p638p5xWZQg0kTv1WRVJ1LyV84anT/CTmw+BfKQyNy0kISVnGEwoIoi6vkQOHRReu
        e7o/shYWA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38696)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hbiqf-0000av-8V; Fri, 14 Jun 2019 10:50:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hbiqd-00027H-Dc; Fri, 14 Jun 2019 10:50:15 +0100
Date:   Fri, 14 Jun 2019 10:50:15 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, hkallweit1@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com, ruxandra.radulescu@nxp.com
Subject: Re: [PATCH RFC 4/6] dpaa2-mac: add initial driver
Message-ID: <20190614095015.mhs723furhhsaclo@shell.armlinux.org.uk>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <1560470153-26155-5-git-send-email-ioana.ciornei@nxp.com>
 <20190614014223.GD28822@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614014223.GD28822@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 03:42:23AM +0200, Andrew Lunn wrote:
> > +static phy_interface_t phy_mode(enum dpmac_eth_if eth_if)
> > +{
> > +	switch (eth_if) {
> > +	case DPMAC_ETH_IF_RGMII:
> > +		return PHY_INTERFACE_MODE_RGMII;
> 
> So the MAC cannot insert RGMII delays? I didn't see anything in the
> PHY object about configuring the delays. Does the PCB need to add
> delays via squiggles in the tracks?
> 
> > +static void dpaa2_mac_validate(struct phylink_config *config,
> > +			       unsigned long *supported,
> > +			       struct phylink_link_state *state)
> > +{
> > +	struct dpaa2_mac_priv *priv = to_dpaa2_mac_priv(phylink_config);
> > +	struct dpmac_link_state *dpmac_state = &priv->state;
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > +
> > +	phylink_set(mask, Autoneg);
> > +	phylink_set_port_modes(mask);
> > +
> > +	switch (state->interface) {
> > +	case PHY_INTERFACE_MODE_10GKR:
> > +		phylink_set(mask, 10baseT_Full);
> > +		phylink_set(mask, 100baseT_Full);
> > +		phylink_set(mask, 1000baseT_Full);
> > +		phylink_set(mask, 10000baseT_Full);
> > +		break;

How does 10GBASE-KR mode support these lesser speeds - 802.3 makes no
provision for slower speeds for a 10GBASE-KR link, it is a fixed speed
link.  I don't see any other possible phy interface mode supported that
would allow for the 1G, 100M and 10M speeds (i.o.w. SGMII).  If SGMII
is not supported, then how do you expect these other speeds to work?

Does your PHY do speed conversion - if so, we need to come up with a
much better way of handling that (we need phylib to indicate that the
PHY is so capable.)

> > +	case PHY_INTERFACE_MODE_QSGMII:
> > +	case PHY_INTERFACE_MODE_RGMII:
> > +	case PHY_INTERFACE_MODE_RGMII_ID:
> > +	case PHY_INTERFACE_MODE_RGMII_RXID:
> > +	case PHY_INTERFACE_MODE_RGMII_TXID:
> > +		phylink_set(mask, 10baseT_Full);
> > +		phylink_set(mask, 100baseT_Full);
> > +		phylink_set(mask, 1000baseT_Full);
> > +		break;
> > +	case PHY_INTERFACE_MODE_USXGMII:
> > +		phylink_set(mask, 10baseT_Full);
> > +		phylink_set(mask, 100baseT_Full);
> > +		phylink_set(mask, 1000baseT_Full);
> > +		phylink_set(mask, 10000baseT_Full);
> > +		break;
> > +	default:
> > +		goto empty_set;
> > +	}
> 
> I think this is wrong. This is about validating what the MAC can
> do. The state->interface should not matter. The PHY will indicate what
> interface mode should be used when auto-neg has completed. The MAC is
> then expected to change its interface to fit.

The question is whether a PHY/MAC wired up using a particular topology
can switch between other interface types.

For example, SGMII, 802.3z and 10GBASE-KR all use a single serdes lane
which means that as long as both ends are configured for the same
protocol, the result should work.  As an example, Marvell 88x3310 PHYs
switch between these three modes depending on the negotiated speed.

So, this is more to do with saying what the MAC can support with a
particular wiring topology rather than the strict PHY interface type.

Take mvneta:

        /* Half-duplex at speeds higher than 100Mbit is unsupported */
        if (pp->comphy || state->interface != PHY_INTERFACE_MODE_2500BASEX) {
                phylink_set(mask, 1000baseT_Full);
                phylink_set(mask, 1000baseX_Full);
        }
        if (pp->comphy || state->interface == PHY_INTERFACE_MODE_2500BASEX) {
                phylink_set(mask, 2500baseX_Full);
        }

If we have a comphy, we can switch the MAC speed between 1G and 2.5G
here, so we allow both 1G and 2.5G to be set in the supported mask.

If we do not have a comphy, we are not able to change the MAC speed
at runtime, so we are more restrictive with the support mask.

> > +static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
> > +			     const struct phylink_link_state *state)
> > +{
> > +	struct dpaa2_mac_priv *priv = to_dpaa2_mac_priv(phylink_config);
> > +	struct dpmac_link_state *dpmac_state = &priv->state;
> > +	struct device *dev = &priv->mc_dev->dev;
> > +	int err;
> > +
> > +	if (state->speed == SPEED_UNKNOWN && state->duplex == DUPLEX_UNKNOWN)
> > +		return;

As I've already pointed out, state->speed and state->duplex are only
valid for fixed-link and PHY setups.  They are not valid for SGMII
and 802.3z, which use in-band configuration/negotiation, but then in
your validate callback, it seems you don't support these.

Since many SFP modules require SGMII and 802.3z, I wonder how this
is going to work.

> > +
> > +	dpmac_state->up = !!state->link;
> > +	if (dpmac_state->up) {

No, whether the link is up or down is not a concern for this function,
and it's not guaranteed to be valid here.

I can see I made a bad choice when designing this interface - it was
simpler to have just one structure for reading the link state from the
MAC and setting the configuration, because the two were very similar.

I can see I should've made them separate and specific to each call
(which would necessitate additional code, but for the sake of enforcing
correct programming interface usage, it would've been the right thing.)

> > +		dpmac_state->rate = state->speed;
> > +
> > +		if (!state->duplex)
> > +			dpmac_state->options |= DPMAC_LINK_OPT_HALF_DUPLEX;
> > +		else
> > +			dpmac_state->options &= ~DPMAC_LINK_OPT_HALF_DUPLEX;
> > +
> > +		if (state->an_enabled)
> > +			dpmac_state->options |= DPMAC_LINK_OPT_AUTONEG;
> > +		else
> > +			dpmac_state->options &= ~DPMAC_LINK_OPT_AUTONEG;
> 
> As Russell pointed out, this auto-neg is only valid in a limited
> context. The MAC generally does not perform auto-neg. The MAC is only
> involved in auto-neg when inband signalling is used between the MAC
> and PHY in 802.3z.

or SGMII.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
