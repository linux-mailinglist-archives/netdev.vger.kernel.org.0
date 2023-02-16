Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454A369977B
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBPObw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBPObv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:31:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1605C48E0A
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676557869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=faR/LEvxBhJu5MRBAakGXaa+HT/XVJ73vTZ1nw/pp04=;
        b=dvVr2rRifnL2uEO7z+sl4X3FDQMIj3FKgNRi5bDU0e9Gq8jCE+OLRESkuQYnNwdaHmlUXl
        ynN7nzQo2uzU/Ta83RwrsevHudbN+UmbGuTbZxvHuyjfPAEB5q8wl6Q3vtqlgrrPemMd4y
        +FBqmv+lqDZrGLuL+HbXLQAMvgHyn/4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-UETMjXflNDycmbLbyCQtHQ-1; Thu, 16 Feb 2023 09:31:05 -0500
X-MC-Unique: UETMjXflNDycmbLbyCQtHQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11A1087A9F4;
        Thu, 16 Feb 2023 14:31:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B307C492B0E;
        Thu, 16 Feb 2023 14:31:01 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     yangbo.lu@nxp.com, richardcochran@gmail.com
Cc:     mlichvar@redhat.com, gerhard@engleder-embedded.com,
        habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH net] ptp: vclock: use mutex to fix "sleep on atomic" bug
Date:   Thu, 16 Feb 2023 15:30:51 +0100
Message-Id: <20230216143051.23348-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vclocks were using spinlocks to protect access to its timecounter and
cyclecounter. Access to timecounter/cyclecounter is backed by the same
driver callbacks that are used for non-virtual PHCs, but the usage of
the spinlock imposes a new limitation that didn't exist previously: now
they're called in atomic context so they mustn't sleep.

Some drivers like sfc or ice may sleep on these callbacks, causing
errors like "BUG: scheduling while atomic: ptp5/25223/0x00000002"

Fix it replacing the vclock's spinlock by a mutex. It fix the mentioned
bug and it doesn't introduce longer delays.

I've tested synchronizing various different combinations of clocks:
- vclock->sysclock
- sysclock->vclock
- vclock->vclock
- hardware PHC in different NIC -> vclock
- created 4 vclocks and launch 4 parallel phc2sys processes

In all cases, comparing the delays reported by phc2sys, they are in the
same range of values than before applying the patch.

Link: https://lore.kernel.org/netdev/69d0ff33-bd32-6aa5-d36c-fbdc3c01337c@redhat.com/
Fixes: 5d43f951b1ac ("ptp: add ptp virtual clock driver framework")
Reported-by: Yalin Li <yalli@redhat.com>
Suggested-by: Richard Cochran <richardcochran@gmail.com>
Tested-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/ptp/ptp_private.h |  2 +-
 drivers/ptp/ptp_vclock.c  | 44 +++++++++++++++++++--------------------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 77918a2c6701..75f58fc468a7 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -66,7 +66,7 @@ struct ptp_vclock {
 	struct hlist_node vclock_hash_node;
 	struct cyclecounter cc;
 	struct timecounter tc;
-	spinlock_t lock;	/* protects tc/cc */
+	struct mutex lock;	/* protects tc/cc */
 };
 
 /*
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 1c0ed4805c0a..eacaa7fad5dd 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -43,16 +43,16 @@ static void ptp_vclock_hash_del(struct ptp_vclock *vclock)
 static int ptp_vclock_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
-	unsigned long flags;
 	s64 adj;
 
 	adj = (s64)scaled_ppm << PTP_VCLOCK_FADJ_SHIFT;
 	adj = div_s64(adj, PTP_VCLOCK_FADJ_DENOMINATOR);
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock) < 0)
+		return -EINTR;
 	timecounter_read(&vclock->tc);
 	vclock->cc.mult = PTP_VCLOCK_CC_MULT + adj;
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	return 0;
 }
@@ -60,11 +60,11 @@ static int ptp_vclock_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 static int ptp_vclock_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
-	unsigned long flags;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock) < 0)
+		return -EINTR;
 	timecounter_adjtime(&vclock->tc, delta);
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	return 0;
 }
@@ -73,12 +73,12 @@ static int ptp_vclock_gettime(struct ptp_clock_info *ptp,
 			      struct timespec64 *ts)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
-	unsigned long flags;
 	u64 ns;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock) < 0)
+		return -EINTR;
 	ns = timecounter_read(&vclock->tc);
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 	*ts = ns_to_timespec64(ns);
 
 	return 0;
@@ -91,7 +91,6 @@ static int ptp_vclock_gettimex(struct ptp_clock_info *ptp,
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	struct ptp_clock *pptp = vclock->pclock;
 	struct timespec64 pts;
-	unsigned long flags;
 	int err;
 	u64 ns;
 
@@ -99,9 +98,10 @@ static int ptp_vclock_gettimex(struct ptp_clock_info *ptp,
 	if (err)
 		return err;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock) < 0)
+		return -EINTR;
 	ns = timecounter_cyc2time(&vclock->tc, timespec64_to_ns(&pts));
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	*ts = ns_to_timespec64(ns);
 
@@ -113,11 +113,11 @@ static int ptp_vclock_settime(struct ptp_clock_info *ptp,
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	u64 ns = timespec64_to_ns(ts);
-	unsigned long flags;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock) < 0)
+		return -EINTR;
 	timecounter_init(&vclock->tc, &vclock->cc, ns);
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	return 0;
 }
@@ -127,7 +127,6 @@ static int ptp_vclock_getcrosststamp(struct ptp_clock_info *ptp,
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	struct ptp_clock *pptp = vclock->pclock;
-	unsigned long flags;
 	int err;
 	u64 ns;
 
@@ -135,9 +134,10 @@ static int ptp_vclock_getcrosststamp(struct ptp_clock_info *ptp,
 	if (err)
 		return err;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock) < 0)
+		return -EINTR;
 	ns = timecounter_cyc2time(&vclock->tc, ktime_to_ns(xtstamp->device));
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	xtstamp->device = ns_to_ktime(ns);
 
@@ -205,7 +205,7 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 
 	INIT_HLIST_NODE(&vclock->vclock_hash_node);
 
-	spin_lock_init(&vclock->lock);
+	mutex_init(&vclock->lock);
 
 	vclock->clock = ptp_clock_register(&vclock->info, &pclock->dev);
 	if (IS_ERR_OR_NULL(vclock->clock)) {
@@ -269,7 +269,6 @@ ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 {
 	unsigned int hash = vclock_index % HASH_SIZE(vclock_hash);
 	struct ptp_vclock *vclock;
-	unsigned long flags;
 	u64 ns;
 	u64 vclock_ns = 0;
 
@@ -281,9 +280,10 @@ ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 		if (vclock->clock->index != vclock_index)
 			continue;
 
-		spin_lock_irqsave(&vclock->lock, flags);
+		if (mutex_lock_interruptible(&vclock->lock) < 0)
+			break;
 		vclock_ns = timecounter_cyc2time(&vclock->tc, ns);
-		spin_unlock_irqrestore(&vclock->lock, flags);
+		mutex_unlock(&vclock->lock);
 		break;
 	}
 
-- 
2.34.3

