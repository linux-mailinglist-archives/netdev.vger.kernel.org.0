Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FDF229927
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 15:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgGVN0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 09:26:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49076 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgGVN0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 09:26:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jyEl6-006Ksf-De; Wed, 22 Jul 2020 15:26:08 +0200
Date:   Wed, 22 Jul 2020 15:26:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bruno Thomsen <bth@kamstrup.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        "bruno.thomsen@gmail.com" <bruno.thomsen@gmail.com>
Subject: Re: fec: micrel: Ethernet PHY type ID auto-detection issue
Message-ID: <20200722132608.GX1339445@lunn.ch>
References: <CAH+2xPCzrBgngz5cY9DDDjnFUBNa=NSH3VMchFcnoVbjSm3rEw@mail.gmail.com>
 <CAOMZO5DtYDomD8FDCZDwYCSr2AwNT81Ay4==aDxXyBxtyvPiJA@mail.gmail.com>
 <20200717163441.GA1339445@lunn.ch>
 <AM0PR04MB697747DD5CFED332E6729122DC780@AM0PR04MB6977.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB697747DD5CFED332E6729122DC780@AM0PR04MB6977.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bruno

Is it held in reset, and the reset is released, or is the reset line
toggled active and then inactive?

> > void mdio_device_reset(struct mdio_device *mdiodev, int value)
> > {
> > 	unsigned int d;
> > 
> > 	......
> > 
> > 	d = value ? mdiodev->reset_assert_delay : mdiodev->reset_deassert_delay;
> > 	if (d)
> > 		usleep_range(d, d + max_t(unsigned int, d / 10, 100));
> 
> This is not the recommended way of sleeping if d > 20ms.
> 
> https://www.kernel.org/doc/Documentation/timers/timers-howto.txt
> 
> The deprecated fec code handles this correctly.
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/freescale/fec_main.c#L3381
> 
> if (d)
> 	if (d > 20000)
> 		msleep(d / 1000);
> 	else
> 		usleep_range(d, d + max_t(unsigned int, d / 10, 100));

Patch welcome.

> Micrel recommended reset circuit has a deassert tau of 100ms, e.g. 10k * 10uF.
> So to be sure the signal is deasserted 5 * tau or more, and this brings the value
> up in the 500-1000ms range depending on component tolerances and design
> margin.
> 
> See figure 22 in pdf for reset circuit.
> http://ww1.microchip.com/downloads/en/devicedoc/ksz8081mnx-rnb.pdf
> 
> So my current conclusion is that using generic mdio phy handling does
> not work with Micrel PHYs unless 3 issues has been resolved.
> - Reset PHY before auto type detection.

This has been raised recently. Look back in the mail archive about a
month. For GPIOs this is easier to solve. But regulators pose a
problem.

Part of the problem is the history of this code. It originated from a
PHY which needed to be reset after probe and configuration to make its
clock stable, if i remember correctly. So the PHY would already probe,
without the reset. Something similar was needed for another PHY so the
code got pulled out of the driver and into the PHY core. But the
assumption remained, the PHY will probe, the reset is used after the
probe. This code now needs to be made more generic.

There is one other option, depending on your board design. The PHY
core supports two different resets. There is a per PHY reset, which is
what you are using. And then there is a reset for all devices on the
bus. That is used when multiple PHYs are connected to one reset GPIO.
You might be able to use that reset instead. But you might need to fix
up the sleep code in that case as well.

	Andrew
