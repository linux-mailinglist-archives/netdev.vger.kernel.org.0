Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0FB0113ECD
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 10:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbfLEJzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 04:55:10 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:55779 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729072AbfLEJzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 04:55:10 -0500
Received: by mail-io1-f70.google.com with SMTP id z21so1988358iob.22
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 01:55:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UEstprLMXsCJ/HcpDk+4IwZmvggk9j9Se+yVTAfNs9w=;
        b=bnPgss1Fa3AK07HiUvfjDVFndoUcuBgaCXMHTtAk+z/rEMS4UEWudkBzp53vISllT+
         P7xnf7IewbAsmQMPsmAS69GmzCk8fMEow6QUS03BA+jVORos7KIwikRMhS7UB6pMrI2w
         5PwDABG9SxNHhKtct7Z61u5zTMvOB16eacfeu5PTgEdO5KW4XRXnjmj/rtJ0DzWrsan0
         QeDokvTeH9ndIHeVjbuVJ5pueobzPoXBrFsPTnCPDpen5ozLMpMbNpEot5DUqHA4+/j4
         WeUNjw17hR/A+5i8mWIyTMr62w0kIAuGsq84lO7DkMEW8Gfl9QrJ1H1SZbH4csQL8O1u
         vgzg==
X-Gm-Message-State: APjAAAXi+EdSOsp2MlXXGaA4ABAUUrysxfPFjpT0YHw/bnfsWmvf8oVa
        o706tycA7bRUPK4t+XlKwuWfn7puIcEvbVVbx2yYwV6/2KVL
X-Google-Smtp-Source: APXvYqxEC5Hd+oGaUcY0dxSeF8ga0fUvD8JgCnawrnQBgpnq74Q3Bc3hsmSle+e1lMUiawGmo49tPO6f/EJzGkzv5s9tyC1W32Sd
MIME-Version: 1.0
X-Received: by 2002:a02:ca42:: with SMTP id i2mr7387961jal.87.1575539709420;
 Thu, 05 Dec 2019 01:55:09 -0800 (PST)
Date:   Thu, 05 Dec 2019 01:55:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b5aff60598f1ec45@google.com>
Subject: memory leak in genl_rcv_msg
From:   syzbot <syzbot+21f04f481f449c8db840@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@mellanox.com, johannes.berg@intel.com,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    32ef9553 Merge tag 'fsnotify_for_v5.5-rc1' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e778eae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3ceab2bd652d6555
dashboard link: https://syzkaller.appspot.com/bug?extid=21f04f481f449c8db840
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11808adae00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=137058eae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+21f04f481f449c8db840@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888121379340 (size 32):
   comm "syz-executor138", pid 7118, jiffies 4294943875 (age 7.840s)
   hex dump (first 32 bytes):
     40 e9 11 84 ff ff ff ff d8 0a b4 83 ff ff ff ff  @...............
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000005c57b8f8>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000005c57b8f8>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000005c57b8f8>] slab_alloc mm/slab.c:3319 [inline]
     [<000000005c57b8f8>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<000000005e5d1167>] kmalloc include/linux/slab.h:556 [inline]
     [<000000005e5d1167>] genl_dumpit_info_alloc net/netlink/genetlink.c:463  
[inline]
     [<000000005e5d1167>] genl_family_rcv_msg_dumpit  
net/netlink/genetlink.c:597 [inline]
     [<000000005e5d1167>] genl_family_rcv_msg net/netlink/genetlink.c:714  
[inline]
     [<000000005e5d1167>] genl_rcv_msg+0x385/0x580  
net/netlink/genetlink.c:734
     [<00000000f3f6d30b>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2477
     [<000000007bebabc8>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:745
     [<0000000013f3b7b9>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1302 [inline]
     [<0000000013f3b7b9>] netlink_unicast+0x223/0x310  
net/netlink/af_netlink.c:1328
     [<00000000bd3e2e68>] netlink_sendmsg+0x29f/0x550  
net/netlink/af_netlink.c:1917
     [<0000000061329f0f>] sock_sendmsg_nosec net/socket.c:638 [inline]
     [<0000000061329f0f>] sock_sendmsg+0x54/0x70 net/socket.c:658
     [<000000006ede6ef7>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2329
     [<000000008306e582>] ___sys_sendmsg+0x9c/0x100 net/socket.c:2383
     [<00000000194a34f7>] __sys_sendmsg+0x80/0xf0 net/socket.c:2429
     [<00000000a228fcfc>] __do_sys_sendmsg net/socket.c:2438 [inline]
     [<00000000a228fcfc>] __se_sys_sendmsg net/socket.c:2436 [inline]
     [<00000000a228fcfc>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2436
     [<0000000035c29044>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<000000005e1aef5b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
