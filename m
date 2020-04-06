Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE2919FCD7
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 20:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgDFSQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 14:16:14 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:45515 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgDFSQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 14:16:14 -0400
Received: by mail-io1-f69.google.com with SMTP id g5so595257ioh.12
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 11:16:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zB2Pul4O3CZEdfX+FknGpoFpPmJ28DN3NmrYEX8GLIY=;
        b=eVTwPVlJa/IFVIT1WjHCgr0TKJ080ybGwqMa97m1uXNvKU4H25RS4O6EExAqK6gerh
         JMC+viGtp+9Nl8G4mq4cZiKfFk2msbnD7moE575Qqn10DzBSdwwAu+zyFs8pv/drCiJq
         g7Myq1/YWL48siHGL3kN7PIEpsjuH8noMrHA+1BJ8FIOnNszgNfIYKOWZFGXg00dBN2b
         ASv+bom0TFr09BMMzBP4o9uvuBWCI4qps/P/A7Ltm2C9eGjGPve2x2YPfe125fs1TJ0k
         jam3J2MNtw7S5nEPH5AJ/0mHy6n2dRxkPpuVQgBy6ny4o6PYlsphquVM10BTQ0bjM8Nh
         c5nw==
X-Gm-Message-State: AGi0PuYQB1CRfrkpiaVu0zNtJlcZcvZ8um6AVDvvy3wcHVnDw5jbBh3t
        PAk3NBfMp1980cxX2KJ0aHPdnBGBN5gBesejOpf2fHOCOIYL
X-Google-Smtp-Source: APiQypJ93U4Y/7M+URA5MQp73cNseNFmj41V0xx14yE9AAAt9D7ywvfR5mKxr0bACRwKYycHzC//moVWA6jhFaIB3vz6ZelBsTt3
MIME-Version: 1.0
X-Received: by 2002:a02:cac4:: with SMTP id f4mr566095jap.51.1586196973505;
 Mon, 06 Apr 2020 11:16:13 -0700 (PDT)
Date:   Mon, 06 Apr 2020 11:16:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002656a605a2a34356@google.com>
Subject: WARNING: refcount bug in crypto_destroy_tfm
From:   syzbot <syzbot+fc0674cde00b66844470@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    468c2a10 mlxsw: spectrum_trap: fix unintention integer ove..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11089cb3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c1e98458335a7d1
dashboard link: https://syzkaller.appspot.com/bug?extid=fc0674cde00b66844470
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=115f2a43e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=141ea0ede00000

The bug was bisected to:

commit 4f87ee118d16b4b2116a477229573ed5003b0d78
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sat Dec 7 14:15:17 2019 +0000

    crypto: api - Do not zap spawn->alg

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10ffbc2be00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12ffbc2be00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14ffbc2be00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fc0674cde00b66844470@syzkaller.appspotmail.com
Fixes: 4f87ee118d16 ("crypto: api - Do not zap spawn->alg")

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 7174 at lib/refcount.c:28 refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 7174 Comm: syz-executor413 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 2c 95 1e fe e9 8a fe ff ff e8 c2 81 e1 fd 48 c7 c7 40 c6 71 88 c6 05 82 bd f1 06 01 e8 17 f6 b2 fd <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0018:ffffc90001a17b18 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815ca861 RDI: fffff52000342f55
RBP: 0000000000000003 R08: ffff8880949fe300 R09: ffffed1015cc66a1
R10: ffffed1015cc66a0 R11: ffff8880ae633507 R12: ffff88809a6d187c
R13: ffff8880a40eb000 R14: 0000000000000000 R15: ffff8880a40eb010
 refcount_sub_and_test include/linux/refcount.h:261 [inline]
 refcount_dec_and_test include/linux/refcount.h:281 [inline]
 crypto_alg_put crypto/internal.h:93 [inline]
 crypto_mod_put crypto/api.c:45 [inline]
 crypto_destroy_tfm+0x2a1/0x310 crypto/api.c:566
 crypto_exit_ops crypto/api.c:308 [inline]
 crypto_destroy_tfm+0xb1/0x310 crypto/api.c:565
 crypto_free_aead include/crypto/aead.h:185 [inline]
 aead_release+0x2d/0x50 crypto/algif_aead.c:506
 alg_do_release crypto/af_alg.c:114 [inline]
 alg_sock_destruct+0x85/0xe0 crypto/af_alg.c:358
 __sk_destruct+0x4b/0x7c0 net/core/sock.c:1696
 sk_destruct+0xc6/0x100 net/core/sock.c:1740
 __sk_free+0xef/0x3d0 net/core/sock.c:1751
 sk_free+0x78/0xa0 net/core/sock.c:1762
 sock_put include/net/sock.h:1778 [inline]
 af_alg_release+0xdb/0x110 crypto/af_alg.c:121
 __sock_release+0xcd/0x280 net/socket.c:605
 sock_close+0x18/0x20 net/socket.c:1283
 __fput+0x2e9/0x860 fs/file_table.c:280
 task_work_run+0xf4/0x1b0 kernel/task_work.c:123
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0xb34/0x2dd0 kernel/exit.c:793
 do_group_exit+0x125/0x340 kernel/exit.c:891
 __do_sys_exit_group kernel/exit.c:902 [inline]
 __se_sys_exit_group kernel/exit.c:900 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:900
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x43ff78
Code: 00 00 be 3c 00 00 00 eb 19 66 0f 1f 84 00 00 00 00 00 48 89 d7 89 f0 0f 05 48 3d 00 f0 ff ff 77 21 f4 48 89 d7 44 89 c0 0f 05 <48> 3d 00 f0 ff ff 76 e0 f7 d8 64 41 89 01 eb d8 0f 1f 84 00 00 00
RSP: 002b:00007ffe423e1db8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043ff78
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004bf850 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d1180 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
