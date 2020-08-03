Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0AE23A8E1
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgHCOuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgHCOuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 10:50:50 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74A152076E;
        Mon,  3 Aug 2020 14:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596466249;
        bh=hYqtB5D8bWSgMhqH73CrhvUPEYWs3SY+kGQi2srIaeo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q+iSnGP5ZNkXtGQxke2PTU+GyeDD/wYYeOyi+w/42hBZHwEgwWfTWTG6noTc02Lfo
         qcPdCNpZTW5UcOW0Xfs6iJ4erN+q3x9pHzlt8aWgfzoliUC53iWlbYEX+5MoQV20iD
         lKE2twHBN05pcyPdii3h1bNPN6r9NIHtyS9sFf3U=
Date:   Mon, 3 Aug 2020 23:50:42 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Muchun Song <songmuchun@bytedance.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     naveen.n.rao@linux.ibm.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH] kprobes: fix NULL pointer dereference at
 kprobe_ftrace_handler
Message-Id: <20200803235042.6bacaf3eb53b7ab831f4edd3@kernel.org>
In-Reply-To: <CAMZfGtUDmQgDySu7OSBNYv5y2_QJfzDcVeYG2eY6-1xYq+t1Uw@mail.gmail.com>
References: <20200728064536.24405-1-songmuchun@bytedance.com>
        <CAMZfGtUDmQgDySu7OSBNYv5y2_QJfzDcVeYG2eY6-1xYq+t1Uw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Aug 2020 13:46:25 +0800
Muchun Song <songmuchun@bytedance.com> wrote:

> Ping guys. Any comments or suggestions?
> 
> On Tue, Jul 28, 2020 at 2:45 PM Muchun Song <songmuchun@bytedance.com> wrote:
> >
> > We found a case of kernel panic on our server. The stack trace is as
> > follows(omit some irrelevant information):
> >
> >   BUG: kernel NULL pointer dereference, address: 0000000000000080
> >   RIP: 0010:kprobe_ftrace_handler+0x5e/0xe0
> >   RSP: 0018:ffffb512c6550998 EFLAGS: 00010282
> >   RAX: 0000000000000000 RBX: ffff8e9d16eea018 RCX: 0000000000000000
> >   RDX: ffffffffbe1179c0 RSI: ffffffffc0535564 RDI: ffffffffc0534ec0
> >   RBP: ffffffffc0534ec1 R08: ffff8e9d1bbb0f00 R09: 0000000000000004
> >   R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> >   R13: ffff8e9d1f797060 R14: 000000000000bacc R15: ffff8e9ce13eca00
> >   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   CR2: 0000000000000080 CR3: 00000008453d0005 CR4: 00000000003606e0
> >   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >   Call Trace:
> >    <IRQ>
> >    ftrace_ops_assist_func+0x56/0xe0
> >    ftrace_call+0x5/0x34
> >    tcpa_statistic_send+0x5/0x130 [ttcp_engine]
> >
> > The tcpa_statistic_send is the function being kprobed. After analysis,
> > the root cause is that the fourth parameter regs of kprobe_ftrace_handler
> > is NULL. Why regs is NULL? We use the crash tool to analyze the kdump.
> >
> >   crash> dis tcpa_statistic_send -r
> >          <tcpa_statistic_send>: callq 0xffffffffbd8018c0 <ftrace_caller>
> >
> > The tcpa_statistic_send calls ftrace_caller instead of ftrace_regs_caller.
> > So it is reasonable that the fourth parameter regs of kprobe_ftrace_handler
> > is NULL. In theory, we should call the ftrace_regs_caller instead of the
> > ftrace_caller. After in-depth analysis, we found a reproducible path.
> >
> >   Writing a simple kernel module which starts a periodic timer. The
> >   timer's handler is named 'kprobe_test_timer_handler'. The module
> >   name is kprobe_test.ko.
> >
> >   1) insmod kprobe_test.ko
> >   2) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'
> >   3) echo 0 > /proc/sys/kernel/ftrace_enabled
> >   4) rmmod kprobe_test
> >   5) stop step 2) kprobe
> >   6) insmod kprobe_test.ko
> >   7) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'
> >
> > We mark the kprobe as GONE but not disarm the kprobe in the step 4).
> > The step 5) also do not disarm the kprobe when unregister kprobe. So
> > we do not remove the ip from the filter. In this case, when the module
> > loads again in the step 6), we will replace the code to ftrace_caller
> > via the ftrace_module_enable(). When we register kprobe again, we will
> > not replace ftrace_caller to ftrace_regs_caller because the ftrace is
> > disabled in the step 3). So the step 7) will trigger kernel panic. Fix
> > this problem by disarming the kprobe when the module is going away.
> >

Nice catch!

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Fixes: ae6aa16fdc16 ("kprobes: introduce ftrace based optimization")
Cc: stable@vger.kernel.org

Thank you!

> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
> > Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> > ---
> >  kernel/kprobes.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> > index 146c648eb943..503add629599 100644
> > --- a/kernel/kprobes.c
> > +++ b/kernel/kprobes.c
> > @@ -2148,6 +2148,13 @@ static void kill_kprobe(struct kprobe *p)
> >          * the original probed function (which will be freed soon) any more.
> >          */
> >         arch_remove_kprobe(p);
> > +
> > +       /*
> > +        * The module is going away. We should disarm the kprobe which
> > +        * is using ftrace.
> > +        */
> > +       if (kprobe_ftrace(p))
> > +               disarm_kprobe_ftrace(p);
> >  }
> >
> >  /* Disable one kprobe */
> > --
> > 2.11.0
> >
> 
> 
> -- 
> Yours,
> Muchun


-- 
Masami Hiramatsu <mhiramat@kernel.org>
