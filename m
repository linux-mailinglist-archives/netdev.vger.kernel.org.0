Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665AB3AD852
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 08:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhFSHBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 03:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbhFSHBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 03:01:33 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55530C061767
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 23:58:46 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e33so9723954pgm.3
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 23:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=Y5Tj5VBfCDbHRxlPn8EtoNBakme15m1U4y437Ov6/kw=;
        b=Zmz0Z57zzTZN7vi+XP62G9zO+kHJ3UaMg5mFKyYQdIyu+26sNfCxPtP67wwyyQRXah
         NFvcbF7aNBAOkwI0T5s9T0LcoblIGAggFwTJBU7O9SztNvJ9ijCzw/c6JzEVUFo7b4lX
         iQ8AkJOcNXj+Pi2vhepIP2cFpbD077ujcNJtgkcfsL7FrGpVxXtdRdPmwCDdh72tuLZ3
         /10HhOoPOO1LzYgcK/hJEYxo8QE+F7VqeiKzRVQ6N/PW2A9OusIcNGgAkZxFLtS1hn/M
         E09LD3JEpUbfE3IlMCZcP7GTpVuqC4QUBd2EYXsSKqh8Kv29EkicGMIEwuumYqRddBhP
         Fgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=Y5Tj5VBfCDbHRxlPn8EtoNBakme15m1U4y437Ov6/kw=;
        b=RfcwiFEAVjH6gflMi8e6K8qiyDsof2jK5k88+yDNz6oZ1gF38CXeccErNyEfxkGPtv
         d0VRA3a85/Dsi4x4+Etcb0n0hNmThHE/rSiIv0QFibxrNGc5X+SuxZpJ46fUxJ36TPjv
         kbYGRj7ReS0MLq/IZcj4XLsvCcmgdgTksfEyq/y06uoiapZYNILDuOTbKCblx7dS1Z51
         25TR24zNzbgP0LHojIzsvNlcQ9jsx5P0BPr7aUvoeGQa/V0+yy9nBdusJXx8Gy+5dJWT
         k8nXTqDZdeQRuV3sWhXcLI7Rh5viz5/aDm1f8mc0LXp9NUWw5BwQhDH9+MtShjWJHkDw
         Sc4g==
X-Gm-Message-State: AOAM533H8TKxZBReyLpteIXr4+DhxVgW5R8ZT3q+FwQG4x5DFzS0YTZ5
        HknGpJa8YmJexD3KWDbEF3tf+g==
X-Google-Smtp-Source: ABdhPJzPs85UcA/yDB5qZB1bEIJzU2KAQlxMsL2vm1BBiNkWPW/rGjtp8QleDURaiSUBQCMWz6jMDA==
X-Received: by 2002:aa7:83c3:0:b029:2e8:f2ba:3979 with SMTP id j3-20020aa783c30000b02902e8f2ba3979mr8852013pfn.8.1624085925610;
        Fri, 18 Jun 2021 23:58:45 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id b21sm10769551pgj.74.2021.06.18.23.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 23:58:45 -0700 (PDT)
Date:   Fri, 18 Jun 2021 23:58:45 -0700 (PDT)
X-Google-Original-Date: Fri, 18 Jun 2021 23:58:32 PDT (-0700)
Subject:     Re: [PATCH v3] riscv: Ensure BPF_JIT_REGION_START aligned with PMD size
In-Reply-To: <20210618220913.6fde1957@xhacker>
CC:     corbet@lwn.net, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, ryabinin.a.a@gmail.com, glider@google.com,
        andreyknvl@gmail.com, dvyukov@google.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, alex@ghiti.fr, linux-doc@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     jszhang3@mail.ustc.edu.cn, schwab@linux-m68k.org
Message-ID: <mhng-3008635e-9a78-413a-8b99-d20a14c5494b@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Jun 2021 07:09:13 PDT (-0700), jszhang3@mail.ustc.edu.cn wrote:
> From: Jisheng Zhang <jszhang@kernel.org>
>
> Andreas reported commit fc8504765ec5 ("riscv: bpf: Avoid breaking W^X")
> breaks booting with one kind of defconfig, I reproduced a kernel panic
> with the defconfig:
>
> [    0.138553] Unable to handle kernel paging request at virtual address ffffffff81201220
> [    0.139159] Oops [#1]
> [    0.139303] Modules linked in:
> [    0.139601] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc5-default+ #1
> [    0.139934] Hardware name: riscv-virtio,qemu (DT)
> [    0.140193] epc : __memset+0xc4/0xfc
> [    0.140416]  ra : skb_flow_dissector_init+0x1e/0x82
> [    0.140609] epc : ffffffff8029806c ra : ffffffff8033be78 sp : ffffffe001647da0
> [    0.140878]  gp : ffffffff81134b08 tp : ffffffe001654380 t0 : ffffffff81201158
> [    0.141156]  t1 : 0000000000000002 t2 : 0000000000000154 s0 : ffffffe001647dd0
> [    0.141424]  s1 : ffffffff80a43250 a0 : ffffffff81201220 a1 : 0000000000000000
> [    0.141654]  a2 : 000000000000003c a3 : ffffffff81201258 a4 : 0000000000000064
> [    0.141893]  a5 : ffffffff8029806c a6 : 0000000000000040 a7 : ffffffffffffffff
> [    0.142126]  s2 : ffffffff81201220 s3 : 0000000000000009 s4 : ffffffff81135088
> [    0.142353]  s5 : ffffffff81135038 s6 : ffffffff8080ce80 s7 : ffffffff80800438
> [    0.142584]  s8 : ffffffff80bc6578 s9 : 0000000000000008 s10: ffffffff806000ac
> [    0.142810]  s11: 0000000000000000 t3 : fffffffffffffffc t4 : 0000000000000000
> [    0.143042]  t5 : 0000000000000155 t6 : 00000000000003ff
> [    0.143220] status: 0000000000000120 badaddr: ffffffff81201220 cause: 000000000000000f
> [    0.143560] [<ffffffff8029806c>] __memset+0xc4/0xfc
> [    0.143859] [<ffffffff8061e984>] init_default_flow_dissectors+0x22/0x60
> [    0.144092] [<ffffffff800010fc>] do_one_initcall+0x3e/0x168
> [    0.144278] [<ffffffff80600df0>] kernel_init_freeable+0x1c8/0x224
> [    0.144479] [<ffffffff804868a8>] kernel_init+0x12/0x110
> [    0.144658] [<ffffffff800022de>] ret_from_exception+0x0/0xc
> [    0.145124] ---[ end trace f1e9643daa46d591 ]---
>
> After some investigation, I think I found the root cause: commit
> 2bfc6cd81bd ("move kernel mapping outside of linear mapping") moves
> BPF JIT region after the kernel:
>
> | #define BPF_JIT_REGION_START	PFN_ALIGN((unsigned long)&_end)
>
> The &_end is unlikely aligned with PMD size, so the front bpf jit
> region sits with part of kernel .data section in one PMD size mapping.
> But kernel is mapped in PMD SIZE, when bpf_jit_binary_lock_ro() is
> called to make the first bpf jit prog ROX, we will make part of kernel
> .data section RO too, so when we write to, for example memset the
> .data section, MMU will trigger a store page fault.
>
> To fix the issue, we need to ensure the BPF JIT region is PMD size
> aligned. This patch acchieve this goal by restoring the BPF JIT region
> to original position, I.E the 128MB before kernel .text section. The
> modification to kasan_init.c is inspired by Alexandre.
>
> Fixes: fc8504765ec5 ("riscv: bpf: Avoid breaking W^X")
> Reported-by: Andreas Schwab <schwab@linux-m68k.org>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
> Since v2:
>  - Split the local vars rename modification into another patch per Alexandre
>    suggestion
>  - Add Fixes tag
>
> Since v1:
>  - Fix early boot hang when kasan is enabled
>  - Update Documentation/riscv/vm-layout.rst
>
>  Documentation/riscv/vm-layout.rst | 4 ++--
>  arch/riscv/include/asm/pgtable.h  | 5 ++---
>  arch/riscv/mm/kasan_init.c        | 2 +-
>  3 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/riscv/vm-layout.rst b/Documentation/riscv/vm-layout.rst
> index 329d32098af4..b7f98930d38d 100644
> --- a/Documentation/riscv/vm-layout.rst
> +++ b/Documentation/riscv/vm-layout.rst
> @@ -58,6 +58,6 @@ RISC-V Linux Kernel SV39
>                                                                |
>    ____________________________________________________________|____________________________________________________________
>                      |            |                  |         |
> -   ffffffff00000000 |   -4    GB | ffffffff7fffffff |    2 GB | modules
> -   ffffffff80000000 |   -2    GB | ffffffffffffffff |    2 GB | kernel, BPF
> +   ffffffff00000000 |   -4    GB | ffffffff7fffffff |    2 GB | modules, BPF
> +   ffffffff80000000 |   -2    GB | ffffffffffffffff |    2 GB | kernel
>    __________________|____________|__________________|_________|____________________________________________________________
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 9469f464e71a..380cd3a7e548 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -30,9 +30,8 @@
>
>  #define BPF_JIT_REGION_SIZE	(SZ_128M)
>  #ifdef CONFIG_64BIT
> -/* KASLR should leave at least 128MB for BPF after the kernel */
> -#define BPF_JIT_REGION_START	PFN_ALIGN((unsigned long)&_end)
> -#define BPF_JIT_REGION_END	(BPF_JIT_REGION_START + BPF_JIT_REGION_SIZE)
> +#define BPF_JIT_REGION_START	(BPF_JIT_REGION_END - BPF_JIT_REGION_SIZE)
> +#define BPF_JIT_REGION_END	(MODULES_END)
>  #else
>  #define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
>  #define BPF_JIT_REGION_END	(VMALLOC_END)
> diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
> index 9daacae93e33..55c113345460 100644
> --- a/arch/riscv/mm/kasan_init.c
> +++ b/arch/riscv/mm/kasan_init.c
> @@ -201,7 +201,7 @@ void __init kasan_init(void)
>
>  	/* Populate kernel, BPF, modules mapping */
>  	kasan_populate(kasan_mem_to_shadow((const void *)MODULES_VADDR),
> -		       kasan_mem_to_shadow((const void *)BPF_JIT_REGION_END));
> +		       kasan_mem_to_shadow((const void *)MODULES_VADDR + SZ_2G));
>
>  	for (i = 0; i < PTRS_PER_PTE; i++)
>  		set_pte(&kasan_early_shadow_pte[i],

Thanks, this is on fixes.  With the previous fix also applied it still 
boots for me.

Andreas: I saw you indicate that a subset of this (without the kasan 
chunk, which was breaking for me) fixed your boot issue, but I don't see 
a direct confirmation of that.  LMK if there's still an issue on your 
end, otherwise I'm going to assume this is solved.

Thanks for sorting this out!
