Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428DA40BDA2
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbhIOCSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:16 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:44226 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235259AbhIOCSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:10 -0400
Received: (qmail 83647 invoked by uid 89); 15 Sep 2021 02:16:51 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 15 Sep 2021 02:16:51 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 12/18] ptp: ocp: Add debugfs entry for timecard
Date:   Tue, 14 Sep 2021 19:16:30 -0700
Message-Id: <20210915021636.153754-13-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a view into the timecard internals for debugging.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 233 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 233 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index ea12f685edf6..36924423444e 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4,6 +4,7 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/debugfs.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/serial_8250.h>
@@ -208,6 +209,7 @@ struct ptp_ocp {
 	struct tod_reg __iomem	*tod;
 	struct pps_reg __iomem	*pps_to_ext;
 	struct pps_reg __iomem	*pps_to_clk;
+	struct gpio_reg __iomem	*pps_select;
 	struct gpio_reg __iomem	*sma;
 	struct irig_master_reg	__iomem *irig_out;
 	struct irig_slave_reg	__iomem *irig_in;
@@ -224,6 +226,7 @@ struct ptp_ocp {
 	struct platform_device	*spi_flash;
 	struct clk_hw		*i2c_clk;
 	struct timer_list	watchdog;
+	struct dentry		*debug_root;
 	time64_t		gnss_lost;
 	int			id;
 	int			n_irqs;
@@ -354,6 +357,10 @@ static struct ocp_resource ocp_fb_resource[] = {
 		OCP_MEM_RESOURCE(image),
 		.offset = 0x00020000, .size = 0x1000,
 	},
+	{
+		OCP_MEM_RESOURCE(pps_select),
+		.offset = 0x00130000, .size = 0x1000,
+	},
 	{
 		OCP_MEM_RESOURCE(sma),
 		.offset = 0x00140000, .size = 0x1000,
@@ -1815,6 +1822,225 @@ static struct attribute *timecard_attrs[] = {
 };
 ATTRIBUTE_GROUPS(timecard);
 
+static const char *
+gpio_map(u32 gpio, u32 bit, const char *pri, const char *sec, const char *def)
+{
+	const char *ans;
+
+	if (gpio & (1 << bit))
+		ans = pri;
+	else if (gpio & (1 << (bit + 16)))
+		ans = sec;
+	else
+		ans = def;
+	return ans;
+}
+
+static void
+gpio_multi_map(char *buf, u32 gpio, u32 bit,
+	       const char *pri, const char *sec, const char *def)
+{
+	char *ans = buf;
+
+	strcpy(ans, def);
+	if (gpio & (1 << bit))
+		ans += sprintf(ans, "%s ", pri);
+	if (gpio & (1 << (bit + 16)))
+		ans += sprintf(ans, "%s ", sec);
+}
+
+static int
+ptp_ocp_summary_show(struct seq_file *s, void *data)
+{
+	struct device *dev = s->private;
+	struct ptp_system_timestamp sts;
+	u32 sma_in, sma_out, ctrl, val;
+	struct ts_reg __iomem *ts_reg;
+	struct timespec64 ts;
+	struct ptp_ocp *bp;
+	const char *src;
+	char *buf;
+	bool on;
+
+	buf = (char *)__get_free_page(GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	bp = dev_get_drvdata(dev);
+	sma_in = ioread32(&bp->sma->gpio1);
+	sma_out = ioread32(&bp->sma->gpio2);
+
+	seq_printf(s, "%7s: /dev/ptp%d\n", "PTP", ptp_clock_index(bp->ptp));
+
+	sma1_show(dev, NULL, buf);
+	seq_printf(s, "   sma1: %s", buf);
+
+	sma2_show(dev, NULL, buf);
+	seq_printf(s, "   sma2: %s", buf);
+
+	sma3_show(dev, NULL, buf);
+	seq_printf(s, "   sma3: %s", buf);
+
+	sma4_show(dev, NULL, buf);
+	seq_printf(s, "   sma4: %s", buf);
+
+	if (bp->ts0) {
+		ts_reg = bp->ts0->mem;
+		on = ioread32(&ts_reg->enable);
+		src = "GNSS";
+		seq_printf(s, "%7s: %s, src: %s\n", "TS0",
+			   on ? " ON" : "OFF", src);
+	}
+
+	if (bp->ts1) {
+		ts_reg = bp->ts1->mem;
+		on = ioread32(&ts_reg->enable);
+		src = gpio_map(sma_in, 2, "sma1", "sma2", "----");
+		seq_printf(s, "%7s: %s, src: %s\n", "TS1",
+			   on ? " ON" : "OFF", src);
+	}
+
+	if (bp->ts2) {
+		ts_reg = bp->ts2->mem;
+		on = ioread32(&ts_reg->enable);
+		src = gpio_map(sma_in, 3, "sma1", "sma2", "----");
+		seq_printf(s, "%7s: %s, src: %s\n", "TS2",
+			   on ? " ON" : "OFF", src);
+	}
+
+	if (bp->irig_out) {
+		ctrl = ioread32(&bp->irig_out->ctrl);
+		on = ctrl & IRIG_M_CTRL_ENABLE;
+		val = ioread32(&bp->irig_out->status);
+		gpio_multi_map(buf, sma_out, 4, "sma3", "sma4", "----");
+		seq_printf(s, "%7s: %s, error: %d, mode %d, out: %s\n", "IRIG",
+			   on ? " ON" : "OFF", val, (ctrl >> 16), buf);
+	}
+
+	if (bp->irig_in) {
+		on = ioread32(&bp->irig_in->ctrl) & IRIG_S_CTRL_ENABLE;
+		val = ioread32(&bp->irig_in->status);
+		src = gpio_map(sma_in, 4, "sma1", "sma2", "----");
+		seq_printf(s, "%7s: %s, error: %d, src: %s\n", "IRIG in",
+			   on ? " ON" : "OFF", val, src);
+	}
+
+	if (bp->dcf_out) {
+		on = ioread32(&bp->dcf_out->ctrl) & DCF_M_CTRL_ENABLE;
+		val = ioread32(&bp->dcf_out->status);
+		gpio_multi_map(buf, sma_out, 5, "sma3", "sma4", "----");
+		seq_printf(s, "%7s: %s, error: %d, out: %s\n", "DCF",
+			   on ? " ON" : "OFF", val, buf);
+	}
+
+	if (bp->dcf_in) {
+		on = ioread32(&bp->dcf_in->ctrl) & DCF_S_CTRL_ENABLE;
+		val = ioread32(&bp->dcf_in->status);
+		src = gpio_map(sma_in, 5, "sma1", "sma2", "----");
+		seq_printf(s, "%7s: %s, error: %d, src: %s\n", "DCF in",
+			   on ? " ON" : "OFF", val, src);
+	}
+
+	/* compute src for PPS1, used below. */
+	if (bp->pps_select) {
+		val = ioread32(&bp->pps_select->gpio1);
+		if (val & 0x01)
+			src = gpio_map(sma_in, 0, "sma1", "sma2", "----");
+		else if (val & 0x02)
+			src = "MAC";
+		else if (val & 0x04)
+			src = "GNSS";
+		else
+			src = "----";
+	} else {
+		src = "?";
+	}
+
+	/* assumes automatic switchover/selection */
+	val = ioread32(&bp->reg->select);
+	switch (val >> 16) {
+	case 0:
+		sprintf(buf, "----");
+		break;
+	case 2:
+		sprintf(buf, "IRIG");
+		break;
+	case 3:
+		sprintf(buf, "%s via PPS1", src);
+		break;
+	case 6:
+		sprintf(buf, "DCF");
+		break;
+	default:
+		strcpy(buf, "unknown");
+		break;
+	}
+	val = ioread32(&bp->reg->status);
+	seq_printf(s, "%7s: %s, state: %s\n", "PHC src", buf,
+		   val & OCP_STATUS_IN_SYNC ? "sync" : "unsynced");
+
+	/* reuses PPS1 src from earlier */
+	seq_printf(s, "MAC PPS1 src: %s\n", src);
+
+	src = gpio_map(sma_in, 1, "sma1", "sma2", "GNSS2");
+	seq_printf(s, "MAC PPS2 src: %s\n", src);
+
+	if (!ptp_ocp_gettimex(&bp->ptp_info, &ts, &sts)) {
+		struct timespec64 sys_ts;
+		s64 pre_ns, post_ns, ns;
+
+		pre_ns = timespec64_to_ns(&sts.pre_ts);
+		post_ns = timespec64_to_ns(&sts.post_ts);
+		ns = (pre_ns + post_ns) / 2;
+		ns += (s64)bp->utc_tai_offset * NSEC_PER_SEC;
+		sys_ts = ns_to_timespec64(ns);
+
+		seq_printf(s, "%7s: %lld.%ld == %ptT TAI\n", "PHC",
+			   ts.tv_sec, ts.tv_nsec, &ts);
+		seq_printf(s, "%7s: %lld.%ld == %ptT UTC offset %d\n", "SYS",
+			   sys_ts.tv_sec, sys_ts.tv_nsec, &sys_ts,
+			   bp->utc_tai_offset);
+		seq_printf(s, "%7s: PHC:SYS offset: %lld  window: %lld\n", "",
+			   timespec64_to_ns(&ts) - ns,
+			   post_ns - pre_ns);
+	}
+
+	free_page((unsigned long)buf);
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(ptp_ocp_summary);
+
+static struct dentry *ptp_ocp_debugfs_root;
+
+static void
+ptp_ocp_debugfs_add_device(struct ptp_ocp *bp)
+{
+	struct dentry *d;
+
+	d = debugfs_create_dir(dev_name(&bp->dev), ptp_ocp_debugfs_root);
+	bp->debug_root = d;
+	debugfs_create_file("summary", 0444, bp->debug_root,
+			    &bp->dev, &ptp_ocp_summary_fops);
+}
+
+static void
+ptp_ocp_debugfs_remove_device(struct ptp_ocp *bp)
+{
+	debugfs_remove_recursive(bp->debug_root);
+}
+
+static void
+ptp_ocp_debugfs_init(void)
+{
+	ptp_ocp_debugfs_root = debugfs_create_dir("timecard", NULL);
+}
+
+static void
+ptp_ocp_debugfs_fini(void)
+{
+	debugfs_remove_recursive(ptp_ocp_debugfs_root);
+}
+
 static void
 ptp_ocp_dev_release(struct device *dev)
 {
@@ -1918,6 +2144,8 @@ ptp_ocp_complete(struct ptp_ocp *bp)
 	if (device_add_groups(&bp->dev, timecard_groups))
 		pr_err("device add groups failed\n");
 
+	ptp_ocp_debugfs_add_device(bp);
+
 	return 0;
 }
 
@@ -1988,6 +2216,7 @@ ptp_ocp_detach_sysfs(struct ptp_ocp *bp)
 static void
 ptp_ocp_detach(struct ptp_ocp *bp)
 {
+	ptp_ocp_debugfs_remove_device(bp);
 	ptp_ocp_detach_sysfs(bp);
 	if (timer_pending(&bp->watchdog))
 		del_timer_sync(&bp->watchdog);
@@ -2157,6 +2386,8 @@ ptp_ocp_init(void)
 	const char *what;
 	int err;
 
+	ptp_ocp_debugfs_init();
+
 	what = "timecard class";
 	err = class_register(&timecard_class);
 	if (err)
@@ -2179,6 +2410,7 @@ ptp_ocp_init(void)
 out_notifier:
 	class_unregister(&timecard_class);
 out:
+	ptp_ocp_debugfs_fini();
 	pr_err(KBUILD_MODNAME ": failed to register %s: %d\n", what, err);
 	return err;
 }
@@ -2189,6 +2421,7 @@ ptp_ocp_fini(void)
 	bus_unregister_notifier(&i2c_bus_type, &ptp_ocp_i2c_notifier);
 	pci_unregister_driver(&ptp_ocp_driver);
 	class_unregister(&timecard_class);
+	ptp_ocp_debugfs_fini();
 }
 
 module_init(ptp_ocp_init);
-- 
2.31.1

