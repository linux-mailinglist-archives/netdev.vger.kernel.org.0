Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB28A45E899
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 08:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359321AbhKZHpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 02:45:41 -0500
Received: from verein.lst.de ([213.95.11.211]:45024 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245483AbhKZHnk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 02:43:40 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id F195168AFE; Fri, 26 Nov 2021 08:40:22 +0100 (CET)
Date:   Fri, 26 Nov 2021 08:40:22 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        thomas.lendacky@amd.com, dave.hansen@intel.com
Subject: Re: [PATCH 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Message-ID: <20211126074022.GA23659@lst.de>
References: <20211116153923.196763-1-ltykernel@gmail.com> <20211116153923.196763-4-ltykernel@gmail.com> <20211117100142.GB10330@lst.de> <c93bf3d4-75c1-bc3d-2789-1d65e7c19158@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c93bf3d4-75c1-bc3d-2789-1d65e7c19158@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:00:08PM +0800, Tianyu Lan wrote:
> On 11/17/2021 6:01 PM, Christoph Hellwig wrote:
>> This doesn't really have much to do with normal DMA mapping,
>> so why does this direct through the dma ops?
>>
>
> According to the previous discussion, dma_alloc_noncontigous()
> and dma_vmap_noncontiguous() may be used to handle the noncontigous
> memory alloc/map in the netvsc driver. So add alloc/free and vmap/vunmap
> callbacks here to handle the case. The previous patch v4 & v5 handles
> the allocation and map in the netvsc driver. If this should not go though 
> dma ops, We also may make it as vmbus specific function and keep
> the function in the vmbus driver.

But that only makes sense if they can actually use the normal DMA ops.
If you implement your own incomplete ops and require to use them you
do nothing but adding indirect calls to your fast path and making the
code convoluted.
