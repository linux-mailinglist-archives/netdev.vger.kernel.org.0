Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059C2587CB7
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 14:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236716AbiHBM4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 08:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiHBM4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 08:56:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B024B7DD
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 05:56:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 540FAB81EFA
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 12:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFC2C433B5;
        Tue,  2 Aug 2022 12:56:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WgKgP+IO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1659444985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IBuUm247yyrJEHxfKP62BHIIjounyU4x8Yyk2UEXz4E=;
        b=WgKgP+IOQ0RM0dkcpANJlQGsAsV1odeMdQDLH4Vk09miHLdVYW3zwVzvJazQSCyHhjeVMx
        lWnTwNV+9AcAGgqOy7D2G7NbHYJy9ECqots7iGl1WGmdd58ryRVMH097/RYe9O5s6zt5JL
        dU8pu9qTJmRH5bMzCmC8D8kGgaz4fEc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 44e7471c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 2 Aug 2022 12:56:25 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     kuba@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH next-next 1/4] wireguard: ratelimiter: use hrtimer in selftest
Date:   Tue,  2 Aug 2022 14:56:10 +0200
Message-Id: <20220802125613.340848-2-Jason@zx2c4.com>
In-Reply-To: <20220802125613.340848-1-Jason@zx2c4.com>
References: <20220802125613.340848-1-Jason@zx2c4.com>
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

Using msleep() is problematic because it's compared against
ratelimiter.c's ktime_get_coarse_boottime_ns(), which means on systems
with slow jiffies (such as UML's forced HZ=100), the result is
inaccurate. So switch to using schedule_hrtimeout().

However, hrtimer gives us access only to the traditional posix timers,
and none of the _COARSE variants. So now, rather than being too
imprecise like jiffies, it's too precise.

One solution would be to give it a large "range" value, but this will
still fire early on a loaded system. A better solution is to align the
timeout to the actual coarse timer, and then round up to the nearest
tick, plus change.

So add the timeout to the current coarse time, and then
schedule_hrtimer() until the absolute computed time.

This should hopefully reduce flakes in CI as well. Note that we keep the
retry loop in case the entire function is running behind, because the
test could still be scheduled out, by either the kernel or by the
hypervisor's kernel, in which case restarting the test and hoping to not
be scheduled out still helps.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/selftest/ratelimiter.c | 25 +++++++++++---------
 kernel/time/hrtimer.c                        |  1 +
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireguard/selftest/ratelimiter.c b/drivers/net/wireguard/selftest/ratelimiter.c
index 007cd4457c5f..ba87d294604f 100644
--- a/drivers/net/wireguard/selftest/ratelimiter.c
+++ b/drivers/net/wireguard/selftest/ratelimiter.c
@@ -6,28 +6,29 @@
 #ifdef DEBUG
 
 #include <linux/jiffies.h>
+#include <linux/hrtimer.h>
 
 static const struct {
 	bool result;
-	unsigned int msec_to_sleep_before;
+	u64 nsec_to_sleep_before;
 } expected_results[] __initconst = {
 	[0 ... PACKETS_BURSTABLE - 1] = { true, 0 },
 	[PACKETS_BURSTABLE] = { false, 0 },
-	[PACKETS_BURSTABLE + 1] = { true, MSEC_PER_SEC / PACKETS_PER_SECOND },
+	[PACKETS_BURSTABLE + 1] = { true, NSEC_PER_SEC / PACKETS_PER_SECOND },
 	[PACKETS_BURSTABLE + 2] = { false, 0 },
-	[PACKETS_BURSTABLE + 3] = { true, (MSEC_PER_SEC / PACKETS_PER_SECOND) * 2 },
+	[PACKETS_BURSTABLE + 3] = { true, (NSEC_PER_SEC / PACKETS_PER_SECOND) * 2 },
 	[PACKETS_BURSTABLE + 4] = { true, 0 },
 	[PACKETS_BURSTABLE + 5] = { false, 0 }
 };
 
 static __init unsigned int maximum_jiffies_at_index(int index)
 {
-	unsigned int total_msecs = 2 * MSEC_PER_SEC / PACKETS_PER_SECOND / 3;
+	u64 total_nsecs = 2 * NSEC_PER_SEC / PACKETS_PER_SECOND / 3;
 	int i;
 
 	for (i = 0; i <= index; ++i)
-		total_msecs += expected_results[i].msec_to_sleep_before;
-	return msecs_to_jiffies(total_msecs);
+		total_nsecs += expected_results[i].nsec_to_sleep_before;
+	return nsecs_to_jiffies(total_nsecs);
 }
 
 static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
@@ -42,8 +43,12 @@ static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
 	loop_start_time = jiffies;
 
 	for (i = 0; i < ARRAY_SIZE(expected_results); ++i) {
-		if (expected_results[i].msec_to_sleep_before)
-			msleep(expected_results[i].msec_to_sleep_before);
+		if (expected_results[i].nsec_to_sleep_before) {
+			ktime_t timeout = ktime_add(ktime_add_ns(ktime_get_coarse_boottime(), TICK_NSEC * 4 / 3),
+						    ns_to_ktime(expected_results[i].nsec_to_sleep_before));
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_hrtimeout_range_clock(&timeout, 0, HRTIMER_MODE_ABS, CLOCK_BOOTTIME);
+		}
 
 		if (time_is_before_jiffies(loop_start_time +
 					   maximum_jiffies_at_index(i)))
@@ -127,7 +132,7 @@ bool __init wg_ratelimiter_selftest(void)
 	if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_UBSAN))
 		return true;
 
-	BUILD_BUG_ON(MSEC_PER_SEC % PACKETS_PER_SECOND != 0);
+	BUILD_BUG_ON(NSEC_PER_SEC % PACKETS_PER_SECOND != 0);
 
 	if (wg_ratelimiter_init())
 		goto out;
@@ -176,7 +181,6 @@ bool __init wg_ratelimiter_selftest(void)
 				test += test_count;
 				goto err;
 			}
-			msleep(500);
 			continue;
 		} else if (ret < 0) {
 			test += test_count;
@@ -195,7 +199,6 @@ bool __init wg_ratelimiter_selftest(void)
 				test += test_count;
 				goto err;
 			}
-			msleep(50);
 			continue;
 		}
 		test += test_count;
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 0ea8702eb516..23af5eca11b1 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2311,6 +2311,7 @@ schedule_hrtimeout_range_clock(ktime_t *expires, u64 delta,
 
 	return !t.task ? 0 : -EINTR;
 }
+EXPORT_SYMBOL_GPL(schedule_hrtimeout_range_clock);
 
 /**
  * schedule_hrtimeout_range - sleep until timeout
-- 
2.35.1

