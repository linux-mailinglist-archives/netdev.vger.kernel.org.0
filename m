Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6AE443DAE
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 08:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhKCH3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 03:29:32 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:27109 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbhKCH3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 03:29:32 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HkdZS0sGcz1DJ8Z;
        Wed,  3 Nov 2021 15:24:48 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 3 Nov 2021 15:26:51 +0800
Received: from [10.174.179.234] (10.174.179.234) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 3 Nov 2021 15:26:49 +0800
Subject: Re: [PATCH bpf-next] riscv, bpf: fix some compiler error
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
References: <20211102145642.724820-1-tongtiangen@huawei.com>
 <CAJ+HfNg1Ki=1Zc+ThW-ynvtDo5=fNAUK-XV08-icz-nY9CNoUQ@mail.gmail.com>
 <448599f5-e773-6ab5-bdaf-289f583edf01@huawei.com>
 <CAJ+HfNj_p36trWFzdyxVVgykrPVq=OvKcYq61w2QyKsHwa0gDw@mail.gmail.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
From:   tongtiangen <tongtiangen@huawei.com>
Message-ID: <f3ed7e48-c565-9147-eca0-6298a36b3d61@huawei.com>
Date:   Wed, 3 Nov 2021 15:26:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNj_p36trWFzdyxVVgykrPVq=OvKcYq61w2QyKsHwa0gDw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.234]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/11/3 14:10, Björn Töpel wrote:
> On Wed, 3 Nov 2021 at 04:06, tongtiangen <tongtiangen@huawei.com> wrote:
>>
> [...]
>>>
>> Hi Björn:
>>  From the perspective of development, introduce asm/extable.h is also prepare for the
>> subsequent modification of exception_table_entry, such as:
>>    1. https://lkml.org/lkml/2021/10/20/591
>>    2. https://lore.kernel.org/linux-arm-kernel/20211019160219.5202-11-mark.rutland@arm.com/
>>
>> Therefore, the prototype declarations and definitions related to kernel config are placed in head file,
>> which can avoid compiler error and simplify the rendering of functions.
>>
>
> Sure, but *this* patch is about getting the broken RV32 build to work,
> aimed for the bpf tree. Moving the extable.h is unrelated, and should
> not be done here. IMO it would be better to have this patch small/easy
> to read. I can't really see how this patch helps, when merging with
> Jisheng's work.
>
> ...and I still think that:
> --8<--
> diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
> index 18bf338303b6..ddb7d3b99e89 100644
> --- a/arch/riscv/mm/extable.c
> +++ b/arch/riscv/mm/extable.c
> @@ -11,7 +11,7 @@
>  #include <linux/module.h>
>  #include <linux/uaccess.h>
>
> -#ifdef CONFIG_BPF_JIT
> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
>  int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
> struct pt_regs *regs);
>  #endif
>
> @@ -23,7 +23,7 @@ int fixup_exception(struct pt_regs *regs)
>         if (!fixup)
>                 return 0;
>
> -#ifdef CONFIG_BPF_JIT
> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
>         if (regs->epc >= BPF_JIT_REGION_START && regs->epc < BPF_JIT_REGION_END)
>                 return rv_bpf_fixup_exception(fixup, regs);
>  #endif
> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
> index 2ca345c7b0bf..6372a235522d 100644
> --- a/arch/riscv/net/bpf_jit_comp64.c
> +++ b/arch/riscv/net/bpf_jit_comp64.c
> @@ -459,6 +459,8 @@ static int emit_call(bool fixed, u64 addr, struct
> rv_jit_context *ctx)
>  #define BPF_FIXUP_OFFSET_MASK   GENMASK(26, 0)
>  #define BPF_FIXUP_REG_MASK      GENMASK(31, 27)
>
> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
> +                          struct pt_regs *regs);
>  int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
>                                 struct pt_regs *regs)
>  {
> -->8--
>
> is much simpler.

Adding a function declaration in bpf_jit_comp64.c file cannot fix this compiler error:

....
when CONFIG_BPF_JIT and CONFIG_ARCH_64I is open, There is the following compiler error (W=1):
   error: no previous prototype for 'rv_bpf_fixup_exception'
....

To fix this compiler error, you need to make a declaration in a header file, which is also
the reason for introducing extable.h.

Before making this patch, I thought about this change, but on the whole, I think the modification
scheme of adding header files moved me.;-)

>
>
>
> Thoughts?
> Björn
>
>
>
>
>> Thanks.
>> Tong.
>>
>>>
>>> Björn
>>> .
>>>
> .
>
