Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682793318F1
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 22:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhCHVA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 16:00:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46444 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCHVAm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 16:00:42 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lJMzV-009sh5-SP; Mon, 08 Mar 2021 22:00:37 +0100
Date:   Mon, 8 Mar 2021 22:00:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     jonas.gorski@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: mdio: Add BCM6368 MDIO mux bus controller
Message-ID: <YEaQdXwrmVekXp4G@lunn.ch>
References: <20210308184102.3921-1-noltari@gmail.com>
 <20210308184102.3921-3-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308184102.3921-3-noltari@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int bcm6368_mdiomux_probe(struct platform_device *pdev)
> +{
> +	struct bcm6368_mdiomux_desc *md;
> +	struct mii_bus *bus;
> +	struct resource *res;
> +	int rc;
> +
> +	md = devm_kzalloc(&pdev->dev, sizeof(*md), GFP_KERNEL);
> +	if (!md)
> +		return -ENOMEM;
> +	md->dev = &pdev->dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -EINVAL;
> +
> +	/* Just ioremap, as this MDIO block is usually integrated into an
> +	 * Ethernet MAC controller register range
> +	 */
> +	md->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> +	if (!md->base) {
> +		dev_err(&pdev->dev, "failed to ioremap register\n");
> +		return -ENOMEM;
> +	}
> +
> +	md->mii_bus = devm_mdiobus_alloc(&pdev->dev);
> +	if (!md->mii_bus) {
> +		dev_err(&pdev->dev, "mdiomux bus alloc failed\n");
> +		return ENOMEM;
> +	}
> +
> +	bus = md->mii_bus;
> +	bus->priv = md;
> +	bus->name = "BCM6368 MDIO mux bus";
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-%d", pdev->name, pdev->id);
> +	bus->parent = &pdev->dev;
> +	bus->read = bcm6368_mdiomux_read;
> +	bus->write = bcm6368_mdiomux_write;
> +	bus->phy_mask = 0x3f;
> +	bus->dev.of_node = pdev->dev.of_node;
> +
> +	rc = mdiobus_register(bus);
> +	if (rc) {
> +		dev_err(&pdev->dev, "mdiomux registration failed\n");
> +		return rc;
> +	}

So this is different to all the other mux drivers. Normally there is
an MDIO driver. And there is a mux driver. Two separate drivers. The
mux driver uses a phandle to reference the MDIO driver. Here we have
both in one driver.

Does this MDIO bus device exist as a standalone device? Without the
mux? If silicon does exist like that, having two separate drivers
would be better.

     Andrew
