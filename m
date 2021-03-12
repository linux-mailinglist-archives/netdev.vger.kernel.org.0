Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA3133937E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhCLQeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhCLQeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:34:06 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEFFC061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 08:34:06 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id f145so9582238ybg.11
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 08:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xd1OpSyULBAJCoaVVVrUuAIYtmhkhP65BjNqmabUSts=;
        b=tbXRuUKTAJ5OAzLt4K/pJhrwxAyj+0prXM6A/hLCmCMfOhznh8CB2cMbHU4IgyVxW5
         Im21oExo+0EMEbC1VIEOvaPHRbzZFruXZG8nlj4Tt0atYQ+i6rCMf8Sc1UetIG0kNtca
         sA6HIkx89UhP/NR7A8HDOO9I2rtiH5F5Ej+PRtgcL/gyhMeWSEYGjDsbV9Rf1ttIMRgt
         2nYv+umR2yKe+MvCQOWDNXYAuQm1O4y61WtiTBvisiV+ldsE+sA1dzI9Ck7X7JKed6ei
         x/HX5w7QqT+ZhF3g13nEw7CMcayY8A1UDh2YtoTSl+3Sj+MEAiprFeCVGeD0XhqbPnxB
         +ISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xd1OpSyULBAJCoaVVVrUuAIYtmhkhP65BjNqmabUSts=;
        b=MaSGL/9mVZprLeSQJV0211oDL1C7DGnSeo1uThEDz/LdMQBObwg2olCT6PsW402ZkL
         z1RaO+b89Ye/2QwPB6/GnSt+6RLTxUA+uM2Ue3spaQLx82yOcydR9A3ToyyR/ZgjDLNV
         MQrahmBDP/ih+F2nPxvHFQKJ1t0FAjTuHUSpkbCCmUF2in5QckX/LZJPD5HHnLaX70eh
         MzSSvIEH+RAmEF/MAz6SbDHVBSSUdp6cPWhJZ3h8GbaagmmtEXIhydYPG3YBPTKmgTGn
         26Q6htRS3ljdesils19G+D1C3MakUzcp6EB63DYL7QcPQfzPxsGrSypjEHVN2AlZb+3M
         aHaw==
X-Gm-Message-State: AOAM531QXC/Q7cYfhN835qnT2yKK2rWTZoYY1/eseYqedRMRmUwjkzNC
        Q6bIyTBtFF2jwXrcSgGdb2g24t9uCxI43oQtnMKALg==
X-Google-Smtp-Source: ABdhPJxTNip7fRhXXacvymw5GDHidct5oiKxuvIuYl2k74buQ2MPzFqhAIv6SB81Zi9YTWU8TyTZ7l+/yTWNknU9dnM=
X-Received: by 2002:a5b:78f:: with SMTP id b15mr20254754ybq.234.1615566845126;
 Fri, 12 Mar 2021 08:34:05 -0800 (PST)
MIME-Version: 1.0
References: <20210312162127.239795-1-alobakin@pm.me> <20210312162127.239795-5-alobakin@pm.me>
In-Reply-To: <20210312162127.239795-5-alobakin@pm.me>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 12 Mar 2021 17:33:53 +0100
Message-ID: <CANn89i+T-r=i3GBv-9EWBjpR_NhgZ=vP08BwTGXc8Kw3nO+OEQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] gro: improve flow distribution across GRO
 buckets in dev_gro_receive()
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 5:22 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Most of the functions that "convert" hash value into an index
> (when RPS is configured / XPS is not configured / etc.) set
> reciprocal_scale() on it. Its logics is simple, but fair enough and
> accounts the entire input value.
> On the opposite side, 'hash & (GRO_HASH_BUCKETS - 1)' expression uses
> only 3 least significant bits of the value, which is far from
> optimal (especially for XOR RSS hashers, where the hashes of two
> different flows may differ only by 1 bit somewhere in the middle).
>
> Use reciprocal_scale() here too to take the entire hash value into
> account and improve flow dispersion between GRO hash buckets.
>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/core/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 65d9e7d9d1e8..bd7c9ba54623 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5952,7 +5952,7 @@ static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
>
>  static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
>  {
> -       u32 bucket = skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
> +       u32 bucket = reciprocal_scale(skb_get_hash_raw(skb), GRO_HASH_BUCKETS);

This is going to use 3 high order bits instead of 3 low-order bits.
Now, had you use hash_32(skb_get_hash_raw(skb), 3), you could have
claimed to use "more bits"

Toeplitz already shuffles stuff.

Adding a multiply here seems not needed.

Please provide experimental results, because this looks unnecessary to me.
