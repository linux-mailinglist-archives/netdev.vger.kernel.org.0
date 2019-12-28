Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E88F12BD66
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 12:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfL1LPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 06:15:54 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39162 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726248AbfL1LPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 06:15:54 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ilA4S-00072O-81; Sat, 28 Dec 2019 12:15:48 +0100
Date:   Sat, 28 Dec 2019 12:15:48 +0100
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        eric.dumazet@gmail.com
Subject: Re: INFO: rcu detected stall in br_handle_frame (2)
Message-ID: <20191228111548.GI795@breakpoint.cc>
References: <000000000000f9f9a8059a737d7e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f9f9a8059a737d7e@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com> wrote:

[ CC Eric, fq related ]

> syzbot found the following crash on:
> 
> HEAD commit:    7e0165b2 Merge branch 'akpm' (patches from Andrew)
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=116ec09ee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1b59a3066828ac4c
> dashboard link: https://syzkaller.appspot.com/bug?extid=dc9071cc5a85950bdfce
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159182c1e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1221218ee00000
> 
> Bisection is inconclusive: the bug happens on the oldest tested release.
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=158224c1e00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=178224c1e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=138224c1e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com
> 
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> 	(detected by 0, t=10502 jiffies, g=10149, q=201)
> rcu: All QSes seen, last rcu_preempt kthread activity 10502
> (4294978441-4294967939), jiffies_till_next_fqs=1, root ->qsmask 0x0
> sshd            R  running task    26584 10034   9965 0x00000008
> Call Trace:
>  <IRQ>
>  sched_show_task kernel/sched/core.c:5954 [inline]
[..]

The reproducer sets up 'fq' sched with TCA_FQ_QUANTUM == 0x80000000

This causes infinite loop in fq_dequeue:

if (f->credit <= 0) {
  f->credit += q->quantum;
  goto begin;
}

... because f->credit is either 0 or -2147483648.

Eric, what is a 'sane' ->quantum value?

One could simply add a 'quantum > 0 && quantum < INT_MAX'
constraint afaics.

If you don't have a better idea/suggestion for an upperlimit INT_MAX
would be enough to prevent perpetual <= 0 condition.
