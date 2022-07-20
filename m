Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E2E57B164
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbiGTHIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiGTHIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:08:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAB93F30F;
        Wed, 20 Jul 2022 00:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GFX+qSyVeGJnPVlu5lo+Bgmtg0MaLj2TqF38/Ct5tNA=; b=hNvfOTvG6FoWkG+lboFrHiAaYQ
        kHgOncxnTSe/zflov0BSxv+GS5X8WDKJXLy8pW+7Ecz2AFsmxWkUE7OyZDag7nC39zOo+ANttPoLA
        RKZZqkon2En7qRRSzYeC0EC87wvxUas48fROIhsQ2Afqq+Hi/n/bTaPsHEp6LXOv1z3KuOwlW3Cc7
        Fq3/Loa77YGhOOKEPOMXOBD3cFEOLGM0nPPsFrZWAiEhLBOR44Uj+l988zIFJE2qGA5AiMYHxvpXp
        i/3IACwwXv+y0vXpgViI6GVYYdTwBRtPMKwoVrE0UKHabxYJtH2aF6wlCfXk5BSQcL/Sk7yWJVwTL
        TKjIMC2A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33458)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oE3oi-0003oL-Bw; Wed, 20 Jul 2022 08:08:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oE3og-0003gm-Uu; Wed, 20 Jul 2022 08:08:18 +0100
Date:   Wed, 20 Jul 2022 08:08:18 +0100
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
Subject: Re: [PATCH v2 08/11] net: phylink: Adjust advertisement based on
 rate adaptation
Message-ID: <Ytep4isHcwFM7Ctc@shell.armlinux.org.uk>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-9-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719235002.1944800-9-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 07:49:58PM -0400, Sean Anderson wrote:
> +static int phylink_caps_to_speed(unsigned long caps)
> +{
> +	unsigned int max_cap = __fls(caps);
> +
> +	if (max_cap == __fls(MAC_10HD) || max_cap == __fls(MAC_10FD))
> +		return SPEED_10;
> +	if (max_cap == __fls(MAC_100HD) || max_cap == __fls(MAC_100FD))
> +		return SPEED_100;
> +	if (max_cap == __fls(MAC_1000HD) || max_cap == __fls(MAC_1000FD))
> +		return SPEED_1000;
> +	if (max_cap == __fls(MAC_2500FD))
> +		return SPEED_2500;
> +	if (max_cap == __fls(MAC_5000FD))
> +		return SPEED_5000;
> +	if (max_cap == __fls(MAC_10000FD))
> +		return SPEED_10000;
> +	if (max_cap == __fls(MAC_20000FD))
> +		return SPEED_20000;
> +	if (max_cap == __fls(MAC_25000FD))
> +		return SPEED_25000;
> +	if (max_cap == __fls(MAC_40000FD))
> +		return SPEED_40000;
> +	if (max_cap == __fls(MAC_50000FD))
> +		return SPEED_50000;
> +	if (max_cap == __fls(MAC_56000FD))
> +		return SPEED_56000;
> +	if (max_cap == __fls(MAC_100000FD))
> +		return SPEED_100000;
> +	if (max_cap == __fls(MAC_200000FD))
> +		return SPEED_200000;
> +	if (max_cap == __fls(MAC_400000FD))
> +		return SPEED_400000;
> +	return SPEED_UNKNOWN;
> +}

One of my recent patches introduced "phylink_caps_params" table into
the DSA code (which isn't merged) but it's about converting the caps
into the SPEED_* and DUPLEX_*. This is doing more or less the same
7thing but with a priority for speed rather than duplex. The question
about whether it should be this way for the DSA case or whether speed
should take priority was totally ignored by all reviewers of the code
despite being explicitly asked.

Maybe this could be reused here rather than having similar code.

> @@ -482,7 +529,39 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
>  		break;
>  	}
>  
> -	return caps & mac_capabilities;
> +	switch (rate_adaptation) {
> +	case RATE_ADAPT_NONE:
> +		break;
> +	case RATE_ADAPT_PAUSE: {
> +		/* The MAC must support asymmetric pause towards the local
> +		 * device for this. We could allow just symmetric pause, but
> +		 * then we might have to renegotiate if the link partner
> +		 * doesn't support pause.

Why do we need to renegotiate, and what would this achieve? The link
partner isn't going to say "oh yes I do support pause after all",
and in any case this function is working out what the capabilities
of the system is prior to bringing anything up.

All that we need to know here is whether the MAC supports receiving
pause frames from the PHY - if it doesn't, then the MAC is
incompatible with the PHY using rate adaption.

> +		 */
> +		if (!(mac_capabilities & MAC_SYM_PAUSE) ||
> +		    !(mac_capabilities & MAC_ASYM_PAUSE))
> +			break;
> +
> +		/* Can't adapt if the MAC doesn't support the interface's max
> +		 * speed
> +		 */
> +		if (state.speed != phylink_caps_to_speed(mac_capabilities))
> +			break;

I'm not sure this is the right way to check. If the MAC supports e.g.
10G, 1G, 100M and 10M, but we have a PHY operating in 1000base-X mode
to the PCS/MAC and is using rate adaption, then phylink_caps_to_speed()
will return 10G, but state.speed will be 1G.

Don't we instead want to check whether the MAC capabilities has the FD
bit corresponding to state.speed set?

> +
> +		adapted_caps = GENMASK(__fls(caps), __fls(MAC_10HD));
> +		/* We can't use pause frames in half-duplex mode */
> +		adapted_caps &= ~(MAC_1000HD | MAC_100HD | MAC_10HD);

Have you checked the PHY documentation to see what the behaviour is
in rate adaption mode with pause frames and it negotiates HD on the
media side? Does it handle the HD issue internally?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
