Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5237E19B4C1
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 19:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732137AbgDARhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 13:37:21 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:38739 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgDARhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 13:37:21 -0400
Received: by mail-yb1-f201.google.com with SMTP id k140so865869ybf.5
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 10:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wlLZAzbkwugt5T2XXG9KI0MUCOZsK4HjBggRINLaAFg=;
        b=qL8OGtq7s0YPnsLfUazAiodcTdqHzeX/KvCTDrYnohdEC9LuUmkkMgnMUZHQvbg2Pq
         5Xare6C6Kr6tIXsLGQXvIOfsCqujWShmmy7Pn1ybuLSJuouRK55TC7xjUYumuCkyY/4v
         5IuDIbv7C9gMybflo2AAQtWK1+DaY3C9aqaOjAqJi7XhuWIOTCDZLH5kk4fTtjb0Rcup
         N6nC6kkQUX80FenvoCEreLU6z6hcMPW7pGrFdIl94G9gNzgakZApcr/2+osSE2qo+Wbm
         OUpTmat9cJbcvwZXjCKOstj55oFZjpe1HYfyMa6UGeOeiWgjUYFIL206orZ+JmEKJXe3
         PGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wlLZAzbkwugt5T2XXG9KI0MUCOZsK4HjBggRINLaAFg=;
        b=j7kVaEGAye8eO6iGbIOISoIOqzZTc5WjDGc1LkVsQWW6sZzg4q2L3huIarFo17+Gtt
         RXQfHiPZx2qJyu7Yeywq/wsp84FOAZ1gMwSmT3bJek+VvbshOcDQu4kCbj4XcfpXtY4O
         2VsweJlAOW4bh8D2rinoRZxDgN0YUnPJQ3oqqOfKOKBMP2DBx05JWHrhrp+hMD3ifaZT
         tQJdjT8gaKC7vbR3RT5mk16dUex0FZF9QyPdqaw/le/8Veu+4pHN7L1m8tG10OLh4q7X
         jO1ftFuC7O6Y9505mSAlPC/HgZuY4CIu0vQIJNJV/NFvidyoQU3FKbWQ0aP4jrPNYFbp
         G9pA==
X-Gm-Message-State: ANhLgQ2e3Nnk0lzZHSg7MqqjjFTHTplDLmid1qs7aZb6Ih9ms3FkxCUF
        TDobdEry1820W+CKW/Uqp6eW39iyeO/cYw==
X-Google-Smtp-Source: ADFU+vsvuC8NCrYOIlTILnQwzU77iZySl8MrST9E0DI3W7PNDk2CAO2tvgYaH+/SewLAxOmezgEAXVwwc/3hbQ==
X-Received: by 2002:a25:a2c6:: with SMTP id c6mr41000713ybn.270.1585762639724;
 Wed, 01 Apr 2020 10:37:19 -0700 (PDT)
Date:   Wed,  1 Apr 2020 10:37:16 -0700
Message-Id: <20200401173716.222205-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
Subject: [PATCH nf 1/1] netfilter: nf_tables: do not leave dangling pointer in nf_tables_set_alloc_name
From:   Eric Dumazet <edumazet@google.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If nf_tables_set_alloc_name() frees set->name, we better
clear set->name to avoid a future use-after-free or invalid-free.

BUG: KASAN: double-free or invalid-free in nf_tables_newset+0x1ed6/0x2560 net/netfilter/nf_tables_api.c:4148

CPU: 0 PID: 28233 Comm: syz-executor.0 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
 kasan_report_invalid_free+0x61/0xa0 mm/kasan/report.c:468
 __kasan_slab_free+0x129/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 nf_tables_newset+0x1ed6/0x2560 net/netfilter/nf_tables_api.c:4148
 nfnetlink_rcv_batch+0x83a/0x1610 net/netfilter/nfnetlink.c:433
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2345
 ___sys_sendmsg+0x100/0x170 net/socket.c:2399
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2432
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c849
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe5ca21dc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fe5ca21e6d4 RCX: 000000000045c849
RDX: 0000000000000000 RSI: 0000000020000c40 RDI: 0000000000000003
RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000000000000095b R14: 00000000004cc0e9 R15: 000000000076bf0c

Allocated by task 28233:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc_track_caller+0x159/0x790 mm/slab.c:3671
 kvasprintf+0xb5/0x150 lib/kasprintf.c:25
 kasprintf+0xbb/0xf0 lib/kasprintf.c:59
 nf_tables_set_alloc_name net/netfilter/nf_tables_api.c:3536 [inline]
 nf_tables_newset+0x1543/0x2560 net/netfilter/nf_tables_api.c:4088
 nfnetlink_rcv_batch+0x83a/0x1610 net/netfilter/nfnetlink.c:433
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2345
 ___sys_sendmsg+0x100/0x170 net/socket.c:2399
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2432
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 28233:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:476
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 nf_tables_set_alloc_name net/netfilter/nf_tables_api.c:3544 [inline]
 nf_tables_newset+0x1f73/0x2560 net/netfilter/nf_tables_api.c:4088
 nfnetlink_rcv_batch+0x83a/0x1610 net/netfilter/nfnetlink.c:433
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2345
 ___sys_sendmsg+0x100/0x170 net/socket.c:2399
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2432
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a6032d00
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff8880a6032d00, ffff8880a6032d20)
The buggy address belongs to the page:
page:ffffea0002980c80 refcount:1 mapcount:0 mapping:ffff8880aa0001c0 index:0xffff8880a6032fc1
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002a3be88 ffffea00029b1908 ffff8880aa0001c0
raw: ffff8880a6032fc1 ffff8880a6032000 000000010000003e 0000000000000000
page dumped because: kasan: bad access detected

Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d0ab5ffa1e2c9e915af4fd77bcd6b4f9ed875a09..f91e96d8de05f99c45b059d1fa6431daf6405cc6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3542,6 +3542,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 			continue;
 		if (!strcmp(set->name, i->name)) {
 			kfree(set->name);
+			set->name = NULL;
 			return -ENFILE;
 		}
 	}
-- 
2.26.0.rc2.310.g2932bb562d-goog

