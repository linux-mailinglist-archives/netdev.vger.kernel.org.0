Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A23436788
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhJUQYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:24:47 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45878 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230072AbhJUQYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 12:24:46 -0400
Received: from zn.tnic (p200300ec2f191200ee5ad10a1c627015.dip0.t-ipconnect.de [IPv6:2003:ec:2f19:1200:ee5a:d10a:1c62:7015])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 229661EC011B;
        Thu, 21 Oct 2021 18:22:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634833349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=s9B7TcJbpJamc03KXDCXQuXf1+/ogvmvN6UH47r0t44=;
        b=ViCKbfkrxBNFBw9sV4dQEIRuYioGwgmaVA8GvvP+1GAYxiIAzKzmb9Rie6jAt9cV5OrGsU
        HtSbyZJdONQ2tN3ELB2DRGPD/mr3vaOmS5XQoSlGJkpzXo49ujTlMTwkbgprJPAkI1yxSN
        2b1jb3B/MwUtUKcSij1cujLYU/sAmlE=
Date:   Thu, 21 Oct 2021 18:22:26 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        rientjes@google.com, pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        saravanand@fb.com, aneesh.kumar@linux.ibm.com, hannes@cmpxchg.org,
        tj@kernel.org, michael.h.kelley@microsoft.com,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: Re: [PATCH V8 5/9] x86/sev-es: Expose sev_es_ghcb_hv_call() to call
 ghcb hv call out of sev code
Message-ID: <YXGTwppQ8syUyJ72@zn.tnic>
References: <20211021154110.3734294-1-ltykernel@gmail.com>
 <20211021154110.3734294-6-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211021154110.3734294-6-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 11:41:05AM -0400, Tianyu Lan wrote:
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index ea9abd69237e..368ed36971e3 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -124,10 +124,9 @@ static enum es_result verify_exception_info(struct ghcb *ghcb, struct es_em_ctxt
>  	return ES_VMM_ERROR;
>  }
>  
> -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> -					  struct es_em_ctxt *ctxt,
> -					  u64 exit_code, u64 exit_info_1,
> -					  u64 exit_info_2)
> +enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb, bool set_ghcb_msr,
> +				   struct es_em_ctxt *ctxt, u64 exit_code,
> +				   u64 exit_info_1, u64 exit_info_2)
>  {
>  	/* Fill in protocol and format specifiers */
>  	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
> @@ -137,7 +136,15 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>  	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>  	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>  
> -	sev_es_wr_ghcb_msr(__pa(ghcb));
> +	/*
> +	 * Hyper-V unenlightened guests use a paravisor for communicating and
> +	 * GHCB pages are being allocated and set up by that paravisor. Linux
> +	 * should not change ghcb page pa in such case and so add set_ghcb_msr

"... not change the GHCB page's physical address."

Remove the "so add... " rest.

Otherwise, LGTM.

Do you want me to take it through the tip tree?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
