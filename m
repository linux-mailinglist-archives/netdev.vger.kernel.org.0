Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C1755DE50
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243934AbiF1Hsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 03:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243058AbiF1HrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 03:47:24 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB2A393;
        Tue, 28 Jun 2022 00:47:23 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g20-20020a17090a579400b001ed52939d72so6357013pji.4;
        Tue, 28 Jun 2022 00:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2ksIIskBw2Ba8fG6PLP066/IQFUnSATGlOiAhq4Wz6g=;
        b=ihFYpfFS8d6iJ2BV7LsKrSmaDFX/g69vCGo1x2oSR8/wmtfo6fxfMMYR0bxhc6fIw0
         WGA/putgNHdRpGSTxz7GdsuNVs7Rf7KLBFPGCUVbIv1xXoE0H6pjOpxtLnx5QvRF1UvH
         gI/S2VkUVzaCahnqFLm39oicCvBQckGeaspWAF5wqIwvYnA2WzRfVAL3Rtr8EmSSqCXS
         jHbOR/6aBc08MLxm5/thxsWstzTfGddSseEn0MehzdeW8eM3Mk95xW8mm2upYycqfFgT
         8ts+t7H/OwnPWudq52iwoMTuGo3yRuv+idiBn8/aIVqu0BkG55SW+ar2q1lHdv+JNiwj
         /bjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2ksIIskBw2Ba8fG6PLP066/IQFUnSATGlOiAhq4Wz6g=;
        b=LB8Us1SW+jkb2yobdESqPpYXh6WeeCX6ejbToPozC4U7kiYN0hcUvcyG/MwbnsBFf7
         nqfD3JnIDkhQ3lLlqWwyStUnmfvOy7RC3I3Qw3NgapeR8qbaHu8OpqPOb+49Qf1/EMoS
         e53uEqfun/hVQDBaL8jEqmrSLDAapFtv42GGskWtHuLI3e8RafPhoFz5xxBy1rML6+ql
         GHfhtYqHMSchpix5ETilR1tnurl923OGgbmPeeY37yCsONd7hEfKe/ZjdZI4/+/pr7XO
         GVSeb8wWHc+Mom9cAd5SYkhUAjt3vZU6ksaCQyFwR3zkYkFENf17I1Yvzdwd0rjIG4Tl
         KB6g==
X-Gm-Message-State: AJIora+iiXope+pwGnDuLEz+Wf0o3Yehv5KmZL9BhNfNbko1SA9HBRQO
        w0+1oeh1tJeK46I3xRWfWC3QauTnftnlr0bWSY30Y5RlEX8Zsb0x
X-Google-Smtp-Source: AGRyM1tfbhrWRuWpNYKQ03g2t4onqMKMSYhyD8nIEgluUdUVAr0LVkkndOKQCV2/HktBaPmG0Za5N+AEfqrhU7SgQGA=
X-Received: by 2002:a17:902:d701:b0:16a:2206:9ba8 with SMTP id
 w1-20020a170902d70100b0016a22069ba8mr2377741ply.168.1656402442810; Tue, 28
 Jun 2022 00:47:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220627190120.176470-1-ivan.malov@oktetlabs.ru> <20220628001752.17586-1-ivan.malov@oktetlabs.ru>
In-Reply-To: <20220628001752.17586-1-ivan.malov@oktetlabs.ru>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 28 Jun 2022 09:47:11 +0200
Message-ID: <CAJ8uoz2Gcs+oYorgHofz=0ZOznNoKS8hdyOK=rWwhRtYXO=RHw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] xsk: clear page contiguity bit when unmapping pool
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

On Tue, Jun 28, 2022 at 2:18 AM Ivan Malov <ivan.malov@oktetlabs.ru> wrote:
>
> When a XSK pool gets mapped, xp_check_dma_contiguity() adds bit 0x1
> to pages' DMA addresses that go in ascending order and at 4K stride.
> The problem is that the bit does not get cleared before doing unmap.
> As a result, a lot of warnings from iommu_dma_unmap_page() are seen
> suggesting mapping lookup failures at drivers/iommu/dma-iommu.c:848.

Thanks Ivan for spotting this. Please add if this patch is for bpf or
net in your subject line. E.g., [PATCH net].

Also, I cannot find a warning at drivers/iommu/dma-iommu.c:848. For
net and bpf I have a WARN() at line 679 in __iommu_dma_unmap(). Maybe
it would be better to just refer to __iommu_dma_unmap() and the
warning in that function. Line numbers tend to change.

> Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
> Signed-off-by: Ivan Malov <ivan.malov@oktetlabs.ru>
> ---
>  v1 -> v2: minor adjustments to dispose of the "Fixes:" tag warning
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
