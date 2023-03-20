Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC0A6C10CD
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 12:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbjCTL2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 07:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjCTL1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 07:27:36 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B063D52C;
        Mon, 20 Mar 2023 04:27:19 -0700 (PDT)
Received: from zn.tnic (p5de8e687.dip0.t-ipconnect.de [93.232.230.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1134D1EC0662;
        Mon, 20 Mar 2023 12:27:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1679311634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PE0V7lE9EfhB921N//zo5ZjSYSOvTBfEu1v7T+9F1sY=;
        b=dCu69jjGMO1potJ7a2X20nTWZx06nNYsCEepX6UJ7SL80wE9zvtHc3bymc6rx6Q2Vjhq4N
        bE3iqcCbsNY1tBR/XZefUmkzRnn3IQ7NwEVoQHjxjCi0vQW3RsK6EroJZUqdMq+F5X9WWd
        xW9Kn/hEDhTI+D/D6kYApwf4ub1HsGM=
Date:   Mon, 20 Mar 2023 12:27:13 +0100
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
Subject: Re: [PATCH v6 00/13] Add PCI pass-thru support to Hyper-V
 Confidential VMs
Message-ID: <20230320112713.GDZBhDESaTus4AR3SJ@fat_crate.local>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 06:40:01PM -0800, Michael Kelley wrote:
>  arch/x86/coco/core.c                |  42 +++++--
>  arch/x86/hyperv/hv_init.c           |  18 +--
>  arch/x86/hyperv/ivm.c               | 148 +++++++++++++----------
>  arch/x86/include/asm/coco.h         |   1 -
>  arch/x86/include/asm/hyperv-tlfs.h  |   3 +
>  arch/x86/include/asm/mshyperv.h     |  16 ++-
>  arch/x86/include/asm/x86_init.h     |   4 +
>  arch/x86/kernel/apic/io_apic.c      |  16 ++-
>  arch/x86/kernel/cpu/mshyperv.c      |  22 ++--
>  arch/x86/kernel/x86_init.c          |   2 +
>  arch/x86/mm/ioremap.c               |   5 +
>  arch/x86/mm/mem_encrypt_amd.c       |  10 +-
>  arch/x86/mm/pat/set_memory.c        |   3 -

...

>  29 files changed, 440 insertions(+), 439 deletions(-)

The x86 bits look pretty much ready modulo some uncertainties in patch 6.

When this has all been clarified I'm thinking of taking patches

1-2,4-6

through tip and giving an immutable branch to HyperV maintainers to base
the rest ontop...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
