Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C28374064
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbhEEQep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234173AbhEEQdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:33:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CC8D61413;
        Wed,  5 May 2021 16:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232331;
        bh=JAmVOxDyKUgdrJmFBjGYGYUz7eU8KCpUfdYmctsoKJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMVVX4aWDXcrPUXlcvjQdPSD7zPPbnPC8p7z/c1pHv0C29rwgA2ih4n+10qjQWomP
         7Akodf9jqitImyf9GU6tYEJZ8Y+cpKVicWRN8UhhUIBa2qbE5XpH7CHSFMhkqCQu2g
         NhWZMtSeLj01UevY0SpIId3Jiwnw1/gfjaaMq0VXo4/TPq9n+uDCxEAIy1ztVttJ7U
         tfZxNfkU51uIm9L/bQTBGACBfXBRmsvdoTsHPceF+XcDMo5DRJm67DSlaozHsm0FWJ
         GsATgEhVthk0jQaSZVMPahQiVO7Ff25f9MI0Zrw9i89zlys3dg6otrcaJJU+vsaXad
         HHIKOBoy4bAiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 034/116] ip6_vti: proper dev_{hold|put} in ndo_[un]init methods
Date:   Wed,  5 May 2021 12:30:02 -0400
Message-Id: <20210505163125.3460440-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 40cb881b5aaa0b69a7d93dec8440d5c62dae299f ]

After adopting CONFIG_PCPU_DEV_REFCNT=n option, syzbot was able to trigger
a warning [1]

Issue here is that:

- all dev_put() should be paired with a corresponding prior dev_hold().

- A driver doing a dev_put() in its ndo_uninit() MUST also
  do a dev_hold() in its ndo_init(), only when ndo_init()
  is returning 0.

Otherwise, register_netdevice() would call ndo_uninit()
in its error path and release a refcount too soon.

Therefore, we need to move dev_hold() call from
vti6_tnl_create2() to vti6_dev_init_gen()

[1]
WARNING: CPU: 0 PID: 15951 at lib/refcount.c:31 refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Modules linked in:
CPU: 0 PID: 15951 Comm: syz-executor.3 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Code: 1d 6a 5a e8 09 31 ff 89 de e8 8d 1a ab fd 84 db 75 e0 e8 d4 13 ab fd 48 c7 c7 a0 e1 c1 89 c6 05 4a 5a e8 09 01 e8 2e 36 fb 04 <0f> 0b eb c4 e8 b8 13 ab fd 0f b6 1d 39 5a e8 09 31 ff 89 de e8 58
RSP: 0018:ffffc90001eaef28 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815c51f5 RDI: fffff520003d5dd7
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815bdf8e R11: 0000000000000000 R12: ffff88801bb1c568
R13: ffff88801f69e800 R14: 00000000ffffffff R15: ffff888050889d40
FS:  00007fc79314e700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1c1ff47108 CR3: 0000000020fd5000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __refcount_dec include/linux/refcount.h:344 [inline]
 refcount_dec include/linux/refcount.h:359 [inline]
 dev_put include/linux/netdevice.h:4135 [inline]
 vti6_dev_uninit+0x31a/0x360 net/ipv6/ip6_vti.c:297
 register_netdevice+0xadf/0x1500 net/core/dev.c:10308
 vti6_tnl_create2+0x1b5/0x400 net/ipv6/ip6_vti.c:190
 vti6_newlink+0x9d/0xd0 net/ipv6/ip6_vti.c:1020
 __rtnl_newlink+0x1062/0x1710 net/core/rtnetlink.c:3443
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x331/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmmsg+0x195/0x470 net/socket.c:2490
 __do_sys_sendmmsg net/socket.c:2519 [inline]
 __se_sys_sendmmsg net/socket.c:2516 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2516

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_vti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index e0cc32e45880..932b15b13053 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -193,7 +193,6 @@ static int vti6_tnl_create2(struct net_device *dev)
 
 	strcpy(t->parms.name, dev->name);
 
-	dev_hold(dev);
 	vti6_tnl_link(ip6n, t);
 
 	return 0;
@@ -934,6 +933,7 @@ static inline int vti6_dev_init_gen(struct net_device *dev)
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!dev->tstats)
 		return -ENOMEM;
+	dev_hold(dev);
 	return 0;
 }
 
-- 
2.30.2

