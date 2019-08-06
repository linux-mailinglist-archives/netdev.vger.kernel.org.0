Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2288C839F4
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 22:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfHFUA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 16:00:58 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34186 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfHFUA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 16:00:58 -0400
Received: by mail-ot1-f68.google.com with SMTP id n5so95691125otk.1;
        Tue, 06 Aug 2019 13:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VaOMR+SUZElYH0Eetic8a/+Hs8jgmt9NIHaGtBcxFPM=;
        b=TngasMsK4VNmxfirXQoozUrNZixTJrh5h2kC3Fa/ZBpmNydnUMizu+QaNDXrbPORqA
         LUcxKGR2kGLPUVCAG+ujMbZlMdv+IqWR9ra+m7iTJ+AfMC++Y8R1xruk5J8HBma3OVeD
         271cMVDklGhu0DXNyPhReNS4Glv9BEMFIaN627Isa45aEM8M/7FYQLApxbPd9oAnUBsi
         +jSt8X2b5XtoADey3XpzbHQ8I/uqgwx1UQszsKkhViGmHE+noAbMvXvgz0Hlxq3sflXD
         a5q/tYKeEbtB+ocWno6jFcyYfWsM3YCcfNsKZjEyssRSg0lno7aji39ysG0kykKk8pNV
         foHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VaOMR+SUZElYH0Eetic8a/+Hs8jgmt9NIHaGtBcxFPM=;
        b=d6x9tKU8H+85I5DoxKfkK/VswvlFTmxDLOnleMKDLvOQV+bUZHKX/i0F2KOG7ae5dt
         vkaNWkXBlB0sAjAU+8ksiiFFF6sWeXuDg4rdXCVch3DFUEjYQq4RFQoh7L6Dx3UKg6lr
         m44U8eAy51xqXbFvp5idVB+fbawZF8nEXrckKwjsHZU1pcoHKbZKNZVeC0W0/HU+Fc51
         Zlk2KJpE2fk8YJdayFGpP3lMlonkbSzWjL4uAfOsazkX7og/MQLgi9fmZO8hEWoAuuBa
         z8/y1M+WJ0x4SlN0CV/fFe50eihRFWwaWxJC612efekceBGFjbs0cG8L2CphApNENjz1
         kpWw==
X-Gm-Message-State: APjAAAVcONRrLNEHmIhVUPCi98B7ddfhwzwdjkeiYclWQIXhGWV1tgdX
        rRw0zMpUpzc6rLCLJVVS7H1vCNszKXHLhhsJYPy7xadcGhw=
X-Google-Smtp-Source: APXvYqx+MC/6Cl1pEL3O2XLiSNXCdL35U9JI3kpbwQNG/AkZ6DUYfCMIFGJfMWultA7dg8cGYp72TdjyMGK15LDUL3o=
X-Received: by 2002:a6b:dd18:: with SMTP id f24mr5102882ioc.97.1565121656651;
 Tue, 06 Aug 2019 13:00:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190806092919.13211-1-firo.yang@suse.com>
In-Reply-To: <20190806092919.13211-1-firo.yang@suse.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 6 Aug 2019 13:00:45 -0700
Message-ID: <CAKgT0UdFky-tnyhn_oXGefex=9FN5ckAJ0YYd2Z7STZg1V48Hg@mail.gmail.com>
Subject: Re: [PATCH 1/1] ixgbe: sync the first fragment unconditionally
To:     Firo Yang <firo.yang@suse.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 2:38 AM Firo Yang <firo.yang@suse.com> wrote:
>
> In Xen environment, if Xen-swiotlb is enabled, ixgbe driver
> could possibly allocate a page, DMA memory buffer, for the first
> fragment which is not suitable for Xen-swiotlb to do DMA operations.
> Xen-swiotlb will internally allocate another page for doing DMA
> operations. It requires syncing between those two pages. Otherwise,
> we may get an incomplete skb. To fix this problem, sync the first
> fragment no matter the first fargment is makred as "page_released"
> or not.
>
> Signed-off-by: Firo Yang <firo.yang@suse.com>

From what I can tell the code below is fine. However the patch
description isn't very clear about the issue.

Specifically since we are mapping the frame with
DMA_ATTR_SKIP_CPU_SYNC we have to unmap with that as well. As a result
a sync is not performed on an unmap and must be done manually as we
skipped it for the first frag. As such we need to always sync before
possibly performing a page unmap operation.

Also you can probably add the following to your patch description"
Fixes: f3213d932173 ("ixgbe: Update driver to make use of DMA
attributes in Rx path")
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index cbaf712d6529..200de9838096 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -1825,13 +1825,7 @@ static void ixgbe_pull_tail(struct ixgbe_ring *rx_ring,
>  static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
>                                 struct sk_buff *skb)
>  {
> -       /* if the page was released unmap it, else just sync our portion */
> -       if (unlikely(IXGBE_CB(skb)->page_released)) {
> -               dma_unmap_page_attrs(rx_ring->dev, IXGBE_CB(skb)->dma,
> -                                    ixgbe_rx_pg_size(rx_ring),
> -                                    DMA_FROM_DEVICE,
> -                                    IXGBE_RX_DMA_ATTR);
> -       } else if (ring_uses_build_skb(rx_ring)) {
> +       if (ring_uses_build_skb(rx_ring)) {
>                 unsigned long offset = (unsigned long)(skb->data) & ~PAGE_MASK;
>
>                 dma_sync_single_range_for_cpu(rx_ring->dev,
> @@ -1848,6 +1842,14 @@ static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
>                                               skb_frag_size(frag),
>                                               DMA_FROM_DEVICE);
>         }
> +
> +       /* If the page was released, just unmap it. */
> +       if (unlikely(IXGBE_CB(skb)->page_released)) {
> +               dma_unmap_page_attrs(rx_ring->dev, IXGBE_CB(skb)->dma,
> +                                    ixgbe_rx_pg_size(rx_ring),
> +                                    DMA_FROM_DEVICE,
> +                                    IXGBE_RX_DMA_ATTR);
> +       }
>  }
>
>  /**
> --
> 2.16.4
>
