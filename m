Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2E8CE352
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbfJGNWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbfJGNWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 09:22:23 -0400
Received: from paulmck-ThinkPad-P72 (unknown [12.12.162.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 821E820867;
        Mon,  7 Oct 2019 13:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570454541;
        bh=94FgQQQInriYcdaiwu3nO9LUTD1ig1lcCMAvKOjrqC4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Wu2tRRwWmif60CLvRIfmXIIdxFUVzY/DAMy3D3xiCP2QeY68YVmor0hUkkGfC6XNh
         HQ5HFPMwKqUTAOkE6hahJ8U/4Hip40f10Qx+/7iXubKwJtAux+CmTvfJi1CdRQvyIk
         OJTLt4gus3H0Mindd4qm+p3wqKrjbVvaKu+k86uM=
Date:   Mon, 7 Oct 2019 06:22:20 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Marco Elver <elver@google.com>
Cc:     syzbot <syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com>,
        josh@joshtriplett.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Subject: Re: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
Message-ID: <20191007132220.GZ2689@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <000000000000604e8905944f211f@google.com>
 <CANpmjNNmSOagbTpffHr4=Yedckx9Rm2NuGqC9UqE+AOz5f1-ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNmSOagbTpffHr4=Yedckx9Rm2NuGqC9UqE+AOz5f1-ZQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 12:04:16PM +0200, Marco Elver wrote:
> +RCU maintainers
> This might be a data-race in RCU itself.

Quite possibly.  I will take a look, but there will be delays due to this
week being bootcamp and all.

							Thanx, Paul

> On Mon, 7 Oct 2019 at 12:01, syzbot
> <syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    b4bd9343 x86, kcsan: Enable KCSAN for x86
> > git tree:       https://github.com/google/ktsan.git kcsan
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11edb20d600000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=c0906aa620713d80
> > dashboard link: https://syzkaller.appspot.com/bug?extid=134336b86f728d6e55a0
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com
> >
> > ==================================================================
> > BUG: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
> >
> > write to 0xffffffff85a7f140 of 8 bytes by task 7 on cpu 0:
> >   rcu_report_exp_cpu_mult+0x4f/0xa0 kernel/rcu/tree_exp.h:244
> >   rcu_report_exp_rdp+0x6c/0x90 kernel/rcu/tree_exp.h:254
> >   rcu_preempt_deferred_qs_irqrestore+0x3bb/0x580 kernel/rcu/tree_plugin.h:475
> >   rcu_read_unlock_special+0xec/0x370 kernel/rcu/tree_plugin.h:659
> >   __rcu_read_unlock+0xcf/0xe0 kernel/rcu/tree_plugin.h:394
> >   rcu_read_unlock include/linux/rcupdate.h:645 [inline]
> >   batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:411 [inline]
> >   batadv_nc_worker+0x13a/0x390 net/batman-adv/network-coding.c:718
> >   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
> >   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
> >   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
> >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
> >
> > read to 0xffffffff85a7f140 of 8 bytes by task 7251 on cpu 1:
> >   _find_next_bit lib/find_bit.c:39 [inline]
> >   find_next_bit+0x57/0xe0 lib/find_bit.c:70
> >   sync_rcu_exp_select_node_cpus+0x28e/0x510 kernel/rcu/tree_exp.h:375
> >   sync_rcu_exp_select_cpus+0x30c/0x590 kernel/rcu/tree_exp.h:439
> >   rcu_exp_sel_wait_wake kernel/rcu/tree_exp.h:575 [inline]
> >   wait_rcu_exp_gp+0x25/0x40 kernel/rcu/tree_exp.h:589
> >   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
> >   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
> >   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
> >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
> >
> > Reported by Kernel Concurrency Sanitizer on:
> > CPU: 1 PID: 7251 Comm: kworker/1:4 Not tainted 5.3.0+ #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Workqueue: rcu_gp wait_rcu_exp_gp
> > ==================================================================
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
