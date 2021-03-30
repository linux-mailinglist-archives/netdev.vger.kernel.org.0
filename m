Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD70D34E172
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 08:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhC3GqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 02:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhC3Gp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 02:45:56 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17765C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 23:45:56 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id p12so6363133pgj.10
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 23:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KZP75OjQry/uPdKjzimKTM/OAfV058mi27NbCAn/2pg=;
        b=jdhZy5I7jMWKREhbyPGHBFCUvvl7zLTXjMzAjsoeshwb1aUqSUk/y8cd1Q6z8ey59D
         ZgYsAyFFffmt4L95Aqz5PCVzIEmEWjX7TtToQfv797kfOxwe5rYl3If0PjWDuaxxZxjP
         uTrr5Pdgiq2hYdqwqiMfX5UdKV95GL9OwmJQPk45c+ta2D9PQhzJdtdx85nTGMpFMkke
         zcolgJjyskKlYDzYFX8NlMDN+et2KZp6tgrOq/apqKhYwmMGPXNIfCEdByIiO9KvuzV2
         0gcsp5Mq/qNVE2xwXuMzUEFSyNJ4DWFsYgf0FvP3mO5qFxeW/484O6aoIHXumuo89igP
         BKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KZP75OjQry/uPdKjzimKTM/OAfV058mi27NbCAn/2pg=;
        b=RQvP4liUJtehDgvjTn2zj1BI6KFHhnYlQYu7NuHZMBUzdQ2jvBkiAj3UhtS1zC72js
         +xtErBVe4dWtA3FS9Bt3E4tVHyuv2wjol4taENJ0bX1vMskCGM/NV8Gd/a1mFCHvE9Op
         vQtDuTWb95M5VxC+ZCv/VAhWadGntbFo24VrpYFTK4+i8sDGjsJtraaXdISfI0W4b5wZ
         9hLSxdfGVIZk+Z7Zbqujd8BSaUTPWpvwdLFVj+phv5t6KMPUMcDVu5TZzSkTtfEm2jtd
         6yNJKJwfnDY/40t9Uai53LWPWn0DIo7JzOngRFXUpWzG81+VWM/yyP3Zw+H4IK/2miQP
         A+eA==
X-Gm-Message-State: AOAM532+fj6zyanDPd6SNjBGa4Ao+YwGcxSx07Dv94ImWkZjLymrrVof
        DGdnx9VTTIa3maVAlwtpBiE=
X-Google-Smtp-Source: ABdhPJyoIKXAyJh5JC7i7hSizaw2TTHhSZD8dL4N5AyLtgPDhUGPxQZtjqbDjTjqeWXkQohC6f9XNw==
X-Received: by 2002:a63:4462:: with SMTP id t34mr26619062pgk.389.1617086755659;
        Mon, 29 Mar 2021 23:45:55 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:78a0:7565:129d:828c])
        by smtp.gmail.com with ESMTPSA id y20sm19286714pfo.210.2021.03.29.23.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 23:45:55 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods
Date:   Mon, 29 Mar 2021 23:45:51 -0700
Message-Id: <20210330064551.545964-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Same reasons than for the previous commits :
6289a98f0817 ("sit: proper dev_{hold|put} in ndo_[un]init methods")
40cb881b5aaa ("ip6_vti: proper dev_{hold|put} in ndo_[un]init methods")
7f700334be9a ("ip6_gre: proper dev_{hold|put} in ndo_[un]init methods")

After adopting CONFIG_PCPU_DEV_REFCNT=n option, syzbot was able to trigger
a warning [1]

Issue here is that:

- all dev_put() should be paired with a corresponding prior dev_hold().

- A driver doing a dev_put() in its ndo_uninit() MUST also
  do a dev_hold() in its ndo_init(), only when ndo_init()
  is returning 0.

Otherwise, register_netdevice() would call ndo_uninit()
in its error path and release a refcount too soon.

[1]
WARNING: CPU: 1 PID: 21059 at lib/refcount.c:31 refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Modules linked in:
CPU: 1 PID: 21059 Comm: syz-executor.4 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Code: 1d 6a 5a e8 09 31 ff 89 de e8 8d 1a ab fd 84 db 75 e0 e8 d4 13 ab fd 48 c7 c7 a0 e1 c1 89 c6 05 4a 5a e8 09 01 e8 2e 36 fb 04 <0f> 0b eb c4 e8 b8 13 ab fd 0f b6 1d 39 5a e8 09 31 ff 89 de e8 58
RSP: 0018:ffffc900025aefe8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815c51f5 RDI: fffff520004b5def
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815bdf8e R11: 0000000000000000 R12: ffff888023488568
R13: ffff8880254e9000 R14: 00000000dfd82cfd R15: ffff88802ee2d7c0
FS:  00007f13bc590700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0943e74000 CR3: 0000000025273000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __refcount_dec include/linux/refcount.h:344 [inline]
 refcount_dec include/linux/refcount.h:359 [inline]
 dev_put include/linux/netdevice.h:4135 [inline]
 ip6_tnl_dev_uninit+0x370/0x3d0 net/ipv6/ip6_tunnel.c:387
 register_netdevice+0xadf/0x1500 net/core/dev.c:10308
 ip6_tnl_create2+0x1b5/0x400 net/ipv6/ip6_tunnel.c:263
 ip6_tnl_newlink+0x312/0x580 net/ipv6/ip6_tunnel.c:2052
 __rtnl_newlink+0x1062/0x1710 net/core/rtnetlink.c:3443
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 919067cc845f ("net: add CONFIG_PCPU_DEV_REFCNT")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/ip6_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index cd78f5b2cd75e20a79fd6c4cbfafd548204c2b7c..67ee9d58ec5efcc81e8b27406bd4f57a0caea70b 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -266,7 +266,6 @@ static int ip6_tnl_create2(struct net_device *dev)
 
 	strcpy(t->parms.name, dev->name);
 
-	dev_hold(dev);
 	ip6_tnl_link(ip6n, t);
 	return 0;
 
@@ -1882,6 +1881,7 @@ ip6_tnl_dev_init_gen(struct net_device *dev)
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = IP6_MAX_MTU - dev->hard_header_len;
 
+	dev_hold(dev);
 	return 0;
 
 destroy_dst:
-- 
2.31.0.291.g576ba9dcdaf-goog

