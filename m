Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84B023E79A
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 09:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgHGHQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 03:16:31 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:35183 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgHGHQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 03:16:23 -0400
Received: by mail-il1-f199.google.com with SMTP id g6so866109iln.2
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 00:16:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=W4cVy11OCLnN/zPHpr+tWScWweV3Vb2c1Wlz/XJooDc=;
        b=bsUFc5HrMeweqXqqAmL49v8sMmhgh+1EZcscIMvgcTBbGxSwQHhcbC696Cmhd2sd4v
         +dw8gzgJIIZrm1mbyzx1CeXRkZiTC3M1nnXJf0opNQVUfK6vMLjZ7+5G0mc2TAm6VOje
         B9Hsa5x4JLVin6d1aekIw44SkxBn9WnTRX5d28dfRJGayw1b9LYlXEPSucgaAIPAVvoz
         mEyQW+AG3njYO5PpXmdd6cDDE4sgKBjEL2wEqz3hpBATWiJmq5yMW7Wm6ZkdN7KNdE/0
         Y/v5FSkdF3tNQ8vjteK/dWlPAxC1XwInN81hVMwavQg3imIzsaU5S3UeJCLGuVfFkmWw
         Pbcw==
X-Gm-Message-State: AOAM533oDRbGjGTOU7CZygpmSUf+chf1iTVkGiF5cqeoJuNoYy3aJirX
        BSgWla/8OIB3OTNJTrjShQghOxMK+RztuBsqO1/WorEWPRzA
X-Google-Smtp-Source: ABdhPJxpxMAx65WmbFFSsgv31NegkqlA8MObGTlpV+ua7JbfBjLtrdjKhGoSE+RixHS8C6A5HqQansj7ioPkTjlLoXF/+U8dRujA
MIME-Version: 1.0
X-Received: by 2002:a92:d782:: with SMTP id d2mr3215408iln.8.1596784582572;
 Fri, 07 Aug 2020 00:16:22 -0700 (PDT)
Date:   Fri, 07 Aug 2020 00:16:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3c45105ac44616f@google.com>
Subject: memory leak in hci_conn_add
From:   syzbot <syzbot+52b86f9cc3cda3b318e0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    47ec5303 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a0122c900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eab224ce244e423c
dashboard link: https://syzkaller.appspot.com/bug?extid=52b86f9cc3cda3b318e0
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=118774aa900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+52b86f9cc3cda3b318e0@syzkaller.appspotmail.com

2020/08/07 02:25:22 executed programs: 153
BUG: memory leak
unreferenced object 0xffff88811aef9800 (size 2048):
  comm "syz-executor.0", pid 7170, jiffies 4295036619 (age 51.850s)
  hex dump (first 32 bytes):
    00 40 3d 15 81 88 ff ff 22 01 00 00 00 00 ad de  .@=.....".......
    00 00 00 00 11 aa aa aa aa aa 00 aa aa aa aa aa  ................
  backtrace:
    [<00000000d9c20f00>] kmalloc include/linux/slab.h:555 [inline]
    [<00000000d9c20f00>] kzalloc include/linux/slab.h:669 [inline]
    [<00000000d9c20f00>] hci_conn_add+0x2e/0x4a0 net/bluetooth/hci_conn.c:525
    [<0000000035c3df04>] hci_connect_acl net/bluetooth/hci_conn.c:1252 [inline]
    [<0000000035c3df04>] hci_connect_acl+0x154/0x170 net/bluetooth/hci_conn.c:1237
    [<0000000084224e06>] l2cap_chan_connect+0x2bb/0xbb0 net/bluetooth/l2cap_core.c:7900
    [<000000008efaf6d0>] bt_6lowpan_connect net/bluetooth/6lowpan.c:932 [inline]
    [<000000008efaf6d0>] lowpan_control_write+0x2fb/0x380 net/bluetooth/6lowpan.c:1166
    [<00000000d92efe51>] full_proxy_write+0x61/0x90 fs/debugfs/file.c:234
    [<000000007171039b>] vfs_write+0xfa/0x250 fs/read_write.c:576
    [<000000006150b244>] ksys_write+0x72/0x120 fs/read_write.c:631
    [<00000000c631a395>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000f2b9f07c>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811c49f200 (size 512):
  comm "syz-executor.0", pid 7170, jiffies 4295036619 (age 51.850s)
  hex dump (first 32 bytes):
    00 98 ef 1a 81 88 ff ff c0 9a 3e 15 81 88 ff ff  ..........>.....
    fd 03 00 00 00 00 00 00 00 06 00 00 00 00 00 00  ................
  backtrace:
    [<000000003ade7b37>] kmalloc include/linux/slab.h:555 [inline]
    [<000000003ade7b37>] kzalloc include/linux/slab.h:669 [inline]
    [<000000003ade7b37>] l2cap_conn_add.part.0+0x3b/0x300 net/bluetooth/l2cap_core.c:7702
    [<00000000c0f3ada8>] l2cap_conn_add net/bluetooth/l2cap_core.c:7888 [inline]
    [<00000000c0f3ada8>] l2cap_chan_connect+0x742/0xbb0 net/bluetooth/l2cap_core.c:7909
    [<000000008efaf6d0>] bt_6lowpan_connect net/bluetooth/6lowpan.c:932 [inline]
    [<000000008efaf6d0>] lowpan_control_write+0x2fb/0x380 net/bluetooth/6lowpan.c:1166
    [<00000000d92efe51>] full_proxy_write+0x61/0x90 fs/debugfs/file.c:234
    [<000000007171039b>] vfs_write+0xfa/0x250 fs/read_write.c:576
    [<000000006150b244>] ksys_write+0x72/0x120 fs/read_write.c:631
    [<00000000c631a395>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000f2b9f07c>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
