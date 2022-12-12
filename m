Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABDA649C32
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiLLKa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiLLK3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:29:47 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF06101FF;
        Mon, 12 Dec 2022 02:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670840901; x=1702376901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dYV37g3X+SSwpEd4KXd8IMmFiLzamzR/r9hKufS0MX0=;
  b=WgVA7U8XQaPn28nnv4/9YvTpOiGcrfmpr899Oyrf8JgM8wLAoV1eY0X3
   r4xF69LylVx5NnTGaK25gTc7se0D5h0pulxqWp//ExVLuewrJbTY5f19+
   32nklap4X4N1aG/bHw1iCiO9zN1Upx0GaIc9yqWhBcitTIMKfpkeipMaS
   qx7FkFI8kekuhc0HsR25TJxbjxFry8GGyoljmjlBiLH4ClyV2pc5rkf0E
   Otn3BCFHgj0UYR44r0Pd40aH4jAalJE7ak9D9S40RYgvos3YrZzah7++u
   y9eFu7DYQGIbjlHevtTxk6pNLbIsT7GEWGQkQV6p6Fdwmd1Wwz4pF1g3i
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="187686737"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 03:28:20 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 03:28:17 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 03:28:11 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v4 10/13] net: dsa: microchip: ptp: add periodic output signal
Date:   Mon, 12 Dec 2022 15:56:36 +0530
Message-ID: <20221212102639.24415-11-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221212102639.24415-1-arun.ramadoss@microchip.com>
References: <20221212102639.24415-1-arun.ramadoss@microchip.com>
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
v3 -> v4
- Added KSZ_MAX_PULSE_WIDTH macro for constant 125000000
- Reordered the ksz_perout_restart to avoid function definition
- moved the dev_info inside ksz_perout_restart
- used helper function to calculate the min pulse width
- replaced spaces with tabs in ksz_ptp_reg.h

v2 -> v3
- No change

v1 -> v2
- In ksz_ptp_enable function, removed the check request->index since it
is handled in upper layer. For the default case use -EOPNOSUPP instead
of -EINVAL.
---
 drivers/net/dsa/microchip/ksz_common.h  |  13 ++
 drivers/net/dsa/microchip/ksz_ptp.c     | 289 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h     |   8 +
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  63 ++++++
 4 files changed, 373 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 6809e1a76037..ecc186c857aa 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -477,6 +477,19 @@ static inline int ksz_rmw16(struct ksz_device *dev, u32 reg, u16 mask,
 	return ret;
 }
 
+static inline int ksz_rmw32(struct ksz_device *dev, u32 reg, u32 mask,
+			    u32 value)
+{
+	int ret;
+
+	ret = regmap_update_bits(dev->regmap[2], reg, mask, value);
+	if (ret)
+		dev_err(dev->dev, "can't rmw 32bit reg 0x%x: %pe\n", reg,
+			ERR_PTR(ret));
+
+	return ret;
+}
+
 static inline int ksz_write64(struct ksz_device *dev, u32 reg, u64 value)
 {
 	u32 val[2];
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index b01df7beb6aa..2bc3ed72dc56 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -25,12 +25,210 @@
  * = (2^30-1) * (2 ^ 32) / 40 ns * 1 ns = 6249999
  */
 #define KSZ_MAX_DRIFT_CORR 6249999
+#define KSZ_MAX_PULSE_WIDTH 125000000LL
 
 #define KSZ_PTP_INC_NS 40  /* HW clock is incremented every 40 ns (by 40) */
 #define KSZ_PTP_SUBNS_BITS 32
 
 #define KSZ_PTP_INT_START 13
 
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
+	ret = ksz_rmw32(dev, REG_PTP_CTRL_STAT__4, TRIG_ENABLE, TRIG_ENABLE);
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
+static int ksz_ptp_enable_perout(struct ksz_device *dev,
+				 struct ptp_perout_request const *request,
+				 int on)
+{
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+	u64 req_pulse_width_ns;
+	u64 cycle_width_ns;
+	u64 pulse_width_ns;
+	int pin = 0;
+	u32 data32;
+	int ret;
+
+	if (request->flags & ~PTP_PEROUT_DUTY_CYCLE)
+		return -EOPNOTSUPP;
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
+		req_pulse_width_ns = (request->period.sec * NSEC_PER_SEC +
+				      request->period.nsec) / 2;
+		pulse_width_ns = min_t(u64, req_pulse_width_ns,
+				       KSZ_MAX_PULSE_WIDTH);
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
+	ret = ksz_ptp_tou_start(dev, request->index);
+	if (ret)
+		return ret;
+
+	ptp_data->tou_mode = KSZ_PTP_TOU_PEROUT;
+
+	return 0;
+}
+
 static int ksz_ptp_enable_mode(struct ksz_device *dev)
 {
 	struct ksz_tagger_data *tagger_data = ksz_tagger_data(dev->ds);
@@ -370,6 +568,51 @@ static int ksz_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	return ret;
 }
 
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
+	dev_info(dev->dev, "Restarting periodic output signal\n");
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
 static int ksz_ptp_settime(struct ptp_clock_info *ptp,
 			   const struct timespec64 *ts)
 {
@@ -396,6 +639,18 @@ static int ksz_ptp_settime(struct ptp_clock_info *ptp,
 	if (ret)
 		goto unlock;
 
+	switch (ptp_data->tou_mode) {
+	case KSZ_PTP_TOU_IDLE:
+		break;
+
+	case KSZ_PTP_TOU_PEROUT:
+		ret = ksz_ptp_restart_perout(dev);
+		if (ret)
+			goto unlock;
+
+		break;
+	}
+
 	spin_lock_bh(&ptp_data->clock_lock);
 	ptp_data->clock_time = *ts;
 	spin_unlock_bh(&ptp_data->clock_lock);
@@ -489,6 +744,18 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	if (ret)
 		goto unlock;
 
+	switch (ptp_data->tou_mode) {
+	case KSZ_PTP_TOU_IDLE:
+		break;
+
+	case KSZ_PTP_TOU_PEROUT:
+		ret = ksz_ptp_restart_perout(dev);
+		if (ret)
+			goto unlock;
+
+		break;
+	}
+
 	spin_lock_bh(&ptp_data->clock_lock);
 	ptp_data->clock_time = timespec64_add(ptp_data->clock_time, delta64);
 	spin_unlock_bh(&ptp_data->clock_lock);
@@ -498,6 +765,26 @@ static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return ret;
 }
 
+static int ksz_ptp_enable(struct ptp_clock_info *ptp,
+			  struct ptp_clock_request *req, int on)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	int ret;
+
+	switch (req->type) {
+	case PTP_CLK_REQ_PEROUT:
+		mutex_lock(&ptp_data->lock);
+		ret = ksz_ptp_enable_perout(dev, &req->perout, on);
+		mutex_unlock(&ptp_data->lock);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
 /*  Function is pointer to the do_aux_work in the ptp_clock capability */
 static long ksz_ptp_do_aux_work(struct ptp_clock_info *ptp)
 {
@@ -546,6 +833,8 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
 	ptp_data->caps.adjfine		= ksz_ptp_adjfine;
 	ptp_data->caps.adjtime		= ksz_ptp_adjtime;
 	ptp_data->caps.do_aux_work	= ksz_ptp_do_aux_work;
+	ptp_data->caps.enable		= ksz_ptp_enable;
+	ptp_data->caps.n_per_out	= 3;
 
 	ret = ksz_ptp_start_clock(dev);
 	if (ret)
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 0b14aed71ec2..9451e3a76375 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -12,6 +12,11 @@
 
 #include <linux/ptp_clock_kernel.h>
 
+enum ksz_ptp_tou_mode {
+	KSZ_PTP_TOU_IDLE,
+	KSZ_PTP_TOU_PEROUT,
+};
+
 struct ksz_ptp_data {
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
@@ -20,6 +25,9 @@ struct ksz_ptp_data {
 	/* lock for accessing the clock_time */
 	spinlock_t clock_lock;
 	struct timespec64 clock_time;
+	enum ksz_ptp_tou_mode tou_mode;
+	struct timespec64 perout_target_time_first;  /* start of first pulse */
+	struct timespec64 perout_period;
 };
 
 int ksz_ptp_clock_register(struct dsa_switch *ds);
diff --git a/drivers/net/dsa/microchip/ksz_ptp_reg.h b/drivers/net/dsa/microchip/ksz_ptp_reg.h
index abe95bbefc12..c5c76b9a4329 100644
--- a/drivers/net/dsa/microchip/ksz_ptp_reg.h
+++ b/drivers/net/dsa/microchip/ksz_ptp_reg.h
@@ -49,6 +49,69 @@
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
+#define REG_PTP_CTRL_STAT__4		0x052C
+
+#define GPIO_IN			BIT(7)
+#define GPIO_OUT			BIT(6)
+#define TS_INT_ENABLE			BIT(5)
+#define TRIG_ACTIVE			BIT(4)
+#define TRIG_ENABLE			BIT(3)
+#define TRIG_RESET			BIT(2)
+#define TS_ENABLE			BIT(1)
+#define TS_RESET			BIT(0)
+
+#define REG_TRIG_TARGET_NANOSEC	0x0530
+#define REG_TRIG_TARGET_SEC		0x0534
+
+#define REG_TRIG_CTRL__4		0x0538
+
+#define TRIG_CASCADE_ENABLE		BIT(31)
+#define TRIG_CASCADE_TAIL		BIT(30)
+#define TRIG_CASCADE_UPS_M		GENMASK(29, 26)
+#define TRIG_NOW			BIT(25)
+#define TRIG_NOTIFY			BIT(24)
+#define TRIG_EDGE			BIT(23)
+#define TRIG_PATTERN_M			GENMASK(22, 20)
+#define TRIG_NEG_EDGE			0
+#define TRIG_POS_EDGE			1
+#define TRIG_NEG_PULSE			2
+#define TRIG_POS_PULSE			3
+#define TRIG_NEG_PERIOD		4
+#define TRIG_POS_PERIOD		5
+#define TRIG_REG_OUTPUT		6
+#define TRIG_GPO_M			GENMASK(19, 16)
+#define TRIG_CASCADE_ITERATE_CNT_M	GENMASK(15, 0)
+
+#define REG_TRIG_CYCLE_WIDTH		0x053C
+#define TRIG_CYCLE_WIDTH_M		GENMASK(31, 0)
+
+#define REG_TRIG_CYCLE_CNT		0x0540
+
+#define TRIG_CYCLE_CNT_M		GENMASK(31, 16)
+#define TRIG_BIT_PATTERN_M		GENMASK(15, 0)
+
+#define REG_TRIG_ITERATE_TIME		0x0544
+
+#define REG_TRIG_PULSE_WIDTH__4	0x0548
+
+#define TRIG_PULSE_WIDTH_M		GENMASK(23, 0)
+
 /* Port PTP Register */
 #define REG_PTP_PORT_RX_DELAY__2	0x0C00
 #define REG_PTP_PORT_TX_DELAY__2	0x0C02
-- 
2.36.1

