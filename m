Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C00C3BEBD8
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhGGQSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:18:24 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:57317 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbhGGQSY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 12:18:24 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 167GFZTe002304;
        Wed, 7 Jul 2021 18:15:35 +0200
Date:   Wed, 7 Jul 2021 18:15:35 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Maciej Zenczykowski <maze@google.com>
Subject: Re: [PATCH net] ipv6: tcp: drop silly ICMPv6 packet too big messages
Message-ID: <20210707161535.GF1978@1wt.eu>
References: <20210707154630.583448-1-eric.dumazet@gmail.com>
 <20210707155930.GE1978@1wt.eu>
 <CANn89iKroJhPxiFJFNhopS6cS-Y6u1z_RLDTDCnmH8PMkJwEsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKroJhPxiFJFNhopS6cS-Y6u1z_RLDTDCnmH8PMkJwEsA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 06:06:21PM +0200, Eric Dumazet wrote:
> On Wed, Jul 7, 2021 at 5:59 PM Willy Tarreau <w@1wt.eu> wrote:
> >
> > Hi Eric,
> >
> > On Wed, Jul 07, 2021 at 08:46:30AM -0700, Eric Dumazet wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > While TCP stack scales reasonably well, there is still one part that
> > > can be used to DDOS it.
> > >
> > > IPv6 Packet too big messages have to lookup/insert a new route,
> > > and if abused by attackers, can easily put hosts under high stress,
> > > with many cpus contending on a spinlock while one is stuck in fib6_run_gc()
> >
> > Just thinking loud, wouldn't it make sense to support randomly dropping
> > such packets on input (or even better rate-limit them) ? After all, if
> > a host on the net feels like it will need to send one, it will surely
> > need to send a few more until one is taken into account so it's not
> > dramatic. And this could help significantly reduce their processing cost.
> 
> Not sure what you mean by random.

I just meant statistical randomness. E.g. drop 9/10 when under stress for
example.

> We probably want to process valid packets, if they ever reach us.

That's indeed the other side of my question. I.e. if a server gets hit
by such a flood, do we consider more important to spend the CPU cycles
processing all received packets or can we afford dropping a lot of them.

> In our case, we could simply drop all ICMPv6 " packet too big"
>  messages, since we clamp TCP/IPv6 MSS to the bare minimum anyway.
> 
> Adding a generic check in TCP/ipv6 stack is cheaper than an iptables
> rule (especially if this is the only rule that must be used)

Sure, I was not thinking about iptables here, rather a hard-coded
prandom_u32() call or a percpu cycling counter.

Willy
