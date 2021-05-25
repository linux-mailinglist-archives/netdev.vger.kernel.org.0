Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33E339041C
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbhEYOjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234105AbhEYOiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 10:38:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85EFF61401;
        Tue, 25 May 2021 14:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621953392;
        bh=cEe5ScQzy5z7+XHVG5DLL2Ps9gSI7vLv6dB1pBoh0XA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=IGkkkQnlspJu2gHZCn2FBM6qdy9GGfhuguSVRFfHUhavCSMkP0avrR9NiCPVbwwIY
         1Wk86sVZg1usShc1pXiZ/9+HiX2qa78xxDx/psxctCef6l2mczXpzAv5A2uXdWfFxG
         xrYtQklBN747VMis2oxmD0iiy+sTUZGqr9479qgkH42naRStiMtDDLp988f3nfqns9
         Ge0YRD3g9+eUr4esS2mLhxX6A5kIWdvxoWMbVh4M4FJA3UTtgebUV5u5jbrmgUigLS
         p8/P0fj39+kuf3bY4bJ2/qyu9k18M+h1N1cwhAuL4ZZLnz7nD4AkUJ85XA1Yyih+ml
         ntj6OduzZPFMA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 54A245C02A7; Tue, 25 May 2021 07:36:32 -0700 (PDT)
Date:   Tue, 25 May 2021 07:36:32 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     "Xu, Yanfei" <yanfei.xu@windriver.com>,
        syzbot <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com>,
        rcu@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, bpf <bpf@vger.kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in
 check_all_holdout_tasks_trace
Message-ID: <20210525143632.GP4441@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <000000000000f034fc05c2da6617@google.com>
 <CACT4Y+ZGkye_MnNr92qQameXVEHNc1QkpmNrG3W8Yd1Xg_hfhw@mail.gmail.com>
 <20210524041350.GJ4441@paulmck-ThinkPad-P17-Gen-1>
 <20210524224602.GA1963972@paulmck-ThinkPad-P17-Gen-1>
 <24f352fc-c01e-daa8-5138-1f89f75c7c16@windriver.com>
 <20210525033355.GN4441@paulmck-ThinkPad-P17-Gen-1>
 <CACT4Y+bkZv7uo505EBJcE1MLFG1GprZ5npdbaUXZ+ASTJyJU8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4Y+bkZv7uo505EBJcE1MLFG1GprZ5npdbaUXZ+ASTJyJU8A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 10:33:27AM +0200, Dmitry Vyukov wrote:
> On Tue, May 25, 2021 at 5:33 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Tue, May 25, 2021 at 10:31:55AM +0800, Xu, Yanfei wrote:
> > >
> > >
> > > On 5/25/21 6:46 AM, Paul E. McKenney wrote:
> > > > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > > >
> > > > On Sun, May 23, 2021 at 09:13:50PM -0700, Paul E. McKenney wrote:
> > > > > On Sun, May 23, 2021 at 08:51:56AM +0200, Dmitry Vyukov wrote:
> > > > > > On Fri, May 21, 2021 at 7:29 PM syzbot
> > > > > > <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com> wrote:
> > > > > > >
> > > > > > > Hello,
> > > > > > >
> > > > > > > syzbot found the following issue on:
> > > > > > >
> > > > > > > HEAD commit:    f18ba26d libbpf: Add selftests for TC-BPF management API
> > > > > > > git tree:       bpf-next
> > > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=17f50d1ed00000
> > > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=8ff54addde0afb5d
> > > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=7b2b13f4943374609532
> > > > > > >
> > > > > > > Unfortunately, I don't have any reproducer for this issue yet.
> > > > > > >
> > > > > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > > > > Reported-by: syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com
> > > > > >
> > > > > > This looks rcu-related. +rcu mailing list
> > > > >
> > > > > I think I see a possible cause for this, and will say more after some
> > > > > testing and after becoming more awake Monday morning, Pacific time.
> > > >
> > > > No joy.  From what I can see, within RCU Tasks Trace, the calls to
> > > > get_task_struct() are properly protected (either by RCU or by an earlier
> > > > get_task_struct()), and the calls to put_task_struct() are balanced by
> > > > those to get_task_struct().
> > > >
> > > > I could of course have missed something, but at this point I am suspecting
> > > > an unbalanced put_task_struct() has been added elsewhere.
> > > >
> > > > As always, extra eyes on this code would be a good thing.
> > > >
> > > > If it were reproducible, I would of course suggest bisection.  :-/
> > > >
> > > >                                                          Thanx, Paul
> > > >
> > > Hi Paul,
> > >
> > > Could it be?
> > >
> > >        CPU1                                        CPU2
> > > trc_add_holdout(t, bhp)
> > > //t->usage==2
> > >                                       release_task
> > >                                         put_task_struct_rcu_user
> > >                                           delayed_put_task_struct
> > >                                             ......
> > >                                             put_task_struct(t)
> > >                                             //t->usage==1
> > >
> > > check_all_holdout_tasks_trace
> > >   ->trc_wait_for_one_reader
> > >     ->trc_del_holdout
> > >       ->put_task_struct(t)
> > >       //t->usage==0 and task_struct freed
> > >   READ_ONCE(t->trc_reader_checked)
> > >   //ops， t had been freed.
> > >
> > > So, after excuting trc_wait_for_one_reader（）, task might had been removed
> > > from holdout list and the corresponding task_struct was freed.
> > > And we shouldn't do READ_ONCE(t->trc_reader_checked).
> >
> > I was suspicious of that call to trc_del_holdout() from within
> > trc_wait_for_one_reader(), but the only time it executes is in the
> > context of the current running task, which means that CPU 2 had better
> > not be invoking release_task() on it just yet.
> >
> > Or am I missing your point?
> >
> > Of course, if you can reproduce it, the following patch might be
> > an interesting thing to try, my doubts notwithstanding.  But more
> > important, please check the patch to make sure that we are both
> > talking about the same call to trc_del_holdout()!
> >
> > If we are talking about the same call to trc_del_holdout(), are you
> > actually seeing that code execute except when rcu_tasks_trace_pertask()
> > calls trc_wait_for_one_reader()?
> >
> > > I investigate the trc_wait_for_one_reader（） and found before we excute
> > > trc_del_holdout, there is always set t->trc_reader_checked=true. How about
> > > we just set the checked flag and unified excute trc_del_holdout()
> > > in check_all_holdout_tasks_trace with checking the flag?
> >
> > The problem is that we cannot execute trc_del_holdout() except in
> > the context of the RCU Tasks Trace grace-period kthread.  So it is
> > necessary to manipulate ->trc_reader_checked separately from the list
> > in order to safely synchronize with IPIs and with the exit code path
> > for any reader tasks, see for example trc_read_check_handler() and
> > exit_tasks_rcu_finish_trace().
> >
> > Or are you thinking of some other approach?
> 
> This could be caused by a buggy extra put_pid somewhere else, right?
> If so, I suspect that's what may be happening. We've 2 very similar
> use-after-free reports on an internal kernel, but it also has a number
> of other use-after-free reports in pid-related functions
> (pid_task/pid_nr_ns/attach_pid). One of them is happening relatively
> frequently (150 crashes) and is caused by something in the tty
> subsystem. Presumably it may be causing one off use-after-free's in
> other random places of the kernel as well. Unfortunately these crashes
> don't happen on the upstream kernel (at least not yet).
> So if you don't see any obvious smoking gun in rcu, I think we can
> assume for now that it's due to tty.

Good to hear!

On the other hand, it looks like Yanfei might have found a real problem,
whether or not it was actually being triggered.  Tough to prove either
way, of course!

                                                        Thanx, Paul

> > ------------------------------------------------------------------------
> >
> > diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
> > index efb8127f3a36..2a0d4bdd619a 100644
> > --- a/kernel/rcu/tasks.h
> > +++ b/kernel/rcu/tasks.h
> > @@ -987,7 +987,6 @@ static void trc_wait_for_one_reader(struct task_struct *t,
> >         // The current task had better be in a quiescent state.
> >         if (t == current) {
> >                 t->trc_reader_checked = true;
> > -               trc_del_holdout(t);
> >                 WARN_ON_ONCE(READ_ONCE(t->trc_reader_nesting));
> >                 return;
> >         }
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20210525033355.GN4441%40paulmck-ThinkPad-P17-Gen-1.
