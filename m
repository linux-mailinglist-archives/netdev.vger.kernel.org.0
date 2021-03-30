Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE22D34EDD4
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 18:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhC3Q2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 12:28:53 -0400
Received: from foss.arm.com ([217.140.110.172]:40940 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232250AbhC3Q21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 12:28:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79B92D6E;
        Tue, 30 Mar 2021 09:28:26 -0700 (PDT)
Received: from [10.57.24.208] (unknown [10.57.24.208])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C45EC3F719;
        Tue, 30 Mar 2021 09:28:22 -0700 (PDT)
Subject: Re: [PATCH 16/18] iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
To:     Will Deacon <will@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-17-hch@lst.de>
 <20210330131149.GP5908@willie-the-truck>
 <a6952aa7-4d7e-54f0-339e-e15f88596dcc@arm.com>
 <20210330135801.GA6187@willie-the-truck>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <578d6aa5-4239-f5d7-2e9f-686b18e52bba@arm.com>
Date:   Tue, 30 Mar 2021 17:28:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210330135801.GA6187@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-30 14:58, Will Deacon wrote:
> On Tue, Mar 30, 2021 at 02:19:38PM +0100, Robin Murphy wrote:
>> On 2021-03-30 14:11, Will Deacon wrote:
>>> On Tue, Mar 16, 2021 at 04:38:22PM +0100, Christoph Hellwig wrote:
>>>> From: Robin Murphy <robin.murphy@arm.com>
>>>>
>>>> Instead make the global iommu_dma_strict paramete in iommu.c canonical by
>>>> exporting helpers to get and set it and use those directly in the drivers.
>>>>
>>>> This make sure that the iommu.strict parameter also works for the AMD and
>>>> Intel IOMMU drivers on x86.  As those default to lazy flushing a new
>>>> IOMMU_CMD_LINE_STRICT is used to turn the value into a tristate to
>>>> represent the default if not overriden by an explicit parameter.
>>>>
>>>> Signed-off-by: Robin Murphy <robin.murphy@arm.com>.
>>>> [ported on top of the other iommu_attr changes and added a few small
>>>>    missing bits]
>>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>> ---
>>>>    drivers/iommu/amd/iommu.c                   | 23 +-------
>>>>    drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 50 +---------------
>>>>    drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
>>>>    drivers/iommu/arm/arm-smmu/arm-smmu.c       | 27 +--------
>>>>    drivers/iommu/dma-iommu.c                   |  9 +--
>>>>    drivers/iommu/intel/iommu.c                 | 64 ++++-----------------
>>>>    drivers/iommu/iommu.c                       | 27 ++++++---
>>>>    include/linux/iommu.h                       |  4 +-
>>>>    8 files changed, 40 insertions(+), 165 deletions(-)
>>>
>>> I really like this cleanup, but I can't help wonder if it's going in the
>>> wrong direction. With SoCs often having multiple IOMMU instances and a
>>> distinction between "trusted" and "untrusted" devices, then having the
>>> flush-queue enabled on a per-IOMMU or per-domain basis doesn't sound
>>> unreasonable to me, but this change makes it a global property.
>>
>> The intent here was just to streamline the existing behaviour of stuffing a
>> global property into a domain attribute then pulling it out again in the
>> illusion that it was in any way per-domain. We're still checking
>> dev_is_untrusted() before making an actual decision, and it's not like we
>> can't add more factors at that point if we want to.
> 
> Like I say, the cleanup is great. I'm just wondering whether there's a
> better way to express the complicated logic to decide whether or not to use
> the flush queue than what we end up with:
> 
> 	if (!cookie->fq_domain && (!dev || !dev_is_untrusted(dev)) &&
> 	    domain->ops->flush_iotlb_all && !iommu_get_dma_strict())
> 
> which is mixing up globals, device properties and domain properties. The
> result is that the driver code ends up just using the global to determine
> whether or not to pass IO_PGTABLE_QUIRK_NON_STRICT to the page-table code,
> which is a departure from the current way of doing things.

But previously, SMMU only ever saw the global policy piped through the 
domain attribute by iommu_group_alloc_default_domain(), so there's no 
functional change there.

Obviously some of the above checks could be factored out into some kind 
of iommu_use_flush_queue() helper that IOMMU drivers can also call if 
they need to keep in sync. Or maybe we just allow iommu-dma to set 
IO_PGTABLE_QUIRK_NON_STRICT directly via iommu_set_pgtable_quirks() if 
we're treating that as a generic thing now.

>>> For example, see the recent patch from Lu Baolu:
>>>
>>> https://lore.kernel.org/r/20210225061454.2864009-1-baolu.lu@linux.intel.com
>>
>> Erm, this patch is based on that one, it's right there in the context :/
> 
> Ah, sorry, I didn't spot that! I was just trying to illustrate that this
> is per-device.

Sure, I understand - and I'm just trying to bang home that despite 
appearances it's never actually been treated as such for SMMU, so 
anything that's wrong after this change was already wrong before.

Robin.
