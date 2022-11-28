Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBF863A660
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiK1Kuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiK1Kuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:50:51 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BF0BF9;
        Mon, 28 Nov 2022 02:50:50 -0800 (PST)
Received: from zn.tnic (p200300ea9733e719329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e719:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4BBF71EC059E;
        Mon, 28 Nov 2022 11:50:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669632649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZCCj7bcQc75acbwO7FOWk4dJlCrWMoBIyYNAusQQi2U=;
        b=oAEzJbYg5od8O3kDuXXte3PxpqRhYKSbKUONg0mq2ROUkTDdzrKVonBJnEQ5T41YGSsGOe
        rIo1R8sUPfBlavzVlofbxLwQPbc7E4cGRNEl8iN2+/Tl/4mcYIfR+6Nj2qS2ynm1/KS7Hm
        w4HnHBDdjRCvLu/emxxA1vwYAVRcccA=
Date:   Mon, 28 Nov 2022 11:50:45 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
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
Subject: Re: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Message-ID: <Y4SShb6nMz3gqkwh@zn.tnic>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
 <01d7c7cc-bd4e-ee9b-f5b2-73ea367e602f@linux.intel.com>
 <BYAPR21MB1688A31ED795ED1B5ACB6D26D7099@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y3uNj0z26EjkHeCn@zn.tnic>
 <6b5129cf-6986-bbb1-7e60-37849fc383fc@linux.intel.com>
 <BYAPR21MB168873879B0EEF71DED3D460D70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BYAPR21MB168873879B0EEF71DED3D460D70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 05:59:04PM +0000, Michael Kelley (LINUX) wrote:
> Right.  But here's my point:  With current code and an image built with
> CONFIG_AMD_MEM_ENCRYPT=y and running as a TDX guest,
> sme_postprocess_startup() will not decrypt the bss_decrypted section.
> Then later mem_encrypt_free_decrypted_mem() will run, see that
> CC_ATTR_MEM_ENCRYPT is true, and try to re-encrypt the memory.
> In other words, a TDX guest would break in the same way as a Hyper-V
> vTOM guest would break.  This patch fixes the problem for both cases.

I guess making the check more concrete by checking sme_me_mask directly
along with a comment makes sense.

We need to be very careful here not to fragment the code too much for
all the different guest types.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
