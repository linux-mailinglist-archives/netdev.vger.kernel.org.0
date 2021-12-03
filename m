Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AD5466FBD
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbhLCCar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbhLCCao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:30:44 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD529C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:27:21 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 71so1613948pgb.4
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ATnrD+CBlywypNgbBi2Deb+783HN3rBIMRBzVUFMTkM=;
        b=DIzknvjqmUaI1WilIUYsvxXWurGCvGH6tRAGlpPHm4ed6dQP4ksogCFlhbjcFNzYzw
         UN37xQqxkjuLiHUOYAQ0+HBpkAjQt49Cj+NMESWBJQxdm4os4XnqbUq6hpYZaGz5gm9D
         RX7fnKX0EnxrvyBx9qE8Jlors1wwYrKkGtE17oAwSD3ts7mP6UuK1yFwcUiOGCIkTu47
         xh0J1EFJSmhUJbHkiyWpElHeZKFECA6DnedgDTBSog4OpiA+dNm+IvLC3qxklnSVKBNa
         TA8Zkv7xLhRb8SV6/cr7GL6cB7j/84OCAzjRAEDEYoC3pSDPW1d0kIL+qkF9AgOpwEot
         5Zfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ATnrD+CBlywypNgbBi2Deb+783HN3rBIMRBzVUFMTkM=;
        b=JIi+JF8hKEn2V/bxdV3KJW99K5Yi9HJmff5Vyl/OnR1u//uri0jnfZj4JE3iHpEo2H
         gQKCm8gudSheEguJrUZ9mbGZeIGyUS1Eupk7Mal9e3NOcZ+97IaWxbTWonA+TlW7nhIK
         B4y/m9s/YGqwRJbkwlljL3ZxBSTCPPvXCv3VR7ld2yRZNLKqoFAXVn0zKCZZr6+P4pT7
         RWSwKFnw4qDGGrcM26g9uIWz2Sy6gC3iwPqxfCA5YW6uRs1CaHl7gVnLQ5KDkyLOdpw1
         EkBQdl2y5Ao4CRWWTVpyoBBnBlfzr8jUr9l5Cq42lnegVR6YmouWCW2L4uoMe24Aqe/q
         MaBA==
X-Gm-Message-State: AOAM530FwL8ldN+H2VUlPSX/3P3H44fl2lpVIsulvrWNvhOzKDUHw+O6
        xcTt8uQGlFOMCn/Pb4Lr0Y4=
X-Google-Smtp-Source: ABdhPJyyLxeMQTQXBGRu4t3W9Tp81tIGFHCu+tQVxUABvyfoJrGAIi7bkwolpi4zhOt63lQiPQ0IEw==
X-Received: by 2002:a63:4a63:: with SMTP id j35mr2330950pgl.409.1638498441249;
        Thu, 02 Dec 2021 18:27:21 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id np1sm4027201pjb.22.2021.12.02.18.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:27:20 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] bonding: make tx_rebalance_counter an atomic
Date:   Thu,  2 Dec 2021 18:27:18 -0800
Message-Id: <20211203022718.1036284-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

KCSAN reported a data-race [1] around tx_rebalance_counter
which can be accessed from different contexts, without
the protection of a lock/mutex.

[1]
BUG: KCSAN: data-race in bond_alb_init_slave / bond_alb_monitor

write to 0xffff888157e8ca24 of 4 bytes by task 7075 on cpu 0:
 bond_alb_init_slave+0x713/0x860 drivers/net/bonding/bond_alb.c:1613
 bond_enslave+0xd94/0x3010 drivers/net/bonding/bond_main.c:1949
 do_set_master net/core/rtnetlink.c:2521 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3475 [inline]
 rtnl_newlink+0x1298/0x13b0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x745/0x7e0 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x14e/0x250 net/netlink/af_netlink.c:2491
 rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:5589
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x5fc/0x6c0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x6e1/0x7d0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x195/0x230 net/socket.c:2492
 __do_sys_sendmsg net/socket.c:2501 [inline]
 __se_sys_sendmsg net/socket.c:2499 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2499
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888157e8ca24 of 4 bytes by task 1082 on cpu 1:
 bond_alb_monitor+0x8f/0xc00 drivers/net/bonding/bond_alb.c:1511
 process_one_work+0x3fc/0x980 kernel/workqueue.c:2298
 worker_thread+0x616/0xa70 kernel/workqueue.c:2445
 kthread+0x2c7/0x2e0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

value changed: 0x00000001 -> 0x00000064

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 1082 Comm: kworker/u4:3 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bond1 bond_alb_monitor

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/bonding/bond_alb.c | 14 ++++++++------
 include/net/bond_alb.h         |  2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 2ec8e015c7b3364ae8ab07d0750c4ded29d5815a..533e476988f2492bd56dd97e1e16f6cb80737086 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1501,14 +1501,14 @@ void bond_alb_monitor(struct work_struct *work)
 	struct slave *slave;
 
 	if (!bond_has_slaves(bond)) {
-		bond_info->tx_rebalance_counter = 0;
+		atomic_set(&bond_info->tx_rebalance_counter, 0);
 		bond_info->lp_counter = 0;
 		goto re_arm;
 	}
 
 	rcu_read_lock();
 
-	bond_info->tx_rebalance_counter++;
+	atomic_inc(&bond_info->tx_rebalance_counter);
 	bond_info->lp_counter++;
 
 	/* send learning packets */
@@ -1530,7 +1530,7 @@ void bond_alb_monitor(struct work_struct *work)
 	}
 
 	/* rebalance tx traffic */
-	if (bond_info->tx_rebalance_counter >= BOND_TLB_REBALANCE_TICKS) {
+	if (atomic_read(&bond_info->tx_rebalance_counter) >= BOND_TLB_REBALANCE_TICKS) {
 		bond_for_each_slave_rcu(bond, slave, iter) {
 			tlb_clear_slave(bond, slave, 1);
 			if (slave == rcu_access_pointer(bond->curr_active_slave)) {
@@ -1540,7 +1540,7 @@ void bond_alb_monitor(struct work_struct *work)
 				bond_info->unbalanced_load = 0;
 			}
 		}
-		bond_info->tx_rebalance_counter = 0;
+		atomic_set(&bond_info->tx_rebalance_counter, 0);
 	}
 
 	if (bond_info->rlb_enabled) {
@@ -1610,7 +1610,8 @@ int bond_alb_init_slave(struct bonding *bond, struct slave *slave)
 	tlb_init_slave(slave);
 
 	/* order a rebalance ASAP */
-	bond->alb_info.tx_rebalance_counter = BOND_TLB_REBALANCE_TICKS;
+	atomic_set(&bond->alb_info.tx_rebalance_counter,
+		   BOND_TLB_REBALANCE_TICKS);
 
 	if (bond->alb_info.rlb_enabled)
 		bond->alb_info.rlb_rebalance = 1;
@@ -1647,7 +1648,8 @@ void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave, char
 			rlb_clear_slave(bond, slave);
 	} else if (link == BOND_LINK_UP) {
 		/* order a rebalance ASAP */
-		bond_info->tx_rebalance_counter = BOND_TLB_REBALANCE_TICKS;
+		atomic_set(&bond_info->tx_rebalance_counter,
+			   BOND_TLB_REBALANCE_TICKS);
 		if (bond->alb_info.rlb_enabled) {
 			bond->alb_info.rlb_rebalance = 1;
 			/* If the updelay module parameter is smaller than the
diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
index f6af76c87a6c3856e92ac438c6c93c4c6ab9eec2..191c36afa1f4aa543f9b3b57d35630f0e71c2584 100644
--- a/include/net/bond_alb.h
+++ b/include/net/bond_alb.h
@@ -126,7 +126,7 @@ struct tlb_slave_info {
 struct alb_bond_info {
 	struct tlb_client_info	*tx_hashtbl; /* Dynamically allocated */
 	u32			unbalanced_load;
-	int			tx_rebalance_counter;
+	atomic_t		tx_rebalance_counter;
 	int			lp_counter;
 	/* -------- rlb parameters -------- */
 	int rlb_enabled;
-- 
2.34.1.400.ga245620fadb-goog

