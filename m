Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1ED577707
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 17:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbiGQPU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 11:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiGQPU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 11:20:58 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698B713E13
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 08:20:57 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id p26-20020a1c545a000000b003a2fb7c1274so3577576wmi.1
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 08:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ompQDR3UBOILxxEUkYy8imbo4CdIgDcxZchoRKZ8CDg=;
        b=VKzeAfhYB6+ryWXb3ODjXV0qqa3G+lla8W3h8FCoNk+h4fBMjjnmN6S4GFA7yfhmbR
         0/VYw6DmWZq6QHVwaO14YWNfoj0Letx5dfAwXC/0XDKMWXB1ZY7ut+MkhJ59nql1nYRE
         8PGdaXnOjNM1y+UpsWeh3NgcppRSLsJgY8VLo+xSsEuW87A0FhhkjXs88v1DUxbO9EBO
         4KU2NbMuk9V8fEO8NCPp4zXN00NfAwdFkZbzc7X0Cu/uWqmJgsO8OYX9xvMd/QtL3Jdk
         NVYH6GvS36qoXlMhrY0hSqcp9mXjx8SwOUCe0+7lAOE3HdqGuG4lidKy/wBXWV/umJeu
         HaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ompQDR3UBOILxxEUkYy8imbo4CdIgDcxZchoRKZ8CDg=;
        b=Ao9rpzVRpraZHxpBvhUeYYIFSpBU6VwuLlwOg/xYTBoXRzI6e/49ywIv2Ae14UW5DU
         vsBnImaSo88eNg5nqlZww44IlaVFKQTZvg8mtnACw7635tkT++hvWWcioc3CZDFU6Wn0
         d4DqZJ0v4VRnXe+0n/vESDde8IZqemK7ciNjUiYdANuHY2tJY8u8Mw0Juq1TGcWw1y2z
         LQsB4M1ALcfJU2CA5xjGUEIkA6/J6lDmp3UvEELf7zmZsq/G4LXhpG0CV2vXWnHkUv21
         KVcmSoUnWXISe+IMA/YPJpb8UCSjqek6W8WebDKaqXuzwNn3oFqtXtihdDgc15xWxNae
         q4kw==
X-Gm-Message-State: AJIora9QieCMOnyluTvMf00dpvBoCM5Q7TsihnMMWHwTeebtz7uY7Vkb
        J9zmS6NZEJbN0umAeabYKtUdq30IFW5+1oFuXoeKuA==
X-Google-Smtp-Source: AGRyM1t1Y7RmnDdR/V+aBlHm8CuklVboTPANWmDrdPD5T2K4Y71oroaN5Y8Gr17Fq0GJOiZU3ggySXZyfNPllQjPHS0=
X-Received: by 2002:a05:600c:5110:b0:3a3:125:b3a6 with SMTP id
 o16-20020a05600c511000b003a30125b3a6mr17384270wms.155.1658071255901; Sun, 17
 Jul 2022 08:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220715171755.38497-1-kuniyu@amazon.com> <20220715171755.38497-15-kuniyu@amazon.com>
In-Reply-To: <20220715171755.38497-15-kuniyu@amazon.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Sun, 17 Jul 2022 08:20:19 -0700
Message-ID: <CAK6E8=cH9TcPobp0UmQqph87TgEtzjAA_YdbTqGORnL4gg=nVA@mail.gmail.com>
Subject: Re: [PATCH v1 net 14/15] tcp: Fix data-races around sysctl_tcp_fastopen.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
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

On Fri, Jul 15, 2022 at 10:21 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> While reading sysctl_tcp_fastopen, it can be changed concurrently.
> Thus, we need to add READ_ONCE() to its readers.
>
> Fixes: 2100c8d2d9db ("net-tcp: Fast Open base")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> CC: Yuchung Cheng <ycheng@google.com>
Thanks for the improvement

Acked-by: Yuchung Cheng <ycheng@google.com>

> ---
>  net/ipv4/af_inet.c      | 2 +-
>  net/ipv4/tcp.c          | 6 ++++--
>  net/ipv4/tcp_fastopen.c | 4 ++--
>  3 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 4bc24f9e38b3..59a0c5406fc1 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -217,7 +217,7 @@ int inet_listen(struct socket *sock, int backlog)
>                  * because the socket was in TCP_LISTEN state previously but
>                  * was shutdown() rather than close().
>                  */
> -               tcp_fastopen = sock_net(sk)->ipv4.sysctl_tcp_fastopen;
> +               tcp_fastopen = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen);
>                 if ((tcp_fastopen & TFO_SERVER_WO_SOCKOPT1) &&
>                     (tcp_fastopen & TFO_SERVER_ENABLE) &&
>                     !inet_csk(sk)->icsk_accept_queue.fastopenq.max_qlen) {
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index b1b1bcbc4f60..2faaaaf540ac 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1150,7 +1150,8 @@ static int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
>         struct sockaddr *uaddr = msg->msg_name;
>         int err, flags;
>
> -       if (!(sock_net(sk)->ipv4.sysctl_tcp_fastopen & TFO_CLIENT_ENABLE) ||
> +       if (!(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen) &
> +             TFO_CLIENT_ENABLE) ||
>             (uaddr && msg->msg_namelen >= sizeof(uaddr->sa_family) &&
>              uaddr->sa_family == AF_UNSPEC))
>                 return -EOPNOTSUPP;
> @@ -3617,7 +3618,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
>         case TCP_FASTOPEN_CONNECT:
>                 if (val > 1 || val < 0) {
>                         err = -EINVAL;
> -               } else if (net->ipv4.sysctl_tcp_fastopen & TFO_CLIENT_ENABLE) {
> +               } else if (READ_ONCE(net->ipv4.sysctl_tcp_fastopen) &
> +                          TFO_CLIENT_ENABLE) {
>                         if (sk->sk_state == TCP_CLOSE)
>                                 tp->fastopen_connect = val;
>                         else
> diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
> index fdbcf2a6d08e..0acdb5473850 100644
> --- a/net/ipv4/tcp_fastopen.c
> +++ b/net/ipv4/tcp_fastopen.c
> @@ -332,7 +332,7 @@ static bool tcp_fastopen_no_cookie(const struct sock *sk,
>                                    const struct dst_entry *dst,
>                                    int flag)
>  {
> -       return (sock_net(sk)->ipv4.sysctl_tcp_fastopen & flag) ||
> +       return (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen) & flag) ||
>                tcp_sk(sk)->fastopen_no_cookie ||
>                (dst && dst_metric(dst, RTAX_FASTOPEN_NO_COOKIE));
>  }
> @@ -347,7 +347,7 @@ struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
>                               const struct dst_entry *dst)
>  {
>         bool syn_data = TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq + 1;
> -       int tcp_fastopen = sock_net(sk)->ipv4.sysctl_tcp_fastopen;
> +       int tcp_fastopen = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen);
>         struct tcp_fastopen_cookie valid_foc = { .len = -1 };
>         struct sock *child;
>         int ret = 0;
> --
> 2.30.2
>
