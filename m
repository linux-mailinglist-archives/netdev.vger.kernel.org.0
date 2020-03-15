Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E1B185B25
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 09:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgCOIMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 04:12:05 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56970 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbgCOIMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 04:12:05 -0400
Received: by mail-io1-f72.google.com with SMTP id d13so9532236ioo.23
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 01:12:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=B1udWNZFP2+uCGqHulCFNjS4uzsBFRxuW+COtRJVWQo=;
        b=DT4dyg8n3ngFpT5qppiqgUqmdZdxdm70FG7Zdy/dC1yqLyhlmXoxq4skEiAN9uoZPv
         6PJtHIvLN/qJEEy5fGE2hVhaD73le6tWDAPe3v3tVDK7sBEOhEjK78TLczVLaS9Rx1JF
         YSuU5TWjzzjMllJ1Kha4+DEHi2JkWOlGzpsQPcqmAS+nt2MkFJ1Q+XPHXYFc0tlHq9Mf
         wX9LyfnPRfrmti0o+4Vywn4wo5oDD0BhMlW4amBgjORhgHTq+N/IZRmcQPYA2xujs6KN
         dexwfvCabqcu1mKe3E0q4ur+QMvLPG+lH5i3UopaenuAASmXm1xt0yOm2s6jZJugN/ro
         N31w==
X-Gm-Message-State: ANhLgQ3RRGWg8xXXWuyrPQtspolifR4uYL454N3sKiWdl4ccwg45n0RP
        PlhbbOMqI1ovlqqKy7fh+8HF4cDJ4MkGEipoGEkAjh6WaO+n
X-Google-Smtp-Source: ADFU+vtjVVDO2mH8MqEI3xzxgZd5CSb7YS1t67uwDYHA1SpFWolkxsWbXUYKL7FiuhuHycgZLrZDPY14DL9Oj8zY0zr32qkMgVob
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:685:: with SMTP id o5mr22304710ils.86.1584259922356;
 Sun, 15 Mar 2020 01:12:02 -0700 (PDT)
Date:   Sun, 15 Mar 2020 01:12:02 -0700
In-Reply-To: <CADG63jCNAngPC9+KuGAChibPn0ZeTmfiUvYntUqDudGQF0h7xw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e7736205a0e041f5@google.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
From:   syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
To:     anenbupt@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered crash:
KASAN: use-after-free Read in sctp_wfree

==================================================================
BUG: KASAN: use-after-free in sctp_write_space net/sctp/socket.c:9225 [inline]
BUG: KASAN: use-after-free in sctp_wake_up_waiters net/sctp/socket.c:9050 [inline]
BUG: KASAN: use-after-free in sctp_wfree+0x463/0x710 net/sctp/socket.c:9112
Read of size 8 at addr ffff8880a181f5a8 by task syz-executor.2/8661

CPU: 1 PID: 8661 Comm: syz-executor.2 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 print_address_description+0x74/0x5c0 mm/kasan/report.c:374
 __kasan_report+0x14b/0x1c0 mm/kasan/report.c:506
 kasan_report+0x25/0x50 mm/kasan/common.c:641
 sctp_write_space net/sctp/socket.c:9225 [inline]
 sctp_wake_up_waiters net/sctp/socket.c:9050 [inline]
 sctp_wfree+0x463/0x710 net/sctp/socket.c:9112
 skb_release_head_state+0xfb/0x210 net/core/skbuff.c:651
 skb_release_all net/core/skbuff.c:662 [inline]
 __kfree_skb+0x22/0x1c0 net/core/skbuff.c:678
 sctp_chunk_destroy net/sctp/sm_make_chunk.c:1454 [inline]
 sctp_chunk_put+0x17b/0x200 net/sctp/sm_make_chunk.c:1481
 sctp_datamsg_destroy net/sctp/chunk.c:107 [inline]
 sctp_datamsg_put+0x438/0x570 net/sctp/chunk.c:128
 sctp_chunk_free+0x46/0x60 net/sctp/sm_make_chunk.c:1466
 __sctp_outq_teardown+0x80a/0x9d0 net/sctp/outqueue.c:257
 sctp_association_free+0x21e/0x7c0 net/sctp/associola.c:339
 sctp_cmd_delete_tcb net/sctp/sm_sideeffect.c:930 [inline]
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1318 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x3c01/0x5560 net/sctp/sm_sideeffect.c:1156
 sctp_primitive_ABORT+0x93/0xc0 net/sctp/primitive.c:104
 sctp_close+0x231/0x770 net/sctp/socket.c:1512
 inet_release+0x135/0x180 net/ipv4/af_inet.c:427
 __sock_release net/socket.c:605 [inline]
 sock_close+0xd8/0x260 net/socket.c:1283
 __fput+0x2d8/0x730 fs/file_table.c:280
 task_work_run+0x176/0x1b0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:164 [inline]
 prepare_exit_to_usermode+0x48e/0x600 arch/x86/entry/common.c:195
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x416041
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffdc88e28b0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000416041
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 0000000000000001 R08: 00ffffffffffffff R09: 00ffffffffffffff
R10: 00007ffdc88e2990 R11: 0000000000000293 R12: 000000000076bf20
R13: 0000000000770850 R14: 0000000000012e64 R15: 000000000076bf2c

Allocated by task 8662:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc+0x118/0x1c0 mm/kasan/common.c:515
 slab_post_alloc_hook mm/slab.h:584 [inline]
 slab_alloc mm/slab.c:3320 [inline]
 kmem_cache_alloc+0x1f5/0x2d0 mm/slab.c:3484
 sk_prot_alloc+0x58/0x2b0 net/core/sock.c:1597
 sk_alloc+0x35/0x990 net/core/sock.c:1657
 inet_create+0x576/0xc80 net/ipv4/af_inet.c:321
 __sock_create+0x5c9/0x8d0 net/socket.c:1433
 sock_create net/socket.c:1484 [inline]
 __sys_socket+0xde/0x2d0 net/socket.c:1526
 __do_sys_socket net/socket.c:1535 [inline]
 __se_sys_socket net/socket.c:1533 [inline]
 __x64_sys_socket+0x76/0x80 net/socket.c:1533
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8661:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:476
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free+0x7e/0xf0 mm/slab.c:3694
 sk_prot_free net/core/sock.c:1638 [inline]
 __sk_destruct+0x60e/0x740 net/core/sock.c:1724
 sctp_wfree+0x3af/0x710 net/sctp/socket.c:9111
 skb_release_head_state+0xfb/0x210 net/core/skbuff.c:651
 skb_release_all net/core/skbuff.c:662 [inline]
 __kfree_skb+0x22/0x1c0 net/core/skbuff.c:678
 sctp_chunk_destroy net/sctp/sm_make_chunk.c:1454 [inline]
 sctp_chunk_put+0x17b/0x200 net/sctp/sm_make_chunk.c:1481
 sctp_datamsg_destroy net/sctp/chunk.c:107 [inline]
 sctp_datamsg_put+0x438/0x570 net/sctp/chunk.c:128
 sctp_chunk_free+0x46/0x60 net/sctp/sm_make_chunk.c:1466
 __sctp_outq_teardown+0x80a/0x9d0 net/sctp/outqueue.c:257
 sctp_association_free+0x21e/0x7c0 net/sctp/associola.c:339
 sctp_cmd_delete_tcb net/sctp/sm_sideeffect.c:930 [inline]
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1318 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x3c01/0x5560 net/sctp/sm_sideeffect.c:1156
 sctp_primitive_ABORT+0x93/0xc0 net/sctp/primitive.c:104
 sctp_close+0x231/0x770 net/sctp/socket.c:1512
 inet_release+0x135/0x180 net/ipv4/af_inet.c:427
 __sock_release net/socket.c:605 [inline]
 sock_close+0xd8/0x260 net/socket.c:1283
 __fput+0x2d8/0x730 fs/file_table.c:280
 task_work_run+0x176/0x1b0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:164 [inline]
 prepare_exit_to_usermode+0x48e/0x600 arch/x86/entry/common.c:195
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a181f040
 which belongs to the cache SCTP of size 1800
The buggy address is located 1384 bytes inside of
 1800-byte region [ffff8880a181f040, ffff8880a181f748)
The buggy address belongs to the page:
page:ffffea00028607c0 refcount:1 mapcount:0 mapping:ffff888099725000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffff8880995ded48 ffff8880995ded48 ffff888099725000
raw: 0000000000000000 ffff8880a181f040 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a181f480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a181f500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880a181f580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff8880a181f600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a181f680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         26395f8f sctp: fix refcount bug in sctp_wfree
git tree:       https://github.com/hqj/hqjagain_test.git sctp_wfree_refcount_bug
console output: https://syzkaller.appspot.com/x/log.txt?x=14358a1de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5295e161cd85b82
dashboard link: https://syzkaller.appspot.com/bug?extid=cea71eec5d6de256d54d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

