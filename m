Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064056686F4
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 23:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240413AbjALW3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 17:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240478AbjALW3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 17:29:08 -0500
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7DA34D67;
        Thu, 12 Jan 2023 14:27:09 -0800 (PST)
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 30CMQbhM014797;
        Thu, 12 Jan 2023 23:26:43 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 5D67A1228D5;
        Thu, 12 Jan 2023 23:26:33 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1673562393; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JMxNME3ozDwNUAcYbk5SZUzo9XYZXZMkq+hwpZ7QsMI=;
        b=voiTp0xTyceKV2LU6Ix0hCIOHdqVm5jPITTYboNFQz/hyV4PnDXKjVt0oIRydaD7zA6x1X
        XeiLDB8hTeQn8qCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1673562393; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JMxNME3ozDwNUAcYbk5SZUzo9XYZXZMkq+hwpZ7QsMI=;
        b=VTPX71qrVTSR8eudbSopYZqGWMip7xM8wNs9Hd1Tx99jvP4p+LD84H5/MOnZkM5RkNOcw8
        DSeQJjL9zh8jpJyuzgn3+zu2JKlevG/aWMhXBoDzzkOQQIEr6SMti+8kU9sWX5+kTPeHyy
        wNlPPguO2hndTiPnX274YCP/ggX1q3xTjwMBSSpj/nv4bLsceccim19kLmt+ShTEKTT2+D
        QLp1GgZQLz3DjfuX2EO8B2wFiCZwcJxU99m76DbMNCpiphH3Vyler3VOaYae6qqC9eC0B7
        8QnVpXJUkVhdetMN0fjFLZ89bCeB95cCpJPskKfGobNMzsi4zu1XelzqxVuu2Q==
Date:   Thu, 12 Jan 2023 23:26:33 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jonathan Maxwell <jmaxwell37@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        martin.lau@kernel.org, joel@joelfernandes.org, paulmck@kernel.org,
        eyal.birger@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next v2] ipv6: remove max_size check inline with ipv4
Message-Id: <20230112232633.02e120f0f589e124ee986dc7@uniroma2.it>
In-Reply-To: <CAGHK07DvW1NmfWE+6tFEpY3tkNpFYXitebJh1o8HYk_1=MdoaQ@mail.gmail.com>
References: <20230112012532.311021-1-jmaxwell37@gmail.com>
        <20230112214140.b490f5e77e46d9cdab53d2b2@uniroma2.it>
        <CAGHK07DvW1NmfWE+6tFEpY3tkNpFYXitebJh1o8HYk_1=MdoaQ@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Jan 2023 08:48:24 +1100
Jonathan Maxwell <jmaxwell37@gmail.com> wrote:

> Hi Andrea,
> 
> On Fri, Jan 13, 2023 at 7:41 AM Andrea Mayer <andrea.mayer@uniroma2.it> wrote:
> >
> > Hi Jon,
> >
> > On Thu, 12 Jan 2023 12:25:32 +1100
> > Jon Maxwell <jmaxwell37@gmail.com> wrote:
> >
> > > v2: Correct syntax error in net/ipv6/route.c
> > >
> > > In ip6_dst_gc() replace:
> > >
> > > if (entries > gc_thresh)
> > >
> > > With:
> > >
> > > if (entries > ops->gc_thresh)
> > >
> > > Sending Ipv6 packets in a loop via a raw socket triggers an issue where a
> > > route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly
> > > consumes the Ipv6 max_size threshold which defaults to 4096 resulting in
> > > these warnings:
> > >
> > > [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > > [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > .
> > > .
> > > [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > >
> > > When this happens the packet is dropped and sendto() gets a network is
> > > unreachable error:
> > >
> > > # ./a.out -s
> > >
> > > remaining pkt 200557 errno 101
> > > remaining pkt 196462 errno 101
> > > .
> > > .
> > > remaining pkt 126821 errno 101
> > >
> > > Implement David Aherns suggestion to remove max_size check seeing that Ipv6
> > > has a GC to manage memory usage. Ipv4 already does not check max_size.
> > >
> > > Here are some memory comparisons for Ipv4 vs Ipv6 with the patch:
> > >
> > > Test by running 5 instances of a program that sends UDP packets to a raw
> > > socket 5000000 times. Compare Ipv4 and Ipv6 performance with a similar
> > > program.
> > >
> > > Ipv4:
> > >
> >
> > is it supposed to be Ipv6, right?
> >
> 
> No, That is for Ipv4, DavidA asked me to include a comparison between Ipv4
> and Ipv6.  So that is taken for a test running 5 processes that sends 5000000
> packets on  an ipv4 raw socket. If you scroll down, Ipv6 memory statistics
> are under "Ipv6 with patch:".
> 

I asked because these tests also report ip6_dst_cache counters that I would not
have expected to find in IPv4 cases (and viceversa).

Thanks for the clarification.

Ciao,
Andrea

> Regards
> 
> Jon
> 
> > Ciao,
> > Andrea
> >
> > > Before test:
> > >
> > > # grep -e Slab -e Free /proc/meminfo
> > > MemFree:        29427108 kB
> > > Slab:             237612 kB
> > >
> > > # grep dst_cache /proc/slabinfo
> > > ip6_dst_cache       1912   2528    256   32    2 : tunables    0    0    0
> > > xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0
> > > ip_dst_cache        2881   3990    192   42    2 : tunables    0    0    0
> > >
> > > During test:
> > >
> > > # grep -e Slab -e Free /proc/meminfo
> > > MemFree:        29417608 kB
> > > Slab:             247712 kB
> > >
> > > # grep dst_cache /proc/slabinfo
> > > ip6_dst_cache       1912   2528    256   32    2 : tunables    0    0    0
> > > xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0
> > > ip_dst_cache       44394  44394    192   42    2 : tunables    0    0    0
> > >
> > > After test:
> > >
> > > # grep -e Slab -e Free /proc/meminfo
> > > MemFree:        29422308 kB
> > > Slab:             238104 kB
> > >
> > > # grep dst_cache /proc/slabinfo
> > > ip6_dst_cache       1912   2528    256   32    2 : tunables    0    0    0
> > > xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0
> > > ip_dst_cache        3048   4116    192   42    2 : tunables    0    0    0
> > >
> > > Ipv6 with patch:
> > >
> > > Errno 101 errors are not observed anymore with the patch.
> > >
> > > Before test:
> > >
> > > # grep -e Slab -e Free /proc/meminfo
> > > MemFree:        29422308 kB
> > > Slab:             238104 kB
> > >
> > > # grep dst_cache /proc/slabinfo
> > > ip6_dst_cache       1912   2528    256   32    2 : tunables    0    0    0
> > > xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0
> > > ip_dst_cache        3048   4116    192   42    2 : tunables    0    0    0
> > >
> > > During Test:
> > >
> > > # grep -e Slab -e Free /proc/meminfo
> > > MemFree:        29431516 kB
> > > Slab:             240940 kB
> > >
> > > # grep dst_cache /proc/slabinfo
> > > ip6_dst_cache      11980  12064    256   32    2 : tunables    0    0    0
> > > xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0
> > > ip_dst_cache        3048   4116    192   42    2 : tunables    0    0    0
> > >
> > > After Test:
> > >
> > > # grep -e Slab -e Free /proc/meminfo
> > > MemFree:        29441816 kB
> > > Slab:             238132 kB
> > >
> > > # grep dst_cache /proc/slabinfo
> > > ip6_dst_cache       1902   2432    256   32    2 : tunables    0    0    0
> > > xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0
> > > ip_dst_cache        3048   4116    192   42    2 : tunables    0    0    0
> > >
> > > Tested-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> > > Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> > > ---
> > >  include/net/dst_ops.h |  2 +-
> > >  net/core/dst.c        |  8 ++------
> > >  net/ipv6/route.c      | 13 +++++--------
> > >  3 files changed, 8 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/include/net/dst_ops.h b/include/net/dst_ops.h
> > > index 88ff7bb2bb9b..632086b2f644 100644
> > > --- a/include/net/dst_ops.h
> > > +++ b/include/net/dst_ops.h
> > > @@ -16,7 +16,7 @@ struct dst_ops {
> > >       unsigned short          family;
> > >       unsigned int            gc_thresh;
> > >
> > > -     int                     (*gc)(struct dst_ops *ops);
> > > +     void                    (*gc)(struct dst_ops *ops);
> > >       struct dst_entry *      (*check)(struct dst_entry *, __u32 cookie);
> > >       unsigned int            (*default_advmss)(const struct dst_entry *);
> > >       unsigned int            (*mtu)(const struct dst_entry *);
> > > diff --git a/net/core/dst.c b/net/core/dst.c
> > > index 6d2dd03dafa8..31c08a3386d3 100644
> > > --- a/net/core/dst.c
> > > +++ b/net/core/dst.c
> > > @@ -82,12 +82,8 @@ void *dst_alloc(struct dst_ops *ops, struct net_device *dev,
> > >
> > >       if (ops->gc &&
> > >           !(flags & DST_NOCOUNT) &&
> > > -         dst_entries_get_fast(ops) > ops->gc_thresh) {
> > > -             if (ops->gc(ops)) {
> > > -                     pr_notice_ratelimited("Route cache is full: consider increasing sysctl net.ipv6.route.max_size.\n");
> > > -                     return NULL;
> > > -             }
> > > -     }
> > > +         dst_entries_get_fast(ops) > ops->gc_thresh)
> > > +             ops->gc(ops);
> > >
> > >       dst = kmem_cache_alloc(ops->kmem_cachep, GFP_ATOMIC);
> > >       if (!dst)
> > > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > > index e74e0361fd92..b643dda68d31 100644
> > > --- a/net/ipv6/route.c
> > > +++ b/net/ipv6/route.c
> > > @@ -91,7 +91,7 @@ static struct dst_entry *ip6_negative_advice(struct dst_entry *);
> > >  static void          ip6_dst_destroy(struct dst_entry *);
> > >  static void          ip6_dst_ifdown(struct dst_entry *,
> > >                                      struct net_device *dev, int how);
> > > -static int            ip6_dst_gc(struct dst_ops *ops);
> > > +static void           ip6_dst_gc(struct dst_ops *ops);
> > >
> > >  static int           ip6_pkt_discard(struct sk_buff *skb);
> > >  static int           ip6_pkt_discard_out(struct net *net, struct sock *sk, struct sk_buff *skb);
> > > @@ -3284,11 +3284,10 @@ struct dst_entry *icmp6_dst_alloc(struct net_device *dev,
> > >       return dst;
> > >  }
> > >
> > > -static int ip6_dst_gc(struct dst_ops *ops)
> > > +static void ip6_dst_gc(struct dst_ops *ops)
> > >  {
> > >       struct net *net = container_of(ops, struct net, ipv6.ip6_dst_ops);
> > >       int rt_min_interval = net->ipv6.sysctl.ip6_rt_gc_min_interval;
> > > -     int rt_max_size = net->ipv6.sysctl.ip6_rt_max_size;
> > >       int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
> > >       int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
> > >       unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
> > > @@ -3296,11 +3295,10 @@ static int ip6_dst_gc(struct dst_ops *ops)
> > >       int entries;
> > >
> > >       entries = dst_entries_get_fast(ops);
> > > -     if (entries > rt_max_size)
> > > +     if (entries > ops->gc_thresh)
> > >               entries = dst_entries_get_slow(ops);
> > >
> > > -     if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
> > > -         entries <= rt_max_size)
> > > +     if (time_after(rt_last_gc + rt_min_interval, jiffies))
> > >               goto out;
> > >
> > >       fib6_run_gc(atomic_inc_return(&net->ipv6.ip6_rt_gc_expire), net, true);
> > > @@ -3310,7 +3308,6 @@ static int ip6_dst_gc(struct dst_ops *ops)
> > >  out:
> > >       val = atomic_read(&net->ipv6.ip6_rt_gc_expire);
> > >       atomic_set(&net->ipv6.ip6_rt_gc_expire, val - (val >> rt_elasticity));
> > > -     return entries > rt_max_size;
> > >  }
> > >
> > >  static int ip6_nh_lookup_table(struct net *net, struct fib6_config *cfg,
> > > @@ -6512,7 +6509,7 @@ static int __net_init ip6_route_net_init(struct net *net)
> > >  #endif
> > >
> > >       net->ipv6.sysctl.flush_delay = 0;
> > > -     net->ipv6.sysctl.ip6_rt_max_size = 4096;
> > > +     net->ipv6.sysctl.ip6_rt_max_size = INT_MAX;
> > >       net->ipv6.sysctl.ip6_rt_gc_min_interval = HZ / 2;
> > >       net->ipv6.sysctl.ip6_rt_gc_timeout = 60*HZ;
> > >       net->ipv6.sysctl.ip6_rt_gc_interval = 30*HZ;
> > > --
> > > 2.31.1


-- 
Andrea Mayer <andrea.mayer@uniroma2.it>
