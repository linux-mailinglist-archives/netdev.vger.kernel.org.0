Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D45846A611
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348786AbhLFT5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:57:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348710AbhLFT5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 14:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=oN+L5Wm3ItNttMBbh6PzcZw+glspAz/dwdZfwv5XL38=; b=Xs
        0vaIr2cSSXsrHVSpI1V/klweJRH2repWRSAp5W4qVdgCJWoUUOajBmtZptOpnjL4uSedmEgWIhayF
        1J0619Li/U/fwJHvI/btJ59W/HpPKyaaho/cUQVhFCczizC3dM3tv8sycNHPFeMqeN5thWEDdZg5s
        fwk6He/cz3+IMSQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muK3W-00FhKV-U9; Mon, 06 Dec 2021 20:53:46 +0100
Date:   Mon, 6 Dec 2021 20:53:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya5qSoNhJRiSif/U@lunn.ch>
References: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
 <YapE3I0K4s1Vzs3w@lunn.ch>
 <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
 <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211206193730.oubyveywniyvptfk@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Just out of curiosity, can you try this change? It looks like a
> > > simple
> > > case of mismatched conditions inside the mv88e6xxx driver between
> > > what
> > > is supposed to force the link down and what is supposed to force it
> > > up:
> > > 
> > > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > > index 20f183213cbc..d235270babf7 100644
> > > --- a/net/dsa/port.c
> > > +++ b/net/dsa/port.c
> > > @@ -1221,7 +1221,7 @@ int dsa_port_link_register_of(struct dsa_port
> > > *dp)
> > >                 if (of_phy_is_fixed_link(dp->dn) || phy_np) {
> > >                         if (ds->ops->phylink_mac_link_down)
> > >                                 ds->ops->phylink_mac_link_down(ds, port,
> > > -                                       MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
> > > +                                       MLO_AN_PHY, PHY_INTERFACE_MODE_NA);
> > >                         return dsa_port_phylink_register(dp);
> > >                 }
> > >                 return 0;
> > 
> > Yes, that appears to also make it work.
> > 
> > Martyn
> 
> Well, I just pointed out what the problem is, I don't know how to solve
> it, honest! :)
> 
> It's clear that the code is wrong, because it's in an "if" block that
> checks for "of_phy_is_fixed_link(dp->dn) || phy_np" but then it omits
> the "phy_np" part of it. On the other hand we can't just go ahead and
> say "if (phy_np) mode = MLO_AN_PHY; else mode = MLO_AN_FIXED;" because
> MLO_AN_INBAND is also a valid option that we may be omitting. So we'd
> have to duplicate part of the logic from phylink_parse_mode(), which
> does not appear ideal at all. What would be ideal is if this fabricated
> phylink call would not be done at all, but I don't know enough about the
> systems that need it, I expect Andrew knows more.

phylink assumes interfaces start in the down state. It will then
configure them and bring them up as needed. This is not always true
with mv88e6xxx, the interface can already by up, and then the hardware
and phylink have different state information. So this call was added
to force the link down before phylink took control of it.

So i suspect something is missing when phylink sometime later does
bring the interface up. It is not fully undoing what this down
does. Maybe enable the dev_dbg() in mv88e6xxx_port_set_link() and see
what value it has in both the good and bad case?

     Andrew

