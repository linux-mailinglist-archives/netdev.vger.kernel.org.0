Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963995F6C83
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 19:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiJFRLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 13:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiJFRLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 13:11:16 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02796A2840;
        Thu,  6 Oct 2022 10:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665076273; x=1696612273;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YCMZD2AP3iQVb0aK1bLG/pOxiCyTeDnTpOa5PHM4oFE=;
  b=A4t1gPIZd8TNrIu084PVccJfOaCPQVPnMXArRm7E16n93QnGdlzQHvJ3
   ccYQEdsPR6qGdtBjszboY1BPug/WrzCiLCxNbeOYd3XyhjXeY1dL5e0q2
   O20Zoue48CD30fT5+bLDTapHkEktRBmWnZYsAHEp2xHYJ+yCkVeT3m6OE
   w=;
X-IronPort-AV: E=Sophos;i="5.95,164,1661817600"; 
   d="scan'208";a="252606526"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 17:10:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com (Postfix) with ESMTPS id 8D31FA2533;
        Thu,  6 Oct 2022 17:10:55 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 6 Oct 2022 17:10:54 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.176) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 6 Oct 2022 17:10:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>, <vyasevic@redhat.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v4 net 3/5] tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().
Date:   Thu, 6 Oct 2022 10:10:38 -0700
Message-ID: <20221006171038.68453-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <d669f9a18ae0b18fbecad7efbd2bc2d789f280f3.camel@redhat.com>
References: <d669f9a18ae0b18fbecad7efbd2bc2d789f280f3.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.176]
X-ClientProxiedBy: EX13D40UWA002.ant.amazon.com (10.43.160.149) To
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
Date:   Thu, 06 Oct 2022 11:19:53 +0200
> On Tue, 2022-10-04 at 10:18 -0700, Kuniyuki Iwashima wrote:
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
> > For now, rxpmtu is only the case, but not to miss the future change
> > and a similar bug fixed in commit e27326009a3d ("net: ping6: Fix
> > memleak in ipv6_renew_options()."), let's set a new function to IPv6
> > sk->sk_destruct() and call inet6_cleanup_sock() there.  Since the
> > conversion does not change sk->sk_destruct(), we can guarantee that
> > we can clean up IPv6 resources finally.
> > 
> > We can now remove all inet6_destroy_sock() calls from IPv6 protocol
> > specific ->destroy() functions, but such changes are invasive to
> > backport.  So they can be posted as a follow-up later for net-next.
> > 
> > Fixes: 03485f2adcde ("udpv6: Add lockless sendmsg() support")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> > Cc: Vladislav Yasevich <vyasevic@redhat.com>
> > ---
> >  include/net/ipv6.h    |  1 +
> >  include/net/udp.h     |  2 +-
> >  include/net/udplite.h |  8 --------
> >  net/ipv4/udp.c        |  9 ++++++---
> >  net/ipv4/udplite.c    |  8 ++++++++
> >  net/ipv6/af_inet6.c   |  9 ++++++++-
> >  net/ipv6/udp.c        | 15 ++++++++++++++-
> >  net/ipv6/udp_impl.h   |  1 +
> >  net/ipv6/udplite.c    |  9 ++++++++-
> >  9 files changed, 47 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> > index dfa70789b771..e7ec3e8cd52e 100644
> > --- a/include/net/ipv6.h
> > +++ b/include/net/ipv6.h
> > @@ -1179,6 +1179,7 @@ void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
> >  void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
> >  
> >  void inet6_cleanup_sock(struct sock *sk);
> > +void inet6_sock_destruct(struct sock *sk);
> >  int inet6_release(struct socket *sock);
> >  int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
> >  int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
> > diff --git a/include/net/udp.h b/include/net/udp.h
> > index 5ee88ddf79c3..fee053bcd17c 100644
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -247,7 +247,7 @@ static inline bool udp_sk_bound_dev_eq(struct net *net, int bound_dev_if,
> >  }
> >  
> >  /* net/ipv4/udp.c */
> > -void udp_destruct_sock(struct sock *sk);
> > +void udp_destruct_common(struct sock *sk);
> >  void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len);
> >  int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb);
> >  void udp_skb_destructor(struct sock *sk, struct sk_buff *skb);
> > diff --git a/include/net/udplite.h b/include/net/udplite.h
> > index 0143b373602e..299c14ce2bb9 100644
> > --- a/include/net/udplite.h
> > +++ b/include/net/udplite.h
> > @@ -25,14 +25,6 @@ static __inline__ int udplite_getfrag(void *from, char *to, int  offset,
> >  	return copy_from_iter_full(to, len, &msg->msg_iter) ? 0 : -EFAULT;
> >  }
> >  
> > -/* Designate sk as UDP-Lite socket */
> > -static inline int udplite_sk_init(struct sock *sk)
> > -{
> > -	udp_init_sock(sk);
> > -	udp_sk(sk)->pcflag = UDPLITE_BIT;
> > -	return 0;
> > -}
> > -
> >  /*
> >   * 	Checksumming routines
> >   */
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 560d9eadeaa5..48adb418e404 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1598,7 +1598,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
> >  }
> >  EXPORT_SYMBOL_GPL(__udp_enqueue_schedule_skb);
> >  
> > -void udp_destruct_sock(struct sock *sk)
> > +void udp_destruct_common(struct sock *sk)
> >  {
> >  	/* reclaim completely the forward allocated memory */
> >  	struct udp_sock *up = udp_sk(sk);
> > @@ -1611,10 +1611,14 @@ void udp_destruct_sock(struct sock *sk)
> >  		kfree_skb(skb);
> >  	}
> >  	udp_rmem_release(sk, total, 0, true);
> > +}
> > +EXPORT_SYMBOL_GPL(udp_destruct_common);
> >  
> > +static void udp_destruct_sock(struct sock *sk)
> > +{
> > +	udp_destruct_common(sk);
> >  	inet_sock_destruct(sk);
> >  }
> > -EXPORT_SYMBOL_GPL(udp_destruct_sock);
> >  
> >  int udp_init_sock(struct sock *sk)
> >  {
> > @@ -1622,7 +1626,6 @@ int udp_init_sock(struct sock *sk)
> >  	sk->sk_destruct = udp_destruct_sock;
> >  	return 0;
> >  }
> > -EXPORT_SYMBOL_GPL(udp_init_sock);
> >  
> >  void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len)
> >  {
> > diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
> > index 6e08a76ae1e7..4785ac4a8719 100644
> > --- a/net/ipv4/udplite.c
> > +++ b/net/ipv4/udplite.c
> > @@ -17,6 +17,14 @@
> >  struct udp_table 	udplite_table __read_mostly;
> >  EXPORT_SYMBOL(udplite_table);
> >  
> > +/* Designate sk as UDP-Lite socket */
> > +static inline int udplite_sk_init(struct sock *sk)
> 
> You should avoid the 'inline' specifier in c files.

I'll fix it.


> > +{
> > +	udp_init_sock(sk);
> > +	udp_sk(sk)->pcflag = UDPLITE_BIT;
> > +	return 0;
> > +}
> > +
> >  static int udplite_rcv(struct sk_buff *skb)
> >  {
> >  	return __udp4_lib_rcv(skb, &udplite_table, IPPROTO_UDPLITE);
> > diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> > index 83b9e432f3df..ce5378b78ec9 100644
> > --- a/net/ipv6/af_inet6.c
> > +++ b/net/ipv6/af_inet6.c
> > @@ -109,6 +109,13 @@ static __inline__ struct ipv6_pinfo *inet6_sk_generic(struct sock *sk)
> >  	return (struct ipv6_pinfo *)(((u8 *)sk) + offset);
> >  }
> >  
> > +void inet6_sock_destruct(struct sock *sk)
> > +{
> > +	inet6_cleanup_sock(sk);
> > +	inet_sock_destruct(sk);
> > +}
> > +EXPORT_SYMBOL_GPL(inet6_sock_destruct);
> 
> I'm sorry for not noticing this before, but it looks like the above
> export is not needed? only used by udp, which is in the same binary
> (either kernel of ipv6 module) as af_inet6

Ah, please don't be sorry, I appreciate your review!
Exactly, it compiled without exporting the symbol, I'll remove it in v5.
