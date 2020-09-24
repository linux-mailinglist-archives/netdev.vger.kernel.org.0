Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92334277B92
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgIXWRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:17:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:51230 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIXWRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 18:17:39 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLZYW-0005Rj-Op; Fri, 25 Sep 2020 00:17:36 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLZYW-000DK0-JU; Fri, 25 Sep 2020 00:17:36 +0200
Subject: Re: [PATCH bpf-next 4/6] bpf, libbpf: add bpf_tail_call_static helper
 for bpf programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <cover.1600967205.git.daniel@iogearbox.net>
 <ae48d5b3c4b6b7ee1285c3167c3aa38ae3fdc093.1600967205.git.daniel@iogearbox.net>
 <CAEf4BzZ4kFGeUgpJV9MgE1iJ6Db=E-TXoF73z3Rae5zgp5LLZA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5f3850b2-7346-02d7-50f5-f63355115f35@iogearbox.net>
Date:   Fri, 25 Sep 2020 00:17:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZ4kFGeUgpJV9MgE1iJ6Db=E-TXoF73z3Rae5zgp5LLZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25937/Thu Sep 24 15:53:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 10:53 PM, Andrii Nakryiko wrote:
> On Thu, Sep 24, 2020 at 11:22 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> Port of tail_call_static() helper function from Cilium's BPF code base [0]
>> to libbpf, so others can easily consume it as well. We've been using this
>> in production code for some time now. The main idea is that we guarantee
>> that the kernel's BPF infrastructure and JIT (here: x86_64) can patch the
>> JITed BPF insns with direct jumps instead of having to fall back to using
>> expensive retpolines. By using inline asm, we guarantee that the compiler
>> won't merge the call from different paths with potentially different
>> content of r2/r3.
>>
>> We're also using __throw_build_bug() macro in different places as a neat
>> trick to trigger compilation errors when compiler does not remove code at
>> compilation time. This works for the BPF backend as it does not implement
>> the __builtin_trap().
>>
>>    [0] https://github.com/cilium/cilium/commit/f5537c26020d5297b70936c6b7d03a1e412a1035
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
>>   tools/lib/bpf/bpf_helpers.h | 32 ++++++++++++++++++++++++++++++++
>>   1 file changed, 32 insertions(+)
>>
>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
>> index 1106777df00b..18b75a4c82e6 100644
>> --- a/tools/lib/bpf/bpf_helpers.h
>> +++ b/tools/lib/bpf/bpf_helpers.h
>> @@ -53,6 +53,38 @@
>>          })
>>   #endif
>>
>> +/*
>> + * Misc useful helper macros
>> + */
>> +#ifndef __throw_build_bug
>> +# define __throw_build_bug()   __builtin_trap()
>> +#endif
> 
> this will become part of libbpf stable API, do we want/need to expose
> it? If we want to expose it, then we should probably provide a better
> description.
> 
> But also curious, how is it better than _Static_assert() (see
> test_cls_redirect.c), which also allows to provide a better error
> message?

Need to get back to you whether that has same semantics. We use the __throw_build_bug()
also in __bpf_memzero() and friends [0] as a way to trigger a hard build bug if we hit
a default switch-case [0], so we detect unsupported sizes which are not covered by the
implementation yet. If _Static_assert (0, "foo") does the trick, we could also use that;
will check with our code base.

   [0] https://github.com/cilium/cilium/blob/master/bpf/include/bpf/builtins.h

>> +static __always_inline void
>> +bpf_tail_call_static(void *ctx, const void *map, const __u32 slot)
>> +{
>> +       if (!__builtin_constant_p(slot))
>> +               __throw_build_bug();
>> +
>> +       /*
>> +        * Don't gamble, but _guarantee_ that LLVM won't optimize setting
>> +        * r2 and r3 from different paths ending up at the same call insn as
>> +        * otherwise we won't be able to use the jmpq/nopl retpoline-free
>> +        * patching by the x86-64 JIT in the kernel.
>> +        *
> 
> So the clobbering comment below is completely clear. But this one is
> less clear without some sort of example situation in which bad things
> happen. Do you mind providing some pseudo-C example in which the
> compiler will optimize things in such a way that the tail call
> patching won't happen?

The details are pretty much here [1] and mentioned at plumbers, so if we end up from
different paths with different map or const key at the same tail-call call insn, then
the record_func_key() will determine that we need to emit retpoline instead of patching
which could have occured with two tail-call call insns, for example. This helper is just
to guarantee that the latter will always happen.

   [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d2e4c1e6c2947269346054ac8937ccfe9e0bcc6b

>> +        * Note on clobber list: we need to stay in-line with BPF calling
>> +        * convention, so even if we don't end up using r0, r4, r5, we need
>> +        * to mark them as clobber so that LLVM doesn't end up using them
>> +        * before / after the call.
>> +        */
>> +       asm volatile("r1 = %[ctx]\n\t"
>> +                    "r2 = %[map]\n\t"
>> +                    "r3 = %[slot]\n\t"
>> +                    "call 12\n\t"
>> +                    :: [ctx]"r"(ctx), [map]"r"(map), [slot]"i"(slot)
>> +                    : "r0", "r1", "r2", "r3", "r4", "r5");
>> +}
>> +
>>   /*
>>    * Helper structure used by eBPF C program
>>    * to describe BPF map attributes to libbpf loader
>> --
>> 2.21.0
>>

