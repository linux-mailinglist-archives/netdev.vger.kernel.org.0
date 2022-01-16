Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5F848FBE1
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 10:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbiAPJCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 04:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiAPJCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 04:02:25 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE705C061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 01:02:24 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id l6-20020a17090a4d4600b001b44bb75a8bso6045593pjh.3
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 01:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/uBrL59bgDFlt5etC3XXi+1XnFMPjm5r9PCjGG42F9A=;
        b=IcfqUxWzX9LZvLp0Uo0PseqsngSMp/F9ZYH9Pqxr5P3z1wck88Z5HMgfyfjXYUAwow
         tqU7zhXw8Bed+AX5nKIcqy9MCgogDPrLrOOxNuyCtX66mbM3/mfUh8qYukfdjO+zR50t
         LMiYnacAvQ2eANFzoNIzdy13jJGyKThpJjHe+vH8zwi4+MBBuSNbKVnQnERhogVXJDA5
         3dR+6WtEd2JS9rcqt+4iW6JjnM2ubvTRTMWlnHNwUmbBhGG4UdoolxncPsj9yGI+ZGkf
         Ek6vnaELZkM3fcuFR5yA4flLYjzvTy+dmvb5QPGjKrcJDJPaCCYV5be4T+ymyozmpjn4
         gDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/uBrL59bgDFlt5etC3XXi+1XnFMPjm5r9PCjGG42F9A=;
        b=l3qCsUfWdwpVEt7/qVBh08dwunsSRcUA79IvunZ3WerF8Hkcds8uQg5PzmKAM8iTQ5
         cHFA79/btiH7AecTXEcPRbyMq6Osl/ji9XYmfU6dLlZ/LPb8sy3XCFhiQvDzKRJXMuNH
         a6aNDSRIE9K/BiSm1XPezflTUZgcywAdbO119zlLUiQfMJb4gQCKuNJqq7SJ7spq9tTH
         QD94EG6s+uoBG02EYEsX/b8Ai5Y3Ckwn8Zrm5SQtcC2k3KgVTFQeGRLsi0n3d/tsj0oy
         FWjWuazONYMEHFAhQhYF0jA+ZEpdsvlfyfVgiZPoMX8KuR453Jyk2GS9K6O1b83D7sDM
         t//A==
X-Gm-Message-State: AOAM533yzjCXPdNgg9tYp6uZRGqH5Ytc8ipbHTZLZKa/6JAj7TKOKwkN
        8urfzLcThKnucjvRa5dcG/E=
X-Google-Smtp-Source: ABdhPJw+oKarQsWdrg7+CvGaK+grY78OARXBOfHtuActKR2ec/GrDpTXSbtzOGRv6DE6xshq7IDLig==
X-Received: by 2002:a17:902:9348:b0:14a:1390:5e1b with SMTP id g8-20020a170902934800b0014a13905e1bmr16981030plp.149.1642323744532;
        Sun, 16 Jan 2022 01:02:24 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a1fb:ea1f:df5:de85])
        by smtp.gmail.com with ESMTPSA id j16sm11550421pfj.16.2022.01.16.01.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 01:02:24 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH v2 net] ipv4: update fib_info_cnt under spinlock protection
Date:   Sun, 16 Jan 2022 01:02:20 -0800
Message-Id: <20220116090220.2378360-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

In the past, free_fib_info() was supposed to be called
under RTNL protection.

This eventually was no longer the case.

Instead of enforcing RTNL it seems we simply can
move fib_info_cnt changes to occur when fib_info_lock
is held.

v2: David Laight suggested to update fib_info_cnt
only when an entry is added/deleted to/from the hash table,
as fib_info_cnt is used to make sure hash table size
is optimal.

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
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Ido Schimmel <idosch@mellanox.com>
Cc: Jiri Pirko <jiri@mellanox.com>
---
 net/ipv4/fib_semantics.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 828de171708f599b56f63715514c0259c7cb08a2..45619c005b8dddd7ccd5c7029efa4ed69b6ce1de 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -249,7 +249,6 @@ void free_fib_info(struct fib_info *fi)
 		pr_warn("Freeing alive fib_info %p\n", fi);
 		return;
 	}
-	fib_info_cnt--;
 
 	call_rcu(&fi->rcu, free_fib_info_rcu);
 }
@@ -260,6 +259,10 @@ void fib_release_info(struct fib_info *fi)
 	spin_lock_bh(&fib_info_lock);
 	if (fi && refcount_dec_and_test(&fi->fib_treeref)) {
 		hlist_del(&fi->fib_hash);
+
+		/* Paired with READ_ONCE() in fib_create_info(). */
+		WRITE_ONCE(fib_info_cnt, fib_info_cnt - 1);
+
 		if (fi->fib_prefsrc)
 			hlist_del(&fi->fib_lhash);
 		if (fi->nh) {
@@ -1430,7 +1433,9 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 #endif
 
 	err = -ENOBUFS;
-	if (fib_info_cnt >= fib_info_hash_size) {
+
+	/* Paired with WRITE_ONCE() in fib_release_info() */
+	if (READ_ONCE(fib_info_cnt) >= fib_info_hash_size) {
 		unsigned int new_size = fib_info_hash_size << 1;
 		struct hlist_head *new_info_hash;
 		struct hlist_head *new_laddrhash;
@@ -1462,7 +1467,6 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		return ERR_PTR(err);
 	}
 
-	fib_info_cnt++;
 	fi->fib_net = net;
 	fi->fib_protocol = cfg->fc_protocol;
 	fi->fib_scope = cfg->fc_scope;
@@ -1591,6 +1595,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 	refcount_set(&fi->fib_treeref, 1);
 	refcount_set(&fi->fib_clntref, 1);
 	spin_lock_bh(&fib_info_lock);
+	fib_info_cnt++;
 	hlist_add_head(&fi->fib_hash,
 		       &fib_info_hash[fib_info_hashfn(fi)]);
 	if (fi->fib_prefsrc) {
-- 
2.34.1.703.g22d0c6ccf7-goog

