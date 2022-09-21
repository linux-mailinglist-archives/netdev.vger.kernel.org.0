Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549A15BFBAF
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiIUJxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiIUJwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:52:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E4B641F;
        Wed, 21 Sep 2022 02:50:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oawN0-0006Q7-RY; Wed, 21 Sep 2022 11:50:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <netfilter-devel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 2/4] netfilter: conntrack: revisit the gc initial rescheduling bias
Date:   Wed, 21 Sep 2022 11:49:58 +0200
Message-Id: <20220921095000.29569-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921095000.29569-1-fw@strlen.de>
References: <20220921095000.29569-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

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
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8efa6bd5703c..8208a28ea342 100644
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
2.35.1

