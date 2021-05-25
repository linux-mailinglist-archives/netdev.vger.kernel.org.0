Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F04C3903E6
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhEYOaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233947AbhEYOaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 10:30:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22D4861417;
        Tue, 25 May 2021 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621952916;
        bh=yOFbOyeOH4Z8ERI4DE9qAGtun2OsQD4wk3ZwQA5/0IU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=t9swXW7m8mWa6CRB+0wVSwacFcw7sA4VD62Rj6HKhQCxCq/8VHbwwrf8ybEkJ/AY9
         g/hwyXeOIMsgmaZst+NJfHISK766JarxaE8Ms+kWqO/F7YRbGIryshGd1MA6uW9YVD
         7WKna8MLyOD6HdpuOvdSTegQ0wdFVVfVasn6Tdvn+de4yXt5R7543VzSIMPtOqNI4f
         +AoKfNpxLeluLgPwmpYM4eJeU7PCFY0qJoOS0k9JnaD4dI823PBh5DW0n1VCFRila1
         x+sczSgjQkZ8TjS7htUCTO3Bpz19QxJBxdSSSbIk4AaCXaO+Jox38t/d8leURr2y4X
         u4Xd8+NBFYY6Q==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id DB6C55C02A7; Tue, 25 May 2021 07:28:35 -0700 (PDT)
Date:   Tue, 25 May 2021 07:28:35 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     "Xu, Yanfei" <yanfei.xu@windriver.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
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
Message-ID: <20210525142835.GO4441@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <000000000000f034fc05c2da6617@google.com>
 <CACT4Y+ZGkye_MnNr92qQameXVEHNc1QkpmNrG3W8Yd1Xg_hfhw@mail.gmail.com>
 <20210524041350.GJ4441@paulmck-ThinkPad-P17-Gen-1>
 <20210524224602.GA1963972@paulmck-ThinkPad-P17-Gen-1>
 <24f352fc-c01e-daa8-5138-1f89f75c7c16@windriver.com>
 <20210525033355.GN4441@paulmck-ThinkPad-P17-Gen-1>
 <4b98d598-8044-0254-9ee2-0c9814b0245a@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b98d598-8044-0254-9ee2-0c9814b0245a@windriver.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 06:24:10PM +0800, Xu, Yanfei wrote:
> 
> 
> On 5/25/21 11:33 AM, Paul E. McKenney wrote:
> > [Please note: This e-mail is from an EXTERNAL e-mail address]
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
> > > >                                                           Thanx, Paul
> > > > 
> > > Hi Paul,
> > > 
> > > Could it be?
> > > 
> > >         CPU1                                        CPU2
> > > trc_add_holdout(t, bhp)
> > > //t->usage==2
> > >                                        release_task
> > >                                          put_task_struct_rcu_user
> > >                                            delayed_put_task_struct
> > >                                              ......
> > >                                              put_task_struct(t)
> > >                                              //t->usage==1
> > > 
> > > check_all_holdout_tasks_trace
> > >    ->trc_wait_for_one_reader
> > >      ->trc_del_holdout
> > >        ->put_task_struct(t)
> > >        //t->usage==0 and task_struct freed
> > >    READ_ONCE(t->trc_reader_checked)
> > >    //ops， t had been freed.
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
> 
> Two times.
> 1. the task is current.
> 
>                trc_wait_for_one_reader
>                  ->trc_del_holdout

This one should be fine because the task cannot be freed until it
actually exits, and the grace-period kthread never exits.  But it
could also be removed without any problem that I see.

> 2. task isn't current.
> 
>                trc_wait_for_one_reader
>                  ->get_task_struct
>                  ->try_invoke_on_locked_down_task（trc_inspect_reader）
>                    ->trc_del_holdout
>                  ->put_task_struct

Ah, this one is more interesting, thank you!

Yes, it is safe from the list's viewpoint to do the removal in the
trc_inspect_reader() callback, but you are right that the grace-period
kthread may touch the task structure after return, and there might not
be anything else holding that task structure in place.

> > Of course, if you can reproduce it, the following patch might be
> 
> Sorry...I can't reproduce it, just analyse syzbot's log. :(

Well, if it could be reproduced, that would mean that it was too easy,
wouldn't it?  ;-)

How about the (untested) patch below, just to make sure that we are
talking about the same thing?  I have started testing, but then
again, I have not yet been able to reproduce this, either.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index efb8127f3a36..8b25551d10db 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -957,10 +957,9 @@ static bool trc_inspect_reader(struct task_struct *t, void *arg)
 		in_qs = likely(!t->trc_reader_nesting);
 	}
 
-	// Mark as checked.  Because this is called from the grace-period
-	// kthread, also remove the task from the holdout list.
+	// Mark as checked so that the grace-period kthread will
+	// remove it from the holdout list.
 	t->trc_reader_checked = true;
-	trc_del_holdout(t);
 
 	if (in_qs)
 		return true;  // Already in quiescent state, done!!!
