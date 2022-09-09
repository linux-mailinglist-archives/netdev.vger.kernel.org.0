Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3C85B3D13
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 18:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiIIQgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 12:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIIQgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 12:36:13 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015A8133A32
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 09:36:12 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-348b1838c2bso25621457b3.3
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 09:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=LuWeHJa9gHphqO4a/dxtq/FqwtHAsVxExRzaNvOhKLs=;
        b=Af13cpj0ZuC8IXgsIa198ymCtQICBFTxfsfF9+6kaDQOW3RYf9V5Le7SC0xelOH7jS
         oTLq8+rJJZ2sEsu6LCIn5hbPGxMXtCIFiXRPu45En/BcFg4tJuEz7M0ggdX41Qrh7M3H
         k4THPms4bQCYYmUd532DG+2tKBz3e+6iwk+owNvKSjnnXHKoCoGPEOrZAn7lJA0P7tlO
         z4uwujlmK8j/cEuIq7Bw9lsIIr2vT1JfOukpTdmhk2Mw31snpfqrVRhvpgE/x2ZAZsif
         Z6LjF4pB0SVSHy1IZ+VueTbZDzuIrMTk903wtb6kl/zg1TlidzhDj8l3oo8b8w8dPafF
         FpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=LuWeHJa9gHphqO4a/dxtq/FqwtHAsVxExRzaNvOhKLs=;
        b=EJjAmGpiU5XA6QAif2NlaOCHxUYQRyn8lP5sUw0BnPDxvwUspVP2L5XRhU2voC9EmU
         wf/s10ugJ0iJTPVhDz982V7fqaNyKrbCHcj20WP4aGH2FvEhsTtjuFFUE00DXaAwidVM
         ZAOfR/lPt422e3sQt9Mjr/72/1AksPeZp134OIMZHntpDEnXKfx1Dm0hpaufePZkxn9g
         1L2suSk/op8TTtO+ZQbd71nodyw4hZs134BFuAf8PJeNXUL3bA3FI/XeL2CugmWRdZUa
         2x2sbj4M9/YKzn7kWWwZ8rVLVEBZJ/jy8/aGYcJnrDmrbLRsj9UWZwYv59xzyRZTK/Xg
         dgbg==
X-Gm-Message-State: ACgBeo34cRUS4mV7yETCZBEuVyQtYWnTg2q7w5P/5Ya+ypCYUqSnS8Ym
        42LC/mVPQuHJ336f8/xgmWDKR8zqZhMfa/BHtol42w==
X-Google-Smtp-Source: AA6agR6WsH9WBgmnH1fzgrhe0ajJJ3tykupUUiyJU6HySY9484OSxa/OxW5IZ945tQSPNVLFDq//0pIMwiZmQ7WFEe4=
X-Received: by 2002:a0d:d5cd:0:b0:345:68b1:c06e with SMTP id
 x196-20020a0dd5cd000000b0034568b1c06emr12710864ywd.489.1662741371898; Fri, 09
 Sep 2022 09:36:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220907015618.2140679-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220907015618.2140679-1-william.xuanziyang@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 9 Sep 2022 09:36:00 -0700
Message-ID: <CANn89iKPmDXvPzw9tYpiqHH7LegAgTb14fAiAqH8vAxZ3KsryA@mail.gmail.com>
Subject: Re: [PATCH net] net: tun: limit first seg size to avoid oversized linearization
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Petar Penkov <peterpenkov96@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 6, 2022 at 6:56 PM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
>
> Recently, we found a syzkaller problem as following:
>
> ========================================================
> WARNING: CPU: 1 PID: 17965 at mm/page_alloc.c:5295 __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
> ...
> Call trace:
>  __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
>  __alloc_pages_node include/linux/gfp.h:550 [inline]
>  alloc_pages_node include/linux/gfp.h:564 [inline]
>  kmalloc_large_node+0x94/0x350 mm/slub.c:4038
>  __kmalloc_node_track_caller+0x620/0x8e4 mm/slub.c:4545
>  __kmalloc_reserve.constprop.0+0x1e4/0x2b0 net/core/skbuff.c:151
>  pskb_expand_head+0x130/0x8b0 net/core/skbuff.c:1654
>  __skb_grow include/linux/skbuff.h:2779 [inline]
>  tun_napi_alloc_frags+0x144/0x610 drivers/net/tun.c:1477
>  tun_get_user+0x31c/0x2010 drivers/net/tun.c:1835
>  tun_chr_write_iter+0x98/0x100 drivers/net/tun.c:2036
>
> It is because the first seg size of the iov_iter from user space is
> very big, it is 2147479538 which is bigger than the threshold value
> for bail out early in __alloc_pages(). And skb->pfmemalloc is true,
> __kmalloc_reserve() would use pfmemalloc reserves without __GFP_NOWARN
> flag. Thus we got a warning.
>
> I noticed that non-first segs size are required less than PAGE_SIZE in
> tun_napi_alloc_frags(). The first seg should not be a special case, and
> oversized linearization is also unreasonable. Limit the first seg size to
> PAGE_SIZE to avoid oversized linearization.
>
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  drivers/net/tun.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 259b2b84b2b3..7db515f94667 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1454,12 +1454,12 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
>                                             size_t len,
>                                             const struct iov_iter *it)
>  {
> +       size_t linear = iov_iter_single_seg_count(it);
>         struct sk_buff *skb;
> -       size_t linear;
>         int err;
>         int i;
>
> -       if (it->nr_segs > MAX_SKB_FRAGS + 1)
> +       if (it->nr_segs > MAX_SKB_FRAGS + 1 || linear > PAGE_SIZE)
>                 return ERR_PTR(-EMSGSIZE);
>

This does not look good to me.

Some drivers allocate 9KB+ for 9000 MTU, in a single allocation,
because the hardware is not SG capable in RX.

>         local_bh_disable();
> @@ -1468,7 +1468,6 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
>         if (!skb)
>                 return ERR_PTR(-ENOMEM);
>
> -       linear = iov_iter_single_seg_count(it);
>         err = __skb_grow(skb, linear);
>         if (err)
>                 goto free;
> --
> 2.25.1
>
