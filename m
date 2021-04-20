Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD08365949
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhDTMyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:54:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60074 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232342AbhDTMyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 08:54:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lYpsh-0007J1-Q3; Tue, 20 Apr 2021 14:53:31 +0200
Date:   Tue, 20 Apr 2021 14:53:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>
Subject: Re: [PATCH 3/3] net: ethernet: ixp4xx: Use OF MDIO bus registration
Message-ID: <YH7Oy4F37HsTZYij@lunn.ch>
References: <20210419225133.2005360-1-linus.walleij@linaro.org>
 <20210419225133.2005360-3-linus.walleij@linaro.org>
 <YH4yqLn6llQdLVax@lunn.ch>
 <CACRpkdb8L=V+=5XVSV_viC5dLcLPWH5s9ztuESXjyRBWJOu9iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb8L=V+=5XVSV_viC5dLcLPWH5s9ztuESXjyRBWJOu9iA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 10:44:16AM +0200, Linus Walleij wrote:
> On Tue, Apr 20, 2021 at 3:47 AM Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > > @@ -1381,25 +1382,12 @@ static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
> > >       /* NPE ID 0x00, 0x10, 0x20... */
> > >       plat->npe = (val << 4);
> > >
> > > -     phy_np = of_parse_phandle(np, "phy-handle", 0);
> > > -     if (phy_np) {
> > > -             ret = of_property_read_u32(phy_np, "reg", &val);
> > > -             if (ret) {
> > > -                     dev_err(dev, "cannot find phy reg\n");
> > > -                     return NULL;
> > > -             }
> > > -             of_node_put(phy_np);
> > > -     } else {
> > > -             dev_err(dev, "cannot find phy instance\n");
> > > -             val = 0;
> > > -     }
> > > -     plat->phy = val;
> > > -
> >
> > Isn't this code you just added in the previous patch?
> 
> Yep. It's by the token of "one technical step per patch"

I don't actually seeing it being a step, since it is actually broken
and of_phy_get_and_connect() does pretty much everything it should do,
which is what you replace it with.

It is a long time since i converted a platform_data driver to DT. But
i remember trying to fill in the platform_data structure from DT was
often the wrong way to do it. They contain different data, and you
cannot easily map one to the other. So you need to make bigger changes
to the probe function. You have two intermingled code paths, one
dealing with platform_data, and the other using DT.

I've not looked in detail, but i guess my first step would be, cleanly
register the MDIO bus. Second step would be to register the PHY. And
it might need some refactoring patches just to make it easier to
understand.

> > > -     snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
> > > -              mdio_bus->id, plat->phy);
> > > -     phydev = phy_connect(ndev, phy_id, &ixp4xx_adjust_link,
> > > -                          PHY_INTERFACE_MODE_MII);
> > > +     if (np) {
> > > +             phydev = of_phy_get_and_connect(ndev, np, ixp4xx_adjust_link);
> > > +     } else {
> > > +             snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
> > > +                      mdio_bus->id, plat->phy);
> >
> > mdiobus_get_phy() and phy_connect_direct() might be better.
> 
> Do you mean for the legacy code path (else clause), or the
> new code path with of_phy_get_and_connect() or both?
> 
> I tried not to change the legacy code in order to not introduce
> regressions, so if I change that I suppose it should be a
> separate patch.

Yes, the legacy code. You don't often see this string parsing
method. And since you have the bus, and the index, you can directly go
to the PHY avoiding it all. A separate patch would be better.

   Andrew
