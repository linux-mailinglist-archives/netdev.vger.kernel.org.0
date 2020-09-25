Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B0127923F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgIYUdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgIYUXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 16:23:35 -0400
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD49C0613BD;
        Fri, 25 Sep 2020 12:57:30 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLtlc-000278-AU; Fri, 25 Sep 2020 21:52:28 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLtlc-000NwZ-4t; Fri, 25 Sep 2020 21:52:28 +0200
Subject: Re: [PATCH bpf-next 4/6] bpf, libbpf: add bpf_tail_call_static helper
 for bpf programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <cover.1600967205.git.daniel@iogearbox.net>
 <ae48d5b3c4b6b7ee1285c3167c3aa38ae3fdc093.1600967205.git.daniel@iogearbox.net>
 <CAEf4BzZ4kFGeUgpJV9MgE1iJ6Db=E-TXoF73z3Rae5zgp5LLZA@mail.gmail.com>
 <5f3850b2-7346-02d7-50f5-f63355115f35@iogearbox.net>
 <ec815b89-09aa-9e33-29b4-19e369ccfa21@iogearbox.net>
 <52cd972d-c183-5d14-b790-4d3a66b8fda2@iogearbox.net>
 <CAEf4BzZmpLOCSp4wvXWHzmfZHq5R4S32M0_V5OvGA+QQGGG43w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bdddb94c-555c-3833-f82e-a53f83b1a77e@iogearbox.net>
Date:   Fri, 25 Sep 2020 21:52:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZmpLOCSp4wvXWHzmfZHq5R4S32M0_V5OvGA+QQGGG43w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25938/Fri Sep 25 15:54:20 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/20 6:50 PM, Andrii Nakryiko wrote:
> On Fri, Sep 25, 2020 at 8:52 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 9/25/20 5:42 PM, Daniel Borkmann wrote:
>>> On 9/25/20 12:17 AM, Daniel Borkmann wrote:
>>>> On 9/24/20 10:53 PM, Andrii Nakryiko wrote:
>>>>> On Thu, Sep 24, 2020 at 11:22 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>>>>
>>>>>> Port of tail_call_static() helper function from Cilium's BPF code base [0]
>>>>>> to libbpf, so others can easily consume it as well. We've been using this
>>>>>> in production code for some time now. The main idea is that we guarantee
>>>>>> that the kernel's BPF infrastructure and JIT (here: x86_64) can patch the
>>>>>> JITed BPF insns with direct jumps instead of having to fall back to using
>>>>>> expensive retpolines. By using inline asm, we guarantee that the compiler
>>>>>> won't merge the call from different paths with potentially different
>>>>>> content of r2/r3.
>>>>>>
>>>>>> We're also using __throw_build_bug() macro in different places as a neat
>>>>>> trick to trigger compilation errors when compiler does not remove code at
>>>>>> compilation time. This works for the BPF backend as it does not implement
>>>>>> the __builtin_trap().
>>>>>>
>>>>>>     [0] https://github.com/cilium/cilium/commit/f5537c26020d5297b70936c6b7d03a1e412a1035
>>>>>>
>>>>>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>>>>>> ---
>>>>>>    tools/lib/bpf/bpf_helpers.h | 32 ++++++++++++++++++++++++++++++++
>>>>>>    1 file changed, 32 insertions(+)
>>>>>>
>>>>>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
>>>>>> index 1106777df00b..18b75a4c82e6 100644
>>>>>> --- a/tools/lib/bpf/bpf_helpers.h
>>>>>> +++ b/tools/lib/bpf/bpf_helpers.h
>>>>>> @@ -53,6 +53,38 @@
>>>>>>           })
>>>>>>    #endif
>>>>>>
>>>>>> +/*
>>>>>> + * Misc useful helper macros
>>>>>> + */
>>>>>> +#ifndef __throw_build_bug
>>>>>> +# define __throw_build_bug()   __builtin_trap()
>>>>>> +#endif
>>>>>
>>>>> this will become part of libbpf stable API, do we want/need to expose
>>>>> it? If we want to expose it, then we should probably provide a better
>>>>> description.
>>>>>
>>>>> But also curious, how is it better than _Static_assert() (see
>>>>> test_cls_redirect.c), which also allows to provide a better error
>>>>> message?
>>>>
>>>> Need to get back to you whether that has same semantics. We use the __throw_build_bug()
>>>> also in __bpf_memzero() and friends [0] as a way to trigger a hard build bug if we hit
>>>> a default switch-case [0], so we detect unsupported sizes which are not covered by the
>>>> implementation yet. If _Static_assert (0, "foo") does the trick, we could also use that;
>>>> will check with our code base.
>>>
>>> So _Static_assert() won't work here, for example consider:
>>>
>>>     # cat f1.c
>>>     int main(void)
>>>     {
>>>       if (0)
>>>           _Static_assert(0, "foo");
>>>       return 0;
>>>     }
>>>     # clang -target bpf -Wall -O2 -c f1.c -o f1.o
>>>     f1.c:4:3: error: expected expression
>>>                   _Static_assert(0, "foo");
>>>                   ^
>>>     1 error generated.
>>
>> .. aaand it looks like I need some more coffee. ;-) But result is the same after all:
>>
>>     # clang -target bpf -Wall -O2 -c f1.c -o f1.o
>>     f1.c:4:3: error: static_assert failed "foo"
>>                   _Static_assert(0, "foo");
>>                   ^              ~
>>     1 error generated.
>>
>>     # cat f1.c
>>     int main(void)
>>     {
>>          if (0) {
>>                  _Static_assert(0, "foo");
>>          }
>>          return 0;
>>     }
> 
> You need still more :-P. For you use case it will look like this:
> 
> $ cat test-bla.c
> int bar(int x) {
>         _Static_assert(!__builtin_constant_p(x), "not a constant!");
>         return x;
> }
> 
> int foo() {
>          bar(123);
>          return 0;
> }
> $ clang -target bpf -O2 -c test-bla.c -o test-bla.o
> $ echo $?
> 0

Right, but that won't work for example for the use case to detect switch cases which fall
into default case as mentioned with the mem* optimizations earlier in this thread.

> But in general to ensure unreachable code it's probably useful anyway
> to have this. How about calling it __bpf_build_error() or maybe even
> __bpf_unreachable()?

I think the __bpf_unreachable() sounds best to me, will use that.

>>> In order for it to work as required form the use-case, the _Static_assert() must not trigger
>>> here given the path is unreachable and will be optimized away. I'll add a comment to the
>>> __throw_build_bug() helper. Given libbpf we should probably also prefix with bpf_. If you see
>>> a better name that would fit, pls let me know.
>>>
>>>>     [0] https://github.com/cilium/cilium/blob/master/bpf/include/bpf/builtins.h
>>> Thanks,
>>> Daniel
>>

