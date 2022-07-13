Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D355739CB
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 17:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiGMPND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 11:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiGMPNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 11:13:02 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E389D422DE;
        Wed, 13 Jul 2022 08:13:01 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id a5so15935366wrx.12;
        Wed, 13 Jul 2022 08:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4vzuaiK89mNNh/nwqD4oUWzJWJJr65XkB3GW5Tnocj4=;
        b=UA0PoymRNkksCuxZWYAv/ZRkiyikwrb59uXLO7ECaQLMB75pVwdcP2Uwhr1Co8/MnK
         W5w97d5R8xPf3p8tzs6fSD8viPNDRAzsxFYoFd9YjkxqIhbRXPLbQ8b3WhcNChdzf4p3
         pHEAXIJtgHtPainiVhY4g9c2vgyY05cnc6WxXkFKPIAn3qjtjBcG2ohku7ygBfyFpwFr
         nQ72aRqjTyHvPCcltm8n4nZ5ZDaHiJ3pdrx9hVX7cAxSec6/SurU9YLyQ6CGsVTur1yy
         mzwywtFzYg1mbtlwkiDlvmeD3RxhRF7/PvHYlBNHwpo+QgToy7VUhl3Yczi7ad/Dm8xX
         7yMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4vzuaiK89mNNh/nwqD4oUWzJWJJr65XkB3GW5Tnocj4=;
        b=8QPJQgVfRIFPzftclexpLKqDh4EGFWZg3ML3JZuPVbc3vPbMUGqcBINLskkZt35ZSH
         FoaEfxW/sBWitGQmfOvPPKHcHGIytMeJxdmr/sQi7iop0djQoBS6MZIi+3ncGI+qqaA0
         ENcSjqiE7t11XgUv5LN5jwpBKso4xgx37mxxLGQQWzRGS2x9kaCDYK2Tj8HcGyVo1okb
         q4SqtnhBHZfLImsSJEOToGIcnHhepFYUQh5rsp2B3aml827AASlsUJzlFVXe3rcYl3GX
         qySEl19Z5YrQSkCGbbHuEk3F6Zo4GxOKKtjDxCHGH3KCfTORkS8r+A+hC4Ycg4eglYY1
         H+0Q==
X-Gm-Message-State: AJIora8ItCB6B0eEVIZ2r6h7VAZrsWhZMqjotvlvkWUN0x9pK9K8cM3d
        jkmghJkcxV1N1ODXKFLlKZTegicf5eKyyeNE1k8=
X-Google-Smtp-Source: AGRyM1u1dYq++U5gRPxzwe9IKoYGV8+QeF4OBIj+0JqXO9OtXN3I1de0ITCObBR+9R6nUhHbJ0essZ0XTlKd+H3HHvg=
X-Received: by 2002:a5d:5703:0:b0:21d:6c55:4986 with SMTP id
 a3-20020a5d5703000000b0021d6c554986mr3770543wrv.455.1657725180321; Wed, 13
 Jul 2022 08:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220713150143.147537-1-mlombard@redhat.com>
In-Reply-To: <20220713150143.147537-1-mlombard@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 13 Jul 2022 08:12:49 -0700
Message-ID: <CAKgT0Uet==0v3bFV8KcnXLxB9BoC8qyMRkeH-X5sfWE7Bm7ikg@mail.gmail.com>
Subject: Re: [PATCH V2] mm: prevent page_frag_alloc() from corrupting the memory
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Chen Lin <chen45464546@163.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 8:01 AM Maurizio Lombardi <mlombard@redhat.com> wrote:
>
> A number of drivers call page_frag_alloc() with a
> fragment's size > PAGE_SIZE.
> In low memory conditions, __page_frag_cache_refill() may fail the order 3
> cache allocation and fall back to order 0;
> In this case, the cache will be smaller than the fragment, causing
> memory corruptions.
>
> Prevent this from happening by checking if the newly allocated cache
> is large enough for the fragment; if not, the allocation will fail
> and page_frag_alloc() will return NULL.
>
> V2: do not free the cache page because this could make memory pressure
> even worse, just return NULL.
>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  mm/page_alloc.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e008a3df0485..b1407254a826 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5617,6 +5617,8 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
>                 /* reset page count bias and offset to start of new frag */
>                 nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
>                 offset = size - fragsz;
> +               if (unlikely(offset < 0))
> +                       return NULL;
>         }
>
>         nc->pagecnt_bias--;

This works for me. If I am not mistaken it should be only adding one
conditional jump that isn't taken to the fast path based on a
calculation we were already doing.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
