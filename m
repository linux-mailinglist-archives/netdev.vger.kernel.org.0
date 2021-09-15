Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3544040BD9D
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbhIOCSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:10 -0400
Received: from smtp8.emailarray.com ([65.39.216.67]:60851 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbhIOCSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:04 -0400
Received: (qmail 92111 invoked by uid 89); 15 Sep 2021 02:16:45 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 15 Sep 2021 02:16:45 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 07/18] ptp: ocp: Add SMA selector and controls
Date:   Tue, 14 Sep 2021 19:16:25 -0700
Message-Id: <20210915021636.153754-8-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The latest firmware for the TimeCard adds selectable signals for
the SMA input/outputs.  Add support for SMA selectors, and the
GPIO controls needed for steering signals.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 389 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 361 insertions(+), 28 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 23d5f20f43f8..7441dac4e9c5 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -124,6 +124,13 @@ struct img_reg {
 	u32	version;
 };
 
+struct gpio_reg {
+	u32	gpio1;
+	u32	__pad0;
+	u32	gpio2;
+	u32	__pad1;
+};
+
 struct ptp_ocp_flash_info {
 	const char *name;
 	int pci_offset;
@@ -159,6 +166,7 @@ struct ptp_ocp {
 	struct tod_reg __iomem	*tod;
 	struct pps_reg __iomem	*pps_to_ext;
 	struct pps_reg __iomem	*pps_to_clk;
+	struct gpio_reg __iomem	*sma;
 	struct ptp_ocp_ext_src	*pps;
 	struct ptp_ocp_ext_src	*ts0;
 	struct ptp_ocp_ext_src	*ts1;
@@ -283,6 +291,10 @@ static struct ocp_resource ocp_fb_resource[] = {
 		OCP_MEM_RESOURCE(image),
 		.offset = 0x00020000, .size = 0x1000,
 	},
+	{
+		OCP_MEM_RESOURCE(sma),
+		.offset = 0x00140000, .size = 0x1000,
+	},
 	{
 		OCP_I2C_RESOURCE(i2c_ctrl),
 		.offset = 0x00150000, .size = 0x10000, .irq_vec = 7,
@@ -330,10 +342,12 @@ MODULE_DEVICE_TABLE(pci, ptp_ocp_pcidev_id);
 static DEFINE_MUTEX(ptp_ocp_lock);
 static DEFINE_IDR(ptp_ocp_idr);
 
-static struct {
+struct ocp_selector {
 	const char *name;
 	int value;
-} ptp_ocp_clock[] = {
+};
+
+static struct ocp_selector ptp_ocp_clock[] = {
 	{ .name = "NONE",	.value = 0 },
 	{ .name = "TOD",	.value = 1 },
 	{ .name = "IRIG",	.value = 2 },
@@ -343,33 +357,67 @@ static struct {
 	{ .name = "DCF",	.value = 6 },
 	{ .name = "REGS",	.value = 0xfe },
 	{ .name = "EXT",	.value = 0xff },
+	{ }
+};
+
+static struct ocp_selector ptp_ocp_sma_in[] = {
+	{ .name = "10Mhz",	.value = 0x00 },
+	{ .name = "PPS1",	.value = 0x01 },
+	{ .name = "PPS2",	.value = 0x02 },
+	{ .name = "TS1",	.value = 0x04 },
+	{ .name = "TS2",	.value = 0x08 },
+	{ }
+};
+
+static struct ocp_selector ptp_ocp_sma_out[] = {
+	{ .name = "10Mhz",	.value = 0x00 },
+	{ .name = "PHC",	.value = 0x01 },
+	{ .name = "MAC",	.value = 0x02 },
+	{ .name = "GNSS",	.value = 0x04 },
+	{ .name = "GNSS2",	.value = 0x08 },
+	{ }
 };
 
 static const char *
-ptp_ocp_clock_name_from_val(int val)
+ptp_ocp_select_name_from_val(struct ocp_selector *tbl, int val)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(ptp_ocp_clock); i++)
-		if (ptp_ocp_clock[i].value == val)
-			return ptp_ocp_clock[i].name;
+	for (i = 0; tbl[i].name; i++)
+		if (tbl[i].value == val)
+			return tbl[i].name;
 	return NULL;
 }
 
 static int
-ptp_ocp_clock_val_from_name(const char *name)
+ptp_ocp_select_val_from_name(struct ocp_selector *tbl, const char *name)
 {
-	const char *clk;
+	const char *select;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(ptp_ocp_clock); i++) {
-		clk = ptp_ocp_clock[i].name;
-		if (!strncasecmp(name, clk, strlen(clk)))
-			return ptp_ocp_clock[i].value;
+	for (i = 0; tbl[i].name; i++) {
+		select = tbl[i].name;
+		if (!strncasecmp(name, select, strlen(select)))
+			return tbl[i].value;
 	}
 	return -EINVAL;
 }
 
+static ssize_t
+ptp_ocp_select_table_show(struct ocp_selector *tbl, char *buf)
+{
+	ssize_t count;
+	int i;
+
+	count = 0;
+	for (i = 0; tbl[i].name; i++)
+		count += sysfs_emit_at(buf, count, "%s ", tbl[i].name);
+	if (count)
+		count--;
+	count += sysfs_emit_at(buf, count, "\n");
+	return count;
+}
+
 static int
 __ptp_ocp_gettime_locked(struct ptp_ocp *bp, struct timespec64 *ts,
 			 struct ptp_system_timestamp *sts)
@@ -756,7 +804,7 @@ ptp_ocp_info(struct ptp_ocp *bp)
 	select = ioread32(&bp->reg->select);
 	dev_info(&bp->pdev->dev, "Version %d.%d.%d, clock %s, device ptp%d\n",
 		 version >> 24, (version >> 16) & 0xff, version & 0xffff,
-		 ptp_ocp_clock_name_from_val(select >> 16),
+		 ptp_ocp_select_name_from_val(ptp_ocp_clock, select >> 16),
 		 ptp_clock_index(bp->ptp));
 
 	if (bp->tod)
@@ -1181,6 +1229,297 @@ ptp_ocp_register_resources(struct ptp_ocp *bp, kernel_ulong_t driver_data)
 	return err;
 }
 
+/*
+ * ANT0 == gps	(in)
+ * ANT1 == sma1 (in)
+ * ANT2 == sma2 (in)
+ * ANT3 == sma3 (out)
+ * ANT4 == sma4 (out)
+ */
+
+enum ptp_ocp_sma_mode {
+	SMA_MODE_IN,
+	SMA_MODE_OUT,
+};
+
+static struct ptp_ocp_sma_connector {
+	enum	ptp_ocp_sma_mode mode;
+	bool	fixed_mode;
+	u16	default_out_idx;
+} ptp_ocp_sma_map[4] = {
+	{
+		.mode = SMA_MODE_IN,
+		.fixed_mode = true,
+	},
+	{
+		.mode = SMA_MODE_IN,
+		.fixed_mode = true,
+	},
+	{
+		.mode = SMA_MODE_OUT,
+		.fixed_mode = true,
+		.default_out_idx = 0,		/* 10Mhz */
+	},
+	{
+		.mode = SMA_MODE_OUT,
+		.fixed_mode = true,
+		.default_out_idx = 1,		/* PHC */
+	},
+};
+
+static ssize_t
+ptp_ocp_show_output(u32 val, char *buf, int default_idx)
+{
+	const char *name;
+	ssize_t count;
+
+	count = sysfs_emit(buf, "OUT: ");
+	name = ptp_ocp_select_name_from_val(ptp_ocp_sma_out, val);
+	if (!name)
+		name = ptp_ocp_sma_out[default_idx].name;
+	count += sysfs_emit_at(buf, count, "%s\n", name);
+	return count;
+}
+
+static ssize_t
+ptp_ocp_show_inputs(u32 val, char *buf, const char *zero_in)
+{
+	const char *name;
+	ssize_t count;
+	int i;
+
+	count = sysfs_emit(buf, "IN: ");
+	for (i = 0; i < ARRAY_SIZE(ptp_ocp_sma_in); i++) {
+		if (val & ptp_ocp_sma_in[i].value) {
+			name = ptp_ocp_sma_in[i].name;
+			count += sysfs_emit_at(buf, count, "%s ", name);
+		}
+	}
+	if (!val && zero_in)
+		count += sysfs_emit_at(buf, count, "%s ", zero_in);
+	if (count)
+		count--;
+	count += sysfs_emit_at(buf, count, "\n");
+	return count;
+}
+
+static int
+sma_parse_inputs(const char *buf, enum ptp_ocp_sma_mode *mode)
+{
+	struct ocp_selector *tbl[] = { ptp_ocp_sma_in, ptp_ocp_sma_out };
+	int idx, count, dir;
+	char **argv;
+	int ret;
+
+	argv = argv_split(GFP_KERNEL, buf, &count);
+	if (!argv)
+		return -ENOMEM;
+
+	ret = -EINVAL;
+	if (!count)
+		goto out;
+
+	idx = 0;
+	dir = *mode == SMA_MODE_IN ? 0 : 1;
+	if (!strcasecmp("IN:", argv[idx])) {
+		dir = 0;
+		idx++;
+	}
+	if (!strcasecmp("OUT:", argv[0])) {
+		dir = 1;
+		idx++;
+	}
+	*mode = dir == 0 ? SMA_MODE_IN : SMA_MODE_OUT;
+
+	ret = 0;
+	for (; idx < count; idx++)
+		ret |= ptp_ocp_select_val_from_name(tbl[dir], argv[idx]);
+	if (ret < 0)
+		ret = -EINVAL;
+
+out:
+	argv_free(argv);
+	return ret;
+}
+
+static ssize_t
+ptp_ocp_sma_show(struct ptp_ocp *bp, int sma_nr, u32 val, char *buf,
+		 const char *zero_in)
+{
+	struct ptp_ocp_sma_connector *sma = &ptp_ocp_sma_map[sma_nr - 1];
+
+	if (sma->mode == SMA_MODE_IN)
+		return ptp_ocp_show_inputs(val, buf, zero_in);
+
+	return ptp_ocp_show_output(val, buf, sma->default_out_idx);
+}
+
+static ssize_t
+sma1_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+
+	val = ioread32(&bp->sma->gpio1) & 0x3f;
+	return ptp_ocp_sma_show(bp, 1, val, buf, ptp_ocp_sma_in[0].name);
+}
+
+static ssize_t
+sma2_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+
+	val = (ioread32(&bp->sma->gpio1) >> 16) & 0x3f;
+	return ptp_ocp_sma_show(bp, 2, val, buf, NULL);
+}
+
+static ssize_t
+sma3_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+
+	val = ioread32(&bp->sma->gpio2) & 0x3f;
+	return ptp_ocp_sma_show(bp, 3, val, buf, NULL);
+}
+
+static ssize_t
+sma4_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+
+	val = (ioread32(&bp->sma->gpio2) >> 16) & 0x3f;
+	return ptp_ocp_sma_show(bp, 4, val, buf, NULL);
+}
+
+static void
+ptp_ocp_sma_store_output(struct ptp_ocp *bp, u32 val, u32 shift)
+{
+	unsigned long flags;
+	u32 gpio, mask;
+
+	mask = 0xffff << (16 - shift);
+
+	spin_lock_irqsave(&bp->lock, flags);
+
+	gpio = ioread32(&bp->sma->gpio2);
+	gpio = (gpio & mask) | (val << shift);
+	iowrite32(gpio, &bp->sma->gpio2);
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+}
+
+static void
+ptp_ocp_sma_store_inputs(struct ptp_ocp *bp, u32 val, u32 shift)
+{
+	unsigned long flags;
+	u32 gpio, mask;
+
+	mask = 0xffff << (16 - shift);
+
+	spin_lock_irqsave(&bp->lock, flags);
+
+	gpio = ioread32(&bp->sma->gpio1);
+	gpio = (gpio & mask) | (val << shift);
+	iowrite32(gpio, &bp->sma->gpio1);
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+}
+
+static ssize_t
+ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr, u32 shift)
+{
+	struct ptp_ocp_sma_connector *sma = &ptp_ocp_sma_map[sma_nr - 1];
+	enum ptp_ocp_sma_mode mode;
+	int val;
+
+	mode = sma->mode;
+	val = sma_parse_inputs(buf, &mode);
+	if (val < 0)
+		return val;
+
+	if (mode != sma->mode && sma->fixed_mode)
+		return -EOPNOTSUPP;
+
+	if (mode != sma->mode) {
+		pr_err("Mode changes not supported yet.\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (sma->mode == SMA_MODE_IN)
+		ptp_ocp_sma_store_inputs(bp, val, shift);
+	else
+		ptp_ocp_sma_store_output(bp, val, shift);
+
+	return 0;
+}
+
+static ssize_t
+sma1_store(struct device *dev, struct device_attribute *attr,
+	   const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int err;
+
+	err = ptp_ocp_sma_store(bp, buf, 1, 0);
+	return err ? err : count;
+}
+
+static ssize_t
+sma2_store(struct device *dev, struct device_attribute *attr,
+	   const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int err;
+
+	err = ptp_ocp_sma_store(bp, buf, 2, 16);
+	return err ? err : count;
+}
+
+static ssize_t
+sma3_store(struct device *dev, struct device_attribute *attr,
+	   const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int err;
+
+	err = ptp_ocp_sma_store(bp, buf, 3, 0);
+	return err ? err : count;
+}
+
+static ssize_t
+sma4_store(struct device *dev, struct device_attribute *attr,
+	   const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int err;
+
+	err = ptp_ocp_sma_store(bp, buf, 4, 16);
+	return err ? err : count;
+}
+static DEVICE_ATTR_RW(sma1);
+static DEVICE_ATTR_RW(sma2);
+static DEVICE_ATTR_RW(sma3);
+static DEVICE_ATTR_RW(sma4);
+
+static ssize_t
+available_sma_inputs_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	return ptp_ocp_select_table_show(ptp_ocp_sma_in, buf);
+}
+static DEVICE_ATTR_RO(available_sma_inputs);
+
+static ssize_t
+available_sma_outputs_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	return ptp_ocp_select_table_show(ptp_ocp_sma_out, buf);
+}
+static DEVICE_ATTR_RO(available_sma_outputs);
+
 static ssize_t
 serialnum_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -1216,7 +1555,7 @@ clock_source_show(struct device *dev, struct device_attribute *attr, char *buf)
 	u32 select;
 
 	select = ioread32(&bp->reg->select);
-	p = ptp_ocp_clock_name_from_val(select >> 16);
+	p = ptp_ocp_select_name_from_val(ptp_ocp_clock, select >> 16);
 
 	return sysfs_emit(buf, "%s\n", p);
 }
@@ -1229,7 +1568,7 @@ clock_source_store(struct device *dev, struct device_attribute *attr,
 	unsigned long flags;
 	int val;
 
-	val = ptp_ocp_clock_val_from_name(buf);
+	val = ptp_ocp_select_val_from_name(ptp_ocp_clock, buf);
 	if (val < 0)
 		return val;
 
@@ -1245,19 +1584,7 @@ static ssize_t
 available_clock_sources_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
-	const char *clk;
-	ssize_t count;
-	int i;
-
-	count = 0;
-	for (i = 0; i < ARRAY_SIZE(ptp_ocp_clock); i++) {
-		clk = ptp_ocp_clock[i].name;
-		count += sysfs_emit_at(buf, count, "%s ", clk);
-	}
-	if (count)
-		count--;
-	count += sysfs_emit_at(buf, count, "\n");
-	return count;
+	return ptp_ocp_select_table_show(ptp_ocp_clock, buf);
 }
 static DEVICE_ATTR_RO(available_clock_sources);
 
@@ -1266,6 +1593,12 @@ static struct attribute *timecard_attrs[] = {
 	&dev_attr_gnss_sync.attr,
 	&dev_attr_clock_source.attr,
 	&dev_attr_available_clock_sources.attr,
+	&dev_attr_sma1.attr,
+	&dev_attr_sma2.attr,
+	&dev_attr_sma3.attr,
+	&dev_attr_sma4.attr,
+	&dev_attr_available_sma_inputs.attr,
+	&dev_attr_available_sma_outputs.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(timecard);
-- 
2.31.1

