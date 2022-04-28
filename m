Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABCE5133E4
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 14:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346482AbiD1MoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 08:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346383AbiD1MoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 08:44:23 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34579AF1F7;
        Thu, 28 Apr 2022 05:41:06 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 23SCeFeQ007481;
        Thu, 28 Apr 2022 14:40:15 +0200
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
Subject: [PATCH v2 net 2/7] tcp: use different parts of the port_offset for index and offset
Date:   Thu, 28 Apr 2022 14:39:56 +0200
Message-Id: <20220428124001.7428-3-w@1wt.eu>
X-Mailer: git-send-email 2.17.5
In-Reply-To: <20220428124001.7428-1-w@1wt.eu>
References: <20220428124001.7428-1-w@1wt.eu>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amit Klein suggests that we use different parts of port_offset for the
table's index and the port offset so that there is no direct relation
between them.

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Cc: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/inet_hashtables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 9d24d9319f3d..29c701cd8312 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -777,7 +777,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	net_get_random_once(table_perturb, sizeof(table_perturb));
 	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
 
-	offset = READ_ONCE(table_perturb[index]) + port_offset;
+	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
 	offset %= remaining;
 
 	/* In first pass we try ports of @low parity.
-- 
2.17.5

