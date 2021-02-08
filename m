Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A8A314307
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 23:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhBHWbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 17:31:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56466 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230055AbhBHWbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 17:31:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9F3M-004x80-Hv; Mon, 08 Feb 2021 23:30:44 +0100
Date:   Mon, 8 Feb 2021 23:30:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG support
Message-ID: <YCG7lEncISjQwEOk@lunn.ch>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
 <20210203165458.28717-6-vadym.kochan@plvision.eu>
 <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87v9b249oq.fsf@waldekranz.com>
 <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I took a quick look at it, and what I found left me very puzzled. I hope
> > you do not mind me asking a generic question about the policy around
> > switchdev drivers. If someone published a driver using something similar
> > to the following configuration flow:
> > 
> > iproute2  daemon(SDK)
> >    |        ^    |
> >    :        :    : user/kernel boundary
> >    v        |    |
> > netlink     |    |
> >    |        |    |
> >    v        |    |
> >  driver     |    |
> >    |        |    |
> >    '--------'    |
> >                  : kernel/hardware boundary
> >                  v
> >                 ASIC
> > 
> > My guess is that they would be (rightly IMO) told something along the
> > lines of "we do not accept drivers that are just shims for proprietary
> > SDKs".
> > 
> > But it seems like if that same someone has enough area to spare in their
> > ASIC to embed a CPU, it is perfectly fine to run that same SDK on it,
> > call it "firmware", and then push a shim driver into the kernel tree.
> > 
> > iproute2
> >    |
> >    :               user/kernel boundary
> >    v
> > netlink
> >    |
> >    v
> >  driver
> >    |
> >    |
> >    :               kernel/hardware boundary
> >    '-------------.
> >                  v
> >              daemon(SDK)
> >                  |
> >                  v
> >                 ASIC
> > 
> > What have we, the community, gained by this? In the old world, the
> > vendor usually at least had to ship me the SDK in source form. Having
> > seen the inside of some of those sausage factories, they are not the
> > kinds of code bases that I want at the bottom of my stack; even less so
> > in binary form where I am entirely at the vendor's mercy for bugfixes.
> > 
> > We are talking about a pure Ethernet fabric here, so there is no fig
> > leaf of "regulatory requirements" to hide behind, in contrast to WiFi
> > for example.
> > 
> > Is it the opinion of the netdev community that it is OK for vendors to
> > use this model?

What i find interesting is the comparison between Microchip Sparx5 and
Marvell Prestera. They offer similar capabilities. Both have a CPU on
them. As you say Marvell is pushing their SDK into this CPU, black
box. Microchip decided to open everything, no firmware, the kernel
driver is directly accessing the hardware, the datasheet is available,
and microchip engineers are here on the list.

I really hope that Sparx5 takes off, and displaces Prestera. In terms
of being able to solve issues, we the community can work with
Sparx5. Prestera is too much a black box.

	Andrew
