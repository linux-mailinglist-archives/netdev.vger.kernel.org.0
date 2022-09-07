Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1F05B0FF8
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 00:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiIGWn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 18:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIGWn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 18:43:28 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4271666A50
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 15:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662590607; x=1694126607;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cCrIv87n0I2CAUezZ+MB5XPN22XKAFKcVnZxvTbYOgE=;
  b=XyNoIxrppreoJxN0cRzvmi6NhsJz0b00+L4Z1ZaDiMxa8s3ylErBoMm3
   TqoymjEChDFV2bkrfxT94CB9WOie4Xg04oXLmf+fQzdIG60HmhSIAQh3Q
   vQ8ZF2doaxUFVZh0zLLELiQi9sBd1VbjT+clKr7/BduSZwHwl+6R8w/P3
   s=;
X-IronPort-AV: E=Sophos;i="5.93,298,1654560000"; 
   d="scan'208";a="127737565"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-d803d33a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 22:43:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-d803d33a.us-west-2.amazon.com (Postfix) with ESMTPS id A847781309;
        Wed,  7 Sep 2022 22:43:10 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 7 Sep 2022 22:43:09 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.172) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Wed, 7 Sep 2022 22:43:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v5 net-next 6/6] tcp: Introduce optional per-netns ehash.
Date:   Wed, 7 Sep 2022 15:43:00 -0700
Message-ID: <20220907224300.37277-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iLHReCZF8k0PT7-5kvfZeZOF590obNN3i25jKcd--2Siw@mail.gmail.com>
References: <CANn89iLHReCZF8k0PT7-5kvfZeZOF590obNN3i25jKcd--2Siw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.172]
X-ClientProxiedBy: EX13D45UWB004.ant.amazon.com (10.43.161.54) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Sep 2022 14:57:14 -0700
> On Wed, Sep 7, 2022 at 2:47 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Wed, 7 Sep 2022 13:55:08 -0700
> > > On Tue, Sep 6, 2022 at 5:57 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > The more sockets we have in the hash table, the longer we spend looking
> > > > up the socket.  While running a number of small workloads on the same
> > > > host, they penalise each other and cause performance degradation.
> > > >
> > > > The root cause might be a single workload that consumes much more
> > > > resources than the others.  It often happens on a cloud service where
> > > > different workloads share the same computing resource.
> > > >
> > > > On EC2 c5.24xlarge instance (196 GiB memory and 524288 (1Mi / 2) ehash
> > > > entries), after running iperf3 in different netns, creating 24Mi sockets
> > > > without data transfer in the root netns causes about 10% performance
> > > > regression for the iperf3's connection.
> > > >
> > > >  thash_entries          sockets         length          Gbps
> > > >         524288                1              1          50.7
> > > >                            24Mi             48          45.1
> > > >
> > > > It is basically related to the length of the list of each hash bucket.
> > > > For testing purposes to see how performance drops along the length,
> > > > I set 131072 (1Mi / 8) to thash_entries, and here's the result.
> > > >
> > > >  thash_entries          sockets         length          Gbps
> > > >         131072                1              1          50.7
> > > >                             1Mi              8          49.9
> > > >                             2Mi             16          48.9
> > > >                             4Mi             32          47.3
> > > >                             8Mi             64          44.6
> > > >                            16Mi            128          40.6
> > > >                            24Mi            192          36.3
> > > >                            32Mi            256          32.5
> > > >                            40Mi            320          27.0
> > > >                            48Mi            384          25.0
> > > >
> > > > To resolve the socket lookup degradation, we introduce an optional
> > > > per-netns hash table for TCP, but it's just ehash, and we still share
> > > > the global bhash, bhash2 and lhash2.
> > > >
> > > > With a smaller ehash, we can look up non-listener sockets faster and
> > > > isolate such noisy neighbours.  In addition, we can reduce lock contention.
> > > >
> > > > We can control the ehash size by a new sysctl knob.  However, depending
> > > > on workloads, it will require very sensitive tuning, so we disable the
> > > > feature by default (net.ipv4.tcp_child_ehash_entries == 0).  Moreover,
> > > > we can fall back to using the global ehash in case we fail to allocate
> > > > enough memory for a new ehash.  The maximum size is 16Mi, which is large
> > > > enough that even if we have 48Mi sockets, the average list length is 3,
> > > > and regression would be less than 1%.
> > > >
> > > > We can check the current ehash size by another read-only sysctl knob,
> > > > net.ipv4.tcp_ehash_entries.  A negative value means the netns shares
> > > > the global ehash (per-netns ehash is disabled or failed to allocate
> > > > memory).
> > > >
> > > >   # dmesg | cut -d ' ' -f 5- | grep "established hash"
> > > >   TCP established hash table entries: 524288 (order: 10, 4194304 bytes, vmalloc hugepage)
> > > >
> > > >   # sysctl net.ipv4.tcp_ehash_entries
> > > >   net.ipv4.tcp_ehash_entries = 524288  # can be changed by thash_entries
> > > >
> > > >   # sysctl net.ipv4.tcp_child_ehash_entries
> > > >   net.ipv4.tcp_child_ehash_entries = 0  # disabled by default
> > > >
> > > >   # ip netns add test1
> > > >   # ip netns exec test1 sysctl net.ipv4.tcp_ehash_entries
> > > >   net.ipv4.tcp_ehash_entries = -524288  # share the global ehash
> > > >
> > > >   # sysctl -w net.ipv4.tcp_child_ehash_entries=100
> > > >   net.ipv4.tcp_child_ehash_entries = 100
> > > >
> > > >   # ip netns add test2
> > > >   # ip netns exec test2 sysctl net.ipv4.tcp_ehash_entries
> > > >   net.ipv4.tcp_ehash_entries = 128  # own a per-netns ehash with 2^n buckets
> > > >
> > > > When more than two processes in the same netns create per-netns ehash
> > > > concurrently with different sizes, we need to guarantee the size in
> > > > one of the following ways:
> > > >
> > > >   1) Share the global ehash and create per-netns ehash
> > > >
> > > >   First, unshare() with tcp_child_ehash_entries==0.  It creates dedicated
> > > >   netns sysctl knobs where we can safely change tcp_child_ehash_entries
> > > >   and clone()/unshare() to create a per-netns ehash.
> > > >
> > > >   2) Control write on sysctl by BPF
> > > >
> > > >   We can use BPF_PROG_TYPE_CGROUP_SYSCTL to allow/deny read/write on
> > > >   sysctl knobs.
> > > >
> > > > Note the default values of two sysctl knobs depend on the ehash size and
> > > > should be tuned carefully:
> > > >
> > > >   tcp_max_tw_buckets  : tcp_child_ehash_entries / 2
> > > >   tcp_max_syn_backlog : max(128, tcp_child_ehash_entries / 128)
> > > >
> > > > As a bonus, we can dismantle netns faster.  Currently, while destroying
> > > > netns, we call inet_twsk_purge(), which walks through the global ehash.
> > > > It can be potentially big because it can have many sockets other than
> > > > TIME_WAIT in all netns.  Splitting ehash changes that situation, where
> > > > it's only necessary for inet_twsk_purge() to clean up TIME_WAIT sockets
> > > > in each netns.
> > > >
> > > > With regard to this, we do not free the per-netns ehash in inet_twsk_kill()
> > > > to avoid UAF while iterating the per-netns ehash in inet_twsk_purge().
> > > > Instead, we do it in tcp_sk_exit_batch() after calling tcp_twsk_purge() to
> > > > keep it protocol-family-independent.
> > > >
> > > > In the future, we could optimise ehash lookup/iteration further by removing
> > > > netns comparison for the per-netns ehash.
> > > >
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > >
> > > ...
> > >
> > > > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > > > index c440de998910..e94e1316fcc3 100644
> > > > --- a/net/ipv4/inet_hashtables.c
> > > > +++ b/net/ipv4/inet_hashtables.c
> > > > @@ -1145,3 +1145,60 @@ int inet_ehash_locks_alloc(struct inet_hashinfo *hashinfo)
> > > >         return 0;
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(inet_ehash_locks_alloc);
> > > > +
> > > > +struct inet_hashinfo *inet_pernet_hashinfo_alloc(struct inet_hashinfo *hashinfo,
> > > > +                                                unsigned int ehash_entries)
> > > > +{
> > > > +       struct inet_hashinfo *new_hashinfo;
> > > > +       int i;
> > > > +
> > > > +       new_hashinfo = kmalloc(sizeof(*new_hashinfo), GFP_KERNEL);
> > > > +       if (!new_hashinfo)
> > > > +               goto err;
> > > > +
> > > > +       new_hashinfo->ehash = kvmalloc_array(ehash_entries,
> > > > +                                            sizeof(struct inet_ehash_bucket),
> > > > +                                            GFP_KERNEL_ACCOUNT);
> > >
> > > Note that in current kernel,  init_net ehash table is using hugepages:
> > >
> > > # dmesg | grep "TCP established hash table"
> > > [   17.512756] TCP established hash table entries: 524288 (order: 10,
> > > 4194304 bytes, vmalloc hugepage)
> > >
> > > As this is very desirable, I would suggest using the following to
> > > avoid possible performance regression,
> > > especially for workload wanting a big ehash, as hinted by your changelog.
> > >
> > > new_hashinfo->ehash = vmalloc_huge(ehash_entries * sizeof(struct
> > > inet_ehash_bucket), GFP_KERNEL_ACCOUNT);
> > >
> > > (No overflow can happen in the multiply, as ehash_entries < 16M)
> >
> > Do we need 'get_order(size) >= MAX_ORDER' check or just use it?
> 
> No need, just use it.
> 
> If you happen to allocate 1MB, vmalloc_huge() will simply use 256 4k
> pages, not 2MB.
> 
> > Due to the test in alloc_large_system_hash(), on a machine where the
> > calculted bucket size is not large enough, we don't use hugepages for
> > init_net.
> 
> I can tell that even my laptop allocates hugepage...
> 
> And it will all depend on the user-configured ehash table size.

Ok, I'll use vmalloc_huge().


> > > Another point is that on NUMA, init_net ehash table is spread over
> > > available NUMA nodes.
> > >
> > > While net_pernet_hashinfo_alloc() will allocate pages depending on
> > > current process NUMA policy.
> > >
> > > Maybe worth noting this in the changelog, because it is very possible
> > > that new nets
> > > is created with default NUMA policy, and depending on which cpu
> > > current thread is
> > > running, hash table will fully reside on a 'random' node, with very
> > > different performance
> > > results for highly optimized networking applications.
> >
> > Sounds great!
> > But I'm not familiar with mm, so let me confirm a bit more.
> >
> > It seems vmalloc_huge() always pass NUMA_NO_NODE to __vmalloc_node_range(),
> > so if we use vmalloc_huge(), the per-net ehash will be spread on each NUMA
> > nodes unless vmap_allow_huge is disabled in the kernel parameters, right?
> 
> No, it depends on current NUMA policy
> 
> "man numa"
> 
> By default, at system init time, NUMA policy spreads allocations on
> all memory nodes.
> 
> After system has booted, default NUMA policy allocates memory on your
> local node only.
> 
> You can check on a NUMA host how vmalloc regions are spread
> 
> grep N0= /proc/vmallocinfo
> grep N1= /proc/vmallocinfo
> 
> 
> For instance, all large system hashes are evenly spread:
> 
> grep alloc_large_system_hash /proc/vmallocinfo
> ...
> 0x00000000c13cf72b-0x0000000068e51b86 4198400
> alloc_large_system_hash+0x160/0x3aa pages=1024 vmalloc vpages N0=512
> N1=512
> ...
> 
> while:
> # echo 200000 >/proc/sys/net/ipv4/tcp_child_ehash_entries
> # unshare -n
> # grep  inet_pernet_hashinfo_alloc /proc/vmallocinfo
> 0x00000000980d41fd-0x00000000ea510502 2101248
> inet_pernet_hashinfo_alloc+0x79/0x910 pages=512 vmalloc N1=512
> 
> (everything has been allocated into N1, because "unshare -n" probably
> was scheduled on a cpu in NUMA node1)

Thanks for explanation!
I'll note the difference with the global ehash and NUMA policy in the
changelog.


> > Or, even if we use vmalloc_huge(), the ehash could be controlled by the
> > current process's NUMA policy?  (Sorry I'm not sure where the policy is
> > applied..)
> >
> >
> > > > +       if (!new_hashinfo->ehash)
> > > > +               goto free_hashinfo;
> > > > +
> > > > +       new_hashinfo->ehash_mask = ehash_entries - 1;
> > > > +
> > > > +       if (inet_ehash_locks_alloc(new_hashinfo))
> > > > +               goto free_ehash;
> > > > +
> > > > +       for (i = 0; i < ehash_entries; i++)
> > > > +               INIT_HLIST_NULLS_HEAD(&new_hashinfo->ehash[i].chain, i);
> > > > +
> > > > +       new_hashinfo->bind_bucket_cachep = hashinfo->bind_bucket_cachep;
> > > > +       new_hashinfo->bhash = hashinfo->bhash;
> > > > +       new_hashinfo->bind2_bucket_cachep = hashinfo->bind2_bucket_cachep;
> > > > +       new_hashinfo->bhash2 = hashinfo->bhash2;
> > > > +       new_hashinfo->bhash_size = hashinfo->bhash_size;
> > > > +
> > > > +       new_hashinfo->lhash2_mask = hashinfo->lhash2_mask;
> > > > +       new_hashinfo->lhash2 = hashinfo->lhash2;
> > > > +
