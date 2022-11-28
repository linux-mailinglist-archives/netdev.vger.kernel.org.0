Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DDB63A638
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiK1Kfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiK1KfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:35:16 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE87F18E18;
        Mon, 28 Nov 2022 02:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669631675; x=1701167675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nEYbHaSj7KYAS8mvwDzkP3IopXLcIRYJYEIXKy9P2hU=;
  b=sCmpIyOYE2vBF/bid8BClgYiY8tNiZeMIigNk809ntKEIztLFYDtetVa
   1XhEYBRnjg+TqvblXKZx8giZDVjGCIL/izX2Fh2D5nxpRsKCf8zVI4Mnp
   rBlX5ZR4L4nikoKgc4kAkdcSWF67siyiEVXl5fPOcv1Mw6LzQLa/T4a1P
   X+T917Yxdtde5Dx0EASWf7+WNEjHX+4adBNhPH6k+uGqLcR7ZOksVgPes
   tzruZDjw+wplP1Qo9AhK921TQpnBz8qYDJ6//pB80BNJCeDiPKz/OsRox
   kPa1ZrBsyCw1FI+ciD2tM7EpeRcFl9EOKBG5yPvV5y0zAXjWyKhTqz0Pt
   A==;
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="188931372"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2022 03:34:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 28 Nov 2022 03:34:30 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 28 Nov 2022 03:34:25 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v1 11/12] net: dsa: microchip: ptp: add periodic output signal
Date:   Mon, 28 Nov 2022 16:02:26 +0530
Message-ID: <20221128103227.23171-12-arun.ramadoss@microchip.com>
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

LAN937x and KSZ PTP supported switches has Three Trigger output unit.
This TOU can used to generate the periodic signal for PTP. TOU has the
cycle width register of 32 bit in size and period width register of 24
bit, each value is of 8ns so the pulse width can be maximum 125ms.

Tested using ./testptp -d /dev/ptp0 -p 1000000000 -w 100000000 for
generating the 10ms pulse width

Signed-off-by: Christian Eggers <ceggers@arri.de>
Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.h  |  13 +
 drivers/net/dsa/microchip/ksz_ptp.c     | 317 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h     |   8 +
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  71 ++++++
 4 files changed, 409 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index dbde70a8990a..a5f5ba489186 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -476,6 +476,19 @@ static inline int ksz_rmw16(struct ksz_device *dev, u32 reg, u16 mask,
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
index 79ed31fd1398..15b863c85cb1 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -24,6 +24,269 @@
 
 #define KSZ_PTP_INT_START 13
 
+static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts);
+
+static int ksz_ptp_tou_gpio(struct ksz_device *dev)
+{
+	int ret;
+
+	ret = ksz_rmw32(dev, REG_SW_GLOBAL_LED_OVR__4, LED_OVR_1, LED_OVR_1);
+	if (ret)
+		return ret;
+
+	return ksz_rmw32(dev, REG_SW_GLOBAL_LED_SRC__4,
+			 LED_SRC_PTP_GPIO_1, LED_SRC_PTP_GPIO_1);
+}
+
+static int ksz_ptp_tou_reset(struct ksz_device *dev, u8 unit)
+{
+	u32 data;
+	int ret;
+
+	/* Reset trigger unit (clears TRIGGER_EN, but not GPIOSTATx) */
+	ret = ksz_rmw32(dev, REG_PTP_CTRL_STAT__4, TRIG_RESET, TRIG_RESET);
+
+	data = FIELD_PREP(TRIG_DONE_M, BIT(unit));
+	ret = ksz_write32(dev, REG_PTP_TRIG_STATUS__4, data);
+	if (ret)
+		return ret;
+
+	data = FIELD_PREP(TRIG_INT_M, BIT(unit));
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
+static int ksz_ptp_tou_start(struct ksz_device *dev, u8 unit)
+{
+	u32 data;
+	int ret;
+
+	ret = ksz_rmw32(dev, REG_PTP_CTRL_STAT__4, TRIG_ENABLE | GPIO_OUT,
+			TRIG_ENABLE | GPIO_OUT);
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
+	if (FIELD_GET(TRIG_ERROR_M, data) & (1 << unit)) {
+		dev_err(dev->dev, "%s: Trigger unit%d error!\n", __func__,
+			unit);
+		ret = -EIO;
+		/* Unit will be reset on next access */
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ksz_ptp_configure_perout(struct ksz_device *dev,
+				    u32 cycle_width_ns, u32 pulse_width_ns,
+				    struct timespec64 const *target_time,
+				    u8 index)
+{
+	u32 data;
+	int ret;
+
+	data = FIELD_PREP(TRIG_NOTIFY, 1) |
+		FIELD_PREP(TRIG_GPO_M, index) |
+		FIELD_PREP(TRIG_PATTERN_M, TRIG_POS_PERIOD);
+	ret = ksz_write32(dev, REG_TRIG_CTRL__4, data);
+	if (ret)
+		return ret;
+
+	ret = ksz_write32(dev, REG_TRIG_CYCLE_WIDTH, cycle_width_ns);
+	if (ret)
+		return ret;
+
+	/* Set cycle count 0 - Infinite */
+	ret = ksz_rmw32(dev, REG_TRIG_CYCLE_CNT, TRIG_CYCLE_CNT_M, 0);
+	if (ret)
+		return ret;
+
+	data = (pulse_width_ns / 8);
+	ret = ksz_write32(dev, REG_TRIG_PULSE_WIDTH__4, data);
+	if (ret)
+		return ret;
+
+	ret = ksz_ptp_tou_target_time_set(dev, target_time);
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
+				 struct ptp_perout_request const *request,
+				 int on)
+{
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+	u64 cycle_width_ns;
+	u64 pulse_width_ns;
+	int pin = 0;
+	u32 data32;
+	int ret;
+
+	if (request->flags & ~KSZ_PEROUT_VALID_FLAGS)
+		return -EINVAL;
+
+	if (ptp_data->tou_mode != KSZ_PTP_TOU_PEROUT &&
+	    ptp_data->tou_mode != KSZ_PTP_TOU_IDLE)
+		return -EBUSY;
+
+	data32 = FIELD_PREP(PTP_GPIO_INDEX, pin) |
+		 FIELD_PREP(PTP_TOU_INDEX, request->index);
+	ret = ksz_rmw32(dev, REG_PTP_UNIT_INDEX__4,
+			PTP_GPIO_INDEX | PTP_TOU_INDEX, data32);
+	if (ret)
+		return ret;
+
+	ret = ksz_ptp_tou_reset(dev, request->index);
+	if (ret)
+		return ret;
+
+	if (!on) {
+		ptp_data->tou_mode = KSZ_PTP_TOU_IDLE;
+		return 0;
+	}
+
+	ptp_data->perout_target_time_first.tv_sec  = request->start.sec;
+	ptp_data->perout_target_time_first.tv_nsec = request->start.nsec;
+
+	ptp_data->perout_period.tv_sec = request->period.sec;
+	ptp_data->perout_period.tv_nsec = request->period.nsec;
+
+	cycle_width_ns = timespec64_to_ns(&ptp_data->perout_period);
+	if ((cycle_width_ns & TRIG_CYCLE_WIDTH_M) != cycle_width_ns)
+		return -EINVAL;
+
+	if (request->flags & PTP_PEROUT_DUTY_CYCLE) {
+		pulse_width_ns = request->on.sec * NSEC_PER_SEC +
+			request->on.nsec;
+	} else {
+		/* Use a duty cycle of 50%. Maximum pulse width supported by the
+		 * hardware is a little bit more than 125 ms.
+		 */
+		pulse_width_ns = min_t(u64,
+				       (request->period.sec * NSEC_PER_SEC
+					+ request->period.nsec) / 2
+				       / 8 * 8,
+				       125000000LL);
+	}
+
+	ret = ksz_ptp_tou_pulse_verify(pulse_width_ns);
+	if (ret)
+		return ret;
+
+	ret = ksz_ptp_configure_perout(dev, cycle_width_ns, pulse_width_ns,
+				       &ptp_data->perout_target_time_first,
+				       pin);
+	if (ret)
+		return ret;
+
+	ret = ksz_ptp_tou_gpio(dev);
+	if (ret)
+		return ret;
+
+	ret = ksz_ptp_tou_start(dev, request->index);
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
+	struct ptp_perout_request request;
+	struct timespec64 next;
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
+	next = ns_to_timespec64(next_ns);
+	request.start.sec  = next.tv_sec;
+	request.start.nsec = next.tv_nsec;
+	request.period.sec  = ptp_data->perout_period.tv_sec;
+	request.period.nsec = ptp_data->perout_period.tv_nsec;
+	request.index = 0;
+	request.flags = 0;
+
+	return ksz_ptp_enable_perout(dev, &request, 1);
+}
+
 static int ksz_ptp_enable_mode(struct ksz_device *dev, bool enable)
 {
 	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
@@ -291,6 +554,20 @@ static int ksz_ptp_settime(struct ptp_clock_info *ptp,
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
@@ -384,6 +661,20 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
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
@@ -393,6 +684,30 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return ret;
 }
 
+static int ksz_ptp_enable(struct ptp_clock_info *ptp,
+			  struct ptp_clock_request *req, int on)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	struct ptp_perout_request *request = &req->perout;
+	int ret;
+
+	switch (req->type) {
+	case PTP_CLK_REQ_PEROUT:
+		if (request->index > ptp->n_per_out)
+			return -EINVAL;
+
+		mutex_lock(&ptp_data->lock);
+		ret = ksz_ptp_enable_perout(dev, request, on);
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
@@ -508,6 +823,8 @@ static const struct ptp_clock_info ksz_ptp_caps = {
 	.adjfine	= ksz_ptp_adjfine,
 	.adjtime	= ksz_ptp_adjtime,
 	.do_aux_work	= ksz_ptp_do_aux_work,
+	.enable		= ksz_ptp_enable,
+	.n_per_out	= 3,
 };
 
 int ksz_ptp_clock_register(struct dsa_switch *ds)
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index ff169d119169..94ffd8bc0603 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -10,6 +10,11 @@
 
 #include <linux/ptp_clock_kernel.h>
 
+enum ksz_ptp_tou_mode {
+	KSZ_PTP_TOU_IDLE,
+	KSZ_PTP_TOU_PEROUT,
+};
+
 struct ksz_ptp_data {
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
@@ -18,6 +23,9 @@ struct ksz_ptp_data {
 	/* lock for accessing the clock_time */
 	spinlock_t clock_lock;
 	struct timespec64 clock_time;
+	enum ksz_ptp_tou_mode tou_mode;
+	struct timespec64 perout_target_time_first;  /* start of first perout pulse */
+	struct timespec64 perout_period;
 };
 
 int ksz_ptp_clock_register(struct dsa_switch *ds);
diff --git a/drivers/net/dsa/microchip/ksz_ptp_reg.h b/drivers/net/dsa/microchip/ksz_ptp_reg.h
index 0c5a1193e1a1..f714deb55681 100644
--- a/drivers/net/dsa/microchip/ksz_ptp_reg.h
+++ b/drivers/net/dsa/microchip/ksz_ptp_reg.h
@@ -6,6 +6,14 @@
 #ifndef __KSZ_PTP_REGS_H
 #define __KSZ_PTP_REGS_H
 
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
 
@@ -54,6 +62,69 @@
 #define PTP_MASTER			BIT(1)
 #define PTP_1STEP			BIT(0)
 
+#define REG_PTP_UNIT_INDEX__4		0x0520
+
+#define PTP_GPIO_INDEX			GENMASK(19, 16)
+#define PTP_TSI_INDEX			BIT(8)
+#define PTP_TOU_INDEX			GENMASK(1, 0)
+
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

