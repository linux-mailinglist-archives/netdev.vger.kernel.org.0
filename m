Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7505ECBC7
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 19:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbiI0R45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 13:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbiI0R4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 13:56:33 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21FEB2493
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 10:56:32 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-349c4310cf7so107919447b3.3
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 10:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=wodJgfUa1EcS285xg38sKYnqTm2D6j7gyqKsVFEC5zw=;
        b=IymQIo8MZKGuoPYfkbpgeB3mZsTTmn9WB2O236WpkhioG7mthSB+hhCF+OlJP2NuFt
         55bH7UJ9iH9Cd/YJWRcND7dN0VYFJqbBgRla3mr8aoC9C4TKC65EQVpgu6QH6+0vNcD6
         mrf8+3aLsv083VhX5VsENYhWCHDdYAHaYg0Ad9/Xd/8MoP65KCVbI3EuTEIOr7ol2VIp
         +GBIPVOX9hZcvWNgovc8bsm18bP+bFLQwrmdXaoo1m4bYiyOuARVa8t8QFziv+ATsHWJ
         j+oN6hUJy+m+Uem2Hhedwttr+qNUL9gZVYo3k092jU3zPMbQbQV2O8RYP8Ovb1bB4/jD
         ZTFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=wodJgfUa1EcS285xg38sKYnqTm2D6j7gyqKsVFEC5zw=;
        b=SImIHu5nKYEGDgprVjuYbAqB4tzOZamKiM3H7BElQ1TeFyuVbXMg2k9PkZ827VpVhp
         0KMqfjdWmGpDRFGMqJe/VmHa5X6OTgCajcmj068U0LCPfh0xAh0zsxJ4t8VJ+0OlX7x/
         xSmtr1gqEG91aNSh2Yveq/AHbtArzo9oKkDguljyX4m/RG+4eUR4SQ0vGO++JKkSHFnH
         Yz8SHj+rrQXR1PimV4Io/jgtRHSuwYACp6LmMzS+FYkrxSbWjEPfJpMklS5d7jBfX4xc
         eJ7MTNdFhasajAjA/BbtgY9PnuX0BYVlfcHoqR0GwmIbkL8FazfR4FPfz3wEqeAu6FZO
         fypg==
X-Gm-Message-State: ACrzQf0bWYOkqUYI9nBF/kvgZ28Ivev1hF6YsAqFbaFFXB+OU+PbHxLC
        753IvP2I8+RyWtEvTb2ehhLNW7Tlo+v+KwjlEfCC7w==
X-Google-Smtp-Source: AMsMyM4KSP5GR9r6ddt+d6r6UErUJtG+Ci8JAn6QFzU4f2g40KIju+kRkFsCLoP02jtWq+0zZvYgJWChOTZsFv2+eYY=
X-Received: by 2002:a0d:e244:0:b0:351:ce09:1b13 with SMTP id
 l65-20020a0de244000000b00351ce091b13mr4099010ywe.332.1664301391921; Tue, 27
 Sep 2022 10:56:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220927164824.36027-1-kuniyu@amazon.com> <20220927165340.36239-1-kuniyu@amazon.com>
In-Reply-To: <20220927165340.36239-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 10:56:20 -0700
Message-ID: <CANn89i+sETETmONTC_ZBS688W8vpFyXpxFKjMw-Hh_cZevwQ6g@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 10:49 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Kuniyuki Iwashima <kuniyu@amazon.com>
> Date:   Tue, 27 Sep 2022 09:48:24 -0700
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
>
> Are you mentioning this commit ?
>

No, this is a new syzbot report, with a different stack trace.

> 086d49058cd8 ("ipv6: annotate some data-races around sk->sk_prot")
>
> Then, yes, I'll add syzbot tags to patch 4 and 5.
>
>
> >
> > No, I haven't.
> > Could you provide the URL?
> > I'm happy to include the syzbot tag and KCSAN report in the changelog.
> >
> >
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
> > > >
