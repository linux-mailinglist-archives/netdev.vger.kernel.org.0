Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2DB48967A
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244047AbiAJKhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:37:20 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:57270 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239436AbiAJKhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 05:37:19 -0500
Received: by mail-io1-f70.google.com with SMTP id d187-20020a6bb4c4000000b00601c0b8532aso10713371iof.23
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 02:37:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=28Zn727PbkOa9e5z/Te0bGji+C0r00GDui6Opfz/fgY=;
        b=1+LOdBXVqtPddCQP+LzlBcytr4TUoJEqddNwRj2AViU/PmLxT5MOuNgglUCd0g83hc
         G4CekQo8LM5K7DC8gEzw4Qs9vuUu8AGN86H6hS9lAPV4/Xt1vFDDOm81sMV7+nUb3CUc
         EXCtxUKhk7nlbyiqB7VJcvJKpSmd3xw3IHcNczUuyG+TUR4TKfJ/xDPutrO2KC//dke7
         oPHNyH3QMhEDfY0HwWOvc3qidjoyW3qOiu8CzkKQ1RTqmVKzcPZoA/MKvmFSR9EaNZEc
         YX+Eay+aUNn+/AqqMUktkvcpD9zhvUtXlTKvilSngH6d+M0l4fqz2RWvGZwayC6PlymB
         ZC4Q==
X-Gm-Message-State: AOAM533rolabTXDsMe1BFyYyFuPxPAncPDEUjTOzmco+w8mQEfAvt4J0
        jpaNtnZXJSu/CxCCX22iLj49Yc34QUbhzr7DqJibJ2kKS43Z
X-Google-Smtp-Source: ABdhPJxkWJglLMH3JYkAs5xRuRcpxjI7rYX9TuzOm255LBfzxK0nlisfIObbM2ncvDqJUr2+cbUo4jJfvo5yCLgKxSReC+qt7bFu
MIME-Version: 1.0
X-Received: by 2002:a6b:ba05:: with SMTP id k5mr35882555iof.194.1641811039359;
 Mon, 10 Jan 2022 02:37:19 -0800 (PST)
Date:   Mon, 10 Jan 2022 02:37:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ca1d2005d537ebac@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in __dev_queue_xmit
From:   syzbot <syzbot+e163f2ff7c3f7efd8203@syzkaller.appspotmail.com>
To:     a@unstable.cc, alobakin@pm.me, andrii@kernel.org, ast@kernel.org,
        atenart@kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        bpf@vger.kernel.org, coreteam@netfilter.org, daniel@iogearbox.net,
        davem@davemloft.net, fw@strlen.de, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kadlec@netfilter.org, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lukas@wunner.de, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, songliubraving@fb.com, sven@narfation.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4c375272fb0b Merge branch 'net-add-preliminary-netdev-refc..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=164749a9b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b8e24e3a80e3875
dashboard link: https://syzkaller.appspot.com/bug?extid=e163f2ff7c3f7efd8203
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11493641b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ac6aceb00000

The issue was bisected to:

commit 42df6e1d221dddc0f2acf2be37e68d553ad65f96
Author: Lukas Wunner <lukas@wunner.de>
Date:   Fri Oct 8 20:06:03 2021 +0000

    netfilter: Introduce egress hook

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1236329db00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1136329db00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1636329db00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e163f2ff7c3f7efd8203@syzkaller.appspotmail.com
Fixes: 42df6e1d221d ("netfilter: Introduce egress hook")

=============================
WARNING: suspicious RCU usage
5.16.0-rc3-syzkaller #0 Not tainted
-----------------------------
include/linux/netfilter_netdev.h:97 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
3 locks held by kworker/u4:2/49:
 #0: ffff88814b0fe938 ((wq_completion)bat_events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88814b0fe938 ((wq_completion)bat_events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff88814b0fe938 ((wq_completion)bat_events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff88814b0fe938 ((wq_completion)bat_events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:635 [inline]
 #0: ffff88814b0fe938 ((wq_completion)bat_events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
 #0: ffff88814b0fe938 ((wq_completion)bat_events){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2269
 #1: ffffc9000119fdb0 ((work_completion)(&(&forw_packet_aggr->delayed_work)->work)){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2273
 #2: ffffffff8bb83b00 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1e3/0x3640 net/core/dev.c:4036

stack backtrace:
CPU: 1 PID: 49 Comm: kworker/u4:2 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nf_hook_egress include/linux/netfilter_netdev.h:97 [inline]
 __dev_queue_xmit+0x2eac/0x3640 net/core/dev.c:4053
 batadv_send_skb_packet+0x4a9/0x5f0 net/batman-adv/send.c:108
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:421 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0x6d7/0x8e0 net/batman-adv/bat_iv_ogm.c:1701
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
