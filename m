Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A353AAD6B
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 09:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhFQHZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 03:25:26 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:36209 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbhFQHZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 03:25:23 -0400
Received: (Authenticated sender: alex@ghiti.fr)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id E10C7240008;
        Thu, 17 Jun 2021 07:23:04 +0000 (UTC)
Subject: Re: [PATCH] riscv: Ensure BPF_JIT_REGION_START aligned with PMD size
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc:     Andreas Schwab <schwab@linux-m68k.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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
References: <20210330022144.150edc6e@xhacker>
 <20210330022521.2a904a8c@xhacker> <87o8ccqypw.fsf@igel.home>
 <20210612002334.6af72545@xhacker> <87bl8cqrpv.fsf@igel.home>
 <20210614010546.7a0d5584@xhacker> <87im2hsfvm.fsf@igel.home>
 <20210615004928.2d27d2ac@xhacker>
 <ab536c78-ba1c-c65c-325a-8f9fba6e9d46@ghiti.fr>
 <20210616080328.6548e762@xhacker>
From:   Alex Ghiti <alex@ghiti.fr>
Message-ID: <4cdb1261-6474-8ae6-7a92-a3be81ce8cb5@ghiti.fr>
Date:   Thu, 17 Jun 2021 09:23:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210616080328.6548e762@xhacker>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 16/06/2021 à 02:03, Jisheng Zhang a écrit :
> On Tue, 15 Jun 2021 20:54:19 +0200
> Alex Ghiti <alex@ghiti.fr> wrote:
> 
>> Hi Jisheng,
> 
> Hi Alex,
> 
>>
>> Le 14/06/2021 à 18:49, Jisheng Zhang a écrit :
>>> From: Jisheng Zhang <jszhang@kernel.org>
>>>
>>> Andreas reported commit fc8504765ec5 ("riscv: bpf: Avoid breaking W^X")
>>> breaks booting with one kind of config file, I reproduced a kernel panic
>>> with the config:
>>>
>>> [    0.138553] Unable to handle kernel paging request at virtual address ffffffff81201220
>>> [    0.139159] Oops [#1]
>>> [    0.139303] Modules linked in:
>>> [    0.139601] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc5-default+ #1
>>> [    0.139934] Hardware name: riscv-virtio,qemu (DT)
>>> [    0.140193] epc : __memset+0xc4/0xfc
>>> [    0.140416]  ra : skb_flow_dissector_init+0x1e/0x82
>>> [    0.140609] epc : ffffffff8029806c ra : ffffffff8033be78 sp : ffffffe001647da0
>>> [    0.140878]  gp : ffffffff81134b08 tp : ffffffe001654380 t0 : ffffffff81201158
>>> [    0.141156]  t1 : 0000000000000002 t2 : 0000000000000154 s0 : ffffffe001647dd0
>>> [    0.141424]  s1 : ffffffff80a43250 a0 : ffffffff81201220 a1 : 0000000000000000
>>> [    0.141654]  a2 : 000000000000003c a3 : ffffffff81201258 a4 : 0000000000000064
>>> [    0.141893]  a5 : ffffffff8029806c a6 : 0000000000000040 a7 : ffffffffffffffff
>>> [    0.142126]  s2 : ffffffff81201220 s3 : 0000000000000009 s4 : ffffffff81135088
>>> [    0.142353]  s5 : ffffffff81135038 s6 : ffffffff8080ce80 s7 : ffffffff80800438
>>> [    0.142584]  s8 : ffffffff80bc6578 s9 : 0000000000000008 s10: ffffffff806000ac
>>> [    0.142810]  s11: 0000000000000000 t3 : fffffffffffffffc t4 : 0000000000000000
>>> [    0.143042]  t5 : 0000000000000155 t6 : 00000000000003ff
>>> [    0.143220] status: 0000000000000120 badaddr: ffffffff81201220 cause: 000000000000000f
>>> [    0.143560] [<ffffffff8029806c>] __memset+0xc4/0xfc
>>> [    0.143859] [<ffffffff8061e984>] init_default_flow_dissectors+0x22/0x60
>>> [    0.144092] [<ffffffff800010fc>] do_one_initcall+0x3e/0x168
>>> [    0.144278] [<ffffffff80600df0>] kernel_init_freeable+0x1c8/0x224
>>> [    0.144479] [<ffffffff804868a8>] kernel_init+0x12/0x110
>>> [    0.144658] [<ffffffff800022de>] ret_from_exception+0x0/0xc
>>> [    0.145124] ---[ end trace f1e9643daa46d591 ]---
>>>
>>> After some investigation, I think I found the root cause: commit
>>> 2bfc6cd81bd ("move kernel mapping outside of linear mapping") moves
>>> BPF JIT region after the kernel:
>>>
>>> The &_end is unlikely aligned with PMD size, so the front bpf jit
>>> region sits with part of kernel .data section in one PMD size mapping.
>>> But kernel is mapped in PMD SIZE, when bpf_jit_binary_lock_ro() is
>>> called to make the first bpf jit prog ROX, we will make part of kernel
>>> .data section RO too, so when we write to, for example memset the
>>> .data section, MMU will trigger a store page fault.
>>
>> Good catch, we make sure no physical allocation happens between _end and
>> the next PMD aligned address, but I missed this one.
>>
>>>
>>> To fix the issue, we need to ensure the BPF JIT region is PMD size
>>> aligned. This patch acchieve this goal by restoring the BPF JIT region
>>> to original position, I.E the 128MB before kernel .text section.
>>
>> But I disagree with your solution: I made sure modules and BPF programs
>> get their own virtual regions to avoid worst case scenario where one
>> could allocate all the space and leave nothing to the other (we are
>> limited to +- 2GB offset). Why don't just align BPF_JIT_REGION_START to
>> the next PMD aligned address?
> 
> Originally, I planed to fix the issue by aligning BPF_JIT_REGION_START, but
> IIRC, BPF experts are adding (or have added) "Calling kernel functions from BPF"
> feature, there's a risk that BPF JIT region is beyond the 2GB of module region:
> 
> ------
> module
> ------
> kernel
> ------
> BPF_JIT
> 
> So I made this patch finally. In this patch, we let BPF JIT region sit
> between module and kernel.
> 

 From what I read in the lwn article, I'm not sure BPF programs can call 
module functions, can someone tell us if it is possible? Or planned?

> To address "make sure modules and BPF programs get their own virtual regions",
> what about something as below (applied against this patch)?
> 
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 380cd3a7e548..da1158f10b09 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -31,7 +31,7 @@
>   #define BPF_JIT_REGION_SIZE	(SZ_128M)
>   #ifdef CONFIG_64BIT
>   #define BPF_JIT_REGION_START	(BPF_JIT_REGION_END - BPF_JIT_REGION_SIZE)
> -#define BPF_JIT_REGION_END	(MODULES_END)
> +#define BPF_JIT_REGION_END	(PFN_ALIGN((unsigned long)&_start))
>   #else
>   #define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
>   #define BPF_JIT_REGION_END	(VMALLOC_END)
> @@ -40,7 +40,7 @@
>   /* Modules always live before the kernel */
>   #ifdef CONFIG_64BIT
>   #define MODULES_VADDR	(PFN_ALIGN((unsigned long)&_end) - SZ_2G)
> -#define MODULES_END	(PFN_ALIGN((unsigned long)&_start))
> +#define MODULES_END	(BPF_JIT_REGION_END)
>   #endif
>   
> 

In case it is possible, I would let the vmalloc allocator handle the 
case where modules steal room from BPF: I would then not implement the 
above but rather your first patch.

And do not forget to modify Documentation/riscv/vm-layout.rst 
accordingly and remove the comment "/* KASLR should leave at least 128MB 
for BPF after the kernel */"

Thanks,

Alex

> 
>>
>> Again, good catch, thanks,
>>
>> Alex
>>
>>>
>>> Reported-by: Andreas Schwab <schwab@linux-m68k.org>
>>> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
>>> ---
>>>    arch/riscv/include/asm/pgtable.h | 5 ++---
>>>    1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
>>> index 9469f464e71a..380cd3a7e548 100644
>>> --- a/arch/riscv/include/asm/pgtable.h
>>> +++ b/arch/riscv/include/asm/pgtable.h
>>> @@ -30,9 +30,8 @@
>>>    
>>>    #define BPF_JIT_REGION_SIZE	(SZ_128M)
>>>    #ifdef CONFIG_64BIT
>>> -/* KASLR should leave at least 128MB for BPF after the kernel */
>>> -#define BPF_JIT_REGION_START	PFN_ALIGN((unsigned long)&_end)
>>> -#define BPF_JIT_REGION_END	(BPF_JIT_REGION_START + BPF_JIT_REGION_SIZE)
>>> +#define BPF_JIT_REGION_START	(BPF_JIT_REGION_END - BPF_JIT_REGION_SIZE)
>>> +#define BPF_JIT_REGION_END	(MODULES_END)
>>>    #else
>>>    #define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
>>>    #define BPF_JIT_REGION_END	(VMALLOC_END)
>>>    
> 
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
> 
