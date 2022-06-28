Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7944355C250
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344235AbiF1J3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 05:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiF1J3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 05:29:31 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618B71D0CD;
        Tue, 28 Jun 2022 02:29:30 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h192so11666342pgc.4;
        Tue, 28 Jun 2022 02:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ku8sd/FmFey6xKarUDMB6w/xJb9wzEr7gAs97eZl/hI=;
        b=Sg5I5qeAHEbBNVIwQ8GW+1Lg5cofwvSFHKsn4iCzm/h3Gs/B947Vn5Qkf3Nabhcf9C
         LndBu7crlL33EqM6Dvmx8M5I+R478dWgFyeAP+6f3IwW23LsB5pZdKkMljGRAl+dNy9k
         8iM0dZGSG3/ykpqVqwfKt3s0twdzikH1xfVjTsJB9qF+ina9hdA8cB7hCmwE8Syhq+S1
         JAhfFtS9VCIkZNKxIIDIoeiY7jGWlp3PgJ+WOO7xaftX3Pf1yjhIetFZqVAn180bSl21
         1Rgly7dZmF3Q8d9sXYSDzpJSHLUd5gLL2V9jIFltWWWX+FBwbkodlFytbsfR9MiJxDNO
         Ov9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ku8sd/FmFey6xKarUDMB6w/xJb9wzEr7gAs97eZl/hI=;
        b=oma7AL8Ky/ntYG2OpVQdD8dT13h0442BjxBMgmsoyMQ5ICzwRLN8e2F6btDiItwikx
         CkCUbrj/1kqJTohrTDK9s/4EbgZuhVfoUytDwrQczzjWkmWPXnJ7g3kmrukxJ3ntjQrV
         lJ9UG3WFPbIo3wooVtzhI6oLgSiagIwOvae/eRERataj3XQ18koEW/rMSG2kqGhiaLOh
         o+dPtFAoil5OAvHxzdDYTNqY8r97VtaBRbStYRZhHS50OQK0ZmbgbBUwpqWkXo3m1vwn
         YhoaYglP29E3R23CT0M4iCIjN7MdmgA+nrjAt7xc+kJOl3nR+XX1LKp74aV9XIyosMy2
         kXtA==
X-Gm-Message-State: AJIora9OtkbmwpXauRyPtnoZN3ltnPFAKAvLj6lMYibgptqF0GRjknC1
        kQVhYN3Gm/FkHx6D5lYTk1+NECHSxXNacwKldCgOQRRnO84U/ikUhTA=
X-Google-Smtp-Source: AGRyM1vLajzsdi2GOUxKhlu9g05WKIu5y1ew/paqtLSpjsXmu6YWvKEquvngE9FPA4JtJ8098MvcKtjeyYdoH7act1s=
X-Received: by 2002:a05:6a00:811:b0:525:50c2:4c2f with SMTP id
 m17-20020a056a00081100b0052550c24c2fmr3860004pfk.62.1656408569807; Tue, 28
 Jun 2022 02:29:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220627190120.176470-1-ivan.malov@oktetlabs.ru> <20220628091848.534803-1-ivan.malov@oktetlabs.ru>
In-Reply-To: <20220628091848.534803-1-ivan.malov@oktetlabs.ru>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 28 Jun 2022 11:29:18 +0200
Message-ID: <CAJ8uoz1Ha=aOfF8+ttJLcU3nyCJBpUUyKk27rzKbPGx10oD6qQ@mail.gmail.com>
Subject: Re: [PATCH net v3 1/1] xsk: clear page contiguity bit when unmapping pool
To:     Ivan Malov <ivan.malov@oktetlabs.ru>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Rybchenko <andrew.rybchenko@oktetlabs.ru>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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
        Maxim Mikityanskiy <maximmi@mellanox.com>
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

On Tue, Jun 28, 2022 at 11:25 AM Ivan Malov <ivan.malov@oktetlabs.ru> wrote:
>
> When a XSK pool gets mapped, xp_check_dma_contiguity() adds bit 0x1
> to pages' DMA addresses that go in ascending order and at 4K stride.
> The problem is that the bit does not get cleared before doing unmap.
> As a result, a lot of warnings from iommu_dma_unmap_page() are seen
> in dmesg, which indicates that lookups by iommu_iova_to_phys() fail.
>
> Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
> Signed-off-by: Ivan Malov <ivan.malov@oktetlabs.ru>

Thanks Ivan.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> ---
>  v1 -> v2: minor adjustments to dispose of the "Fixes:" tag warning
>  v2 -> v3: extra refinements to apply notes from Magnus Karlsson
>
>  net/xdp/xsk_buff_pool.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 87bdd71c7bb6..f70112176b7c 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -332,6 +332,7 @@ static void __xp_dma_unmap(struct xsk_dma_map *dma_map, unsigned long attrs)
>         for (i = 0; i < dma_map->dma_pages_cnt; i++) {
>                 dma = &dma_map->dma_pages[i];
>                 if (*dma) {
> +                       *dma &= ~XSK_NEXT_PG_CONTIG_MASK;
>                         dma_unmap_page_attrs(dma_map->dev, *dma, PAGE_SIZE,
>                                              DMA_BIDIRECTIONAL, attrs);
>                         *dma = 0;
> --
> 2.30.2
>
