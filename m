Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197ED5133F2
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 14:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346580AbiD1Mox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 08:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346498AbiD1Mom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 08:44:42 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55502AFAE4;
        Thu, 28 Apr 2022 05:41:14 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 23SCeFwv007486;
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
Subject: [PATCH v2 net 7/7] tcp: drop the hash_32() part from the index calculation
Date:   Thu, 28 Apr 2022 14:40:01 +0200
Message-Id: <20220428124001.7428-8-w@1wt.eu>
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

In commit 190cc82489f4 ("tcp: change source port randomizarion at
connect() time"), the table_perturb[] array was introduced and an
index was taken from the port_offset via hash_32(). But it turns
out that hash_32() performs a multiplication while the input here
comes from the output of SipHash in secure_seq, that is well
distributed enough to avoid the need for yet another hash.

Suggested-by: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/inet_hashtables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index cc5f66328b47..a5d57fa679ca 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -778,7 +778,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 
 	net_get_random_once(table_perturb,
 			    INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
-	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
+	index = port_offset & (INET_TABLE_PERTURB_SIZE - 1);
 
 	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
 	offset %= remaining;
-- 
2.17.5

