Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F2A57DECB
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 11:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236577AbiGVJe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236573AbiGVJel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:34:41 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5D8E1CA4
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:23:15 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2ef5380669cso41436727b3.9
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ib3W98oChuOwd1PVFyd6WToLFbPUhYfk53XWlshBtQ4=;
        b=fV9NKUegiZPTzqh+LOnkZLW82E7NVhTI3IF4YnaaGt/o4/jEUvbjMP4SZjfGT3KlfP
         o4pTfmTOUeA7hkS2nvkyWmOuxGZZlx51GcqK57ahgVgDO/v7zfhngFKlT68uDmtjDsec
         FO6PIGMHLEzRsjZSm+ljRMGO49VgVZ7k2XLuRf22Md668xBZb4APtMDGm4hjoCDwjjNh
         vXTXsc1O4sqaHUPJsqzqNofSyW1jWSLQ0ttfgMWU5ci3bpLWk55l9+OrJDmb+okSes8Z
         KTMJ2MNJqJO6HxVgjW+jqwFv8NRTSyvqwDTYixWrpOSqDY4dvrp4nti6e5DJqDhJuqFz
         AomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ib3W98oChuOwd1PVFyd6WToLFbPUhYfk53XWlshBtQ4=;
        b=AQA+m0qJJvCfq/CCgAgh7361Wb4GAfQaANI3hPfaWvlLWSlHmKRzxQEv6BDsW9TVZs
         kyVqAaxI6B6bs86jv1xPSdVrQF1bHS3MLFyzl2wql7Gsd8UdVWzq8ZHSTBTqbCWQC/Og
         A/slnwJjlwwauuqTP12JSazENVzvaAjdhEz0WpB6/vNKK0GJ22z5nw9kIntlqHEkmvI7
         VjOH9j+8yk1JODXywMSUkMCxDf9kFJz/XkhZfATWTag8b706zWBjownX3iX8/thlTXVV
         Boc6HdEcT4VMyK42pCZhlAl1iwScps9K4cpDlnXcZV3bcjT1OheiVYL78Y7vD5rDTshb
         CAzA==
X-Gm-Message-State: AJIora+Nkmdztc3PoIRYssNJ3TbjF10cYTf8c6i7a7/ALQiPARgNJgNt
        8W29U5Lne2/MIeTWMBaIU5iBjZqAR4fehu6WRUOCdA==
X-Google-Smtp-Source: AGRyM1vi6K8c0xDKW7xzbvBmwFfn4AZiS6DZ+ByR/SJJJdwSF9sfcLnbodoSy4C7nSs8R9ikUY5t+FN1gjC14iLroG8=
X-Received: by 2002:a81:23ce:0:b0:31e:65c1:f4f with SMTP id
 j197-20020a8123ce000000b0031e65c10f4fmr2289205ywj.255.1658481793710; Fri, 22
 Jul 2022 02:23:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220721151041.1215017-1-marek@cloudflare.com> <20220721151041.1215017-2-marek@cloudflare.com>
In-Reply-To: <20220721151041.1215017-2-marek@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Jul 2022 11:23:02 +0200
Message-ID: <CANn89iKi2yaw=H-E8e9iet-gwr9vR6SmN9hibHF-5nT44K+e+g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] RTAX_INITRWND should be able to bring the
 rcv_ssthresh above 64KiB
To:     Marek Majkowski <marek@cloudflare.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Ivan Babrou <ivan@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
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

On Thu, Jul 21, 2022 at 5:10 PM Marek Majkowski <marek@cloudflare.com> wrote:
>
> We already support RTAX_INITRWND / initrwnd path attribute:
>
>  $ ip route change local 127.0.0.0/8 dev lo initrwnd 1024
>
> However normally, the initial advertised receive window is limited to
> 64KiB by rcv_ssthresh, regardless of initrwnd. This patch changes
> that, bumping up rcv_ssthresh to value derived from initrwnd. This
> allows for larger initial advertised receive windows, which is useful
> for specific types of TCP flows: big BDP ones, where there is a lot of
> data to send immediately after the flow is established.
>
> There are three places where we initialize sockets:
>  - tcp_output:tcp_connect_init
>  - tcp_minisocks:tcp_openreq_init_rwin
>  - syncookies
>
> In the first two we already have a call to `tcp_rwnd_init_bpf` and
> `dst_metric(RTAX_INITRWND)` which retrieve the bpf/path initrwnd
> attribute. We use this value to bring `rcv_ssthresh` up, potentially
> above the traditional 64KiB.
>
> With higher initial `rcv_ssthresh` the receiver will open the receive
> window more aggresively, which can improve large BDP flows - large
> throughput and latency.
>
> This patch does not cover the syncookies case.
>
> Signed-off-by: Marek Majkowski <marek@cloudflare.com>
> ---
>  include/net/inet_sock.h  |  1 +
>  net/ipv4/tcp_minisocks.c |  8 ++++++--
>  net/ipv4/tcp_output.c    | 10 ++++++++--
>  3 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
> index daead5fb389a..bc68c9b70942 100644
> --- a/include/net/inet_sock.h
> +++ b/include/net/inet_sock.h
> @@ -89,6 +89,7 @@ struct inet_request_sock {
>                                 no_srccheck: 1,
>                                 smc_ok     : 1;
>         u32                     ir_mark;
> +       u32                     rcv_ssthresh;

Why do we need to store this value in the request_sock ?

It is derived from a route attribute and MSS, all this should be
available when the full blown socket is created.

It would also work even with syncookies.

>         union {
>                 struct ip_options_rcu __rcu     *ireq_opt;
>  #if IS_ENABLED(CONFIG_IPV6)
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 6854bb1fb32b..89ba2a30a012 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -360,6 +360,7 @@ void tcp_openreq_init_rwin(struct request_sock *req,
>         u32 window_clamp;
>         __u8 rcv_wscale;
>         u32 rcv_wnd;
> +       int adj_mss;
>         int mss;
>
>         mss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
> @@ -378,15 +379,18 @@ void tcp_openreq_init_rwin(struct request_sock *req,
>         else if (full_space < rcv_wnd * mss)
>                 full_space = rcv_wnd * mss;
>
> +       adj_mss = mss - (ireq->tstamp_ok ? TCPOLEN_TSTAMP_ALIGNED : 0);
> +
>         /* tcp_full_space because it is guaranteed to be the first packet */
>         tcp_select_initial_window(sk_listener, full_space,
> -               mss - (ireq->tstamp_ok ? TCPOLEN_TSTAMP_ALIGNED : 0),
> +               adj_mss,
>                 &req->rsk_rcv_wnd,
>                 &req->rsk_window_clamp,
>                 ireq->wscale_ok,
>                 &rcv_wscale,
>                 rcv_wnd);
>         ireq->rcv_wscale = rcv_wscale;
> +       ireq->rcv_ssthresh = max(req->rsk_rcv_wnd, rcv_wnd * adj_mss);
>  }
>  EXPORT_SYMBOL(tcp_openreq_init_rwin);
>
> @@ -502,7 +506,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
>         newtp->rx_opt.tstamp_ok = ireq->tstamp_ok;
>         newtp->rx_opt.sack_ok = ireq->sack_ok;
>         newtp->window_clamp = req->rsk_window_clamp;
> -       newtp->rcv_ssthresh = req->rsk_rcv_wnd;
> +       newtp->rcv_ssthresh = ireq->rcv_ssthresh;
>         newtp->rcv_wnd = req->rsk_rcv_wnd;
>         newtp->rx_opt.wscale_ok = ireq->wscale_ok;
>         if (newtp->rx_opt.wscale_ok) {
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 18c913a2347a..0f2d4174ea59 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3642,6 +3642,7 @@ static void tcp_connect_init(struct sock *sk)
>         struct tcp_sock *tp = tcp_sk(sk);
>         __u8 rcv_wscale;
>         u32 rcv_wnd;
> +       u32 mss;
>
>         /* We'll fix this up when we get a response from the other end.
>          * See tcp_input.c:tcp_rcv_state_process case TCP_SYN_SENT.
> @@ -3679,8 +3680,10 @@ static void tcp_connect_init(struct sock *sk)
>         if (rcv_wnd == 0)
>                 rcv_wnd = dst_metric(dst, RTAX_INITRWND);
>
> +       mss = tp->advmss - (tp->rx_opt.ts_recent_stamp ?
> +                           tp->tcp_header_len - sizeof(struct tcphdr) : 0);
>         tcp_select_initial_window(sk, tcp_full_space(sk),
> -                                 tp->advmss - (tp->rx_opt.ts_recent_stamp ? tp->tcp_header_len - sizeof(struct tcphdr) : 0),
> +                                 mss,
>                                   &tp->rcv_wnd,
>                                   &tp->window_clamp,
>                                   sock_net(sk)->ipv4.sysctl_tcp_window_scaling,
> @@ -3688,7 +3691,10 @@ static void tcp_connect_init(struct sock *sk)
>                                   rcv_wnd);
>
>         tp->rx_opt.rcv_wscale = rcv_wscale;
> -       tp->rcv_ssthresh = tp->rcv_wnd;
> +       if (rcv_wnd)
> +               tp->rcv_ssthresh = max(tp->rcv_wnd, rcv_wnd * mss);
> +       else
> +               tp->rcv_ssthresh = tp->rcv_wnd;
>
>         sk->sk_err = 0;
>         sock_reset_flag(sk, SOCK_DONE);
> --
> 2.25.1
>
