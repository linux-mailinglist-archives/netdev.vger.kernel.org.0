Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227DA1AFC4B
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 19:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgDSRFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 13:05:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48620 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgDSRFu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 13:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=df22MOiMiBWPmZ9Unkx77qadZVa96KWysrhmpciDQY4=; b=K0nBRNGsQY3lkkO4oT1w01NaQm
        nsDK8Xw6vAdXBHItWPAKhsaJskg/SyCU26sC4OXoKm4a1n88nk/yKjKauW9aQp6J9N2FytLzfNegB
        dH5MZ2s8pHB7v1r8/KTY4j56if+warOy6nrLRn00wMUIC+3w0FIBRQo+E+Ab1hZOOTqM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQDO7-003f7D-KM; Sun, 19 Apr 2020 19:05:47 +0200
Date:   Sun, 19 Apr 2020 19:05:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/3] net: phy: bcm54140: add hwmon support
Message-ID: <20200419170547.GO836632@lunn.ch>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200417192858.6997-3-michael@walle.cc>
 <20200417195003.GG785713@lunn.ch>
 <35d00dfe1ad24b580dc247d882aa2e39@walle.cc>
 <20200417201338.GI785713@lunn.ch>
 <84679226df03bdd8060cb95761724d3a@walle.cc>
 <20200417212829.GJ785713@lunn.ch>
 <4f3ff33f78472f547212f87f75a37b66@walle.cc>
 <20200419162928.GL836632@lunn.ch>
 <ebc026792e09d5702d031398e96d34f2@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebc026792e09d5702d031398e96d34f2@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Maybe we need a phydev->shared structure, which all PHYs in one
> > package share?
> 
> That came to my mind too. But how could the PHY core find out which
> shared structure belongs to which phydev? I guess the phydev have to
> find out, but then how does it tell the PHY core that it wants such
> a shared structure. Have the (base) PHY address as an identifier?

Yes. I was thinking along those lines.

phy_package_join(phydev, base)

If this is the first call with that value of base, allocate the
structure, set the ref count to 1, and set phydev->shared to point to
it. For subsequent calls, increment the reference count, and set
phydev->shared.

phy_package_leave(phydev)

Decrement the reference count, and set phydev->shared to NULL. If the
reference count goes to 0, free the structure.

> > Get the core to do reference counting on the structure?
> > Add helpers phy_read_shared(), phy_write_shared(), etc, which does
> > MDIO accesses on the base device, taking care of the locking.
> 
> The "base" access is another thing, I guess, which has nothing to do
> with the shared structure.

I'm making the assumption that all global addresses are at the base
address. If we don't want to make that assumption, we need the change
the API above so you pass a cookie, and all PHYs need to use the same
cookie to identify the package.

Maybe base is the wrong name, since MSCC can have the base as the high
address of the four, not the low?

Still just thinking aloud....

       Andrew
