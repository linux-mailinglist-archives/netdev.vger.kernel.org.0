Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851A06323A8
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiKUNdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiKUNdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:33:03 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFAEBFF59;
        Mon, 21 Nov 2022 05:32:59 -0800 (PST)
Received: from zn.tnic (p200300ea9733e725329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e725:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C9C6B1EC053F;
        Mon, 21 Nov 2022 14:32:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669037577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=h6QdlM3if85oKaJAXlxT1/ww0EFma2c3NtTeZN9RKM4=;
        b=F/qey3CdoLaY63yMD4WxsH1hFqcb8XOOWthbY+Nbxn+Wmmnr5u1piaNXCGLV0Mh3LG99Pn
        rqOSgWpLbhkeLNecWYqWX/jiQzwmnfIMO7Eb2YyHE4IM4ljndmEMt8EppBbrHJD5+8r0GA
        BDmK9mEPeFJCTBclgIhpz+1NyntkeW8=
Date:   Mon, 21 Nov 2022 14:32:54 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: Re: [Patch v3 01/14] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Message-ID: <Y3t+BipyGPUV3q8F@zn.tnic>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-2-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1668624097-14884-2-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 10:41:24AM -0800, Michael Kelley wrote:
> Current code re-calculates the size after aligning the starting and
> ending physical addresses on a page boundary. But the re-calculation
> also embeds the masking of high order bits that exceed the size of
> the physical address space (via PHYSICAL_PAGE_MASK). If the masking
> removes any high order bits, the size calculation results in a huge
> value that is likely to immediately fail.
> 
> Fix this by re-calculating the page-aligned size first. Then mask any
> high order bits using PHYSICAL_PAGE_MASK.
> 
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>  arch/x86/mm/ioremap.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 78c5bc6..6453fba 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -217,9 +217,15 @@ static void __ioremap_check_mem(resource_size_t addr, unsigned long size,
>  	 * Mappings have to be page-aligned
>  	 */
>  	offset = phys_addr & ~PAGE_MASK;
> -	phys_addr &= PHYSICAL_PAGE_MASK;
> +	phys_addr &= PAGE_MASK;
>  	size = PAGE_ALIGN(last_addr+1) - phys_addr;
>  
> +	/*
> +	 * Mask out any bits not part of the actual physical
> +	 * address, like memory encryption bits.
> +	 */
> +	phys_addr &= PHYSICAL_PAGE_MASK;
> +
>  	retval = memtype_reserve(phys_addr, (u64)phys_addr + size,
>  						pcm, &new_pcm);
>  	if (retval) {
> -- 

This looks like a fix to me that needs to go to independently to stable.
And it would need a Fixes tag.

/me does some git archeology...

I guess this one:

ffa71f33a820 ("x86, ioremap: Fix incorrect physical address handling in PAE mode")

should be old enough so that it goes to all relevant stable kernels...

Hmm?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
