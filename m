Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42358658490
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 17:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbiL1Q61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 11:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbiL1Q5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 11:57:54 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437BA1FCFA;
        Wed, 28 Dec 2022 08:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GdOKgnKxbKVJV4+JZ/4p3pbY7F/lzdsJP2qZqHVunbo=; b=Sc3m55x0JdOk566x9NnCpGFNAc
        TJDqMkLG7FIwALCOKeWdsANWcOgiwBqrKcxmGUNTH24sJHksZrSYn+e5ldIR5/8HCgclQ0fTkz8kN
        MLc4K0EbCg0bXoS0hWZ4JGWvYyMnMNdpiUqM+zNmMvF9YU8vV9m5601/BuN25aW6uQAo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pAZgo-000eWF-BD; Wed, 28 Dec 2022 17:54:02 +0100
Date:   Wed, 28 Dec 2022 17:54:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Michael Walle <michael@walle.cc>, Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next v2 1/2] net: phy: allow a phy to opt-out of
 interrupt handling
Message-ID: <Y6x0qrNH7P1h8+Lz@lunn.ch>
References: <20221228164008.1653348-1-michael@walle.cc>
 <20221228164008.1653348-2-michael@walle.cc>
 <f547b3b9-4c8f-b370-471a-0a7b5f025e50@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f547b3b9-4c8f-b370-471a-0a7b5f025e50@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 08:49:35AM -0800, Florian Fainelli wrote:
> 
> 
> On 12/28/2022 8:40 AM, Michael Walle wrote:
> > Until now, it is not possible for a PHY driver to disable interrupts
> > during runtime. If a driver offers the .config_intr() as well as the
> > .handle_interrupt() ops, it is eligible for interrupt handling.
> > Introduce a new flag for the dev_flags property of struct phy_device, which
> > can be set by PHY driver to skip interrupt setup and fall back to polling
> > mode.
> > 
> > At the moment, this is used for the MaxLinear PHY which has broken
> > interrupt handling and there is a need to disable interrupts in some
> > cases.
> > 
> > Signed-off-by: Michael Walle <michael@walle.cc>
> > ---
> >   drivers/net/phy/phy_device.c | 7 +++++++
> >   include/linux/phy.h          | 2 ++
> >   2 files changed, 9 insertions(+)
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 716870a4499c..e4562859ac00 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -1487,6 +1487,13 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
> >   	phydev->interrupts = PHY_INTERRUPT_DISABLED;
> > +	/* PHYs can request to use poll mode even though they have an
> > +	 * associated interrupt line. This could be the case if they
> > +	 * detect a broken interrupt handling.
> > +	 */
> > +	if (phydev->dev_flags & PHY_F_NO_IRQ)
> > +		phydev->irq = PHY_POLL;
> 
> Cannot you achieve the same thing with the PHY driver mangling phydev->irq
> to a negative value, or is that too later already by the time your phy
> driver's probe function is running?

It is actually to early. The interrupt is requested when the MAC
attaches the PHY. There are is at least one MAC driver which assigns
the phydev->irq just before attaching the PHY, a long time after the
PHY has probed.

    Andrew
