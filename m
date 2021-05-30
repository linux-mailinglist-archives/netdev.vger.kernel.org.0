Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8238395276
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 20:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhE3S1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 14:27:35 -0400
Received: from mail.skyhub.de ([5.9.137.197]:56852 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhE3S1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 14:27:34 -0400
Received: from zn.tnic (p200300ec2f2460006cdc9875a311c8ed.dip0.t-ipconnect.de [IPv6:2003:ec:2f24:6000:6cdc:9875:a311:c8ed])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 297BA1EC04DA;
        Sun, 30 May 2021 20:25:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622399154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZTX0veBS1A2m8n8rpJ5g64mOUcWUApPggEQNAUBCm9A=;
        b=IAw0F2TyYVY+rP1eI5AmqzSeMaa7HppyT4ap29b/IT/iNKMfdosPs+xMPG3f3mF2O4Wki1
        qhqGsUCN8l5tGn5bKA48frRbVNMVM2kOQP558FnSnfXnQJ2b7GfkbAAMJMi5biEwUyaXxK
        zI/Js2FGqWivkGhb4JVQazJsFli3sWY=
Date:   Sun, 30 May 2021 20:25:47 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, cai@lca.pw,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        Tianyu.Lan@microsoft.com, konrad.wilk@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
Subject: Re: [RFC PATCH V3 03/11] x86/Hyper-V: Add new hvcall guest address
 host visibility support
Message-ID: <YLPYqxF7urDIAd9z@zn.tnic>
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-4-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210530150628.2063957-4-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 30, 2021 at 11:06:20AM -0400, Tianyu Lan wrote:
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 156cd235659f..a82975600107 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -29,6 +29,8 @@
>  #include <asm/proto.h>
>  #include <asm/memtype.h>
>  #include <asm/set_memory.h>
> +#include <asm/hyperv-tlfs.h>
> +#include <asm/mshyperv.h>
>  
>  #include "../mm_internal.h"
>  
> @@ -1986,8 +1988,14 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>  	int ret;
>  
>  	/* Nothing to do if memory encryption is not active */
> -	if (!mem_encrypt_active())
> +	if (hv_is_isolation_supported()) {
> +		return hv_set_mem_host_visibility((void *)addr,
> +				numpages * HV_HYP_PAGE_SIZE,
> +				enc ? VMBUS_PAGE_NOT_VISIBLE
> +				: VMBUS_PAGE_VISIBLE_READ_WRITE);

Put all this gunk in a hv-specific function somewhere in hv-land which
you only call from here. This way you probably won't even need to export
hv_set_mem_host_visibility() and so on...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
