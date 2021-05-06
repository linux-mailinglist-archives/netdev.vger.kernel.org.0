Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4B6375427
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 14:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhEFMy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 08:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhEFMy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 08:54:26 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B4CC061574;
        Thu,  6 May 2021 05:53:28 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y2so3341894plr.5;
        Thu, 06 May 2021 05:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5WXMH/ndWpImhouQOG5zFoq1OQIw9YVoXhadZEmqijU=;
        b=Af4eESRCxxsPQS1x0ulyp3g0yrH0ZFkBAjcp/f7T9eTxoZnCPWE9RdFK97GqY4nZxh
         EDJ+5PsItbxJBZ/21bhvcas2vjf59rc7mv3GIpXCpCp5eZrl16EaE/OIrCOoD7Uy614P
         PGQnX/57CzmOPbgkk/d6cgnKdWQSFS7XeEZfPRsmj31OoJ6boTj7746nVkjSyi81qz3j
         VN/9nm0PVfYHjDSplhT+uW9FQ6a9UyjOAjjSgtqJVU+06i/Yj9/3OtrjSRSxcnz9qZKc
         qvILqfWRChxPVquV0tYBs6G9n19OAuizrU4S8w5a8H+qW+RwQZTD3KLHa7fjKn3ZZgDA
         01Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5WXMH/ndWpImhouQOG5zFoq1OQIw9YVoXhadZEmqijU=;
        b=FhY4EYnbPBr8YKJEcaWn8F1VX1XcQKZO2fOQeAtfW/ZIP52WPnhh1RqXTx0V0Jaqmr
         +gMDe7oyU58BwthnWHyvdgBVPK9COyU9JKx2nf5KBjl5uB0JJzKEuU/Vyhp4XtczefXy
         CZwkzyICTT+MUJV5jHsCLjMCs53s/80YYeX8K8jEj2i8lXc4EN7TtcQjBE5lXoY/9Jx5
         QyxYkL3nwJKdL+EiGr9s9X8qvB5PuniQsWANNf79LwlUlHxghlxxxeGq1pwxDjkD0Hs5
         AXczINzBkFEoxoe9g10jxfu2Ggn4Lr5gNz0Wla/ujJ3OvMiS9xE42jyDV6+C6qk4ClZl
         awbg==
X-Gm-Message-State: AOAM53332SnY+DivPeBXuu7KzZ8PcXg0oa8NR7bv71Wl9vLibHoekBha
        3Y2P1VuF/xwknyxMEFY9uxI=
X-Google-Smtp-Source: ABdhPJzvbTEAAug/ATqEyzPKuGC/0yQlGJ3v2LbUbasXE51OTotFgaKrdBVG6qSYo2jD347L6Wu03Q==
X-Received: by 2002:a17:903:3106:b029:e9:15e8:250e with SMTP id w6-20020a1709033106b02900e915e8250emr4332080plc.33.1620305608165;
        Thu, 06 May 2021 05:53:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4970:7438:9f62:403a])
        by smtp.gmail.com with ESMTPSA id f1sm9382242pjt.50.2021.05.06.05.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 05:53:27 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net 1/2] netfilter: nf_tables: avoid overflows in nft_hash_buckets()
Date:   Thu,  6 May 2021 05:53:23 -0700
Message-Id: <20210506125323.3887186-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
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
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netfilter/nft_set_hash.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 58f576abcd4a7f22bb9d362550b98e79e2152af3..328f2ce32e4cbd772afe03a10f6d13a7ed6b93d5 100644
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
2.31.1.527.g47e6f16901-goog

