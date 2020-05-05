Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3415D1C5722
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgEENh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:37:29 -0400
Received: from www62.your-server.de ([213.133.104.62]:53756 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728608AbgEENh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 09:37:28 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jVxlF-0005Bf-8A; Tue, 05 May 2020 15:37:25 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jVxlE-000FC1-Su; Tue, 05 May 2020 15:37:24 +0200
Subject: Re: [PATCH 1/1] selftests/bpf: add cls_redirect classifier
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Theo Julienne <theojulienne@github.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com
References: <20200424185556.7358-1-lmb@cloudflare.com>
 <20200424185556.7358-2-lmb@cloudflare.com>
 <20200426173324.5zg7isugereb5ert@ast-mbp.dhcp.thefacebook.com>
 <CACAyw98nK_Vkstp-vEqNwKXtoCRnTOPr7Eh+ziH56tJGbnPsig@mail.gmail.com>
 <185417b8-0d50-f8a3-7a09-949066579732@iogearbox.net>
 <20200504234827.6mrogryxk73jc6x2@ast-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a5829cb4-3759-6cd8-c9de-62e9813f00d6@iogearbox.net>
Date:   Tue, 5 May 2020 15:37:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200504234827.6mrogryxk73jc6x2@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25803/Tue May  5 14:19:25 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/20 1:48 AM, Alexei Starovoitov wrote:
> On Sat, May 02, 2020 at 01:48:51AM +0200, Daniel Borkmann wrote:
>> On 4/27/20 11:45 AM, Lorenz Bauer wrote:
>>> On Sun, 26 Apr 2020 at 18:33, Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>> [...]
>>>>> +/* Linux packet pointers are either aligned to NET_IP_ALIGN (aka 2 bytes),
>>>>> + * or not aligned if the arch supports efficient unaligned access.
>>>>> + *
>>>>> + * Since the verifier ensures that eBPF packet accesses follow these rules,
>>>>> + * we can tell LLVM to emit code as if we always had a larger alignment.
>>>>> + * It will yell at us if we end up on a platform where this is not valid.
>>>>> + */
>>>>> +typedef uint8_t *net_ptr __attribute__((align_value(8)));
>>>>
>>>> Wow. I didn't know about this attribute.
>>>> I wonder whether it can help Daniel's memcpy hack.
>>>
>>> Yes, I think so.
>>
>> Just for some more context [0]. I think the problem is a bit more complex in
>> general. Generally, _any_ kind of pointer to some data (except for the stack)
>> is currently treated as byte-by-byte copy from __builtin_memcpy() and other
>> similarly available __builtin_*() helpers on BPF backend since the backend
>> cannot make any assumptions about the data's alignment and whether unaligned
>> access from the underlying arch is ok & efficient (the latter the verifier
>> does judge for us however). So it's definitely not just limited to xdp->data.
>> There is also the issue that while access to any non-stack data can be
>> unaligned, access to the stack however cannot. I've discussed a while back
>> with Yonghong about potential solutions. One would be to add a small patch
>> to the BPF backend to enable __builtin_*() helpers to allow for unaligned
>> access which could then be opt-ed in e.g. via -mattr from llc for the case
>> when we know that the compiled program only runs on archs with efficient
>> unaligned access anyway. However, this still potentially breaks with the BPF
>> stack for the case when objects are, for example, larger than size 8 but with
>> a natural alignment smaller than 8 where __builtin_memcpy() would then decide
>> to emit dw-typed load/stores. But for these cases could then be annotated via
>> __aligned(8) on stack. So this is basically what we do right now as a generic
>> workaround in Cilium [0], meaning, our own memcpy/memset with optimal number
>> of instructions and __aligned(8) where needed; most of the time this __aligned(8)
>> is not needed, so it's really just a few places, and we also have a cocci
>> scripts to catch these during development if needed. Anyway, real thing would
>> be to allow the BPF stack for unaligned access as well and then BPF backend
>> could nicely solve this in a native way w/o any workarounds, but that is tbd.
>>
>> Thanks,
>> Daniel
>>
>>    [0] https://github.com/cilium/cilium/blob/master/bpf/include/bpf/builtins.h
> 
> Daniel,
> do you mind adding such memcpy to libbpf ?

We could do that, yeah. Is there a way from BPF C code when compiling with clang to
get to the actual underlying architecture (x86-64, arm64, ppc, etc) when compiling
with `-target bpf` so that we can always fall back to __builtin_*() for those where
verifier would bail out on unaligned access? Keep in mind the __bpf_memcpy() and
__bpf_memzero() from [0] are fully compile time resolved and I did the implementation
for sizes of 1,2,4,..., 96 where the latter is in two' increments, so no odd buffer
sizes as we don't need them in our code. If someone does hit such an odd case, then
I'm currently throwing a compilation error via __throw_build_bug(). Latter is a nice
way to be able to guarantee that a switch/case or if condition is never hit during
compilation time. It resolves to __builtin_trap() which is not implemented in the
BPF backend and therefore yells to the developer when built into the code (this has
a nice property which wouldn't work with BUILD_BUG_ON() for example). Anyway, what
I'm saying is that either we'd need the full thing with all sizes or document that
unsupported size would be hit when __builtin_trap() assertion is seen.

Thanks,
Daniel
