Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88EE76349EA
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbiKVWS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiKVWS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:18:26 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8186152F;
        Tue, 22 Nov 2022 14:18:23 -0800 (PST)
Received: from zn.tnic (p200300ea9733e747329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e747:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3C0BA1EC064F;
        Tue, 22 Nov 2022 23:18:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669155502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=vW0B+TAHUwisjxfaBne/M3qasDBVG7nKJqzQcmiMG10=;
        b=MFe6z+1Kfz6XbF4ixEsnZwacl3uI2WXTk9DxxQCdQhBv+K/6F/9E0blW+kMZCgQzdMAYwA
        A/GgxEvERo1EGXqiNoRejymtMKj06+CpGkudbfhEsA+iekLVAVIr19epOSW6cDTRx5gEwa
        NA2MiaKjV0NXc0/Pm9xqIRQZYW3FNu4=
Date:   Tue, 22 Nov 2022 23:18:17 +0100
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
Message-ID: <Y31Kqacbp9R5A1PF@zn.tnic>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
 <Y3uTK3rBV6eXSJnC@zn.tnic>
 <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 06:22:46PM +0000, Michael Kelley (LINUX) wrote:
> I think the core problem here is the naming and meaning of
> CC_VENDOR_HYPERV. The name was created originally when the
> Hyper-V vTOM handling code was a lot of special cases.   With the
> changes in this patch series that make the vTOM functionality more
> mainstream, the name would be better as CC_VENDOR_AMD_VTOM.

No, if CC_VENDOR_HYPERV means different things depending on what kind of
guests you're doing, then you should not use a CC_VENDOR at all.

> vTOM is part of the AMD SEV-SNP spec, and it's a different way of
> doing the encryption from the "C-bit" based approach. As much as
> possible, I'm trying to not make it be Hyper-V specific, though
> currently we have N=1 for hypervisors that offer the vTOM option, so
> it's a little hard to generalize.

Actually, it is very simple to generalize: vTOM and the paravisor and
VMPL are all part of the effort to support unenlightened, unmodified
guests with SNP.

So, if KVM wants to run Windows NT 4.0 guests as SNP guests, then it
probably would need the same contraptions.

> With the thinking oriented that way, a Linux guest on Hyper-V using
> TDX will run with CC_VENDOR_INTEL.  A Linux guest on Hyper-V that
> is fully enlightened to use the "C-bit" will run with CC_VENDOR_AMD.

Right.

> Dexuan Cui just posted a patch set for initial TDX support on Hyper-V,
> and I think that runs with CC_VENDOR_INTEL (Dexuan -- correct me if
> I'm wrong about that -- I haven't reviewed your patches yet).  Tianyu Lan
> has a patch set out for Hyper-V guests using the "C-bit".  That patch set
> still uses CC_VENDOR_HYPERV.  Tianyu and I need to work through
> whether his patch set can run with CC_VENDOR_AMD like everyone
> else using the "C-bit" approach.

So I'm not sure the vendor is the right approach here. I guess we need
to specify the *type* of guest being supported.

> Yes, the polarity of the AMD vTOM bit matches the polarity of the
> TDX GPA.SHARED bit, and is the opposite polarity of the AMD "C-bit".
> I'll add a comment to that effect.
> 
> Anyway, that's where I think this should go. Does it make sense?
> Other thoughts?

I think all that polarity doesn't matter as long as we abstract it away
with, "mark encrypted" and "mark decrypted".

But it is late now and I could be wrong - I'll look at the rest
tomorrow-ish.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
