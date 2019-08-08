Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19FF86754
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390214AbfHHQoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 12:44:11 -0400
Received: from mail-ot1-f70.google.com ([209.85.210.70]:50471 "EHLO
        mail-ot1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390133AbfHHQoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 12:44:08 -0400
Received: by mail-ot1-f70.google.com with SMTP id a21so62929554otk.17
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 09:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=iHsPdrpnVUzzAO5Tf1V0+Uz36Wmve8VdL1a5sOx66mk=;
        b=nUiYB3qF7e8MCXb6HgcOSBj8j3fIUKdSvhcSmGvN+ejGQW/ppoSnTE7SFNr54SMuvX
         XF1dMVPvXtbJqufoChLK/BqUQOxITfww2e8Mi3ItnIawrXt1qQpgpQbLMRo0RMsLiUd1
         ZEfORuPnh0n+fKu1FSTr8icenb7zctwkrD1ydWz5a9Pmg79jxVVI+RySX0R98MRkpybz
         Mi1P0XfFAl5YpwK9n58XztPrjVQboYXNhqQ/bGJwAiMhI0olSHq0oTf+4l1cni43VmwP
         2BBQtVfaFsLNIu/LRjC3M0LpRBkjn2G8wVcG2EEKN1U7F2IpmWtQVxKUICYl58Vv/tRs
         vTlA==
X-Gm-Message-State: APjAAAUSUdiJ/iArmov9mmC1yd013Z53FA0wn1YMB65LBajeXZ/JKjXO
        OzjscJKQWJzdYNYxSk6qbI+pEduwUD3uD6eRg2U4yKcqXfri
X-Google-Smtp-Source: APXvYqyo78jxXQQ0AW+OjxxN1emWNnXNmX+2l9sgSJE9/qUF4I8w6aVsT1ES1JQr8NOm156voc57iQ+bbleVs3sKqbBauCgIdNSO
MIME-Version: 1.0
X-Received: by 2002:a5d:928a:: with SMTP id s10mr16244046iom.29.1565282647023;
 Thu, 08 Aug 2019 09:44:07 -0700 (PDT)
Date:   Thu, 08 Aug 2019 09:44:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000262820058f9dc474@google.com>
Subject: KASAN: use-after-free Read in tls_wait_data
From:   syzbot <syzbot+30c791a76814a3c6c9f9@syzkaller.appspotmail.com>
To:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7b4980e0 Add linux-next specific files for 20190802
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14a749b4600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e1348afd44b5e02
dashboard link: https://syzkaller.appspot.com/bug?extid=30c791a76814a3c6c9f9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+30c791a76814a3c6c9f9@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in tls_wait_data+0x884/0x980  
net/tls/tls_sw.c:1261
Read of size 8 at addr ffff88808ea9f890 by task syz-executor.2/31898

CPU: 1 PID: 31898 Comm: syz-executor.2 Not tainted 5.3.0-rc2-next-20190802  
#58
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:610
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  tls_wait_data+0x884/0x980 net/tls/tls_sw.c:1261
  tls_sw_recvmsg+0x57d/0x17c0 net/tls/tls_sw.c:1730
  inet_recvmsg+0x136/0x620 net/ipv4/af_inet.c:838
  sock_recvmsg_nosec+0x89/0xb0 net/socket.c:871
  ___sys_recvmsg+0x271/0x5a0 net/socket.c:2480
  do_recvmmsg+0x27e/0x7a0 net/socket.c:2601
  __sys_recvmmsg+0x259/0x270 net/socket.c:2680
  __do_sys_recvmmsg net/socket.c:2703 [inline]
  __se_sys_recvmmsg net/socket.c:2696 [inline]
  __x64_sys_recvmmsg+0xe6/0x140 net/socket.c:2696
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6093e3ec78 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000459829
RDX: 0000000000000004 RSI: 00000000200031c0 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6093e3f6d4
R13: 00000000004c6d67 R14: 00000000004dc0a8 R15: 00000000ffffffff

Allocated by task 31898:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:486 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:459
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:500
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:686 [inline]
  tls_set_sw_offload+0x110a/0x1567 net/tls/tls_sw.c:2243
  do_tls_setsockopt_conf net/tls/tls_main.c:594 [inline]
  do_tls_setsockopt net/tls/tls_main.c:630 [inline]
  tls_setsockopt+0x68d/0x8d0 net/tls/tls_main.c:649
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3130
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2084
  __do_sys_setsockopt net/socket.c:2100 [inline]
  __se_sys_setsockopt net/socket.c:2097 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2097
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 17:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:448
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:456
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  tls_sw_free_ctx_rx+0x31/0x40 net/tls/tls_sw.c:2145
  tls_ctx_free_deferred+0xc4/0x130 net/tls/tls_main.c:279
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff88808ea9f680
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 528 bytes inside of
  1024-byte region [ffff88808ea9f680, ffff88808ea9fa80)
The buggy address belongs to the page:
page:ffffea00023aa780 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea000295f888 ffffea00021f7908 ffff8880aa400c40
raw: 0000000000000000 ffff88808ea9e000 0000000100000007 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88808ea9f780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808ea9f800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88808ea9f880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                          ^
  ffff88808ea9f900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808ea9f980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
