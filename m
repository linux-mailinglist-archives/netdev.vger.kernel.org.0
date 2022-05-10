Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE89522008
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346690AbiEJPxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346866AbiEJPv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:51:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2003852524;
        Tue, 10 May 2022 08:46:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2B82615A5;
        Tue, 10 May 2022 15:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2B8C385CA;
        Tue, 10 May 2022 15:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197568;
        bh=s6m1N4ESMrAWyUkCmGJdidYNclNI7R+8a5C4X+CB5Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFS3KehAJyQjRgs8kvVndf4ug5xnSVjfLck3DQ/aAtiDuluo3BRa0pJZy08J5P8iO
         Hd34BQ2H1t7nip2I2I3jWBaNq0bbIt8VNmzphkmKiGmqRKD70VjcK8ITMP8K5nNVRE
         waVjdHWHV5xTrbNnZIC6N9hILwMmlyxN/RiMrqA234DO0RAtrsAZctfMQD7/3hIXc2
         ilIFUjI1NIcNkqrkWabIAwXGD7ZYEUjvqf2e4yaDMqdlcrhbCmXj2KE37tLn3NS6mP
         TvY3ZFOq75OPPTNs8HpeYnV+a4talF4PpFOMNUmJTqS9ZQlXw6ImCIKD9GaXo9M5hY
         z6KTQn58ZEwPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, Willy Tarreau <w@1wt.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 7/8] tcp: resalt the secret every 10 seconds
Date:   Tue, 10 May 2022 11:45:35 -0400
Message-Id: <20220510154536.154070-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154536.154070-1-sashal@kernel.org>
References: <20220510154536.154070-1-sashal@kernel.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4dfa9b438ee34caca4e6a4e5e961641807367f6f ]

In order to limit the ability for an observer to recognize the source
ports sequence used to contact a set of destinations, we should
periodically shuffle the secret. 10 seconds looks effective enough
without causing particular issues.

Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Cc: Amit Klein <aksecurity@gmail.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Tested-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/secure_seq.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 7b6b1d2c3d10..2f9796a1a63f 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -23,6 +23,8 @@
 static siphash_key_t net_secret __read_mostly;
 static siphash_key_t ts_secret __read_mostly;
 
+#define EPHEMERAL_PORT_SHUFFLE_PERIOD (10 * HZ)
+
 static __always_inline void net_secret_init(void)
 {
 	net_get_random_once(&net_secret, sizeof(net_secret));
@@ -101,11 +103,13 @@ u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 	const struct {
 		struct in6_addr saddr;
 		struct in6_addr daddr;
+		unsigned int timeseed;
 		__be16 dport;
 	} __aligned(SIPHASH_ALIGNMENT) combined = {
 		.saddr = *(struct in6_addr *)saddr,
 		.daddr = *(struct in6_addr *)daddr,
-		.dport = dport
+		.timeseed = jiffies / EPHEMERAL_PORT_SHUFFLE_PERIOD,
+		.dport = dport,
 	};
 	net_secret_init();
 	return siphash(&combined, offsetofend(typeof(combined), dport),
@@ -146,8 +150,10 @@ EXPORT_SYMBOL_GPL(secure_tcp_seq);
 u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
 {
 	net_secret_init();
-	return siphash_3u32((__force u32)saddr, (__force u32)daddr,
-			    (__force u16)dport, &net_secret);
+	return siphash_4u32((__force u32)saddr, (__force u32)daddr,
+			    (__force u16)dport,
+			    jiffies / EPHEMERAL_PORT_SHUFFLE_PERIOD,
+			    &net_secret);
 }
 EXPORT_SYMBOL_GPL(secure_ipv4_port_ephemeral);
 #endif
-- 
2.35.1

