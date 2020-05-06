Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EE11C7C81
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgEFVdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:33:33 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55147 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbgEFVd1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 17:33:27 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 50d3269b;
        Wed, 6 May 2020 21:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=6SZ2ShOF3NA13UH2PvVv0pokh
        70=; b=e3sgm4SL0HGi2lbq7khL6YwFjH/gY7LilQ9ozQhGApUoiKJIMdE38stCk
        rQCazLIve1+VZXem0s7yUDQXSV6y+foTYXTr155GTwEPPOsOucLKDfePfmElP9PV
        4dxLN3O5Ml42B7Fwq3m03Dv9f+2kaX/1ZQ8i8wCSThSLe2xvcEWtiSD2U7apF0gy
        Gl37jwGTC4EAmsd4cxH8beoBlExPrYGtYZHp2gCiNsv9OwnH48hd5/lTv2cqkSNO
        OjgXH1UOQJ9okJ+khVw0sU1ncwJBkt2aQQ2AJevzlkPKb5syDPp5wgqYe3NFGNbJ
        U+/SxZB+T40lEco6GxhO+q2XD1Usw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ecfd542f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 6 May 2020 21:20:40 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net 4/5] wireguard: selftests: initalize ipv6 members to NULL to squelch clang warning
Date:   Wed,  6 May 2020 15:33:05 -0600
Message-Id: <20200506213306.1344212-5-Jason@zx2c4.com>
In-Reply-To: <20200506213306.1344212-1-Jason@zx2c4.com>
References: <20200506213306.1344212-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without setting these to NULL, clang complains in certain
configurations that have CONFIG_IPV6=n:

In file included from drivers/net/wireguard/ratelimiter.c:223:
drivers/net/wireguard/selftest/ratelimiter.c:173:34: error: variable 'skb6' is uninitialized when used here [-Werror,-Wuninitialized]
                ret = timings_test(skb4, hdr4, skb6, hdr6, &test_count);
                                               ^~~~
drivers/net/wireguard/selftest/ratelimiter.c:123:29: note: initialize the variable 'skb6' to silence this warning
        struct sk_buff *skb4, *skb6;
                                   ^
                                    = NULL
drivers/net/wireguard/selftest/ratelimiter.c:173:40: error: variable 'hdr6' is uninitialized when used here [-Werror,-Wuninitialized]
                ret = timings_test(skb4, hdr4, skb6, hdr6, &test_count);
                                                     ^~~~
drivers/net/wireguard/selftest/ratelimiter.c:125:22: note: initialize the variable 'hdr6' to silence this warning
        struct ipv6hdr *hdr6;
                            ^

We silence this warning by setting the variables to NULL as the warning
suggests.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/selftest/ratelimiter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/selftest/ratelimiter.c b/drivers/net/wireguard/selftest/ratelimiter.c
index bcd6462e4540..007cd4457c5f 100644
--- a/drivers/net/wireguard/selftest/ratelimiter.c
+++ b/drivers/net/wireguard/selftest/ratelimiter.c
@@ -120,9 +120,9 @@ bool __init wg_ratelimiter_selftest(void)
 	enum { TRIALS_BEFORE_GIVING_UP = 5000 };
 	bool success = false;
 	int test = 0, trials;
-	struct sk_buff *skb4, *skb6;
+	struct sk_buff *skb4, *skb6 = NULL;
 	struct iphdr *hdr4;
-	struct ipv6hdr *hdr6;
+	struct ipv6hdr *hdr6 = NULL;
 
 	if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_UBSAN))
 		return true;
-- 
2.26.2

