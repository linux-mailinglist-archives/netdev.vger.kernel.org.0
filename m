Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340AF640ECC
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiLBTyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiLBTyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:54:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29078BEE0C;
        Fri,  2 Dec 2022 11:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=T2YfCnfEWemlLWCsHybL4TuoCsjshhXfCn1RZG9CK+Q=; b=s6xguxGgJR/gCcDIJPLArLDmO6
        T0pBwqISRqlZQNSKzQt9NhpCqBhQtQFB24VBbLWkeDLTZsT0iy5qAawp/LxQImG1/N6pRd9NHpkIK
        oQ2M8gNM7GpTy5vr/+sQlLD9ewoqO3d/5pH1gYKt9t7ZdG66UcqM180IMNEhZu15A7J1vvvz1U3N5
        /qvkspOTtVxROy/1J7LftPWFVjlmFHHkyWtmnQfPbRmiEqI7XMnrOx0ktPLrBWw23CIUGMKSC4T6A
        TOEXxe+62PvU0mfXnbGiUfrH44LB/yrEiRmNISfvF2SjdV1LbklvkkoFZW7IfwRHsLIN3TMwGOnCA
        JaDkAI9A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35540)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p1C7N-0004Wy-8Q; Fri, 02 Dec 2022 19:54:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p1C7L-0004f4-T9; Fri, 02 Dec 2022 19:54:39 +0000
Date:   Fri, 2 Dec 2022 19:54:39 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] dsa: lan9303: Move to PHYLINK
Message-ID: <Y4pX//cG2Hq8NvbM@shell.armlinux.org.uk>
References: <20221202191749.27437-1-jerry.ray@microchip.com>
 <20221202191749.27437-3-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202191749.27437-3-jerry.ray@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jerry,

On Fri, Dec 02, 2022 at 01:17:49PM -0600, Jerry Ray wrote:
> -static void lan9303_adjust_link(struct dsa_switch *ds, int port,
> -				struct phy_device *phydev)
> -{
> -	struct lan9303 *chip = ds->priv;
> -	int ctl;
> -
> -	if (!phy_is_pseudo_fixed_link(phydev))
> -		return;
> -
> -	ctl = lan9303_phy_read(ds, port, MII_BMCR);
> -
> -	ctl &= ~BMCR_ANENABLE;
> -
> -	if (phydev->speed == SPEED_100)
> -		ctl |= BMCR_SPEED100;
> -	else if (phydev->speed == SPEED_10)
> -		ctl &= ~BMCR_SPEED100;
> -	else
> -		dev_err(ds->dev, "unsupported speed: %d\n", phydev->speed);
> -
> -	if (phydev->duplex == DUPLEX_FULL)
> -		ctl |= BMCR_FULLDPLX;
> -	else
> -		ctl &= ~BMCR_FULLDPLX;
> -
> -	lan9303_phy_write(ds, port, MII_BMCR, ctl);
> -
> -	if (port == chip->phy_addr_base) {
> -		/* Virtual Phy: Remove Turbo 200Mbit mode */
> -		lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &ctl);
> -
> -		ctl &= ~LAN9303_VIRT_SPECIAL_TURBO;
> -		regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, ctl);
> -	}
> -}

Is this functionality no longer necessary? For example, I don't see
anywhere else in the driver that this turbo mode is disabled.

I'm guessing the above code writing MII_BMCR is to force the
configuration of integrated PHYs to be the fixed-link settings?
How is that dealt with after the removal of the above code?

> -
>  static int lan9303_port_enable(struct dsa_switch *ds, int port,
>  			       struct phy_device *phy)
>  {
> @@ -1279,6 +1243,41 @@ static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> +static void lan9303_phylink_get_caps(struct dsa_switch *ds, int port,
> +				     struct phylink_config *config)
> +{
> +	struct lan9303 *chip = ds->priv;
> +
> +	dev_dbg(chip->dev, "%s(%d) entered.", __func__, port);
> +
> +	config->mac_capabilities = MAC_10 | MAC_100 | MAC_ASYM_PAUSE |
> +				   MAC_SYM_PAUSE;
> +
> +	if (dsa_port_is_cpu(dsa_to_port(ds, port))) {
> +		/* cpu port */
> +		phy_interface_empty(config->supported_interfaces);

This should not be necessary - the supported_interfaces member should
already be zero.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
