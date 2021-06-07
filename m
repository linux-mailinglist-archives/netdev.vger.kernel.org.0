Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D18339D526
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 08:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhFGGnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 02:43:42 -0400
Received: from verein.lst.de ([213.95.11.211]:44563 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhFGGnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 02:43:39 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C9F1667373; Mon,  7 Jun 2021 08:41:42 +0200 (CEST)
Date:   Mon, 7 Jun 2021 08:41:42 +0200
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
Subject: Re: [RFC PATCH V3 01/11] x86/HV: Initialize GHCB page in Isolation
 VM
Message-ID: <20210607064142.GA24478@lst.de>
References: <20210530150628.2063957-1-ltykernel@gmail.com> <20210530150628.2063957-2-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210530150628.2063957-2-ltykernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 30, 2021 at 11:06:18AM -0400, Tianyu Lan wrote:
> +	if (ms_hyperv.ghcb_base) {
> +		rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
> +
> +		ghcb_va = ioremap_cache(ghcb_gpa, HV_HYP_PAGE_SIZE);
> +		if (!ghcb_va)
> +			return -ENOMEM;

Can you explain this a bit more?  We've very much deprecated
ioremap_cache in favor of memremap.  Why yo you need a __iomem address
here?  Why do we need the remap here at all?

Does the data structure at this address not have any types that we
could use a struct for?

> +
> +		rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
> +		ghcb_va = ioremap_cache(ghcb_gpa, HV_HYP_PAGE_SIZE);
> +		if (!ghcb_va) {

This seems to duplicate the above code.

> +bool hv_isolation_type_snp(void)
> +{
> +	return static_branch_unlikely(&isolation_type_snp);
> +}
> +EXPORT_SYMBOL_GPL(hv_isolation_type_snp);

This probably wants a kerneldoc explaining when it should be used.
