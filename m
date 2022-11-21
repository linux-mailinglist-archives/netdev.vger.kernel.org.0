Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485C363276F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiKUPLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiKUPKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:10:53 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B895CBE252;
        Mon, 21 Nov 2022 07:03:12 -0800 (PST)
Received: from zn.tnic (p200300ea9733e725329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e725:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 45E7E1EC064C;
        Mon, 21 Nov 2022 16:03:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669042991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Ad0xyJQtRuj2l0HKhWgNpGUpnSMGJ0sK9iQrDE+ZQ9k=;
        b=UxVYoF3Ez3k9aL2h4PQRxGYz0bNOj11by8YRTCWsFJS4EMjNk4OCRpnme2Scpi73L/9qlf
        IbNFDMlblbgrdYpZBKjhcf3pXJPR5glZBVzvEMcTFrrAYXrhOqK8c7sDEXcYzkH5YxdjyL
        AvxLtCqL6o1513540e1ijOqmzdvqdA8=
Date:   Mon, 21 Nov 2022 16:03:07 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: Re: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Message-ID: <Y3uTK3rBV6eXSJnC@zn.tnic>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 10:41:30AM -0800, Michael Kelley wrote:
> Hyper-V guests on AMD SEV-SNP hardware have the option of using the
> "virtual Top Of Memory" (vTOM) feature specified by the SEV-SNP
> architecture. With vTOM, shared vs. private memory accesses are
> controlled by splitting the guest physical address space into two
> halves.  vTOM is the dividing line where the uppermost bit of the
> physical address space is set; e.g., with 47 bits of guest physical
> address space, vTOM is 0x40000000000 (bit 46 is set).  Guest phyiscal

Unknown word [phyiscal] in commit message.
Suggestions: ['physical', 'physically', ... ]

Please introduce a spellchecker into your patch creation workflow.

...

> @@ -108,6 +115,7 @@ u64 cc_mkenc(u64 val)
>  	switch (vendor) {
>  	case CC_VENDOR_AMD:
>  		return val | cc_mask;
> +	case CC_VENDOR_HYPERV:
>  	case CC_VENDOR_INTEL:
>  		return val & ~cc_mask;
>  	default:
> @@ -121,6 +129,7 @@ u64 cc_mkdec(u64 val)
>  	switch (vendor) {
>  	case CC_VENDOR_AMD:
>  		return val & ~cc_mask;
> +	case CC_VENDOR_HYPERV:
>  	case CC_VENDOR_INTEL:
>  		return val | cc_mask;
>  	default:

Uuuh, this needs a BIG FAT COMMENT.

You're running on SNP and yet the enc/dec meaning is flipped. And that's
because of vTOM.

What happens if you have other types of SNP-based VMs on HyperV? The
isolation VMs thing? Or is that the same?

What happens when you do TDX guests with HyperV?

This becomes wrong then.

I think you need a more finer-grained check here in the sense of "is it
a HyperV guest using a paravisor and vTOM is enabled" or so.

Otherwise, I like the removal of the HyperV-specific checks ofc.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
