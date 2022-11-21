Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288D9632BDA
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiKUSQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiKUSQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:16:15 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F906C0514;
        Mon, 21 Nov 2022 10:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669054575; x=1700590575;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=xX4/g0oio96LX1HY5otdCTZt6qmKzdQZbF++Ebk/k10=;
  b=M99Ryvqhu+0BlN6oNZ/Zps6K3vdP3mZNFglZBqamyDtAJUqWye2GiQCI
   3kVkyCGCDbUaj7yPoMZ20zmoND2y5vSlqonMGtDdQTD+mQWUSw6jEDXHF
   vhxZWxHVKmxk9ZOWgjfYa6rUgX/Dr05cWyJ4Z7dlhm/Auu3mm6XGSCtel
   rUn0O2wljt1upR7x7VYFqkyK2c/suNFDI7HfS6aOK530wdkm63Dn3YW+m
   Q+oNegRoUHXRhhpZbedA2YZSkqYA4yj9JvrzbBNBnJHXbubo9Fl2Nv8M0
   7TLGwHo/l1gBiABJgAvkswRVzKRXrIB62wf0JxP0of1/uK0vErmkEgz8C
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="293337899"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="293337899"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 10:14:39 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="709905335"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="709905335"
Received: from ticela-or-327.amr.corp.intel.com (HELO [10.209.6.63]) ([10.209.6.63])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 10:14:28 -0800
Message-ID: <e5f9529f-955c-fc28-5d46-c77f23a71d04@intel.com>
Date:   Mon, 21 Nov 2022 10:14:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [Patch v3 01/14] x86/ioremap: Fix page aligned size calculation
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
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-2-git-send-email-mikelley@microsoft.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <1668624097-14884-2-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/22 10:41, Michael Kelley wrote:
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

Looks good:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

Although I do agree with Boris that this superficially looks like
something that's important to backport.  It would be best to either beef
up the changelog to explain why that's not the case, or to treat this as
an actual fix and submit separately.
