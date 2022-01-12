Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1833148C44D
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353308AbiALM7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 07:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353310AbiALM7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 07:59:43 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2676BC06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 04:59:43 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so4655607pjp.0
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 04:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OHdLFTm8lKZbKl6kA8r0qWGd9KpsoadgXMTbyIo8Zug=;
        b=izKuq5YSe41ks1ogojyup2sNfPy691J9TXqpkQSJ0EBfO1+Jhgo+IWOBl121xaq9CR
         /9VwvQjO5xMvt8UayghXJjczNDppstil2YDe/pEUpBY3lFUsScqLdSw8iv3WU8KX26TZ
         aVQRBNT++V6FPdpNe4q/wgVvc/QLADDn8aXnvsMMp5NVkWhfUmJsCoRSjY0hoAD2Jpn9
         ymD7JrabF9Q8Ut68q32+Y4g+Xx03BqnIBP/mfLC8ENCdcRrxtid+gEltk0YR2ZOSC0R0
         Rfr+Ham2tg3KAVPuL7LagTZOh6cAEvAOWnTr08sIvEYXt7otUXfAXV5ho/VeCeVzQ9bE
         5AGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OHdLFTm8lKZbKl6kA8r0qWGd9KpsoadgXMTbyIo8Zug=;
        b=QYQNfAdQBhTKUPGVDQ2vB+yM4soHoX0BVOAGwCsGmACsQallkWO2h60jrYJh8HKN0N
         jIYUEyzQqYFm+4YPGvscYSzJ4E0nGZ4W8UfTCUzq4sqaQUDUzPWwBMxdbIJgGfB5mtPQ
         ByUaz+sXrToUKhl4k/y8kGLGL7eOT4kWjEti+GVtEJuxGtHbWbRjjQr9z32b35C5lFLX
         JwNyZNqKiqUrLBfPtTNA8rNRmCz9W5vPO8pVQ+ki3zIc2iyAkHW+I1ZvuuWEI8ZiZ5Z0
         uXZFdAqCl5P3/EFsZDXqNYiMD96Fw2EdTlOswE0tNQQ64pqqy4Wym48WeywovDnyePJN
         9jKQ==
X-Gm-Message-State: AOAM530opaRmCAcPtYX57Z7w97NYTqeK8xbCZiemak//JvQhPjer/wYg
        7Nrg4XlD8AzjGvVvh05oUO0=
X-Google-Smtp-Source: ABdhPJzR2wUax8cFAJfutNaxKXNrJA0DM193Ws8LJa2++U75I1KefEx9tSMgAp6Q7Y+K8LkjRZis9A==
X-Received: by 2002:a63:354c:: with SMTP id c73mr8384494pga.532.1641992382682;
        Wed, 12 Jan 2022 04:59:42 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d4:f730:8e14:abc3])
        by smtp.gmail.com with ESMTPSA id nv2sm6862200pjb.12.2022.01.12.04.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 04:59:42 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net/smc: fix possible NULL deref in smc_pnet_add_eth()
Date:   Wed, 12 Jan 2022 04:59:39 -0800
Message-Id: <20220112125939.507195-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

I missed that @ndev value can be NULL.

I prefer not factorizing this NULL check, and instead
clearly document where a NULL might be expected.

general protection fault, probably for non-canonical address 0xdffffc00000000ba: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000005d0-0x00000000000005d7]
CPU: 0 PID: 19875 Comm: syz-executor.2 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_acquire+0xd7a/0x5470 kernel/locking/lockdep.c:4897
Code: 14 0e 41 bf 01 00 00 00 0f 86 c8 00 00 00 89 05 5c 20 14 0e e9 bd 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f 85 9f 2e 00 00 49 81 3e 20 c5 1a 8f 0f 84 52 f3 ff
RSP: 0018:ffffc900057071d0 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 1ffff92000ae0e65 RCX: 1ffff92000ae0e4c
RDX: 00000000000000ba RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff1b24ae2 R11: 000000000008808a R12: 0000000000000000
R13: ffff888040ca4000 R14: 00000000000005d0 R15: 0000000000000000
FS:  00007fbd683e0700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2be22000 CR3: 0000000013fea000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 ref_tracker_alloc+0x182/0x440 lib/ref_tracker.c:84
 netdev_tracker_alloc include/linux/netdevice.h:3859 [inline]
 smc_pnet_add_eth net/smc/smc_pnet.c:372 [inline]
 smc_pnet_enter net/smc/smc_pnet.c:492 [inline]
 smc_pnet_add+0x49a/0x14d0 net/smc/smc_pnet.c:555
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2413
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: b60645248af3 ("net/smc: add net device tracker to struct smc_pnetentry")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/smc/smc_pnet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index db9825c01e0af2b17454b27e4d47ee035f42c8a2..291f1484a1b74c0a793ab3c4f3ef90804d1f9932 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -369,7 +369,8 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 	memcpy(new_pe->pnet_name, pnet_name, SMC_MAX_PNETID_LEN);
 	strncpy(new_pe->eth_name, eth_name, IFNAMSIZ);
 	new_pe->ndev = ndev;
-	netdev_tracker_alloc(ndev, &new_pe->dev_tracker, GFP_KERNEL);
+	if (ndev)
+		netdev_tracker_alloc(ndev, &new_pe->dev_tracker, GFP_KERNEL);
 	rc = -EEXIST;
 	new_netdev = true;
 	write_lock(&pnettable->lock);
-- 
2.34.1.575.g55b058a8bb-goog

