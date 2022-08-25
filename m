Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9FBB5A04F2
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiHYAFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiHYAFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:05:30 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D293065811
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 17:05:28 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id s10-20020a17090a6e4a00b001fba85daa67so88782pjm.7
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 17:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=X0aXbVnjIsqv6IZlugAyzwT5Jn0BIh8DUeidfr3NTwU=;
        b=pizx5jtbolFH74HPRP+JXhQp2kt4f4Gvo5c8BahsoqOTkDMpUC21gySwAqRyERcsxp
         RxiJ7ZTDPE4UhNy7ASniRjeSQfLiOp7A52n7UcNJaRcgoNbt5hJSwRUZ2tkpQ2Q3baJ8
         4cQTvaVR9bW07R8J1S2oVdOXktAWKIkD5EuCtdCBJ7DOtVg6boyaG97qE7d++5ICk+ah
         2bvtXldISERsWobmMdnkvmtae/Ky7rkElbKgMUHUw96nEyyamlUTC7zNBQtNgsfupFiv
         1ehcbs9orlmOrXVk8eSGqQ8mVmxBPOLIJjcaHvhtzjRgZpozbsey811NndPtqmQMB85j
         qK7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=X0aXbVnjIsqv6IZlugAyzwT5Jn0BIh8DUeidfr3NTwU=;
        b=38Qmb027aXxsgUzZQaO633GkgCkcIsxiFJK1c767gmYIJLbuTx/+rBx/LMGizSaEnW
         /teb03yvGZsiW7KxgkjxVCea6XJREn2Rb2TTAw5GGx0atxV1pZ73zxXCIvM6oVKs2mMm
         orMW9+zoOWBDBzW2XvOJ6TvXgE6UPLXse1vBzrUVzwXLNlRlU5D1KMlsB1vWRnAPL+PQ
         c+4W/j+treFiJq3GQHy+CdkYGnsQvrZcgOQviWuBFVA1k58lhbEdn1O6uwd50JlD8qRQ
         B4fuXFeoe89tr3+Kx5b9D63RvaYod9hD2dlq4NGLUgvbLBLz3ZoHKymlbcFuF24t0xPM
         TPkA==
X-Gm-Message-State: ACgBeo02hSGgFoVjbnxFFFuE+7RE8+uVgACjTg1pcIvqCXWSdoIh51CQ
        JW8l4D6ASKZqhpcvieev2NS3uDFCRWqodQ==
X-Google-Smtp-Source: AA6agR5XSREtrswBTLHTLhIxt0y3r3MXI7uBpxQYmDyvEFx98x6p9m1M8gUdoBcShWUI0C8PD7kVrWRRQWbPPw==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a05:6a00:4147:b0:52e:2d56:17c8 with SMTP
 id bv7-20020a056a00414700b0052e2d5617c8mr1426905pfb.51.1661385928246; Wed, 24
 Aug 2022 17:05:28 -0700 (PDT)
Date:   Thu, 25 Aug 2022 00:05:04 +0000
In-Reply-To: <20220825000506.239406-1-shakeelb@google.com>
Message-Id: <20220825000506.239406-2-shakeelb@google.com>
Mime-Version: 1.0
References: <20220825000506.239406-1-shakeelb@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 1/3] mm: page_counter: remove unneeded atomic ops for low/min
From:   Shakeel Butt <shakeelb@google.com>
To:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>
Cc:     "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For cgroups using low or min protections, the function
propagate_protected_usage() was doing an atomic xchg() operation
irrespectively. We can optimize out this atomic operation for one
specific scenario where the workload is using the protection (i.e.
min > 0) and the usage is above the protection (i.e. usage > min).

This scenario is actually very common where the users want a part of
their workload to be protected against the external reclaim. Though this
optimization does introduce a race when the usage is around the
protection and concurrent charges and uncharged trip it over or under
the protection. In such cases, we might see lower effective protection
but the subsequent charge/uncharge will correct it.

To evaluate the impact of this optimization, on a 72 CPUs machine, we
ran the following workload in a three level of cgroup hierarchy with top
level having min and low setup appropriately to see if this optimization
is effective for the mentioned case.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
Without (6.0-rc1)	10482.7 Mbps
With patch		14542.5 Mbps (38.7% improvement)

With the patch, the throughput improved by 38.7%

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
---
Changes since v1:
- Commit message update with more detail on which scenario is getting
  optimized and possible race condition.

 mm/page_counter.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index eb156ff5d603..47711aa28161 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -17,24 +17,23 @@ static void propagate_protected_usage(struct page_counter *c,
 				      unsigned long usage)
 {
 	unsigned long protected, old_protected;
-	unsigned long low, min;
 	long delta;
 
 	if (!c->parent)
 		return;
 
-	min = READ_ONCE(c->min);
-	if (min || atomic_long_read(&c->min_usage)) {
-		protected = min(usage, min);
+	protected = min(usage, READ_ONCE(c->min));
+	old_protected = atomic_long_read(&c->min_usage);
+	if (protected != old_protected) {
 		old_protected = atomic_long_xchg(&c->min_usage, protected);
 		delta = protected - old_protected;
 		if (delta)
 			atomic_long_add(delta, &c->parent->children_min_usage);
 	}
 
-	low = READ_ONCE(c->low);
-	if (low || atomic_long_read(&c->low_usage)) {
-		protected = min(usage, low);
+	protected = min(usage, READ_ONCE(c->low));
+	old_protected = atomic_long_read(&c->low_usage);
+	if (protected != old_protected) {
 		old_protected = atomic_long_xchg(&c->low_usage, protected);
 		delta = protected - old_protected;
 		if (delta)
-- 
2.37.1.595.g718a3a8f04-goog

