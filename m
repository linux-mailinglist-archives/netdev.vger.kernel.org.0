Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC353DF08D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbhHCOoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:44:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234360AbhHCOnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 10:43:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ACG/s8bQyXMAoKivsxoVT6bV/5aODUI1FE4W/+TE7Po=; b=u9tMLfCgSHBBxy+9+7rKPi9g/W
        TOqN+109lJMs5yOmt1Hj3kMEm+PXC+li+8Imm24m2ctMG+Iy2LJO4x5WbRxYmSjgJiFQprP1KOCC5
        SbDmI7fxD1lWXo3oBT41FaNra1U10i5h1k2RQMssR5r/AUFXQHw+5OG9su517YxokOIs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAvdQ-00Fyig-Vw; Tue, 03 Aug 2021 16:43:12 +0200
Date:   Tue, 3 Aug 2021 16:43:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <YQlWAHSTQ4K3/zet@lunn.ch>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
 <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <YQXJHA+z+hXjxe6+@lunn.ch>
 <20210802213353.qu5j3gn4753xlj43@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802213353.qu5j3gn4753xlj43@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 12:33:53AM +0300, Vladimir Oltean wrote:
> On Sun, Aug 01, 2021 at 12:05:16AM +0200, Andrew Lunn wrote:
> > > So you support both the cases where an internal PHY is described using
> > > OF bindings, and where the internal PHY is implicitly accessed using the
> > > slave_mii_bus of the switch, at a PHY address equal to the port number,
> > > and with no phy-handle or fixed-link device tree property for that port?
> > > 
> > > Do you need both alternatives? The first is already more flexible than
> > > the second.
> > 
> > The first is also much more verbose in DT, and the second generally
> > just works without any DT. What can be tricky with the second is
> > getting PHY interrupts to work, but it is possible, the mv88e6xxx does
> > it.
> 
> - The explicit phy-handle is more verbose as far as the DT description
>   goes for one particular use case of indirect internal PHY access, but
>   it also leads to less complex code (more uniform with other usage
>   patterns in the kernel). What is tricky with an implicit phy-handle is
>   trivial without it. This makes a difference with DM_DSA in U-Boot,
>   where I would really like to avoid bloating the code and just support
>   2 options for a DSA switch port: either a phy-handle or a fixed-link.
>   These two are already "Turing-complete" (they can describe any system)
>   so I only see the implicit phy-handle as a helping hand for a few lazy
>   DT writers. Since I have been pushing back that we shouldn't bloat
>   U-Boot with implicit phy-handle logic when it doesn't give a concrete
>   benefit, and have gotten a push back in return that Linux does allow
>   it and it would be desirable for one DT binding to cover all, I now
>   need to promote the more generic approach for Linux going forward too.
> 
> - If the switch has the ability for its internal PHYs to be accessed
>   directly over MDIO pins instead of using indirect SPI transfers, using
>   a phy-handle is a generic way to handle both cases, while the implicit
>   phy-handle does not give you that option.
> 
> - If there is complex pinmuxing in the SoC and one port can either be
>   connected to an internal 100base-T1 or to a 100base-TX PHY, and this
>   is not detectable by software, this cannot be dealt with using an
>   implicit phy-handle if the 100base-T1 and 100base-TX PHYs are not at
>   the same address.
> 
> - In general, if the internal PHYs are not at an MDIO address equal to
>   the port number, this cannot be dealt with using the implicit
>   phy-handle method.

There are good reasons to use an explicit phy-handle, and i would
never block such code. However, implicit is historically how it was
done. There are many DT blobs which assume it works. So implicit is
not going away.

If you want to only support explicit in U-Boot, that is fine. I would
suggest making this clear in the U-Boot documentation.

	Andrew
