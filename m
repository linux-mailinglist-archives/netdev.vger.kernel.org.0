Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C41662B61
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 17:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbjAIQiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 11:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234478AbjAIQin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 11:38:43 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44311649A;
        Mon,  9 Jan 2023 08:38:42 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 190A41EC0104;
        Mon,  9 Jan 2023 17:38:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673282321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=VUS6E1kTGTyemsfzfDqBXzhlr7jEukuBikzhrrd6xvM=;
        b=Qz2DjSz9JIXdYW/k4q2ntmvFXAyjTyzOsL7PHKUlXR2z1WdVdr2mSARwV5cs7weWdpWH0v
        lQUgEwCRqE5GGMeONmDT4Jz/Of3fTORO5ee/Cerm9gqRJ6+AsyRNHr0Yv03wcP20WFbXdP
        1NyOsABbKcWFqOwVPPg4B46fXe8ZjN8=
Date:   Mon, 9 Jan 2023 17:38:36 +0100
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
Subject: Re: [Patch v4 06/13] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Message-ID: <Y7xDDNMIDyHKLicG@zn.tnic>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <1669951831-4180-7-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1669951831-4180-7-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 07:30:24PM -0800, Michael Kelley wrote:
> Hyper-V guests on AMD SEV-SNP hardware have the option of using the
> "virtual Top Of Memory" (vTOM) feature specified by the SEV-SNP
> architecture. With vTOM, shared vs. private memory accesses are
> controlled by splitting the guest physical address space into two
> halves.  vTOM is the dividing line where the uppermost bit of the
> physical address space is set; e.g., with 47 bits of guest physical
> address space, vTOM is 0x400000000000 (bit 46 is set).  Guest physical
> memory is accessible at two parallel physical addresses -- one below
> vTOM and one above vTOM.  Accesses below vTOM are private (encrypted)
> while accesses above vTOM are shared (decrypted). In this sense, vTOM
> is like the GPA.SHARED bit in Intel TDX.
> 
> Support for Hyper-V guests using vTOM was added to the Linux kernel in
> two patch sets[1][2]. This support treats the vTOM bit as part of
> the physical address. For accessing shared (decrypted) memory, these
> patch sets create a second kernel virtual mapping that maps to physical
> addresses above vTOM.
> 
> A better approach is to treat the vTOM bit as a protection flag, not
> as part of the physical address. This new approach is like the approach
> for the GPA.SHARED bit in Intel TDX. Rather than creating a second kernel
> virtual mapping, the existing mapping is updated using recently added
> coco mechanisms.  When memory is changed between private and shared using
> set_memory_decrypted() and set_memory_encrypted(), the PTEs for the
> existing kernel mapping are changed to add or remove the vTOM bit
> in the guest physical address, just as with TDX. The hypercalls to
> change the memory status on the host side are made using the existing
> callback mechanism. Everything just works, with a minor tweak to map
> the IO-APIC to use private accesses.
> 
> To accomplish the switch in approach, the following must be done in
> this single patch:

s/in this single patch//

> * Update Hyper-V initialization to set the cc_mask based on vTOM
>   and do other coco initialization.
> 
> * Update physical_mask so the vTOM bit is no longer treated as part
>   of the physical address
> 
> * Remove CC_VENDOR_HYPERV and merge the associated vTOM functionality
>   under CC_VENDOR_AMD. Update cc_mkenc() and cc_mkdec() to set/clear
>   the vTOM bit as a protection flag.
> 
> * Code already exists to make hypercalls to inform Hyper-V about pages
>   changing between shared and private.  Update this code to run as a
>   callback from __set_memory_enc_pgtable().
> 
> * Remove the Hyper-V special case from __set_memory_enc_dec()
> 
> * Remove the Hyper-V specific call to swiotlb_update_mem_attributes()
>   since mem_encrypt_init() will now do it.
> 
> [1] https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com/
> [2] https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com/
> 
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>  arch/x86/coco/core.c             | 37 ++++++++++++++++++++--------
>  arch/x86/hyperv/hv_init.c        | 11 ---------
>  arch/x86/hyperv/ivm.c            | 52 +++++++++++++++++++++++++++++++---------
>  arch/x86/include/asm/coco.h      |  1 -
>  arch/x86/include/asm/mshyperv.h  |  8 ++-----
>  arch/x86/include/asm/msr-index.h |  1 +
>  arch/x86/kernel/cpu/mshyperv.c   | 15 ++++++------
>  arch/x86/mm/pat/set_memory.c     |  3 ---
>  8 files changed, 78 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index 49b44f8..c361c52 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -44,6 +44,24 @@ static bool intel_cc_platform_has(enum cc_attr attr)
>  static bool amd_cc_platform_has(enum cc_attr attr)
>  {
>  #ifdef CONFIG_AMD_MEM_ENCRYPT
> +
> +	/*
> +	 * Handle the SEV-SNP vTOM case where sme_me_mask must be zero,
> +	 * and the other levels of SME/SEV functionality, including C-bit
> +	 * based SEV-SNP, must not be enabled.
> +	 */
> +	if (sev_status & MSR_AMD64_SNP_VTOM_ENABLED) {

		return amd_cc_platform_vtom();

or so and then stick that switch in there.

This way it looks kinda grafted in front and with a function call with a telling
name it says it is a special case...

> +		switch (attr) {
> +		case CC_ATTR_GUEST_MEM_ENCRYPT:
> +		case CC_ATTR_MEM_ENCRYPT:
> +		case CC_ATTR_ACCESS_IOAPIC_ENCRYPTED:
> +			return true;
> +		default:
> +			return false;
> +		}
> +	}

The rest looks kinda nice, I gotta say. I can't complain. :)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
