Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE895210C0F
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbgGANZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:25:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41412 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728941AbgGANZH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 09:25:07 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jqcjO-0039OF-3I; Wed, 01 Jul 2020 15:24:54 +0200
Date:   Wed, 1 Jul 2020 15:24:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux.cj@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 1/3] net: phy: introduce find_phy_device()
Message-ID: <20200701132454.GF718441@lunn.ch>
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
 <20200701061233.31120-2-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701061233.31120-2-calvin.johnson@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct phy_device *find_phy_device(struct fwnode_handle *fwnode)

We should consider the naming convention. All phylib phy functions
start with phy_. We already have phy_find_first(), so maybe
phy_find_by_fwnode() to follow the pattern?

> +{
> +	struct fwnode_handle *fwnode_mdio;
> +	struct platform_device *pdev;
> +	struct mii_bus *mdio;
> +	struct device *dev;
> +	int addr;
> +	int err;
> +
> +	fwnode_mdio = fwnode_find_reference(fwnode, "mdio-handle", 0);
> +	dev = bus_find_device_by_fwnode(&platform_bus_type, fwnode_mdio);
> +	if (IS_ERR_OR_NULL(dev))
> +		return NULL;
> +	pdev =  to_platform_device(dev);
> +	mdio = platform_get_drvdata(pdev);

That is a big assumption to make. Please take a look at the
class_find_device_by_*() functions, as used by of_mdio_find_bus(),
mdio_find_bus(), etc.

	Andrew
