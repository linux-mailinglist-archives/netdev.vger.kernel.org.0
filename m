Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB755BA969
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 11:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiIPJ35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 05:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiIPJ3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 05:29:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894D5193C0;
        Fri, 16 Sep 2022 02:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 263FC62990;
        Fri, 16 Sep 2022 09:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADFFC433D6;
        Fri, 16 Sep 2022 09:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663320590;
        bh=mH+7FsWWlU4xLltqGgEz1Qg6OJXIWH4c9PbXakdU4qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Flr+J/78gOr/+njPfQrcd6VKAJajooc9fwFIcMOYvIgHf/Bv6nlfgyhtxYhMrhchD
         0SLqSfJ3Da9yzjV8yBFwJtdQBd+rRC0YkEONGMh5THsbIIn/Kzo/L3urb6tFWuPvmi
         2yzIpzWJH8RomhlPLvUodjHxMvLpZ/w4WXia3rq3XEaoeQ+epSpLCYvlK786OlhEqQ
         LzxhIf/V1zecMFXbrpjKaJj8jnklJbzc4YXnn6S2wSooHJJKLfdVww5h4SGkmmRzCm
         bk5O7upAzlnxllPYKXp+9PKIcldAKZJWkWnpMmzlShiGyO0Lr/Mk7X/4JlYW0tZN5v
         Woe0vjnpIexxg==
From:   Antoine Tenart <atenart@kernel.org>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     Antoine Tenart <atenart@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: conntrack: revisit the gc initial rescheduling bias
Date:   Fri, 16 Sep 2022 11:29:41 +0200
Message-Id: <20220916092941.39121-3-atenart@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916092941.39121-1-atenart@kernel.org>
References: <20220916092941.39121-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit changed the way the rescheduling delay is computed
which has a side effect: the bias is now represented as much as the
other entries in the rescheduling delay which makes the logic to kick in
only with very large sets, as the initial interval is very large
(INT_MAX).

Revisit the GC initial bias to allow more frequent GC for smaller sets
while still avoiding wakeups when a machine is mostly idle. We're moving
from a large initial value to pretending we have 100 entries expiring at
the upper bound. This way only a few entries having a small timeout
won't impact much the rescheduling delay and non-idle machines will have
enough entries to lower the delay when needed. This also improves
readability as the initial bias is now linked to what is computed
instead of being an arbitrary large value.

Fixes: 2cfadb761d3d ("netfilter: conntrack: revisit gc autotuning")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2e6d5f1e6d63..8f261cd5b3a5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -86,10 +86,12 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
 /* clamp timeouts to this value (TCP unacked) */
 #define GC_SCAN_INTERVAL_CLAMP	(300ul * HZ)
 
-/* large initial bias so that we don't scan often just because we have
- * three entries with a 1s timeout.
+/* Initial bias pretending we have 100 entries at the upper bound so we don't
+ * wakeup often just because we have three entries with a 1s timeout while still
+ * allowing non-idle machines to wakeup more often when needed.
  */
-#define GC_SCAN_INTERVAL_INIT	INT_MAX
+#define GC_SCAN_INITIAL_COUNT	100
+#define GC_SCAN_INTERVAL_INIT	GC_SCAN_INTERVAL_MAX
 
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 #define GC_SCAN_EXPIRED_MAX	(64000u / HZ)
@@ -1477,7 +1479,7 @@ static void gc_worker(struct work_struct *work)
 
 	if (i == 0) {
 		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
-		gc_work->count = 1;
+		gc_work->count = GC_SCAN_INITIAL_COUNT;
 		gc_work->start_time = start_time;
 	}
 
-- 
2.37.3

