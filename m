Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD204F7832
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242342AbiDGHy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242330AbiDGHy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:54:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86BEF1C4B17
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649317975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NeKgo4zQVrdq6IcW5Wmd0hkOphqBpf2zABHpDxlt6y4=;
        b=cNyPRgz/jqo+LBAZqzfKiyxKOt5VYaTCX4E2A23Y8Uc5NRy51S2zh+Jd9CjtOl2jjUJ3wS
        mmA81NfdRG9WWWYMu75CTDmk5Q80hgxxQyG6KMXMOlv2dSnbndLCGdiB/q/XL/pZlGehp4
        wVN3VF5gUZdsmV3V1hFrUGEA2/HCzT0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-8I66qEciNCybx5-R8dhIhA-1; Thu, 07 Apr 2022 03:52:54 -0400
X-MC-Unique: 8I66qEciNCybx5-R8dhIhA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35A863804091;
        Thu,  7 Apr 2022 07:52:48 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25E60C28119;
        Thu,  7 Apr 2022 07:52:45 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id EDE841C01A8; Thu,  7 Apr 2022 09:52:43 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH v4 1/2] timer: add a function to adjust timeouts to be upper bound
Date:   Thu,  7 Apr 2022 09:52:41 +0200
Message-Id: <20220407075242.118253-2-asavkov@redhat.com>
In-Reply-To: <20220407075242.118253-1-asavkov@redhat.com>
References: <871qyb35q4.ffs@tglx>
 <20220407075242.118253-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
 kernel/time/timer.c   | 68 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 56 insertions(+), 13 deletions(-)

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
index 85f1021ad4595..a645b62e257e2 100644
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
@@ -545,6 +555,38 @@ static int calc_wheel_index(unsigned long expires, unsigned long clk,
 	return idx;
 }
 
+/**
+ * upper_bound_timeout - return granularity-adjusted timeout
+ * @timeout: timeout value in jiffies
+ *
+ * This function return supplied timeout adjusted based on timer wheel
+ * granularity effectively making supplied value an upper bound at which the
+ * timer will expire. Due to the way timer wheel works timeouts smaller than
+ * LVL_GRAN on their respecrive levels will be _at least_
+ * LVL_GRAN(lvl) - LVL_GRAN(lvl -1)) jiffies early.
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
+	return LVL_GRAN(lvl) > timeout ? 0 : timeout - LVL_GRAN(lvl);
+}
+EXPORT_SYMBOL(upper_bound_timeout);
+
 static void
 trigger_dyntick_cpu(struct timer_base *base, struct timer_list *timer)
 {
-- 
2.34.1

