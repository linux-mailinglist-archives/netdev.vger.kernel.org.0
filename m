Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBAB5ECBFE
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 20:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbiI0SQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 14:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiI0SQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 14:16:48 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53CD77E91;
        Tue, 27 Sep 2022 11:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664302607; x=1695838607;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PuABBEe9ztA82DNS3lLRxVtCVWUTdMo9AbnRbcTH3fk=;
  b=NKCybjJXANSIEFP/quegB4iXlehQEjMfnviPG0nKSk+nC1hXgCIze6w9
   ihgmIOqgoDKE7qQJamXrjHlpRjWGTtM3bQpJRScNJyhguJA//k1ZR6o+N
   VBb1Ob6sHy047mhbu7ADSxEgnPlOqF/X8tKYtE77cY+hDsOSBBE6zrBxp
   k=;
X-IronPort-AV: E=Sophos;i="5.93,350,1654560000"; 
   d="scan'208";a="1058574852"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-f20e0c8b.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 17:07:14 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-f20e0c8b.us-east-1.amazon.com (Postfix) with ESMTPS id D7CC681B4A;
        Tue, 27 Sep 2022 17:07:13 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 27 Sep 2022 17:07:13 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.179) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 27 Sep 2022 17:07:10 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH v1 net 5/5] tcp: Fix data races around icsk->icsk_af_ops.
Date:   Tue, 27 Sep 2022 10:07:03 -0700
Message-ID: <20220927170703.37265-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJ-a6DQ=ZmaQJKag3Tpa15TK-3E2o9=FHQVZb8QDCEvHQ@mail.gmail.com>
References: <CANn89iJ-a6DQ=ZmaQJKag3Tpa15TK-3E2o9=FHQVZb8QDCEvHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.179]
X-ClientProxiedBy: EX13P01UWB004.ant.amazon.com (10.43.161.213) To
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
Date:   Tue, 27 Sep 2022 09:55:03 -0700
> On Tue, Sep 27, 2022 at 9:48 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Tue, 27 Sep 2022 09:39:37 -0700
> > > On Tue, Sep 27, 2022 at 9:33 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > IPV6_ADDRFORM changes icsk->icsk_af_ops under lock_sock(), but
> > > > tcp_(get|set)sockopt() read it locklessly.  To avoid load/store
> > > > tearing, we need to add READ_ONCE() and WRITE_ONCE() for the reads
> > > > and write.
> > >
> > > I am pretty sure I have released a syzkaller bug recently with this issue.
> > > Have you seen this?
> > > If yes, please include the appropriate syzbot tag.
> >
> > No, I haven't.
> > Could you provide the URL?
> > I'm happy to include the syzbot tag and KCSAN report in the changelog.
> >
> >
> 
> Report has been released 10 days ago, but apparently the syzbot queue
> is so full these days that the report is still throttled.

Thank you!
I'll add this in v2.


> 
> ==================================================================
> BUG: KCSAN: data-race in tcp_setsockopt / tcp_v6_connect
> 
> write to 0xffff88813c624518 of 8 bytes by task 23936 on cpu 0:
> tcp_v6_connect+0x5b3/0xce0 net/ipv6/tcp_ipv6.c:240
> __inet_stream_connect+0x159/0x6d0 net/ipv4/af_inet.c:660
> inet_stream_connect+0x44/0x70 net/ipv4/af_inet.c:724
> __sys_connect_file net/socket.c:1976 [inline]
> __sys_connect+0x197/0x1b0 net/socket.c:1993
> __do_sys_connect net/socket.c:2003 [inline]
> __se_sys_connect net/socket.c:2000 [inline]
> __x64_sys_connect+0x3d/0x50 net/socket.c:2000
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> read to 0xffff88813c624518 of 8 bytes by task 23937 on cpu 1:
> tcp_setsockopt+0x147/0x1c80 net/ipv4/tcp.c:3789
> sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3585
> __sys_setsockopt+0x212/0x2b0 net/socket.c:2252
> __do_sys_setsockopt net/socket.c:2263 [inline]
> __se_sys_setsockopt net/socket.c:2260 [inline]
> __x64_sys_setsockopt+0x62/0x70 net/socket.c:2260
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> value changed: 0xffffffff8539af68 -> 0xffffffff8539aff8
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 23937 Comm: syz-executor.5 Not tainted
> 6.0.0-rc4-syzkaller-00331-g4ed9c1e971b1-dirty #0
> 
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 08/26/2022
> ==================================================================
> 
> > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > ---
> > > >  net/ipv4/tcp.c           | 10 ++++++----
> > > >  net/ipv6/ipv6_sockglue.c |  3 ++-
> > > >  2 files changed, 8 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > > index e373dde1f46f..c86dd0ccef5b 100644
> > > > --- a/net/ipv4/tcp.c
> > > > +++ b/net/ipv4/tcp.c
> > > > @@ -3795,8 +3795,9 @@ int tcp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
> > > >         const struct inet_connection_sock *icsk = inet_csk(sk);
> > > >
> > > >         if (level != SOL_TCP)
> > > > -               return icsk->icsk_af_ops->setsockopt(sk, level, optname,
> > > > -                                                    optval, optlen);
> > > > +               /* IPV6_ADDRFORM can change icsk->icsk_af_ops under us. */
> > > > +               return READ_ONCE(icsk->icsk_af_ops)->setsockopt(sk, level, optname,
> > > > +                                                               optval, optlen);
> > > >         return do_tcp_setsockopt(sk, level, optname, optval, optlen);
> > > >  }
> > > >  EXPORT_SYMBOL(tcp_setsockopt);
> > > > @@ -4394,8 +4395,9 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
> > > >         struct inet_connection_sock *icsk = inet_csk(sk);
> > > >
> > > >         if (level != SOL_TCP)
> > > > -               return icsk->icsk_af_ops->getsockopt(sk, level, optname,
> > > > -                                                    optval, optlen);
> > > > +               /* IPV6_ADDRFORM can change icsk->icsk_af_ops under us. */
> > > > +               return READ_ONCE(icsk->icsk_af_ops)->getsockopt(sk, level, optname,
> > > > +                                                               optval, optlen);
> > > >         return do_tcp_getsockopt(sk, level, optname, optval, optlen);
> > > >  }
> > > >  EXPORT_SYMBOL(tcp_getsockopt);
> > > > diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> > > > index a89db5872dc3..726d95859898 100644
> > > > --- a/net/ipv6/ipv6_sockglue.c
> > > > +++ b/net/ipv6/ipv6_sockglue.c
> > > > @@ -479,7 +479,8 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
> > > >
> > > >                                 /* Paired with READ_ONCE(sk->sk_prot) in inet6_stream_ops */
> > > >                                 WRITE_ONCE(sk->sk_prot, &tcp_prot);
> > > > -                               icsk->icsk_af_ops = &ipv4_specific;
> > > > +                               /* Paired with READ_ONCE() in tcp_(get|set)sockopt() */
> > > > +                               WRITE_ONCE(icsk->icsk_af_ops, &ipv4_specific);
> > > >                                 sk->sk_socket->ops = &inet_stream_ops;
> > > >                                 sk->sk_family = PF_INET;
> > > >                                 tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
> > > > --
> > > > 2.30.2

