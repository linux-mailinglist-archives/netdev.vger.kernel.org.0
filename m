Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C741D695A
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 20:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbfJNSWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 14:22:38 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:43869 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729950AbfJNSWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 14:22:37 -0400
Received: by mail-pg1-f202.google.com with SMTP id 6so13194516pgi.10
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 11:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=iEt6Hhs3SLo3wOUxBehwLxl7Gce+Pw1Q5LdbojBXSBA=;
        b=MzKEBqbhWvnKKhA5xezvGh40ooVORYmDGNOFmU/xeLnYe4ozhcIDetNRWUZZgwIk9K
         VOUbytAGCYo23yuh3GEysS/SUv4yUFB3HyC+jPSwRyAz7IC6TxSdON96/w4juBJ0IjXg
         uudVcDdbU4Nx3Kx1GX4cKb1u573RGeFvkjb4dAfZ6vGub/9ISpcW4H0XjavxdvF4Cigu
         /ISG5FrNrgH7iLiUxIh/xfaolSzuMtGXV+EIDReWH8ZkrT2UUNGjYvqgh9m0nWwGqZPL
         deHkrkUNe4tkLzzknwLnXnFJq0xwUjcYAnuEkbrTc5VuqxNOSWFuyfvdzQxcH7LpKJy6
         PTLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=iEt6Hhs3SLo3wOUxBehwLxl7Gce+Pw1Q5LdbojBXSBA=;
        b=HboPk/srpVVK4arZG9t0GtFNHKovh9mILOCiIlICtk2jCc/B2Ywebp5n10STwDjzhr
         8QBXjO0bdF99yfVmnDEN09/ucaOQhG4wZhjbGMgOATDFbwa5Idao2kCvDkhxMyDDZLPf
         y3tSpvPyAzgMr/9kZbfJZ0GsPjf+QqrPciwQTcAxwYeBGX1JdiNlkmWkE3QIdv+T5Er3
         HoYHchNOy0FIO6kkr9iZVrWICy7br9BplJXTFWGu3EVOyjGqJMeAoENNXtSo0VKUo//H
         6Ch/WNXCopmoEc1dg+E+Jmm8UFVt2ctQ9AVaYyFHZJjEMCPVlS6ibu/0ZRINBQKjEts5
         mG/w==
X-Gm-Message-State: APjAAAWK+D8bhG45vqaP81aJxTNE7dko4M5vtaEW9GabjF3m/TunzF+H
        ctB0pMTOftQwa4d1CqnbAdBcJscAtmxG9g==
X-Google-Smtp-Source: APXvYqzVDd9AnYYQqGM6UaTvgb2APwABkwGOojXzCBNWe+ta2EmA3bcQqbyIa93PdR/yGZ1v4O1V8U0eYq1eZQ==
X-Received: by 2002:a63:a54d:: with SMTP id r13mr33957939pgu.353.1571077354914;
 Mon, 14 Oct 2019 11:22:34 -0700 (PDT)
Date:   Mon, 14 Oct 2019 11:22:30 -0700
Message-Id: <20191014182230.205162-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net] net: avoid potential infinite loop in tc_ctl_action()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot+cf0adbb9c28c8866c788@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tc_ctl_action() has the ability to loop forever if tcf_action_add()
returns -EAGAIN.

This special case has been done in case a module needed to be loaded,
but it turns out that tcf_add_notify() could also return -EAGAIN
if the socket sk_rcvbuf limit is hit.

We need to separate the two cases, and only loop for the module
loading case.

While we are at it, add a limit of 10 attempts since unbounded
loops are always scary.

syzbot repro was something like :

socket(PF_NETLINK, SOCK_RAW|SOCK_NONBLOCK, NETLINK_ROUTE) = 3
write(3, ..., 38) = 38
setsockopt(3, SOL_SOCKET, SO_RCVBUF, [0], 4) = 0
sendmsg(3, {msg_name(0)=NULL, msg_iov(1)=[{..., 388}], msg_controllen=0, msg_flags=0x10}, ...)

NMI backtrace for cpu 0
CPU: 0 PID: 1054 Comm: khungtaskd Not tainted 5.4.0-rc1+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
 arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0x9d0/0xef0 kernel/hung_task.c:289
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 8859 Comm: syz-executor910 Not tainted 5.4.0-rc1+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:arch_local_save_flags arch/x86/include/asm/paravirt.h:751 [inline]
RIP: 0010:lockdep_hardirqs_off+0x1df/0x2e0 kernel/locking/lockdep.c:3453
Code: 5c 08 00 00 5b 41 5c 41 5d 5d c3 48 c7 c0 58 1d f3 88 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 d3 00 00 00 <48> 83 3d 21 9e 99 07 00 0f 84 b9 00 00 00 9c 58 0f 1f 44 00 00 f6
RSP: 0018:ffff8880a6f3f1b8 EFLAGS: 00000046
RAX: 1ffffffff11e63ab RBX: ffff88808c9c6080 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffff88808c9c6914
RBP: ffff8880a6f3f1d0 R08: ffff88808c9c6080 R09: fffffbfff16be5d1
R10: fffffbfff16be5d0 R11: 0000000000000003 R12: ffffffff8746591f
R13: ffff88808c9c6080 R14: ffffffff8746591f R15: 0000000000000003
FS:  00000000011e4880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 00000000a8920000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 trace_hardirqs_off+0x62/0x240 kernel/trace/trace_preemptirq.c:45
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
 _raw_spin_lock_irqsave+0x6f/0xcd kernel/locking/spinlock.c:159
 __wake_up_common_lock+0xc8/0x150 kernel/sched/wait.c:122
 __wake_up+0xe/0x10 kernel/sched/wait.c:142
 netlink_unlock_table net/netlink/af_netlink.c:466 [inline]
 netlink_unlock_table net/netlink/af_netlink.c:463 [inline]
 netlink_broadcast_filtered+0x705/0xb80 net/netlink/af_netlink.c:1514
 netlink_broadcast+0x3a/0x50 net/netlink/af_netlink.c:1534
 rtnetlink_send+0xdd/0x110 net/core/rtnetlink.c:714
 tcf_add_notify net/sched/act_api.c:1343 [inline]
 tcf_action_add+0x243/0x370 net/sched/act_api.c:1362
 tc_ctl_action+0x3b5/0x4bc net/sched/act_api.c:1410
 rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5386
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5404
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
RIP: 0033:0x440939

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+cf0adbb9c28c8866c788@syzkaller.appspotmail.com
---
 net/sched/act_api.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 4e7429c6f86496516b2a31264808f85f3b5f39c0..69d4676a402f54ac0d03999b5c73e572c1f06447 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1353,11 +1353,16 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 			  struct netlink_ext_ack *extack)
 {
 	size_t attr_size = 0;
-	int ret = 0;
+	int loop, ret;
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {};
 
-	ret = tcf_action_init(net, NULL, nla, NULL, NULL, ovr, 0, actions,
-			      &attr_size, true, extack);
+	for (loop = 0; loop < 10; loop++) {
+		ret = tcf_action_init(net, NULL, nla, NULL, NULL, ovr, 0,
+				      actions, &attr_size, true, extack);
+		if (ret != -EAGAIN)
+			break;
+	}
+
 	if (ret < 0)
 		return ret;
 	ret = tcf_add_notify(net, n, actions, portid, attr_size, extack);
@@ -1407,11 +1412,8 @@ static int tc_ctl_action(struct sk_buff *skb, struct nlmsghdr *n,
 		 */
 		if (n->nlmsg_flags & NLM_F_REPLACE)
 			ovr = 1;
-replay:
 		ret = tcf_action_add(net, tca[TCA_ACT_TAB], n, portid, ovr,
 				     extack);
-		if (ret == -EAGAIN)
-			goto replay;
 		break;
 	case RTM_DELACTION:
 		ret = tca_action_gd(net, tca[TCA_ACT_TAB], n,
-- 
2.23.0.700.g56cf767bdb-goog

