Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DED13E462F
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 15:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbhHINKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 09:10:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39888 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234207AbhHINJ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 09:09:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bj4IgXIg32jZPQDCAO7n9XK4DWEWjo8Tf/ELTxnwevk=; b=Di5e2m5iSa/uhBcJoEare1Zxg6
        pQL10khiMNUk8jvmuQneGR5vwzw2XfxYtfnfw5I+p1BnI0Wz67WwkCn8Kn+onYvpSMhNyDzFU2Wwr
        Ugc9+90IbMvOISMPqZdjx3r6rbpOC6nyhS4zF/MapHTZoFKFITwDmj+ib4TlFXzjqS0k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mD51r-00Ghnx-S3; Mon, 09 Aug 2021 15:09:19 +0200
Date:   Mon, 9 Aug 2021 15:09:19 +0200
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
Subject: Re: [PATCH 2/2] net: Add driver for LiteX's LiteETH network interface
Message-ID: <YREo/wS8iagiuYBA@lunn.ch>
References: <20210806054904.534315-1-joel@jms.id.au>
 <20210806054904.534315-3-joel@jms.id.au>
 <YQ7czmvIm6FTZAol@lunn.ch>
 <CACPK8XdOUhz8U0NqOcLRPC3=rjfVB1FFhwyJzMy2AE+7Omm_2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPK8XdOUhz8U0NqOcLRPC3=rjfVB1FFhwyJzMy2AE+7Omm_2g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 03:20:57AM +0000, Joel Stanley wrote:
> On Sat, 7 Aug 2021 at 19:19, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > +static void liteeth_reset_hw(struct liteeth *priv)
> > > +{
> > > +     /* Reset, twice */
> > > +     writeb(0, priv->base + LITEETH_PHY_CRG_RESET);
> > > +     udelay(10);
> > > +     writeb(1, priv->base + LITEETH_PHY_CRG_RESET);
> > > +     udelay(10);
> > > +     writeb(0, priv->base + LITEETH_PHY_CRG_RESET);
> > > +     udelay(10);
> >
> > What is this actually resetting?
> 
> This comes from the reference firmware that many (but not all) litex
> systems run before loading their operating system.
> 
> I'm not completely sure how necessary it still is; I will drop it for now.

Which did not answer my question. Once we know what is being reset, we
can maybe suggest when/how it should be reset.

> > > +static int liteeth_probe(struct platform_device *pdev)
> > > +{
> > > +     struct net_device *netdev;
> > > +     void __iomem *buf_base;
> > > +     struct resource *res;
> > > +     struct liteeth *priv;
> > > +     int irq, err;
> > > +
> > > +     netdev = alloc_etherdev(sizeof(*priv));
> > > +     if (!netdev)
> > > +             return -ENOMEM;
> > > +
> > > +     priv = netdev_priv(netdev);
> > > +     priv->netdev = netdev;
> > > +     priv->dev = &pdev->dev;
> > > +
> > > +     irq = platform_get_irq(pdev, 0);
> > > +     if (irq < 0) {
> > > +             dev_err(&pdev->dev, "Failed to get IRQ\n");
> > > +             goto err;
> > > +     }
> > > +
> > > +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > +     priv->base = devm_ioremap_resource(&pdev->dev, res);
> > > +     if (IS_ERR(priv->base)) {
> > > +             err = PTR_ERR(priv->base);
> > > +             goto err;
> > > +     }
> > > +
> > > +     res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > > +     priv->mdio_base = devm_ioremap_resource(&pdev->dev, res);
> > > +     if (IS_ERR(priv->mdio_base)) {
> > > +             err = PTR_ERR(priv->mdio_base);
> > > +             goto err;
> > > +     }
> >
> > So you don't have any PHY handling, or any MDIO bus master code. So i
> > would drop this, until the MDIO architecture question is answered. I
> > also wonder how much use the MAC driver is without any PHY code?
> > Unless you have a good reason, i don't think we should merge this
> > until it makes the needed calls into phylib. It is not much code to
> > add.
> 
> You mean I should skip out the parsing of the mdio base until I'm
> using it? That's reasonable.

It could be we insist you add MDIO and PHY handling. But first we need
to understand the architecture.

   Andrew
