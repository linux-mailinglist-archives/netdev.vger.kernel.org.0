Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D16624DA3
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiKJWbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKJWbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:31:13 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E20F56554;
        Thu, 10 Nov 2022 14:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ckYAbxaJX0FE8Tra3HuW7LsP7t9ODhY0IvtR+ncmsgw=; b=ovhF5zrWCtYwRWd0map5L3rP9S
        ULuwT6k3vz7XX9YcVnv00raZit9RjhuDzHvp8RtGfApuIYgsm968LEldgM7IbE4U4seuynQcE0rox
        633dO+HcsRyvID8hubiuWBcJDQWu7ZQVNOlWRY/1SSBTV+f7jVZU+IVRwdOkPxQMPCUA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otG4A-0024Zo-7g; Thu, 10 Nov 2022 23:30:34 +0100
Date:   Thu, 10 Nov 2022 23:30:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Add listening address to SYN flood message
Message-ID: <Y217ikkZzXKKGix4@lunn.ch>
References: <f847459dc0a0e2d8ffa1d290d06e0e4a226a6f39.1668075479.git.jamie.bainbridge@gmail.com>
 <Y20Bxc1gQ8nrFsvA@lunn.ch>
 <CAAvyFNg1F8ixrgy0YeL-TT5xLmk8N7dD=ZMLQ6VxsjHb_PU9bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAvyFNg1F8ixrgy0YeL-TT5xLmk8N7dD=ZMLQ6VxsjHb_PU9bg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 08:20:18AM +1100, Jamie Bainbridge wrote:
> On Fri, 11 Nov 2022 at 00:51, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Thu, Nov 10, 2022 at 09:21:06PM +1100, Jamie Bainbridge wrote:
> > > The SYN flood message prints the listening port number, but on a system
> > > with many processes bound to the same port on different IPs, it's
> > > impossible to tell which socket is the problem.
> > >
> > > Add the listen IP address to the SYN flood message. It might have been
> > > nicer to print the address first, but decades of monitoring tools are
> > > watching for the string "SYN flooding on port" so don't break that.
> > >
> > > Tested with each protcol's "any" address and a host address:
> > >
> > >  Possible SYN flooding on port 9001. IP 0.0.0.0.
> > >  Possible SYN flooding on port 9001. IP 127.0.0.1.
> > >  Possible SYN flooding on port 9001. IP ::.
> > >  Possible SYN flooding on port 9001. IP fc00::1.
> > >
> > > Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
> > > ---
> > >  net/ipv4/tcp_input.c | 16 +++++++++++++---
> > >  1 file changed, 13 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > > index 0640453fce54b6daae0861d948f3db075830daf6..fb86056732266fedc8ad574bbf799dbdd7a425a3 100644
> > > --- a/net/ipv4/tcp_input.c
> > > +++ b/net/ipv4/tcp_input.c
> > > @@ -6831,9 +6831,19 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
> > >               __NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDROP);
> > >
> > >       if (!queue->synflood_warned && syncookies != 2 &&
> > > -         xchg(&queue->synflood_warned, 1) == 0)
> > > -             net_info_ratelimited("%s: Possible SYN flooding on port %d. %s.  Check SNMP counters.\n",
> > > -                                  proto, sk->sk_num, msg);
> > > +         xchg(&queue->synflood_warned, 1) == 0) {
> > > +#if IS_ENABLED(CONFIG_IPV6)
> > > +             if (sk->sk_family == AF_INET6) {
> >
> > Can the IS_ENABLED() go inside the if? You get better build testing
> > that way.
> >
> >      Andrew
> 
> Are you sure? Why would the IS_ENABLED() be inside of a condition
> which isn't compiled in? If IPv6 isn't compiled in then the condition
> would never evaluate as true, so seems pointless a pointless
> comparison to make? People not compiling in IPv6 have explicitly asked
> *not* to have their kernel filled with a bunch of "if (family ==
> AF_INET6)" haven't they?
> 
> There are many other examples of this pattern of "IS_ENABLED()" first
> and "if (family == AF_INET6)" inside it, but I can't see any of the
> inverse which I think you're suggesting, see:
> 
>  grep -C1 -ERHn "IS_ENABLED\(CONFIG_IPV6\)" net | grep -C1 "family == AF_INET6"
> 
> Please let me know if I've misunderstood?

So what i'm suggesting is

               if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
                       net_info_ratelimited("%s: Possible SYN flooding on port %d. IP %pI6c. %s.  Check SNMP counters.\n",
                                       proto, sk->sk_num,
                                       &sk->sk_v6_rcv_saddr, msg);
		}

The IS_ENABLED(CONFIG_IPV6) will evaluate to 0 at compile time, and
the optimiser will throw away the whole lot since it can never be
true. However, before the code gets to the optimiser, it first needs
to compile. It will check you have the correct number of parameters
for the string format, do the types match, do the structure members
exist, etc. Anybody doing compile testing of a change, and they have
IPV6 turned off, has a chance off getting errors reported when they
have actually broken IPV6, but don't know it, because they are not
compiling it.

Now, IPV6 is one of those big options which i expect 0-day tests quite
regularly. Using IF_ENABLED() like this brings more benefit from less
used options which gets very little build testing, and so are often
broke until somebody like Arnd runs builds with lots of random
configs.

	Andrew
