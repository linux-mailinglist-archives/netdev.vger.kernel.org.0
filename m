Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94576164B1C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 17:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgBSQyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 11:54:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgBSQyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 11:54:19 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 828E42465D;
        Wed, 19 Feb 2020 16:54:17 +0000 (UTC)
Date:   Wed, 19 Feb 2020 11:54:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC patch 04/19] bpf/tracing: Remove redundant
 preempt_disable() in __bpf_trace_run()
Message-ID: <20200219115415.57ee6d3c@gandalf.local.home>
In-Reply-To: <20200214161503.289763704@linutronix.de>
References: <20200214133917.304937432@linutronix.de>
        <20200214161503.289763704@linutronix.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Feb 2020 14:39:21 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> __bpf_trace_run() disables preemption around the BPF_PROG_RUN() invocation.
> 
> This is redundant because __bpf_trace_run() is invoked from a trace point
> via __DO_TRACE() which already disables preemption _before_ invoking any of
> the functions which are attached to a trace point.
> 
> Remove it.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/trace/bpf_trace.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1476,9 +1476,7 @@ static __always_inline
>  void __bpf_trace_run(struct bpf_prog *prog, u64 *args)
>  {

Should there be a "cant_migrate()" added here?

-- Steve

>  	rcu_read_lock();
> -	preempt_disable();
>  	(void) BPF_PROG_RUN(prog, args);
> -	preempt_enable();
>  	rcu_read_unlock();
>  }
>  

