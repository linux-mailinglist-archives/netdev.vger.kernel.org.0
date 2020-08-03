Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FC623A7FC
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgHCOAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:00:17 -0400
Received: from www62.your-server.de ([213.133.104.62]:36412 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgHCOAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:00:17 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2b0d-00056W-FE; Mon, 03 Aug 2020 16:00:11 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2b0d-000U2m-7y; Mon, 03 Aug 2020 16:00:11 +0200
Subject: Re: [PATCH v6 bpf-next 0/6] bpf: tailcalls in BPF subprograms
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
References: <20200731000324.2253-1-maciej.fijalkowski@intel.com>
 <fbe6e5ca-65ba-7698-3b8d-1214b5881e88@iogearbox.net>
 <20200801071357.GA19421@ranger.igk.intel.com>
 <20200802030752.bnebgrr6jkl3dgnk@ast-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f37dea67-9128-a1a2-beaa-2e74b321504a@iogearbox.net>
Date:   Mon, 3 Aug 2020 16:00:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200802030752.bnebgrr6jkl3dgnk@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25892/Sun Aug  2 17:01:36 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/20 5:07 AM, Alexei Starovoitov wrote:
> On Sat, Aug 01, 2020 at 09:13:57AM +0200, Maciej Fijalkowski wrote:
>> On Sat, Aug 01, 2020 at 03:03:19AM +0200, Daniel Borkmann wrote:
>>> On 7/31/20 2:03 AM, Maciej Fijalkowski wrote:
>>>> v5->v6:
>>>> - propagate only those poke descriptors that individual subprogram is
>>>>     actually using (Daniel)
>>>> - drop the cumbersome check if poke desc got filled in map_poke_run()
>>>> - move poke->ip renaming in bpf_jit_add_poke_descriptor() from patch 4
>>>>     to patch 3 to provide bisectability (Daniel)
>>>
>>> I did a basic test with Cilium on K8s with this set, spawning a few Pods
>>> and checking connectivity & whether we're not crashing since it has bit more
>>> elaborate tail call use. So far so good. I was inclined to push the series
>>> out, but there is one more issue I noticed and didn't notice earlier when
>>> reviewing, and that is overall stack size:
>>>
>>> What happens when you create a single program that has nested BPF to BPF
>>> calls e.g. either up to the maximum nesting or one call that is using up
>>> the max stack size which is then doing another BPF to BPF call that contains
>>> the tail call. In the tail call map, you have the same program in there.
>>> This means we create a worst case stack from BPF size of max_stack_size *
>>> max_tail_call_size, that is, 512*32. So that adds 16k worst case. For x86
>>> we have a stack of arch/x86/include/asm/page_64_types.h:
>>>
>>>    #define THREAD_SIZE_ORDER       (2 + KASAN_STACK_ORDER)
>>>   #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
>>>
>>> So we end up with 16k in a typical case. And this will cause kernel stack
>>> overflow; I'm at least not seeing where we handle this situation in the
> 
> Not quite. The subprog is always 32 byte stack (from safety pov).
> The real stack (when JITed) can be lower or zero.
> So the max stack is (512 - 32) * 32 = 15360.
> So there is no overflow, but may be a bit too close to comfort.

I did a check with adding `stack_not_used(current)` to various points which
provides some useful data under CONFIG_DEBUG_STACK_USAGE. From tc ingress side
I'm getting roughly 13k free stack space which is definitely less than 15k even
at tc layer. I also checked on sk_filter_trim_cap() on ingress and worst case I
saw is very close to 12k, so a malicious or by accident a buggy program would be
able to cause a stack overflow as-is.

> Imo the room is ok to land the set and the better enforcement can
> be done as a follow up later, like below idea...
> 
>>> set. Hm, need to think more, but maybe this needs tracking of max stack
>>> across tail calls to force an upper limit..
>>
>> My knee jerk reaction would be to decrement the allowed max tail calls,
>> but not sure if it's an option and if it would help.
> 
> How about make the verifier use a lower bound for a function with a tail call ?
> Something like 64 would work.
> subprog_info[idx].stack_depth with tail_call will be >= 64.
> Then the main function will be automatically limited to 512-64 and the worst
> case stack = 14kbyte.

Even 14k is way too close, see above. Some archs that are supported by the kernel
run under 8k total stack size. In the long run if more archs would support tail
calls with bpf-to-bpf calls, we might need a per-arch upper cap, but I think in
this context here an upper total cap on x86 that is 4k should be reasonable, it
sounds broken to me if more is indeed needed for the vast majority of use cases.

> When the sub prog with tail call is not an empty body (malicious stack
> abuser) then the lower bound won't affect anything.
> A bit annoying that stack_depth will be used by JIT to actually allocate
> that much. Some of it will not be used potentially, but I think it's fine.
> It's much simpler solution than to keep two variables to track stack size.
> Or may be check_max_stack_depth() can be a bit smarter and it can detect
> that subprog is using tail_call without actually hacking stack_depth variable.

+1, I think that would be better, maybe we could have a different cost function
for the tail call counter itself depending in which call-depth we are, but that
also requires two vars for tracking (tail call counter, call depth counter), so
more JIT changes & emitted insns required. :/ Otoh, what if tail call counter
is limited to 4k and we subtract stack usage instead with a min cost (e.g. 128)
if progs use less than that? Though the user experience will be really bad in
this case given these semantics feel less deterministic / hard to debug from
user PoV.

> Essentially I'm proposing to tweak this formula:
> depth += round_up(max_t(u32, subprog[idx].stack_depth, 1), 32);
> and replace 1 with 64 for subprogs with tail_call.
> 

