Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29304D5305
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245006AbiCJUUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244924AbiCJUU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:20:29 -0500
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537F2180D35
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 12:19:25 -0800 (PST)
Received: (qmail 86875 invoked by uid 89); 10 Mar 2022 20:19:24 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 10 Mar 2022 20:19:24 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v2 08/10] ptp: ocp: Add 4 frequency counters
Date:   Thu, 10 Mar 2022 12:19:10 -0800
Message-Id: <20220310201912.933172-9-jonathan.lemon@gmail.com>
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

Input signals can be steered to any of the frequency counters.
The counter measures the frequency over a number of seconds:

  echo 0 > freq1/seconds  = turns off measurement
  echo 1 > freq1/seconds  = sets period & turns on measurment.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 172 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 165 insertions(+), 7 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 002b3d00996e..d2ef4e7fcc47 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -199,6 +199,15 @@ struct signal_reg {
 	u32	repeat_count;
 };
 
+struct frequency_reg {
+	u32	ctrl;
+	u32	status;
+};
+#define FREQ_STATUS_VALID	BIT(31)
+#define FREQ_STATUS_ERROR	BIT(30)
+#define FREQ_STATUS_OVERRUN	BIT(29)
+#define FREQ_STATUS_MASK	(BIT(24) - 1)
+
 struct ptp_ocp_flash_info {
 	const char *name;
 	int pci_offset;
@@ -245,6 +254,7 @@ struct ocp_attr_group {
 
 #define OCP_CAP_BASIC	BIT(0)
 #define OCP_CAP_SIGNAL	BIT(1)
+#define OCP_CAP_FREQ	BIT(2)
 
 struct ptp_ocp_signal {
 	ktime_t		period;
@@ -275,6 +285,7 @@ struct ptp_ocp {
 	struct dcf_master_reg	__iomem *dcf_out;
 	struct dcf_slave_reg	__iomem *dcf_in;
 	struct tod_reg		__iomem *nmea_out;
+	struct frequency_reg	__iomem *freq_in[4];
 	struct ptp_ocp_ext_src	*signal_out[4];
 	struct ptp_ocp_ext_src	*pps;
 	struct ptp_ocp_ext_src	*ts0;
@@ -576,6 +587,22 @@ static struct ocp_resource ocp_fb_resource[] = {
 			},
 		},
 	},
+	{
+		OCP_MEM_RESOURCE(freq_in[0]),
+		.offset = 0x01200000, .size = 0x10000,
+	},
+	{
+		OCP_MEM_RESOURCE(freq_in[1]),
+		.offset = 0x01210000, .size = 0x10000,
+	},
+	{
+		OCP_MEM_RESOURCE(freq_in[2]),
+		.offset = 0x01220000, .size = 0x10000,
+	},
+	{
+		OCP_MEM_RESOURCE(freq_in[3]),
+		.offset = 0x01230000, .size = 0x10000,
+	},
 	{
 		.setup = ptp_ocp_fb_board_init,
 	},
@@ -614,13 +641,17 @@ static struct ocp_selector ptp_ocp_clock[] = {
 #define SMA_DISABLE		0x10000
 
 static struct ocp_selector ptp_ocp_sma_in[] = {
-	{ .name = "10Mhz",	.value = 0x00 },
-	{ .name = "PPS1",	.value = 0x01 },
-	{ .name = "PPS2",	.value = 0x02 },
-	{ .name = "TS1",	.value = 0x04 },
-	{ .name = "TS2",	.value = 0x08 },
-	{ .name = "IRIG",	.value = 0x10 },
-	{ .name = "DCF",	.value = 0x20 },
+	{ .name = "10Mhz",	.value = 0x0000 },
+	{ .name = "PPS1",	.value = 0x0001 },
+	{ .name = "PPS2",	.value = 0x0002 },
+	{ .name = "TS1",	.value = 0x0004 },
+	{ .name = "TS2",	.value = 0x0008 },
+	{ .name = "IRIG",	.value = 0x0010 },
+	{ .name = "DCF",	.value = 0x0020 },
+	{ .name = "FREQ1",	.value = 0x0100 },
+	{ .name = "FREQ2",	.value = 0x0200 },
+	{ .name = "FREQ3",	.value = 0x0400 },
+	{ .name = "FREQ4",	.value = 0x0800 },
 	{ .name = "None",	.value = SMA_DISABLE },
 	{ }
 };
@@ -1835,6 +1866,8 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	ver = bp->fw_version & 0xffff;
 	if (ver >= 19)
 		bp->fw_cap |= OCP_CAP_SIGNAL;
+	if (ver >= 20)
+		bp->fw_cap |= OCP_CAP_FREQ;
 
 	ptp_ocp_tod_init(bp);
 	ptp_ocp_nmea_out_init(bp);
@@ -2430,6 +2463,73 @@ static EXT_ATTR_RO(signal, start, 1);
 static EXT_ATTR_RO(signal, start, 2);
 static EXT_ATTR_RO(signal, start, 3);
 
+static ssize_t
+seconds_store(struct device *dev, struct device_attribute *attr,
+	      const char *buf, size_t count)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int idx = (uintptr_t)ea->var;
+	u32 val;
+	int err;
+
+	err = kstrtou32(buf, 0, &val);
+	if (err)
+		return err;
+	if (val > 0xff)
+		return -EINVAL;
+
+	if (val)
+		val = (val << 8) | 0x1;
+
+	iowrite32(val, &bp->freq_in[idx]->ctrl);
+
+	return count;
+}
+
+static ssize_t
+seconds_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int idx = (uintptr_t)ea->var;
+	u32 val;
+
+	val = ioread32(&bp->freq_in[idx]->ctrl);
+	if (val & 1)
+		val = (val >> 8) & 0xff;
+	else
+		val = 0;
+
+	return sysfs_emit(buf, "%u\n", val);
+}
+static EXT_ATTR_RW(freq, seconds, 0);
+static EXT_ATTR_RW(freq, seconds, 1);
+static EXT_ATTR_RW(freq, seconds, 2);
+static EXT_ATTR_RW(freq, seconds, 3);
+
+static ssize_t
+frequency_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int idx = (uintptr_t)ea->var;
+	u32 val;
+
+	val = ioread32(&bp->freq_in[idx]->status);
+	if (val & FREQ_STATUS_ERROR)
+		return sysfs_emit(buf, "error\n");
+	if (val & FREQ_STATUS_OVERRUN)
+		return sysfs_emit(buf, "overrun\n");
+	if (val & FREQ_STATUS_VALID)
+		return sysfs_emit(buf, "%lu\n", val & FREQ_STATUS_MASK);
+	return 0;
+}
+static EXT_ATTR_RO(freq, frequency, 0);
+static EXT_ATTR_RO(freq, frequency, 1);
+static EXT_ATTR_RO(freq, frequency, 2);
+static EXT_ATTR_RO(freq, frequency, 3);
+
 static ssize_t
 serialnum_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -2689,6 +2789,26 @@ DEVICE_SIGNAL_GROUP(gen2, 1);
 DEVICE_SIGNAL_GROUP(gen3, 2);
 DEVICE_SIGNAL_GROUP(gen4, 3);
 
+#define _DEVICE_FREQ_GROUP_ATTRS(_nr)					\
+	static struct attribute *fb_timecard_freq##_nr##_attrs[] = {	\
+		&dev_attr_freq##_nr##_seconds.attr.attr,		\
+		&dev_attr_freq##_nr##_frequency.attr.attr,		\
+		NULL,							\
+	}
+
+#define DEVICE_FREQ_GROUP(_name, _nr)					\
+	_DEVICE_FREQ_GROUP_ATTRS(_nr);					\
+	static const struct attribute_group				\
+			fb_timecard_freq##_nr##_group = {		\
+		.name = #_name,						\
+		.attrs = fb_timecard_freq##_nr##_attrs,			\
+}
+
+DEVICE_FREQ_GROUP(freq1, 0);
+DEVICE_FREQ_GROUP(freq2, 1);
+DEVICE_FREQ_GROUP(freq3, 2);
+DEVICE_FREQ_GROUP(freq4, 3);
+
 static struct attribute *fb_timecard_attrs[] = {
 	&dev_attr_serialnum.attr,
 	&dev_attr_gnss_sync.attr,
@@ -2717,6 +2837,10 @@ static const struct ocp_attr_group fb_timecard_groups[] = {
 	{ .cap = OCP_CAP_SIGNAL,    .group = &fb_timecard_signal1_group },
 	{ .cap = OCP_CAP_SIGNAL,    .group = &fb_timecard_signal2_group },
 	{ .cap = OCP_CAP_SIGNAL,    .group = &fb_timecard_signal3_group },
+	{ .cap = OCP_CAP_FREQ,	    .group = &fb_timecard_freq0_group },
+	{ .cap = OCP_CAP_FREQ,	    .group = &fb_timecard_freq1_group },
+	{ .cap = OCP_CAP_FREQ,	    .group = &fb_timecard_freq2_group },
+	{ .cap = OCP_CAP_FREQ,	    .group = &fb_timecard_freq3_group },
 	{ },
 };
 
@@ -2781,6 +2905,36 @@ _signal_summary_show(struct seq_file *s, struct ptp_ocp *bp, int nr)
 	seq_printf(s, " start:%llu\n", signal->start);
 }
 
+static void
+_frequency_summary_show(struct seq_file *s, int nr,
+			struct frequency_reg __iomem *reg)
+{
+	char label[8];
+	bool on;
+	u32 val;
+
+	if (!reg)
+		return;
+
+	sprintf(label, "FREQ%d", nr);
+	val = ioread32(&reg->ctrl);
+	on = val & 1;
+	val = (val >> 8) & 0xff;
+	seq_printf(s, "%7s: %s, sec:%u",
+		   label,
+		   on ? " ON" : "OFF",
+		   val);
+
+	val = ioread32(&reg->status);
+	if (val & FREQ_STATUS_ERROR)
+		seq_printf(s, ", error");
+	if (val & FREQ_STATUS_OVERRUN)
+		seq_printf(s, ", overrun");
+	if (val & FREQ_STATUS_VALID)
+		seq_printf(s, ", freq %lu Hz", val & FREQ_STATUS_MASK);
+	seq_printf(s, "  reg:%x\n", val);
+}
+
 static int
 ptp_ocp_summary_show(struct seq_file *s, void *data)
 {
@@ -2888,6 +3042,10 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 		for (i = 0; i < 4; i++)
 			_signal_summary_show(s, bp, i);
 
+	if (bp->fw_cap & OCP_CAP_FREQ)
+		for (i = 0; i < 4; i++)
+			_frequency_summary_show(s, i, bp->freq_in[i]);
+
 	if (bp->irig_out) {
 		ctrl = ioread32(&bp->irig_out->ctrl);
 		on = ctrl & IRIG_M_CTRL_ENABLE;
-- 
2.31.1

