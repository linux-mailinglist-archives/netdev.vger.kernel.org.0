Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05976354DB7
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 09:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244252AbhDFHV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 03:21:28 -0400
Received: from hs01.dk-develop.de ([173.249.23.66]:40976 "EHLO
        hs01.dk-develop.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbhDFHV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 03:21:28 -0400
Date:   Tue, 6 Apr 2021 09:21:15 +0200
From:   Danilo Krummrich <danilokrummrich@dk-develop.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        davem@davemloft.net, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <YGwL67WBGKbWU3TH@arch-linux>
References: <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
 <20210401084857.GW1463@shell.armlinux.org.uk>
 <YGZvGfNSBBq/92D+@arch-linux>
 <20210402125858.GB1463@shell.armlinux.org.uk>
 <YGoSS7llrl5K6D+/@arch-linux>
 <YGsRwxwXILC1Tp2S@lunn.ch>
 <YGtdv++nv3H5K43E@arch-linux>
 <YGtksD5p5JVpnazu@lunn.ch>
 <YGuPcNPXiQZkEehh@arch-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGuPcNPXiQZkEehh@arch-linux>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 12:30:11AM +0200, Danilo Krummrich wrote:
> On Mon, Apr 05, 2021 at 09:27:44PM +0200, Andrew Lunn wrote:
> > > Now, instead of encoding this information of the bus' capabilities at both
> > > places, I'd propose just checking the mii_bus->capabilities field in the
> > > mdiobus_c45_*() functions. IMHO this would be a little cleaner, than having two
> > > places where this information is stored. What do you think about that?
> > 
> > You will need to review all the MDIO bus drivers to make sure they
> > correctly set the capabilities. There is something like 55 using
> > of_mdiobus_register() and 45 using mdiobus_register(). So you have 100
> > drivers to review.
> Yes, but I think it would be enough to look at the drivers handling the
> MII_ADDR_C45 flag, because those are either
> - actually capable to do C45 bus transfers or
> - do properly return -EOPNOTSUPP.
> 
> I counted 27 drivers handling the MII_ADDR_C45 flag. Setting the capabilities
> for those should be pretty easy.
> 
> The remaining ones, which should be about 73 then, could be left untouched,
> because the default capability MDIOBUS_NO_CAP would indicate they can C22 only.
> Since they don't handle the MII_ADDR_C45 flag at all, this should be the
> correct assumption.
Forgot to mention, this would also automatically fixup that userspace C45
requests for those "remaining" drivers results in garbage on the bus. :-)
> > 
> > 	Andrew
> > 
