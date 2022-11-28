Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0946363AECA
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 18:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbiK1RYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 12:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiK1RYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 12:24:45 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592A318B07;
        Mon, 28 Nov 2022 09:24:44 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 984241EC04AD;
        Mon, 28 Nov 2022 18:24:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669656282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ofHbYnVy9pKGLSG0CBINcLO5iWDquzjR2O+Lfhp2bVE=;
        b=lhtKPFxwjXRviivf+ftwO4wDLoSdBCc7ijyJe8F/HpUJE4ImtI4M4kjomQFSbCxWEEbXiE
        5fXt2Xrz/OWphZ0Pn9/KMZBNi1UW19mtA9Q5KaKTr8fnxJrxoIyFz0aKgV/RScSFs4ni4t
        ZeRfT/y2iGQovaYjAuBpE0EmeFOHEZA=
Date:   Mon, 28 Nov 2022 18:24:38 +0100
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
Subject: Re: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Message-ID: <Y4Tu1tx6E1CfnrJi@zn.tnic>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
 <Y3uTK3rBV6eXSJnC@zn.tnic>
 <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y31Kqacbp9R5A1PF@zn.tnic>
 <BYAPR21MB16886FF8B35F51964A515CD5D70C9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <BYAPR21MB1688AF2F106CDC14E4F97DB4D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Ti4UTBRGmbi0hD@zn.tnic>
 <BYAPR21MB1688466C7766148C6B3B4684D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BYAPR21MB1688466C7766148C6B3B4684D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 04:59:27PM +0000, Michael Kelley (LINUX) wrote:
> 2) The Linux guest must set the vTOM flag in a PTE to access a page
> as unencrypted.

What exactly do you call the "vTOM flag in the PTE"?

I see this here:

"When bit 1 (vTOM) of SEV_FEATURES is set in the VMSA of an SNP-active
VM, the VIRTUAL_TOM field is used to determine the C-bit for data
accesses instead of the guest page table contents. All data accesses
below VIRTUAL_TOM are accessed with an effective C-bit of 1 and all
addresses at or above VIRTUAL_TOM are accessed with an effective C-bit
of 0."

Now you say

"vTOM is the dividing line where the uppermost bit of the physical
address space is set; e.g., with 47 bits of guest physical address
space, vTOM is 0x40000000000 (bit 46 is set)."

So on your guests, is VIRTUAL_TOM == 0x400000000000?

Btw, that 0x4000.. does not have bit 46 set but bit 42. Bit 46 set is

	0x400000000000

which means one more '0' at the end.

So before we discuss this further, let's agree on the basics first.

> What Windows guests do isn't really relevant.  Again, the code in this patch
> series all runs directly in the Linux guest, not the paravisor.  And the Linux
> guest isn't unmodified.  We've added changes to understand vTOM and
> the need to communicate with the hypervisor about page changes
> between private and shared.  But there are other changes for a fully
> enlightened guest that we don't have to make when using AMD vTOM,
> because the paravisor transparently (to the guest -- Linux or Windows)
> handles those issues.

So this is some other type of guest you wanna run.

Where is the documentation of that thing?

I'd like to know what exactly it is going to use in the kernel.

> Again, no.  What I have proposed as CC_VENDOR_AMD_VTOM is

There's no vendor AMD_VTOM!

We did the vendor thing to denote Intel or AMD wrt to confidential
computing.

Now you're coming up with something special. It can't be HYPERV because
Hyper-V does other types of confidential solutions too, apparently.

Now before this goes any further I'd like for "something special" to be
defined properly and not just be a one-off Hyper-V thing.

> specific to AMD's virtual-Top-of-Memory architecture.  The TDX
> architecture doesn't really have a way to use a paravisor.
> 
> To summarize, the code in this patch series is about a 3rd encryption
> scheme that is used by the guest.

Yes, can that third thing be used by other hypervisors or is this
Hyper-V special?

> It is completely parallel to the AMD C-bit encryption scheme and
> the Intel TDX encryption scheme. With the AMD vTOM scheme, there is
> a paravisor that transparently emulates some things for the guest
> so there are fewer code changes needed in the guest, but this patch
> series is not about that paravisor code.

Would other hypervisors want to support such a scheme?

Is this architecture documented somewhere? If so, where?

What would it mean for the kernel to support it.

And so on and so on.

Thanks.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
