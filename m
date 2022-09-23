Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6AB5E81FD
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 20:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbiIWSsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 14:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiIWSsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 14:48:14 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD3E120592;
        Fri, 23 Sep 2022 11:48:12 -0700 (PDT)
Message-ID: <5833ca7d-2fcf-9dc5-2370-952f96583a75@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663958890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qkgy8iRU09OQfHLs7XM/U2jAwwvUsH4xPM9G7sV/f/E=;
        b=H32BkaMrDZJamZ/QD6cz1Jxxk2bDHcAfaIcO++C2prGI4qQra9dM0+zvdK8vZK13Kd1FwQ
        Xhdm31KtWsuBK6uq9qJ7wxrq9A/BkVz7QAjiAcyj+h89i4l9K45Ab/TMhzP9UG2T8xCvWx
        ACx61uUOaywYzPCVR2jsCZFSLE9aTQo=
Date:   Fri, 23 Sep 2022 11:48:07 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 4/5] bpf: Stop bpf_setsockopt(TCP_CONGESTION) in
 init ops to recur itself
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
References: <20220922225616.3054840-1-kafai@fb.com>
 <20220922225642.3058176-1-kafai@fb.com>
 <CAADnVQK4fVZ0KdWkV7MfP_F3As7cme46SoR30YU0bk0zAfpOrA@mail.gmail.com>
 <99e23c92-b1dc-db45-73f7-c210eb1debc8@linux.dev>
 <CAADnVQKFdpiQFxgF253V5XmtjnrVXcZ14sxT_Q3vOQ97WxScMQ@mail.gmail.com>
 <27c7725a-738a-2227-5e47-ab2afab29348@linux.dev>
 <CAEf4BzZu8yHdVGGGDFKH4gZJw7NWuYcsYSY-vTOgNw3m=d5N7w@mail.gmail.com>
 <CAEf4BzYfR9SOEqMC8rv7uHZctt51fKXJr0FuoV-DMK-_qbZdJA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAEf4BzYfR9SOEqMC8rv7uHZctt51fKXJr0FuoV-DMK-_qbZdJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/22 11:30 AM, Andrii Nakryiko wrote:
> On Fri, Sep 23, 2022 at 11:27 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
>>
>> On Fri, Sep 23, 2022 at 10:46 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>>
>>> On 9/23/22 8:26 AM, Alexei Starovoitov wrote:
>>>> On Thu, Sep 22, 2022 at 6:11 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>>>>
>>>>> On 9/22/22 5:12 PM, Alexei Starovoitov wrote:
>>>>>> On Thu, Sep 22, 2022 at 3:56 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>>>>>>
>>>>>>> From: Martin KaFai Lau <martin.lau@kernel.org>
>>>>>>>
>>>>>>> When a bad bpf prog '.init' calls
>>>>>>> bpf_setsockopt(TCP_CONGESTION, "itself"), it will trigger this loop:
>>>>>>>
>>>>>>> .init => bpf_setsockopt(tcp_cc) => .init => bpf_setsockopt(tcp_cc) ...
>>>>>>> ... => .init => bpf_setsockopt(tcp_cc).
>>>>>>>
>>>>>>> It was prevented by the prog->active counter before but the prog->active
>>>>>>> detection cannot be used in struct_ops as explained in the earlier
>>>>>>> patch of the set.
>>>>>>>
>>>>>>> In this patch, the second bpf_setsockopt(tcp_cc) is not allowed
>>>>>>> in order to break the loop.  This is done by checking the
>>>>>>> previous bpf_run_ctx has saved the same sk pointer in the
>>>>>>> bpf_cookie.
>>>>>>>
>>>>>>> Note that this essentially limits only the first '.init' can
>>>>>>> call bpf_setsockopt(TCP_CONGESTION) to pick a fallback cc (eg. peer
>>>>>>> does not support ECN) and the second '.init' cannot fallback to
>>>>>>> another cc.  This applies even the second
>>>>>>> bpf_setsockopt(TCP_CONGESTION) will not cause a loop.
>>>>>>>
>>>>>>> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
>>>>>>> ---
>>>>>>>     include/linux/filter.h |  3 +++
>>>>>>>     net/core/filter.c      |  4 ++--
>>>>>>>     net/ipv4/bpf_tcp_ca.c  | 54 ++++++++++++++++++++++++++++++++++++++++++
>>>>>>>     3 files changed, 59 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>>>>>>> index 98e28126c24b..9942ecc68a45 100644
>>>>>>> --- a/include/linux/filter.h
>>>>>>> +++ b/include/linux/filter.h
>>>>>>> @@ -911,6 +911,9 @@ int sk_get_filter(struct sock *sk, sockptr_t optval, unsigned int len);
>>>>>>>     bool sk_filter_charge(struct sock *sk, struct sk_filter *fp);
>>>>>>>     void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp);
>>>>>>>
>>>>>>> +int _bpf_setsockopt(struct sock *sk, int level, int optname,
>>>>>>> +                   char *optval, int optlen);
>>>>>>> +
>>>>>>>     u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
>>>>>>>     #define __bpf_call_base_args \
>>>>>>>            ((u64 (*)(u64, u64, u64, u64, u64, const struct bpf_insn *)) \
>>>>>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>>>>>> index f4cea3ff994a..e56a1ebcf1bc 100644
>>>>>>> --- a/net/core/filter.c
>>>>>>> +++ b/net/core/filter.c
>>>>>>> @@ -5244,8 +5244,8 @@ static int __bpf_setsockopt(struct sock *sk, int level, int optname,
>>>>>>>            return -EINVAL;
>>>>>>>     }
>>>>>>>
>>>>>>> -static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>>>>>>> -                          char *optval, int optlen)
>>>>>>> +int _bpf_setsockopt(struct sock *sk, int level, int optname,
>>>>>>> +                   char *optval, int optlen)
>>>>>>>     {
>>>>>>>            if (sk_fullsock(sk))
>>>>>>>                    sock_owned_by_me(sk);
>>>>>>> diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
>>>>>>> index 6da16ae6a962..a9f2cab5ffbc 100644
>>>>>>> --- a/net/ipv4/bpf_tcp_ca.c
>>>>>>> +++ b/net/ipv4/bpf_tcp_ca.c
>>>>>>> @@ -144,6 +144,57 @@ static const struct bpf_func_proto bpf_tcp_send_ack_proto = {
>>>>>>>            .arg2_type      = ARG_ANYTHING,
>>>>>>>     };
>>>>>>>
>>>>>>> +BPF_CALL_5(bpf_init_ops_setsockopt, struct sock *, sk, int, level,
>>>>>>> +          int, optname, char *, optval, int, optlen)
>>>>>>> +{
>>>>>>> +       struct bpf_tramp_run_ctx *run_ctx, *saved_run_ctx;
>>>>>>> +       int ret;
>>>>>>> +
>>>>>>> +       if (optname != TCP_CONGESTION)
>>>>>>> +               return _bpf_setsockopt(sk, level, optname, optval, optlen);
>>>>>>> +
>>>>>>> +       run_ctx = (struct bpf_tramp_run_ctx *)current->bpf_ctx;
>>>>>>> +       if (unlikely(run_ctx->saved_run_ctx &&
>>>>>>> +                    run_ctx->saved_run_ctx->type == BPF_RUN_CTX_TYPE_STRUCT_OPS)) {
>>>>>>> +               saved_run_ctx = (struct bpf_tramp_run_ctx *)run_ctx->saved_run_ctx;
>>>>>>> +               /* It stops this looping
>>>>>>> +                *
>>>>>>> +                * .init => bpf_setsockopt(tcp_cc) => .init =>
>>>>>>> +                * bpf_setsockopt(tcp_cc)" => .init => ....
>>>>>>> +                *
>>>>>>> +                * The second bpf_setsockopt(tcp_cc) is not allowed
>>>>>>> +                * in order to break the loop when both .init
>>>>>>> +                * are the same bpf prog.
>>>>>>> +                *
>>>>>>> +                * This applies even the second bpf_setsockopt(tcp_cc)
>>>>>>> +                * does not cause a loop.  This limits only the first
>>>>>>> +                * '.init' can call bpf_setsockopt(TCP_CONGESTION) to
>>>>>>> +                * pick a fallback cc (eg. peer does not support ECN)
>>>>>>> +                * and the second '.init' cannot fallback to
>>>>>>> +                * another cc.
>>>>>>> +                */
>>>>>>> +               if (saved_run_ctx->bpf_cookie == (uintptr_t)sk)
>>>>>>> +                       return -EBUSY;
>>>>>>> +       }
>>>>>>> +
>>>>>>> +       run_ctx->bpf_cookie = (uintptr_t)sk;
>>>>>>> +       ret = _bpf_setsockopt(sk, level, optname, optval, optlen);
>>>>>>> +       run_ctx->bpf_cookie = 0;
>>>>>>
>>>>>> Instead of adding 4 bytes for enum in patch 3
>>>>>> (which will be 8 bytes due to alignment)
>>>>>> and abusing bpf_cookie here
>>>>>> (which struct_ops bpf prog might eventually read and be surprised
>>>>>> to find sk pointer in there)
>>>>>> how about adding 'struct task_struct *saved_current' as another arg
>>>>>> to bpf_tramp_run_ctx ?
>>>>>> Always store the current task in there in prog_entry_struct_ops
>>>>>> and then compare it here in this specialized bpf_init_ops_setsockopt?
>>>>>>
>>>>>> Or maybe always check in enter_prog_struct_ops:
>>>>>> if (container_of(current->bpf_ctx, struct bpf_tramp_run_ctx,
>>>>>> run_ctx)->saved_current == current) // goto out since recursion?
>>>>>> it will prevent issues in case we don't know about and will
>>>>>> address the good recursion case as explained in patch 1?
>>>>>> I'm assuming 2nd ssthresh runs in a different task..
>>>>>> Or is it actually the same task?
>>>>>
>>>>> The 2nd ssthresh() should run in the same task but different sk.  The
>>>>> first ssthresh(sk[1]) was run in_task() context and then got
>>>>> interrupted.  The softirq then handles the rcv path which just happens
>>>>> to also call ssthresh(sk[2]) in the unlikely pkt-loss case. It is like
>>>>> ssthresh(sk[1]) => softirq => ssthresh(sk[2]).
>>>>>
>>>>> The tcp-cc ops can recur but cannot recur on the same sk because it
>>>>> requires to hold the sk lock, so the patch remembers what was the
>>>>> previous sk to ensure it does not recur on the same sk.  Then it needs
>>>>> to peek into the previous run ctx which may not always be
>>>>> bpf_trump_run_ctx.  eg. a cg bpf prog (with bpf_cg_run_ctx) can call
>>>>> bpf_setsockopt(TCP_CONGESTION, "a_bpf_tcp_cc") which then will call the
>>>>> a_bpf_tcp_cc->init().  It needs a bpf_run_ctx_type so it can safely peek
>>>>> the previous bpf_run_ctx.
>>>>
>>>> got it.
>>>>
>>>>>
>>>>> Since struct_ops is the only one that needs to peek into the previous
>>>>> run_ctx (through tramp_run_ctx->saved_run_ctx),  instead of adding 4
>>>>> bytes to the bpf_run_ctx, one idea just came to my mind is to use one
>>>>> bit in the tramp_run_ctx->saved_run_ctx pointer itsef.  Something like
>>>>> this if it reuses the bpf_cookie (probably missed some int/ptr type
>>>>> casting):
>>>>>
>>>>> #define BPF_RUN_CTX_STRUCT_OPS_BIT 1UL
>>>>>
>>>>> u64 notrace __bpf_prog_enter_struct_ops(struct bpf_prog *prog,
>>>>>                                        struct bpf_tramp_run_ctx *run_ctx)
>>>>>            __acquires(RCU)
>>>>> {
>>>>>           rcu_read_lock();
>>>>>           migrate_disable();
>>>>>
>>>>>           run_ctx->saved_run_ctx = bpf_set_run_ctx((&run_ctx->run_ctx) |
>>>>>                                           BPF_RUN_CTX_STRUCT_OPS_BIT);
>>>>>
>>>>>            return bpf_prog_start_time();
>>>>> }
>>>>>
>>>>> BPF_CALL_5(bpf_init_ops_setsockopt, struct sock *, sk, int, level,
>>>>>               int, optname, char *, optval, int, optlen)
>>>>> {
>>>>>           /* ... */
>>>>>           if (unlikely((run_ctx->saved_run_ctx &
>>>>>                           BPF_RUN_CTX_STRUCT_OPS_BIT) && ...) {
>>>>>                   /* ... */
>>>>>                   if (bpf_cookie == (uintptr_t)sk)
>>>>>                           return -EBUSY;
>>>>>           }
>>>>>
>>>>> }
>>>>
>>>> that should work, but don't you need to loop through all previous
>>>> run_ctx and check all with BPF_RUN_CTX_STRUCT_OPS_BIT type ?
>>>> Since run_ctx is saved in the task and we have preemptible
>>>> rpgos there could be tracing prog in the chain:
>>>> struct_ops_run_ctx->tracing_run_ctx->struct_ops_run_ctx
>>>> where 1st and last have the same 'sk'.
>>>
>>>
>>> This interleave of different run_ctx could happen.  My understanding is
>>> the 'struct_ops_run_ctx' can only be created when the tcp stack is
>>> calling the 'bpf_tcp_cc->init()' (or other cc ops).  In the above case,
>>> the first and second struct_ops_run_ctx are interleaved with a
>>> tracing_run_ctx.  Each of these two struct_ops_run_ctx was created from
>>> a different 'bpf_tcp_cc->init()' call by the kernel tcp stack.  They
>>> cannot be called with the same sk and changing that sk at the same time
>>> like this.  Otherwise, the kernel stack has a bug.
>>
>> There could be also kprobe context in the chain, not necessarily
>> trampoline-based context. You want to look at previous struct_ops
>> run_ctx (if any), but it's not necessarily run_ctx->saved_run_ctx. It
>> could be one of the still earlier ones in the chain. And given kprobe
>> run_ctx doesn't have saved_run_ctx field and don't preserve the chain
>> of run_ctxs, there is no reliable way to check entire chain of
>> run_ctxs.
>>
>> BPF_RUN_CTX_STRUCT_OPS_BIT is a bit dangerous if we ever do a similar
>> bit trick for some other type of run_ctx (which honestly we should
>> avoid). Enum would be safer, but still, you need to check the entire
>> chain of run_ctxs, which we do not preserve.

There is no need to check the entire chain.  Only the immediate previous 
one is needed.  If the previous one is a kprobe, it is fine since there 
is no loop.  If there is an even earlier run ctx that is a 
bpf_struct_ops_run_ctx, then it must be on a different sk.

>>
>> It seems to me that run_ctx is not the right mechanism to use here,
>> tbh. Are there any other alternatives?
> 
> E.g., we can't have more than one struct_ops program attached to any
> given socket, right? So can we just use one bit on struct sock to mark
> "it is being processed by struct_ops.init program" and just check
> that?

It was one of my eariler thought.  I went with this route to use the 
existing run context instead of getting a hole or bit from tcp_sock to 
handle this corner case.
