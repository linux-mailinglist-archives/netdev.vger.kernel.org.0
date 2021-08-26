Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042033F7F3D
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 02:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhHZAMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 20:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhHZAMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 20:12:47 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBD2C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 17:12:00 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id g2so680360uad.4
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 17:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pe852tzX5e5B4WKfOmntm7FOG4THceEV/c2nvvMJzDY=;
        b=SGSipTh7PboDDKzMv0ORQt3fqRgB8BzlnD7LD6Lt5SNt9oZGzWjowwuyFmZJgWlN3l
         iF9TnH2a+gmgvg450s4rePp7Dm20+Y2czeZv3ck8DIYTzctAi509Y76uIshDlMTjJjop
         0cX/sEWg+XHZpExFuxLQrQBNi+G+CAtcAGZwM59xO2XwngPAZQ1lNe18OCTBmCDVjV+r
         hymCz7bNN44qJeyn4d48V8V//4mquIVOlZnJjHYThjbXnhsTTxybv8cyl8xj2YfGZKDq
         EqD5dFfSLh7AN77CQ6wIYUNQQpb6t7Z7L9aUmUZ/q5Zc7YmKdUqi629B9N+4dSYyT7zN
         Lzqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pe852tzX5e5B4WKfOmntm7FOG4THceEV/c2nvvMJzDY=;
        b=Zf6bq65cY7VkYd6u++sWuvDmstgkgAQUWo88N0OK6fyBMw7PqxgVg/bLJJem1jLyKB
         b/pFe9bSUx+2egzdy1TKyi2rKm9btC6KK2hltWDpPZDmrC9bZFoLxZ9N0w9dR15VmmuC
         iueL9aEpCNGPrb1sWrZb0FHH4WfFqapEgNTEPPWx5p7ccX/U7oz7Vu5dl58yRLehZitV
         glaA6XtroLeP5NtRPl/Zg7g8vyaLe8JDt3qPrb6yTW6K81erpyxWO2o09g+k6zIm8Ggz
         LLJ7MondTkmTPgDwdDF4FOJ3wHI+52Hum6bkl9xRqvNnOGdLtXvPWhy4Ws3a1GLD0K5Q
         Gk+w==
X-Gm-Message-State: AOAM533QzaDfreTSONpXh+mGsiNNKWbGCNGgUWXQeF0L+ge+84SDEB52
        pSX1FMRhU/MKzeYtYeLBrqTdMk+5N5DPfLUcgCtr1g==
X-Google-Smtp-Source: ABdhPJyt6USDrEvuby/IvUXIT3nrDvEdXdSG1yZPqvFXqW37kCKEMn/bV3LjGiU2cFQKCxLW6dG0JcFfwLyTZ9QWIak=
X-Received: by 2002:ab0:26cd:: with SMTP id b13mr608844uap.98.1629936719652;
 Wed, 25 Aug 2021 17:11:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210825231729.401676-1-eric.dumazet@gmail.com> <20210825231729.401676-2-eric.dumazet@gmail.com>
In-Reply-To: <20210825231729.401676-2-eric.dumazet@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 25 Aug 2021 17:11:48 -0700
Message-ID: <CAEA6p_DHT5bNFBy_B-Z2BeSeJZN8ndSBgkvkJd5S7GTMW26rgQ@mail.gmail.com>
Subject: Re: [PATCH net 1/2] ipv6: use siphash in rt6_exception_hash()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        Keyu Man <kman001@ucr.edu>, Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 4:17 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> A group of security researchers brought to our attention
> the weakness of hash function used in rt6_exception_hash()
>
> Lets use siphash instead of Jenkins Hash, to considerably
> reduce security risks.
>
> Following patch deals with IPv4.
>
> Fixes: 35732d01fe31 ("ipv6: introduce a hash table to store dst cache")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Keyu Man <kman001@ucr.edu>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
Acked-by: Wei Wang <weiwan@google.com>

Thanks Eric!

> ---
>
>
>
>  net/ipv6/route.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index b6ddf23d38330ded88509b8507998ce82a72799b..c5e8ecb96426bda619fe242351e40dcf6ff68bcf 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -41,6 +41,7 @@
>  #include <linux/nsproxy.h>
>  #include <linux/slab.h>
>  #include <linux/jhash.h>
> +#include <linux/siphash.h>
>  #include <net/net_namespace.h>
>  #include <net/snmp.h>
>  #include <net/ipv6.h>
> @@ -1484,17 +1485,24 @@ static void rt6_exception_remove_oldest(struct rt6_exception_bucket *bucket)
>  static u32 rt6_exception_hash(const struct in6_addr *dst,
>                               const struct in6_addr *src)
>  {
> -       static u32 seed __read_mostly;
> -       u32 val;
> +       static siphash_key_t rt6_exception_key __read_mostly;
> +       struct {
> +               struct in6_addr dst;
> +               struct in6_addr src;
> +       } __aligned(SIPHASH_ALIGNMENT) combined = {
> +               .dst = *dst,
> +       };
> +       u64 val;
>
> -       net_get_random_once(&seed, sizeof(seed));
> -       val = jhash2((const u32 *)dst, sizeof(*dst)/sizeof(u32), seed);
> +       net_get_random_once(&rt6_exception_key, sizeof(rt6_exception_key));
>
>  #ifdef CONFIG_IPV6_SUBTREES
>         if (src)
> -               val = jhash2((const u32 *)src, sizeof(*src)/sizeof(u32), val);
> +               combined.src = *src;
>  #endif
> -       return hash_32(val, FIB6_EXCEPTION_BUCKET_SIZE_SHIFT);
> +       val = siphash(&combined, sizeof(combined), &rt6_exception_key);
> +
> +       return hash_64(val, FIB6_EXCEPTION_BUCKET_SIZE_SHIFT);
>  }
>
>  /* Helper function to find the cached rt in the hash table
> --
> 2.33.0.rc2.250.ged5fa647cd-goog
>
