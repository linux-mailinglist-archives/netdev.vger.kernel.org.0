Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238EC20E9DF
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgF3AEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgF3AEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:04:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7191AC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:04:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s9so20654077ybj.18
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BB2mhcr/jTof3+JMm+oB+qeCoQQRqFHD9Ts6iqFdoOw=;
        b=VHYK4L54bQ7udGOiArz2mXGU92Asd37TAqxduFWlGx2naClkiU1e12oZ8DK1mJ87h+
         7h6Mi/4j5/zPpmc/BWGgPW0NHNVWL3EfBMenbQQUcMm0ddzovNe1dSqM3Zdzsq00ygUO
         dAk/kIx1wkB3xrIFvqHzKxoEat+EcMudKIBoCfjXGc4lE/qvcYCCI+4YJye7URfa/Wng
         7gLufJV81ND+0+BSH7Ia1x/BPcJTUEmu4OLvHkGc7PzyGO750OPfLHa1EPJz3DyStwkR
         wPi6GRhGK5wMUTAWfIapkeYzhWZRjmcwxtFi5ZNeHqIbcTvzs18pKyHtAd6i+Kfr6YRh
         IZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BB2mhcr/jTof3+JMm+oB+qeCoQQRqFHD9Ts6iqFdoOw=;
        b=FEAP+ZK0+j28Sh/l3LEIiElc9eJ54VBp647TnpOCvxG90eoXMGWord4jpb5KX+MLiw
         BGzpJJjT5FNw8N0p4WNdeGtG1FW8SIGvb00Dg1k/L8njGP4U+qyBLMq9RIQ/jzNgB49L
         WO14aEWn5FYOrucnzDizzYseX00badaDhWwvxwgQGIxFzb8GrDKI8chLifu5HERW+GqL
         eVLo4hnMHw22JEzJ5ikuoinLbtDBsDd8aZYmsj/XnY1FmTtQvZ6buvhWPyQsVcbxmjbz
         xTBsTwDk3mXTQ2yiKRJLfDI+YAC1Au7iqcJu9fr7Xofpzhy1iWm5V/GnrlktgQ6n83py
         K4yg==
X-Gm-Message-State: AOAM530hC7/KcEIiL0xLRUGhAwzok7LClsloIBUu33udUTg8fOWY1zID
        B552Z20BifZV4R6dfi42TB+yubCJvBSW7w==
X-Google-Smtp-Source: ABdhPJx4+N6yCZzmhjLROvjHKYhanHvYG1JE6Vzp3RhYJGUcxJbNELbU2XiXj5FLBGy3zjV/R6O5djivtOfACQ==
X-Received: by 2002:a25:3b94:: with SMTP id i142mr28484080yba.46.1593475459774;
 Mon, 29 Jun 2020 17:04:19 -0700 (PDT)
Date:   Mon, 29 Jun 2020 17:04:17 -0700
Message-Id: <20200630000417.2249731-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net] netfilter: ipset: call ip_set_free() instead of kfree()
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

Whenever ip_set_alloc() is used, allocated memory can either
use kmalloc() or vmalloc(). We should call kvfree() or
ip_set_free()

invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 21935 Comm: syz-executor.3 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__phys_addr+0xa7/0x110 arch/x86/mm/physaddr.c:28
Code: 1d 7a 09 4c 89 e3 31 ff 48 d3 eb 48 89 de e8 d0 58 3f 00 48 85 db 75 0d e8 26 5c 3f 00 4c 89 e0 5b 5d 41 5c c3 e8 19 5c 3f 00 <0f> 0b e8 12 5c 3f 00 48 c7 c0 10 10 a8 89 48 ba 00 00 00 00 00 fc
RSP: 0000:ffffc900018572c0 EFLAGS: 00010046
RAX: 0000000000040000 RBX: 0000000000000001 RCX: ffffc9000fac3000
RDX: 0000000000040000 RSI: ffffffff8133f437 RDI: 0000000000000007
RBP: ffffc90098aff000 R08: 0000000000000000 R09: ffff8880ae636cdb
R10: 0000000000000000 R11: 0000000000000000 R12: 0000408018aff000
R13: 0000000000080000 R14: 000000000000001d R15: ffffc900018573d8
FS:  00007fc540c66700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc9dcd67200 CR3: 0000000059411000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 virt_to_head_page include/linux/mm.h:841 [inline]
 virt_to_cache mm/slab.h:474 [inline]
 kfree+0x77/0x2c0 mm/slab.c:3749
 hash_net_create+0xbb2/0xd70 net/netfilter/ipset/ip_set_hash_gen.h:1536
 ip_set_create+0x6a2/0x13c0 net/netfilter/ipset/ip_set_core.c:1128
 nfnetlink_rcv_msg+0xbe8/0xea0 net/netfilter/nfnetlink.c:230
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:564
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb19
Code: Bad RIP value.
RSP: 002b:00007fc540c65c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004fed80 RCX: 000000000045cb19
RDX: 0000000000000000 RSI: 0000000020001080 RDI: 0000000000000003
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000000000000095e R14: 00000000004cc295 R15: 00007fc540c666d4

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Fixes: 03c8b234e61a ("netfilter: ipset: Generalize extensions support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c    | 2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c  | 2 +-
 net/netfilter/ipset/ip_set_hash_gen.h     | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 486959f70cf313b44b06fdaffef6827fbe04eaba..a8ce04a4bb72abef52524edad94dc7d69d39458a 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -326,7 +326,7 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	set->variant = &bitmap_ip;
 	if (!init_map_ip(set, map, first_ip, last_ip,
 			 elements, hosts, netmask)) {
-		kfree(map);
+		ip_set_free(map);
 		return -ENOMEM;
 	}
 	if (tb[IPSET_ATTR_TIMEOUT]) {
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 2310a316e0affc69676062f7d984126e6a0b8e83..2c625e0f49ec020581206445b3365663d9c19746 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -363,7 +363,7 @@ bitmap_ipmac_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_ipmac;
 	if (!init_map_ipmac(set, map, first_ip, last_ip, elements)) {
-		kfree(map);
+		ip_set_free(map);
 		return -ENOMEM;
 	}
 	if (tb[IPSET_ATTR_TIMEOUT]) {
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index e56ced66f202d6d8b6e913f0349a9991583d4014..7138e080def4cfd7abf40a9ca485212773dda8ec 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -274,7 +274,7 @@ bitmap_port_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_port;
 	if (!init_map_port(set, map, first_port, last_port)) {
-		kfree(map);
+		ip_set_free(map);
 		return -ENOMEM;
 	}
 	if (tb[IPSET_ATTR_TIMEOUT]) {
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 1ee43752d6d3ccb1eae1684369a8be5ea5b96656..521e970be4028de7659b437616f844744362f10b 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -682,7 +682,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	}
 	t->hregion = ip_set_alloc(ahash_sizeof_regions(htable_bits));
 	if (!t->hregion) {
-		kfree(t);
+		ip_set_free(t);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1533,7 +1533,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	}
 	t->hregion = ip_set_alloc(ahash_sizeof_regions(hbits));
 	if (!t->hregion) {
-		kfree(t);
+		ip_set_free(t);
 		kfree(h);
 		return -ENOMEM;
 	}
-- 
2.27.0.212.ge8ba1cc988-goog

