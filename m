Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83BF658EEA
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiL2QWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiL2QWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:22:24 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4374413DD4
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 08:22:24 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so11451697pjk.3
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 08:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ec85AyiKc77bI9XsP5tX5lamemx/Nh18BP3PMc4R5sU=;
        b=JyJ1HotxL5h5gP0PAUr+bSyy8u1zOFXKWz1ZfgSiQeQvzYRYtdYK5A29TTv7eUyBSq
         O6WUTpHiy10Kl0hHmRgy/d9fal5bMY/E/lNTQ2LCgCfG8iVu/uN6+Uj5ExC6mHOnsXiu
         0ohB97kr44YJgmKniWXNLUoVi+8oVMmtdexytQrx6+rzrxhktuoTfzAedL35hCbYbn09
         5yB5XsMVIjKdTNReT5H6YpQsO7a4nnDDcbUBIjnPH2H4vmdpB5S32Eq6ZsH3EXQnBVqu
         h/JxK+dWLoxFuxlgdjXCLEO7aHIvjXxyMe2Wjpx0m1kdrzxduQK6w3r0Q8wQ2fW6djA1
         pXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ec85AyiKc77bI9XsP5tX5lamemx/Nh18BP3PMc4R5sU=;
        b=eaVqRxtSSHLAuHK//0Km1kNPKtxxgLRliTRm+s0a4SnXpcVMyOBTMtLavGBI3luFsp
         8bd8MM6umikaN1kKqT1A9yFdhkIzi4btkczuZTxC8AR6OvP6/z6euLS5LYvZYpcJeU5D
         Smt0kIyCjTNyOLKYu5odpz8jbUWLNU/Lkn6XenibIwECgn//Tk7B2KzkvUI1dAQUh0T5
         C0MHDHIzGqWBDVvTj8ovfLsNh7Srp2osbTWdb9EtCz3358cfBu1NHn/XyH0QprVSGQo5
         ehIIfPnZJLMYg6Nssg8HYswVSLypLcBvnYrw4gTipjU02F3VvPUp2DqvM6OmtaW6O4WC
         F5gA==
X-Gm-Message-State: AFqh2kpDcwanzyo6ylxzw3TGbJGGCUxRItMENfUMNsKLKGUJRJQZLaoa
        deLBahLzoMxY4FKRjZAwBkrR0Q==
X-Google-Smtp-Source: AMrXdXvdOJhcRsj0KUW218UKcAvJUd1l0xKIGxZQv8spR2kcI0qwBPtGX+cj507spyFm31HkJycFdg==
X-Received: by 2002:a17:902:a981:b0:187:403c:7a3b with SMTP id bh1-20020a170902a98100b00187403c7a3bmr25977484plb.69.1672330943683;
        Thu, 29 Dec 2022 08:22:23 -0800 (PST)
Received: from localhost ([135.180.226.51])
        by smtp.gmail.com with ESMTPSA id o4-20020a170902bcc400b0019254c19697sm13000824pls.289.2022.12.29.08.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 08:22:23 -0800 (PST)
Date:   Thu, 29 Dec 2022 08:22:23 -0800 (PST)
X-Google-Original-Date: Thu, 29 Dec 2022 07:51:42 PST (-0800)
Subject:     Re: [RFC PATCH] mm: remove zap_page_range and change callers to use zap_vma_page_range
In-Reply-To: <20221216192012.13562-1-mike.kravetz@oracle.com>
CC:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        david@redhat.com, mhocko@suse.com, peterx@redhat.com,
        nadav.amit@gmail.com, willy@infradead.org, vbabka@suse.cz,
        riel@surriel.com, Will Deacon <will@kernel.org>,
        mpe@ellerman.id.au, borntraeger@linux.ibm.com,
        dave.hansen@linux.intel.com, brauner@kernel.org,
        edumazet@google.com, akpm@linux-foundation.org,
        mike.kravetz@oracle.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     mike.kravetz@oracle.com
Message-ID: <mhng-3136c2a0-6953-4794-856c-46cacdc2c30a@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Dec 2022 11:20:12 PST (-0800), mike.kravetz@oracle.com wrote:
> zap_page_range was originally designed to unmap pages within an address
> range that could span multiple vmas.  While working on [1], it was
> discovered that all callers of zap_page_range pass a range entirely within
> a single vma.  In addition, the mmu notification call within zap_page
> range does not correctly handle ranges that span multiple vmas as calls
> should be vma specific.
>
> Instead of fixing zap_page_range, change all callers to use the new
> routine zap_vma_page_range.  zap_vma_page_range is just a wrapper around
> zap_page_range_single passing in NULL zap details.  The name is also
> more in line with other exported routines that operate within a vma.
> We can then remove zap_page_range.
>
> Also, change madvise_dontneed_single_vma to use this new routine.
>
> [1] https://lore.kernel.org/linux-mm/20221114235507.294320-2-mike.kravetz@oracle.com/
> Suggested-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> ---
>  arch/arm64/kernel/vdso.c                |  4 ++--
>  arch/powerpc/kernel/vdso.c              |  2 +-
>  arch/powerpc/platforms/book3s/vas-api.c |  2 +-
>  arch/powerpc/platforms/pseries/vas.c    |  2 +-
>  arch/riscv/kernel/vdso.c                |  4 ++--
>  arch/s390/kernel/vdso.c                 |  2 +-
>  arch/s390/mm/gmap.c                     |  2 +-
>  arch/x86/entry/vdso/vma.c               |  2 +-
>  drivers/android/binder_alloc.c          |  2 +-
>  include/linux/mm.h                      |  7 ++++--
>  mm/madvise.c                            |  4 ++--
>  mm/memory.c                             | 30 -------------------------
>  mm/page-writeback.c                     |  2 +-
>  net/ipv4/tcp.c                          |  6 ++---
>  14 files changed, 22 insertions(+), 49 deletions(-)

[snip]

> diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
> index e410275918ac..a405119da2c0 100644
> --- a/arch/riscv/kernel/vdso.c
> +++ b/arch/riscv/kernel/vdso.c
> @@ -127,10 +127,10 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
>  		unsigned long size = vma->vm_end - vma->vm_start;
>
>  		if (vma_is_special_mapping(vma, vdso_info.dm))
> -			zap_page_range(vma, vma->vm_start, size);
> +			zap_vma_page_range(vma, vma->vm_start, size);
>  #ifdef CONFIG_COMPAT
>  		if (vma_is_special_mapping(vma, compat_vdso_info.dm))
> -			zap_page_range(vma, vma->vm_start, size);
> +			zap_vma_page_range(vma, vma->vm_start, size);
>  #endif
>  	}

Acked-by: Palmer Dabbelt <palmer@rivosinc.com> # RISC-V

Thanks!
