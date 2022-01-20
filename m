Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFAF494F83
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 14:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbiATNrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 08:47:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46274 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235845AbiATNrB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 08:47:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LI7fgGU1QLBmTbo6Itbou4oEcT/ffjAEXYDBbz7bC8o=; b=DcGAfY3n9u4WLa8D6DpfOrUvEA
        BWinE8CxJwNtOpCkJ0qNrH/j5cIt7/jIP/slGn/CFIBsWkB9yrPSoza2OPvy4fNXZmNa1q4mL6cgJ
        VI135fzyhLv7Px03eaHzpnh/9ryUvD89FDRrG2b4VfjKxwYl31R8UdrIuAXfIjRUAWXM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nAXmA-001zjh-Ij; Thu, 20 Jan 2022 14:46:54 +0100
Date:   Thu, 20 Jan 2022 14:46:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
Message-ID: <Yelnzrrd0a4Bl5AL@lunn.ch>
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 01:19:29PM +0800, Kai-Heng Feng wrote:
> BIOS on Dell Edge Gateway 3200 already makes its own phy LED setting, so
> instead of setting another value, keep it untouched and restore the saved
> value on system resume.

Please split this patch into two:

Don't touch the LEDs

Save and restore the LED configuration over suspend/resume.

> -static void marvell_config_led(struct phy_device *phydev)
> +static int marvell_find_led_config(struct phy_device *phydev)
>  {
> -	u16 def_config;
> -	int err;
> +	int def_config;
> +
> +	if (phydev->dev_flags & PHY_USE_FIRMWARE_LED) {
> +		def_config = phy_read_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL);
> +		return def_config < 0 ? -1 : def_config;

What about the other two registers which configure the LEDs?

Since you talked about suspend/resume, does this machine support WoL?
Is the BIOS configuring LED2 to be used as an interrupt when WoL is
enabled in the BIOS? Do you need to save/restore that configuration
over suspend/review? And prevent the driver from changing the
configuration?

> +static const struct dmi_system_id platform_flags[] = {
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell EMC"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Edge Gateway 3200"),
> +		},
> +		.driver_data = (void *)PHY_USE_FIRMWARE_LED,
> +	},

This needs a big fat warning, that it will affect all LEDs for PHYs
which linux is driving, on that machine. So PHYs on USB dongles, PHYs
in SFPs, PHYs on plugin PCIe card etc.

Have you talked with Dells Product Manager and do they understand the
implications of this? 

> +	{}
> +};
> +
>  /**
>   * phy_attach_direct - attach a network device to a given PHY device pointer
>   * @dev: network device to attach
> @@ -1363,6 +1379,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>  	struct mii_bus *bus = phydev->mdio.bus;
>  	struct device *d = &phydev->mdio.dev;
>  	struct module *ndev_owner = NULL;
> +	const struct dmi_system_id *dmi;
>  	bool using_genphy = false;
>  	int err;
>  
> @@ -1443,6 +1460,10 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>  			phydev_err(phydev, "error creating 'phy_standalone' sysfs entry\n");
>  	}
>  
> +	dmi = dmi_first_match(platform_flags);
> +	if (dmi)
> +		phydev->dev_flags |= (u32)dmi->driver_data;

Please us your new flag directly. We don't want this abused to pass
any old flag to the PHY.

> +
>  /**
>   * struct phy_device - An instance of a PHY
>   *
> @@ -663,6 +665,7 @@ struct phy_device {
>  
>  	struct phy_led_trigger *led_link_trigger;
>  #endif
> +	int led_config;

You cannot put this here because you don't know how many registers are
used to hold the configuration. Marvell has 3, other drivers can have
other numbers. The information needs to be saved into the drivers on
priv structure.

>  
>  	/*
>  	 * Interrupt number for this PHY
> @@ -776,6 +779,12 @@ struct phy_driver {
>  	 */
>  	int (*config_init)(struct phy_device *phydev);
>  
> +	/**
> +	 * @config_led: Called to config the PHY LED,
> +	 * Use the resume flag to indicate init or resume
> +	 */
> +	void (*config_led)(struct phy_device *phydev, bool resume);

I don't see any need for this.

  Andrew
