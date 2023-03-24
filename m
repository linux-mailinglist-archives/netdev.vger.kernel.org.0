Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741286C8359
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbjCXR2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCXR2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:28:43 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EA67EF3;
        Fri, 24 Mar 2023 10:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679678922; x=1711214922;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Mcsu5T7NDXbU35tcwWViyIcGBa4XNa6+MDZfpZrvpaE=;
  b=MvUvhVtq7ZtBFgXGB2y67AbkEVdAzvvbCpeIk50F8WzTnNYfO62j2XRh
   WhgdgKUZSFdpgE/rPF3fA/ez6USbru7THet7ivLpZi1De1AjusVpa9fil
   p5DIdk1x+3DI0D3tR5+LHjqG3lD1PnZTu6uhpSGPom0JycdI/h4rNgnxl
   hvl5kV2in+3oXc8zqXQ8IcTuU851P1bLi0TnyJsNk7i+n9XZ0RZAHy8Br
   KfqpeEz+aXgd0xRikQSV/4ZNhzvWHQq3RJZREmlYuDX8m7C7XP+IEOEmi
   siJrI/vZlrbW3Kurw17C7YGSnXjC1gciHNBbxJtamdV2vZFVLOLOPdlui
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="404758386"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="404758386"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 10:28:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="793525414"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="793525414"
Received: from bahessel-mobl.amr.corp.intel.com (HELO [10.209.94.88]) ([10.209.94.88])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 10:28:39 -0700
Message-ID: <3224215f-4ac6-713b-9f88-0d68e0572126@linux.intel.com>
Date:   Fri, 24 Mar 2023 10:28:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [PATCH v6 06/13] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Content-Language: en-US
To:     Dexuan Cui <decui@microsoft.com>, Borislav Petkov <bp@alien8.de>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
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
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
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
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
 <1678329614-3482-7-git-send-email-mikelley@microsoft.com>
 <20230320112258.GCZBhCEpNAIk0rUDnx@fat_crate.local>
 <BYAPR21MB16880C855EDB5AD3AECA473DD7809@BYAPR21MB1688.namprd21.prod.outlook.com>
 <20230320181646.GAZBijDiAckZ9WOmhU@fat_crate.local>
 <BYAPR21MB1688DF161ACE142DEA721DA1D7809@BYAPR21MB1688.namprd21.prod.outlook.com>
 <20230323134306.GEZBxXahNkFIx1vyzN@fat_crate.local>
 <20230324154856.GDZB3GaHG/3L0Q1x47@fat_crate.local>
 <SA1PR21MB1335023500AE3E7C8AE6F867BF849@SA1PR21MB1335.namprd21.prod.outlook.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <SA1PR21MB1335023500AE3E7C8AE6F867BF849@SA1PR21MB1335.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 3/24/23 10:10 AM, Dexuan Cui wrote:
>> From: Borislav Petkov <bp@alien8.de>
>> Sent: Friday, March 24, 2023 8:49 AM
>> ...
>> With first six applied:
>>
>> arch/x86/coco/core.c:123:7: error: use of undeclared identifier 'sev_status'
>>                 if (sev_status & MSR_AMD64_SNP_VTOM)
>>                     ^
> 
> Your config doesn't define CONFIG_AMD_MEM_ENCRYPT:
> # CONFIG_AMD_MEM_ENCRYPT is not set

If you have config dependency, I think you should fix it in the code or add
Kconfig dependency.

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
