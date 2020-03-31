Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83EC199772
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 15:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgCaNag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 09:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730216AbgCaNaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 09:30:35 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAD6F2071A;
        Tue, 31 Mar 2020 13:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585661435;
        bh=uO/NKypA7LUmisthzrVdqB5I23GNQdepGZzQUNrR5Ic=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=pZYzaAH90sGaV9/3hpdSAshsRx3TBBdPDpYQpJZZMrKJ/EKxu5YknRgmf/1UCGhTp
         +t3E6HnMAI4xry2UmZF2oUKimQR4b0W3IKU5Mo8tMsCJRNBvAjs9e46ygI4bR0qUEg
         ZJ3CwKbifMUDZS9HX7CCFJ5HWsotXl0FalDB+NVQ=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id BAFBC352040B; Tue, 31 Mar 2020 06:30:34 -0700 (PDT)
Date:   Tue, 31 Mar 2020 06:30:34 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: add a temporary refcnt for struct
 tcindex_data
Message-ID: <20200331133034.GJ19865@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200328191259.17145-1-xiyou.wangcong@gmail.com>
 <20200330213514.GT19865@paulmck-ThinkPad-P72>
 <CAM_iQpUu6524ZyZDBu=nkuhpubyGBTHEJ-HK8qrpCW=EEKGujw@mail.gmail.com>
 <20200331023009.GI19865@paulmck-ThinkPad-P72>
 <CAM_iQpVrERPYoNNK+hywxLONEv3mF7f0Y37uMQ0gqVeR8E8kPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVrERPYoNNK+hywxLONEv3mF7f0Y37uMQ0gqVeR8E8kPQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 07:54:09PM -0700, Cong Wang wrote:
> On Mon, Mar 30, 2020 at 7:30 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Mon, Mar 30, 2020 at 04:24:42PM -0700, Cong Wang wrote:
> > > On Mon, Mar 30, 2020 at 2:35 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > > >
> > > > On Sat, Mar 28, 2020 at 12:12:59PM -0700, Cong Wang wrote:
> > > > > Although we intentionally use an ordered workqueue for all tc
> > > > > filter works, the ordering is not guaranteed by RCU work,
> > > > > given that tcf_queue_work() is esstenially a call_rcu().
> > > > >
> > > > > This problem is demostrated by Thomas:
> > > > >
> > > > >   CPU 0:
> > > > >     tcf_queue_work()
> > > > >       tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> > > > >
> > > > >   -> Migration to CPU 1
> > > > >
> > > > >   CPU 1:
> > > > >      tcf_queue_work(&p->rwork, tcindex_destroy_work);
> > > > >
> > > > > so the 2nd work could be queued before the 1st one, which leads
> > > > > to a free-after-free.
> > > > >
> > > > > Enforcing this order in RCU work is hard as it requires to change
> > > > > RCU code too. Fortunately we can workaround this problem in tcindex
> > > > > filter by taking a temporary refcnt, we only refcnt it right before
> > > > > we begin to destroy it. This simplifies the code a lot as a full
> > > > > refcnt requires much more changes in tcindex_set_parms().
> > > > >
> > > > > Reported-by: syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com
> > > > > Fixes: 3d210534cc93 ("net_sched: fix a race condition in tcindex_destroy()")
> > > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > > Cc: Paul E. McKenney <paulmck@kernel.org>
> > > > > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > > > > Cc: Jiri Pirko <jiri@resnulli.us>
> > > > > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > > >
> > > > Looks plausible, but what did you do to verify that the structures
> > > > were in fact being freed?  See below for more detail.
> > >
> > > I ran the syzbot reproducer for about 20 minutes, there was no
> > > memory leak reported after scanning.
> >
> > And if you (say) set the initial reference count to two instead of one,
> > there is a memory leak reported, correct?
> 
> No, I didn't do an A/B test. I just added a printk right before the kfree(),
> if it helps to convince you, here is one portion of the kernel log:
> 
> [   39.159298] a.out (703) used greatest stack depth: 11624 bytes left
> [   39.166365] a.out (701) used greatest stack depth: 11352 bytes left
> [   39.453257] freeing struct tcindex_data.
> [   39.573554] freeing struct tcindex_data.
> [   39.681540] freeing struct tcindex_data.
> [   39.781158] freeing struct tcindex_data.
> [   39.877726] freeing struct tcindex_data.
> [   39.985515] freeing struct tcindex_data.
> [   40.097687] freeing struct tcindex_data.
> [   40.213691] freeing struct tcindex_data.
> [   40.271465] device bridge_slave_1 left promiscuous mode
> [   40.274078] bridge0: port 2(bridge_slave_1) entered disabled state
> [   40.297258] device bridge_slave_0 left promiscuous mode
> [   40.299377] bridge0: port 1(bridge_slave_0) entered disabled state
> [   40.733355] device hsr_slave_0 left promiscuous mode
> [   40.749322] device hsr_slave_1 left promiscuous mode
> [   40.784220] team0 (unregistering): Port device team_slave_1 removed
> [   40.792641] team0 (unregistering): Port device team_slave_0 removed
> [   40.806302] bond0 (unregistering): (slave bond_slave_1): Releasing
> backup interface
> [   40.836972] bond0 (unregistering): (slave bond_slave_0): Releasing
> backup interface
> [   40.931688] bond0 (unregistering): Released all slaves
> [   44.149970] freeing struct tcindex_data.
> [   44.159568] freeing struct tcindex_data.
> [   44.172786] freeing struct tcindex_data.
> [   44.813214] freeing struct tcindex_data.
> [   44.821857] freeing struct tcindex_data.
> [   44.825064] freeing struct tcindex_data.
> [   44.826889] freeing struct tcindex_data.
> [   45.294254] freeing struct tcindex_data.
> [   45.297980] freeing struct tcindex_data.
> [   45.300623] freeing struct tcindex_data.
> 
> And no memory leak of course:
> 
> [root@localhost tmp]# echo scan > /sys/kernel/debug/kmemleak
> [root@localhost tmp]# echo scan > /sys/kernel/debug/kmemleak
> [root@localhost tmp]# cat /sys/kernel/debug/kmemleak

Much more convincing, thank you!

Feel free to add:

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

							Thanx, Paul
