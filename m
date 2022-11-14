Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A863F6285AD
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237985AbiKNQlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237744AbiKNQkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:40:45 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135D227B3B;
        Mon, 14 Nov 2022 08:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668444016; x=1699980016;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=NyFJv37USCMkGKKFF9UUCmmK2dRvMkUuHiokinRnJZs=;
  b=JVst40f4+hpLUI6jEHgt0GhQN2o8/Sz01GUTwKWdCL6U5V2ERkjvaSM9
   /mqic9m63LZEypQZc12Kv6G0szaW5lkOJ4iXxI73CAd3q1CZOzePFSurT
   sy+qiZruNljhKxxOHe6d8mLhmrOUv23sYdxJN9CgsMOypLC0wuGOIapn6
   uoki3+A3w0xRrV+YcQOpPHyh144lIpq6XNpg3XnLlaNSJMX00VLD9UeLx
   DKvSG1EAZnAA6xWhN8vxvjg2c7xboetIXYnPdD1gTtRvd0KtiH1iMxMn7
   Myc06/k8ZFx/ovHe2/6rIONzUu0BV7sOQ4Y6+3Pd1AhPp91SjvtG5LVVN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="292414327"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="292414327"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 08:40:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616377843"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="616377843"
Received: from satyanay-mobl1.amr.corp.intel.com (HELO [10.209.114.162]) ([10.209.114.162])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 08:40:14 -0800
Message-ID: <feca1a0a-b9b2-44d9-30e9-c6a6aa11f6cd@intel.com>
Date:   Mon, 14 Nov 2022 08:40:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 01/12] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
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
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
 <1668147701-4583-2-git-send-email-mikelley@microsoft.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <1668147701-4583-2-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/22 22:21, Michael Kelley wrote:
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -218,7 +218,7 @@ static void __ioremap_check_mem(resource_size_t addr, unsigned long size,
>  	 */
>  	offset = phys_addr & ~PAGE_MASK;
>  	phys_addr &= PHYSICAL_PAGE_MASK;
> -	size = PAGE_ALIGN(last_addr+1) - phys_addr;
> +	size = (PAGE_ALIGN(last_addr+1) & PHYSICAL_PAGE_MASK) - phys_addr;

Michael, thanks for the explanation in your other reply.  First and
foremost, I *totally* missed the reason for this patch.  I was thinking
about issues that could pop up from the _lower_ bits being masked off.

Granted, your changelog _did_ say "upper bits", so shame on me.  But, it
would be great to put some more background in the changelog to make it a
bit harder for silly reviewers to miss such things.

I'd also like to propose something that I think is more straightforward:

        /*
         * Mappings have to be page-aligned
         */
        offset = phys_addr & ~PAGE_MASK;
        phys_addr &= PAGE_MASK;
        size = PAGE_ALIGN(last_addr+1) - phys_addr;

	/*
	 * Mask out any bits not parts of the actual physical
	 * address, like memory encryption bits.
	 */
	phys_addr &= PHYSICAL_PAGE_MASK;

Because, first of all, that "Mappings have to be page-aligned" thing is
(now) doing more than page-aligning things.  Second, the moment you mask
out the metadata bits, the 'size' calculation gets harder.  Doing it in
two phases (page alignment followed by metadata bit masking) breaks up
the two logical operations.


