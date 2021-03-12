Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA12D33837E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhCLCUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 21:20:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231591AbhCLCTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 21:19:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKXOk-00ASDr-PV; Fri, 12 Mar 2021 03:19:30 +0100
Date:   Fri, 12 Mar 2021 03:19:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        limings@nvidia.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v4] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <YErPsvwjcmOMMIos@lunn.ch>
References: <1615380399-31970-1-git-send-email-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615380399-31970-1-git-send-email-davthompson@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define DRV_VERSION 1.19

> +static int mlxbf_gige_probe(struct platform_device *pdev)
> +{
> +	unsigned int phy_int_gpio;
> +	struct phy_device *phydev;
> +	struct net_device *netdev;
> +	struct resource *mac_res;
> +	struct resource *llu_res;
> +	struct resource *plu_res;
> +	struct mlxbf_gige *priv;
> +	void __iomem *llu_base;
> +	void __iomem *plu_base;
> +	void __iomem *base;
> +	int addr, version;
> +	u64 control;
> +	int err = 0;
> +
> +	if (device_property_read_u32(&pdev->dev, "version", &version)) {
> +		dev_err(&pdev->dev, "Version Info not found\n");
> +		return -EINVAL;
> +	}

Is this a device tree property? ACPI? If it is device tree property
you need to document the binding, Documentation/devicetree/bindinds/...

> +
> +	if (version != (int)DRV_VERSION) {
> +		dev_err(&pdev->dev, "Version Mismatch. Expected %d Returned %d\n",
> +			(int)DRV_VERSION, version);
> +		return -EINVAL;
> +	}

That is odd. Doubt odd. First of, why (int)1.19? Why not just set
DRV_VERSION to 1? This is the only place you use this, so the .19
seems pointless. Secondly, what does this version in DT/ACPI actually
represent? The hardware version? Then you should be using a compatible
string? Or read a hardware register which tells you have hardware
version.

> +
> +	err = device_property_read_u32(&pdev->dev, "phy-int-gpio", &phy_int_gpio);
> +	if (err < 0)
> +		phy_int_gpio = MLXBF_GIGE_DEFAULT_PHY_INT_GPIO;

Again, this probably needs documenting. This is not how you do
interrupts with DT. I also don't think it is correct for ACPI, but i
don't know ACPI.

> +	phydev = phy_find_first(priv->mdiobus);
> +	if (!phydev) {
> +		mlxbf_gige_mdio_remove(priv);
> +		return -ENODEV;
> +	}

If you are using DT, please use a phandle to the device on the MDIO
bus.

> +	/* Sets netdev->phydev to phydev; which will eventually
> +	 * be used in ioctl calls.
> +	 * Cannot pass NULL handler.
> +	 */
> +	err = phy_connect_direct(netdev, phydev,
> +				 mlxbf_gige_adjust_link,
> +				 PHY_INTERFACE_MODE_GMII);

It does a lot more than just set netdev->phydev. I'm not sure this
comment has any real value.

	Andrew
