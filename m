Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DECE473BDA
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 05:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhLNEBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 23:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhLNEBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 23:01:46 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02B7C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 20:01:46 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id j11so16304061pgs.2
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 20:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hLIRPv7ANsd5EYekJkM3u3atVUUOtGJ7wFKPT0gl+xc=;
        b=W05bDODZiQabQeW3GdcWWGaqhQA7fbB9ap09A996TeBCfnsmdxYhhRygiRexK698n9
         +jbUkm/xQoFiAcwwglNigADHSteo9mP1bz5f4ythE5SRx+MCpwaUzE3dwQ8VtkYbN7aR
         RzudH3obKkKCNTcTyX0gMepnXMB3+eQPkyfUh6jryw3s+k0JYZzVUBj4Po+kR889baLS
         xb2e2B7d8h6PSdV2Wxd0skfA6TcSqjas/ecSd0n/usXEVzkYf10DzYZaiQdCTVYj6vgB
         yl8TZmPaQY1p6bfXiPLkqkUFk1Uw3sgl+sGCdggKem67df+J5uBnrtSefGDxlrEpr7Sl
         12qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hLIRPv7ANsd5EYekJkM3u3atVUUOtGJ7wFKPT0gl+xc=;
        b=JJm8TBZs/D3A/4A1XeLMlKxXnmTzuzLQSx1momoIL35fnFhES5MjqLc12YjOiID9sJ
         /EZH7rmsO+/1ImTS0knzNUbIgJ7a9QhEU2un2ScoV6sQPZ/4q5AskfxSxucuPJkZzmGF
         Y0U0qbWddwGtxa5Pi1YI+ijk5DSSZ4CAg20ZR7fv6lV2/sj2q8fM0uAvA34l1Ogp+ps/
         F6b8L0xoObNgaxzb/Bxm+kbsu3bVv1LPDfJmqCZA2PBYEChBzv0bOK1iwRwdt6Ov3BjR
         ZXNMM4Z27CcTrABB9I5kRZ1qswx0rGmC8/L4cPoeHRzzW9EC+iEiNPJPBm9r9sTvFY2L
         YYPw==
X-Gm-Message-State: AOAM532UoTCn+iX8Dwpqxb2wFjKomKSYVKFq8Uvy6bkQb6I4WXnC7Ywz
        MR8EsCidf3divenFQu5gUEA=
X-Google-Smtp-Source: ABdhPJxxvMWgZCYQM9LotLRNg/+OzXnsA9YVjbNx68JdagQrPrfPm4HwjCgMsfW+Z9v0l+o3k2WMQQ==
X-Received: by 2002:a05:6a00:b49:b0:49f:cc01:10ff with SMTP id p9-20020a056a000b4900b0049fcc0110ffmr2106841pfo.42.1639454505832;
        Mon, 13 Dec 2021 20:01:45 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5cbb:7251:72ab:eb48])
        by smtp.gmail.com with ESMTPSA id u22sm15105271pfk.148.2021.12.13.20.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 20:01:45 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] netlink: fix ethnl_parse_header_dev_get() for possible NULL deref
Date:   Mon, 13 Dec 2021 20:01:41 -0800
Message-Id: <20211214040141.3518805-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

I missed that ethnl_parse_header_dev_get() can be called
with @require_dev being false.

syzbot reported:
general protection fault, probably for non-canonical address 0xdffffc00000000ba: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000005d0-0x00000000000005d7]
CPU: 1 PID: 4172 Comm: syz-executor.4 Not tainted 5.16.0-rc4-next-20211210-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_acquire+0xd7d/0x54a0 kernel/locking/lockdep.c:4897
Code: 12 0e 41 be 01 00 00 00 0f 86 c8 00 00 00 89 05 99 83 12 0e e9 bd 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 f3 2f 00 00 48 81 3b 60 54 1a 8f 0f 84 52 f3 ff
RSP: 0018:ffffc9000c8df0b0 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 00000000000005d0 RCX: 0000000000000000
RDX: 00000000000000ba RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 000000000008808a R12: 0000000000000000
R13: ffff888074618000 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f2a0b676700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f46d6c3a3a5 CR3: 000000001fb88000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5639 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5604
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 ref_tracker_alloc+0x17c/0x430 lib/ref_tracker.c:84
 netdev_tracker_alloc include/linux/netdevice.h:3860 [inline]
 ethnl_parse_header_dev_get+0x267/0x780 net/ethtool/netlink.c:145
 ethnl_default_parse+0x8d/0x130 net/ethtool/netlink.c:316
 ethnl_default_start+0x21f/0x560 net/ethtool/netlink.c:545
 genl_start+0x3cc/0x670 net/netlink/genetlink.c:596
 __netlink_dump_start+0x584/0x900 net/netlink/af_netlink.c:2361
 genl_family_rcv_msg_dumpit+0x1c9/0x310 net/netlink/genetlink.c:689
 genl_family_rcv_msg net/netlink/genetlink.c:772 [inline]
 genl_rcv_msg+0x434/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2492
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1315 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1341
 netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ethtool/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 23f32a995099ab420d25651d85c192210b76442f..f09c62302a9a8942b3210a0496319cd5bcac1b0b 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -142,7 +142,8 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 	}
 
 	req_info->dev = dev;
-	netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
+	if (dev)
+		netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
 	req_info->flags = flags;
 	return 0;
 }
-- 
2.34.1.173.g76aa8bc2d0-goog

