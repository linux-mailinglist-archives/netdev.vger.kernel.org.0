Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E5E5ECBE9
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 20:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiI0SKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 14:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiI0SKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 14:10:31 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C3958DF5;
        Tue, 27 Sep 2022 11:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664302229; x=1695838229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4KMhpEi2qvbIzq1MJwu/qPP+wlFp9A/BnHYl7D0/8uM=;
  b=OP29F8oyUs4HcP0vofpF7hXURZS7zfhsQyrKaV7tWt9bxIiQUv8XY2xS
   uH5it1czFGx60Rp7/ZKtiIARSPvO0HxlER5KHplMIEY5UJmFIyE/m34pa
   2p/DNg7xxCoj7AzXIKKZ3lcmmZwX11w3iw3gjrT7ZVBbjVYySo/WfHHgs
   4=;
X-IronPort-AV: E=Sophos;i="5.93,350,1654560000"; 
   d="scan'208";a="1058572144"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 17:02:51 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com (Postfix) with ESMTPS id 788884591B;
        Tue, 27 Sep 2022 17:02:50 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 27 Sep 2022 17:02:49 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 27 Sep 2022 17:02:47 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>,
        <vyasevic@redhat.com>
Subject: Re: [PATCH v1 net 3/5] tcp/udp: Call inet6_destroy_sock() in IPv4 sk_prot->destroy().
Date:   Tue, 27 Sep 2022 10:02:39 -0700
Message-ID: <20220927170239.37041-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iKguA1pAc7wUuWVwuSLJ7+dDRLscY0CEJXNPpg8gphJbg@mail.gmail.com>
References: <CANn89iKguA1pAc7wUuWVwuSLJ7+dDRLscY0CEJXNPpg8gphJbg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D49UWB001.ant.amazon.com (10.43.163.72) To
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

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 09:50:04 -0700
> On Tue, Sep 27, 2022 at 9:13 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > Originally, inet6_sk(sk)->XXX were changed under lock_sock(), so we were
> > able to clean them up by calling inet6_destroy_sock() during the IPv6 ->
> > IPv4 conversion by IPV6_ADDRFORM.  However, commit 03485f2adcde ("udpv6:
> > Add lockless sendmsg() support") added a lockless memory allocation path,
> > which could cause a memory leak:
> >
> > setsockopt(IPV6_ADDRFORM)                 sendmsg()
> > +-----------------------+                 +-------+
> > - do_ipv6_setsockopt(sk, ...)             - udpv6_sendmsg(sk, ...)
> >   - lock_sock(sk)                           ^._ called via udpv6_prot
> >   - WRITE_ONCE(sk->sk_prot, &tcp_prot)          before WRITE_ONCE()
> >   - inet6_destroy_sock()
> >   - release_sock(sk)                        - ip6_make_skb(sk, ...)
> >                                               ^._ lockless fast path for
> >                                                   the non-corking case
> >
> >                                               - __ip6_append_data(sk, ...)
> >                                                 - ipv6_local_rxpmtu(sk, ...)
> >                                                   - xchg(&np->rxpmtu, skb)
> >                                                     ^._ rxpmtu is never freed.
> >
> >                                             - lock_sock(sk)
> >
> > For now, rxpmtu is only the case, but let's call inet6_destroy_sock()
> > in both TCP/UDP v4 destroy functions not to miss the future change.
> >
> > We can consolidate TCP/UDP v4/v6 destroy functions, but such changes
> > are too invasive to backport to stable.  So, they can be posted as a
> > follow-up later for net-next.
> >
> > Fixes: 03485f2adcde ("udpv6: Add lockless sendmsg() support")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> > Cc: Vladislav Yasevich <vyasevic@redhat.com>
> > ---
> >  net/ipv4/tcp_ipv4.c | 5 +++++
> >  net/ipv4/udp.c      | 6 ++++++
> >  net/ipv6/tcp_ipv6.c | 1 -
> >  3 files changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index 5b019ba2b9d2..035b6c52a243 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -2263,6 +2263,11 @@ void tcp_v4_destroy_sock(struct sock *sk)
> >         tcp_saved_syn_free(tp);
> >
> >         sk_sockets_allocated_dec(sk);
> > +
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +       if (sk->sk_prot_creator == &tcpv6_prot)
> > +               inet6_destroy_sock(sk);
> > +#endif
> >  }
> 
> This is ugly, and will not compile with CONFIG_IPV6=m, right ?

Ah, exactly...

ld: net/ipv4/tcp_ipv4.o: in function `tcp_v4_destroy_sock':
/mnt/ec2-user/kernel/214_tcp_ipv6_renew_options_memleak/net/ipv4/tcp_ipv4.c:2290: undefined reference to `tcpv6_prot'
ld: /mnt/ec2-user/kernel/214_tcp_ipv6_renew_options_memleak/net/ipv4/tcp_ipv4.c:2291: undefined reference to `inet6_destroy_sock'
ld: net/ipv4/udp.o: in function `udp_destroy_sock':
/mnt/ec2-user/kernel/214_tcp_ipv6_renew_options_memleak/net/ipv4/udp.c:2660: undefined reference to `udpv6_prot'
ld: /mnt/ec2-user/kernel/214_tcp_ipv6_renew_options_memleak/net/ipv4/udp.c:2661: undefined reference to `inet6_destroy_sock'

So, do we have to move these 4 under net/ipv4/ with #ifdef CONFIG_IPv6 ?


> >  EXPORT_SYMBOL(tcp_v4_destroy_sock);
> >
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 560d9eadeaa5..cdf131c0a819 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -115,6 +115,7 @@
> >  #include <net/udp_tunnel.h>
> >  #if IS_ENABLED(CONFIG_IPV6)
> >  #include <net/ipv6_stubs.h>
> > +#include <net/transp_v6.h>
> >  #endif
> >
> >  struct udp_table udp_table __read_mostly;
> > @@ -2666,6 +2667,11 @@ void udp_destroy_sock(struct sock *sk)
> >                 if (up->encap_enabled)
> >                         static_branch_dec(&udp_encap_needed_key);
> >         }
> > +
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +       if (sk->sk_prot_creator == &udpv6_prot)
> > +               inet6_destroy_sock(sk);
> > +#endif
> >  }
> >
> >  /*
> > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > index e54eee80ce5f..1ff6a92f7774 100644
> > --- a/net/ipv6/tcp_ipv6.c
> > +++ b/net/ipv6/tcp_ipv6.c
> > @@ -1945,7 +1945,6 @@ static int tcp_v6_init_sock(struct sock *sk)
> >  static void tcp_v6_destroy_sock(struct sock *sk)
> >  {
> >         tcp_v4_destroy_sock(sk);
> > -       inet6_destroy_sock(sk);
> >  }
> >
> >  #ifdef CONFIG_PROC_FS
> > --
> > 2.30.2
> >
