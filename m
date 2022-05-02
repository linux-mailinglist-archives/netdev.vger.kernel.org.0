Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA0B516C62
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354966AbiEBIvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383925AbiEBIup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:50:45 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25B962B18B;
        Mon,  2 May 2022 01:47:06 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 2428kHr2024178;
        Mon, 2 May 2022 10:46:17 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Subject: [PATCH v3 net 5/7] tcp: dynamically allocate the perturb table used by source ports
Date:   Mon,  2 May 2022 10:46:12 +0200
Message-Id: <20220502084614.24123-6-w@1wt.eu>
X-Mailer: git-send-email 2.17.5
In-Reply-To: <20220502084614.24123-1-w@1wt.eu>
References: <20220502084614.24123-1-w@1wt.eu>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll need to further increase the size of this table and it's likely
that at some point its size will not be suitable anymore for a static
table. Let's allocate it on boot from inet_hashinfo2_init(), which is
called from tcp_init().

Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Cc: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/inet_hashtables.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 63bb4902f018..48ca07853068 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -731,7 +731,8 @@ EXPORT_SYMBOL_GPL(inet_unhash);
  * privacy, this only consumes 1 KB of kernel memory.
  */
 #define INET_TABLE_PERTURB_SHIFT 8
-static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
+#define INET_TABLE_PERTURB_SIZE (1 << INET_TABLE_PERTURB_SHIFT)
+static u32 *table_perturb;
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		struct sock *sk, u64 port_offset,
@@ -774,7 +775,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	net_get_random_once(table_perturb, sizeof(table_perturb));
+	net_get_random_once(table_perturb,
+			    INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
 	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
 
 	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
@@ -912,6 +914,12 @@ void __init inet_hashinfo2_init(struct inet_hashinfo *h, const char *name,
 					    low_limit,
 					    high_limit);
 	init_hashinfo_lhash2(h);
+
+	/* this one is used for source ports of outgoing connections */
+	table_perturb = kmalloc_array(INET_TABLE_PERTURB_SIZE,
+				      sizeof(*table_perturb), GFP_KERNEL);
+	if (!table_perturb)
+		panic("TCP: failed to alloc table_perturb");
 }
 
 int inet_hashinfo2_init_mod(struct inet_hashinfo *h)
-- 
2.17.5

