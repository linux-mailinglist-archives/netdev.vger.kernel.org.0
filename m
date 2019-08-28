Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73663A0AAF
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 21:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfH1TsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 15:48:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:55274 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfH1TsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 15:48:07 -0400
Received: by mail-io1-f72.google.com with SMTP id a20so908885iok.21
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 12:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7ghtGp5J+PmV7Tcxs0OU6gXbW9w20QxLS/lDebvWWVc=;
        b=cMWur1Ap31flIRjq/blnC4ND84SDrRnG670joy5P3xtKTYdBzw9OVg2rf86eKjFRjb
         bQpkkkVRIzlxBZQ5DXlIFL6pCDZtCjUdtCljdyrjjAEzRxJoYwSGd8qqeTK+rqe2YCcW
         5R4dG7Ate7hRhXeVS5ackNOaMDiQwCQzsHZqRaJVZqZhCAulFpkudlUsGtJBXqEIRnsp
         mfawBy5DSsab+nLVOauaw2cCRKW1xsYFCgj+nX6HZaFjfuDvVblb1GYVGsuxXvzCmVVV
         gcM5C0IqcB2OE4+zKjEIGN7nCpHZ3eWIwofjyts2Kv4Bl58cQlrUAk8VnLqE0MLaD/2P
         SEYQ==
X-Gm-Message-State: APjAAAXxSWqiacKOSrVYbuTWBY1eTheIaias7tzr3tZSnpJyHh+Bny6U
        fkqZP3ysvpaAurgRb4vt6X5bslCwiV85OLnI6XwJUfGF5X69
X-Google-Smtp-Source: APXvYqy8422xexpBhNrHpDudiBE5UkQQ/lRD82sxQxtDjUp+UsY2P2Ciy7ys5i7Hzf6S0o6iyyWU+ZFdd0o7xQeYDGZHqXX9YFzp
MIME-Version: 1.0
X-Received: by 2002:a02:4881:: with SMTP id p123mr6348414jaa.69.1567021686233;
 Wed, 28 Aug 2019 12:48:06 -0700 (PDT)
Date:   Wed, 28 Aug 2019 12:48:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f6a13b059132aa6c@google.com>
Subject: KASAN: use-after-free Read in rxrpc_put_peer
From:   syzbot <syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ed2393ca Add linux-next specific files for 20190827
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11b4a79c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2ef5940a07ed45f4
dashboard link: https://syzkaller.appspot.com/bug?extid=b9be979c55f2bea8ed30
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c73066600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __rxrpc_put_peer net/rxrpc/peer_object.c:411  
[inline]
BUG: KASAN: use-after-free in rxrpc_put_peer+0x685/0x6a0  
net/rxrpc/peer_object.c:435
Read of size 8 at addr ffff8880a05bd218 by task ksoftirqd/1/16

CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.3.0-rc6-next-20190827 #74
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  __rxrpc_put_peer net/rxrpc/peer_object.c:411 [inline]
  rxrpc_put_peer+0x685/0x6a0 net/rxrpc/peer_object.c:435
  rxrpc_rcu_destroy_call+0x5e/0x140 net/rxrpc/call_object.c:566
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2157 [inline]
  rcu_core+0x581/0x1560 kernel/rcu/tree.c:2377
  rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2386
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  run_ksoftirqd kernel/softirq.c:603 [inline]
  run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
  smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 17189:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:686 [inline]
  rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
  rxrpc_lookup_local+0x562/0x1ba0 net/rxrpc/local_object.c:277
  rxrpc_sendmsg+0x379/0x5f0 net/rxrpc/af_rxrpc.c:566
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x3e2/0x920 net/socket.c:2311
  __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2413
  __do_sys_sendmmsg net/socket.c:2442 [inline]
  __se_sys_sendmmsg net/socket.c:2439 [inline]
  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2439
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  rxrpc_local_rcu+0x62/0x80 net/rxrpc/local_object.c:499
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2157 [inline]
  rcu_core+0x581/0x1560 kernel/rcu/tree.c:2377
  rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2386
  __do_softirq+0x262/0x98c kernel/softirq.c:292

The buggy address belongs to the object at ffff8880a05bd200
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 24 bytes inside of
  1024-byte region [ffff8880a05bd200, ffff8880a05bd600)
The buggy address belongs to the page:
page:ffffea0002816f00 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0xffff8880a05bcd80 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea00027c4588 ffffea0002381088 ffff8880aa400c40
raw: ffff8880a05bcd80 ffff8880a05bc000 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a05bd100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a05bd180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8880a05bd200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                             ^
  ffff8880a05bd280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a05bd300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
