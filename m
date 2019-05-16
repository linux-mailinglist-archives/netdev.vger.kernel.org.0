Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24BA920F70
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 22:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfEPUDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 16:03:15 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38358 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfEPUDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 16:03:14 -0400
Received: by mail-ot1-f65.google.com with SMTP id s19so4631969otq.5
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 13:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rm/qjQCxmkL0fG0/QYSrKGRFi+aPLwCrWebdzc/V9fM=;
        b=E9x0dyvPdcCryXTxSrMdGhif2YxcA0J6VU7/sAMs/bhDLJu+FPvhTDvXSyhn4to5Wh
         rW/+hR1ZOOBJXuIBJCxv6o5ND9fefq1evRbkubEjF8xximkn33eVrY47dGUUonvRZUdz
         focZGMLNGvFfYYwOwwlA/oQgsZwahF8/pbmg9dduXhdONuuMBHnHFCkcfw7C9oEhVdOa
         Z5poK/ZWqRyudQKo6aFAtUMwH8TuVT8hE1WDgqxbV9nAfTskrvjPyn8XeXm7fanUnp6X
         UFNQB5xcYbTlymVOOzK7fnQFjaxJ6oqtBE1Ulwlbxtn0no324T28XxW9HHsjJjIG8jXo
         D4iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rm/qjQCxmkL0fG0/QYSrKGRFi+aPLwCrWebdzc/V9fM=;
        b=C8oucQBzs1od5uOIO7a/pFUfVLKyYLBElEHWRUfKlbS3RMzA2kHcMBqj0MHJk18yBR
         fbSmCOkYqHima+ThE7MjTqrHIevskGBl9l7X+vY3jkJ+VkLgP2eiwQO7tQu57TL25f7o
         wexY3BfUwRMGdYsvUW6HkLdtY/09G5hO62GPSdOBLmmt7rJm3JWxXzz5mT22y0u7f/CL
         /5eM4II8RtPuzmDFnpExkEHLtmlz89+shL+ktjPCGVmroNOwFqz+xXkGB51CirGrmWon
         vjQREo/DR2jRnWecbSxe3g2geVBQ8xMKU7+8VFjdYiZt+ufiJ753/ADYfNIW+oGShxKh
         UPgg==
X-Gm-Message-State: APjAAAXxoejT+tkm26j0XV4YGhw8NJJmCKtkQp/1e5y7VsZx4xPa1zhg
        OgC3wRXlWf0H6hPqYsC+Il5CA5u5Tg3ZeCkLpYlaEA==
X-Google-Smtp-Source: APXvYqzX0fcj0N/3BUxXW9cPkjTJNjUFwoHhbJSJVCPIG+RSfskvEskwzWcWqQCCJSuo/vYPT0vx04ytXZIyFKzfjzk=
X-Received: by 2002:a9d:538a:: with SMTP id w10mr17400704otg.343.1558036993462;
 Thu, 16 May 2019 13:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190516181620.126962-1-tracywwnj@gmail.com> <20190516191516.mceg7ufus5nzstie@kafai-mbp>
In-Reply-To: <20190516191516.mceg7ufus5nzstie@kafai-mbp>
From:   Wei Wang <weiwan@google.com>
Date:   Thu, 16 May 2019 13:02:38 -0700
Message-ID: <CAEA6p_AO-JEpx5nsp3fQv3ApjTV_ondiJM9Jh4j0fWPxUhSsFw@mail.gmail.com>
Subject: Re: [PATCH v2 net] ipv6: fix src addr routing with the exception table
To:     Martin Lau <kafai@fb.com>
Cc:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 12:15 PM Martin Lau <kafai@fb.com> wrote:
>
> On Thu, May 16, 2019 at 11:16:20AM -0700, Wei Wang wrote:
> > From: Wei Wang <weiwan@google.com>
> >
> > When inserting route cache into the exception table, the key is
> > generated with both src_addr and dest_addr with src addr routing.
> > However, current logic always assumes the src_addr used to generate the
> > key is a /128 host address. This is not true in the following scenarios:
> > 1. When the route is a gateway route or does not have next hop.
> >    (rt6_is_gw_or_nonexthop() == false)
> > 2. When calling ip6_rt_cache_alloc(), saddr is passed in as NULL.
> > This means, when looking for a route cache in the exception table, we
> > have to do the lookup twice: first time with the passed in /128 host
> > address, second time with the src_addr stored in fib6_info.
> >
> > This solves the pmtu discovery issue reported by Mikael Magnusson where
> > a route cache with a lower mtu info is created for a gateway route with
> > src addr. However, the lookup code is not able to find this route cache.
> >
> > Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
> > Reported-by: Mikael Magnusson <mikael.kernel@lists.m7n.se>
> > Bisected-by: David Ahern <dsahern@gmail.com>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > Cc: Martin Lau <kafai@fb.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > ---
> > Changes from v1:
> > - restructure the code to only include the new logic in
> >   rt6_find_cached_rt()
> > ---
> >  net/ipv6/route.c | 49 +++++++++++++++++++++++++-----------------------
> >  1 file changed, 26 insertions(+), 23 deletions(-)
> >
> > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > index 23a20d62daac..35873b57c7f1 100644
> > --- a/net/ipv6/route.c
> > +++ b/net/ipv6/route.c
> > @@ -111,8 +111,8 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
> >                        int iif, int type, u32 portid, u32 seq,
> >                        unsigned int flags);
> >  static struct rt6_info *rt6_find_cached_rt(const struct fib6_result *res,
> > -                                        struct in6_addr *daddr,
> > -                                        struct in6_addr *saddr);
> > +                                        const struct in6_addr *daddr,
> > +                                        const struct in6_addr *saddr);
> >
> >  #ifdef CONFIG_IPV6_ROUTE_INFO
> >  static struct fib6_info *rt6_add_route_info(struct net *net,
> > @@ -1566,31 +1566,44 @@ void rt6_flush_exceptions(struct fib6_info *rt)
> >   * Caller has to hold rcu_read_lock()
> >   */
> >  static struct rt6_info *rt6_find_cached_rt(const struct fib6_result *res,
> > -                                        struct in6_addr *daddr,
> > -                                        struct in6_addr *saddr)
> > +                                        const struct in6_addr *daddr,
> > +                                        const struct in6_addr *saddr)
> >  {
> >       struct rt6_exception_bucket *bucket;
> >       struct in6_addr *src_key = NULL;
> >       struct rt6_exception *rt6_ex;
> >       struct rt6_info *ret = NULL;
> >
> > -     bucket = rcu_dereference(res->f6i->rt6i_exception_bucket);
> > -
> >  #ifdef CONFIG_IPV6_SUBTREES
> >       /* fib6i_src.plen != 0 indicates f6i is in subtree
> >        * and exception table is indexed by a hash of
> >        * both fib6_dst and fib6_src.
> > -      * Otherwise, the exception table is indexed by
> > -      * a hash of only fib6_dst.
> > +      * However, the src addr used to create the hash
> > +      * might not be exactly the passed in saddr which
> > +      * is a /128 addr from the flow.
> > +      * So we need to use f6i->fib6_src to redo lookup
> > +      * if the passed in saddr does not find anything.
> > +      * (See the logic in ip6_rt_cache_alloc() on how
> > +      * rt->rt6i_src is updated.)
> >        */
> >       if (res->f6i->fib6_src.plen)
> >               src_key = saddr;
> > +find_ex:
> >  #endif
> > +     bucket = rcu_dereference(res->f6i->rt6i_exception_bucket);
> >       rt6_ex = __rt6_find_exception_rcu(&bucket, daddr, src_key);
> >
> >       if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
> >               ret = rt6_ex->rt6i;
> >
> > +#ifdef CONFIG_IPV6_SUBTREES
> > +     /* Use fib6_src as src_key and redo lookup */
> > +     if (!ret && src_key == saddr) {
> I am worry about the "src_key == saddr" check.
> e.g. what if "saddr == &res->f6i->fib6_src.addr" in the future.
>
> May be "!ret && src_key && src_key != &res->f6i->fib6_src.addr"?
>
> Other than that,
> Acked-by: Martin KaFai Lau <kafai@fb.com>
>
> Thanks for the v2.
>
Hmm... That does seem to be a valid concern, although it is very
unlikely I think...
But to be safe, the check you proposed looks good to me. I will change it in v3.

> > +             src_key = &res->f6i->fib6_src.addr;
> > +             goto find_ex;
> > +     }
> > +#endif
> > +
> >       return ret;
> >  }
