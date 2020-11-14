Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874E22B3153
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 00:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgKNXDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 18:03:53 -0500
Received: from smtp.netregistry.net ([202.124.241.204]:41042 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgKNXDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 18:03:53 -0500
Received: from 124-148-94-203.tpgi.com.au ([124.148.94.203]:41306 helo=192-168-1-16.tpgi.com.au)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1ke4a9-0007y9-Kj; Sun, 15 Nov 2020 10:03:48 +1100
Date:   Sun, 15 Nov 2020 09:03:43 +1000
From:   Russell Strong <russell@strong.id.au>
To:     Guillaume Nault <gnault@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing
Message-ID: <20201115090343.447ad8b8@192-168-1-16.tpgi.com.au>
In-Reply-To: <20201113090225.GA25425@linux.home>
References: <20201113120637.39c45f3f@192-168-1-16.tpgi.com.au>
        <20201112193656.73621cd5@hermes.local>
        <20201113090225.GA25425@linux.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated-User: russell@strong.id.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 10:02:25 +0100
Guillaume Nault <gnault@redhat.com> wrote:

> On Thu, Nov 12, 2020 at 07:36:56PM -0800, Stephen Hemminger wrote:
> > On Fri, 13 Nov 2020 12:06:37 +1000
> > Russell Strong <russell@strong.id.au> wrote:
> >   
> > > diff --git a/include/uapi/linux/in_route.h
> > > b/include/uapi/linux/in_route.h index 0cc2c23b47f8..db5d236b9c50
> > > 100644 --- a/include/uapi/linux/in_route.h
> > > +++ b/include/uapi/linux/in_route.h
> > > @@ -28,6 +28,6 @@
> > >  
> > >  #define RTCF_NAT	(RTCF_DNAT|RTCF_SNAT)
> > >  
> > > -#define RT_TOS(tos)	((tos)&IPTOS_TOS_MASK)
> > > +#define RT_TOS(tos)	((tos)&IPTOS_DS_MASK)
> > >    
> > 
> > Changing behavior of existing header files risks breaking
> > applications. 
> > > diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
> > > index ce54a30c2ef1..1499105d1efd 100644
> > > --- a/net/ipv4/fib_rules.c
> > > +++ b/net/ipv4/fib_rules.c
> > > @@ -229,7 +229,7 @@ static int fib4_rule_configure(struct fib_rule
> > > *rule, struct sk_buff *skb, int err = -EINVAL;
> > >  	struct fib4_rule *rule4 = (struct fib4_rule *) rule;
> > >  
> > > -	if (frh->tos & ~IPTOS_TOS_MASK) {
> > > +	if (frh->tos & ~IPTOS_RT_MASK) {  
> > 
> > This needs to be behind a sysctl and the default has to be to keep
> > the old behavior  
> 
> Can't we just define a new DSCP mask and replace the users of TOS one
> by one? In most cases DSCP just makes the 3 highest bits available,
> which souldn't change existing behaviours. We just need to pay
> attention to the ECN bit that'd be masked out by DSCP but not by old
> TOS. However, ECN has been supported for a long time, so most usages
> of TOS already clear both ECN bits.
> 
> Let's not add a new sysctl if not necessary and, in any case, let's
> not change macros blindly.
> 

I've implemented the change ( patches to follow ) using a sysctl and
did some playing around with it.  There are some odd behaviours that
aren't intuitive to a user.

With the sysctl off:
]# ip rule add dsfield EF lookup 1234
Error: Invalid tos.

Turning the sysctl on:
]# sysctl net.ipv4.route_tos_as_dscp=1
]# ip rule add dsfield EF lookup 1234
]# ip route add prohibit 8.8.8.8 table 1234
]# ping 8.8.8.8
64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=31.2 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=115 time=23.7 ms
]# ping 8.8.8.8 -Q 0xb8
ping: Do you want to ping broadcast? Then -b. If not, check your local
firewall rules

All good.

Turning the sysctl off again:
]# sysctl net.ipv4.route_tos_as_dscp=0
]# ip rule
]# ip rule
0:	from all lookup local
32765:	from all tos EF lookup 1234
32766:	from all lookup main
32767:	from all lookup default

The rule is still present.  So as a user I would expect it to work...
But....

]# ping 8.8.8.8 -Q 0xb8
64 bytes from 8.8.8.8: icmp_seq=2 ttl=115 time=23.2 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=115 time=23.9 ms

The rule is no longer triggered.  Which is what I would expect.
But users may not.

So my questions would be:

What should happen here?
Should clearing the sysctl remove rules that could no longer be added?
Is clearing the rules even more confusing?
Is Guillaume's suggestion the right way as it avoids the confusion?

iproute2 is already presenting dscp to the users. I didn't modify
it.

Thanks,

Russell Strong


