Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615D5BBE64
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 00:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391372AbfIWWTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 18:19:02 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:35474 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387989AbfIWWTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 18:19:02 -0400
Received: by mail-vs1-f73.google.com with SMTP id 7so2143946vsx.2
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 15:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cXQnwYmGpmurFNzY32G2FaS4vzTTSqER52uhakwrYEg=;
        b=ErhTgDdKoEdmyB0SThxXnIanwbejw8ByDYRQlrG/8CFKroS4GEJ7iRcLfNEJLJA4AX
         DLhh5qb5dNjlFGqZCjsWGl+eQuTFj5nGzmGZlUy0QOyBrYmZNtGnqXGKGbbscNO45BxT
         6nh3DjVoj2ofMeqiQRbe0sfd33HVxe8VUuqj242v9ZFj4l/tmunehYKkf/Eq5Btk1NTA
         FOH2LI7Rpm2KbHhkWODWPWMh/8HQO/pZHDmnRrIx9FYXVh83k4RpLWNNCkzxRpfvflCa
         2iw85alFuvqEI9r8CmRZwfRbC5ALYyBv/cbbZQ8qcyRU/S/ZiHaxHTOVCnZ1Oy9Yr3O4
         sk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cXQnwYmGpmurFNzY32G2FaS4vzTTSqER52uhakwrYEg=;
        b=q1ncL34xRhbzzT1HMa7blpHHK92Vnm/3+30Kx0uTfoVa7riJQNOGgNaIAPCOwQ5fIO
         EIhgx7rQRlawAkP4cVgA65KliAbw8FdszFh2jjBlvzHfu3LFfE9MN+aleWFYTSjYtmim
         TZIJi101R7lGhJ1zdrc1jTaG2RUSpR3Yny8JTtq9R+/3YP6ThhZEL0wE6RPDB51Yca6l
         PWKIlfEj+JuwZwM9+z9lt4nwXpUrE9UGrsKuaeFjlcomxlC6UD7NO58T9lTIWP7Pnn2x
         Llq7Sz0bsTFDx0Cc+0lYjLkj/B2w32eoL0ogzowvo3AGOpACIryaBJX1XvHqDdUlm1Yb
         u1xA==
X-Gm-Message-State: APjAAAUoqezDsxM+oaOlWVsmeKkNR7ro5k/skp+X2B8boyQgvorExy3T
        8rmV8j/4d7ChlHb1oeQSd7vHx3qPw412Xw==
X-Google-Smtp-Source: APXvYqwnoXdzjgtPVKFG1Y2Aq7zmR2H8MUHT5ND15q+LMe6EQs+Rcc+pmIp3wXkgHUkf8cdhr9qTiRGc0VJvJw==
X-Received: by 2002:a1f:9893:: with SMTP id a141mr1309650vke.75.1569277141480;
 Mon, 23 Sep 2019 15:19:01 -0700 (PDT)
Date:   Mon, 23 Sep 2019 15:18:57 -0700
Message-Id: <20190923221857.103908-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH v2 net] net: sched: fix possible crash in tcf_action_destroy()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the allocation done in tcf_exts_init() failed,
we end up with a NULL pointer in exts->actions.

kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8198 Comm: syz-executor.3 Not tainted 5.3.0-rc8+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tcf_action_destroy+0x71/0x160 net/sched/act_api.c:705
Code: c3 08 44 89 ee e8 4f cb bb fb 41 83 fd 20 0f 84 c9 00 00 00 e8 c0 c9 bb fb 48 89 d8 48 b9 00 00 00 00 00 fc ff df 48 c1 e8 03 <80> 3c 08 00 0f 85 c0 00 00 00 4c 8b 33 4d 85 f6 0f 84 9d 00 00 00
RSP: 0018:ffff888096e16ff0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: dffffc0000000000
RDX: 0000000000040000 RSI: ffffffff85b6ab30 RDI: 0000000000000000
RBP: ffff888096e17020 R08: ffff8880993f6140 R09: fffffbfff11cae67
R10: fffffbfff11cae66 R11: ffffffff88e57333 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888096e177a0 R15: 0000000000000001
FS:  00007f62bc84a700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000758040 CR3: 0000000088b64000 CR4: 00000000001426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tcf_exts_destroy+0x38/0xb0 net/sched/cls_api.c:3030
 tcindex_set_parms+0xf7f/0x1e50 net/sched/cls_tcindex.c:488
 tcindex_change+0x230/0x318 net/sched/cls_tcindex.c:519
 tc_new_tfilter+0xa4b/0x1c70 net/sched/cls_api.c:2152
 rtnetlink_rcv_msg+0x838/0xb00 net/core/rtnetlink.c:5214
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5241
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:657
 ___sys_sendmsg+0x3e2/0x920 net/socket.c:2311
 __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]

Fixes: 90b73b77d08e ("net: sched: change action API to use array of pointers to actions")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Jiri Pirko <jiri@mellanox.com>
---
 net/sched/act_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 2558f00f6b3eda64a87f63c32592c15b7a0a2bfe..b58742e22afb8c40badc64f4d7c4e676839d7d07 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -702,6 +702,9 @@ int tcf_action_destroy(struct tc_action *actions[], int bind)
 	struct tc_action *a;
 	int ret = 0, i;
 
+	if (!actions)
+		return 0;
+
 	for (i = 0; i < TCA_ACT_MAX_PRIO && actions[i]; i++) {
 		a = actions[i];
 		actions[i] = NULL;
-- 
2.23.0.351.gc4317032e6-goog

