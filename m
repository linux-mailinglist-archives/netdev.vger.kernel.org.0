Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3162CF2E8
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730904AbgLDRPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:15:37 -0500
Received: from smtp7.emailarray.com ([65.39.216.66]:26796 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgLDRPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 12:15:36 -0500
Received: (qmail 62282 invoked by uid 89); 4 Dec 2020 17:14:54 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 4 Dec 2020 17:14:54 -0000
Date:   Fri, 4 Dec 2020 09:14:52 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next] bpf: increment and use correct thread
 iterator
Message-ID: <20201204171452.bl4foim6x7nf3vvn@bsd-mbp.dhcp.thefacebook.com>
References: <20201204034302.2123841-1-jonathan.lemon@gmail.com>
 <2b90f131-5cb0-3c67-ea2e-f2c66ad918a7@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b90f131-5cb0-3c67-ea2e-f2c66ad918a7@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 12:01:53AM -0800, Yonghong Song wrote:
> 
> 
> On 12/3/20 7:43 PM, Jonathan Lemon wrote:
> > From: Jonathan Lemon <bsd@fb.com>
> 
> Could you explain in the commit log what problem this patch
> tries to solve? What bad things could happen without this patch?

Without the patch, on a particular set of systems, RCU will repeatedly
generate stall warnings similar to the trace below.  The common factor
for all the traces seems to be using task_file_seq_next().  With the
patch, all the warnings go away.

 rcu: INFO: rcu_sched self-detected stall on CPU
 rcu: \x0910-....: (20666 ticks this GP) idle=4b6/1/0x4000000000000002 softirq=14346773/14346773 fqs=5064
 \x09(t=21013 jiffies g=25395133 q=154147)
 NMI backtrace for cpu 10
 #1
 Hardware name: Quanta Leopard ORv2-DDR4/Leopard ORv2-DDR4, BIOS F06_3B17 03/16/2018
 Call Trace:
  <IRQ>
  dump_stack+0x50/0x70
  nmi_cpu_backtrace.cold.6+0x13/0x50
  ? lapic_can_unplug_cpu.cold.30+0x40/0x40
  nmi_trigger_cpumask_backtrace+0xba/0xca
  rcu_dump_cpu_stacks+0x99/0xc7
  rcu_sched_clock_irq.cold.90+0x1b4/0x3aa
  ? tick_sched_do_timer+0x60/0x60
  update_process_times+0x24/0x50
  tick_sched_timer+0x37/0x70
  __hrtimer_run_queues+0xfe/0x270
  hrtimer_interrupt+0xf4/0x210
  smp_apic_timer_interrupt+0x5e/0x120
  apic_timer_interrupt+0xf/0x20
  </IRQ>
 RIP: 0010:find_ge_pid_upd+0x5/0x20
 Code: 80 00 00 00 00 0f 1f 44 00 00 48 83 ec 08 89 7c 24 04 48 8d 7e 08 48 8d 74 24 04 e8 d5 d3 9a 00 48 83 c4 08 c3 0f 1f 44 00 00 <48> 89 f8 48 8d 7e 08 48 89 c6 e9 bc d3 9a 00 cc cc cc cc cc cc cc
 RSP: 0018:ffffc9002b7abdb8 EFLAGS: 00000297 ORIG_RAX: ffffffffffffff13
 RAX: 00000000002ca5cd RBX: ffff889c44c0ba00 RCX: 0000000000000000
 RDX: 0000000000000002 RSI: ffffffff8284eb80 RDI: ffffc9002b7abdc4
 RBP: ffffc9002b7abe0c R08: ffff8895afe93a00 R09: ffff8891388abb50
 R10: 000000000000000c R11: 00000000002ca600 R12: 000000000000003f
 R13: ffffffff8284eb80 R14: 0000000000000001 R15: 00000000ffffffff
  task_seq_get_next+0x53/0x180
  task_file_seq_get_next+0x159/0x220
  task_file_seq_next+0x4f/0xa0
  bpf_seq_read+0x159/0x390
  vfs_read+0x8a/0x140
  ksys_read+0x59/0xd0
  do_syscall_64+0x42/0x110
  entry_SYSCALL_64_after_hwframe+0x44/0xa9


> > If unable to obtain the file structure for the current task,
> > proceed to the next task number after the one returned from
> > task_seq_get_next(), instead of the next task number from the
> > original iterator.
> This seems a correct change. The current code should still work
> but it may do some redundant/unnecessary work in kernel.
> This only happens when a task does not have any file,
> no sure whether this is the culprit for the problem this
> patch tries to address.
> 
> > 
> > Use thread_group_leader() instead of comparing tgid vs pid, which
> > might may be racy.
> 
> I see
> 
> static inline bool thread_group_leader(struct task_struct *p)
> {
>         return p->exit_signal >= 0;
> }
> 
> I am not sure whether thread_group_leader(task) is equivalent
> to task->tgid == task->pid or not. Any documentation or explanation?
> 
> Could you explain why task->tgid != task->pid in the original
> code could be racy?

My understanding is that anything which uses pid_t for comparision
in the kernel is incorrect.  Looking at de_thread(), there is a 
section which swaps the pid and tids around, but doesn't seem to 
change tgid directly.

There's also this comment in linux/pid.h:
        /*
         * Both old and new leaders may be attached to
         * the same pid in the middle of de_thread().
         */

So the safest thing to do is use the explicit thread_group_leader()
macro rather than trying to open code things.


> > Only obtain the task reference count at the end of the RCU section
> > instead of repeatedly obtaining/releasing it when iterathing though
> > a thread group.
> 
> I think this is an optimization and not about the correctness.

Yes, but the loop in question can be executed thousands of times, and 
there isn't much point in doing this needless work.  It's unclear 
whether this is a significant time contribution to the RCU stall,
but reducing the amount of refcounting isn't a bad thing.
-- 
Jonathan
