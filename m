Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B7D22446A
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgGQTml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:42:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41722 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbgGQTmk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 15:42:40 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jwWFh-005etS-2h; Fri, 17 Jul 2020 21:42:37 +0200
Date:   Fri, 17 Jul 2020 21:42:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Martin Rowe <martin.p.rowe@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, vivien.didelot@gmail.com
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
Message-ID: <20200717194237.GE1339445@lunn.ch>
References: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
 <20200711162349.GL1014141@lunn.ch>
 <20200711192255.GO1551@shell.armlinux.org.uk>
 <CAOAjy5TBOhovCRDF7NC-DWemA2k5as93tqq3gOT1chO4O0jpiA@mail.gmail.com>
 <20200712132554.GS1551@shell.armlinux.org.uk>
 <CAOAjy5T0oNJBsjru9r7MPu_oO8TSpY4PKDg7whq4yBJE12mPaA@mail.gmail.com>
 <20200717092153.GK1551@shell.armlinux.org.uk>
 <CAOAjy5RNz8mGi4XjP_8x-aZo5VhXRFF446R7NgcQGEKWVpUV1Q@mail.gmail.com>
 <20200717185119.GL1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717185119.GL1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 07:51:19PM +0100, Russell King - ARM Linux admin wrote:
> On Fri, Jul 17, 2020 at 12:50:07PM +0000, Martin Rowe wrote:
> > On Fri, 17 Jul 2020 at 09:22, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > > The key file is /sys/kernel/debug/mv88e6xxx.0/regs - please send the
> > > contents of that file.
> > 
> > $ cat regs.broken
> >     GLOBAL GLOBAL2 SERDES     0    1    2    3    4    5
> >  0:  c800       0    ffff  9e07 9e4f 100f 100f 9e4f 170b
> >  1:     0    803e    ffff     3    3    3    3    3 201f
>                                                       ^^^^
> This is where the problem is.
> 
> >  1:     0    803e    ffff     3    3    3    3    3 203f
>                                                       ^^^^
> 
> In the broken case, the link is forced down, in the working case, the
> link is forced up.
> 
> What seems to be happening is:
> 
> dsa_port_link_register_of() gets called, and we do this:
> 
>                 phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
>                 if (of_phy_is_fixed_link(dp->dn) || phy_np) {
>                         if (ds->ops->phylink_mac_link_down)
>                                 ds->ops->phylink_mac_link_down(ds, port,
>                                         MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
>                         return dsa_port_phylink_register(dp);
> 
> which forces the link down, and for some reason the link never comes
> back up.
>
> One of the issues here is of_phy_is_fixed_link() - it is dangerous.
> The function name leads you astray - it suggests that if it returns
> true, then you have a fixed link, but it also returns true of you
> have managed!="auto" in DT, so it's actually fixed-or-inband-link.
> 
> Andrew, any thoughts?


Hi Russell

I think that is my change, if i remember correctly. Something to do
with phylink assuming all interfaces are down to begin with. But DSA
and CPU links were defaulting to up. When phylink later finds the
fixed-link it then configures the interface up again, and because the
interface is up, nothing actually happens, or it ends up in the wrong
mode. So i think my intention was, if there is a fixed link in DT,
down the interface before registering it with phylink, so its
assumptions are true, and it will later be correctly configured up.

So in this case, do you think we are falling into the trap of
managed!="auto" ?

	Andrew
