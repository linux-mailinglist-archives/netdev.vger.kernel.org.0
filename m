Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65274E6214
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 12:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349638AbiCXLGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 07:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242588AbiCXLGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 07:06:48 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B0615BD0E;
        Thu, 24 Mar 2022 04:05:17 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3FD11515;
        Thu, 24 Mar 2022 04:05:16 -0700 (PDT)
Received: from [10.57.43.230] (unknown [10.57.43.230])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E8DC3F73D;
        Thu, 24 Mar 2022 04:05:13 -0700 (PDT)
Message-ID: <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com>
Date:   Thu, 24 Mar 2022 11:05:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Content-Language: en-GB
To:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
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
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <4386660.LvFx2qVVIh@natalenko.name>
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

On 2022-03-24 10:25, Oleksandr Natalenko wrote:
> Hello.
> 
> On čtvrtek 24. března 2022 6:57:32 CET Christoph Hellwig wrote:
>> On Wed, Mar 23, 2022 at 08:54:08PM +0000, Robin Murphy wrote:
>>> I'll admit I still never quite grasped the reason for also adding the
>>> override to swiotlb_sync_single_for_device() in aa6f8dcbab47, but I think
>>> by that point we were increasingly tired and confused and starting to
>>> second-guess ourselves (well, I was, at least). I don't think it's wrong
>>> per se, but as I said I do think it can bite anyone who's been doing
>>> dma_sync_*() wrong but getting away with it until now. If ddbd89deb7d3
>>> alone turns out to work OK then I'd be inclined to try a partial revert of
>>> just that one hunk.
>>
>> Agreed.  Let's try that first.
>>
>> Oleksandr, can you try the patch below:
>>
>>
>> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
>> index 6db1c475ec827..6c350555e5a1c 100644
>> --- a/kernel/dma/swiotlb.c
>> +++ b/kernel/dma/swiotlb.c
>> @@ -701,13 +701,10 @@ void swiotlb_tbl_unmap_single(struct device *dev, phys_addr_t tlb_addr,
>>   void swiotlb_sync_single_for_device(struct device *dev, phys_addr_t tlb_addr,
>>   		size_t size, enum dma_data_direction dir)
>>   {
>> -	/*
>> -	 * Unconditional bounce is necessary to avoid corruption on
>> -	 * sync_*_for_cpu or dma_ummap_* when the device didn't overwrite
>> -	 * the whole lengt of the bounce buffer.
>> -	 */
>> -	swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
>> -	BUG_ON(!valid_dma_direction(dir));
>> +	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
>> +		swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
>> +	else
>> +		BUG_ON(dir != DMA_FROM_DEVICE);
>>   }
>>   
>>   void swiotlb_sync_single_for_cpu(struct device *dev, phys_addr_t tlb_addr,
>>
> 
> With this patch the AP works for me.

Cool, thanks for confirming. So I think ath9k probably is doing 
something dodgy with dma_sync_*(), but if Linus prefers to make the 
above change rather than wait for that to get figured out, I believe 
that should be fine.

The crucial part of the "rework" patch is that we'll unconditionally 
initialise the SWIOTLB bounce slot as it's allocated in 
swiotlb_tbl_map_single(), regardless of DMA_ATTR_SKIP_CPU_SYNC. As long 
as that happens, we're safe in terms of leaking data from previous 
mappings, and any possibility for incorrect sync usage to lose 
newly-written DMA data is at least no worse than it always has been. The 
most confusion was around how the proposed DMA_ATTR_OVERWRITE attribute 
would need to interact with DMA_ATTR_SKIP_CPU_SYNC to remain safe but 
still have any useful advantage, so unless and until anyone wants to 
revisit that, this should remain comparatively simple to reason about.

Cheers,
Robin.
