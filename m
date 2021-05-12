Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9179037D06E
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 19:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242607AbhELRfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 13:35:00 -0400
Received: from foss.arm.com ([217.140.110.172]:45770 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239282AbhELRaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 13:30:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F2BB31B;
        Wed, 12 May 2021 10:29:40 -0700 (PDT)
Received: from [192.168.1.123] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37C463F719;
        Wed, 12 May 2021 10:29:35 -0700 (PDT)
Subject: Re: [Resend RFC PATCH V2 10/12] HV/IOMMU: Add Hyper-V dma ops support
To:     Tianyu Lan <ltykernel@gmail.com>, Christoph Hellwig <hch@lst.de>,
        konrad.wilk@oracle.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        m.szyprowski@samsung.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
References: <20210414144945.3460554-1-ltykernel@gmail.com>
 <20210414144945.3460554-11-ltykernel@gmail.com>
 <20210414154729.GD32045@lst.de>
 <a316af73-2c96-f307-6285-593597e05123@gmail.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <4793ae97-5e29-4a45-d2b6-61c151322065@arm.com>
Date:   Wed, 12 May 2021 18:29:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a316af73-2c96-f307-6285-593597e05123@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-12 17:01, Tianyu Lan wrote:
> Hi Christoph and Konrad:
>       Current Swiotlb bounce buffer uses a pool for all devices. There
> is a high overhead to get or free bounce buffer during performance test.
> Swiotlb code now use a global spin lock to protect bounce buffer data.
> Several device queues try to acquire the spin lock and this introduce
> additional overhead.
> 
> For performance and security perspective, each devices should have a
> separate swiotlb bounce buffer pool and so this part needs to rework.
> I want to check this is right way to resolve performance issues with 
> swiotlb bounce buffer. If you have some other suggestions,welcome.

We're already well on the way to factoring out SWIOTLB to allow for just 
this sort of more flexible usage like per-device bounce pools - see here:

https://lore.kernel.org/linux-iommu/20210510095026.3477496-1-tientzu@chromium.org/T/#t

FWIW this looks to have an awful lot in common with what's going to be 
needed for Android's protected KVM and Arm's Confidential Compute 
Architecture, so we'll all be better off by doing it right. I'm getting 
the feeling that set_memory_decrypted() wants to grow into a more 
general abstraction that can return an alias at a different GPA if 
necessary.

Robin.

> 
> Thanks.
> 
> On 4/14/2021 11:47 PM, Christoph Hellwig wrote:
>>> +static dma_addr_t hyperv_map_page(struct device *dev, struct page 
>>> *page,
>>> +                  unsigned long offset, size_t size,
>>> +                  enum dma_data_direction dir,
>>> +                  unsigned long attrs)
>>> +{
>>> +    phys_addr_t map, phys = (page_to_pfn(page) << PAGE_SHIFT) + offset;
>>> +
>>> +    if (!hv_is_isolation_supported())
>>> +        return phys;
>>> +
>>> +    map = swiotlb_tbl_map_single(dev, phys, size, HV_HYP_PAGE_SIZE, 
>>> dir,
>>> +                     attrs);
>>> +    if (map == (phys_addr_t)DMA_MAPPING_ERROR)
>>> +        return DMA_MAPPING_ERROR;
>>> +
>>> +    return map;
>>> +}
>>
>> This largerly duplicates what dma-direct + swiotlb does.  Please use
>> force_dma_unencrypted to force bounce buffering and just use the generic
>> code.
>>
>>> +    if (hv_isolation_type_snp()) {
>>> +        ret = hv_set_mem_host_visibility(
>>> +                phys_to_virt(hyperv_io_tlb_start),
>>> +                hyperv_io_tlb_size,
>>> +                VMBUS_PAGE_VISIBLE_READ_WRITE);
>>> +        if (ret)
>>> +            panic("%s: Fail to mark Hyper-v swiotlb buffer visible 
>>> to host. err=%d\n",
>>> +                  __func__, ret);
>>> +
>>> +        hyperv_io_tlb_remap = ioremap_cache(hyperv_io_tlb_start
>>> +                        + ms_hyperv.shared_gpa_boundary,
>>> +                            hyperv_io_tlb_size);
>>> +        if (!hyperv_io_tlb_remap)
>>> +            panic("%s: Fail to remap io tlb.\n", __func__);
>>> +
>>> +        memset(hyperv_io_tlb_remap, 0x00, hyperv_io_tlb_size);
>>> +        swiotlb_set_bounce_remap(hyperv_io_tlb_remap);
>>
>> And this really needs to go into a common hook where we currently just
>> call set_memory_decrypted so that all the different schemes for these
>> trusted VMs (we have about half a dozen now) can share code rather than
>> reinventing it.
>>
