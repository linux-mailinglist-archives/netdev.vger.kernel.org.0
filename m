Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEC2C93DA
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbfJBVyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:54:25 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41372 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbfJBVyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:54:25 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iFmZd-0005nW-C8; Wed, 02 Oct 2019 23:54:17 +0200
Date:   Wed, 2 Oct 2019 23:54:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] ipv6: drop incoming packets having a v4mapped source
 address
Message-ID: <20191002215417.GB13866@breakpoint.cc>
References: <20191002163855.145178-1-edumazet@google.com>
 <20191002183856.GA13866@breakpoint.cc>
 <CANn89iLsrAm80Snk9YzEASWtrskqWFpEU11Y253pt1S=75B4wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLsrAm80Snk9YzEASWtrskqWFpEU11Y253pt1S=75B4wA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:
> > > @@ -223,6 +223,16 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> > >       if (ipv6_addr_is_multicast(&hdr->saddr))
> > >               goto err;
> > >
> > > +     /* While RFC4291 is not explicit about v4mapped addresses
> > > +      * in IPv6 headers, it seems clear linux dual-stack
> > > +      * model can not deal properly with these.
> > > +      * Security models could be fooled by ::ffff:127.0.0.1 for example.
> > > +      *
> > > +      * https://tools.ietf.org/html/draft-itojun-v6ops-v4mapped-harmful-02
> > > +      */
> > > +     if (ipv6_addr_v4mapped(&hdr->saddr))
> > > +             goto err;
> > > +
> >
> > Any reason to only consider ->saddr instead of checking daddr as well?
> 
> I do not see reasons the packet should be accepted for sane configurations ?

Fair enough, thanks for explaining.
