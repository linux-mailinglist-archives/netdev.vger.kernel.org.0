Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5665014FD5D
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 14:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgBBNhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 08:37:35 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:41567 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgBBNhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 08:37:35 -0500
Received: from [192.168.0.12] (127.19.86.79.rev.sfr.net [79.86.19.127])
        (Authenticated sender: alex@ghiti.fr)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 28D74240002;
        Sun,  2 Feb 2020 13:37:30 +0000 (UTC)
Subject: Re: [PATCH bpf-next v2 6/9] riscv, bpf: provide RISC-V specific JIT
 image alloc/free
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     linux-riscv@lists.infradead.org, bpf@vger.kernel.org,
        anup@brainfault.org
References: <20191216091343.23260-1-bjorn.topel@gmail.com>
 <20191216091343.23260-7-bjorn.topel@gmail.com>
From:   Alex Ghiti <alex@ghiti.fr>
Message-ID: <3f6d3495-efdf-e663-2a84-303fde947a1d@ghiti.fr>
Date:   Sun, 2 Feb 2020 08:37:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191216091343.23260-7-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/19 4:13 AM, Björn Töpel wrote:
> This commit makes sure that the JIT images is kept close to the kernel
> text, so BPF calls can use relative calling with auipc/jalr or jal
> instead of loading the full 64-bit address and jalr.
>
> The BPF JIT image region is 128 MB before the kernel text.
>
> Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
> ---
>   arch/riscv/include/asm/pgtable.h |  4 ++++
>   arch/riscv/net/bpf_jit_comp.c    | 13 +++++++++++++
>   2 files changed, 17 insertions(+)
>
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 7ff0ed4f292e..cc3f49415620 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -404,6 +404,10 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>   #define VMALLOC_END      (PAGE_OFFSET - 1)
>   #define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
>   
> +#define BPF_JIT_REGION_SIZE	(SZ_128M)
> +#define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> +#define BPF_JIT_REGION_END	(VMALLOC_END)
> +
>   /*
>    * Roughly size the vmemmap space to be large enough to fit enough
>    * struct pages to map half the virtual address space. Then
> diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
> index 8aa19c846881..46cff093f526 100644
> --- a/arch/riscv/net/bpf_jit_comp.c
> +++ b/arch/riscv/net/bpf_jit_comp.c
> @@ -1656,3 +1656,16 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   					   tmp : orig_prog);
>   	return prog;
>   }
> +
> +void *bpf_jit_alloc_exec(unsigned long size)
> +{
> +	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
> +				    BPF_JIT_REGION_END, GFP_KERNEL,
> +				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
> +				    __builtin_return_address(0));
> +}
> +
> +void bpf_jit_free_exec(void *addr)
> +{
> +	return vfree(addr);
> +}


I think it would be better to completely avoid this patch and the 
definition of this
new zone by using the generic implementation if we had the patch 
discussed here
regarding modules memory allocation (that in any case we need to fix 
modules loading):

https://lore.kernel.org/linux-riscv/d868acf5-7242-93dc-0051-f97e64dc4387@ghiti.fr/T/#m2be30cb71dc9aa834a50d346961acee26158a238

Alex

