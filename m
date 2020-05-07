Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A2D1C81ED
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 07:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgEGF4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 01:56:19 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39667 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgEGF4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 01:56:18 -0400
Received: by mail-io1-f69.google.com with SMTP id m67so4748980ioa.6
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 22:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wVHnZBdfyelp7ItkqjoOIAyBI5rLEJAUDuhp3+059VA=;
        b=X7NnrssAp4Kshl+5GUuo6/Ycv7oQEMSw2FOOnNDeN0oRCn97C34QZ67cdlrPY4O4G6
         PLxVwpWDKj7Od7Sw50NUuwZBOxaQlBGKppS599va4WrM8lM6acX6xiftlUtjZtAWNwG9
         oTXPEo5k8meWilACfxhJu5bn6DZ5Q/5AY8GUjQcum79H3VQjV5veeGVNY/qur770Ek5a
         TSPlgsENt/Jsry0VVDqeVskfRPM1iSL941TnUxcMfuws5g6izZ4Gsl0YECbyenc/gPA1
         jz7ugJ0dYkBpABjmetqYU0j1FTtaKyK1mrML53IlJQx9utRh05hBkQRjNH7oZ1aXE2G4
         SysQ==
X-Gm-Message-State: AGi0PuZ/yELNcAI7RkE7DqGzcmBzlpJz4uQ0fdairFHDKVew+Ao7ziay
        fb8RgPgrBD4jXJKxGfR7ou+APyAGfURzq99X2hLjoBb8x/Te
X-Google-Smtp-Source: APiQypK1PKVWCXB8ym1KWjuZ5ba9lxFRPHatCEW8G1ugYFktrt07MRiR36gTTuHl5v7jOLypKjmqCBWPAGtMV+QXY/0ZdgA+aqpH
MIME-Version: 1.0
X-Received: by 2002:a92:dd09:: with SMTP id n9mr13471871ilm.132.1588830976495;
 Wed, 06 May 2020 22:56:16 -0700 (PDT)
Date:   Wed, 06 May 2020 22:56:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f6592a05a5088904@google.com>
Subject: memory leak in inet6_create (2)
From:   syzbot <syzbot+db84db800df5aa102826@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f66ed1eb Merge tag 'iomap-5.7-fixes-1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12cf3c4c100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=36dc1e5ad3e26c41
dashboard link: https://syzkaller.appspot.com/bug?extid=db84db800df5aa102826
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1269d24c100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d01c4c100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+db84db800df5aa102826@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888110ef1800 (size 1840):
  comm "syz-executor783", pid 8417, jiffies 4294954395 (age 25.940s)
  hex dump (first 32 bytes):
    00 00 00 00 7f 00 00 06 15 14 f5 21 4e 20 22 dc  ...........!N ".
    0a 00 0b 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace:
    [<000000007986323e>] sk_prot_alloc+0x3c/0x170 net/core/sock.c:1598
    [<000000002fc61b2a>] sk_alloc+0x30/0x330 net/core/sock.c:1658
    [<000000000d7242e5>] inet6_create net/ipv6/af_inet6.c:181 [inline]
    [<000000000d7242e5>] inet6_create+0x112/0x4d0 net/ipv6/af_inet6.c:108
    [<00000000ca79ca9d>] __sock_create+0x14a/0x220 net/socket.c:1433
    [<000000007253d628>] sock_create net/socket.c:1484 [inline]
    [<000000007253d628>] __sys_socket+0x60/0x110 net/socket.c:1526
    [<00000000503be95b>] __do_sys_socket net/socket.c:1535 [inline]
    [<00000000503be95b>] __se_sys_socket net/socket.c:1533 [inline]
    [<00000000503be95b>] __x64_sys_socket+0x1a/0x20 net/socket.c:1533
    [<0000000042ce79c0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000b1aeae16>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888110eaf620 (size 32):
  comm "syz-executor783", pid 8417, jiffies 4294954395 (age 25.940s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 c0 d8 f0 10 81 88 ff ff  ................
    01 00 00 00 03 00 00 00 33 00 00 00 00 00 00 00  ........3.......
  backtrace:
    [<000000000d2c6b3e>] kmalloc include/linux/slab.h:555 [inline]
    [<000000000d2c6b3e>] kzalloc include/linux/slab.h:669 [inline]
    [<000000000d2c6b3e>] selinux_sk_alloc_security+0x43/0xa0 security/selinux/hooks.c:5126
    [<00000000d4591378>] security_sk_alloc+0x42/0x70 security/security.c:2120
    [<000000009002ddd9>] sk_prot_alloc+0x9c/0x170 net/core/sock.c:1607
    [<000000002fc61b2a>] sk_alloc+0x30/0x330 net/core/sock.c:1658
    [<000000000d7242e5>] inet6_create net/ipv6/af_inet6.c:181 [inline]
    [<000000000d7242e5>] inet6_create+0x112/0x4d0 net/ipv6/af_inet6.c:108
    [<00000000ca79ca9d>] __sock_create+0x14a/0x220 net/socket.c:1433
    [<000000007253d628>] sock_create net/socket.c:1484 [inline]
    [<000000007253d628>] __sys_socket+0x60/0x110 net/socket.c:1526
    [<00000000503be95b>] __do_sys_socket net/socket.c:1535 [inline]
    [<00000000503be95b>] __se_sys_socket net/socket.c:1533 [inline]
    [<00000000503be95b>] __x64_sys_socket+0x1a/0x20 net/socket.c:1533
    [<0000000042ce79c0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000b1aeae16>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888110f0d8c0 (size 64):
  comm "syz-executor783", pid 8417, jiffies 4294954395 (age 25.940s)
  hex dump (first 32 bytes):
    15 00 00 01 00 00 00 00 a0 39 dc 10 81 88 ff ff  .........9......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002bb571e8>] kmalloc include/linux/slab.h:555 [inline]
    [<000000002bb571e8>] kzalloc include/linux/slab.h:669 [inline]
    [<000000002bb571e8>] netlbl_secattr_alloc include/net/netlabel.h:382 [inline]
    [<000000002bb571e8>] selinux_netlbl_sock_genattr+0x48/0x180 security/selinux/netlabel.c:76
    [<00000000201274d5>] selinux_netlbl_socket_post_create+0x41/0xb0 security/selinux/netlabel.c:398
    [<00000000189429bf>] selinux_socket_post_create+0x182/0x390 security/selinux/hooks.c:4541
    [<0000000054916bb2>] security_socket_post_create+0x54/0x80 security/security.c:2032
    [<0000000085ba4813>] __sock_create+0x1cc/0x220 net/socket.c:1449
    [<000000007253d628>] sock_create net/socket.c:1484 [inline]
    [<000000007253d628>] __sys_socket+0x60/0x110 net/socket.c:1526
    [<00000000503be95b>] __do_sys_socket net/socket.c:1535 [inline]
    [<00000000503be95b>] __se_sys_socket net/socket.c:1533 [inline]
    [<00000000503be95b>] __x64_sys_socket+0x1a/0x20 net/socket.c:1533
    [<0000000042ce79c0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000b1aeae16>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888110dc39a0 (size 32):
  comm "syz-executor783", pid 8417, jiffies 4294954395 (age 25.940s)
  hex dump (first 32 bytes):
    6b 65 72 6e 65 6c 5f 74 00 73 79 73 74 65 6d 5f  kernel_t.system_
    72 3a 6b 65 72 6e 65 6c 5f 74 3a 73 30 00 00 00  r:kernel_t:s0...
  backtrace:
    [<0000000090b931e1>] kstrdup+0x36/0x70 mm/util.c:60
    [<0000000079ad8987>] security_netlbl_sid_to_secattr+0x97/0x100 security/selinux/ss/services.c:3739
    [<000000006911d3c9>] selinux_netlbl_sock_genattr+0x67/0x180 security/selinux/netlabel.c:79
    [<00000000201274d5>] selinux_netlbl_socket_post_create+0x41/0xb0 security/selinux/netlabel.c:398
    [<00000000189429bf>] selinux_socket_post_create+0x182/0x390 security/selinux/hooks.c:4541
    [<0000000054916bb2>] security_socket_post_create+0x54/0x80 security/security.c:2032
    [<0000000085ba4813>] __sock_create+0x1cc/0x220 net/socket.c:1449
    [<000000007253d628>] sock_create net/socket.c:1484 [inline]
    [<000000007253d628>] __sys_socket+0x60/0x110 net/socket.c:1526
    [<00000000503be95b>] __do_sys_socket net/socket.c:1535 [inline]
    [<00000000503be95b>] __se_sys_socket net/socket.c:1533 [inline]
    [<00000000503be95b>] __x64_sys_socket+0x1a/0x20 net/socket.c:1533
    [<0000000042ce79c0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000b1aeae16>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888110ef1800 (size 1840):
  comm "syz-executor783", pid 8417, jiffies 4294954395 (age 30.410s)
  hex dump (first 32 bytes):
    00 00 00 00 7f 00 00 06 15 14 f5 21 4e 20 22 dc  ...........!N ".
    0a 00 0b 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace:
    [<000000007986323e>] sk_prot_alloc+0x3c/0x170 net/core/sock.c:1598
    [<000000002fc61b2a>] sk_alloc+0x30/0x330 net/core/sock.c:1658
    [<000000000d7242e5>] inet6_create net/ipv6/af_inet6.c:181 [inline]
    [<000000000d7242e5>] inet6_create+0x112/0x4d0 net/ipv6/af_inet6.c:108
    [<00000000ca79ca9d>] __sock_create+0x14a/0x220 net/socket.c:1433
    [<000000007253d628>] sock_create net/socket.c:1484 [inline]
    [<000000007253d628>] __sys_socket+0x60/0x110 net/socket.c:1526
    [<00000000503be95b>] __do_sys_socket net/socket.c:1535 [inline]
    [<00000000503be95b>] __se_sys_socket net/socket.c:1533 [inline]
    [<00000000503be95b>] __x64_sys_socket+0x1a/0x20 net/socket.c:1533
    [<0000000042ce79c0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000b1aeae16>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888110eaf620 (size 32):
  comm "syz-executor783", pid 8417, jiffies 4294954395 (age 30.410s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 c0 d8 f0 10 81 88 ff ff  ................
    01 00 00 00 03 00 00 00 33 00 00 00 00 00 00 00  ........3.......
  backtrace:
    [<000000000d2c6b3e>] kmalloc include/linux/slab.h:555 [inline]
    [<000000000d2c6b3e>] kzalloc include/linux/slab.h:669 [inline]
    [<000000000d2c6b3e>] selinux_sk_alloc_security+0x43/0xa0 security/selinux/hooks.c:5126
    [<00000000d4591378>] security_sk_alloc+0x42/0x70 security/security.c:2120
    [<000000009002ddd9>] sk_prot_alloc+0x9c/0x170 net/core/sock.c:1607
    [<000000002fc61b2a>] sk_alloc+0x30/0x330 net/core/sock.c:1658
    [<000000000d7242e5>] inet6_create net/ipv6/af_inet6.c:181 [inline]
    [<000000000d7242e5>] inet6_create+0x112/0x4d0 net/ipv6/af_inet6.c:108
    [<00000000ca79ca9d>] __sock_create+0x14a/0x220 net/socket.c:1433
    [<000000007253d628>] sock_create net/socket.c:1484 [inline]
    [<000000007253d628>] __sys_socket+0x60/0x110 net/socket.c:1526
    [<00000000503be95b>] __do_sys_socket net/socket.c:1535 [inline]
    [<00000000503be95b>] __se_sys_socket net/socket.c:1533 [inline]
    [<00000000503be95b>] __x64_sys_socket+0x1a/0x20 net/socket.c:1533
    [<0000000042ce79c0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000b1aeae16>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888110f0d8c0 (size 64):
  comm "syz-executor783", pid 8417, jiffies 4294954395 (age 30.410s)
  hex dump (first 32 bytes):
    15 00 00 01 00 00 00 00 a0 39 dc 10 81 88 ff ff  .........9......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002bb571e8>] kmalloc include/linux/slab.h:555 [inline]
    [<000000002bb571e8>] kzalloc include/linux/slab.h:669 [inline]
    [<000000002bb571e8>] netlbl_secattr_alloc include/net/netlabel.h:382 [inline]
    [<000000002bb571e8>] selinux_netlbl_sock_genattr+0x48/0x180 security/selinux/netlabel.c:76
    [<00000000201274d5>] selinux_netlbl_socket_post_create+0x41/0xb0 security/selinux/netlabel.c:398
    [<00000000189429bf>] selinux_socket_post_create+0x182/0x390 security/selinux/hooks.c:4541
    [<0000000054916bb2>] security_socket_post_create+0x54/0x80 security/security.c:2032
    [<0000000085ba4813>] __sock_create+0x1cc/0x220 net/socket.c:1449
    [<000000007253d628>] sock_create net/socket.c:1484 [inline]
    [<000000007253d628>] __sys_socket+0x60/0x110 net/socket.c:1526
    [<00000000503be95b>] __do_sys_socket net/socket.c:1535 [inline]
    [<00000000503be95b>] __se_sys_socket net/socket.c:1533 [inline]
    [<00000000503be95b>] __x64_sys_socket+0x1a/0x20 net/socket.c:1533
    [<0000000042ce79c0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000b1aeae16>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888110dc39a0 (size 32):
  comm "syz-executor783", pid 8417, jiffies 4294954395 (age 30.410s)
  hex dump (first 32 bytes):
    6b 65 72 6e 65 6c 5f 74 00 73 79 73 74 65 6d 5f  kernel_t.system_
    72 3a 6b 65 72 6e 65 6c 5f 74 3a 73 30 00 00 00  r:kernel_t:s0...
  backtrace:
    [<0000000090b931e1>] kstrdup+0x36/0x70 mm/util.c:60
    [<0000000079ad8987>] security_netlbl_sid_to_secattr+0x97/0x100 security/selinux/ss/services.c:3739
    [<000000006911d3c9>] selinux_netlbl_sock_genattr+0x67/0x180 security/selinux/netlabel.c:79
    [<00000000201274d5>] selinux_netlbl_socket_post_create+0x41/0xb0 security/selinux/netlabel.c:398
    [<00000000189429bf>] selinux_socket_post_create+0x182/0x390 security/selinux/hooks.c:4541
    [<0000000054916bb2>] security_socket_post_create+0x54/0x80 security/security.c:2032
    [<0000000085ba4813>] __sock_create+0x1cc/0x220 net/socket.c:1449
    [<000000007253d628>] sock_create net/socket.c:1484 [inline]
    [<000000007253d628>] __sys_socket+0x60/0x110 net/socket.c:1526
    [<00000000503be95b>] __do_sys_socket net/socket.c:1535 [inline]
    [<00000000503be95b>] __se_sys_socket net/socket.c:1533 [inline]
    [<00000000503be95b>] __x64_sys_socket+0x1a/0x20 net/socket.c:1533
    [<0000000042ce79c0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000b1aeae16>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
