Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294822240A8
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 18:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgGQQeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 12:34:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41328 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbgGQQeo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 12:34:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jwTJp-005d3c-Q9; Fri, 17 Jul 2020 18:34:41 +0200
Date:   Fri, 17 Jul 2020 18:34:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Bruno Thomsen <bth@kamstrup.com>,
        Lars Alex Pedersen <laa@kamstrup.com>
Subject: Re: fec: micrel: Ethernet PHY type ID auto-detection issue
Message-ID: <20200717163441.GA1339445@lunn.ch>
References: <CAH+2xPCzrBgngz5cY9DDDjnFUBNa=NSH3VMchFcnoVbjSm3rEw@mail.gmail.com>
 <CAOMZO5DtYDomD8FDCZDwYCSr2AwNT81Ay4==aDxXyBxtyvPiJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5DtYDomD8FDCZDwYCSr2AwNT81Ay4==aDxXyBxtyvPiJA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 12:52:08PM -0300, Fabio Estevam wrote:
> Hi Bruno,

> > I have been having issues with Ethernet PHY type ID
> > auto-detection when changing from the deprecated fec
> > phy-reset-{gpios,duration,post-delay} properties to the
> > modern mdio reset-{assert-us,deassert-us,gpios}
> > properties in the device tree.

> > Kernel error messages (modem mdio reset):
> > mdio_bus 30be0000.ethernet-1: MDIO device at address 1 is missing.
> > fec 30be0000.ethernet eth0: Unable to connect to phy

It sounds like the PHY is not responding during scanning of the bus.

https://elixir.bootlin.com/linux/v5.8-rc4/source/drivers/of/of_mdio.c#L277

If you dig down the call chain:

https://elixir.bootlin.com/linux/v5.8-rc4/source/drivers/net/phy/phy_device.c#L778

This reads register 2 and 3 of the PHY to get its ID.

https://elixir.bootlin.com/linux/v5.8-rc4/source/drivers/net/phy/phy_device.c#L817

If the ID is mostly 0xff there is no device there.

So check the initial reset state of the PHY, and when is it taken out
of reset, and is the delay long enough for it to get itself together
and start answering requests.

   Andrew
