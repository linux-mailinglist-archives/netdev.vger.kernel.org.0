Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5409C639823
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 20:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiKZTWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 14:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiKZTWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 14:22:07 -0500
X-Greylist: delayed 588 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 26 Nov 2022 11:22:05 PST
Received: from out-30.mta0.migadu.com (out-30.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C828619C03
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 11:22:05 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669489935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mld0Zf5BHHuTHmAamXf8kUapqnIfndf6LF73jgEUyOU=;
        b=JRT26BDvFyqYcCreQlbv+eRunjXarfdLgSQrSIN61868nvVAbKFfzCAPXP1pu6+7vfuQdd
        WyQDQUFYp/RCMRU6uZHcxzmr1bgQox4v5SK5bCluwdnbKPLCHupa2a077vEk/OaK8sx4/z
        /EOB1zmujUK1lo/QM2FLlP61uFm+QVU=
From:   andrey.konovalov@linux.dev
To:     Marco Elver <elver@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        kasan-dev@googlegroups.com, Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Florian Mayer <fmayer@google.com>,
        Jann Horn <jannh@google.com>,
        Mark Brand <markbrand@google.com>, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH v2 2/2] net, kasan: sample tagging of skb allocations with HW_TAGS
Date:   Sat, 26 Nov 2022 20:12:13 +0100
Message-Id: <7bf26d03fab8d99cdeea165990e9f2cf054b77d6.1669489329.git.andreyknvl@google.com>
In-Reply-To: <4c341c5609ed09ad6d52f937eeec28d142ff1f46.1669489329.git.andreyknvl@google.com>
References: <4c341c5609ed09ad6d52f937eeec28d142ff1f46.1669489329.git.andreyknvl@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>

As skb page_alloc allocations tend to be big, tagging and checking all
such allocations with Hardware Tag-Based KASAN introduces a significant
slowdown in testing scenarios that extensively use the network. This is
undesirable, as Hardware Tag-Based KASAN is intended to be used in
production and thus its performance impact is crucial.

Use __GFP_KASAN_SAMPLE flag for skb page_alloc allocations to make KASAN
use sampling and tag only some of these allocations.

When running a local loopback test on a testing MTE-enabled device in sync
mode, enabling Hardware Tag-Based KASAN intoduces a 50% slowdown. Applying
this patch and setting kasan.page_alloc.sampling to a value higher than 1
allows to lower the slowdown. The performance improvement saturates around
the sampling interval value of 10, which lowers the slowdown to 20%. The
slowdown in real scenarios will likely be better.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 net/core/skbuff.c | 4 ++--
 net/core/sock.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 88fa40571d0c..fdea87deee13 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6135,8 +6135,8 @@ struct sk_buff *alloc_skb_with_frags(unsigned long header_len,
 		while (order) {
 			if (npages >= 1 << order) {
 				page = alloc_pages((gfp_mask & ~__GFP_DIRECT_RECLAIM) |
-						   __GFP_COMP |
-						   __GFP_NOWARN,
+						   __GFP_COMP | __GFP_NOWARN |
+						   __GFP_KASAN_SAMPLE,
 						   order);
 				if (page)
 					goto fill_page;
diff --git a/net/core/sock.c b/net/core/sock.c
index a3ba0358c77c..f7d20070ad88 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2842,7 +2842,7 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 		/* Avoid direct reclaim but allow kswapd to wake */
 		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
 					  __GFP_COMP | __GFP_NOWARN |
-					  __GFP_NORETRY,
+					  __GFP_NORETRY | __GFP_KASAN_SAMPLE,
 					  SKB_FRAG_PAGE_ORDER);
 		if (likely(pfrag->page)) {
 			pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
-- 
2.25.1

