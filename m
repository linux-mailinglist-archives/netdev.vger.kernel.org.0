Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B832DB3AD
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 19:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731560AbgLOSX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 13:23:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731534AbgLOSX3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 13:23:29 -0500
Date:   Tue, 15 Dec 2020 10:22:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608056568;
        bh=QPrErB5DMDQIIkF9V+Ie0fJXxDat+232EdenUKSeBSs=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=KWuMsYDIjqWHsxQvud7m9sdHgw7mSYKUSIbCUKHAlV19RXkHQcf4T7UbUy0HQYAll
         sBwOzEGkQcL8NDxf4qhZSUDzjmbpilZbZKOKTjSYifH7Z67MiN522UA3h0c8sUKJLr
         CP9NP4X8FQHU36xrIufIUx1pZaP/f/5lw7IsuzxCYGaldU57gdoKaq9b9MA/2iK0dx
         VrDsJz+nBpR5GGNS8n0gCfwOCqd+DcmynZEnF/0nGMtDMJQJRComYTZdwqhi9mMIk7
         V0xo/LGcsBYLAaqPl/Nbg5vjaMFaxbWdIZE/abIoworzR88qT2XpI/sXmfOLGDfgkl
         zm5GECZO0ya6Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>, rcu@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [stabe-rc 5.9 ] sched: core.c:7270 Illegal context switch in
 RCU-bh read-side critical section!
Message-ID: <20201215102246.4bdca3d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215144531.GZ2657@paulmck-ThinkPad-P72>
References: <CA+G9fYtu1zOz8ErUzftNG4Dc9=cv1grsagBojJraGhm4arqXyw@mail.gmail.com>
        <20201215144531.GZ2657@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 06:45:31 -0800 Paul E. McKenney wrote:
> > Crash log:
> > --------------
> > # selftests: bpf: test_tc_edt.sh
> > [  503.796362]
> > [  503.797960] =============================
> > [  503.802131] WARNING: suspicious RCU usage
> > [  503.806232] 5.9.15-rc1 #1 Tainted: G        W
> > [  503.811358] -----------------------------
> > [  503.815444] /usr/src/kernel/kernel/sched/core.c:7270 Illegal
> > context switch in RCU-bh read-side critical section!
> > [  503.825858]
> > [  503.825858] other info that might help us debug this:
> > [  503.825858]
> > [  503.833998]
> > [  503.833998] rcu_scheduler_active = 2, debug_locks = 1
> > [  503.840981] 3 locks held by kworker/u12:1/157:
> > [  503.845514]  #0: ffff0009754ed538
> > ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x208/0x768
> > [  503.855048]  #1: ffff800013e63df0 (net_cleanup_work){+.+.}-{0:0},
> > at: process_one_work+0x208/0x768
> > [  503.864201]  #2: ffff8000129fe3f0 (pernet_ops_rwsem){++++}-{3:3},
> > at: cleanup_net+0x64/0x3b8
> > [  503.872786]
> > [  503.872786] stack backtrace:
> > [  503.877229] CPU: 1 PID: 157 Comm: kworker/u12:1 Tainted: G        W
> >         5.9.15-rc1 #1
> > [  503.885433] Hardware name: ARM Juno development board (r2) (DT)
> > [  503.891382] Workqueue: netns cleanup_net
> > [  503.895324] Call trace:
> > [  503.897786]  dump_backtrace+0x0/0x1f8
> > [  503.901464]  show_stack+0x2c/0x38
> > [  503.904796]  dump_stack+0xec/0x158
> > [  503.908215]  lockdep_rcu_suspicious+0xd4/0xf8
> > [  503.912591]  ___might_sleep+0x1e4/0x208  
> 
> You really are forbidden to invoke ___might_sleep() while in a BH-disable
> region of code, whether due to rcu_read_lock_bh(), local_bh_disable(),
> or whatever else.
> 
> I do see the cond_resched() in inet_twsk_purge(), but I don't immediately
> see a BH-disable region of code.  Maybe someone more familiar with this
> code would have some ideas.
> 
> Or you could place checks for being in a BH-disable further up in
> the code.  Or build with CONFIG_DEBUG_INFO=y to allow more precise
> interpretation of this stack trace.

My money would be on the option that whatever run on this workqueue
before forgot to re-enable BH, but we already have a check for that...
Naresh, do you have the full log? Is there nothing like "BUG: workqueue
leaked lock" above the splat?
