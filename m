Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850C84E7153
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 11:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358891AbiCYKf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 06:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237250AbiCYKfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 06:35:54 -0400
X-Greylist: delayed 530 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Mar 2022 03:34:17 PDT
Received: from ns.iliad.fr (ns.iliad.fr [212.27.33.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2479A88B1;
        Fri, 25 Mar 2022 03:34:17 -0700 (PDT)
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id 498C720383;
        Fri, 25 Mar 2022 11:25:25 +0100 (CET)
Received: from sakura (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id 3BA7320338;
        Fri, 25 Mar 2022 11:25:25 +0100 (CET)
Message-ID: <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
From:   Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Date:   Fri, 25 Mar 2022 11:25:25 +0100
In-Reply-To: <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
         <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
         <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
         <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
         <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
         <20220324163132.GB26098@lst.de>
         <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
         <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
Organization: Freebox
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Fri Mar 25 11:25:25 2022 +0100 (CET)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 2022-03-24 at 12:26 -0700, Linus Torvalds wrote:

> 
> It's actually very natural in that situation to flush the caches from
> the CPU side again. And so dma_sync_single_for_device() is a fairly
> reasonable thing to do in that situation.
> 

In the non-cache-coherent scenario, and assuming dma_map() did an
initial cache invalidation, you can write this:

rx_buffer_complete_1(buf)
{
	invalidate_cache(buf, size)
	if (!is_ready(buf))
		return;
	<proceed with receive>
}

or 

rx_buffer_complete_2(buf)
{
	if (!is_ready(buf)) {
		invalidate_cache(buf, size)
		return;
	}
	<proceed with receive>
}

The latter is preferred for performance because dma_map() did the
initial invalidate.

Of course you could write:

rx_buffer_complete_3(buf)
{
	invalidate_cache(buf, size)
	if
(!is_ready(buf)) {
		invalidate_cache(buf, size)
		return;
	}
	
<proceed with receive>
}


but it's a waste of CPU cycles

So I'd be very cautious assuming sync_for_cpu() and sync_for_device()
are both doing invalidation in existing implementation of arch DMA ops,
implementers may have taken some liberty around DMA-API to avoid
unnecessary cache operation (not to blame them).


For example looking at arch/arm/mm/dma-mapping.c, for DMA_FROM_DEVICE

sync_single_for_device()
  => __dma_page_cpu_to_dev()
    => dma_cache_maint_page(op=dmac_map_area)
      => cpu_cache.dma_map_area()

sync_single_for_cpu()
  => __dma_page_dev_to_cpu()
    =>
__dma_page_cpu_to_dev(op=dmac_unmap_area)
      =>
cpu_cache.dma_unmap_area()

dma_map_area() always does cache invalidate.

But for a couple of CPU variant, dma_unmap_area() is a noop, so
sync_for_cpu() does nothing.

Toke's patch will break ath9k on those platforms (mostly silent
breakage, rx corruption leading to bad performance)


> There's a fair number of those dma_sync_single_for_device() things
> all over. Could we find mis-uses and warn about them some way? It
> seems to be a very natural thing to do in this context, but bounce
> buffering does make them very fragile.

At least in network drivers, there are at least two patterns:

1) The issue at hand, hardware mixing rx_status and data inside the
same area. Usually very old hardware, very quick grep in network
drivers only revealed slicoss.c. Probably would have gone unnoticed if
ath9k hardware wasn't so common.


2) The very common "copy break" pattern. If a received packet is
smaller than a certain threshold, the driver rx path is changed to do:

 sync_for_cpu()
 alloc_small_skb()
 memcpy(small_skb, rx_buffer_data)
 sync_for_device()

Original skb is left in the hardware, this reduces memory wasted.

This pattern is completely valid wrt DMA-API, the buffer is always
either owned by CPU or device.


-- 
Maxime



