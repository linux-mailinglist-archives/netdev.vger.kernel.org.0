Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574F5CC1C7
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 19:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387769AbfJDReu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 13:34:50 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:43186 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfJDReu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 13:34:50 -0400
Received: by mail-vk1-f201.google.com with SMTP id w1so2926615vkd.10
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 10:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5K+2rRNdstkyeIuDB2TS7RVzqhPaSCJhD4S5o8uevFE=;
        b=TCf7HUcXll0bA+po39VSIilhqrNeoN3E0G45mcIGCRz1ryDQdE8IHMillA6+nNGMlN
         Hv040AE2zZdbtgBzuE6wJxYUmHSSNxssVesQjONMaqg4Z424Pk3ZgTS/OBKcmf/NNn6F
         NFN+9H+u691RuNF904I+KYpxr9kRJLw0myJKGOOiHE/1qBGNjaZx5jfHzEsIajpbUqMM
         xPCOpGM2v1WkyhafnnTjSy0RoycdWonDKt/VnZrvMo0iDS5T4GDr2gmMRWxzAqZ9xf3t
         c4qoeQKClLTEMk8lORbez3w22WjUn2NCiTjsLmQorTHHhhTLi9mIP6PHPVqMXjgPy/8w
         5+ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5K+2rRNdstkyeIuDB2TS7RVzqhPaSCJhD4S5o8uevFE=;
        b=hwWgwP//T+cfHozu0rwK/qialM0SgSBiaOYc7I38pFyGGVMR0QN46kX53OBUXwFibU
         851txjX8IemVvSLaJ8dyPyythV8TEOPTIgTYx7jcp3A9l3sBJ/iuXMFQwOBlSyQSbd2P
         Bnx6dcetCKSNS2hHooOziF5TKnyyhc0ZiZ0rYbxGFW0f3X+Wv4/Bh6W1dTSMwwd6gtZ1
         Phr9ResL9zibyF9s4kymzkgMgaEqVF7sUT+qmsYnGGPbCvC1mAZTk5e7+mhNVGnjOyuo
         OmJbf96D4glXLTTcUvPS2pBw0neFHalNU1nBHlBaHuNaXijFqamHkpV0KARmLm4Di/AN
         XTYw==
X-Gm-Message-State: APjAAAW1gKfINF8Oq2zq67tb5eVko68EpAkR+9o+DkXYuFUAoTDJlHWs
        6I4p7JZ521QxDYrdYdxv9q0PDrhXamqa2w==
X-Google-Smtp-Source: APXvYqw7qCiN0pMpFyW2saJwGl940vezJfSv9bXDJV0Jg8Dn4dyVfga4FgocxnOIRkygH8r3qdMDBhlC13GXeg==
X-Received: by 2002:ab0:77ce:: with SMTP id y14mr8239238uar.96.1570210489129;
 Fri, 04 Oct 2019 10:34:49 -0700 (PDT)
Date:   Fri,  4 Oct 2019 10:34:45 -0700
Message-Id: <20191004173445.81907-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] sch_dsmark: fix potential NULL deref in dsmark_init()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure TCA_DSMARK_INDICES was provided by the user.

syzbot reported :

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8799 Comm: syz-executor235 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_get_u16 include/net/netlink.h:1501 [inline]
RIP: 0010:dsmark_init net/sched/sch_dsmark.c:364 [inline]
RIP: 0010:dsmark_init+0x193/0x640 net/sched/sch_dsmark.c:339
Code: 85 db 58 0f 88 7d 03 00 00 e8 e9 1a ac fb 48 8b 9d 70 ff ff ff 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 ca
RSP: 0018:ffff88809426f3b8 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff85c6eb09
RDX: 0000000000000000 RSI: ffffffff85c6eb17 RDI: 0000000000000004
RBP: ffff88809426f4b0 R08: ffff88808c4085c0 R09: ffffed1015d26159
R10: ffffed1015d26158 R11: ffff8880ae930ac7 R12: ffff8880a7e96940
R13: dffffc0000000000 R14: ffff88809426f8c0 R15: 0000000000000000
FS:  0000000001292880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 000000008ca1b000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 qdisc_create+0x4ee/0x1210 net/sched/sch_api.c:1237
 tc_modify_qdisc+0x524/0x1c50 net/sched/sch_api.c:1653
 rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5223
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5241
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:657
 ___sys_sendmsg+0x803/0x920 net/socket.c:2311
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
 __do_sys_sendmsg net/socket.c:2365 [inline]
 __se_sys_sendmsg net/socket.c:2363 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
 do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440369

Fixes: 758cc43c6d73 ("[PKT_SCHED]: Fix dsmark to apply changes consistent")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/sch_dsmark.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index bad1cbe59a562799b8e5c1b1085616fe67d4edd9..05605b30bef3abac1da2e0e821c871a54b3635ba 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -361,6 +361,8 @@ static int dsmark_init(struct Qdisc *sch, struct nlattr *opt,
 		goto errout;
 
 	err = -EINVAL;
+	if (!tb[TCA_DSMARK_INDICES])
+		goto errout;
 	indices = nla_get_u16(tb[TCA_DSMARK_INDICES]);
 
 	if (hweight32(indices) != 1)
-- 
2.23.0.581.g78d2f28ef7-goog

