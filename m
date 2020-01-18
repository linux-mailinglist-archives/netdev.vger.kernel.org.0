Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DABB3141688
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 09:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgARI1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 03:27:12 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:49881 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgARI1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 03:27:11 -0500
Received: by mail-il1-f197.google.com with SMTP id j21so20820858ilf.16
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 00:27:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=R1FC2VQFkGKJMrNldgUHX6oyCmcJr7euyd2+3MRfUF8=;
        b=oVodqtwUL934c79sxI0krHINx0rnFLg58fvMIFP2Tg54DnAhxw9xvK9QRZfoiyx67h
         H6xg0YKpHIk1n2X3xsaLow/hwrBmalqOAUYMbEQHTjsfwNOzOB0o6ao8bQjdN4hAEUp1
         L/zstxLPuwvPtWF29AjdIircBsFrURYyXf8eYzRwI0VHCoo++r/jQp8G9wHzxFuocsig
         c8kqzQxfAG2jg3TdjMIAix62iL5SfZsgXMffaQYwxRLPYAwSQqSw5vAPFwhGqv7YtMD6
         gRrtzhTeSDzcP6ZUyN5PL3IXuWg/o/iMGeDs+nk7BJnxYhVfY4HlG7PXsrAgNwSRHMel
         tjAw==
X-Gm-Message-State: APjAAAXs/UAPgYo91uxIvQf1gijCi8v9N/8N6JusegZiltj2baEQVs51
        zeO6H3LJ4RgRK3sx/pf4coIZSyhtvZd9ZipSMqP7rxndyj3K
X-Google-Smtp-Source: APXvYqzR7Ph3Vmx77KY8Q2s+ShM3ergqG8VPNNJGf9TAHYTW5nHGem5MBy+6j967MVy1kjhnYEuyz30U04xqhoUeFwVZk0ldhr8V
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:f0f:: with SMTP id x15mr2205856ilj.298.1579336030985;
 Sat, 18 Jan 2020 00:27:10 -0800 (PST)
Date:   Sat, 18 Jan 2020 00:27:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001ba488059c65d352@google.com>
Subject: BUG: corrupted list in __nf_tables_abort
From:   syzbot <syzbot+437bf61d165c87bd40fb@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5a9ef194 net: systemport: Fixed queue mapping in internal ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15efd8d6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=437bf61d165c87bd40fb
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1285ccc9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1424c135e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+437bf61d165c87bd40fb@syzkaller.appspotmail.com

netlink: 20 bytes leftover after parsing attributes in process `syz-executor790'.
list_del corruption, ffff8880a302a400->prev is LIST_POISON2 (dead000000000122)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:48!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 10047 Comm: syz-executor790 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__list_del_entry_valid.cold+0x37/0x4f lib/list_debug.c:48
Code: be fd 0f 0b 4c 89 ea 4c 89 f6 48 c7 c7 a0 65 71 88 e8 a0 ba be fd 0f 0b 4c 89 e2 4c 89 f6 48 c7 c7 00 66 71 88 e8 8c ba be fd <0f> 0b 4c 89 f6 48 c7 c7 c0 66 71 88 e8 7b ba be fd 0f 0b cc cc cc
RSP: 0018:ffffc900021c7478 EFLAGS: 00010282
RAX: 000000000000004e RBX: ffff8880a302a400 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e53a6 RDI: fffff52000438e81
RBP: ffffc900021c7490 R08: 000000000000004e R09: ffffed1015d06621
R10: ffffed1015d06620 R11: ffff8880ae833107 R12: dead000000000122
R13: ffff8880921d92f0 R14: ffff8880a302a400 R15: ffff8880936a7c80
FS:  00007fd3a288c700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffde1b0aeb0 CR3: 000000009f715000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __list_del_entry include/linux/list.h:131 [inline]
 list_del_rcu include/linux/rculist.h:148 [inline]
 __nf_tables_abort+0x1e53/0x2a50 net/netfilter/nf_tables_api.c:7258
 nf_tables_abort+0x17/0x30 net/netfilter/nf_tables_api.c:7373
 nfnetlink_rcv_batch+0xa5d/0x17a0 net/netfilter/nfnetlink.c:494
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3e7/0x460 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446b19
Code: e8 8c e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fd3a288bd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446b19
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000003
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 00000000200002c0 R14: 00000000004aeb00 R15: 0000000000000000
Modules linked in:
---[ end trace c2ab85444d78ba35 ]---
RIP: 0010:__list_del_entry_valid.cold+0x37/0x4f lib/list_debug.c:48
Code: be fd 0f 0b 4c 89 ea 4c 89 f6 48 c7 c7 a0 65 71 88 e8 a0 ba be fd 0f 0b 4c 89 e2 4c 89 f6 48 c7 c7 00 66 71 88 e8 8c ba be fd <0f> 0b 4c 89 f6 48 c7 c7 c0 66 71 88 e8 7b ba be fd 0f 0b cc cc cc
RSP: 0018:ffffc900021c7478 EFLAGS: 00010282
RAX: 000000000000004e RBX: ffff8880a302a400 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e53a6 RDI: fffff52000438e81
RBP: ffffc900021c7490 R08: 000000000000004e R09: ffffed1015d06621
R10: ffffed1015d06620 R11: ffff8880ae833107 R12: dead000000000122
R13: ffff8880921d92f0 R14: ffff8880a302a400 R15: ffff8880936a7c80
FS:  00007fd3a288c700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
