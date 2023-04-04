Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361F76D58BC
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbjDDG0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbjDDG0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:26:01 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C172138;
        Mon,  3 Apr 2023 23:26:00 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id i6so37472893ybu.8;
        Mon, 03 Apr 2023 23:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680589559;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+H9GL64TGrcz+vOZNvr1jljQ38/CD9zQDOXsTVZAefM=;
        b=HI3PNT/pXakw12UQF3wpfr1WWc3sTtXEAx7eWTPsOicgPgEbBbAsujm/eb0z5okUYj
         GpAV5tvhWPNDdG/Rn3UabcLCmxPe9axmlKO++m7C4GIbErVpVZSjRY+Z8g9M7WQ6Ny0t
         s3YS9vEyubZ4bQLFONEBtPWVN/xu20M+wRP5ITlhSn8JLdv9JdBYwuV/9YpvyJE0+gcX
         JMh6JVMGDjq9OrrVOFT73ugvihaA1YRucSrELAUhVeR5td/pWjISxNlfzB4zv54l5s69
         wBwgBdaXXZaY1SWdtqTKWF4A8x8elWHulKZdHW/dTnjQcdPtwyBkpvUbnMZ7ycM53xS2
         kWZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680589559;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+H9GL64TGrcz+vOZNvr1jljQ38/CD9zQDOXsTVZAefM=;
        b=mzacJP6mTQt4oc/z/yvR4x6JQ9i9pB1n8w9w038OgjDEpuShoLpAZDZinowyxVVwYP
         dlTMGIVCuBLqpj0w6f0tVeyLSwPaR1LTB+jQYa1rqzro+3t7YcrIDvkh/lNtEYmVv6ne
         98tZRsBrNdgXwpqLPqtU4rjznx9O9F9xCzHloleJbgWGzJCseDY67FPc5l+jpW8n5aYC
         Fc84lnOHXf/Ul3iHwLd3oc8BzT5Ze213C2OAOV42qmr57qm+FqdgkXntgMAb8fx9C1iL
         ikDXKjqjK/MhXDu+DDwYJlIEtFoJ/NoAJ/TQgMivaYUw5/+C4iSzmN5UhLY5iIt8v/OG
         dLkw==
X-Gm-Message-State: AAQBX9fm+42Qv9upyTH5jNGJz6MHUMdWF83vtk7BlfxNA/P11ngGoxr4
        YVCo/WoGzQ5YIk+DgRxM57yTXQIAMluoZllLmLs=
X-Google-Smtp-Source: AKy350YwYLFMDMHigbbaZO3ehKUrYJxvv/9XkbY5TAvGCGwG1WvwUyacsmIQfOXhMgkzJJaNRoL2kJJLdYwD3Mnsa5Y=
X-Received: by 2002:a25:d4d0:0:b0:b3b:fb47:8534 with SMTP id
 m199-20020a25d4d0000000b00b3bfb478534mr990192ybf.5.1680589559363; Mon, 03 Apr
 2023 23:25:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230403143601.32168-1-kal.conley@dectris.com>
In-Reply-To: <20230403143601.32168-1-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 4 Apr 2023 08:25:48 +0200
Message-ID: <CAJ8uoz1BKJ1_jq6Sum-OkZQTR_ftmr5Enj+Cmn4Qsi15_jOpbQ@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: Fix unaligned descriptor validation
To:     Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 at 16:38, Kal Conley <kal.conley@dectris.com> wrote:
>
> Make sure unaligned descriptors that straddle the end of the UMEM are
> considered invalid. Currently, descriptor validation is broken for
> zero-copy mode which only checks descriptors at page granularity.
> Descriptors that cross the end of the UMEM but not a page boundary may
> be therefore incorrectly considered valid. The check needs to happen
> before the page boundary and contiguity checks in
> xp_desc_crosses_non_contig_pg. Do this check in
> xp_unaligned_validate_desc instead like xp_check_unaligned already does.

Thanks for catching this Kal.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  include/net/xsk_buff_pool.h | 9 ++-------
>  net/xdp/xsk_queue.h         | 1 +
>  2 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 3e952e569418..d318c769b445 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -180,13 +180,8 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
>         if (likely(!cross_pg))
>                 return false;
>
> -       if (pool->dma_pages_cnt) {
> -               return !(pool->dma_pages[addr >> PAGE_SHIFT] &
> -                        XSK_NEXT_PG_CONTIG_MASK);
> -       }
> -
> -       /* skb path */
> -       return addr + len > pool->addrs_cnt;
> +       return pool->dma_pages_cnt &&
> +              !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
>  }
>
>  static inline u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index bfb2a7e50c26..66c6f57c9c44 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -162,6 +162,7 @@ static inline bool xp_unaligned_validate_desc(struct xsk_buff_pool *pool,
>                 return false;
>
>         if (base_addr >= pool->addrs_cnt || addr >= pool->addrs_cnt ||
> +           addr + desc->len > pool->addrs_cnt ||
>             xp_desc_crosses_non_contig_pg(pool, addr, desc->len))
>                 return false;
>
> --
> 2.39.2
>
