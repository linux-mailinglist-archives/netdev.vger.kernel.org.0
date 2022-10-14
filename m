Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0B75FF161
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 17:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiJNPaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 11:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiJNP3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 11:29:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129E5F002;
        Fri, 14 Oct 2022 08:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1665761383; x=1697297383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LR20ISPZTVlIw7Mi+HJrgiQ6JDULKdv0p1mwU3lq/O4=;
  b=W1Czk0+6fmkB2PKOMKm5JfVm/E/X33XcW17aqyxU/zRDScqj+bmxL0T/
   uMsxr6oBMI/vegh3BYl9UmloFaCY1EZR6WUqT3upSphzIHNTXKu7YxpmR
   0UKso1e+XJPetNgjEJNM13GPhbQcTXXkyAKBPZCTYnfQNIMdE8JP7h7i6
   OLH55UvTa6is01SUPOhfOQCZ/P5CpEd+TnJYaLf/AZjV+QsZV+20T5VPc
   Y6Fe9GZBDE2HuqseMqOSIfwwtM9xy7gbsrrTfr3wr7ciQ5PBF9RvJIZvR
   YI40ew3bARw0eI6BjPXcg6yBba6TwijtRTEP2OfWgvPnlHIclR50IHk7X
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="195427909"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2022 08:29:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 14 Oct 2022 08:29:36 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 14 Oct 2022 08:29:31 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: [RFC Patch net-next 3/6] net: dsa: microchip: Manipulating absolute time using ptp hw clock
Date:   Fri, 14 Oct 2022 20:58:54 +0530
Message-ID: <20221014152857.32645-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221014152857.32645-1-arun.ramadoss@microchip.com>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is used for reconstructing the absolute time from the 32bit
hardware time stamping value. The do_aux ioctl is used for reading the
ptp hardware clock and store it to global variable.
The timestamped value in tail tag during rx and register during tx are
32 bit value (2 bit seconds and 30 bit nanoseconds). The time taken to
read entire ptp clock will be time consuming. In order to speed up, the
software clock is maintained. This clock time will be added to 32 bit
timestamp to get the absolute time stamp.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.h |  1 +
 drivers/net/dsa/microchip/ksz_ptp.c    | 55 +++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_ptp.h    |  3 ++
 3 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 0e5f02d3992e..b15bcb6251e9 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -7,6 +7,7 @@
 #ifndef __KSZ_COMMON_H
 #define __KSZ_COMMON_H
 
+#include <linux/dsa/ksz_common.h>
 #include <linux/etherdevice.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 5199840377aa..c4cef3884a4d 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -24,12 +24,22 @@
 
 static int ksz_ptp_enable_mode(struct ksz_device *dev, bool enable)
 {
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
 	u16 data = 0;
+	int ret;
 
 	/* Enable PTP mode */
-	if (enable)
+	if (enable) {
 		data = PTP_ENABLE;
 
+		/* Schedule cyclic call of ksz_ptp_do_aux_work() */
+		ret = ptp_schedule_worker(ptp_data->clock, 0);
+		if (ret)
+			return ret;
+	} else {
+		ptp_cancel_worker_sync(ptp_data->clock);
+	}
+
 	return ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_ENABLE, data);
 }
 
@@ -223,6 +233,10 @@ static int ksz_ptp_settime(struct ptp_clock_info *ptp,
 	/* Load PTP clock from shadow registers */
 	ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_LOAD_TIME, PTP_LOAD_TIME);
 
+	spin_lock_bh(&ptp_data->clock_lock);
+	ptp_data->clock_time = *ts;
+	spin_unlock_bh(&ptp_data->clock_lock);
+
 error_return:
 	mutex_unlock(&ptp_data->lock);
 
@@ -276,6 +290,7 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
 	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	struct timespec64 delta64 = ns_to_timespec64(delta);
 	s32 sec, nsec;
 	u16 data16;
 	int ret;
@@ -309,14 +324,48 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 
 	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
 
+	spin_lock_bh(&ptp_data->clock_lock);
+	ptp_data->clock_time = timespec64_add(ptp_data->clock_time, delta64);
+	spin_unlock_bh(&ptp_data->clock_lock);
+
 error_return:
 	mutex_unlock(&ptp_data->lock);
 	return ret;
 }
 
+/*  Function is pointer to the do_aux_work in the ptp_clock capability */
+static long ksz_ptp_do_aux_work(struct ptp_clock_info *ptp)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	struct timespec64 ts;
+
+	mutex_lock(&ptp_data->lock);
+	_ksz_ptp_gettime(dev, &ts);
+	mutex_unlock(&ptp_data->lock);
+
+	spin_lock_bh(&ptp_data->clock_lock);
+	ptp_data->clock_time = ts;
+	spin_unlock_bh(&ptp_data->clock_lock);
+
+	return HZ;  /* reschedule in 1 second */
+}
+
 static int ksz_ptp_start_clock(struct ksz_device *dev)
 {
-	return ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ENABLE, PTP_CLK_ENABLE);
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+	int ret;
+
+	ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ENABLE, PTP_CLK_ENABLE);
+	if (ret)
+		return ret;
+
+	spin_lock_bh(&ptp_data->clock_lock);
+	ptp_data->clock_time.tv_sec = 0;
+	ptp_data->clock_time.tv_nsec = 0;
+	spin_unlock_bh(&ptp_data->clock_lock);
+
+	return 0;
 }
 
 static const struct ptp_clock_info ksz_ptp_caps = {
@@ -327,6 +376,7 @@ static const struct ptp_clock_info ksz_ptp_caps = {
 	.settime64	= ksz_ptp_settime,
 	.adjfine	= ksz_ptp_adjfine,
 	.adjtime	= ksz_ptp_adjtime,
+	.do_aux_work	= ksz_ptp_do_aux_work,
 };
 
 int ksz_ptp_clock_register(struct dsa_switch *ds)
@@ -336,6 +386,7 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
 	int ret;
 
 	mutex_init(&ptp_data->lock);
+	spin_lock_init(&ptp_data->clock_lock);
 
 	ptp_data->caps = ksz_ptp_caps;
 
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 4c024cc9d935..09c0e58c365e 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -13,6 +13,9 @@ struct ksz_ptp_data {
 	struct ptp_clock *clock;
 	/* Serializes all operations on the PTP hardware clock */
 	struct mutex lock;
+	/* lock for accessing the clock_time */
+	spinlock_t clock_lock;
+	struct timespec64 clock_time;
 };
 
 int ksz_ptp_clock_register(struct dsa_switch *ds);
-- 
2.36.1

