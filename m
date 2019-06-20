Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75054D9E8
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfFTTBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:01:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32637 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfFTTBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:01:20 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8358F308621B;
        Thu, 20 Jun 2019 19:01:20 +0000 (UTC)
Received: from localhost (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19281601B6;
        Thu, 20 Jun 2019 19:01:16 +0000 (UTC)
Date:   Thu, 20 Jun 2019 21:01:13 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6 04/11] ipv4: Dump route exceptions if
 requested
Message-ID: <20190620210113.6aa2c022@redhat.com>
In-Reply-To: <777387d8-fa15-388e-875a-02aa5df977dd@gmail.com>
References: <cover.1560987611.git.sbrivio@redhat.com>
        <b5aacd9a3a3f4b256dfd091cdd8771d0f6a1aea2.1560987611.git.sbrivio@redhat.com>
        <777387d8-fa15-388e-875a-02aa5df977dd@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 20 Jun 2019 19:01:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 07:31:32 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/19/19 5:59 PM, Stefano Brivio wrote:
> > diff --git a/include/net/route.h b/include/net/route.h
> > index 065b47754f05..e7f65388a6d4 100644
> > --- a/include/net/route.h
> > +++ b/include/net/route.h
> > @@ -44,6 +44,7 @@
> >  #define RT_CONN_FLAGS_TOS(sk,tos)   (RT_TOS(tos) | sock_flag(sk, SOCK_LOCALROUTE))
> >  
> >  struct fib_nh;
> > +struct fib_alias;
> >  struct fib_info;
> >  struct uncached_list;
> >  struct rtable {  
> 
> we should not expose fib_alias to route.c.

I was also not enthusiastic about that, but...:

> > @@ -230,6 +231,9 @@ void fib_modify_prefix_metric(struct in_ifaddr *ifa, u32 new_metric);
> >  void rt_add_uncached_list(struct rtable *rt);
> >  void rt_del_uncached_list(struct rtable *rt);
> >  
> > +int fnhe_dump_buckets(struct fib_alias *fa, int nhsel, struct sk_buff *skb,
> > +		      struct netlink_callback *cb, int *fa_index, int fa_start);
> > +
> >  static inline void ip_rt_put(struct rtable *rt)
> >  {
> >  	/* dst_release() accepts a NULL parameter.
> > diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> > index 94e5d83db4db..03f51e5192e5 100644
> > --- a/net/ipv4/fib_trie.c
> > +++ b/net/ipv4/fib_trie.c
> > @@ -2078,28 +2078,51 @@ void fib_free_table(struct fib_table *tb)
> >  	call_rcu(&tb->rcu, __trie_free_rcu);
> >  }
> >  
> > +static int fib_dump_fnhe_from_leaf(struct fib_alias *fa, struct sk_buff *skb,
> > +				   struct netlink_callback *cb,
> > +				   int *fa_index, int fa_start)
> > +{
> > +	struct fib_info *fi = fa->fa_info;
> > +	int nhsel;
> > +
> > +	if (!fi || fi->fib_flags & RTNH_F_DEAD)
> > +		return 0;
> > +
> > +	for (nhsel = 0; nhsel < fib_info_num_path(fi); nhsel++) {
> > +		int err;
> > +
> > +		err = fnhe_dump_buckets(fa, nhsel, skb, cb, fa_index, fa_start);
> > +		if (err)
> > +			return err;
> > +	}
> > +
> > +	return 0;
> > +}  
> 
> fib_info would be the better argument to pass in to the fnhe dump, and

...we need to pass the table ID to rt_fill_info(). Sure, I can pass
that explicitly, but doing so kind of tells me I'm not passing the
right argument, with sufficient information. What do you think?

> I think the loop over where the bucket is should be in route.c as well.
> So how about fib_info_dump_fnhe() as the helper exposed from route.c,
> and it does the loop over nexthops and calls fnhe_dump_buckets.

Yes, I could do that conveniently if I'm passing a fib_info there. I'm
stlll undecided if it's worth it, I guess I don't really have a
preference.

> As for the loop, you could fill an skb without finishing a bucket inside
> of a nexthop so you need top track which nexthop is current as well.

I think this is not a problem, and also checked that selftests trigger
this. Buckets are transparent to the counter for partial dumps (s_fa),
they are just an arbitrary grouping from that perspective, just like
items on the chain for the same bucket.

Take this example, s_i values in [], s_fa values in ():

  node (fa) #1 [1]
    nexthop #1
    bucket #1 -> #0 in chain (1)
    bucket #2 -> #0 in chain (2) -> #1 in chain (3) -> #2 in chain (4)
    bucket #3 -> #0 in chain (5) -> #1 in chain (6)

    nexthop #2
    bucket #1 -> #0 in chain (7) -> #1 in chain (8)
    bucket #2 -> #0 in chain (9)
  --
  node (fa) #2 [2]
    nexthop #1
    bucket #1 -> #0 in chain (1) -> #1 in chain (2)
    bucket #2 -> #0 in chain (3)


If I stop at (3), (4), (7) for "node #1", or at (2) for "node #2", it
doesn't really matter, because nexthops and buckets are always
traversed in the same way (walking flattens all that).

For IPv4, I could even drop the in-tree/in-node distinction (s_i/s_fa).
But accounting becomes terribly inconvenient though, and it would be
inconsistent with what I needed to do for IPv6 (skip/skip_in_node): we
have 'sernum' there, which is used to mark what node we need to restart
from in case of changes. Within a node, however, I can't make any
assumptions like that, so if the fib6 tree changes, I'll restart from
the beginning of the node (see discussion with Martin on v1).

My idea would be to keep it like it is at the moment, and later make it
as "accurate" as it is on IPv6, introducing something like 'sernum'. If
we start with this, it will be more convenient to do that later.

-- 
Stefano
