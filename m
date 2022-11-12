Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108536265DC
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 01:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbiKLALm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 19:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234537AbiKLALh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 19:11:37 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052DA54B1A;
        Fri, 11 Nov 2022 16:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668211896; x=1699747896;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=LiZwmYGwAznYW6wrpo4GEBOGDwQrkWj7tTELRkONMMw=;
  b=Ny7JK8HlDrFRt5trB8P87UdEy36SRNwkKbkK5Q6HUb6MMK14SVOHUwh3
   YwcA3jc/+4bWBtgh3ELR1LQQPAvwQPpboqLBIN5+4faSnMzEaIDsi7CTe
   PBPo6CuEA6LRF0XCasaoKb8VbqnQCx72bVXujZA95PMZpfxDqor5pWOAR
   QNbQFX8WCnVhcA6sqRPWokmzpDYKBpoXFP+rMJQUhONGwNck04YG8Sz62
   2q+9vg9NIa27tBBAhpc5KETG7ui7BqMaJFac/+eskgR3slGU+1xoej/Zp
   kNivApIiDEkX3/TwBg3GID0Bz7t/i7IadFNZge/bkB+2mz67W/VYVFyL6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="313484745"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="313484745"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 16:11:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="615617910"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="615617910"
Received: from nmpoonaw-mobl1.amr.corp.intel.com (HELO [10.252.134.46]) ([10.252.134.46])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 16:11:33 -0800
Message-ID: <7d621ab2-6717-c6b6-5c3c-90af4c2f4afc@intel.com>
Date:   Fri, 11 Nov 2022 16:11:32 -0800
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
> If applying the PHYSICAL_PAGE_MASK to the phys_addr argument causes
> upper bits to be masked out, the re-calculation of size to account for
> page alignment is incorrect because the same bits are not masked out
> in last_addr.
> 
> Fix this by masking the page aligned last_addr as well.

This makes sense at first glance.

How did you notice this?  What is the impact to users?  Did the bug
actually cause you some trouble or was it by inspection?  Do you have a
sense of how many folks might be impacted?  Any thoughts on how it
lasted for 14+ years?

For the functionality of the mapping, I guess 'size' doesn't really
matter because even a 1-byte 'size' will map a page.  The other fallout
would be from memtype_reserve() reserving too little.  But, that's
unlikely to matter for small mappings because even though:

	ioremap(0x1800, 0x800);

would end up just reserving 0x1000->0x1800, it still wouldn't allow

	ioremap(0x1000, 0x800);

to succeed because *both* of them would end up trying to reserve the
beginning of the page.  Basically, the first caller effectively reserves
the whole page and any second user will fail.

So the other place it would matter would be for mappings that span two
pages, say:

	ioremap(0x1fff, 0x2)

But I guess those aren't very common.  Most large ioremap() callers seem
to already have base and size page-aligned.

Anyway, sorry to make so much of a big deal about a one-liner.  But,
these decade-old bugs really make me wonder how they stuck around for so
long.

I'd be curious if you thought about this too while putting together this
fox.
