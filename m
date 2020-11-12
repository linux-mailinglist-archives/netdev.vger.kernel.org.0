Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5652B08FB
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgKLPxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:53:06 -0500
Received: from mailout08.rmx.de ([94.199.90.85]:34369 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbgKLPxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:53:02 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CX5j60F3QzMqkr;
        Thu, 12 Nov 2020 16:52:58 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CX5gY0yQYz2xG2;
        Thu, 12 Nov 2020 16:51:37 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.59) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 12 Nov
 2020 16:42:02 +0100
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
Subject: [PATCH net-next v2 11/11] net: dsa: microchip: ksz9477: add periodic output support
Date:   Thu, 12 Nov 2020 16:35:37 +0100
Message-ID: <20201112153537.22383-12-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112153537.22383-1-ceggers@arri.de>
References: <20201112153537.22383-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.59]
X-RMX-ID: 20201112-165145-4CX5gY0yQYz2xG2-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KSZ9563 has a Trigger Output Unit (TOU) which can be used to
generate periodic signals.

The pulse length can be altered via a device attribute.

Tested on a Microchip KSZ9563 switch.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/net/dsa/microchip/ksz9477_ptp.c | 197 +++++++++++++++++++++++-
 include/linux/dsa/ksz_common.h          |   6 +
 2 files changed, 202 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.c b/drivers/net/dsa/microchip/ksz9477_ptp.c
index 004bf43d33bf..1babacb9ee0d 100644
--- a/drivers/net/dsa/microchip/ksz9477_ptp.c
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.c
@@ -90,6 +90,20 @@ static int ksz9477_ptp_tou_cycle_count_set(struct ksz_device *dev, u16 count)
 	return 0;
 }
 
+static int ksz9477_ptp_tou_pulse_verify(u64 pulse_ns)
+{
+	u32 data;
+
+	if (pulse_ns & 0x3)
+		return -EINVAL;
+
+	data = (pulse_ns / 8);
+	if (data != (data & TRIG_PULSE_WIDTH_M))
+		return -ERANGE;
+
+	return 0;
+}
+
 static int ksz9477_ptp_tou_pulse_set(struct ksz_device *dev, u32 pulse_ns)
 {
 	u32 data;
@@ -191,6 +205,7 @@ static int ksz9477_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	return 0;
 }
 
+static int ksz9477_ptp_restart_perout(struct ksz_device *dev);
 static int ksz9477_ptp_enable_pps(struct ksz_device *dev, int on);
 
 static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
@@ -234,6 +249,15 @@ static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	case KSZ_PTP_TOU_IDLE:
 		break;
 
+	case KSZ_PTP_TOU_PEROUT:
+		dev_info(dev->dev, "Restarting periodic output signal\n");
+
+		ret = ksz9477_ptp_restart_perout(dev);
+		if (ret)
+			goto error_return;
+
+		break;
+
 	case KSZ_PTP_TOU_PPS:
 		dev_info(dev->dev, "Restarting PPS\n");
 
@@ -348,6 +372,15 @@ static int ksz9477_ptp_settime(struct ptp_clock_info *ptp, struct timespec64 con
 	case KSZ_PTP_TOU_IDLE:
 		break;
 
+	case KSZ_PTP_TOU_PEROUT:
+		dev_info(dev->dev, "Restarting periodic output signal\n");
+
+		ret = ksz9477_ptp_restart_perout(dev);
+		if (ret)
+			goto error_return;
+
+		break;
+
 	case KSZ_PTP_TOU_PPS:
 		dev_info(dev->dev, "Restarting PPS\n");
 
@@ -367,6 +400,159 @@ static int ksz9477_ptp_settime(struct ptp_clock_info *ptp, struct timespec64 con
 	return ret;
 }
 
+static int ksz9477_ptp_configure_perout(struct ksz_device *dev, u32 cycle_width_ns,
+					u16 cycle_count, u32 pulse_width_ns,
+					struct timespec64 const *target_time)
+{
+	int ret;
+	u32 trig_ctrl;
+
+	/* Enable notify, set rising edge, set periodic pattern */
+	trig_ctrl = TRIG_NOTIFY | (TRIG_POS_PERIOD << TRIG_PATTERN_S);
+	ret = ksz_write32(dev, REG_TRIG_CTRL__4, trig_ctrl);
+	if (ret)
+		return ret;
+
+	ret = ksz9477_ptp_tou_cycle_width_set(dev, cycle_width_ns);
+	if (ret)
+		return ret;
+
+	ksz9477_ptp_tou_cycle_count_set(dev,  cycle_count);
+	if (ret)
+		return ret;
+
+	ret = ksz9477_ptp_tou_pulse_set(dev, pulse_width_ns);
+	if (ret)
+		return ret;
+
+	ret = ksz9477_ptp_tou_target_time_set(dev, target_time);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_ptp_enable_perout(struct ksz_device *dev,
+				     struct ptp_perout_request const *perout_request, int on)
+{
+	u32 gpio_stat0;
+	u64 cycle_width_ns;
+	int ret;
+
+	if (dev->ptp_tou_mode != KSZ_PTP_TOU_PEROUT && dev->ptp_tou_mode != KSZ_PTP_TOU_IDLE)
+		return -EBUSY;
+
+	ret = ksz9477_ptp_tou_reset(dev, 0);
+	if (ret)
+		return ret;
+
+	if (!on) {
+		dev->ptp_tou_mode = KSZ_PTP_TOU_IDLE;
+		return 0;  /* success */
+	}
+
+	dev->ptp_perout_target_time_first.tv_sec  = perout_request->start.sec;
+	dev->ptp_perout_target_time_first.tv_nsec = perout_request->start.nsec;
+
+	dev->ptp_perout_period.tv_sec = perout_request->period.sec;
+	dev->ptp_perout_period.tv_nsec = perout_request->period.nsec;
+
+	cycle_width_ns = timespec64_to_ns(&dev->ptp_perout_period);
+	if ((cycle_width_ns & GENMASK(31, 0)) != cycle_width_ns)
+		return -EINVAL;
+
+	if (perout_request->flags & PTP_PEROUT_DUTY_CYCLE) {
+		u64 value = perout_request->on.sec * NSEC_PER_SEC +
+			    perout_request->on.nsec;
+
+		ret = ksz9477_ptp_tou_pulse_verify(value);
+		if (ret)
+			return ret;
+
+		dev->ptp_perout_pulse_width_ns = value;
+	}
+
+	ret = ksz9477_ptp_configure_perout(dev, cycle_width_ns,
+					   dev->ptp_perout_cycle_count,
+					   dev->ptp_perout_pulse_width_ns,
+					   &dev->ptp_perout_target_time_first);
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
+	if (gpio_stat0 & (1 << (0 + TRIG_ERROR_S))) {
+		dev_err(dev->dev, "%s: Trigger unit0 error!\n", __func__);
+		ret = -EIO;
+		/* Unit will be reset on next access */
+		return ret;
+	}
+
+	dev->ptp_tou_mode = KSZ_PTP_TOU_PEROUT;
+	return 0;
+}
+
+static int ksz9477_ptp_restart_perout(struct ksz_device *dev)
+{
+	struct timespec64 now;
+	s64 now_ns, first_ns, period_ns, next_ns;
+	unsigned int count;
+	int ret;
+
+	ret = _ksz9477_ptp_gettime(dev, &now);
+	if (ret)
+		return ret;
+
+	now_ns = timespec64_to_ns(&now);
+	first_ns = timespec64_to_ns(&dev->ptp_perout_target_time_first);
+
+	/* Calculate next perout event based on start time and period */
+	period_ns = timespec64_to_ns(&dev->ptp_perout_period);
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
+				.sec  = dev->ptp_perout_period.tv_sec,
+				.nsec = dev->ptp_perout_period.tv_nsec
+			},
+			.index = 0,
+			.flags = 0,  /* keep current values */
+		};
+		ret = ksz9477_ptp_enable_perout(dev, &perout_request, 1);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 #define KSZ9477_PPS_TOU 0   /* currently fixed to trigger output unit 0 */
 
 static int ksz9477_ptp_enable_pps(struct ksz_device *dev, int on)
@@ -457,6 +643,15 @@ static int ksz9477_ptp_enable(struct ptp_clock_info *ptp, struct ptp_clock_reque
 	int ret;
 
 	switch (req->type) {
+	case PTP_CLK_REQ_PEROUT:
+	{
+		struct ptp_perout_request const *perout_request = &req->perout;
+
+		mutex_lock(&dev->ptp_mutex);
+		ret = ksz9477_ptp_enable_perout(dev, perout_request, on);
+		mutex_unlock(&dev->ptp_mutex);
+		return ret;
+	}
 	case PTP_CLK_REQ_PPS:
 		mutex_lock(&dev->ptp_mutex);
 		ret = ksz9477_ptp_enable_pps(dev, on);
@@ -790,7 +985,7 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 	dev->ptp_caps.max_adj     = 6249999;
 	dev->ptp_caps.n_alarm     = 0;
 	dev->ptp_caps.n_ext_ts    = 0;  /* currently not implemented */
-	dev->ptp_caps.n_per_out   = 0;
+	dev->ptp_caps.n_per_out   = 1;
 	dev->ptp_caps.pps         = 1;
 	dev->ptp_caps.adjfine     = ksz9477_ptp_adjfine;
 	dev->ptp_caps.adjtime     = ksz9477_ptp_adjtime;
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index 375f484ddb31..f5c3db50b60a 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -16,6 +16,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/spinlock.h>
 #include <linux/regmap.h>
+#include <linux/time64.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <net/dsa.h>
@@ -69,6 +70,7 @@ struct ksz_port {
 
 enum ksz_ptp_tou_mode {
 	KSZ_PTP_TOU_IDLE,
+	KSZ_PTP_TOU_PEROUT,
 	KSZ_PTP_TOU_PPS,
 };
 
@@ -131,6 +133,10 @@ struct ksz_device {
 	/* approximated current time, read once per second from hardware */
 	struct timespec64 ptp_clock_time;
 	enum ksz_ptp_tou_mode ptp_tou_mode;
+	struct timespec64 ptp_perout_target_time_first;  /* start of first perout pulse */
+	struct timespec64 ptp_perout_period;
+	u32 ptp_perout_pulse_width_ns;
+	u16 ptp_perout_cycle_count;
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

