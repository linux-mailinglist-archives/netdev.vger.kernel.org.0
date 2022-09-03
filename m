Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D365ABC77
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 04:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbiICCvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 22:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiICCu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 22:50:59 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660A186B70
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 19:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662173458; x=1693709458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1g/u9waKSVdoO36VYD44WjzMVe/7kx9X1xMQva7xIWc=;
  b=XN6asUAbtyZiqg2bQ3k3eTEVxKFv56uz4j/KwYiI5GRZCY8YAKU1oWQw
   ejguh/kn1YKqSSTt0cZuTAFmpbPdqhq6GN1FW28VgwfhujJTBLIqvL5KG
   1bNfQcyGxyxdZGaMvQ1sSoU5uS1Kw0gYACHNbjlVYCxAG/O/k3LqFyZWM
   M=;
X-IronPort-AV: E=Sophos;i="5.93,286,1654560000"; 
   d="scan'208";a="237205129"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-f20e0c8b.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 02:50:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-f20e0c8b.us-east-1.amazon.com (Postfix) with ESMTPS id 36F378B756;
        Sat,  3 Sep 2022 02:50:44 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Sat, 3 Sep 2022 02:50:44 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.230) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Sat, 3 Sep 2022 02:50:42 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v3 net-next 3/5] tcp: Access &tcp_hashinfo via net.
Date:   Fri, 2 Sep 2022 19:50:34 -0700
Message-ID: <20220903025034.98192-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iLHKRZU_+vdQAf-RYn5gDxRN4-9_k4wn5N7xAzadGH=EA@mail.gmail.com>
References: <CANn89iLHKRZU_+vdQAf-RYn5gDxRN4-9_k4wn5N7xAzadGH=EA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.230]
X-ClientProxiedBy: EX13d09UWA003.ant.amazon.com (10.43.160.227) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Sep 2022 19:30:31 -0700
> On Fri, Sep 2, 2022 at 6:44 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Kuniyuki Iwashima <kuniyu@amazon.com>
> > Date:   Fri, 2 Sep 2022 18:12:43 -0700
> > > From:   Eric Dumazet <edumazet@google.com>
> > > Date:   Fri, 2 Sep 2022 17:53:18 -0700
> > > > On Fri, Sep 2, 2022 at 5:44 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > >
> > > > > From:   Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > Date:   Thu, 1 Sep 2022 15:12:16 -0700
> > > > > > From:   Eric Dumazet <edumazet@google.com>
> > > > > > Date:   Thu, 1 Sep 2022 14:30:43 -0700
> > > > > > > On Thu, Sep 1, 2022 at 2:25 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > > > >
> > > > > > > > From:   Paolo Abeni <pabeni@redhat.com>
> > > > > > >
> > > > > > > > > /Me is thinking aloud...
> > > > > > > > >
> > > > > > > > > I'm wondering if the above has some measurable negative effect for
> > > > > > > > > large deployments using only the main netns?
> > > > > > > > >
> > > > > > > > > Specifically, are net->ipv4.tcp_death_row and net->ipv4.tcp_death_row-
> > > > > > > > > >hashinfo already into the working set data for established socket?
> > > > > > > > > Would the above increase the WSS by 2 cache-lines?
> > > > > > > >
> > > > > > > > Currently, the death_row and hashinfo are touched around tw sockets or
> > > > > > > > connect().  If connections on the deployment are short-lived or frequently
> > > > > > > > initiated by itself, that would be host and included in WSS.
> > > > > > > >
> > > > > > > > If the workload is server and there's no active-close() socket or
> > > > > > > > connections are long-lived, then it might not be included in WSS.
> > > > > > > > But I think it's not likely than the former if the deployment is
> > > > > > > > large enough.
> > > > > > > >
> > > > > > > > If this change had large impact, then we could revert fbb8295248e1
> > > > > > > > which converted net->ipv4.tcp_death_row into pointer for 0dad4087a86a
> > > > > > > > that tried to fire a TW timer after netns is freed, but 0dad4087a86a
> > > > > > > > has already reverted.
> > > > > > >
> > > > > > >
> > > > > > > Concern was fast path.
> > > > > > >
> > > > > > > Each incoming packet does a socket lookup.
> > > > > > >
> > > > > > > Fetching hashinfo (instead of &tcp_hashinfo) with a dereference of a
> > > > > > > field in 'struct net' might inccurr a new cache line miss.
> > > > > > >
> > > > > > > Previously, first cache line of tcp_info was enough to bring a lot of
> > > > > > > fields in cpu cache.
> > > > > >
> > > > > > Ok, let me test on that if there could be regressions.
> > > > >
> > > > > I tested tcp_hashinfo vs tcp_death_row->hashinfo with super_netperf
> > > > > and collected HW cache-related metrics with perf.
> > > > >
> > > > > After the patch the number of L1 miss seems to increase, but the
> > > > > instructions per cycle also increases, and cache miss rate did not
> > > > > change.  Also, there was not performance regression for netperf.
> > > > >
> > > > >
> > > > > Tested:
> > > > >
> > > > > # cat perf_super_netperf
> > > > > echo 0 > /proc/sys/kernel/nmi_watchdog
> > > > > echo 3 > /proc/sys/vm/drop_caches
> > > > >
> > > > > perf stat -a \
> > > > >      -e cycles,instructions,cache-references,cache-misses,bus-cycles \
> > > > >      -e L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores \
> > > > >      -e dTLB-loads,dTLB-load-misses \
> > > > >      -e LLC-loads,LLC-load-misses,LLC-stores \
> > > > >      ./super_netperf $(($(nproc) * 2)) -H 10.0.0.142 -l 60 -fM
> > > > >
> > > > > echo 1 > /proc/sys/kernel/nmi_watchdog
> > > > >
> > > > >
> > > > > Before:
> > > > >
> > > > > # ./perf_super_netperf
> > > > > 2929.81
> > > > >
> > > > >  Performance counter stats for 'system wide':
> > > > >
> > > > >    494,002,600,338      cycles                                                        (23.07%)
> > > > >    241,230,662,890      instructions              #    0.49  insn per cycle           (30.76%)
> > > > >      6,303,603,008      cache-references                                              (38.45%)
> > > > >      1,421,440,332      cache-misses              #   22.550 % of all cache refs      (46.15%)
> > > > >      4,861,179,308      bus-cycles                                                    (46.15%)
> > > > >     65,410,735,599      L1-dcache-loads                                               (46.15%)
> > > > >     12,647,247,339      L1-dcache-load-misses     #   19.34% of all L1-dcache accesses  (30.77%)
> > > > >     32,912,656,369      L1-dcache-stores                                              (30.77%)
> > > > >     66,015,779,361      dTLB-loads                                                    (30.77%)
> > > > >         81,293,994      dTLB-load-misses          #    0.12% of all dTLB cache accesses  (30.77%)
> > > > >      2,946,386,949      LLC-loads                                                     (30.77%)
> > > > >        257,223,942      LLC-load-misses           #    8.73% of all LL-cache accesses  (30.77%)
> > > > >      1,183,820,461      LLC-stores                                                    (15.38%)
> > > > >
> > > > >       62.132250590 seconds time elapsed
> > > > >
> > > >
> > > > This test will not be able to see a difference really...
> > > >
> > > > What is needed is to measure the latency when nothing at all is in the caches.
> > > >
> > > > Vast majority of real world TCP traffic is light or moderate.
> > > > Packets are received and cpu has to bring X cache lines into L1 in
> > > > order to process one packet.
> > > >
> > > > We slowly are increasing X over time :/
> > > >
> > > > pahole is your friend, more than a stress-test.
> > >
> > > Here's pahole result on my local build.  As Paolo said, we
> > > need 2 cachelines for tcp_death_row and the hashinfo?
> > >
> > > How about moving hashinfo as the first member of struct
> > > inet_timewait_death_row and convert it to just struct
> > > instead of pointer so that we need 1 cache line to read
> > > hashinfo?
> >
> > Like this.
> >
> > $ pahole -EC netns_ipv4 vmlinux
> > struct netns_ipv4 {
> >         struct inet_timewait_death_row {
> >                 struct inet_hashinfo * hashinfo __attribute__((__aligned__(64)));        /*     0     8 */
> >                 /* typedef refcount_t */ struct refcount_struct {
> >                         /* typedef atomic_t */ struct {
> >                                 int counter;                                             /*     8     4 */
> >                         } refs; /*     8     4 */
> >                 } tw_refcount; /*     8     4 */
> >                 int                sysctl_max_tw_buckets;                                /*    12     4 */
> >         } tcp_death_row __attribute__((__aligned__(64))) __attribute__((__aligned__(64))); /*     0    64 */
> >
> >         /* XXX last struct has 48 bytes of padding */
> >
> >         /* --- cacheline 1 boundary (64 bytes) --- */
> > ...
> > } __attribute__((__aligned__(64)));
> >
> >
> > ---8<---
> > diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> > index 6320a76cefdc..dee53193d258 100644
> > --- a/include/net/netns/ipv4.h
> > +++ b/include/net/netns/ipv4.h
> > @@ -32,16 +32,15 @@ struct ping_group_range {
> >  struct inet_hashinfo;
> >
> >  struct inet_timewait_death_row {
> > -       refcount_t              tw_refcount;
> > -
> >         struct inet_hashinfo    *hashinfo ____cacheline_aligned_in_smp;
> > +       refcount_t              tw_refcount;
> 
> This would be very bad. tw_refcount would share a cache line with hashinfo.
> 
> false sharing is more problematic than a cache line miss in read mode.

Ah, exactly.
Then I will add ____cacheline_aligned_in_smp to tw_refcount, instead of
keeping the original order, to avoid invalidation by sysctl_max_tw_buckets
change, which wouldn't be so frequently done though.

 struct inet_timewait_death_row {
-       refcount_t              tw_refcount;
-
-       struct inet_hashinfo    *hashinfo ____cacheline_aligned_in_smp;
+       struct inet_hashinfo    *hashinfo;
+       refcount_t              tw_refcount ____cacheline_aligned_in_smp;
        int                     sysctl_max_tw_buckets;
 };


> 
> >         int                     sysctl_max_tw_buckets;
> >  };
> >
> >  struct tcp_fastopen_context;
> >
> >  struct netns_ipv4 {
> > -       struct inet_timewait_death_row *tcp_death_row;
> > +       struct inet_timewait_death_row tcp_death_row;
> >
> >  #ifdef CONFIG_SYSCTL
> >         struct ctl_table_header *forw_hdr;
> > ---8<---
> >
