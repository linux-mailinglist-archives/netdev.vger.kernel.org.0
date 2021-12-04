Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D474685D6
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 16:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244389AbhLDPL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 10:11:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58140 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241868AbhLDPL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 10:11:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0300CB80CF8;
        Sat,  4 Dec 2021 15:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A84C341C5;
        Sat,  4 Dec 2021 15:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638630479;
        bh=8DSniUTZJxl6IRNvVfvDMqEWm9tUkbvkoDNYA0T6EpY=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Rdi9zV15VDKa0CMzmMin5J0Py7RWjF2z+N4pK2OlxL/xsHCcKCkt23Fk6ffMWDRNd
         Hh9sYtPUOC0hJt7Ds0n+9SBlD5y73ffpOs0xKXriTxu71E20GdBMRL/vtwNbG3RbCF
         LeUcIL7TkvvUOk/zOYb8aizCY5a4pwkMcCwmS4Hj2TDROOvO8j/Gu1VYoOSYPDIper
         YuCb9s1hGk0jEByHQAMZYGjCiQHs6/iFx9tr8r8EKkJFI0cSaQ2AJYcWBU0TqvoDTh
         q3b5y0BVO6dCO0evc39zg+L+F5HV2FW7jN2IGHI7HPvOduv9qP4HDZPbnMvd8QEkkv
         7WiHscEqwvDUw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 718625C1010; Sat,  4 Dec 2021 07:07:59 -0800 (PST)
Date:   Sat, 4 Dec 2021 07:07:59 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+fe9d8c955bd1d0f02dc1@syzkaller.appspotmail.com>,
        bigeasy@linutronix.de, jgross@suse.com, jiangshanlai@gmail.com,
        joel@joelfernandes.org, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        mingo@kernel.org, namit@vmware.com, netdev@vger.kernel.org,
        peterz@infradead.org, rcu@vger.kernel.org, rdunlap@infradead.org,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING in trc_read_check_handler
Message-ID: <20211204150759.GW641268@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <00000000000069924b05c8cc3b84@google.com>
 <000000000000b7e3ee05d21bd19d@google.com>
 <20211201210938.GL641268@paulmck-ThinkPad-P17-Gen-1>
 <CACT4Y+bLs5ycD1khkbMFDW=5UxMqxmbkXQoskyEz74H-u98pDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+bLs5ycD1khkbMFDW=5UxMqxmbkXQoskyEz74H-u98pDw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 10:50:47AM +0100, Dmitry Vyukov wrote:
> On Wed, 1 Dec 2021 at 22:09, Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Wed, Dec 01, 2021 at 12:50:07PM -0800, syzbot wrote:
> > > syzbot suspects this issue was fixed by commit:
> > >
> > > commit 96017bf9039763a2e02dcc6adaa18592cd73a39d
> > > Author: Paul E. McKenney <paulmck@kernel.org>
> > > Date:   Wed Jul 28 17:53:41 2021 +0000
> > >
> > >     rcu-tasks: Simplify trc_read_check_handler() atomic operations
> > >
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1281d89db00000
> > > start commit:   5319255b8df9 selftests/bpf: Skip verifier tests that fail ..
> > > git tree:       bpf-next
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=9290a409049988d4
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=fe9d8c955bd1d0f02dc1
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14990477300000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105ebd84b00000
> > >
> > > If the result looks correct, please mark the issue as fixed by replying with:
> >
> > #syz fix: rcu-tasks: Simplify trc_read_check_handler() atomic operations
> >
> > > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> >
> > Give or take.  There were quite a few related bugs, so some or all of
> > the following commits might also have helped:
> >
> > cbe0d8d91415c rcu-tasks: Wait for trc_read_check_handler() IPIs
> > 18f08e758f34e rcu-tasks: Add trc_inspect_reader() checks for exiting critical section
> > 46aa886c483f5 rcu-tasks: Fix IPI failure handling in trc_wait_for_one_reader
> 
> Thanks for checking. If we don't have one exact fix, let's go with
> what syzbot suggested. At this point it does not matter much since all
> of them are in most trees I assume. We just need to close the bug with
> something.
> 
> #syz fix: rcu-tasks: Simplify trc_read_check_handler() atomic operations

Fair enough!

> > Quibbles aside, it is nice to get an automated email about having fixed
> > a bug as opposed to having added one.  ;-)
> 
> Yes, but one is not possible without the other :-)

But of course it is possible!  For example, syzkaller might find a bug
that was already fixed, and then before notifying me about the bug, you
see the fix.  For example, by failing to reproduce a mainline bug on -rcu.

Not that I particularly want to be auto-spammed about bugs that I have
already fixed, mind you!  ;-)

							Thanx, Paul
