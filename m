Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716825ECA30
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbiI0Q4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiI0Qzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:55:46 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC404E61D
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:55:16 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id e187so12910391ybh.10
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=vv3W7RQ7dbZpyBjlAQgi1M2Mtk3zvmXTUqiF3crSNUY=;
        b=WW16dMN983lgj7CgWDAI1u+cbIcZvIuoT1QF4KByI9XPKrblTCqJ+fiueGcp5vlHT3
         HWcCr0UV2jMVaJPltFx6TxPGBPOfBOrHTW5omESJCIXOn19wYqHUIU56mR6RsELxKoz4
         XOXh0q7aEvNUHvdq8otTruXqYyH0wlnIqai7dfGeYPRCTku/jOszoEmEUOCXhm/2KXaC
         ZHWGCvsqBOOal2tc4BUB8WhDGwoi87OPQqWFWqdZK54OjugNl6dTyWL/EeF67Pds/Sfk
         Pc8eooNqTvezdHI7UKVch9QpGoKUHpNn1hg10bn8yM0+Nb78a3iXXZl4Jq9QLVmv+vVE
         uMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vv3W7RQ7dbZpyBjlAQgi1M2Mtk3zvmXTUqiF3crSNUY=;
        b=HktEpDaGpMqh/d9e5ewywur3+mjeNt1h7/wTWmLqoRFlIdnhtLTNBfUg4EoKujJhFl
         xzQ/4uN+zuzBhbUImn0raro3qq6h2xvDh40wKrnJsO/Ru+S7jxgzM9p2gFC0jdMbfr2C
         AnR9kUrYs3jpMaYUOLCb66JgBV9wIW2pA/5o99LZB3IhMfCD3it2hvzAqXScv5scl4XX
         hfLfAbXrdESzcfBGhwm9XHtUTuIN2kcAcqUZP5z8aO8tq6x0r52LC0pQS5frmPiDSvz4
         oOneGMzD6grC0Euz5tjXcrCT4luF+wHiLdZHZhP2WjmE8r3leP/2bTieGXvvxcN+a7P9
         G4mw==
X-Gm-Message-State: ACrzQf193CObmSRuyUASOyM9svwpNna4zdOO+JhPCmT0OZLo1iKRUqIi
        tB6mIj9+IN7hHXcU3nBJ4YmmcYr/Bbt9MTqYdMTg7A==
X-Google-Smtp-Source: AMsMyM6NbbMtdQMpVfLCAh0D0q68PKe3qwWQ3D+kcPlFlbxLVmV17y2Ou35POHeKahxqYviJ1ZAc33Ny+NGeQhVBJcQ=
X-Received: by 2002:a25:80d0:0:b0:6b3:f287:93a4 with SMTP id
 c16-20020a2580d0000000b006b3f28793a4mr25039297ybm.427.1664297715530; Tue, 27
 Sep 2022 09:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iLyqG8SRmHhWZOZUc-HDR88z_TNZn4_zbJz5MW4+kh2ZQ@mail.gmail.com>
 <20220927164824.36027-1-kuniyu@amazon.com>
In-Reply-To: <20220927164824.36027-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 09:55:03 -0700
Message-ID: <CANn89iJ-a6DQ=ZmaQJKag3Tpa15TK-3E2o9=FHQVZb8QDCEvHQ@mail.gmail.com>
Subject: Re: [PATCH v1 net 5/5] tcp: Fix data races around icsk->icsk_af_ops.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 9:48 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Tue, 27 Sep 2022 09:39:37 -0700
> > On Tue, Sep 27, 2022 at 9:33 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > IPV6_ADDRFORM changes icsk->icsk_af_ops under lock_sock(), but
> > > tcp_(get|set)sockopt() read it locklessly.  To avoid load/store
> > > tearing, we need to add READ_ONCE() and WRITE_ONCE() for the reads
> > > and write.
> >
> > I am pretty sure I have released a syzkaller bug recently with this issue.
> > Have you seen this?
> > If yes, please include the appropriate syzbot tag.
>
> No, I haven't.
> Could you provide the URL?
> I'm happy to include the syzbot tag and KCSAN report in the changelog.
>
>

Report has been released 10 days ago, but apparently the syzbot queue
is so full these days that the report is still throttled.

==================================================================
BUG: KCSAN: data-race in tcp_setsockopt / tcp_v6_connect

write to 0xffff88813c624518 of 8 bytes by task 23936 on cpu 0:
tcp_v6_connect+0x5b3/0xce0 net/ipv6/tcp_ipv6.c:240
__inet_stream_connect+0x159/0x6d0 net/ipv4/af_inet.c:660
inet_stream_connect+0x44/0x70 net/ipv4/af_inet.c:724
__sys_connect_file net/socket.c:1976 [inline]
__sys_connect+0x197/0x1b0 net/socket.c:1993
__do_sys_connect net/socket.c:2003 [inline]
__se_sys_connect net/socket.c:2000 [inline]
__x64_sys_connect+0x3d/0x50 net/socket.c:2000
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffff88813c624518 of 8 bytes by task 23937 on cpu 1:
tcp_setsockopt+0x147/0x1c80 net/ipv4/tcp.c:3789
sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3585
__sys_setsockopt+0x212/0x2b0 net/socket.c:2252
__do_sys_setsockopt net/socket.c:2263 [inline]
__se_sys_setsockopt net/socket.c:2260 [inline]
__x64_sys_setsockopt+0x62/0x70 net/socket.c:2260
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0xffffffff8539af68 -> 0xffffffff8539aff8

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 23937 Comm: syz-executor.5 Not tainted
6.0.0-rc4-syzkaller-00331-g4ed9c1e971b1-dirty #0

Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 08/26/2022
==================================================================

> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > ---
> > >  net/ipv4/tcp.c           | 10 ++++++----
> > >  net/ipv6/ipv6_sockglue.c |  3 ++-
> > >  2 files changed, 8 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > index e373dde1f46f..c86dd0ccef5b 100644
> > > --- a/net/ipv4/tcp.c
> > > +++ b/net/ipv4/tcp.c
> > > @@ -3795,8 +3795,9 @@ int tcp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
> > >         const struct inet_connection_sock *icsk = inet_csk(sk);
> > >
> > >         if (level != SOL_TCP)
> > > -               return icsk->icsk_af_ops->setsockopt(sk, level, optname,
> > > -                                                    optval, optlen);
> > > +               /* IPV6_ADDRFORM can change icsk->icsk_af_ops under us. */
> > > +               return READ_ONCE(icsk->icsk_af_ops)->setsockopt(sk, level, optname,
> > > +                                                               optval, optlen);
> > >         return do_tcp_setsockopt(sk, level, optname, optval, optlen);
> > >  }
> > >  EXPORT_SYMBOL(tcp_setsockopt);
> > > @@ -4394,8 +4395,9 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
> > >         struct inet_connection_sock *icsk = inet_csk(sk);
> > >
> > >         if (level != SOL_TCP)
> > > -               return icsk->icsk_af_ops->getsockopt(sk, level, optname,
> > > -                                                    optval, optlen);
> > > +               /* IPV6_ADDRFORM can change icsk->icsk_af_ops under us. */
> > > +               return READ_ONCE(icsk->icsk_af_ops)->getsockopt(sk, level, optname,
> > > +                                                               optval, optlen);
> > >         return do_tcp_getsockopt(sk, level, optname, optval, optlen);
> > >  }
> > >  EXPORT_SYMBOL(tcp_getsockopt);
> > > diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> > > index a89db5872dc3..726d95859898 100644
> > > --- a/net/ipv6/ipv6_sockglue.c
> > > +++ b/net/ipv6/ipv6_sockglue.c
> > > @@ -479,7 +479,8 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
> > >
> > >                                 /* Paired with READ_ONCE(sk->sk_prot) in inet6_stream_ops */
> > >                                 WRITE_ONCE(sk->sk_prot, &tcp_prot);
> > > -                               icsk->icsk_af_ops = &ipv4_specific;
> > > +                               /* Paired with READ_ONCE() in tcp_(get|set)sockopt() */
> > > +                               WRITE_ONCE(icsk->icsk_af_ops, &ipv4_specific);
> > >                                 sk->sk_socket->ops = &inet_stream_ops;
> > >                                 sk->sk_family = PF_INET;
> > >                                 tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
> > > --
> > > 2.30.2
> > >
