Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241A71EEF48
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 04:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgFECCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 22:02:23 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46700 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgFECCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 22:02:20 -0400
Received: by mail-io1-f70.google.com with SMTP id w2so4804733iom.13
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 19:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=szPEl64cpoHvhxXlR5lo+T/AwMKKhjIH6u2ObmlDQ8E=;
        b=BeSg6kpBAlfUc1Ubl2k04qEBT+4ICIi4lIe6qb/9lkHGF5it/nSeUmcK+c9an14mdl
         5FFQ5hosCoNaw26kBu+UM9Z8iOeS35OFxFK6skQz1ZNwK/x6iRXHCXoa/PkibaK3YVb7
         G2D5BFP38wTcwHaWmavzvlcEv1vXpzwlX60gAevb9/jVREhC/DMynmM9iYDOWstMW5rl
         PFvrcA6m/LpRterZqHRDrillwRftTP53zdZ7MLFASV9TBe7RN5yrFQ37RVikpgfeZlMV
         MmoIqu4a7MWtISh+EVEn/mBp1pqSphx78A2WvmU/VGfhVNLekHNkK7ltoLNmEGsoz8N+
         RPRg==
X-Gm-Message-State: AOAM532AkxFWAv8RfC3syp59r5/O3ccZcx790MHlkuUKRmHGIw3qrlwK
        3hvtQ1F06YRmq6YGkuKS8NiuSQlNuNTNWf26o516bCtGBXbs
X-Google-Smtp-Source: ABdhPJy35sGcsK5T99oV/Miqd0MTFmMIRGWwz7NG7KYR7p84q6J2DjC+KVRxWgwyPqvZlI1/vg6BarUMynCMXcFO+QudDyc1gEy4
MIME-Version: 1.0
X-Received: by 2002:a92:cc4e:: with SMTP id t14mr4239598ilq.138.1591322538629;
 Thu, 04 Jun 2020 19:02:18 -0700 (PDT)
Date:   Thu, 04 Jun 2020 19:02:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a363b205a74ca6a2@google.com>
Subject: BUG: using smp_processor_id() in preemptible code in radix_tree_node_alloc
From:   syzbot <syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    acf25aa6 Merge tag 'Smack-for-5.8' of git://github.com/csc..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d6307a100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5263d9b5bce03c67
dashboard link: https://syzkaller.appspot.com/bug?extid=3eec59e770685e3dc879
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15bd4c1e100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1520c9de100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com

RAX: ffffffffffffffda RBX: 00007ffdf01d56d0 RCX: 00000000004406c9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 0000000000000005 R08: 0000000000000001 R09: 0000000000000031
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401f50
R13: 0000000000401fe0 R14: 0000000000000000 R15: 0000000000000000
BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor036/6796
caller is radix_tree_node_alloc.constprop.0+0x200/0x330 lib/radix-tree.c:262
CPU: 0 PID: 6796 Comm: syz-executor036 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_preemption_disabled lib/smp_processor_id.c:47 [inline]
 debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
 radix_tree_node_alloc.constprop.0+0x200/0x330 lib/radix-tree.c:262
 radix_tree_extend+0x256/0x4e0 lib/radix-tree.c:424
 idr_get_free+0x60c/0x8e0 lib/radix-tree.c:1492
 idr_alloc_u32+0x170/0x2d0 lib/idr.c:46
 idr_alloc+0xc2/0x130 lib/idr.c:87
 qrtr_port_assign net/qrtr/qrtr.c:703 [inline]
 __qrtr_bind.isra.0+0x12e/0x5c0 net/qrtr/qrtr.c:756
 qrtr_autobind net/qrtr/qrtr.c:787 [inline]
 qrtr_autobind+0xaf/0xf0 net/qrtr/qrtr.c:775
 qrtr_sendmsg+0x1d6/0x770 net/qrtr/qrtr.c:895
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x4406c9
Code: 25 02 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdf01d56c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffdf01d56d0 RCX: 00000000004406c9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 0000000000000005 R08: 0000000000000001 R09: 0000000000000031
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401f50
R13: 0000000000401fe0 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
