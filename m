Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100D72DAFA9
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 16:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbgLOOq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:46:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729673AbgLOOqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 09:46:13 -0500
Date:   Tue, 15 Dec 2020 06:45:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608043531;
        bh=hkpf31UFUYyRxiF6BbOpG60WCQtb0yuT2eROaMYIk5Q=;
        h=From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=oSv5SBsQhJpCuad94J3BmrL3IXIFGnarQv6YUL5zDK9G1ii8n+GoaxnxhE6WEd4Fb
         uIYUQ+SUesWdCzXggoVvDKQvwu/3hS1bxkUw/sxrNI+lTjgmUuLX4PLF+cY+rnekqt
         vQmw6aQTgkxEYO71TEhAseKXPKFcSWccZN0DLY/RR2vS3PBlnXRFjNvTjIeZZ8hg78
         Xusvdxgjxtu98dpohJHGTb8JoRNd9haXugQue6Ru7avlCXinrrRQwFlIScdRB/qtlf
         mF46nqMGbjV5ymrEYza61FS+JTjpoWKh4PMUGM5akdN5FZmTW7dCBdssOKJQNVSlxS
         sysaA7xn5dqYA==
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
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
Message-ID: <20201215144531.GZ2657@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <CA+G9fYtu1zOz8ErUzftNG4Dc9=cv1grsagBojJraGhm4arqXyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtu1zOz8ErUzftNG4Dc9=cv1grsagBojJraGhm4arqXyw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 07:50:31AM +0530, Naresh Kamboju wrote:
> There are two warnings "WARNING: suspicious RCU usage" noticed on arm64 juno-r2
> device while running selftest bpf test_tc_edt.sh and net: udpgro_bench.sh.
> These warnings are occurring intermittently.
> 
> metadata:
>   git branch: linux-5.9.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git describe: v5.9.14-106-g609d95a95925
>   make_kernelversion: 5.9.15-rc1
>   kernel-config:
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/linux-stable-rc-5.9/58/config
> 
> 
> Steps to reproduce:
> ------------------
> Not easy to reproduce.
> 
> Crash log:
> --------------
> # selftests: bpf: test_tc_edt.sh
> [  503.796362]
> [  503.797960] =============================
> [  503.802131] WARNING: suspicious RCU usage
> [  503.806232] 5.9.15-rc1 #1 Tainted: G        W
> [  503.811358] -----------------------------
> [  503.815444] /usr/src/kernel/kernel/sched/core.c:7270 Illegal
> context switch in RCU-bh read-side critical section!
> [  503.825858]
> [  503.825858] other info that might help us debug this:
> [  503.825858]
> [  503.833998]
> [  503.833998] rcu_scheduler_active = 2, debug_locks = 1
> [  503.840981] 3 locks held by kworker/u12:1/157:
> [  503.845514]  #0: ffff0009754ed538
> ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x208/0x768
> [  503.855048]  #1: ffff800013e63df0 (net_cleanup_work){+.+.}-{0:0},
> at: process_one_work+0x208/0x768
> [  503.864201]  #2: ffff8000129fe3f0 (pernet_ops_rwsem){++++}-{3:3},
> at: cleanup_net+0x64/0x3b8
> [  503.872786]
> [  503.872786] stack backtrace:
> [  503.877229] CPU: 1 PID: 157 Comm: kworker/u12:1 Tainted: G        W
>         5.9.15-rc1 #1
> [  503.885433] Hardware name: ARM Juno development board (r2) (DT)
> [  503.891382] Workqueue: netns cleanup_net
> [  503.895324] Call trace:
> [  503.897786]  dump_backtrace+0x0/0x1f8
> [  503.901464]  show_stack+0x2c/0x38
> [  503.904796]  dump_stack+0xec/0x158
> [  503.908215]  lockdep_rcu_suspicious+0xd4/0xf8
> [  503.912591]  ___might_sleep+0x1e4/0x208

You really are forbidden to invoke ___might_sleep() while in a BH-disable
region of code, whether due to rcu_read_lock_bh(), local_bh_disable(),
or whatever else.

I do see the cond_resched() in inet_twsk_purge(), but I don't immediately
see a BH-disable region of code.  Maybe someone more familiar with this
code would have some ideas.

Or you could place checks for being in a BH-disable further up in
the code.  Or build with CONFIG_DEBUG_INFO=y to allow more precise
interpretation of this stack trace.

							Thanx, Paul

> [  503.916444]  inet_twsk_purge+0x144/0x378
> [  503.920384]  tcpv6_net_exit_batch+0x20/0x28
> [  503.924585]  ops_exit_list.isra.10+0x78/0x88
> [  503.928872]  cleanup_net+0x248/0x3b8
> [  503.932462]  process_one_work+0x2b0/0x768
> [  503.936487]  worker_thread+0x48/0x498
> [  503.940166]  kthread+0x158/0x168
> [  503.943409]  ret_from_fork+0x10/0x1c
> [  504.165891] IPv6: ADDRCONF(NETDEV_CHANGE): veth_src: link becomes ready
> [  504.459624] audit: type=1334 audit(1607978673.070:40866):
> prog-id=20436 op=LOAD
> <>
> [  879.304684]
> [  879.306200] =============================
> [  879.310314] WARNING: suspicious RCU usage
> [  879.314420] 5.9.15-rc1 #1 Tainted: G        W
> [  879.319554] -----------------------------
> [  879.323644] /usr/src/kernel/kernel/sched/core.c:7270 Illegal
> context switch in RCU-sched read-side critical section!
> [  879.334259]
> [  879.334259] other info that might help us debug this:
> [  879.334259]
> [  879.342345]
> [  879.342345] rcu_scheduler_active = 2, debug_locks = 1
> [  879.348958] 3 locks held by kworker/u12:8/248:
> [  879.353483]  #0: ffff0009754ed538
> ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x208/0x768
> [  879.362910]  #1: ffff800013bc3df0 (net_cleanup_work){+.+.}-{0:0},
> at: process_one_work+0x208/0x768
> [  879.371984]  #2: ffff8000129fe3f0 (pernet_ops_rwsem){++++}-{3:3},
> at: cleanup_net+0x64/0x3b8
> [  879.380540]
> [  879.380540] stack backtrace:
> [  879.384998] CPU: 1 PID: 248 Comm: kworker/u12:8 Tainted: G        W
>         5.9.15-rc1 #1
> [  879.393201] Hardware name: ARM Juno development board (r2) (DT)
> [  879.399147] Workqueue: netns cleanup_net
> [  879.403089] Call trace:
> [  879.405550]  dump_backtrace+0x0/0x1f8
> [  879.409228]  show_stack+0x2c/0x38
> [  879.412561]  dump_stack+0xec/0x158
> # ud[  879.415980]  lockdep_rcu_suspicious+0xd4/0xf8
> [  879.420691]  ___might_sleep+0x1ac/0x208
> p tx:     32 MB/s      546 calls/[  879.424570]
> nf_ct_iterate_cleanup+0x1b8/0x2d8 [nf_conntrack]
> s    546 msg/s[  879.433190]  nf_conntrack_cleanup_net_list+0x58/0x100
> [nf_conntrack]
> 
> [  879.440765]  nf_conntrack_pernet_exit+0xa8/0xb8 [nf_conntrack]
> [  879.446755]  ops_exit_list.isra.10+0x78/0x88
> [  879.451043]  cleanup_net+0x248/0x3b8
> [  879.454635]  process_one_work+0x2b0/0x768
> [  879.458661]  worker_thread+0x48/0x498
> [  879.462340]  kthread+0x158/0x168
> [  879.465584]  ret_from_fork+0x10/0x1c
> 
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 
> Full test log link,
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.y/build/v5.9.14-106-g609d95a95925/testrun/3586574/suite/linux-log-parser/test/check-kernel-warning-2049484/log
> 
> 
> -- 
> Linaro LKFT
> https://lkft.linaro.org
