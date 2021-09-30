Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89D941E106
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 20:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351279AbhI3SWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 14:22:35 -0400
Received: from mail.skyhub.de ([5.9.137.197]:43480 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351282AbhI3SW0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 14:22:26 -0400
Received: from zn.tnic (p200300ec2f0e160042ff9e72dd33ffc9.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1600:42ff:9e72:dd33:ffc9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BDC561EC052C;
        Thu, 30 Sep 2021 20:20:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1633026040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=FXyOq/QMBX4m5TO7R9gCBXGs2SQRIs7nKHlxFhhRzA8=;
        b=eT+8YEfPrmSWLKeBe4sPaMbSsDltmaGjWcspmyrqCwnOuzTm4K1dChyrOJCGMyrAYnVUfh
        r6u0gvWL7KLGCNsLaxM78DtrUnzdqnkLk+spjkiE7y2TQKD5JVcs/lmlsUbl7vAWpMXOUa
        YtkoYm471zCc5pj5k+hmgCwx0wd5OYs=
Date:   Thu, 30 Sep 2021 20:20:37 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        konrad.wilk@oracle.com, hch@lst.de, robin.murphy@arm.com,
        joro@8bytes.org, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V6 5/8] x86/hyperv: Add Write/Read MSR registers via ghcb
 page
Message-ID: <YVX/9Xxxgy5D/Cvo@zn.tnic>
References: <20210930130545.1210298-1-ltykernel@gmail.com>
 <20210930130545.1210298-6-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210930130545.1210298-6-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 09:05:41AM -0400, Tianyu Lan wrote:
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 9f90f460a28c..dd7f37de640b 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -94,10 +94,9 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
>  	ctxt->regs->ip += ctxt->insn.length;
>  }
>  
> -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> -					  struct es_em_ctxt *ctxt,
> -					  u64 exit_code, u64 exit_info_1,
> -					  u64 exit_info_2)
> +enum es_result sev_es_ghcb_hv_call_simple(struct ghcb *ghcb,
> +				   u64 exit_code, u64 exit_info_1,
> +				   u64 exit_info_2)

Align arguments on the opening brace.

Also, there's nothing "simple" about it - what you've carved out does
the actual HV call and the trailing part is verifying the HV info. So
that function should be called

__sev_es_ghcb_hv_call()

and the outer one without the "__".

>  {
>  	enum es_result ret;
>  
> @@ -109,29 +108,45 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>  	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>  	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>  
> -	sev_es_wr_ghcb_msr(__pa(ghcb));
>  	VMGEXIT();
>  
> -	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
> -		u64 info = ghcb->save.sw_exit_info_2;
> -		unsigned long v;
> -
> -		info = ghcb->save.sw_exit_info_2;
> -		v = info & SVM_EVTINJ_VEC_MASK;
> -
> -		/* Check if exception information from hypervisor is sane. */
> -		if ((info & SVM_EVTINJ_VALID) &&
> -		    ((v == X86_TRAP_GP) || (v == X86_TRAP_UD)) &&
> -		    ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
> -			ctxt->fi.vector = v;
> -			if (info & SVM_EVTINJ_VALID_ERR)
> -				ctxt->fi.error_code = info >> 32;
> -			ret = ES_EXCEPTION;
> -		} else {
> -			ret = ES_VMM_ERROR;
> -		}
> -	} else {
> +	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1)
> +		ret = ES_VMM_ERROR;
> +	else
>  		ret = ES_OK;
> +
> +	return ret;
> +}
> +
> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +				   struct es_em_ctxt *ctxt,
> +				   u64 exit_code, u64 exit_info_1,
> +				   u64 exit_info_2)


Align arguments on the opening brace.

> +{
> +	unsigned long v;
> +	enum es_result ret;
> +	u64 info;
> +
> +	sev_es_wr_ghcb_msr(__pa(ghcb));
> +
> +	ret = sev_es_ghcb_hv_call_simple(ghcb, exit_code, exit_info_1,
> +					 exit_info_2);
> +	if (ret == ES_OK)
> +		return ret;
> +
> +	info = ghcb->save.sw_exit_info_2;
> +	v = info & SVM_EVTINJ_VEC_MASK;
> +
> +	/* Check if exception information from hypervisor is sane. */
> +	if ((info & SVM_EVTINJ_VALID) &&
> +	    ((v == X86_TRAP_GP) || (v == X86_TRAP_UD)) &&
> +	    ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
> +		ctxt->fi.vector = v;
> +		if (info & SVM_EVTINJ_VALID_ERR)
> +			ctxt->fi.error_code = info >> 32;
> +		ret = ES_EXCEPTION;
> +	} else {
> +		ret = ES_VMM_ERROR;

Why do you need to assign ES_VMM_ERROR here again when you return it
above?

IOW, that else branch is not really needed.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
