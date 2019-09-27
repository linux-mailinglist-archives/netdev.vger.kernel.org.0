Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDDFBFCA9
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 03:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfI0BTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 21:19:12 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:53572 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfI0BTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 21:19:11 -0400
Received: by mail-io1-f71.google.com with SMTP id w8so8697690iol.20
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 18:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mi8lauVOvgpW0sRVX5CncHViKZCNtn/dgkBU1pzhQIk=;
        b=ER0hWhBjsWR7yMlPWqYPH55ytVcEOxfsbOpsM1uzr7Tb2g+TC/4WG/UviRIFhtrSoz
         K97jrfvQJFhhneLwtBQ1a0lvWDQWsJd7phF3IlE7aAfV72V4MT9fR5atRACYi8lRuQia
         ukiTeE1SmP7KayS0EC51TvJeACWjBJYtmwd79XldthV31jTi4xWWwVHf1ZzFI6GfjdES
         QOz9dBLTCB6mH504eI9SSmXbaxkCk6CtSWqsEC/2KrS4LrpFtx+2yLHiz7/r57crzkmI
         K9urIu/BtlHQsYcMsICIPWNuslfSH3nsNiWIWRrLqzVesQWEPxND/UhKSuJW9BPUQLJC
         ecng==
X-Gm-Message-State: APjAAAXSuTf+OZ3HPS1K6Xs+XMT3q+g5oOEBEsGbXvNvfYP3he4rHFmN
        9dNH/mSUvXjYNo8Rn8u6//JRmyah84Wzv9KSxP+yXThWZPUD
X-Google-Smtp-Source: APXvYqyz6lC33pgSvhNu+WIQYUFqnDUmCNjc6GOB/af2rJtTmtzOY+aFDgWLHTBWQau7Gq+oL0Rh/ndmyeDfBZQ2G4LKFO8XOJCv
MIME-Version: 1.0
X-Received: by 2002:a92:3601:: with SMTP id d1mr1835580ila.253.1569547149089;
 Thu, 26 Sep 2019 18:19:09 -0700 (PDT)
Date:   Thu, 26 Sep 2019 18:19:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000047a6eb05937eaced@google.com>
Subject: memory leak in tls_init
From:   syzbot <syzbot+35bc8fe94c9f38db8320@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f41def39 Merge tag 'ceph-for-5.4-rc1' of git://github.com/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=105b7ff9600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2e29707d7d1530b3
dashboard link: https://syzkaller.appspot.com/bug?extid=35bc8fe94c9f38db8320
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145b3419600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+35bc8fe94c9f38db8320@syzkaller.appspotmail.com

2019/09/26 13:11:21 executed programs: 23
BUG: memory leak
unreferenced object 0xffff88810e482a00 (size 512):
   comm "syz-executor.4", pid 6874, jiffies 4295090041 (age 14.090s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000e93f019a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e93f019a>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000e93f019a>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000e93f019a>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000268637bd>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000268637bd>] kzalloc include/linux/slab.h:686 [inline]
     [<00000000268637bd>] create_ctx net/tls/tls_main.c:611 [inline]
     [<00000000268637bd>] tls_init net/tls/tls_main.c:794 [inline]
     [<00000000268637bd>] tls_init+0xbc/0x200 net/tls/tls_main.c:773
     [<00000000f52c33c5>] __tcp_set_ulp net/ipv4/tcp_ulp.c:139 [inline]
     [<00000000f52c33c5>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:160
     [<0000000009cb49a0>] do_tcp_setsockopt.isra.0+0x1c1/0xe10  
net/ipv4/tcp.c:2825
     [<00000000b9d96429>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3152
     [<0000000038a5546c>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3142
     [<00000000d945b2a0>] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
     [<000000003c3afaa0>] __do_sys_setsockopt net/socket.c:2100 [inline]
     [<000000003c3afaa0>] __se_sys_setsockopt net/socket.c:2097 [inline]
     [<000000003c3afaa0>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2097
     [<00000000f7f21cbd>] do_syscall_64+0x73/0x1f0  
arch/x86/entry/common.c:290
     [<00000000d4c003b9>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810e71e600 (size 512):
   comm "syz-executor.4", pid 6888, jiffies 4295090060 (age 13.900s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000e93f019a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e93f019a>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000e93f019a>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000e93f019a>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000268637bd>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000268637bd>] kzalloc include/linux/slab.h:686 [inline]
     [<00000000268637bd>] create_ctx net/tls/tls_main.c:611 [inline]
     [<00000000268637bd>] tls_init net/tls/tls_main.c:794 [inline]
     [<00000000268637bd>] tls_init+0xbc/0x200 net/tls/tls_main.c:773
     [<00000000f52c33c5>] __tcp_set_ulp net/ipv4/tcp_ulp.c:139 [inline]
     [<00000000f52c33c5>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:160
     [<0000000009cb49a0>] do_tcp_setsockopt.isra.0+0x1c1/0xe10  
net/ipv4/tcp.c:2825
     [<00000000b9d96429>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3152
     [<0000000038a5546c>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3142
     [<00000000d945b2a0>] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
     [<000000003c3afaa0>] __do_sys_setsockopt net/socket.c:2100 [inline]
     [<000000003c3afaa0>] __se_sys_setsockopt net/socket.c:2097 [inline]
     [<000000003c3afaa0>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2097
     [<00000000f7f21cbd>] do_syscall_64+0x73/0x1f0  
arch/x86/entry/common.c:290
     [<00000000d4c003b9>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810e356800 (size 512):
   comm "syz-executor.0", pid 6926, jiffies 4295090085 (age 13.650s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000e93f019a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e93f019a>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000e93f019a>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000e93f019a>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000268637bd>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000268637bd>] kzalloc include/linux/slab.h:686 [inline]
     [<00000000268637bd>] create_ctx net/tls/tls_main.c:611 [inline]
     [<00000000268637bd>] tls_init net/tls/tls_main.c:794 [inline]
     [<00000000268637bd>] tls_init+0xbc/0x200 net/tls/tls_main.c:773
     [<00000000f52c33c5>] __tcp_set_ulp net/ipv4/tcp_ulp.c:139 [inline]
     [<00000000f52c33c5>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:160
     [<0000000009cb49a0>] do_tcp_setsockopt.isra.0+0x1c1/0xe10  
net/ipv4/tcp.c:2825
     [<00000000b9d96429>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3152
     [<0000000038a5546c>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3142
     [<00000000d945b2a0>] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
     [<000000003c3afaa0>] __do_sys_setsockopt net/socket.c:2100 [inline]
     [<000000003c3afaa0>] __se_sys_setsockopt net/socket.c:2097 [inline]
     [<000000003c3afaa0>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2097
     [<00000000f7f21cbd>] do_syscall_64+0x73/0x1f0  
arch/x86/entry/common.c:290
     [<00000000d4c003b9>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810e3df600 (size 512):
   comm "syz-executor.4", pid 6933, jiffies 4295090088 (age 13.620s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000e93f019a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e93f019a>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<00000000e93f019a>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000e93f019a>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000268637bd>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000268637bd>] kzalloc include/linux/slab.h:686 [inline]
     [<00000000268637bd>] create_ctx net/tls/tls_main.c:611 [inline]
     [<00000000268637bd>] tls_init net/tls/tls_main.c:794 [inline]
     [<00000000268637bd>] tls_init+0xbc/0x200 net/tls/tls_main.c:773
     [<00000000f52c33c5>] __tcp_set_ulp net/ipv4/tcp_ulp.c:139 [inline]
     [<00000000f52c33c5>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:160
     [<0000000009cb49a0>] do_tcp_setsockopt.isra.0+0x1c1/0xe10  
net/ipv4/tcp.c:2825
     [<00000000b9d96429>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3152
     [<0000000038a5546c>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3142
     [<00000000d945b2a0>] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
     [<000000003c3afaa0>] __do_sys_setsockopt net/socket.c:2100 [inline]
     [<000000003c3afaa0>] __se_sys_setsockopt net/socket.c:2097 [inline]
     [<000000003c3afaa0>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2097
     [<00000000f7f21cbd>] do_syscall_64+0x73/0x1f0  
arch/x86/entry/common.c:290
     [<00000000d4c003b9>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
