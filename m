Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF825EC9EF
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbiI0QtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbiI0Qsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:48:53 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757ADB4AB;
        Tue, 27 Sep 2022 09:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664297329; x=1695833329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KeNqr9c4YEEl6TJaonX4jPKG+rD7IHPilstBlaa2ATY=;
  b=Qf4J48wZ0/T8RZUFCD8BUhjdaU/hmEBAnRChYAXexgInsa0w74WGYKsW
   vJRXzVTr4fKvRO23DrFe8H2hRcNjCndk6fhGdn8reoma9IcdwCE31xeCl
   fF8Lx5XgaLhWqEZWV7xyEr7nQmBF+oNPYLkZEeZO27lHC2honq8uyEABk
   E=;
X-IronPort-AV: E=Sophos;i="5.93,349,1654560000"; 
   d="scan'208";a="249252708"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-28a78e3f.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 16:48:35 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-28a78e3f.us-west-2.amazon.com (Postfix) with ESMTPS id BD1FAA2614;
        Tue, 27 Sep 2022 16:48:34 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 27 Sep 2022 16:48:34 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.214) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 27 Sep 2022 16:48:31 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH v1 net 5/5] tcp: Fix data races around icsk->icsk_af_ops.
Date:   Tue, 27 Sep 2022 09:48:24 -0700
Message-ID: <20220927164824.36027-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iLyqG8SRmHhWZOZUc-HDR88z_TNZn4_zbJz5MW4+kh2ZQ@mail.gmail.com>
References: <CANn89iLyqG8SRmHhWZOZUc-HDR88z_TNZn4_zbJz5MW4+kh2ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.214]
X-ClientProxiedBy: EX13D44UWC002.ant.amazon.com (10.43.162.169) To
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
Date:   Tue, 27 Sep 2022 09:39:37 -0700
> On Tue, Sep 27, 2022 at 9:33 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > IPV6_ADDRFORM changes icsk->icsk_af_ops under lock_sock(), but
> > tcp_(get|set)sockopt() read it locklessly.  To avoid load/store
> > tearing, we need to add READ_ONCE() and WRITE_ONCE() for the reads
> > and write.
> 
> I am pretty sure I have released a syzkaller bug recently with this issue.
> Have you seen this?
> If yes, please include the appropriate syzbot tag.

No, I haven't.
Could you provide the URL?
I'm happy to include the syzbot tag and KCSAN report in the changelog.


> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  net/ipv4/tcp.c           | 10 ++++++----
> >  net/ipv6/ipv6_sockglue.c |  3 ++-
> >  2 files changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index e373dde1f46f..c86dd0ccef5b 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -3795,8 +3795,9 @@ int tcp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
> >         const struct inet_connection_sock *icsk = inet_csk(sk);
> >
> >         if (level != SOL_TCP)
> > -               return icsk->icsk_af_ops->setsockopt(sk, level, optname,
> > -                                                    optval, optlen);
> > +               /* IPV6_ADDRFORM can change icsk->icsk_af_ops under us. */
> > +               return READ_ONCE(icsk->icsk_af_ops)->setsockopt(sk, level, optname,
> > +                                                               optval, optlen);
> >         return do_tcp_setsockopt(sk, level, optname, optval, optlen);
> >  }
> >  EXPORT_SYMBOL(tcp_setsockopt);
> > @@ -4394,8 +4395,9 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
> >         struct inet_connection_sock *icsk = inet_csk(sk);
> >
> >         if (level != SOL_TCP)
> > -               return icsk->icsk_af_ops->getsockopt(sk, level, optname,
> > -                                                    optval, optlen);
> > +               /* IPV6_ADDRFORM can change icsk->icsk_af_ops under us. */
> > +               return READ_ONCE(icsk->icsk_af_ops)->getsockopt(sk, level, optname,
> > +                                                               optval, optlen);
> >         return do_tcp_getsockopt(sk, level, optname, optval, optlen);
> >  }
> >  EXPORT_SYMBOL(tcp_getsockopt);
> > diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> > index a89db5872dc3..726d95859898 100644
> > --- a/net/ipv6/ipv6_sockglue.c
> > +++ b/net/ipv6/ipv6_sockglue.c
> > @@ -479,7 +479,8 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
> >
> >                                 /* Paired with READ_ONCE(sk->sk_prot) in inet6_stream_ops */
> >                                 WRITE_ONCE(sk->sk_prot, &tcp_prot);
> > -                               icsk->icsk_af_ops = &ipv4_specific;
> > +                               /* Paired with READ_ONCE() in tcp_(get|set)sockopt() */
> > +                               WRITE_ONCE(icsk->icsk_af_ops, &ipv4_specific);
> >                                 sk->sk_socket->ops = &inet_stream_ops;
> >                                 sk->sk_family = PF_INET;
> >                                 tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
> > --
> > 2.30.2
> >
