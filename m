Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90A062CF6A
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbiKQAUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbiKQAU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:20:29 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69A645EF1;
        Wed, 16 Nov 2022 16:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668644427; x=1700180427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OwavocW5NJuPb92cb+UmVHArM9k2XXgrJ2q8fSHGR3M=;
  b=MraeKwuqFN7oJpWW9NgUruy+yYO6URBSBo21gMH5NCkPXZB/XU22DLiB
   shAC5tBeutarJGHyumRF8nouQfyBuA7MgMSV/WT9bWtBIVSxDxW0+WFpT
   EoA9J3THRm8bASSydkXuKV28GV0s3UM687sGJM0KiVXY6in5IS9LQFWWv
   Q=;
X-IronPort-AV: E=Sophos;i="5.96,169,1665446400"; 
   d="scan'208";a="1074475348"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 00:20:22 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id A87AFC333F;
        Thu, 17 Nov 2022 00:20:21 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 17 Nov 2022 00:20:21 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Thu, 17 Nov 2022 00:20:18 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <joannelkoong@gmail.com>
CC:     <acme@mandriva.com>, <davem@davemloft.net>, <dccp@vger.kernel.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>, <martin.lau@kernel.org>,
        <mathew.j.martineau@linux.intel.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <pengfei.xu@intel.com>,
        <stephen@networkplumber.org>, <william.xuanziyang@huawei.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2 net 1/4] dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
Date:   Wed, 16 Nov 2022 16:20:10 -0800
Message-ID: <20221117002010.72675-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAJnrk1YOfyGQ2Vic9xkoSj+uv7fuYAwh4wFLv1cBJ5LPiHsEvw@mail.gmail.com>
References: <CAJnrk1YOfyGQ2Vic9xkoSj+uv7fuYAwh4wFLv1cBJ5LPiHsEvw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D34UWA001.ant.amazon.com (10.43.160.173) To
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
Date:   Wed, 16 Nov 2022 16:11:21 -0800
> On Wed, Nov 16, 2022 at 2:28 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
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
> > Note that after this patch, the repro [0] will trigger the WARN_ON()
> > in inet_csk_get_port() again, but this patch is not buggy and rather
> > fixes a bug papering over the bhash2's bug for which we need another
> > fix.
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
> >
> > Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
> > Fixes: 7c657876b63c ("[DCCP]: Initial implementation")
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> LGTM. Btw, the 4th patch in this series overwrites these changes by
> moving this logic into the new inet_bhash2_reset_saddr() function you
> added, so we could also drop this patch from the series. OTOH, this
> commit message in this patch has some good background context. So I
> don't have a preference either way :)
> 
> Acked-by: Joanne Koong <joannelkoong@gmail.com>

Thanks for reviewing!

Yes, these changes are overwritten later, but only this patch can be
backported to other stable versions, so I kept this separated.


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
