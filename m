Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608C662C20B
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 16:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbiKPPPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 10:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiKPPPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 10:15:36 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 199EF4B990;
        Wed, 16 Nov 2022 07:15:34 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDFAE150C;
        Wed, 16 Nov 2022 07:15:36 -0800 (PST)
Received: from [10.57.70.190] (unknown [10.57.70.190])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A3E913F587;
        Wed, 16 Nov 2022 07:15:26 -0800 (PST)
Message-ID: <be8ca3f9-b7f7-5402-0cfc-47b9985e007b@arm.com>
Date:   Wed, 16 Nov 2022 15:15:10 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 2/7] RDMA/hfi1: don't pass bogus GFP_ flags to
 dma_alloc_coherent
Content-Language: en-GB
To:     Dean Luick <dean.luick@cornelisnetworks.com>,
        Christoph Hellwig <hch@lst.de>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <20221113163535.884299-1-hch@lst.de>
 <20221113163535.884299-3-hch@lst.de>
 <c7c6eb30-4b54-01f7-9651-07deac3662bf@cornelisnetworks.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <c7c6eb30-4b54-01f7-9651-07deac3662bf@cornelisnetworks.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-16 14:40, Dean Luick wrote:
> On 11/13/2022 10:35 AM, Christoph Hellwig wrote:
>> dma_alloc_coherent is an opaque allocator that only uses the GFP_ flags
>> for allocation context control.  Don't pass GFP_USER which doesn't make
>> sense for a kernel DMA allocation or __GFP_COMP which makes no sense
>> for an allocation that can't in any way be converted to a page pointer.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   drivers/infiniband/hw/hfi1/init.c | 21 +++------------------
>>   1 file changed, 3 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
>> index 436372b314312..24c0f0d257fc9 100644
>> --- a/drivers/infiniband/hw/hfi1/init.c
>> +++ b/drivers/infiniband/hw/hfi1/init.c
>> @@ -1761,17 +1761,11 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
>>        unsigned amt;
>>
>>        if (!rcd->rcvhdrq) {
>> -             gfp_t gfp_flags;
>> -
>>                amt = rcvhdrq_size(rcd);
>>
>> -             if (rcd->ctxt < dd->first_dyn_alloc_ctxt || rcd->is_vnic)
>> -                     gfp_flags = GFP_KERNEL;
>> -             else
>> -                     gfp_flags = GFP_USER;
>>                rcd->rcvhdrq = dma_alloc_coherent(&dd->pcidev->dev, amt,
>>                                                  &rcd->rcvhdrq_dma,
>> -                                               gfp_flags | __GFP_COMP);
>> +                                               GFP_KERNEL);
> 
> A user context receive header queue may be mapped into user space.  Is that not the use case for GFP_USER?  The above conditional is what decides.
> 
> Why do you think GFP_USER should be removed here?

Coherent DMA buffers are allocated by a kernel driver or subsystem for 
the use of a device managed by that driver or subsystem, and thus they 
fundamentally belong to the kernel as proxy for the device. Any coherent 
DMA buffer may be mapped to userspace with the dma_mmap_*() interfaces, 
but they're never a "userspace allocation" in that sense.

Thanks,
Robin.
