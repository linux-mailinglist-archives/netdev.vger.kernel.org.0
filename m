Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7FB4D5303
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244846AbiCJUUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244884AbiCJUU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:20:28 -0500
Received: from smtp7.emailarray.com (smtp7.emailarray.com [65.39.216.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA8818023B
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 12:19:22 -0800 (PST)
Received: (qmail 68846 invoked by uid 89); 10 Mar 2022 20:19:21 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 10 Mar 2022 20:19:21 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v2 06/10] ptp: ocp: Add signal generators and update sysfs nodes
Date:   Thu, 10 Mar 2022 12:19:08 -0800
Message-Id: <20220310201912.933172-7-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220310201912.933172-1-jonathan.lemon@gmail.com>
References: <20220310201912.933172-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer firmware provides 4 programmable signal generators, add
support for those here.  The signal generators provide the
ability to set the period, duty cycle, phase offset, and polarity,
with new values defaulting to prior values.

The period and phase offset are specified in nanoseconds.

E.g:    period [duty [phase [polarity]]]

  echo 500000000 > signal	# 1/2 second period
  echo 1000000 40 100 > signal	# 1ms period, 40% on, offset 100ns
  echo 0 > signal		# turn off generator

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 486 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 476 insertions(+), 10 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index e55dc9586ec0..397e3e6b840f 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -179,6 +179,26 @@ struct dcf_slave_reg {
 
 #define DCF_S_CTRL_ENABLE	BIT(0)
 
+struct signal_reg {
+	u32	enable;
+	u32	status;
+	u32	polarity;
+	u32	version;
+	u32	__pad0[4];
+	u32	cable_delay;
+	u32	__pad1[3];
+	u32	intr;
+	u32	intr_mask;
+	u32	__pad2[2];
+	u32	start_ns;
+	u32	start_sec;
+	u32	pulse_ns;
+	u32	pulse_sec;
+	u32	period_ns;
+	u32	period_sec;
+	u32	repeat_count;
+};
+
 struct ptp_ocp_flash_info {
 	const char *name;
 	int pci_offset;
@@ -224,6 +244,17 @@ struct ocp_attr_group {
 };
 
 #define OCP_CAP_BASIC	BIT(0)
+#define OCP_CAP_SIGNAL	BIT(1)
+
+struct ptp_ocp_signal {
+	ktime_t		period;
+	ktime_t		pulse;
+	ktime_t		phase;
+	ktime_t		start;
+	int		duty;
+	bool		polarity;
+	bool		running;
+};
 
 #define OCP_BOARD_ID_LEN		13
 #define OCP_SERIAL_LEN			6
@@ -244,6 +275,7 @@ struct ptp_ocp {
 	struct dcf_master_reg	__iomem *dcf_out;
 	struct dcf_slave_reg	__iomem *dcf_in;
 	struct tod_reg		__iomem *nmea_out;
+	struct ptp_ocp_ext_src	*signal_out[4];
 	struct ptp_ocp_ext_src	*pps;
 	struct ptp_ocp_ext_src	*ts0;
 	struct ptp_ocp_ext_src	*ts1;
@@ -274,6 +306,7 @@ struct ptp_ocp {
 	u32			utc_tai_offset;
 	u32			ts_window_adjust;
 	u64			fw_cap;
+	struct ptp_ocp_signal	signal[4];
 	struct ptp_ocp_sma_connector sma[4];
 };
 
@@ -297,7 +330,10 @@ static int ptp_ocp_register_serial(struct ptp_ocp *bp, struct ocp_resource *r);
 static int ptp_ocp_register_ext(struct ptp_ocp *bp, struct ocp_resource *r);
 static int ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r);
 static irqreturn_t ptp_ocp_ts_irq(int irq, void *priv);
+static irqreturn_t ptp_ocp_signal_irq(int irq, void *priv);
 static int ptp_ocp_ts_enable(void *priv, u32 req, bool enable);
+static int ptp_ocp_signal_enable(void *priv, u32 req, bool enable);
+static int ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr);
 
 static const struct ocp_attr_group fb_timecard_groups[];
 
@@ -358,6 +394,10 @@ static struct ptp_ocp_eeprom_map fb_eeprom_map[] = {
  * 8: HWICAP (notused)
  * 9: SPI Flash
  * 10: NMEA
+ * 11: Signal Generator 1
+ * 12: Signal Generator 2
+ * 13: Signal Generator 3
+ * 14: Signal Generator 4
  */
 
 static struct ocp_resource ocp_fb_resource[] = {
@@ -401,6 +441,42 @@ static struct ocp_resource ocp_fb_resource[] = {
 			.enable = ptp_ocp_ts_enable,
 		},
 	},
+	{
+		OCP_EXT_RESOURCE(signal_out[0]),
+		.offset = 0x010D0000, .size = 0x10000, .irq_vec = 11,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 1,
+			.irq_fcn = ptp_ocp_signal_irq,
+			.enable = ptp_ocp_signal_enable,
+		},
+	},
+	{
+		OCP_EXT_RESOURCE(signal_out[1]),
+		.offset = 0x010E0000, .size = 0x10000, .irq_vec = 12,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 2,
+			.irq_fcn = ptp_ocp_signal_irq,
+			.enable = ptp_ocp_signal_enable,
+		},
+	},
+	{
+		OCP_EXT_RESOURCE(signal_out[2]),
+		.offset = 0x010F0000, .size = 0x10000, .irq_vec = 13,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 3,
+			.irq_fcn = ptp_ocp_signal_irq,
+			.enable = ptp_ocp_signal_enable,
+		},
+	},
+	{
+		OCP_EXT_RESOURCE(signal_out[3]),
+		.offset = 0x01100000, .size = 0x10000, .irq_vec = 14,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 4,
+			.irq_fcn = ptp_ocp_signal_irq,
+			.enable = ptp_ocp_signal_enable,
+		},
+	},
 	{
 		OCP_MEM_RESOURCE(pps_to_ext),
 		.offset = 0x01030000, .size = 0x10000,
@@ -548,15 +624,19 @@ static struct ocp_selector ptp_ocp_sma_in[] = {
 };
 
 static struct ocp_selector ptp_ocp_sma_out[] = {
-	{ .name = "10Mhz",	.value = 0x00 },
-	{ .name = "PHC",	.value = 0x01 },
-	{ .name = "MAC",	.value = 0x02 },
-	{ .name = "GNSS1",	.value = 0x04 },
-	{ .name = "GNSS2",	.value = 0x08 },
-	{ .name = "IRIG",	.value = 0x10 },
-	{ .name = "DCF",	.value = 0x20 },
-	{ .name = "GND",        .value = 0x2000 },
-	{ .name = "VCC",        .value = 0x4000 },
+	{ .name = "10Mhz",	.value = 0x0000 },
+	{ .name = "PHC",	.value = 0x0001 },
+	{ .name = "MAC",	.value = 0x0002 },
+	{ .name = "GNSS1",	.value = 0x0004 },
+	{ .name = "GNSS2",	.value = 0x0008 },
+	{ .name = "IRIG",	.value = 0x0010 },
+	{ .name = "DCF",	.value = 0x0020 },
+	{ .name = "GEN1",	.value = 0x0040 },
+	{ .name = "GEN2",	.value = 0x0080 },
+	{ .name = "GEN3",	.value = 0x0100 },
+	{ .name = "GEN4",	.value = 0x0200 },
+	{ .name = "GND",	.value = 0x2000 },
+	{ .name = "VCC",	.value = 0x4000 },
 	{ }
 };
 
@@ -1319,6 +1399,113 @@ ptp_ocp_register_i2c(struct ptp_ocp *bp, struct ocp_resource *r)
 	return 0;
 }
 
+/* The expectation is that this is triggered only on error. */
+static irqreturn_t
+ptp_ocp_signal_irq(int irq, void *priv)
+{
+	struct ptp_ocp_ext_src *ext = priv;
+	struct signal_reg __iomem *reg = ext->mem;
+	struct ptp_ocp *bp = ext->bp;
+	u32 enable, status;
+	int gen;
+
+	gen = ext->info->index - 1;
+
+	enable = ioread32(&reg->enable);
+	status = ioread32(&reg->status);
+
+	/* disable generator on error */
+	if (status || !enable) {
+		iowrite32(0, &reg->intr_mask);
+		iowrite32(0, &reg->enable);
+		bp->signal[gen].running = false;
+	}
+
+	iowrite32(0, &reg->intr);	/* ack interrupt */
+
+	return IRQ_HANDLED;
+}
+
+static int
+ptp_ocp_signal_set(struct ptp_ocp *bp, int gen, struct ptp_ocp_signal *s)
+{
+	struct ptp_system_timestamp sts;
+	struct timespec64 ts;
+	ktime_t start_ns;
+	int err;
+
+	if (!s->period)
+		return 0;
+
+	if (!s->pulse)
+		s->pulse = ktime_divns(s->period * s->duty, 100);
+
+	err = ptp_ocp_gettimex(&bp->ptp_info, &ts, &sts);
+	if (err)
+		return err;
+
+	start_ns = ktime_set(ts.tv_sec, ts.tv_nsec) + NSEC_PER_MSEC;
+	if (!s->start) {
+		/* roundup() does not work on 32-bit systems */
+		s->start = DIV_ROUND_UP_ULL(start_ns, s->period);
+		s->start = ktime_add(s->start, s->phase);
+	}
+
+	if (s->duty < 1 || s->duty > 99)
+		return -EINVAL;
+
+	if (s->pulse < 1 || s->pulse > s->period)
+		return -EINVAL;
+
+	if (s->start < start_ns)
+		return -EINVAL;
+
+	bp->signal[gen] = *s;
+
+	return 0;
+}
+
+static int
+ptp_ocp_signal_enable(void *priv, u32 req, bool enable)
+{
+	struct ptp_ocp_ext_src *ext = priv;
+	struct signal_reg __iomem *reg = ext->mem;
+	struct ptp_ocp *bp = ext->bp;
+	struct timespec64 ts;
+	int gen;
+
+	gen = ext->info->index - 1;
+
+	iowrite32(0, &reg->intr_mask);
+	iowrite32(0, &reg->enable);
+	bp->signal[gen].running = false;
+	if (!enable)
+		return 0;
+
+	ts = ktime_to_timespec64(bp->signal[gen].start);
+	iowrite32(ts.tv_sec, &reg->start_sec);
+	iowrite32(ts.tv_nsec, &reg->start_ns);
+
+	ts = ktime_to_timespec64(bp->signal[gen].period);
+	iowrite32(ts.tv_sec, &reg->period_sec);
+	iowrite32(ts.tv_nsec, &reg->period_ns);
+
+	ts = ktime_to_timespec64(bp->signal[gen].pulse);
+	iowrite32(ts.tv_sec, &reg->pulse_sec);
+	iowrite32(ts.tv_nsec, &reg->pulse_ns);
+
+	iowrite32(bp->signal[gen].polarity, &reg->polarity);
+	iowrite32(0, &reg->repeat_count);
+
+	iowrite32(0, &reg->intr);		/* clear interrupt state */
+	iowrite32(1, &reg->intr_mask);		/* enable interrupt */
+	iowrite32(3, &reg->enable);		/* valid & enable */
+
+	bp->signal[gen].running = true;
+
+	return 0;
+}
+
 static irqreturn_t
 ptp_ocp_ts_irq(int irq, void *priv)
 {
@@ -1491,6 +1678,29 @@ ptp_ocp_nmea_out_init(struct ptp_ocp *bp)
 	iowrite32(1, &bp->nmea_out->ctrl);		/* enable */
 }
 
+static void
+_ptp_ocp_signal_init(struct ptp_ocp_signal *s, struct signal_reg __iomem *reg)
+{
+	u32 val;
+
+	iowrite32(0, &reg->enable);		/* disable */
+
+	val = ioread32(&reg->polarity);
+	s->polarity = val ? true : false;
+	s->duty = 50;
+}
+
+static void
+ptp_ocp_signal_init(struct ptp_ocp *bp)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		if (bp->signal_out[i])
+			_ptp_ocp_signal_init(&bp->signal[i],
+					     bp->signal_out[i]->mem);
+}
+
 static void
 ptp_ocp_sma_init(struct ptp_ocp *bp)
 {
@@ -1534,15 +1744,22 @@ ptp_ocp_sma_init(struct ptp_ocp *bp)
 static int
 ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 {
+	int ver;
+
 	bp->flash_start = 1024 * 4096;
 	bp->eeprom_map = fb_eeprom_map;
 	bp->fw_version = ioread32(&bp->image->version);
 	bp->attr_tbl = fb_timecard_groups;
 	bp->fw_cap = OCP_CAP_BASIC;
 
+	ver = bp->fw_version & 0xffff;
+	if (ver >= 19)
+		bp->fw_cap |= OCP_CAP_SIGNAL;
+
 	ptp_ocp_tod_init(bp);
 	ptp_ocp_nmea_out_init(bp);
 	ptp_ocp_sma_init(bp);
+	ptp_ocp_signal_init(bp);
 
 	return ptp_ocp_init_clock(bp);
 }
@@ -1946,6 +2163,189 @@ available_sma_outputs_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_sma_outputs);
 
+#define EXT_ATTR_RO(_group, _name, _val)				\
+	struct dev_ext_attribute dev_attr_##_group##_val##_##_name =	\
+		{ __ATTR_RO(_name), (void *)_val }
+#define EXT_ATTR_RW(_group, _name, _val)				\
+	struct dev_ext_attribute dev_attr_##_group##_val##_##_name =	\
+		{ __ATTR_RW(_name), (void *)_val }
+#define to_ext_attr(x) container_of(x, struct dev_ext_attribute, attr)
+
+/* period [duty [phase [polarity]]] */
+static ssize_t
+signal_store(struct device *dev, struct device_attribute *attr,
+	     const char *buf, size_t count)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	struct ptp_ocp_signal s = { };
+	int gen = (uintptr_t)ea->var;
+	int argc, err;
+	char **argv;
+
+	argv = argv_split(GFP_KERNEL, buf, &argc);
+	if (!argv)
+		return -ENOMEM;
+
+	err = -EINVAL;
+	s.duty = bp->signal[gen].duty;
+	s.phase = bp->signal[gen].phase;
+	s.period = bp->signal[gen].period;
+	s.polarity = bp->signal[gen].polarity;
+
+	switch (argc) {
+	case 4:
+		argc--;
+		err = kstrtobool(argv[argc], &s.polarity);
+		if (err)
+			goto out;
+		fallthrough;
+	case 3:
+		argc--;
+		err = kstrtou64(argv[argc], 0, &s.phase);
+		if (err)
+			goto out;
+		fallthrough;
+	case 2:
+		argc--;
+		err = kstrtoint(argv[argc], 0, &s.duty);
+		if (err)
+			goto out;
+		fallthrough;
+	case 1:
+		argc--;
+		err = kstrtou64(argv[argc], 0, &s.period);
+		if (err)
+			goto out;
+		break;
+	default:
+		goto out;
+	}
+
+	err = ptp_ocp_signal_set(bp, gen, &s);
+	if (err)
+		goto out;
+
+	err = ptp_ocp_signal_enable(bp->signal_out[gen], gen, s.period != 0);
+
+out:
+	argv_free(argv);
+	return err ? err : count;
+}
+
+static ssize_t
+signal_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	struct ptp_ocp_signal *signal;
+	struct timespec64 ts;
+	ssize_t count;
+	int i;
+
+	i = (uintptr_t)ea->var;
+	signal = &bp->signal[i];
+
+	count = sysfs_emit(buf, "%llu %d %llu %d", signal->period,
+			   signal->duty, signal->phase, signal->polarity);
+
+	ts = ktime_to_timespec64(signal->start);
+	count += sysfs_emit_at(buf, count, " %ptT TAI\n", &ts);
+
+	return count;
+}
+static EXT_ATTR_RW(signal, signal, 0);
+static EXT_ATTR_RW(signal, signal, 1);
+static EXT_ATTR_RW(signal, signal, 2);
+static EXT_ATTR_RW(signal, signal, 3);
+
+static ssize_t
+duty_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int i = (uintptr_t)ea->var;
+
+	return sysfs_emit(buf, "%d\n", bp->signal[i].duty);
+}
+static EXT_ATTR_RO(signal, duty, 0);
+static EXT_ATTR_RO(signal, duty, 1);
+static EXT_ATTR_RO(signal, duty, 2);
+static EXT_ATTR_RO(signal, duty, 3);
+
+static ssize_t
+period_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int i = (uintptr_t)ea->var;
+
+	return sysfs_emit(buf, "%llu\n", bp->signal[i].period);
+}
+static EXT_ATTR_RO(signal, period, 0);
+static EXT_ATTR_RO(signal, period, 1);
+static EXT_ATTR_RO(signal, period, 2);
+static EXT_ATTR_RO(signal, period, 3);
+
+static ssize_t
+phase_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int i = (uintptr_t)ea->var;
+
+	return sysfs_emit(buf, "%llu\n", bp->signal[i].phase);
+}
+static EXT_ATTR_RO(signal, phase, 0);
+static EXT_ATTR_RO(signal, phase, 1);
+static EXT_ATTR_RO(signal, phase, 2);
+static EXT_ATTR_RO(signal, phase, 3);
+
+static ssize_t
+polarity_show(struct device *dev, struct device_attribute *attr,
+	      char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int i = (uintptr_t)ea->var;
+
+	return sysfs_emit(buf, "%d\n", bp->signal[i].polarity);
+}
+static EXT_ATTR_RO(signal, polarity, 0);
+static EXT_ATTR_RO(signal, polarity, 1);
+static EXT_ATTR_RO(signal, polarity, 2);
+static EXT_ATTR_RO(signal, polarity, 3);
+
+static ssize_t
+running_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int i = (uintptr_t)ea->var;
+
+	return sysfs_emit(buf, "%d\n", bp->signal[i].running);
+}
+static EXT_ATTR_RO(signal, running, 0);
+static EXT_ATTR_RO(signal, running, 1);
+static EXT_ATTR_RO(signal, running, 2);
+static EXT_ATTR_RO(signal, running, 3);
+
+static ssize_t
+start_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int i = (uintptr_t)ea->var;
+	struct timespec64 ts;
+
+	ts = ktime_to_timespec64(bp->signal[i].start);
+	return sysfs_emit(buf, "%llu.%lu\n", ts.tv_sec, ts.tv_nsec);
+}
+static EXT_ATTR_RO(signal, start, 0);
+static EXT_ATTR_RO(signal, start, 1);
+static EXT_ATTR_RO(signal, start, 2);
+static EXT_ATTR_RO(signal, start, 3);
+
 static ssize_t
 serialnum_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -2180,6 +2580,31 @@ tod_correction_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(tod_correction);
 
+#define _DEVICE_SIGNAL_GROUP_ATTRS(_nr)					\
+	static struct attribute *fb_timecard_signal##_nr##_attrs[] = {	\
+		&dev_attr_signal##_nr##_signal.attr.attr,		\
+		&dev_attr_signal##_nr##_duty.attr.attr,			\
+		&dev_attr_signal##_nr##_phase.attr.attr,		\
+		&dev_attr_signal##_nr##_period.attr.attr,		\
+		&dev_attr_signal##_nr##_polarity.attr.attr,		\
+		&dev_attr_signal##_nr##_running.attr.attr,		\
+		&dev_attr_signal##_nr##_start.attr.attr,		\
+		NULL,							\
+	}
+
+#define DEVICE_SIGNAL_GROUP(_name, _nr)					\
+	_DEVICE_SIGNAL_GROUP_ATTRS(_nr);				\
+	static const struct attribute_group				\
+			fb_timecard_signal##_nr##_group = {		\
+		.name = #_name,						\
+		.attrs = fb_timecard_signal##_nr##_attrs,		\
+}
+
+DEVICE_SIGNAL_GROUP(gen1, 0);
+DEVICE_SIGNAL_GROUP(gen2, 1);
+DEVICE_SIGNAL_GROUP(gen3, 2);
+DEVICE_SIGNAL_GROUP(gen4, 3);
+
 static struct attribute *fb_timecard_attrs[] = {
 	&dev_attr_serialnum.attr,
 	&dev_attr_gnss_sync.attr,
@@ -2204,6 +2629,10 @@ static const struct attribute_group fb_timecard_group = {
 };
 static const struct ocp_attr_group fb_timecard_groups[] = {
 	{ .cap = OCP_CAP_BASIC,	    .group = &fb_timecard_group },
+	{ .cap = OCP_CAP_SIGNAL,    .group = &fb_timecard_signal0_group },
+	{ .cap = OCP_CAP_SIGNAL,    .group = &fb_timecard_signal1_group },
+	{ .cap = OCP_CAP_SIGNAL,    .group = &fb_timecard_signal2_group },
+	{ .cap = OCP_CAP_SIGNAL,    .group = &fb_timecard_signal3_group },
 	{ },
 };
 
@@ -2241,6 +2670,33 @@ gpio_output_map(char *buf, struct ptp_ocp *bp, u16 map[][2], u16 bit)
 	}
 }
 
+static void
+_signal_summary_show(struct seq_file *s, struct ptp_ocp *bp, int nr)
+{
+	struct signal_reg __iomem *reg = bp->signal_out[nr]->mem;
+	struct ptp_ocp_signal *signal = &bp->signal[nr];
+	char label[8];
+	bool on;
+	u32 val;
+
+	if (!signal)
+		return;
+
+	on = signal->running;
+	sprintf(label, "GEN%d", nr);
+	seq_printf(s, "%7s: %s, period:%llu duty:%d%% phase:%llu pol:%d",
+		   label, on ? " ON" : "OFF",
+		   signal->period, signal->duty, signal->phase,
+		   signal->polarity);
+
+	val = ioread32(&reg->enable);
+	seq_printf(s, " [%x", val);
+	val = ioread32(&reg->status);
+	seq_printf(s, " %x]", val);
+
+	seq_printf(s, " start:%llu\n", signal->start);
+}
+
 static int
 ptp_ocp_summary_show(struct seq_file *s, void *data)
 {
@@ -2252,6 +2708,7 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	struct ptp_ocp *bp;
 	char *src, *buf;
 	bool on, map;
+	int i;
 
 	buf = (char *)__get_free_page(GFP_KERNEL);
 	if (!buf)
@@ -2343,6 +2800,10 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 			   on && map ? " ON" : "OFF", src);
 	}
 
+	if (bp->fw_cap & OCP_CAP_SIGNAL)
+		for (i = 0; i < 4; i++)
+			_signal_summary_show(s, bp, i);
+
 	if (bp->irig_out) {
 		ctrl = ioread32(&bp->irig_out->ctrl);
 		on = ctrl & IRIG_M_CTRL_ENABLE;
@@ -2742,6 +3203,8 @@ ptp_ocp_detach_sysfs(struct ptp_ocp *bp)
 static void
 ptp_ocp_detach(struct ptp_ocp *bp)
 {
+	int i;
+
 	ptp_ocp_debugfs_remove_device(bp);
 	ptp_ocp_detach_sysfs(bp);
 	if (timer_pending(&bp->watchdog))
@@ -2754,6 +3217,9 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 		ptp_ocp_unregister_ext(bp->ts2);
 	if (bp->pps)
 		ptp_ocp_unregister_ext(bp->pps);
+	for (i = 0; i < 4; i++)
+		if (bp->signal_out[i])
+			ptp_ocp_unregister_ext(bp->signal_out[i]);
 	if (bp->gnss_port != -1)
 		serial8250_unregister_port(bp->gnss_port);
 	if (bp->gnss2_port != -1)
@@ -2804,7 +3270,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * allow this - if not all of the IRQ's are returned, skip the
 	 * extra devices and just register the clock.
 	 */
-	err = pci_alloc_irq_vectors(pdev, 1, 11, PCI_IRQ_MSI | PCI_IRQ_MSIX);
+	err = pci_alloc_irq_vectors(pdev, 1, 15, PCI_IRQ_MSI | PCI_IRQ_MSIX);
 	if (err < 0) {
 		dev_err(&pdev->dev, "alloc_irq_vectors err: %d\n", err);
 		goto out;
-- 
2.31.1

