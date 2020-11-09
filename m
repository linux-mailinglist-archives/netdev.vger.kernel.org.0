Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F1D2AC19E
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 18:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbgKIQ75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730704AbgKIQ7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:59:55 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD40C0613D4
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 08:59:54 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id y17so8940264ilg.4
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 08:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V7qgkSHMMktCLOUjouaNoMEtnZbDIbhksuSKxKZr5R8=;
        b=c2Zmdx0nl+SL6niIVFThXeHouIfQORYH45B8pJqnnGHgsfAiyCFowTCJtag9usFx5j
         ycXo5MTPOakbdjScJ6GVdQ7tZ8rF0fBcKTzsJuL+sLMwrVbgCtKKVg/nau+pZA14SO4E
         +Hr/AWfquwzvBdx2k33Y6vVtr5xedd/DGqOxKebETjRdQpmrEhbY8rezxhjomK5gDNFz
         V0wMikoJiycKvlziTOCCIM/20OvGRwBcMHjQSkkKci8UZYjlxmNLwKeyJ6iWPEKHX8Xw
         Q3hfUd5jidrKkS/PC7cH2+b/fW0RIhFVL0v+q1eOT4qBs6U9eno5qQnN0cnN/Ssc5deX
         sV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V7qgkSHMMktCLOUjouaNoMEtnZbDIbhksuSKxKZr5R8=;
        b=ek1OHy6kO6QJ/lFT2IiGDvct0/ZrrTLS49LR+KEh8Ziec0CTCt/LBooilZnZvJAnVe
         8WhoORMmybp1OH1lLZkKcPdc9rgZ2tk78aJU4nwXWeZsYwYuov9N2zbBBxQ83syBZcjB
         zFo0duPvcfdRqxTzzVWR+kj9fk4A78sCyYCBzHN7p6VSwRMSlaoAASvpHX/sE6YkPHXR
         A4yATe8QOLCjYGKbHyPupZikzgCUHRK0IYoW+HlGvDLUjln0ciS/mD05zHh/wjwj7bxi
         azwIYt4ca9H6G/o87Yyyl/F12NiYvDwlUt/0EDp7dRZK3rocwa4zfRLmZw9GdDHaKl86
         H4gA==
X-Gm-Message-State: AOAM533/++u7T83uqvlCcsfVeYyJS61415HWNOKgkfw5/k+vYpBXmVrB
        DtgvkNAVfcmnqOOCt5kyk3hpy5OH03t1fhCc42dGlw==
X-Google-Smtp-Source: ABdhPJwPOgD9do3vA7redAiPDuCx+1baYbHULmtkvCS5x/RyY3i4TWfy1ELeR2AGRG8CvnkdSNncp/1a12CP0ko4+BI=
X-Received: by 2002:a05:6e02:14c9:: with SMTP id o9mr11372459ilk.137.1604941193450;
 Mon, 09 Nov 2020 08:59:53 -0800 (PST)
MIME-Version: 1.0
References: <CANn89iLhCjh7ZQRanVEj6Sytzn6LhFOb9Xo7O=teLHPouoeopw@mail.gmail.com>
 <1604940830-74688-1-git-send-email-wenan.mao@linux.alibaba.com>
In-Reply-To: <1604940830-74688-1-git-send-email-wenan.mao@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Nov 2020 17:59:42 +0100
Message-ID: <CANn89iLVWFgDvkUygK8Sh_H7=qFmuZKo1h=aoq+F57J28r4EUA@mail.gmail.com>
Subject: Re: [PATCH net v3] net: Update window_clamp if SOCK_RCVBUF is set
To:     Mao Wenan <wenan.mao@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 5:54 PM Mao Wenan <wenan.mao@linux.alibaba.com> wrote:
>
> When net.ipv4.tcp_syncookies=1 and syn flood is happened,
> cookie_v4_check or cookie_v6_check tries to redo what
> tcp_v4_send_synack or tcp_v6_send_synack did,
> rsk_window_clamp will be changed if SOCK_RCVBUF is set,
> which will make rcv_wscale is different, the client
> still operates with initial window scale and can overshot
> granted window, the client use the initial scale but local
> server use new scale to advertise window value, and session
> work abnormally.
>
> Fixes: e88c64f0a425 ("tcp: allow effective reduction of TCP's
> rcv-buffer via setsockopt")

Please put this tag in a single line (no line wrap)
And do not add an empty line after it.
The Fixes: tag is part of the official tags, all grouped together.
>
> Signed-off-by: Mao Wenan <wenan.mao@linux.alibaba.com>
> ---
>  v3: add local variable full_space, add fixes tag.
>  v2: fix for ipv6.
>  net/ipv4/syncookies.c | 7 ++++++-
>  net/ipv6/syncookies.c | 8 +++++++-
>  2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
> index 6ac473b..eea4698 100644
> --- a/net/ipv4/syncookies.c
> +++ b/net/ipv4/syncookies.c
> @@ -327,6 +327,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
>         struct inet_request_sock *ireq;
>         struct tcp_request_sock *treq;
>         struct tcp_sock *tp = tcp_sk(sk);
> +       int full_space = tcp_full_space(sk);

Please delay the actual call to tcp_full_space() until we need it.
If a packet does not validate the cookie, no need to init @full_space.

>         const struct tcphdr *th = tcp_hdr(skb);
>         __u32 cookie = ntohl(th->ack_seq) - 1;
>         struct sock *ret = sk;
> @@ -427,8 +428,12 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
>
>         /* Try to redo what tcp_v4_send_synack did. */
>         req->rsk_window_clamp = tp->window_clamp ? :dst_metric(&rt->dst, RTAX_WINDOW);
> +       /* limit the window selection if the user enforce a smaller rx buffer */

eg:
      full_space = tcp_full_space(sk);

> +       if (sk->sk_userlocks & SOCK_RCVBUF_LOCK &&
> +           (req->rsk_window_clamp > full_space || req->rsk_window_clamp == 0))
> +               req->rsk_window_clamp = full_space;
>
> -       tcp_select_initial_window(sk, tcp_full_space(sk), req->mss,
> +       tcp_select_initial_window(sk, full_space, req->mss,
>                                   &req->rsk_rcv_wnd, &req->rsk_window_clamp,
>                                   ireq->wscale_ok, &rcv_wscale,
>                                   dst_metric(&rt->dst, RTAX_INITRWND));
> diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
> index e796a64..5b09bb6 100644
> --- a/net/ipv6/syncookies.c
> +++ b/net/ipv6/syncookies.c
> @@ -132,6 +132,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
>         struct tcp_request_sock *treq;
>         struct ipv6_pinfo *np = inet6_sk(sk);
>         struct tcp_sock *tp = tcp_sk(sk);
> +       int full_space = tcp_full_space(sk);

Same remark here.

>         const struct tcphdr *th = tcp_hdr(skb);
>         __u32 cookie = ntohl(th->ack_seq) - 1;
>         struct sock *ret = sk;
> @@ -241,7 +242,12 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
>         }
>
>         req->rsk_window_clamp = tp->window_clamp ? :dst_metric(dst, RTAX_WINDOW);
> -       tcp_select_initial_window(sk, tcp_full_space(sk), req->mss,
> +       /* limit the window selection if the user enforce a smaller rx buffer */
> +       if (sk->sk_userlocks & SOCK_RCVBUF_LOCK &&
> +           (req->rsk_window_clamp > full_space || req->rsk_window_clamp == 0))
> +               req->rsk_window_clamp = full_space;
> +
> +       tcp_select_initial_window(sk, full_space, req->mss,
>                                   &req->rsk_rcv_wnd, &req->rsk_window_clamp,
>                                   ireq->wscale_ok, &rcv_wscale,
>                                   dst_metric(dst, RTAX_INITRWND));
> --
> 1.8.3.1
>

Thanks !
