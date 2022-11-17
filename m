Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343E862E744
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbiKQVro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiKQVrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:47:39 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E446A69DD8;
        Thu, 17 Nov 2022 13:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668721658; x=1700257658;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=0xIE0lGR+1HvQFnathUuD8Giy/crD3N1QjHrDya9xTk=;
  b=U/ChOYXC27GRWC2VvwYixln6dj5kV5LFA4e6S67p7LiE5cISxSmQOlfc
   nfGpeq6SQFSnRVNcA5MxHUCCpU/vTQY5NukqL8SqtGj7J0ao9+4WnZ3d9
   434918MKKFpCjieaO5X7kgP5rjClM2HXvFHmWun1im5FbvyMJUxMH6F59
   maEr6fMdlqOlF+PVkjckE6qXR+cMDddJky5doIBeubb8Ew5xrn7xKhymW
   H2lRahQ9tE5lbHF9P/+phCupu5+OEqVeRytMMtFgsnurc9NQTW4NaRlby
   iEZJ/sqVX5v855BH6FCeb5TZLbNrw4wi6cf/Z+5X30yJyjBR1bQxj9dSg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="399271322"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="399271322"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 13:47:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="642261895"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="642261895"
Received: from wangyi7-mobl3.amr.corp.intel.com (HELO [10.212.182.5]) ([10.212.182.5])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 13:47:35 -0800
Message-ID: <01d7c7cc-bd4e-ee9b-f5b2-73ea367e602f@linux.intel.com>
Date:   Thu, 17 Nov 2022 13:47:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Content-Language: en-US
To:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lpieralisi@kernel.org, robh@kernel.org,
        kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        ak@linux.intel.com, isaku.yamahata@intel.com,
        dan.j.williams@intel.com, jane.chu@oracle.com, seanjc@google.com,
        tony.luck@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/16/22 10:41 AM, Michael Kelley wrote:
> Current code in sme_postprocess_startup() decrypts the bss_decrypted
> section when sme_me_mask is non-zero.  But code in
> mem_encrypt_free_decrytped_mem() re-encrypts the unused portion based
> on CC_ATTR_MEM_ENCRYPT.  In a Hyper-V guest VM using vTOM, these
> conditions are not equivalent as sme_me_mask is always zero when
> using vTOM.  Consequently, mem_encrypt_free_decrypted_mem() attempts
> to re-encrypt memory that was never decrypted.
> 
> Fix this in mem_encrypt_free_decrypted_mem() by conditioning the
> re-encryption on the same test for non-zero sme_me_mask.  Hyper-V
> guests using vTOM don't need the bss_decrypted section to be
> decrypted, so skipping the decryption/re-encryption doesn't cause
> a problem.
> 

Do you think it needs Fixes tag?

> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>  arch/x86/mm/mem_encrypt_amd.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
> index 9c4d8db..5a51343 100644
> --- a/arch/x86/mm/mem_encrypt_amd.c
> +++ b/arch/x86/mm/mem_encrypt_amd.c
> @@ -513,10 +513,14 @@ void __init mem_encrypt_free_decrypted_mem(void)
>  	npages = (vaddr_end - vaddr) >> PAGE_SHIFT;
>  
>  	/*
> -	 * The unused memory range was mapped decrypted, change the encryption
> -	 * attribute from decrypted to encrypted before freeing it.
> +	 * If the unused memory range was mapped decrypted, change the encryption
> +	 * attribute from decrypted to encrypted before freeing it. Base the
> +	 * re-encryption on the same condition used for the decryption in
> +	 * sme_postprocess_startup(). Higher level abstractions, such as
> +	 * CC_ATTR_MEM_ENCRYPT, aren't necessarily equivalent in a Hyper-V VM
> +	 * using vTOM, where sme_me_mask is always zero.
>  	 */
> -	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT)) {
> +	if (sme_get_me_mask()) {
>  		r = set_memory_encrypted(vaddr, npages);
>  		if (r) {
>  			pr_warn("failed to free unused decrypted pages\n");

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
