Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B355111C1
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358428AbiD0G4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358378AbiD0G4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:56:21 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4556D50B34;
        Tue, 26 Apr 2022 23:53:10 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 23R6qoCf002125;
        Wed, 27 Apr 2022 08:52:50 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 1/7] secure_seq: return the full 64-bit of the siphash
Date:   Wed, 27 Apr 2022 08:52:27 +0200
Message-Id: <20220427065233.2075-2-w@1wt.eu>
X-Mailer: git-send-email 2.17.5
In-Reply-To: <20220427065233.2075-1-w@1wt.eu>
References: <20220427065233.2075-1-w@1wt.eu>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SipHash replaced MD5 in secure_ipv4_port_ephemeral() via commit
7cd23e5300c1 ("secure_seq: use SipHash in place of MD5"), but the
output remained truncated to 32-bit only. In order to exploit more
bits from the hash, let's make the function return the full 64-bit
of siphash_3u32().

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Cc: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/net/inet_hashtables.h | 2 +-
 include/net/secure_seq.h      | 2 +-
 net/core/secure_seq.c         | 2 +-
 net/ipv4/inet_hashtables.c    | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index f72ec113ae56..98e1ec1a14f0 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -425,7 +425,7 @@ static inline void sk_rcv_saddr_set(struct sock *sk, __be32 addr)
 }
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-			struct sock *sk, u32 port_offset,
+			struct sock *sk, u64 port_offset,
 			int (*check_established)(struct inet_timewait_death_row *,
 						 struct sock *, __u16,
 						 struct inet_timewait_sock **));
diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
index d7d2495f83c2..5cea9ed9c773 100644
--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@ -4,7 +4,7 @@
 
 #include <linux/types.h>
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
 u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport);
 u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 9b8443774449..2cdd43a63f64 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -142,7 +142,7 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 }
 EXPORT_SYMBOL_GPL(secure_tcp_seq);
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
 {
 	net_secret_init();
 	return siphash_3u32((__force u32)saddr, (__force u32)daddr,
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 17440840a791..09cbad0488ca 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -504,7 +504,7 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet_sk_port_offset(const struct sock *sk)
+static u64 inet_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -734,7 +734,7 @@ EXPORT_SYMBOL_GPL(inet_unhash);
 static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-		struct sock *sk, u32 port_offset,
+		struct sock *sk, u64 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
 			struct sock *, __u16, struct inet_timewait_sock **))
 {
@@ -859,7 +859,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 int inet_hash_connect(struct inet_timewait_death_row *death_row,
 		      struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet_sk_port_offset(sk);
-- 
2.17.5

