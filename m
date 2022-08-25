Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9346F5A04F0
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiHYAFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiHYAFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:05:44 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4839F67464
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 17:05:35 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c7-20020a170902d48700b00172ea5ea9caso6467433plg.15
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 17:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=PYwH6PVPNEHbvaxrK4rS2xJuwZB9u4thO5MZW7XvPbI=;
        b=P+EUKtE6ricb8wdTGimfBl8wJsULmlf1U1ls8bGlVkUaNforVbvQ3tC93r2Tpdhx/X
         hu4ZaMawAO1E12zWi9v+4nP6DUb1SVdPpLc3AZ/xudS37LWaRSiaGz4e0Ka35xNar8nS
         etTkXsMGtCUsHLIDJkq4yN6bXebVUWkeBXO36LV/lhjXudjbUt/w2JGO2qgaytESq7HV
         6902pIR1fNvHv7YRbB2LtQuxsm8du6S+P2rMcQlo6xTb/H6Yi7+CtEya63vTqQFwHjtL
         G+IvhJMvzorYcD57EwbY2fI611avPsNj/SezAfStYMECqaRueXSKqxPmfC43aGfBG3ct
         BUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=PYwH6PVPNEHbvaxrK4rS2xJuwZB9u4thO5MZW7XvPbI=;
        b=X+c1Qs8MDi5Y5407/JKsLF72fpZkKG7Bo+6aeY6281Funp3JRAb7vThK8Qb5OHF7qw
         CDsXyRKZlBp34GCDbKjnu3YS4xBTuBFsc+2p8Ig5+fXkIXkxmB+fcvLBZSLQOn8NHS24
         bxb/2QdGb167qnbYVd1/1fKMinpTe42d9B35XqQbruihF9Xuvmbh3ua5cRCmiNWXfduZ
         8MElDM+sXYos9AVC6427SZsxMKRth1uidrjSFlzl8CQOexHQiHH7jWO/CEkP7ER+vMbM
         lprkQbtRpDXxGkHbLRI0omzkhGlWNICmaBx7AcEajsFh0ky4LrjSV7n3/8vFgsA6/z4w
         XKJQ==
X-Gm-Message-State: ACgBeo3Az7bNcF1E2svywC36GTEj3rvloZzkiOTiqutclDJbWK6KgPoz
        8Ji/6WYFBgP0ED0zkXB98WKdAYbGjnG2vw==
X-Google-Smtp-Source: AA6agR7GEZzDTz56S0z9ZFwwo3+8A2cJS+hBXK4FDB5SFen3ixUf21xrVf8m+nkxp75ju1W8OqgypD5lC+ctAw==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a17:90b:a14:b0:1fa:bc6e:e5e8 with SMTP id
 gg20-20020a17090b0a1400b001fabc6ee5e8mr118633pjb.1.1661385933916; Wed, 24 Aug
 2022 17:05:33 -0700 (PDT)
Date:   Thu, 25 Aug 2022 00:05:05 +0000
In-Reply-To: <20220825000506.239406-1-shakeelb@google.com>
Message-Id: <20220825000506.239406-3-shakeelb@google.com>
Mime-Version: 1.0
References: <20220825000506.239406-1-shakeelb@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 2/3] mm: page_counter: rearrange struct page_counter fields
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With memcg v2 enabled, memcg->memory.usage is a very hot member for
the workloads doing memcg charging on multiple CPUs concurrently.
Particularly the network intensive workloads. In addition, there is a
false cache sharing between memory.usage and memory.high on the charge
path. This patch moves the usage into a separate cacheline and move all
the read most fields into separate cacheline.

To evaluate the impact of this optimization, on a 72 CPUs machine, we
ran the following workload in a three level of cgroup hierarchy.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
Without (6.0-rc1)	10482.7 Mbps
With patch		12413.7 Mbps (18.4% improvement)

With the patch, the throughput improved by 18.4%.

One side-effect of this patch is the increase in the size of struct
mem_cgroup. For example with this patch on 64 bit build, the size of
struct mem_cgroup increased from 4032 bytes to 4416 bytes. However for
the performance improvement, this additional size is worth it. In
addition there are opportunities to reduce the size of struct
mem_cgroup like deprecation of kmem and tcpmem page counters and
better packing.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
---
Changes since v1:
- Updated the commit message
- Make struct page_counter cache align.

 include/linux/page_counter.h | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 679591301994..78a1c934e416 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -3,15 +3,26 @@
 #define _LINUX_PAGE_COUNTER_H
 
 #include <linux/atomic.h>
+#include <linux/cache.h>
 #include <linux/kernel.h>
 #include <asm/page.h>
 
+#if defined(CONFIG_SMP)
+struct pc_padding {
+	char x[0];
+} ____cacheline_internodealigned_in_smp;
+#define PC_PADDING(name)	struct pc_padding name
+#else
+#define PC_PADDING(name)
+#endif
+
 struct page_counter {
+	/*
+	 * Make sure 'usage' does not share cacheline with any other field. The
+	 * memcg->memory.usage is a hot member of struct mem_cgroup.
+	 */
 	atomic_long_t usage;
-	unsigned long min;
-	unsigned long low;
-	unsigned long high;
-	unsigned long max;
+	PC_PADDING(_pad1_);
 
 	/* effective memory.min and memory.min usage tracking */
 	unsigned long emin;
@@ -23,18 +34,18 @@ struct page_counter {
 	atomic_long_t low_usage;
 	atomic_long_t children_low_usage;
 
-	/* legacy */
 	unsigned long watermark;
 	unsigned long failcnt;
 
-	/*
-	 * 'parent' is placed here to be far from 'usage' to reduce
-	 * cache false sharing, as 'usage' is written mostly while
-	 * parent is frequently read for cgroup's hierarchical
-	 * counting nature.
-	 */
+	/* Keep all the read most fields in a separete cacheline. */
+	PC_PADDING(_pad2_);
+
+	unsigned long min;
+	unsigned long low;
+	unsigned long high;
+	unsigned long max;
 	struct page_counter *parent;
-};
+} ____cacheline_internodealigned_in_smp;
 
 #if BITS_PER_LONG == 32
 #define PAGE_COUNTER_MAX LONG_MAX
-- 
2.37.1.595.g718a3a8f04-goog

