Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21953390F49
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 06:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhEZEWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 00:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231136AbhEZEWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 00:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40B576142D;
        Wed, 26 May 2021 04:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622002865;
        bh=NZKWIN28iWuMtjx6BwvjImZPFZySO0UG0/he/MAoOis=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=dTZCvWMWWIsvt8irM23V9io/StaXDR1Cdseku9Lxh04kO0vPna4PjGXjE6Bo+I2z8
         mdv/xlk6MJ4QuPqVQa4GH5w+REaAbbmURy+JDEBapRHSTJ78aFEGDSjNbTxQ0EnIIF
         8Ie2aJF9XvS/twNVN3GFMb8mBC58BspP4tQyCmVXn1apMM4zHtiK0X8+icgynZHb+M
         8PDlQKJEMVHTgP/I7ks8ohUSxrGKTiOYpSRcXno5c/Nj2KRHJ7mU2EY2AsSB8r+ZU1
         XADd/lLOeVNPwNZcuolGkrlfzb4VtDiUYEXODhGylUXB64gMwO/hlMd3+rtGjbSDg+
         ahQM+ac+wo5Dg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 04DE85C0395; Tue, 25 May 2021 21:21:05 -0700 (PDT)
Date:   Tue, 25 May 2021 21:21:04 -0700
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
Message-ID: <20210526042104.GZ4441@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <000000000000f034fc05c2da6617@google.com>
 <CACT4Y+ZGkye_MnNr92qQameXVEHNc1QkpmNrG3W8Yd1Xg_hfhw@mail.gmail.com>
 <20210524041350.GJ4441@paulmck-ThinkPad-P17-Gen-1>
 <20210524224602.GA1963972@paulmck-ThinkPad-P17-Gen-1>
 <24f352fc-c01e-daa8-5138-1f89f75c7c16@windriver.com>
 <20210525033355.GN4441@paulmck-ThinkPad-P17-Gen-1>
 <4b98d598-8044-0254-9ee2-0c9814b0245a@windriver.com>
 <20210525142835.GO4441@paulmck-ThinkPad-P17-Gen-1>
 <62d52830-e422-d08d-fbb8-9e0984672ffe@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62d52830-e422-d08d-fbb8-9e0984672ffe@windriver.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 10:22:59AM +0800, Xu, Yanfei wrote:
> On 5/25/21 10:28 PM, Paul E. McKenney wrote:
> > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > 
> > On Tue, May 25, 2021 at 06:24:10PM +0800, Xu, Yanfei wrote:
> > > 
> > > 
> > > On 5/25/21 11:33 AM, Paul E. McKenney wrote:
> > > > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > > > 
> > > > On Tue, May 25, 2021 at 10:31:55AM +0800, Xu, Yanfei wrote:
> > > > > 
> > > > > 
> > > > > On 5/25/21 6:46 AM, Paul E. McKenney wrote:
> > > > > > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > > > > > 
> > > > > > On Sun, May 23, 2021 at 09:13:50PM -0700, Paul E. McKenney wrote:
> > > > > > > On Sun, May 23, 2021 at 08:51:56AM +0200, Dmitry Vyukov wrote:
> > > > > > > > On Fri, May 21, 2021 at 7:29 PM syzbot
> > > > > > > > <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com> wrote:
> > > > > > > > > 
> > > > > > > > > Hello,
> > > > > > > > > 
> > > > > > > > > syzbot found the following issue on:
> > > > > > > > > 
> > > > > > > > > HEAD commit:    f18ba26d libbpf: Add selftests for TC-BPF management API
> > > > > > > > > git tree:       bpf-next
> > > > > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=17f50d1ed00000
> > > > > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=8ff54addde0afb5d
> > > > > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=7b2b13f4943374609532
> > > > > > > > > 
> > > > > > > > > Unfortunately, I don't have any reproducer for this issue yet.
> > > > > > > > > 
> > > > > > > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > > > > > > Reported-by: syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com
> > > > > > > > 
> > > > > > > > This looks rcu-related. +rcu mailing list
> > > > > > > 
> > > > > > > I think I see a possible cause for this, and will say more after some
> > > > > > > testing and after becoming more awake Monday morning, Pacific time.
> > > > > > 
> > > > > > No joy.  From what I can see, within RCU Tasks Trace, the calls to
> > > > > > get_task_struct() are properly protected (either by RCU or by an earlier
> > > > > > get_task_struct()), and the calls to put_task_struct() are balanced by
> > > > > > those to get_task_struct().
> > > > > > 
> > > > > > I could of course have missed something, but at this point I am suspecting
> > > > > > an unbalanced put_task_struct() has been added elsewhere.
> > > > > > 
> > > > > > As always, extra eyes on this code would be a good thing.
> > > > > > 
> > > > > > If it were reproducible, I would of course suggest bisection.  :-/
> > > > > > 
> > > > > >                                                            Thanx, Paul
> > > > > > 
> > > > > Hi Paul,
> > > > > 
> > > > > Could it be?
> > > > > 
> > > > >          CPU1                                        CPU2
> > > > > trc_add_holdout(t, bhp)
> > > > > //t->usage==2
> > > > >                                         release_task
> > > > >                                           put_task_struct_rcu_user
> > > > >                                             delayed_put_task_struct
> > > > >                                               ......
> > > > >                                               put_task_struct(t)
> > > > >                                               //t->usage==1
> > > > > 
> > > > > check_all_holdout_tasks_trace
> > > > >     ->trc_wait_for_one_reader
> > > > >       ->trc_del_holdout
> > > > >         ->put_task_struct(t)
> > > > >         //t->usage==0 and task_struct freed
> > > > >     READ_ONCE(t->trc_reader_checked)
> > > > >     //ops， t had been freed.
> > > > > 
> > > > > So, after excuting trc_wait_for_one_reader（）, task might had been removed
> > > > > from holdout list and the corresponding task_struct was freed.
> > > > > And we shouldn't do READ_ONCE(t->trc_reader_checked).
> > > > 
> > > > I was suspicious of that call to trc_del_holdout() from within
> > > > trc_wait_for_one_reader(), but the only time it executes is in the
> > > > context of the current running task, which means that CPU 2 had better
> > > > not be invoking release_task() on it just yet.
> > > > 
> > > > Or am I missing your point?
> > > 
> > > Two times.
> > > 1. the task is current.
> > > 
> > >                 trc_wait_for_one_reader
> > >                   ->trc_del_holdout
> > 
> > This one should be fine because the task cannot be freed until it
> > actually exits, and the grace-period kthread never exits.  But it
> > could also be removed without any problem that I see. >
> 
> Agree, current task's task_struct should be high probably safe.  If you
> think it is safe to remove, I prefer to remove it. Because it can make
> trc_wait_for_one_reader's behavior about deleting task from holdout more
> unified. And there should be a very small racy that the task is checked as a
> current and then turn into a exiting task before its task_struct is accessed
> in trc_wait_for_one_reader or check_all_holdout_tasks_trace.（or I
> misunderstand something about rcu tasks）
> 
> > > 2. task isn't current.
> > > 
> > >                 trc_wait_for_one_reader
> > >                   ->get_task_struct
> > >                   ->try_invoke_on_locked_down_task（trc_inspect_reader）
> > >                     ->trc_del_holdout
> > >                   ->put_task_struct
> > 
> > Ah, this one is more interesting, thank you!
> > 
> > Yes, it is safe from the list's viewpoint to do the removal in the
> > trc_inspect_reader() callback, but you are right that the grace-period
> > kthread may touch the task structure after return, and there might not
> > be anything else holding that task structure in place.
> > 
> > > > Of course, if you can reproduce it, the following patch might be
> > > 
> > > Sorry...I can't reproduce it, just analyse syzbot's log. :(
> > 
> > Well, if it could be reproduced, that would mean that it was too easy,
> > wouldn't it?  ;-)
> 
> Ha ;-)

But it should be possible to make this happen...  Is it possible to
add lots of short-lived tasks to the test that failed?

> > How about the (untested) patch below, just to make sure that we are
> > talking about the same thing?  I have started testing, but then
> > again, I have not yet been able to reproduce this, either.
> > 
> >                                                          Thanx, Paul
> 
> Yes! we are talking the same thing, Should I send a new patch?

Or look at these commits that I queued this past morning (Pacific Time)
on the "dev" branch of the -rcu tree:

aac385ea2494 rcu-tasks: Don't delete holdouts within trc_inspect_reader()
bf30dc63947c rcu-tasks: Don't delete holdouts within trc_wait_for_one_reader()

They pass initial testing, but then again, such tests passed before
these patches were queued.  :-/

							Thanx, Paul
