Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A786A0685
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbjBWKpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbjBWKpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:45:24 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB9628D0B;
        Thu, 23 Feb 2023 02:45:23 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2A7101EC06D8;
        Thu, 23 Feb 2023 11:45:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677149121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=8eflZCArBNS2iTHAutvusXrIThQ3jEI6ZgIoi6B+se4=;
        b=phohTQQkWdVgEHvajC+jqND3J6RrHkQAfEY26jsta89saiUXDjpax72/t8uzsykiPJTRAp
        wELV5m3c0rpFSuB9kPVe4/xWfwZUbq0+qD7UZZAn5zsd6GJrzIJJ4KLaNv+bRBAxyk8yY4
        05KPHD5NTscdl5DEOeJB5BZsKM8fqEU=
Date:   Thu, 23 Feb 2023 11:45:17 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Dave Hansen <dave.hansen@intel.com>,
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
Message-ID: <Y/dDvTMrCm4GFsvv@zn.tnic>
References: <Y+4wiyepKU8IEr48@zn.tnic>
 <BYAPR21MB168853FD0676CCACF7C249B0D7A09@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+5immKTXCsjSysx@zn.tnic>
 <BYAPR21MB16880EC9C85EC9343F9AF178D7A19@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y++VSZNAX9Cstbqo@zn.tnic>
 <Y/aTmL5Y8DtOJu9w@google.com>
 <Y/aYQlQzRSEH5II/@zn.tnic>
 <Y/adN3GQJTdDPmS8@google.com>
 <Y/ammgkyo3QVon+A@zn.tnic>
 <Y/a/lzOwqMjOUaYZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/a/lzOwqMjOUaYZ@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 05:21:27PM -0800, Sean Christopherson wrote:
> The MTRR mess isn't unique to coco guests, e.g. KVM explicitly "supports" VMMs
> hiding MTTRs from the guest by defaulting to WB if MTTRs aren't exposed to the
> guest.  Why on earth Hyper-V suddenly needs to enlighten the guest is beyond me,
> but whatever the reason, it's not unique to coco VMs.

Well, TDX can't stomach MTRRs either, reportedly, and I hear we should
try to avoid #VEs for them too.

And this is the problem: all those guest "enlightening" efforts come up
with the weirdest stuff they need to sprinkle around arch/x86/. And if
we let that without paying attention to the big picture, that will
become an unmaintanable mess.

And I'm not proud of some of the stuff we did in arch/x86/ already and
some day they'll get on my nerves just enough...

> All I'm advocating is that for determining whether or not a device should be mapped
> private vs. shared, provide an API so that the hypervisor-specific enlightened code
> can manage that insanity without polluting common code.  If we are ever fortunate
> enough to have common enumeration, e.g. through ACPI or something, the enlightened
> code can simply reroute to the common code.  This is a well established pattern for
> many paravirt features, I don't see why it wouldn't work here.

Yah, that would be good. If the device can know upfront how it needs to
ioremap its address range, then that is fine - we already have
ioremap_encrypted() for example.

What I don't like is hooking conditionals into the common code to figure
out what to do depending on what we're running on.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
