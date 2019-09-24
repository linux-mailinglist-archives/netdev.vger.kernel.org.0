Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0951BC2C0
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 09:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502655AbfIXHgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 03:36:25 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:43049 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388489AbfIXHgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 03:36:25 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6c2e1b8c;
        Tue, 24 Sep 2019 06:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=sxkr1GjA+CsTQ6F9imEHmeQRp90=; b=0K6Ytrl/QEsiaO1QZr6s
        +K7CfH2DPbhur/Qy3RFbGxcJzXNW2ugJbMgIhVnUMpZxVpzTgMqxE3lXYyHe30ZL
        4KbwsIEZthGw9zi+qowGGpxDkB2XsaictHzT8vnq1txFDdUHf/nT9QKr7V8L3xJW
        O9QCKE00gkivk1hykqNT3obEgyeLL4YtLg+YM4RZGecvyPQIpGVIlidG2eDQgj9a
        kWUEtrBG8ArIyDxwZBFv6orgP5PWAS+RoENJWt677BNh4I39wIxYmKceGrBgBaqQ
        HdUvSDMxb3jWLCaKfXbf67t61bGhEOLbuOA2uMXD9SBrIaNFsXS9Ua6vnLMMjfne
        Zw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6493f950 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 24 Sep 2019 06:50:47 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH] ipv6: do not free rt if FIB_LOOKUP_NOREF is set on suppress rule
Date:   Tue, 24 Sep 2019 09:36:15 +0200
Message-Id: <20190924073615.31704-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7d9e5f422150 removed references from certain dsts, but accounting
for this never translated down into the fib6 suppression code. This bug
was triggered by WireGuard users who use wg-quick(8), which uses the
"suppress-prefix" directive to ip-rule(8) for routing all of their
internet traffic without routing loops. The test case in the link of
this commit reliably triggers various crashes due to the use-after-free
caused by the reference underflow.

Cc: stable@vger.kernel.org
Fixes: 7d9e5f422150 ("ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF")
Test-case: https://git.zx2c4.com/WireGuard/commit/?id=ad66532000f7a20b149e47c5eb3a957362c8e161
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/ipv6/fib6_rules.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index d22b6c140f23..f9e8fe3ff0c5 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -287,7 +287,8 @@ static bool fib6_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg
 	return false;
 
 suppress_route:
-	ip6_rt_put(rt);
+	if (!(arg->flags & FIB_LOOKUP_NOREF))
+		ip6_rt_put(rt);
 	return true;
 }
 
-- 
2.21.0

