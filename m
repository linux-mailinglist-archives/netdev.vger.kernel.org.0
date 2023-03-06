Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31AB66AD0D4
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCFVvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjCFVvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:51:07 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D20862D8B;
        Mon,  6 Mar 2023 13:51:06 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 645651EC0373;
        Mon,  6 Mar 2023 22:51:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1678139464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZcMCliQs5T2pgPApnAR1x0YFEL96itD44N0jLsGaXgQ=;
        b=BE+qJc2rT1BVVGQjQtVN1VU23K9ps6I+5GT/nqUHZmIagIglFZLKot+VP4zRkBAPauEzGy
        yxINZtrTb7YccV3vtMI3Hqj4U+AKE7uNYf4iwdrP4wHjlUA2enUjve3en1uiov2yU4qPGa
        cYI94G79L+ABKsKYlLPF8CjD+oagt3s=
Date:   Mon, 6 Mar 2023 22:51:04 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
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
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Message-ID: <20230306215104.GEZAZgSPa4qBBu9lRd@fat_crate.local>
References: <BYAPR21MB16880EC9C85EC9343F9AF178D7A19@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y++VSZNAX9Cstbqo@zn.tnic>
 <Y/aTmL5Y8DtOJu9w@google.com>
 <Y/aYQlQzRSEH5II/@zn.tnic>
 <Y/adN3GQJTdDPmS8@google.com>
 <Y/ammgkyo3QVon+A@zn.tnic>
 <Y/a/lzOwqMjOUaYZ@google.com>
 <Y/dDvTMrCm4GFsvv@zn.tnic>
 <BYAPR21MB1688F68888213E5395396DD9D7AB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <255249f2-47af-07b7-d9d9-9edfdd108348@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <255249f2-47af-07b7-d9d9-9edfdd108348@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 12:27:50PM -0800, Dave Hansen wrote:
> On 2/23/23 12:01, Michael Kelley (LINUX) wrote:
> > Dave Hansen:  Are you also OK with Sean's proposal?  Looking for consensus
> > here ....
> 
> Yeah, I'm generally OK with it as long as Borislav is.

Right, I think we're ok with the following basic rules:

- pure arch/x86/ code should use the x86_platform function pointers to
  query hypervisor capabilities/peculiarities

- cc_platform_has() should be used in generic/driver code as it
  abstracts away the underlying platform better. IOW, querying
  x86_platform.... in generic, platform-agnostic driver code looks weird to
  say the least

The hope is that those two should be enough to support most guest types
and not let the zoo get too much out of hand...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
