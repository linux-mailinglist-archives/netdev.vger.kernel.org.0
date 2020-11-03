Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424FC2A4D59
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgKCRn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:43:27 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:44711 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728999AbgKCRn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:43:27 -0500
Received: by mail-il1-f199.google.com with SMTP id s70so9734472ili.11
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:43:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=D+S4B5TClngCIxW7RZpJraudOaV9HhZ8fHYmAJkNFjU=;
        b=L0s9D9oItERCN479hlGSfBsHJ4O6TLyBt/ffn38hvIsoRdH+1p84qz/mXnYiAMAu9J
         sUDoimeCEajeJ6TuWd8SQvQCL76nHnDMEvFE2FJd+Lsr2BQeB5ChL5uabcHwkPxke+SU
         /yENsv+9mYOZcP1bSxuBqW2LsfSq3ML9AcW50TnfvgUvirkTFCv5GWqnce6FTW4x1xKr
         kFFNfaxPT1AWLg3BItWuPKHtQe8xzEJHa2QCg59rxBHco9MuRIBmKILqmb/L1g9+uuyD
         4hR7sEuPFFHzwbofnt6xQAHoTISu1NeCWeo/yFFuHoTEf+rH90N/cYp6ksewErUq17Vw
         PNFA==
X-Gm-Message-State: AOAM5319NHRXsokJ4pRPDHCOVakR4I+P26l3e0uEyDkgrIQe679thjAB
        wsX17mYdvguPxTywVtjjav/HNYHmEvbsaoDV8/30ORtke0Co
X-Google-Smtp-Source: ABdhPJzQTw/5YLQJKwQ9jmeAgAi91/xW6raIVxcaYqDyLI/Vb+28qXO5S6DM7Q1HO9GUtJ8jUZIhis7NbWhuKkqDeq1vJrRUB4Yp
MIME-Version: 1.0
X-Received: by 2002:a5d:9850:: with SMTP id p16mr15104176ios.22.1604425405566;
 Tue, 03 Nov 2020 09:43:25 -0800 (PST)
Date:   Tue, 03 Nov 2020 09:43:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005e15f805b3376601@google.com>
Subject: BUG: sleeping function called from invalid context in sta_info_move_state
From:   syzbot <syzbot+d5a9416c6cafe53b5dd0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    04a55c94 Merge tag 'mac80211-for-net-2020-10-30' of git://..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12079c3a500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=803dd96a0e492ac1
dashboard link: https://syzkaller.appspot.com/bug?extid=d5a9416c6cafe53b5dd0
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13714d8a500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=155a5792500000

The issue was bisected to:

commit dcd479e10a0510522a5d88b29b8f79ea3467d501
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Oct 9 12:17:11 2020 +0000

    mac80211: always wind down STA state

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12d3158a500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11d3158a500000
console output: https://syzkaller.appspot.com/x/log.txt?x=16d3158a500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d5a9416c6cafe53b5dd0@syzkaller.appspotmail.com
Fixes: dcd479e10a05 ("mac80211: always wind down STA state")

wlan0: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
wlan0: Creating new IBSS network, BSSID 50:50:50:50:50:50
wlan1: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
BUG: sleeping function called from invalid context at net/mac80211/sta_info.c:1962
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 8, name: kworker/u4:0
4 locks held by kworker/u4:0/8:
 #0: ffff88801b994138 ((wq_completion)phy4){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88801b994138 ((wq_completion)phy4){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88801b994138 ((wq_completion)phy4){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88801b994138 ((wq_completion)phy4){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88801b994138 ((wq_completion)phy4){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88801b994138 ((wq_completion)phy4){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90000cd7da8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffff888024610d00 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1021 [inline]
 #2: ffff888024610d00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_work+0x93/0xe80 net/mac80211/ibss.c:1683
 #3: ffffffff8b337160 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_finish net/mac80211/sta_info.c:644 [inline]
 #3: ffffffff8b337160 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_rcu+0x680/0x2ba0 net/mac80211/sta_info.c:732
Preemption disabled at:
[<ffffffff88e616bf>] __mutex_lock_common kernel/locking/mutex.c:955 [inline]
[<ffffffff88e616bf>] __mutex_lock+0x10f/0x10e0 kernel/locking/mutex.c:1103
CPU: 0 PID: 8 Comm: kworker/u4:0 Not tainted 5.10.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy4 ieee80211_iface_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 ___might_sleep.cold+0x1e8/0x22e kernel/sched/core.c:7298
 sta_info_move_state+0x32/0x8d0 net/mac80211/sta_info.c:1962
 sta_info_free+0x65/0x3b0 net/mac80211/sta_info.c:274
 sta_info_insert_rcu+0x303/0x2ba0 net/mac80211/sta_info.c:738
 ieee80211_ibss_finish_sta+0x212/0x390 net/mac80211/ibss.c:592
 ieee80211_ibss_work+0x2c7/0xe80 net/mac80211/ibss.c:1700
 ieee80211_iface_work+0x82e/0x970 net/mac80211/iface.c:1476
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

=============================
[ BUG: Invalid wait context ]
5.10.0-rc1-syzkaller #0 Tainted: G        W        
-----------------------------
kworker/u4:0/8 is trying to lock:
ffff88801bb429d0 (&local->chanctx_mtx){+.+.}-{3:3}, at: ieee80211_recalc_min_chandef+0x49/0x140 net/mac80211/util.c:2740
other info that might help us debug this:
context-{4:4}
4 locks held by kworker/u4:0/8:
 #0: ffff88801b994138 ((wq_completion)phy4){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88801b994138 ((wq_completion)phy4){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88801b994138 ((wq_completion)phy4){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88801b994138 ((wq_completion)phy4){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88801b994138 ((wq_completion)phy4){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88801b994138 ((wq_completion)phy4){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90000cd7da8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffff888024610d00 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1021 [inline]
 #2: ffff888024610d00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_work+0x93/0xe80 net/mac80211/ibss.c:1683
 #3: ffffffff8b337160 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_finish net/mac80211/sta_info.c:644 [inline]
 #3: ffffffff8b337160 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_rcu+0x680/0x2ba0 net/mac80211/sta_info.c:732
stack backtrace:
CPU: 0 PID: 8 Comm: kworker/u4:0 Tainted: G        W         5.10.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy4 ieee80211_iface_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4489 [inline]
 check_wait_context kernel/locking/lockdep.c:4550 [inline]
 __lock_acquire.cold+0x310/0x3a2 kernel/locking/lockdep.c:4787
 lock_acquire kernel/locking/lockdep.c:5442 [inline]
 lock_acquire+0x1af/0x8b0 kernel/locking/lockdep.c:5407
 __mutex_lock_common kernel/locking/mutex.c:956 [inline]
 __mutex_lock+0x134/0x10e0 kernel/locking/mutex.c:1103
 ieee80211_recalc_min_chandef+0x49/0x140 net/mac80211/util.c:2740
 sta_info_move_state+0x3cf/0x8d0 net/mac80211/sta_info.c:2019
 sta_info_free+0x65/0x3b0 net/mac80211/sta_info.c:274
 sta_info_insert_rcu+0x303/0x2ba0 net/mac80211/sta_info.c:738
 ieee80211_ibss_finish_sta+0x212/0x390 net/mac80211/ibss.c:592
 ieee80211_ibss_work+0x2c7/0xe80 net/mac80211/ibss.c:1700
 ieee80211_iface_work+0x82e/0x970 net/mac80211/iface.c:1476
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
