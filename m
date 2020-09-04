Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2817825D6AA
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 12:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbgIDKn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 06:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgIDKnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 06:43:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E95C061244;
        Fri,  4 Sep 2020 03:43:50 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599216228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MnGIfosYk6cuOJ5u1p3Q4PQ2dvvUjoREuzlxSo4dxaU=;
        b=npUgoxul9PeKnpU46ohfOIOenC8OyKgAAAuF84mB0KxUTVR6zXC/G8rLE9mWnUL+URwNbg
        4WFwC1yAfM1Cii3LGhQrjWj3jICfT8lleYwAdj+jOwZc4R4pYXxlDuC0hizto+evJhULwd
        R/TjQ1cVa/ZP5qXw4Cp9UJoQDUBczJCesM65sR8sGE59pj39gs97c2IZI6lmezd5GAiADB
        D9mRKLaPeiMM3ZhQfUQRKYiCXUjWzhr/VOMj2J8eMj6xwtLgKsXiitvJq7XIjuSzYpbl8O
        rCnyQWvzIT3zxWHO4/DgBqLtLfw9dSPSVOiVySD501sJBD292ddzYBM/oRFAow==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599216228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MnGIfosYk6cuOJ5u1p3Q4PQ2dvvUjoREuzlxSo4dxaU=;
        b=tO8UNn6rGH+CSrtxAn8YdA2fKMBnK+kSk+arlcDrSMt1DdcT4Ph7T2vp7h6QyqWTEoOOKW
        /oJcLxg+Z3fLDcBQ==
To:     syzbot <syzbot+91923aae0b157bd6c0c5@syzkaller.appspotmail.com>,
        elver@google.com, linux-kernel@vger.kernel.org,
        miaoqinglang@huawei.com, syzkaller-bugs@googlegroups.com
Cc:     trond.myklebust@hammerspace.com,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: WARNING: ODEBUG bug in process_one_work (2)
In-Reply-To: <0000000000001c3dac05ae58a990@google.com>
References: <0000000000001c3dac05ae58a990@google.com>
Date:   Fri, 04 Sep 2020 12:43:47 +0200
Message-ID: <87h7sd4yak.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02 2020 at 11:18, syzbot wrote:

Cc+: Relevant maintainers

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    4d41ead6 Merge tag 'block-5.9-2020-08-28' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1196ce61900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=978db74cb30aa994
> dashboard link: https://syzkaller.appspot.com/bug?extid=91923aae0b157bd6c0c5
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11b1cbb6900000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+91923aae0b157bd6c0c5@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> ODEBUG: free active (active state 0) object type: timer_list hint: xprt_init_autodisconnect+0x0/0x150 include/linux/refcount.h:274
> WARNING: CPU: 1 PID: 8854 at lib/debugobjects.c:485 debug_print_object+0x160/0x250 lib/debugobjects.c:485

xprt->timer is still armed at the time when RCU frees xprt....

> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 8854 Comm: kworker/1:10 Not tainted 5.9.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events kfree_rcu_work
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  panic+0x2e3/0x75c kernel/panic.c:231
>  __warn.cold+0x20/0x4a kernel/panic.c:600
>  report_bug+0x1bd/0x210 lib/bug.c:198
>  handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
>  exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
>  asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
> RIP: 0010:debug_print_object+0x160/0x250 lib/debugobjects.c:485
> Code: dd a0 26 94 88 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 bf 00 00 00 48 8b 14 dd a0 26 94 88 48 c7 c7 00 1c 94 88 e8 52 38 a6 fd <0f> 0b 83 05 53 4f 13 07 01 48 83 c4 20 5b 5d 41 5c 41 5d c3 48 89
> RSP: 0018:ffffc9000b68fb28 EFLAGS: 00010082
> RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
> RDX: ffff8880a216c300 RSI: ffffffff815dafc7 RDI: fffff520016d1f57
> RBP: 0000000000000001 R08: 0000000000000001 R09: ffff8880ae720f8b
> R10: 0000000000000000 R11: 0000000035383854 R12: ffffffff89be2ea0
> R13: ffffffff81638450 R14: dead000000000100 R15: dffffc0000000000
>  __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
>  debug_check_no_obj_freed+0x301/0x41c lib/debugobjects.c:998
>  kmem_cache_free_bulk+0x9e/0x190 mm/slab.c:3718
>  kfree_bulk include/linux/slab.h:411 [inline]
>  kfree_rcu_work+0x506/0x8c0 kernel/rcu/tree.c:3150
>  process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
>  kthread+0x3b5/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
