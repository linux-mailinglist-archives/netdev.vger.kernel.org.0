Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7D0434870
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhJTKBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhJTKBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 06:01:22 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA156C06161C;
        Wed, 20 Oct 2021 02:59:08 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0db300e25116189b6f3930.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:b300:e251:1618:9b6f:3930])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F41EA1EC0541;
        Wed, 20 Oct 2021 11:59:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634723947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=yYD0zgbH5UOus3UngmRiFbvOTmQXCCS6PVOjejhkpfw=;
        b=OXYIE6y7qReAd9h1BdwVEOL7La9YgctHRa9BrMJadKK64LFiu/kVaPAn7A6b3kUVbleuIb
        KMjteEH5HMlu2HQSi72yCktE5uwGE0svHBa7bHCpCsezwsdpJRFArAqzpox83vRWOMfVY2
        x3CaC672i4q/f67PE48XBg1wA8VFI0s=
Date:   Wed, 20 Oct 2021 11:59:05 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        jroedel@suse.de, brijesh.singh@amd.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org, tj@kernel.org,
        aneesh.kumar@linux.ibm.com, saravanand@fb.com, hannes@cmpxchg.org,
        rientjes@google.com, michael.h.kelley@microsoft.com,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: Re: [PATCH] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call ghcb
 hv call out of sev code
Message-ID: <YW/oaZ2GN15hQdyd@zn.tnic>
References: <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
 <20211020062321.3581158-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211020062321.3581158-1-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 02:23:16AM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> 
> Hyper-V also needs to call ghcb hv call to write/read MSR in Isolation VM.
> So expose __sev_es_ghcb_hv_call() to call it in the Hyper-V code.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  arch/x86/include/asm/sev.h   | 11 +++++++++++
>  arch/x86/kernel/sev-shared.c | 24 +++++++++++++++++++-----
>  2 files changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index fa5cd05d3b5b..295c847c3cd4 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -81,12 +81,23 @@ static __always_inline void sev_es_nmi_complete(void)
>  		__sev_es_nmi_complete();
>  }
>  extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
> +extern enum es_result __sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +					    struct es_em_ctxt *ctxt,
> +					    u64 exit_code, u64 exit_info_1,
> +					    u64 exit_info_2);

You can do here:

static inline enum es_result
__sev_es_ghcb_hv_call(struct ghcb *ghcb, u64 exit_code, u64 exit_info_1, u64 exit_info_2) { return ES_VMM_ERROR; }

> @@ -137,12 +141,22 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>  	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>  	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>  
> -	sev_es_wr_ghcb_msr(__pa(ghcb));
>  	VMGEXIT();
>  
>  	return verify_exception_info(ghcb, ctxt);
>  }
>  
> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +					  struct es_em_ctxt *ctxt,
> +					  u64 exit_code, u64 exit_info_1,
> +					  u64 exit_info_2)
> +{
> +	sev_es_wr_ghcb_msr(__pa(ghcb));
> +
> +	return __sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, exit_info_1,
> +				     exit_info_2);
> +}

Well, why does Hyper-V need this thing a bit differently, without the
setting of the GHCB's physical address?

What if another hypervisor does yet another SEV implementation and yet
another HV call needs to be defined?

If stuff is going to be exported to other users, then stuff better be
defined properly so that it is used by multiple hypervisors.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
