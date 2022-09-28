Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFF05ED3A5
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiI1DuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbiI1DuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:50:11 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E41358B4C
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:50:08 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-333a4a5d495so118449047b3.10
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=FUl+mZTUrO6ZcNdjEggFHQOBC8un5MjxsRdqd4O15KI=;
        b=YNLEIt3HNu+bMioC6bkhvdmDyheeVHSf1FV4PVw4P2i9EGqzrmeZSyjtZvc4BNIBtd
         72wRzF1wBwRVKYfp6UnIsOnBgSKyqoAHlX1y3g0HLJgij5C7dO+irHDyH8ppvJDwUPlm
         l9gd7cHbeeUQYi9Vd/ddH5qlQ7yN/DIuydYWv42PEfXbysHtCrudtJ4KDIrh/xvJzZVx
         ZzUbq5ofB3rOkFWpasDXoc6Fh5BPe+/2aAARE1ZkitWqHExGwAPr3OSdJUu532N565PP
         iWXjrYnkmb2lbYhyn7HX7HqeSU7HKyvZCPhsuPvT0BS/wCFQO4YbVDOaTF6V4GpGz/uK
         StPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=FUl+mZTUrO6ZcNdjEggFHQOBC8un5MjxsRdqd4O15KI=;
        b=RGj8fb0mth+gk3xddqxPq+66hwVEZ4tnoMgFomcanUfnSJD1N/epV29IGObvksbdU6
         DfjvFpUJ/p+n/JnG8YPBlmBr45jlzEJN6hGPb4cypfyWjFMMa9PV62T6BbNEXRTCcCiO
         BJl1P+I4x3WtE5nugJmda1+yvCbqFQ6piPp1E4bc0/MakdG36DnFphPPIHeczyB3kwsu
         UXKJiR9ewUi+98SmAXOp40jV+wkY7hg9kio9xeKtc9o6Dw6HLekd7q8TLlee8/Q/jLOz
         p9kup/+9/sqi2Gt8/LBnX+ZSrwzVI1FJ6CMB5Luo9EQf/FVfMW5Ti/nVw0pfPxJAvCHS
         L58Q==
X-Gm-Message-State: ACrzQf1PGzkXSmGsKdDwfDMdbkXG3z/G/xXTr90etiqqf6HLHSEH+kqS
        4Zh1TaQGbdUI/NvXik06qH7Nq6S50fl6d21HLUzn8/4/DTw=
X-Google-Smtp-Source: AMsMyM7tUvCpOMHn1o20VU7R0iDSIRfZfj6SmQYWJPb6dC/gtM4eoZfhFlCRI8GKfiUBy3KnkMr5ZphJWgseH8vbqn4=
X-Received: by 2002:a81:6756:0:b0:345:525e:38 with SMTP id b83-20020a816756000000b00345525e0038mr28765374ywc.47.1664337007584;
 Tue, 27 Sep 2022 20:50:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220927002544.3381205-1-kafai@fb.com>
In-Reply-To: <20220927002544.3381205-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 20:49:55 -0700
Message-ID: <CANn89iLdDbkFWWPh8tPp71-PNf-FY=DqODhqqQ+iUN+o2=GwYw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Fix incorrect address comparison when
 searching for a bind2 bucket
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
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

On Mon, Sep 26, 2022 at 5:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> From: Martin KaFai Lau <martin.lau@kernel.org>
>
> The v6_rcv_saddr and rcv_saddr are inside a union in the
> 'struct inet_bind2_bucket'.  When searching a bucket by following the
> bhash2 hashtable chain, eg. inet_bind2_bucket_match, it is only using
> the sk->sk_family and there is no way to check if the inet_bind2_bucket
> has a v6 or v4 address in the union.  This leads to an uninit-value
> KMSAN report in [0] and also potentially incorrect matches.

I do not see the KMSAN report, is it missing from this changelog ?

Thanks.


>
> This patch fixes it by adding a family member to the inet_bind2_bucket
> and then tests 'sk->sk_family != tb->family' before matching
> the sk's address to the tb's address.


>
> Cc: Joanne Koong <joannelkoong@gmail.com>
> Cc: Alexander Potapenko <glider@google.com>
> Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> ---
>  include/net/inet_hashtables.h |  3 +++
>  net/ipv4/inet_hashtables.c    | 10 ++++++++++
>  2 files changed, 13 insertions(+)
>
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index 9121ccab1fa1..3af1e927247d 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -95,6 +95,9 @@ struct inet_bind2_bucket {
>         possible_net_t          ib_net;
>         int                     l3mdev;
>         unsigned short          port;
> +#if IS_ENABLED(CONFIG_IPV6)
> +       unsigned short          family;
> +#endif
>         union {
>  #if IS_ENABLED(CONFIG_IPV6)
>                 struct in6_addr         v6_rcv_saddr;
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 74e64aad5114..49db8c597eea 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -109,6 +109,7 @@ static void inet_bind2_bucket_init(struct inet_bind2_bucket *tb,
>         tb->l3mdev    = l3mdev;
>         tb->port      = port;
>  #if IS_ENABLED(CONFIG_IPV6)
> +       tb->family    = sk->sk_family;
>         if (sk->sk_family == AF_INET6)
>                 tb->v6_rcv_saddr = sk->sk_v6_rcv_saddr;
>         else
> @@ -146,6 +147,9 @@ static bool inet_bind2_bucket_addr_match(const struct inet_bind2_bucket *tb2,
>                                          const struct sock *sk)
>  {
>  #if IS_ENABLED(CONFIG_IPV6)
> +       if (sk->sk_family != tb2->family)
> +               return false;
> +
>         if (sk->sk_family == AF_INET6)
>                 return ipv6_addr_equal(&tb2->v6_rcv_saddr,
>                                        &sk->sk_v6_rcv_saddr);
> @@ -791,6 +795,9 @@ static bool inet_bind2_bucket_match(const struct inet_bind2_bucket *tb,
>                                     int l3mdev, const struct sock *sk)
>  {
>  #if IS_ENABLED(CONFIG_IPV6)
> +       if (sk->sk_family != tb->family)
> +               return false;
> +
>         if (sk->sk_family == AF_INET6)
>                 return net_eq(ib2_net(tb), net) && tb->port == port &&
>                         tb->l3mdev == l3mdev &&
> @@ -807,6 +814,9 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
>  #if IS_ENABLED(CONFIG_IPV6)
>         struct in6_addr addr_any = {};
>
> +       if (sk->sk_family != tb->family)
> +               return false;
> +
>         if (sk->sk_family == AF_INET6)
>                 return net_eq(ib2_net(tb), net) && tb->port == port &&
>                         tb->l3mdev == l3mdev &&
> --
> 2.30.2
>
