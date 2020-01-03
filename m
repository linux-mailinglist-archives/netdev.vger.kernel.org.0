Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B2412F809
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 13:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbgACMO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 07:14:26 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:40294 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727457AbgACMOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 07:14:25 -0500
Received: by mail-yw1-f67.google.com with SMTP id i126so18431995ywe.7
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 04:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W8MUWrTxuoX6XI0MmOoLCHEiHqdBSrMIsyG7Vqg/r0U=;
        b=oQI0Yawz6xuvLc0uAT7alNFKqYYKAmJs09ctW83CDTuuDTjm1cFQ4syAC3DHkdHjPv
         XllCBcElfYhcc0k5ooYXVxVEwLSoH8aulAEUy+q20pRsn0sI/GEz0DglC3zoyIgcpCVc
         WQA2oOZNq3cr7YRSeELrm1XlvUXtpq1K6Wng+tSko4wMAiJY1RanQ8fHMJS6awAjt31I
         zGpii84anpeJOjs78QrD2BGeJZh8Jywc+/ZukOBMP5/LhY0mZXXZGszemqxF4SDSuTW9
         IWPJMlkzQ/XKgZGdbFYz10YUmHwYF/wbWXaqHdb6RqT9Q4ShjWUgQkB0VjfZ+eIbEPp3
         LXGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W8MUWrTxuoX6XI0MmOoLCHEiHqdBSrMIsyG7Vqg/r0U=;
        b=MpIGFD5Z/cMNivp4I1f+jF0dYIchxyHBNfrA1wwjKX3DbQe28Mq7WiWsV9Vg4Gdya+
         5eqPie6pykr9vEjx4akesZY9I6SPBuBrqGkygiFl8GcA5Ro+XMoOUSlwC5mscRn/BdhR
         XHRhO4lpB9jKHf+CE5BLYh5pWI7n/qSuajXCLgpmvIB5NRIcdNu8R/sHsyl1sNYXFuQO
         J2AIX4UFubc/tbkMpe8hfvE4cWCvgMWmiyiWKcCQeeCb02dI1vrNs4V+NW+ZfVDGlwsX
         UOFoTHOov4Cbf5nIAm+jl5oL0waNU6i+mPN9Mvo2ZWKoIn5TCCitd6CvSzywRGzAoQxe
         RNVQ==
X-Gm-Message-State: APjAAAVkRpVSd0wCuBUNwsVNvUhrLzwy+BMg8Y1syLApnOqc8jVkY2nS
        QJEk7iecWNRguEoSMTOepexvWFVTXMV2a5a3xcgsT5IIvSfrfQ==
X-Google-Smtp-Source: APXvYqyJ2TQ1ibBR4+hGb6iCB/fmGhn2vQJy0iYsUhIxZ8xhZY8v9ZrLH9fNVe7l+prbKPesE8Cqyx8ouMZOvvPJf8g=
X-Received: by 2002:a81:b38a:: with SMTP id r132mr69280092ywh.114.1578053663511;
 Fri, 03 Jan 2020 04:14:23 -0800 (PST)
MIME-Version: 1.0
References: <0GtwbnKBeenJLjYDiEqWz1RxHrIwx7PSbAxVS-oif8zDKbB97dg5TwYLUmWww8xIFQ3u4mOIcRvA27LqGYmSiF68CjFnubwPqDJyAO9FlQA=@protonmail.com>
In-Reply-To: <0GtwbnKBeenJLjYDiEqWz1RxHrIwx7PSbAxVS-oif8zDKbB97dg5TwYLUmWww8xIFQ3u4mOIcRvA27LqGYmSiF68CjFnubwPqDJyAO9FlQA=@protonmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Jan 2020 04:14:10 -0800
Message-ID: <CANn89iLiDnDfoeuEE-AsbG_bsU5Ojt9VQcZ53FmEOStT9_fj6A@mail.gmail.com>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
To:     Ttttabcd <ttttabcd@protonmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 30, 2019 at 5:21 PM Ttttabcd <ttttabcd@protonmail.com> wrote:
>
> In the original logic of tcp_conn_request, the backlog parameter of the
> listen system call and net.ipv4.tcp_max_syn_backlog are independent of
> each other, which causes some confusion in the processing.
>
> The backlog determines the maximum length of request_sock_queue, hereafter
> referred to as backlog.
>
> In the original design, if syn_cookies is not turned on, a quarter of
> tcp_max_syn_backlog will be reserved for clients that have proven to
> exist, mitigating syn attacks.
>
> Suppose now that tcp_max_syn_backlog is 1000, but the backlog is only 200,
> then 1000 >> 2 = 250, the backlog is used up by the syn attack, and the
> above mechanism will not work.
>
> Is tcp_max_syn_backlog used to limit the
> maximum length of request_sock_queue?
>
> Now suppose sycookie is enabled, backlog is 1000, and tcp_max_syn_backlog
> is only 200. In this case tcp_max_syn_backlog will be useless.
>
> Because syn_cookies is enabled, the tcp_max_syn_backlog logic will
> be ignored, and the length of request_sock_queue will exceed
> tcp_max_syn_backlog until the backlog.
>
> I modified the original logic and set the minimum value in backlog and
> tcp_max_syn_backlog as the maximum length limit of request_sock_queue.
>
> Now there is only a unified limit.
>
> The maximum length limit variable is "max_syn_backlog".
>
> Use syn_cookies whenever max_syn_backlog is exceeded.
>
> If syn_cookies is not enabled, a quarter of the max_syn_backlog queue is
> reserved for hosts that have proven to exist.
>
> In any case, request_sock_queue will not exceed max_syn_backlog.
> When syn_cookies is not turned on, a quarter of the queue retention
> will not be preempted.
>
> Signed-off-by: AK Deng <ttttabcd@protonmail.com>
> ---
>  net/ipv4/tcp_input.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 88b987ca9ebb..8f7e12844ae7 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6562,14 +6562,18 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
>         struct request_sock *req;
>         bool want_cookie = false;
>         struct dst_entry *dst;
> +       u32 max_syn_backlog;
>         struct flowi fl;
>
> +       max_syn_backlog = min_t(u32, net->ipv4.sysctl_max_syn_backlog,
> +                             sk->sk_max_ack_backlog);
> +
>         /* TW buckets are converted to open requests without
>          * limitations, they conserve resources and peer is
>          * evidently real one.
>          */
>         if ((net->ipv4.sysctl_tcp_syncookies == 2 ||
> -            inet_csk_reqsk_queue_is_full(sk)) && !isn) {
> +            inet_csk_reqsk_queue_len(sk) >= max_syn_backlog) && !isn) {
>                 want_cookie = tcp_syn_flood_action(sk, rsk_ops->slab_name);
>                 if (!want_cookie)
>                         goto drop;
> @@ -6621,8 +6625,8 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
>         if (!want_cookie && !isn) {
>                 /* Kill the following clause, if you dislike this way. */
>                 if (!net->ipv4.sysctl_tcp_syncookies &&
> -                   (net->ipv4.sysctl_max_syn_backlog - inet_csk_reqsk_queue_len(sk) <
> -                    (net->ipv4.sysctl_max_syn_backlog >> 2)) &&

Note that the prior condition is using signed arithmetic.


> +                   (max_syn_backlog - inet_csk_reqsk_queue_len(sk) <
> +                    (max_syn_backlog >> 2)) &&
>                     !tcp_peer_is_proven(req, dst)) {
>                         /* Without syncookies last quarter of
>                          * backlog is filled with destinations,
> --
> 2.24.0

I would prefer not changing this code, unless you prove there is a real problem.

(sysctl_max_syn_backlog defauts to 4096, and syncookies are enabled by
default, for a good reason)

Basically, sysctl_max_syn_backlog is not used today (because
syncookies are enabled...)

Your change might break users that suddenly will get behavior changes
if their sysctl_max_syn_backlog was set to a small value.
Unfortunately  some sysctl values are often copied/pasted from various
web pages claiming how to get best TCP performance.

It would be quite silly to change the kernel to adapt a change
(sysctl_max_syn_backlog set to 200 ... ) done by one of these admins.

Thanks.
