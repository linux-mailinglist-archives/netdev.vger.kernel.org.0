Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF8462332E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 20:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiKITJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 14:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKITJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 14:09:23 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D89D272C
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 11:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668020962; x=1699556962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xFyXlOoh1DLRRBhQRFuYi8vQOChRI4Jv1Ctl2HhKcGU=;
  b=jNZIyoe/aqgJ68zfU+96AlIZ94w1QRDXQ97Fr1Vs9jT6bR5z/v6Jsj3h
   KxbYzAOT7KKS54u7ciKRI6Dv6eR850u/S/5FX46oSyYSf7MAqfTENMoWT
   /jcX5wlKY0WMm9v7Q230Xz+Elh/lE/+E9/B8LoOfRQ1MMp0X/L/CIMb2Z
   w=;
X-IronPort-AV: E=Sophos;i="5.96,151,1665446400"; 
   d="scan'208";a="149322759"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 19:09:20 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id BB2A4824F3;
        Wed,  9 Nov 2022 19:09:17 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 9 Nov 2022 19:09:16 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Wed, 9 Nov 2022 19:09:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 net-next 6/6] udp: Introduce optional per-netns hash table.
Date:   Wed, 9 Nov 2022 11:09:06 -0800
Message-ID: <20221109190906.25023-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <824f56a316b96aaa0cc52c301429a3438486b691.camel@redhat.com>
References: <824f56a316b96aaa0cc52c301429a3438486b691.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D28UWB003.ant.amazon.com (10.43.161.60) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Wed, 09 Nov 2022 10:02:49 +0100
> Hello,
> 
> On Mon, 2022-11-07 at 10:41 -0800, Kuniyuki Iwashima wrote:
> > From:   Paolo Abeni <pabeni@redhat.com>
> > Date:   Mon, 07 Nov 2022 11:03:38 +0100
> > > On Fri, 2022-11-04 at 12:06 -0700, Kuniyuki Iwashima wrote:
> > > > The maximum hash table size is 64K due to the nature of the protocol. [0]
> > > > It's smaller than TCP, and fewer sockets can cause a performance drop.
> > > > 
> > > > On an EC2 c5.24xlarge instance (192 GiB memory), after running iperf3 in
> > > > different netns, creating 32Mi sockets without data transfer in the root
> > > > netns causes regression for the iperf3's connection.
> > > > 
> > > >   uhash_entries		sockets		length		Gbps
> > > > 	    64K		      1		     1		5.69
> > > > 			    1Mi		    16		5.27
> > > > 			    2Mi		    32		4.90
> > > > 			    4Mi		    64		4.09
> > > > 			    8Mi		   128		2.96
> > > > 			   16Mi		   256		2.06
> > > > 			   32Mi		   512		1.12
> > > > 
> > > > The per-netns hash table breaks the lengthy lists into shorter ones.  It is
> > > > useful on a multi-tenant system with thousands of netns.  With smaller hash
> > > > tables, we can look up sockets faster, isolate noisy neighbours, and reduce
> > > > lock contention.
> > > > 
> > > > The max size of the per-netns table is 64K as well.  This is because the
> > > > possible hash range by udp_hashfn() always fits in 64K within the same
> > > > netns and we cannot make full use of the whole buckets larger than 64K.
> > > > 
> > > >   /* 0 < num < 64K  ->  X < hash < X + 64K */
> > > >   (num + net_hash_mix(net)) & mask;
> > > > 
> > > > The sysctl usage is the same with TCP:
> > > > 
> > > >   $ dmesg | cut -d ' ' -f 6- | grep "UDP hash"
> > > >   UDP hash table entries: 65536 (order: 9, 2097152 bytes, vmalloc)
> > > > 
> > > >   # sysctl net.ipv4.udp_hash_entries
> > > >   net.ipv4.udp_hash_entries = 65536  # can be changed by uhash_entries
> > > > 
> > > >   # sysctl net.ipv4.udp_child_hash_entries
> > > >   net.ipv4.udp_child_hash_entries = 0  # disabled by default
> > > > 
> > > >   # ip netns add test1
> > > >   # ip netns exec test1 sysctl net.ipv4.udp_hash_entries
> > > >   net.ipv4.udp_hash_entries = -65536  # share the global table
> > > > 
> > > >   # sysctl -w net.ipv4.udp_child_hash_entries=100
> > > >   net.ipv4.udp_child_hash_entries = 100
> > > > 
> > > >   # ip netns add test2
> > > >   # ip netns exec test2 sysctl net.ipv4.udp_hash_entries
> > > >   net.ipv4.udp_hash_entries = 128  # own a per-netns table with 2^n buckets
> > > > 
> > > > We could optimise the hash table lookup/iteration further by removing
> > > > the netns comparison for the per-netns one in the future.  Also, we
> > > > could optimise the sparse udp_hslot layout by putting it in udp_table.
> > > > 
> > > > [0]: https://lore.kernel.org/netdev/4ACC2815.7010101@gmail.com/
> > > > 
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > ---
> > > >  Documentation/networking/ip-sysctl.rst |  27 ++++++
> > > >  include/linux/udp.h                    |   2 +
> > > >  include/net/netns/ipv4.h               |   2 +
> > > >  net/ipv4/sysctl_net_ipv4.c             |  38 ++++++++
> > > >  net/ipv4/udp.c                         | 119 ++++++++++++++++++++++---
> > > >  5 files changed, 178 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> > > > index 815efc89ad73..ea788ef4def0 100644
> > > > --- a/Documentation/networking/ip-sysctl.rst
> > > > +++ b/Documentation/networking/ip-sysctl.rst
> > > > @@ -1177,6 +1177,33 @@ udp_rmem_min - INTEGER
> > > >  udp_wmem_min - INTEGER
> > > >  	UDP does not have tx memory accounting and this tunable has no effect.
> > > >  
> > > > +udp_hash_entries - INTEGER
> > > > +	Show the number of hash buckets for UDP sockets in the current
> > > > +	networking namespace.
> > > > +
> > > > +	A negative value means the networking namespace does not own its
> > > > +	hash buckets and shares the initial networking namespace's one.
> > > > +
> > > > +udp_child_ehash_entries - INTEGER
> > > > +	Control the number of hash buckets for UDP sockets in the child
> > > > +	networking namespace, which must be set before clone() or unshare().
> > > > +
> > > > +	If the value is not 0, the kernel uses a value rounded up to 2^n
> > > > +	as the actual hash bucket size.  0 is a special value, meaning
> > > > +	the child networking namespace will share the initial networking
> > > > +	namespace's hash buckets.
> > > > +
> > > > +	Note that the child will use the global one in case the kernel
> > > > +	fails to allocate enough memory.  In addition, the global hash
> > > > +	buckets are spread over available NUMA nodes, but the allocation
> > > > +	of the child hash table depends on the current process's NUMA
> > > > +	policy, which could result in performance differences.
> > > > +
> > > > +	Possible values: 0, 2^n (n: 0 - 16 (64K))
> > > 
> > > If you constraint the non-zero minum size to UDP_HTABLE_SIZE_MIN - not
> > > sure if that makes sense - than you could avoid dynamically allocating
> > > the bitmap in udp_lib_get_port(). 
> > 
> > Yes, but 256 didn't match for our case.  Also, I was thinking like
> > this not to affect the global table case.  Which do you prefer ?
> > 
> > uncompiled code:
> > 
> > unsigned long *udp_get_bitmap(struct udp_table *udptable,
> > 			      unsigned long *bitmap_stack)
> > {
> > 	unsigned long *bitmap;
> > 
> > 	if (udptable == &udp_table)
> > 		return bitmap_stack;
> > 
> > 	/* UDP_HTABLE_SIZE_MIN */
> > 	if (udptable->log >= 8)
> > 		return bitmap_stack;
> > 
> > 	bitmap = bitmap_alloc(udp_bitmap_size(udptable));
> > 	if (!bitmap)
> > 		return bitmap_stack;
> > 
> > 	return bitmap;
> > }
> > 
> > void udp_free_bitmap(unsigned long *bitmap,
> > 		     unsigned long *bitmap_stack)
> > {
> > 	if (bitmap != bitmap_stack)
> > 		bitmap_free(bitmap);
> > }
> 
> I'm sorry for the latency. The thing that makes me feel not so
> comfortable is the new allocation required in udp_lib_get_port().
> 
> The above will avoid such allocation for the common case, but not for
> every caller.
> 
> What about adding a 'unsigned long *bitmap' field to udp_table, setting
> it to the global bitmap for the main table, and allocating enough
> storage to include even the bitmap when allocating the per netns
> udp_table? e.g.

I like the idea, much cleaner!

> 
> L1_CACHE_ALIGN(hash_entries * 2 * sizeof(struct udp_hslot)) *
> BITS_TO_LONGS(udp_bitmap_size(udptable))

Maybe this ? as we don't use bitmap for hslot2.

L1_CACHE_ALIGN(hash_entries * 2 * sizeof(struct udp_hslot) +
               hash_entries * BITS_TO_LONGS(udp_bitmap_size(udptable)))

Thank you!

> 
> WDYT?
> 
> thanks!
> 
> Paolo
