Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCB948ED38
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 16:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242530AbiANPjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 10:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiANPjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 10:39:06 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631B9C061574
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 07:39:06 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id m21so3059820pfd.3
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 07:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jVbM6mNS8KL0cWCXHRSztyCzhbS89w4K+/FP+fPVBx8=;
        b=N6pBNupYy9tWD7LNrJwmvXAg1SuuLNl4/0fq4LY5/EtU4Pao0wFovEWaUSIqgGUvsP
         d1uhAMOlT14Fbrak6usRFkJqsWDAtcDbLfSXNB/J2EPtpsmlqo+7nId4ljYMS4EbMx8C
         cjDzDrUfOuKfHi3xqjm/rKfQ24iP61bU1M1zDJv9SPoS/1ql8Se+lPxJR4N5zGAMQ2lZ
         oMYusByIdNAqK7mSIVLWVyz6XQSuFqLE4/xonktFlU06c9pm6mOQtKvIxSmMQCOV9ml9
         Naa9K3b1tSC7NetTB/pswMQV95ILQBUUpcXcab5gLYM/p4NwirsyQhcScdritgJ83KZw
         m7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jVbM6mNS8KL0cWCXHRSztyCzhbS89w4K+/FP+fPVBx8=;
        b=CklgTo6EpSKnIWvuuODSiOLNYgL9sdE4UcKEDNV6INC/BidOWXZBVX4Jzz2txfHpCc
         65QRS2u3cv+Zt10ue7sClqZ5xSaErNJCipG+7b45xPzDP1VCfM+IxOp8BACn2oI7uwo/
         Ko2+a6mq+Jqy/60h39WifCdxIsnP1imzPloDyz6IR1li2PAM39qgHnMuG4BAraTI8McH
         8DcM6c8u9s5NPs5ZWlMPqJPuku1eeDpKEy+zXLDsKIfVn9DGwvSPE7ULwXSClyJHaIeF
         zg9WF1FgEQisXg7tBCtFj5M5rbR7oPOK9AiYFMXX8RV8mGkiqDQq5zTlo5/hHIKd7Z+i
         2tGg==
X-Gm-Message-State: AOAM530wI6UhtkGm6TqUZqZwghwfDioAEYNdBc5w/njnb0xsZw8nV7Jv
        wJOJ2P7hs/v+t0WikDElVi8=
X-Google-Smtp-Source: ABdhPJwNMor2g60iZS5VwJzuf4i7b28BOXklsiP1tqABsrsEmSD5ATWor65HtDSIg6d9Iy8yV8naSg==
X-Received: by 2002:a63:ad0a:: with SMTP id g10mr8251865pgf.493.1642174745886;
        Fri, 14 Jan 2022 07:39:05 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f20:3e1b:6f78:eebe])
        by smtp.gmail.com with ESMTPSA id y7sm3991723pfg.195.2022.01.14.07.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 07:39:05 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net] ipv4: make fib_info_cnt atomic
Date:   Fri, 14 Jan 2022 07:39:02 -0800
Message-Id: <20220114153902.1989393-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Instead of making sure all free_fib_info() callers
hold rtnl, it seems better to convert fib_info_cnt
to an atomic_t.

BUG: KCSAN: data-race in fib_create_info / free_fib_info

write to 0xffffffff86e243a0 of 4 bytes by task 26429 on cpu 0:
 fib_create_info+0xe78/0x3440 net/ipv4/fib_semantics.c:1428
 fib_table_insert+0x148/0x10c0 net/ipv4/fib_trie.c:1224
 fib_magic+0x195/0x1e0 net/ipv4/fib_frontend.c:1087
 fib_add_ifaddr+0xd0/0x2e0 net/ipv4/fib_frontend.c:1109
 fib_netdev_event+0x178/0x510 net/ipv4/fib_frontend.c:1466
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0x53/0xb0 kernel/notifier.c:391
 __dev_notify_flags+0x1d3/0x3b0
 dev_change_flags+0xa2/0xc0 net/core/dev.c:8872
 do_setlink+0x810/0x2410 net/core/rtnetlink.c:2719
 rtnl_group_changelink net/core/rtnetlink.c:3242 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3396 [inline]
 rtnl_newlink+0xb10/0x13b0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x745/0x7e0 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x14e/0x250 net/netlink/af_netlink.c:2496
 rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:5589
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x5fc/0x6c0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x726/0x840 net/netlink/af_netlink.c:1921
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

read to 0xffffffff86e243a0 of 4 bytes by task 31505 on cpu 1:
 free_fib_info+0x35/0x80 net/ipv4/fib_semantics.c:252
 fib_info_put include/net/ip_fib.h:575 [inline]
 nsim_fib4_rt_destroy drivers/net/netdevsim/fib.c:294 [inline]
 nsim_fib4_rt_replace drivers/net/netdevsim/fib.c:403 [inline]
 nsim_fib4_rt_insert drivers/net/netdevsim/fib.c:431 [inline]
 nsim_fib4_event drivers/net/netdevsim/fib.c:461 [inline]
 nsim_fib_event drivers/net/netdevsim/fib.c:881 [inline]
 nsim_fib_event_work+0x15ca/0x2cf0 drivers/net/netdevsim/fib.c:1477
 process_one_work+0x3fc/0x980 kernel/workqueue.c:2298
 process_scheduled_works kernel/workqueue.c:2361 [inline]
 worker_thread+0x7df/0xa70 kernel/workqueue.c:2447
 kthread+0x2c7/0x2e0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

value changed: 0x00000d2d -> 0x00000d2e

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 31505 Comm: kworker/1:21 Not tainted 5.16.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events nsim_fib_event_work

Fixes: 48bb9eb47b27 ("netdevsim: fib: Add dummy implementation for FIB offload")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Ido Schimmel <idosch@mellanox.com>
Cc: Jiri Pirko <jiri@mellanox.com>
---
 net/ipv4/fib_semantics.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 828de171708f599b56f63715514c0259c7cb08a2..302373acf232205c812d10a041a87f22a64b1017 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -51,7 +51,7 @@ static DEFINE_SPINLOCK(fib_info_lock);
 static struct hlist_head *fib_info_hash;
 static struct hlist_head *fib_info_laddrhash;
 static unsigned int fib_info_hash_size;
-static unsigned int fib_info_cnt;
+static atomic_t fib_info_cnt;
 
 #define DEVINDEX_HASHBITS 8
 #define DEVINDEX_HASHSIZE (1U << DEVINDEX_HASHBITS)
@@ -249,7 +249,7 @@ void free_fib_info(struct fib_info *fi)
 		pr_warn("Freeing alive fib_info %p\n", fi);
 		return;
 	}
-	fib_info_cnt--;
+	atomic_dec(&fib_info_cnt);
 
 	call_rcu(&fi->rcu, free_fib_info_rcu);
 }
@@ -1430,7 +1430,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 #endif
 
 	err = -ENOBUFS;
-	if (fib_info_cnt >= fib_info_hash_size) {
+	if (atomic_read(&fib_info_cnt) >= fib_info_hash_size) {
 		unsigned int new_size = fib_info_hash_size << 1;
 		struct hlist_head *new_info_hash;
 		struct hlist_head *new_laddrhash;
@@ -1462,7 +1462,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		return ERR_PTR(err);
 	}
 
-	fib_info_cnt++;
+	atomic_inc(&fib_info_cnt);
 	fi->fib_net = net;
 	fi->fib_protocol = cfg->fc_protocol;
 	fi->fib_scope = cfg->fc_scope;
-- 
2.34.1.703.g22d0c6ccf7-goog

