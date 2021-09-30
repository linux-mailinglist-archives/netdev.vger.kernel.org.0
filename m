Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1442541E084
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 20:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353009AbhI3SD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 14:03:57 -0400
Received: from mail.skyhub.de ([5.9.137.197]:40490 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352908AbhI3SD4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 14:03:56 -0400
Received: from zn.tnic (p200300ec2f0e16001aa756a0ef3ae707.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1600:1aa7:56a0:ef3a:e707])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8D03E1EC04F3;
        Thu, 30 Sep 2021 20:02:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1633024931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gg6GBClwXHFeNqO89BOVkISWLtUh+pX3g0xDqXc+XKE=;
        b=pP3gJ2jscGAV8t0o+eADqT80uEfCsRv3YABU1QJ5ED1kkfTade5r8859DePCPWQAI8Ed+6
        E+W45AYkCFGq50yUT+02Ndq80nZTrJ3mCBhwE0wjQcWa94b8/Q05Ik9/FjweaIfNGSxtCE
        KRk+8OjCA2mRsSfnqULioeqqvLmhM1k=
Date:   Thu, 30 Sep 2021 20:02:07 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        konrad.wilk@oracle.com, hch@lst.de, robin.murphy@arm.com,
        joro@8bytes.org, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V6 3/8] x86/hyperv: Add new hvcall guest address host
 visibility  support
Message-ID: <YVX7n4YM8ZirwTQu@zn.tnic>
References: <20210930130545.1210298-1-ltykernel@gmail.com>
 <20210930130545.1210298-4-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210930130545.1210298-4-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 09:05:39AM -0400, Tianyu Lan wrote:
> @@ -1980,15 +1982,11 @@ int set_memory_global(unsigned long addr, int numpages)
>  				    __pgprot(_PAGE_GLOBAL), 0);
>  }
>  
> -static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
> +static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)

What exactly is that "pgtable" at the end of the name supposed to mean?

So if you want to have different indirections here, I'd suggest you do
this:

set_memory_encrypted/decrypted() is the external API. It calls

_set_memory_enc_dec() which does your hv_* checks. Note the single
underscore "_" prefix.

Then, the workhorse remains __set_memory_enc_dec().

Ok?

Also, we're reworking the mem_encrypt_active() accessors:

https://lkml.kernel.org/r/20210928191009.32551-1-bp@alien8.de

so some synchronization when juggling patchsets will be needed. JFYI
anyway.

Also 2, building your set triggers this, dunno if I'm missing some
patches on my local branch for that.

In file included from ./arch/x86/include/asm/mshyperv.h:240,
                 from ./include/clocksource/hyperv_timer.h:18,
                 from ./arch/x86/include/asm/vdso/gettimeofday.h:21,
                 from ./include/vdso/datapage.h:137,
                 from ./arch/x86/include/asm/vgtod.h:12,
                 from arch/x86/entry/vdso/vma.c:20:
./include/asm-generic/mshyperv.h: In function ‘vmbus_signal_eom’:
./include/asm-generic/mshyperv.h:153:3: error: implicit declaration of function ‘hv_set_register’; did you mean ‘kset_register’? [-Werror=implicit-function-declaration]
  153 |   hv_set_register(HV_REGISTER_EOM, 0);
      |   ^~~~~~~~~~~~~~~
      |   kset_register
In file included from ./arch/x86/include/asm/mshyperv.h:240,
                 from arch/x86/mm/pat/set_memory.c:34:
./include/asm-generic/mshyperv.h: In function ‘vmbus_signal_eom’:
...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
