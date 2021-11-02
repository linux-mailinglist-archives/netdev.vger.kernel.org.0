Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB0B443629
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhKBTAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 15:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhKBTAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 15:00:37 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B661C061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 11:58:02 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id d3so30300wrh.8
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 11:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=47dg4wDUBrwuePyaPcYFC2VKfaiVAGlUW1ptBmkxq6g=;
        b=Ci6/T+hRM/12osLnmdWVxnK1W5ShBdR7uIkeCS0VJy5jDPW1Q7llEVF74CxSIhs+PM
         zSlUHWfHzc2QKJbemfarZFtSR9D72CeZFQfpx4IOa5bxlpGQzjBtOn308e+tb0B7U5Pc
         vJ1IjRurjhL9hCpVqIJXZHiY9jdqvoJVw84MxZ3oQIEaD/XlpTfmConzUtSHf4NbKQlo
         3q7SfckqFpb3laXYrX+1qzbokTlrIbgmkE+GcbfD6gfVxsKrH3AvidnDGqjEYcs+8VXD
         knbFaBlzhpl6T+JCexAYlHTE6Nw+CQqNH8fsXhS+gstwwTpQ2ntyc9pMHRyy5wiQ1PP4
         eA/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=47dg4wDUBrwuePyaPcYFC2VKfaiVAGlUW1ptBmkxq6g=;
        b=1jUAobbgwJcaPsLDRQFSkUZsD1+QOdeEK/IdL7HxOaySerR12iFBG6pO5RHULbBZjW
         46xGl/R4mak+HsZLxosKUezQuwov1ZBlCfmoiQMFzeG4cyhzlYRHcPzvbJJo4Q3bfUza
         sqpBRk5iZeoLLy8lvSKKutJaPYMV19js12IXD02XBaSxLm2++jS2Djr5nmH9t+0x6/OF
         1qT5MTMv3vM0tGiRZKc/DQtv8VG4cOjMktZndlOK4Ci+bwHVgZjfwJ5LlL+jXsSmDG/8
         F23KuyGd7UYCPQsFSooB+TyB9MH2GqFhzHp0LXkkcWCBaExCPeD0xHkoeseyOPcu48K3
         xgTA==
X-Gm-Message-State: AOAM530tu7dkqeVRgN3JKu/DPI8hEr3prbqqId62sfekT0tBxhKNNjHB
        uP9BPxdCXTORgatTxFQSbG4x9W/wa629G9pJUYBZnQ==
X-Google-Smtp-Source: ABdhPJxGhv1Nqjq5h2hVcPi8AykmeTcMpWKPrLb8qguQwQJh+588fgc8q/dK9c0v66hXjknwMrsWalOVQjufdUx4qsk=
X-Received: by 2002:a5d:5850:: with SMTP id i16mr24120984wrf.197.1635879480844;
 Tue, 02 Nov 2021 11:58:00 -0700 (PDT)
MIME-Version: 1.0
References: <863fdf13-b1f4-f429-d8ac-269f9ceaa747@gmail.com> <20211102183235.14679-1-hmukos@yandex-team.ru>
In-Reply-To: <20211102183235.14679-1-hmukos@yandex-team.ru>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 2 Nov 2021 11:57:22 -0700
Message-ID: <CAK6E8=df3ZCt=tBDZHs8OEXWvnWpihxBr0x2+WP+smE+DXB9qQ@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: Use BPF timeout setting for SYN ACK RTO
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     eric.dumazet@gmail.com, brakmo@fb.com, mitradir@yandex-team.ru,
        ncardwell@google.com, netdev@vger.kernel.org, zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 11:33 AM Akhmat Karakotov <hmukos@yandex-team.ru> wrote:
>
> When setting RTO through BPF program, some SYN ACK packets were unaffected
> and continued to use TCP_TIMEOUT_INIT constant. This patch adds timeout
> option to struct request_sock. Option is initialized with TCP_TIMEOUT_INIT
> and is reassigned through BPF using tcp_timeout_init call. SYN ACK
> retransmits now use newly added timeout option.
>
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>  include/net/request_sock.h      | 2 ++
>  net/ipv4/inet_connection_sock.c | 2 +-
>  net/ipv4/tcp_input.c            | 8 +++++---
>  net/ipv4/tcp_minisocks.c        | 4 ++--
>  4 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> index 29e41ff3ec93..144c39db9898 100644
> --- a/include/net/request_sock.h
> +++ b/include/net/request_sock.h
> @@ -70,6 +70,7 @@ struct request_sock {
>         struct saved_syn                *saved_syn;
>         u32                             secid;
>         u32                             peer_secid;
> +       u32                             timeout;
>  };
>
>  static inline struct request_sock *inet_reqsk(const struct sock *sk)
> @@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
>         sk_node_init(&req_to_sk(req)->sk_node);
>         sk_tx_queue_clear(req_to_sk(req));
>         req->saved_syn = NULL;
> +       req->timeout = 0;
why not just set to TCP_TIMEOUT_INIT to avoid setting it again in
inet_reqsk_alloc?

>         req->num_timeout = 0;
>         req->num_retrans = 0;
>         req->sk = NULL;
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 0d477c816309..c43cc1f22092 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -870,7 +870,7 @@ static void reqsk_timer_handler(struct timer_list *t)
>
>                 if (req->num_timeout++ == 0)
>                         atomic_dec(&queue->young);
> -               timeo = min(TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
> +               timeo = min(req->timeout << req->num_timeout, TCP_RTO_MAX);
>                 mod_timer(&req->rsk_timer, jiffies + timeo);
>
>                 if (!nreq)
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 3f7bd7ae7d7a..5c181dc4e96f 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6706,6 +6706,7 @@ struct request_sock *inet_reqsk_alloc(const struct request_sock_ops *ops,
>                 ireq->ireq_state = TCP_NEW_SYN_RECV;
>                 write_pnet(&ireq->ireq_net, sock_net(sk_listener));
>                 ireq->ireq_family = sk_listener->sk_family;
> +               req->timeout = TCP_TIMEOUT_INIT;
>         }
>
>         return req;
> @@ -6922,9 +6923,10 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
>                 sock_put(fastopen_sk);
>         } else {
>                 tcp_rsk(req)->tfo_listener = false;
> -               if (!want_cookie)
> -                       inet_csk_reqsk_queue_hash_add(sk, req,
> -                               tcp_timeout_init((struct sock *)req));
> +               if (!want_cookie) {
> +                       req->timeout = tcp_timeout_init((struct sock *)req);
> +                       inet_csk_reqsk_queue_hash_add(sk, req, req->timeout);
> +               }
>                 af_ops->send_synack(sk, dst, &fl, req, &foc,
>                                     !want_cookie ? TCP_SYNACK_NORMAL :
>                                                    TCP_SYNACK_COOKIE,
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 0a4f3f16140a..9724c9c6d331 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -590,7 +590,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
>                          * it can be estimated (approximately)
>                          * from another data.
>                          */
> -                       tmp_opt.ts_recent_stamp = ktime_get_seconds() - ((TCP_TIMEOUT_INIT/HZ)<<req->num_timeout);
> +                       tmp_opt.ts_recent_stamp = ktime_get_seconds() - (req->timeout << req->num_timeout) / HZ;
>                         paws_reject = tcp_paws_reject(&tmp_opt, th->rst);
>                 }
>         }
> @@ -629,7 +629,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
>                     !inet_rtx_syn_ack(sk, req)) {
>                         unsigned long expires = jiffies;
>
> -                       expires += min(TCP_TIMEOUT_INIT << req->num_timeout,
> +                       expires += min(req->timeout << req->num_timeout,
>                                        TCP_RTO_MAX);
>                         if (!fastopen)
>                                 mod_timer_pending(&req->rsk_timer, expires);
> --
> 2.17.1
>
