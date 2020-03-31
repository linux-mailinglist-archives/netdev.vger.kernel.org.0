Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25531989FB
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 04:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgCaCaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 22:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbgCaCaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 22:30:10 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D07020714;
        Tue, 31 Mar 2020 02:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585621810;
        bh=FD8CgPWAQX9TSNL4nh1PkXKlh/qf4FGMjtfo2zUOUoI=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Oe4+x0x65ZcAipe2HBifzbL8TaluBoCtbDYWCEIzAvG2VgnqueZS1FQWVkrjubsIx
         oreJSJsfQiWQe8EMHfq3ArGIBdxKwsDTYHDaV3bAgivsKoAMrSx6usGD+Zy83S5dQI
         rbl7ve2asZ1iImrYpi0fd4s6+e7v8IEAAy1BhNLc=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 097F03523148; Mon, 30 Mar 2020 19:30:10 -0700 (PDT)
Date:   Mon, 30 Mar 2020 19:30:10 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: add a temporary refcnt for struct
 tcindex_data
Message-ID: <20200331023009.GI19865@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200328191259.17145-1-xiyou.wangcong@gmail.com>
 <20200330213514.GT19865@paulmck-ThinkPad-P72>
 <CAM_iQpUu6524ZyZDBu=nkuhpubyGBTHEJ-HK8qrpCW=EEKGujw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUu6524ZyZDBu=nkuhpubyGBTHEJ-HK8qrpCW=EEKGujw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 04:24:42PM -0700, Cong Wang wrote:
> On Mon, Mar 30, 2020 at 2:35 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Sat, Mar 28, 2020 at 12:12:59PM -0700, Cong Wang wrote:
> > > Although we intentionally use an ordered workqueue for all tc
> > > filter works, the ordering is not guaranteed by RCU work,
> > > given that tcf_queue_work() is esstenially a call_rcu().
> > >
> > > This problem is demostrated by Thomas:
> > >
> > >   CPU 0:
> > >     tcf_queue_work()
> > >       tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> > >
> > >   -> Migration to CPU 1
> > >
> > >   CPU 1:
> > >      tcf_queue_work(&p->rwork, tcindex_destroy_work);
> > >
> > > so the 2nd work could be queued before the 1st one, which leads
> > > to a free-after-free.
> > >
> > > Enforcing this order in RCU work is hard as it requires to change
> > > RCU code too. Fortunately we can workaround this problem in tcindex
> > > filter by taking a temporary refcnt, we only refcnt it right before
> > > we begin to destroy it. This simplifies the code a lot as a full
> > > refcnt requires much more changes in tcindex_set_parms().
> > >
> > > Reported-by: syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com
> > > Fixes: 3d210534cc93 ("net_sched: fix a race condition in tcindex_destroy()")
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Paul E. McKenney <paulmck@kernel.org>
> > > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > > Cc: Jiri Pirko <jiri@resnulli.us>
> > > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> >
> > Looks plausible, but what did you do to verify that the structures
> > were in fact being freed?  See below for more detail.
> 
> I ran the syzbot reproducer for about 20 minutes, there was no
> memory leak reported after scanning.

And if you (say) set the initial reference count to two instead of one,
there is a memory leak reported, correct?

							Thanx, Paul
