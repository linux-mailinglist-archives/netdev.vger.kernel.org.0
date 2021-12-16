Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2671477013
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236511AbhLPLRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236483AbhLPLRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 06:17:46 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F77C06173E
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 03:17:46 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id gj24so6315448pjb.0
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 03:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CWAy1WYqdSt/0YPoIzDdHpHS3ER1pM3RG8AZaTEmK8Q=;
        b=iP/vFaZw8AT5iDkekLgQsiXmN97plx/rL1l4u2IMjlFpoFr82d5DidyAa3dwV6GdXV
         nKhYx4su0u32MqiFwZTZmNvJrIBLs7IeaDrQesvvhsbq+ISrs4AG163d5Ig6hxNzEV3H
         o22lDw6NQMabygysWYETtuOVu7CKUdIzZ8XvXmg+L6Yh2a96crVIoGfGaX8XB1IJwTDW
         PaXik9aCYrGRLi+clmedNErdxPLstfB9Joq2Al+q9UL/ZX6kL6xOlj/niITJMcSgjApR
         BGWqomI/nPJhZjRoc5dToMMooGbeVoF/huETpRG5DDEnv+qxVZQ1xMX12e+amUeyy5EY
         Zgmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CWAy1WYqdSt/0YPoIzDdHpHS3ER1pM3RG8AZaTEmK8Q=;
        b=67ZE9luaOoQICH9cBwkNtkDdFDafyxkZgZXZp8w1da2+Je0es/KsPlo3E82hJ59q8x
         RtP7NLz4sC6oykKWNpkdtw6UxWCwrL3WjILlOgJLY7rvyafqnWlzNEJkGpVydk0B/m1Q
         eH+4CgOv1Ywrgli+kPRXK5f3E14n30qxnRhVzn7lQndi0oEiZitb+14ld54Lw5G7sMms
         8EcZp4azPvC+yuOlP565LczNse8wI74RO9ekoHmFycEAzIdBjHUNqLawt+AVPxm85t3B
         Q+tUuoTorcAOB7FjGnMYEl5febWkZqGmJf2g2F008fr3cU2juugIP/G0gD5FnQKRLGdp
         AfCA==
X-Gm-Message-State: AOAM531GaF5lfSUIEh1+0VHr+LuyhhIU9BYXg94JU68iXv4p7zN+1jOS
        cj1ZPvvnwNpkyfGNp+J/iWA=
X-Google-Smtp-Source: ABdhPJyWSdbHmaOpCSOzru7qFfHQEpmAqu6bwQL20/JJGMXNeeDNbdEH7mLUqXUg5qR0EMCZBHe5Hg==
X-Received: by 2002:a17:90b:4b01:: with SMTP id lx1mr5465469pjb.38.1639653465903;
        Thu, 16 Dec 2021 03:17:45 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:df9f:324c:2f16:6a6b])
        by smtp.gmail.com with ESMTPSA id k3sm5072589pgq.54.2021.12.16.03.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 03:17:45 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] sit: do not call ipip6_dev_free() from sit_init_net()
Date:   Thu, 16 Dec 2021 03:17:41 -0800
Message-Id: <20211216111741.1387540-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

ipip6_dev_free is sit dev->priv_destructor, already called
by register_netdevice() if something goes wrong.

Alternative would be to make ipip6_dev_free() robust against
multiple invocations, but other drivers do not implement this
strategy.

syzbot reported:

dst_release underflow
WARNING: CPU: 0 PID: 5059 at net/core/dst.c:173 dst_release+0xd8/0xe0 net/core/dst.c:173
Modules linked in:
CPU: 1 PID: 5059 Comm: syz-executor.4 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:dst_release+0xd8/0xe0 net/core/dst.c:173
Code: 4c 89 f2 89 d9 31 c0 5b 41 5e 5d e9 da d5 44 f9 e8 1d 90 5f f9 c6 05 87 48 c6 05 01 48 c7 c7 80 44 99 8b 31 c0 e8 e8 67 29 f9 <0f> 0b eb 85 0f 1f 40 00 53 48 89 fb e8 f7 8f 5f f9 48 83 c3 a8 48
RSP: 0018:ffffc9000aa5faa0 EFLAGS: 00010246
RAX: d6894a925dd15a00 RBX: 00000000ffffffff RCX: 0000000000040000
RDX: ffffc90005e19000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: 0000000000000000 R08: ffffffff816a1f42 R09: ffffed1017344f2c
R10: ffffed1017344f2c R11: 0000000000000000 R12: 0000607f462b1358
R13: 1ffffffff1bfd305 R14: ffffe8ffffcb1358 R15: dffffc0000000000
FS:  00007f66c71a2700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f88aaed5058 CR3: 0000000023e0f000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 dst_cache_destroy+0x107/0x1e0 net/core/dst_cache.c:160
 ipip6_dev_free net/ipv6/sit.c:1414 [inline]
 sit_init_net+0x229/0x550 net/ipv6/sit.c:1936
 ops_init+0x313/0x430 net/core/net_namespace.c:140
 setup_net+0x35b/0x9d0 net/core/net_namespace.c:326
 copy_net_ns+0x359/0x5c0 net/core/net_namespace.c:470
 create_new_namespaces+0x4ce/0xa00 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0x11e/0x180 kernel/nsproxy.c:226
 ksys_unshare+0x57d/0xb50 kernel/fork.c:3075
 __do_sys_unshare kernel/fork.c:3146 [inline]
 __se_sys_unshare kernel/fork.c:3144 [inline]
 __x64_sys_unshare+0x34/0x40 kernel/fork.c:3144
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f66c882ce99
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f66c71a2168 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00007f66c893ff60 RCX: 00007f66c882ce99
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000048040200
RBP: 00007f66c8886ff1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff6634832f R14: 00007f66c71a2300 R15: 0000000000022000
 </TASK>

Fixes: cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/sit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 1b57ee36d6682e04085aa271c6c5c09e6e3a7b7e..8a3618a30632a8fab997edff82065a194dcaac1b 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1933,7 +1933,6 @@ static int __net_init sit_init_net(struct net *net)
 	return 0;
 
 err_reg_dev:
-	ipip6_dev_free(sitn->fb_tunnel_dev);
 	free_netdev(sitn->fb_tunnel_dev);
 err_alloc_dev:
 	return err;
-- 
2.34.1.173.g76aa8bc2d0-goog

