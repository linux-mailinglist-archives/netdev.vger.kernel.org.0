Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2033FA6DF
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 19:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbhH1RC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 13:02:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46128 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230470AbhH1RCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 13:02:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=34N6KPTUp7LARCoRQy4s+AFxJpLySRpClrFRIaL/Ojg=; b=2pYR2t2UYn1zmKDF18hnELZW1t
        ifIU8YFelD1D6urPBYtDCOgHOzEXPjmJZEHF9NX0k+96wo4lnrN8n5dcCUbnnz1BHGWEq31Wrdifl
        KHaqQ7hrhGZyiLgD0hYT8rOc15OG8DYk8J5XK85FZx4CL/Q84Qw2m6m0DCfo9BdoBB30=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mK1iG-004IxO-QV; Sat, 28 Aug 2021 19:01:48 +0200
Date:   Sat, 28 Aug 2021 19:01:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YSpr/BOZj2PKoC8B@lunn.ch>
References: <YSeTdb6DbHbBYabN@lunn.ch>
 <CAGETcx-pSi60NtMM=59cve8kN9ff9fgepQ5R=uJ3Gynzh=0_BA@mail.gmail.com>
 <YSf/Mps9E77/6kZX@lunn.ch>
 <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch>
 <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch>
 <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch>
 <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 02:33:02PM -0700, Saravana Kannan wrote:
> On Fri, Aug 27, 2021 at 1:11 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > > I've not yet looked at plain Ethernet drivers. This pattern could also
> > > > exist there. And i wonder about other complex structures, i2c bus
> > > > multiplexors, you can have interrupt controllers as i2c devices,
> > > > etc. So the general case could exist in other places.
> > >
> > > I haven't seen any generic issues like this reported so far. It's only
> > > after adding phy-handle that we are hitting these issues with DSA
> > > switches.
> >
> > Can you run your parser over the 2250 DTB blobs and see how many
> > children have dependencies on a parent? That could give us an idea how
> > many moles need whacking. And maybe, where in the tree they are
> > hiding?
> 
> You are only responding to part of my email. As I said in my previous
> email: "There are plenty of cases where it's better to delay the child
> device's probe until the parent finishes. You even gave an example[7]
> where it would help avoid unnecessary deferred probes." Can you please
> give your thoughts on the rest of the points I made too?

I must admit, my main problem at the moment is -rc1 in two weeks
time. It seems like a number of board with Ethernet switches will be
broken, that worked before. phy-handle is not limited to switch
drivers, it is also used for Ethernet drivers. So it could be, a
number of Ethernet drivers are also going to be broken in -rc1?

But the issues sounds not to be specific to phy-handle, but any
phandle that points back to a parent. So it could be drivers outside
of networking are also going to be broken with -rc1?

You have been very focused on one or two drivers. I would much rather
see you getting an idea of how wide spread this problem is, and what
should we do for -rc1?

Even if modifying DSA drivers to component drivers is possible, while
not breaking backwards compatibility with DT, it is not going to
happen over night. That is something for the next merge window, not
this merge window.

So reverting the phy-handle seems like part of the fix for -rc1. But
until you look at those 2250 DTB blobs, we have no idea if that is
sufficient for -rc1.

    Andrew
