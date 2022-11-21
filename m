Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8604D632F8C
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 23:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiKUWHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 17:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKUWHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 17:07:14 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5521CFE0;
        Mon, 21 Nov 2022 14:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669068433; x=1700604433;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7JevZklHRhgjJyAYKj9U70VX+jOIJ49nUGohqNammx8=;
  b=NS/PVYOBTaAlax1OuU3XXbzvjulq6xOJ1WYNlFzav9W9igVZ3K8RAMVC
   JibwbUziJJUpYBdHrBO514C+2GJ81K78qt/uKQW7Ca/MZMJcI/5iyLxAf
   ucaLYNLR5gmuvtUTegGgwZyV9lq2GN9NJ0UOGpaFDpwGsa79YciLd06FY
   QuhUsg+IqaTLudbTDb/RyStUqiP4Y+xWY1xoREoPkCcDkycTbADknQdRR
   ymQDOQNwgaepQfW0sMxyTPMS30wtaWtelSyiyabPvT6cN/Tta+zKf/KsT
   +ellQIbW+jtpUYD6Bt8sepYHzLYWk3Ev/JZDpuX3Lp9SgDotwBlG/sMbx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="377930927"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="377930927"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 14:06:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="672250971"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="672250971"
Received: from dylanhol-mobl.amr.corp.intel.com (HELO [10.212.242.103]) ([10.212.242.103])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 14:06:54 -0800
Message-ID: <6b5129cf-6986-bbb1-7e60-37849fc383fc@linux.intel.com>
Date:   Mon, 21 Nov 2022 14:06:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
 <01d7c7cc-bd4e-ee9b-f5b2-73ea367e602f@linux.intel.com>
 <BYAPR21MB1688A31ED795ED1B5ACB6D26D7099@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y3uNj0z26EjkHeCn@zn.tnic>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <Y3uNj0z26EjkHeCn@zn.tnic>
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



On 11/21/22 6:39 AM, Borislav Petkov wrote:
> On Fri, Nov 18, 2022 at 02:55:32AM +0000, Michael Kelley (LINUX) wrote:
>> But I had not thought about TDX.  In the TDX case, it appears that
>> sme_postprocess_startup() will not decrypt the bss_decrypted section.
>> The corresponding mem_encrypt_free_decrypted_mem() is a no-op unless
>> CONFIG_AMD_MEM_ENCRYPT is set.  But maybe if someone builds a
>> kernel image that supports both TDX and AMD encryption, it could break
> 
> sme_me_mask better be 0 on a kernel with both built in and running as a
> TDX guest.
> 

Yes. It will be 0 in TDX. In sme_enable(), AMD code checks for CPUID
support before updating the sme_me_mask.

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
