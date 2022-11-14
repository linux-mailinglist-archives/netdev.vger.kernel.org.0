Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC327628651
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237993AbiKNQ7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238146AbiKNQ6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:58:43 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81C43E0AF;
        Mon, 14 Nov 2022 08:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668445073; x=1699981073;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=1yAuHjiGqTYi1byh38jC/erNusV9XXEVsRIKu4bAuk0=;
  b=efQ2Q9cn77vT/6XoiaWuk8H1Y8DLJaPrj2GACPyk6WDmjMO52Th4Fgqk
   SfrM5vp0XHjvDZDlO8QQbUCQU/34f3+Cpmg5s7qLiasP9C7B02PKvPk8Z
   rZ/JK+EdFyd5F2aKOO4KtM7oaIEcUjwrOQDQJXl0F5qK8vBZ2NmBmT07L
   0i6xp21pFfXaJ3N0Zzki/6JJEAeDdqypQMShwxkHmkOaZWJTPQcw2tp8C
   k1pQquehQ+pa4v+lvj3EODDW7zUUn0xh9WnCR8o/ChjmsLCaALJ0vZ/ZE
   10P+jjVH5EL1AGqFyRSMNQTkwY0pPE8iF3MFevG5EOzACMSUalnnIQviM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="338810175"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="338810175"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 08:57:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="669729848"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="669729848"
Received: from satyanay-mobl1.amr.corp.intel.com (HELO [10.209.114.162]) ([10.209.114.162])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 08:57:50 -0800
Message-ID: <10a4eb94-4764-717b-7c20-64a3d895b3d1@intel.com>
Date:   Mon, 14 Nov 2022 08:57:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 01/12] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Content-Language: en-US
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
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
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
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
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
 <1668147701-4583-2-git-send-email-mikelley@microsoft.com>
 <feca1a0a-b9b2-44d9-30e9-c6a6aa11f6cd@intel.com>
 <BYAPR21MB1688430B2111541FE68D3569D7059@BYAPR21MB1688.namprd21.prod.outlook.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <BYAPR21MB1688430B2111541FE68D3569D7059@BYAPR21MB1688.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/22 08:53, Michael Kelley (LINUX) wrote:
>> Because, first of all, that "Mappings have to be page-aligned" thing is
>> (now) doing more than page-aligning things.  Second, the moment you mask
>> out the metadata bits, the 'size' calculation gets harder.  Doing it in
>> two phases (page alignment followed by metadata bit masking) breaks up
>> the two logical operations.
>>
> Work for me.  Will do this in v3.

Kirill also made a good point about TDX: it isn't affected by this
because it always passes *real* (no metadata bits set) physical
addresses in here.  Could you double check that you don't want to do the
same for your code?


