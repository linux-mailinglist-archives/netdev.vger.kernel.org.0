Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF844E7226
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 12:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355909AbiCYL3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 07:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238578AbiCYL3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 07:29:23 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64335A5EBC;
        Fri, 25 Mar 2022 04:27:48 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EEFB12FC;
        Fri, 25 Mar 2022 04:27:48 -0700 (PDT)
Received: from [10.57.41.19] (unknown [10.57.41.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B7E03F73B;
        Fri, 25 Mar 2022 04:27:45 -0700 (PDT)
Message-ID: <cce202fb-5185-aa3e-9e9b-11626192cb49@arm.com>
Date:   Fri, 25 Mar 2022 11:27:41 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Content-Language: en-GB
To:     mbizon@freebox.fr, Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
Cc:     Netdev <netdev@vger.kernel.org>, Kalle Valo <kvalo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Halil Pasic <pasic@linux.ibm.com>,
        iommu <iommu@lists.linux-foundation.org>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1812355.tdWV9SEqCh@natalenko.name>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de>
 <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
 <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-25 10:25, Maxime Bizon wrote:
> 
> On Thu, 2022-03-24 at 12:26 -0700, Linus Torvalds wrote:
> 
>>
>> It's actually very natural in that situation to flush the caches from
>> the CPU side again. And so dma_sync_single_for_device() is a fairly
>> reasonable thing to do in that situation.
>>
> 
> In the non-cache-coherent scenario, and assuming dma_map() did an
> initial cache invalidation, you can write this:
> 
> rx_buffer_complete_1(buf)
> {
> 	invalidate_cache(buf, size)
> 	if (!is_ready(buf))
> 		return;
> 	<proceed with receive>
> }
> 
> or
> 
> rx_buffer_complete_2(buf)
> {
> 	if (!is_ready(buf)) {
> 		invalidate_cache(buf, size)
> 		return;
> 	}
> 	<proceed with receive>
> }
> 
> The latter is preferred for performance because dma_map() did the
> initial invalidate.
> 
> Of course you could write:
> 
> rx_buffer_complete_3(buf)
> {
> 	invalidate_cache(buf, size)
> 	if
> (!is_ready(buf)) {
> 		invalidate_cache(buf, size)
> 		return;
> 	}
> 	
> <proceed with receive>
> }
> 
> 
> but it's a waste of CPU cycles
> 
> So I'd be very cautious assuming sync_for_cpu() and sync_for_device()
> are both doing invalidation in existing implementation of arch DMA ops,
> implementers may have taken some liberty around DMA-API to avoid
> unnecessary cache operation (not to blame them).

Right, if you have speculatively-prefetching caches, you have to 
invalidate DMA_FROM_DEVICE in unmap/sync_for_cpu, since a cache may have 
pulled in a snapshot of partly-written data at any point beforehand. But 
if you don't, then you can simply invalidate up-front in 
map/sync_for_device to tie in with the other directions, and trust that 
it stays that way for the duration.

What muddies the waters a bit is that the opposite combination 
sync_for_cpu(DMA_TO_DEVICE) really *should* always be a no-op, and I for 
one have already made the case for eliding that in code elsewhere, but 
it doesn't necessarily hold for the inverse here, hence why I'm not sure 
there even is a robust common solution for peeking at a live 
DMA_FROM_DEVICE buffer.

Robin.

> For example looking at arch/arm/mm/dma-mapping.c, for DMA_FROM_DEVICE
> 
> sync_single_for_device()
>    => __dma_page_cpu_to_dev()
>      => dma_cache_maint_page(op=dmac_map_area)
>        => cpu_cache.dma_map_area()
> 
> sync_single_for_cpu()
>    => __dma_page_dev_to_cpu()
>      =>
> __dma_page_cpu_to_dev(op=dmac_unmap_area)
>        =>
> cpu_cache.dma_unmap_area()
> 
> dma_map_area() always does cache invalidate.
> 
> But for a couple of CPU variant, dma_unmap_area() is a noop, so
> sync_for_cpu() does nothing.
> 
> Toke's patch will break ath9k on those platforms (mostly silent
> breakage, rx corruption leading to bad performance)
> 
> 
>> There's a fair number of those dma_sync_single_for_device() things
>> all over. Could we find mis-uses and warn about them some way? It
>> seems to be a very natural thing to do in this context, but bounce
>> buffering does make them very fragile.
> 
> At least in network drivers, there are at least two patterns:
> 
> 1) The issue at hand, hardware mixing rx_status and data inside the
> same area. Usually very old hardware, very quick grep in network
> drivers only revealed slicoss.c. Probably would have gone unnoticed if
> ath9k hardware wasn't so common.
> 
> 
> 2) The very common "copy break" pattern. If a received packet is
> smaller than a certain threshold, the driver rx path is changed to do:
> 
>   sync_for_cpu()
>   alloc_small_skb()
>   memcpy(small_skb, rx_buffer_data)
>   sync_for_device()
> 
> Original skb is left in the hardware, this reduces memory wasted.
> 
> This pattern is completely valid wrt DMA-API, the buffer is always
> either owned by CPU or device.
> 
> 
