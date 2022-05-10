Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0ECA521FB1
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346349AbiEJPwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346389AbiEJPu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:50:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC3C28AB81;
        Tue, 10 May 2022 08:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09D166138B;
        Tue, 10 May 2022 15:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26620C385A6;
        Tue, 10 May 2022 15:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197505;
        bh=GXv6tY1AebcHyT6RQTdWPQMx6r8FXPGYTvF7mOdzci8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuaXSY/uxEXGkKC50oBvP81Va20Nk5YsCaQbWE82xU00+ljUbKf8VRPL8BJKYT3/A
         cIBr7V7F13co6oQ0zfHMM2E4jNXJHybttlE4P9TP4NPri54AO8soGciH0o7CRAhPT6
         l7y2/n4y5gZfn5ENOlQisiXmymvQ7Y2NMLJ3Eu5L7YSnu6rj0ccL0EWbJcl2SHmX80
         QV+eYMg6TAqS9qxB37nLmJb9RbC/pKzFT8YBcI1pHNb6LBFXQ4FyPq3ljGUS0JROzq
         wQAujoFj9NOvYIyXyZp3B/dfEDvq6cav9GmXRsU/d86RnppjGrj+/R/BYu3XC/XECz
         JGBvAGSivCa6w==
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
Subject: [PATCH AUTOSEL 5.15 16/19] tcp: dynamically allocate the perturb table used by source ports
Date:   Tue, 10 May 2022 11:44:26 -0400
Message-Id: <20220510154429.153677-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154429.153677-1-sashal@kernel.org>
References: <20220510154429.153677-1-sashal@kernel.org>
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
index 573a7e66ebc8..763395e30c77 100644
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

