Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6937F2A158
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404363AbfEXWhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:37:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:60076 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404233AbfEXWhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:37:41 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hUIok-0006XU-CG; Sat, 25 May 2019 00:37:38 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hUIok-000UbG-6I; Sat, 25 May 2019 00:37:38 +0200
Subject: Re: [PATCH bpf-next v5 1/3] bpf: implement bpf_send_signal() helper
To:     Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@fb.com>, Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20190523214745.854300-1-yhs@fb.com>
 <20190523214745.854355-1-yhs@fb.com>
 <54257f88-b088-2330-ba49-a78ce06d08bf@iogearbox.net>
 <fe5ed98c-0cc2-b126-25e6-84774c03bcb9@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <289e2279-8a88-8046-d4e0-c29cf79080a5@iogearbox.net>
Date:   Sat, 25 May 2019 00:37:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <fe5ed98c-0cc2-b126-25e6-84774c03bcb9@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25459/Fri May 24 09:59:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/25/2019 12:20 AM, Yonghong Song wrote:
> On 5/24/19 2:39 PM, Daniel Borkmann wrote:
>> On 05/23/2019 11:47 PM, Yonghong Song wrote:
>>> This patch tries to solve the following specific use case.
>>>
>>> Currently, bpf program can already collect stack traces
>>> through kernel function get_perf_callchain()
>>> when certain events happens (e.g., cache miss counter or
>>> cpu clock counter overflows). But such stack traces are
>>> not enough for jitted programs, e.g., hhvm (jited php).
>>> To get real stack trace, jit engine internal data structures
>>> need to be traversed in order to get the real user functions.
>>>
>>> bpf program itself may not be the best place to traverse
>>> the jit engine as the traversing logic could be complex and
>>> it is not a stable interface either.
>>>
>>> Instead, hhvm implements a signal handler,
>>> e.g. for SIGALARM, and a set of program locations which
>>> it can dump stack traces. When it receives a signal, it will
>>> dump the stack in next such program location.
>>>
>>> Such a mechanism can be implemented in the following way:
>>>    . a perf ring buffer is created between bpf program
>>>      and tracing app.
>>>    . once a particular event happens, bpf program writes
>>>      to the ring buffer and the tracing app gets notified.
>>>    . the tracing app sends a signal SIGALARM to the hhvm.
>>>
>>> But this method could have large delays and causing profiling
>>> results skewed.
>>>
>>> This patch implements bpf_send_signal() helper to send
>>> a signal to hhvm in real time, resulting in intended stack traces.
>>>
>>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>> ---
>>>   include/uapi/linux/bpf.h | 17 +++++++++-
>>>   kernel/trace/bpf_trace.c | 72 ++++++++++++++++++++++++++++++++++++++++
>>>   2 files changed, 88 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index 63e0cf66f01a..68d4470523a0 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -2672,6 +2672,20 @@ union bpf_attr {
>>>    *		0 on success.
>>>    *
>>>    *		**-ENOENT** if the bpf-local-storage cannot be found.
>>> + *
>>> + * int bpf_send_signal(u32 sig)
>>> + *	Description
>>> + *		Send signal *sig* to the current task.
>>> + *	Return
>>> + *		0 on success or successfully queued.
>>> + *
>>> + *		**-EBUSY** if work queue under nmi is full.
>>> + *
>>> + *		**-EINVAL** if *sig* is invalid.
>>> + *
>>> + *		**-EPERM** if no permission to send the *sig*.
>>> + *
>>> + *		**-EAGAIN** if bpf program can try again.
>>>    */
>>>   #define __BPF_FUNC_MAPPER(FN)		\
>>>   	FN(unspec),			\
>>> @@ -2782,7 +2796,8 @@ union bpf_attr {
>>>   	FN(strtol),			\
>>>   	FN(strtoul),			\
>>>   	FN(sk_storage_get),		\
>>> -	FN(sk_storage_delete),
>>> +	FN(sk_storage_delete),		\
>>> +	FN(send_signal),
>>>   
>>>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>>>    * function eBPF program intends to call
>>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>>> index f92d6ad5e080..70029eafc71f 100644
>>> --- a/kernel/trace/bpf_trace.c
>>> +++ b/kernel/trace/bpf_trace.c
>>> @@ -567,6 +567,63 @@ static const struct bpf_func_proto bpf_probe_read_str_proto = {
>>>   	.arg3_type	= ARG_ANYTHING,
>>>   };
>>>   
>>> +struct send_signal_irq_work {
>>> +	struct irq_work irq_work;
>>> +	struct task_struct *task;
>>> +	u32 sig;
>>> +};
>>> +
>>> +static DEFINE_PER_CPU(struct send_signal_irq_work, send_signal_work);
>>> +
>>> +static void do_bpf_send_signal(struct irq_work *entry)
>>> +{
>>> +	struct send_signal_irq_work *work;
>>> +
>>> +	work = container_of(entry, struct send_signal_irq_work, irq_work);
>>> +	group_send_sig_info(work->sig, SEND_SIG_PRIV, work->task, PIDTYPE_TGID);
>>> +}
>>> +
>>> +BPF_CALL_1(bpf_send_signal, u32, sig)
>>> +{
>>> +	struct send_signal_irq_work *work = NULL;
>>> +
>>> +	/* Similar to bpf_probe_write_user, task needs to be
>>> +	 * in a sound condition and kernel memory access be
>>> +	 * permitted in order to send signal to the current
>>> +	 * task.
>>> +	 */
>>> +	if (unlikely(current->flags & (PF_KTHREAD | PF_EXITING)))
>>> +		return -EPERM;
>>> +	if (unlikely(uaccess_kernel()))
>>> +		return -EPERM;
>>> +	if (unlikely(!nmi_uaccess_okay()))
>>> +		return -EPERM;
>>> +
>>> +	if (in_nmi()) {
>>> +		work = this_cpu_ptr(&send_signal_work);
>>> +		if (work->irq_work.flags & IRQ_WORK_BUSY)
>>
>> Given here and in stackmap are the only two users outside of kernel/irq_work.c,
>> it may probably be good to add a small helper to include/linux/irq_work.h and
>> use it for both.
>>
>> Perhaps something like ...
>>
>> static inline bool irq_work_busy(struct irq_work *work)
>> {
>> 	return READ_ONCE(work->flags) & IRQ_WORK_BUSY;
>> }
> 
> Not sure whether READ_ONCE is needed here or not.
> 
> The irq_work is per cpu data structure,
>    static DEFINE_PER_CPU(struct send_signal_irq_work, send_signal_work);
> so presumably no collision for work->flags memory reference.

The busy bit you're testing is cleared via cmpxchg(), kernel/irq_work.c +169:

cmpxchg(&work->flags, flags, flags & ~IRQ_WORK_BUSY);
