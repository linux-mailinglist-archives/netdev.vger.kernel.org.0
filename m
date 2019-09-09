Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17D2ADB9F
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 17:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732364AbfIIPCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 11:02:00 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:38266 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfIIPB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 11:01:59 -0400
Received: by mail-yw1-f66.google.com with SMTP id f187so4885199ywa.5
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 08:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rUE9XfPQzVOkU8A+tW+bDNv+qPs+FQWcVStFD975yvI=;
        b=kRZbfU+rV9xW2LykirPsmolWRrRRKz667vfMqIhKakBadeq0op5Swg1icESwt1yII4
         QHYSZqWrRH6yq0yPCKWzjFuZ6j6BWvr7zzvv1IYAQkOEKlOKiI35dZipedDXhcQeZ+DC
         dlK9oeypqXAksmGoo9YRON/4yEoRztbbARkL6yX3ng+t/4PNUQlKoSThHWF8Gdie4QSA
         2WqrJXGC62QDwNsCZnzBI8OmpIweklBsQm49R+ouCn+6Elm4MMUjhiEty0SDgickT1Vb
         YjfFykVuh/m7EMUqhDEj+NZ6z38l7Pc0AQYJkt0vl3Q0crb1zeGAm+wj9k50AXJzFIpP
         Y4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rUE9XfPQzVOkU8A+tW+bDNv+qPs+FQWcVStFD975yvI=;
        b=D+Q4nws2YAI1pZzmK18IKxqFDQOPRw7VSMfLYlG9X7I/xyeIWK2FQXtJqzjghO+2zz
         KQCiApNBdNY03s5dSMaiXYe3xuFILRbUfduYnAp1Y7WboazeLBuNc9JBAXjGwQADsWm1
         fE/kczzm5YMZs+S0kxJxnI5JkpeQe8jq6JDu7qmHmK8ADRBivM4NJmTLdiWyXKcFrkXD
         yEhqRnlRPA/EkNq5mGtoaRNaq/GVgwy9J7GkuXRLjomDl7ALZWevf5R4jPZEJJXd6CQr
         8GPE7ZD8+EkY58TavB0MITp838gmBGQ4XDLJ0tqazKRyi7jfeU52elhzyHDCN3Y26B4I
         HEWw==
X-Gm-Message-State: APjAAAUoEWeTFsXYwwk8/rQWy4JVTh5Y/U16utQHoYM9UALmSnSkTgAE
        EzHAGa2lLnc6roY1X3z9Tc/PoBB/QiArvorbm/m1xg==
X-Google-Smtp-Source: APXvYqwI/6onPZfQYtbeyVioyGWN5PxhSsG09TFQ/8M31BmYpXIR9U6m4vV6dkvnv9JQBlWBFzuQAAtGCRA1Wm7ooMk=
X-Received: by 2002:a0d:db56:: with SMTP id d83mr16207277ywe.135.1568041318271;
 Mon, 09 Sep 2019 08:01:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190909142844.347495-1-tph@fb.com>
In-Reply-To: <20190909142844.347495-1-tph@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Sep 2019 17:01:46 +0200
Message-ID: <CANn89iJ5wANqhpR28y5AYf6GTBgzTau+u0N0ogG690C71LbxaA@mail.gmail.com>
Subject: Re: [PATCH] tcp: Add TCP_INFO counter for packets received out-of-order
To:     Thomas Higdon <tph@fb.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 9, 2019 at 4:30 PM Thomas Higdon <tph@fb.com> wrote:
>
> For receive-heavy cases on the server-side, we want to track the
> connection quality for individual client IPs. This counter, similar to
> the existing system-wide TCPOFOQueue counter in /proc/net/netstat,
> tracks out-of-order packet reception. By providing this counter in
> TCP_INFO, it will allow understanding to what degree receive-heavy
> sockets are experiencing out-of-order delivery and packet drops
> indicating congestion.
>
> Please note that this is similar to the counter in NetBSD TCP_INFO, and
> has the same name.
>
> Signed-off-by: Thomas Higdon <tph@fb.com>
> ---
>  include/linux/tcp.h      | 2 ++
>  include/uapi/linux/tcp.h | 2 ++
>  net/ipv4/tcp.c           | 1 +
>  net/ipv4/tcp_input.c     | 1 +
>  4 files changed, 6 insertions(+)
>
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index f3a85a7fb4b1..a01dc78218f1 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -393,6 +393,8 @@ struct tcp_sock {
>          */
>         struct request_sock *fastopen_rsk;
>         u32     *saved_syn;
> +
> +       u32 rcv_ooopack; /* Received out-of-order packets, for tcpinfo */
>  };
>
>  enum tsq_enum {
> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> index b3564f85a762..20237987ccc8 100644
> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -270,6 +270,8 @@ struct tcp_info {
>         __u64   tcpi_bytes_retrans;  /* RFC4898 tcpEStatsPerfOctetsRetrans */
>         __u32   tcpi_dsack_dups;     /* RFC4898 tcpEStatsStackDSACKDups */
>         __u32   tcpi_reord_seen;     /* reordering events seen */
> +
> +       __u32   tcpi_rcv_ooopack;    /* Out-of-order packets received */

This is problematic : you create a 32bit hole in this structure that
we will never be able to fill.

We need to add another metric here so that the whole 64bit space is used.

>  };
>
>  /* netlink attributes types for SCM_TIMESTAMPING_OPT_STATS */
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 94df48bcecc2..d4386f054f18 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3295,6 +3295,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
>         info->tcpi_bytes_retrans = tp->bytes_retrans;
>         info->tcpi_dsack_dups = tp->dsack_dups;
>         info->tcpi_reord_seen = tp->reord_seen;
> +       info->tcpi_rcv_ooopack = tp->rcv_ooopack;
>         unlock_sock_fast(sk, slow);
>  }
>  EXPORT_SYMBOL_GPL(tcp_get_info);
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 706cbb3b2986..2774680c5d05 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -4555,6 +4555,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
>         tp->pred_flags = 0;
>         inet_csk_schedule_ack(sk);
>
> +       tp->rcv_ooopack++;

We count skbs or we count segments ?

(GRO might have aggregated multiple segments)


>         NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFOQUEUE);
>         seq = TCP_SKB_CB(skb)->seq;
>         end_seq = TCP_SKB_CB(skb)->end_seq;


You forgot to clear the field in tcp_disconnect()
