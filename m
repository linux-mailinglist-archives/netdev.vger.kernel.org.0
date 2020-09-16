Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1422626CAD1
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgIPUNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbgIPRdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:33:14 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA66EC02C2AD;
        Wed, 16 Sep 2020 09:03:24 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 30C2D689F; Wed, 16 Sep 2020 12:03:16 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 30C2D689F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1600272196;
        bh=AhbQil9hi1jajqnwwBoDpoEkSw6sqlLr283ReFc5xQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oGFyz4comJG6R79ISTIV5cstLTo7DBCtV3gmkUf2vHJHQue7W9VeVwmdy+Dqp2ucR
         gc1fU3CQra+Ebnqq67PfhQ2EkkLC5VhhQcXeZdIQb3xyWM1iBUU7TXG+MbbMZiejrz
         E1/Wi9MFGcYe+jJfw4dnRGXPvS+jDFiftMA3szxs=
Date:   Wed, 16 Sep 2020 12:03:16 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     syzbot <syzbot+1594adb1b44e354153d8@syzkaller.appspotmail.com>
Cc:     anna.schumaker@netapp.com, chuck.lever@oracle.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, trond.myklebust@hammerspace.com
Subject: Re: general protection fault in cache_clean
Message-ID: <20200916160316.GA4560@fieldses.org>
References: <0000000000002b3ac605af559958@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002b3ac605af559958@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 01:04:20AM -0700, syzbot wrote:
> syzbot found the following issue on:
> 
> HEAD commit:    581cb3a2 Merge tag 'f2fs-for-5.9-rc5' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11f5c011900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a9075b36a6ae26c9
> dashboard link: https://syzkaller.appspot.com/bug?extid=1594adb1b44e354153d8
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1594adb1b44e354153d8@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0012e34a9a: 0000 [#1] PREEMPT SMP KASAN
> KASAN: probably user-memory-access in range [0x00000000971a54d0-0x00000000971a54d7]
> CPU: 1 PID: 19990 Comm: kworker/1:11 Not tainted 5.9.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events_power_efficient do_cache_clean
> RIP: 0010:cache_clean+0x119/0x7f0 net/sunrpc/cache.c:444

That's in cache_clean():
	spin_lock(&cache_list_lock);
	...
	current_detail = list_entry(next, struct cache_detail, others)
444:	if (current_detail->nextcheck > seconds_since_boot())

It suggests cache_list or current_detail (both globals) are corrupted
somehow.

Those are manipulated only by cache_clean() and
sunrpc_{init,destroy}_cache_detail(), always under the cache_list_lock.

All the callers have to do to get this right is make sure the
cache_detail they pass in is allocated before calling
sunrpc_init_cache_detail() and not freed till after calling
sunrpc_destroy_cache_detail().  I think they all get that right.

So I'm assuming this is a random memory scribble from somewhere else or
something, unless it pops up again....

(The one thing I'm a little unsure of here is the
list_empty(&cache_list) checks used to decide when to stop the
cache_cleaner.  But that's a separate problem, if it is a problem.)

--b.


> Code: 81 fb 20 eb 94 8a 0f 84 b8 00 00 00 e8 80 df 33 fa 48 8d 83 40 ff ff ff 48 8d 7b 10 48 89 05 8e 8e 13 06 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 0f 85 e0 05 00 00 48 8d 6c 24 38 4c 8b 63 10 48 89
> RSP: 0018:ffffc90008e1fc48 EFLAGS: 00010206
> RAX: 0000000012e34a9a RBX: 00000000971a54c0 RCX: ffffffff87406dbb
> RDX: ffff88804358a000 RSI: ffffffff87406e00 RDI: 00000000971a54d0
> RBP: 0000000000000100 R08: 0000000000000001 R09: 0000000000000003
> R10: 0000000000000100 R11: 0000000000000000 R12: 0000000000000100
> R13: dffffc0000000000 R14: ffff88803451b200 R15: ffff8880ae735600
> FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004ef310 CR3: 000000009ca1b000 CR4: 00000000001526e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  do_cache_clean+0xd/0xd0 net/sunrpc/cache.c:502
>  process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
>  kthread+0x3b5/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> Modules linked in:
> ---[ end trace 4c54bbd0e20d734b ]---
> RIP: 0010:cache_clean+0x119/0x7f0 net/sunrpc/cache.c:444
> Code: 81 fb 20 eb 94 8a 0f 84 b8 00 00 00 e8 80 df 33 fa 48 8d 83 40 ff ff ff 48 8d 7b 10 48 89 05 8e 8e 13 06 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 0f 85 e0 05 00 00 48 8d 6c 24 38 4c 8b 63 10 48 89
> RSP: 0018:ffffc90008e1fc48 EFLAGS: 00010206
> RAX: 0000000012e34a9a RBX: 00000000971a54c0 RCX: ffffffff87406dbb
> RDX: ffff88804358a000 RSI: ffffffff87406e00 RDI: 00000000971a54d0
> RBP: 0000000000000100 R08: 0000000000000001 R09: 0000000000000003
> R10: 0000000000000100 R11: 0000000000000000 R12: 0000000000000100
> R13: dffffc0000000000 R14: ffff88803451b200 R15: ffff8880ae735600
> FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004ef310 CR3: 000000009ca1b000 CR4: 00000000001526e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
