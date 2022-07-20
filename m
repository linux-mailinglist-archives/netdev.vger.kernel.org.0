Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8357957B139
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 08:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiGTGtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 02:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiGTGoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 02:44:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A7D42ACE;
        Tue, 19 Jul 2022 23:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=buEbPj35VBOKwfMS/RY6ZEKeyl1ASTH12iRmqn5wlKI=; b=tAs8wmxKzaPfRWJEnOqN1t6ahZ
        D7QhCw4w8oRh1hNY3RPCkYfpOpyldLf2EI3TqEwoIQPVOHOxBM3AYw+40YJiu5exXIVCGHZk4AWdi
        5MWfHQz4yYLZCe3wRLixuMbKfKBhHCmiiui/tkWBFouUEaHa8QTIBKq3DMNJdmD+CrAdD1vDG5RVZ
        XbucAhRE8BOdAajR+S8lFPCZTjmaJfM8PpGkwvOMtQr+oNrgLR/OtoEiL8bmtQSQqT6KWrWLXAVoq
        bpjA9Bsb4qWUH2Z4lK4kO7YFa8bGzR97Kszey4V18OORYSpSZ2aUSM+b6nH/txhAC/tOWW+ZOpnBg
        f1dan0aA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33454)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oE3RD-0003mj-LK; Wed, 20 Jul 2022 07:44:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oE3R9-0003gE-F7; Wed, 20 Jul 2022 07:43:59 +0100
Date:   Wed, 20 Jul 2022 07:43:59 +0100
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
Subject: Re: [PATCH v2 06/11] net: phylink: Support differing link/interface
 speed/duplex
Message-ID: <YtekL4y/XKn1m/V4@shell.armlinux.org.uk>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-7-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719235002.1944800-7-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 07:49:56PM -0400, Sean Anderson wrote:
> This adds support for cases when the link speed or duplex differs from
> the speed or duplex of the phy interface mode. Such cases can occur when
> some kind of rate adaptation is occurring.
> 
> The following terms are used within this and the following patches. I
> do not believe the meaning of these terms are uncommon or surprising,
> but for maximum clarity I would like to be explicit:
> 
> - Phy interface mode: the protocol used to communicate between the MAC
>   or PCS (if used) and the phy. If no phy is in use, this is the same as
>   the link mode. Each phy interface mode supported by Linux is a member
>   of phy_interface_t.
> - Link mode: the protocol used to communicate between the local phy (or
>   PCS) and the remote phy (or PCS) over the physical medium. Each link
>   mode supported by Linux is a member of ethtool_link_mode_bit_indices.
> - Phy interface mode speed: the speed of unidirectional data transfer
>   over a phy interface mode, including encoding overhead, but excluding
>   protocol and flow-control overhead. The speed of a phy interface mode
>   may vary. For example, SGMII may have a speed of 10, 100, or 1000
>   Mbit/s.
> - Link mode speed: similarly, the speed of unidirectional data transfer
>   over a physical medium, including overhead, but excluding protocol and
>   flow-control overhead. The speed of a link mode is usually fixed, but
>   some exceptional link modes (such as 2BASE-TL) may vary their speed
>   depending on the medium characteristics.
> 
> Before this patch, phylink assumed that the link mode speed was the same
> as the phy interface mode speed. This is typically the case; however,
> some phys have the ability to adapt between differing link mode and phy
> interface mode speeds. To support these phys, this patch removes this
> assumption, and adds a separate variable for link speed. Additionally,
> to support rate adaptation, a MAC may need to have a certain duplex
> (such as half or full). This may be different from the link's duplex. To
> keep track of this distunction, this patch adds another variable to
> track link duplex.

I thought we had decided that using the term "link" in these new members
was a bad idea.

> @@ -925,12 +944,16 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
>  	linkmode_zero(state->lp_advertising);
>  	state->interface = pl->link_config.interface;
>  	state->an_enabled = pl->link_config.an_enabled;
> -	if  (state->an_enabled) {
> +	if (state->an_enabled) {
> +		state->link_speed = SPEED_UNKNOWN;
> +		state->link_duplex = DUPLEX_UNKNOWN;
>  		state->speed = SPEED_UNKNOWN;
>  		state->duplex = DUPLEX_UNKNOWN;
>  		state->pause = MLO_PAUSE_NONE;
>  	} else {
> -		state->speed =  pl->link_config.speed;
> +		state->link_speed = pl->link_config.link_speed;
> +		state->link_duplex = pl->link_config.link_duplex;
> +		state->speed = pl->link_config.speed;
>  		state->duplex = pl->link_config.duplex;
>  		state->pause = pl->link_config.pause;
>  	}
> @@ -944,6 +967,9 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
>  		pl->mac_ops->mac_pcs_get_state(pl->config, state);
>  	else
>  		state->link = 0;
> +
> +	state->link_speed = state->speed;
> +	state->link_duplex = state->duplex;

Why do you need to set link_speed and link_duple above if they're always
copied over here?

>  /* The fixed state is... fixed except for the link state,
> @@ -953,10 +979,17 @@ static void phylink_get_fixed_state(struct phylink *pl,
>  				    struct phylink_link_state *state)
>  {
>  	*state = pl->link_config;
> -	if (pl->config->get_fixed_state)
> +	if (pl->config->get_fixed_state) {
>  		pl->config->get_fixed_state(pl->config, state);
> -	else if (pl->link_gpio)
> +		/* FIXME: these should not be updated, but
> +		 * bcm_sf2_sw_fixed_state does it anyway
> +		 */
> +		state->link_speed = state->speed;
> +		state->link_duplex = state->duplex;
> +		phylink_state_fill_speed_duplex(state);

This looks weird. Why copy state->xxx to state->link_xxx and then copy
them back to state->xxx in a helper function?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
