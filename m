Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2494363B5C5
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbiK1XXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiK1XXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:23:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3C7DFCE;
        Mon, 28 Nov 2022 15:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lBGNBrRxKEGZ085fldSHbll+54ktYNBZy8fzs9T2aOc=; b=XQb5jy7is03lw9m92hSma01us9
        nqU4g7+VML5CameXc+hrKUc3a708xyyS5a2DziYwQDMxBOGs5om802a8ehDDRhtbC5jdx5SYMtJ5E
        DbAxYpWvQq/hNR+jl0Gqlva8xjXrdy1WmM1IJW4sN9GUfT+1eQNtIssI0C9et1rEDm6ovqYa/Ie6W
        +Cwmbq3W1eKmDD1jUJ1f/KN9YesWKce1iT5iKkS42qPeRKvp80Z4Erv8hNUxZXbXNZd6ng75x83yo
        PGA0ErlssgYvskle0v1wsgz3q6Yh0YDaM2A/5KvyXcHlf6prHREpqq6xk3n7oN/+qZEJuXCpWg3du
        rWtfZW/g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35464)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oznSl-00009l-2e; Mon, 28 Nov 2022 23:22:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oznSh-0000xa-MG; Mon, 28 Nov 2022 23:22:55 +0000
Date:   Mon, 28 Nov 2022 23:22:55 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v2 2/2] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <Y4VCz2i+kkK0z+XY@shell.armlinux.org.uk>
References: <20221128195409.100873-1-sean.anderson@seco.com>
 <20221128195409.100873-2-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128195409.100873-2-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 02:54:09PM -0500, Sean Anderson wrote:
> When autonegotiation completes, the phy interface will be set based on
> the global config register for that speed. If the SERDES mode is set to
> something which the MAC does not support, then the link will not come
> up. To avoid this, validate each combination of interface speed and link
> speed which might be configured. This way, we ensure that we only
> consider rate adaptation in our advertisement when we can actually use
> it.
> 
> The API for get_rate_matching requires that PHY_INTERFACE_MODE_NA be
> handled properly. To do this, we adopt a structure similar to
> phylink_validate.

Note that this has all but gone away except for a few legacy cases with
the advent of the supported_interfaces bitmap.

Also note that phy_get_rate_matching() will not be called by phylink
with PHY_INTERFACE_MODE_NA since my recent commit (7642cc28fd37 "net:
phylink: fix PHY validation with rate adaption"), and phylink is
currently the only user of this interface.

> At the top-level, we either validate a particular
> interface speed or all of them. Below that, we validate each combination
> of serdes speed and link speed.
> 
> For some firmwares, not all speeds are supported. In this case, the
> global config register for that speed will be initialized to zero
> (indicating that rate adaptation is not supported). We can detect this
> by reading the PMA/PMD speed register to determine which speeds are
> supported. This register is read once in probe and cached for later.
> 
> Fixes: 3c42563b3041 ("net: phy: aquantia: Add support for rate matching")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> This commit should not get backported until it soaks in master for a
> while.

You will have to monitor the emails from stable to achieve that - as you
have a Fixes tag, that will trigger it to be picked up fairly quicky.

>  #define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
>  #define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
>  #define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
> +#define VEND1_GLOBAL_CFG_SERDES_MODE		GENMASK(2, 0)
> +#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI	0
> +#define VEND1_GLOBAL_CFG_SERDES_MODE_SGMII	3
> +#define VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII	4
> +#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI5G	6
> +#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI20G	7
>  
>  #define VEND1_GLOBAL_RSVD_STAT1			0xc885
>  #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
> @@ -173,6 +179,7 @@ static const struct aqr107_hw_stat aqr107_hw_stats[] = {
>  
>  struct aqr107_priv {
>  	u64 sgmii_stats[AQR107_SGMII_STAT_SZ];
> +	int supported_speeds;
>  };
>  
>  static int aqr107_get_sset_count(struct phy_device *phydev)
> @@ -675,13 +682,141 @@ static int aqr107_wait_processor_intensive_op(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +/**
> + * aqr107_rate_adapt_ok_one() - Validate rate adaptation for one configuration
> + * @phydev: The phy to act on
> + * @serdes_speed: The speed of the serdes (aka the phy interface)
> + * @link_speed: The speed of the link
> + *
> + * This function validates whether rate adaptation will work for a particular
> + * combination of @serdes_speed and @link_speed.
> + *
> + * Return: %true if the global config register for @link_speed is configured for
> + * rate adaptation, %true if @link_speed will not be advertised, %false
> + * otherwise.
> + */
> +static bool aqr107_rate_adapt_ok_one(struct phy_device *phydev, int serdes_speed,
> +				     int link_speed)
> +{
> +	struct aqr107_priv *priv = phydev->priv;
> +	int val, speed_bit;
> +	u32 reg;
> +
> +	phydev_dbg(phydev, "validating link_speed=%d serdes_speed=%d\n",
> +		   link_speed, serdes_speed);
> +
> +	switch (link_speed) {
> +	case SPEED_10000:
> +		reg = VEND1_GLOBAL_CFG_10G;
> +		speed_bit = MDIO_SPEED_10G;
> +		break;
> +	case SPEED_5000:
> +		reg = VEND1_GLOBAL_CFG_5G;
> +		speed_bit = MDIO_PCS_SPEED_5G;
> +		break;
> +	case SPEED_2500:
> +		reg = VEND1_GLOBAL_CFG_2_5G;
> +		speed_bit = MDIO_PCS_SPEED_2_5G;
> +		break;
> +	case SPEED_1000:
> +		reg = VEND1_GLOBAL_CFG_1G;
> +		speed_bit = MDIO_PMA_SPEED_1000;
> +		break;
> +	case SPEED_100:
> +		reg = VEND1_GLOBAL_CFG_100M;
> +		speed_bit = MDIO_PMA_SPEED_100;
> +		break;
> +	case SPEED_10:
> +		reg = VEND1_GLOBAL_CFG_10M;
> +		speed_bit = MDIO_PMA_SPEED_10;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return false;
> +	}
> +
> +	/* Vacuously OK, since we won't advertise it anyway */
> +	if (!(priv->supported_speeds & speed_bit))
> +		return true;

This doesn't make any sense. priv->supported_speeds is the set of speeds
read from the PMAPMD. The only bits that are valid for this are the
MDIO_PMA_SPEED_* definitions, but teh above switch makes use of the
MDIO_PCS_SPEED_* definitions. To see why this is wrong, look at these
two definitions:

#define MDIO_PMA_SPEED_10               0x0040  /* 10M capable */
#define MDIO_PCS_SPEED_2_5G             0x0040  /* 2.5G capable */

Note that they are the same value, yet above, you're testing for bit 6
being clear effectively for both 10M and 2.5G speeds. I suspect this
is *not* what you want.

MDIO_PMA_SPEED_* are only valid for the PMAPMD MMD (MMD 1).
MDIO_PCS_SPEED_* are only valid for the PCS MMD (MMD 3).

> +
> +	val = phy_read_mmd(phydev, MDIO_MMD_VEND1, reg);
> +	if (val < 0) {
> +		phydev_warn(phydev, "could not read register %x:%.04x (err = %d)\n",
> +			    MDIO_MMD_VEND1, reg, val);
> +		return false;
> +	}
> +
> +	phydev_dbg(phydev, "%x:%.04x = %.04x\n", MDIO_MMD_VEND1, reg, val);
> +	if (FIELD_GET(VEND1_GLOBAL_CFG_RATE_ADAPT, val) !=
> +		VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE)
> +		return false;
> +
> +	switch (FIELD_GET(VEND1_GLOBAL_CFG_SERDES_MODE, val)) {
> +	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI20G:
> +		return serdes_speed == SPEED_20000;
> +	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI:
> +		return serdes_speed == SPEED_10000;
> +	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI5G:
> +		return serdes_speed == SPEED_5000;
> +	case VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII:
> +		return serdes_speed == SPEED_2500;
> +	case VEND1_GLOBAL_CFG_SERDES_MODE_SGMII:
> +		return serdes_speed == SPEED_1000;
> +	default:
> +		return false;
> +	}
> +}
> +
> +/**
> + * aqr107_rate_adapt_ok() - Validate rate adaptation for an interface speed
> + * @phydev: The phy device
> + * @speed: The serdes (phy interface) speed
> + *
> + * This validates whether rate adaptation will work for a particular @speed.
> + * All link speeds less than or equal to @speed are validate to ensure they are
> + * configured properly.
> + *
> + * Return: %true if rate adaptation is supported for @speed, %false otherwise.
> + */
> +static bool aqr107_rate_adapt_ok(struct phy_device *phydev, int speed)
> +{
	static int speeds[] = {
		SPEED_10,
		SPEED_100,
		SPEED_1000,
		SPEED_2500,
		SPEED_5000,
		SPEED_10000,
	};
	int i;

	for (i = 0; i < ARRAY_SIZE(speeds) && speeds[i] <= speed; i++)
		if (!aqr107_rate_adapt_ok_one(phydev, speed, speeds[i]))
			return false;

	/* speed must be in speeds[] */
	if (i == ARRAY_SIZE(speeds) || speeds[i] != speed)
		return false;

	return true;

would be more concise code?

> +}
> +
>  static int aqr107_get_rate_matching(struct phy_device *phydev,
>  				    phy_interface_t iface)
>  {
> -	if (iface == PHY_INTERFACE_MODE_10GBASER ||
> -	    iface == PHY_INTERFACE_MODE_2500BASEX ||
> -	    iface == PHY_INTERFACE_MODE_NA)
> +	if (iface != PHY_INTERFACE_MODE_NA) {
> +		if (aqr107_rate_adapt_ok(phydev,
> +					 phy_interface_max_speed(iface)))
> +			return RATE_MATCH_PAUSE;
> +		else
> +			return RATE_MATCH_NONE;
> +	}
> +
> +	if (aqr107_rate_adapt_ok(phydev, SPEED_10000) ||
> +	    aqr107_rate_adapt_ok(phydev, SPEED_2500) ||
> +	    aqr107_rate_adapt_ok(phydev, SPEED_1000))
>  		return RATE_MATCH_PAUSE;
> +
>  	return RATE_MATCH_NONE;
>  }
>  
> @@ -711,10 +846,19 @@ static int aqr107_resume(struct phy_device *phydev)
>  
>  static int aqr107_probe(struct phy_device *phydev)
>  {
> -	phydev->priv = devm_kzalloc(&phydev->mdio.dev,
> -				    sizeof(struct aqr107_priv), GFP_KERNEL);
> -	if (!phydev->priv)
> +	struct aqr107_priv *priv;
> +
> +	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
>  		return -ENOMEM;
> +	phydev->priv = priv;
> +
> +	priv->supported_speeds = phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
> +					      MDIO_SPEED);
> +	if (priv->supported_speeds < 0) {

Given the above confusion about the MDIO_SPEED register, I'd suggest
this isn't simply named "supported_speeds" but "pmapmd_speeds" to
indicate that it's the pmapmd mmd speed register.

> +		phydev_err(phydev, "could not determine supported speeds\n");
> +		return priv->supported_speeds;
> +	};
>  
>  	return aqr_hwmon_probe(phydev);
>  }
> -- 
> 2.35.1.1320.gc452695387.dirty
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
