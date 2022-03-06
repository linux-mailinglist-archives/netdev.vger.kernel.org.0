Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181194CEA1F
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 09:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiCFI6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 03:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiCFI6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 03:58:36 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E73F255AF
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 00:57:44 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id d10so25963584eje.10
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 00:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nFl8voH13+B60rPVfRGg/sN/NnRz7ZCp7lxbB/q82DQ=;
        b=LqvzdCz+yDLiWJrQQBeQSBzyY40E+6veWVgX37z/icL5/bs4qknlHY+Z3jqVZsETbC
         UFn81NdQ8EVWQPa7fAl5+PuyVN0qn6DEnX1E3oEW5cGM2fsC8iejsAoBnioSm0c7VlBi
         94RL0YFoupN9CpRjj/MhlhufxyQ/KRnf1UB8HXlRB0IR3wLwRLogcy9JEvVEwo7TUd1Y
         mWoIN6vPwqC6fJyj7u4CQRTrqEeXpnFujQRp9mELkJmaEPDJKm4/BqRivRMATDpusGzG
         isHVqfCDhle3+SBV6aOT9Wvt7clyH33b/j5CKt4ItP1GpIJmijYLVzm9z1mahec/qc9y
         mhTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nFl8voH13+B60rPVfRGg/sN/NnRz7ZCp7lxbB/q82DQ=;
        b=KFVQcBaYnT9bzkZQFJwZaJUHoybmFvewt3KcI+MWN3J7gfsHrHKZbwypNA6s9azfsb
         8YBer1cBlc11QQGMXVNzBv1vzSnL4ZVU7Z0GDTOnNeblkPU+Byb48XQBxMC8PsqcnUWy
         CWhePujHAbB57b5O3p4CBm32PrrwcAIcNWyvWjGaejIrOm6OUjrhhLcxLmnMG6xQzVGm
         IK1HiGSvD2p09eEZu58EQgjUT2O0EXtSdautJs7pfoKwNtPEFnyTFlt4OOiT9ixnSolw
         HExkHSejkQmuL8/sJ1PT+SmhpCcaAJ1mKdLTztY1PLjC4lwU5g/L1rA0PTKvDb5yT7Ge
         gwAA==
X-Gm-Message-State: AOAM530JDE24BXktzNHZplNkxBpyoSYO67yD+hGb1kJnC7pW/KZ9VlGr
        bO+UcVnwMjSL52Tc+R+5JrmgBQ==
X-Google-Smtp-Source: ABdhPJzx7dnRgdVDMN0lCVQWsBOWbg2LkvbYDrmyeKUHEGn7xgRFXE0YjJ2wdfz+eZNUWWNj4lBrSg==
X-Received: by 2002:a17:907:7283:b0:6da:9504:1dbf with SMTP id dt3-20020a170907728300b006da95041dbfmr4996134ejc.84.1646557063448;
        Sun, 06 Mar 2022 00:57:43 -0800 (PST)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id z24-20020a170906815800b006dab4bd985dsm2663423ejw.107.2022.03.06.00.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 00:57:43 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [RFC PATCH net-next 5/6] ptp: Allow vclocks without free running physical clock
Date:   Sun,  6 Mar 2022 09:56:57 +0100
Message-Id: <20220306085658.1943-6-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220306085658.1943-1-gerhard@engleder-embedded.com>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
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

If a physical clock supports an additional free running time, then there
is no need to force the physical clock itself to free running.

Guarantee free running physical clock only if additional free running
time is not supported.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/ptp/ptp_clock.c   |  8 ++++----
 drivers/ptp/ptp_private.h |  9 +++++++++
 drivers/ptp/ptp_sysfs.c   | 11 ++++++-----
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index b6f2cfd15dd2..b9944053e2b8 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -77,8 +77,8 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
 {
 	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
 
-	if (ptp_vclock_in_use(ptp)) {
-		pr_err("ptp: virtual clock in use\n");
+	if (ptp_vclock_free_run(ptp)) {
+		pr_err("ptp: virtual clock requires free run\n");
 		return -EBUSY;
 	}
 
@@ -103,8 +103,8 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 	struct ptp_clock_info *ops;
 	int err = -EOPNOTSUPP;
 
-	if (ptp_vclock_in_use(ptp)) {
-		pr_err("ptp: virtual clock in use\n");
+	if (ptp_vclock_free_run(ptp)) {
+		pr_err("ptp: virtual clock requires free run\n");
 		return -EBUSY;
 	}
 
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index dba6be477067..595eb741d391 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -96,6 +96,15 @@ static inline bool ptp_vclock_in_use(struct ptp_clock *ptp)
 	return in_use;
 }
 
+/* Check if free run for virtual clock is required */
+static inline bool ptp_vclock_free_run(struct ptp_clock *ptp)
+{
+	if (ptp->info->getfreeruntimex64)
+		return false;
+	else
+		return ptp_vclock_in_use(ptp);
+}
+
 extern struct class *ptp_class;
 
 /*
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 9233bfedeb17..485dcfd4a8c3 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -230,11 +230,12 @@ static ssize_t n_vclocks_store(struct device *dev,
 		for (i = 1; i <= ptp->n_vclocks - num; i++)
 			*(ptp->vclock_index + ptp->n_vclocks - i) = -1;
 	}
-
-	if (num == 0)
-		dev_info(dev, "only physical clock in use now\n");
-	else
-		dev_info(dev, "guarantee physical clock free running\n");
+	if (!ptp->info->getfreeruntimex64) {
+		if (num == 0)
+			dev_info(dev, "only physical clock in use now\n");
+		else
+			dev_info(dev, "guarantee physical clock free running\n");
+	}
 
 	ptp->n_vclocks = num;
 	mutex_unlock(&ptp->n_vclocks_mux);
-- 
2.20.1

