Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56392A94C0
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 11:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgKFKx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 05:53:28 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:52111 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgKFKx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 05:53:26 -0500
Received: by mail-il1-f197.google.com with SMTP id f8so670144ilj.18
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 02:53:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DDSyTW0cXmYYVcRPO4w8oETTjvfxbaLefaEF1z3VOqw=;
        b=sW7bgQfdHZOQLt0XtZUToCrcsefR5cynLAvsXh/g8aHjBa4KucMtD7h2uN3IlxU8Sq
         gLyXFfups1//S085n+t0VPAIL3kqGNcoTELENt8Fw02I7nglKlZpFyMOq5AoZH19oedn
         93lsjTD6Uj0a3UPfMJVIN8MSYhd6RzFepP1TMVZsJL7ynepSnGTGvH4XAl4zxFoSuv7N
         pYxSuHNgtVvvk2XKsWETsEP1D5FRTg/oYTIhtcn798xxPN+RGXBPkby7neh5vox0tOFE
         DaLZpZcpC8n/6C0snopthxV1Pu63XHDIVf5VaYMmRDFYKDFV7mOlIzscRp2nIutB+ZRZ
         bMvQ==
X-Gm-Message-State: AOAM531ZeEotEMhWtcNh4WyWDXBBywhPFBt+mMLzocmGXL7JaZqxrECx
        BO43WSiV9NDKz+ELz3RUe358BDcAI1dx6ug/RefI3LXZNtyb
X-Google-Smtp-Source: ABdhPJyW6YXkMYU74RkWHcekbpdxFTrNthZb9JCrArTwPLfB6vH6p3Oj1st3EsqwF3G89qvqNXHc4U3zgyZNV9Uh1STyXsK9LMjX
MIME-Version: 1.0
X-Received: by 2002:a5e:9604:: with SMTP id a4mr973198ioq.61.1604660004200;
 Fri, 06 Nov 2020 02:53:24 -0800 (PST)
Date:   Fri, 06 Nov 2020 02:53:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000892b3905b36e059b@google.com>
Subject: WARNING: bad unlock balance in ieee80211_unregister_hw
From:   syzbot <syzbot+a6e9e84a19d90b996a65@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        gnault@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    cb5dc5b0 Merge branch 'bpf: safeguard hashtab locking in N..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13498a0c500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=58a4ca757d776bfe
dashboard link: https://syzkaller.appspot.com/bug?extid=a6e9e84a19d90b996a65
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a6e9e84a19d90b996a65@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
5.9.0-syzkaller #0 Not tainted
-------------------------------------
kworker/u4:3/24893 is trying to release lock ((wq_completion)phy264) at:
[<ffffffff81476be1>] flush_workqueue+0xe1/0x13e0 kernel/workqueue.c:2780
but there are no more locks to release!

other info that might help us debug this:
3 locks held by kworker/u4:3/24893:
 #0: ffff8881407aa938 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881407aa938 ((wq_completion)netns){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881407aa938 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881407aa938 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881407aa938 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881407aa938 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc9000218fda8 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffffffff8c914010 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xa00 net/core/net_namespace.c:566

stack backtrace:
CPU: 1 PID: 24893 Comm: kworker/u4:3 Not tainted 5.9.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_unlock_imbalance_bug include/trace/events/lock.h:58 [inline]
 __lock_release kernel/locking/lockdep.c:5126 [inline]
 lock_release.cold+0x34/0x4e kernel/locking/lockdep.c:5462
 flush_workqueue+0x125/0x13e0 kernel/workqueue.c:2784
 drain_workqueue+0x1a5/0x3c0 kernel/workqueue.c:2948
 destroy_workqueue+0x71/0x760 kernel/workqueue.c:4372
 ieee80211_unregister_hw+0x1a2/0x210 net/mac80211/main.c:1388
 mac80211_hwsim_del_radio drivers/net/wireless/mac80211_hwsim.c:3360 [inline]
 hwsim_exit_net+0x56b/0xc90 drivers/net/wireless/mac80211_hwsim.c:4115
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:187
 cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:604
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
device hsr_slave_1 left promiscuous mode
batman_adv: batadv0: Removing interface: batadv_slave_0
batman_adv: batadv0: Interface deactivated: batadv_slave_1
batman_adv: batadv0: Removing interface: batadv_slave_1
bridge0: port 2(bridge_slave_1) entered disabled state
device bridge_slave_0 left promiscuous mode
bridge0: port 1(bridge_slave_0) entered disabled state
device veth0_macvtap left promiscuous mode


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
