Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC6843D859
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhJ1BE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:04:27 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13983 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhJ1BE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 21:04:27 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HfnKD3KrdzWtCr;
        Thu, 28 Oct 2021 09:00:00 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 09:01:57 +0800
Received: from [10.174.179.234] (10.174.179.234) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 09:01:55 +0800
Subject: Re: [PATCH bpf-next,v3] riscv, bpf: Add BPF exception tables
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
References: <20211027111822.3801679-1-tongtiangen@huawei.com>
 <CAJ+HfNhC=hfFnjVvCf=bw+n1msRjR3gGUyapAmsRDupZ5CusrQ@mail.gmail.com>
 <15487721-b3de-73c7-5ef3-614c6da2f8cd@iogearbox.net>
CC:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
From:   tongtiangen <tongtiangen@huawei.com>
Message-ID: <5c38b790-65e9-6ba2-75bd-121d6d51ab34@huawei.com>
Date:   Thu, 28 Oct 2021 09:01:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <15487721-b3de-73c7-5ef3-614c6da2f8cd@iogearbox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.234]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/28 7:11, Daniel Borkmann wrote:
> On 10/27/21 6:55 PM, Björn Töpel wrote:
>> On Wed, 27 Oct 2021 at 13:03, Tong Tiangen <tongtiangen@huawei.com> wrote:
>>>
>>> When a tracing BPF program attempts to read memory without using the
>>> bpf_probe_read() helper, the verifier marks the load instruction with
>>> the BPF_PROBE_MEM flag. Since the riscv JIT does not currently recognize
>>> this flag it falls back to the interpreter.
>>>
>>> Add support for BPF_PROBE_MEM, by appending an exception table to the
>>> BPF program. If the load instruction causes a data abort, the fixup
>>> infrastructure finds the exception table and fixes up the fault, by
>>> clearing the destination register and jumping over the faulting
>>> instruction.
>>>
>>> A more generic solution would add a "handler" field to the table entry,
>>> like on x86 and s390.
>>>
>>> The same issue in ARM64 is fixed in:
>>> commit 800834285361 ("bpf, arm64: Add BPF exception tables")
>>>
>>> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
>>> Tested-by: Pu Lehui <pulehui@huawei.com>
>>> ---
>>> v3:
>>> Modify according to Björn's comments, mainly code optimization.
>>
>> Thank you!
>>
>> I ran this patch against the test_bpf.ko, and selftests/bpf -- no
>> regressions, and after the patch is applied more tests passes. Yay!
>>
>> On a related note. The RISC-V selftests/bpf is in a pretty lousy
>> state. I'll send a cleanup patch for them soonish. E.g.:
>
> Thanks for testing!
>
>> * RISC-V is missing in bpf_tracing.h (libbpf)
>> * Some programs don't converge in 16 steps, I had to increase it to ~32
>> * The selftest/bpf Makefile needed some RV specific changes
>> * ...a lot of tests still don't pass, and needs to be looked in to
>
> Sounds good, please ship them. ;)
>
>> Feel free to add:
>>
>> Acked-by: Björn Töpel <bjorn@kernel.org>
>
> Applied, thanks! Tong, if you have a chance, please follow up with Mark's
> suggestion to align the extable infra to arm64/x86.

Thanks, Mark's suggestion is good. I will improve this part if I have the opportunity.
>
> Thanks,
> Daniel
> .
>
