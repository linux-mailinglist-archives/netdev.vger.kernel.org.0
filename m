Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE94634A53
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbiKVWzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbiKVWzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:55:19 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32B9DD3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:55:09 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-39ce6773248so88761527b3.12
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vgVj81TaAJFPaup6fEizR2CqkCcmP7+hjUnyLuec4+o=;
        b=RuJwiWKaa2cOkX9/h/pterDKBIAJDyCMl3Gr2uokUaHiSgUYf21FBwhwfxGjFmEaux
         DBrN6a5QhNaok28H5BUN4BDVZPpvBg2kKMmzDbJkI3dN14ygAuhbKzSGa7RHQSIYVb6J
         M26ETl80wMn5iENf8wxbk0Q+FoFB6tTXpvTjNWzl5v1R5ed7nRKbE/JX3ORhTe5mVAJX
         FM9+59F9ZllVPLSRCp4yncMNAebZy8+1gwc+2Hg99EJhj9XIegPAVWMNOhNhYbwjRzXm
         vci4H/4bdTkf3ixODqhpo65YzIV0aiMt9txB6cEo61dfu7HSU17O1o0AqK/FzDJa+1eI
         sxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vgVj81TaAJFPaup6fEizR2CqkCcmP7+hjUnyLuec4+o=;
        b=Zj+Ngq4+69ol9vpY907C/BM/dbQpv/lT+bSzEzFtbRTD3tycgxlWahHgh3l/P2YRpL
         SIMCukyg9JlKvvoT4Q2C04lJPwTG/OGWvtSO4vpI/3C+IsnW6GXEmBv0EutrlFRENWYT
         1AwkqmHBNZ1cemdp+xeOcydu4gqaw3N0S7zsGUe+mkpxXn6ulhZBn37aeTSLDg7pY8Ha
         /KDiP8uhmWYwRgy9ZLreMrNOROF6Gl8jX49TtfQeJMLD6mNZ70btj7/at4j1SwRJkaEM
         qSdgR/SrNyqziuqetkKJGG1ry7G7GEIByDbd4qnQGG9AyVS1Bz/D8e5+P8+AsF8Bb7Z5
         GP2Q==
X-Gm-Message-State: ANoB5pmN0xN/aYECCxux5wq9PH7v1gARPhss0Y2KSFe5X4xlbqPqZaIp
        /1aj5KOpT2VbTzAu2NAu1bbl2vc3use6HYHb27Jmsw==
X-Google-Smtp-Source: AA0mqf5lWYRbouY3wvSyTTHF5VwEyw1ykqzKm2VlVp0D1XBZHCXBRTzTAdT5ZyzQLfVztmPc7a+6n8h/U/Z8cXwlc/M=
X-Received: by 2002:a81:5f04:0:b0:393:ab0b:5a31 with SMTP id
 t4-20020a815f04000000b00393ab0b5a31mr22706109ywb.55.1669157708673; Tue, 22
 Nov 2022 14:55:08 -0800 (PST)
MIME-Version: 1.0
References: <20221112040452.644234-1-edumazet@google.com> <Y30gZm0mO4YNO85d@localhost.localdomain>
In-Reply-To: <Y30gZm0mO4YNO85d@localhost.localdomain>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 22 Nov 2022 14:54:57 -0800
Message-ID: <CANn89iL-hGPeaTzCibdaOoquAQYNYa8Fu337tqu98xyoZWarOQ@mail.gmail.com>
Subject: Re: [PATCH -next] iommu/dma: avoid expensive indirect calls for sync operations
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        iommu@lists.linux.dev, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com
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

On Tue, Nov 22, 2022 at 11:18 AM Michal Kubiak <michal.kubiak@intel.com> wrote:
>
> On Sat, Nov 12, 2022 at 04:04:52AM +0000, Eric Dumazet wrote:
> > Quite often, NIC devices do not need dma_sync operations
> > on x86_64 at least.
> >
> > Indeed, when dev_is_dma_coherent(dev) is true and
> > dev_use_swiotlb(dev) is false, iommu_dma_sync_single_for_cpu()
> > and friends do nothing.
> >
> > However, indirectly calling them when CONFIG_RETPOLINE=y
> > consumes about 10% of cycles on a cpu receiving packets
> > from softirq at ~100Gbit rate, as shown in [1]
> >
> > Even if/when CONFIG_RETPOLINE is not set, there
> > is a cost of about 3%.
> >
> > This patch adds a copy of iommu_dma_ops structure,
> > where sync_single_for_cpu, sync_single_for_device,
> > sync_sg_for_cpu and sync_sg_for_device are unset.
>
>
> Larysa from our team has found out this patch introduces also a
> functional improvement for batch allocation in AF_XDP while iommmu is
> turned on.
> In 'xp_alloc_batch()' function there is a check if DMA needs a
> synchronization. If so, batch allocation is not supported and we can
> allocate only one buffer at a time.
>
> The flag 'dma_need_sync' is being set according to the value returned by
> the function 'dma_need_sync()' (from '/kernel/dma/mapping.c').
> That function only checks if at least one of two DMA ops is defined:
> 'ops->sync_single_for_cpu' or 'ops->sync_single_for_device'.
>
> > +static const struct dma_map_ops iommu_nosync_dma_ops = {
> > +     iommu_dma_ops_common_fields
> > +
> > +     .sync_single_for_cpu    = NULL,
> > +     .sync_single_for_device = NULL,
> > +     .sync_sg_for_cpu        = NULL,
> > +     .sync_sg_for_device     = NULL,
> > +};
> > +#undef iommu_dma_ops_common_fields
> > +
> >  /*
> >   * The IOMMU core code allocates the default DMA domain, which the underlying
> >   * IOMMU driver needs to support via the dma-iommu layer.
> > @@ -1586,7 +1612,8 @@ void iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 dma_limit)
> >       if (iommu_is_dma_domain(domain)) {
> >               if (iommu_dma_init_domain(domain, dma_base, dma_limit, dev))
> >                       goto out_err;
> > -             dev->dma_ops = &iommu_dma_ops;
> > +             dev->dma_ops = dev_is_dma_sync_needed(dev) ?
> > +                             &iommu_dma_ops : &iommu_nosync_dma_ops;
> >       }
> >
> >       return;
>
>  This code removes defining 'sync_*' DMA ops if they are not actually
>  used. Thanks to that improvement the function 'dma_need_sync()' will
>  always return more meaningful information if any DMA synchronization is
>  actually needed for iommu.
>
>  Together with Larysa we have applied that patch and we can confirm it
>  helps for batch buffer allocation in AF_XDP ('xsk_buff_alloc_batch()'
>  call) when iommu is enabled.

Thanks for testing !

I am quite busy relocating, I will address Christoph feedback next week.
