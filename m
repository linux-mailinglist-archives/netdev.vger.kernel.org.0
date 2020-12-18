Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AD52DE24B
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 13:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgLRMFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 07:05:02 -0500
Received: from correo.us.es ([193.147.175.20]:51970 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgLRMFB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 07:05:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8B288EB484
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 13:04:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7AD50DA858
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 13:04:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7A2F8DA856; Fri, 18 Dec 2020 13:04:01 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4307DDA704;
        Fri, 18 Dec 2020 13:03:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 18 Dec 2020 13:03:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 06CBC42DF560;
        Fri, 18 Dec 2020 13:03:58 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/4] netfilter: ipset: fix shift-out-of-bounds in htable_bits()
Date:   Fri, 18 Dec 2020 13:04:09 +0100
Message-Id: <20201218120409.3659-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201218120409.3659-1-pablo@netfilter.org>
References: <20201218120409.3659-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

htable_bits() can call jhash_size(32) and trigger shift-out-of-bounds

UBSAN: shift-out-of-bounds in net/netfilter/ipset/ip_set_hash_gen.h:151:6
shift exponent 32 is too large for 32-bit type 'unsigned int'
CPU: 0 PID: 8498 Comm: syz-executor519
 Not tainted 5.10.0-rc7-next-20201208-syzkaller #0
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 htable_bits net/netfilter/ipset/ip_set_hash_gen.h:151 [inline]
 hash_mac_create.cold+0x58/0x9b net/netfilter/ipset/ip_set_hash_gen.h:1524
 ip_set_create+0x610/0x1380 net/netfilter/ipset/ip_set_core.c:1115
 nfnetlink_rcv_msg+0xecc/0x1180 net/netfilter/nfnetlink.c:252
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:600
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

This patch replaces htable_bits() by simple fls(hashsize - 1) call:
it alone returns valid nbits both for round and non-round hashsizes.
It is normal to set any nbits here because it is validated inside
following htable_size() call which returns 0 for nbits>31.

Fixes: 1feab10d7e6d("netfilter: ipset: Unified hash type generation")
Reported-by: syzbot+d66bfadebca46cf61a2b@syzkaller.appspotmail.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 1e7dddf824ae..6186358eac7c 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -141,20 +141,6 @@ htable_size(u8 hbits)
 	return hsize * sizeof(struct hbucket *) + sizeof(struct htable);
 }
 
-/* Compute htable_bits from the user input parameter hashsize */
-static u8
-htable_bits(u32 hashsize)
-{
-	/* Assume that hashsize == 2^htable_bits */
-	u8 bits = fls(hashsize - 1);
-
-	if (jhash_size(bits) != hashsize)
-		/* Round up to the first 2^n value */
-		bits = fls(hashsize);
-
-	return bits;
-}
-
 #ifdef IP_SET_HASH_WITH_NETS
 #if IPSET_NET_COUNT > 1
 #define __CIDR(cidr, i)		(cidr[i])
@@ -1525,7 +1511,11 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	if (!h)
 		return -ENOMEM;
 
-	hbits = htable_bits(hashsize);
+	/* Compute htable_bits from the user input parameter hashsize.
+	 * Assume that hashsize == 2^htable_bits,
+	 * otherwise round up to the first 2^n value.
+	 */
+	hbits = fls(hashsize - 1);
 	hsize = htable_size(hbits);
 	if (hsize == 0) {
 		kfree(h);
-- 
2.20.1

