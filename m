Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94D53A5A3C
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 21:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhFMTxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 15:53:04 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:56880 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbhFMTxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 15:53:04 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4G34vN64Cwz1qtQV;
        Sun, 13 Jun 2021 21:50:56 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4G34vN363qz1qsYj;
        Sun, 13 Jun 2021 21:50:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id HJAVNxtJklRu; Sun, 13 Jun 2021 21:50:54 +0200 (CEST)
X-Auth-Info: LElrgumow5j7MizGUQKNpWrnXWIF9Qr7mZEEQCIJzLKJl+b0lrS27gPvl8MTWt4G
Received: from igel.home (ppp-46-244-177-185.dynamic.mnet-online.de [46.244.177.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 13 Jun 2021 21:50:54 +0200 (CEST)
Received: by igel.home (Postfix, from userid 1000)
        id D34602C369D; Sun, 13 Jun 2021 21:50:53 +0200 (CEST)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 7/9] riscv: bpf: Avoid breaking W^X
References: <20210330022144.150edc6e@xhacker>
        <20210330022521.2a904a8c@xhacker> <87o8ccqypw.fsf@igel.home>
        <20210612002334.6af72545@xhacker> <87bl8cqrpv.fsf@igel.home>
        <20210614010546.7a0d5584@xhacker>
X-Yow:  ..  Once upon a time, four AMPHIBIOUS HOG CALLERS attacked a family
 of DEFENSELESS, SENSITIVE COIN COLLECTORS and brought DOWN their
 PROPERTY VALUES!!
Date:   Sun, 13 Jun 2021 21:50:53 +0200
In-Reply-To: <20210614010546.7a0d5584@xhacker> (Jisheng Zhang's message of
        "Mon, 14 Jun 2021 01:05:46 +0800")
Message-ID: <87im2hsfvm.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jun 14 2021, Jisheng Zhang wrote:

> I think I found the root cause: commit 2bfc6cd81bd ("move kernel mapping
> outside of linear mapping") moves BPF JIT region after the kernel:
>
> #define BPF_JIT_REGION_START   PFN_ALIGN((unsigned long)&_end)
>
> The &_end is unlikely aligned with PMD SIZE, so the front bpf jit region
> sits with kernel .data section in one PMD. But kenrel is mapped in PMD SIZE,
> so when bpf_jit_binary_lock_ro() is called to make the first bpf jit prog
> ROX, we will make part of kernel .data section RO too, so when we write, for example
> memset the .data section, MMU will trigger store page fault.
>
> To fix the issue, we need to make the bpf jit region PMD size aligned by either
> patch BPF_JIT_REGION_START to align on PMD size rather than PAGE SIZE, or
> something as below patch to move the BPF region before modules region:
>
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 9469f464e71a..997b894edbc2 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -31,8 +31,8 @@
>  #define BPF_JIT_REGION_SIZE	(SZ_128M)
>  #ifdef CONFIG_64BIT
>  /* KASLR should leave at least 128MB for BPF after the kernel */
> -#define BPF_JIT_REGION_START	PFN_ALIGN((unsigned long)&_end)
> -#define BPF_JIT_REGION_END	(BPF_JIT_REGION_START + BPF_JIT_REGION_SIZE)
> +#define BPF_JIT_REGION_START	(BPF_JIT_REGION_END - BPF_JIT_REGION_SIZE)
> +#define BPF_JIT_REGION_END	(MODULES_VADDR)
>  #else
>  #define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
>  #define BPF_JIT_REGION_END	(VMALLOC_END)
> @@ -40,8 +40,8 @@
>  
>  /* Modules always live before the kernel */
>  #ifdef CONFIG_64BIT
> -#define MODULES_VADDR	(PFN_ALIGN((unsigned long)&_end) - SZ_2G)
>  #define MODULES_END	(PFN_ALIGN((unsigned long)&_start))
> +#define MODULES_VADDR	(MODULES_END - SZ_128M)
>  #endif
>  
>  
> can you please try it? Per my test, the issue is fixed.

I can confirm that this fixes the issue.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
