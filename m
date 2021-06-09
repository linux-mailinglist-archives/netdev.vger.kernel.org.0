Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20523A149C
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 14:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhFIMkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbhFIMk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 08:40:28 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC14C061574;
        Wed,  9 Jun 2021 05:38:33 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 99A0E36A; Wed,  9 Jun 2021 14:38:30 +0200 (CEST)
Date:   Wed, 9 Jun 2021 14:38:29 +0200
From:   Joerg Roedel <joro@8bytes.org>
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
        sstabellini@kernel.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
Subject: Re: [RFC PATCH V3 01/11] x86/HV: Initialize GHCB page in Isolation VM
Message-ID: <YMC2RSr/J1WYCvtz@8bytes.org>
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-2-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210530150628.2063957-2-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 30, 2021 at 11:06:18AM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> Hyper-V exposes GHCB page via SEV ES GHCB MSR for SNP guest
> to communicate with hypervisor. Map GHCB page for all
> cpus to read/write MSR register and submit hvcall request
> via GHCB.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  arch/x86/hyperv/hv_init.c       | 60 ++++++++++++++++++++++++++++++---
>  arch/x86/include/asm/mshyperv.h |  2 ++
>  include/asm-generic/mshyperv.h  |  2 ++
>  3 files changed, 60 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index bb0ae4b5c00f..dc74d01cb859 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -60,6 +60,9 @@ static int hv_cpu_init(unsigned int cpu)
>  	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[smp_processor_id()];
>  	void **input_arg;
>  	struct page *pg;
> +	u64 ghcb_gpa;
> +	void *ghcb_va;
> +	void **ghcb_base;

Any reason you can't reuse the SEV-ES support code in the Linux kernel?
It already has code to setup GHCBs for all vCPUs.

I see that you don't need #VC handling in your SNP VMs because of the
paravisor running underneath it, but just re-using the GHCB setup code
shouldn't be too hard.

Regards,

	Joerg
