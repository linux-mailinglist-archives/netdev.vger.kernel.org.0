Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E96D39D561
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 08:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFGGwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 02:52:05 -0400
Received: from verein.lst.de ([213.95.11.211]:44679 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhFGGwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 02:52:04 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6BD7A68AFE; Mon,  7 Jun 2021 08:50:07 +0200 (CEST)
Date:   Mon, 7 Jun 2021 08:50:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, cai@lca.pw, krish.sadhukhan@oracle.com,
        saravanand@fb.com, Tianyu.Lan@microsoft.com,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
Subject: Re: [RFC PATCH V3 10/11] HV/Netvsc: Add Isolation VM support for
 netvsc driver
Message-ID: <20210607065007.GE24478@lst.de>
References: <20210530150628.2063957-1-ltykernel@gmail.com> <20210530150628.2063957-11-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210530150628.2063957-11-ltykernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 30, 2021 at 11:06:27AM -0400, Tianyu Lan wrote:
> +	if (hv_isolation_type_snp()) {
> +		pfns = kcalloc(buf_size / HV_HYP_PAGE_SIZE, sizeof(unsigned long),
> +			       GFP_KERNEL);
> +		for (i = 0; i < buf_size / HV_HYP_PAGE_SIZE; i++)
> +			pfns[i] = virt_to_hvpfn(net_device->recv_buf + i * HV_HYP_PAGE_SIZE) +
> +				(ms_hyperv.shared_gpa_boundary >> HV_HYP_PAGE_SHIFT);
> +
> +		vaddr = vmap_pfn(pfns, buf_size / HV_HYP_PAGE_SIZE, PAGE_KERNEL_IO);
> +		kfree(pfns);
> +		if (!vaddr)
> +			goto cleanup;
> +		net_device->recv_original_buf = net_device->recv_buf;
> +		net_device->recv_buf = vaddr;
> +	}

This probably wnats a helper to make the thing more readable.  But who
came up with this fucked up communication protocol where the host needs
to map random pfns into a contigous range?  Sometime I really have to
wonder what crack the hyper-v people take when comparing this to the
relatively sane approach others take.

> +	for (i = 0; i < page_count; i++)
> +		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
> +				 packet->dma_range[i].mapping_size,
> +				 DMA_TO_DEVICE);
> +
> +	kfree(packet->dma_range);

Any reason this isn't simply using a struct scatterlist?

> +	for (i = 0; i < page_count; i++) {
> +		char *src = phys_to_virt((pb[i].pfn << HV_HYP_PAGE_SHIFT)
> +					 + pb[i].offset);
> +		u32 len = pb[i].len;
> +
> +		dma = dma_map_single(&hv_dev->device, src, len,
> +				     DMA_TO_DEVICE);

dma_map_single can only be used on page baked memory, and if this is
using page backed memory you wouldn't need to do thee phys_to_virt
tricks.  Can someone explain the mess here in more detail?

>  	struct rndis_device *dev = nvdev->extension;
>  	struct rndis_request *request = NULL;
> +	struct hv_device *hv_dev = ((struct net_device_context *)
> +			netdev_priv(ndev))->device_ctx;

Why not use a net_device_context local variable instead of this cast
galore?
