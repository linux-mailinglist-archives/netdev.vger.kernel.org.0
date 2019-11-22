Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F501074B3
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 16:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKVPTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 10:19:18 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46860 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfKVPTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 10:19:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pMD8odOMs/KFtDYCt/r1bWIrjWCUci9BNgccikQ8rgA=; b=CSwvWC29apy9LZj3zuZ/HauHi
        DEWLcdRfndF30CkUuPi+8CPdS7sXNMW2VAoD8TIzERK89k7NGVdPiBuyH9jlnPH37S9QyszpJEzO8
        2fwuDcnYn1GcItlQlYJVMIkV7O1KkAkfVknZ6zAgQ8E/UqjPxZ9EJO0uUNIV1GOTc3GzUkGw/uVVo
        BbSBQiozYGj9Mp9FsDa371hh7D5nCkczw+CNO5jZtJpoErdFZQUTUQ6K7pkbIuiM31Ct0OJc/Jk1v
        lJsn6bJCvRsmYOJmHZS5Tfys4SsXe7uOxHv2gDJnMA0EIXQOj7hp+/NQPqfqnOnin4bJHxwc0Delb
        BNhF8EQ6A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43164)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iYAiF-0005ug-LO; Fri, 22 Nov 2019 15:19:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iYAiC-0003qg-W8; Fri, 22 Nov 2019 15:19:09 +0000
Date:   Fri, 22 Nov 2019 15:19:08 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC] net: phy: allow ethtool to set any supported fixed speed
Message-ID: <20191122151908.GK25745@shell.armlinux.org.uk>
References: <E1iYAhG-0005c2-8H@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iYAhG-0005c2-8H@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 03:18:10PM +0000, Russell King wrote:
> phylib restricts the fixed speed to 1000, 100 or 10Mbps, even if the
> PHY supports other speeds, or doesn't even support these speeds.
> Validate the fixed speed against the PHY capabilities, and return an
> error if we are unable to find a match.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> NOTE: is this correct behaviour - or should we do something like:
> 
> 	s = phy_lookup_setting(speed, duplex, phydev->support, false);
> 	if (!s)
> 		return -EINVAL;
> 
> 	phydev->speed = speed;
> 	phydev->duplex = duplex;

Sorry, that should've been:

	phydev->speed = s->speed;
	phydev->duplex = s->duplex;

> 
> IOW, set either an exact match, or a slower supported speed than was
> requested, or the slowest?  That's how phy_sanitize_settings() is
> implemented, which I replicated for phylink's ethtool implementation.
> 
> Another issue here is with the validation of the settings that the
> user passed in - this looks very racy.  Consider the following:
> 
> - another thread calls phy_ethtool_ksettings_set(), which sets
>   phydev->speed and phydev->duplex, and disables autoneg.
> - the phylib state machine is running, and overwrites the
>   phydev->speed and phydev->duplex settings
> - phy_ethtool_ksettings_set() then calls phy_start_aneg() which
>   sets the PHY up with the phylib-read settings rather than the
>   settings the user requested.
> 
> IMHO, phylib needs to keep the user requested settings separate from
> the readback state from the PHY.
> 
> Yet another issue is what to do when a PHY doesn't support disabled
> autoneg (or it's not known how to make it work) - the PHY driver
> doesn't get a look-in to validate the settings, phylib just expects
> every PHY out there to support it.  The best the PHY driver can do
> is to cause it's config_aneg() method to return -EINVAL, dropping
> the PHY state machine into PHY_HALTED mode via phy_error() - which
> will then provoke a nice big stack dump in phy_stop() when the
> network device is downed as phy_is_started() will return false.
> Clearly not a good user experience on any level (API or kernel
> behaviour.)
> 
>  drivers/net/phy/phy.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 9e431b9f9d87..75d11c48afce 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -270,31 +270,32 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
>  	linkmode_and(advertising, advertising, phydev->supported);
>  
>  	/* Verify the settings we care about. */
> -	if (autoneg != AUTONEG_ENABLE && autoneg != AUTONEG_DISABLE)
> -		return -EINVAL;
> +	switch (autoneg) {
> +	case AUTONEG_ENABLE:
> +		if (linkmode_empty(advertising))
> +			return -EINVAL;
> +		break;
> +	
> +	case AUTONEG_DISABLE:
> +		if (duplex != DUPLEX_HALF && duplex != DUPLEX_FULL)
> +			return -EINVAL;
>  
> -	if (autoneg == AUTONEG_ENABLE && linkmode_empty(advertising))
> -		return -EINVAL;
> +		if (!phy_lookup_setting(speed, duplex, phydev->supported, true))
> +			return -EINVAL;
> +		break;
>  
> -	if (autoneg == AUTONEG_DISABLE &&
> -	    ((speed != SPEED_1000 &&
> -	      speed != SPEED_100 &&
> -	      speed != SPEED_10) ||
> -	     (duplex != DUPLEX_HALF &&
> -	      duplex != DUPLEX_FULL)))
> +	default:
>  		return -EINVAL;
> +	}
>  
>  	phydev->autoneg = autoneg;
> -
> +	phydev->duplex = duplex;
>  	phydev->speed = speed;
>  
>  	linkmode_copy(phydev->advertising, advertising);
> -
>  	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
>  			 phydev->advertising, autoneg == AUTONEG_ENABLE);
>  
> -	phydev->duplex = duplex;
> -
>  	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
>  
>  	/* Restart the PHY */
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
