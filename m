Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D642F2BC7C
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 02:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfE1Af4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 20:35:56 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:55889 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfE1Af4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 20:35:56 -0400
Received: by mail-qk1-f201.google.com with SMTP id f25so25061021qkk.22
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 17:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FYKLnUATJ1Mq+XMb6/FwPTit+7k64lO2jRS0friwFHg=;
        b=pqeBbDlnFkkKwBJpirNqOl/VGKG/bDaWPnTz8UmbmtXwTSCR9q2LMVcLQM/OVTsi+j
         qVzYdGMBCcjky2hv/mV0pmrKafZJELPqVlj/AIKW9XT/jp1ltBqYlp/p6HXCStYmPH93
         L9GSu9sAFSPfjKALOAyTAwJKklDbo/dNppL2EX9vtKD/YmPmWUbWGg9iMx6/pYiRhaYq
         EOcUSuanTZibia24tikd0U0NoNuMl5qiPZb5EuSrvWHNYwZzBPHtTqu54EIiQkCDnAJE
         T2HfHUVOiJ0dJSivKdrqYIzT3+Fer3Dzt6OXpKHzQWMtls3Pj9DoJJ9PpU2ZQlaPfnC/
         PuEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FYKLnUATJ1Mq+XMb6/FwPTit+7k64lO2jRS0friwFHg=;
        b=IceiXcuySKHaP8ymW3a/R4O6Am8/IObsYVDd9sYMQTsLENqpzSO+wtbOFw+8Cok4w9
         +oTlqIS74Aiaffr1oWd+0YpTa4+km/clPuWtAOFG7dn0Bkr//tjvmH6HbQRTa184R9kB
         aJolK/EJTd/4uQAua8x3MgeDkrS1k2dqbGeFdPbC11MtuXZUdgb6MkA/pBuTAUP+aLE0
         b3JSpTMsyib6jRoXO72JWB1yhX42eVMb+8wcZLaMkU1QrKZe8O25BJwJbfNxANWNwCOo
         UNwSZsDOoEx/rNyUGqm30PrzNC6oMHn3MR1IvvbD76FyRf/jpVY8MKG3CMs0/3RQVXsI
         z7EQ==
X-Gm-Message-State: APjAAAUEyhMEvjRCiwmctzXsuMSb+ekRNRy4YSoWWN2qxS8qv/RugYxX
        C+WR2gv+F0Vnjc+bBZvlIXXfmFu+8cC7mw==
X-Google-Smtp-Source: APXvYqzdgqIsqyuLuDA3U/kEB6+bT55qDJS/M1or9iBaOmCzdhefEIjuCA5O5k7cWt3kbZ2GyYKIuVf5yUOR/w==
X-Received: by 2002:ac8:2d87:: with SMTP id p7mr298570qta.353.1559003755456;
 Mon, 27 May 2019 17:35:55 -0700 (PDT)
Date:   Mon, 27 May 2019 17:35:52 -0700
Message-Id: <20190528003552.88258-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net] llc: fix skb leak in llc_build_and_send_ui_pkt()
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

If llc_mac_hdr_init() returns an error, we must drop the skb
since no llc_build_and_send_ui_pkt() caller will take care of this.

BUG: memory leak
unreferenced object 0xffff8881202b6800 (size 2048):
  comm "syz-executor907", pid 7074, jiffies 4294943781 (age 8.590s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    1a 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace:
    [<00000000e25b5abe>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
    [<00000000e25b5abe>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<00000000e25b5abe>] slab_alloc mm/slab.c:3326 [inline]
    [<00000000e25b5abe>] __do_kmalloc mm/slab.c:3658 [inline]
    [<00000000e25b5abe>] __kmalloc+0x161/0x2c0 mm/slab.c:3669
    [<00000000a1ae188a>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000a1ae188a>] sk_prot_alloc+0xd6/0x170 net/core/sock.c:1608
    [<00000000ded25bbe>] sk_alloc+0x35/0x2f0 net/core/sock.c:1662
    [<000000002ecae075>] llc_sk_alloc+0x35/0x170 net/llc/llc_conn.c:950
    [<00000000551f7c47>] llc_ui_create+0x7b/0x140 net/llc/af_llc.c:173
    [<0000000029027f0e>] __sock_create+0x164/0x250 net/socket.c:1430
    [<000000008bdec225>] sock_create net/socket.c:1481 [inline]
    [<000000008bdec225>] __sys_socket+0x69/0x110 net/socket.c:1523
    [<00000000b6439228>] __do_sys_socket net/socket.c:1532 [inline]
    [<00000000b6439228>] __se_sys_socket net/socket.c:1530 [inline]
    [<00000000b6439228>] __x64_sys_socket+0x1e/0x30 net/socket.c:1530
    [<00000000cec820c1>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
    [<000000000c32554f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811d750d00 (size 224):
  comm "syz-executor907", pid 7074, jiffies 4294943781 (age 8.600s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 f0 0c 24 81 88 ff ff 00 68 2b 20 81 88 ff ff  ...$.....h+ ....
  backtrace:
    [<0000000053026172>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
    [<0000000053026172>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<0000000053026172>] slab_alloc_node mm/slab.c:3269 [inline]
    [<0000000053026172>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
    [<00000000fa8f3c30>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
    [<00000000d96fdafb>] alloc_skb include/linux/skbuff.h:1058 [inline]
    [<00000000d96fdafb>] alloc_skb_with_frags+0x5f/0x250 net/core/skbuff.c:5327
    [<000000000a34a2e7>] sock_alloc_send_pskb+0x269/0x2a0 net/core/sock.c:2225
    [<00000000ee39999b>] sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2242
    [<00000000e034d810>] llc_ui_sendmsg+0x10a/0x540 net/llc/af_llc.c:933
    [<00000000c0bc8445>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000c0bc8445>] sock_sendmsg+0x54/0x70 net/socket.c:671
    [<000000003b687167>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
    [<00000000922d78d9>] __do_sys_sendto net/socket.c:1976 [inline]
    [<00000000922d78d9>] __se_sys_sendto net/socket.c:1972 [inline]
    [<00000000922d78d9>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
    [<00000000cec820c1>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
    [<000000000c32554f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/llc/llc_output.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/llc/llc_output.c b/net/llc/llc_output.c
index 94425e421213a3fd2719428244156a890a98127a..9e4b6bcf6920d216530c9ac89cdb197a32bed473 100644
--- a/net/llc/llc_output.c
+++ b/net/llc/llc_output.c
@@ -72,6 +72,8 @@ int llc_build_and_send_ui_pkt(struct llc_sap *sap, struct sk_buff *skb,
 	rc = llc_mac_hdr_init(skb, skb->dev->dev_addr, dmac);
 	if (likely(!rc))
 		rc = dev_queue_xmit(skb);
+	else
+		kfree_skb(skb);
 	return rc;
 }
 
-- 
2.22.0.rc1.257.g3120a18244-goog

