Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22662675E11
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 20:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjATT3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 14:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjATT3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 14:29:12 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3AE0D0DA2;
        Fri, 20 Jan 2023 11:28:48 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB11511FB;
        Fri, 20 Jan 2023 11:29:08 -0800 (PST)
Received: from [10.57.89.132] (unknown [10.57.89.132])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A6FF03F445;
        Fri, 20 Jan 2023 11:28:23 -0800 (PST)
Message-ID: <f24fcba7-2fcb-ed43-05da-60763dbb07bf@arm.com>
Date:   Fri, 20 Jan 2023 19:28:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 04/10] iommu/dma: Use the gfp parameter in
 __iommu_dma_alloc_noncontiguous()
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-tegra@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nouveau@lists.freedesktop.org,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
References: <4-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <4-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-01-18 18:00, Jason Gunthorpe wrote:
> Change the sg_alloc_table_from_pages() allocation that was hardwired to
> GFP_KERNEL to use the gfp parameter like the other allocations in this
> function.
> 
> Auditing says this is never called from an atomic context, so it is safe
> as is, but reads wrong.

I think the point may have been that the sgtable metadata is a 
logically-distinct allocation from the buffer pages themselves. Much 
like the allocation of the pages array itself further down in 
__iommu_dma_alloc_pages(). I see these days it wouldn't be catastrophic 
to pass GFP_HIGHMEM into __get_free_page() via sg_kmalloc(), but still, 
allocating implementation-internal metadata with all the same 
constraints as a DMA buffer has just as much smell of wrong about it IMO.

I'd say the more confusing thing about this particular context is why 
we're using iommu_map_sg_atomic() further down - that seems to have been 
an oversight in 781ca2de89ba, since this particular path has never 
supported being called in atomic context.

Overall I'm starting to wonder if it might not be better to stick a "use 
GFP_KERNEL_ACCOUNT if you allocate" flag in the domain for any level of 
the API internals to pick up as appropriate, rather than propagate 
per-call gfp flags everywhere. As it stands we're still missing 
potential pagetable and other domain-related allocations by drivers in 
.attach_dev and even (in probably-shouldn't-really-happen cases) 
.unmap_pages...

Thanks,
Robin.

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/dma-iommu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 8c2788633c1766..e4bf1bb159f7c7 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -822,7 +822,7 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
>   	if (!iova)
>   		goto out_free_pages;
>   
> -	if (sg_alloc_table_from_pages(sgt, pages, count, 0, size, GFP_KERNEL))
> +	if (sg_alloc_table_from_pages(sgt, pages, count, 0, size, gfp))
>   		goto out_free_iova;
>   
>   	if (!(ioprot & IOMMU_CACHE)) {
