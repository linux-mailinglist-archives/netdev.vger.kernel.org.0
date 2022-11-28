Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C89663ADDC
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 17:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbiK1Qdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 11:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiK1Qdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 11:33:43 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A0120F4E;
        Mon, 28 Nov 2022 08:33:42 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 316F51EC06AC;
        Mon, 28 Nov 2022 17:33:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669653221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=EkSu+bn5/ZdG6Mdy9WEl50uErDZt1Q23YH5+7wiGeAg=;
        b=DblfEotbkHNmwa2p8MaGT0cfAGRLMK+vW9sJd37I3B/E+hScXEcT3rlwTevGqgYvTw6YOk
        OS/2zXzpf0gG1G6P1TZSyLNhxqgSE2qY1ASAQ6JDdC6hnDVheJwoeDtZhMWDVfqQcJwrnq
        nCCI8Z2KkjwSaOGbQrxrcHjRo+6zFBg=
Date:   Mon, 28 Nov 2022 17:33:37 +0100
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
Message-ID: <Y4Ti4UTBRGmbi0hD@zn.tnic>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
 <Y3uTK3rBV6eXSJnC@zn.tnic>
 <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y31Kqacbp9R5A1PF@zn.tnic>
 <BYAPR21MB16886FF8B35F51964A515CD5D70C9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <BYAPR21MB1688AF2F106CDC14E4F97DB4D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BYAPR21MB1688AF2F106CDC14E4F97DB4D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 02:38:11PM +0000, Michael Kelley (LINUX) wrote:
> Any further comment on this patch?  I think we're agreement.  For
> this patch series I propose to change the symbol "CC_VENDOR_HYPERV"
> to "CC_VENDOR_AMD_VTOM" and the function name
> hyperv_cc_platform_has() to amd_vtom_cc_platform_has().

That doesn't sound optimal to me.

So, let's clarify things first: those Isolation VMs - are they going to
be the paravisors?

I don't see any other option because the unmodified guest must be some
old windoze....

So, if they're going to be that, then I guess this should be called

	CC_ATTR_PARAVISOR

to denote that it is a thin layer of virt gunk between an unmodified
guest and a hypervisor.

And if TDX wants to do that too later, then they can use that flag too.

Yes, no?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
