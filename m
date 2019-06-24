Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89C8350465
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 10:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfFXIVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 04:21:16 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:51197 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727633AbfFXIVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 04:21:08 -0400
Received: by mail-io1-f70.google.com with SMTP id m26so20996575ioh.17
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 01:21:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PfmmemVraNIxI6xjjNEvl/9kDCueIQPxeZ900vua0uw=;
        b=ReGngYkaIjSh03ZKQZduJcIJCQcHkUfIEhnKj27d14FwyDScnw6pfgu/FNKq64Kw6N
         MxBuWJZpjXqbnBvF1uNUoed4r9U17CCyTR5sbJpySmoyROpUfeF69y3ojliwm2p0oxK6
         4waG/LFW/g2zfiesf9Z7xHSueFon6Hj2EZ1pJIZH6uhqPOY0shi2Ms3sCTQaJXPHws8A
         8Ake+wdhq44cU48xrnd7Xl32donkiyH0SNDgkw+6RKsrwrvnmyjjIo2InNPRvfqYjS5h
         nV8BYdsQHL4uf5Yow/2Xyk2klsQB57vRKfXnm+1FfWKpXQoGxl89s7dUahfdZihKD3P6
         O50A==
X-Gm-Message-State: APjAAAULgAQ1U9OD4W/dmSrVhmXb+7+ntP4jgVkkPH4l4mKIPG2dsGzC
        Fd3Kt0X1KVfC1DiXnErYR2JB58NVU0Md0z/He+UMzOuL7HCy
X-Google-Smtp-Source: APXvYqxvzSw4Gt2SyXS2Fn9mr/9LihzP8O+jYOpbtX8llqrRJPzJyHM7fKRhwdVaVHbCyh/B1Cqwec6u0XZjJ4jAjtErRomE5BSU
MIME-Version: 1.0
X-Received: by 2002:a6b:b804:: with SMTP id i4mr11666934iof.119.1561364466899;
 Mon, 24 Jun 2019 01:21:06 -0700 (PDT)
Date:   Mon, 24 Jun 2019 01:21:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006a28b5058c0d7e17@google.com>
Subject: BUG: workqueue leaked lock or atomic in smc_tx_work
From:   syzbot <syzbot+8759e3927fd85a7c520a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kgraul@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ubraun@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ef68aaa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e5c77f8090a3b96b
dashboard link: https://syzkaller.appspot.com/bug?extid=8759e3927fd85a7c520a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8759e3927fd85a7c520a@syzkaller.appspotmail.com

BUG: workqueue leaked lock or atomic: kworker/1:2/0x00000000/22354
      last function: smc_tx_work
1 lock held by kworker/1:2/22354:
  #0: 0000000093e90241 (sk_lock-AF_SMC){+.+.}, at: lock_sock  
include/net/sock.h:1522 [inline]
  #0: 0000000093e90241 (sk_lock-AF_SMC){+.+.}, at: smc_tx_work+0x22/0x1d0  
net/smc/smc_tx.c:577
CPU: 1 PID: 22354 Comm: kworker/1:2 Not tainted 5.2.0-rc5+ #57
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events smc_tx_work
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  process_one_work+0x108f/0x1790 kernel/workqueue.c:2284
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x354/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

======================================================
WARNING: possible circular locking dependency detected
5.2.0-rc5+ #57 Not tainted
------------------------------------------------------
kworker/1:2/22354 is trying to acquire lock:
0000000007a836d5 ((wq_completion)events){+.+.}, at: __write_once_size  
include/linux/compiler.h:221 [inline]
0000000007a836d5 ((wq_completion)events){+.+.}, at: arch_atomic64_set  
arch/x86/include/asm/atomic64_64.h:34 [inline]
0000000007a836d5 ((wq_completion)events){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:855 [inline]
0000000007a836d5 ((wq_completion)events){+.+.}, at: atomic_long_set  
include/asm-generic/atomic-long.h:40 [inline]
0000000007a836d5 ((wq_completion)events){+.+.}, at: set_work_data  
kernel/workqueue.c:620 [inline]
0000000007a836d5 ((wq_completion)events){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:647 [inline]
0000000007a836d5 ((wq_completion)events){+.+.}, at:  
process_one_work+0x87e/0x1790 kernel/workqueue.c:2240

but task is already holding lock:
0000000093e90241 (sk_lock-AF_SMC){+.+.}, at: lock_sock  
include/net/sock.h:1522 [inline]
0000000093e90241 (sk_lock-AF_SMC){+.+.}, at: smc_tx_work+0x22/0x1d0  
net/smc/smc_tx.c:577

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (sk_lock-AF_SMC){+.+.}:
        lock_sock_nested+0xcb/0x120 net/core/sock.c:2924
        lock_sock include/net/sock.h:1522 [inline]
        smc_tcp_listen_work+0x8a/0xf60 net/smc/af_smc.c:1366
        process_one_work+0x989/0x1790 kernel/workqueue.c:2269
        worker_thread+0x98/0xe40 kernel/workqueue.c:2415
        kthread+0x354/0x420 kernel/kthread.c:255
        ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

-> #1 ((work_completion)(&smc->tcp_listen_work)){+.+.}:
        process_one_work+0x90f/0x1790 kernel/workqueue.c:2245
        worker_thread+0x98/0xe40 kernel/workqueue.c:2415
        kthread+0x354/0x420 kernel/kthread.c:255
        ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

-> #0 ((wq_completion)events){+.+.}:
        lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4303
        process_one_work+0x8df/0x1790 kernel/workqueue.c:2244
        worker_thread+0x98/0xe40 kernel/workqueue.c:2415
        kthread+0x354/0x420 kernel/kthread.c:255
        ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

other info that might help us debug this:

Chain exists of:
   (wq_completion)events --> (work_completion)(&smc->tcp_listen_work) -->  
sk_lock-AF_SMC

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(sk_lock-AF_SMC);
                                 
lock((work_completion)(&smc->tcp_listen_work));
                                lock(sk_lock-AF_SMC);
   lock((wq_completion)events);

  *** DEADLOCK ***

1 lock held by kworker/1:2/22354:
  #0: 0000000093e90241 (sk_lock-AF_SMC){+.+.}, at: lock_sock  
include/net/sock.h:1522 [inline]
  #0: 0000000093e90241 (sk_lock-AF_SMC){+.+.}, at: smc_tx_work+0x22/0x1d0  
net/smc/smc_tx.c:577

stack backtrace:
CPU: 1 PID: 22354 Comm: kworker/1:2 Not tainted 5.2.0-rc5+ #57
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events vmpressure_work_fn
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_circular_bug.cold+0x1cc/0x28f kernel/locking/lockdep.c:1565
  check_prev_add kernel/locking/lockdep.c:2310 [inline]
  check_prevs_add kernel/locking/lockdep.c:2418 [inline]
  validate_chain kernel/locking/lockdep.c:2800 [inline]
  __lock_acquire+0x3755/0x5490 kernel/locking/lockdep.c:3793
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4303
  process_one_work+0x8df/0x1790 kernel/workqueue.c:2244
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x354/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
