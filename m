Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5AE658CA1
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 13:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbiL2MSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 07:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiL2MSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 07:18:00 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F9710B5B;
        Thu, 29 Dec 2022 04:18:00 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 891F11EC034B;
        Thu, 29 Dec 2022 13:17:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672316278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=wSRpswI9u60JfI6sWY2yfCWEP9K0fmolgwn8Wp8wVro=;
        b=nUijUjCO3f0F3lKDnwUjShJLuzg8Te08KQWeSK1O8CYkaoOv4H1WdTTd60grAJwdH3ybYk
        7d1+JxrHlDav78/VwKPK5g7hOs5SwfviZ7tTlbVb67rQZCREhd2nfhpmXX/gQBidKGyasA
        T0pJccZK9EcweKSTC+UPU6YntjU/RDQ=
Date:   Thu, 29 Dec 2022 13:17:48 +0100
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
Subject: Re: [Patch v4 04/13] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Message-ID: <Y62FbJ1rZ6TVUgml@zn.tnic>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <1669951831-4180-5-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1669951831-4180-5-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 07:30:22PM -0800, Michael Kelley wrote:
> Current code in sme_postprocess_startup() decrypts the bss_decrypted
> section when sme_me_mask is non-zero.  But code in
> mem_encrypt_free_decrypted_mem() re-encrypts the unused portion based
> on CC_ATTR_MEM_ENCRYPT.  In a Hyper-V guest VM using vTOM, these
> conditions are not equivalent as sme_me_mask is always zero when
> using vTOM.  Consequently, mem_encrypt_free_decrypted_mem() attempts
> to re-encrypt memory that was never decrypted.
> 
> Fix this in mem_encrypt_free_decrypted_mem() by conditioning the
> re-encryption on the same test for non-zero sme_me_mask.  Hyper-V
> guests using vTOM don't need the bss_decrypted section to be
> decrypted, so skipping the decryption/re-encryption doesn't cause
> a problem.

Lemme simplify the formulations a bit:

"sme_postprocess_startup() decrypts the bss_decrypted ection when me_mask
sme_is non-zero.

mem_encrypt_free_decrypted_mem() re-encrypts the unused portion based on
CC_ATTR_MEM_ENCRYPT.

In a Hyper-V guest VM using vTOM, these conditions are not equivalent
as sme_me_mask is always zero when using vTOM. Consequently,
mem_encrypt_free_decrypted_mem() attempts to re-encrypt memory that was
never decrypted.

So check sme_me_mask in mem_encrypt_free_decrypted_mem() too.

Hyper-V guests using vTOM don't need the bss_decrypted section to be
decrypted, so skipping the decryption/re-encryption doesn't cause a
problem."

> Fixes: e9d1d2bb75b2 ("treewide: Replace the use of mem_encrypt_active() with cc_platform_has()")

So when you say Fixes - this is an issue only for vTOM-using VMs and
before yours, there were none. And yours needs more enablement than just
this patch.

So does this one really need to be backported to stable@?

I'm asking because there's AI which will pick it up based on this Fixes
tag up but that AI is still not that smart to replace us all. :-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
