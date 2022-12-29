Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D703F658F48
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiL2Qyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiL2Qye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:54:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C11DF45;
        Thu, 29 Dec 2022 08:54:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E617B61849;
        Thu, 29 Dec 2022 16:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0105CC433D2;
        Thu, 29 Dec 2022 16:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672332873;
        bh=ZH9RxnFigQ3RNw39YbUtHTL0S/l1Ahl1+A4wI5byIbY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=R10r7pyB/UbK+tFVrEctWZRBQDwXUu22AT9vlVvp01hWq47xoIDSjFMGjzchZHZyi
         66/f6Fyce3eiltODaKq7VCqCK7dEcSB+AEG/RiMfCeuFs5aHKOk04bjidHv0VMJg51
         7WmjXsXWwOfU6OTVz3GNBNxo2UPCzuJ6Lj1MVqG68xavgMqoQqQi8P+hclvXLAxICh
         6hwmO9NJFRzLbSYZaa7hk/VMuB37tlN/9a+3qfWxOD7PCUhUlXyjN4PN9NKa9zAfRf
         wyd25rIuT8zy8rhiE4MDUbsOUTJSpXOYH5WV+pUVRp96h/fzUefZQSawaaw4dD90Iy
         3S049RPbLL/xQ==
Date:   Thu, 29 Dec 2022 10:54:31 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lpieralisi@kernel.org, robh@kernel.org,
        kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
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
Message-ID: <20221229165431.GA611286@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y62FbJ1rZ6TVUgml@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 29, 2022 at 01:17:48PM +0100, Borislav Petkov wrote:
> On Thu, Dec 01, 2022 at 07:30:22PM -0800, Michael Kelley wrote:
> > Current code in sme_postprocess_startup() decrypts the bss_decrypted
> > section when sme_me_mask is non-zero.  But code in
> > mem_encrypt_free_decrypted_mem() re-encrypts the unused portion based
> > on CC_ATTR_MEM_ENCRYPT.  In a Hyper-V guest VM using vTOM, these
> > conditions are not equivalent as sme_me_mask is always zero when
> > using vTOM.  Consequently, mem_encrypt_free_decrypted_mem() attempts
> > to re-encrypt memory that was never decrypted.
> > 
> > Fix this in mem_encrypt_free_decrypted_mem() by conditioning the
> > re-encryption on the same test for non-zero sme_me_mask.  Hyper-V
> > guests using vTOM don't need the bss_decrypted section to be
> > decrypted, so skipping the decryption/re-encryption doesn't cause
> > a problem.
> 
> Lemme simplify the formulations a bit:
> 
> "sme_postprocess_startup() decrypts the bss_decrypted ection when me_mask
> sme_is non-zero.

s/ection/section/

(In case you copy/paste this text without noticing the typo)

