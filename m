Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88344D0C83
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbiCHALM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344039AbiCHALL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:11:11 -0500
Received: from smtp5.emailarray.com (smtp5.emailarray.com [65.39.216.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00F536E36
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 16:10:14 -0800 (PST)
Received: (qmail 30131 invoked by uid 89); 8 Mar 2022 00:10:13 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 8 Mar 2022 00:10:13 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next] ptp: ocp: Add support for selectable SMA directions.
Date:   Mon,  7 Mar 2022 16:10:12 -0800
Message-Id: <20220308001012.2452-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
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

Assuming the firmware allows it, the direction of each SMA connector
is no longer fixed.  Handle remapping directions for each pin.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 332 +++++++++++++++++++++++++++---------------
 1 file changed, 213 insertions(+), 119 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 8e23d563a577..758b5b6a43ca 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -206,6 +206,17 @@ struct ptp_ocp_ext_src {
 	int			irq_vec;
 };
 
+enum ptp_ocp_sma_mode {
+	SMA_MODE_IN,
+	SMA_MODE_OUT,
+};
+
+struct ptp_ocp_sma_connector {
+	enum	ptp_ocp_sma_mode mode;
+	bool	fixed_fcn;
+	bool	fixed_dir;
+};
+
 #define OCP_BOARD_ID_LEN		13
 #define OCP_SERIAL_LEN			6
 
@@ -218,7 +229,8 @@ struct ptp_ocp {
 	struct pps_reg __iomem	*pps_to_ext;
 	struct pps_reg __iomem	*pps_to_clk;
 	struct gpio_reg __iomem	*pps_select;
-	struct gpio_reg __iomem	*sma;
+	struct gpio_reg __iomem	*sma_map1;
+	struct gpio_reg __iomem	*sma_map2;
 	struct irig_master_reg	__iomem *irig_out;
 	struct irig_slave_reg	__iomem *irig_in;
 	struct dcf_master_reg	__iomem *dcf_out;
@@ -252,6 +264,7 @@ struct ptp_ocp {
 	int			flash_start;
 	u32			utc_tai_offset;
 	u32			ts_window_adjust;
+	struct ptp_ocp_sma_connector sma[4];
 };
 
 #define OCP_REQ_TIMESTAMP	BIT(0)
@@ -417,9 +430,13 @@ static struct ocp_resource ocp_fb_resource[] = {
 		.offset = 0x00130000, .size = 0x1000,
 	},
 	{
-		OCP_MEM_RESOURCE(sma),
+		OCP_MEM_RESOURCE(sma_map1),
 		.offset = 0x00140000, .size = 0x1000,
 	},
+	{
+		OCP_MEM_RESOURCE(sma_map2),
+		.offset = 0x00220000, .size = 0x1000,
+	},
 	{
 		OCP_I2C_RESOURCE(i2c_ctrl),
 		.offset = 0x00150000, .size = 0x10000, .irq_vec = 7,
@@ -502,6 +519,9 @@ static struct ocp_selector ptp_ocp_clock[] = {
 	{ }
 };
 
+#define SMA_ENABLE		BIT(15)
+#define SMA_SELECT_MASK		((1U << 15) - 1)
+
 static struct ocp_selector ptp_ocp_sma_in[] = {
 	{ .name = "10Mhz",	.value = 0x00 },
 	{ .name = "PPS1",	.value = 0x01 },
@@ -1455,6 +1475,45 @@ ptp_ocp_nmea_out_init(struct ptp_ocp *bp)
 	iowrite32(1, &bp->nmea_out->ctrl);		/* enable */
 }
 
+static void
+ptp_ocp_sma_init(struct ptp_ocp *bp)
+{
+	u32 reg;
+	int i;
+
+	/* defaults */
+	bp->sma[0].mode = SMA_MODE_IN;
+	bp->sma[1].mode = SMA_MODE_IN;
+	bp->sma[2].mode = SMA_MODE_OUT;
+	bp->sma[3].mode = SMA_MODE_OUT;
+
+	/* If no SMA1 map, the pin functions and directions are fixed. */
+	if (!bp->sma_map1) {
+		for (i = 0; i < 4; i++) {
+			bp->sma[i].fixed_fcn = true;
+			bp->sma[i].fixed_dir = true;
+		}
+		return;
+	}
+
+	/* If SMA2 GPIO output map is all 1, it is not present.
+	 * This indicates the firmware has fixed direction SMA pins.
+	 */
+	reg = ioread32(&bp->sma_map2->gpio2);
+	if (reg == 0xffffffff) {
+		for (i = 0; i < 4; i++)
+			bp->sma[i].fixed_dir = true;
+	} else {
+		reg = ioread32(&bp->sma_map1->gpio1);
+		bp->sma[0].mode = reg & BIT(15) ? SMA_MODE_IN : SMA_MODE_OUT;
+		bp->sma[1].mode = reg & BIT(31) ? SMA_MODE_IN : SMA_MODE_OUT;
+
+		reg = ioread32(&bp->sma_map1->gpio2);
+		bp->sma[2].mode = reg & BIT(15) ? SMA_MODE_OUT : SMA_MODE_IN;
+		bp->sma[3].mode = reg & BIT(31) ? SMA_MODE_OUT : SMA_MODE_IN;
+	}
+}
+
 /* FB specific board initializers; last "resource" registered. */
 static int
 ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
@@ -1465,6 +1524,7 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 
 	ptp_ocp_tod_init(bp);
 	ptp_ocp_nmea_out_init(bp);
+	ptp_ocp_sma_init(bp);
 
 	return ptp_ocp_init_clock(bp);
 }
@@ -1566,36 +1626,6 @@ __handle_signal_inputs(struct ptp_ocp *bp, u32 val)
  * ANT4 == sma4 (out)
  */
 
-enum ptp_ocp_sma_mode {
-	SMA_MODE_IN,
-	SMA_MODE_OUT,
-};
-
-static struct ptp_ocp_sma_connector {
-	enum	ptp_ocp_sma_mode mode;
-	bool	fixed_mode;
-	u16	default_out_idx;
-} ptp_ocp_sma_map[4] = {
-	{
-		.mode = SMA_MODE_IN,
-		.fixed_mode = true,
-	},
-	{
-		.mode = SMA_MODE_IN,
-		.fixed_mode = true,
-	},
-	{
-		.mode = SMA_MODE_OUT,
-		.fixed_mode = true,
-		.default_out_idx = 0,		/* 10Mhz */
-	},
-	{
-		.mode = SMA_MODE_OUT,
-		.fixed_mode = true,
-		.default_out_idx = 1,		/* PHC */
-	},
-};
-
 static ssize_t
 ptp_ocp_show_output(u32 val, char *buf, int default_idx)
 {
@@ -1611,7 +1641,7 @@ ptp_ocp_show_output(u32 val, char *buf, int default_idx)
 }
 
 static ssize_t
-ptp_ocp_show_inputs(u32 val, char *buf, const char *zero_in)
+ptp_ocp_show_inputs(u32 val, char *buf, int default_idx)
 {
 	const char *name;
 	ssize_t count;
@@ -1624,8 +1654,9 @@ ptp_ocp_show_inputs(u32 val, char *buf, const char *zero_in)
 			count += sysfs_emit_at(buf, count, "%s ", name);
 		}
 	}
-	if (!val && zero_in)
-		count += sysfs_emit_at(buf, count, "%s ", zero_in);
+	if (!val && default_idx >= 0)
+		count += sysfs_emit_at(buf, count, "%s ",
+				       ptp_ocp_sma_in[default_idx].name);
 	if (count)
 		count--;
 	count += sysfs_emit_at(buf, count, "\n");
@@ -1650,7 +1681,7 @@ sma_parse_inputs(const char *buf, enum ptp_ocp_sma_mode *mode)
 
 	idx = 0;
 	dir = *mode == SMA_MODE_IN ? 0 : 1;
-	if (!strcasecmp("IN:", argv[idx])) {
+	if (!strcasecmp("IN:", argv[0])) {
 		dir = 0;
 		idx++;
 	}
@@ -1671,102 +1702,123 @@ sma_parse_inputs(const char *buf, enum ptp_ocp_sma_mode *mode)
 	return ret;
 }
 
-static ssize_t
-ptp_ocp_sma_show(struct ptp_ocp *bp, int sma_nr, u32 val, char *buf,
-		 const char *zero_in)
+static u32
+ptp_ocp_sma_get(struct ptp_ocp *bp, int sma_nr, enum ptp_ocp_sma_mode mode)
 {
-	struct ptp_ocp_sma_connector *sma = &ptp_ocp_sma_map[sma_nr - 1];
+	u32 __iomem *gpio;
+	u32 shift;
+
+	if (bp->sma[sma_nr - 1].fixed_fcn)
+		return (sma_nr - 1) & 1;
+
+	if (mode == SMA_MODE_IN)
+		gpio = sma_nr > 2 ? &bp->sma_map2->gpio1 : &bp->sma_map1->gpio1;
+	else
+		gpio = sma_nr > 2 ? &bp->sma_map1->gpio2 : &bp->sma_map2->gpio2;
+	shift = sma_nr & 1 ? 0 : 16;
+
+	return (ioread32(gpio) >> shift) & 0xffff;
+}
+
+static ssize_t
+ptp_ocp_sma_show(struct ptp_ocp *bp, int sma_nr, char *buf,
+		 int default_in_idx, int default_out_idx)
+{
+	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
+	u32 val;
+
+	val = ptp_ocp_sma_get(bp, sma_nr, sma->mode) & SMA_SELECT_MASK;
 
 	if (sma->mode == SMA_MODE_IN)
-		return ptp_ocp_show_inputs(val, buf, zero_in);
+		return ptp_ocp_show_inputs(val, buf, default_in_idx);
 
-	return ptp_ocp_show_output(val, buf, sma->default_out_idx);
+	return ptp_ocp_show_output(val, buf, default_out_idx);
 }
 
 static ssize_t
 sma1_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct ptp_ocp *bp = dev_get_drvdata(dev);
-	u32 val;
 
-	val = ioread32(&bp->sma->gpio1) & 0x3f;
-	return ptp_ocp_sma_show(bp, 1, val, buf, ptp_ocp_sma_in[0].name);
+	return ptp_ocp_sma_show(bp, 1, buf, 0, 1);
 }
 
 static ssize_t
 sma2_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct ptp_ocp *bp = dev_get_drvdata(dev);
-	u32 val;
 
-	val = (ioread32(&bp->sma->gpio1) >> 16) & 0x3f;
-	return ptp_ocp_sma_show(bp, 2, val, buf, NULL);
+	return ptp_ocp_sma_show(bp, 2, buf, -1, 1);
 }
 
 static ssize_t
 sma3_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct ptp_ocp *bp = dev_get_drvdata(dev);
-	u32 val;
 
-	val = ioread32(&bp->sma->gpio2) & 0x3f;
-	return ptp_ocp_sma_show(bp, 3, val, buf, NULL);
+	return ptp_ocp_sma_show(bp, 3, buf, -1, 0);
 }
 
 static ssize_t
 sma4_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct ptp_ocp *bp = dev_get_drvdata(dev);
-	u32 val;
 
-	val = (ioread32(&bp->sma->gpio2) >> 16) & 0x3f;
-	return ptp_ocp_sma_show(bp, 4, val, buf, NULL);
+	return ptp_ocp_sma_show(bp, 4, buf, -1, 1);
 }
 
 static void
-ptp_ocp_sma_store_output(struct ptp_ocp *bp, u32 val, u32 shift)
+ptp_ocp_sma_store_output(struct ptp_ocp *bp, int sma_nr, u32 val)
 {
+	u32 reg, mask, shift;
 	unsigned long flags;
-	u32 gpio, mask;
+	u32 __iomem *gpio;
+
+	gpio = sma_nr > 2 ? &bp->sma_map1->gpio2 : &bp->sma_map2->gpio2;
+	shift = sma_nr & 1 ? 0 : 16;
 
 	mask = 0xffff << (16 - shift);
 
 	spin_lock_irqsave(&bp->lock, flags);
 
-	gpio = ioread32(&bp->sma->gpio2);
-	gpio = (gpio & mask) | (val << shift);
+	reg = ioread32(gpio);
+	reg = (reg & mask) | (val << shift);
 
-	__handle_signal_outputs(bp, gpio);
+	__handle_signal_outputs(bp, reg);
 
-	iowrite32(gpio, &bp->sma->gpio2);
+	iowrite32(reg, gpio);
 
 	spin_unlock_irqrestore(&bp->lock, flags);
 }
 
 static void
-ptp_ocp_sma_store_inputs(struct ptp_ocp *bp, u32 val, u32 shift)
+ptp_ocp_sma_store_inputs(struct ptp_ocp *bp, int sma_nr, u32 val)
 {
+	u32 reg, mask, shift;
 	unsigned long flags;
-	u32 gpio, mask;
+	u32 __iomem *gpio;
+
+	gpio = sma_nr > 2 ? &bp->sma_map2->gpio1 : &bp->sma_map1->gpio1;
+	shift = sma_nr & 1 ? 0 : 16;
 
 	mask = 0xffff << (16 - shift);
 
 	spin_lock_irqsave(&bp->lock, flags);
 
-	gpio = ioread32(&bp->sma->gpio1);
-	gpio = (gpio & mask) | (val << shift);
+	reg = ioread32(gpio);
+	reg = (reg & mask) | (val << shift);
 
-	__handle_signal_inputs(bp, gpio);
+	__handle_signal_inputs(bp, reg);
 
-	iowrite32(gpio, &bp->sma->gpio1);
+	iowrite32(reg, gpio);
 
 	spin_unlock_irqrestore(&bp->lock, flags);
 }
 
-static ssize_t
-ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr, u32 shift)
+static int
+ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 {
-	struct ptp_ocp_sma_connector *sma = &ptp_ocp_sma_map[sma_nr - 1];
+	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
 	enum ptp_ocp_sma_mode mode;
 	int val;
 
@@ -1775,18 +1827,30 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr, u32 shift)
 	if (val < 0)
 		return val;
 
-	if (mode != sma->mode && sma->fixed_mode)
+	if (mode != sma->mode && sma->fixed_dir)
 		return -EOPNOTSUPP;
 
-	if (mode != sma->mode) {
-		pr_err("Mode changes not supported yet.\n");
-		return -EOPNOTSUPP;
+	if (sma->fixed_fcn) {
+		if (val != ((sma_nr - 1) & 1))
+			return -EOPNOTSUPP;
+		return 0;
 	}
 
-	if (sma->mode == SMA_MODE_IN)
-		ptp_ocp_sma_store_inputs(bp, val, shift);
+	if (mode != sma->mode) {
+		if (mode == SMA_MODE_IN)
+			ptp_ocp_sma_store_output(bp, sma_nr, 0);
+		else
+			ptp_ocp_sma_store_inputs(bp, sma_nr, 0);
+		sma->mode = mode;
+	}
+
+	if (!sma->fixed_dir)
+		val |= SMA_ENABLE;		/* add enable bit */
+
+	if (mode == SMA_MODE_IN)
+		ptp_ocp_sma_store_inputs(bp, sma_nr, val);
 	else
-		ptp_ocp_sma_store_output(bp, val, shift);
+		ptp_ocp_sma_store_output(bp, sma_nr, val);
 
 	return 0;
 }
@@ -1798,7 +1862,7 @@ sma1_store(struct device *dev, struct device_attribute *attr,
 	struct ptp_ocp *bp = dev_get_drvdata(dev);
 	int err;
 
-	err = ptp_ocp_sma_store(bp, buf, 1, 0);
+	err = ptp_ocp_sma_store(bp, buf, 1);
 	return err ? err : count;
 }
 
@@ -1809,7 +1873,7 @@ sma2_store(struct device *dev, struct device_attribute *attr,
 	struct ptp_ocp *bp = dev_get_drvdata(dev);
 	int err;
 
-	err = ptp_ocp_sma_store(bp, buf, 2, 16);
+	err = ptp_ocp_sma_store(bp, buf, 2);
 	return err ? err : count;
 }
 
@@ -1820,7 +1884,7 @@ sma3_store(struct device *dev, struct device_attribute *attr,
 	struct ptp_ocp *bp = dev_get_drvdata(dev);
 	int err;
 
-	err = ptp_ocp_sma_store(bp, buf, 3, 0);
+	err = ptp_ocp_sma_store(bp, buf, 3);
 	return err ? err : count;
 }
 
@@ -1831,7 +1895,7 @@ sma4_store(struct device *dev, struct device_attribute *attr,
 	struct ptp_ocp *bp = dev_get_drvdata(dev);
 	int err;
 
-	err = ptp_ocp_sma_store(bp, buf, 4, 16);
+	err = ptp_ocp_sma_store(bp, buf, 4);
 	return err ? err : count;
 }
 static DEVICE_ATTR_RW(sma1);
@@ -2110,31 +2174,38 @@ static struct attribute *timecard_attrs[] = {
 };
 ATTRIBUTE_GROUPS(timecard);
 
-static const char *
-gpio_map(u32 gpio, u32 bit, const char *pri, const char *sec, const char *def)
+static void
+gpio_input_map(char *buf, struct ptp_ocp *bp, u16 map[][2], u16 bit,
+	       const char *def)
 {
-	const char *ans;
+	int i;
 
-	if (gpio & (1 << bit))
-		ans = pri;
-	else if (gpio & (1 << (bit + 16)))
-		ans = sec;
-	else
-		ans = def;
-	return ans;
+	for (i = 0; i < 4; i++) {
+		if (bp->sma[i].mode != SMA_MODE_IN)
+			continue;
+		if (map[i][0] & (1 << bit)) {
+			sprintf(buf, "sma%d", i + 1);
+			return;
+		}
+	}
+	if (!def)
+		def = "----";
+	strcpy(buf, def);
 }
 
 static void
-gpio_multi_map(char *buf, u32 gpio, u32 bit,
-	       const char *pri, const char *sec, const char *def)
+gpio_output_map(char *buf, struct ptp_ocp *bp, u16 map[][2], u16 bit)
 {
 	char *ans = buf;
+	int i;
 
-	strcpy(ans, def);
-	if (gpio & (1 << bit))
-		ans += sprintf(ans, "%s ", pri);
-	if (gpio & (1 << (bit + 16)))
-		ans += sprintf(ans, "%s ", sec);
+	strcpy(ans, "----");
+	for (i = 0; i < 4; i++) {
+		if (bp->sma[i].mode != SMA_MODE_OUT)
+			continue;
+		if (map[i][1] & (1 << bit))
+			ans += sprintf(ans, "sma%d ", i + 1);
+	}
 }
 
 static int
@@ -2142,21 +2213,18 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 {
 	struct device *dev = s->private;
 	struct ptp_system_timestamp sts;
-	u32 sma_in, sma_out, ctrl, val;
+	u16 sma_val[4][2], ctrl, val;
 	struct ts_reg __iomem *ts_reg;
 	struct timespec64 ts;
 	struct ptp_ocp *bp;
-	const char *src;
+	char *src, *buf;
 	bool on, map;
-	char *buf;
 
 	buf = (char *)__get_free_page(GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
 	bp = dev_get_drvdata(dev);
-	sma_in = ioread32(&bp->sma->gpio1);
-	sma_out = ioread32(&bp->sma->gpio2);
 
 	seq_printf(s, "%7s: /dev/ptp%d\n", "PTP", ptp_clock_index(bp->ptp));
 	if (bp->gnss_port != -1)
@@ -2168,17 +2236,42 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	if (bp->nmea_port != -1)
 		seq_printf(s, "%7s: /dev/ttyS%d\n", "NMEA", bp->nmea_port);
 
+	memset(sma_val, 0xff, sizeof(sma_val));
+	if (bp->sma_map1) {
+		u32 reg;
+
+		reg = ioread32(&bp->sma_map1->gpio1);
+		sma_val[0][0] = reg & 0xffff;
+		sma_val[1][0] = reg >> 16;
+
+		reg = ioread32(&bp->sma_map1->gpio2);
+		sma_val[2][1] = reg & 0xffff;
+		sma_val[3][1] = reg >> 16;
+
+		reg = ioread32(&bp->sma_map2->gpio1);
+		sma_val[2][0] = reg & 0xffff;
+		sma_val[3][0] = reg >> 16;
+
+		reg = ioread32(&bp->sma_map2->gpio2);
+		sma_val[0][1] = reg & 0xffff;
+		sma_val[1][1] = reg >> 16;
+	}
+
 	sma1_show(dev, NULL, buf);
-	seq_printf(s, "   sma1: %s", buf);
+	seq_printf(s, "   sma1: %04x,%04x %s",
+		   sma_val[0][0], sma_val[0][1], buf);
 
 	sma2_show(dev, NULL, buf);
-	seq_printf(s, "   sma2: %s", buf);
+	seq_printf(s, "   sma2: %04x,%04x %s",
+		   sma_val[1][0], sma_val[1][1], buf);
 
 	sma3_show(dev, NULL, buf);
-	seq_printf(s, "   sma3: %s", buf);
+	seq_printf(s, "   sma3: %04x,%04x %s",
+		   sma_val[2][0], sma_val[2][1], buf);
 
 	sma4_show(dev, NULL, buf);
-	seq_printf(s, "   sma4: %s", buf);
+	seq_printf(s, "   sma4: %04x,%04x %s",
+		   sma_val[3][0], sma_val[3][1], buf);
 
 	if (bp->ts0) {
 		ts_reg = bp->ts0->mem;
@@ -2191,17 +2284,17 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	if (bp->ts1) {
 		ts_reg = bp->ts1->mem;
 		on = ioread32(&ts_reg->enable);
-		src = gpio_map(sma_in, 2, "sma1", "sma2", "----");
+		gpio_input_map(buf, bp, sma_val, 2, NULL);
 		seq_printf(s, "%7s: %s, src: %s\n", "TS1",
-			   on ? " ON" : "OFF", src);
+			   on ? " ON" : "OFF", buf);
 	}
 
 	if (bp->ts2) {
 		ts_reg = bp->ts2->mem;
 		on = ioread32(&ts_reg->enable);
-		src = gpio_map(sma_in, 3, "sma1", "sma2", "----");
+		gpio_input_map(buf, bp, sma_val, 3, NULL);
 		seq_printf(s, "%7s: %s, src: %s\n", "TS2",
-			   on ? " ON" : "OFF", src);
+			   on ? " ON" : "OFF", buf);
 	}
 
 	if (bp->pps) {
@@ -2221,7 +2314,7 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 		ctrl = ioread32(&bp->irig_out->ctrl);
 		on = ctrl & IRIG_M_CTRL_ENABLE;
 		val = ioread32(&bp->irig_out->status);
-		gpio_multi_map(buf, sma_out, 4, "sma3", "sma4", "----");
+		gpio_output_map(buf, bp, sma_val, 4);
 		seq_printf(s, "%7s: %s, error: %d, mode %d, out: %s\n", "IRIG",
 			   on ? " ON" : "OFF", val, (ctrl >> 16), buf);
 	}
@@ -2229,15 +2322,15 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	if (bp->irig_in) {
 		on = ioread32(&bp->irig_in->ctrl) & IRIG_S_CTRL_ENABLE;
 		val = ioread32(&bp->irig_in->status);
-		src = gpio_map(sma_in, 4, "sma1", "sma2", "----");
+		gpio_input_map(buf, bp, sma_val, 4, NULL);
 		seq_printf(s, "%7s: %s, error: %d, src: %s\n", "IRIG in",
-			   on ? " ON" : "OFF", val, src);
+			   on ? " ON" : "OFF", val, buf);
 	}
 
 	if (bp->dcf_out) {
 		on = ioread32(&bp->dcf_out->ctrl) & DCF_M_CTRL_ENABLE;
 		val = ioread32(&bp->dcf_out->status);
-		gpio_multi_map(buf, sma_out, 5, "sma3", "sma4", "----");
+		gpio_output_map(buf, bp, sma_val, 5);
 		seq_printf(s, "%7s: %s, error: %d, out: %s\n", "DCF",
 			   on ? " ON" : "OFF", val, buf);
 	}
@@ -2245,9 +2338,9 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	if (bp->dcf_in) {
 		on = ioread32(&bp->dcf_in->ctrl) & DCF_S_CTRL_ENABLE;
 		val = ioread32(&bp->dcf_in->status);
-		src = gpio_map(sma_in, 5, "sma1", "sma2", "----");
+		gpio_input_map(buf, bp, sma_val, 5, NULL);
 		seq_printf(s, "%7s: %s, error: %d, src: %s\n", "DCF in",
-			   on ? " ON" : "OFF", val, src);
+			   on ? " ON" : "OFF", val, buf);
 	}
 
 	if (bp->nmea_out) {
@@ -2260,8 +2353,9 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	/* compute src for PPS1, used below. */
 	if (bp->pps_select) {
 		val = ioread32(&bp->pps_select->gpio1);
+		src = &buf[80];
 		if (val & 0x01)
-			src = gpio_map(sma_in, 0, "sma1", "sma2", "----");
+			gpio_input_map(src, bp, sma_val, 0, NULL);
 		else if (val & 0x02)
 			src = "MAC";
 		else if (val & 0x04)
@@ -2298,8 +2392,8 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	/* reuses PPS1 src from earlier */
 	seq_printf(s, "MAC PPS1 src: %s\n", src);
 
-	src = gpio_map(sma_in, 1, "sma1", "sma2", "GNSS2");
-	seq_printf(s, "MAC PPS2 src: %s\n", src);
+	gpio_input_map(buf, bp, sma_val, 1, "GNSS2");
+	seq_printf(s, "MAC PPS2 src: %s\n", buf);
 
 	if (!ptp_ocp_gettimex(&bp->ptp_info, &ts, &sts)) {
 		struct timespec64 sys_ts;
-- 
2.31.1

