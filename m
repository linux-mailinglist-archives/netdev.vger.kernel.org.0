Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F54E214247
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 02:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgGDAON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 20:14:13 -0400
Received: from correo.us.es ([193.147.175.20]:56768 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbgGDAOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 20:14:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC6B9ED5C2
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 02:14:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B3D1DA78D
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 02:14:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8E843DA78B; Sat,  4 Jul 2020 02:14:10 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 291F1DA72F;
        Sat,  4 Jul 2020 02:14:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 04 Jul 2020 02:14:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 03DF242EF532;
        Sat,  4 Jul 2020 02:14:07 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/2] netfilter: ipset: call ip_set_free() instead of kfree()
Date:   Sat,  4 Jul 2020 02:13:58 +0200
Message-Id: <20200704001359.1304-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200704001359.1304-1-pablo@netfilter.org>
References: <20200704001359.1304-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c    | 2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c  | 2 +-
 net/netfilter/ipset/ip_set_hash_gen.h     | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 486959f70cf3..a8ce04a4bb72 100644
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
index 2310a316e0af..2c625e0f49ec 100644
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
index e56ced66f202..7138e080def4 100644
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
index 1ee43752d6d3..521e970be402 100644
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
2.20.1

