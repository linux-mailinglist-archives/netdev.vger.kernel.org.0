Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C1935F86A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352492AbhDNPvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:51:23 -0400
Received: from verein.lst.de ([213.95.11.211]:59466 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352488AbhDNPun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 11:50:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 10BD568C7B; Wed, 14 Apr 2021 17:50:17 +0200 (CEST)
Date:   Wed, 14 Apr 2021 17:50:16 +0200
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
Subject: Re: [Resend RFC PATCH V2 11/12] HV/Netvsc: Add Isolation VM
 support for netvsc driver
Message-ID: <20210414155016.GE32045@lst.de>
References: <20210414144945.3460554-1-ltykernel@gmail.com> <20210414144945.3460554-12-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414144945.3460554-12-ltykernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct dma_range {
> +	dma_addr_t dma;
> +	u32 mapping_size;
> +};

That's a rather generic name that is bound to create a conflict sooner
or later.

>  #include "hyperv_net.h"
>  #include "netvsc_trace.h"
> +#include "../../hv/hyperv_vmbus.h"

Please move public interfaces out of the private header rather than doing
this.

> +	if (hv_isolation_type_snp()) {
> +		area = get_vm_area(buf_size, VM_IOREMAP);

Err, no.  get_vm_area is private a for a reason.

> +		if (!area)
> +			goto cleanup;
> +
> +		vaddr = (unsigned long)area->addr;
> +		for (i = 0; i < buf_size / HV_HYP_PAGE_SIZE; i++) {
> +			extra_phys = (virt_to_hvpfn(net_device->recv_buf + i * HV_HYP_PAGE_SIZE)
> +				<< HV_HYP_PAGE_SHIFT) + ms_hyperv.shared_gpa_boundary;
> +			ret |= ioremap_page_range(vaddr + i * HV_HYP_PAGE_SIZE,
> +					   vaddr + (i + 1) * HV_HYP_PAGE_SIZE,
> +					   extra_phys, PAGE_KERNEL_IO);
> +		}
> +
> +		if (ret)
> +			goto cleanup;

And this is not something a driver should ever do.  I think you are badly
reimplementing functionality that should be in the dma coherent allocator
here.
