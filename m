Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC22D25B665
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 00:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgIBWUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 18:20:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgIBWUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 18:20:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDb7G-00Cwlz-8S; Thu, 03 Sep 2020 00:20:30 +0200
Date:   Thu, 3 Sep 2020 00:20:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, adam.rudzinski@arf.net.pl,
        m.felsch@pengutronix.de, hkallweit1@gmail.com,
        richard.leitner@skidata.com, zhengdejin5@gmail.com,
        devicetree@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        robh+dt@kernel.org
Subject: Re: [RFC net-next 2/2] net: phy: bcm7xxx: request and manage GPHY
 clock
Message-ID: <20200902222030.GJ3050651@lunn.ch>
References: <20200902213347.3177881-1-f.fainelli@gmail.com>
 <20200902213347.3177881-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902213347.3177881-3-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	priv->clk = devm_clk_get_optional(&phydev->mdio.dev, "sw_gphy");
> +	if (IS_ERR(priv->clk))
> +		return PTR_ERR(priv->clk);
> +
> +	/* To get there, the mdiobus registration logic already enabled our
> +	 * clock otherwise we would not have probed this device since we would
> +	 * not be able to read its ID. To avoid artificially bumping up the
> +	 * clock reference count, only do the clock enable from a phy_remove ->
> +	 * phy_probe path (driver unbind, then rebind).
> +	 */
> +	if (!__clk_is_enabled(priv->clk))
> +		ret = clk_prepare_enable(priv->clk);

This i don't get. The clock subsystem does reference counting. So what
i would expect to happen is that during scanning of the bus, phylib
enables the clock and keeps it enabled until after probe. To keep
things balanced, phylib would disable the clock after probe.

If the driver wants the clock enabled all the time, it can enable it
in the probe method. The common clock framework will then have two
reference counts for the clock, so that when the probe exists, and
phylib disables the clock, the CCF keeps the clock ticking. The PHY
driver can then disable the clock in .remove.

There are some PHYs which will enumerate with the clock disabled. They
only need it ticking for packet transfer. Such PHY drivers can enable
the clock only when needed in order to save some power when the
interface is administratively down.

	  Andrew
