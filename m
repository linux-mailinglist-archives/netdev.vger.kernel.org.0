Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4F30131970
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 21:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgAFUaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 15:30:55 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:55800 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbgAFUaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 15:30:52 -0500
Received: by mail-pj1-f74.google.com with SMTP id bg6so11445886pjb.5
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 12:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=whzyxQYQXvjMcCTJs6EQaIKKwq84iWaQqrRefY9gQh4=;
        b=DDmakhYVx2GmGKJNFQN+Gl03iroatxQtI9nfb7qFlBTfzitS4sITWglXAHXNxvXNlv
         MCgsmVQrbhlvJ/xKANERgDn3nikEuIsZIzWTIW8JstIzZSkG+/MH7kFk7F3eV80334NR
         uWSb0rV09ZlLZlfoXVsBh/E16FpWFkGvQOuckXeMfiKL5RbA5Az8QAPyacpTaXAL3ZKz
         GvuSLqrEE3Whs6+7yjdSgNqzK4dzemPfWOlMBoKLQCGW2vx9fVZ3W4T1qMRa8DHMIhnZ
         7Xk52CumEPJplJu5qPtRFidrWiUa2RUQndhCwH/jPepuIz2eJWHkbd5vU8STE2K80h15
         4Vcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=whzyxQYQXvjMcCTJs6EQaIKKwq84iWaQqrRefY9gQh4=;
        b=rGaEqK2KDUbTyUID0TjebHo8THjuvtTo8TioZDx+KLdqihbI5MLJd/9xuLX7ukeg+r
         Kb7rVLD2BPVSPaooKqFa7rRhKg8A05zNZ5PMhFPUDwNPh9Q4hRZqbyob/ySdaxkdJA6n
         UjvKfJKCDQHzEsbRvqWr0+ZYxHV8guowWUkFUiV7k/t6+TJ9Ug0PSv8HmU5PlDCuM7dG
         BdmawIIwIE8dYIcD7mH/rxQ6HFhMB4GU7vX8IbkTrUcjh2snZ0yNdoilw4zlGzVr5d8H
         1vboUOxUJDPtxSaLjypI3Ul1O1/ZhjL/Avk9RSy2DZGppQieoMoPImZe41nJx//am2LT
         mPKA==
X-Gm-Message-State: APjAAAXfm6IWXABj+pIUbPdE3UbgHQ2sxxDanQwnk/r9P0CtPnHat0T9
        C3GE+295NhWK2SOK6x82O8BHo8fpGGDuqg==
X-Google-Smtp-Source: APXvYqx5Wl98rNoulwrw1W9co46ZiktdSooxK5kRig/kxJB4gtPxUfv4pCU8EllHSxH/dkxyAv5NjnUMlUa8Dg==
X-Received: by 2002:a63:a53:: with SMTP id z19mr74427165pgk.267.1578342651719;
 Mon, 06 Jan 2020 12:30:51 -0800 (PST)
Date:   Mon,  6 Jan 2020 12:30:48 -0800
Message-Id: <20200106203048.204196-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net] macvlan: do not assume mac_header is set in macvlan_broadcast()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use of eth_hdr() in tx path is error prone.

Many drivers call skb_reset_mac_header() before using it,
but others do not.

Commit 6d1ccff62780 ("net: reset mac header in dev_start_xmit()")
attempted to fix this generically, but commit d346a3fae3ff
("packet: introduce PACKET_QDISC_BYPASS socket option") brought
back the macvlan bug.

Lets add a new helper, so that tx paths no longer have
to call skb_reset_mac_header() only to get a pointer
to skb->data.

Hopefully we will be able to revert 6d1ccff62780
("net: reset mac header in dev_start_xmit()") and save few cycles
in transmit fast path.

BUG: KASAN: use-after-free in __get_unaligned_cpu32 include/linux/unaligned/packed_struct.h:19 [inline]
BUG: KASAN: use-after-free in mc_hash drivers/net/macvlan.c:251 [inline]
BUG: KASAN: use-after-free in macvlan_broadcast+0x547/0x620 drivers/net/macvlan.c:277
Read of size 4 at addr ffff8880a4932401 by task syz-executor947/9579

CPU: 0 PID: 9579 Comm: syz-executor947 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 __asan_report_load_n_noabort+0xf/0x20 mm/kasan/generic_report.c:145
 __get_unaligned_cpu32 include/linux/unaligned/packed_struct.h:19 [inline]
 mc_hash drivers/net/macvlan.c:251 [inline]
 macvlan_broadcast+0x547/0x620 drivers/net/macvlan.c:277
 macvlan_queue_xmit drivers/net/macvlan.c:520 [inline]
 macvlan_start_xmit+0x402/0x77f drivers/net/macvlan.c:559
 __netdev_start_xmit include/linux/netdevice.h:4447 [inline]
 netdev_start_xmit include/linux/netdevice.h:4461 [inline]
 dev_direct_xmit+0x419/0x630 net/core/dev.c:4079
 packet_direct_xmit+0x1a9/0x250 net/packet/af_packet.c:240
 packet_snd net/packet/af_packet.c:2966 [inline]
 packet_sendmsg+0x260d/0x6220 net/packet/af_packet.c:2991
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 __sys_sendto+0x262/0x380 net/socket.c:1985
 __do_sys_sendto net/socket.c:1997 [inline]
 __se_sys_sendto net/socket.c:1993 [inline]
 __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1993
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x442639
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc13549e08 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000442639
RDX: 000000000000000e RSI: 0000000020000080 RDI: 0000000000000003
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000403bb0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9389:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x163/0x770 mm/slab.c:3665
 kmalloc include/linux/slab.h:561 [inline]
 tomoyo_realpath_from_path+0xc5/0x660 security/tomoyo/realpath.c:252
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x230/0x430 security/tomoyo/file.c:822
 tomoyo_inode_getattr+0x1d/0x30 security/tomoyo/tomoyo.c:129
 security_inode_getattr+0xf2/0x150 security/security.c:1222
 vfs_getattr+0x25/0x70 fs/stat.c:115
 vfs_statx_fd+0x71/0xc0 fs/stat.c:145
 vfs_fstat include/linux/fs.h:3265 [inline]
 __do_sys_newfstat+0x9b/0x120 fs/stat.c:378
 __se_sys_newfstat fs/stat.c:375 [inline]
 __x64_sys_newfstat+0x54/0x80 fs/stat.c:375
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9389:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 tomoyo_realpath_from_path+0x1a7/0x660 security/tomoyo/realpath.c:289
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x230/0x430 security/tomoyo/file.c:822
 tomoyo_inode_getattr+0x1d/0x30 security/tomoyo/tomoyo.c:129
 security_inode_getattr+0xf2/0x150 security/security.c:1222
 vfs_getattr+0x25/0x70 fs/stat.c:115
 vfs_statx_fd+0x71/0xc0 fs/stat.c:145
 vfs_fstat include/linux/fs.h:3265 [inline]
 __do_sys_newfstat+0x9b/0x120 fs/stat.c:378
 __se_sys_newfstat fs/stat.c:375 [inline]
 __x64_sys_newfstat+0x54/0x80 fs/stat.c:375
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a4932000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1025 bytes inside of
 4096-byte region [ffff8880a4932000, ffff8880a4933000)
The buggy address belongs to the page:
page:ffffea0002924c80 refcount:1 mapcount:0 mapping:ffff8880aa402000 index:0x0 compound_mapcount: 0
raw: 00fffe0000010200 ffffea0002846208 ffffea00028f3888 ffff8880aa402000
raw: 0000000000000000 ffff8880a4932000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a4932300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a4932380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880a4932400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff8880a4932480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a4932500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: b863ceb7ddce ("[NET]: Add macvlan driver")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/macvlan.c    | 2 +-
 include/linux/if_ether.h | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 05631d97eeb4fbfe3ca599dfdccb1c355b1feb45..747c0542a53c763676d491c91a5b704f0eb9848e 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -259,7 +259,7 @@ static void macvlan_broadcast(struct sk_buff *skb,
 			      struct net_device *src,
 			      enum macvlan_mode mode)
 {
-	const struct ethhdr *eth = eth_hdr(skb);
+	const struct ethhdr *eth = skb_eth_hdr(skb);
 	const struct macvlan_dev *vlan;
 	struct sk_buff *nskb;
 	unsigned int i;
diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index 76cf11e905e160b32625adefd1bcc7b641ff6527..8a9792a6427ad9cf58b50c79cbfe185615800dcb 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -24,6 +24,14 @@ static inline struct ethhdr *eth_hdr(const struct sk_buff *skb)
 	return (struct ethhdr *)skb_mac_header(skb);
 }
 
+/* Prefer this version in TX path, instead of
+ * skb_reset_mac_header() + eth_hdr()
+ */
+static inline struct ethhdr *skb_eth_hdr(const struct sk_buff *skb)
+{
+	return (struct ethhdr *)skb->data;
+}
+
 static inline struct ethhdr *inner_eth_hdr(const struct sk_buff *skb)
 {
 	return (struct ethhdr *)skb_inner_mac_header(skb);
-- 
2.24.1.735.g03f4e72817-goog

