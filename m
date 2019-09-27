Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9982DC0115
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfI0IZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:25:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51967 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfI0IZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:25:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id 7so5574121wme.1
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 01:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mJD2haK773Q632B84P/qTidj1uDEnaYyTvkOnKcl2MU=;
        b=HV/lZky5vwmd9AmeV/jtds+SF6mM/oxgQoceIjp0FqGyVfR+6OMU7/K1LNC9/AfZkv
         WiNZCabSAefqzsDIVO9vnh8WX0nAxWn4bwyrxbLDe7Er4J0bdXNw9M6akGpIix9mTRGt
         tz8h9Qpj2bcN0evSHjgjkU4hT790li1933mNHJ7dChuVNUd93Mja7EnrQh5/Y0cGtbIG
         DgM4lNkChz+m+V0sQ0goefZcvkOG+7fRJF+7BQiWoFjlzyZv4KA2V6cT5vlcMfyo7JBA
         1RYSiKv3lr2qbr7K3CZF7UBK/zfH48SGno9AQ7lcdXUCuzvhAKP/7UetC/KovBMsO6xz
         LifQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mJD2haK773Q632B84P/qTidj1uDEnaYyTvkOnKcl2MU=;
        b=B6XHzffJBuK8xg5h6knCccV0S61Py7YSoyF4U1ze8H7hig+k4QU97eSAvjgeAk3OkD
         Ys3mTZ0L7cC+6cXUdX3l4z3C21HVFmW9BXSqC398/qUEOm7YRaS+WaZKNO+P+6OeUS2E
         Y1TQcQ3/1U1UG/BAhQ+v1gVf4ThURqAv5WA4YLpDv8Yj3KuXXYDATLKkA70S5tlkp0uY
         XIopfuZBo7Yg7RGG9rQVhZz6hFPvkVb95FH2RjnDwwdI2LB97OotrDQFDRbuLxk5cSgi
         iv9R4SbqlT8glCoqNrn+jMKrEfQj1aYO6bX5pR0jGZSxRWATlXPKOrHIf8Kn9h2293pq
         HjGw==
X-Gm-Message-State: APjAAAWMDNtWDt18k4IDMgdUIv5cRsIgcpXJcYBuWqMp11yQOXq71Utf
        rz74zKo5m2y4ZiCjpNKALDMO6IQQYv4BiilhkeU=
X-Google-Smtp-Source: APXvYqy7fpQoQBkUOBDauQD0dzUVcmZkw2ZTXUHjaq8GiQOIoCdUR/CWHhIdapCEXdcSPAooCInwLkwu2GwPzeBBmtg=
X-Received: by 2002:a7b:c252:: with SMTP id b18mr6023771wmj.68.1569572753090;
 Fri, 27 Sep 2019 01:25:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190926224251.249797-1-edumazet@google.com>
In-Reply-To: <20190926224251.249797-1-edumazet@google.com>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Fri, 27 Sep 2019 18:25:19 +1000
Message-ID: <CAGHK07B9E0AOBNtqVqKyJQOdU7ijdVi-7jLwnH+=S7ZgG5kpeA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Jon Maxwell <jmaxwell37@gmail.com>

Thanks for fixing that Eric.


On Fri, Sep 27, 2019 at 8:42 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Yuchung Cheng and Marek Majkowski independently reported a weird
> behavior of TCP_USER_TIMEOUT option when used at connect() time.
>
> When the TCP_USER_TIMEOUT is reached, tcp_write_timeout()
> believes the flow should live, and the following condition
> in tcp_clamp_rto_to_user_timeout() programs one jiffie timers :
>
>     remaining = icsk->icsk_user_timeout - elapsed;
>     if (remaining <= 0)
>         return 1; /* user timeout has passed; fire ASAP */
>
> This silly situation ends when the max syn rtx count is reached.
>
> This patch makes sure we honor both TCP_SYNCNT and TCP_USER_TIMEOUT,
> avoiding these spurious SYN packets.
>
> Fixes: b701a99e431d ("tcp: Add tcp_clamp_rto_to_user_timeout() helper to improve accuracy")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Yuchung Cheng <ycheng@google.com>
> Reported-by: Marek Majkowski <marek@cloudflare.com>
> Cc: Jon Maxwell <jmaxwell37@gmail.com>
> Link: https://marc.info/?l=linux-netdev&m=156940118307949&w=2
> ---
>  net/ipv4/tcp_timer.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index dbd9d2d0ee63aa46ad2dda417da6ec9409442b77..40de2d2364a1eca14c259d77ebed361d17829eb9 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -210,7 +210,7 @@ static int tcp_write_timeout(struct sock *sk)
>         struct inet_connection_sock *icsk = inet_csk(sk);
>         struct tcp_sock *tp = tcp_sk(sk);
>         struct net *net = sock_net(sk);
> -       bool expired, do_reset;
> +       bool expired = false, do_reset;
>         int retry_until;
>
>         if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
> @@ -242,9 +242,10 @@ static int tcp_write_timeout(struct sock *sk)
>                         if (tcp_out_of_resources(sk, do_reset))
>                                 return 1;
>                 }
> +       }
> +       if (!expired)
>                 expired = retransmits_timed_out(sk, retry_until,
>                                                 icsk->icsk_user_timeout);
> -       }
>         tcp_fastopen_active_detect_blackhole(sk, expired);
>
>         if (BPF_SOCK_OPS_TEST_FLAG(tp, BPF_SOCK_OPS_RTO_CB_FLAG))
> --
> 2.23.0.444.g18eeb5a265-goog
>
