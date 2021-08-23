Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DE93F5190
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhHWTvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:51:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37326 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhHWTve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 15:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GSSeMlmpA7UhSuMUJ8NnHuiSMaN0kV8nPnwYdVCRwdE=; b=YYDn0FJEfq94F9mZd7VN+ZUdl3
        IrEwkHBWOyFNkLJDIdAxbjerzlwH+5rNlBMJo2LepZnMdYttK1qIBnwYNXrtst3hwXbFqjTBfufQg
        Hml08cBIHIpXfjgwqMY5+lRomFmHiuE5DrP9Vtq8NIqKH4d35BO3kDcYmNwTfD4XH4ro=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mIFxv-003Vfs-8K; Mon, 23 Aug 2021 21:50:39 +0200
Date:   Mon, 23 Aug 2021 21:50:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        kernel-team@android.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH v2] of: property: fw_devlink: Add support for
 "phy-handle" property
Message-ID: <YSP8D9SzN1wmQgtV@lunn.ch>
References: <20210818021717.3268255-1-saravanak@google.com>
 <CGME20210823120849eucas1p11d3919886444358472be3edd1c662755@eucas1p1.samsung.com>
 <0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com>
 <YSOfvMIltzWPCKc/@lunn.ch>
 <CAGETcx_eUE1gLAaqXdLjCb2XxttH20066kXs969khnrEZQ71mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_eUE1gLAaqXdLjCb2XxttH20066kXs969khnrEZQ71mA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 11:13:08AM -0700, Saravana Kannan wrote:
> On Mon, Aug 23, 2021 at 6:16 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Mon, Aug 23, 2021 at 02:08:48PM +0200, Marek Szyprowski wrote:
> > > Hi,
> > >
> > > On 18.08.2021 04:17, Saravana Kannan wrote:
> > > > Allows tracking dependencies between Ethernet PHYs and their consumers.
> > > >
> > > > Cc: Andrew Lunn <andrew@lunn.ch>
> > > > Cc: netdev@vger.kernel.org
> > > > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > >
> > > This patch landed recently in linux-next as commit cf4b94c8530d ("of:
> > > property: fw_devlink: Add support for "phy-handle" property"). It breaks
> > > ethernet operation on my Amlogic-based ARM64 boards: Odroid C4
> > > (arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts) and N2
> > > (meson-g12b-odroid-n2.dts) as well as Khadas VIM3/VIM3l
> > > (meson-g12b-a311d-khadas-vim3.dts and meson-sm1-khadas-vim3l.dts).
> > >
> > > In case of OdroidC4 I see the following entries in the
> > > /sys/kernel/debug/devices_deferred:
> > >
> > > ff64c000.mdio-multiplexer
> > > ff3f0000.ethernet
> > >
> > > Let me know if there is anything I can check to help debugging this issue.
> >
> > Hi Marek
> >
> > Please try this. Completetly untested, not even compile teseted:
> >
> > diff --git a/drivers/of/property.c b/drivers/of/property.c
> > index 0c0dc2e369c0..7c4e257c0a81 100644
> > --- a/drivers/of/property.c
> > +++ b/drivers/of/property.c
> > @@ -1292,6 +1292,7 @@ DEFINE_SIMPLE_PROP(resets, "resets", "#reset-cells")
> >  DEFINE_SIMPLE_PROP(leds, "leds", NULL)
> >  DEFINE_SIMPLE_PROP(backlight, "backlight", NULL)
> >  DEFINE_SIMPLE_PROP(phy_handle, "phy-handle", NULL)
> > +DEFINE_SIMPLE_PROP(mdio_parent_bus, "mdio-parent-bus", NULL);
> >  DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
> >  DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
> >
> > @@ -1381,6 +1382,7 @@ static const struct supplier_bindings of_supplier_bindings[] = {
> >         { .parse_prop = parse_leds, },
> >         { .parse_prop = parse_backlight, },
> >         { .parse_prop = parse_phy_handle, },
> > +       { .parse_prop = parse_mdio_parent_bus, },
> >         { .parse_prop = parse_gpio_compat, },
> >         { .parse_prop = parse_interrupts, },
> >         { .parse_prop = parse_regulators, },
> 
> Looking at the code, I'm fairly certain that the device that
> corresponds to a DT node pointed to by mdio-parent-bus will be a "bus"
> device that's registered with the mdio_bus_class.
> 
> If my understanding is right, then Nak for this patch. It'll break a
> lot of probes.
> 
> TL;DR is that stateful/managed device links don't make sense for
> devices that are never probed/bound to a driver.

So some more background, which might help you get an idea what is
going on here, and what you will need to implement.

There are a number of different ways an mdio bus driver can come into
existence.

They can be classical devices, which are described in device tree and
probed in the normal way. Most of the mdio bus drivers in
driver/net/mdio are like this, and they have documented bindings, and
compatible strings, e.g. Documentation/devicetree/bindings/net/marvell-orion-mdio.txt

Multiplexers, which are probably a subclass of the above classical
devices. They have documented binds and compatible strings. They link
to another MDIO bus, and some other resource to switch the
multiplexor, e.g, GPIOs, a MMIO register, a Linux multiplexer.

They can be embedded inside some other device, typically an Ethernet
controller, but also a Ethernet switch. In this case, the parent
device should have an MDIO node in its device tree. An example would
be the freescale FEC
Documentation/devicetree/bindings/net/fsl,fec.yaml So if you are
trying to fulfil dependencies for this sort of mdio bus, you need to
probe the FEC driver, and as a side effect, the MDIO bus driver will
pop into existence.

    Andrew

