Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2929041189E
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238355AbhITPve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:51:34 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:35822 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhITPvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:51:33 -0400
Received: by mail-il1-f199.google.com with SMTP id f4-20020a056e0204c400b0022dbd3f8b18so40973708ils.2
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:50:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=REbrO1+DJq8+8rxE89T6GJ08rqZaihFpWJJq6HBvFOg=;
        b=v+DoRAfknMjUKwWZB6ozhQRomzcSJiDKTMfO7j18rCeOCa3Ai9egXW4+RabuBvIECZ
         eNFptLTty1+Gg0r7rRpzUeeWy1wFVpkp8kxDi70vELUwz/3fWR4gLMt4rvLh5qjfdDXw
         49A8a2rQIDRe6BpoWCOZd/uy1CPpQnhQIkeSCW1Af1c+ymNn0xJWe23hYggvEMu1fxtY
         V3q5LzgqKOFYixyt632BP0/9zM2HFQkbQ2t2ATnBDPdRiDviIIejDJAEXzyeIppwsB4b
         fTzSJvT2Fl5dQtfFNgSWgrHMnmGpeoQT/F2g3ha16FouhGFluNZrhYpn0zja2G32WG+t
         PImg==
X-Gm-Message-State: AOAM532R0X4FHyHnHdvRPf1s4Una6ag8m+kLfCZw8rfAjxLT8bKLdb2W
        Y5EOm2J/BaDpj5a2B8XsoNNFfewEpRInOQFUybbGwXMp9DX7
X-Google-Smtp-Source: ABdhPJyKiFuVw1OS8VDfUA6ejlPBdb18FbuflG+8eXqWlaZq4au6kzEh/jFNOE8dqqBYAW3Ysrj8f0uD8YaJypMm4M2LIAtaLfQn
MIME-Version: 1.0
X-Received: by 2002:a05:6638:22d1:: with SMTP id j17mr19821480jat.129.1632153006798;
 Mon, 20 Sep 2021 08:50:06 -0700 (PDT)
Date:   Mon, 20 Sep 2021 08:50:06 -0700
In-Reply-To: <20210920142348.4642-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000307a5205cc6f3c02@google.com>
Subject: Re: [syzbot] INFO: task can't die in __lock_sock
From:   syzbot <syzbot+7d51f807c81b190a127d@syzkaller.appspotmail.com>
To:     desmondcheongzx@gmail.com, edumazet@google.com, hdanton@sina.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
possible deadlock in rfcomm_sk_state_change

============================================
WARNING: possible recursive locking detected
5.15.0-rc2-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.0/9050 is trying to acquire lock:
ffff88807ce5d120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1612 [inline]
ffff88807ce5d120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: rfcomm_sk_state_change+0xb4/0x390 net/bluetooth/rfcomm/sock.c:73

but task is already holding lock:
ffff88807ce5d120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1612 [inline]
ffff88807ce5d120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: rfcomm_sock_shutdown+0x54/0x210 net/bluetooth/rfcomm/sock.c:928

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM);
  lock(sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by syz-executor.0/9050:
 #0: ffff88806c8fa010 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:786 [inline]
 #0: ffff88806c8fa010 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:648
 #1: ffff88807ce5d120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1612 [inline]
 #1: ffff88807ce5d120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: rfcomm_sock_shutdown+0x54/0x210 net/bluetooth/rfcomm/sock.c:928
 #2: ffffffff8d320f28 (rfcomm_mutex){+.+.}-{3:3}, at: rfcomm_dlc_close+0x34/0x240 net/bluetooth/rfcomm/core.c:507
 #3: ffff88806875dd28 (&d->lock){+.+.}-{3:3}, at: __rfcomm_dlc_close+0x162/0x8a0 net/bluetooth/rfcomm/core.c:487

stack backtrace:
CPU: 1 PID: 9050 Comm: syz-executor.0 Not tainted 5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2944 [inline]
 check_deadlock kernel/locking/lockdep.c:2987 [inline]
 validate_chain kernel/locking/lockdep.c:3776 [inline]
 __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 lock_sock_nested+0x4e/0x140 net/core/sock.c:3183
 lock_sock include/net/sock.h:1612 [inline]
 rfcomm_sk_state_change+0xb4/0x390 net/bluetooth/rfcomm/sock.c:73
 __rfcomm_dlc_close+0x1b6/0x8a0 net/bluetooth/rfcomm/core.c:489
 rfcomm_dlc_close+0x1ea/0x240 net/bluetooth/rfcomm/core.c:520
 __rfcomm_sock_close+0xac/0x260 net/bluetooth/rfcomm/sock.c:220
 rfcomm_sock_shutdown+0xe9/0x210 net/bluetooth/rfcomm/sock.c:931
 rfcomm_sock_release+0x5f/0x140 net/bluetooth/rfcomm/sock.c:951
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0x288/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 get_signal+0x1b35/0x2160 kernel/signal.c:2641
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0f295fa188 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: fffffffffffffffc RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000000000080 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007fff56050a0f R14: 00007f0f295fa300 R15: 0000000000022000


Tested on:

commit:         e4e737bb Linux 5.15-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1256b6e3300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=25af12c0a765245
dashboard link: https://syzkaller.appspot.com/bug?extid=7d51f807c81b190a127d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10e5ef77300000

