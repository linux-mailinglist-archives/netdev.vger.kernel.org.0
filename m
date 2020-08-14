Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DB5244A4D
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgHNNS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:18:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53706 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgHNNS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 09:18:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k6Zb5-009OOp-E8; Fri, 14 Aug 2020 15:18:15 +0200
Date:   Fri, 14 Aug 2020 15:18:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     Jonathan McDowell <noodles@earth.li>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v4 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200814131815.GA2238071@lunn.ch>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-2-vadym.kochan@plvision.eu>
 <20200813080322.GH21409@earth.li>
 <20200814082054.GD17795@plvision.eu>
 <20200814120536.GA26106@earth.li>
 <20200814122744.GF17795@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814122744.GF17795@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Currently 
> > > 
> > >     compatible = "marvell,prestera"
> > > 
> > > is used as default, so may be
> > > 
> > > you mean to support few matching including particular silicon too, like ?
> > > 
> > > 
> > >     compatible = "marvell,prestera"
> > >     compatible = "marvell,prestera-ac3x"
> > > 
> > > Would you please give an example ?
> > 
> > AFAICT "Prestera" is the general name for the Marvell
> > enterprise/data-centre silicon, comparable to the "LinkStreet"
> > designation for their lower end switching. The mv88e* drivers do not
> > mention LinkStreet in their compatible strings at all, choosing instead
> > to refer to chip IDs (I see mv88e6085, mv88e6190 + mv88e6250).
> > 
> > I do not have enough familiarity with the Prestera range to be able to
> > tell what commonality there is between the different versions (it
> > appears you need an NDA to get hold of the programming references), but
> > even just looking at your driver and the vendor code for the BobCat it
> > seems that AlleyCat3 uses an extended DSA header format, and requires a
> > firmware with message based access, in comparison to the BobCat which
> > uses register poking.
> > 
> > Based on that I'd recommend not using the bare "marvell,prestera"
> > compatible string, but instead something more specific.
> > "marvell,prestera-ac3x" seems like a suitable choice, assuming that's
> > how these chips are named/generally referred to.
> > 
> > Also I'd expand your Kconfig information to actually include "Marvell
> > Prestera 98DX326x" as that's the only supported chip range at present.
> > 
> 
> Yes, Prestera covers more range of devices. But it is planning to cover
> other devices too, and currently there is no device-specific DTS
> properties which are used in this version, but only the generic one -
> since only the MAC address node.
> 
> I mean that if there will be other Prestera devices supported then it
> will require to extend the DTS matching string in the driver just to
> support the same generic DTS properties for new device.
> 
> Anyway I will rise and discuss this question.

Hi Vadym

Lets start with how mv88e6xxx does this. The switches have ID
registers. Once you have read the ID registers, you know what device
you have, and you can select device specific code as needed. However,
these ID registers are in three different locations, depending on the
chip family. So the compatible string is all about where to read the
ID from, not about what specific chip is. So most device tree bindings
say "marvell,mv88e6085", but the 6390 family use "marvell,mv88e6190"
for example.

This naming scheme is actually odd compared to others. And that
oddness causes confusion. But it avoids a few problems. If you have
per chip compatible strings, what do you do when it conflicts with the
ID registers. If from day 1 you validate the compatible string against
the ID register and fail the probe if it is incorrect, you are
O.K. But if you decide to add this validation later, you are going to
find a number of device tree blobs which have the wrong compatible
string. Do you fail the probe on boards which have worked?

So what to do with this driver?

Does the prestera have ID registers? Are you using them in the driver?

Marvell is not particularly good at backwards compatibility. Does your
compatible string give you enough wiggle room you can easily introduce
another compatible string in order to find the ID registers when they
move?

	Andrew
