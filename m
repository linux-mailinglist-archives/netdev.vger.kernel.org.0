Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6532B08F0
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgKLPvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:51:45 -0500
Received: from mailout07.rmx.de ([94.199.90.95]:34719 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728321AbgKLPvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:51:43 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 4CX5gY155LzBxBs;
        Thu, 12 Nov 2020 16:51:37 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CX5f01cjRz2xc1;
        Thu, 12 Nov 2020 16:50:16 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.59) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 12 Nov
 2020 16:41:32 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 10/11] net: dsa: microchip: ksz9477: add Pulse Per Second (PPS) support
Date:   Thu, 12 Nov 2020 16:35:36 +0100
Message-ID: <20201112153537.22383-11-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112153537.22383-1-ceggers@arri.de>
References: <20201112153537.22383-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.59]
X-RMX-ID: 20201112-165016-4CX5f01cjRz2xc1-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KSZ9563 has a Trigger Output Unit (TOU) which can be used to
generate periodic signals.

After adjusting the PTP clock time, the PPS signal has to be restarted.

Tested on a Microchip KSZ9563 switch.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/net/dsa/microchip/ksz9477_ptp.c | 251 +++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz9477_ptp.h |   2 +
 include/linux/dsa/ksz_common.h          |   6 +
 3 files changed, 257 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.c b/drivers/net/dsa/microchip/ksz9477_ptp.c
index 12698568b68b..004bf43d33bf 100644
--- a/drivers/net/dsa/microchip/ksz9477_ptp.c
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.c
@@ -19,6 +19,126 @@
 #define KSZ_PTP_INC_NS 40  /* HW clock is incremented every 40 ns (by 40) */
 #define KSZ_PTP_SUBNS_BITS 32  /* Number of bits in sub-nanoseconds counter */
 
+/* Shared register access routines (Trigger Output Unit) */
+
+static int ksz9477_ptp_tou_reset(struct ksz_device *dev, unsigned int unit)
+{
+	u32 ctrl_stat, data;
+	int ret;
+
+	/* Reset trigger unit (clears TRIGGER_EN, but not GPIOSTATx) */
+	ret = ksz_read32(dev, REG_PTP_CTRL_STAT__4, &ctrl_stat);
+	if (ret)
+		return ret;
+
+	ctrl_stat |= TRIG_RESET;
+
+	ret = ksz_write32(dev, REG_PTP_CTRL_STAT__4, ctrl_stat);
+	if (ret)
+		return ret;
+
+	/* Clear DONE */
+	data = 1 << (unit + TRIG_DONE_S);
+	ret = ksz_write32(dev, REG_PTP_TRIG_STATUS__4, data);
+	if (ret)
+		return ret;
+
+	/* Clear IRQ */
+	data = 1 << (unit + TRIG_INT_S);
+	ret = ksz_write32(dev, REG_PTP_INT_STATUS__4, data);
+	if (ret)
+		return ret;
+
+	/* Clear reset and set GPIO direction */
+	ctrl_stat &= ~TRIG_ENABLE;  /* clear cached bit :-) */
+	ctrl_stat &= ~TRIG_RESET;
+
+	ret = ksz_write32(dev, REG_PTP_CTRL_STAT__4, ctrl_stat);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_ptp_tou_cycle_width_set(struct ksz_device *dev, u32 width_ns)
+{
+	int ret;
+
+	ret = ksz_write32(dev, REG_TRIG_CYCLE_WIDTH, width_ns);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_ptp_tou_cycle_count_set(struct ksz_device *dev, u16 count)
+{
+	u32 data;
+	int ret;
+
+	ret = ksz_read32(dev, REG_TRIG_CYCLE_CNT, &data);
+	if (ret)
+		return ret;
+
+	data &= ~(TRIG_CYCLE_CNT_M << TRIG_CYCLE_CNT_S);
+	data |= (count & TRIG_CYCLE_CNT_M) << TRIG_CYCLE_CNT_S;
+
+	ret = ksz_write32(dev, REG_TRIG_CYCLE_CNT, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_ptp_tou_pulse_set(struct ksz_device *dev, u32 pulse_ns)
+{
+	u32 data;
+
+	data = (pulse_ns / 8);
+
+	return ksz_write32(dev, REG_TRIG_PULSE_WIDTH__4, data);
+}
+
+static int ksz9477_ptp_tou_target_time_set(struct ksz_device *dev, struct timespec64 const *ts)
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
+static int ksz9477_ptp_tou_start(struct ksz_device *dev, u32 *ctrl_stat_)
+{
+	u32 ctrl_stat;
+	int ret;
+
+	ret = ksz_read32(dev, REG_PTP_CTRL_STAT__4, &ctrl_stat);
+	if (ret)
+		return ret;
+
+	ctrl_stat |= TRIG_ENABLE;
+
+	ret = ksz_write32(dev, REG_PTP_CTRL_STAT__4, ctrl_stat);
+	if (ret)
+		return ret;
+
+	if (ctrl_stat_)
+		*ctrl_stat_ = ctrl_stat;
+
+	return 0;
+}
+
 /* Posix clock support */
 
 static int ksz9477_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
@@ -71,6 +191,8 @@ static int ksz9477_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	return 0;
 }
 
+static int ksz9477_ptp_enable_pps(struct ksz_device *dev, int on);
+
 static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
@@ -108,6 +230,20 @@ static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	if (ret)
 		goto error_return;
 
+	switch (dev->ptp_tou_mode) {
+	case KSZ_PTP_TOU_IDLE:
+		break;
+
+	case KSZ_PTP_TOU_PPS:
+		dev_info(dev->dev, "Restarting PPS\n");
+
+		ret = ksz9477_ptp_enable_pps(dev, 1);
+		if (ret)
+			goto error_return;
+
+		break;
+	}
+
 	spin_lock_irqsave(&dev->ptp_clock_lock, flags);
 	dev->ptp_clock_time = timespec64_add(dev->ptp_clock_time, delta64);
 	spin_unlock_irqrestore(&dev->ptp_clock_lock, flags);
@@ -208,6 +344,20 @@ static int ksz9477_ptp_settime(struct ptp_clock_info *ptp, struct timespec64 con
 	if (ret)
 		goto error_return;
 
+	switch (dev->ptp_tou_mode) {
+	case KSZ_PTP_TOU_IDLE:
+		break;
+
+	case KSZ_PTP_TOU_PPS:
+		dev_info(dev->dev, "Restarting PPS\n");
+
+		ret = ksz9477_ptp_enable_pps(dev, 1);
+		if (ret)
+			goto error_return;
+
+		break;
+	}
+
 	spin_lock_irqsave(&dev->ptp_clock_lock, flags);
 	dev->ptp_clock_time = *ts;
 	spin_unlock_irqrestore(&dev->ptp_clock_lock, flags);
@@ -217,9 +367,106 @@ static int ksz9477_ptp_settime(struct ptp_clock_info *ptp, struct timespec64 con
 	return ret;
 }
 
+#define KSZ9477_PPS_TOU 0   /* currently fixed to trigger output unit 0 */
+
+static int ksz9477_ptp_enable_pps(struct ksz_device *dev, int on)
+{
+	struct timespec64 now, pps_start, diff;
+	u32 gpio_stat0, trig_ctrl;
+	int ret;
+
+	if (dev->ptp_tou_mode != KSZ_PTP_TOU_PPS && dev->ptp_tou_mode != KSZ_PTP_TOU_IDLE)
+		return -EBUSY;
+
+	/* Reset trigger unit 0 */
+	ret = ksz9477_ptp_tou_reset(dev, KSZ9477_PPS_TOU);
+	if (ret)
+		return ret;
+
+	if (!on) {
+		dev->ptp_tou_mode = KSZ_PTP_TOU_IDLE;
+		return 0;  /* success */
+	}
+
+	/* Enable notify, set rising edge, set periodic pulse pattern */
+	trig_ctrl = TRIG_NOTIFY | (TRIG_POS_PERIOD << TRIG_PATTERN_S);
+
+	ret = ksz_write32(dev, REG_TRIG_CTRL__4, trig_ctrl);
+	if (ret)
+		return ret;
+
+	/* Set cycle width (1 s) */
+	ret = ksz9477_ptp_tou_cycle_width_set(dev, NSEC_PER_SEC);
+	if (ret)
+		return ret;
+
+	/* Set cycle count (infinite) */
+	ksz9477_ptp_tou_cycle_count_set(dev, 0);
+	if (ret)
+		return ret;
+
+	/* Set pulse with (125 ms / 8 ns) */
+	ret = ksz9477_ptp_tou_pulse_set(dev, 125000000);
+	if (ret)
+		return ret;
+
+	/* Read current time */
+	ret = _ksz9477_ptp_gettime(dev, &now);
+	if (ret)
+		return ret;
+
+	/* Determine and write start time of PPS */
+	pps_start.tv_sec = now.tv_sec + 1;
+	pps_start.tv_nsec = 0;
+	diff = timespec64_sub(pps_start, now);
+
+	/* Reserve at least 100 ms for programming and activating */
+	if (diff.tv_nsec < 100000000)
+		pps_start.tv_sec++;
+
+	ret = ksz9477_ptp_tou_target_time_set(dev, &pps_start);
+	if (ret)
+		return ret;
+
+	/* Activate trigger unit */
+	ret = ksz9477_ptp_tou_start(dev, NULL);
+	if (ret)
+		return ret;
+
+	/* Check error flag:
+	 * - the ACTIVE flag is NOT cleared an error!
+	 */
+	ret = ksz_read32(dev, REG_PTP_TRIG_STATUS__4, &gpio_stat0);
+	if (ret)
+		return ret;
+
+	if (gpio_stat0 & (1 << (KSZ9477_PPS_TOU + TRIG_ERROR_S))) {
+		dev_err(dev->dev, "%s: Trigger unit error!\n", __func__);
+		ret = -EIO;
+		/* Unit will be reset on next access */
+		return ret;
+	}
+
+	dev->ptp_tou_mode = KSZ_PTP_TOU_PPS;
+	return 0;
+}
+
 static int ksz9477_ptp_enable(struct ptp_clock_info *ptp, struct ptp_clock_request *req, int on)
 {
-	return -ENOTTY;
+	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
+	int ret;
+
+	switch (req->type) {
+	case PTP_CLK_REQ_PPS:
+		mutex_lock(&dev->ptp_mutex);
+		ret = ksz9477_ptp_enable_pps(dev, on);
+		mutex_unlock(&dev->ptp_mutex);
+		return ret;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static long ksz9477_ptp_do_aux_work(struct ptp_clock_info *ptp)
@@ -544,7 +791,7 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 	dev->ptp_caps.n_alarm     = 0;
 	dev->ptp_caps.n_ext_ts    = 0;  /* currently not implemented */
 	dev->ptp_caps.n_per_out   = 0;
-	dev->ptp_caps.pps         = 0;
+	dev->ptp_caps.pps         = 1;
 	dev->ptp_caps.adjfine     = ksz9477_ptp_adjfine;
 	dev->ptp_caps.adjtime     = ksz9477_ptp_adjtime;
 	dev->ptp_caps.gettime64   = ksz9477_ptp_gettime;
diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.h b/drivers/net/dsa/microchip/ksz9477_ptp.h
index e8d50a086311..03058e795678 100644
--- a/drivers/net/dsa/microchip/ksz9477_ptp.h
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.h
@@ -20,6 +20,7 @@
 int ksz9477_ptp_init(struct ksz_device *dev);
 void ksz9477_ptp_deinit(struct ksz_device *dev);
 
+irqreturn_t ksz9477_ptp_interrupt(struct ksz_device *dev);
 irqreturn_t ksz9477_ptp_port_interrupt(struct ksz_device *dev, int port);
 
 int ksz9477_ptp_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts);
@@ -33,6 +34,7 @@ bool ksz9477_ptp_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *
 static inline int ksz9477_ptp_init(struct ksz_device *dev) { return 0; }
 static inline void ksz9477_ptp_deinit(struct ksz_device *dev) {}
 
+static inline irqreturn_t ksz9477_ptp_interrupt(struct ksz_device *dev) { return IRQ_NONE; }
 static inline irqreturn_t ksz9477_ptp_port_interrupt(struct ksz_device *dev, int port)
 	{ return IRQ_NONE; }
 
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index bfe8873b1636..375f484ddb31 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -67,6 +67,11 @@ struct ksz_port {
 #endif
 };
 
+enum ksz_ptp_tou_mode {
+	KSZ_PTP_TOU_IDLE,
+	KSZ_PTP_TOU_PPS,
+};
+
 struct ksz_device {
 	struct dsa_switch *ds;
 	struct ksz_platform_data *pdata;
@@ -125,6 +130,7 @@ struct ksz_device {
 	spinlock_t ptp_clock_lock; /* for ptp_clock_time */
 	/* approximated current time, read once per second from hardware */
 	struct timespec64 ptp_clock_time;
+	enum ksz_ptp_tou_mode ptp_tou_mode;
 #endif
 };
 
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

