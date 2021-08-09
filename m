Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2013E4689
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 15:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbhHIN14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 09:27:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39946 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhHIN1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 09:27:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XPcwLD3bV7njc8ZJSvv3i6NpD/qthpMV+YNj6jBN0Nc=; b=KNANoakmu9zX5ptv9bakmVwzXS
        VhNg7Xgh4r8JcEz2d/r7StCSFlBrCdT6nizpMQvSR6eZDWoHowQEhCab2rTuxnlRqvAg03GA9qfhG
        CGcKdyzU14BLkcvu+cBUt4bsUFXysNI69XyiroliVyLi4Lphx+4BzbcPptiDqpkWu7wU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mD5JK-00GhzY-HE; Mon, 09 Aug 2021 15:27:22 +0200
Date:   Mon, 9 Aug 2021 15:27:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Stafford Horne <shorne@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: net: Add bindings for LiteETH
Message-ID: <YREtOlBnRl42lwhD@lunn.ch>
References: <20210806054904.534315-1-joel@jms.id.au>
 <20210806054904.534315-2-joel@jms.id.au>
 <YQ7ZXu7hHTCNBwNz@lunn.ch>
 <CACPK8XdKi3f60h2PNjuWsEiw5Rz+F7Ngtw0yF0ZOg+N3kOy0tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPK8XdKi3f60h2PNjuWsEiw5Rz+F7Ngtw0yF0ZOg+N3kOy0tQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Joel
> >
> > How configurable is the synthesis? Can the MDIO bus be left out? You
> > can have only the MDIO bus and no MAC?
> >
> > I've not looked at the driver yet, but if the MDIO bus has its own
> > address space, you could consider making it a standalone
> > device. Somebody including two or more LiteETH blocks could then have
> > one shared MDIO bus. That is a supported Linux architecture.
> 
> It's currently integrated as one device. If you instatined two blocks,
> you would end up with two mdio controllers, each inside those two
> liteeth blocks.

O.K. So at the moment, that is the default architecture, and the
driver should then support it. But since there appears to be a clean
address space split, the Linux MDIO driver could still be
separate. But it might depend on the reset, since the register is in
the MDIO address space. So again, we need to understand what that
reset is about.

> Obviously being software someone could change that. We've had a few
> discussions about the infinite possibilities of a soft SoC and what
> that means for adding driver support to mainline.

Has any thought been given to making the hardware somehow
enumerable/self describing? A register containing features which have
been synthesised? There could be a bit indicating is the MDIO bus
master is present, etc.

> As the soft core project evolves, we can revisit what goes in
> mainline, how flexible that driver support needs to be, and how best
> to manage that.

We can do that, but we have to keep backwards compatibility in
mind. We cannot break older synthesised IP blobs because a new feature
has come along and the driver has changed. It is best to put some
thought into that now, how forward/backward compatibility will work.
A revision register, a self description register, something which
helps the software driver identify what the 'hardware' is.

      Andrew

> 
> >
> > > +
> > > +  interrupts:
> > > +    maxItems: 1
> > > +
> > > +  rx-fifo-depth:
> > > +    description: Receive FIFO size, in units of 2048 bytes
> > > +
> > > +  tx-fifo-depth:
> > > +    description: Transmit FIFO size, in units of 2048 bytes
> > > +
> > > +  mac-address:
> > > +    description: MAC address to use
> > > +
> > > +required:
> > > +  - compatible
> > > +  - reg
> > > +  - interrupts
> > > +
> > > +additionalProperties: false
> > > +
> > > +examples:
> > > +  - |
> > > +    mac: ethernet@8020000 {
> > > +        compatible = "litex,liteeth";
> > > +        reg = <0x8021000 0x100
> > > +               0x8020800 0x100
> > > +               0x8030000 0x2000>;
> > > +        rx-fifo-depth = <2>;
> > > +        tx-fifo-depth = <2>;
> > > +        interrupts = <0x11 0x1>;
> > > +    };
> >
> > You would normally expect to see some MDIO properties here, a link to
> > the standard MDIO yaml, etc.
> 
> Do you have a favourite example that I could follow?

Documentation/devicetree/bindings/net/mdio.yaml describes all the
standard properties. Picking a file at random:

Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml

