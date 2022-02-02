Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281C74A6C53
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 08:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiBBH3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 02:29:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34794 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236750AbiBBH3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 02:29:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB9BB6178D;
        Wed,  2 Feb 2022 07:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5DBC004E1;
        Wed,  2 Feb 2022 07:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643786970;
        bh=26oHZ8vPtcOPyXKDjLAHkT61kFVbwnkIgRev3TI/TwA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vFkk5g2vuLW3BYdhspWsCLkp8cirZrU+YVzDQbWcw/nj/LfdPDhBK06B+vaCXqUl+
         QusglW40WUHWbnW+t6EExHqg5DojLIPkHiKkJdbaubsdhOl2EYMIWnQlM8NYnN1lkE
         OOx6Utx8ZbtaNe7qQyl+41U/11380DdLNJ08Dgvc+xV5rI4tQF6qOuu4wYV1/BsqpD
         qxgEIcIOyvFarHhNWnQUafx+SIjf+XXUes6YAdAssjrYW6QU8vmHZz50R311TrT0+Z
         4i190mTE8Dnge+5Ld1Dhwos46dYgSg0iI9yzrkPnczVVJtzzLa0HcyS6QqC/+m5V1D
         PIKO0js96J0Gw==
Date:   Wed, 2 Feb 2022 16:29:25 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v7 00/10] fprobe: Introduce fprobe function entry/exit
 probe
Message-Id: <20220202162925.bd74e7970fc35cb4236eef48@kernel.org>
In-Reply-To: <YfnKIyTwi+F3IPdI@krava>
References: <164360522462.65877.1891020292202285106.stgit@devnote2>
        <YfnKIyTwi+F3IPdI@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Wed, 2 Feb 2022 01:02:43 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Mon, Jan 31, 2022 at 02:00:24PM +0900, Masami Hiramatsu wrote:
> > Hi,
> > 
> > Here is the 7th version of fprobe. This version fixes unregister_fprobe()
> > ensures that exit_handler is not called after returning from the
> > unregister_fprobe(), and fixes some comments and documents.
> > 
> > The previous version is here[1];
> > 
> > [1] https://lore.kernel.org/all/164338031590.2429999.6203979005944292576.stgit@devnote2/T/#u
> > 
> > This series introduces the fprobe, the function entry/exit probe
> > with multiple probe point support. This also introduces the rethook
> > for hooking function return as same as the kretprobe does. This
> > abstraction will help us to generalize the fgraph tracer,
> > because we can just switch to it from the rethook in fprobe,
> > depending on the kernel configuration.
> > 
> > The patch [1/10] is from Jiri's series[2].
> > 
> > [2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
> > 
> > And the patch [9/10] adds the FPROBE_FL_KPROBE_SHARED flag for the case
> > if user wants to share the same code (or share a same resource) on the
> > fprobe and the kprobes.
> 
> hi,
> it works fine for bpf selftests, but when I use it through bpftrace
> to attach more probes with:
> 
>   # ./src/bpftrace -e 'kprobe:ksys_* { }'
>   Attaching 27 probes
> 
> I'm getting stalls like:
> 
> krava33 login: [  988.574069] INFO: task bpftrace:4137 blocked for more than 122 seconds.
> [  988.577577]       Not tainted 5.16.0+ #89
> [  988.580173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  988.585538] task:bpftrace        state:D stack:    0 pid: 4137 ppid:  4123 flags:0x00004004
> [  988.589869] Call Trace:
> [  988.591312]  <TASK>
> [  988.592577]  __schedule+0x3a8/0xd30
> [  988.594469]  ? wait_for_completion+0x84/0x110
> [  988.596753]  schedule+0x4e/0xc0
> [  988.598480]  schedule_timeout+0xed/0x130
> [  988.600524]  ? rcu_read_lock_sched_held+0x12/0x70
> [  988.602901]  ? lock_release+0x253/0x4a0
> [  988.604935]  ? lock_acquired+0x1b7/0x410
> [  988.607041]  ? trace_hardirqs_on+0x1b/0xe0
> [  988.609202]  wait_for_completion+0xae/0x110
> [  988.613762]  __wait_rcu_gp+0x127/0x130
> [  988.615787]  synchronize_rcu_tasks_generic+0x46/0xa0
> [  988.618329]  ? call_rcu_tasks+0x20/0x20
> [  988.620600]  ? rcu_tasks_pregp_step+0x10/0x10
> [  988.623232]  ftrace_shutdown.part.0+0x174/0x210
> [  988.625820]  unregister_ftrace_function+0x37/0x60
> [  988.628480]  unregister_fprobe+0x2d/0x50
> [  988.630928]  bpf_link_free+0x4e/0x70
> [  988.633126]  bpf_link_release+0x11/0x20
> [  988.635249]  __fput+0xae/0x270
> [  988.637022]  task_work_run+0x5c/0xa0
> [  988.639016]  exit_to_user_mode_prepare+0x251/0x260
> [  988.641294]  syscall_exit_to_user_mode+0x16/0x50
> [  988.646249]  do_syscall_64+0x48/0x90
> [  988.648218]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  988.650787] RIP: 0033:0x7f9079e95fbb
> [  988.652761] RSP: 002b:00007ffd474fa3b0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> [  988.656718] RAX: 0000000000000000 RBX: 00000000011bf8d0 RCX: 00007f9079e95fbb
> [  988.660110] RDX: 0000000000000000 RSI: 00007ffd474fa3b0 RDI: 0000000000000019
> [  988.663512] RBP: 00007ffd474faaf0 R08: 0000000000000000 R09: 000000000000001a
> [  988.666673] R10: 0000000000000064 R11: 0000000000000293 R12: 0000000000000001
> [  988.669770] R13: 00000000004a19a1 R14: 00007f9083428c00 R15: 00000000008c02d8
> [  988.672601]  </TASK>
> [  988.675763] INFO: lockdep is turned off.
> 
> I have't investigated yet, any idea?

Hmm, no, as far as I tested with my example module, it works well as below;

 # insmod fprobe_example.ko symbol='ksys_*' && ls && sleep 1 && rmmod  fprobe_example.ko 
[  125.820113] fprobe_init: Planted fprobe at ksys_*
[  125.823153] sample_entry_handler: Enter <ksys_write+0x0/0xf0> ip = 0x000000008d8da91f
[  125.824247]                          fprobe_handler.part.0+0xb1/0x150
[  125.825024]                          fprobe_handler+0x1e/0x20
[  125.825799]                          0xffffffffa000e0e3
[  125.826540]                          ksys_write+0x5/0xf0
[  125.827344]                          do_syscall_64+0x3b/0x90
[  125.828144]                          entry_SYSCALL_64_after_hwframe+0x44/0xae
fprobe_example.ko
[  125.829178] sample_exit_handler: Return from <ksys_write+0x0/0xf0> ip = 0x000000008d8da91f to rip = 0x00000000be5e197e (__x64_sys_write+0x1a/0x20)
[  125.830707]                          fprobe_exit_handler+0x29/0x30
[  125.831415]                          rethook_trampoline_handler+0x99/0x140
[  125.832259]                          arch_rethook_trampoline_callback+0x3f/0x50
[  125.833110]                          arch_rethook_trampoline+0x2f/0x50
[  125.833803]                          __x64_sys_write+0x1a/0x20
[  125.834448]                          do_syscall_64+0x3b/0x90
[  125.835055]                          entry_SYSCALL_64_after_hwframe+0x44/0xae
[  126.878825] fprobe_exit: fprobe at ksys_* unregistered
#

Even with NR_CPUS=3, it didn't cause the stall. But maybe you'd better test
with Paul's fix as Andrii pointed.

Thank you,




> 
> thanks,
> jirka
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
