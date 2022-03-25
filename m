Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC514E792F
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 17:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376900AbiCYQrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 12:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245408AbiCYQrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 12:47:21 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63BDDB9191;
        Fri, 25 Mar 2022 09:45:46 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06F6C12FC;
        Fri, 25 Mar 2022 09:45:46 -0700 (PDT)
Received: from [10.57.41.19] (unknown [10.57.41.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 495323F73D;
        Fri, 25 Mar 2022 09:45:43 -0700 (PDT)
Message-ID: <f4224721-4578-61d3-69a7-9a3a76c50529@arm.com>
Date:   Fri, 25 Mar 2022 16:45:39 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Content-Language: en-GB
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        mbizon@freebox.fr, Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
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
References: <1812355.tdWV9SEqCh@natalenko.name>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de>
 <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
 <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
 <87a6de80em.fsf@toke.dk>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <87a6de80em.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-25 16:25, Toke Høiland-Jørgensen wrote:
> Maxime Bizon <mbizon@freebox.fr> writes:
> 
>> On Thu, 2022-03-24 at 12:26 -0700, Linus Torvalds wrote:
>>
>>>
>>> It's actually very natural in that situation to flush the caches from
>>> the CPU side again. And so dma_sync_single_for_device() is a fairly
>>> reasonable thing to do in that situation.
>>>
>>
>> In the non-cache-coherent scenario, and assuming dma_map() did an
>> initial cache invalidation, you can write this:
>>
>> rx_buffer_complete_1(buf)
>> {
>> 	invalidate_cache(buf, size)
>> 	if (!is_ready(buf))
>> 		return;
>> 	<proceed with receive>
>> }
>>
>> or
>>
>> rx_buffer_complete_2(buf)
>> {
>> 	if (!is_ready(buf)) {
>> 		invalidate_cache(buf, size)
>> 		return;
>> 	}
>> 	<proceed with receive>
>> }
>>
>> The latter is preferred for performance because dma_map() did the
>> initial invalidate.
>>
>> Of course you could write:
>>
>> rx_buffer_complete_3(buf)
>> {
>> 	invalidate_cache(buf, size)
>> 	if
>> (!is_ready(buf)) {
>> 		invalidate_cache(buf, size)
>> 		return;
>> 	}
>> 	
>> <proceed with receive>
>> }
>>
>>
>> but it's a waste of CPU cycles
>>
>> So I'd be very cautious assuming sync_for_cpu() and sync_for_device()
>> are both doing invalidation in existing implementation of arch DMA ops,
>> implementers may have taken some liberty around DMA-API to avoid
>> unnecessary cache operation (not to blame them).
> 
> I sense an implicit "and the driver can't (or shouldn't) influence
> this" here, right?

Right, drivers don't get a choice of how a given DMA API implementation 
works.

>> For example looking at arch/arm/mm/dma-mapping.c, for DMA_FROM_DEVICE
>>
>> sync_single_for_device()
>>    => __dma_page_cpu_to_dev()
>>      => dma_cache_maint_page(op=dmac_map_area)
>>        => cpu_cache.dma_map_area()
>>
>> sync_single_for_cpu()
>>    => __dma_page_dev_to_cpu()
>>      =>
>> __dma_page_cpu_to_dev(op=dmac_unmap_area)
>>        =>
>> cpu_cache.dma_unmap_area()
>>
>> dma_map_area() always does cache invalidate.
>>
>> But for a couple of CPU variant, dma_unmap_area() is a noop, so
>> sync_for_cpu() does nothing.
>>
>> Toke's patch will break ath9k on those platforms (mostly silent
>> breakage, rx corruption leading to bad performance)
> 
> Okay, so that would be bad obviously. So if I'm reading you correctly
> (cf my question above), we can't fix this properly from the driver side,
> and we should go with the partial SWIOTLB revert instead?

Do you have any other way of telling if DMA is idle, or temporarily 
pausing it before the sync_for_cpu, such that you could honour the 
notion of ownership transfer properly? As mentioned elsewhere I suspect 
the only "real" fix if you really do need to allow concurrent access is 
to use the coherent DMA API for buffers rather than streaming mappings, 
but that's obviously some far more significant surgery.

Robin.
