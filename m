Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4753615F67E
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 20:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388369AbgBNTLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 14:11:31 -0500
Received: from mail.efficios.com ([167.114.26.124]:39954 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387499AbgBNTLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 14:11:30 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 680A923BC4A;
        Fri, 14 Feb 2020 14:11:29 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id TcPM7Ry9pqIq; Fri, 14 Feb 2020 14:11:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id E37F523BC49;
        Fri, 14 Feb 2020 14:11:28 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com E37F523BC49
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1581707488;
        bh=BwocIdJ32MF6rN8SbWERs4qF83E6BOd6O3a5XNTTwUM=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=u4Y+SzgUEWqaBJAj+n5ulWl0tWeX+D6s/UV45wjSv90GM0IbqdrJGmjNO5KnxwAjI
         v47M0ItKq4/avXufSvae+2f2pyP+ZYWq/1JnmSwgOYRgTaLU9dT+IzVcKAW8rRodNA
         AEtR5pZQJzH9c7EZJzVm0LoygNNv21o9EfAn3UGRTOyB1zNGfs0wtqVhMQXEdJr4OL
         GrFJ7uStC48HDYYUSFCOMNfy9P3Cu80EhznAKiSMx5YbgewFtoZJ+QWH9SI40Jw1Op
         6c2HA0l7oaSpXyfNFhhDUAar48DZf/4tWw15PXTDnQ7wnrRR25OtFmXxRquSpW2m8G
         kJmq7Cr7LbMyg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ixSyBUEApmFR; Fri, 14 Feb 2020 14:11:28 -0500 (EST)
Received: from localhost (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 539DD23BB53;
        Fri, 14 Feb 2020 14:11:28 -0500 (EST)
Date:   Fri, 14 Feb 2020 14:11:26 -0500
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC patch 14/19] bpf: Use migrate_disable() in hashtab code
Message-ID: <20200214191126.lbiusetaxecdl3of@localhost>
References: <20200214133917.304937432@linutronix.de>
 <20200214161504.325142160@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214161504.325142160@linutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14-Feb-2020 02:39:31 PM, Thomas Gleixner wrote:
> The required protection is that the caller cannot be migrated to a
> different CPU as these places take either a hash bucket lock or might
> trigger a kprobe inside the memory allocator. Both scenarios can lead to
> deadlocks. The deadlock prevention is per CPU by incrementing a per CPU
> variable which temporarily blocks the invocation of BPF programs from perf
> and kprobes.
> 
> Replace the preempt_disable/enable() pairs with migrate_disable/enable()
> pairs to prepare BPF to work on PREEMPT_RT enabled kernels. On a non-RT
> kernel this maps to preempt_disable/enable(), i.e. no functional change.

Will that _really_ work on RT ?

I'm puzzled about what will happen in the following scenario on RT:

Thread A is preempted within e.g. htab_elem_free_rcu, and Thread B is
scheduled and runs through a bunch of tracepoints. Both are on the
same CPU's runqueue:

CPU 1

Thread A is scheduled
(Thread A) htab_elem_free_rcu()
(Thread A)   migrate disable
(Thread A)   __this_cpu_inc(bpf_prog_active); -> per-cpu variable for
                                               deadlock prevention.
Thread A is preempted
Thread B is scheduled
(Thread B) Runs through various tracepoints:
           trace_call_bpf()
           if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
               -> will skip any instrumentation that happens to be on
                  this CPU until...
Thread B is preempted
Thread A is scheduled
(Thread A)  __this_cpu_dec(bpf_prog_active);
(Thread A)  migrate enable

Having all those events randomly and silently discarded might be quite
unexpected from a user standpoint. This turns the deadlock prevention
mechanism into a random tracepoint-dropping facility, which is
unsettling. One alternative approach we could consider to solve this
is to make this deadlock prevention nesting counter per-thread rather
than per-cpu.

Also, I don't think using __this_cpu_inc() without preempt-disable or
irq off is safe. You'll probably want to move to this_cpu_inc/dec
instead, which can be heavier on some architectures.

Thanks,

Mathieu


> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/bpf/hashtab.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -698,11 +698,11 @@ static void htab_elem_free_rcu(struct rc
>  	 * we're calling kfree, otherwise deadlock is possible if kprobes
>  	 * are placed somewhere inside of slub
>  	 */
> -	preempt_disable();
> +	migrate_disable();
>  	__this_cpu_inc(bpf_prog_active);
>  	htab_elem_free(htab, l);
>  	__this_cpu_dec(bpf_prog_active);
> -	preempt_enable();
> +	migrate_enable();
>  }
>  
>  static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
> @@ -1327,7 +1327,7 @@ static int
>  	}
>  
>  again:
> -	preempt_disable();
> +	migrate_disable();
>  	this_cpu_inc(bpf_prog_active);
>  	rcu_read_lock();
>  again_nocopy:
> @@ -1347,7 +1347,7 @@ static int
>  		raw_spin_unlock_irqrestore(&b->lock, flags);
>  		rcu_read_unlock();
>  		this_cpu_dec(bpf_prog_active);
> -		preempt_enable();
> +		migrate_enable();
>  		goto after_loop;
>  	}
>  
> @@ -1356,7 +1356,7 @@ static int
>  		raw_spin_unlock_irqrestore(&b->lock, flags);
>  		rcu_read_unlock();
>  		this_cpu_dec(bpf_prog_active);
> -		preempt_enable();
> +		migrate_enable();
>  		kvfree(keys);
>  		kvfree(values);
>  		goto alloc;
> @@ -1406,7 +1406,7 @@ static int
>  
>  	rcu_read_unlock();
>  	this_cpu_dec(bpf_prog_active);
> -	preempt_enable();
> +	migrate_enable();
>  	if (bucket_cnt && (copy_to_user(ukeys + total * key_size, keys,
>  	    key_size * bucket_cnt) ||
>  	    copy_to_user(uvalues + total * value_size, values,
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
