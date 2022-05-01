Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B1C516407
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345716AbiEALWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345629AbiEALWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:22:17 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185B3583A1
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 04:18:52 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id a21so13769476edb.1
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 04:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0zq9xRvCzkWBQI5fSrd7bckEJpq28r5hzcGjbCVkbmI=;
        b=I2pZvEVmcDtM+hBOl1d94PfJjfi94MRGBSfJ8+Oaxe7vdTnrDEOwRYQsQwhbMpOLyo
         XmgWz8NLPsHpOjjbsoUSwO2ys5Pgi59PomiBIHnH3eB5w1ceqvDMldF16jCDIys++a2B
         +NodPfb6PgmhcDQsKUSYeH2lHu7Eg5/f/lXoLK6ZekO21l4PmXwJpORWbROw7GW/66Qm
         PVlm4otx8c1RwPj4l6UNu1h1YOQQpy8o6JLR+q/VrXa7NlM0ylMzV0ni2vbactPCc9XY
         elir2OrNlgVNdaENMfpNilghZhIM1Q4nGPx/BmkWwsNSMBPxOjTz8Dm13D8iETa8Cbj4
         ZTYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0zq9xRvCzkWBQI5fSrd7bckEJpq28r5hzcGjbCVkbmI=;
        b=kdCUa1QEhoIaV5uBQ8IyrrgacT4/ukNKGZN/Fhkf8FjMxk+IBjk3qfJXkF3/4Whuyo
         wYZ39VseCuEfc4CUXbw2P1GUYUf0Yxwenlh6rVP8cufhVlXb6bZW9HYxpglGIg7hjIa7
         xUxKTWPr3Kd7qxzFUzwAjnB8b2aZWWKBhndS2j4cg5z9eY2Wp+af8VaivSbUA96YbK0j
         fntnMPPeyR20dtZIfr/cv8Rq0JX/mydoJdqOH877tkjdhi/8dtAARxyvkpD35rfTHaAq
         J+ozpMw7n1M1NyIzDHMmjBYgwdhOqqGUvfVcMleCQCDvIN38j9qG2mEApnwPUVuoDrXu
         28Dg==
X-Gm-Message-State: AOAM532nprX9L8nhuL9ab+YDCMFkQU53tGhYNLTk3R4jfyAbbvX82v2S
        sLmofNxkmIYERJ6aWt2+Wfk8aA==
X-Google-Smtp-Source: ABdhPJyz5PmDdDxM4SRBiT7HL61bLM/YL956b5IsKPheUPXXMEMAxl4Cw73XuhBGXjKJQRsNIGKElQ==
X-Received: by 2002:aa7:da4a:0:b0:425:d676:9684 with SMTP id w10-20020aa7da4a000000b00425d6769684mr8393511eds.248.1651403930630;
        Sun, 01 May 2022 04:18:50 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id mm29-20020a170906cc5d00b006f3ef214dcesm2508630ejb.52.2022.05.01.04.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 04:18:50 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 5/6] ptp: Speed up vclock lookup
Date:   Sun,  1 May 2022 13:18:35 +0200
Message-Id: <20220501111836.10910-6-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220501111836.10910-1-gerhard@engleder-embedded.com>
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp_convert_timestamp() is called in the RX path of network messages.
The current implementation takes ~5000ns on 1.2GHz A53. This is too much
for the hot path of packet processing.

Introduce hash table for fast vclock lookup in ptp_convert_timestamp().
The execution time of ptp_convert_timestamp() is reduced to ~700ns on
1.2GHz A53.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/ptp/ptp_private.h |  1 +
 drivers/ptp/ptp_vclock.c  | 66 ++++++++++++++++++++++++++++-----------
 2 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index ab47c10b3874..77918a2c6701 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -63,6 +63,7 @@ struct ptp_vclock {
 	struct ptp_clock *pclock;
 	struct ptp_clock_info info;
 	struct ptp_clock *clock;
+	struct hlist_node vclock_hash_node;
 	struct cyclecounter cc;
 	struct timecounter tc;
 	spinlock_t lock;	/* protects tc/cc */
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index c30bcce2bb43..1c0ed4805c0a 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -5,6 +5,7 @@
  * Copyright 2021 NXP
  */
 #include <linux/slab.h>
+#include <linux/hashtable.h>
 #include "ptp_private.h"
 
 #define PTP_VCLOCK_CC_SHIFT		31
@@ -13,6 +14,32 @@
 #define PTP_VCLOCK_FADJ_DENOMINATOR	15625ULL
 #define PTP_VCLOCK_REFRESH_INTERVAL	(HZ * 2)
 
+/* protects vclock_hash addition/deletion */
+static DEFINE_SPINLOCK(vclock_hash_lock);
+
+static DEFINE_READ_MOSTLY_HASHTABLE(vclock_hash, 8);
+
+static void ptp_vclock_hash_add(struct ptp_vclock *vclock)
+{
+	spin_lock(&vclock_hash_lock);
+
+	hlist_add_head_rcu(&vclock->vclock_hash_node,
+			   &vclock_hash[vclock->clock->index % HASH_SIZE(vclock_hash)]);
+
+	spin_unlock(&vclock_hash_lock);
+}
+
+static void ptp_vclock_hash_del(struct ptp_vclock *vclock)
+{
+	spin_lock(&vclock_hash_lock);
+
+	hlist_del_init_rcu(&vclock->vclock_hash_node);
+
+	spin_unlock(&vclock_hash_lock);
+
+	synchronize_rcu();
+}
+
 static int ptp_vclock_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
@@ -176,6 +203,8 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 	snprintf(vclock->info.name, PTP_CLOCK_NAME_LEN, "ptp%d_virt",
 		 pclock->index);
 
+	INIT_HLIST_NODE(&vclock->vclock_hash_node);
+
 	spin_lock_init(&vclock->lock);
 
 	vclock->clock = ptp_clock_register(&vclock->info, &pclock->dev);
@@ -187,11 +216,15 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 	timecounter_init(&vclock->tc, &vclock->cc, 0);
 	ptp_schedule_worker(vclock->clock, PTP_VCLOCK_REFRESH_INTERVAL);
 
+	ptp_vclock_hash_add(vclock);
+
 	return vclock;
 }
 
 void ptp_vclock_unregister(struct ptp_vclock *vclock)
 {
+	ptp_vclock_hash_del(vclock);
+
 	ptp_clock_unregister(vclock->clock);
 	kfree(vclock);
 }
@@ -234,34 +267,29 @@ EXPORT_SYMBOL(ptp_get_vclocks_index);
 
 ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 {
-	char name[PTP_CLOCK_NAME_LEN] = "";
+	unsigned int hash = vclock_index % HASH_SIZE(vclock_hash);
 	struct ptp_vclock *vclock;
-	struct ptp_clock *ptp;
 	unsigned long flags;
-	struct device *dev;
 	u64 ns;
+	u64 vclock_ns = 0;
 
-	snprintf(name, PTP_CLOCK_NAME_LEN, "ptp%d", vclock_index);
-	dev = class_find_device_by_name(ptp_class, name);
-	if (!dev)
-		return 0;
+	ns = ktime_to_ns(*hwtstamp);
 
-	ptp = dev_get_drvdata(dev);
-	if (!ptp->is_virtual_clock) {
-		put_device(dev);
-		return 0;
-	}
+	rcu_read_lock();
 
-	vclock = info_to_vclock(ptp->info);
+	hlist_for_each_entry_rcu(vclock, &vclock_hash[hash], vclock_hash_node) {
+		if (vclock->clock->index != vclock_index)
+			continue;
 
-	ns = ktime_to_ns(*hwtstamp);
+		spin_lock_irqsave(&vclock->lock, flags);
+		vclock_ns = timecounter_cyc2time(&vclock->tc, ns);
+		spin_unlock_irqrestore(&vclock->lock, flags);
+		break;
+	}
 
-	spin_lock_irqsave(&vclock->lock, flags);
-	ns = timecounter_cyc2time(&vclock->tc, ns);
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	rcu_read_unlock();
 
-	put_device(dev);
-	return ns_to_ktime(ns);
+	return ns_to_ktime(vclock_ns);
 }
 EXPORT_SYMBOL(ptp_convert_timestamp);
 #endif
-- 
2.20.1

