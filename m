Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1C835F826
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350876AbhDNPr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:47:56 -0400
Received: from verein.lst.de ([213.95.11.211]:59439 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232985AbhDNPrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 11:47:55 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0127168C7B; Wed, 14 Apr 2021 17:47:30 +0200 (CEST)
Date:   Wed, 14 Apr 2021 17:47:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: Re: [Resend RFC PATCH V2 10/12] HV/IOMMU: Add Hyper-V dma ops
 support
Message-ID: <20210414154729.GD32045@lst.de>
References: <20210414144945.3460554-1-ltykernel@gmail.com> <20210414144945.3460554-11-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414144945.3460554-11-ltykernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static dma_addr_t hyperv_map_page(struct device *dev, struct page *page,
> +				  unsigned long offset, size_t size,
> +				  enum dma_data_direction dir,
> +				  unsigned long attrs)
> +{
> +	phys_addr_t map, phys = (page_to_pfn(page) << PAGE_SHIFT) + offset;
> +
> +	if (!hv_is_isolation_supported())
> +		return phys;
> +
> +	map = swiotlb_tbl_map_single(dev, phys, size, HV_HYP_PAGE_SIZE, dir,
> +				     attrs);
> +	if (map == (phys_addr_t)DMA_MAPPING_ERROR)
> +		return DMA_MAPPING_ERROR;
> +
> +	return map;
> +}

This largerly duplicates what dma-direct + swiotlb does.  Please use
force_dma_unencrypted to force bounce buffering and just use the generic
code.

> +	if (hv_isolation_type_snp()) {
> +		ret = hv_set_mem_host_visibility(
> +				phys_to_virt(hyperv_io_tlb_start),
> +				hyperv_io_tlb_size,
> +				VMBUS_PAGE_VISIBLE_READ_WRITE);
> +		if (ret)
> +			panic("%s: Fail to mark Hyper-v swiotlb buffer visible to host. err=%d\n",
> +			      __func__, ret);
> +
> +		hyperv_io_tlb_remap = ioremap_cache(hyperv_io_tlb_start
> +					    + ms_hyperv.shared_gpa_boundary,
> +						    hyperv_io_tlb_size);
> +		if (!hyperv_io_tlb_remap)
> +			panic("%s: Fail to remap io tlb.\n", __func__);
> +
> +		memset(hyperv_io_tlb_remap, 0x00, hyperv_io_tlb_size);
> +		swiotlb_set_bounce_remap(hyperv_io_tlb_remap);

And this really needs to go into a common hook where we currently just
call set_memory_decrypted so that all the different schemes for these
trusted VMs (we have about half a dozen now) can share code rather than
reinventing it.
