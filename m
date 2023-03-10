Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7208C6B52EB
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjCJViZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjCJViY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:38:24 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E905ADCF
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678484302; x=1710020302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RDIn1zqM7OGJXXpldbTXQ8oJ5t1TY9Z6ypLagRiIU9U=;
  b=qF4BU0Soo4PvxWgMbaQE0dQFGbMETdRWrCk4VffokaeIXms1pvVmQnS8
   jmdEXyBC7UyYbW5TV4AdAHZuYFJiglD1AnhS0Ru5RFRejmrGU9OYyR5uz
   4xfSa+w7RNdsdSSWe9isNWCta9Z/8+SPANvwnTn+naPv/SNbWCaN7qAYQ
   o=;
X-IronPort-AV: E=Sophos;i="5.98,250,1673913600"; 
   d="scan'208";a="1111528550"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 21:38:16 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com (Postfix) with ESMTPS id A337C44352;
        Fri, 10 Mar 2023 21:38:15 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.22; Fri, 10 Mar 2023 21:38:15 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.20) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Fri, 10 Mar 2023 21:38:12 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <bianmingkun@gmail.com>
CC:     <kerneljasonxing@gmail.com>, <netdev@vger.kernel.org>,
        <kuniyu@amazon.com>
Subject: Re: [ISSUE]soft lockup in __inet_lookup_established() function which one sock exist in two hash buckets(tcp_hashinfo.ehash)
Date:   Fri, 10 Mar 2023 13:38:04 -0800
Message-ID: <20230310213804.26304-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAL87dS0sSsKQOcf22gcHuHu7PjG_j1uiOx-AfRKdT7rznVfJ6Q@mail.gmail.com>
References: <CAL87dS0sSsKQOcf22gcHuHu7PjG_j1uiOx-AfRKdT7rznVfJ6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.100.20]
X-ClientProxiedBy: EX19D040UWB002.ant.amazon.com (10.13.138.89) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   mingkun bian <bianmingkun@gmail.com>
Date:   Fri, 10 Mar 2023 22:51:31 +0800
> Hi,
> 
>     I am sorry to submit the same post, because the format of the
> previous post is wrong.
> 
>     I have encountered the same issue which causes loop in
> __inet_lookup_established for 22 seconds, then kernel crash,
> similarly, we have thousands of devices with heavy network traffic,
> but only a few of them crash every day due to this reason.
> 
>  https://lore.kernel.org/lkml/CAL+tcoDAY=Q5pohEPgkBTNghxTb0AhmbQD58dPDghyxmrcWMRQ@mail.gmail.com/T/#mb7b613de68d86c9a302ccf227292ac273cbe7f7c
> 
>     Kernel version is 4.18.0, I analyzed the vmcore and find the point

Thanks for the report, but you should not use 4.18.0 at least, which
is no longer supported.  Could you try reproducing it on the net-next
tree or another stable versions listed below ?

https://www.kernel.org/category/releases.html

Thanks,
Kuniyuki


> of infinite loop is that one sock1 pointers exist in two hash
> buckets(tcp_hashinfo.ehash),
> 
>     tcp_hashinfo.ehash is as following:
>     buckets0:
>     buckets1:->sock1*->0x31(sock1->sk_nulls_node.next = 0x31, which
> means that sock1* is the end of buckets1), sock1* should not be here
> at buckets1,the real vmcore also has only one sock* in buckets1.
>     buckets2:
>     buckets3:->sock1*->0x31, sock1* is in the correct position at buckets3
>     buckets4:->sock2*
>     ...
>     buckets:N->sockn*
> 
>     then a skb(inet_ehashfn=0x1) came, it matched to buckets1, and the
> condition validation(sk->sk_hash != hash) failed, then entered
> condition validation(get_nulls_value(node) != slot) ,
>     get_nulls_value(node) = 3
>     slot = 1
>     finally, go to begin, and infinite loop.
> 
>     begin:
>     sk_nulls_for_each_rcu(sk, node, &head->chain) {
>     if (sk->sk_hash != hash)
>         continue;
>     }
>     ...
>     if (get_nulls_value(node) != slot)
>         goto begin;
> 
>    why does sock1 can exist in two hash buckets, are there some
> scenarios where the sock is not deleted from the tcp_hashinfo.ehash
> before sk_free?
> 
> 
>   The detailed three vmcore information is as follow：
>   vmcore1' info:
>   1. print the skb, skb is 0xffff94824975e000 which stored in stack.
> 
>    crash> p *(struct tcphdr *)(((struct
> sk_buff*)0xffff94824975e000)->head + ((struct
> sk_buff*)0xffff94824975e000)->transport_header)
>   $4 = {
>   source = 24125,
>   dest = 47873,
>   seq = 4005063716,
>   ack_seq = 1814397867,
>   res1 = 0,
>   doff = 8,
>   fin = 0,
>   syn = 0,
>   rst = 0,
>   psh = 1,
>   ack = 1,
>   urg = 0,
>   ece = 0,
>   cwr = 0,
>   window = 33036,
>   check = 19975,
>   urg_ptr = 0
> }
> 
> 2. print the sock1, tcp is in TIME_WAIT,the detailed analysis process
> is as follows:
> a. R14 is 0xffffad2e0dc8a210, which is &hashinfo->ehash[slot].
> 
> crash> p *((struct inet_ehash_bucket*)0xffffad2e0dc8a210)
> $14 = {
>   chain = {
>     first = 0xffff9483ba400f48
>   }
> }
> 
> b. sock* = 0xffff9483ba400f48 - offset(sock, sk_nulls_node) = 0xffff9483ba400ee0
> 
> we can see sock->sk_nulls_node is:
>   skc_nulls_node = {
>         next = 0x4efbf,
>         pprev = 0xffffad2e0dd2cef8
>       }
> 
> c. skb inet_ehashfn is 0x13242 which is in R15.
> 
> sock->skc_node is 0x4efbf, then its real slot is 0x4efbf >> 1 = 0x277df
> then bukets[0x277df] is (0x277df - 0x13242) * 8 + 0xffffad2e0dc8a210 =
> 0xFFFFAD2E0DD2CEF8
> 
> d. print bukets[0x277df], find 0xffff9483ba400f48 is the same  as
> bukets[0x13242]
> 
> crash> p *((struct inet_ehash_bucket*)0xFFFFAD2E0DD2CEF8)
> $32 = {
>   chain = {
>     first = 0xffff9483ba400f48
>   }
> }
> 
> crash> p *((struct inet_timewait_sock*)0xffff9483ba400ee0)
> $5 = {
>   __tw_common = {
>     {
>       skc_addrpair = 1901830485687183552,
>       {
>         skc_daddr = 442804416,
>         skc_rcv_saddr = 442804416
>       }
>     },
>     {
>       skc_hash = 2667739103,
>       skc_u16hashes = {30687, 40706}
>     },
>     {
>       skc_portpair = 3817294857,
>       {
>         skc_dport = 19465,
>         skc_num = 58247
>       }
>     },
>     skc_family = 2,
>     skc_state = 6 '\006',
>     skc_reuse = 0 '\000',
>     skc_reuseport = 0 '\000',
>     skc_ipv6only = 0 '\000',
>     skc_net_refcnt = 0 '\000',
>     skc_bound_dev_if = 0,
>     {
>       skc_bind_node = {
>         next = 0x0,
>         pprev = 0xffff9492a8950538
>       },
>       skc_portaddr_node = {
>         next = 0x0,
>         pprev = 0xffff9492a8950538
>       }
>     },
>     skc_prot = 0xffffffff9b9a9840,
>     skc_net = {
>       net = 0xffffffff9b9951c0
>     },
>     skc_v6_daddr = {
>       in6_u = {
>         u6_addr8 =
> "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
>         u6_addr16 = {0, 0, 0, 0, 0, 0, 0, 0},
>         u6_addr32 = {0, 0, 0, 0}
>       }
>     },
>     skc_v6_rcv_saddr = {
>       in6_u = {
>         u6_addr8 =
> "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
>         u6_addr16 = {0, 0, 0, 0, 0, 0, 0, 0},
>         u6_addr32 = {0, 0, 0, 0}
>       }
>     },
>     skc_cookie = {
>       counter = 0
>     },
>     {
>       skc_flags = 18446744072025102208,
>       skc_listener = 0xffffffff9b995780,
>       skc_tw_dr = 0xffffffff9b995780
>     },
>     skc_dontcopy_begin = 0xffff9483ba400f48,
>     {
>       skc_node = {
>         next = 0x4efbf,
>         pprev = 0xffffad2e0dd2cef8
>       },
>       skc_nulls_node = {
>         next = 0x4efbf,
>         pprev = 0xffffad2e0dd2cef8
>       }
>     },
>     skc_tx_queue_mapping = 0,
>     skc_rx_queue_mapping = 0,
>     {
>       skc_incoming_cpu = -1680142171,
>       skc_rcv_wnd = 2614825125,
>       skc_tw_rcv_nxt = 2614825125
>     },
>     skc_refcnt = {
>       refs = {
>         counter = 3
>       }
>     },
>     skc_dontcopy_end = 0xffff9483ba400f64,
>     {
>       skc_rxhash = 320497927,
>       skc_window_clamp = 320497927,
>       skc_tw_snd_nxt = 320497927
>     }
>   },
>   tw_mark = 0,
>   tw_substate = 6 '\006',
>   tw_rcv_wscale = 10 '\n',
>   tw_sport = 34787,
>   tw_kill = 0,
>   tw_transparent = 0,
>   tw_flowlabel = 0,
>   tw_pad = 0,
>   tw_tos = 0,
>   tw_timer = {
>     entry = {
>       next = 0xffff9483ba401d48,
>       pprev = 0xffff9481680177f8
>     },
>     expires = 52552264960,
>     function = 0xffffffff9ad67ba0,
>     flags = 1339031587,
>     rh_reserved1 = 0,
>     rh_reserved2 = 0,
>     rh_reserved3 = 0,
>     rh_reserved4 = 0
>   },
>   tw_tb = 0xffff9492a8950500
> }
> 3.call stack
> [48256841.222682]  panic+0xe8/0x25c
> [48256841.222766]  ? secondary_startup_64+0xb6/0xc0
> [48256841.222853]  watchdog_timer_fn+0x209/0x210
> [48256841.222939]  ? watchdog+0x30/0x30
> [48256841.223027]  __hrtimer_run_queues+0xe5/0x260
> [48256841.223117]  hrtimer_interrupt+0x122/0x270
> [48256841.223209]  ? sched_clock+0x5/0x10
> [48256841.223296]  smp_apic_timer_interrupt+0x6a/0x140
> [48256841.223384]  apic_timer_interrupt+0xf/0x20
> [48256841.223471] RIP: 0010:__inet_lookup_established+0xe9/0x170
> [48256841.223562] Code: f6 74 33 44 3b 62 a4 75 3d 48 3b 6a 98 75 37
> 8b 42 ac 85 c0 75 24 4c 3b 6a c8 75 2a 5b 5d 41 5c 41 5d 41 5e 48 89
> f8 41 5f c3 <48> d1 ea 49 39 d7 0f 85 5a ff ff ff 31 ff eb e2 39 44 24
> 38 74 d6
> [48256841.224242] RSP: 0018:ffff9497e0e83bf8 EFLAGS: 00000202
> ORIG_RAX: ffffffffffffff13
> [48256841.224904] RAX: ffffad2e0dbf1000 RBX: 0000000088993242 RCX:
> 0000000034d20a82
> [48256841.225576] RDX: 000000000004efbf RSI: 00000000527c6da0 RDI:
> 0000000000000000
> [48256841.226268] RBP: 1e31b4763470e11b R08: 0000000001bb5e3d R09:
> 00000000000001bb
> [48256841.226969] R10: 0000000000005429 R11: 0000000000000000 R12:
> 0000000001bb5e3d
> [48256841.227646] R13: ffffffff9b9951c0 R14: ffffad2e0dc8a210 R15:
> 0000000000013242
> [48256841.228330]  ? apic_timer_interrupt+0xa/0x20
> [48256841.228714]  ? __inet_lookup_established+0x3f/0x170
> [48256841.229097]  tcp_v4_early_demux+0xb0/0x170
> [48256841.229487]  ip_rcv_finish+0x17c/0x430
> [48256841.229865]  ip_rcv+0x27c/0x380
> [48256841.230242]  __netif_receive_skb_core+0x9e9/0xac0
> [48256841.230623]  ? inet_gro_receive+0x21b/0x2d0
> [48256841.230999]  ? recalibrate_cpu_khz+0x10/0x10
> [48256841.231378]  netif_receive_skb_internal+0x42/0xf0
> [48256841.231777]  napi_gro_receive+0xbf/0xe0
> 
> 
> vmcore2' info:
>  1. print the skb
> crash> p *(struct tcphdr *)(((struct
> sk_buff*)0xffff9d60c008b500)->head + ((struct
> sk_buff*)0xffff9d60c008b500)->transport_header)
> $28 = {
>   source = 35911,
>   dest = 20480,
>   seq = 1534560442,
>   ack_seq = 0,
>   res1 = 0,
>   doff = 10,
>   fin = 0,
>   syn = 1,
>   rst = 0,
>   psh = 0,
>   ack = 0,
>   urg = 0,
>   ece = 0,
>   cwr = 0,
>   window = 65535,
>   check = 56947,
>   urg_ptr = 0
> }
> 2. print the sock1, tcp is in TIME_WAIT, but the sock is ipv4, I do
> not know why skc_v6_daddr and rh_reserved is not zero, maybe memory
> out of bounds?
> crash> p *((struct inet_timewait_sock*)0xFFFF9D6F1997D540)
> $29 = {
>   __tw_common = {
>     {
>       skc_addrpair = 388621010873919680,
>       {
>         skc_daddr = 426027200,
>         skc_rcv_saddr = 90482880
>       }
>     },
>     {
>       skc_hash = 884720419,
>       skc_u16hashes = {49955, 13499}
>     },
>     {
>       skc_portpair = 156018620,
>       {
>         skc_dport = 42940,
>         skc_num = 2380
>       }
>     },
>     skc_family = 2,
>     skc_state = 6 '\006',
>     skc_reuse = 1 '\001',
>     skc_reuseport = 0 '\000',
>     skc_ipv6only = 0 '\000',
>     skc_net_refcnt = 0 '\000',
>     skc_bound_dev_if = 0,
>     {
>       skc_bind_node = {
>         next = 0xffff9d8993851448,
>         pprev = 0xffff9d89c3510458
>       },
>       skc_portaddr_node = {
>         next = 0xffff9d8993851448,
>         pprev = 0xffff9d89c3510458
>       }
>     },
>     skc_prot = 0xffffffff9c7a9840,
>     skc_net = {
>       net = 0xffffffff9c7951c0
>     },
>     skc_v6_daddr = {
>       in6_u = {
>         u6_addr8 = "$P\325\001\354M\213D\021p\323\337\n",
>         u6_addr16 = {20516, 42222, 54662, 60417, 35661, 4420, 54128, 2783},
>         u6_addr32 = {2767081508, 3959543174, 289704781, 182440816}
>       }
>     },
>     skc_v6_rcv_saddr = {
>       in6_u = {
>         u6_addr8 = "˲\231ª\212*pzf\212\277\325\065؄",
>         u6_addr16 = {45771, 49817, 35498, 28714, 26234, 49034, 13781, 34008},
>         u6_addr32 = {3264852683, 1881836202, 3213518458, 2228762069}
>       }
>     },
>     skc_cookie = {
>       counter = 0
>     },
>     {
>       skc_flags = 18446744072039782272,
>       skc_listener = 0xffffffff9c795780,
>       skc_tw_dr = 0xffffffff9c795780
>     },
>     skc_dontcopy_begin = 0xffff9d6f1997d5a8,
>     {
>       skc_node = {
>         next = 0x78647,
>         pprev = 0xffffb341cddea918
>       },
>       skc_nulls_node = {
>         next = 0x78647,
>         pprev = 0xffffb341cddea918
>       }
>     },
>     skc_tx_queue_mapping = 51317,
>     skc_rx_queue_mapping = 9071,
>     {
>       skc_incoming_cpu = -720721118,
>       skc_rcv_wnd = 3574246178,
>       skc_tw_rcv_nxt = 3574246178
>     },
>     skc_refcnt = {
>       refs = {
>         counter = 3
>       }
>     },
>     skc_dontcopy_end = 0xffff9d6f1997d5c4,
>     {
>       skc_rxhash = 2663156681,
>       skc_window_clamp = 2663156681,
>       skc_tw_snd_nxt = 2663156681
>     }
>   },
>   tw_mark = 0,
>   tw_substate = 6 '\006',
>   tw_rcv_wscale = 10 '\n',
>   tw_sport = 19465,
>   tw_kill = 0,
>   tw_transparent = 0,
>   tw_flowlabel = 201048,
>   tw_pad = 1,
>   tw_tos = 0,
>   tw_timer = {
>     entry = {
>       next = 0xffff9d6f1997d4c8,
>       pprev = 0xffff9d6f1997c6f8
>     },
>     expires = 52813074277,
>     function = 0xffffffff9bb67ba0,
>     flags = 1313865770,
>     rh_reserved1 = 14775289730400096190,
>     rh_reserved2 = 10703603942626563734,
>     rh_reserved3 = 17306812468345150807,
>     rh_reserved4 = 9531906593543422642
>   },
>   tw_tb = 0xffff9d897232a500
> }
> 
> vmcore3' info:
> 1. print the skbcrash> p *(struct tcphdr *)(((struct
> sk_buff*)0xffffa039e93aaf00)->head + ((struct
> sk_buff*)0xffffa039e93aaf00)->transport_header)
> $6 = {
>   source = 9269,
>   dest = 47873,
>   seq = 147768854,
>   ack_seq = 1282978926,
>   res1 = 0,
>   doff = 5,
>   fin = 0,
>   syn = 0,
>   rst = 0,
>   psh = 0,
>   ack = 1,
>   urg = 0,
>   ece = 0,
>   cwr = 0,
>   window = 47146,
>   check = 55446,
>   urg_ptr = 0
> }
> 2. print the sock1, tcp is in TIME_WAIT
> crash> p *((struct inet_timewait_sock*)0xFFFFA0444BAADBA0)
> $7 = {
>   __tw_common = {
>     {
>       skc_addrpair = 2262118455826491584,
>       {
>         skc_daddr = 392472768,
>         skc_rcv_saddr = 526690496
>       }
>     },
>     {
>       skc_hash = 382525308,
>       skc_u16hashes = {57212, 5836}
>     },
>     {
>       skc_portpair = 1169509385,
>       {
>         skc_dport = 19465,
>         skc_num = 17845
>       }
>     },
>     skc_family = 2,
>     skc_state = 6 '\006',
>     skc_reuse = 0 '\000',
>     skc_reuseport = 0 '\000',
>     skc_ipv6only = 0 '\000',
>     skc_net_refcnt = 0 '\000',
>     skc_bound_dev_if = 0,
>     {
>       skc_bind_node = {
>         next = 0x0,
>         pprev = 0xffffa0528fefba98
>       },
>       skc_portaddr_node = {
>         next = 0x0,
>         pprev = 0xffffa0528fefba98
>       }
>     },
>     skc_prot = 0xffffffffa33a9840,
>     skc_net = {
>       net = 0xffffffffa33951c0
>     },
>     skc_v6_daddr = {
>       in6_u = {
>         u6_addr8 =
> "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
>         u6_addr16 = {0, 0, 0, 0, 0, 0, 0, 0},
>         u6_addr32 = {0, 0, 0, 0}
>       }
>     },
>     skc_v6_rcv_saddr = {
>       in6_u = {
>         u6_addr8 =
> "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
>         u6_addr16 = {0, 0, 0, 0, 0, 0, 0, 0},
>         u6_addr32 = {0, 0, 0, 0}
>       }
>     },
>     skc_cookie = {
>       counter = 20818915981
>     },
>     {
>       skc_flags = 18446744072153028480,
>       skc_listener = 0xffffffffa3395780,
>       skc_tw_dr = 0xffffffffa3395780
>     },
>     skc_dontcopy_begin = 0xffffa0444baadc08,
>     {
>       skc_node = {
>         next = 0x9bef9,
>         pprev = 0xffffb36fcde60be0
>       },
>       skc_nulls_node = {
>         next = 0x9bef9,
>         pprev = 0xffffb36fcde60be0
>       }
>     },
>     skc_tx_queue_mapping = 0,
>     skc_rx_queue_mapping = 0,
>     {
>       skc_incoming_cpu = -2041214926,
>       skc_rcv_wnd = 2253752370,
>       skc_tw_rcv_nxt = 2253752370
>     },
>     skc_refcnt = {
>       refs = {
>         counter = 3
>       }
>     },
>     skc_dontcopy_end = 0xffffa0444baadc24,
>     {
>       skc_rxhash = 653578381,
>       skc_window_clamp = 653578381,
>       skc_tw_snd_nxt = 653578381
>     }
>   },
>   tw_mark = 0,
>   tw_substate = 6 '\006',
>   tw_rcv_wscale = 10 '\n',
>   tw_sport = 46405,
>   tw_kill = 0,
>   tw_transparent = 0,
>   tw_flowlabel = 0,
>   tw_pad = 0,
>   tw_tos = 0,
>   tw_timer = {
>     entry = {
>       next = 0xffffa0444baac808,
>       pprev = 0xffffa0388b5477f8
>     },
>     expires = 33384532933,
>     function = 0xffffffffa2767ba0,
>     flags = 1313865761,
>     rh_reserved1 = 0,
>     rh_reserved2 = 0,
>     rh_reserved3 = 0,
>     rh_reserved4 = 0
>   },
>   tw_tb = 0xffffa05cc8322d40
> }
