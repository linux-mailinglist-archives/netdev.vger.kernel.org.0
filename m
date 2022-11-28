Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE7363A62A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiK1KeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiK1Kdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:33:39 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6059584;
        Mon, 28 Nov 2022 02:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669631617; x=1701167617;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FVqWV4woybKDyxGqRG0ty0ONw8f1+jYYhKXZtMlz+mc=;
  b=loicr4YtUnGgguNHBKAjh/yFmmSl6Qegh+2nTjycHIY4oZWbv5B7Apif
   uKY47RckhqogCYcYdDfVQrsjcz4iKeQUdKLki/0FTziB2WDKR7SOFyz9q
   ny/cEwWjY2hhJoc3K1sPvtN25G9lVoCHDA411570xtC0oqauhPmJu6u47
   6pfiP4/fvpkapf6Eu5B6zxmbwpBvOr3YhOWb4KBA2k7zqI7kZZnBU7Vkv
   prpEHUBg7mJLHPp6SWjdFm6CUQun7KBAiKPIMf91n1oHpmOK8uGQHpAOz
   pBYGTkCKOLPiCGP71dEao72MbPT9It+7/SBbhT6ZJx7/nrwC6qH9/NZ7O
   w==;
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="125375583"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2022 03:33:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 28 Nov 2022 03:33:33 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 28 Nov 2022 03:33:27 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v1 04/12] net: dsa: microchip: ptp: Manipulating absolute time using ptp hw clock
Date:   Mon, 28 Nov 2022 16:02:19 +0530
Message-ID: <20221128103227.23171-5-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221128103227.23171-1-arun.ramadoss@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

RFC v1
- This patch is based on Christian Eggers Initial hardware timestamping
support
---
 drivers/net/dsa/microchip/ksz_ptp.c | 58 ++++++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_ptp.h |  3 ++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 184aa57a8489..415522ef4ce9 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -22,11 +22,20 @@
 
 static int ksz_ptp_enable_mode(struct ksz_device *dev, bool enable)
 {
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
 	u16 data = 0;
+	int ret;
 
-	if (enable)
+	if (enable) {
 		data = PTP_ENABLE;
 
+		ret = ptp_schedule_worker(ptp_data->clock, 0);
+		if (ret)
+			return ret;
+	} else {
+		ptp_cancel_worker_sync(ptp_data->clock);
+	}
+
 	return ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_ENABLE, data);
 }
 
@@ -200,6 +209,12 @@ static int ksz_ptp_settime(struct ptp_clock_info *ptp,
 		goto error_return;
 
 	ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_LOAD_TIME, PTP_LOAD_TIME);
+	if (ret)
+		goto error_return;
+
+	spin_lock_bh(&ptp_data->clock_lock);
+	ptp_data->clock_time = *ts;
+	spin_unlock_bh(&ptp_data->clock_lock);
 
 error_return:
 	mutex_unlock(&ptp_data->lock);
@@ -254,6 +269,7 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
 	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	struct timespec64 delta64 = ns_to_timespec64(delta);
 	s32 sec, nsec;
 	u16 data16;
 	int ret;
@@ -286,15 +302,51 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 		data16 |= PTP_STEP_DIR;
 
 	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
+	if (ret)
+		goto error_return;
+
+	spin_lock_bh(&ptp_data->clock_lock);
+	ptp_data->clock_time = timespec64_add(ptp_data->clock_time, delta64);
+	spin_unlock_bh(&ptp_data->clock_lock);
 
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
@@ -305,6 +357,7 @@ static const struct ptp_clock_info ksz_ptp_caps = {
 	.settime64	= ksz_ptp_settime,
 	.adjfine	= ksz_ptp_adjfine,
 	.adjtime	= ksz_ptp_adjtime,
+	.do_aux_work	= ksz_ptp_do_aux_work,
 };
 
 int ksz_ptp_clock_register(struct dsa_switch *ds)
@@ -315,6 +368,7 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
 
 	ptp_data = &dev->ptp_data;
 	mutex_init(&ptp_data->lock);
+	spin_lock_init(&ptp_data->clock_lock);
 
 	ptp_data->caps = ksz_ptp_caps;
 
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 17f455c3b2c5..81fa2e8b9cf4 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -15,6 +15,9 @@ struct ksz_ptp_data {
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

