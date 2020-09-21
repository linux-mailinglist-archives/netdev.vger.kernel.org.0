Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602D827197A
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 04:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIUCui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 22:50:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgIUCui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 22:50:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKBuV-00FXDV-4L; Mon, 21 Sep 2020 04:50:35 +0200
Date:   Mon, 21 Sep 2020 04:50:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next RFC v1 0/4] Add per port devlink regions
Message-ID: <20200921025035.GB3702050@lunn.ch>
References: <20200919144332.3665538-1-andrew@lunn.ch>
 <20200920233340.ddps7yxoqlbvmv7m@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200920233340.ddps7yxoqlbvmv7m@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 11:33:41PM +0000, Vladimir Oltean wrote:
> On Sat, Sep 19, 2020 at 04:43:28PM +0200, Andrew Lunn wrote:
> >
> > DSA only instantiates devlink ports for switch ports which are used.
> > For this hardware, only 4 user ports and the CPU port have devlink
> > ports, which explains the discontinuous port regions.
> 
> This is not so much a choice, as it is a workaround of the fact that
> dsa_port_setup(), which registers devlink ports with devlink, is called
> after ds->ops->setup(), so you can't register your port regions from
> the same place as the global regions now.

Correct.

> So you're doing it from ds->ops->port_enable(), which is the DSA wrapper
> for .ndo_open(). So, consequently, your port regions will only be
> registered when the port is up, and will be unregistered when it goes
> down. Is that what you want? I understand that users probably think they
> want to debug only the ports that they actively use, but I've heard of
> at least one problem in the past which was caused by invalid settings
> (flooding in that case) on a port that was down. Sure, this is probably
> a rare situation, but as I said, somebody trying to use port regions to
> debug something like that is probably going to have a hard time, because
> it isn't an easy surgery to figure the probe ordering out.

I did intially create the port instances at the same time as the
global ones, and it died a horrible death. And i was aiming to
register a region for each port, not just those which are used.

This splits into two problems.

1) Devlink has no concept of a port which is unused. We simply don't
register unused ports. So we need to add a new devlink_port_flavour:
DEVLINK_PORT_FLAVOUR_UNUSED. That seems easy enough.

2) We need to rearrange the order the core sets stuff up, such that it
registers devlink ports before calling the DSA driver setup()
method. I think that is possible after a quick look at the code.

	Andrew
