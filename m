Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10762663F83
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbjAJLuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238154AbjAJLtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:49:43 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED06544E7
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:49:42 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-4a263c4ddbaso151100467b3.0
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gvbUlZbRkizbNLG13i/TrEMaNfYnnm+tdXnbq4eQJHE=;
        b=cVgRNtqYIixuNnDAzzPFynB0ej+czZZDE01Jr9Mymv37ApAjz8e+v0nc53E16TmoNF
         hnXTrsfxPUoOc1VKP8mrf/cSI20DjnU61BvQ6MB4oisGUfXAy8OiPB7RP6yT6HILLhAi
         DQRu9aLKR/bZjGqtghxWVocK//SXMG5GxPC9ak5M90RtbnuYibg6uo0YTSF6awsS+HYA
         I/5rKYE/EcgiKBk9xplqTvSV1wJ7LOKj03T9iPWx0vRWd8Rz1KGOj/mmAZNSvq36aLCp
         eEQxIyYc1NzRVdKO13tnGbY1PqAcgV42kukI4r7qYB6bcvTcfSTy9WANZb98LsiRJM4c
         GfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gvbUlZbRkizbNLG13i/TrEMaNfYnnm+tdXnbq4eQJHE=;
        b=2yNMF2FwcWKqPFwW/Up/NRxiY5JQ3NhDgf2SkvYwsUJzlzHvvoclzJMdjqXkq5FiNv
         7AMr/3LDL2GiiPjxrQ+vB0RDPlAtmp1U7vu6S2aEMvj0GwS+BxxuQa3zmR0VwS3Pn+8j
         b/9qfePvapq8iXiuL+t18DT/qTGef9K3VQlsO3AjQk1axP89LJPk83jJyZSkgA16c8EW
         8af92abwjE+ZvKz9ondm9LRBALqdKvqwWaSVDSiNmr54l+QfirudP1Q3Q6Y7rryQxUWh
         sxRmCdnzVCLH3zMMKLKN2/w4GpPZUVqNbR0oXVacGI0sSf9G0W+ByiE0vH6ZMM84DgIV
         B27Q==
X-Gm-Message-State: AFqh2ko1HnVGgOz5htTlfYftSH/UKaHtr9DqNyjHV12fS08SmTwqnM7i
        0dN5YV50geXAH4TABg70VaViBKuYwcysXpFMwjg64g==
X-Google-Smtp-Source: AMrXdXvT9+Wig9vRLkuuqpK4LpWwK1/ehVCRfNWr58Xawzlgx+Qrr0rwJJYbJ5ikuZxBLOaV+Hk6fZMDbdwKgOBEG28=
X-Received: by 2002:a05:690c:b05:b0:467:2f6:4de5 with SMTP id
 cj5-20020a05690c0b0500b0046702f64de5mr2220727ywb.278.1673351381761; Tue, 10
 Jan 2023 03:49:41 -0800 (PST)
MIME-Version: 1.0
References: <20230110091356.1524-1-cuiyunhui@bytedance.com>
In-Reply-To: <20230110091356.1524-1-cuiyunhui@bytedance.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 10 Jan 2023 12:49:30 +0100
Message-ID: <CANn89i+Wh2krOy4YFWvBsEx-s_JgQ0HixHAVJwGw18dVPeyiqw@mail.gmail.com>
Subject: Re: [PATCH v5] sock: add tracepoint for send recv length
To:     Yunhui Cui <cuiyunhui@bytedance.com>
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
        xiyou.wangcong@gmail.com, duanxiongchun@bytedance.com,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org, dust.li@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-16.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 10:15 AM Yunhui Cui <cuiyunhui@bytedance.com> wrote:
>
> Add 2 tracepoints to monitor the tcp/udp traffic
> of per process and per cgroup.
>
> Regarding monitoring the tcp/udp traffic of each process, there are two
> existing solutions, the first one is https://www.atoptool.nl/netatop.php.
> The second is via kprobe/kretprobe.
>
> Netatop solution is implemented by registering the hook function at the
> hook point provided by the netfilter framework.
>
> These hook functions may be in the soft interrupt context and cannot
> directly obtain the pid. Some data structures are added to bind packets
> and processes. For example, struct taskinfobucket, struct taskinfo ...
>
> Every time the process sends and receives packets it needs multiple
> hashmaps,resulting in low performance and it has the problem fo inaccurate
> tcp/udp traffic statistics(for example: multiple threads share sockets).
>
> We can obtain the information with kretprobe, but as we know, kprobe gets
> the result by trappig in an exception, which loses performance compared
> to tracepoint.
>
> We compared the performance of tracepoints with the above two methods, and
> the results are as follows:
>
> ab -n 1000000 -c 1000 -r http://127.0.0.1/index.html
> without trace:
> Time per request: 39.660 [ms] (mean)
> Time per request: 0.040 [ms] (mean, across all concurrent requests)
>
> netatop:
> Time per request: 50.717 [ms] (mean)
> Time per request: 0.051 [ms] (mean, across all concurrent requests)
>
> kr:
> Time per request: 43.168 [ms] (mean)
> Time per request: 0.043 [ms] (mean, across all concurrent requests)
>
> tracepoint:
> Time per request: 41.004 [ms] (mean)
> Time per request: 0.041 [ms] (mean, across all concurrent requests
>
> It can be seen that tracepoint has better performance.
>
> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> Signed-off-by: Xiongchun Duan <duanxiongchun@bytedance.com>
> ---
>  include/trace/events/sock.h | 44 +++++++++++++++++++++++++++++++++++++
>  net/socket.c                | 36 ++++++++++++++++++++++++++----
>  2 files changed, 76 insertions(+), 4 deletions(-)
>

...

> +static noinline void call_trace_sock_recv_length(struct sock *sk, int ret, int flags)
> +{
> +       trace_sock_recv_length(sk, !(flags & MSG_PEEK) ? ret :
> +                              (ret < 0 ? ret : 0), flags);

Maybe we should only 'fast assign' the two fields (ret and flags),
and let this logic happen later at 'print' time ?

This would reduce storage by one integer, and make fast path really fast.

This also could potentially remove the need for the peculiar construct with
these noinline helpers.

> +}
> +
>  static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
>                                      int flags)


>  {
> -       return INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
> -                                 inet_recvmsg, sock, msg, msg_data_left(msg),
> -                                 flags);
> +       int ret = INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
> +                                    inet_recvmsg, sock, msg,
> +                                    msg_data_left(msg), flags);
> +
> +       if (trace_sock_recv_length_enabled())
> +               call_trace_sock_recv_length(sock->sk, !(flags & MSG_PEEK) ?
> +                                           ret : (ret < 0 ? ret : 0), flags);
> +       return ret;
>  }

Maybe you meant :

  if (trace_sock_recv_length_enabled())
      call_trace_sock_recv_length(sock->sk, ret, flags);

?

Please make sure to test your patches.
