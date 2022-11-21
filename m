Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA74631E3B
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 11:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiKUKYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 05:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiKUKYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 05:24:45 -0500
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FB820F66
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 02:24:44 -0800 (PST)
Received: by mail-qk1-f172.google.com with SMTP id s20so7682379qkg.5
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 02:24:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tuz4GXSuMABf7djgSVIWhgWtMsICfYMb1in6u5g4o1Y=;
        b=RD2+Q6ttYuomYwS2aqwU3NLD9InKsr7zv7HnUtEy7wmemF3jhJdUMRudzlqOrNRTsz
         71OEhKoud0jnfxvMgc4VMptv+ysIdlS04trZh0eouUVpt8+a5nqUoJAVy1bVRnXUCVjc
         Kazs7klHYL8aaHNafK+3rpTWHHPSr15PkV8lean1wvUZWjhfq+2jbbKj2EVjZ8DYlgEe
         gtfPtdUeGZCKLMU8WOi5fuOGqQPeuOkvOqAecTw1q7wAxdltUzQsj8r6AhbXB8oYdGFb
         fbZXA4K7DrseDFtIkarrVe7sPSD9/ZiVkH3i/xSLiQU3ai33lSSbGY3xoqMQ3K1V4AKe
         sR5w==
X-Gm-Message-State: ANoB5pkLTxyUJS9ueCITcVaFmVjU3jdOXI9HKGVpFADsT7ZXfg00h0ha
        UgqsTV2CpTw5RAHGOfTEFn+LTO5tsXk4nw==
X-Google-Smtp-Source: AA0mqf5lhtfta+xinzEQ3RZfTomsgA0x3s2TmSkphccriFBwYMWhkvVHcI6g1yvyzk/En3vNLAnIPA==
X-Received: by 2002:a37:b901:0:b0:6ec:2b04:5099 with SMTP id j1-20020a37b901000000b006ec2b045099mr1660098qkf.501.1669026283135;
        Mon, 21 Nov 2022 02:24:43 -0800 (PST)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id bq40-20020a05620a46a800b006fb7c42e73asm7938643qkb.21.2022.11.21.02.24.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 02:24:41 -0800 (PST)
Received: by mail-yb1-f177.google.com with SMTP id n189so617396yba.8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 02:24:40 -0800 (PST)
X-Received: by 2002:a25:ad8b:0:b0:6de:6c43:3991 with SMTP id
 z11-20020a25ad8b000000b006de6c433991mr15252917ybi.604.1669026280531; Mon, 21
 Nov 2022 02:24:40 -0800 (PST)
MIME-Version: 1.0
References: <20221121095631.216209-1-hch@lst.de> <20221121095631.216209-2-hch@lst.de>
In-Reply-To: <20221121095631.216209-2-hch@lst.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 21 Nov 2022 11:24:29 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVWjDYEAXqWuYYEOb=C-phYjS7wYNPSyZYweR0WhzSZ+A@mail.gmail.com>
Message-ID: <CAMuHMdVWjDYEAXqWuYYEOb=C-phYjS7wYNPSyZYweR0WhzSZ+A@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: fec: use dma_alloc_noncoherent for m532x
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Ungerer <gerg@linux-m68k.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-m68k@lists.linux-m68k.org, uclinux-dev@uclinux.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On Mon, Nov 21, 2022 at 10:56 AM Christoph Hellwig <hch@lst.de> wrote:
> The m532x coldfire platforms can't properly implement dma_alloc_coherent
> and currently just return noncoherent memory from it.  The fec driver
> than works around this with a flush of all caches in the receive path.
> Make this hack a little less bad by using the explicit
> dma_alloc_noncoherent API and documenting the hacky cache flushes.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for your patch!

> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1580,6 +1580,10 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>         struct page *page;
>
>  #ifdef CONFIG_M532x
> +       /*
> +        * Hacky flush of all caches instead of using the DMA API for the TSO
> +        * headers.
> +        */
>         flush_cache_all();
>  #endif
>         rxq = fep->rx_queue[queue_id];
> @@ -3123,10 +3127,17 @@ static void fec_enet_free_queue(struct net_device *ndev)
>         for (i = 0; i < fep->num_tx_queues; i++)
>                 if (fep->tx_queue[i] && fep->tx_queue[i]->tso_hdrs) {
>                         txq = fep->tx_queue[i];
> +#ifdef CONFIG_M532x

Shouldn't this be the !CONFIG_M532x path?

>                         dma_free_coherent(&fep->pdev->dev,
>                                           txq->bd.ring_size * TSO_HEADER_SIZE,
>                                           txq->tso_hdrs,
>                                           txq->tso_hdrs_dma);
> +#else
> +                       dma_free_noncoherent(&fep->pdev->dev,
> +                                         txq->bd.ring_size * TSO_HEADER_SIZE,
> +                                         txq->tso_hdrs, txq->tso_hdrs_dma,
> +                                         DMA_BIDIRECTIONAL);
> +#endif
>                 }
>
>         for (i = 0; i < fep->num_rx_queues; i++)
> @@ -3157,10 +3168,18 @@ static int fec_enet_alloc_queue(struct net_device *ndev)
>                 txq->tx_wake_threshold =
>                         (txq->bd.ring_size - txq->tx_stop_threshold) / 2;
>
> +#ifdef CONFIG_M532x

Likewise

>                 txq->tso_hdrs = dma_alloc_coherent(&fep->pdev->dev,
>                                         txq->bd.ring_size * TSO_HEADER_SIZE,
>                                         &txq->tso_hdrs_dma,
>                                         GFP_KERNEL);
> +#else
> +               /* m68knommu manually flushes all caches in fec_enet_rx_queue */
> +               txq->tso_hdrs = dma_alloc_noncoherent(&fep->pdev->dev,
> +                                       txq->bd.ring_size * TSO_HEADER_SIZE,
> +                                       &txq->tso_hdrs_dma, DMA_BIDIRECTIONAL,
> +                                       GFP_KERNEL);
> +#endif
>                 if (!txq->tso_hdrs) {
>                         ret = -ENOMEM;
>                         goto alloc_failed;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
