Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EC765AD18
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 06:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjABFG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 00:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjABFGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 00:06:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3935A13B;
        Sun,  1 Jan 2023 21:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672635979; x=1704171979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6vTynQ3BTXpIj2XAnkrO/CzKQBj3AqcCak5VVhINevM=;
  b=ZdcBxABp5z4YzGPZP4jBxVzc9iIp0GLGY73kqPre6kCDKGVNb2ltBhFQ
   bq0dDTR+hPBhVZ46feCuZFxhYkhaeJlwT1UOkwL870LdqQjUhfH/4d0rk
   WA2Rst1Hxgt/yZI2kSCpDxfYarujW6eNGC2SJyL3ZaoAKcxokxjnYjvmK
   1xD1rB/NgVWVriAQ24Uagxz4tHXUIcqJbpBhYRle5GULfN4tH2dnGtTG6
   TbPwbqbyMXgBpX5fPK09hJKYWbtjLQiAJJLYPGu0BBawwmTjMHHKHZ3jl
   Oa2zb3O7LIpXTsH/j3OJ/dF17A5K8D7yAo/AC+qeIC07CXxwcStMPCT9x
   g==;
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="190347420"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jan 2023 22:06:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 1 Jan 2023 22:06:17 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Sun, 1 Jan 2023 22:06:12 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>,
        <jacob.e.keller@intel.com>
Subject: [Patch net-next v6 04/13] net: dsa: microchip: ptp: manipulating absolute time using ptp hw clock
Date:   Mon, 2 Jan 2023 10:34:50 +0530
Message-ID: <20230102050459.31023-5-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230102050459.31023-1-arun.ramadoss@microchip.com>
References: <20230102050459.31023-1-arun.ramadoss@microchip.com>
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

From: Christian Eggers <ceggers@arri.de>

This patch is used for reconstructing the absolute time from the 32bit
hardware time stamping value. The do_aux ioctl is used for reading the
ptp hardware clock and store it to global variable.
The timestamped value in tail tag during rx and register during tx are
32 bit value (2 bit seconds and 30 bit nanoseconds). The time taken to
read entire ptp clock will be time consuming. In order to speed up, the
software clock is maintained. This clock time will be added to 32 bit
timestamp to get the absolute time stamp.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
v1 -> v2
- Used ksz_ptp_gettime instead of _ksz_ptp_gettime in do_aux_work()
- Removed the spin_lock_bh in the ksz_ptp_start_clock()

RFC v1
- This patch is based on Christian Eggers Initial hardware timestamping
support
---
 drivers/net/dsa/microchip/ksz_ptp.c | 52 ++++++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_ptp.h |  3 ++
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 8be03095e061..16f172c1f5c2 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -28,9 +28,11 @@
 static int ksz_ptp_enable_mode(struct ksz_device *dev)
 {
 	struct ksz_tagger_data *tagger_data = ksz_tagger_data(dev->ds);
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
 	struct ksz_port *prt;
 	struct dsa_port *dp;
 	bool tag_en = false;
+	int ret;
 
 	dsa_switch_for_each_user_port(dp, dev->ds) {
 		prt = &dev->ports[dp->index];
@@ -40,6 +42,14 @@ static int ksz_ptp_enable_mode(struct ksz_device *dev)
 		}
 	}
 
+	if (tag_en) {
+		ret = ptp_schedule_worker(ptp_data->clock, 0);
+		if (ret)
+			return ret;
+	} else {
+		ptp_cancel_worker_sync(ptp_data->clock);
+	}
+
 	tagger_data->hwtstamp_set_state(dev->ds, tag_en);
 
 	return ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_ENABLE,
@@ -221,6 +231,12 @@ static int ksz_ptp_settime(struct ptp_clock_info *ptp,
 		goto unlock;
 
 	ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_LOAD_TIME, PTP_LOAD_TIME);
+	if (ret)
+		goto unlock;
+
+	spin_lock_bh(&ptp_data->clock_lock);
+	ptp_data->clock_time = *ts;
+	spin_unlock_bh(&ptp_data->clock_lock);
 
 unlock:
 	mutex_unlock(&ptp_data->lock);
@@ -271,6 +287,7 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
 	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	struct timespec64 delta64 = ns_to_timespec64(delta);
 	s32 sec, nsec;
 	u16 data16;
 	int ret;
@@ -303,15 +320,46 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 		data16 |= PTP_STEP_DIR;
 
 	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
+	if (ret)
+		goto unlock;
+
+	spin_lock_bh(&ptp_data->clock_lock);
+	ptp_data->clock_time = timespec64_add(ptp_data->clock_time, delta64);
+	spin_unlock_bh(&ptp_data->clock_lock);
 
 unlock:
 	mutex_unlock(&ptp_data->lock);
 	return ret;
 }
 
+/*  Function is pointer to the do_aux_work in the ptp_clock capability */
+static long ksz_ptp_do_aux_work(struct ptp_clock_info *ptp)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct timespec64 ts;
+
+	ksz_ptp_gettime(ptp, &ts);
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
+	ptp_data->clock_time.tv_sec = 0;
+	ptp_data->clock_time.tv_nsec = 0;
+
+	return 0;
 }
 
 int ksz_ptp_clock_register(struct dsa_switch *ds)
@@ -322,6 +370,7 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
 
 	ptp_data = &dev->ptp_data;
 	mutex_init(&ptp_data->lock);
+	spin_lock_init(&ptp_data->clock_lock);
 
 	ptp_data->caps.owner		= THIS_MODULE;
 	snprintf(ptp_data->caps.name, 16, "Microchip Clock");
@@ -330,6 +379,7 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
 	ptp_data->caps.settime64	= ksz_ptp_settime;
 	ptp_data->caps.adjfine		= ksz_ptp_adjfine;
 	ptp_data->caps.adjtime		= ksz_ptp_adjtime;
+	ptp_data->caps.do_aux_work	= ksz_ptp_do_aux_work;
 
 	ret = ksz_ptp_start_clock(dev);
 	if (ret)
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 7bb3fde2dd14..2c29a0b604bb 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -17,6 +17,9 @@ struct ksz_ptp_data {
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

