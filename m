Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3617D6C10B8
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 12:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjCTLX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 07:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjCTLXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 07:23:23 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4E8C67D;
        Mon, 20 Mar 2023 04:23:05 -0700 (PDT)
Received: from zn.tnic (p5de8e687.dip0.t-ipconnect.de [93.232.230.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D531F1EC0531;
        Mon, 20 Mar 2023 12:23:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1679311383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=JHX6LI9jJmsbEsBfZqSHSOd2XPlLSGzi7teSPbRUpc8=;
        b=d4AGbS54cHbrOmAlC2TeA8RAdxFydCPUxwHuWE7LG94VZK/I81tDgXPPZMWVpf4DNq8Y7P
        2Q52sQOzeJnEVE+hMv3/j20c4Y2TKQi8M0j1bP07zCuNMpJ6+F7LmQvyK1uwJWvQtLv0p8
        g3UvKNX3SFkQ0BWBa8xO/48ku3u2ygY=
Date:   Mon, 20 Mar 2023 12:22:58 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Subject: Re: [PATCH v6 06/13] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Message-ID: <20230320112258.GCZBhCEpNAIk0rUDnx@fat_crate.local>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
 <1678329614-3482-7-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1678329614-3482-7-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 06:40:07PM -0800, Michael Kelley wrote:
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index 49b44f8..d1c3306 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -88,8 +106,6 @@ bool cc_platform_has(enum cc_attr attr)
>  		return amd_cc_platform_has(attr);
>  	case CC_VENDOR_INTEL:
>  		return intel_cc_platform_has(attr);
> -	case CC_VENDOR_HYPERV:
> -		return hyperv_cc_platform_has(attr);
>  	default:
>  		return false;
>  	}
> @@ -103,11 +119,14 @@ u64 cc_mkenc(u64 val)
>  	 * encryption status of the page.
>  	 *
>  	 * - for AMD, bit *set* means the page is encrypted
> -	 * - for Intel *clear* means encrypted.
> +	 * - for AMD with vTOM and for Intel, *clear* means encrypted
>  	 */
>  	switch (vendor) {
>  	case CC_VENDOR_AMD:
> -		return val | cc_mask;
> +		if (sev_status & MSR_AMD64_SNP_VTOM)
> +			return val & ~cc_mask;

This is silly. It should simply be:

		if (sev_status & MSR_AMD64_SNP_VTOM)
			return val;


> +		else
> +			return val | cc_mask;
>  	case CC_VENDOR_INTEL:
>  		return val & ~cc_mask;
>  	default:
> @@ -120,7 +139,10 @@ u64 cc_mkdec(u64 val)
>  	/* See comment in cc_mkenc() */
>  	switch (vendor) {
>  	case CC_VENDOR_AMD:
> -		return val & ~cc_mask;
> +		if (sev_status & MSR_AMD64_SNP_VTOM)
> +			return val | cc_mask;

So if you set the C-bit, that doesn't make it decrypted on AMD. cc_mask
on VTOM is 0 so why even bother?

Same as the above.

> +		else
> +			return val & ~cc_mask;
>  	case CC_VENDOR_INTEL:
>  		return val | cc_mask;
>  	default:

...

> +void __init hv_vtom_init(void)
> +{
> +	/*
> +	 * By design, a VM using vTOM doesn't see the SEV setting,
> +	 * so SEV initialization is bypassed and sev_status isn't set.
> +	 * Set it here to indicate a vTOM VM.
> +	 */

This looks like a hack. The SEV status MSR cannot be intercepted so the
guest should see vTOM. How are you running vTOM without setting it even up?!

> +	sev_status = MSR_AMD64_SNP_VTOM;
> +	cc_set_vendor(CC_VENDOR_AMD);
> +	cc_set_mask(ms_hyperv.shared_gpa_boundary);
> +	physical_mask &= ms_hyperv.shared_gpa_boundary - 1;
> +
> +	x86_platform.hyper.is_private_mmio = hv_is_private_mmio;
> +	x86_platform.guest.enc_cache_flush_required = hv_vtom_cache_flush_required;
> +	x86_platform.guest.enc_tlb_flush_required = hv_vtom_tlb_flush_required;
> +	x86_platform.guest.enc_status_change_finish = hv_vtom_set_host_visibility;
> +}
> +
> +#endif /* CONFIG_AMD_MEM_ENCRYPT */
> +
>  /*
>   * hv_map_memory - map memory to extra space in the AMD SEV-SNP Isolation VM.
>   */

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
