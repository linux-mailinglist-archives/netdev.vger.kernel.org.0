Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 279D415FE0C
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 11:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgBOKus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 05:50:48 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40944 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgBOKus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 05:50:48 -0500
Received: by mail-pg1-f195.google.com with SMTP id z7so6478665pgk.7
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 02:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vURb206eHO1HYzK+flFkwhfUsNajxsNkahnYzJaCx4o=;
        b=Yp1EdCbIptxkShd7UXpn7fP3XAa/RatluhNNA4KycP2DUvLLCnNEUKLz2QtyCEoB/a
         +TVEaHyjhZ0J4m5sazfOcBhv2LuqWMDRmNqfY3MKZamMN43V5amu/n1sxQTNtUPgtz+6
         17AdrxhD/102dVV8cGjYLZylzplu2zsLZDMYGJtaVvQ3OYjTZdRdBqd2fKYasftNB/GC
         aO8nTwhkLzNpIGELHD2w6V6Skio66tcOUfyP2FdNBGrbdsm3hOhuI4lLa8BNmu/+qqzF
         hzDApy7FxWoJHVIravtre4NjwoeVItDByFtkBzGaCoAwFrUbHQGqaNBIubziH5+W5jV8
         tpWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vURb206eHO1HYzK+flFkwhfUsNajxsNkahnYzJaCx4o=;
        b=oeaPLQJgob0KRegHRtpH8WbB23LFVft3BaJO8k/VTK+0phgWwlqKOXQQ2Gzt5MuHp8
         uCVObTZc7WlghGtdgluF96P5OG9nmuwcUwU4Qcj/+ABEtMeHj9p1TdyFqeXMfmRc9QnB
         ERuIYlwY6Q4ppiY+De1HRa4RHnQOXsUUwgkj8YG+jnZJ9LY7OjDR2DyV2PHFSErzEeL9
         fa2fxYu+VqTwGjzvwFBnKoP+ahdQxNgdJskXPwxIJgvYEOrR2tWWrvOwGbuD+RfSXPBb
         0Vkm1JBc6Pi1DY8sEeitP/Gzw8DTgxVIVJO5Ysoo2Q6+V9u19/QRAnNPZ8lwlYD/HMOl
         Qa6g==
X-Gm-Message-State: APjAAAXb98Sgb2VKINnUYsv+PfPeUNuZXdy49RhBIeOMyPWIP3mVnqCX
        q1LzCvfRJLllz8PioMj1fJ0=
X-Google-Smtp-Source: APXvYqzQiNVz/DS/oHUSKdURxbbWQtyEM5LEq7FGUqX0dL8qV5lPnAGGJUHBwNu6899Wdd0GOAEKkA==
X-Received: by 2002:a63:6d01:: with SMTP id i1mr7941757pgc.55.1581763847270;
        Sat, 15 Feb 2020 02:50:47 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id k2sm10387717pgk.84.2020.02.15.02.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 02:50:46 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 3/3] bonding: fix lockdep warning in bond_get_stats()
Date:   Sat, 15 Feb 2020 10:50:40 +0000
Message-Id: <20200215105040.21606-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the "struct bonding", there is stats_lock.
This lock protects "bond_stats" in the "struct bonding".
bond_stats is updated in the bond_get_stats() and this function would be
executed concurrently. So, the lock is needed.

Bonding interfaces would be nested.
So, either stats_lock should use dynamic lockdep class key or stats_lock
should be used by spin_lock_nested(). In the current code, stats_lock is
using a dynamic lockdep class key.
But there is no updating stats_lock_key routine So, lockdep warning
will occur.

Test commands:
    ip link add bond0 type bond
    ip link add bond1 type bond
    ip link set bond0 master bond1
    ip link set bond0 nomaster
    ip link set bond1 master bond0

Splat looks like:
[   38.420603][  T957] 5.5.0+ #394 Not tainted
[   38.421074][  T957] ------------------------------------------------------
[   38.421837][  T957] ip/957 is trying to acquire lock:
[   38.422399][  T957] ffff888063262cd8 (&bond->stats_lock_key#2){+.+.}, at: bond_get_stats+0x90/0x4d0 [bonding]
[   38.423528][  T957]
[   38.423528][  T957] but task is already holding lock:
[   38.424526][  T957] ffff888065fd2cd8 (&bond->stats_lock_key){+.+.}, at: bond_get_stats+0x90/0x4d0 [bonding]
[   38.426075][  T957]
[   38.426075][  T957] which lock already depends on the new lock.
[   38.426075][  T957]
[   38.428536][  T957]
[   38.428536][  T957] the existing dependency chain (in reverse order) is:
[   38.429475][  T957]
[   38.429475][  T957] -> #1 (&bond->stats_lock_key){+.+.}:
[   38.430273][  T957]        _raw_spin_lock+0x30/0x70
[   38.430812][  T957]        bond_get_stats+0x90/0x4d0 [bonding]
[   38.431451][  T957]        dev_get_stats+0x1ec/0x270
[   38.432088][  T957]        bond_get_stats+0x1a5/0x4d0 [bonding]
[   38.432767][  T957]        dev_get_stats+0x1ec/0x270
[   38.433322][  T957]        rtnl_fill_stats+0x44/0xbe0
[   38.433866][  T957]        rtnl_fill_ifinfo+0xeb2/0x3720
[   38.434474][  T957]        rtmsg_ifinfo_build_skb+0xca/0x170
[   38.435081][  T957]        rtmsg_ifinfo_event.part.33+0x1b/0xb0
[   38.436848][  T957]        rtnetlink_event+0xcd/0x120
[   38.437455][  T957]        notifier_call_chain+0x90/0x160
[   38.438067][  T957]        netdev_change_features+0x74/0xa0
[   38.438708][  T957]        bond_compute_features.isra.45+0x4e6/0x6f0 [bonding]
[   38.439522][  T957]        bond_enslave+0x3639/0x47b0 [bonding]
[   38.440225][  T957]        do_setlink+0xaab/0x2ef0
[   38.440786][  T957]        __rtnl_newlink+0x9c5/0x1270
[   38.441463][  T957]        rtnl_newlink+0x65/0x90
[   38.442075][  T957]        rtnetlink_rcv_msg+0x4a8/0x890
[   38.442774][  T957]        netlink_rcv_skb+0x121/0x350
[   38.443451][  T957]        netlink_unicast+0x42e/0x610
[   38.444282][  T957]        netlink_sendmsg+0x65a/0xb90
[   38.444992][  T957]        ____sys_sendmsg+0x5ce/0x7a0
[   38.445679][  T957]        ___sys_sendmsg+0x10f/0x1b0
[   38.446365][  T957]        __sys_sendmsg+0xc6/0x150
[   38.447007][  T957]        do_syscall_64+0x99/0x4f0
[   38.447668][  T957]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   38.448538][  T957]
[   38.448538][  T957] -> #0 (&bond->stats_lock_key#2){+.+.}:
[   38.449554][  T957]        __lock_acquire+0x2d8d/0x3de0
[   38.450148][  T957]        lock_acquire+0x164/0x3b0
[   38.450711][  T957]        _raw_spin_lock+0x30/0x70
[   38.451292][  T957]        bond_get_stats+0x90/0x4d0 [bonding]
[   38.451950][  T957]        dev_get_stats+0x1ec/0x270
[   38.452425][  T957]        bond_get_stats+0x1a5/0x4d0 [bonding]
[   38.453362][  T957]        dev_get_stats+0x1ec/0x270
[   38.453825][  T957]        rtnl_fill_stats+0x44/0xbe0
[   38.454390][  T957]        rtnl_fill_ifinfo+0xeb2/0x3720
[   38.456257][  T957]        rtmsg_ifinfo_build_skb+0xca/0x170
[   38.456998][  T957]        rtmsg_ifinfo_event.part.33+0x1b/0xb0
[   38.459351][  T957]        rtnetlink_event+0xcd/0x120
[   38.460086][  T957]        notifier_call_chain+0x90/0x160
[   38.460829][  T957]        netdev_change_features+0x74/0xa0
[   38.461752][  T957]        bond_compute_features.isra.45+0x4e6/0x6f0 [bonding]
[   38.462705][  T957]        bond_enslave+0x3639/0x47b0 [bonding]
[   38.463476][  T957]        do_setlink+0xaab/0x2ef0
[   38.464141][  T957]        __rtnl_newlink+0x9c5/0x1270
[   38.464897][  T957]        rtnl_newlink+0x65/0x90
[   38.465522][  T957]        rtnetlink_rcv_msg+0x4a8/0x890
[   38.466215][  T957]        netlink_rcv_skb+0x121/0x350
[   38.466895][  T957]        netlink_unicast+0x42e/0x610
[   38.467583][  T957]        netlink_sendmsg+0x65a/0xb90
[   38.468285][  T957]        ____sys_sendmsg+0x5ce/0x7a0
[   38.469202][  T957]        ___sys_sendmsg+0x10f/0x1b0
[   38.469884][  T957]        __sys_sendmsg+0xc6/0x150
[   38.470587][  T957]        do_syscall_64+0x99/0x4f0
[   38.471245][  T957]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   38.472093][  T957]
[   38.472093][  T957] other info that might help us debug this:
[   38.472093][  T957]
[   38.473438][  T957]  Possible unsafe locking scenario:
[   38.473438][  T957]
[   38.474898][  T957]        CPU0                    CPU1
[   38.476234][  T957]        ----                    ----
[   38.480171][  T957]   lock(&bond->stats_lock_key);
[   38.480808][  T957]                                lock(&bond->stats_lock_key#2);
[   38.481791][  T957]                                lock(&bond->stats_lock_key);
[   38.482754][  T957]   lock(&bond->stats_lock_key#2);
[   38.483416][  T957]
[   38.483416][  T957]  *** DEADLOCK ***
[   38.483416][  T957]
[   38.484505][  T957] 3 locks held by ip/957:
[   38.485048][  T957]  #0: ffffffffbccf6230 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x457/0x890
[   38.486198][  T957]  #1: ffff888065fd2cd8 (&bond->stats_lock_key){+.+.}, at: bond_get_stats+0x90/0x4d0 [bonding]
[   38.487625][  T957]  #2: ffffffffbc9254c0 (rcu_read_lock){....}, at: bond_get_stats+0x5/0x4d0 [bonding]
[   38.488897][  T957]
[   38.488897][  T957] stack backtrace:
[   38.489646][  T957] CPU: 1 PID: 957 Comm: ip Not tainted 5.5.0+ #394
[   38.490497][  T957] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   38.492810][  T957] Call Trace:
[   38.493219][  T957]  dump_stack+0x96/0xdb
[   38.493709][  T957]  check_noncircular+0x371/0x450
[   38.494344][  T957]  ? lookup_address+0x60/0x60
[   38.494923][  T957]  ? print_circular_bug.isra.35+0x310/0x310
[   38.495699][  T957]  ? hlock_class+0x130/0x130
[   38.496334][  T957]  ? __lock_acquire+0x2d8d/0x3de0
[   38.496979][  T957]  __lock_acquire+0x2d8d/0x3de0
[   38.497607][  T957]  ? register_lock_class+0x14d0/0x14d0
[   38.498333][  T957]  ? check_chain_key+0x236/0x5d0
[   38.499003][  T957]  lock_acquire+0x164/0x3b0
[   38.499800][  T957]  ? bond_get_stats+0x90/0x4d0 [bonding]
[   38.500706][  T957]  _raw_spin_lock+0x30/0x70
[   38.501435][  T957]  ? bond_get_stats+0x90/0x4d0 [bonding]
[   38.502311][  T957]  bond_get_stats+0x90/0x4d0 [bonding]
[ ... ]

But, there is another problem.
The dynamic lockdep class key is protected by RTNL, but bond_get_stats()
would be called outside of RTNL.
So, it would use an invalid dynamic lockdep class key.

In order to fix this issue, stats_lock uses spin_lock_nested() instead of
a dynamic lockdep key.
The bond_get_stats() calls bond_get_lowest_level_rcu() to get the correct
nest level value, which will be used by spin_lock_nested().
The "dev->lower_level" indicates lower nest level value, but this value
is invalid outside of RTNL.
So, bond_get_lowest_level_rcu() returns valid lower nest level value in
the RCU critical section.
bond_get_lowest_level_rcu() will be work only when LOCKDEP is enabled.

Fixes: 089bca2caed0 ("bonding: use dynamic lockdep key instead of subclass")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - Initial patch

 drivers/net/bonding/bond_main.c | 53 +++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 1e9d5d35fc78..d10805e5e623 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3526,6 +3526,47 @@ static void bond_fold_stats(struct rtnl_link_stats64 *_res,
 	}
 }
 
+#ifdef CONFIG_LOCKDEP
+static int bond_get_lowest_level_rcu(struct net_device *dev)
+{
+	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
+	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
+	int cur = 0, max = 0;
+
+	now = dev;
+	iter = &dev->adj_list.lower;
+
+	while (1) {
+		next = NULL;
+		while (1) {
+			ldev = netdev_next_lower_dev_rcu(now, &iter);
+			if (!ldev)
+				break;
+
+			next = ldev;
+			niter = &ldev->adj_list.lower;
+			dev_stack[cur] = now;
+			iter_stack[cur++] = iter;
+			if (max <= cur)
+				max = cur;
+			break;
+		}
+
+		if (!next) {
+			if (!cur)
+				return max;
+			next = dev_stack[--cur];
+			niter = iter_stack[cur];
+		}
+
+		now = next;
+		iter = niter;
+	}
+
+	return max;
+}
+#endif
+
 static void bond_get_stats(struct net_device *bond_dev,
 			   struct rtnl_link_stats64 *stats)
 {
@@ -3533,11 +3574,17 @@ static void bond_get_stats(struct net_device *bond_dev,
 	struct rtnl_link_stats64 temp;
 	struct list_head *iter;
 	struct slave *slave;
+	int nest_level = 0;
 
-	spin_lock(&bond->stats_lock);
-	memcpy(stats, &bond->bond_stats, sizeof(*stats));
 
 	rcu_read_lock();
+#ifdef CONFIG_LOCKDEP
+	nest_level = bond_get_lowest_level_rcu(bond_dev);
+#endif
+
+	spin_lock_nested(&bond->stats_lock, nest_level);
+	memcpy(stats, &bond->bond_stats, sizeof(*stats));
+
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		const struct rtnl_link_stats64 *new =
 			dev_get_stats(slave->dev, &temp);
@@ -3547,10 +3594,10 @@ static void bond_get_stats(struct net_device *bond_dev,
 		/* save off the slave stats for the next run */
 		memcpy(&slave->slave_stats, new, sizeof(*new));
 	}
-	rcu_read_unlock();
 
 	memcpy(&bond->bond_stats, stats, sizeof(*stats));
 	spin_unlock(&bond->stats_lock);
+	rcu_read_unlock();
 }
 
 static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd)
-- 
2.17.1

