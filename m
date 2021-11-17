Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A654542C9
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 09:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhKQImG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 03:42:06 -0500
Received: from 163-172-96-212.rev.poneytelecom.eu ([163.172.96.212]:46544 "EHLO
        1wt.eu" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhKQImG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 03:42:06 -0500
X-Greylist: delayed 1191 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Nov 2021 03:42:05 EST
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 1AH8J7Tx006680;
        Wed, 17 Nov 2021 09:19:07 +0100
Date:   Wed, 17 Nov 2021 09:19:07 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     syzbot <syzbot+6f8ddb9f2ff4adf065cb@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING: refcount bug in __linkwatch_run_queue
Message-ID: <20211117081907.GA6276@1wt.eu>
References: <000000000000e4810705d0e479d5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000e4810705d0e479d5@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 01:23:19AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    fa55b7dcdc43 Linux 5.16-rc1
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=109339e1b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6c3ab72998e7f1a4
> dashboard link: https://syzkaller.appspot.com/bug?extid=6f8ddb9f2ff4adf065cb
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6f8ddb9f2ff4adf065cb@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> refcount_t: decrement hit 0; leaking memory.
> WARNING: CPU: 1 PID: 26140 at lib/refcount.c:31 refcount_warn_saturate+0x17c/0x1a0 lib/refcount.c:31
> Modules linked in:
> CPU: 1 PID: 26140 Comm: kworker/1:26 Not tainted 5.16.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events linkwatch_event
> RIP: 0010:refcount_warn_saturate+0x17c/0x1a0 lib/refcount.c:31
> Code: f4 8a 31 c0 e8 f5 45 38 fd 0f 0b e9 64 ff ff ff e8 49 6a 6e fd c6 05 06 40 f5 09 01 48 c7 c7 80 fe f4 8a 31 c0 e8 d4 45 38 fd <0f> 0b e9 43 ff ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c a2 fe ff
> RSP: 0018:ffffc90003537b68 EFLAGS: 00010246
> RAX: 26aa35cdf4075e00 RBX: 0000000000000004 RCX: ffff88803baaba00
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: 0000000000000004 R08: ffffffff8169fb82 R09: ffffed10173667b1
> R10: ffffed10173667b1 R11: 0000000000000000 R12: ffff88807ccac000
> R13: 1ffff1100f9958b7 R14: 1ffff1100f9958b8 R15: ffff88807ccac5b8
> FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f217b0e6740 CR3: 0000000019e96000 CR4: 00000000003526e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000000ff46
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __linkwatch_run_queue+0x4f5/0x800 net/core/link_watch.c:213
>  linkwatch_event+0x48/0x50 net/core/link_watch.c:252
>  process_one_work+0x853/0x1140 kernel/workqueue.c:2298
>  worker_thread+0xac1/0x1320 kernel/workqueue.c:2445
>  kthread+0x468/0x490 kernel/kthread.c:327
>  ret_from_fork+0x1f/0x30
>  </TASK>

Thanks for the report. I'm seeing that linkwatch_do_dev() is also
called in linkwatch_forget_dev(), and am wondering if we're not
seeing a sequence like this one:

  linkwatch_forget_dev()
    list_del_init()
    linkwatch_do_dev()
      netdev_state_change()
        ... one of the notifiers
           ... linkwatch_add_event() => adds to watch list
      dev_put()
  ...
  
  __linkwatch_run_queue()
    linkwatch_do_dev()
      dev_put()
        => bang!

Well, in theory, no, since linkwatch_add_event() will call dev_hold()
when adding to the list, so we ought to leave the first call with a
refcount still covering the list's presence, and I don't see how it
can reach zero before reaching dev_put() in linkwatch_do_dev() as this
function is only called when the event was picked from the list.

The only difference I'm seeing is that before the patch, a call to
linkwatch_forget_dev() on a non-present device would call dev_put()
without going through dev_activate(), dev_deactivate(), nor
netdev_state_change(), but I'm not seeing how that could make a
difference. linkwatch_forget_dev() is called from netdev_wait_allrefs()
which will wait for the refcnt to be exactly 1, thus even if we queue
an extra event we cant leave that function until the event has been
processed.

Thus for now I'm puzzled :-/

Willy
