Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3621A27EBB2
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbgI3PBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3PBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 11:01:33 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601EBC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 08:01:33 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id w2so2055171wmi.1
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 08:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EMPWcBb+VpyV5Bw48iW4AOYmW3+MDazn7tWXbQxJEHg=;
        b=iVZnF4mg0kqsS2U+GlaQwYAZEQlC06cfL8HSxxqyn2A/Kaxt1q5bWW0NE8X8ZN4Q9k
         5+gKtarFv/0wWthz91hjcMvxJ8pjwOuTLsgWulr8aPT3gixkLuzhs02eTULeojGJjDIs
         ZlxvpsY1fKaz6f2LfghqU8eduA+HYVW66zwNIkDtA0HzghON5RmT8sUH87ZrRqQA3hdu
         2oVtcHcV8sdWxnJwFnJkhUMRkUwVq5gaH2fo+HcIoPwWRUJLIeJVk2iWFlR2yoYEPVvs
         ACQFid730kPEwB0SIhvYwSTI8A7tdhbeCMKRfGrVhscD+Rt+NBHxPmKBAjT2CvcTgl6Y
         KRFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EMPWcBb+VpyV5Bw48iW4AOYmW3+MDazn7tWXbQxJEHg=;
        b=INWcgf8+lChrGV8Hw/ihszRcsekTevwWU6BDlGaf9qK9SOAt1u2tru4J0L3nJAwLQ1
         v/TnJrOHeQnzrdDhYkCFL3LstOIAgOqUDQI/t3592qzcCW+r06Wjs+jroGDKywKTjnVk
         m1bV5r8wur/jFftUPBKuJ3rZKEQYRaOn8QjWU7o38dwY3fJafEoQqgEDZrNSnJ0GtA8U
         2tLyzUrvbwQGl+bO46u8AejEWYeExPEojnO+d06+krRwGXLy/FEdvoEOgq+QEooVH4Ry
         4Z6X8+8vk/pXCLghv44tLwGQzC7+qRYZZ7LCJ3l0VnUm6nUMZZ6+VOSq/ZXkj1/NqotY
         XeaA==
X-Gm-Message-State: AOAM533W3uVssmlI3gQjqd5clohL1DW4F8fGlwtQHKNIq8Y/56eDaZWI
        rq2VSN+KReMyJioTqAsQ355Qt1a7h00yC72l+nHnCAzfQBE=
X-Google-Smtp-Source: ABdhPJz95lIDsmDaZipchllNfVt1Hv5WCg1nSE3tYWPPieRSl/p6tgBd2Yg5GHeOI/BqN7Pzvw2OQfg4zleii5vER/g=
X-Received: by 2002:a7b:cd0f:: with SMTP id f15mr3459504wmj.3.1601478091720;
 Wed, 30 Sep 2020 08:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200930125457.1579469-1-eric.dumazet@gmail.com> <20200930125457.1579469-3-eric.dumazet@gmail.com>
In-Reply-To: <20200930125457.1579469-3-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Wed, 30 Sep 2020 11:00:55 -0400
Message-ID: <CACSApvbdSonMNLzSmtnKS2JyFSdwzi-dcDXJb9bLxoJd13KxcQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] tcp: add exponential backoff in __tcp_send_ack()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 8:55 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Whenever host is under very high memory pressure,
> __tcp_send_ack() skb allocation fails, and we setup
> a 200 ms (TCP_DELACK_MAX) timer before retrying.
>
> On hosts with high number of TCP sockets, we can spend
> considerable amount of cpu cycles in these attempts,
> add high pressure on various spinlocks in mm-layer,
> ultimately blocking threads attempting to free space
> from making any progress.
>
> This patch adds standard exponential backoff to avoid
> adding fuel to the fire.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  include/net/inet_connection_sock.h |  3 ++-
>  net/ipv4/tcp_output.c              | 11 ++++++++---
>  2 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index 79875f976190750819948425e63dd0309c699050..7338b3865a2a3d278dc27c0167bba1b966bbda9f 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -110,7 +110,7 @@ struct inet_connection_sock {
>                 __u8              pending;       /* ACK is pending                         */
>                 __u8              quick;         /* Scheduled number of quick acks         */
>                 __u8              pingpong;      /* The session is interactive             */
> -               /* one byte hole. */
> +               __u8              retry;         /* Number of attempts                     */
>                 __u32             ato;           /* Predicted tick of soft clock           */
>                 unsigned long     timeout;       /* Currently scheduled timeout            */
>                 __u32             lrcvtime;      /* timestamp of last received data packet */
> @@ -199,6 +199,7 @@ static inline void inet_csk_clear_xmit_timer(struct sock *sk, const int what)
>  #endif
>         } else if (what == ICSK_TIME_DACK) {
>                 icsk->icsk_ack.pending = 0;
> +               icsk->icsk_ack.retry = 0;
>  #ifdef INET_CSK_CLEAR_TIMERS
>                 sk_stop_timer(sk, &icsk->icsk_delack_timer);
>  #endif
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 6bd4e383030ea20441332a30e98fbda8cd90f84a..bf48cd73e96787a14b6f9af8beddb1067a7cb8dc 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3941,10 +3941,15 @@ void __tcp_send_ack(struct sock *sk, u32 rcv_nxt)
>         buff = alloc_skb(MAX_TCP_HEADER,
>                          sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN));
>         if (unlikely(!buff)) {
> +               struct inet_connection_sock *icsk = inet_csk(sk);
> +               unsigned long delay;
> +
> +               delay = TCP_DELACK_MAX << icsk->icsk_ack.retry;
> +               if (delay < TCP_RTO_MAX)
> +                       icsk->icsk_ack.retry++;
>                 inet_csk_schedule_ack(sk);
> -               inet_csk(sk)->icsk_ack.ato = TCP_ATO_MIN;
> -               inet_csk_reset_xmit_timer(sk, ICSK_TIME_DACK,
> -                                         TCP_DELACK_MAX, TCP_RTO_MAX);
> +               icsk->icsk_ack.ato = TCP_ATO_MIN;
> +               inet_csk_reset_xmit_timer(sk, ICSK_TIME_DACK, delay, TCP_RTO_MAX);
>                 return;
>         }
>
> --
> 2.28.0.806.g8561365e88-goog
>
