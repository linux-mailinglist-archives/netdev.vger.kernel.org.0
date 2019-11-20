Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E3A104586
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 22:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbfKTVNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 16:13:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:36464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725819AbfKTVNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 16:13:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E765DB37C;
        Wed, 20 Nov 2019 21:13:48 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 5F0BAE1EB1; Wed, 20 Nov 2019 22:13:48 +0100 (CET)
Date:   Wed, 20 Nov 2019 22:13:48 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>, Firo Yang <firo.yang@suse.com>
Subject: Re: possible race in __inet_lookup_established()
Message-ID: <20191120211348.GD29650@unicorn.suse.cz>
References: <20191120083919.GH27852@unicorn.suse.cz>
 <CANn89iJYXh7AwK8_Aiz3wXqugG0icPNW6OPsPxwOvpH90kr+Ew@mail.gmail.com>
 <20191120181046.GA29650@unicorn.suse.cz>
 <CANn89iLfX2CYKU7hPZkPTNiUoCUyW2PLznsVnxomu4JEWmkefQ@mail.gmail.com>
 <20191120195226.GB29650@unicorn.suse.cz>
 <e9d19a66-94af-b4e8-255d-38a8cdc6f218@gmail.com>
 <20191120204948.GC29650@unicorn.suse.cz>
 <CANn89iJeq2CCBrdgt=fFxG3Uk7f4CHbLfsOM2S8q3ucC6znzEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJeq2CCBrdgt=fFxG3Uk7f4CHbLfsOM2S8q3ucC6znzEA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 12:57:48PM -0800, Eric Dumazet wrote:
> On Wed, Nov 20, 2019 at 12:49 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > Firo suggested something like
> >
> > ------------------------------------------------------------------------
> > --- a/net/ipv4/inet_hashtables.c
> > +++ b/net/ipv4/inet_hashtables.c
> > @@ -362,6 +362,8 @@ struct sock *__inet_lookup_established(struct net *net,
> >
> >  begin:
> >         sk_nulls_for_each_rcu(sk, node, &head->chain) {
> > +               if (unlikely(!node))
> > +                       goto begin;
> >                 if (sk->sk_hash != hash)
> >                         continue;
> >                 if (likely(INET_MATCH(sk, net, acookie,
> > ------------------------------------------------------------------------
> >
> > It depends on implementation details but I believe it would work. It
> > would be nicer if we could detect the switch to a listening socket but
> > I don't see how to make such test race free without introducing
> > unacceptable performance penalty.
> 
> No, we do not want to add more checks in the fast path really.
> 
> I was more thinking about not breaking the RCU invariants.
> 
> (ie : adding back the nulls stuff that I removed in 3b24d854cb35
> ("tcp/dccp: do not touch
> listener sk_refcnt under synflood")

Yes, that would do the trick. It would add some cycles to listener
lookup but that is less harm than slowing down established socket
lookup.

Michal
