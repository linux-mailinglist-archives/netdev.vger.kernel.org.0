Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3982E628B1A
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 22:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbiKNVJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 16:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237750AbiKNVJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 16:09:16 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFD3BE2E
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 13:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668460155; x=1699996155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mxLOp4/kA674X0L/i/vG62/W6BP4Esup5ivOgLTnc5k=;
  b=bCwtkDC9DmyVlY62M4EoGz6uACxgbgsN9GeA0eIdR8r67chQNlLgn7qQ
   OCcEX4jQdxm33O2Nj3CE3DfbDsL4hEaXETU2y1MVHh9NtnpCH5chB2hPn
   y50BABcpPLlrUu/o0+/wRPiEotnOFslE4ymGcNiKb5x1OKXYc7Cczw0vj
   I=;
X-IronPort-AV: E=Sophos;i="5.96,164,1665446400"; 
   d="scan'208";a="279862339"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 21:09:09 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com (Postfix) with ESMTPS id 5075E160F44;
        Mon, 14 Nov 2022 21:09:07 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 14 Nov 2022 21:09:06 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Mon, 14 Nov 2022 21:09:04 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 6/6] udp: Introduce optional per-netns hash table.
Date:   Mon, 14 Nov 2022 13:08:56 -0800
Message-ID: <20221114210856.34981-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <84f835ca7aacb831561cb9fb49ad4e014bf2b1fd.camel@redhat.com>
References: <84f835ca7aacb831561cb9fb49ad4e014bf2b1fd.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D36UWA002.ant.amazon.com (10.43.160.24) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Mon, 14 Nov 2022 21:55:11 +0100
> On Mon, 2022-11-14 at 12:21 -0800, Kuniyuki Iwashima wrote:
> > From:   Paolo Abeni <pabeni@redhat.com>
> > Date:   Fri, 11 Nov 2022 09:53:31 +0100
> > > On Thu, 2022-11-10 at 20:00 -0800, Kuniyuki Iwashima wrote:
> > > > @@ -408,6 +409,28 @@ static int proc_tcp_ehash_entries(struct ctl_table *table, int write,
> > > >  	return proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > > >  }
> > > >  
> > > > +static int proc_udp_hash_entries(struct ctl_table *table, int write,
> > > > +				 void *buffer, size_t *lenp, loff_t *ppos)
> > > > +{
> > > > +	struct net *net = container_of(table->data, struct net,
> > > > +				       ipv4.sysctl_udp_child_hash_entries);
> > > > +	int udp_hash_entries;
> > > > +	struct ctl_table tbl;
> > > > +
> > > > +	udp_hash_entries = net->ipv4.udp_table->mask + 1;
> > > > +
> > > > +	/* A negative number indicates that the child netns
> > > > +	 * shares the global udp_table.
> > > > +	 */
> > > > +	if (!net_eq(net, &init_net) && net->ipv4.udp_table == &udp_table)
> > > > +		udp_hash_entries *= -1;
> > > > +
> > > > +	tbl.data = &udp_hash_entries;
> > > > +	tbl.maxlen = sizeof(int);
> > > 
> > > I see the procfs code below will only use tbl.data and tbl.maxlen, but
> > > perhaps is cleaner intially explicitly memset tbl to 0 
> > 
> > Will add memset()
> > 
> > 
> > > 
> > > > 
> > > > +
> > > > +	return proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > > > +}
> > > > +
> > > >  #ifdef CONFIG_IP_ROUTE_MULTIPATH
> > > >  static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
> > > >  					  void *buffer, size_t *lenp,
> > > 
> > > [...]
> > > 
> > > > @@ -3308,22 +3308,112 @@ u32 udp_flow_hashrnd(void)
> > > >  }
> > > >  EXPORT_SYMBOL(udp_flow_hashrnd);
> > > >  
> > > > -static int __net_init udp_sysctl_init(struct net *net)
> > > > +static void __net_init udp_sysctl_init(struct net *net)
> > > >  {
> > > > -	net->ipv4.udp_table = &udp_table;
> > > > -
> > > >  	net->ipv4.sysctl_udp_rmem_min = PAGE_SIZE;
> > > >  	net->ipv4.sysctl_udp_wmem_min = PAGE_SIZE;
> > > >  
> > > >  #ifdef CONFIG_NET_L3_MASTER_DEV
> > > >  	net->ipv4.sysctl_udp_l3mdev_accept = 0;
> > > >  #endif
> > > > +}
> > > > +
> > > > +static struct udp_table __net_init *udp_pernet_table_alloc(unsigned int hash_entries)
> > > > +{
> > > > +	unsigned long hash_size, bitmap_size;
> > > > +	struct udp_table *udptable;
> > > > +	int i;
> > > > +
> > > > +	udptable = kmalloc(sizeof(*udptable), GFP_KERNEL);
> > > > +	if (!udptable)
> > > > +		goto out;
> > > > +
> > > > +	udptable->log = ilog2(hash_entries);
> > > > +	udptable->mask = hash_entries - 1;
> > > > +
> > > > +	hash_size = L1_CACHE_ALIGN(hash_entries * 2 * sizeof(struct udp_hslot));
> > > > +	bitmap_size = hash_entries *
> > > > +		BITS_TO_LONGS(udp_bitmap_size(udptable)) * sizeof(unsigned long);
> > > 
> > > Ouch, I'm very sorry. I did not realize we need a bitmap per hash
> > > bucket. This leads to a constant 8k additional memory overhead per
> > > netns, undependently from arch long bitsize.
> > 
> > Ugh, it will be 64K per netns ... ?
> > 
> > hash_entries              : 2 ^ n
> > BITS_TO_LONGS             : 2 ^ -m # arch specific
                                    -(m + 3)
> > udp_bitmap_size(udptable) : 2 ^ (16 - n)
> > sizeof(unsigned long)     : 2 ^ m  # arch specific
> > 
> > (2 ^ n) * (2 ^ -m) * (2 ^ (16 - n)) * (2 ^ m)
                  (-m - 3)
> > = 2 ^ (n - m + 16 - n + m)
                   13
> > = 2 ^ 16
          13
> > = 64 K
       8 K
> 
> For the records, I still think it's 8k ;)
> 
> BITS_TO_LONGS(n) * sizeof(unsigned long) is always equal to n/8
> regardless of the arch, while the above math gives BITS_TO_LONGS(n) *
> sizeof(unsigned long) == n.

Ah, right!
My math was bad :p

Thank you!
