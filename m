Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6477E45145
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 03:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfFNBm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 21:42:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfFNBm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 21:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=na2VxB1O17mU5LYtPKxoIWui4kdbBPIH9FHsOBViC7I=; b=FPK8tREFMEQ4wGH8+rsThyl84q
        6iel3VvYWJpHF87bvfKOmTDzXHVnjg+rczuTbHPjHiRb3rNy8AjJ/hA3ItppLmpjHUBU4MM0zQxmf
        wKX4Gvo+itz8SSbSTpdbQmOjuGzpRZMOGy1p2e28tKO91Gupuci8WvB0+IGrIKXxROf8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hbbEV-0008AA-UT; Fri, 14 Jun 2019 03:42:23 +0200
Date:   Fri, 14 Jun 2019 03:42:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     linux@armlinux.org.uk, hkallweit1@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com, ruxandra.radulescu@nxp.com
Subject: Re: [PATCH RFC 4/6] dpaa2-mac: add initial driver
Message-ID: <20190614014223.GD28822@lunn.ch>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <1560470153-26155-5-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560470153-26155-5-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static phy_interface_t phy_mode(enum dpmac_eth_if eth_if)
> +{
> +	switch (eth_if) {
> +	case DPMAC_ETH_IF_RGMII:
> +		return PHY_INTERFACE_MODE_RGMII;

So the MAC cannot insert RGMII delays? I didn't see anything in the
PHY object about configuring the delays. Does the PCB need to add
delays via squiggles in the tracks?

> +static void dpaa2_mac_validate(struct phylink_config *config,
> +			       unsigned long *supported,
> +			       struct phylink_link_state *state)
> +{
> +	struct dpaa2_mac_priv *priv = to_dpaa2_mac_priv(phylink_config);
> +	struct dpmac_link_state *dpmac_state = &priv->state;
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	phylink_set(mask, Autoneg);
> +	phylink_set_port_modes(mask);
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_10GKR:
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 10000baseT_Full);
> +		break;
> +	case PHY_INTERFACE_MODE_QSGMII:
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 1000baseT_Full);
> +		break;
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 10000baseT_Full);
> +		break;
> +	default:
> +		goto empty_set;
> +	}

I think this is wrong. This is about validating what the MAC can
do. The state->interface should not matter. The PHY will indicate what
interface mode should be used when auto-neg has completed. The MAC is
then expected to change its interface to fit.

But lets see what Russell says.

> +static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
> +			     const struct phylink_link_state *state)
> +{
> +	struct dpaa2_mac_priv *priv = to_dpaa2_mac_priv(phylink_config);
> +	struct dpmac_link_state *dpmac_state = &priv->state;
> +	struct device *dev = &priv->mc_dev->dev;
> +	int err;
> +
> +	if (state->speed == SPEED_UNKNOWN && state->duplex == DUPLEX_UNKNOWN)
> +		return;
> +
> +	dpmac_state->up = !!state->link;
> +	if (dpmac_state->up) {
> +		dpmac_state->rate = state->speed;
> +
> +		if (!state->duplex)
> +			dpmac_state->options |= DPMAC_LINK_OPT_HALF_DUPLEX;
> +		else
> +			dpmac_state->options &= ~DPMAC_LINK_OPT_HALF_DUPLEX;
> +
> +		if (state->an_enabled)
> +			dpmac_state->options |= DPMAC_LINK_OPT_AUTONEG;
> +		else
> +			dpmac_state->options &= ~DPMAC_LINK_OPT_AUTONEG;

As Russell pointed out, this auto-neg is only valid in a limited
context. The MAC generally does not perform auto-neg. The MAC is only
involved in auto-neg when inband signalling is used between the MAC
and PHY in 802.3z.

As the name says, dpaa2_mac_config is about the MAC.

   Andrew
