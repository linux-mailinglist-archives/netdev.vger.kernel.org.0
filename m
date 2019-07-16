Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A7A6A30E
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 09:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfGPHiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 03:38:06 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:33449 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfGPHiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 03:38:06 -0400
Received: by mail-io1-f69.google.com with SMTP id 132so22565041iou.0
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 00:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bJw9LnzY1rJ9isWjFMt+q8i/a0JnuAOn1wY69zF7tck=;
        b=Pzdc2fmoHbvpfuKqsfjrixNh7/Osqp3PL0qX9nkQeC9VF9bPVlIq13EFZllb14KRWm
         t4sL+uHq1tnDYTpnq0CFs3m1ajv7LxeJWHw1YuKG4vk4+kju/MBLLZRf2lrZIeuizb2B
         2XV6/775yhtJNgB1UMAjWoVBZm9Gk78zNxxq/EgxhW+8TERZqUpAxSgx2HtYib4W6TX2
         b3pHPLlYIIEI7xlXvHdPgP6t5p5wX7LuRaIneP+wvPLmsA4kcOlwvgAtiIKgai9R69CJ
         WXMg+TbNr9WKTTJFYkUjmEv5entjAYFckUKzqFUEZ4lsDwa3UUwNfXGKQpLHe3PLYCg5
         e/gA==
X-Gm-Message-State: APjAAAUcm1ITPfxa3WIdBivoAsHgvMDBY6LtFaiReHTG6AshMdl88OHl
        tqQ/AsA+9QxrdMDJNyzzsLOaPcCnfBXwCXyym3qhSiSsLmND
X-Google-Smtp-Source: APXvYqzyQlT37VPrWgoxkTZJsxTXY1bdJjfO+iKbm9CvgHcG4Czjv38KmkR7c6mQqGt31S/UIIc4uRt3bJdiyVSOEhBiNeTlRCz7
MIME-Version: 1.0
X-Received: by 2002:a02:c615:: with SMTP id i21mr32100870jan.135.1563262685615;
 Tue, 16 Jul 2019 00:38:05 -0700 (PDT)
Date:   Tue, 16 Jul 2019 00:38:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000111cbe058dc7754d@google.com>
Subject: memory leak in new_inode_pseudo (2)
From:   syzbot <syzbot+e682cca30bc101a4d9d9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    fec88ab0 Merge tag 'for-linus-hmm' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15a3da1fa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8422fa55ce69212c
dashboard link: https://syzkaller.appspot.com/bug?extid=e682cca30bc101a4d9d9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ca5aa4600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e682cca30bc101a4d9d9@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff8881223e5980 (size 768):
   comm "syz-executor.0", pid 7093, jiffies 4294950175 (age 8.140s)
   hex dump (first 32 bytes):
     01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<0000000030f6ab07>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000030f6ab07>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000030f6ab07>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000030f6ab07>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
     [<0000000005b17a67>] sock_alloc_inode+0x1c/0xa0 net/socket.c:238
     [<00000000cae2a9b4>] alloc_inode+0x2c/0xe0 fs/inode.c:227
     [<000000004d22e56a>] new_inode_pseudo+0x18/0x70 fs/inode.c:916
     [<000000007bb4d82d>] sock_alloc+0x1c/0x90 net/socket.c:554
     [<00000000884dfd41>] __sock_create+0x8f/0x250 net/socket.c:1378
     [<000000009dc85063>] sock_create_kern+0x3b/0x50 net/socket.c:1483
     [<00000000ca0afb1d>] smc_create+0xae/0x160 net/smc/af_smc.c:1975
     [<00000000ff903d89>] __sock_create+0x164/0x250 net/socket.c:1414
     [<00000000c0787cdf>] sock_create net/socket.c:1465 [inline]
     [<00000000c0787cdf>] __sys_socket+0x69/0x110 net/socket.c:1507
     [<0000000067a4ade6>] __do_sys_socket net/socket.c:1516 [inline]
     [<0000000067a4ade6>] __se_sys_socket net/socket.c:1514 [inline]
     [<0000000067a4ade6>] __x64_sys_socket+0x1e/0x30 net/socket.c:1514
     [<000000001e7b04ac>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000003fe40e36>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811f269f50 (size 56):
   comm "syz-executor.0", pid 7093, jiffies 4294950175 (age 8.140s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 5a 3e 22 81 88 ff ff 68 9f 26 1f 81 88 ff ff  .Z>"....h.&.....
   backtrace:
     [<0000000030f6ab07>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000030f6ab07>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000030f6ab07>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000030f6ab07>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
     [<000000005d4d6be7>] kmem_cache_zalloc include/linux/slab.h:738 [inline]
     [<000000005d4d6be7>] lsm_inode_alloc security/security.c:522 [inline]
     [<000000005d4d6be7>] security_inode_alloc+0x33/0xb0  
security/security.c:875
     [<00000000ef89212c>] inode_init_always+0x108/0x200 fs/inode.c:169
     [<00000000647feaf5>] alloc_inode+0x49/0xe0 fs/inode.c:234
     [<000000004d22e56a>] new_inode_pseudo+0x18/0x70 fs/inode.c:916
     [<000000007bb4d82d>] sock_alloc+0x1c/0x90 net/socket.c:554
     [<00000000884dfd41>] __sock_create+0x8f/0x250 net/socket.c:1378
     [<000000009dc85063>] sock_create_kern+0x3b/0x50 net/socket.c:1483
     [<00000000ca0afb1d>] smc_create+0xae/0x160 net/smc/af_smc.c:1975
     [<00000000ff903d89>] __sock_create+0x164/0x250 net/socket.c:1414
     [<00000000c0787cdf>] sock_create net/socket.c:1465 [inline]
     [<00000000c0787cdf>] __sys_socket+0x69/0x110 net/socket.c:1507
     [<0000000067a4ade6>] __do_sys_socket net/socket.c:1516 [inline]
     [<0000000067a4ade6>] __se_sys_socket net/socket.c:1514 [inline]
     [<0000000067a4ade6>] __x64_sys_socket+0x1e/0x30 net/socket.c:1514
     [<000000001e7b04ac>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000003fe40e36>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
