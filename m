Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A212F02CA
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 19:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbhAISIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 13:08:01 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:43846 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbhAISIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 13:08:01 -0500
Received: by mail-io1-f69.google.com with SMTP id c7so10186315iob.10
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 10:07:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BsWPSRLwA8RolMCenavGS+3Cc+3bFo32dZEP7iTFhQQ=;
        b=EmCPi0rZuHNesRcv3LBIZuyESln7FoMNElekS38wDDeCFnnxEzFnDucr1g7J7j/KG7
         W0JqsJnjuj9pqalaqRI6NzqXcaRYYP4Wl++BPHTlq/J4JpqYVU46zoxzvdEF8JuXkIQO
         h2xbZuRUIgjENiRZLrPwzHg3cb7GOGbezsHcLKh6RY0s0DOKfMj69jaGrO7cZ6+gufkf
         JSLiCX0smLY5vmkXm39ESz8ZGcLbw/YLJjrbWBqvAcwPXiF0E88z/IBqIBBO3qrYdT4L
         eTxZOTO57nySab9OHGlVwrJCs2vLGDaLptUUxwJqz5hwo21g5LTE6PTrBWGto92nili8
         sOFw==
X-Gm-Message-State: AOAM5333OUih9dNAHN7OxXoIoiT5nTSKGcqLVD/ebTx7uM2NvPd2iy9Z
        CVicTT/W9Y6kndCl88DFddj13K5bdy4UMmaq7DDOMQuSmbIx
X-Google-Smtp-Source: ABdhPJz2Fo27W90BS/ZeLDfCQnG0/dKaG79rae//EhtT+TWJtJJIc7bDQPUyhQPc9JFX+zteVapA2LGjHFUzMWEmpReY/N/GWimy
MIME-Version: 1.0
X-Received: by 2002:a02:c7d1:: with SMTP id s17mr8607663jao.142.1610215639684;
 Sat, 09 Jan 2021 10:07:19 -0800 (PST)
Date:   Sat, 09 Jan 2021 10:07:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000371e5a05b87b8bf9@google.com>
Subject: memory leak in tcp_cdg_init
From:   syzbot <syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    36bbbd0e Merge branch 'rcu/urgent' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ef4dfb500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b991a69440391446
dashboard link: https://syzkaller.appspot.com/bug?extid=f1e24a0594d4e3a895d3
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e1bb2b500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com

2021/01/05 17:50:00 executed programs: 127
2021/01/05 17:50:06 executed programs: 146
2021/01/05 17:50:12 executed programs: 157
2021/01/05 17:50:19 executed programs: 175
BUG: memory leak
unreferenced object 0xffff888125940080 (size 64):
  comm "syz-executor.1", pid 11113, jiffies 4294986279 (age 14.750s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000bf291225>] kmalloc_array include/linux/slab.h:592 [inline]
    [<00000000bf291225>] kcalloc include/linux/slab.h:621 [inline]
    [<00000000bf291225>] tcp_cdg_init+0x37/0x60 net/ipv4/tcp_cdg.c:380
    [<00000000f991e122>] tcp_init_congestion_control+0x31/0x160 net/ipv4/tcp_cong.c:183
    [<000000009761f0eb>] tcp_reinit_congestion_control net/ipv4/tcp_cong.c:207 [inline]
    [<000000009761f0eb>] tcp_set_congestion_control+0x35e/0x380 net/ipv4/tcp_cong.c:377
    [<00000000825a01e7>] do_tcp_setsockopt net/ipv4/tcp.c:3319 [inline]
    [<00000000825a01e7>] tcp_setsockopt+0x3fc/0x13f0 net/ipv4/tcp.c:3599
    [<0000000009f41711>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2115
    [<000000008873566c>] __do_sys_setsockopt net/socket.c:2126 [inline]
    [<000000008873566c>] __se_sys_setsockopt net/socket.c:2123 [inline]
    [<000000008873566c>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2123
    [<0000000048fbe902>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000b377d397>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888125940880 (size 64):
  comm "syz-executor.4", pid 11115, jiffies 4294986279 (age 14.750s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000bf291225>] kmalloc_array include/linux/slab.h:592 [inline]
    [<00000000bf291225>] kcalloc include/linux/slab.h:621 [inline]
    [<00000000bf291225>] tcp_cdg_init+0x37/0x60 net/ipv4/tcp_cdg.c:380
    [<00000000f991e122>] tcp_init_congestion_control+0x31/0x160 net/ipv4/tcp_cong.c:183
    [<000000009761f0eb>] tcp_reinit_congestion_control net/ipv4/tcp_cong.c:207 [inline]
    [<000000009761f0eb>] tcp_set_congestion_control+0x35e/0x380 net/ipv4/tcp_cong.c:377
    [<00000000825a01e7>] do_tcp_setsockopt net/ipv4/tcp.c:3319 [inline]
    [<00000000825a01e7>] tcp_setsockopt+0x3fc/0x13f0 net/ipv4/tcp.c:3599
    [<0000000009f41711>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2115
    [<000000008873566c>] __do_sys_setsockopt net/socket.c:2126 [inline]
    [<000000008873566c>] __se_sys_setsockopt net/socket.c:2123 [inline]
    [<000000008873566c>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2123
    [<0000000048fbe902>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000b377d397>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
