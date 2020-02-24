Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440C516B060
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgBXTkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 14:40:25 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46683 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBXTkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 14:40:24 -0500
Received: by mail-pg1-f194.google.com with SMTP id y30so5630707pga.13;
        Mon, 24 Feb 2020 11:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=scSwL+/ed755uFJ90j5w37fp1jhFdhEzmUIhsR9VTAA=;
        b=L1po6j4D2H92/hvRNB11HbAiY3p65YpajFhZyxuGdxVo5LmdthkVftmbEuFuNr2eOd
         /qeH7F5Sdd4lzzTIwY0Qm1orxwZYM/2VYZEmrBgSbWyybZGjDTVVmtRetD1r1dYY9Lnz
         VxBM7ZgNqfLXpuIr1ne9lX2Of44YfXAcGIAppUrf+PO/cmYH9A23xpCIn4SQEhRhvU3U
         D1LciOrVN3MF0P7WIeTD+Uq+In2Rtt2NJMTURx9eSX3NpmArN9EnOJ1LSlCIaG3Hc3Tp
         TwRtD2ktz0obLOPl9rAsgP0RVXoZ8fO8GZrQBdkwliHs0T9Ar3tw0y0mqVrrTvH2KyCq
         8GyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=scSwL+/ed755uFJ90j5w37fp1jhFdhEzmUIhsR9VTAA=;
        b=gWnLTRvbAX/d/KkvWl17s+6NqPhmi17zk65tQKWRBqari1c6gVyGn/d4SmV8rWol+O
         bUjVJy4IaSvAHZWIgwSamqM7inlDA19JVYVVKU2LZ36Dc4Q24RJ0z/CuJVzTb/9VRXQe
         dbFcDblIGJeV82eyZOjE3/IKodOXwYar7zGSwd2gY9jY8U2281t7fm7FdlPGA+D+IFmm
         dWvIZAE6NIZv8nuTC0LR2lt65wghSiCBkxwttBebDWhNogCF2EPVkL/fry0u1yiIsyq+
         +H/1IvA866SnZcNr64odP8r1EtpQ1S2Vl+FhHs1H8IIVZeSV5uPPu2xGR8KX3eWqfLF3
         lTZQ==
X-Gm-Message-State: APjAAAVNYBgVSW875kyzEjpMcOmiPZqkTL3BBebvAo6gsy7VKJCr8BTW
        wzhn/ssK8TvcwIE7xA56phQ=
X-Google-Smtp-Source: APXvYqx7VayPo9fzLuogwXiuuGdtCzqJw9WAlW/sl/zsATRzG3Aw0hYmTpG2ua/khpWVbjOkDYWeSQ==
X-Received: by 2002:a63:cc09:: with SMTP id x9mr34807474pgf.339.1582573223430;
        Mon, 24 Feb 2020 11:40:23 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::6:2457])
        by smtp.gmail.com with ESMTPSA id w14sm13704058pgi.22.2020.02.24.11.40.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Feb 2020 11:40:22 -0800 (PST)
Date:   Mon, 24 Feb 2020 11:40:20 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [patch V3 06/22] bpf/trace: Remove redundant preempt_disable
 from trace_call_bpf()
Message-ID: <20200224194017.rtwjcgjxnmltisfe@ast-mbp>
References: <20200224140131.461979697@linutronix.de>
 <20200224145643.059995527@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224145643.059995527@linutronix.de>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 03:01:37PM +0100, Thomas Gleixner wrote:
> Similar to __bpf_trace_run this is redundant because __bpf_trace_run() is
> invoked from a trace point via __DO_TRACE() which already disables
> preemption _before_ invoking any of the functions which are attached to a
> trace point.
> 
> Remove it and add a cant_sleep() check.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> V3: New patch. Replaces the previous one which converted this to migrate_disable() 
> ---
>  kernel/trace/bpf_trace.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -83,7 +83,7 @@ unsigned int trace_call_bpf(struct trace
>  	if (in_nmi()) /* not supported yet */
>  		return 1;
>  
> -	preempt_disable();
> +	cant_sleep();
>  
>  	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
>  		/*
> @@ -115,7 +115,6 @@ unsigned int trace_call_bpf(struct trace
>  
>   out:
>  	__this_cpu_dec(bpf_prog_active);
> -	preempt_enable();

My testing uncovered that above was too aggressive:
[   41.533438] BUG: assuming atomic context at kernel/trace/bpf_trace.c:86
[   41.534265] in_atomic(): 0, irqs_disabled(): 0, pid: 2348, name: test_progs
[   41.536907] Call Trace:
[   41.537167]  dump_stack+0x75/0xa0
[   41.537546]  __cant_sleep.cold.105+0x8b/0xa3
[   41.538018]  ? exit_to_usermode_loop+0x77/0x140
[   41.538493]  trace_call_bpf+0x4e/0x2e0
[   41.538908]  __uprobe_perf_func.isra.15+0x38f/0x690
[   41.539399]  ? probes_profile_seq_show+0x220/0x220
[   41.539962]  ? __mutex_lock_slowpath+0x10/0x10
[   41.540412]  uprobe_dispatcher+0x5de/0x8f0
[   41.540875]  ? uretprobe_dispatcher+0x7c0/0x7c0
[   41.541404]  ? down_read_killable+0x200/0x200
[   41.541852]  ? __kasan_kmalloc.constprop.6+0xc1/0xd0
[   41.542356]  uprobe_notify_resume+0xacf/0x1d60

The following fixes it:

commit 7b7b71ff43cc0b15567b60c38a951c8a2cbc97f0 (HEAD -> bpf-next)
Author: Alexei Starovoitov <ast@kernel.org>
Date:   Mon Feb 24 11:27:15 2020 -0800

    bpf: disable migration for bpf progs attached to uprobe

    trace_call_bpf() no longer disables preemption on its own.
    All callers of this function has to do it explicitly.

    Signed-off-by: Alexei Starovoitov <ast@kernel.org>

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 18d16f3ef980..7581f5eb6091 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1333,8 +1333,15 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
        int size, esize;
        int rctx;

-       if (bpf_prog_array_valid(call) && !trace_call_bpf(call, regs))
-               return;
+       if (bpf_prog_array_valid(call)) {
+               u32 ret;
+
+               migrate_disable();
+               ret = trace_call_bpf(call, regs);
+               migrate_enable();
+               if (!ret)
+                       return;
+       }

But looking at your patch cant_sleep() seems unnecessary strong.
Should it be cant_migrate() instead?
And two calls to __this_cpu*() replaced with this_cpu*() ?
If you can ack it I can fix it up in place and apply the whole thing.
That was the only issue I found.
