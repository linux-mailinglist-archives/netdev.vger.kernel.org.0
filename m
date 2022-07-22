Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0790E57E6E9
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbiGVS7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbiGVS7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:59:02 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455AD564E1
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:59:01 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id a7so1093551vkl.0
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yn7R/clyKf2k9jxNpS2OSdcpGCpHnhI+UiyvsIGIClo=;
        b=X7eALXzLFu1UDuCO2O1/eGiBlgfYrMiSmyYo5c1PLP2NjtSanu4cj2oDaYkmE8bcRK
         BMkUKZXi4ePIfeyJ1ZrEQJVkMlwD99YBUwQp2jUCxe5V09rxof4kxoDwyyPzVOqCZKSp
         RxUsJd9aAar5xs6zAB+8mp4rZU0EsB7m2hBFDEp77swOBiXP4xpDegvQ+V/vHeMdVXas
         v16+4JY1Ip/2dxBnhpwUnogQiQpDkmEexSLwkIrp1OWRGaBxIcy44dc7hNBAxmExOW9X
         rIY1vJgU49eSTKYGK3xSlFM5XufafyGuVTbeitsHVS/1Pew1d7dCOJugRDId2tsbB0iA
         uU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yn7R/clyKf2k9jxNpS2OSdcpGCpHnhI+UiyvsIGIClo=;
        b=Ut7fs7iadwl8bjoDJXKw8TSIesBAd5zQsXak2pVqcJxQwythquzbc6idznlFZ91HrD
         r4w2UlK9hZsc4CLG9RY2DZcShozpfP/V5Ju8+hLQBQb9ztcjupQSU7GzBCc8WTM7mJo8
         NHZW2hJRXTegJyhtM5uSj8LrTRFAU2U6o7AUPKhgSXEhMCgbZ/89gZQ12iZNnIuRJ5GI
         T1PkNqbZZsskXlGUpL/ZoMiG/7n56pilXVkBQAkJOt6MyAikX3MG63y92hjn8OuMSxcE
         2SHze7Ca5dhu02U9wE0lNRJ2awncnSDfmJwEuaY+GfKksB+49+cYUqtvfsCCWqtOH9mc
         f0fg==
X-Gm-Message-State: AJIora95Dt2oBZXdXuMysfCs6lXOuWBzhh6v5ItPqlMdUU8w18h4W8aA
        KG88EAsSRVWTYAI38AOnf8rrTFDseNxuSemUduNBbw==
X-Google-Smtp-Source: AGRyM1uE/pyDTSP6cJOJSnrhNFsGbV+mR7597FJTpAinJp6Rztz01lvvt/AeQEu2g75ACqjmUNFqwqjeS91vb2YzFFQ=
X-Received: by 2002:a1f:1887:0:b0:374:750e:ce54 with SMTP id
 129-20020a1f1887000000b00374750ece54mr439684vky.28.1658516340282; Fri, 22 Jul
 2022 11:59:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220722182205.96838-1-kuniyu@amazon.com> <20220722182205.96838-7-kuniyu@amazon.com>
In-Reply-To: <20220722182205.96838-7-kuniyu@amazon.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 22 Jul 2022 11:58:49 -0700
Message-ID: <CAEA6p_DwfgkLheTK1QvSyZPbotvmadn7cubtqf1UFAHWfdDY=Q@mail.gmail.com>
Subject: Re: [PATCH v1 net 6/7] tcp: Fix data-races around sysctl_tcp_reflect_tos.
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

On Fri, Jul 22, 2022 at 11:24 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> While reading sysctl_tcp_reflect_tos, it can be changed concurrently.
> Thus, we need to add READ_ONCE() to its readers.
>
> Fixes: ac8f1710c12b ("tcp: reflect tos value received in SYN to the socket")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---

Acked-by: Wei Wang <weiwan@google.com>

> CC: Wei Wang <weiwan@google.com>
> ---
>  net/ipv4/tcp_ipv4.c | 4 ++--
>  net/ipv6/tcp_ipv6.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index d16e6e40f47b..586c102ce152 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1006,7 +1006,7 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
>         if (skb) {
>                 __tcp_v4_send_check(skb, ireq->ir_loc_addr, ireq->ir_rmt_addr);
>
> -               tos = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
> +               tos = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos) ?
>                                 (tcp_rsk(req)->syn_tos & ~INET_ECN_MASK) |
>                                 (inet_sk(sk)->tos & INET_ECN_MASK) :
>                                 inet_sk(sk)->tos;
> @@ -1526,7 +1526,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
>         /* Set ToS of the new socket based upon the value of incoming SYN.
>          * ECT bits are set later in tcp_init_transfer().
>          */
> -       if (sock_net(sk)->ipv4.sysctl_tcp_reflect_tos)
> +       if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos))
>                 newinet->tos = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
>
>         if (!dst) {
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 9d3ede293258..be09941fe6d9 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -546,7 +546,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
>                 if (np->repflow && ireq->pktopts)
>                         fl6->flowlabel = ip6_flowlabel(ipv6_hdr(ireq->pktopts));
>
> -               tclass = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
> +               tclass = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos) ?
>                                 (tcp_rsk(req)->syn_tos & ~INET_ECN_MASK) |
>                                 (np->tclass & INET_ECN_MASK) :
>                                 np->tclass;
> @@ -1314,7 +1314,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
>         /* Set ToS of the new socket based upon the value of incoming SYN.
>          * ECT bits are set later in tcp_init_transfer().
>          */
> -       if (sock_net(sk)->ipv4.sysctl_tcp_reflect_tos)
> +       if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos))
>                 newnp->tclass = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
>
>         /* Clone native IPv6 options from listening socket (if any)
> --
> 2.30.2
>
