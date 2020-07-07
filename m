Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6D2217504
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgGGRSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgGGRSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 13:18:44 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 085FC2078A;
        Tue,  7 Jul 2020 17:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594142323;
        bh=pUTBhug55qWGrkAB5wyXchKr2yiif3vkK2Iy9BKGHjA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wr+azqwMC9OUQNGFPyarr/RRGonhfj+ni3j/001lS0VuvuHb1DU3ElKkcqIEDyrDN
         isR7LcVuOlEzX8pprkE6WoKBcqYEQ22xsePJLpWYdS2r7Gn5LsPNU7dnRrc4xPcZYF
         KopGEdei7R2mWWjl0ko2ftoay7RToo1lnwhV1j24=
Received: by mail-oi1-f174.google.com with SMTP id k4so35474878oik.2;
        Tue, 07 Jul 2020 10:18:43 -0700 (PDT)
X-Gm-Message-State: AOAM531gsCp3povzGC48otAPz6drY6B1xkG9S7B4PrAmWMGpappznIb8
        3Dc3ekYlUMeUFy8FxWGM5GpU1N7HwnfamrcY6w==
X-Google-Smtp-Source: ABdhPJwnW18eGjcb7GypEIvTrmIdxT1Ml5LeeQBihduI7SVrU/0eaFhyDjBHwHYGID/JvvhQjMBKML+Lr4CMW074jT8=
X-Received: by 2002:aca:4844:: with SMTP id v65mr4330159oia.152.1594142322315;
 Tue, 07 Jul 2020 10:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200706181331.x2tn5cl5jn5kqmhx@gilmour.lan> <20200707141918.GA928075@lunn.ch>
 <20200707145440.teimwt6kmsnyi5dz@gilmour.lan> <82482500-d329-71d4-619a-7cb2eddaf9ad@gmail.com>
In-Reply-To: <82482500-d329-71d4-619a-7cb2eddaf9ad@gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 7 Jul 2020 11:18:31 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLxUbf28MqYXsTd-bUPTq9XXaRqVOOy6qnDd9t3LQoP9A@mail.gmail.com>
Message-ID: <CAL_JsqLxUbf28MqYXsTd-bUPTq9XXaRqVOOy6qnDd9t3LQoP9A@mail.gmail.com>
Subject: Re: PHY reset handling during DT parsing
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Maxime Ripard <maxime@cerno.tech>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 10:39 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 7/7/2020 7:54 AM, Maxime Ripard wrote:
> > Hi Andrew,
> >
> > On Tue, Jul 07, 2020 at 04:19:18PM +0200, Andrew Lunn wrote:
> >> On Mon, Jul 06, 2020 at 08:13:31PM +0200, Maxime Ripard wrote:
> >>> I came across an issue today on an Allwinner board, but I believe it's a
> >>> core issue.
> >>>
> >>> That board is using the stmac driver together with a phy that happens to
> >>> have a reset GPIO, except that that GPIO will never be claimed, and the
> >>> PHY will thus never work.
> >>>
> >>> You can find an example of such a board here:
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/sun6i-a31-hummingbird.dts#n195
> >>>
> >>> It looks like when of_mdiobus_register() will parse the DT, it will then
> >>> call of_mdiobus_register_phy() for each PHY it encounters [1].
> >>> of_mdiobus_register_phy() will then if the phy doesn't have an
> >>> ethernet-phy-id* compatible call get_phy_device() [2], and will later on
> >>> call phy_register_device [3].
> >>>
> >>> get_phy_device() will then call get_phy_id() [4], that will try to
> >>> access the PHY through the MDIO bus [5].
> >>>
> >>> The code that deals with the PHY reset line / GPIO is however only done
> >>> in mdiobus_device_register, called through phy_device_register. Since
> >>> this is happening way after the call to get_phy_device, our PHY might
> >>> still very well be in reset if the bootloader hasn't put it out of reset
> >>> and left it there.
> >>
> >> Hi Maxime
> >>
> >> If you look at the history of this code,
> >>
> >> commit bafbdd527d569c8200521f2f7579f65a044271be
> >> Author: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> >> Date:   Mon Dec 4 13:35:05 2017 +0100
> >>
> >>     phylib: Add device reset GPIO support
> >>
> >> you will see there is an assumption the PHY can be detected while in
> >> reset. The reset was originally handled inside the at803x PHY driver
> >> probe function, before it got moved into the core.
> >>
> >> What you are asking for it reasonable, but you have some history to
> >> deal with, changing some assumptions as to what the reset is all
> >> about.
> >
> > Thanks for the pointer.
> >
> > It looks to me from the commit log that the assumption was that a
> > bootloader could leave the PHY into reset though?
> >
> > It starts with:
> >
> >> The PHY devices sometimes do have their reset signal (maybe even power
> >> supply?) tied to some GPIO and sometimes it also does happen that a
> >> boot loader does not leave it deasserted.
> >
> > This is exactly the case I was discussing. The bootloader hasn't used
> > the PHY, and thus the PHY reset signal is still asserted?
>
> The current solution to this problem would be to have a reset property
> specified for the MDIO bus controller node such that the reset would be
> de-asserted during mdiobus_register() and prior to scanning the MDIO bus.

Unless the reset controls all the devices on the mdio bus, the
controller node is not the right place. The core could look into the
child nodes, but this is just one possible property.

> This has the nice property that for a 1:1 mapping between MDIO bus
> controller and device, it works (albeit maybe not being accurately
> describing hardware), but if you have multiple MDIO/PHY devices sitting
> on the bus, they might each have their own reset control and while we
> would attempt to manage that reset line from that call path:
>
> mdiobus_scan()
>  -> phy_device_register()
>     -> mdiobus_register_device()
>
> it would be too late because there is a preceding get_phy_device() which
> attempts to read the PHY device's OUI and it would fail if the PHY is
> still held in reset.
>
> We have had a similar discussion before with regulators:
>
> http://archive.lwn.net:8080/devicetree/20200622093744.13685-1-brgl@bgdev.pl/
>
> and so far we do not really have a good solution to this problem either.
>
> For your specific use case with resets you could do a couple of things:
>
> - if there is only one PHY on the MDIO bus you can describe the reset
> line to be within the MDIO bus controller node (explained above), this
> is not great but it is not necessarily too far from reality either
>
> - if you know the PHY OUI, you can put it as a compatible string in the
> form: ethernet-phy-id%4x.%4x and that will avoid the MDIO bus layer to
> try to read from the PHY but instead match it with a driver and create a
> phy_device instance right away

The h/w is simply not discoverable, so it needs a compatible string.

> I think we are open to a "pre probe" model where it is possible to have
> a phy_device instance created that would allow reset controller or
> regulator (or clocks, too) to be usable with a struct device reference,
> yet make no HW access until all of these resources have been enabled.

I think this is needed for the kernel's driver model in general. It's
not an MDIO specific problem.

Rob
