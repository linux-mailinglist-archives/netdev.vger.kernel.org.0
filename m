Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16DD675EC9
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 21:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjATUPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 15:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjATUPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 15:15:18 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7167CAED83;
        Fri, 20 Jan 2023 12:15:17 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E66031EC068B;
        Fri, 20 Jan 2023 21:15:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1674245716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=URGCdxWMZB194yM7DqWI/LMbwc4I1xa66tqKx+JFPCM=;
        b=miS51UW/cZawfDQzsiX5CMN7crQiXDw1rMl2UJLaGR2uSVeW8sv9hplnApztEqWEwfO7Jh
        PtnaNoT5kqitY/1kkbgEHXWHMNKdN3tDeYyS7c9LYJ+wUXg1qeeL0xx0KfbOxWcG52mFQq
        4cXVDL/7CFzDHD6zREWhJAQhmU/gqZk=
Date:   Fri, 20 Jan 2023 21:15:10 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Subject: Re: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Message-ID: <Y8r2TjW/R3jymmqT@zn.tnic>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
 <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 01:42:25PM -0800, Michael Kelley wrote:
> In a AMD SEV-SNP VM using vTOM, devices in MMIO space may be provided by
> the paravisor and need to be mapped as encrypted.  Provide a function
> for the hypervisor to specify the address range for such devices.
> In __ioremap_caller(), map addresses in this range as encrypted.
> 
> Only a single range is supported. If multiple devices need to be
> mapped encrypted, the paravisor must place them within the single
> contiguous range.

This already is starting to sound insufficient and hacky. And it also makes
CC_ATTR_ACCESS_IOAPIC_ENCRYPTED insufficient either.

So, the situation we have is, we're a SEV-SNP VM using vTOM. Which means,
MSR_AMD64_SEV[3] = 1. Or SEV_FEATURES[1], alternatively - same thing.

That MSR cannot be intercepted by the HV and we use it extensively in Linux when
it runs as a SEV-* guest. And I had asked this before, during review, but why
aren't you checking this bit above when you wanna do vTOM-specific work?

Because then you can do that check and

1. map the IO-APIC encrypted
2. map MMIO space of devices from the driver encrypted too
3. ...

and so on.

And you won't need those other, not as nice things...

Hmmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
