Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066531BA554
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgD0NsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:48:18 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:34894 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgD0NsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 09:48:17 -0400
Received: by mail-io1-f70.google.com with SMTP id s26so20419362ioj.2
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 06:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=IKLvnmX2O6G5JUPiVLiWpSP3a5qdDUhizIddlOL+gt0=;
        b=jbZPfx3u8DnCglQZ0R2YIaWF0ZHofwUhDI8GbQ24EYXnWyqKboXYoBxvq9FxoaIMHY
         5q6dYBPnE2ch7KQuFUkahZx3i3y/WMkjYVrMhN1nvOq2gK+PqXRN+oTsfbM+Eg+3mGid
         hqNimQnzMH62B1DOtGifNiaLP1JenxOfuP2oE9CiIVqpmhucRQbBU46XSTWmbiMN3WUu
         oefCAjFcceg5TON4N2ZPMuzht2nToQXl5XFUA4zGJKFAmpRFqsXYvgQrlr07+9mIZM+W
         e+0b6M64Gaj4xXdGALWpmkVwrke1J/OjA6GKg6DLe8q9s3+n4Mnyy6ttlDA+KmeDrPD4
         rlig==
X-Gm-Message-State: AGi0PubSFMrFuJQHLr3zA+aTAWirZM37SKs3lrTJ1ApPrKsi/0FEEnH7
        yFTY7Sxyaw+KY1Le2FsSMLRWuvzYd5n5PdJSIiwl4qfcDB8d
X-Google-Smtp-Source: APiQypJMIAfRCG58K421qGBsaWHhvtaekdn2fEP6m3wE4vbwtCLcO2tCumRPcC8TM6DhEFnx4rznkFHTrAySJgtc01uMdr9hjAn5
MIME-Version: 1.0
X-Received: by 2002:a02:5184:: with SMTP id s126mr9960216jaa.81.1587995295346;
 Mon, 27 Apr 2020 06:48:15 -0700 (PDT)
Date:   Mon, 27 Apr 2020 06:48:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007bf88805a445f729@google.com>
Subject: memory leak in inet_create (2)
From:   syzbot <syzbot+bb7ba8dd62c3cb6e3c78@syzkaller.appspotmail.com>
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

HEAD commit:    5ef58e29 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f0f144100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bb30a3887988ffff
dashboard link: https://syzkaller.appspot.com/bug?extid=bb7ba8dd62c3cb6e3c78
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110e8fcfe00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bb7ba8dd62c3cb6e3c78@syzkaller.appspotmail.com

2020/04/25 22:35:25 executed programs: 3
2020/04/25 22:35:30 executed programs: 5
2020/04/25 22:35:36 executed programs: 7
BUG: memory leak
unreferenced object 0xffff88811094b300 (size 2200):
  comm "syz-executor.0", pid 6864, jiffies 4294947266 (age 13.790s)
  hex dump (first 32 bytes):
    ac 14 14 bb ac 14 14 0a 89 26 f2 70 40 01 00 00  .........&.p@...
    02 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace:
    [<000000002efa2559>] sk_prot_alloc+0x3c/0x170 net/core/sock.c:1598
    [<00000000a5b6b437>] sk_alloc+0x30/0x330 net/core/sock.c:1658
    [<00000000494c18b6>] inet_create net/ipv4/af_inet.c:321 [inline]
    [<00000000494c18b6>] inet_create+0x119/0x450 net/ipv4/af_inet.c:247
    [<000000001239bbdb>] __sock_create+0x14a/0x220 net/socket.c:1433
    [<00000000c1f7caa8>] sock_create net/socket.c:1484 [inline]
    [<00000000c1f7caa8>] __sys_socket+0x60/0x110 net/socket.c:1526
    [<00000000d35154cc>] __do_sys_socket net/socket.c:1535 [inline]
    [<00000000d35154cc>] __se_sys_socket net/socket.c:1533 [inline]
    [<00000000d35154cc>] __x64_sys_socket+0x1a/0x20 net/socket.c:1533
    [<00000000283ef9ec>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<000000004290d57b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811b253f60 (size 32):
  comm "syz-executor.0", pid 6864, jiffies 4294947266 (age 13.790s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 c0 3d 3f 15 81 88 ff ff  .........=?.....
    01 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000007d627037>] kmalloc include/linux/slab.h:555 [inline]
    [<000000007d627037>] kzalloc include/linux/slab.h:669 [inline]
    [<000000007d627037>] selinux_sk_alloc_security+0x43/0xa0 security/selinux/hooks.c:5126
    [<0000000076a22383>] security_sk_alloc+0x42/0x70 security/security.c:2120
    [<0000000066acd291>] sk_prot_alloc+0x9c/0x170 net/core/sock.c:1607
    [<00000000a5b6b437>] sk_alloc+0x30/0x330 net/core/sock.c:1658
    [<00000000494c18b6>] inet_create net/ipv4/af_inet.c:321 [inline]
    [<00000000494c18b6>] inet_create+0x119/0x450 net/ipv4/af_inet.c:247
    [<000000001239bbdb>] __sock_create+0x14a/0x220 net/socket.c:1433
    [<00000000c1f7caa8>] sock_create net/socket.c:1484 [inline]
    [<00000000c1f7caa8>] __sys_socket+0x60/0x110 net/socket.c:1526
    [<00000000d35154cc>] __do_sys_socket net/socket.c:1535 [inline]
    [<00000000d35154cc>] __se_sys_socket net/socket.c:1533 [inline]
    [<00000000d35154cc>] __x64_sys_socket+0x1a/0x20 net/socket.c:1533
    [<00000000283ef9ec>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<000000004290d57b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881153f3dc0 (size 64):
  comm "syz-executor.0", pid 6864, jiffies 4294947266 (age 13.790s)
  hex dump (first 32 bytes):
    15 00 00 01 00 00 00 00 20 68 e9 1c 81 88 ff ff  ........ h......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000dde82831>] kmalloc include/linux/slab.h:555 [inline]
    [<00000000dde82831>] kzalloc include/linux/slab.h:669 [inline]
    [<00000000dde82831>] netlbl_secattr_alloc include/net/netlabel.h:382 [inline]
    [<00000000dde82831>] selinux_netlbl_sock_genattr+0x48/0x180 security/selinux/netlabel.c:76
    [<00000000438c6346>] selinux_netlbl_socket_post_create+0x41/0xb0 security/selinux/netlabel.c:398
    [<00000000b422abf2>] selinux_socket_post_create+0x182/0x390 security/selinux/hooks.c:4541
    [<000000005be0d1ac>] security_socket_post_create+0x54/0x80 security/security.c:2032
    [<00000000a0ec3d71>] __sock_create+0x1cc/0x220 net/socket.c:1449
    [<00000000c1f7caa8>] sock_create net/socket.c:1484 [inline]
    [<00000000c1f7caa8>] __sys_socket+0x60/0x110 net/socket.c:1526
    [<00000000d35154cc>] __do_sys_socket net/socket.c:1535 [inline]
    [<00000000d35154cc>] __se_sys_socket net/socket.c:1533 [inline]
    [<00000000d35154cc>] __x64_sys_socket+0x1a/0x20 net/socket.c:1533
    [<00000000283ef9ec>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<000000004290d57b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811ce96820 (size 32):
  comm "syz-executor.0", pid 6864, jiffies 4294947266 (age 13.790s)
  hex dump (first 32 bytes):
    6b 65 72 6e 65 6c 5f 74 00 73 79 73 74 65 6d 5f  kernel_t.system_
    72 3a 6b 65 72 6e 65 6c 5f 74 3a 73 30 00 00 00  r:kernel_t:s0...
  backtrace:
    [<000000007edbec14>] kstrdup+0x36/0x70 mm/util.c:60
    [<00000000b343d2c4>] security_netlbl_sid_to_secattr+0x97/0x100 security/selinux/ss/services.c:3739
    [<00000000ddb8495a>] selinux_netlbl_sock_genattr+0x67/0x180 security/selinux/netlabel.c:79
    [<00000000438c6346>] selinux_netlbl_socket_post_create+0x41/0xb0 security/selinux/netlabel.c:398
    [<00000000b422abf2>] selinux_socket_post_create+0x182/0x390 security/selinux/hooks.c:4541
    [<000000005be0d1ac>] security_socket_post_create+0x54/0x80 security/security.c:2032
    [<00000000a0ec3d71>] __sock_create+0x1cc/0x220 net/socket.c:1449
    [<00000000c1f7caa8>] sock_create net/socket.c:1484 [inline]
    [<00000000c1f7caa8>] __sys_socket+0x60/0x110 net/socket.c:1526
    [<00000000d35154cc>] __do_sys_socket net/socket.c:1535 [inline]
    [<00000000d35154cc>] __se_sys_socket net/socket.c:1533 [inline]
    [<00000000d35154cc>] __x64_sys_socket+0x1a/0x20 net/socket.c:1533
    [<00000000283ef9ec>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<000000004290d57b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881113aa400 (size 512):
  comm "syz-executor.0", pid 6864, jiffies 4294947266 (age 13.790s)
  hex dump (first 32 bytes):
    00 b3 94 10 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 03 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000031227790>] kmalloc_node include/linux/slab.h:573 [inline]
    [<0000000031227790>] kzalloc_node include/linux/slab.h:680 [inline]
    [<0000000031227790>] sk_psock_init+0x2a/0x180 net/core/skmsg.c:496
    [<00000000a405c065>] sock_map_link.isra.0+0x469/0x4f0 net/core/sock_map.c:236
    [<000000003b7d5922>] sock_map_update_common+0xa1/0x3c0 net/core/sock_map.c:451
    [<00000000f12c515e>] sock_map_update_elem+0x1e9/0x220 net/core/sock_map.c:552
    [<000000000fedde3d>] bpf_map_update_value.isra.0+0x141/0x2f0 kernel/bpf/syscall.c:169
    [<000000004deb6133>] map_update_elem kernel/bpf/syscall.c:1098 [inline]
    [<000000004deb6133>] __do_sys_bpf+0x16bf/0x1f00 kernel/bpf/syscall.c:3689
    [<00000000283ef9ec>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<000000004290d57b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
