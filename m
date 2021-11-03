Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFFF44426A
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhKCNch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:32:37 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:27172 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKCNcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 09:32:36 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Hknf00NcwzTgDr;
        Wed,  3 Nov 2021 21:28:24 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 3 Nov 2021 21:29:53 +0800
Received: from [10.174.179.234] (10.174.179.234) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 3 Nov 2021 21:29:52 +0800
Subject: Re: [PATCH bpf-next] riscv, bpf: Fix RV32 broken build, and silence
 RV64 warning
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        <ast@kernel.org>, <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20211103115453.397209-1-bjorn@kernel.org>
 <f98b15c9-bd06-267e-e404-ae4f607d8740@iogearbox.net>
CC:     <luke.r.nels@gmail.com>, <xi.wang@gmail.com>,
        <linux-riscv@lists.infradead.org>
From:   tongtiangen <tongtiangen@huawei.com>
Message-ID: <993a1ca1-dc66-e749-bc69-a439dffb0534@huawei.com>
Date:   Wed, 3 Nov 2021 21:29:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <f98b15c9-bd06-267e-e404-ae4f607d8740@iogearbox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.234]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/11/3 21:15, Daniel Borkmann wrote:
> On 11/3/21 12:54 PM, Björn Töpel wrote:
>> Commit 252c765bd764 ("riscv, bpf: Add BPF exception tables") only
>> addressed RV64, and broke the RV32 build [1]. Fix by gating the exception
>> tables code with CONFIG_ARCH_RV64I.
>>
>> Further, silence a "-Wmissing-prototypes" warning [2] in the RV64 BPF
>> JIT.
>>
>> [1] https://lore.kernel.org/llvm/202111020610.9oy9Rr0G-lkp@intel.com/
>> [2] https://lore.kernel.org/llvm/202110290334.2zdMyRq4-lkp@intel.com/
>>
>> Fixes: 252c765bd764 ("riscv, bpf: Add BPF exception tables")
>> Signed-off-by: Björn Töpel <bjorn@kernel.org>
>> ---
>> Tong/Daniel: The RV32 build has been broken since Thursday. I'll try
>> to fast-track a bit, and commit a quick-fix for it. Hope that's OK
>> with you, Tong!
>>
>> I've verified the build on my machine using riscv32 GCC 9.3.0 and
>> riscv64 GCC 11.2.0.
>
> Thanks for the fix Bjorn!
>
>> arch/riscv/mm/extable.c         | 4 ++--
>>   arch/riscv/net/bpf_jit_comp64.c | 2 ++
>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
>> index 18bf338303b6..ddb7d3b99e89 100644
>> --- a/arch/riscv/mm/extable.c
>> +++ b/arch/riscv/mm/extable.c
>> @@ -11,7 +11,7 @@
>>   #include <linux/module.h>
>>   #include <linux/uaccess.h>
>>   -#ifdef CONFIG_BPF_JIT
>> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
>>   int rv_bpf_fixup_exception(const struct exception_table_entry *ex, struct pt_regs *regs);
>>   #endif
>>   @@ -23,7 +23,7 @@ int fixup_exception(struct pt_regs *regs)
>>       if (!fixup)
>>           return 0;
>>   -#ifdef CONFIG_BPF_JIT
>> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
>>       if (regs->epc >= BPF_JIT_REGION_START && regs->epc < BPF_JIT_REGION_END)
>>           return rv_bpf_fixup_exception(fixup, regs);
>>   #endif
>> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
>> index 2ca345c7b0bf..f2a779c7e225 100644
>> --- a/arch/riscv/net/bpf_jit_comp64.c
>> +++ b/arch/riscv/net/bpf_jit_comp64.c
>> @@ -459,6 +459,8 @@ static int emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
>>   #define BPF_FIXUP_OFFSET_MASK   GENMASK(26, 0)
>>   #define BPF_FIXUP_REG_MASK      GENMASK(31, 27)
>>   +int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
>> +                struct pt_regs *regs);
>
> I'm okay to take this as a quick fix, but if its not too much hassle, could we add a
> arch/riscv/include/asm/extable.h in similar fashion like arm64 or x86 where we move
> the ex_handler_bpf() signature there, did you have a chance to check?

Hi Daniel:
On the question of whether to add asm/extable.h, I have an in-depth discussion with Björn, both schemes are OK.

This patch is the scheme of adding a header file:
https://lore.kernel.org/bpf/20211102145642.724820-1-tongtiangen@huawei.com/

Reviewed-by: Tong Tiangen <tongtiangen@huawei.com>

Thanks.

>
>>   int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
>>                   struct pt_regs *regs)
>>   {
>>
>> base-commit: cc0356d6a02e064387c16a83cb96fe43ef33181e
>>
>
> Thanks,
> Daniel
> .
>
