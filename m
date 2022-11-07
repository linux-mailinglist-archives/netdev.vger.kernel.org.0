Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF89261E832
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 02:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiKGBPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 20:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiKGBPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 20:15:13 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF34D11F;
        Sun,  6 Nov 2022 17:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667783712; x=1699319712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LvG2y9vuTzkklBU+0KDISGnOwxeG/V5vl2Wv5z3k26s=;
  b=P/78D10X3XWrLWAxYKfPWljqEqK0xbL+hmmz3MnD7RU9PWV7SwerENOw
   uBsNw+Iy/bPUeRUIHc5b5+EXIo/W5QWZ4XU+kvgFS4umc6Jn2891xbkik
   2MuCrKhfty3zE/PBMTBjigI4TSBr3kvbbT95lbDo1VEzZVkFAnCn0hkas
   0=;
X-IronPort-AV: E=Sophos;i="5.96,143,1665446400"; 
   d="scan'208";a="238994624"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-fad5e78e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 01:15:06 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-fad5e78e.us-west-2.amazon.com (Postfix) with ESMTPS id A0107A3305;
        Mon,  7 Nov 2022 01:15:04 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 7 Nov 2022 01:15:03 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Mon, 7 Nov 2022 01:15:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <joannelkoong@gmail.com>
CC:     <acme@mandriva.com>, <davem@davemloft.net>, <dccp@vger.kernel.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>, <martin.lau@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <william.xuanziyang@huawei.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v1 net] dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
Date:   Sun, 6 Nov 2022 17:14:51 -0800
Message-ID: <20221107011451.35814-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAJnrk1ZF_0vG0gS0cVVjZSaiKpCFCbw3=C9twQqy-n9qPjoBiQ@mail.gmail.com>
References: <CAJnrk1ZF_0vG0gS0cVVjZSaiKpCFCbw3=C9twQqy-n9qPjoBiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D47UWA002.ant.amazon.com (10.43.163.30) To
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

From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Sun, 6 Nov 2022 11:18:44 -0800
> On Thu, Nov 3, 2022 at 10:24 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > When connect() is called on a socket bound to the wildcard address,
> > we change the socket's saddr to a local address.  If the socket
> > fails to connect() to the destination, we have to reset the saddr.
> >
> > However, when an error occurs after inet_hash6?_connect() in
> > (dccp|tcp)_v[46]_conect(), we forget to reset saddr and leave
> > the socket bound to the address.
> >
> > From the user's point of view, whether saddr is reset or not varies
> > with errno.  Let's fix this inconsistent behaviour.
> >
> > Note that with this patch, the repro [0] will trigger the WARN_ON()
> > in inet_csk_get_port() again, but this patch is not buggy and rather
> > fixes a bug papering over the bhash2's bug [1] for which we need
> > another fix.
> >
> > For the record, the repro causes -EADDRNOTAVAIL in inet_hash6_connect()
> > by this sequence:
> >
> >   s1 = socket()
> >   s1.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> >   s1.bind(('127.0.0.1', 10000))
> >   s1.sendto(b'hello', MSG_FASTOPEN, (('127.0.0.1', 10000)))
> >   # or s1.connect(('127.0.0.1', 10000))
> >
> >   s2 = socket()
> >   s2.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> >   s2.bind(('0.0.0.0', 10000))
> >   s2.connect(('127.0.0.1', 10000))  # -EADDRNOTAVAIL
> >
> >   s2.listen(32)  # WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);
> >
> > [0]: https://syzkaller.appspot.com/bug?extid=015d756bbd1f8b5c8f09
> > [1]: https://lore.kernel.org/netdev/20221029001249.86337-1-kuniyu@amazon.com/
> >
> > Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
> > Fixes: 7c657876b63c ("[DCCP]: Initial implementation")
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  net/dccp/ipv4.c     | 2 ++
> >  net/dccp/ipv6.c     | 2 ++
> >  net/ipv4/tcp_ipv4.c | 2 ++
> >  net/ipv6/tcp_ipv6.c | 2 ++
> >  4 files changed, 8 insertions(+)
> >
> > diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> > index 713b7b8dad7e..40640c26680e 100644
> > --- a/net/dccp/ipv4.c
> > +++ b/net/dccp/ipv4.c
> > @@ -157,6 +157,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> >          * This unhashes the socket and releases the local port, if necessary.
> >          */
> >         dccp_set_state(sk, DCCP_CLOSED);
> > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > +               inet_reset_saddr(sk);
> >         ip_rt_put(rt);
> >         sk->sk_route_caps = 0;
> >         inet->inet_dport = 0;
> > diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> > index e57b43006074..626166cb6d7e 100644
> > --- a/net/dccp/ipv6.c
> > +++ b/net/dccp/ipv6.c
> > @@ -985,6 +985,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> >
> >  late_failure:
> >         dccp_set_state(sk, DCCP_CLOSED);
> > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > +               inet_reset_saddr(sk);
> >         __sk_dst_reset(sk);
> >  failure:
> >         inet->inet_dport = 0;
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index 87d440f47a70..6a3a732b584d 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -343,6 +343,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> >          * if necessary.
> >          */
> >         tcp_set_state(sk, TCP_CLOSE);
> > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > +               inet_reset_saddr(sk);
> >         ip_rt_put(rt);
> >         sk->sk_route_caps = 0;
> >         inet->inet_dport = 0;
> > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > index 2a3f9296df1e..81b396e5cf79 100644
> > --- a/net/ipv6/tcp_ipv6.c
> > +++ b/net/ipv6/tcp_ipv6.c
> > @@ -359,6 +359,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> >
> >  late_failure:
> >         tcp_set_state(sk, TCP_CLOSE);
> > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > +               inet_reset_saddr(sk);
> >  failure:
> >         inet->inet_dport = 0;
> >         sk->sk_route_caps = 0;
> > --
> > 2.30.2
> >
> 
> inet_reset_saddr() sets both inet_saddr and inet_rcv_saddr to 0, but I
> think there are some edge cases where when dccp/tcp_v4/6_connect() is
> called, inet_saddr is 0 but inet_rcv_saddr is not, which means we'd
> need to reset inet_rcv_saddr to its original value. The example case
> I'm looking at is  __inet_bind() where if the request is to bind to a
> multicast address,
> 
>     inet->inet_rcv_saddr = inet->inet_saddr = addr->sin_addr.s_addr;
>     if (chk_addr_ret == RTN_MULTICAST || chk_addr_ret == RTN_BROADCAST)
>         inet->inet_saddr = 0;  /* Use device */

Thanks for reviewing.

We have to take care of these two error paths.

  * (dccp|tcp)_v[46]_coonnect()
  * __inet_stream_connect()

In __inet_stream_connect(), we call ->disconnect(), which already has the
same logic in this patch.

In your edge case, once (dccp|tcp)_v[46]_coonnect() succeeds, both of
inet->inet_saddr and sk_rcv_saddr are non-zero.  If connect() fails after
that, in ->disconnect(), we cannot know if we should restore sk_rcv_saddr
only.  Also, we don't have the previous address there.

For these reasons, we reset both addresses only if the sk was bound to
INADDR_ANY, which we can detect by the SOCK_BINDADDR_LOCK flag.

As you mentinoed, we can restore sk_rcv_saddr for the edge case in
(dccp|tcp)_v[46]_coonnect() but cannot in __inet_stream_connect().

If we do so, we need another flag for the case and another member to save
the old multicast/broadcast address. (+ where we need rehash for bhash2)

What do you think ?
