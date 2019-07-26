Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2988763F7
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 12:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfGZK7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 06:59:53 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40027 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfGZK7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 06:59:53 -0400
Received: by mail-io1-f66.google.com with SMTP id h6so17345276iom.7
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 03:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/2Qkyg89gM8E4GiN52BSgJrYKhgOHFEX8MPsTOQQb/8=;
        b=pvKKUb3xOgOs5idwxVhzJYYdgRH/f/hAG+mKTXBqLzmghnIB+xujpY1bBX9Y7LdVMd
         aa+9Jt3AuO0Z+wHmXBs10VaaQaWws08Jo7yKOGYxFZaomRSCzixATWN007WGKlzn48EA
         MfTec8I68rvjBmvtB214HMPqY9bMtNJPjysQehKPbyefTroUBtvIkPufc//tKBw+3Q3W
         GhxC8/QO4NqmtXKDkFTfzoSVaEKnICoXOwH0JuyFLRh7ZV/6ndmdlqe1FttJgKV/DPAQ
         4zOxvgJqZo2nlpiVPA7khQNbyK3zr3GiFarRbnSzEbNe8EtRuu6bdZIPpCGdVa+nJwyf
         P6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/2Qkyg89gM8E4GiN52BSgJrYKhgOHFEX8MPsTOQQb/8=;
        b=gRMq/x2XznlmQGggqO6gM46heTxbWnx81aFU+tDWU+uoJ+wsmSY/6pTG15dipy2WyH
         gNArYeyoikrPoHghNZ74Ke9c2rfjwzhaqC+GlZjkEG4Gg8UnUJx3AoYnG1G/FwI+QZC2
         gOWnsm4XaJ5bi5KLnM36LupXPAjX+AS1j7irPQFeVPxx/qoPLCc5WBy2rOQQnhYaJ69i
         jLClPvXyrnAGAoURzTXEUKVc3ZpFG331725C8/QKVU78gWaDCfb2oKXaEcd/pGXpaJ5K
         NCIIYDJgZP0Xfcr+Amg+jL9sM3cO9zsOoId5K7MF7W+Fh0eBPIgP86D4T+UVeXgh2fue
         +M5A==
X-Gm-Message-State: APjAAAUC1M1b8cunJhARndctcTrzWSV2btYTITDVrTNPkX6AYpxhPFOM
        blCiJ/Z+avzfEMA3I1wWnrX7Xp4gWDsuo4Gy96iSiNiueBChWQ==
X-Google-Smtp-Source: APXvYqwy0DspGrxpJRfm+kJx/feLb96cqxdHBXTbxWdZC6ECQstx1/+jNOE+Dzwx0A8fEiu4b7xFBoluWw/tmZ/Q6DY=
X-Received: by 2002:a02:c7c9:: with SMTP id s9mr38357516jao.82.1564138791753;
 Fri, 26 Jul 2019 03:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b7abcc058e924c12@google.com>
In-Reply-To: <000000000000b7abcc058e924c12@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 26 Jul 2019 12:59:40 +0200
Message-ID: <CACT4Y+aigCawAqjh=W83uAvbC+n3FXfsiYSA0sbMSn8kkPMSNA@mail.gmail.com>
Subject: Re: possible deadlock in rxrpc_put_peer
To:     syzbot <syzbot+72af434e4b3417318f84@syzkaller.appspotmail.com>,
        David Howells <dhowells@redhat.com>,
        David Miller <davem@davemloft.net>,
        linux-afs@lists.infradead.org, netdev <netdev@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 11:38 AM syzbot
<syzbot+72af434e4b3417318f84@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    6d21a41b Add linux-next specific files for 20190718
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=174e3af0600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3430a151e1452331
> dashboard link: https://syzkaller.appspot.com/bug?extid=72af434e4b3417318f84
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+72af434e4b3417318f84@syzkaller.appspotmail.com

+net/rxrpc/peer_object.c maintainers

> ============================================
> WARNING: possible recursive locking detected
> 5.2.0-next-20190718 #41 Not tainted
> --------------------------------------------
> kworker/0:3/21678 is trying to acquire lock:
> 00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at: spin_lock_bh
> /./include/linux/spinlock.h:343 [inline]
> 00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at:
> __rxrpc_put_peer /net/rxrpc/peer_object.c:415 [inline]
> 00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at:
> rxrpc_put_peer+0x2d3/0x6a0 /net/rxrpc/peer_object.c:435
>
> but task is already holding lock:
> 00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at: spin_lock_bh
> /./include/linux/spinlock.h:343 [inline]
> 00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at:
> rxrpc_peer_keepalive_dispatch /net/rxrpc/peer_event.c:378 [inline]
> 00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at:
> rxrpc_peer_keepalive_worker+0x6b3/0xd02 /net/rxrpc/peer_event.c:430
>
> other info that might help us debug this:
>   Possible unsafe locking scenario:
>
>         CPU0
>         ----
>    lock(&(&rxnet->peer_hash_lock)->rlock);
>    lock(&(&rxnet->peer_hash_lock)->rlock);
>
>   *** DEADLOCK ***
>
>   May be due to missing lock nesting notation
>
> 3 locks held by kworker/0:3/21678:
>   #0: 000000007c4c2bc3 ((wq_completion)krxrpcd){+.+.}, at: __write_once_size
> /./include/linux/compiler.h:226 [inline]
>   #0: 000000007c4c2bc3 ((wq_completion)krxrpcd){+.+.}, at: arch_atomic64_set
> /./arch/x86/include/asm/atomic64_64.h:34 [inline]
>   #0: 000000007c4c2bc3 ((wq_completion)krxrpcd){+.+.}, at: atomic64_set
> /./include/asm-generic/atomic-instrumented.h:855 [inline]
>   #0: 000000007c4c2bc3 ((wq_completion)krxrpcd){+.+.}, at: atomic_long_set
> /./include/asm-generic/atomic-long.h:40 [inline]
>   #0: 000000007c4c2bc3 ((wq_completion)krxrpcd){+.+.}, at: set_work_data
> /kernel/workqueue.c:620 [inline]
>   #0: 000000007c4c2bc3 ((wq_completion)krxrpcd){+.+.}, at:
> set_work_pool_and_clear_pending /kernel/workqueue.c:647 [inline]
>   #0: 000000007c4c2bc3 ((wq_completion)krxrpcd){+.+.}, at:
> process_one_work+0x88b/0x1740 /kernel/workqueue.c:2240
>   #1: 000000006782bc7f
> ((work_completion)(&rxnet->peer_keepalive_work)){+.+.}, at:
> process_one_work+0x8c1/0x1740 /kernel/workqueue.c:2244
>   #2: 00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at:
> spin_lock_bh /./include/linux/spinlock.h:343 [inline]
>   #2: 00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at:
> rxrpc_peer_keepalive_dispatch /net/rxrpc/peer_event.c:378 [inline]
>   #2: 00000000aa5eecdf (&(&rxnet->peer_hash_lock)->rlock){+.-.}, at:
> rxrpc_peer_keepalive_worker+0x6b3/0xd02 /net/rxrpc/peer_event.c:430
>
> stack backtrace:
> CPU: 0 PID: 21678 Comm: kworker/0:3 Not tainted 5.2.0-next-20190718 #41
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: krxrpcd rxrpc_peer_keepalive_worker
> Call Trace:
>   __dump_stack /lib/dump_stack.c:77 [inline]
>   dump_stack+0x172/0x1f0 /lib/dump_stack.c:113
>   print_deadlock_bug /kernel/locking/lockdep.c:2301 [inline]
>   check_deadlock /kernel/locking/lockdep.c:2342 [inline]
>   validate_chain /kernel/locking/lockdep.c:2881 [inline]
>   __lock_acquire.cold+0x194/0x398 /kernel/locking/lockdep.c:3880
>   lock_acquire+0x190/0x410 /kernel/locking/lockdep.c:4413
>   __raw_spin_lock_bh /./include/linux/spinlock_api_smp.h:135 [inline]
>   _raw_spin_lock_bh+0x33/0x50 /kernel/locking/spinlock.c:175
>   spin_lock_bh /./include/linux/spinlock.h:343 [inline]
>   __rxrpc_put_peer /net/rxrpc/peer_object.c:415 [inline]
>   rxrpc_put_peer+0x2d3/0x6a0 /net/rxrpc/peer_object.c:435
>   rxrpc_peer_keepalive_dispatch /net/rxrpc/peer_event.c:381 [inline]
>   rxrpc_peer_keepalive_worker+0x7a6/0xd02 /net/rxrpc/peer_event.c:430
>   process_one_work+0x9af/0x1740 /kernel/workqueue.c:2269
>   worker_thread+0x98/0xe40 /kernel/workqueue.c:2415
>   kthread+0x361/0x430 /kernel/kthread.c:255
>   ret_from_fork+0x24/0x30 /arch/x86/entry/entry_64.S:352
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000b7abcc058e924c12%40google.com.
