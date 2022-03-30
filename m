Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1A84EBCA5
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 10:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244280AbiC3IW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 04:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244308AbiC3IWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 04:22:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0E9230F52
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 01:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648628468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tz0siigGtQofb7cxDXPZMYsGDoU6AwwuCe+CGjU+qdY=;
        b=b1L5h1gfpsSiY3+usvQ65BsRwL9EmNKknV3iRiiGWOLDE9YxhpHKIXvgHmJCTAsksHw/3I
        NAEnfUkgR/JlSzAfW2GTjKgnNXy4P0cAYNBSgbCsP79/axN1LJd7R7ovbd+2G4l3HNHLjE
        fuDLQvRNiOjrYQxyCJggYiJv42URjWM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-1kVvoYGAPXu0VQdaD07N5Q-1; Wed, 30 Mar 2022 04:21:04 -0400
X-MC-Unique: 1kVvoYGAPXu0VQdaD07N5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65620100BAA7;
        Wed, 30 Mar 2022 08:20:52 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD804400E43D;
        Wed, 30 Mar 2022 08:20:49 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id ABFD41C0136; Wed, 30 Mar 2022 10:20:46 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        asavkov@redhat.com, Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        dsahern@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] timer: add a function to adjust timeouts to be upper bound
Date:   Wed, 30 Mar 2022 10:20:45 +0200
Message-Id: <20220330082046.3512424-2-asavkov@redhat.com>
In-Reply-To: <20220330082046.3512424-1-asavkov@redhat.com>
References: <87zglcfmcv.ffs@tglx>
 <20220330082046.3512424-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current timer wheel implementation is optimized for performance and
energy usage but lacks in precision. This, normally, is not a problem as
most timers that use timer wheel are used for timeouts and thus rarely
expire, instead they often get canceled or modified before expiration.
Even when they don't, expiring a bit late is not an issue for timeout
timers.

TCP keepalive timer is a special case, it's aim is to prevent timeouts,
so triggering earlier rather than later is desired behavior. In a
reported case the user had a 3600s keepalive timer for preventing firewall
disconnects (on a 3650s interval). They observed keepalive timers coming
in up to four minutes late, causing unexpected disconnects.

This commit adds upper_bound_timeout() function that takes a relative
timeout and adjusts it based on timer wheel granularity so that supplied
value effectively becomes an upper bound for the timer.

This was previously discussed here:
https://lore.kernel.org/all/20210302001054.4qgrvnkltvkgikzr@treble/T/#u

Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 include/linux/timer.h |  1 +
 kernel/time/timer.c   | 92 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index fda13c9d1256c..b209d31d543f0 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -168,6 +168,7 @@ static inline int timer_pending(const struct timer_list * timer)
 	return !hlist_unhashed_lockless(&timer->entry);
 }
 
+extern unsigned long upper_bound_timeout(unsigned long timeout);
 extern void add_timer_on(struct timer_list *timer, int cpu);
 extern int del_timer(struct timer_list * timer);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 85f1021ad4595..76d4f26c991be 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -507,28 +507,38 @@ static inline unsigned calc_index(unsigned long expires, unsigned lvl,
 	return LVL_OFFS(lvl) + (expires & LVL_MASK);
 }
 
-static int calc_wheel_index(unsigned long expires, unsigned long clk,
-			    unsigned long *bucket_expiry)
+static inline int get_wheel_lvl(unsigned long delta)
 {
-	unsigned long delta = expires - clk;
-	unsigned int idx;
-
 	if (delta < LVL_START(1)) {
-		idx = calc_index(expires, 0, bucket_expiry);
+		return 0;
 	} else if (delta < LVL_START(2)) {
-		idx = calc_index(expires, 1, bucket_expiry);
+		return 1;
 	} else if (delta < LVL_START(3)) {
-		idx = calc_index(expires, 2, bucket_expiry);
+		return 2;
 	} else if (delta < LVL_START(4)) {
-		idx = calc_index(expires, 3, bucket_expiry);
+		return 3;
 	} else if (delta < LVL_START(5)) {
-		idx = calc_index(expires, 4, bucket_expiry);
+		return 4;
 	} else if (delta < LVL_START(6)) {
-		idx = calc_index(expires, 5, bucket_expiry);
+		return 5;
 	} else if (delta < LVL_START(7)) {
-		idx = calc_index(expires, 6, bucket_expiry);
+		return 6;
 	} else if (LVL_DEPTH > 8 && delta < LVL_START(8)) {
-		idx = calc_index(expires, 7, bucket_expiry);
+		return 7;
+	}
+
+	return -1;
+}
+
+static int calc_wheel_index(unsigned long expires, unsigned long clk,
+			    unsigned long *bucket_expiry)
+{
+	unsigned long delta = expires - clk;
+	unsigned int idx;
+	int lvl = get_wheel_lvl(delta);
+
+	if (lvl >= 0) {
+		idx = calc_index(expires, lvl, bucket_expiry);
 	} else if ((long) delta < 0) {
 		idx = clk & LVL_MASK;
 		*bucket_expiry = clk;
@@ -545,6 +555,62 @@ static int calc_wheel_index(unsigned long expires, unsigned long clk,
 	return idx;
 }
 
+/**
+ * upper_bound_timeout - return granularity-adjusted timeout
+ * @timeout: timeout value in jiffies
+ *
+ * This function return supplied timeout adjusted based on timer wheel
+ * granularity effectively making supplied value an upper bound at which the
+ * timer will expire.
+ */
+unsigned long upper_bound_timeout(unsigned long timeout)
+{
+	int lvl = get_wheel_lvl(timeout);
+
+	if (lvl < 0) {
+		if ((long) timeout < 0) {
+			/*
+			 * This will expire immediately so no adjustment
+			 * needed.
+			 */
+			return timeout;
+		} else {
+			if (timeout > WHEEL_TIMEOUT_CUTOFF)
+				timeout = WHEEL_TIMEOUT_CUTOFF;
+			lvl = LVL_DEPTH - 1;
+		}
+	}
+
+	if (timeout - LVL_GRAN(lvl) < LVL_START(lvl)) {
+		/*
+		 * Beginning of each level is a special case, we can't just
+		 * subtract LVL_GRAN(lvl) because then timeout ends up on a
+		 * previous level and is guaranteed to fire off early. We can't
+		 * mitigate this completely, but we can try to minimize the
+		 * margin.
+		 */
+		if (timeout - LVL_GRAN(lvl - 1) < LVL_START(lvl)) {
+			/*
+			 * If timeout is within previous level's granularity
+			 * adjust timeout using that level's granularity.
+			 */
+			return timeout - LVL_GRAN(lvl - 1);
+		} else {
+			/*
+			 * If LVL_GRAN(lvl - 1) < timeout < LVL_GRAN(lvl)
+			 * the best we can do is to set timeout to the end of
+			 * previous level. This means that the timer will
+			 * trigger early. In worst case it will be _at least_
+			 * (LVL_GRAN(lvl) - LVL_GRAN(lvl -1)) jiffies early.
+			 */
+			return LVL_START(lvl) - 1;
+		}
+	} else {
+		return timeout - LVL_GRAN(lvl);
+	}
+}
+EXPORT_SYMBOL(upper_bound_timeout);
+
 static void
 trigger_dyntick_cpu(struct timer_base *base, struct timer_list *timer)
 {
-- 
2.34.1

