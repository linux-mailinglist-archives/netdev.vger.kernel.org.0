Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC545EC9B9
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiI0QkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiI0Qj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:39:59 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA3AA1D40
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:39:50 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id p69so12989052yba.0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=aPZZvdHCO6t0xXd5NWzf+aPYrxcxwpoMO7xp4G2f6CM=;
        b=Fm2R1f+DVTKK5+KDJEY1qNDIfCzOZr6lo0Ra5izK/D+RDI3YkTsRuk3FJtne0aVueE
         4hvLfw+Sal3eU2FGQUUDJwVLxV9L3RhkFKJM8xV/qsB27CyM0KEBNw/YhqhZPD2MiMv+
         RrL9wxP06XX1dSZo4Knr2fy/99Knive+7NHLgiNkHp72WCz041u3UH7lr3blo3sWGftZ
         apeJdn2YozDAJNnYNHKsZGvTzAwsK/WsfkmQ64NkWTj78mRGhRu/anJeJvzfyHUnx7Jk
         /bwtVqru6qq0M/3VTDIQ9hYOuTlRozxe/gg/y4kFch86XBcKJrDsBlY5bfKnV4sJV39w
         kQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=aPZZvdHCO6t0xXd5NWzf+aPYrxcxwpoMO7xp4G2f6CM=;
        b=vXetDrnhqJF240gmarqT9v3Gze5Cl5C+0Uepkv/5RSow4wGs70tAsOhrMJeENbjtMf
         SBX/t19mM67P30R8LJpVjiHDq8yKsGRMR8aTj0ijRfTzmUD4sFcSyKdhzN265GnyrCqk
         U5mBej54hiA1yvdNc2n+P18ZqHerD42GHK3hLTEDu6oX23rgGZPPgNX6rXuF8sOIzPhl
         QDY9Y01IVbNWx2vb3p93sWh9r/pRg/8MJtk+WQxLC76L7ihwnbz43rRtNwzs2+EIV4TD
         ni9P/3lrPm3qFHXUpzPEcWlAI52oPbMiTbg5ZxMADEzt10oTtzucgOIzAP/3j0/9M6r1
         y9EA==
X-Gm-Message-State: ACrzQf3pT+l8r6+DtRWxHfPh0RpplZIQfdXoyPJNe0djWtcyaWJQbiwE
        F659aeOsYZ0JyU9oUXSk2VyEPhVMpOLbg4PiaghCMg==
X-Google-Smtp-Source: AMsMyM4b5jCPcM/U97nQN01GQGG5Cvho4qWsJKZu1mjax1ydsXoHMCJNbrN97s95ZrRygX5/CQNXYgF1v5P/1ClBVxg=
X-Received: by 2002:a25:b48:0:b0:6bc:22f3:a594 with SMTP id
 69-20020a250b48000000b006bc22f3a594mr3007309ybl.55.1664296789843; Tue, 27 Sep
 2022 09:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220927161209.32939-1-kuniyu@amazon.com> <20220927161209.32939-6-kuniyu@amazon.com>
In-Reply-To: <20220927161209.32939-6-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 09:39:37 -0700
Message-ID: <CANn89iLyqG8SRmHhWZOZUc-HDR88z_TNZn4_zbJz5MW4+kh2ZQ@mail.gmail.com>
Subject: Re: [PATCH v1 net 5/5] tcp: Fix data races around icsk->icsk_af_ops.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>
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

On Tue, Sep 27, 2022 at 9:33 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> IPV6_ADDRFORM changes icsk->icsk_af_ops under lock_sock(), but
> tcp_(get|set)sockopt() read it locklessly.  To avoid load/store
> tearing, we need to add READ_ONCE() and WRITE_ONCE() for the reads
> and write.

I am pretty sure I have released a syzkaller bug recently with this issue.
Have you seen this?
If yes, please include the appropriate syzbot tag.


>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/ipv4/tcp.c           | 10 ++++++----
>  net/ipv6/ipv6_sockglue.c |  3 ++-
>  2 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e373dde1f46f..c86dd0ccef5b 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3795,8 +3795,9 @@ int tcp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
>         const struct inet_connection_sock *icsk = inet_csk(sk);
>
>         if (level != SOL_TCP)
> -               return icsk->icsk_af_ops->setsockopt(sk, level, optname,
> -                                                    optval, optlen);
> +               /* IPV6_ADDRFORM can change icsk->icsk_af_ops under us. */
> +               return READ_ONCE(icsk->icsk_af_ops)->setsockopt(sk, level, optname,
> +                                                               optval, optlen);
>         return do_tcp_setsockopt(sk, level, optname, optval, optlen);
>  }
>  EXPORT_SYMBOL(tcp_setsockopt);
> @@ -4394,8 +4395,9 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
>         struct inet_connection_sock *icsk = inet_csk(sk);
>
>         if (level != SOL_TCP)
> -               return icsk->icsk_af_ops->getsockopt(sk, level, optname,
> -                                                    optval, optlen);
> +               /* IPV6_ADDRFORM can change icsk->icsk_af_ops under us. */
> +               return READ_ONCE(icsk->icsk_af_ops)->getsockopt(sk, level, optname,
> +                                                               optval, optlen);
>         return do_tcp_getsockopt(sk, level, optname, optval, optlen);
>  }
>  EXPORT_SYMBOL(tcp_getsockopt);
> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index a89db5872dc3..726d95859898 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -479,7 +479,8 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>
>                                 /* Paired with READ_ONCE(sk->sk_prot) in inet6_stream_ops */
>                                 WRITE_ONCE(sk->sk_prot, &tcp_prot);
> -                               icsk->icsk_af_ops = &ipv4_specific;
> +                               /* Paired with READ_ONCE() in tcp_(get|set)sockopt() */
> +                               WRITE_ONCE(icsk->icsk_af_ops, &ipv4_specific);
>                                 sk->sk_socket->ops = &inet_stream_ops;
>                                 sk->sk_family = PF_INET;
>                                 tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
> --
> 2.30.2
>
