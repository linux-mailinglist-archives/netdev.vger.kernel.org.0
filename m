Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DBD4155BF
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238965AbhIWDE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:04:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238914AbhIWDE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 23:04:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632366204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wud0mbVOd87a6R67icIKZ1G5DitrJve2cTW9a5xlpqg=;
        b=ULW/qfBe9hf6+F8zfeiOQiRcyvwAJ2LKa9jQVlRWNbNvVKd0KlIa1LXlV3L0LOvy2iB6lJ
        6XqKcTQlI/Y18UBIsSagpfQtWHHOsWkRYuc800RzlNCQSP2c9+i7nCkewWdjyCk8ufuBWk
        uyUBxOX3Zy/1/s2NupIny1wRfZtz0HM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-PGPSvEgsNju-TEQcLkBYKA-1; Wed, 22 Sep 2021 23:03:23 -0400
X-MC-Unique: PGPSvEgsNju-TEQcLkBYKA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5A5A1808311;
        Thu, 23 Sep 2021 03:03:21 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B92D75F706;
        Thu, 23 Sep 2021 03:03:11 +0000 (UTC)
Date:   Thu, 23 Sep 2021 11:03:23 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        syzbot <syzbot+a10a3d280be23be45d04@syzkaller.appspotmail.com>,
        axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING: ODEBUG bug in blk_mq_hw_sysfs_release
Message-ID: <YUvue9IEtXsX/rT6@T590>
References: <000000000000bd3a8005cc78ce14@google.com>
 <87mto4gqxk.ffs@tglx>
 <20210922232702.GE880162@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922232702.GE880162@paulmck-ThinkPad-P17-Gen-1>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 04:27:02PM -0700, Paul E. McKenney wrote:
> On Thu, Sep 23, 2021 at 12:56:39AM +0200, Thomas Gleixner wrote:
> > On Mon, Sep 20 2021 at 20:15, syzbot wrote:
> > 
> > Cc+: paulmck
> > 
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    85c698863c15 net/ipv4/tcp_minisocks.c: remove superfluous ..
> > > git tree:       net-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=13d9d3e7300000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=6d93fe4341f98704
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=a10a3d280be23be45d04
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11bd98f7300000
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+a10a3d280be23be45d04@syzkaller.appspotmail.com
> > >
> > > ------------[ cut here ]------------
> > > ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
> > > WARNING: CPU: 0 PID: 3816 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> > > Modules linked in:
> > > CPU: 0 PID: 3816 Comm: syz-executor.0 Not tainted 5.15.0-rc1-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> > > Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd c0 39 e4 89 4c 89 ee 48 c7 c7 c0 2d e4 89 e8 ef e3 14 05 <0f> 0b 83 05 35 09 91 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
> > > RSP: 0018:ffffc9000a6770f0 EFLAGS: 00010282
> > > RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
> > > RDX: ffff88805b3db900 RSI: ffffffff815dbd88 RDI: fffff520014cee10
> > > RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> > > R10: ffffffff815d5b2e R11: 0000000000000000 R12: ffffffff898de180
> > > R13: ffffffff89e43440 R14: ffffffff8164bae0 R15: 1ffff920014cee29
> > > FS:  00007fee66b3a700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007f362471f3a0 CR3: 00000000272af000 CR4: 00000000001506f0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  debug_object_assert_init lib/debugobjects.c:895 [inline]
> > >  debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:866
> > >  debug_timer_assert_init kernel/time/timer.c:739 [inline]
> > >  debug_assert_init kernel/time/timer.c:784 [inline]
> > >  try_to_del_timer_sync+0x6d/0x110 kernel/time/timer.c:1229
> > >  del_timer_sync+0x138/0x1b0 kernel/time/timer.c:1382
> > >  cleanup_srcu_struct+0x14c/0x2f0 kernel/rcu/srcutree.c:379
> > 
> > So cleanup_srcu_struct() tries to delete a timer which was never initialized....
> 
> That does not sound like a way to keep a kernel running...
> 
> For dynamically allocated srcu_struct structures, what is supposed to
> happen is that init_srcu_struct() is invoked at some point before the
> first use.  Then init_srcu_struct() invokes init_srcu_struct_fields()
> which invokes init_srcu_struct_nodes() which initializes that timer.
> Unless the memory allocations in init_srcu_struct_fields() failed,
> in which case init_srcu_struct() should have handed you back a -ENOMEM.
> 
> OK, there is a call to init_srcu_struct() in blk_mq_alloc_hctx().
> It does ignore the init_srcu_struct() return value, so maybe a
> WARN_ON_ONCE(init_srcu_struct(hctx->srcu)) would be good.

Yeah.

That should be the issue because del_timer_sync() from flush_delayed_work() in
cleanup_srcu_struct() isn't complained from the stack trace log, and
just the timer in perpcu field of ->sda isn't initialized, and ->sda is
allocated via alloc_percpu().

> 
> The ->srcu field is declared as follows:
> 
> 	struct srcu_struct	srcu[];
> 
> The blk_mq_hw_ctx_size() function adjusts the size.  All of this is
> controlled by a BLK_MQ_F_BLOCKING flag.  If this flag were to change,
> clearly bad things could happen.  The places where it is set look to me
> to be initialization time, but it might be good to have someone familiar
> with this code double-check this.  Or have a separate bit that records
> the state of BLK_MQ_F_BLOCKING at blk_mq_alloc_hctx() time and complain
> bitterly if there was a change at blk_mq_hw_sysfs_release() time.

BLK_MQ_F_BLOCKING is set from the beginning and never changed.


Thanks,
Ming

