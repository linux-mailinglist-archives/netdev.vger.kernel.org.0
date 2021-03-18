Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B847833FC96
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 02:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhCRBPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 21:15:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33670 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhCRBOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 21:14:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lMhFL-00BZEW-1J; Thu, 18 Mar 2021 02:14:43 +0100
Date:   Thu, 18 Mar 2021 02:14:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Liming Sun <limings@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v4] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <YFKpg+DHZKCiP9+v@lunn.ch>
References: <1615380399-31970-1-git-send-email-davthompson@nvidia.com>
 <YErPsvwjcmOMMIos@lunn.ch>
 <MN2PR12MB297560E219744B3B1E2A768FC76B9@MN2PR12MB2975.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB297560E219744B3B1E2A768FC76B9@MN2PR12MB2975.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +	if (device_property_read_u32(&pdev->dev, "version", &version)) {
> > > +		dev_err(&pdev->dev, "Version Info not found\n");
> > > +		return -EINVAL;
> > > +	}
> > 
> > Is this a device tree property? ACPI? If it is device tree property you need to
> > document the binding, Documentation/devicetree/bindinds/...
> > 
> 
> This driver gets its properties from an ACPI table, not from device tree.
> The "version" property is read from the ACPI table, and if an incompatible
> table version is found the driver does not load.  This logic allows the version
> of the driver and the version of the ACPI table to change and compatibility
> is ensured.  If there's a different/better way to do this, please let me know.

I tend to avoid ACPI. DT seems a better system. DT tries hard to not
break backwards compatibility. Hence it is not really versioned. The
fact you are versioning things and won't load if there is a version
mismatch suggests you don't think backward compatibility is that
important. I personally would not have a version, and promise to keep
backwards compatibility. The current properties you have seem simple
enough.

> 
> > > +
> > > +	if (version != (int)DRV_VERSION) {
> > > +		dev_err(&pdev->dev, "Version Mismatch. Expected %d
> > Returned %d\n",
> > > +			(int)DRV_VERSION, version);
> > > +		return -EINVAL;
> > > +	}
> > 
> > That is odd. Doubt odd. First of, why (int)1.19? Why not just set DRV_VERSION
> > to 1? This is the only place you use this, so the .19 seems pointless. Secondly,
> > what does this version in DT/ACPI actually represent? The hardware version?
> > Then you should be using a compatible string? Or read a hardware register which
> > tells you have hardware version.
> > 
> 
> The value of DRV_VERSION is 1.19 because it specifies the <major>.<minor>
> version of the driver.

Driver versions are pretty pointless. Don't you expect somebody to
back port this into a vendor kernel? Everything around it has
changed. What does this version then tell you? Nothing particularly
useful, since what you really want to know is the release tag in the
source tree, so you have the driver and everything around it you can
then debug.

> > > +
> > > +	err = device_property_read_u32(&pdev->dev, "phy-int-gpio",
> > &phy_int_gpio);
> > > +	if (err < 0)
> > > +		phy_int_gpio = MLXBF_GIGE_DEFAULT_PHY_INT_GPIO;
> > 
> > Again, this probably needs documenting. This is not how you do interrupts with
> > DT. I also don't think it is correct for ACPI, but i don't know ACPI.
> > 
> 
> Right, the "phy-int-gpio" is a property read from the ACPI table.
> Is there a convention for ACPI table use/documentation?

https://www.kernel.org/doc/html/latest/firmware-guide/acpi/gpio-properties.html

This seems to be the correct way to describe GPIOs in ACPI. But you
are using the GPIO as an interrupt sources. Either you need to get the
GPIO descriptor and then map it to an interrupt, or there might be
another way to describe interrupts in ACPI. I very much doubt
device_property_read_u32() is the correct way to do this, but as i
said, i try to avoid ACPI.
 
> > > +	phydev = phy_find_first(priv->mdiobus);
> > > +	if (!phydev) {
> > > +		mlxbf_gige_mdio_remove(priv);
> > > +		return -ENODEV;
> > > +	}
> > 
> > If you are using DT, please use a phandle to the device on the MDIO bus.
> > 
> 
> The code is not using DT.

Yes, you just have to hope the first device on the bus is the correct
device.

	Andrew
