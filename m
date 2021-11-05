Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF34446696
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 16:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbhKEQCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 12:02:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:57688 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbhKEQCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 12:02:31 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mj1d4-000ASG-G8; Fri, 05 Nov 2021 16:59:46 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mj1d4-00007b-8a; Fri, 05 Nov 2021 16:59:46 +0100
Subject: Re: [PATCH bpf-next] riscv, bpf: Fix RV32 broken build, and silence
 RV64 warning
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        jszhang@kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Tong Tiangen <tongtiangen@huawei.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <20211103115453.397209-1-bjorn@kernel.org>
 <f98b15c9-bd06-267e-e404-ae4f607d8740@iogearbox.net>
 <CAJ+HfNg9Ko93D1M5En8wv4f-7j_by=OwnewRDiM+xQ0EZLw06w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <53fbebfd-f786-9b21-3477-437395e3e023@iogearbox.net>
Date:   Fri, 5 Nov 2021 16:59:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNg9Ko93D1M5En8wv4f-7j_by=OwnewRDiM+xQ0EZLw06w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26344/Fri Nov  5 09:18:44 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 2:35 PM, Björn Töpel wrote:
> On Wed, 3 Nov 2021 at 14:15, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 11/3/21 12:54 PM, Björn Töpel wrote:
>>> Commit 252c765bd764 ("riscv, bpf: Add BPF exception tables") only
>>> addressed RV64, and broke the RV32 build [1]. Fix by gating the exception
>>> tables code with CONFIG_ARCH_RV64I.
>>>
>>> Further, silence a "-Wmissing-prototypes" warning [2] in the RV64 BPF
>>> JIT.
>>>
>>> [1] https://lore.kernel.org/llvm/202111020610.9oy9Rr0G-lkp@intel.com/
>>> [2] https://lore.kernel.org/llvm/202110290334.2zdMyRq4-lkp@intel.com/
>>>
>>> Fixes: 252c765bd764 ("riscv, bpf: Add BPF exception tables")
>>> Signed-off-by: Björn Töpel <bjorn@kernel.org>
>>> ---
>>> Tong/Daniel: The RV32 build has been broken since Thursday. I'll try
>>> to fast-track a bit, and commit a quick-fix for it. Hope that's OK
>>> with you, Tong!
>>>
>>> I've verified the build on my machine using riscv32 GCC 9.3.0 and
>>> riscv64 GCC 11.2.0.
>>
>> Thanks for the fix Bjorn!
>>
[...]
>>> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
>>> +                             struct pt_regs *regs);
>>
>> I'm okay to take this as a quick fix, but if its not too much hassle, could we add a
>> arch/riscv/include/asm/extable.h in similar fashion like arm64 or x86 where we move
>> the ex_handler_bpf() signature there, did you have a chance to check?
> 
> OK! I've not looked into it yet!
> 
> There's a patch out from Jisheng on the RV list, which is starting
> some consolidation work [1].
> 
> @Jisheng What do you think about adding type/handlers [2,3] as
> arm64/x86 recently did, to your series?

Fyi, Bjorn, took your fix into bpf so we can move forward wrt broken build & warning
given its small anyway and I'm doing bpf PR very soon today. Either way, Jisheng, you
or Tong can follow-up looking into the extable streamlining wrt arm64/x86. Thanks!

> [1] https://lore.kernel.org/linux-riscv/20211022001957.1eba8f04@xhacker/
> [2] https://lore.kernel.org/linux-arm-kernel/20211019160219.5202-11-mark.rutland@arm.com/
> [3] https://lore.kernel.org/lkml/20210908132525.211958725@linutronix.de/
