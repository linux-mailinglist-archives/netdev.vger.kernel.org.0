Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B003FBF99
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbhH3Xxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:53:43 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:18262 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239150AbhH3Xxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 19:53:39 -0400
Received: (qmail 78132 invoked by uid 89); 30 Aug 2021 23:52:44 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 30 Aug 2021 23:52:44 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: [PATCH net-next 06/11] ptp: ocp: Add SMA selector and controls
Date:   Mon, 30 Aug 2021 16:52:31 -0700
Message-Id: <20210830235236.309993-7-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830235236.309993-1-jonathan.lemon@gmail.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The v10 firmware for the TimeCard adds selectable signals for
the SMA input/outputs.  Add support for SMA selectors, and the
GPIO controls needed for steering signals.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 315 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 287 insertions(+), 28 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index c5fbccab57a8..3920bdb1977a 100644
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
@@ -343,33 +357,71 @@ static struct {
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
+	{ .name = "IRIG",	.value = 0x10 },
+	{ .name = "DCF",	.value = 0x20 },
+	{ }
+};
+
+static struct ocp_selector ptp_ocp_sma_out[] = {
+	{ .name = "10Mhz",	.value = 0x00 },
+	{ .name = "PHC",	.value = 0x01 },
+	{ .name = "MAC",	.value = 0x02 },
+	{ .name = "GNSS",	.value = 0x04 },
+	{ .name = "GNSS2",	.value = 0x08 },
+	{ .name = "IRIG",	.value = 0x10 },
+	{ .name = "DCF",	.value = 0x20 },
+	{ }
 };
 
 static const char *
-ptp_ocp_clock_name_from_val(int val)
+select_name_from_val(struct ocp_selector *tbl, int val)
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
+select_val_from_name(struct ocp_selector *tbl, const char *name)
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
+select_table_show(struct ocp_selector *tbl, char *buf)
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
@@ -756,7 +808,7 @@ ptp_ocp_info(struct ptp_ocp *bp)
 	select = ioread32(&bp->reg->select);
 	dev_info(&bp->pdev->dev, "Version %d.%d.%d, clock %s, device ptp%d\n",
 		 version >> 24, (version >> 16) & 0xff, version & 0xffff,
-		 ptp_ocp_clock_name_from_val(select >> 16),
+		 select_name_from_val(ptp_ocp_clock, select >> 16),
 		 ptp_clock_index(bp->ptp));
 
 	if (bp->tod)
@@ -1204,6 +1256,219 @@ gnss_sync_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR_RO(gnss_sync);
 
+/*
+ * In the schematic, pins are ANTx, these map to the external connectors:
+ * ANT1 == sma2
+ * ANT2 == sma1
+ * ANT3 == sma4
+ * ANT4 == sma3
+ */
+
+static ssize_t
+sma_show_output(u32 val, char *buf, int default_idx)
+{
+	const char *name;
+
+	name = select_name_from_val(ptp_ocp_sma_out, val);
+	if (!name)
+		name = ptp_ocp_sma_out[default_idx].name;
+	return sysfs_emit(buf, "%s\n", name);
+}
+
+static ssize_t
+sma_show_inputs(u32 val, char *buf)
+{
+	const char *name;
+	ssize_t count;
+	int i;
+
+	count = 0;
+	for (i = 0; i < ARRAY_SIZE(ptp_ocp_sma_in); i++) {
+		if (val & ptp_ocp_sma_in[i].value) {
+			name = ptp_ocp_sma_in[i].name;
+			count += sysfs_emit_at(buf, count, "%s ", name);
+		}
+	}
+	if (count)
+		count--;
+	count += sysfs_emit_at(buf, count, "\n");
+	return count;
+}
+
+static int
+sma_parse_inputs(const char *buf)
+{
+	int i, count;
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
+	ret = 0;
+	for (i = 0; i < count; i++)
+		ret |= select_val_from_name(ptp_ocp_sma_in, argv[i]);
+
+out:
+	argv_free(argv);
+	return ret;
+}
+
+static ssize_t
+sma2_out_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+
+	val = ioread32(&bp->sma->gpio2) & 0x3f;
+	return sma_show_output(val, buf, 0);
+}
+
+static ssize_t
+sma1_out_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+
+	val = (ioread32(&bp->sma->gpio2) >> 16) & 0x3f;
+	return sma_show_output(val, buf, 1);
+}
+
+static ssize_t
+sma2_out_store(struct device *dev, struct device_attribute *attr,
+	      const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	unsigned long flags;
+	u32 gpio;
+	int val;
+
+	val = select_val_from_name(ptp_ocp_sma_out, buf);
+	if (val < 0)
+		return val;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	gpio = ioread32(&bp->sma->gpio2);
+	gpio = (gpio & 0xffff0000) | val;
+	iowrite32(gpio, &bp->sma->gpio2);
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return count;
+}
+static DEVICE_ATTR_RW(sma2_out);
+
+static ssize_t
+sma1_out_store(struct device *dev, struct device_attribute *attr,
+	      const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	unsigned long flags;
+	u32 gpio;
+	int val;
+
+	val = select_val_from_name(ptp_ocp_sma_out, buf);
+	if (val < 0)
+		return val;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	gpio = ioread32(&bp->sma->gpio2);
+	gpio = (gpio & 0xffff) | (val << 16);
+	iowrite32(gpio, &bp->sma->gpio2);
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return count;
+}
+static DEVICE_ATTR_RW(sma1_out);
+
+static ssize_t
+sma4_in_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+
+	val = ioread32(&bp->sma->gpio1) & 0x3f;
+	if (val == 0)
+		return sysfs_emit(buf, "%s\n", ptp_ocp_sma_in[0].name);
+	return sma_show_inputs(val, buf);
+}
+
+static ssize_t
+sma3_in_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+
+	val = (ioread32(&bp->sma->gpio1) >> 16) & 0x3f;
+	return sma_show_inputs(val, buf);
+}
+
+static ssize_t
+sma4_in_store(struct device *dev, struct device_attribute *attr,
+	      const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	unsigned long flags;
+	u32 gpio;
+	int val;
+
+	val = sma_parse_inputs(buf);
+	if (val < 0)
+		return val;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	gpio = ioread32(&bp->sma->gpio1);
+	gpio = (gpio & 0xffff0000) | val;
+	iowrite32(gpio, &bp->sma->gpio1);
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return count;
+}
+static DEVICE_ATTR_RW(sma4_in);
+
+static ssize_t
+sma3_in_store(struct device *dev, struct device_attribute *attr,
+	      const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	unsigned long flags;
+	u32 gpio;
+	int val;
+
+	val = sma_parse_inputs(buf);
+	if (val < 0)
+		return val;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	gpio = ioread32(&bp->sma->gpio1);
+	gpio = (gpio & 0xffff) | (val << 16);
+	iowrite32(gpio, &bp->sma->gpio1);
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return count;
+}
+static DEVICE_ATTR_RW(sma3_in);
+
+static ssize_t
+available_sma_inputs_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	return select_table_show(ptp_ocp_sma_in, buf);
+}
+static DEVICE_ATTR_RO(available_sma_inputs);
+
+static ssize_t
+available_sma_outputs_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	return select_table_show(ptp_ocp_sma_out, buf);
+}
+static DEVICE_ATTR_RO(available_sma_outputs);
+
 static ssize_t
 clock_source_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -1212,7 +1477,7 @@ clock_source_show(struct device *dev, struct device_attribute *attr, char *buf)
 	u32 select;
 
 	select = ioread32(&bp->reg->select);
-	p = ptp_ocp_clock_name_from_val(select >> 16);
+	p = select_name_from_val(ptp_ocp_clock, select >> 16);
 
 	return sysfs_emit(buf, "%s\n", p);
 }
@@ -1225,7 +1490,7 @@ clock_source_store(struct device *dev, struct device_attribute *attr,
 	unsigned long flags;
 	int val;
 
-	val = ptp_ocp_clock_val_from_name(buf);
+	val = select_val_from_name(ptp_ocp_clock, buf);
 	if (val < 0)
 		return val;
 
@@ -1241,19 +1506,7 @@ static ssize_t
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
+	return select_table_show(ptp_ocp_clock, buf);
 }
 static DEVICE_ATTR_RO(available_clock_sources);
 
@@ -1262,6 +1515,12 @@ static struct attribute *timecard_attrs[] = {
 	&dev_attr_gnss_sync.attr,
 	&dev_attr_clock_source.attr,
 	&dev_attr_available_clock_sources.attr,
+	&dev_attr_sma1_out.attr,
+	&dev_attr_sma2_out.attr,
+	&dev_attr_sma3_in.attr,
+	&dev_attr_sma4_in.attr,
+	&dev_attr_available_sma_inputs.attr,
+	&dev_attr_available_sma_outputs.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(timecard);
-- 
2.31.1

