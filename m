Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E962632880
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbiKUPod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiKUPoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:44:03 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF88C5633;
        Mon, 21 Nov 2022 07:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669045411; x=1700581411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D1+8ipImQ4gnxZ+ioSzQJc0FyvWQqOqujuMxgkUiyYU=;
  b=vGxaFQ9mtJPYasg+GLS5BkIsYjv/Uo9fsrpieCikeuiKOXS0b9u2HMWB
   L8oL+F4hG4QWbsyz+ATuJQeYqKFunCJ13trpx+I44x4iTLfoNuhM9/s3Z
   rumejj1yp68ndfOe6W8jmfc6qH7R4wQrzAKqZrSaSuq7RLwmg950YIlrQ
   NUWvhb6anM4KZlM00EffcXyvo2k0h2x/jQ3GvIGYBX5dvDX+66fx6ZMY9
   6zjOylLTD/lhRQcte3X41VQVzSVhiyADTOZOgK5XkQkIMEmcypUy2Lmjz
   4jZW2tmXgK0vFw+DU4JF2gzKGytYmzw9mvyKQF4McsH0j+NrTeHIBljlM
   w==;
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="189874860"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Nov 2022 08:43:14 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 21 Nov 2022 08:43:10 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 21 Nov 2022 08:43:05 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: [RFC Patch net-next v2 8/8] net: dsa: microchip: ptp: add periodic output signal
Date:   Mon, 21 Nov 2022 21:11:50 +0530
Message-ID: <20221121154150.9573-9-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221121154150.9573-1-arun.ramadoss@microchip.com>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN937x and KSZ PTP supported switches has Three Trigger output unit.
This TOU can used to generate the periodic signal for PTP. TOU has the
cycle width register of 32 bit in size and period width register of 24
bit, each value is of 8ns so the pulse width can be maximum 125ms.

Tested using ./testptp -d /dev/ptp0 -p 1000000000 -w 100000000 for
generating the 10ms pulse width

Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.h  |  13 +
 drivers/net/dsa/microchip/ksz_ptp.c     | 324 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h     |   8 +
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  65 +++++
 4 files changed, 410 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 764b6a3e5187..e572fa4c79ff 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -478,6 +478,19 @@ static inline int ksz_rmw16(struct ksz_device *dev, u32 reg, u16 mask,
 	return ret;
 }
 
+static inline int ksz_rmw32(struct ksz_device *dev, u32 reg, u32 mask,
+			    u32 value)
+{
+	int ret;
+
+	ret = regmap_update_bits(dev->regmap[2], reg, mask, value);
+	if (ret)
+		dev_err(dev->dev, "can't rmw 32bit reg: 0x%x %pe\n", reg,
+			ERR_PTR(ret));
+
+	return ret;
+}
+
 static inline int ksz_write64(struct ksz_device *dev, u32 reg, u64 value)
 {
 	u32 val[2];
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 5506adaac488..ce5134cc917f 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -26,6 +26,84 @@
 
 #define KSZ_PTP_INT_START 13
 
+#define KSZ_PER_OUT_TOU 0   /* trigger output unit 0 */
+
+static int ksz_ptp_restart_perout(struct ksz_device *dev);
+
+static int ksz_ptp_tou_gpio(struct ksz_device *dev)
+{
+	int ret;
+
+	/* Set the Led Override register */
+	ret = ksz_rmw32(dev, REG_SW_GLOBAL_LED_OVR__4, LED_OVR_1, LED_OVR_1);
+	if (ret)
+		return ret;
+
+	/* Set the Led Source register */
+	return ksz_rmw32(dev, REG_SW_GLOBAL_LED_SRC__4, LED_SRC_PTP_GPIO_1,
+			 LED_SRC_PTP_GPIO_1);
+}
+
+/* Shared register access routines (Trigger Output Unit) */
+static int ksz_ptp_tou_reset(struct ksz_device *dev, u8 unit)
+{
+	u32 data;
+	int ret;
+
+	/* Reset trigger unit (clears TRIGGER_EN, but not GPIOSTATx) */
+	ret = ksz_rmw32(dev, REG_PTP_CTRL_STAT__4, TRIG_RESET, TRIG_RESET);
+
+	/* Clear DONE */
+	data = FIELD_PREP(TRIG_DONE_M, (1 << unit));
+	ret = ksz_write32(dev, REG_PTP_TRIG_STATUS__4, data);
+	if (ret)
+		return ret;
+
+	/* Clear IRQ */
+	data = FIELD_PREP(TRIG_INT_M, (1 << unit));
+	ret = ksz_write32(dev, REG_PTP_INT_STATUS__4, data);
+	if (ret)
+		return ret;
+
+	/* Clear reset and set GPIO direction */
+	return ksz_rmw32(dev, REG_PTP_CTRL_STAT__4, (TRIG_RESET | TRIG_ENABLE),
+			 0);
+}
+
+static int ksz_ptp_tou_pulse_verify(u64 pulse_ns)
+{
+	u32 data;
+
+	if (pulse_ns & 0x3)
+		return -EINVAL;
+
+	data = (pulse_ns / 8);
+	if (!FIELD_FIT(TRIG_PULSE_WIDTH_M, data))
+		return -ERANGE;
+
+	return 0;
+}
+
+static int ksz_ptp_tou_target_time_set(struct ksz_device *dev,
+				       struct timespec64 const *ts)
+{
+	int ret;
+
+	/* Hardware has only 32 bit */
+	if ((ts->tv_sec & 0xffffffff) != ts->tv_sec)
+		return -EINVAL;
+
+	ret = ksz_write32(dev, REG_TRIG_TARGET_NANOSEC, ts->tv_nsec);
+	if (ret)
+		return ret;
+
+	ret = ksz_write32(dev, REG_TRIG_TARGET_SEC, ts->tv_sec);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int ksz_ptp_enable_mode(struct ksz_device *dev, bool enable)
 {
 	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
@@ -306,6 +384,20 @@ static int ksz_ptp_settime(struct ptp_clock_info *ptp,
 	if (ret)
 		goto error_return;
 
+	switch (ptp_data->tou_mode) {
+	case KSZ_PTP_TOU_IDLE:
+		break;
+
+	case KSZ_PTP_TOU_PEROUT:
+		dev_info(dev->dev, "Restarting periodic output signal\n");
+
+		ret = ksz_ptp_restart_perout(dev);
+		if (ret)
+			goto error_return;
+
+		break;
+	}
+
 	spin_lock_bh(&ptp_data->clock_lock);
 	ptp_data->clock_time = *ts;
 	spin_unlock_bh(&ptp_data->clock_lock);
@@ -399,6 +491,20 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	if (ret)
 		goto error_return;
 
+	switch (ptp_data->tou_mode) {
+	case KSZ_PTP_TOU_IDLE:
+		break;
+
+	case KSZ_PTP_TOU_PEROUT:
+		dev_info(dev->dev, "Restarting periodic output signal\n");
+
+		ret = ksz_ptp_restart_perout(dev);
+		if (ret)
+			goto error_return;
+
+		break;
+	}
+
 	spin_lock_bh(&ptp_data->clock_lock);
 	ptp_data->clock_time = timespec64_add(ptp_data->clock_time, delta64);
 	spin_unlock_bh(&ptp_data->clock_lock);
@@ -408,6 +514,222 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return ret;
 }
 
+static int ksz9477_ptp_tou_start(struct ksz_device *dev)
+{
+	u32 data;
+	int ret;
+
+	ret = ksz_rmw32(dev, REG_PTP_CTRL_STAT__4, (GPIO_OUT | TRIG_ENABLE),
+			(GPIO_OUT | TRIG_ENABLE));
+	if (ret)
+		return ret;
+
+	/* Check error flag:
+	 * - the ACTIVE flag is NOT cleared an error!
+	 */
+	ret = ksz_read32(dev, REG_PTP_TRIG_STATUS__4, &data);
+	if (ret)
+		return ret;
+
+	if (FIELD_GET(TRIG_ERROR_M, data) & (1 << KSZ_PER_OUT_TOU)) {
+		dev_err(dev->dev, "%s: Trigger unit0 error!\n", __func__);
+		ret = -EIO;
+		/* Unit will be reset on next access */
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ksz_ptp_configure_perout(struct ksz_device *dev,
+				    u32 cycle_width_ns,
+				    u32 pulse_width_ns,
+				    struct timespec64 const *target_time)
+{
+	u32 data;
+	int ret;
+
+	/* Enable notify, set rising edge, set periodic pattern */
+	data = FIELD_PREP(TRIG_NOTIFY, 1) |
+	       FIELD_PREP(TRIG_PATTERN_M, TRIG_POS_PERIOD);
+	ret = ksz_write32(dev, REG_TRIG_CTRL__4, data);
+	if (ret)
+		return ret;
+
+	/* Set Cycle width */
+	ret = ksz_write32(dev, REG_TRIG_CYCLE_WIDTH, cycle_width_ns);
+	if (ret)
+		return ret;
+
+	/* Set cycle count 0 - Infinite */
+	ret = ksz_rmw32(dev, REG_TRIG_CYCLE_CNT, TRIG_CYCLE_CNT_M, 0);
+	if (ret)
+		return ret;
+
+	/* Set Pulse width units of 8ns */
+	data = (pulse_width_ns / 8);
+	ret = ksz_write32(dev, REG_TRIG_PULSE_WIDTH__4, data);
+	if (ret)
+		return ret;
+
+	ret = ksz_ptp_tou_target_time_set(dev, target_time);
+	if (ret)
+		return ret;
+
+	/* Configure GPIO pins */
+	ret = ksz_ptp_tou_gpio(dev);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+#define KSZ_PEROUT_VALID_FLAGS ( \
+				 PTP_PEROUT_DUTY_CYCLE \
+				 )
+
+static int ksz_ptp_enable_perout(struct ksz_device *dev,
+				 struct ptp_perout_request const *perout_request,
+				 int on)
+{
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+	u64 cycle_width_ns;
+	u64 pulse_width_ns;
+	int ret;
+
+	if (perout_request->flags & ~KSZ_PEROUT_VALID_FLAGS)
+		return -EINVAL;
+
+	if (ptp_data->tou_mode != KSZ_PTP_TOU_PEROUT &&
+	    ptp_data->tou_mode != KSZ_PTP_TOU_IDLE)
+		return -EBUSY;
+
+	ret = ksz_ptp_tou_reset(dev, KSZ_PER_OUT_TOU);
+	if (ret)
+		return ret;
+
+	if (!on) {
+		ptp_data->tou_mode = KSZ_PTP_TOU_IDLE;
+		return 0;  /* success */
+	}
+
+	ptp_data->perout_target_time_first.tv_sec  = perout_request->start.sec;
+	ptp_data->perout_target_time_first.tv_nsec = perout_request->start.nsec;
+
+	ptp_data->perout_period.tv_sec = perout_request->period.sec;
+	ptp_data->perout_period.tv_nsec = perout_request->period.nsec;
+
+	cycle_width_ns = timespec64_to_ns(&ptp_data->perout_period);
+	if ((cycle_width_ns & TRIG_CYCLE_WIDTH_M) != cycle_width_ns)
+		return -EINVAL;
+
+	if (perout_request->flags & PTP_PEROUT_DUTY_CYCLE)
+		pulse_width_ns = perout_request->on.sec * NSEC_PER_SEC +
+			perout_request->on.nsec;
+
+	else
+		/* Use a duty cycle of 50%. Maximum pulse width supported by the
+		 * hardware is a little bit more than 125 ms.
+		 */
+		pulse_width_ns = min_t(u64,
+				       (perout_request->period.sec * NSEC_PER_SEC
+					+ perout_request->period.nsec) / 2
+				       / 8 * 8,
+				       125000000LL);
+
+	ret = ksz_ptp_tou_pulse_verify(pulse_width_ns);
+	if (ret)
+		return ret;
+
+	ret = ksz_ptp_configure_perout(dev, cycle_width_ns,
+				       pulse_width_ns,
+				       &ptp_data->perout_target_time_first);
+	if (ret)
+		return ret;
+
+	/* Activate trigger unit */
+	ret = ksz9477_ptp_tou_start(dev);
+	if (ret)
+		return ret;
+
+	ptp_data->tou_mode = KSZ_PTP_TOU_PEROUT;
+
+	return 0;
+}
+
+static int ksz_ptp_restart_perout(struct ksz_device *dev)
+{
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+	s64 now_ns, first_ns, period_ns, next_ns;
+	struct timespec64 now;
+	unsigned int count;
+	int ret;
+
+	ret = _ksz_ptp_gettime(dev, &now);
+	if (ret)
+		return ret;
+
+	now_ns = timespec64_to_ns(&now);
+	first_ns = timespec64_to_ns(&ptp_data->perout_target_time_first);
+
+	/* Calculate next perout event based on start time and period */
+	period_ns = timespec64_to_ns(&ptp_data->perout_period);
+
+	if (first_ns < now_ns) {
+		count = div_u64(now_ns - first_ns, period_ns);
+		next_ns = first_ns + count * period_ns;
+	} else {
+		next_ns = first_ns;
+	}
+
+	/* Ensure 100 ms guard time prior next event */
+	while (next_ns < now_ns + 100000000)
+		next_ns += period_ns;
+
+	/* Restart periodic output signal */
+	{
+		struct timespec64 next = ns_to_timespec64(next_ns);
+		struct ptp_perout_request perout_request = {
+			.start = {
+				.sec  = next.tv_sec,
+				.nsec = next.tv_nsec
+			},
+			.period = {
+				.sec  = ptp_data->perout_period.tv_sec,
+				.nsec = ptp_data->perout_period.tv_nsec
+			},
+			.index = 0,
+			.flags = 0,  /* keep current values */
+		};
+		ret = ksz_ptp_enable_perout(dev, &perout_request, 1);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int ksz_ptp_enable(struct ptp_clock_info *ptp,
+			  struct ptp_clock_request *req, int on)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	struct ptp_perout_request *perout_request = &req->perout;
+	int ret;
+
+	switch (req->type) {
+	case PTP_CLK_REQ_PEROUT:
+		mutex_lock(&ptp_data->lock);
+		ret = ksz_ptp_enable_perout(dev, perout_request, on);
+		mutex_unlock(&ptp_data->lock);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
 /*  Function is pointer to the do_aux_work in the ptp_clock capability */
 static long ksz_ptp_do_aux_work(struct ptp_clock_info *ptp)
 {
@@ -521,6 +843,8 @@ static const struct ptp_clock_info ksz_ptp_caps = {
 	.adjfine	= ksz_ptp_adjfine,
 	.adjtime	= ksz_ptp_adjtime,
 	.do_aux_work	= ksz_ptp_do_aux_work,
+	.enable		= ksz_ptp_enable,
+	.n_per_out	= 1,
 };
 
 int ksz_ptp_clock_register(struct dsa_switch *ds)
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 7d6786caa633..5f13fbc56820 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -8,6 +8,11 @@
 
 #if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
 
+enum ksz_ptp_tou_mode {
+	KSZ_PTP_TOU_IDLE,
+	KSZ_PTP_TOU_PEROUT,
+};
+
 struct ksz_ptp_data {
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
@@ -16,6 +21,9 @@ struct ksz_ptp_data {
 	/* lock for accessing the clock_time */
 	spinlock_t clock_lock;
 	struct timespec64 clock_time;
+	enum ksz_ptp_tou_mode tou_mode;
+	struct timespec64 perout_target_time_first;  /* start of first perout pulse */
+	struct timespec64 perout_period;
 };
 
 int ksz_ptp_clock_register(struct dsa_switch *ds);
diff --git a/drivers/net/dsa/microchip/ksz_ptp_reg.h b/drivers/net/dsa/microchip/ksz_ptp_reg.h
index ccb87bbdfbcd..df3b4371c49b 100644
--- a/drivers/net/dsa/microchip/ksz_ptp_reg.h
+++ b/drivers/net/dsa/microchip/ksz_ptp_reg.h
@@ -3,6 +3,14 @@
  * Copyright (C) 2019-2021 Microchip Technology Inc.
  */
 
+#define REG_SW_GLOBAL_LED_OVR__4	0x0120
+#define LED_OVR_2			BIT(1)
+#define LED_OVR_1			BIT(0)
+
+#define REG_SW_GLOBAL_LED_SRC__4	0x0128
+#define LED_SRC_PTP_GPIO_1		BIT(3)
+#define LED_SRC_PTP_GPIO_2		BIT(2)
+
 /* 5 - PTP Clock */
 #define REG_PTP_CLK_CTRL		0x0500
 
@@ -51,6 +59,63 @@
 #define PTP_MASTER			BIT(1)
 #define PTP_1STEP			BIT(0)
 
+#define REG_PTP_TRIG_STATUS__4		0x0524
+
+#define TRIG_ERROR_M			GENMASK(18, 16)
+#define TRIG_DONE_M			GENMASK(2, 0)
+
+#define REG_PTP_INT_STATUS__4		0x0528
+
+#define TRIG_INT_M			GENMASK(18, 16)
+#define TS_INT_M			GENMASK(1, 0)
+
+#define REG_PTP_CTRL_STAT__4           0x052C
+
+#define GPIO_IN                        BIT(7)
+#define GPIO_OUT                       BIT(6)
+#define TS_INT_ENABLE                  BIT(5)
+#define TRIG_ACTIVE                    BIT(4)
+#define TRIG_ENABLE                    BIT(3)
+#define TRIG_RESET                     BIT(2)
+#define TS_ENABLE                      BIT(1)
+#define TS_RESET                       BIT(0)
+
+#define REG_TRIG_TARGET_NANOSEC        0x0530
+#define REG_TRIG_TARGET_SEC            0x0534
+
+#define REG_TRIG_CTRL__4               0x0538
+
+#define TRIG_CASCADE_ENABLE            BIT(31)
+#define TRIG_CASCADE_TAIL              BIT(30)
+#define TRIG_CASCADE_UPS_M             GENMASK(29, 26)
+#define TRIG_NOW                       BIT(25)
+#define TRIG_NOTIFY                    BIT(24)
+#define TRIG_EDGE                      BIT(23)
+#define TRIG_PATTERN_M		       GENMASK(22, 20)
+#define TRIG_NEG_EDGE                  0
+#define TRIG_POS_EDGE                  1
+#define TRIG_NEG_PULSE                 2
+#define TRIG_POS_PULSE                 3
+#define TRIG_NEG_PERIOD                4
+#define TRIG_POS_PERIOD                5
+#define TRIG_REG_OUTPUT                6
+#define TRIG_GPO_M		       GENMASK(19, 16)
+#define TRIG_CASCADE_ITERATE_CNT_M     GENMASK(15, 0)
+
+#define REG_TRIG_CYCLE_WIDTH           0x053C
+#define TRIG_CYCLE_WIDTH_M	       GENMASK(31, 0)
+
+#define REG_TRIG_CYCLE_CNT             0x0540
+
+#define TRIG_CYCLE_CNT_M	       GENMASK(31, 16)
+#define TRIG_BIT_PATTERN_M             GENMASK(15, 0)
+
+#define REG_TRIG_ITERATE_TIME          0x0544
+
+#define REG_TRIG_PULSE_WIDTH__4        0x0548
+
+#define TRIG_PULSE_WIDTH_M             GENMASK(23, 0)
+
 /* Port PTP Register */
 #define REG_PTP_PORT_RX_DELAY__2	0x0C00
 #define REG_PTP_PORT_TX_DELAY__2	0x0C02
-- 
2.36.1

