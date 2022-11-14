Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70076628A64
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 21:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbiKNUVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 15:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237480AbiKNUVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 15:21:36 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4532E24
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 12:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668457296; x=1699993296;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gjxpCf6MbUwpCEeeOznDHtA0BDwVN376SIhcYQ7fAoQ=;
  b=g3G4nmX8qmjvRTo78ROSlsu4uzbXTVb06JWOp/12fmTMDaogTmkZLF0n
   Rt/5zVhryTo/dRTKCdqRztyz2nq+LoIBRu3+Ytnn2hUy/wuHkX2Hgo7qA
   hGohpywbbl3b83KQEhCpzyREXRo1WE+ekvDI3D4+c8UVsrmrXs2ok4J18
   g=;
X-IronPort-AV: E=Sophos;i="5.96,164,1665446400"; 
   d="scan'208";a="266507673"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 20:21:32 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com (Postfix) with ESMTPS id E2151416DB;
        Mon, 14 Nov 2022 20:21:30 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 14 Nov 2022 20:21:29 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Mon, 14 Nov 2022 20:21:27 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 6/6] udp: Introduce optional per-netns hash table.
Date:   Mon, 14 Nov 2022 12:21:19 -0800
Message-ID: <20221114202119.32011-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <33ccbd2770b069da8144aa1b94134f7d6464f4eb.camel@redhat.com>
References: <33ccbd2770b069da8144aa1b94134f7d6464f4eb.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D49UWC003.ant.amazon.com (10.43.162.10) To
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
Date:   Fri, 11 Nov 2022 09:53:31 +0100
> On Thu, 2022-11-10 at 20:00 -0800, Kuniyuki Iwashima wrote:
> > @@ -408,6 +409,28 @@ static int proc_tcp_ehash_entries(struct ctl_table *table, int write,
> >  	return proc_dointvec(&tbl, write, buffer, lenp, ppos);
> >  }
> >  
> > +static int proc_udp_hash_entries(struct ctl_table *table, int write,
> > +				 void *buffer, size_t *lenp, loff_t *ppos)
> > +{
> > +	struct net *net = container_of(table->data, struct net,
> > +				       ipv4.sysctl_udp_child_hash_entries);
> > +	int udp_hash_entries;
> > +	struct ctl_table tbl;
> > +
> > +	udp_hash_entries = net->ipv4.udp_table->mask + 1;
> > +
> > +	/* A negative number indicates that the child netns
> > +	 * shares the global udp_table.
> > +	 */
> > +	if (!net_eq(net, &init_net) && net->ipv4.udp_table == &udp_table)
> > +		udp_hash_entries *= -1;
> > +
> > +	tbl.data = &udp_hash_entries;
> > +	tbl.maxlen = sizeof(int);
> 
> I see the procfs code below will only use tbl.data and tbl.maxlen, but
> perhaps is cleaner intially explicitly memset tbl to 0 

Will add memset()


> 
> > 
> > +
> > +	return proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > +}
> > +
> >  #ifdef CONFIG_IP_ROUTE_MULTIPATH
> >  static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
> >  					  void *buffer, size_t *lenp,
> 
> [...]
> 
> > @@ -3308,22 +3308,112 @@ u32 udp_flow_hashrnd(void)
> >  }
> >  EXPORT_SYMBOL(udp_flow_hashrnd);
> >  
> > -static int __net_init udp_sysctl_init(struct net *net)
> > +static void __net_init udp_sysctl_init(struct net *net)
> >  {
> > -	net->ipv4.udp_table = &udp_table;
> > -
> >  	net->ipv4.sysctl_udp_rmem_min = PAGE_SIZE;
> >  	net->ipv4.sysctl_udp_wmem_min = PAGE_SIZE;
> >  
> >  #ifdef CONFIG_NET_L3_MASTER_DEV
> >  	net->ipv4.sysctl_udp_l3mdev_accept = 0;
> >  #endif
> > +}
> > +
> > +static struct udp_table __net_init *udp_pernet_table_alloc(unsigned int hash_entries)
> > +{
> > +	unsigned long hash_size, bitmap_size;
> > +	struct udp_table *udptable;
> > +	int i;
> > +
> > +	udptable = kmalloc(sizeof(*udptable), GFP_KERNEL);
> > +	if (!udptable)
> > +		goto out;
> > +
> > +	udptable->log = ilog2(hash_entries);
> > +	udptable->mask = hash_entries - 1;
> > +
> > +	hash_size = L1_CACHE_ALIGN(hash_entries * 2 * sizeof(struct udp_hslot));
> > +	bitmap_size = hash_entries *
> > +		BITS_TO_LONGS(udp_bitmap_size(udptable)) * sizeof(unsigned long);
> 
> Ouch, I'm very sorry. I did not realize we need a bitmap per hash
> bucket. This leads to a constant 8k additional memory overhead per
> netns, undependently from arch long bitsize.

Ugh, it will be 64K per netns ... ?

hash_entries              : 2 ^ n
BITS_TO_LONGS             : 2 ^ -m # arch specific
udp_bitmap_size(udptable) : 2 ^ (16 - n)
sizeof(unsigned long)     : 2 ^ m  # arch specific

(2 ^ n) * (2 ^ -m) * (2 ^ (16 - n)) * (2 ^ m)
= 2 ^ (n - m + 16 - n + m)
= 2 ^ 16
= 64 K


> 
> I guess it's still acceptable, but perhaps worth mentioning in the
> commit message?
> 
> Again sorry for the back && forth, I'm reconsidering all the above
> given my dumb misunderstanding.
> 
> I see that a minumum size of 256 hash buckets does not match your use
> case, still... if lower values of the per netns hash size are inflated
> to e.g. 128 and we keep the bitmap on stack (should be 64 bytes wide, I
> guess still an acceptable value), the per netns memory overhead will be
> 128*2*<hash bucket size> = 8K, less that what we get the above schema
> and any smaller hash - a single hash bucket leads to a 32 + 8K memory
> overhead.
> 
> TL;DR: what about accepting any per netns hash table size, but always
> allocate at least 128 buckets and keep the bitmap on the stack?

Sure, I'll change the min to 128.

128 * 2 * 16 = 4096 = 4K

---
$ pahole -C udp_hslot vmlinux
struct udp_hslot {
	struct hlist_head          head;                 /*     0     8 */
	int                        count;                /*     8     4 */
	spinlock_t                 lock;                 /*    12     4 */

	/* size: 16, cachelines: 1, members: 3 */
	/* last cacheline: 16 bytes */
} __attribute__((__aligned__(16)));
---


Thank you!


> 
> Thanks,
> 
> Paolo
