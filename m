Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EC25BAF77
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 16:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiIPOiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 10:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiIPOiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 10:38:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B338CB3B05
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 07:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 142B662AEB
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 14:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E749FC433D6;
        Fri, 16 Sep 2022 14:37:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LnCQmHO4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663339076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mua+0b5H+NElwb0CKAd3e/VcJ+8NdYN6XzBKnB38rG4=;
        b=LnCQmHO4LlyWA8Y0gPjOuFTqUBPE4GHrFV8PcAI/deGa/HXF0RVEHxFZjHOgW0aT5NFg2R
        OeEY3SMgE/Vwoa9qdSmtOzSrbSkLP8NxKElr4X5GzpEchsZBazJs1AwjU0QQGcTt6ICovv
        sFC2IuYVDOBQRaQvc7zLlWImlRL5VaI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d4dc207d (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 16 Sep 2022 14:37:56 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     kuba@kernel.org, pablo@netfilter.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 1/3] wireguard: ratelimiter: disable timings test by default
Date:   Fri, 16 Sep 2022 15:37:38 +0100
Message-Id: <20220916143740.831881-2-Jason@zx2c4.com>
In-Reply-To: <20220916143740.831881-1-Jason@zx2c4.com>
References: <20220916143740.831881-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A previous commit tried to make the ratelimiter timings test more
reliable but in the process made it less reliable on other
configurations. This is an impossible problem to solve without
increasingly ridiculous heuristics. And it's not even a problem that
actually needs to be solved in any comprehensive way, since this is only
ever used during development. So just cordon this off with a DEBUG_
ifdef, just like we do for the trie's randomized tests, so it can be
enabled while hacking on the code, and otherwise disabled in CI. In the
process we also revert 151c8e499f47.

Fixes: 151c8e499f47 ("wireguard: ratelimiter: use hrtimer in selftest")
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/selftest/ratelimiter.c | 25 ++++++++------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireguard/selftest/ratelimiter.c b/drivers/net/wireguard/selftest/ratelimiter.c
index ba87d294604f..d4bb40a695ab 100644
--- a/drivers/net/wireguard/selftest/ratelimiter.c
+++ b/drivers/net/wireguard/selftest/ratelimiter.c
@@ -6,29 +6,28 @@
 #ifdef DEBUG
 
 #include <linux/jiffies.h>
-#include <linux/hrtimer.h>
 
 static const struct {
 	bool result;
-	u64 nsec_to_sleep_before;
+	unsigned int msec_to_sleep_before;
 } expected_results[] __initconst = {
 	[0 ... PACKETS_BURSTABLE - 1] = { true, 0 },
 	[PACKETS_BURSTABLE] = { false, 0 },
-	[PACKETS_BURSTABLE + 1] = { true, NSEC_PER_SEC / PACKETS_PER_SECOND },
+	[PACKETS_BURSTABLE + 1] = { true, MSEC_PER_SEC / PACKETS_PER_SECOND },
 	[PACKETS_BURSTABLE + 2] = { false, 0 },
-	[PACKETS_BURSTABLE + 3] = { true, (NSEC_PER_SEC / PACKETS_PER_SECOND) * 2 },
+	[PACKETS_BURSTABLE + 3] = { true, (MSEC_PER_SEC / PACKETS_PER_SECOND) * 2 },
 	[PACKETS_BURSTABLE + 4] = { true, 0 },
 	[PACKETS_BURSTABLE + 5] = { false, 0 }
 };
 
 static __init unsigned int maximum_jiffies_at_index(int index)
 {
-	u64 total_nsecs = 2 * NSEC_PER_SEC / PACKETS_PER_SECOND / 3;
+	unsigned int total_msecs = 2 * MSEC_PER_SEC / PACKETS_PER_SECOND / 3;
 	int i;
 
 	for (i = 0; i <= index; ++i)
-		total_nsecs += expected_results[i].nsec_to_sleep_before;
-	return nsecs_to_jiffies(total_nsecs);
+		total_msecs += expected_results[i].msec_to_sleep_before;
+	return msecs_to_jiffies(total_msecs);
 }
 
 static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
@@ -43,12 +42,8 @@ static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
 	loop_start_time = jiffies;
 
 	for (i = 0; i < ARRAY_SIZE(expected_results); ++i) {
-		if (expected_results[i].nsec_to_sleep_before) {
-			ktime_t timeout = ktime_add(ktime_add_ns(ktime_get_coarse_boottime(), TICK_NSEC * 4 / 3),
-						    ns_to_ktime(expected_results[i].nsec_to_sleep_before));
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_hrtimeout_range_clock(&timeout, 0, HRTIMER_MODE_ABS, CLOCK_BOOTTIME);
-		}
+		if (expected_results[i].msec_to_sleep_before)
+			msleep(expected_results[i].msec_to_sleep_before);
 
 		if (time_is_before_jiffies(loop_start_time +
 					   maximum_jiffies_at_index(i)))
@@ -132,7 +127,7 @@ bool __init wg_ratelimiter_selftest(void)
 	if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_UBSAN))
 		return true;
 
-	BUILD_BUG_ON(NSEC_PER_SEC % PACKETS_PER_SECOND != 0);
+	BUILD_BUG_ON(MSEC_PER_SEC % PACKETS_PER_SECOND != 0);
 
 	if (wg_ratelimiter_init())
 		goto out;
@@ -172,7 +167,7 @@ bool __init wg_ratelimiter_selftest(void)
 	++test;
 #endif
 
-	for (trials = TRIALS_BEFORE_GIVING_UP;;) {
+	for (trials = TRIALS_BEFORE_GIVING_UP; IS_ENABLED(DEBUG_RATELIMITER_TIMINGS);) {
 		int test_count = 0, ret;
 
 		ret = timings_test(skb4, hdr4, skb6, hdr6, &test_count);
-- 
2.37.3

