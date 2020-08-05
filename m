Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10F923D0BB
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgHETwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:52:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbgHEQvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 12:51:00 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DFA922CF7;
        Wed,  5 Aug 2020 16:50:58 +0000 (UTC)
Date:   Wed, 5 Aug 2020 12:50:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     naveen.n.rao@linux.ibm.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, mhiramat@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, sfr@canb.auug.org.au, mingo@kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH v2] kprobes: fix NULL pointer dereference at
 kprobe_ftrace_handler
Message-ID: <20200805125056.1dfe74b5@oasis.local.home>
In-Reply-To: <20200805162713.16386-1-songmuchun@bytedance.com>
References: <20200805162713.16386-1-songmuchun@bytedance.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Aug 2020 00:27:13 +0800
Muchun Song <songmuchun@bytedance.com> wrote:

> We found a case of kernel panic on our server. The stack trace is as
> follows(omit some irrelevant information):
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000080
>   RIP: 0010:kprobe_ftrace_handler+0x5e/0xe0
>   RSP: 0018:ffffb512c6550998 EFLAGS: 00010282
>   RAX: 0000000000000000 RBX: ffff8e9d16eea018 RCX: 0000000000000000
>   RDX: ffffffffbe1179c0 RSI: ffffffffc0535564 RDI: ffffffffc0534ec0
>   RBP: ffffffffc0534ec1 R08: ffff8e9d1bbb0f00 R09: 0000000000000004
>   R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>   R13: ffff8e9d1f797060 R14: 000000000000bacc R15: ffff8e9ce13eca00
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000000000000080 CR3: 00000008453d0005 CR4: 00000000003606e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    <IRQ>
>    ftrace_ops_assist_func+0x56/0xe0
>    ftrace_call+0x5/0x34
>    tcpa_statistic_send+0x5/0x130 [ttcp_engine]
> 
> The tcpa_statistic_send is the function being kprobed. After analysis,
> the root cause is that the fourth parameter regs of kprobe_ftrace_handler
> is NULL. Why regs is NULL? We use the crash tool to analyze the kdump.
> 
>   crash> dis tcpa_statistic_send -r  
>          <tcpa_statistic_send>: callq 0xffffffffbd8018c0 <ftrace_caller>
> 
> The tcpa_statistic_send calls ftrace_caller instead of ftrace_regs_caller.
> So it is reasonable that the fourth parameter regs of kprobe_ftrace_handler
> is NULL. In theory, we should call the ftrace_regs_caller instead of the
> ftrace_caller. After in-depth analysis, we found a reproducible path.
> 
>   Writing a simple kernel module which starts a periodic timer. The
>   timer's handler is named 'kprobe_test_timer_handler'. The module
>   name is kprobe_test.ko.
> 
>   1) insmod kprobe_test.ko
>   2) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'
>   3) echo 0 > /proc/sys/kernel/ftrace_enabled
>   4) rmmod kprobe_test
>   5) stop step 2) kprobe
>   6) insmod kprobe_test.ko
>   7) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'
> 
> We mark the kprobe as GONE but not disarm the kprobe in the step 4).
> The step 5) also do not disarm the kprobe when unregister kprobe. So
> we do not remove the ip from the filter. In this case, when the module
> loads again in the step 6), we will replace the code to ftrace_caller
> via the ftrace_module_enable(). When we register kprobe again, we will
> not replace ftrace_caller to ftrace_regs_caller because the ftrace is
> disabled in the step 3). So the step 7) will trigger kernel panic. Fix
> this problem by disarming the kprobe when the module is going away.
> 
> Fixes: ae6aa16fdc16 ("kprobes: introduce ftrace based optimization")
> Acked-by: Song Liu <songliubraving@fb.com>
> Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> ---
> changelogs in v2:
>  1) fix compiler warning for !CONFIG_KPROBES_ON_FTRACE.

The original patch has already been pulled into the queue and tested.
Please make a new patch that adds this update, as if your original
patch has already been accepted.

Feel free to base it off of:

 git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git  for-next

-- Steve
