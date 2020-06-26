Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF9B20B694
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgFZRJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:09:18 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:35671 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728206AbgFZRJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:09:16 -0400
Received: by mail-il1-f199.google.com with SMTP id m14so6911203iln.2
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:09:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UJwYwmK89yxunKp2bcHoekLYQkO+BCKTNGonzhoLxuY=;
        b=lcNPzaHUHvnjEw8Bbgvl2jEvcHS678P9nwj9D6KKgDtFYbcv9bhcBVjTEyG+SEy0t8
         wQZpvA0JcTGgMqR1PAuYMAGP9mHFZR2k1ya/ZRWDbUVI+NI+RJZns9Jo9qpKpXOaHaTs
         lpiKY/WB8I0dT30IglwVxYLCDs7KNrnvqcj6SRbn+sQ0cG9pK8KjtlbV/CSn49kJIqRC
         991cCg84NYZLFrLVEETtaEm8AcGSNjBYHjWc4fnYhirDFjJ6ham4eL+8fjQes+GlHfjx
         IKWPp5O/Nt8NctC9S+0ZJ1dp5IxQ1as+bN+pVgFq84w284tOSHZRAzrkayV3S0NxbQXs
         zDXA==
X-Gm-Message-State: AOAM532swjnfRlKvTz+N5az+XUM4yPOp5C+8CMWpMqG/tVLQNV9Pi33C
        N3Jo1rmJFgmgovsZ+T99558sJWQsfHrjNgbewHBYdzOj0/3t
X-Google-Smtp-Source: ABdhPJwp1lBfebX04LkygcJHpJUSckhU/8A+t5yFT0sx4CQNGOFhvLxO0JSes1fhhpp7wu98khShfMLUoWIq93tjFAieFQb/ESYr
MIME-Version: 1.0
X-Received: by 2002:a02:662d:: with SMTP id k45mr4483248jac.127.1593191355375;
 Fri, 26 Jun 2020 10:09:15 -0700 (PDT)
Date:   Fri, 26 Jun 2020 10:09:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cbef4a05a8ffc4ef@google.com>
Subject: BUG: using smp_processor_id() in preemptible code in tipc_crypto_xmit
From:   syzbot <syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f4926d51 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=137a899b100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcc6334acae363d4
dashboard link: https://syzkaller.appspot.com/bug?extid=263f8c0d007dc09b2dda
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com

BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor.1/23385
caller is tipc_aead_tfm_next net/tipc/crypto.c:402 [inline]
caller is tipc_aead_encrypt net/tipc/crypto.c:639 [inline]
caller is tipc_crypto_xmit+0x80a/0x2790 net/tipc/crypto.c:1605
CPU: 1 PID: 23385 Comm: syz-executor.1 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 check_preemption_disabled+0x20d/0x220 lib/smp_processor_id.c:48
 tipc_aead_tfm_next net/tipc/crypto.c:402 [inline]
 tipc_aead_encrypt net/tipc/crypto.c:639 [inline]
 tipc_crypto_xmit+0x80a/0x2790 net/tipc/crypto.c:1605
 tipc_bearer_xmit_skb+0x180/0x3f0 net/tipc/bearer.c:523
 tipc_enable_bearer+0xb1d/0xdc0 net/tipc/bearer.c:331
 __tipc_nl_bearer_enable+0x2bf/0x390 net/tipc/bearer.c:995
 tipc_nl_bearer_enable+0x1e/0x30 net/tipc/bearer.c:1003
 genl_family_rcv_msg_doit net/netlink/genetlink.c:691 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:736 [inline]
 genl_rcv_msg+0x61d/0x9e0 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb19
Code: Bad RIP value.
RSP: 002b:00007fa3c4dc1c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000501c40 RCX: 000000000045cb19
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a19 R14: 00000000004ccf82 R15: 00007fa3c4dc26d4
tipc: Enabled bearer <eth:vlan1>, priority 10


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
