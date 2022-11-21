Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F2F632D27
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiKUTpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKUTpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:45:16 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D03C76A0;
        Mon, 21 Nov 2022 11:45:15 -0800 (PST)
Received: from zn.tnic (p200300ea9733e725329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e725:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1D7071EC03EA;
        Mon, 21 Nov 2022 20:45:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669059914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=P5b4SWEpwjdHbs/SaEnye+cahlzdG2kmJ0e9jMb+r2g=;
        b=Hz5c9OWHGhKRkyTmVzuAfPJFyiaBTj+VZZ3OGJhdc9XkaxCu4vpc31EVCIYsCPfNZfVrYd
        SFHZv45DG4dfpvL57diwCak69jxSyHAuAk0AaX0/cl+i/fym7Dc0ipCRSFWzl3qMwi/fY5
        tnAdZjL9Js8BPlHA3bg7m21jURO6bQ0=
Date:   Mon, 21 Nov 2022 20:45:10 +0100
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
Subject: Re: [Patch v3 01/14] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Message-ID: <Y3vVRnAZmDCyQ3Wo@zn.tnic>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-2-git-send-email-mikelley@microsoft.com>
 <Y3t+BipyGPUV3q8F@zn.tnic>
 <BYAPR21MB168871875A5D58698273E914D70A9@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BYAPR21MB168871875A5D58698273E914D70A9@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 04:40:16PM +0000, Michael Kelley (LINUX) wrote:
> As discussed in a parallel thread [1], the incorrect code here doesn't have
> any real impact in already released Linux kernels.  It only affects the
> transition that my patch series implements to change the way vTOM
> is handled.

Are you sure?

PHYSICAL_PAGE_MASK is controlled by __PHYSICAL_MASK which is determined
by CONFIG_DYNAMIC_PHYSICAL_MASK and __PHYSICAL_MASK_SHIFT which all
differ depending on configurations and also dynamic.

It is probably still ok, in probably all possible cases even though I
wouldn't bet on it.

And this fix is simple and all clear so lemme ask it differently: what
would be any downsides in backporting it to stable, just in case?

> I don't know what the tradeoffs are for backporting a fix that doesn't solve
> a real problem vs. just letting it be.  Every backport carries some overhead
> in the process

Have you seen the deluge of stable fixes? :-)

> and there's always a non-zero risk of breaking something.

I don't see how this one would cause any breakage...

> I've leaned away from adding the "Fixes:" tag in such cases. But if
> it's better to go ahead and add the "Fixes:" tag for what's only a
> theoretical problem, I'm OK with doing so.

I think this is a good to have fix anyway as it is Obviously
Correct(tm).

Unless you have any reservations you haven't shared yet...

> [1] https://lkml.org/lkml/2022/11/11/1348

Btw, the proper way to reference to a mail message now is simply to do:

https://lore.kernel.org/r/<Message-ID>

as long as it has been posted on some ML which lore archives. And I
think it archives all.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
