Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8952451DFE8
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390742AbiEFUGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 16:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392566AbiEFUGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 16:06:04 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E715D5F8C3
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 13:02:19 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id kq17so16388195ejb.4
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 13:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xoVsRGejc7SLTpulyc05jnVi3zahQUiuPmNIltw8heM=;
        b=xDUui9fcqirnMiIQzuI/5wo90GL76WVLQEJMSke/dv/Y9P8px4QCotZ7bkaEVJQ4LP
         lO0HJv0WoKa51wHQ5A4wWocKGnf+b2C4MZWGB/46Oft3o4gq4OtZAoRtP+3PDMlctIag
         u3DTr1DP2n6yOFHYQiZx452Kyc+oXdW6ed1QMnKRWdiJx1DQqPuTjbKO9IO42EqU5i5z
         wdgo1LcMP55W2WdG/YEo17McawPTXFWzI3iK07fiTl34lSW7TLshUrGVp9+jgSUFA2fd
         lfU7hzNEuJkAkG+OdACU66bQ02uzHpao3NMQ522Z8LosZMoyO1h/IWKcixe0F4FXkeMF
         LUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xoVsRGejc7SLTpulyc05jnVi3zahQUiuPmNIltw8heM=;
        b=oWDWmnyLDgUs2aSqf/vOWqYzt9uIftCt6AeWgFSxgu78lO8UOcnXSbdBOG1ewHfIIv
         Ujj8/O+27VvcrkAfbk7Srt6Sz2/RiZunDUrUam1TDbeUTpVVtaX6MjpLzDKB5dpz5gg6
         RhKnQTD+C+2z8F7WSYn5Pt9rs961IiyqLRq9ar2iyGgfKF/9iTClGmjANJQ4khAEIGpq
         MhXaUDw7Amry0MD/hEdgWf427KNn694tKxjSvbGfZuDNAvgmaxLdiZ1PLg1YBLdPdLv0
         pGQwxHtsJW5LBOqh7SAaScVsdon8nLAvxTMGMCqv7O9NZSIBM48iso6hTHISXAjdgi0G
         J6QA==
X-Gm-Message-State: AOAM5313QqHy7glpeowcjuleLlwX1SzptImZlXkafSX25OJ05e1czQlT
        iadhMwPfm12Wvm4lfj3pc3simQ==
X-Google-Smtp-Source: ABdhPJxERB7WBKs358mL5A+qWxnO8Ul5y7PT4SEX8uDDz1vXqmyq4DKz+AHg24ShL8yn+qIpw2zjAA==
X-Received: by 2002:a17:907:6d24:b0:6f4:bc43:e7d1 with SMTP id sa36-20020a1709076d2400b006f4bc43e7d1mr4376145ejc.581.1651867338453;
        Fri, 06 May 2022 13:02:18 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:237:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id w5-20020a056402268500b0042617ba6389sm2719887edd.19.2022.05.06.13.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 13:02:18 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, willemb@google.com, kafai@fb.com,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 5/6] ptp: Speed up vclock lookup
Date:   Fri,  6 May 2022 22:01:41 +0200
Message-Id: <20220506200142.3329-6-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220506200142.3329-1-gerhard@engleder-embedded.com>
References: <20220506200142.3329-1-gerhard@engleder-embedded.com>
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
Acked-by: Richard Cochran <richardcochran@gmail.com>
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

