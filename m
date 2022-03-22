Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309DE4E4817
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 22:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbiCVVJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 17:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbiCVVJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 17:09:14 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3540BDFE1
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:07:42 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id m30so15311088wrb.1
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jN9fN+K5eR2qq2+bppJVp+JVT+ABg49IcCA/S7DXA0E=;
        b=8OB/veL5qCHCPUSqSO7ikQAqfix8VnPYKomsTpFuybOrn2cDA9x+SUOg0zR24AyQaI
         Q38ChW22mYayXgozIXueTP7MiLxL3ln3ghjnbDjnc6AkZ7iJ26T57q6J7qfaYSTya79f
         UMCKHm8WvzcBN/1w+k6zxGqVTSGowBZFyh10CssdaBDUXmvEKjLa0oY3cLi5uFNfwR/6
         RrYc+UcKHBLUD6lm4RWgEvsnw3jQ567opT0Yq8SosCql713qr9zofHdzX8cXX5a61JqV
         0U3hYCOMgrBUsSfG7g3pQ4nyQ3gG+dS5J4EwShTfMmN+k8hjflgbtwaOa0rtlz8V8vRo
         w4UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jN9fN+K5eR2qq2+bppJVp+JVT+ABg49IcCA/S7DXA0E=;
        b=aIzQjmnx1+S4vBIvslLOCT0Aol8jr/U++efjyWSgm87sqobao9Fclmn+OK0xGANSa2
         KYwvH1rdKYMHWma44XCcJhYIEDMeoTH44v5+dRYDI4SxgmXDEhMOtVKZ+Kh4NBXpN89J
         Xdr0SCb59eSeMcMXrG33TtXk/jq/L2QIfFXKmgLBYEwyTFixH+BqYmBze3pNVWBJD8/T
         kVrjN7iiNQp1D/H50DLaHfv0OdAzlGyqlwrfbyOid3TRjFIUSMsdr0fgXymUrHuuNK6X
         BRT9DX3BvVCpKDo5Aqy3V7+jWe6Pr8S/wSEMpisCvnSFYBvnR8KtVe4rfcNm91CnSIt0
         RtNw==
X-Gm-Message-State: AOAM5328ON8Q6Wxa80bZt0+CA6NRK7j67wlXdyfntCF2OV2+h39jM2RP
        pKvjwESis0tGQYjsy5StHhQdAw==
X-Google-Smtp-Source: ABdhPJxUWUQrxqUkEZu2vEtfguOXhg7+MpKjzOxHXMGkQtbWXyoxWI9nlJRoxDwiClwsH5QR1go6dw==
X-Received: by 2002:a5d:588b:0:b0:204:1c1a:965d with SMTP id n11-20020a5d588b000000b002041c1a965dmr7641401wrf.669.1647983260673;
        Tue, 22 Mar 2022 14:07:40 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id c7-20020a5d4f07000000b00203db8f13c6sm16281805wru.75.2022.03.22.14.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 14:07:40 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v1 1/6] ptp: Add cycles support for virtual clocks
Date:   Tue, 22 Mar 2022 22:07:17 +0100
Message-Id: <20220322210722.6405-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220322210722.6405-1-gerhard@engleder-embedded.com>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
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

ptp vclocks require a free running time for their timecounter.
Currently only a physical clock forced to free running is supported.
If vclocks are used, then the physical clock cannot be synchronized
anymore. The synchronized time is not available in hardware in this
case. As a result, timed transmission with TAPRIO hardware support
is not possible anymore.

If hardware would support a free running time additionally to the
physical clock, then the physical clock does not need to be forced to
free running. Thus, the physical clocks can still be synchronized
while vclocks are in use.

The physical clock could be used to synchronize the time domain of the
TSN network and trigger TAPRIO. In parallel vclocks can be used to
synchronize other time domains.

Introduce support for a free running time called cycles to physical
clocks. Rework ptp vclocks to use cycles. Default implementation of
cycles is based on time of physical clock. Thus, behavior of ptp vclocks
based on physical clocks without cycles is identical to previous
behavior.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/ptp/ptp_clock.c          | 31 +++++++++++++++++++++++++++----
 drivers/ptp/ptp_private.h        | 10 ++++++++++
 drivers/ptp/ptp_sysfs.c          | 10 ++++++----
 drivers/ptp/ptp_vclock.c         | 13 +++++--------
 include/linux/ptp_clock_kernel.h | 30 ++++++++++++++++++++++++++++++
 5 files changed, 78 insertions(+), 16 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index b6f2cfd15dd2..54b9f54ac0b2 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -77,8 +77,8 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
 {
 	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
 
-	if (ptp_vclock_in_use(ptp)) {
-		pr_err("ptp: virtual clock in use\n");
+	if (ptp_clock_freerun(ptp)) {
+		pr_err("ptp: physical clock is free running\n");
 		return -EBUSY;
 	}
 
@@ -103,8 +103,8 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 	struct ptp_clock_info *ops;
 	int err = -EOPNOTSUPP;
 
-	if (ptp_vclock_in_use(ptp)) {
-		pr_err("ptp: virtual clock in use\n");
+	if (ptp_clock_freerun(ptp)) {
+		pr_err("ptp: physical clock is free running\n");
 		return -EBUSY;
 	}
 
@@ -178,6 +178,14 @@ static void ptp_clock_release(struct device *dev)
 	kfree(ptp);
 }
 
+static int ptp_getcycles64(struct ptp_clock_info *info, struct timespec64 *ts)
+{
+	if (info->getcyclesx64)
+		return info->getcyclesx64(info, ts, NULL);
+	else
+		return info->gettime64(info, ts);
+}
+
 static void ptp_aux_kworker(struct kthread_work *work)
 {
 	struct ptp_clock *ptp = container_of(work, struct ptp_clock,
@@ -225,6 +233,21 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	mutex_init(&ptp->n_vclocks_mux);
 	init_waitqueue_head(&ptp->tsev_wq);
 
+	if (!ptp->info->getcycles64 && !ptp->info->getcyclesx64) {
+		/* Cycles are based on time per default. */
+		ptp->info->getcycles64 = ptp_getcycles64;
+
+		if (ptp->info->gettimex64)
+			ptp->info->getcyclesx64 = ptp->info->gettimex64;
+
+		if (ptp->info->getcrosststamp)
+			ptp->info->getcrosscycles = ptp->info->getcrosststamp;
+	} else {
+		ptp->cycles = true;
+		if (!ptp->info->getcycles64 && ptp->info->getcyclesx64)
+			ptp->info->getcycles64 = ptp_getcycles64;
+	}
+
 	if (ptp->info->do_aux_work) {
 		kthread_init_delayed_work(&ptp->aux_work, ptp_aux_kworker);
 		ptp->kworker = kthread_create_worker(0, "ptp%d", ptp->index);
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index dba6be477067..ae66376def84 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -52,6 +52,7 @@ struct ptp_clock {
 	int *vclock_index;
 	struct mutex n_vclocks_mux; /* protect concurrent n_vclocks access */
 	bool is_virtual_clock;
+	bool cycles;
 };
 
 #define info_to_vclock(d) container_of((d), struct ptp_vclock, info)
@@ -96,6 +97,15 @@ static inline bool ptp_vclock_in_use(struct ptp_clock *ptp)
 	return in_use;
 }
 
+/* Check if ptp clock shall be free running */
+static inline bool ptp_clock_freerun(struct ptp_clock *ptp)
+{
+	if (ptp->cycles)
+		return false;
+
+	return ptp_vclock_in_use(ptp);
+}
+
 extern struct class *ptp_class;
 
 /*
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 9233bfedeb17..8da3d374f78e 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -231,10 +231,12 @@ static ssize_t n_vclocks_store(struct device *dev,
 			*(ptp->vclock_index + ptp->n_vclocks - i) = -1;
 	}
 
-	if (num == 0)
-		dev_info(dev, "only physical clock in use now\n");
-	else
-		dev_info(dev, "guarantee physical clock free running\n");
+	if (!ptp->cycles) {
+		if (num == 0)
+			dev_info(dev, "only physical clock in use now\n");
+		else
+			dev_info(dev, "guarantee physical clock free running\n");
+	}
 
 	ptp->n_vclocks = num;
 	mutex_unlock(&ptp->n_vclocks_mux);
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index cb179a3ea508..3a095eab9cc5 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -68,7 +68,7 @@ static int ptp_vclock_gettimex(struct ptp_clock_info *ptp,
 	int err;
 	u64 ns;
 
-	err = pptp->info->gettimex64(pptp->info, &pts, sts);
+	err = pptp->info->getcyclesx64(pptp->info, &pts, sts);
 	if (err)
 		return err;
 
@@ -104,7 +104,7 @@ static int ptp_vclock_getcrosststamp(struct ptp_clock_info *ptp,
 	int err;
 	u64 ns;
 
-	err = pptp->info->getcrosststamp(pptp->info, xtstamp);
+	err = pptp->info->getcrosscycles(pptp->info, xtstamp);
 	if (err)
 		return err;
 
@@ -143,10 +143,7 @@ static u64 ptp_vclock_read(const struct cyclecounter *cc)
 	struct ptp_clock *ptp = vclock->pclock;
 	struct timespec64 ts = {};
 
-	if (ptp->info->gettimex64)
-		ptp->info->gettimex64(ptp->info, &ts, NULL);
-	else
-		ptp->info->gettime64(ptp->info, &ts);
+	ptp->info->getcycles64(ptp->info, &ts);
 
 	return timespec64_to_ns(&ts);
 }
@@ -168,11 +165,11 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 
 	vclock->pclock = pclock;
 	vclock->info = ptp_vclock_info;
-	if (pclock->info->gettimex64)
+	if (pclock->info->getcyclesx64)
 		vclock->info.gettimex64 = ptp_vclock_gettimex;
 	else
 		vclock->info.gettime64 = ptp_vclock_gettime;
-	if (pclock->info->getcrosststamp)
+	if (pclock->info->getcrosscycles)
 		vclock->info.getcrosststamp = ptp_vclock_getcrosststamp;
 	vclock->cc = ptp_vclock_cc;
 
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 554454cb8693..acdcaa4a1ec2 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -108,6 +108,31 @@ struct ptp_system_timestamp {
  * @settime64:  Set the current time on the hardware clock.
  *              parameter ts: Time value to set.
  *
+ * @getcycles64:  Reads the current free running time from the hardware clock.
+ *                If @getcycles64 and @getcyclesx64 are not supported, then
+ *                @gettime64 or @gettimex64 will be used as default
+ *                implementation.
+ *                parameter ts: Holds the result.
+ *
+ * @getcyclesx64:  Reads the current free running time from the hardware clock
+ *                 and optionally also the system clock.
+ *                 If @getcycles64 and @getcyclesx64 are not supported, then
+ *                 @gettimex64 will be used as default implementation if
+ *                 available.
+ *                 parameter ts: Holds the PHC timestamp.
+ *                 parameter sts: If not NULL, it holds a pair of timestamps
+ *                 from the system clock. The first reading is made right before
+ *                 reading the lowest bits of the PHC timestamp and the second
+ *                 reading immediately follows that.
+ *
+ * @getcrosscycles:  Reads the current free running time from the hardware clock
+ *                   and system clock simultaneously.
+ *                   If @getcycles64 and @getcyclesx64 are not supported, then
+ *                   @getcrosststamp will be used as default implementation if
+ *                   available.
+ *                   parameter cts: Contains timestamp (device,system) pair,
+ *                   where system time is realtime and monotonic.
+ *
  * @enable:   Request driver to enable or disable an ancillary feature.
  *            parameter request: Desired resource to enable or disable.
  *            parameter on: Caller passes one to enable or zero to disable.
@@ -155,6 +180,11 @@ struct ptp_clock_info {
 	int (*getcrosststamp)(struct ptp_clock_info *ptp,
 			      struct system_device_crosststamp *cts);
 	int (*settime64)(struct ptp_clock_info *p, const struct timespec64 *ts);
+	int (*getcycles64)(struct ptp_clock_info *ptp, struct timespec64 *ts);
+	int (*getcyclesx64)(struct ptp_clock_info *ptp, struct timespec64 *ts,
+			    struct ptp_system_timestamp *sts);
+	int (*getcrosscycles)(struct ptp_clock_info *ptp,
+			      struct system_device_crosststamp *cts);
 	int (*enable)(struct ptp_clock_info *ptp,
 		      struct ptp_clock_request *request, int on);
 	int (*verify)(struct ptp_clock_info *ptp, unsigned int pin,
-- 
2.20.1

