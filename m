Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810E843D74F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 01:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhJ0XNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 19:13:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:40952 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhJ0XNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 19:13:42 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mfs4W-000F2p-5m; Thu, 28 Oct 2021 01:11:04 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mfs4V-000GPT-Q9; Thu, 28 Oct 2021 01:11:03 +0200
Subject: Re: [PATCH bpf-next,v3] riscv, bpf: Add BPF exception tables
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Tong Tiangen <tongtiangen@huawei.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
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
References: <20211027111822.3801679-1-tongtiangen@huawei.com>
 <CAJ+HfNhC=hfFnjVvCf=bw+n1msRjR3gGUyapAmsRDupZ5CusrQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <15487721-b3de-73c7-5ef3-614c6da2f8cd@iogearbox.net>
Date:   Thu, 28 Oct 2021 01:11:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNhC=hfFnjVvCf=bw+n1msRjR3gGUyapAmsRDupZ5CusrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26335/Wed Oct 27 10:28:55 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/21 6:55 PM, Björn Töpel wrote:
> On Wed, 27 Oct 2021 at 13:03, Tong Tiangen <tongtiangen@huawei.com> wrote:
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
>> A more generic solution would add a "handler" field to the table entry,
>> like on x86 and s390.
>>
>> The same issue in ARM64 is fixed in:
>> commit 800834285361 ("bpf, arm64: Add BPF exception tables")
>>
>> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
>> Tested-by: Pu Lehui <pulehui@huawei.com>
>> ---
>> v3:
>> Modify according to Björn's comments, mainly code optimization.
> 
> Thank you!
> 
> I ran this patch against the test_bpf.ko, and selftests/bpf -- no
> regressions, and after the patch is applied more tests passes. Yay!
> 
> On a related note. The RISC-V selftests/bpf is in a pretty lousy
> state. I'll send a cleanup patch for them soonish. E.g.:

Thanks for testing!

> * RISC-V is missing in bpf_tracing.h (libbpf)
> * Some programs don't converge in 16 steps, I had to increase it to ~32
> * The selftest/bpf Makefile needed some RV specific changes
> * ...a lot of tests still don't pass, and needs to be looked in to

Sounds good, please ship them. ;)

> Feel free to add:
> 
> Acked-by: Björn Töpel <bjorn@kernel.org>

Applied, thanks! Tong, if you have a chance, please follow up with Mark's
suggestion to align the extable infra to arm64/x86.

Thanks,
Daniel
