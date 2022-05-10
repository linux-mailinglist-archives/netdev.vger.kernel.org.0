Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E101521F77
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346386AbiEJPtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346316AbiEJPsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:48:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C88226FA5E;
        Tue, 10 May 2022 08:44:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 143A7B81D0D;
        Tue, 10 May 2022 15:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727CCC385D0;
        Tue, 10 May 2022 15:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197460;
        bh=MaXGPolPz4kift9fAhWFyxiXkGWK0QfVnz1NKikV7Cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rgh6o6kYp5/7vT2YB2tfFRD5Wt3hWZNxlAvx0fVn3KI3mrQ3kCTW/Z4t5lK4EI9z5
         UX1YMf2WrptkWm5+/Z+GTkH0o3F7P1akgyA/ZrMB/ux+DA2wpJoQ8l3N8I19wEG90A
         btpQzZzbWnOo1e8cnz++Xed6PmqACHuKTaSPiW38C5r6GQKW5rwteyf+4b+clqT49e
         aSOXe/RwGwACjfAqLGOWFZUT6B/djlwIWhSoeJb6GwUPavHQu1YuvnENb6zpV1vP4Y
         uCo4GoQJlMqgenv9P4RPTmgrwRj+2WcGVVEabUsXMaGq5QhzIQD2DC8fe+C4k96nWC
         0pd8RfZbVyZ9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willy Tarreau <w@1wt.eu>, Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 17/21] tcp: dynamically allocate the perturb table used by source ports
Date:   Tue, 10 May 2022 11:43:36 -0400
Message-Id: <20220510154340.153400-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154340.153400-1-sashal@kernel.org>
References: <20220510154340.153400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit e9261476184be1abd486c9434164b2acbe0ed6c2 ]

We'll need to further increase the size of this table and it's likely
that at some point its size will not be suitable anymore for a static
table. Let's allocate it on boot from inet_hashinfo2_init(), which is
called from tcp_init().

Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Cc: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.35.1

