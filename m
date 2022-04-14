Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8EE501A97
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 19:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344186AbiDNR6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 13:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242987AbiDNR6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 13:58:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C6EEBAE9;
        Thu, 14 Apr 2022 10:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aQRTF3v6WmLQmOeCEhYv0QQbxEyOXWbbjzXVmNY/wkY=; b=llHpHdqzvNcD5E/zBlEkbGwDwZ
        awyXGRCalKzGpXgpJTKnZ1Rx/jFaigc2ycwIal82CfULTfB8c8gFABKUaog+NQp4WzZii1IHVQvcW
        btE28fS7pwXTvi6nR1tRlX5C1gea8womMd8aK4vhZJrp6RJfTyCNZuCT5xsWLxk1EoBw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nf3hD-00FrML-U9; Thu, 14 Apr 2022 19:55:55 +0200
Date:   Thu, 14 Apr 2022 19:55:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Laurent Gonzales <laurent.gonzales@non.se.com>,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <YlhgK3sTKHU3CNUM@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-7-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414122250.158113-7-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 +static int a5psw_mdio_reset(struct mii_bus *bus)
> +{
> +	struct a5psw *a5psw = bus->priv;
> +	unsigned long rate;
> +	unsigned long div;
> +	u32 cfgstatus;
> +
> +	rate = clk_get_rate(a5psw->hclk);
> +	div = ((rate / a5psw->mdio_freq) / 2);
> +	if (div >= 511 || div <= 5) {
> +		dev_err(a5psw->dev, "MDIO clock div %ld out of range\n", div);
> +		return -ERANGE;
> +	}
> +
> +	cfgstatus = FIELD_PREP(A5PSW_MDIO_CFG_STATUS_CLKDIV, div);
> +
> +	a5psw_reg_writel(a5psw, A5PSW_MDIO_CFG_STATUS, cfgstatus);

I don't see anything here which does an actual reset. So i think this
function has the wrong name. Please also pass the frequency as a
parameter, because at a quick glance it was not easy to see where it
was used. There does not seem to be any need to store it in a5psw.

> +static int a5psw_probe_mdio(struct a5psw *a5psw)
> +{
> +	struct device *dev = a5psw->dev;
> +	struct device_node *mdio_node;
> +	struct mii_bus *bus;
> +	int err;
> +
> +	if (of_property_read_u32(dev->of_node, "clock-frequency",
> +				 &a5psw->mdio_freq))
> +		a5psw->mdio_freq = A5PSW_MDIO_DEF_FREQ;
> +
> +	bus = devm_mdiobus_alloc(dev);
> +	if (!bus)
> +		return -ENOMEM;
> +
> +	bus->name = "a5psw_mdio";
> +	bus->read = a5psw_mdio_read;
> +	bus->write = a5psw_mdio_write;
> +	bus->reset = a5psw_mdio_reset;

As far as i can see, the read and write functions don't support
C45. Please return -EOPNOTSUPP if they are passed C45 addresses.

     Andrew
