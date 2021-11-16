Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93A84539E3
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 20:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239683AbhKPTPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 14:15:42 -0500
Received: from mail.skyhub.de ([5.9.137.197]:39940 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232659AbhKPTPm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 14:15:42 -0500
Received: from zn.tnic (p200300ec2f1b8100142ca11f4b264b2f.dip0.t-ipconnect.de [IPv6:2003:ec:2f1b:8100:142c:a11f:4b26:4b2f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 63CAB1EC056D;
        Tue, 16 Nov 2021 20:12:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1637089963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=MvK45/ux9p/D3P3nIzsezA5z0FVwGNzV1VvGxFtGLKQ=;
        b=DYO/tXGYfoiflcnBZ3TlKfZZ+/Nly9hyIxYswP+umYZWIDlAGYy77xh7aqb7mOF0MVFTU+
        +GG5FsAU39HXZwuLfIERLqvO7NAOXLMV4qlBiPeZkbRl9YG9fRZFW3kcoexW0VM/khZZpy
        Hn5p4xjCfVD7JeZRj+4M3EhGy/fJ6lk=
Date:   Tue, 16 Nov 2021 20:12:39 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
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
Message-ID: <YZQCp6WWKAdOCbh8@zn.tnic>
References: <20211116153923.196763-1-ltykernel@gmail.com>
 <20211116153923.196763-4-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211116153923.196763-4-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 10:39:21AM -0500, Tianyu Lan wrote:
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 35487305d8af..65bc385ae07a 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -31,6 +31,7 @@
>  #include <asm/processor-flags.h>
>  #include <asm/msr.h>
>  #include <asm/cmdline.h>
> +#include <asm/mshyperv.h>
>  
>  #include "mm_internal.h"
>  
> @@ -203,7 +204,8 @@ void __init sev_setup_arch(void)
>  	phys_addr_t total_mem = memblock_phys_mem_size();
>  	unsigned long size;
>  
> -	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
> +	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)
> +	    && !hv_is_isolation_supported())

Are we gonna start sprinkling this hv_is_isolation_supported() check
everywhere now?

Are those isolation VMs SEV-like guests? Is CC_ATTR_GUEST_MEM_ENCRYPT
set on them?

What you should do, instead, is add an isol. VM specific
hv_cc_platform_has() just like amd_cc_platform_has() and handle
the cc_attrs there for your platform, like return false for
CC_ATTR_GUEST_MEM_ENCRYPT and then you won't need to add that hv_* thing
everywhere.

And then fix it up in __set_memory_enc_dec() too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
