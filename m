Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7E91CFCE1
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 20:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbgELSLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 14:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgELSLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 14:11:20 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD7CC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 11:11:17 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h17so7914117wrc.8
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 11:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y1p3wnnnuxJXfJQ+B4sfVhuDGGWfTfIlHQw5q6MgLlc=;
        b=VzbJlcFfci4sddG1ShZxo8ZVBNcy7Pnd6eKVQK+XrirN6RJi2pa/WCb8VNXvZNETXl
         xTcMl/TEuvh39h/IUlwzDCMzMXWB6bk9SZdNqSuwbiQkTgcp/a+S6jCqH1TfVtGcXUVv
         RhN3JEj2azc9gQOuwHGug2X5VoItguQZ/cXzD9ELa0RlMyTaSfnRc/OpnOTItZ9+656+
         uIoKNSoikhFY0BvedKxgd95Mnm7i3jrTuublO4ByphepgULMeneqldmIk7k0qyQ9W+UW
         1z8pqKuPIZXqNqHIw7JYJ2ljoy4i9WySHnvAa7ksBMXiUBVSo9pi6bv8Fae8NSiN+8Nh
         NIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y1p3wnnnuxJXfJQ+B4sfVhuDGGWfTfIlHQw5q6MgLlc=;
        b=kdDnXFgErdewHwfj3xlJghl+g87el1B9Cq9NDcrLJ4hxUZBhJ+gaOg866PKNM3wIIL
         rhbgzBPE8N+ldc9OlIApWxO4yax22QrZRQ5+Rmndw7moZeJd6iKsfOumD0VrOV5hOj7E
         DOVDI1uCu17reP5ShPXSntqDO+YRiTWom1m7PILfKvNck+er2mG9RP+WqWAUlrN1GEPI
         LlHnmDMTfSwOxm0y2lcA8e9H57s37rsfq/gI6RpszFMeOLioPJQRuLr7WbrdgoEicUeK
         HsUtqDBqrpk3oAk7jb9udlpotHdJdgKk5bYDHqQ//eYRglF3cEEoVhoQuN6BtDsBhC1+
         H1HQ==
X-Gm-Message-State: AGi0Pua5j6uuZSwtBDWCSdqc9w7reT7eiDaMLK++jVkKRxOpV4ecu1fo
        vAj29c2/9Eow3r9jNPajSISlrKDalqiu+xc873iFVg==
X-Google-Smtp-Source: APiQypKUYyFTB9etLpp295qqTCgk0Mb/2uAajLcta5mqSJfsdUmmk7pdHxVnLDdCccjJeYCf96CkUbQAMUuH//RRqBE=
X-Received: by 2002:adf:dc0f:: with SMTP id t15mr25892197wri.165.1589307075796;
 Tue, 12 May 2020 11:11:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200512135430.201113-1-edumazet@google.com>
In-Reply-To: <20200512135430.201113-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 12 May 2020 14:10:39 -0400
Message-ID: <CACSApva2zZqH6Eq4nD_jPGSM8wZ21OgaMS2OFvCr8cHO=rp-fA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix SO_RCVLOWAT hangs with fat skbs
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 9:54 AM Eric Dumazet <edumazet@google.com> wrote:
>
> We autotune rcvbuf whenever SO_RCVLOWAT is set to account for 100%
> overhead in tcp_set_rcvlowat()
>
> This works well when skb->len/skb->truesize ratio is bigger than 0.5
>
> But if we receive packets with small MSS, we can end up in a situation
> where not enough bytes are available in the receive queue to satisfy
> RCVLOWAT setting.
> As our sk_rcvbuf limit is hit, we send zero windows in ACK packets,
> preventing remote peer from sending more data.
>
> Even autotuning does not help, because it only triggers at the time
> user process drains the queue. If no EPOLLIN is generated, this
> can not happen.
>
> Note poll() has a similar issue, after commit
> c7004482e8dc ("tcp: Respect SO_RCVLOWAT in tcp_poll().")
>
> Fixes: 03f45c883c6f ("tcp: avoid extra wakeups for SO_RCVLOWAT users")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Nice find! Thank you for the fix!

> ---
>  include/net/tcp.h    | 13 +++++++++++++
>  net/ipv4/tcp.c       | 14 +++++++++++---
>  net/ipv4/tcp_input.c |  3 ++-
>  3 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 64f84683feaede11fa0789baad277e2b4655ec7a..6f8e60c6fbc746ea7ed2c2ddc97bffdbb7da4fc1 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1420,6 +1420,19 @@ static inline int tcp_full_space(const struct sock *sk)
>         return tcp_win_from_space(sk, READ_ONCE(sk->sk_rcvbuf));
>  }
>
> +/* We provision sk_rcvbuf around 200% of sk_rcvlowat.
> + * If 87.5 % (7/8) of the space has been consumed, we want to override
> + * SO_RCVLOWAT constraint, since we are receiving skbs with too small
> + * len/truesize ratio.
> + */
> +static inline bool tcp_rmem_pressure(const struct sock *sk)
> +{
> +       int rcvbuf = READ_ONCE(sk->sk_rcvbuf);
> +       int threshold = rcvbuf - (rcvbuf >> 3);
> +
> +       return atomic_read(&sk->sk_rmem_alloc) > threshold;
> +}
> +
>  extern void tcp_openreq_init_rwin(struct request_sock *req,
>                                   const struct sock *sk_listener,
>                                   const struct dst_entry *dst);
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e72bd651d21acff036b856c1050bd86c31c468a0..a385fcaaa03beed9bfeabdebc12371e34e0649de 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -476,9 +476,17 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
>  static inline bool tcp_stream_is_readable(const struct tcp_sock *tp,
>                                           int target, struct sock *sk)
>  {
> -       return (READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->copied_seq) >= target) ||
> -               (sk->sk_prot->stream_memory_read ?
> -               sk->sk_prot->stream_memory_read(sk) : false);
> +       int avail = READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->copied_seq);
> +
> +       if (avail > 0) {
> +               if (avail >= target)
> +                       return true;
> +               if (tcp_rmem_pressure(sk))
> +                       return true;
> +       }
> +       if (sk->sk_prot->stream_memory_read)
> +               return sk->sk_prot->stream_memory_read(sk);
> +       return false;
>  }
>
>  /*
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index b996dc1069c53ead2e1f3552716a6cd427942afd..29c6fc8c7716881ec37ad08fbd3497747b9350fe 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -4757,7 +4757,8 @@ void tcp_data_ready(struct sock *sk)
>         const struct tcp_sock *tp = tcp_sk(sk);
>         int avail = tp->rcv_nxt - tp->copied_seq;
>
> -       if (avail < sk->sk_rcvlowat && !sock_flag(sk, SOCK_DONE))
> +       if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
> +           !sock_flag(sk, SOCK_DONE))
>                 return;
>
>         sk->sk_data_ready(sk);
> --
> 2.26.2.645.ge9eca65c58-goog
>
