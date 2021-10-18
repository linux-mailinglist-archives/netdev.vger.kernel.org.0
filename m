Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D624430E72
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhJRDyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:54:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29902 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhJRDyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 23:54:52 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HXjWq5Rzjzbn8m;
        Mon, 18 Oct 2021 11:48:07 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 18 Oct 2021 11:52:38 +0800
Received: from [10.174.179.234] (10.174.179.234) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 18 Oct 2021 11:52:36 +0800
Subject: Re: [PATCH -next] riscv/eBPF: Add BPF exception tables
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
References: <20211015155241.237726-1-tongtiangen@huawei.com>
 <CAJ+HfNhcdVR19s+0CAoX4_r-3EPRzAAV-691DJGtx+WJcM3LgQ@mail.gmail.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
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
Message-ID: <01dd5e0f-4506-59ec-8fc8-ca6f4317f4e0@huawei.com>
Date:   Mon, 18 Oct 2021 11:52:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNhcdVR19s+0CAoX4_r-3EPRzAAV-691DJGtx+WJcM3LgQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.234]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/18 2:40, Björn Töpel wrote:
> Firstly, thanks a lot for working on the exception fixup handling!
>
> Specific comments below, but first some generic input.
>
> For the subject, please use "riscv, bpf" or "riscv: bpf:" instead of
> "riscv/eBPF:", and target the bpf-next tree (details in
> Documentation/bpf/bpf_devel_QA.rst).
>
> Also, it would be really nice if the RISC-V 32b support got the same
> fixup love! ;-)
>
> I haven't taken the code for a spin/selftest run yet, but I'll try to
> do it this week!
>
> Subjective style input: Please use the full 100 chars lines, now that
> we can! ;-)
>

Thanks a lot for your many helpful suggestions. ;-)
I will analyze the support of RISC-V 32bit later, in this patch, I focus on 64bit fixup.
I'm looking forward to spin/selftest test results and the sytle will be corrected in V2.

> On Fri, 15 Oct 2021 at 17:37, Tong Tiangen <tongtiangen@huawei.com> wrote:
>>
>> When a tracing BPF program attempts to read memory without using the
>> bpf_probe_read() helper, the verifier marks the load instruction with
>> the BPF_PROBE_MEM flag. Since the riscv JIT does not currently recognize
>> this flag it falls back to the interpreter.
>>
>> Add support for BPF_PROBE_MEM, by appending an exception table to the
>> BPF program. If the load instruction causes a data abort, the fixup
>> infrastructure finds the exception table and fixes up the fault, by
>> clearing the destination register and jumping over the faulting
>> instruction.
>>
>> A more generic solution would add a "handler" field to the table entry.
>>
>
> So, would it make sense to add a handler field, to be more consistent
> with say, x86?
>
> This code is heavily based on the ARM64 one. Would a "handler", make
> the ARM64 code simpler as well?
>

Yes, this "handler" like x86, as follows:
struct exception_table_entry {
	int insn, fixup, handler;
};

I understand that the "handler" is not make code simpler, but on-demand implementation.

This patch supports the exception fixup framework. In this patch, The exception was simply
handled(just skipping the fault instruction). We can support more complex exception processing
through the "handler".

>> The same issue in ARM64 is fixed in:
>> commit 800834285361 ("bpf, arm64: Add BPF exception tables"),
>>
>> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
>> Tested-by: Pu Lehui <pulehui@huawei.com>
>> ---
>>  arch/riscv/include/asm/Kbuild    |   1 -
>>  arch/riscv/include/asm/extable.h |  49 ++++++++
>>  arch/riscv/include/asm/uaccess.h |  13 ---
>>  arch/riscv/mm/extable.c          |  13 ++-
>>  arch/riscv/net/bpf_jit.h         |   1 +
>>  arch/riscv/net/bpf_jit_comp64.c  | 187 +++++++++++++++++++++++++------
>>  arch/riscv/net/bpf_jit_core.c    |  18 ++-
>>  7 files changed, 222 insertions(+), 60 deletions(-)
>>  create mode 100644 arch/riscv/include/asm/extable.h
>>
>> diff --git a/arch/riscv/include/asm/Kbuild b/arch/riscv/include/asm/Kbuild
>> index 445ccc97305a..57b86fd9916c 100644
>> --- a/arch/riscv/include/asm/Kbuild
>> +++ b/arch/riscv/include/asm/Kbuild
>> @@ -1,6 +1,5 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>  generic-y += early_ioremap.h
>> -generic-y += extable.h
>>  generic-y += flat.h
>>  generic-y += kvm_para.h
>>  generic-y += user.h
>> diff --git a/arch/riscv/include/asm/extable.h b/arch/riscv/include/asm/extable.h
>> new file mode 100644
>> index 000000000000..8a52cdd122de
>> --- /dev/null
>> +++ b/arch/riscv/include/asm/extable.h
>> @@ -0,0 +1,49 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef __ASM_EXTABLE_H
>> +#define __ASM_EXTABLE_H
>> +
>> +/*
>> + * The exception table consists of pairs of addresses: the first is the
>> + * address of an instruction that is allowed to fault, and the second is
>> + * the address at which the program should continue.  No registers are
>> + * modified, so it is entirely up to the continuation code to figure out
>> + * what to do.
>> + *
>> + * All the routines below use bits of fixup code that are out of line
>> + * with the main instruction path.  This means when everything is well,
>> + * we don't even have to jump over them.  Further, they do not intrude
>> + * on our cache or tlb entries.
>> + */
>> +struct exception_table_entry {
>> +       unsigned long insn, fixup;
>> +};
>> +
>
> RISC-V uses the generic exception_table_entry (linux/extable.h), so I
> don't see why it should be redefined here, without any
> changes.
>
> I'd suggest that instead of creating a new extable.h, simply fold the
> changes directly in the mm/except.c. More on that below.
>
> Unless, the "handler field" route is taken. Then, the new
> exception_table_entry should go here.

Ok, your suggestion is more reasonable and this will be fixed in V2.

>
>> +#ifdef CONFIG_BPF_JIT
>> +static inline bool in_bpf_jit(struct pt_regs *regs)
>> +{
>> +       if (!IS_ENABLED(CONFIG_BPF_JIT))
>> +               return false;
>> +
>> +       return regs->epc >= BPF_JIT_REGION_START &&
>> +               regs->epc < BPF_JIT_REGION_END;
>
> Nit/FYI: 100 char lines is OK nowadays! ;-)

Ok, This will be fixed in V2.

>
>> +}
>> +
>> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
>> +                             struct pt_regs *regs);
>> +#else /* !CONFIG_BPF_JIT */
>> +static inline bool in_bpf_jit(struct pt_regs *regs)
>> +{
>> +       return 0;
>> +}
>> +
>> +static inline
>> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
>> +                             struct pt_regs *regs)
>> +{
>> +       return 0;
>> +}
>> +#endif /* !CONFIG_BPF_JIT */
>> +
>> +struct pt_regs;
>> +extern int fixup_exception(struct pt_regs *regs);
>> +#endif
>> diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
>> index f314ff44c48d..96ea91dc0e9c 100644
>> --- a/arch/riscv/include/asm/uaccess.h
>> +++ b/arch/riscv/include/asm/uaccess.h
>> @@ -56,19 +56,6 @@ static inline int __access_ok(unsigned long addr, unsigned long size)
>>         return size <= TASK_SIZE && addr <= TASK_SIZE - size;
>>  }
>>
>> -/*
>> - * The exception table consists of pairs of addresses: the first is the
>> - * address of an instruction that is allowed to fault, and the second is
>> - * the address at which the program should continue.  No registers are
>> - * modified, so it is entirely up to the continuation code to figure out
>> - * what to do.
>> - *
>> - * All the routines below use bits of fixup code that are out of line
>> - * with the main instruction path.  This means when everything is well,
>> - * we don't even have to jump over them.  Further, they do not intrude
>> - * on our cache or tlb entries.
>> - */
>> -
>
> ...and don't remove this...
>

Ok, This will be fixed in V2.

>>  #define __LSW  0
>>  #define __MSW  1
>>
>> diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
>> index 2fc729422151..f8055c6d0f32 100644
>> --- a/arch/riscv/mm/extable.c
>> +++ b/arch/riscv/mm/extable.c
>> @@ -16,9 +16,12 @@ int fixup_exception(struct pt_regs *regs)
>>         const struct exception_table_entry *fixup;
>>
>>         fixup = search_exception_tables(regs->epc);
>> -       if (fixup) {
>> -               regs->epc = fixup->fixup;
>> -               return 1;
>> -       }
>> -       return 0;
>> +       if (!fixup)
>> +               return 0;
>> +
>> +       if (in_bpf_jit(regs))
>> +               return rv_bpf_fixup_exception(fixup, regs);
>> +
>
> ...instead add the definition of in_bpf_jit() here, and the
> CONFIG_BPF_JIT around the "if (in_bpf_jit()...)"

Ok, This will be fixed in V2.

>
>> +       regs->epc = fixup->fixup;
>> +       return 1;
>>  }
>> diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
>> index 75c1e9996867..82f717cc98f7 100644
>> --- a/arch/riscv/net/bpf_jit.h
>> +++ b/arch/riscv/net/bpf_jit.h
>> @@ -71,6 +71,7 @@ struct rv_jit_context {
>>         int ninsns;
>>         int epilogue_offset;
>>         int *offset;            /* BPF to RV */
>> +       int exentry_idx;
>
> I'd prefer if this would be named "nexentries" or something, so it's
> more consistent with "ninsns", clear that "this is number of extable
> entries".
>
>>         unsigned long flags;
>>         int stack_size;
>>  };
>> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
>> index 3af4131c22c7..97411d43785e 100644
>> --- a/arch/riscv/net/bpf_jit_comp64.c
>> +++ b/arch/riscv/net/bpf_jit_comp64.c
>> @@ -5,6 +5,7 @@
>>   *
>>   */
>>
>> +#include <linux/bitfield.h>
>>  #include <linux/bpf.h>
>>  #include <linux/filter.h>
>>  #include "bpf_jit.h"
>> @@ -27,6 +28,21 @@ static const int regmap[] = {
>>         [BPF_REG_AX] =  RV_REG_T0,
>>  };
>>
>> +static const int pt_regmap[] = {
>> +       [RV_REG_A5] = offsetof(struct pt_regs, a5),
>> +       [RV_REG_A0] = offsetof(struct pt_regs, a0),
>> +       [RV_REG_A1] = offsetof(struct pt_regs, a1),
>> +       [RV_REG_A2] = offsetof(struct pt_regs, a2),
>> +       [RV_REG_A3] = offsetof(struct pt_regs, a3),
>> +       [RV_REG_A4] = offsetof(struct pt_regs, a4),
>> +       [RV_REG_S1] = offsetof(struct pt_regs, s1),
>> +       [RV_REG_S2] = offsetof(struct pt_regs, s2),
>> +       [RV_REG_S3] = offsetof(struct pt_regs, s3),
>> +       [RV_REG_S4] = offsetof(struct pt_regs, s4),
>> +       [RV_REG_S5] = offsetof(struct pt_regs, s5),
>> +       [RV_REG_T0] = offsetof(struct pt_regs, t0),
>> +};
>> +
>>  enum {
>>         RV_CTX_F_SEEN_TAIL_CALL =       0,
>>         RV_CTX_F_SEEN_CALL =            RV_REG_RA,
>> @@ -440,6 +456,71 @@ static int emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
>>         return 0;
>>  }
>>
>> +#define BPF_FIXUP_OFFSET_MASK   GENMASK(26, 0)
>> +#define BPF_FIXUP_REG_MASK      GENMASK(31, 27)
>> +
>> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
>> +                               struct pt_regs *regs)
>> +{
>> +       off_t offset = FIELD_GET(BPF_FIXUP_OFFSET_MASK, ex->fixup);
>> +       int regs_offset = FIELD_GET(BPF_FIXUP_REG_MASK, ex->fixup);
>> +
>> +       *(unsigned long *)((unsigned char *)regs + pt_regmap[regs_offset]) = 0;
>> +       regs->epc = (unsigned long)&ex->fixup - offset;
>> +
>> +       return 1;
>> +}
>> +
>> +/* For accesses to BTF pointers, add an entry to the exception table */
>> +static int add_exception_handler(const struct bpf_insn *insn,
>> +                                struct rv_jit_context *ctx,
>> +                                int dst_reg, int insn_len)
>> +{
>> +       off_t offset;
>> +       unsigned long pc;
>> +       struct exception_table_entry *ex;
>> +
>
> Nit: Please use reverse xmas tree sorting (longest lines first).

Ok, This will be fixed in V2.

>
> [...]
>
>
> Cheers,
> Björn
> .
>
