Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6504150E88
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgBCRT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:19:56 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:40732 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbgBCRTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 12:19:55 -0500
Received: by mail-pf1-f201.google.com with SMTP id d127so9716013pfa.7
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 09:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jnL0ScITd8eCMfVda0jLyLM51O2oGM7qNgtPIiFYLaw=;
        b=v6IKuwBbOjYPc/cR3DFvGtZoUWG7D8hWuv8iXebhKJBHqrdO9oEtD5OzTUE/i+KauP
         E04O+8eDhQBdeGEHlWTAq6ABmMqZ3fMurSYER4ZGfHGieG2xxTYFNH8YWoxgqMulFX/O
         CRLFq33yy18wVdukjeQhmk3TwNW45uxWXnEQrfvZ3eRZKyWrxKF9w4kbNyZ/Mx+WTMNM
         DIF9emEx+Eecwcz+WrFL7IG6PjTFib4u+Toip/MohqdHLHQTAt/Ana6PRT8IHSfL+yOV
         e4h301ieYa4Kh8gpQoGZC747UZAdxkyEtBQCijwVETuBA9YjVrXMdg0G5BehBZ6gUTQ8
         Ok+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jnL0ScITd8eCMfVda0jLyLM51O2oGM7qNgtPIiFYLaw=;
        b=jxxfCsJJCzmMUkZaO1csWYjPatpReUsNAYKntzilmxNcepKF+SceguD9KvghGwY++H
         /CrkCJOKt6AkFc48zxYRwJKWzPIPkkzvnVOUu9ZZ1cdrK6naxwLn3OQJaGtnHR51wJik
         xvU0/x8jl3UeZwctdHOJMsizRmy517Qkm5Cp7gUIjwl698SEDjdAXvYkXiJPdKkaO5cJ
         9jGQUYwRJNk1D3ZjLR1HkTK8genP4+ZWIzEut+T5E6pkbxMA7i9QFLhovTqbvg7Rk9TV
         nNixh7E25hJToMfnJP3qRZtx/AYClOlFtNPDTb73Ec3CZ6wBelsYYB8L4pZs04l2KXR8
         UAnQ==
X-Gm-Message-State: APjAAAVPTYPoOn1RY6961TlcriAjdnmiAwZ381kJ+dYBrk51djDbMtLK
        2sd+ya+jxJGfQYbZfILJcTYHmekdvSwhsw==
X-Google-Smtp-Source: APXvYqztnap0MvD/Nu3UzT2FGx102H0njN+adPqY7rxP5rvw8nfZ1BSOFCfkn2TwL0KnULoO2pEk/Bqvxy+Usg==
X-Received: by 2002:a63:220b:: with SMTP id i11mr25720816pgi.50.1580750394752;
 Mon, 03 Feb 2020 09:19:54 -0800 (PST)
Date:   Mon,  3 Feb 2020 09:19:51 -0800
Message-Id: <20200203171951.222257-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] wireguard: fix use-after-free in root_remove_peer_lists
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the unlikely case a new node could not be allocated,
we need to remove @newnode from @peer->allowedips_list
before freeing it.

syzbot reported :

BUG: KASAN: use-after-free in __list_del_entry_valid+0xdc/0xf5 lib/list_debug.c:54
Read of size 8 at addr ffff88809881a538 by task syz-executor.4/30133

CPU: 0 PID: 30133 Comm: syz-executor.4 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
 __list_del_entry_valid+0xdc/0xf5 lib/list_debug.c:54
 __list_del_entry include/linux/list.h:132 [inline]
 list_del include/linux/list.h:146 [inline]
 root_remove_peer_lists+0x24f/0x4b0 drivers/net/wireguard/allowedips.c:65
 wg_allowedips_free+0x232/0x390 drivers/net/wireguard/allowedips.c:300
 wg_peer_remove_all+0xd5/0x620 drivers/net/wireguard/peer.c:187
 wg_set_device+0xd01/0x1350 drivers/net/wireguard/netlink.c:542
 genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
 genl_rcv_msg+0x67d/0xea0 net/netlink/genetlink.c:734
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 genl_rcv+0x29/0x40 net/netlink/genetlink.c:745
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45b399
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f99a9bcdc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f99a9bce6d4 RCX: 000000000045b399
RDX: 0000000000000000 RSI: 0000000020001340 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 00000000000009ba R14: 00000000004cb2b8 R15: 0000000000000009

Allocated by task 30103:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3551
 kmalloc include/linux/slab.h:556 [inline]
 kzalloc include/linux/slab.h:670 [inline]
 add+0x70a/0x1970 drivers/net/wireguard/allowedips.c:236
 wg_allowedips_insert_v4+0xf6/0x160 drivers/net/wireguard/allowedips.c:320
 set_allowedip drivers/net/wireguard/netlink.c:343 [inline]
 set_peer+0xfb9/0x1150 drivers/net/wireguard/netlink.c:468
 wg_set_device+0xbd4/0x1350 drivers/net/wireguard/netlink.c:591
 genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
 genl_rcv_msg+0x67d/0xea0 net/netlink/genetlink.c:734
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 genl_rcv+0x29/0x40 net/netlink/genetlink.c:745
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 30103:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 add+0x12d2/0x1970 drivers/net/wireguard/allowedips.c:266
 wg_allowedips_insert_v4+0xf6/0x160 drivers/net/wireguard/allowedips.c:320
 set_allowedip drivers/net/wireguard/netlink.c:343 [inline]
 set_peer+0xfb9/0x1150 drivers/net/wireguard/netlink.c:468
 wg_set_device+0xbd4/0x1350 drivers/net/wireguard/netlink.c:591
 genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
 genl_rcv_msg+0x67d/0xea0 net/netlink/genetlink.c:734
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 genl_rcv+0x29/0x40 net/netlink/genetlink.c:745
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88809881a500
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 56 bytes inside of
 64-byte region [ffff88809881a500, ffff88809881a540)
The buggy address belongs to the page:
page:ffffea0002620680 refcount:1 mapcount:0 mapping:ffff8880aa400380 index:0x0
raw: 00fffe0000000200 ffffea000250b748 ffffea000254bac8 ffff8880aa400380
raw: 0000000000000000 ffff88809881a000 0000000100000020 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809881a400: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88809881a480: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
>ffff88809881a500: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                                        ^
 ffff88809881a580: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88809881a600: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: wireguard@lists.zx2c4.com
---
 drivers/net/wireguard/allowedips.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
index 121d9ea0f13584f801ab895753e936c0a12f0028..3725e9cd85f4f2797afd59f42af454acc107aa9a 100644
--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -263,6 +263,7 @@ static int add(struct allowedips_node __rcu **trie, u8 bits, const u8 *key,
 	} else {
 		node = kzalloc(sizeof(*node), GFP_KERNEL);
 		if (unlikely(!node)) {
+			list_del(&newnode->peer_list);
 			kfree(newnode);
 			return -ENOMEM;
 		}
-- 
2.25.0.341.g760bfbb309-goog

