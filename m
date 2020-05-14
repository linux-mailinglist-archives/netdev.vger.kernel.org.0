Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCFE1D3C51
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgENSw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728488AbgENSwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:52:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C261B20722;
        Thu, 14 May 2020 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482373;
        bh=fIKF1pDVkSW6DCJNR99hImpfok5ZmIDQ7demSS+zRYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3EqFsbsvrAoZgI8kixBOZIfof+X5e65heH0oOMNn+M/il9Cl8bu6CEIg2OatGDRP
         MDwz01/o7D4pnvBNKfvve3C2WuiJlTpAFKS4R7ViQShkNxiwT9/alw9pstAHuDGmJj
         LMbxO1AghcApJzvkZKRXJwYjf7S+eIEQ8YT8uAEQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.6 51/62] wireguard: selftests: initalize ipv6 members to NULL to squelch clang warning
Date:   Thu, 14 May 2020 14:51:36 -0400
Message-Id: <20200514185147.19716-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 4fed818ef54b08d4b29200e416cce65546ad5312 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/selftest/ratelimiter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/selftest/ratelimiter.c b/drivers/net/wireguard/selftest/ratelimiter.c
index bcd6462e45401..007cd4457c5f6 100644
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
2.20.1

