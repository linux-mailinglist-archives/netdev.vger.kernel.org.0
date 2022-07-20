Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07B057B13B
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 08:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiGTGu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 02:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGTGu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 02:50:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87D32FFD9;
        Tue, 19 Jul 2022 23:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VmYhcl1kntwfBMI/6ezqKks85/4FsO2GpWpJV2EwAT8=; b=yaQZ8TwPitY9oIUmm+HyAGnuFi
        oT0oGMUzC7U/TuzGEZPxeaq57DmFPKj50vwCF1NF0HrKxq5O2lMDydn5X+WXaf+JuzsA/dI08Rxen
        /XWmFc7e7HT8mX4rOeCfIAlyJLcPDajkaXWdrCn/UvhFkaFKgI853fCGqdR7YD/RxRHCaQIGshNji
        WxpwEAkX7UhYLuo+qj9Jo9fnkVBfgKMhEpPGjLOJEhGEfvGpA3Yvl24QPIvtI3bBtnct0ywmHJUiB
        8qU7PmMWh0i1OT0I2QYpytwajQYdLZAnmUBM2wPNMAI+Zl2Wuh8xeICrD2/0E2brba9s5Olyynst3
        4VqY+BLA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33456)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oE3Xp-0003nG-Hk; Wed, 20 Jul 2022 07:50:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oE3Xo-0003gO-C6; Wed, 20 Jul 2022 07:50:52 +0100
Date:   Wed, 20 Jul 2022 07:50:52 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 07/11] net: phylink: Adjust link settings based on
 rate adaptation
Message-ID: <YtelzB1uO0zACa42@shell.armlinux.org.uk>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-8-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719235002.1944800-8-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 07:49:57PM -0400, Sean Anderson wrote:
> If the phy is configured to use pause-based rate adaptation, ensure that
> the link is full duplex with pause frame reception enabled. As
> suggested, if pause-based rate adaptation is enabled by the phy, then
> pause reception is unconditionally enabled.
> 
> The interface duplex is determined based on the rate adaptation type.
> When rate adaptation is enabled, so is the speed. We assume the maximum
> interface speed is used. This is only relevant for MLO_AN_PHY. For
> MLO_AN_INBAND, the MAC/PCS's view of the interface speed will be used.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v2:
> - Use the phy's rate adaptation setting to determine whether to use its
>   link speed/duplex or the MAC's speed/duplex with MLO_AN_INBAND.
> - Always use the rate adaptation setting to determine the interface
>   speed/duplex (instead of sometimes using the interface mode).
> 
>  drivers/net/phy/phylink.c | 126 ++++++++++++++++++++++++++++++++++----
>  include/linux/phylink.h   |   1 +
>  2 files changed, 114 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index da0623d94a64..619ef553476f 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -160,16 +160,93 @@ static const char *phylink_an_mode_str(unsigned int mode)
>   * @state: A link state
>   *
>   * Update the .speed and .duplex members of @state. We can determine them based
> - * on the .link_speed and .link_duplex. This function should be called whenever
> - * .link_speed and .link_duplex are updated.  For example, userspace deals with
> - * link speed and duplex, and not the interface speed and duplex. Similarly,
> - * phys deal with link speed and duplex and only implicitly the interface speed
> - * and duplex.
> + * on the .link_speed, .link_duplex, .interface, and .rate_adaptation. This
> + * function should be called whenever .link_speed and .link_duplex are updated.
> + * For example, userspace deals with link speed and duplex, and not the
> + * interface speed and duplex. Similarly, phys deal with link speed and duplex
> + * and only implicitly the interface speed and duplex.
>   */
>  static void phylink_state_fill_speed_duplex(struct phylink_link_state *state)
>  {
> -	state->speed = state->link_speed;
> -	state->duplex = state->link_duplex;
> +	switch (state->rate_adaptation) {
> +	case RATE_ADAPT_NONE:
> +		state->speed = state->link_speed;
> +		state->duplex = state->link_duplex;
> +		return;
> +	case RATE_ADAPT_PAUSE:
> +		state->duplex = DUPLEX_FULL;
> +		break;
> +	case RATE_ADAPT_CRS:
> +		state->duplex = DUPLEX_HALF;
> +		break;
> +	case RATE_ADAPT_OPEN_LOOP:
> +		state->duplex = state->link_duplex;
> +		break;
> +	}
> +
> +	/* Use the max speed of the interface */
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_100BASEX:
> +	case PHY_INTERFACE_MODE_REVRMII:
> +	case PHY_INTERFACE_MODE_RMII:
> +	case PHY_INTERFACE_MODE_SMII:
> +	case PHY_INTERFACE_MODE_REVMII:
> +	case PHY_INTERFACE_MODE_MII:
> +		state->speed = SPEED_100;
> +		return;
> +
> +	case PHY_INTERFACE_MODE_TBI:
> +	case PHY_INTERFACE_MODE_MOCA:
> +	case PHY_INTERFACE_MODE_RTBI:
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +	case PHY_INTERFACE_MODE_1000BASEKX:
> +	case PHY_INTERFACE_MODE_TRGMII:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_GMII:
> +		state->speed = SPEED_1000;
> +		return;
> +
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		state->speed = SPEED_2500;
> +		return;
> +
> +	case PHY_INTERFACE_MODE_5GBASER:
> +		state->speed = SPEED_5000;
> +		return;
> +
> +	case PHY_INTERFACE_MODE_XGMII:
> +	case PHY_INTERFACE_MODE_RXAUI:
> +	case PHY_INTERFACE_MODE_XAUI:
> +	case PHY_INTERFACE_MODE_10GBASER:
> +	case PHY_INTERFACE_MODE_10GKR:
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		state->speed = SPEED_10000;
> +		return;
> +
> +	case PHY_INTERFACE_MODE_25GBASER:
> +		state->speed = SPEED_25000;
> +		return;
> +
> +	case PHY_INTERFACE_MODE_XLGMII:
> +		state->speed = SPEED_40000;
> +		return;
> +
> +	case PHY_INTERFACE_MODE_INTERNAL:
> +		state->speed = state->link_speed;
> +		return;
> +
> +	case PHY_INTERFACE_MODE_NA:
> +	case PHY_INTERFACE_MODE_MAX:
> +		state->speed = SPEED_UNKNOWN;
> +		return;
> +	}
> +
> +	WARN_ON(1);
>  }
>  
>  /**
> @@ -803,11 +880,12 @@ static void phylink_mac_config(struct phylink *pl,
>  			       const struct phylink_link_state *state)
>  {
>  	phylink_dbg(pl,
> -		    "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
> +		    "%s: mode=%s/%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
>  		    __func__, phylink_an_mode_str(pl->cur_link_an_mode),
>  		    phy_modes(state->interface),
>  		    phy_speed_to_str(state->speed),
>  		    phy_duplex_to_str(state->duplex),
> +		    phy_rate_adaptation_to_str(state->rate_adaptation),
>  		    __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
>  		    state->pause, state->link, state->an_enabled);
>  
> @@ -944,6 +1022,7 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
>  	linkmode_zero(state->lp_advertising);
>  	state->interface = pl->link_config.interface;
>  	state->an_enabled = pl->link_config.an_enabled;
> +	state->rate_adaptation = pl->link_config.rate_adaptation;
>  	if (state->an_enabled) {
>  		state->link_speed = SPEED_UNKNOWN;
>  		state->link_duplex = DUPLEX_UNKNOWN;
> @@ -968,8 +1047,10 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
>  	else
>  		state->link = 0;
>  
> -	state->link_speed = state->speed;
> -	state->link_duplex = state->duplex;
> +	if (state->rate_adaptation == RATE_ADAPT_NONE) {
> +		state->link_speed = state->speed;
> +		state->link_duplex = state->duplex;
> +	}

So we need to have every PCS driver be udpated to fill in link_speed
and link_duplex if rate_adaption != none.

There's got to be a better way - maybe what I suggested in the last
round of only doing the rate adaption thing in the link_up() functions,
since that seems to be the only real difference.

I'm not even sure we need to do that - in the "open loop" case, we
need to be passing the media speed to the MAC driver with the knowledge
that it should be increasing the IPG.

So, I'm thinking we don't want any of these changes, what we instead
should be doing is passing the media speed/duplex and the interface
speed/duplex to the PCS and MAC.

We can do that by storing the PHY rate adaption state, and processing
that in phylink_link_up().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
