Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DC562CF5A
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiKQALg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiKQALf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:11:35 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9A23E0A6;
        Wed, 16 Nov 2022 16:11:34 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id s5so237067edc.12;
        Wed, 16 Nov 2022 16:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NX3CN9AUyxebkkuESpk6/E6QqoY/avU2kY4IrmD2ujQ=;
        b=UccIauWWDxvcoHfrzPsacdmaEJ3YTfK6qc/FeQp5mh8ZhpGxk0XYcfNsxleOoKySJZ
         V5IDcrK6KtZyKK2JPC1poU74RtqFAXo1g5SHH3ja5HneeQAzYx4ZhpVL8PK2GDb1pxs5
         ERsQgSEQAqyB6YHKwwQyCsao0qH90u6Emuj1RLF62F3xP88habSYIGbJ5uIlgoXAjDl1
         So+xEmsbcDYit/b1zvsd7eFTr+pC8J55gJvwO3wUo1XM4Ddrr64Z0FZ19146yKWEoROm
         SUxytJeCooLDn1EtmumYs0nJajXSqyS3FQDsDNkDtyJ+BgXEexkOxd3/HvkZEFvkcPTd
         Awuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NX3CN9AUyxebkkuESpk6/E6QqoY/avU2kY4IrmD2ujQ=;
        b=7EvC9Zp+EJqXUF2MPJHbt5/qNIG9oHxLFTxxNFXOJyvVnbitEN+DzF4bjWF9SNCADs
         vGflKdoS4YIhErt1WTOAITiieDIN1Cu+TAvbwrXbuS3hGT9VFrMe1RnAW0VQg5IcpENk
         qgoGkFGd0MHaPxLkW47NjI1fHx4VJDi4iTaJ5lAKNA3clDmJq+cyarmtA5ioHN0L2zfI
         BMwTd0kBjMbr1PZeAcKAM/lTtG6UWbP2QBiUkmYNolZyeAUueqh+1ThUKH8IujJPw5Rs
         uPgKnnxilKBvBm6B/2UWYHxS0d3pwN1EG9tPzp/o7xUhLmoAX+iWilpxTd/iUnrKMGAj
         0GSA==
X-Gm-Message-State: ANoB5pnmXeCazT7RYvUIODUevwGniPs3EI55ifr/BJyKvtvMCB1U2Oa7
        jmrukPrAoN9STeeqNcskaeZz6K0AsDY0w8oM+S4=
X-Google-Smtp-Source: AA0mqf4/ygC1Y0KA56fscN8YPWdhjwzAF915tfFJAU60BABsHoSXswDsr+1LeNWsXWjDA3osxzPxhGTFdFirKPNVPD4=
X-Received: by 2002:a05:6402:290d:b0:45b:cb6b:c342 with SMTP id
 ee13-20020a056402290d00b0045bcb6bc342mr79865edb.282.1668643892699; Wed, 16
 Nov 2022 16:11:32 -0800 (PST)
MIME-Version: 1.0
References: <20221116222805.64734-1-kuniyu@amazon.com> <20221116222805.64734-2-kuniyu@amazon.com>
In-Reply-To: <20221116222805.64734-2-kuniyu@amazon.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 16 Nov 2022 16:11:21 -0800
Message-ID: <CAJnrk1YOfyGQ2Vic9xkoSj+uv7fuYAwh4wFLv1cBJ5LPiHsEvw@mail.gmail.com>
Subject: Re: [PATCH v2 net 1/4] dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Arnaldo Carvalho de Melo <acme@mandriva.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        dccp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 2:28 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> When connect() is called on a socket bound to the wildcard address,
> we change the socket's saddr to a local address.  If the socket
> fails to connect() to the destination, we have to reset the saddr.
>
> However, when an error occurs after inet_hash6?_connect() in
> (dccp|tcp)_v[46]_conect(), we forget to reset saddr and leave
> the socket bound to the address.
>
> From the user's point of view, whether saddr is reset or not varies
> with errno.  Let's fix this inconsistent behaviour.
>
> Note that after this patch, the repro [0] will trigger the WARN_ON()
> in inet_csk_get_port() again, but this patch is not buggy and rather
> fixes a bug papering over the bhash2's bug for which we need another
> fix.
>
> For the record, the repro causes -EADDRNOTAVAIL in inet_hash6_connect()
> by this sequence:
>
>   s1 = socket()
>   s1.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>   s1.bind(('127.0.0.1', 10000))
>   s1.sendto(b'hello', MSG_FASTOPEN, (('127.0.0.1', 10000)))
>   # or s1.connect(('127.0.0.1', 10000))
>
>   s2 = socket()
>   s2.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>   s2.bind(('0.0.0.0', 10000))
>   s2.connect(('127.0.0.1', 10000))  # -EADDRNOTAVAIL
>
>   s2.listen(32)  # WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);
>
> [0]: https://syzkaller.appspot.com/bug?extid=015d756bbd1f8b5c8f09
>
> Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
> Fixes: 7c657876b63c ("[DCCP]: Initial implementation")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

LGTM. Btw, the 4th patch in this series overwrites these changes by
moving this logic into the new inet_bhash2_reset_saddr() function you
added, so we could also drop this patch from the series. OTOH, this
commit message in this patch has some good background context. So I
don't have a preference either way :)

Acked-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  net/dccp/ipv4.c     | 2 ++
>  net/dccp/ipv6.c     | 2 ++
>  net/ipv4/tcp_ipv4.c | 2 ++
>  net/ipv6/tcp_ipv6.c | 2 ++
>  4 files changed, 8 insertions(+)
>
> diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> index 713b7b8dad7e..40640c26680e 100644
> --- a/net/dccp/ipv4.c
> +++ b/net/dccp/ipv4.c
> @@ -157,6 +157,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>          * This unhashes the socket and releases the local port, if necessary.
>          */
>         dccp_set_state(sk, DCCP_CLOSED);
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +               inet_reset_saddr(sk);
>         ip_rt_put(rt);
>         sk->sk_route_caps = 0;
>         inet->inet_dport = 0;
> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index e57b43006074..626166cb6d7e 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -985,6 +985,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>
>  late_failure:
>         dccp_set_state(sk, DCCP_CLOSED);
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +               inet_reset_saddr(sk);
>         __sk_dst_reset(sk);
>  failure:
>         inet->inet_dport = 0;
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 87d440f47a70..6a3a732b584d 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -343,6 +343,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>          * if necessary.
>          */
>         tcp_set_state(sk, TCP_CLOSE);
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +               inet_reset_saddr(sk);
>         ip_rt_put(rt);
>         sk->sk_route_caps = 0;
>         inet->inet_dport = 0;
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 2a3f9296df1e..81b396e5cf79 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -359,6 +359,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>
>  late_failure:
>         tcp_set_state(sk, TCP_CLOSE);
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +               inet_reset_saddr(sk);
>  failure:
>         inet->inet_dport = 0;
>         sk->sk_route_caps = 0;
> --
> 2.30.2
>
