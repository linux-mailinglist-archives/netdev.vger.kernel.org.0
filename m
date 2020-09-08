Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8071260D68
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 10:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgIHIUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 04:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729257AbgIHIUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 04:20:34 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C77C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 01:20:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 125so5932104ybg.12
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 01:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=97F2kk/LeEZwQe+7sraB4Mn3T/rGEIisHYfqnxFFE6I=;
        b=DAB3tr14t2s1rCVDprA51dcqh2a2UrEa/kLnoqR0fo3Ru5DPmPVl/2/hOqrg5Kkxga
         auoratWlABK1IY1hQ1uaf03Fp9VDQMM9oM3a9FWCIoY1jBgIfeKD2hqhXS+G+Fz8QgvQ
         WD1AZBpY9GaJYIEYBEODAVrkSNfWUfiEv4U9fOXVGTk8PEJQ4s3lZHYe2q4SutTtancp
         m8lwQAZXt6vgOBUiDVecjWi0sA3YL9+HM4f7agRLjTPvJ1WUgh4ISqAVZ1CCC0EjQVhs
         oJ/KFS6sa0/7Ihf5nMInZkBxGezerKNSiV571L4A+dWLbeP0qLifJLTvFwmU2YfAo5YJ
         KsIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=97F2kk/LeEZwQe+7sraB4Mn3T/rGEIisHYfqnxFFE6I=;
        b=MiSvj8KQR1eTpg9ZC1Ksmlrv2ZPGcKUKMejopRnqrjTNeU4rremaE5bUX8bgojlDRA
         ebkoGS2usz+N5MUI/Doad2sQPJkkI7X1LBasDftGei9YGqk5/8QPUszurcDz2KAjjm6D
         fwljVRUYsUlwJJEtcC5oOj15y8OPodRM/2HKAMhBG3NTQrpKmvl3BfmYBmIdqMozoLZu
         42STV81bC6B4qaPzU3h44v3pVaMKoH8b+B9mfj/PxRWOkL7/jVEw0Wt40JYOwS1cfyfg
         BuQMpbp0MOOOtsYlA9cugg0S4erYzAY/8XL5LqnhLQorlFGG666ZBkPFFbseAiLct2H5
         /9Tw==
X-Gm-Message-State: AOAM5310dKPvWMDdIR6n6Aq9QOYalXmkqHsD+Rerg+YY65FkV2Lhanq1
        BPJWKKKzTPCTPYAyWBhJFA/WvnNMmKFXfg==
X-Google-Smtp-Source: ABdhPJzqDVMtaY/gFknJvmwYEhv+ORYiIRUxRCKLcjO2RAONh52+1s6gRFxslCqrvazuoq3DEb+c9ltlePTGQg==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a25:2c8d:: with SMTP id
 s135mr33811823ybs.466.1599553230019; Tue, 08 Sep 2020 01:20:30 -0700 (PDT)
Date:   Tue,  8 Sep 2020 01:20:23 -0700
Message-Id: <20200908082023.3690438-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net] ipv6: avoid lockdep issue in fib6_del()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported twice a lockdep issue in fib6_del() [1]
which I think is caused by net->ipv6.fib6_null_entry
having a NULL fib6_table pointer.

fib6_del() already checks for fib6_null_entry special
case, we only need to return earlier.

Bug seems to occur very rarely, I have thus chosen
a 'bug origin' that makes backports not too complex.

[1]
WARNING: suspicious RCU usage
5.9.0-rc4-syzkaller #0 Not tainted
-----------------------------
net/ipv6/ip6_fib.c:1996 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
4 locks held by syz-executor.5/8095:
 #0: ffffffff8a7ea708 (rtnl_mutex){+.+.}-{3:3}, at: ppp_release+0x178/0x240 drivers/net/ppp/ppp_generic.c:401
 #1: ffff88804c422dd8 (&net->ipv6.fib6_gc_lock){+.-.}-{2:2}, at: spin_trylock_bh include/linux/spinlock.h:414 [inline]
 #1: ffff88804c422dd8 (&net->ipv6.fib6_gc_lock){+.-.}-{2:2}, at: fib6_run_gc+0x21b/0x2d0 net/ipv6/ip6_fib.c:2312
 #2: ffffffff89bd6a40 (rcu_read_lock){....}-{1:2}, at: __fib6_clean_all+0x0/0x290 net/ipv6/ip6_fib.c:2613
 #3: ffff8880a82e6430 (&tb->tb6_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
 #3: ffff8880a82e6430 (&tb->tb6_lock){+.-.}-{2:2}, at: __fib6_clean_all+0x107/0x290 net/ipv6/ip6_fib.c:2245

stack backtrace:
CPU: 1 PID: 8095 Comm: syz-executor.5 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 fib6_del+0x12b4/0x1630 net/ipv6/ip6_fib.c:1996
 fib6_clean_node+0x39b/0x570 net/ipv6/ip6_fib.c:2180
 fib6_walk_continue+0x4aa/0x8e0 net/ipv6/ip6_fib.c:2102
 fib6_walk+0x182/0x370 net/ipv6/ip6_fib.c:2150
 fib6_clean_tree+0xdb/0x120 net/ipv6/ip6_fib.c:2230
 __fib6_clean_all+0x120/0x290 net/ipv6/ip6_fib.c:2246
 fib6_clean_all net/ipv6/ip6_fib.c:2257 [inline]
 fib6_run_gc+0x113/0x2d0 net/ipv6/ip6_fib.c:2320
 ndisc_netdev_event+0x217/0x350 net/ipv6/ndisc.c:1805
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 dev_close_many+0x30b/0x650 net/core/dev.c:1634
 rollback_registered_many+0x3a8/0x1210 net/core/dev.c:9261
 rollback_registered net/core/dev.c:9329 [inline]
 unregister_netdevice_queue+0x2dd/0x570 net/core/dev.c:10410
 unregister_netdevice include/linux/netdevice.h:2774 [inline]
 ppp_release+0x216/0x240 drivers/net/ppp/ppp_generic.c:403
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:163 [inline]
 exit_to_user_mode_prepare+0x1e1/0x200 kernel/entry/common.c:190
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:265
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 421842edeaf6 ("net/ipv6: Add fib6_null_entry")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Ahern <dsahern@gmail.com>
---
 net/ipv6/ip6_fib.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 25a90f3f705c7e6d53615f490f36c5722f3bd8b1..4a664ad4f4d4bb2b521f67e8433a06c77bd301ee 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1993,14 +1993,19 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
 /* Need to own table->tb6_lock */
 int fib6_del(struct fib6_info *rt, struct nl_info *info)
 {
-	struct fib6_node *fn = rcu_dereference_protected(rt->fib6_node,
-				    lockdep_is_held(&rt->fib6_table->tb6_lock));
-	struct fib6_table *table = rt->fib6_table;
 	struct net *net = info->nl_net;
 	struct fib6_info __rcu **rtp;
 	struct fib6_info __rcu **rtp_next;
+	struct fib6_table *table;
+	struct fib6_node *fn;
 
-	if (!fn || rt == net->ipv6.fib6_null_entry)
+	if (rt == net->ipv6.fib6_null_entry)
+		return -ENOENT;
+
+	table = rt->fib6_table;
+	fn = rcu_dereference_protected(rt->fib6_node,
+				       lockdep_is_held(&table->tb6_lock));
+	if (!fn)
 		return -ENOENT;
 
 	WARN_ON(!(fn->fn_flags & RTN_RTINFO));
-- 
2.28.0.526.ge36021eeef-goog

