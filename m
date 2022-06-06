Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F76553EA01
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238895AbiFFNbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238867AbiFFNbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:31:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31C1190D35;
        Mon,  6 Jun 2022 06:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=O73kJ0AnT0Z8YM1gj4D+7aWy/bjgMjU/TGjAUbj6GKc=; b=fLcLgNpZBH/ZmSSttDHtE2xOyx
        2zhUSgJ1gMLo390BgcwFMa5B0tTZk5xfQxiCOfHBqc63JOjPuLNrxsOsTuI6/XiukLP13lVQZREz9
        Or1ub9HFXZeNI0axgKRLqbp4wD1ECZMxQB1PIPVqQZBjQ/oqk5iZ1ELT8MX2qvM7raBrBH6NmGUbU
        5ex+rEEbWy3NBlu7eMLQ2lIlY15A5wN3d1SnxHoxge+idOXDrjLvjfxVhzBvJNhbR62cEp/X+5U25
        QTE7yt8Dh8vA7kEB+vP/PHacclrWLHNFc41gguNvQrQ6TNSxHdJy47RtTUyiA6LImlduNe5YPAz1p
        BLzEQbIw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60970)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nyCpD-00023V-Ku; Mon, 06 Jun 2022 14:31:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nyCpA-0008GJ-Me; Mon, 06 Jun 2022 14:31:16 +0100
Date:   Mon, 6 Jun 2022 14:31:16 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     luizluca@gmail.com, Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: realtek: rtl8365mb: fix GMII caps for
 ports with internal PHY
Message-ID: <Yp4BpJkZx4szsLfm@shell.armlinux.org.uk>
References: <20220606130130.2894410-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220606130130.2894410-1-alvin@pqrs.dk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 06, 2022 at 03:01:30PM +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> phylib defaults to GMII when no phy-mode or phy-connection-type property
> is specified in a DSA port node.
> 
> Commit a5dba0f207e5 ("net: dsa: rtl8365mb: add GMII as user port mode")
> introduced implicit support for GMII mode on ports with internal PHY to
> allow a PHY connection for device trees where the phy-mode is not
> explicitly set to "internal".
> 
> Commit 6ff6064605e9 ("net: dsa: realtek: convert to phylink_generic_validate()")
> then broke this behaviour by discarding the usage of
> rtl8365mb_phy_mode_supported() - where this GMII support was indicated -
> while switching to the new .phylink_get_caps API.
> 
> With the new API, rtl8365mb_phy_mode_supported() is no longer needed.
> Remove it altogether and add back the GMII capability - this time to
> rtl8365mb_phylink_get_caps() - so that the above default behaviour works
> for ports with internal PHY again.

Oops - I guess this has been caused by the delay between my patch being
initially prepared, it sitting around in my tree for many months while
other patches get merged, and it eventually seeing the light of day.

Sorry about that.

> Fixes: 6ff6064605e9 ("net: dsa: realtek: convert to phylink_generic_validate()")
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---
> 
> Luiz, Russel:
> 
> Commit a5dba0f207e5 ought to have had a Fixes: tag I think, because it
> claims to have been fixing a regression in the net-next tree - is that
> right? I seem to have missed both referenced commits when they were
> posted and never hit this issue personally. I only found things now
> during some other refactoring and the test for GMII looked weird to me
> so I went and investigated.
> 
> Could you please help me identify that Fixes: tag? Just for my own
> understanding of what caused this added requirement for GMII on ports
> with internal PHY.

I have absolutely no idea. I don't think any "requirement" has ever been
added - phylib has always defaulted to GMII, so as the driver stood when
it was first submitted on Oct 18 2021, I don't see how it could have
worked, unless the DT it was being tested with specified a phy-mode of
"internal". As you were the one who submitted it, you would have a
better idea.

The only suggestion I have is to bisect to find out exactly what caused
the GMII vs INTERNAL issue to crop up.

> 
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 38 +++++++----------------------
>  1 file changed, 9 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> index 3bb42a9f236d..769f672e9128 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -955,35 +955,21 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
>  	return 0;
>  }
>  
> -static bool rtl8365mb_phy_mode_supported(struct dsa_switch *ds, int port,
> -					 phy_interface_t interface)
> -{
> -	int ext_int;
> -
> -	ext_int = rtl8365mb_extint_port_map[port];
> -
> -	if (ext_int < 0 &&
> -	    (interface == PHY_INTERFACE_MODE_NA ||
> -	     interface == PHY_INTERFACE_MODE_INTERNAL ||
> -	     interface == PHY_INTERFACE_MODE_GMII))
> -		/* Internal PHY */
> -		return true;
> -	else if ((ext_int >= 1) &&
> -		 phy_interface_mode_is_rgmii(interface))
> -		/* Extension MAC */
> -		return true;
> -
> -	return false;
> -}
> -
>  static void rtl8365mb_phylink_get_caps(struct dsa_switch *ds, int port,
>  				       struct phylink_config *config)
>  {
> -	if (dsa_is_user_port(ds, port))
> +	if (dsa_is_user_port(ds, port)) {

Given the updates to rtl8365mb_phy_mode_supported(), this misses out on
the check of rtl8365mb_extint_port_map[port] introduced in commit
6147631c079f ("net: dsa: realtek: rtl8365mb: allow non-cpu extint
ports").

>  		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
>  			  config->supported_interfaces);
> -	else if (dsa_is_cpu_port(ds, port))
> +
> +		/* GMII is the default interface mode for phylib, so
> +		 * we have to support it for ports with integrated PHY.
> +		 */
> +		__set_bit(PHY_INTERFACE_MODE_GMII,
> +			  config->supported_interfaces);
> +	} else if (dsa_is_cpu_port(ds, port)) {

This test also needs to be updated.

Not sure what rtl8365mb_extint_port_map[port] == 0 is supposed to
signify - maybe port unusable? Looks that way to me.

>  		phy_interface_set_rgmii(config->supported_interfaces);
> +	}
>  
>  	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
>  				   MAC_10 | MAC_100 | MAC_1000FD;
> @@ -996,12 +982,6 @@ static void rtl8365mb_phylink_mac_config(struct dsa_switch *ds, int port,
>  	struct realtek_priv *priv = ds->priv;
>  	int ret;
>  
> -	if (!rtl8365mb_phy_mode_supported(ds, port, state->interface)) {
> -		dev_err(priv->dev, "phy mode %s is unsupported on port %d\n",
> -			phy_modes(state->interface), port);
> -		return;
> -	}
> -
>  	if (mode != MLO_AN_PHY && mode != MLO_AN_FIXED) {
>  		dev_err(priv->dev,
>  			"port %d supports only conventional PHY or fixed-link\n",
> -- 
> 2.36.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
