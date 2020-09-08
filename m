Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836D426101D
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 12:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgIHKlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 06:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729894AbgIHKkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 06:40:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC4DC061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 03:40:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q2so15247799ybo.5
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 03:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=frGKIbboHu8sgbGul14CAWpKd6G4h1v4qTv0V3jnjMY=;
        b=p45kcqZeFvIX2JXbQFvt3EQXtg0P3EL0EDY7KpNCHKbZp2SiA+CcrmvEl1pPVtSY7v
         J26mhGu+vX8rRaJXqnC6+M3MrFivv3vTg4vq46+5PbjKSEd9s6Bxbz7mI24n57qJqA8G
         MByi29e2OePw/5n+tGx+Uo/KTjNlSiIB43PxzlW74UmkSW3HAFK6JbTvPJiVlJhy1VmB
         bmZtx4sh0t0/xhB6srf1aJsh05nec+7i38EAVvS4M+VLwX2PmG1U7HsV3UuSufyTnEIR
         G8gXovAVWQtuApYrbIq8sI4yO8l8jzuTNm0mAr6n0iLN6f8B0+40EzJER15vSulbTb4Y
         gfnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=frGKIbboHu8sgbGul14CAWpKd6G4h1v4qTv0V3jnjMY=;
        b=SkTxkLNZxokiwtjyv8ZPtYa7xuYE2uhFIpJjWuUlA6pT9ALpF/kwXfMKC9UneLMHsg
         gy6O+sudMQtaS708O6mKZUYPdj1zCBVe/H7e82nM+2r5nwslgpa55/gCAWiqUUdbrdS9
         putTuwU+z4vbyzVJIB9qYvK9ciinN9TRXng2l+CWrYdGna1QIChhx0GfkeIoPDnrki82
         dON3mRTHAdMQynLOyzJMqgeCdJZezXY3iA6cgsy7nbbMgxW+AqB3dTzgPfkjlZTwAH+W
         /WGl/ySpXbiClvk7K9Dhu8aBrY8aIM9jKe1r4IXaIQZ7SyFqT7mkSX6ZrBKovpgBYO51
         z0Ng==
X-Gm-Message-State: AOAM532mkTOPi8Xwus6WT4x5ZbgxPDhggXJgIz0amFuN36gBznZV26s6
        Md7jXbXwVGf7nzETnCJwT+KH66rHDEP7xw==
X-Google-Smtp-Source: ABdhPJxiSrCFbUou8GYm7+shCPRQUdrd1SRRPbgEE7bHKJXmjMePg6nPBLrYH/G8nh7dP6yPpidvY5UboNzmPQ==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a25:8448:: with SMTP id
 r8mr32184828ybm.119.1599561628035; Tue, 08 Sep 2020 03:40:28 -0700 (PDT)
Date:   Tue,  8 Sep 2020 03:40:25 -0700
Message-Id: <20200908104025.4009085-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net] mac802154: tx: fix use-after-free
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a bug in ieee802154_tx() [1]

A similar issue in ieee802154_xmit_worker() is also fixed in this patch.

[1]
BUG: KASAN: use-after-free in ieee802154_tx+0x3d2/0x480 net/mac802154/tx.c:88
Read of size 4 at addr ffff8880251a8c70 by task syz-executor.3/928

CPU: 0 PID: 928 Comm: syz-executor.3 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 ieee802154_tx+0x3d2/0x480 net/mac802154/tx.c:88
 ieee802154_subif_start_xmit+0xbe/0xe4 net/mac802154/tx.c:130
 __netdev_start_xmit include/linux/netdevice.h:4634 [inline]
 netdev_start_xmit include/linux/netdevice.h:4648 [inline]
 dev_direct_xmit+0x4e9/0x6e0 net/core/dev.c:4203
 packet_snd net/packet/af_packet.c:2989 [inline]
 packet_sendmsg+0x2413/0x5290 net/packet/af_packet.c:3014
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5b9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc98e749c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002ccc0 RCX: 000000000045d5b9
RDX: 0000000000000000 RSI: 0000000020007780 RDI: 000000000000000b
RBP: 000000000118d020 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cfec
R13: 00007fff690c720f R14: 00007fc98e74a9c0 R15: 000000000118cfec

Allocated by task 928:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:518 [inline]
 slab_alloc_node mm/slab.c:3254 [inline]
 kmem_cache_alloc_node+0x136/0x3e0 mm/slab.c:3574
 __alloc_skb+0x71/0x550 net/core/skbuff.c:198
 alloc_skb include/linux/skbuff.h:1094 [inline]
 alloc_skb_with_frags+0x92/0x570 net/core/skbuff.c:5771
 sock_alloc_send_pskb+0x72a/0x880 net/core/sock.c:2348
 packet_alloc_skb net/packet/af_packet.c:2837 [inline]
 packet_snd net/packet/af_packet.c:2932 [inline]
 packet_sendmsg+0x19fb/0x5290 net/packet/af_packet.c:3014
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 928:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kmem_cache_free.part.0+0x74/0x1e0 mm/slab.c:3693
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:622
 __kfree_skb net/core/skbuff.c:679 [inline]
 consume_skb net/core/skbuff.c:838 [inline]
 consume_skb+0xcf/0x160 net/core/skbuff.c:832
 __dev_kfree_skb_any+0x9c/0xc0 net/core/dev.c:3107
 fakelb_hw_xmit+0x20e/0x2a0 drivers/net/ieee802154/fakelb.c:81
 drv_xmit_async net/mac802154/driver-ops.h:16 [inline]
 ieee802154_tx+0x282/0x480 net/mac802154/tx.c:81
 ieee802154_subif_start_xmit+0xbe/0xe4 net/mac802154/tx.c:130
 __netdev_start_xmit include/linux/netdevice.h:4634 [inline]
 netdev_start_xmit include/linux/netdevice.h:4648 [inline]
 dev_direct_xmit+0x4e9/0x6e0 net/core/dev.c:4203
 packet_snd net/packet/af_packet.c:2989 [inline]
 packet_sendmsg+0x2413/0x5290 net/packet/af_packet.c:3014
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880251a8c00
 which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 112 bytes inside of
 224-byte region [ffff8880251a8c00, ffff8880251a8ce0)
The buggy address belongs to the page:
page:0000000062b6a4f1 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x251a8
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0000435c88 ffffea00028b6c08 ffff8880a9055d00
raw: 0000000000000000 ffff8880251a80c0 000000010000000c 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880251a8b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880251a8b80: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880251a8c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff8880251a8c80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff8880251a8d00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb

Fixes: 409c3b0c5f03 ("mac802154: tx: move stats tx increment")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Alexander Aring <alex.aring@gmail.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: linux-wpan@vger.kernel.org
---
 net/mac802154/tx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index ab52811523e992f33f0855cdb711a2752b602e15..c829e4a7532564d401c0d2d1f90f56c2fe030b2c 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -34,11 +34,11 @@ void ieee802154_xmit_worker(struct work_struct *work)
 	if (res)
 		goto err_tx;
 
-	ieee802154_xmit_complete(&local->hw, skb, false);
-
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len;
 
+	ieee802154_xmit_complete(&local->hw, skb, false);
+
 	return;
 
 err_tx:
@@ -78,6 +78,8 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 
 	/* async is priority, otherwise sync is fallback */
 	if (local->ops->xmit_async) {
+		unsigned int len = skb->len;
+
 		ret = drv_xmit_async(local, skb);
 		if (ret) {
 			ieee802154_wake_queue(&local->hw);
@@ -85,7 +87,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 		}
 
 		dev->stats.tx_packets++;
-		dev->stats.tx_bytes += skb->len;
+		dev->stats.tx_bytes += len;
 	} else {
 		local->tx_skb = skb;
 		queue_work(local->workqueue, &local->tx_work);
-- 
2.28.0.526.ge36021eeef-goog

