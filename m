Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 586FD28D9C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 01:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388051AbfEWXIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 19:08:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:52402 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387705AbfEWXIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 19:08:19 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTwop-0000Ay-JG; Fri, 24 May 2019 01:08:15 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTwop-000Rbz-AK; Fri, 24 May 2019 01:08:15 +0200
Subject: Re: [PATCH bpf-next v2 1/3] bpf: implement bpf_send_signal() helper
To:     Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@fb.com>, Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20190522053900.1663459-1-yhs@fb.com>
 <20190522053900.1663537-1-yhs@fb.com>
 <2c07890b-9da5-b4e8-dc94-35def14470ad@iogearbox.net>
 <6041511a-1628-868f-b4b1-e567c234a4a5@fb.com>
 <d863ad02-5151-3e3c-a276-404c9dc957b2@iogearbox.net>
 <bc855846-450f-bc0f-34e3-7219c95fb620@fb.com>
 <86aacfb6-614b-55cb-7fe8-9f2c5c63c126@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5384a86c-94a4-f60f-2414-b8c68d152f57@iogearbox.net>
Date:   Fri, 24 May 2019 01:08:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <86aacfb6-614b-55cb-7fe8-9f2c5c63c126@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25458/Thu May 23 09:58:32 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/23/2019 11:30 PM, Yonghong Song wrote:
> On 5/23/19 2:07 PM, Yonghong Song wrote:
>> On 5/23/19 9:28 AM, Daniel Borkmann wrote:
>>> On 05/23/2019 05:58 PM, Yonghong Song wrote:
>>>> On 5/23/19 8:41 AM, Daniel Borkmann wrote:
>>>>> On 05/22/2019 07:39 AM, Yonghong Song wrote:
>>>>>> This patch tries to solve the following specific use case.
>>>>>>
>>>>>> Currently, bpf program can already collect stack traces
>>>>>> through kernel function get_perf_callchain()
>>>>>> when certain events happens (e.g., cache miss counter or
>>>>>> cpu clock counter overflows). But such stack traces are
>>>>>> not enough for jitted programs, e.g., hhvm (jited php).
>>>>>> To get real stack trace, jit engine internal data structures
>>>>>> need to be traversed in order to get the real user functions.
>>>>>>
>>>>>> bpf program itself may not be the best place to traverse
>>>>>> the jit engine as the traversing logic could be complex and
>>>>>> it is not a stable interface either.
>>>>>>
>>>>>> Instead, hhvm implements a signal handler,
>>>>>> e.g. for SIGALARM, and a set of program locations which
>>>>>> it can dump stack traces. When it receives a signal, it will
>>>>>> dump the stack in next such program location.
>>>>>>
>>>>>> Such a mechanism can be implemented in the following way:
>>>>>>      . a perf ring buffer is created between bpf program
>>>>>>        and tracing app.
>>>>>>      . once a particular event happens, bpf program writes
>>>>>>        to the ring buffer and the tracing app gets notified.
>>>>>>      . the tracing app sends a signal SIGALARM to the hhvm.
>>>>>>
>>>>>> But this method could have large delays and causing profiling
>>>>>> results skewed.
>>>>>>
>>>>>> This patch implements bpf_send_signal() helper to send
>>>>>> a signal to hhvm in real time, resulting in intended stack traces.
>>>>>>
>>>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>>>> ---
>>>>>>     include/uapi/linux/bpf.h | 17 +++++++++-
>>>>>>     kernel/trace/bpf_trace.c | 67 ++++++++++++++++++++++++++++++++++++++++
>>>>>>     2 files changed, 83 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>>>> index 63e0cf66f01a..68d4470523a0 100644
>>>>>> --- a/include/uapi/linux/bpf.h
>>>>>> +++ b/include/uapi/linux/bpf.h
>>>>>> @@ -2672,6 +2672,20 @@ union bpf_attr {
>>>>>>      *		0 on success.
>>>>>>      *
>>>>>>      *		**-ENOENT** if the bpf-local-storage cannot be found.
>>>>>> + *
>>>>>> + * int bpf_send_signal(u32 sig)
>>>>>> + *	Description
>>>>>> + *		Send signal *sig* to the current task.
>>>>>> + *	Return
>>>>>> + *		0 on success or successfully queued.
>>>>>> + *
>>>>>> + *		**-EBUSY** if work queue under nmi is full.
>>>>>> + *
>>>>>> + *		**-EINVAL** if *sig* is invalid.
>>>>>> + *
>>>>>> + *		**-EPERM** if no permission to send the *sig*.
>>>>>> + *
>>>>>> + *		**-EAGAIN** if bpf program can try again.
>>>>>>      */
>>>>>>     #define __BPF_FUNC_MAPPER(FN)		\
>>>>>>     	FN(unspec),			\
>>>>>> @@ -2782,7 +2796,8 @@ union bpf_attr {
>>>>>>     	FN(strtol),			\
>>>>>>     	FN(strtoul),			\
>>>>>>     	FN(sk_storage_get),		\
>>>>>> -	FN(sk_storage_delete),
>>>>>> +	FN(sk_storage_delete),		\
>>>>>> +	FN(send_signal),
>>>>>>     
>>>>>>     /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>>>>>>      * function eBPF program intends to call
>>>>>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>>>>>> index f92d6ad5e080..f8cd0db7289f 100644
>>>>>> --- a/kernel/trace/bpf_trace.c
>>>>>> +++ b/kernel/trace/bpf_trace.c
>>>>>> @@ -567,6 +567,58 @@ static const struct bpf_func_proto bpf_probe_read_str_proto = {
>>>>>>     	.arg3_type	= ARG_ANYTHING,
>>>>>>     };
>>>>>>     
>>>>>> +struct send_signal_irq_work {
>>>>>> +	struct irq_work irq_work;
>>>>>> +	u32 sig;
>>>>>> +};
>>>>>> +
>>>>>> +static DEFINE_PER_CPU(struct send_signal_irq_work, send_signal_work);
>>>>>> +
>>>>>> +static void do_bpf_send_signal(struct irq_work *entry)
>>>>>> +{
>>>>>> +	struct send_signal_irq_work *work;
>>>>>> +
>>>>>> +	work = container_of(entry, struct send_signal_irq_work, irq_work);
>>>>>> +	group_send_sig_info(work->sig, SEND_SIG_PRIV, current, PIDTYPE_TGID);
>>>>>> +}
>>>>>> +
>>>>>> +BPF_CALL_1(bpf_send_signal, u32, sig)
>>>>>> +{
>>>>>> +	struct send_signal_irq_work *work = NULL;
>>>>>> +
>>>>>> +	/* Similar to bpf_probe_write_user, task needs to be
>>>>>> +	 * in a sound condition and kernel memory access be
>>>>>> +	 * permitted in order to send signal to the current
>>>>>> +	 * task.
>>>>>> +	 */
>>>>>> +	if (unlikely(current->flags & (PF_KTHREAD | PF_EXITING)))
>>>>>> +		return -EPERM;
>>>>>> +	if (unlikely(uaccess_kernel()))
>>>>>> +		return -EPERM;
>>>>>> +	if (unlikely(!nmi_uaccess_okay()))
>>>>>> +		return -EPERM;
>>>>>> +
>>>>>> +	if (in_nmi()) {
>>>>>
>>>>> Hm, bit confused, can't this only be done out of process context in
>>>>> general since only there current points to e.g. hhvm? I'm probably
>>>>> missing something. Could you elaborate?
>>>>
>>>> That is true. If in nmi, it is out of process context and in nmi
>>>> context, we use an irq_work here since group_send_sig_info() has
>>>> spinlock inside. The bpf program (e.g., a perf_event program) needs to
>>>> check it is with right current (e.g., by pid) before calling
>>>> this helper.
>>>>
>>>> Does this address your question?
>>
>> Thanks, Daniel. The below are really good questions which I did not
>> really think through with irq_work.
>>
>>> Hm, but how is it guaranteed that 'current' inside the callback is still
>>> the very same you intend to send the signal to?
>>
>> I went through irq_work infrastructure. It looks that "current" may
>> change. irq_work is registered as an interrupt on x86.
>> After nmi, some lower priority
>> interrupts get chances to execute including irq_work. But there are some
>> other interrupts like timer_interrupt and reschedule_interrupt may
>> change "current". But since we are still in interrupt context, task
>> should not be destroyed, so the task structure pointer is still valid.
>>
>> I will pass "current" task struct pointer to irq_work as well. This
>> is similar to what we did in stackmap.c:
>>     work->sem = &current->mm->mmap_sem;
>>     irq_work_queue(&work->irq_work);
>> At irq_work_run() time, the previous "current" in nmi should still be
>> valid.
>>
>>> What happens if you're in softirq and send SIGKILL to yourself? Is this
>>> ignored/handled gracefully in such case?
>>
>> It is not ignored. It handled gracefully in this case. I tried my
>> example to send SIGKILL. The call stack looks below.
>>
>> [   24.211943]  bpf_send_signal+0x9/0xb0
>> [   24.212427]  bpf_prog_fec6e7cc664d5b91_bpf_send_signal_test+0x228/0x1000
>> [   24.213249]  ? bpf_overflow_handler+0xb7/0x180
>> [   24.213853]  ? __perf_event_overflow+0x51/0xe0
>> [   24.214385]  ? perf_swevent_hrtimer+0x10a/0x160
>> [   24.214965]  ? __update_load_avg_cfs_rq+0x1a9/0x1c0
>> [   24.215609]  ? task_tick_fair+0x50/0x690
>> [   24.216104]  ? run_timer_softirq+0x208/0x490
>> [   24.216637]  ? timerqueue_del+0x1e/0x40
>> [   24.217111]  ? task_clock_event_del+0x10/0x10
>> [   24.217658]  ? __hrtimer_run_queues+0x10d/0x2c0
>> [   24.218217]  ? hrtimer_interrupt+0x122/0x270
>> [   24.218765]  ? rcu_irq_enter+0x31/0x110
>> [   24.219223]  ? smp_apic_timer_interrupt+0x67/0x160
>> [   24.219842]  ? apic_timer_interrupt+0xf/0x20
>> [   24.220383]  </IRQ>
>> [   24.220655]  ? event_sched_out.isra.108+0x150/0x150
>> [   24.221271]  ? smp_call_function_single+0xdc/0x100
>> [   24.221898]  ? perf_event_sysfs_show+0x20/0x20
>> [   24.222469]  ? cpu_function_call+0x42/0x60
>> [   24.222982]  ? cpu_clock_event_read+0x10/0x10
>> [   24.223525]  ? event_function_call+0xe6/0xf0
>> [   24.224053]  ? event_sched_out.isra.108+0x150/0x150
>> [   24.224657]  ? perf_remove_from_context+0x20/0x70
>> [   24.225262]  ? perf_event_release_kernel+0x106/0x2e0
>> [   24.225896]  ? perf_release+0xc/0x10
>> [   24.226347]  ? __fput+0xc9/0x230
>> [   24.226767]  ? task_work_run+0x83/0xb0
>> [   24.227243]  ? do_exit+0x300/0xc50
>> [   24.227674]  ? syscall_trace_enter+0x1c9/0x2d0
>> [   24.228223]  ? do_group_exit+0x39/0xb0
>> [   24.228695]  ? __x64_sys_exit_group+0x14/0x20
>> [   24.229270]  ? do_syscall_64+0x49/0x130
>> [   24.229762]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> I see the task is killed and other process is not impacted and
>> no kernel crash/warning.

Hm, but I rather meant when you have the case that we're in_serving_softirq()
e.g. when processing packets on rx and you send a signal to yourself. Shouldn't
we bail out from the helper in such situation as well?

Thanks,
Daniel
