Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE382B159B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 06:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgKMFnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 00:43:33 -0500
Received: from hydra.tuxags.com ([64.13.172.54]:56376 "EHLO mail.tuxags.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgKMFnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 00:43:33 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2020 00:43:33 EST
Received: by mail.tuxags.com (Postfix, from userid 1000)
        id B37E812038E63; Thu, 12 Nov 2020 21:37:24 -0800 (PST)
Date:   Thu, 12 Nov 2020 21:37:24 -0800
From:   Matt Mullins <mmullins@mmlx.us>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, andrii@kernel.org,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@redhat.com>, mmullins@fb.com,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: KASAN: vmalloc-out-of-bounds Read in bpf_trace_run3
Message-ID: <20201113053722.7i4xkiyrlymcwebg@hydra.tuxags.com>
Mail-Followup-To: Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, andrii@kernel.org,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@redhat.com>, mmullins@fb.com,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
References: <00000000000004500b05b31e68ce@google.com>
 <CACT4Y+aBVQ6LKYf9wCV=AUx23xpWmb_6-mBqwkQgeyfXA3SS2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+aBVQ6LKYf9wCV=AUx23xpWmb_6-mBqwkQgeyfXA3SS2A@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 03:57:50PM +0100, Dmitry Vyukov wrote:
> On Mon, Nov 2, 2020 at 12:54 PM syzbot
> <syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    080b6f40 bpf: Don't rely on GCC __attribute__((optimize)) ..
> > git tree:       bpf
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1089d37c500000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=58a4ca757d776bfe
> > dashboard link: https://syzkaller.appspot.com/bug?extid=d29e58bb557324e55e5e
> > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f4b032500000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1371a47c500000
> >
> > The issue was bisected to:
> >
> > commit 9df1c28bb75217b244257152ab7d788bb2a386d0
> > Author: Matt Mullins <mmullins@fb.com>
> > Date:   Fri Apr 26 18:49:47 2019 +0000
> >
> >     bpf: add writable context for raw tracepoints
> 
> 
> We have a number of kernel memory corruptions related to bpf_trace_run now:
> https://groups.google.com/g/syzkaller-bugs/search?q=kernel%2Ftrace%2Fbpf_trace.c
> 
> Can raw tracepoints "legally" corrupt kernel memory (a-la /dev/kmem)?
> Or they shouldn't?
> 
> Looking at the description of Matt's commit, it seems that corruptions
> should not be possible (bounded buffer, checked size, etc). Then it
> means it's a real kernel bug?

This bug doesn't seem to be related to the writability of the
tracepoint; it bisected to that commit simply because it used
BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE for the reproducer and it EINVAL's
before that program type was introduced.  The BPF program it loads is
pretty much a no-op.

The problem here is a kmalloc failure injection into
tracepoint_probe_unregister, but the error is ignored -- so the bpf
program is freed even though the tracepoint is never unregistered.

I have a first pass at a patch to pipe through the error code, but it's
pretty ugly.  It's also called from the file_operations ->release(), for
which errors are solidly ignored in __fput(), so I'm not sure what the
best way to handle ENOMEM is...

> 
> 
> 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12b6c4da500000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=11b6c4da500000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16b6c4da500000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com
> > Fixes: 9df1c28bb752 ("bpf: add writable context for raw tracepoints")
> >
> > ==================================================================
> > BUG: KASAN: vmalloc-out-of-bounds in __bpf_trace_run kernel/trace/bpf_trace.c:2045 [inline]
> > BUG: KASAN: vmalloc-out-of-bounds in bpf_trace_run3+0x3e0/0x3f0 kernel/trace/bpf_trace.c:2083
> > Read of size 8 at addr ffffc90000e6c030 by task kworker/0:3/3754
> >
> > CPU: 0 PID: 3754 Comm: kworker/0:3 Not tainted 5.9.0-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Workqueue:  0x0 (events)
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x107/0x163 lib/dump_stack.c:118
> >  print_address_description.constprop.0.cold+0x5/0x4c8 mm/kasan/report.c:385
> >  __kasan_report mm/kasan/report.c:545 [inline]
> >  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
> >  __bpf_trace_run kernel/trace/bpf_trace.c:2045 [inline]
> >  bpf_trace_run3+0x3e0/0x3f0 kernel/trace/bpf_trace.c:2083
> >  __bpf_trace_sched_switch+0xdc/0x120 include/trace/events/sched.h:138
> >  __traceiter_sched_switch+0x64/0xb0 include/trace/events/sched.h:138
> >  trace_sched_switch include/trace/events/sched.h:138 [inline]
> >  __schedule+0xeb8/0x2130 kernel/sched/core.c:4520
> >  schedule+0xcf/0x270 kernel/sched/core.c:4601
> >  worker_thread+0x14c/0x1120 kernel/workqueue.c:2439
> >  kthread+0x3af/0x4a0 kernel/kthread.c:292
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> >
> >
> > Memory state around the buggy address:
> >  ffffc90000e6bf00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> >  ffffc90000e6bf80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> > >ffffc90000e6c000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> >                                      ^
> >  ffffc90000e6c080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> >  ffffc90000e6c100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> > ==================================================================
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000004500b05b31e68ce%40google.com.
