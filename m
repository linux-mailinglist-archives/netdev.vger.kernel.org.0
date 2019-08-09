Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2837887835
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 13:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406441AbfHILGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 07:06:10 -0400
Received: from mail-ot1-f71.google.com ([209.85.210.71]:50107 "EHLO
        mail-ot1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405954AbfHILGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 07:06:09 -0400
Received: by mail-ot1-f71.google.com with SMTP id l7so68167709otj.16
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 04:06:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zVTRlB/x5YQjuHlXNkGeEct8hD4cekTY0n9YojkyFDU=;
        b=d7Tylm632L3eNTLgqM/WLZZy1mrgM3wDfd5oc/klktlRU96s2mtwfZJsSJoIL4tg+8
         MzRKwvp0IXhJVkKzHVeh46y5WgObI8KkcEbApWHukmoWgK9QzrhenOqMJXDCk5g/XGtW
         6ryR52rjQ4cAG6YGGonjGr4l5sOz/eJXjz3nulgPWVJsAxeSekqgvJBtyWCRcnDW7RMp
         hqD0wDq9+ne5rUDnjWKxoQew+xOuZm4FSMKS56ANd9uZKalqildo8KNaFsGolC2qhJOP
         qi6qvS19eGdOTxlScx8xFhoCSJ2h6fXj5L1b188Q97hZk4iEGe765rQYCMfWlZED6p0z
         A5TA==
X-Gm-Message-State: APjAAAUKlSMan7aTsS/kIl8ZqnjRqYH0Hr8il/OL44x77EIWMcyZVlrP
        jFXYutWJvMyyvxaxmq5sA44/q5axu1fs0nYx79G/CoyWDUYQ
X-Google-Smtp-Source: APXvYqy3Q85weNwM4JYCgJFzoo+N1LJJCD2xUNX+lEyYV85+yaBrOpyhVocQSVRI2cA+GCFcEH9eK0j49dfHLsOIwiLTUmuXkheu
MIME-Version: 1.0
X-Received: by 2002:a02:4e05:: with SMTP id r5mr22339509jaa.27.1565348768322;
 Fri, 09 Aug 2019 04:06:08 -0700 (PDT)
Date:   Fri, 09 Aug 2019 04:06:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000492086058fad2979@google.com>
Subject: BUG: corrupted list in rxrpc_local_processor
From:   syzbot <syzbot+193e29e9387ea5837f1d@syzkaller.appspotmail.com>
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

HEAD commit:    87b983f5 Add linux-next specific files for 20190809
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=161309c2600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28eea330e11df0eb
dashboard link: https://syzkaller.appspot.com/bug?extid=193e29e9387ea5837f1d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+193e29e9387ea5837f1d@syzkaller.appspotmail.com

list_del corruption. prev->next should be ffff8880a4570da0, but was  
ffff88808c74b6e0
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:51!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 22 Comm: kworker/1:1 Not tainted 5.3.0-rc3-next-20190809 #63
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krxrpcd rxrpc_local_processor
RIP: 0010:__list_del_entry_valid.cold+0xf/0x4f lib/list_debug.c:51
Code: e8 f9 73 1d fe 0f 0b 48 89 f1 48 c7 c7 c0 6f e6 87 4c 89 e6 e8 e5 73  
1d fe 0f 0b 4c 89 f6 48 c7 c7 60 71 e6 87 e8 d4 73 1d fe <0f> 0b 4c 89 ea  
4c 89 f6 48 c7 c7 a0 70 e6 87 e8 c0 73 1d fe 0f 0b
RSP: 0018:ffff8880a9a47cc0 EFLAGS: 00010286
RAX: 0000000000000054 RBX: ffff8880a4570db8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815bb706 RDI: ffffed1015348f8a
RBP: ffff8880a9a47cd8 R08: 0000000000000054 R09: ffffed1015d260d9
R10: ffffed1015d260d8 R11: ffff8880ae9306c7 R12: ffff888074400878
R13: ffff888074400878 R14: ffff8880a4570da0 R15: ffff88809509e580
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000400200 CR3: 000000006f1ac000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __list_del_entry include/linux/list.h:131 [inline]
  list_del_init include/linux/list.h:190 [inline]
  rxrpc_local_destroyer net/rxrpc/local_object.c:427 [inline]
  rxrpc_local_processor+0x251/0x830 net/rxrpc/local_object.c:463
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace c8e00778000f001d ]---
RIP: 0010:__list_del_entry_valid.cold+0xf/0x4f lib/list_debug.c:51
Code: e8 f9 73 1d fe 0f 0b 48 89 f1 48 c7 c7 c0 6f e6 87 4c 89 e6 e8 e5 73  
1d fe 0f 0b 4c 89 f6 48 c7 c7 60 71 e6 87 e8 d4 73 1d fe <0f> 0b 4c 89 ea  
4c 89 f6 48 c7 c7 a0 70 e6 87 e8 c0 73 1d fe 0f 0b
RSP: 0018:ffff8880a9a47cc0 EFLAGS: 00010286
RAX: 0000000000000054 RBX: ffff8880a4570db8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815bb706 RDI: ffffed1015348f8a
RBP: ffff8880a9a47cd8 R08: 0000000000000054 R09: ffffed1015d260d9
R10: ffffed1015d260d8 R11: ffff8880ae9306c7 R12: ffff888074400878
R13: ffff888074400878 R14: ffff8880a4570da0 R15: ffff88809509e580
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32f22000 CR3: 000000006f1ac000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
