Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B426ADB4A
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 11:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjCGKCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 05:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjCGKCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 05:02:36 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF47A50704
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 02:02:33 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id o3-20020a257303000000b00a131264017aso13736847ybc.20
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 02:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678183353;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nnVRP9WDxvjsFn5DxVjCDQmzCB1fXfqikwotGjj6IWU=;
        b=p7KQ4dtHe+uGuJ1Wx6LqT8P0xhFLObGN7FH4u6iu/rcGCz8pztq6xl7fjkak2UnwgZ
         tCIdWUtQBQfqsiqugoFpjjvXCeoTPN76m5e/Mey7+/i6lT/A3VsGgv2s6d0hF03tywRS
         wHXRJL8OZaVCgxDBPmNpZrOeihs/EVv+hgAMszLjzJRp6tVwRAIYpwlemu2fT5XWLkmP
         dasUNRHmqHXq6L5e1VGKInsslcFnNbnRlP/FJUFcMXGroE/xpywLacNLvUpIyUvVJjnT
         pXlacyHjqP7Agi85f2LevQxd2nDZPZvOo5i2v1hFfGJtz0gkH7QuDHGeML7ip6nQqTtX
         rVZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678183353;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nnVRP9WDxvjsFn5DxVjCDQmzCB1fXfqikwotGjj6IWU=;
        b=Sw6I77LY7owTQHt74UDtlf6FeWqY8b8f2Uo0Pip7MUSmVY5gFk4JAV1Q1GMQ5RRUiL
         sfZtvXFkSRZ381/tLL3L2LMSP9dRn8tP6L8ySzQuHcj+BAyZv0qzdoF+UFtwIn0NgBqa
         5JGAOq7LLcipnAklWGgaMvD++Jt5N3p2XKz0yaj1yxP3edqxwcl8e8JMbgj3xqqvr1BS
         DwfsxNBR9FZpfLxPj7zHpZiegTdm4sCbQdhV4BbxTevb17qBrSenWfzTlbrlPyPiSw7s
         OfGQGoy8PmHruxbQPjtKfLuiTDomXPGX3RaHZd70LDRSzW6iZINvOqSTgv6iItUkhVAh
         95Iw==
X-Gm-Message-State: AO0yUKXf//ZiXEAfFdmN1b33q9doqb0YQM+xLL2ffgM9wTRRhrwWzQOr
        QHNrrlzOhkLu3+D6VInCFrNPrZa+KcBCog==
X-Google-Smtp-Source: AK7set8jpHIJHhOC7NpBWMsXQeGNBpXddEYEUsQGkL4nbVNIs91Yii7La7yn39sZAuT9E307fENAOH3ZBvJjyg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:e90b:0:b0:9fc:e3d7:d60f with SMTP id
 n11-20020a25e90b000000b009fce3d7d60fmr6128868ybd.5.1678183353101; Tue, 07 Mar
 2023 02:02:33 -0800 (PST)
Date:   Tue,  7 Mar 2023 10:02:31 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307100231.227738-1-edumazet@google.com>
Subject: [PATCH net] af_key: fix kernel-infoleak vs XFRMA_ALG_COMP
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When copy_to_user_state_extra() copies to netlink skb
x->calg content, it expects calg was fully initialized.

We must make sure all unused bytes are cleared at
allocation side.

syzbot reported:

BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline]
BUG: KMSAN: kernel-infoleak in copyout lib/iov_iter.c:169 [inline]
BUG: KMSAN: kernel-infoleak in _copy_to_iter+0x870/0x1fd0 lib/iov_iter.c:529
instrument_copy_to_user include/linux/instrumented.h:121 [inline]
copyout lib/iov_iter.c:169 [inline]
_copy_to_iter+0x870/0x1fd0 lib/iov_iter.c:529
copy_to_iter include/linux/uio.h:179 [inline]
simple_copy_to_iter+0x68/0xa0 net/core/datagram.c:513
__skb_datagram_iter+0x123/0xdc0 net/core/datagram.c:419
skb_copy_datagram_iter+0x5c/0x200 net/core/datagram.c:527
skb_copy_datagram_msg include/linux/skbuff.h:3908 [inline]
netlink_recvmsg+0x4f4/0x15f0 net/netlink/af_netlink.c:1998
sock_recvmsg_nosec net/socket.c:998 [inline]
sock_recvmsg net/socket.c:1016 [inline]
sock_read_iter+0x4bc/0x560 net/socket.c:1089
call_read_iter include/linux/fs.h:2183 [inline]
new_sync_read fs/read_write.c:389 [inline]
vfs_read+0x8cd/0xf40 fs/read_write.c:470
ksys_read+0x21f/0x4f0 fs/read_write.c:613
__do_sys_read fs/read_write.c:623 [inline]
__se_sys_read fs/read_write.c:621 [inline]
__x64_sys_read+0x93/0xd0 fs/read_write.c:621
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was stored to memory at:
__nla_put lib/nlattr.c:1009 [inline]
nla_put+0x1c6/0x230 lib/nlattr.c:1067
copy_to_user_state_extra+0x1175/0x1ac0 net/xfrm/xfrm_user.c:1101
dump_one_state+0x2cc/0x7c0 net/xfrm/xfrm_user.c:1169
xfrm_state_walk+0x721/0x1300 net/xfrm/xfrm_state.c:2308
xfrm_dump_sa+0x1ea/0x6b0 net/xfrm/xfrm_user.c:1240
netlink_dump+0xb1a/0x1560 net/netlink/af_netlink.c:2296
__netlink_dump_start+0xa75/0xc40 net/netlink/af_netlink.c:2401
netlink_dump_start include/linux/netlink.h:294 [inline]
xfrm_user_rcv_msg+0x82c/0xf80 net/xfrm/xfrm_user.c:3091
netlink_rcv_skb+0x3f8/0x750 net/netlink/af_netlink.c:2574
xfrm_netlink_rcv+0x76/0xb0 net/xfrm/xfrm_user.c:3128
netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
netlink_unicast+0xf41/0x1270 net/netlink/af_netlink.c:1365
netlink_sendmsg+0x127d/0x1430 net/netlink/af_netlink.c:1942
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg net/socket.c:734 [inline]
____sys_sendmsg+0xa8f/0xe70 net/socket.c:2479
___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2533
__sys_sendmsg net/socket.c:2562 [inline]
__do_sys_sendmsg net/socket.c:2571 [inline]
__se_sys_sendmsg net/socket.c:2569 [inline]
__x64_sys_sendmsg+0x36b/0x540 net/socket.c:2569
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
slab_post_alloc_hook+0x12d/0xb60 mm/slab.h:766
slab_alloc_node mm/slub.c:3452 [inline]
__kmem_cache_alloc_node+0x518/0x920 mm/slub.c:3491
kmalloc_trace+0x51/0x200 mm/slab_common.c:1062
kmalloc include/linux/slab.h:580 [inline]
pfkey_msg2xfrm_state net/key/af_key.c:1199 [inline]
pfkey_add+0x31ce/0x3bf0 net/key/af_key.c:1504
pfkey_process net/key/af_key.c:2844 [inline]
pfkey_sendmsg+0x16b8/0x1bb0 net/key/af_key.c:3695
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg net/socket.c:734 [inline]
____sys_sendmsg+0xa8f/0xe70 net/socket.c:2479
___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2533
__sys_sendmmsg+0x411/0xa50 net/socket.c:2619
__do_sys_sendmmsg net/socket.c:2648 [inline]
__se_sys_sendmmsg net/socket.c:2645 [inline]
__x64_sys_sendmmsg+0xbc/0x120 net/socket.c:2645
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Bytes 252-311 of 2224 are uninitialized
Memory access of size 2224 starts at ffff888123c76000
Data copied to user address 0000000020000300

CPU: 1 PID: 4311 Comm: syz-executor.2 Tainted: G W 6.2.0-syzkaller-81157-g944070199c5e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/key/af_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index a815f5ab4c49a08a51f7ae5e1200e589621799e8..f77e4ab13a3abc0b98f244752c5df5358aef4060 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1196,7 +1196,7 @@ static struct xfrm_state * pfkey_msg2xfrm_state(struct net *net,
 				err = -ENOSYS;
 				goto out;
 			}
-			x->calg = kmalloc(sizeof(*x->calg), GFP_KERNEL);
+			x->calg = kzalloc(sizeof(*x->calg), GFP_KERNEL);
 			if (!x->calg) {
 				err = -ENOMEM;
 				goto out;
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

