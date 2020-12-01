Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3532CA819
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392064AbgLAQVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:21:32 -0500
Received: from mailout04.rmx.de ([94.199.90.94]:44854 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390664AbgLAQVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 11:21:30 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4ClnQN288sz3qs4T;
        Tue,  1 Dec 2020 17:20:44 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4ClnNv2yG1z2xZn;
        Tue,  1 Dec 2020 17:19:27 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.19) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 1 Dec
 2020 17:11:31 +0100
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
Subject: [PATCH net-next v4 9/9] net: dsa: microchip: ksz9477: add periodic output support
Date:   Tue, 1 Dec 2020 17:06:11 +0100
Message-ID: <20201201160611.22129-10-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201201160611.22129-1-ceggers@arri.de>
References: <20201201160611.22129-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.19]
X-RMX-ID: 20201201-171931-4ClnNv2yG1z2xZn-0@kdin01
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
Changes in v4:
--------------
- 80 chars per line
- reverse christmas tree
- Set default pulse width for perout pulse to 50% (max. 125ms)
- reject unsupported flags for perout_request

On Saturday, 21 November 2020, 00:48:08 CET, Vladimir Oltean wrote:
> On Wed, Nov 18, 2020 at 09:30:13PM +0100, Christian Eggers wrote:

> >  static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
> > @@ -241,6 +256,15 @@ static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
> >  	case KSZ_PTP_TOU_IDLE:
> >  		break;
> >  
> > +	case KSZ_PTP_TOU_PEROUT:
> > +		dev_info(dev->dev, "Restarting periodic output signal\n");
> 
> Isn't this a bit too verbose, or is there something for the user to be
> concerned about?
In my setup this message appears only once after ptp4l has been started. Shall
I remove it?

> Watch out for 80 characters, please!
A few long line are left (for instance ksz9477_ptp_enable_perout). Please let
me know how I shall wrap them.

> > +	if (perout_request->flags & PTP_PEROUT_DUTY_CYCLE) {
> > +		u64 value = perout_request->on.sec * NSEC_PER_SEC +
> > +			    perout_request->on.nsec;
> > +
> > +		ret = ksz9477_ptp_tou_pulse_verify(value);
> > +		if (ret)
> > +			return ret;
> > +
> > +		dev->ptp_perout_pulse_width_ns = value;
> > +	}
> 
> It is not guaranteed that user space will set this flag. Shouldn't you
> assign a default value for the pulse width? I don't know, half the
> period should be a good default.
Yes I should. The hardware support a maximum "duty cycle" of a little bit
more than 125 ms. As PPS signals often have a 125 ms high period, I use this
duration as the maximum.

> > +	/* Check error flag:
> > +	 * - the ACTIVE flag is NOT cleared an error!
> > +	 */
> > +	ret = ksz_read32(dev, REG_PTP_TRIG_STATUS__4, &gpio_stat0);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (gpio_stat0 & (1 << (0 + TRIG_ERROR_S))) {
> 
> What is the role of this "0 +" term here?
> 
> > +		dev_err(dev->dev, "%s: Trigger unit0 error!\n", __func__);
This is the index of the used trigger unit.

 drivers/net/dsa/microchip/ksz9477_ptp.c | 357 +++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz9477_ptp.h |   4 +
 drivers/net/dsa/microchip/ksz_common.h  |  10 +
 3 files changed, 369 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.c b/drivers/net/dsa/microchip/ksz9477_ptp.c
index e68c9fc8e679..c3a0275e444a 100644
--- a/drivers/net/dsa/microchip/ksz9477_ptp.c
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.c
@@ -19,6 +19,140 @@
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
@@ -76,6 +210,8 @@ static int ksz9477_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	return ret;
 }
 
+static int ksz9477_ptp_restart_perout(struct ksz_device *dev);
+
 static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
@@ -115,6 +251,20 @@ static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	if (ret)
 		goto error_return;
 
+	switch (dev->ptp_tou_mode) {
+	case KSZ_PTP_TOU_IDLE:
+		break;
+
+	case KSZ_PTP_TOU_PEROUT:
+		dev_info(dev->dev, "Restarting periodic output signal\n");
+
+		ret = ksz9477_ptp_restart_perout(dev);
+		if (ret)
+			goto error_return;
+
+		break;
+	}
+
 	spin_lock_bh(&ptp_shared->ptp_clock_lock);
 	ptp_shared->ptp_clock_time = timespec64_add(ptp_shared->ptp_clock_time,
 						    delta64);
@@ -218,6 +368,20 @@ static int ksz9477_ptp_settime(struct ptp_clock_info *ptp,
 	if (ret)
 		goto error_return;
 
+	switch (dev->ptp_tou_mode) {
+	case KSZ_PTP_TOU_IDLE:
+		break;
+
+	case KSZ_PTP_TOU_PEROUT:
+		dev_info(dev->dev, "Restarting periodic output signal\n");
+
+		ret = ksz9477_ptp_restart_perout(dev);
+		if (ret)
+			goto error_return;
+
+		break;
+	}
+
 	spin_lock_bh(&ptp_shared->ptp_clock_lock);
 	ptp_shared->ptp_clock_time = *ts;
 	spin_unlock_bh(&ptp_shared->ptp_clock_lock);
@@ -227,10 +391,199 @@ static int ksz9477_ptp_settime(struct ptp_clock_info *ptp,
 	return ret;
 }
 
+static int ksz9477_ptp_configure_perout(struct ksz_device *dev,
+					u32 cycle_width_ns, u16 cycle_count,
+					u32 pulse_width_ns,
+					struct timespec64 const *target_time)
+{
+	u32 trig_ctrl;
+	int ret;
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
+#define KSZ9477_PEROUT_VALID_FLAGS ( \
+	PTP_PEROUT_DUTY_CYCLE \
+)
+
+static int ksz9477_ptp_enable_perout(struct ksz_device *dev,
+				     struct ptp_perout_request const *perout_request,
+				     int on)
+{
+	u64 cycle_width_ns;
+	u64 pulse_width_ns;
+	u32 gpio_stat0;
+	int ret;
+
+	if (perout_request->flags & ~KSZ9477_PEROUT_VALID_FLAGS)
+		return -EINVAL;
+
+	if (dev->ptp_tou_mode != KSZ_PTP_TOU_PEROUT &&
+	    dev->ptp_tou_mode != KSZ_PTP_TOU_IDLE)
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
+	if (perout_request->flags & PTP_PEROUT_DUTY_CYCLE)
+		pulse_width_ns = perout_request->on.sec * NSEC_PER_SEC +
+				 perout_request->on.nsec;
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
+	ret = ksz9477_ptp_tou_pulse_verify(pulse_width_ns);
+	if (ret)
+		return ret;
+
+	dev->ptp_perout_pulse_width_ns = pulse_width_ns;
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
+	s64 now_ns, first_ns, period_ns, next_ns;
+	struct timespec64 now;
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
 static int ksz9477_ptp_enable(struct ptp_clock_info *ptp,
 			      struct ptp_clock_request *req, int on)
 {
-	return -EOPNOTSUPP;
+	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
+	int ret;
+
+	switch (req->type) {
+	case PTP_CLK_REQ_PEROUT: {
+		struct ptp_perout_request const *perout_request = &req->perout;
+
+		mutex_lock(&dev->ptp_mutex);
+		ret = ksz9477_ptp_enable_perout(dev, perout_request, on);
+		mutex_unlock(&dev->ptp_mutex);
+		return ret;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static long ksz9477_ptp_do_aux_work(struct ptp_clock_info *ptp)
@@ -592,7 +945,7 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 	dev->ptp_caps.max_adj     = 6249999;
 	dev->ptp_caps.n_alarm     = 0;
 	dev->ptp_caps.n_ext_ts    = 0;  /* currently not implemented */
-	dev->ptp_caps.n_per_out   = 0;
+	dev->ptp_caps.n_per_out   = 1;
 	dev->ptp_caps.pps         = 0;
 	dev->ptp_caps.adjfine     = ksz9477_ptp_adjfine;
 	dev->ptp_caps.adjtime     = ksz9477_ptp_adjtime;
diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.h b/drivers/net/dsa/microchip/ksz9477_ptp.h
index 2f7c4fa0753a..4d20decf0ad7 100644
--- a/drivers/net/dsa/microchip/ksz9477_ptp.h
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.h
@@ -20,6 +20,7 @@
 int ksz9477_ptp_init(struct ksz_device *dev);
 void ksz9477_ptp_deinit(struct ksz_device *dev);
 
+irqreturn_t ksz9477_ptp_interrupt(struct ksz_device *dev);
 irqreturn_t ksz9477_ptp_port_interrupt(struct ksz_device *dev, int port);
 
 int ksz9477_ptp_get_ts_info(struct dsa_switch *ds, int port,
@@ -36,6 +37,9 @@ bool ksz9477_ptp_port_txtstamp(struct dsa_switch *ds, int port,
 static inline int ksz9477_ptp_init(struct ksz_device *dev) { return 0; }
 static inline void ksz9477_ptp_deinit(struct ksz_device *dev) {}
 
+static inline irqreturn_t ksz9477_ptp_interrupt(struct ksz_device *dev)
+{ return IRQ_NONE; }
+
 static inline irqreturn_t ksz9477_ptp_port_interrupt(struct ksz_device *dev,
 						     int port)
 { return IRQ_NONE; }
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 483a2f0e59d2..c9495c92a32d 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -52,6 +52,11 @@ struct ksz_port {
 #endif
 };
 
+enum ksz_ptp_tou_mode {
+	KSZ_PTP_TOU_IDLE,
+	KSZ_PTP_TOU_PEROUT,
+};
+
 struct ksz_device {
 	struct dsa_switch *ds;
 	struct ksz_platform_data *pdata;
@@ -109,6 +114,11 @@ struct ksz_device {
 	struct hwtstamp_config tstamp_config;
 	struct mutex ptp_mutex;		/* protects PTP related hardware */
 	struct ksz_device_ptp_shared ptp_shared;
+	enum ksz_ptp_tou_mode ptp_tou_mode;
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

