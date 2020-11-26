Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46252C57FB
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 16:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391273AbgKZPVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 10:21:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51514 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391261AbgKZPVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 10:21:23 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kiJ57-008zZm-LH; Thu, 26 Nov 2020 16:21:13 +0100
Date:   Thu, 26 Nov 2020 16:21:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
Message-ID: <20201126152113.GM2073444@lunn.ch>
References: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
 <20201124011459.GD2031446@lunn.ch>
 <20201124131608.1b884063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <98319caa-de5f-6f5e-9c9e-ee680e5abdc0@nvidia.com>
 <20201125141822.GI2075216@lunn.ch>
 <a9835ab6-70a1-5a15-194e-977ff9c859ec@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9835ab6-70a1-5a15-194e-977ff9c859ec@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > If i was implementing the ethtool side of it, i would probably do some
> > sort of caching system. We know page 0 should always exist, so
> > pre-load that into the cache. Try the netlink API first. If that
> > fails, use the ioctl interface. If the ioctl is used, put everything
> > returned into the cache.
> I am not sure what you mean by cache here. Don't you want to read page 0
> once you got the ethtool command to read from the module ? If not, then at
> what stage ?

At the beginning, you try the netlink API and ask for pager 0, bytes
0-127. If you get a page, put it into the cache. If not, use the ioctl
interface, which could return one page, or multiple pages. Put them
all into the cache.

> >   The decoder can then start decoding, see what
> > bits are set indicating other pages should be available. Ask for them
> > from the cache. The netlink API can go fetch them and load them into
> > the cache. If they cannot be loaded return ENODEV, and the decoder has
> > to skip what it wanted to decode.
> 
> So the decoder should read page 0 and check according to page 0 and
> specification which pages should be present, right ?

Yes. It ask the cache, give me a pointer to page 0, bytes 0-127. It
then decodes that, looking at the enumeration data to indicate what
other pages should be available. Maybe it decides, page 0, bytes
128-255 should exist, so it asks the cache for a pointer to that. If
using netlink, it would ask the kernel for that data, put it into the
cache, and return a pointer. If using ioctl, it already knows if it
has that data, so it just returns a pointer, so says sorry, not
available.

> What about the global offset that we currently got when user doesn't specify
> a page, do you mean that this global offset goes through the optional and
> non optional pages that exist and skip the ones that are missing according
> to the specific EEPROM ?

ethtool -m|--dump-module-eeprom|--module-info devname [raw on|off] [hex on|off] [offset N] [length N]

So you mean [offset N] [length N].

That is going to be hard, but the API is broken for complex SFPs with
optional pages. And it is not well defined exactly what offset means.
You can keep backwards compatibility by identifying the SFP from page
0, and then reading the pages in the order the ioctl would do. Let
user space handle it, for those SFPs which the kernel already
supports. For SFPs which the kernel does not support, i would just
return not supported. You can do the same for raw. However, for new
SFPs, for raw you can run the decoder but output to /dev/null. That
loads into the cache all the pages which the decoder knows about. You
can then dump the cache. You probably need a new format, to give an
indication of what each page actually is.

Maybe you want to add new options [page N] [ bank N] to allow
arbitrary queries to be made? Again, you can answer these from the
cache, so the old ioctl interface could work if asked for pages which
the old API had.

    Andrew
