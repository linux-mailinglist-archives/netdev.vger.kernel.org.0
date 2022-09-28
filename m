Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9625ED3BB
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 06:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiI1EAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 00:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiI1EAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 00:00:41 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDC22AF1;
        Tue, 27 Sep 2022 21:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664337640; x=1695873640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cH9DSO15A/GB38Vjdcq45IGeRo3cxOGiz91GY/0LOCs=;
  b=nlq2QhIC7dwG40AzGcFldhdOXA9aydHLmQXyoiB/xsELK+WcvyyPyYS8
   lYIW6TbOXHkfmNcmdoFPLpWzF/v5n9LS2JjCv2nkQ8qArst2lnAYVOv8W
   FmsYKBItte4jwvltSHmZ2pHxyUm+WcKpNXF4+29jf49/9DDPFZXlMlPiO
   E=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-718d0906.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 04:00:27 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-718d0906.us-west-2.amazon.com (Postfix) with ESMTPS id E4BA03E00DE;
        Wed, 28 Sep 2022 04:00:25 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 28 Sep 2022 04:00:25 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.32) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Wed, 28 Sep 2022 04:00:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH v2 net 3/5] tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().
Date:   Tue, 27 Sep 2022 21:00:14 -0700
Message-ID: <20220928040014.76884-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iL00_Gz+jiczvmHPCV9nO7Lzctq_JLyp1V-0obuPWBanQ@mail.gmail.com>
References: <CANn89iL00_Gz+jiczvmHPCV9nO7Lzctq_JLyp1V-0obuPWBanQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.32]
X-ClientProxiedBy: EX13D21UWA004.ant.amazon.com (10.43.160.252) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 20:43:51 -0700
> On Tue, Sep 27, 2022 at 5:29 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
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
> > in IPv6 sk->sk_destruct() not to miss the future change and a similar
> > bug fixed in commit e27326009a3d ("net: ping6: Fix memleak in
> > ipv6_renew_options().")
> 
> I do not see how your patches prevent rxpmtu to be created at the time
> of IPV6_ADDRFROM ?
> 
> There seem to be races.
> 
> lockless UDP sendmsg() is a disaster really.

I think we are never able to prevent it and races exist unless we remove
the lockless path itself, so the patch makes sure to free rxpmtu at least
when we close() the socket.  Currently, we can not even free it.


> > We can now remove all inet6_destroy_sock() calls from IPv6 protocol
> > specific ->destroy() functions, but such changes are invasive to
> > backport.  So they can be posted as a follow-up later for net-next.
> >
> > Fixes: 03485f2adcde ("udpv6: Add lockless sendmsg() support")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  include/net/ipv6.h  |  1 +
> >  include/net/udp.h   |  2 +-
> >  net/ipv4/udp.c      |  8 ++++++--
> >  net/ipv6/af_inet6.c |  9 ++++++++-
> >  net/ipv6/udp.c      | 15 ++++++++++++++-
> >  5 files changed, 30 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> > index de9dcc5652c4..11f1a9a8b066 100644
> > --- a/include/net/ipv6.h
> > +++ b/include/net/ipv6.h
> > @@ -1178,6 +1178,7 @@ void ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err, __be16 port,
> >  void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
> >  void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
> >
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
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 560d9eadeaa5..a84ae44db7e2 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1598,7 +1598,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
> >  }
> >  EXPORT_SYMBOL_GPL(__udp_enqueue_schedule_skb);
> >
> > -void udp_destruct_sock(struct sock *sk)
> > +void udp_destruct_common(struct sock *sk)
> >  {
> >         /* reclaim completely the forward allocated memory */
> >         struct udp_sock *up = udp_sk(sk);
> > @@ -1611,10 +1611,14 @@ void udp_destruct_sock(struct sock *sk)
> >                 kfree_skb(skb);
> >         }
> >         udp_rmem_release(sk, total, 0, true);
> > +}
> > +EXPORT_SYMBOL_GPL(udp_destruct_common);
> >
> > +static void udp_destruct_sock(struct sock *sk)
> > +{
> > +       udp_destruct_common(sk);
> >         inet_sock_destruct(sk);
> >  }
> > -EXPORT_SYMBOL_GPL(udp_destruct_sock);
> >
> >  int udp_init_sock(struct sock *sk)
> >  {
> > diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> > index dbb1430d6cc2..0774cff62f2d 100644
> > --- a/net/ipv6/af_inet6.c
> > +++ b/net/ipv6/af_inet6.c
> > @@ -109,6 +109,13 @@ static __inline__ struct ipv6_pinfo *inet6_sk_generic(struct sock *sk)
> >         return (struct ipv6_pinfo *)(((u8 *)sk) + offset);
> >  }
> >
> > +void inet6_sock_destruct(struct sock *sk)
> > +{
> > +       inet6_destroy_sock(sk);
> > +       inet_sock_destruct(sk);
> > +}
> > +EXPORT_SYMBOL_GPL(inet6_sock_destruct);
> > +
> >  static int inet6_create(struct net *net, struct socket *sock, int protocol,
> >                         int kern)
> >  {
> > @@ -201,7 +208,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
> >                         inet->hdrincl = 1;
> >         }
> >
> > -       sk->sk_destruct         = inet_sock_destruct;
> > +       sk->sk_destruct         = inet6_sock_destruct;
> >         sk->sk_family           = PF_INET6;
> >         sk->sk_protocol         = protocol;
> >
> > diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> > index 3366d6a77ff2..a5256f7184ab 100644
> > --- a/net/ipv6/udp.c
> > +++ b/net/ipv6/udp.c
> > @@ -56,6 +56,19 @@
> >  #include <trace/events/skb.h>
> >  #include "udp_impl.h"
> >
> > +static void udpv6_destruct_sock(struct sock *sk)
> > +{
> > +       udp_destruct_common(sk);
> > +       inet6_sock_destruct(sk);
> > +}
> > +
> > +static int udpv6_init_sock(struct sock *sk)
> > +{
> > +       skb_queue_head_init(&udp_sk(sk)->reader_queue);
> > +       sk->sk_destruct = udpv6_destruct_sock;
> > +       return 0;
> > +}
> > +
> >  static u32 udp6_ehashfn(const struct net *net,
> >                         const struct in6_addr *laddr,
> >                         const u16 lport,
> > @@ -1723,7 +1736,7 @@ struct proto udpv6_prot = {
> >         .connect                = ip6_datagram_connect,
> >         .disconnect             = udp_disconnect,
> >         .ioctl                  = udp_ioctl,
> > -       .init                   = udp_init_sock,
> > +       .init                   = udpv6_init_sock,
> >         .destroy                = udpv6_destroy_sock,
> >         .setsockopt             = udpv6_setsockopt,
> >         .getsockopt             = udpv6_getsockopt,
> > --
> > 2.30.2
