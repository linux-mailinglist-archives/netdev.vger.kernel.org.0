Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5830E1603F9
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 13:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgBPMRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 07:17:10 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:35553 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgBPMRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 07:17:09 -0500
Received: by mail-il1-f197.google.com with SMTP id h18so12002171ilc.2
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 04:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TiJR2Rrr2MKpn3dY2ck7qSgs+ob/JcDQlFIzsL5mFDs=;
        b=GJ6ufnDkQ+V2g/bf7zu2JUpbm8zSJFS61IFy2gH3rLKwpnRMDAbiXXOfO+rWrB64y3
         ehejRr2lzJ0kkHe1GTAog0v1ep4/kObzAO1BFnpJFYetfRboXivCyvVIBwdhaxZcOnPB
         MwQgVvDXrw+mTAF+QSihzd0uvUSUeVGmWkKUyrWWZ1D0eiYweqLz52f8gy86mrsyHWiP
         jQQl4nyQTOh9tyGZSJn6VDCRD76jH9fRsr/hpL+L6+IMbd3LDgsqZ233ArlmJWNc5EIo
         vW8SfKT4oz2RgBdztwTCIjWBl6Mv/CQtJYzQSkpFMj4Tw1n1zGHhS5GWVvkGcVu0n8FL
         phsQ==
X-Gm-Message-State: APjAAAW6cDLUR59BTgKPN6TSaI+RU74kg0BPF0cBcyk3ZsVPk0fmVFhU
        tPHi3Pe0hQfFl6eYlILIwAqKRtXV+lIzGRZjigDK/REmn1sU
X-Google-Smtp-Source: APXvYqz+09Lb+jLh3/28y/DaJwWUdCEjp7LzORkNNwERhiTM9R8SDtqghjoBjaHhGOA1wYgfKEs4iLHPBIr+ZVNV0naeqp2ioxP3
MIME-Version: 1.0
X-Received: by 2002:a92:990b:: with SMTP id p11mr10437149ili.254.1581855429035;
 Sun, 16 Feb 2020 04:17:09 -0800 (PST)
Date:   Sun, 16 Feb 2020 04:17:09 -0800
In-Reply-To: <0000000000000973ee059eaf4de6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ef0d79059eb06a3f@google.com>
Subject: Re: possible deadlock in bpf_lru_push_free
From:   syzbot <syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, kafai@fb.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    2019fc96 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1358bb11e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=735296e4dd620b10
dashboard link: https://syzkaller.appspot.com/bug?extid=122b5421d14e68f29cd1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b67d6ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.6.0-rc1-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.4/13544 is trying to acquire lock:
ffffe8ffffcba0b8 (&loc_l->lock){....}, at: bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:516 [inline]
ffffe8ffffcba0b8 (&loc_l->lock){....}, at: bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555

but task is already holding lock:
ffff888094985960 (&htab->buckets[i].lock){....}, at: __htab_map_lookup_and_delete_batch+0x617/0x1540 kernel/bpf/hashtab.c:1322

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&htab->buckets[i].lock){....}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
       htab_lru_map_delete_node+0xce/0x2f0 kernel/bpf/hashtab.c:593
       __bpf_lru_list_shrink_inactive kernel/bpf/bpf_lru_list.c:220 [inline]
       __bpf_lru_list_shrink+0xf9/0x470 kernel/bpf/bpf_lru_list.c:266
       bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:340 [inline]
       bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline]
       bpf_lru_pop_free+0x87c/0x1670 kernel/bpf/bpf_lru_list.c:499
       prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
       __htab_lru_percpu_map_update_elem+0x67e/0xa90 kernel/bpf/hashtab.c:1069
       bpf_percpu_hash_update+0x16e/0x210 kernel/bpf/hashtab.c:1585
       bpf_map_update_value.isra.0+0x2d7/0x8e0 kernel/bpf/syscall.c:181
       generic_map_update_batch+0x41f/0x610 kernel/bpf/syscall.c:1319
       bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
       __do_sys_bpf+0x9b7/0x41e0 kernel/bpf/syscall.c:3460
       __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
       __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
       do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #1 (&l->lock){....}:
       __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
       _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
       bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:325 [inline]
       bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline]
       bpf_lru_pop_free+0x67f/0x1670 kernel/bpf/bpf_lru_list.c:499
       prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
       __htab_lru_percpu_map_update_elem+0x67e/0xa90 kernel/bpf/hashtab.c:1069
       bpf_percpu_hash_update+0x16e/0x210 kernel/bpf/hashtab.c:1585
       bpf_map_update_value.isra.0+0x2d7/0x8e0 kernel/bpf/syscall.c:181
       generic_map_update_batch+0x41f/0x610 kernel/bpf/syscall.c:1319
       bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
       __do_sys_bpf+0x9b7/0x41e0 kernel/bpf/syscall.c:3460
       __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
       __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
       do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (&loc_l->lock){....}:
       check_prev_add kernel/locking/lockdep.c:2475 [inline]
       check_prevs_add kernel/locking/lockdep.c:2580 [inline]
       validate_chain kernel/locking/lockdep.c:2970 [inline]
       __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
       lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
       bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:516 [inline]
       bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555
       __htab_map_lookup_and_delete_batch+0x8d4/0x1540 kernel/bpf/hashtab.c:1374
       htab_lru_map_lookup_and_delete_batch+0x34/0x40 kernel/bpf/hashtab.c:1491
       bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
       __do_sys_bpf+0x1f7d/0x41e0 kernel/bpf/syscall.c:3456
       __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
       __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
       do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

Chain exists of:
  &loc_l->lock --> &l->lock --> &htab->buckets[i].lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&htab->buckets[i].lock);
                               lock(&l->lock);
                               lock(&htab->buckets[i].lock);
  lock(&loc_l->lock);

 *** DEADLOCK ***

2 locks held by syz-executor.4/13544:
 #0: ffffffff89bac240 (rcu_read_lock){....}, at: __htab_map_lookup_and_delete_batch+0x54b/0x1540 kernel/bpf/hashtab.c:1308
 #1: ffff888094985960 (&htab->buckets[i].lock){....}, at: __htab_map_lookup_and_delete_batch+0x617/0x1540 kernel/bpf/hashtab.c:1322

stack backtrace:
CPU: 0 PID: 13544 Comm: syz-executor.4 Not tainted 5.6.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_circular_bug.isra.0.cold+0x163/0x172 kernel/locking/lockdep.c:1684
 check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1808
 check_prev_add kernel/locking/lockdep.c:2475 [inline]
 check_prevs_add kernel/locking/lockdep.c:2580 [inline]
 validate_chain kernel/locking/lockdep.c:2970 [inline]
 __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
 lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
 bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:516 [inline]
 bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555
 __htab_map_lookup_and_delete_batch+0x8d4/0x1540 kernel/bpf/hashtab.c:1374
 htab_lru_map_lookup_and_delete_batch+0x34/0x40 kernel/bpf/hashtab.c:1491
 bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
 __do_sys_bpf+0x1f7d/0x41e0 kernel/bpf/syscall.c:3456
 __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
 __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c6c9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007efc51c07c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007efc51c086d4 RCX: 000000000045c6c9
RDX: 0000000000000038 RSI: 00000000200001c0 RDI: 0000000000000019
RBP: 000000000076c118 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000060 R14: 00000000004c2e9b R15: 000000000076c124

