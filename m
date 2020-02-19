Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4A1164BDE
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 18:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgBSR02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 12:26:28 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:38913 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgBSR02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 12:26:28 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4T6o-0000pA-OG; Wed, 19 Feb 2020 18:26:03 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id BF7A5103A01; Wed, 19 Feb 2020 18:26:01 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC patch 04/19] bpf/tracing: Remove redundant preempt_disable() in __bpf_trace_run()
In-Reply-To: <20200219115415.57ee6d3c@gandalf.local.home>
References: <20200214133917.304937432@linutronix.de> <20200214161503.289763704@linutronix.de> <20200219115415.57ee6d3c@gandalf.local.home>
Date:   Wed, 19 Feb 2020 18:26:01 +0100
Message-ID: <87d0aapjyu.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Fri, 14 Feb 2020 14:39:21 +0100
> Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> __bpf_trace_run() disables preemption around the BPF_PROG_RUN() invocation.
>> 
>> This is redundant because __bpf_trace_run() is invoked from a trace point
>> via __DO_TRACE() which already disables preemption _before_ invoking any of
>> the functions which are attached to a trace point.
>> 
>> Remove it.
>> 
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  kernel/trace/bpf_trace.c |    2 --
>>  1 file changed, 2 deletions(-)
>> 
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -1476,9 +1476,7 @@ static __always_inline
>>  void __bpf_trace_run(struct bpf_prog *prog, u64 *args)
>>  {
>
> Should there be a "cant_migrate()" added here?

A cant_sleep() is the right thing to add as this really needs to stay
non-preemptible. Hmm?

>>  	rcu_read_lock();
>> -	preempt_disable();
>>  	(void) BPF_PROG_RUN(prog, args);
>> -	preempt_enable();
>>  	rcu_read_unlock();
>>  }

Thanks,

        tglx

