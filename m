Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75CFCE2609
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 00:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407763AbfJWWAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 18:00:30 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:46348 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405035AbfJWWAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 18:00:30 -0400
Received: by mail-ua1-f66.google.com with SMTP id m21so6512096ual.13
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 15:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dI0sWxsLmVczS0Zl3fB+Fk38PLerU4izXXPB6cJSa5A=;
        b=ioh6xhzN+a3+CASwk3N1YxqSkLK2GtccwFu8wOysMt+GiuN7HqrMwoFY/S/i79qz7N
         5FgrfL4fnYIbhwPUpv13bezr+ScSan+Xq3ypVcLReQNvbKaMA9VirGA4DtVemEzFHq+W
         6Nv1ZNYwEaEiuxqEHovQqdKUPJwprXXjdbcrbh6grSaHNBzB7PwKPCwvftx1iIqgz7lW
         3LPAPZaaE3PYCuUNzFvY3qpBq+a2ooldq/1lvxrZu97qKYuS/0uigKKgiGnV40wcfhZ2
         HZ3p3sW37w7ob+eUwmM6ZBDsu+CNYDQk3Uyz0DA0phcPvkYCSdZAF+zYn8/avYsOm+6w
         Sa4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dI0sWxsLmVczS0Zl3fB+Fk38PLerU4izXXPB6cJSa5A=;
        b=Ya559weySE9LOxV/Fb81qmYhzUymTbM1rU/mXpdDY/S6PZ6+AmOGvntwWtIXOIssyP
         rxcACT8Bo5EJDAxWm21V+WPFuVEMXGvgyq4ijw7BHKn4ix5AXN5eVns83GqFy81Wuw33
         xi3LVTCom3ioYIxYjREqbr64IG5vAMUSpYX8ajuJEgz9oqAIqfwCP6NuCpSdH+gklWvj
         ZlinicQ7tSu0I7zN3zDBPKsOHw+mJG+r1CkoNnqhGFtG7CLWL3eFinnA4AhRkyF/k7d3
         BHuoIWdB7Pss2abHE4EiBbD64l0PxThK2VjU3BtQB+E7SXWKxAjr3pRcxwt9D08whsVC
         LBbA==
X-Gm-Message-State: APjAAAXcDw6cc47gDkKxbxO2fmSJfpqgPSmyMVdDfi8OQ+JcEMlbfkVU
        QdrcQc3bEc4Dyob2Ywo/TbT2MhVkjCMNbn0Is8toXQ==
X-Google-Smtp-Source: APXvYqxHczA6BiVplwzud3s2wA04aZMolrqsOBUXDndeV87rWFRn5YMM4GRVW13a5YbULBKherJXiSP0VmUbp49PEbY=
X-Received: by 2002:ab0:1553:: with SMTP id p19mr6938045uae.80.1571868026964;
 Wed, 23 Oct 2019 15:00:26 -0700 (PDT)
MIME-Version: 1.0
References: <2166c3ff-e08d-e89d-4753-01c8bd2d9505@akamai.com> <1571843366-14691-1-git-send-email-jbaron@akamai.com>
In-Reply-To: <1571843366-14691-1-git-send-email-jbaron@akamai.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Wed, 23 Oct 2019 14:59:50 -0700
Message-ID: <CAK6E8=deFWCyfvQNkTYBhTbbQy9aqryXPTCSsUpsu9gG6+pzrg@mail.gmail.com>
Subject: Re: [net-next v2] tcp: add TCP_INFO status for failed client TFO
To:     Jason Baron <jbaron@akamai.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Christoph Paasch <cpaasch@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 8:11 AM Jason Baron <jbaron@akamai.com> wrote:
>
> The TCPI_OPT_SYN_DATA bit as part of tcpi_options currently reports whether
> or not data-in-SYN was ack'd on both the client and server side. We'd like
> to gather more information on the client-side in the failure case in order
> to indicate the reason for the failure. This can be useful for not only
> debugging TFO, but also for creating TFO socket policies. For example, if
> a middle box removes the TFO option or drops a data-in-SYN, we can
> can detect this case, and turn off TFO for these connections saving the
> extra retransmits.
>
> The newly added tcpi_fastopen_client_fail status is 2 bits and has the
> following 4 states:
>
> 1) TFO_STATUS_UNSPEC
>
> Catch-all state which includes when TFO is disabled via black hole
> detection, which is indicated via LINUX_MIB_TCPFASTOPENBLACKHOLE.
>
> 2) TFO_COOKIE_UNAVAILABLE
>
> If TFO_CLIENT_NO_COOKIE mode is off, this state indicates that no cookie
> is available in the cache.
>
> 3) TFO_DATA_NOT_ACKED
>
> Data was sent with SYN, we received a SYN/ACK but it did not cover the data
> portion. Cookie is not accepted by server because the cookie may be invalid
> or the server may be overloaded.
>
> 4) TFO_SYN_RETRANSMITTED
>
> Data was sent with SYN, we received a SYN/ACK which did not cover the data
> after at least 1 additional SYN was sent (without data). It may be the case
> that a middle-box is dropping data-in-SYN packets. Thus, it would be more
> efficient to not use TFO on this connection to avoid extra retransmits
> during connection establishment.
>
> These new fields do not cover all the cases where TFO may fail, but other
> failures, such as SYN/ACK + data being dropped, will result in the
> connection not becoming established. And a connection blackhole after
> session establishment shows up as a stalled connection.
>
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> Cc: Christoph Paasch <cpaasch@apple.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> ---
Acked-by: Yuchung Cheng <ycheng@google.com>

Thanks

> v2:
>   -use tp->total_retrans instead of syn_drop for the non-tfo case
>   -improve state naming (Neal Cardwell)
>   -s/TFO_NO_COOKIE_SENT/TFO_COOKIE_UNAVAILABLE - exclude black-hole
>    from this state
>
>  net/ipv4/tcp_fastopen.c  |  5 ++++-
>  net/ipv4/tcp_input.c     |  4 ++++
>  5 files changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index 99617e5..7790f28 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -223,7 +223,7 @@ struct tcp_sock {
>                 fastopen_connect:1, /* FASTOPEN_CONNECT sockopt */
>                 fastopen_no_cookie:1, /* Allow send/recv SYN+data without a cookie */
>                 is_sack_reneg:1,    /* in recovery from loss with SACK reneg? */
> -               unused:2;
> +               fastopen_client_fail:2; /* reason why fastopen failed */
>         u8      nonagle     : 4,/* Disable Nagle algorithm?             */
>                 thin_lto    : 1,/* Use linear timeouts for thin streams */
>                 recvmsg_inq : 1,/* Indicate # of bytes in queue upon recvmsg */
> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> index 81e6979..74af1f7 100644
> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -155,6 +155,14 @@ enum {
>         TCP_QUEUES_NR,
>  };
>
> +/* why fastopen failed from client perspective */
> +enum tcp_fastopen_client_fail {
> +       TFO_STATUS_UNSPEC, /* catch-all */
> +       TFO_COOKIE_UNAVAILABLE, /* if not in TFO_CLIENT_NO_COOKIE mode */
> +       TFO_DATA_NOT_ACKED, /* SYN-ACK did not ack SYN data */
> +       TFO_SYN_RETRANSMITTED, /* SYN-ACK did not ack SYN data after timeout */
> +};
> +
>  /* for TCP_INFO socket option */
>  #define TCPI_OPT_TIMESTAMPS    1
>  #define TCPI_OPT_SACK          2
> @@ -211,7 +219,7 @@ struct tcp_info {
>         __u8    tcpi_backoff;
>         __u8    tcpi_options;
>         __u8    tcpi_snd_wscale : 4, tcpi_rcv_wscale : 4;
> -       __u8    tcpi_delivery_rate_app_limited:1;
> +       __u8    tcpi_delivery_rate_app_limited:1, tcpi_fastopen_client_fail:2;
>
>         __u32   tcpi_rto;
>         __u32   tcpi_ato;
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 9f41a76..bb5fc97 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2657,6 +2657,7 @@ int tcp_disconnect(struct sock *sk, int flags)
>         /* Clean up fastopen related fields */
>         tcp_free_fastopen_req(tp);
>         inet->defer_connect = 0;
> +       tp->fastopen_client_fail = 0;
>
>         WARN_ON(inet->inet_num && !icsk->icsk_bind_hash);
>
> @@ -3296,6 +3297,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
>         info->tcpi_reord_seen = tp->reord_seen;
>         info->tcpi_rcv_ooopack = tp->rcv_ooopack;
>         info->tcpi_snd_wnd = tp->snd_wnd;
> +       info->tcpi_fastopen_client_fail = tp->fastopen_client_fail;
>         unlock_sock_fast(sk, slow);
>  }
>  EXPORT_SYMBOL_GPL(tcp_get_info);
> diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
> index 3fd4512..dabd2f1 100644
> --- a/net/ipv4/tcp_fastopen.c
> +++ b/net/ipv4/tcp_fastopen.c
> @@ -422,7 +422,10 @@ bool tcp_fastopen_cookie_check(struct sock *sk, u16 *mss,
>                 cookie->len = -1;
>                 return true;
>         }
> -       return cookie->len > 0;
> +       if (cookie->len > 0)
> +               return true;
> +       tcp_sk(sk)->fastopen_client_fail = TFO_COOKIE_UNAVAILABLE;
> +       return false;
>  }
>
>  /* This function checks if we want to defer sending SYN until the first
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 3578357a..d562774 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5812,6 +5812,10 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk, struct sk_buff *synack,
>         tcp_fastopen_cache_set(sk, mss, cookie, syn_drop, try_exp);
>
>         if (data) { /* Retransmit unacked data in SYN */
> +               if (tp->total_retrans)
> +                       tp->fastopen_client_fail = TFO_SYN_RETRANSMITTED;
> +               else
> +                       tp->fastopen_client_fail = TFO_DATA_NOT_ACKED;
>                 skb_rbtree_walk_from(data) {
>                         if (__tcp_retransmit_skb(sk, data, 1))
>                                 break;
> --
> 2.7.4
>
