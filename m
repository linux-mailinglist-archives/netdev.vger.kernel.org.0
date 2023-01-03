Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB03765C38B
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 17:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbjACQIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 11:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237750AbjACQH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 11:07:58 -0500
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4498A1274B;
        Tue,  3 Jan 2023 08:07:55 -0800 (PST)
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 303G7FEw010683;
        Tue, 3 Jan 2023 17:07:20 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 2171E120CE0;
        Tue,  3 Jan 2023 17:07:11 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1672762031; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ponzqwujCMdHaLQwY9lHikWod3tMARwfE8YEJshdl/A=;
        b=qe46ieEpr3ROhDlOWcethB2L4QKgD5B+j/cdgOtd1HkxKKqN7OnRFkAc3BJM/G2BKDf+5/
        nq0mpAnLe+WlInDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1672762031; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ponzqwujCMdHaLQwY9lHikWod3tMARwfE8YEJshdl/A=;
        b=Q8qKGxOdwppg7R3buoVuurgB4AQtrrEJYjFDdsE5YW5hE46nOFNEEQqmyd/+7PlHC8I1Wk
        q9lS70ffpliwc0xdOjpEfkcYujEdQ/N6WRQmoJ2kikdBLO5s/NtonVoDvF5vMT17peMKGs
        9bxpXzB9N/W2CqnpzB/O5iWdVJChQkbDh2yJ5QZBAgDHL8pLpZrDSYsvKFV3kYbe6Prpki
        VkU4V/HhdPVfqUl7WTgTq8pw2pa5a0zEgVnw63zzcEvzTCBaM5XLI0iuXqbm0Tw1FlYhD9
        oklZxf0U67GEFQ5WKPDGKBg/QIBEygOEK4tfCBTlAir5ijl+RZLuQqPoclg45A==
Date:   Tue, 3 Jan 2023 17:07:11 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jonathan Maxwell <jmaxwell37@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
Message-Id: <20230103170711.819921d40132494b4bfd6a0d@uniroma2.it>
In-Reply-To: <CAGHK07Crj8s0wOivw62Q_N4Km6r1qsH-y-8YgfYhX-JJF6kZSA@mail.gmail.com>
References: <20221218234801.579114-1-jmaxwell37@gmail.com>
        <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
        <CAGHK07ALtLTjRP-XOepqoc8xzWcT8=0v5ccL-98f4+SU9vwfsg@mail.gmail.com>
        <20221223212835.eb9d03f3f7db22360e34341d@uniroma2.it>
        <CAGHK07APOwLvhs73WKkQfZuEy2FoKEWJusSyejKVcth4D47g=w@mail.gmail.com>
        <CAGHK07Crj8s0wOivw62Q_N4Km6r1qsH-y-8YgfYhX-JJF6kZSA@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jon,
please see below, thanks.

On Tue, 3 Jan 2023 10:59:50 +1100
Jonathan Maxwell <jmaxwell37@gmail.com> wrote:

> Hi Andrea,
> 
> Happy New Year.
> 

Thank you, Happy New Year to you too and everybody on the mailing list as well.

> Any chance you could test this patch based on the latest net-next
> kernel and let me know the result?
> 
> diff --git a/include/net/dst_ops.h b/include/net/dst_ops.h
> index 88ff7bb2bb9b..632086b2f644 100644
> --- a/include/net/dst_ops.h
> +++ b/include/net/dst_ops.h
> @@ -16,7 +16,7 @@ struct dst_ops {
>         unsigned short          family;
>         unsigned int            gc_thresh;
> 
> -       int                     (*gc)(struct dst_ops *ops);
> +       void                    (*gc)(struct dst_ops *ops);
>         struct dst_entry *      (*check)(struct dst_entry *, __u32 cookie);
>         unsigned int            (*default_advmss)(const struct dst_entry *);
>         unsigned int            (*mtu)(const struct dst_entry *);
> diff --git a/net/core/dst.c b/net/core/dst.c
> index 6d2dd03dafa8..31c08a3386d3 100644
> --- a/net/core/dst.c
> +++ b/net/core/dst.c
> @@ -82,12 +82,8 @@ void *dst_alloc(struct dst_ops *ops, struct net_device *dev,
> 
>         if (ops->gc &&
>             !(flags & DST_NOCOUNT) &&
> -           dst_entries_get_fast(ops) > ops->gc_thresh) {
> -               if (ops->gc(ops)) {
> -                       pr_notice_ratelimited("Route cache is full:
> consider increasing sysctl net.ipv6.route.max_size.\n");
> -                       return NULL;
> -               }
> -       }
> +           dst_entries_get_fast(ops) > ops->gc_thresh)
> +               ops->gc(ops);
> 
>         dst = kmem_cache_alloc(ops->kmem_cachep, GFP_ATOMIC);
>         if (!dst)
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index e74e0361fd92..b643dda68d31 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -91,7 +91,7 @@ static struct dst_entry *ip6_negative_advice(struct
> dst_entry *);
>  static void            ip6_dst_destroy(struct dst_entry *);
>  static void            ip6_dst_ifdown(struct dst_entry *,
>                                        struct net_device *dev, int how);
> -static int              ip6_dst_gc(struct dst_ops *ops);
> +static void             ip6_dst_gc(struct dst_ops *ops);
> 
>  static int             ip6_pkt_discard(struct sk_buff *skb);
>  static int             ip6_pkt_discard_out(struct net *net, struct
> sock *sk, struct sk_buff *skb);
> @@ -3284,11 +3284,10 @@ struct dst_entry *icmp6_dst_alloc(struct
> net_device *dev,
>         return dst;
>  }
> 
> -static int ip6_dst_gc(struct dst_ops *ops)
> +static void ip6_dst_gc(struct dst_ops *ops)
>  {
>         struct net *net = container_of(ops, struct net, ipv6.ip6_dst_ops);
>         int rt_min_interval = net->ipv6.sysctl.ip6_rt_gc_min_interval;
> -       int rt_max_size = net->ipv6.sysctl.ip6_rt_max_size;
>         int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
>         int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
>         unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
> @@ -3296,11 +3295,10 @@ static int ip6_dst_gc(struct dst_ops *ops)
>         int entries;
> 
>         entries = dst_entries_get_fast(ops);
> -       if (entries > rt_max_size)
> +       if (entries > ops->gc_thresh)
>                 entries = dst_entries_get_slow(ops);
> 
> -       if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
> -           entries <= rt_max_size)
> +       if (time_after(rt_last_gc + rt_min_interval, jiffies))
>                 goto out;
> 
>         fib6_run_gc(atomic_inc_return(&net->ipv6.ip6_rt_gc_expire), net, true);
> @@ -3310,7 +3308,6 @@ static int ip6_dst_gc(struct dst_ops *ops)
>  out:
>         val = atomic_read(&net->ipv6.ip6_rt_gc_expire);
>         atomic_set(&net->ipv6.ip6_rt_gc_expire, val - (val >> rt_elasticity));
> -       return entries > rt_max_size;
>  }
> 
>  static int ip6_nh_lookup_table(struct net *net, struct fib6_config *cfg,
> @@ -6512,7 +6509,7 @@ static int __net_init ip6_route_net_init(struct net *net)
>  #endif
> 
>         net->ipv6.sysctl.flush_delay = 0;
> -       net->ipv6.sysctl.ip6_rt_max_size = 4096;
> +       net->ipv6.sysctl.ip6_rt_max_size = INT_MAX;
>         net->ipv6.sysctl.ip6_rt_gc_min_interval = HZ / 2;
>         net->ipv6.sysctl.ip6_rt_gc_timeout = 60*HZ;
>         net->ipv6.sysctl.ip6_rt_gc_interval = 30*HZ;
> 

Yes, I will apply this patch in the next days and check how it deals with the
seg6 subsystem. I will keep you posted.

Ciao,
Andrea

> On Sat, Dec 24, 2022 at 6:38 PM Jonathan Maxwell <jmaxwell37@gmail.com> wrote:
> >
> > On Sat, Dec 24, 2022 at 7:28 AM Andrea Mayer <andrea.mayer@uniroma2.it> wrote:
> > >
> > > Hi Jon,
> > > please see below, thanks.
> > >
> > > On Wed, 21 Dec 2022 08:48:11 +1100
> > > Jonathan Maxwell <jmaxwell37@gmail.com> wrote:
> > >
> > > > On Tue, Dec 20, 2022 at 11:35 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > >
> > > > > On Mon, 2022-12-19 at 10:48 +1100, Jon Maxwell wrote:
> > > > > > Sending Ipv6 packets in a loop via a raw socket triggers an issue where a
> > > > > > route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly
> > > > > > consumes the Ipv6 max_size threshold which defaults to 4096 resulting in
> > > > > > these warnings:
> > > > > >
> > > > > > [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > > > > > [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > > > > .
> > > > > > .
> > > > > > [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > > >
> > > > > If I read correctly, the maximum number of dst that the raw socket can
> > > > > use this way is limited by the number of packets it allows via the
> > > > > sndbuf limit, right?
> > > > >
> > > >
> > > > Yes, but in my test sndbuf limit is never hit so it clones a route for
> > > > every packet.
> > > >
> > > > e.g:
> > > >
> > > > output from C program sending 5000000 packets via a raw socket.
> > > >
> > > > ip raw: total num pkts 5000000
> > > >
> > > > # bpftrace -e 'kprobe:dst_alloc {@count[comm] = count()}'
> > > > Attaching 1 probe...
> > > >
> > > > @count[a.out]: 5000009
> > > >
> > > > > Are other FLOWI_FLAG_KNOWN_NH users affected, too? e.g. nf_dup_ipv6,
> > > > > ipvs, seg6?
> > > > >
> > > >
> > > > Any call to ip6_pol_route(s) where no res.nh->fib_nh_gw_family is 0 can do it.
> > > > But we have only seen this for raw sockets so far.
> > > >
> > >
> > > In the SRv6 subsystem, the seg6_lookup_nexthop() is used by some
> > > cross-connecting behaviors such as End.X and End.DX6 to forward traffic to a
> > > specified nexthop. SRv6 End.X/DX6 can specify an IPv6 DA (i.e., a nexthop)
> > > different from the one carried by the IPv6 header. For this purpose,
> > > seg6_lookup_nexthop() sets the FLOWI_FLAG_KNOWN_NH.
> > >
> > Hi Andrea,
> >
> > Thanks for pointing that datapath out. The more generic approach we are
> > taking bringing Ipv6 closer to Ipv4 in this regard should fix all instances
> > of this.
> >
> > > > > > [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > > > > > [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > > > > .
> > > > > > .
> > > > > > [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > >
> > > I can reproduce the same warning messages reported by you, by instantiating an
> > > End.X behavior whose nexthop is handled by a route for which there is no "via".
> > > In this configuration, the ip6_pol_route() (called by seg6_lookup_nexthop())
> > > triggers ip6_rt_cache_alloc() because i) the FLOWI_FLAG_KNOWN_NH is present ii)
> > > and the res.nh->fib_nh_gw_family is 0 (as already pointed out).
> > >
> >
> > Nice, when I get back after the holiday break I'll submit the next patch. It
> > would be great if you could test the new patch and let me know how it works in
> > your tests at that juncture. I'll keep you posted.
> >
> > Regards
> >
> > Jon
> >
> > > > Regards
> > > >
> > > > Jon
> > >
> > > Ciao,
> > > Andrea


-- 
Andrea Mayer <andrea.mayer@uniroma2.it>
