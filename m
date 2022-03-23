Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC4A4E511D
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 12:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243796AbiCWLSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 07:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241420AbiCWLSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 07:18:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 756D678922
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 04:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648034210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zX8hk0o/ML0CgrkxCRUDQ1+pQWlUttQZxkh67eAZPkA=;
        b=A9Pz8e7kIV46rP3LuSQhwGnXIPB4SfHTfdz6f1zM3qoaipAciZ8Ckakuf7LYbgZudm3G+p
        hH+zviEZhEHpB9HNNdEUuIxR36wTY4FsC4I2xi1w0rI/zAOSRj9BL39//jxhw7ZoWM1aOY
        P1hO/STgJR3mg2wpiCulo8yHOTdZw90=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-5olG-XexMN-QXjc4frN5KQ-1; Wed, 23 Mar 2022 07:16:47 -0400
X-MC-Unique: 5olG-XexMN-QXjc4frN5KQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFD9738009EF;
        Wed, 23 Mar 2022 11:16:46 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C4931121331;
        Wed, 23 Mar 2022 11:16:46 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 559461C0042; Wed, 23 Mar 2022 12:16:45 +0100 (CET)
From:   Artem Savkov <asavkov@redhat.com>
To:     tglx@linutronix.de, jpoimboe@redhat.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH 1/2] timer: introduce upper bound timers
Date:   Wed, 23 Mar 2022 12:16:41 +0100
Message-Id: <20220323111642.2517885-2-asavkov@redhat.com>
In-Reply-To: <20220323111642.2517885-1-asavkov@redhat.com>
References: <20220323111642.2517885-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add TIMER_UPPER_BOUND flag which allows creation of timers that would
expire at most at specified time or earlier.

This was previously discussed here:
https://lore.kernel.org/all/20210302001054.4qgrvnkltvkgikzr@treble/T/#u

Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 include/linux/timer.h |  3 ++-
 kernel/time/timer.c   | 36 ++++++++++++++++++++++--------------
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index fda13c9d1256..9b0963f49528 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -67,7 +67,8 @@ struct timer_list {
 #define TIMER_DEFERRABLE	0x00080000
 #define TIMER_PINNED		0x00100000
 #define TIMER_IRQSAFE		0x00200000
-#define TIMER_INIT_FLAGS	(TIMER_DEFERRABLE | TIMER_PINNED | TIMER_IRQSAFE)
+#define TIMER_UPPER_BOUND	0x00400000
+#define TIMER_INIT_FLAGS	(TIMER_DEFERRABLE | TIMER_PINNED | TIMER_IRQSAFE | TIMER_UPPER_BOUND)
 #define TIMER_ARRAYSHIFT	22
 #define TIMER_ARRAYMASK		0xFFC00000
 
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 85f1021ad459..60253ad9ed86 100644
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
+				upper_bound);
 	}
 	return idx;
 }
@@ -607,7 +613,8 @@ static void internal_add_timer(struct timer_base *base, struct timer_list *timer
 	unsigned long bucket_expiry;
 	unsigned int idx;
 
-	idx = calc_wheel_index(timer->expires, base->clk, &bucket_expiry);
+	idx = calc_wheel_index(timer->expires, base->clk, &bucket_expiry,
+			timer->flags & TIMER_UPPER_BOUND);
 	enqueue_timer(base, timer, idx, bucket_expiry);
 }
 
@@ -1000,7 +1007,8 @@ __mod_timer(struct timer_list *timer, unsigned long expires, unsigned int option
 		}
 
 		clk = base->clk;
-		idx = calc_wheel_index(expires, clk, &bucket_expiry);
+		idx = calc_wheel_index(expires, clk, &bucket_expiry,
+				timer->flags & TIMER_UPPER_BOUND);
 
 		/*
 		 * Retrieve and compare the array index of the pending
-- 
2.34.1

