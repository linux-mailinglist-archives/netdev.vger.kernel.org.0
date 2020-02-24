Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB1A16B115
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 21:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgBXUn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 15:43:28 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51048 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgBXUn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 15:43:28 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6KZ3-0005g7-1V; Mon, 24 Feb 2020 21:42:53 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 36301104088; Mon, 24 Feb 2020 21:42:52 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [patch V3 06/22] bpf/trace: Remove redundant preempt_disable from trace_call_bpf()
In-Reply-To: <20200224194017.rtwjcgjxnmltisfe@ast-mbp>
References: <20200224140131.461979697@linutronix.de> <20200224145643.059995527@linutronix.de> <20200224194017.rtwjcgjxnmltisfe@ast-mbp>
Date:   Mon, 24 Feb 2020 21:42:52 +0100
Message-ID: <875zfvk983.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> On Mon, Feb 24, 2020 at 03:01:37PM +0100, Thomas Gleixner wrote:
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -83,7 +83,7 @@ unsigned int trace_call_bpf(struct trace
>>  	if (in_nmi()) /* not supported yet */
>>  		return 1;
>>  
>> -	preempt_disable();
>> +	cant_sleep();
>>  
>>  	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
>>  		/*
>> @@ -115,7 +115,6 @@ unsigned int trace_call_bpf(struct trace
>>  
>>   out:
>>  	__this_cpu_dec(bpf_prog_active);
>> -	preempt_enable();
>
> My testing uncovered that above was too aggressive:
> [   41.533438] BUG: assuming atomic context at kernel/trace/bpf_trace.c:86
> [   41.534265] in_atomic(): 0, irqs_disabled(): 0, pid: 2348, name: test_progs
> [   41.536907] Call Trace:
> [   41.537167]  dump_stack+0x75/0xa0
> [   41.537546]  __cant_sleep.cold.105+0x8b/0xa3
> [   41.538018]  ? exit_to_usermode_loop+0x77/0x140
> [   41.538493]  trace_call_bpf+0x4e/0x2e0
> [   41.538908]  __uprobe_perf_func.isra.15+0x38f/0x690
> [   41.539399]  ? probes_profile_seq_show+0x220/0x220
> [   41.539962]  ? __mutex_lock_slowpath+0x10/0x10
> [   41.540412]  uprobe_dispatcher+0x5de/0x8f0
> [   41.540875]  ? uretprobe_dispatcher+0x7c0/0x7c0
> [   41.541404]  ? down_read_killable+0x200/0x200
> [   41.541852]  ? __kasan_kmalloc.constprop.6+0xc1/0xd0
> [   41.542356]  uprobe_notify_resume+0xacf/0x1d60

Duh. I missed that particular callchain.

> The following fixes it:
>
> commit 7b7b71ff43cc0b15567b60c38a951c8a2cbc97f0 (HEAD -> bpf-next)
> Author: Alexei Starovoitov <ast@kernel.org>
> Date:   Mon Feb 24 11:27:15 2020 -0800
>
>     bpf: disable migration for bpf progs attached to uprobe
>
>     trace_call_bpf() no longer disables preemption on its own.
>     All callers of this function has to do it explicitly.
>
>     Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 18d16f3ef980..7581f5eb6091 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -1333,8 +1333,15 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
>         int size, esize;
>         int rctx;
>
> -       if (bpf_prog_array_valid(call) && !trace_call_bpf(call, regs))
> -               return;
> +       if (bpf_prog_array_valid(call)) {
> +               u32 ret;
> +
> +               migrate_disable();
> +               ret = trace_call_bpf(call, regs);
> +               migrate_enable();
> +               if (!ret)
> +                       return;
> +       }
>
> But looking at your patch cant_sleep() seems unnecessary strong.
> Should it be cant_migrate() instead?

Yes, if we go with the migrate_disable(). OTOH, having a
preempt_disable() in that uprobe callsite should work as well, then we
can keep the cant_sleep() check which covers all other callsites
properly. No strong opinion though.

> And two calls to __this_cpu*() replaced with this_cpu*() ?

See above.

> If you can ack it I can fix it up in place and apply the whole thing.

Ack.

Thanks,

     tglx
