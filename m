Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB33D18A927
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgCRXWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:22:16 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35024 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgCRXWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 19:22:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZTGgzmv1en6p1p0DLyxrQHO3W+VNWh3PFsOduvdmpx8=; b=MsdTTHp/hhdOKOI+75oPbq9pC
        Y1OGdLfJ0xwFsvkowI9y2PY+YYOuuNmXol42xOSSbLJ+0Aog9AwSIQnPgqw6F2FCyxBtIgai5cz4R
        YF/AcT+P8RXE5lAV4w1kpHqTjI2Q/T0RtZRzO5L3eu3EWcc33THFRHKHD1Uvfyy5KudV7EZ3+ze8Z
        pIhffSQMyoso28dU3osmOaV2dgJDaCz6VgeNIjR/QwciO342rGVZXUYzj4wjaTe/uA2hcZjivmTzn
        yMdRlkJ4WKg9n5zZdN6LKZy2teEuJl+nLUHabGPPU5OcdjwmgFfJ/GpooVROZuB+TfYLgGY1Fc23c
        +LaW+Px5Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:34142)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEi0i-0007LC-6u; Wed, 18 Mar 2020 23:22:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEi0d-0004Be-VA; Wed, 18 Mar 2020 23:21:59 +0000
Date:   Wed, 18 Mar 2020 23:21:59 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: add and use phy_check_downshift
Message-ID: <20200318232159.GA25745@shell.armlinux.org.uk>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
 <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 10:29:01PM +0100, Heiner Kallweit wrote:
> So far PHY drivers have to check whether a downshift occurred to be
> able to notify the user. To make life of drivers authors a little bit
> easier move the downshift notification to phylib. phy_check_downshift()
> compares the highest mutually advertised speed with the actual value
> of phydev->speed (typically read by the PHY driver from a
> vendor-specific register) to detect a downshift.

My personal position on this is that reporting a downshift will be
sporadic at best, even when the link has negotiated slower.

The reason for this is that either end can decide to downshift.  If
the remote partner downshifts, then the local side has no idea that
a downshift occurred, and can't report that the link was downshifted.

So, is it actually useful to report these events?

> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/phy-core.c | 33 +++++++++++++++++++++++++++++++++
>  drivers/net/phy/phy.c      |  1 +
>  include/linux/phy.h        |  1 +
>  3 files changed, 35 insertions(+)
> 
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index e083e7a76..8e861be73 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -329,6 +329,39 @@ void phy_resolve_aneg_linkmode(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL_GPL(phy_resolve_aneg_linkmode);
>  
> +/**
> + * phy_check_downshift - check whether downshift occurred
> + * @phydev: The phy_device struct
> + *
> + * Check whether a downshift to a lower speed occurred. If this should be the
> + * case warn the user.
> + */
> +bool phy_check_downshift(struct phy_device *phydev)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
> +	int i, speed = SPEED_UNKNOWN;
> +
> +	if (phydev->autoneg == AUTONEG_DISABLE)
> +		return false;
> +
> +	linkmode_and(common, phydev->lp_advertising, phydev->advertising);
> +
> +	for (i = 0; i < ARRAY_SIZE(settings); i++)
> +		if (test_bit(settings[i].bit, common)) {
> +			speed = settings[i].speed;
> +			break;
> +		}
> +
> +	if (phydev->speed == speed)
> +		return false;
> +
> +	phydev_warn(phydev, "Downshift occurred from negotiated speed %s to actual speed %s, check cabling!\n",
> +		    phy_speed_to_str(speed), phy_speed_to_str(phydev->speed));
> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(phy_check_downshift);
> +
>  static int phy_resolve_min_speed(struct phy_device *phydev, bool fdx_only)
>  {
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index d71212a41..067ff5fec 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -507,6 +507,7 @@ static int phy_check_link_status(struct phy_device *phydev)
>  		return err;
>  
>  	if (phydev->link && phydev->state != PHY_RUNNING) {
> +		phy_check_downshift(phydev);
>  		phydev->state = PHY_RUNNING;
>  		phy_link_up(phydev);
>  	} else if (!phydev->link && phydev->state != PHY_NOLINK) {
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index cb5a2182b..4962766b2 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -698,6 +698,7 @@ static inline bool phy_is_started(struct phy_device *phydev)
>  
>  void phy_resolve_aneg_pause(struct phy_device *phydev);
>  void phy_resolve_aneg_linkmode(struct phy_device *phydev);
> +bool phy_check_downshift(struct phy_device *phydev);
>  
>  /**
>   * phy_read - Convenience function for reading a given PHY register
> -- 
> 2.25.1
> 
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
