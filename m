Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72FE16B74D
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 02:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgBYBpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 20:45:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60836 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbgBYBpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 20:45:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DUOOeFia5Ij2c83y1NLw8MEtTRsgVwOpA+cJVz9zg3I=; b=yn59aePWZJpEYwiNIGPoO4HkLl
        Drsv+74wPPHFuvK0dzN6clqf8hJfznT1CE3Dx5WrZNjHsU5dtXwH0RH7ZUSg4JaUmm7tfFWH+9zmb
        M3RCvwUO1HGoJotuQARPUMLIdcryWbMAd1AGo2qTYqcgcHavuTAKZKkuoIVzacX0612M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6PHQ-0003fb-FX; Tue, 25 Feb 2020 02:45:00 +0100
Date:   Tue, 25 Feb 2020 02:45:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/2] net: mdio: add ipq8064 mdio driver
Message-ID: <20200225014500.GC9749@lunn.ch>
References: <20200224211035.16897-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224211035.16897-1-ansuelsmth@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int
> +ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
> +{
> +	struct ipq8064_mdio *priv = bus->priv;
> +	u32 miiaddr = MII_BUSY | MII_CLKRANGE_250_300M;
> +	u32 ret_val;
> +	int err;

Hi Ansuel

Reverse Christmas tree. priv needs to move down a line.

> +
> +	/* Reject clause 45 */
> +	if (reg_offset & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +
> +	miiaddr |= ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
> +		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
> +
> +	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> +	usleep_range(8, 10);
> +
> +	err = ipq8064_mdio_wait_busy(priv);
> +	if (err)
> +		return err;
> +
> +	regmap_read(priv->base, MII_DATA_REG_ADDR, &ret_val);
> +	return (int)ret_val;
> +}
> +
> +static int
> +ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
> +{
> +	struct ipq8064_mdio *priv = bus->priv;
> +	u32 miiaddr = MII_WRITE | MII_BUSY | MII_CLKRANGE_250_300M;

Same here.

> +static int
> +ipq8064_mdio_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct ipq8064_mdio *priv;
> +	struct mii_bus *bus;
> +	int ret;
> +
> +	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
> +	if (!bus)
> +		return -ENOMEM;
> +
> +	bus->name = "ipq8064_mdio_bus";
> +	bus->read = ipq8064_mdio_read;
> +	bus->write = ipq8064_mdio_write;
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev->dev));
> +	bus->parent = &pdev->dev;
> +
> +	priv = bus->priv;
> +	priv->base = syscon_node_to_regmap(np);
> +	if (IS_ERR(priv->base) && priv->base != ERR_PTR(-EPROBE_DEFER))
> +		priv->base = syscon_regmap_lookup_by_phandle(np, "master");

"master" is not documented in the binding. Do we really need two
different ways to get the base address?

	  Andrew
