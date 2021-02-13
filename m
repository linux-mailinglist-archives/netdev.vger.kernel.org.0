Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CC231A8CD
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhBMAb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhBMAb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:31:26 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BADC061756
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:30:46 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id x19so1240785ybe.0
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IYJHUadxdcfyiyhZB/DfXUj2HmgRewPwBHaeQomePTs=;
        b=XeLKpshA4DQ9HxG/JkWg378YsbCSEne299DGxtiyoN1RoymRuaGL+x+hcftXSvU0o3
         Od61pQ5TIqLqIYCYo88567YPbbiBK0NgDe8FvcV9RpJ9nygow42f6hTRFd+u13nXc178
         SOcPDbP+CZjGgs7NZH+MAuvqAgWq4pBoC0WwgRikVv149HBIlHYHBT41yPtsR0S3CAtg
         cdqYqTKHUYz4KMrDY40BUCqOAhEl9FezuIRTNOefjm+vZebzkpgkZain116vBe/7oP0j
         YSvwQtIvoM2GK74RZIIiCS6koUgDwnRBI9kqN9zXFsqr8yzaE3eX8w2r5khjwuRnW8A/
         vTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IYJHUadxdcfyiyhZB/DfXUj2HmgRewPwBHaeQomePTs=;
        b=Opj3tDH+NrUWseInBYr8HphZyN6qYMZUXtgrXgH5yphDhFw0wmPtUXAPKvT0i/iF6P
         H88L00RkaCNFFZqc5ONx9xXp3gD5HjPW6DthAduVpVN0e9gr7GmPSyr3FQEXIPEzDm3O
         ruEybk+sx6Y2BX+QB+7hThJ9a75Gd+LPDDemFR0sLnQwcdFYni9+43MV25GElnQd7f4U
         2Hj9PVrSTkOh3KVvxhE0nYyb+LtRUA5VV+WY5nhDB2BHWvVDzpSxcAQ4kPimBzGGvVzG
         uszGClb+aRaT0bgBnMOx5VYt7JH/wFw5dtUqZGXLUv71Vj7g5RiyDPgFJlLvxK1tGyfn
         VwCQ==
X-Gm-Message-State: AOAM530OQy8AOgVTaVs5eXSdYYQlTJ5Hlql1phUlGC6OuomdApnaXl/u
        w9e7KfWQb5OZ0Q78TqwHLE5/d1gUMar9KDYJhp92xA==
X-Google-Smtp-Source: ABdhPJy2lOTWqpgU49wvYNXsJGYcVqPDEaVo82nSzZ7LqD4mG+Nx4QfLG9jqlz9UWFqIDq/16PWtLwlUIhJTssil9jw=
X-Received: by 2002:a25:4981:: with SMTP id w123mr7301730yba.123.1613176245292;
 Fri, 12 Feb 2021 16:30:45 -0800 (PST)
MIME-Version: 1.0
References: <20210212232214.2869897-1-eric.dumazet@gmail.com> <20210212232214.2869897-3-eric.dumazet@gmail.com>
In-Reply-To: <20210212232214.2869897-3-eric.dumazet@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 12 Feb 2021 16:30:33 -0800
Message-ID: <CAEA6p_A0g-7WMfyQbw55wdAKkFkEbW2A-XwTNziP9XyD3MjmCA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] tcp: factorize logic into tcp_epollin_ready()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 3:22 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Both tcp_data_ready() and tcp_stream_is_readable() share the same logic.
>
> Add tcp_epollin_ready() helper to avoid duplication.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Arjun Roy <arjunroy@google.com>
> Cc: Wei Wang <weiwan@google.com>
> ---
>  include/net/tcp.h    | 12 ++++++++++++
>  net/ipv4/tcp.c       | 16 ++++------------
>  net/ipv4/tcp_input.c | 11 ++---------
>  3 files changed, 18 insertions(+), 21 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 244208f6f6c2ace87920b633e469421f557427a6..484eb2362645fd478f59b26b42457ecf4510eb14 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1442,6 +1442,18 @@ static inline bool tcp_rmem_pressure(const struct sock *sk)
>         return atomic_read(&sk->sk_rmem_alloc) > threshold;
>  }
>
> +static inline bool tcp_epollin_ready(const struct sock *sk, int target)
> +{
> +       const struct tcp_sock *tp = tcp_sk(sk);
> +       int avail = READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->copied_seq);
> +
> +       if (avail <= 0)
> +               return false;
> +
> +       return (avail >= target) || tcp_rmem_pressure(sk) ||
> +              (tcp_receive_window(tp) <= inet_csk(sk)->icsk_ack.rcv_mss);
> +}
> +
>  extern void tcp_openreq_init_rwin(struct request_sock *req,
>                                   const struct sock *sk_listener,
>                                   const struct dst_entry *dst);
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 9896ca10bb340924b779cb6a7606d57fdd5c3357..7a6b58ae408d1fb1e5536ccfed8215be123f3b57 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -481,19 +481,11 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
>         }
>  }
>
> -static inline bool tcp_stream_is_readable(const struct tcp_sock *tp,
> -                                         int target, struct sock *sk)
> +static bool tcp_stream_is_readable(struct sock *sk, int target)
>  {
> -       int avail = READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->copied_seq);
> +       if (tcp_epollin_ready(sk, target))
> +               return true;
>
> -       if (avail > 0) {
> -               if (avail >= target)
> -                       return true;
> -               if (tcp_rmem_pressure(sk))
> -                       return true;
> -               if (tcp_receive_window(tp) <= inet_csk(sk)->icsk_ack.rcv_mss)
> -                       return true;
> -       }
>         if (sk->sk_prot->stream_memory_read)
>                 return sk->sk_prot->stream_memory_read(sk);
>         return false;
> @@ -568,7 +560,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
>                     tp->urg_data)
>                         target++;
>
> -               if (tcp_stream_is_readable(tp, target, sk))
> +               if (tcp_stream_is_readable(sk, target))
>                         mask |= EPOLLIN | EPOLLRDNORM;
>
>                 if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index a8f8f98159531e5d1c80660972148986f6acd20a..e32a7056cb7640c67ef2d6a4d9484684d2602fcd 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -4924,15 +4924,8 @@ int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
>
>  void tcp_data_ready(struct sock *sk)
>  {
> -       const struct tcp_sock *tp = tcp_sk(sk);
> -       int avail = tp->rcv_nxt - tp->copied_seq;
> -
> -       if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
> -           !sock_flag(sk, SOCK_DONE) &&

Seems "!sock_flag(sk, SOCK_DONE)" is not checked in
tcp_epollin_read(). Does it matter?

> -           tcp_receive_window(tp) > inet_csk(sk)->icsk_ack.rcv_mss)
> -               return;
> -
> -       sk->sk_data_ready(sk);
> +       if (tcp_epollin_ready(sk, sk->sk_rcvlowat))
> +               sk->sk_data_ready(sk);
>  }
>
>  static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
> --
> 2.30.0.478.g8a0d178c01-goog
>
