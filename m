Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8C2A15A
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404264AbfEXWid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:38:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:60186 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbfEXWic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:38:32 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hUIpa-0006b0-Jq; Sat, 25 May 2019 00:38:30 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hUIpa-00018C-CN; Sat, 25 May 2019 00:38:30 +0200
Subject: Re: [PATCH bpf-next v5 1/3] bpf: implement bpf_send_signal() helper
To:     Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@fb.com>, Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20190523214745.854300-1-yhs@fb.com>
 <20190523214745.854355-1-yhs@fb.com>
 <54257f88-b088-2330-ba49-a78ce06d08bf@iogearbox.net>
 <2f7fe79b-0e3f-2be3-aede-bd8eb369c91e@iogearbox.net>
 <816d5531-2a4c-3f73-040b-0c46d3961980@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <06c3da63-72ef-c37e-ba20-b82130df34bd@iogearbox.net>
Date:   Sat, 25 May 2019 00:38:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <816d5531-2a4c-3f73-040b-0c46d3961980@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25459/Fri May 24 09:59:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/25/2019 12:23 AM, Yonghong Song wrote:
> On 5/24/19 2:59 PM, Daniel Borkmann wrote:
>> On 05/24/2019 11:39 PM, Daniel Borkmann wrote:
>>> On 05/23/2019 11:47 PM, Yonghong Song wrote:
>>>> This patch tries to solve the following specific use case.
>>>>
>>>> Currently, bpf program can already collect stack traces
>>>> through kernel function get_perf_callchain()
>>>> when certain events happens (e.g., cache miss counter or
>>>> cpu clock counter overflows). But such stack traces are
>>>> not enough for jitted programs, e.g., hhvm (jited php).
>>>> To get real stack trace, jit engine internal data structures
>>>> need to be traversed in order to get the real user functions.
>>>>
>>>> bpf program itself may not be the best place to traverse
>>>> the jit engine as the traversing logic could be complex and
>>>> it is not a stable interface either.
>>>>
>>>> Instead, hhvm implements a signal handler,
>>>> e.g. for SIGALARM, and a set of program locations which
>>>> it can dump stack traces. When it receives a signal, it will
>>>> dump the stack in next such program location.
>>>>
>>>> Such a mechanism can be implemented in the following way:
>>>>    . a perf ring buffer is created between bpf program
>>>>      and tracing app.
>>>>    . once a particular event happens, bpf program writes
>>>>      to the ring buffer and the tracing app gets notified.
>>>>    . the tracing app sends a signal SIGALARM to the hhvm.
>>>>
>>>> But this method could have large delays and causing profiling
>>>> results skewed.
>>>>
>>>> This patch implements bpf_send_signal() helper to send
>>>> a signal to hhvm in real time, resulting in intended stack traces.
>>>>
>>>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>> ---
>>>>   include/uapi/linux/bpf.h | 17 +++++++++-
>>>>   kernel/trace/bpf_trace.c | 72 ++++++++++++++++++++++++++++++++++++++++
>>>>   2 files changed, 88 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>> index 63e0cf66f01a..68d4470523a0 100644
>>>> --- a/include/uapi/linux/bpf.h
>>>> +++ b/include/uapi/linux/bpf.h
>>>> @@ -2672,6 +2672,20 @@ union bpf_attr {
>>>>    *		0 on success.
>>>>    *
>>>>    *		**-ENOENT** if the bpf-local-storage cannot be found.
>>>> + *
>>>> + * int bpf_send_signal(u32 sig)
>>>> + *	Description
>>>> + *		Send signal *sig* to the current task.
>>>> + *	Return
>>>> + *		0 on success or successfully queued.
>>>> + *
>>>> + *		**-EBUSY** if work queue under nmi is full.
>>>> + *
>>>> + *		**-EINVAL** if *sig* is invalid.
>>>> + *
>>>> + *		**-EPERM** if no permission to send the *sig*.
>>>> + *
>>>> + *		**-EAGAIN** if bpf program can try again.
>>>>    */
>>>>   #define __BPF_FUNC_MAPPER(FN)		\
>>>>   	FN(unspec),			\
>>>> @@ -2782,7 +2796,8 @@ union bpf_attr {
>>>>   	FN(strtol),			\
>>>>   	FN(strtoul),			\
>>>>   	FN(sk_storage_get),		\
>>>> -	FN(sk_storage_delete),
>>>> +	FN(sk_storage_delete),		\
>>>> +	FN(send_signal),
>>>>   
>>>>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>>>>    * function eBPF program intends to call
>>>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>>>> index f92d6ad5e080..70029eafc71f 100644
>>>> --- a/kernel/trace/bpf_trace.c
>>>> +++ b/kernel/trace/bpf_trace.c
>>>> @@ -567,6 +567,63 @@ static const struct bpf_func_proto bpf_probe_read_str_proto = {
>>>>   	.arg3_type	= ARG_ANYTHING,
>>>>   };
>>>>   
>>>> +struct send_signal_irq_work {
>>>> +	struct irq_work irq_work;
>>>> +	struct task_struct *task;
>>>> +	u32 sig;
>>>> +};
>>>> +
>>>> +static DEFINE_PER_CPU(struct send_signal_irq_work, send_signal_work);
>>>> +
>>>> +static void do_bpf_send_signal(struct irq_work *entry)
>>>> +{
>>>> +	struct send_signal_irq_work *work;
>>>> +
>>>> +	work = container_of(entry, struct send_signal_irq_work, irq_work);
>>>> +	group_send_sig_info(work->sig, SEND_SIG_PRIV, work->task, PIDTYPE_TGID);
>>>> +}
>>>> +
>>>> +BPF_CALL_1(bpf_send_signal, u32, sig)
>>>> +{
>>>> +	struct send_signal_irq_work *work = NULL;
>>>> +
>>
>> Oh, and one more thing:
>>
>> 	if (!valid_signal(sig))
>> 		return -EINVAL;
>>
>> Otherwise when deferring the work, you don't have any such feedback.
> 
> Good advice! Do you want me send a followup patch or
> resend the whole series?

Lets do follow-up.
