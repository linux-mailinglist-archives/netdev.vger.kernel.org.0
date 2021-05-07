Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9F53769AC
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 19:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhEGRs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 13:48:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49144 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhEGRsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 13:48:51 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D06E16414B;
        Fri,  7 May 2021 19:47:03 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 7/8] netfilter: nftables: avoid overflows in nft_hash_buckets()
Date:   Fri,  7 May 2021 19:47:38 +0200
Message-Id: <20210507174739.1850-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210507174739.1850-1-pablo@netfilter.org>
References: <20210507174739.1850-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Number of buckets being stored in 32bit variables, we have to
ensure that no overflows occur in nft_hash_buckets()

syzbot injected a size == 0x40000000 and reported:

UBSAN: shift-out-of-bounds in ./include/linux/log2.h:57:13
shift exponent 64 is too large for 64-bit type 'long unsigned int'
CPU: 1 PID: 29539 Comm: syz-executor.4 Not tainted 5.12.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
 __roundup_pow_of_two include/linux/log2.h:57 [inline]
 nft_hash_buckets net/netfilter/nft_set_hash.c:411 [inline]
 nft_hash_estimate.cold+0x19/0x1e net/netfilter/nft_set_hash.c:652
 nft_select_set_ops net/netfilter/nf_tables_api.c:3586 [inline]
 nf_tables_newset+0xe62/0x3110 net/netfilter/nf_tables_api.c:4322
 nfnetlink_rcv_batch+0xa09/0x24b0 net/netfilter/nfnetlink.c:488
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:612 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:630
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46

Fixes: 0ed6389c483d ("netfilter: nf_tables: rename set implementations")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 58f576abcd4a..328f2ce32e4c 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -412,9 +412,17 @@ static void nft_rhash_destroy(const struct nft_set *set)
 				    (void *)set);
 }
 
+/* Number of buckets is stored in u32, so cap our result to 1U<<31 */
+#define NFT_MAX_BUCKETS (1U << 31)
+
 static u32 nft_hash_buckets(u32 size)
 {
-	return roundup_pow_of_two(size * 4 / 3);
+	u64 val = div_u64((u64)size * 4, 3);
+
+	if (val >= NFT_MAX_BUCKETS)
+		return NFT_MAX_BUCKETS;
+
+	return roundup_pow_of_two(val);
 }
 
 static bool nft_rhash_estimate(const struct nft_set_desc *desc, u32 features,
-- 
2.30.2

