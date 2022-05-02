Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85036516C68
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383882AbiEBIvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383977AbiEBIvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:51:00 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA54259BA2;
        Mon,  2 May 2022 01:47:23 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 2428kHE0024179;
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
Subject: [PATCH v3 net 6/7] tcp: increase source port perturb table to 2^16
Date:   Mon,  2 May 2022 10:46:13 +0200
Message-Id: <20220502084614.24123-7-w@1wt.eu>
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

Moshe Kol, Amit Klein, and Yossi Gilad reported being able to accurately
identify a client by forcing it to emit only 40 times more connections
than there are entries in the table_perturb[] table. The previous two
improvements consisting in resalting the secret every 10s and adding
randomness to each port selection only slightly improved the situation,
and the current value of 2^8 was too small as it's not very difficult
to make a client emit 10k connections in less than 10 seconds.

Thus we're increasing the perturb table from 2^8 to 2^16 so that the the
same precision now requires 2.6M connections, which is more difficult in
this time frame and harder to hide as a background activity. The impact
is that the table now uses 256 kB instead of 1 kB, which could mostly
affect devices making frequent outgoing connections. However such
components usually target a small set of destinations (load balancers,
database clients, perf assessment tools), and in practice only a few
entries will be visited, like before.

A live test at 1 million connections per second showed no performance
difference from the previous value.

Reported-by: Moshe Kol <moshe.kol@mail.huji.ac.il>
Reported-by: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Reported-by: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/inet_hashtables.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 48ca07853068..cc5f66328b47 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -726,11 +726,12 @@ EXPORT_SYMBOL_GPL(inet_unhash);
  * Note that we use 32bit integers (vs RFC 'short integers')
  * because 2^16 is not a multiple of num_ephemeral and this
  * property might be used by clever attacker.
- * RFC claims using TABLE_LENGTH=10 buckets gives an improvement,
- * we use 256 instead to really give more isolation and
- * privacy, this only consumes 1 KB of kernel memory.
+ * RFC claims using TABLE_LENGTH=10 buckets gives an improvement, though
+ * attacks were since demonstrated, thus we use 65536 instead to really
+ * give more isolation and privacy, at the expense of 256kB of kernel
+ * memory.
  */
-#define INET_TABLE_PERTURB_SHIFT 8
+#define INET_TABLE_PERTURB_SHIFT 16
 #define INET_TABLE_PERTURB_SIZE (1 << INET_TABLE_PERTURB_SHIFT)
 static u32 *table_perturb;
 
-- 
2.17.5

