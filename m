Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A924230D09
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbgG1PGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730505AbgG1PGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:06:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63D9C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 08:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hFJGt1UL4y8tF+Y977MR50gdbKJBBxtxS7HunpdtYtU=; b=BeLi/4lWbUY/hIPy4E/4Bb5xo
        cGhkR4rgTB+wkOkj/Kpi2foFcAWqci3MtMQoMqLILtMGuU2mNUYSx8e4NL5oXR9teeTD4lBYEovPW
        vD+hM2iDAnDN5a0RV+i/STQ4gE8yJwVYb1SaNbXexMuw+9wGVMHR77QYA5Xepp+tZFO1LEXc63JAO
        P9WEQMbqP3dj4Fn2Watcn4cYtlDoFizv+Nz83Y6uKI4ncDJOGkb249BJSa+89IBMQltOSmWruAyYK
        ++/BpzNlD1JxD7mc6kUOiAKYoua97+S7gNCBE7Xm59BAEz8IIGAVHtUo0uvVByDioqkdk36eVABUo
        lKWBIltwQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45276)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k0RBG-0004Oc-56; Tue, 28 Jul 2020 16:06:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k0RBD-0004kC-Cb; Tue, 28 Jul 2020 16:06:11 +0100
Date:   Tue, 28 Jul 2020 16:06:11 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com
Subject: Re: [PATCH net-next v4 1/5] net: phylink: add helper function to
 decode USXGMII word
Message-ID: <20200728150611.GO1551@shell.armlinux.org.uk>
References: <20200724080143.12909-1-ioana.ciornei@nxp.com>
 <20200724080143.12909-2-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724080143.12909-2-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 11:01:39AM +0300, Ioana Ciornei wrote:
> With the new addition of the USXGMII link partner ability constants we
> can now introduce a phylink helper that decodes the USXGMII word and
> populates the appropriate fields in the phylink_link_state structure
> based on them.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Looks good, thanks.

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

> ---
> Changes in v4:
>  - patch added
> 
>  drivers/net/phy/phylink.c | 43 +++++++++++++++++++++++++++++++++++++++
>  include/linux/phylink.h   |  3 +++
>  2 files changed, 46 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 32b4bd6a5b55..d7810c908bb3 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -2318,6 +2318,49 @@ static void phylink_decode_sgmii_word(struct phylink_link_state *state,
>  		state->duplex = DUPLEX_HALF;
>  }
>  
> +/**
> + * phylink_decode_usxgmii_word() - decode the USXGMII word from a MAC PCS
> + * @state: a pointer to a struct phylink_link_state.
> + * @lpa: a 16 bit value which stores the USXGMII auto-negotiation word
> + *
> + * Helper for MAC PCS supporting the USXGMII protocol and the auto-negotiation
> + * code word.  Decode the USXGMII code word and populate the corresponding fields
> + * (speed, duplex) into the phylink_link_state structure.
> + */
> +void phylink_decode_usxgmii_word(struct phylink_link_state *state,
> +				 uint16_t lpa)
> +{
> +	switch (lpa & MDIO_USXGMII_SPD_MASK) {
> +	case MDIO_USXGMII_10:
> +		state->speed = SPEED_10;
> +		break;
> +	case MDIO_USXGMII_100:
> +		state->speed = SPEED_100;
> +		break;
> +	case MDIO_USXGMII_1000:
> +		state->speed = SPEED_1000;
> +		break;
> +	case MDIO_USXGMII_2500:
> +		state->speed = SPEED_2500;
> +		break;
> +	case MDIO_USXGMII_5000:
> +		state->speed = SPEED_5000;
> +		break;
> +	case MDIO_USXGMII_10G:
> +		state->speed = SPEED_10000;
> +		break;
> +	default:
> +		state->link = false;
> +		return;
> +	}
> +
> +	if (lpa & MDIO_USXGMII_FULL_DUPLEX)
> +		state->duplex = DUPLEX_FULL;
> +	else
> +		state->duplex = DUPLEX_HALF;
> +}
> +EXPORT_SYMBOL_GPL(phylink_decode_usxgmii_word);
> +
>  /**
>   * phylink_mii_c22_pcs_get_state() - read the MAC PCS state
>   * @pcs: a pointer to a &struct mdio_device.
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index 1aad2aea4610..83fc149a7bd7 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -485,4 +485,7 @@ void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs);
>  
>  void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
>  				   struct phylink_link_state *state);
> +
> +void phylink_decode_usxgmii_word(struct phylink_link_state *state,
> +				 uint16_t lpa);
>  #endif
> -- 
> 2.25.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
