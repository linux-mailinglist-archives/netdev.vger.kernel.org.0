Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEA72BBEF8
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 13:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgKUMgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 07:36:21 -0500
Received: from correo.us.es ([193.147.175.20]:60576 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbgKUMgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 07:36:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E8C04EBACD
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 13:36:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB6E7DA73D
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 13:36:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D11ACDA78F; Sat, 21 Nov 2020 13:36:15 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 814FFDA78A;
        Sat, 21 Nov 2020 13:36:13 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 21 Nov 2020 13:36:13 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 55E494265A5A;
        Sat, 21 Nov 2020 13:36:13 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/4] netfilter: ipset: prevent uninit-value in hash_ip6_add
Date:   Sat, 21 Nov 2020 13:36:00 +0100
Message-Id: <20201121123601.21733-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201121123601.21733-1-pablo@netfilter.org>
References: <20201121123601.21733-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot found that we are not validating user input properly
before copying 16 bytes [1].

Using NLA_BINARY in ipaddr_policy[] for IPv6 address is not correct,
since it ensures at most 16 bytes were provided.

We should instead make sure user provided exactly 16 bytes.

In old kernels (before v4.20), fix would be to remove the NLA_BINARY,
since NLA_POLICY_EXACT_LEN() was not yet available.

[1]
BUG: KMSAN: uninit-value in hash_ip6_add+0x1cba/0x3a50 net/netfilter/ipset/ip_set_hash_gen.h:892
CPU: 1 PID: 11611 Comm: syz-executor.0 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hash_ip6_add+0x1cba/0x3a50 net/netfilter/ipset/ip_set_hash_gen.h:892
 hash_ip6_uadt+0x976/0xbd0 net/netfilter/ipset/ip_set_hash_ip.c:267
 call_ad+0x329/0xd00 net/netfilter/ipset/ip_set_core.c:1720
 ip_set_ad+0x111f/0x1440 net/netfilter/ipset/ip_set_core.c:1808
 ip_set_uadd+0xf6/0x110 net/netfilter/ipset/ip_set_core.c:1833
 nfnetlink_rcv_msg+0xc7d/0xdf0 net/netfilter/nfnetlink.c:252
 netlink_rcv_skb+0x70a/0x820 net/netlink/af_netlink.c:2494
 nfnetlink_rcv+0x4f0/0x4380 net/netfilter/nfnetlink.c:600
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11da/0x14b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x173c/0x1840 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x6d5/0x830 net/socket.c:2440
 __do_sys_sendmsg net/socket.c:2449 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2447
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2447
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe2e503fc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000029ec0 RCX: 000000000045deb9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 000000000118bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 000000000169fb7f R14: 00007fe2e50409c0 R15: 000000000118bf2c

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 __msan_chain_origin+0x57/0xa0 mm/kmsan/kmsan_instr.c:147
 ip6_netmask include/linux/netfilter/ipset/pfxlen.h:49 [inline]
 hash_ip6_netmask net/netfilter/ipset/ip_set_hash_ip.c:185 [inline]
 hash_ip6_uadt+0xb1c/0xbd0 net/netfilter/ipset/ip_set_hash_ip.c:263
 call_ad+0x329/0xd00 net/netfilter/ipset/ip_set_core.c:1720
 ip_set_ad+0x111f/0x1440 net/netfilter/ipset/ip_set_core.c:1808
 ip_set_uadd+0xf6/0x110 net/netfilter/ipset/ip_set_core.c:1833
 nfnetlink_rcv_msg+0xc7d/0xdf0 net/netfilter/nfnetlink.c:252
 netlink_rcv_skb+0x70a/0x820 net/netlink/af_netlink.c:2494
 nfnetlink_rcv+0x4f0/0x4380 net/netfilter/nfnetlink.c:600
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11da/0x14b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x173c/0x1840 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x6d5/0x830 net/socket.c:2440
 __do_sys_sendmsg net/socket.c:2449 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2447
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2447
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 kmsan_memcpy_memmove_metadata+0x25e/0x2d0 mm/kmsan/kmsan.c:226
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:246
 __msan_memcpy+0x46/0x60 mm/kmsan/kmsan_instr.c:110
 ip_set_get_ipaddr6+0x2cb/0x370 net/netfilter/ipset/ip_set_core.c:310
 hash_ip6_uadt+0x439/0xbd0 net/netfilter/ipset/ip_set_hash_ip.c:255
 call_ad+0x329/0xd00 net/netfilter/ipset/ip_set_core.c:1720
 ip_set_ad+0x111f/0x1440 net/netfilter/ipset/ip_set_core.c:1808
 ip_set_uadd+0xf6/0x110 net/netfilter/ipset/ip_set_core.c:1833
 nfnetlink_rcv_msg+0xc7d/0xdf0 net/netfilter/nfnetlink.c:252
 netlink_rcv_skb+0x70a/0x820 net/netlink/af_netlink.c:2494
 nfnetlink_rcv+0x4f0/0x4380 net/netfilter/nfnetlink.c:600
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11da/0x14b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x173c/0x1840 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x6d5/0x830 net/socket.c:2440
 __do_sys_sendmsg net/socket.c:2449 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2447
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2447
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2906 [inline]
 __kmalloc_node_track_caller+0xc61/0x15f0 mm/slub.c:4512
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x309/0xae0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1094 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1176 [inline]
 netlink_sendmsg+0xdb8/0x1840 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0xc7a/0x1240 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x6d5/0x830 net/socket.c:2440
 __do_sys_sendmsg net/socket.c:2449 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2447
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2447
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 7cff6e5e7445..2b19189a930f 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -271,8 +271,7 @@ flag_nested(const struct nlattr *nla)
 
 static const struct nla_policy ipaddr_policy[IPSET_ATTR_IPADDR_MAX + 1] = {
 	[IPSET_ATTR_IPADDR_IPV4]	= { .type = NLA_U32 },
-	[IPSET_ATTR_IPADDR_IPV6]	= { .type = NLA_BINARY,
-					    .len = sizeof(struct in6_addr) },
+	[IPSET_ATTR_IPADDR_IPV6]	= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
 };
 
 int
-- 
2.20.1

