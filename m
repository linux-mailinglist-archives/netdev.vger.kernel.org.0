Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A6443CA96
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237476AbhJ0N3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:29:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:25318 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242135AbhJ0N3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 09:29:20 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HfTr45YthzbhN1;
        Wed, 27 Oct 2021 21:22:12 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 21:26:40 +0800
Received: from [10.174.179.234] (10.174.179.234) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 21:26:39 +0800
Subject: Re: [PATCH bpf-next,v3] riscv, bpf: Add BPF exception tables
To:     Mark Rutland <mark.rutland@arm.com>
References: <20211027111822.3801679-1-tongtiangen@huawei.com>
 <20211027115043.GB54628@C02TD0UTHF1T.local>
CC:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
From:   tongtiangen <tongtiangen@huawei.com>
Message-ID: <8ad6338b-b02c-8488-c725-f522435c8916@huawei.com>
Date:   Wed, 27 Oct 2021 21:26:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20211027115043.GB54628@C02TD0UTHF1T.local>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.234]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/27 19:50, Mark Rutland wrote:
> On Wed, Oct 27, 2021 at 11:18:22AM +0000, Tong Tiangen wrote:
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
>> A more generic solution would add a "handler" field to the table entry,
>> like on x86 and s390.
>>
>> The same issue in ARM64 is fixed in:
>> commit 800834285361 ("bpf, arm64: Add BPF exception tables")
>
>> +#ifdef CONFIG_BPF_JIT
>> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex, struct pt_regs *regs);
>> +#endif
>> +
>>  int fixup_exception(struct pt_regs *regs)
>>  {
>>  	const struct exception_table_entry *fixup;
>>
>>  	fixup = search_exception_tables(regs->epc);
>> -	if (fixup) {
>> -		regs->epc = fixup->fixup;
>> -		return 1;
>> -	}
>> -	return 0;
>> +	if (!fixup)
>> +		return 0;
>> +
>> +#ifdef CONFIG_BPF_JIT
>> +	if (regs->epc >= BPF_JIT_REGION_START && regs->epc < BPF_JIT_REGION_END)
>> +		return rv_bpf_fixup_exception(fixup, regs);
>> +#endif
>> +
>> +	regs->epc = fixup->fixup;
>> +	return 1;
>>  }
>
> As a heads-up, on the extable front, both arm64 and x86 are moving to
> having an enumerated "type" field to select the handler:
>
> x86:
>
>   https://lore.kernel.org/lkml/20210908132525.211958725@linutronix.de/
>
> arm64:
>
>   https://lore.kernel.org/linux-arm-kernel/20211019160219.5202-11-mark.rutland@arm.com/
>
> ... and going forwards, riscv might want to do likewise.
>
> Thanks,
> Mark.
> .
>

Thanks mark, I'm very interested in this change.
