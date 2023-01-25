Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC53167B534
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbjAYOz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235922AbjAYOzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:55:48 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9C630FE;
        Wed, 25 Jan 2023 06:55:46 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C565B1EC0493;
        Wed, 25 Jan 2023 15:55:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1674658543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Y5InzrMMR7tYD7K8IQxbCKmCrcbndsF98jURDpiEvtA=;
        b=QhsVXgG9+mQg62pSTSotZNXiTHgj4Kr6DjoD6RzyyIrLoNuw0inT+OEDkhvYR4sZ9y9twf
        dkUtWiZR9A2rC/a29R9t7FALlEu268HgkolBGU6CkU1ELWPMp15xxUqQFFuhLce3GKLUNv
        ZZy1MIaPxdrIzvmknDNQqsceFa0jwx4=
Date:   Wed, 25 Jan 2023 15:55:40 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
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
        "seanjc@google.com" <seanjc@google.com>,
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
Message-ID: <Y9FC7Dpzr5Uge/Mi@zn.tnic>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
 <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
 <Y8r2TjW/R3jymmqT@zn.tnic>
 <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 21, 2023 at 04:10:23AM +0000, Michael Kelley (LINUX) wrote:
> Per the commit message for 009767dbf42a, it's not safe to read MSR_AMD64_SEV
> on all implementations of AMD processors.

1. Why does that matter to you? This is Hygon.

2. The MSR access is behind CPUID check.

> CC_ATTR_ACCESS_IOAPIC_ENCRYPTED is used in io_apic_set_fixmap(), which is
> called on all Intel/AMD systems without any qualifications.   Even if
> rdmsrl_safe() works at this point in boot, I'm a little leery of reading a new
> MSR in a path that essentially every x86 bare-metal system or VM takes during
> boot.

You read the MSR once and cache it. sme_enable() already does that. I don't see
what the problem is.

> Or am I being overly paranoid about old processor models or hypervisor
> versions potentially doing something weird?

Yes, you are. :)

If they're doing something weird which is out of spec, then we'll deal with them
later.

> But in any case, the whole point of cc_platform_has() is to provide a level of
> abstraction from the hardware registers, and it's fully safe to use on every x86
> bare-metal system or VM.  And while I don't anticipate it now, maybe there's
> some future scheme where a paravisor-like entity could be used with Intel
> TDX.  It seems like using a cc_platform_has() abstraction is better than directly
> accessing the MSR.

That's fine but we're talking about this particular implementation and that is
vTOM-like with the address space split. If TDX does address space split later,
we can accomodate it too. (Although I think they are not interested in this).

And if you really want to use cc_platform_has(), we could do

	cc_platform_has(CC_ADDRESS_SPACE_SPLIT_ON_A_PARAVISOR)

or something with a better name.

The point is, you want to do things which are specific for this particular
implementation. If so, then check for it. Do not do hacky things which get the
work done for your case but can very easily be misused by others.

> My resolution of the TPM driver issue is admittedly a work-around.   I think
> of it as temporary in anticipation of future implementations of PCIe TDISP
> hardware, which allows PCI devices to DMA directly into guest encrypted
> memory.

Yap, that sounds real nice.

> TDISP also places the device's BAR values in an encrypted portion
> of the GPA space. Assuming TDISP hardware comes along in the next couple
> of years, Linux will need a robust way to deal with a mix of PCI devices
> being in unencrypted and encrypted GPA space.  I don't know how a
> specific device will be mapped correctly, but I hope it can happen in the
> generic PCI code, and not by modifying each device driver.

I guess those devices would advertize that capability somehow so that code can
query it and act accordingly.

> It's probably premature to build that robust mechanism now, but when it comes,
> my work-around would be replaced.

It would be replaced if it doesn't have any users. By the looks of it, it'll
soon grow others and then good luck removing it.

> With all that in mind, I don't want to modify the TPM driver to special-case
> its MMIO space being encrypted.  FWIW, the TPM driver today uses
> devm_ioremap_resource() to do the mapping, which defaults to mapping
> decrypted except for the exceptions implemented in __ioremap_caller().
> There's no devm_* option for specifying encrypted.

You mean, it is hard to add a DEVM_IOREMAP_ENCRYPTED type which will have
__devm_ioremap() call ioremap_encrypted()?

Or define a IORESOURCE_ENCRYPTED and pass it through the ioresource flags?

Why is that TPM driver so precious that it can be touched and the arch code
would have to accept hacks?

> Handling decrypted vs. encrypted in the driver would require extending the
> driver API to provide an "encrypted" option, and that seems like going in the
> wrong long-term direction.

Sorry, I can't follow here.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
