Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB25E4E60F2
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 10:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349151AbiCXJQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 05:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349174AbiCXJQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 05:16:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68704424AF
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 02:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648113316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qEVt4cfO169G8sdVkVrrv3t56hidkly+9umoAn8SqMQ=;
        b=Sae7NxIoKi7UqAbKyZ0MV4x4/of3GZ6sHY/nyQxYIfaUsX+1QP20TRMM/IRJfpSFjY23aK
        pZce8geV/EGag5GCmlzHcxEPwafOJuhnPe6D5tvJiBq2uItcHaUzHp2QAdCG35BxlFcoDi
        JVNQoFW2CMscEV1Taaw1s7kBlUe0E1U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-pEsGfTXBN1SQXoEpdTjTbQ-1; Thu, 24 Mar 2022 05:15:11 -0400
X-MC-Unique: pEsGfTXBN1SQXoEpdTjTbQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF44E101AA45;
        Thu, 24 Mar 2022 09:15:10 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C5252027EB4;
        Thu, 24 Mar 2022 09:15:03 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 36C591C0276; Thu, 24 Mar 2022 10:15:02 +0100 (CET)
From:   Artem Savkov <asavkov@redhat.com>
To:     tglx@linutronix.de, jpoimboe@redhat.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH v2 1/2] timer: introduce upper bound timers
Date:   Thu, 24 Mar 2022 10:14:59 +0100
Message-Id: <20220324091500.2638745-2-asavkov@redhat.com>
In-Reply-To: <20220324091500.2638745-1-asavkov@redhat.com>
References: <20220323184026.wkj55y55jbeumngs@treble>
 <20220324091500.2638745-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

This commit adds TIMER_UPPER_BOUND flag which allows creation of timers
that would expire at most at specified time or earlier.

This was previously discussed here:
https://lore.kernel.org/all/20210302001054.4qgrvnkltvkgikzr@treble/T/#u

Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 include/linux/timer.h |  6 +++++-
 kernel/time/timer.c   | 36 ++++++++++++++++++++++--------------
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index fda13c9d1256..4b2456501be6 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -60,6 +60,9 @@ struct timer_list {
  * function is invoked via mod_timer() or add_timer().  If the timer
  * should be placed on a particular CPU, then add_timer_on() has to be
  * used.
+ *
+ * @TIMER_UPPER_BOUND: Unlike normal timers which trigger at specified time or
+ * later, upper bound timer will expire at most at specified time or earlier.
  */
 #define TIMER_CPUMASK		0x0003FFFF
 #define TIMER_MIGRATING		0x00040000
@@ -67,7 +70,8 @@ struct timer_list {
 #define TIMER_DEFERRABLE	0x00080000
 #define TIMER_PINNED		0x00100000
 #define TIMER_IRQSAFE		0x00200000
-#define TIMER_INIT_FLAGS	(TIMER_DEFERRABLE | TIMER_PINNED | TIMER_IRQSAFE)
+#define TIMER_UPPER_BOUND	0x00400000
+#define TIMER_INIT_FLAGS	(TIMER_DEFERRABLE | TIMER_PINNED | TIMER_IRQSAFE | TIMER_UPPER_BOUND)
 #define TIMER_ARRAYSHIFT	22
 #define TIMER_ARRAYMASK		0xFFC00000
 
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 85f1021ad459..f4965644d728 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -491,7 +491,7 @@ static inline void timer_set_idx(struct timer_list *timer, unsigned int idx)
  * time.
  */
 static inline unsigned calc_index(unsigned long expires, unsigned lvl,
-				  unsigned long *bucket_expiry)
+				  unsigned long *bucket_expiry, bool upper_bound)
 {
 
 	/*
@@ -501,34 +501,39 @@ static inline unsigned calc_index(unsigned long expires, unsigned lvl,
 	 * - Truncation of the expiry time in the outer wheel levels
 	 *
 	 * Round up with level granularity to prevent this.
+	 * Do not perform round up in case of upper bound timer.
 	 */
-	expires = (expires + LVL_GRAN(lvl)) >> LVL_SHIFT(lvl);
+	if (upper_bound)
+		expires = expires >> LVL_SHIFT(lvl);
+	else
+		expires = (expires + LVL_GRAN(lvl)) >> LVL_SHIFT(lvl);
+
 	*bucket_expiry = expires << LVL_SHIFT(lvl);
 	return LVL_OFFS(lvl) + (expires & LVL_MASK);
 }
 
 static int calc_wheel_index(unsigned long expires, unsigned long clk,
-			    unsigned long *bucket_expiry)
+			    unsigned long *bucket_expiry, bool upper_bound)
 {
 	unsigned long delta = expires - clk;
 	unsigned int idx;
 
 	if (delta < LVL_START(1)) {
-		idx = calc_index(expires, 0, bucket_expiry);
+		idx = calc_index(expires, 0, bucket_expiry, upper_bound);
 	} else if (delta < LVL_START(2)) {
-		idx = calc_index(expires, 1, bucket_expiry);
+		idx = calc_index(expires, 1, bucket_expiry, upper_bound);
 	} else if (delta < LVL_START(3)) {
-		idx = calc_index(expires, 2, bucket_expiry);
+		idx = calc_index(expires, 2, bucket_expiry, upper_bound);
 	} else if (delta < LVL_START(4)) {
-		idx = calc_index(expires, 3, bucket_expiry);
+		idx = calc_index(expires, 3, bucket_expiry, upper_bound);
 	} else if (delta < LVL_START(5)) {
-		idx = calc_index(expires, 4, bucket_expiry);
+		idx = calc_index(expires, 4, bucket_expiry, upper_bound);
 	} else if (delta < LVL_START(6)) {
-		idx = calc_index(expires, 5, bucket_expiry);
+		idx = calc_index(expires, 5, bucket_expiry, upper_bound);
 	} else if (delta < LVL_START(7)) {
-		idx = calc_index(expires, 6, bucket_expiry);
+		idx = calc_index(expires, 6, bucket_expiry, upper_bound);
 	} else if (LVL_DEPTH > 8 && delta < LVL_START(8)) {
-		idx = calc_index(expires, 7, bucket_expiry);
+		idx = calc_index(expires, 7, bucket_expiry, upper_bound);
 	} else if ((long) delta < 0) {
 		idx = clk & LVL_MASK;
 		*bucket_expiry = clk;
@@ -540,7 +545,8 @@ static int calc_wheel_index(unsigned long expires, unsigned long clk,
 		if (delta >= WHEEL_TIMEOUT_CUTOFF)
 			expires = clk + WHEEL_TIMEOUT_MAX;
 
-		idx = calc_index(expires, LVL_DEPTH - 1, bucket_expiry);
+		idx = calc_index(expires, LVL_DEPTH - 1, bucket_expiry,
+				 upper_bound);
 	}
 	return idx;
 }
@@ -607,7 +613,8 @@ static void internal_add_timer(struct timer_base *base, struct timer_list *timer
 	unsigned long bucket_expiry;
 	unsigned int idx;
 
-	idx = calc_wheel_index(timer->expires, base->clk, &bucket_expiry);
+	idx = calc_wheel_index(timer->expires, base->clk, &bucket_expiry,
+			       timer->flags & TIMER_UPPER_BOUND);
 	enqueue_timer(base, timer, idx, bucket_expiry);
 }
 
@@ -1000,7 +1007,8 @@ __mod_timer(struct timer_list *timer, unsigned long expires, unsigned int option
 		}
 
 		clk = base->clk;
-		idx = calc_wheel_index(expires, clk, &bucket_expiry);
+		idx = calc_wheel_index(expires, clk, &bucket_expiry,
+				       timer->flags & TIMER_UPPER_BOUND);
 
 		/*
 		 * Retrieve and compare the array index of the pending
-- 
2.34.1

