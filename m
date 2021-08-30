Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82173FBF9C
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239222AbhH3Xxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:53:49 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:39809 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239141AbhH3Xxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 19:53:42 -0400
Received: (qmail 84411 invoked by uid 89); 30 Aug 2021 23:52:47 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 30 Aug 2021 23:52:47 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: [PATCH net-next 09/11] ptp: ocp: Add debugfs entry for timecard
Date:   Mon, 30 Aug 2021 16:52:34 -0700
Message-Id: <20210830235236.309993-10-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830235236.309993-1-jonathan.lemon@gmail.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a view into the timecard internals for debugging.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 238 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 237 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 093385c6fed0..daa95f48c39f 100644
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
@@ -1684,6 +1691,223 @@ static struct attribute *timecard_attrs[] = {
 };
 ATTRIBUTE_GROUPS(timecard);
 
+#ifdef CONFIG_DEBUG_FS
+#define gpio_map(gpio, bit, pri, sec, def) ({			\
+	char *_ans;						\
+	if (gpio & (1 << bit))					\
+		_ans = pri;					\
+	else if (gpio & (1 << (bit + 16)))			\
+		_ans = sec;					\
+	else							\
+		_ans = def;					\
+	_ans;							\
+})
+
+#define gpio_multi_map(buf, gpio, bit, pri, sec, def) ({	\
+		char *_ans;					\
+		_ans = buf;					\
+		strcpy(buf, def);				\
+		if (gpio & (1 << (bit + 16)))			\
+			_ans += sprintf(_ans, "%s ", pri);	\
+		if (gpio & (1 << bit))				\
+			_ans += sprintf(_ans, "%s ", sec);	\
+})
+
+static int
+ptp_ocp_summary_show(struct seq_file *s, void *data)
+{
+	struct device *dev = s->private;
+	struct ts_reg __iomem *ts_reg;
+	u32 sma_in, sma_out, val;
+	struct timespec64 ts;
+	struct ptp_ocp *bp;
+	char *buf, *src;
+	bool on;
+
+	buf = (char *)__get_free_page(GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	sma1_out_show(dev, NULL, buf);
+	seq_printf(s, "   sma1: out from %s", buf);
+
+	sma2_out_show(dev, NULL, buf);
+	seq_printf(s, "   sma2: out from %s", buf);
+
+	sma3_in_show(dev, NULL, buf);
+	seq_printf(s, "   sma3: input to %s", buf);
+
+	sma4_in_show(dev, NULL, buf);
+	seq_printf(s, "   sma4: input to %s", buf);
+
+	bp = dev_get_drvdata(dev);
+	sma_in = ioread32(&bp->sma->gpio1);
+	sma_out = ioread32(&bp->sma->gpio2);
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
+		src = gpio_map(sma_in, 2, "sma4", "sma3", "----");
+		seq_printf(s, "%7s: %s, src: %s\n", "TS1",
+			   on ? " ON" : "OFF", src);
+	}
+
+	if (bp->ts2) {
+		ts_reg = bp->ts2->mem;
+		on = ioread32(&ts_reg->enable);
+		src = gpio_map(sma_in, 3, "sma4", "sma3", "----");
+		seq_printf(s, "%7s: %s, src: %s\n", "TS2",
+			   on ? " ON" : "OFF", src);
+	}
+
+	if (bp->irig_out) {
+		on = ioread32(&bp->irig_out->ctrl) & IRIG_M_CTRL_ENABLE;
+		val = ioread32(&bp->irig_out->status);
+		gpio_multi_map(buf, sma_out, 4, "sma1", "sma2", "----");
+		seq_printf(s, "%7s: %s, error: %d, out: %s\n", "IRIG",
+			   on ? " ON" : "OFF", val, buf);
+	}
+
+	if (bp->irig_in) {
+		on = ioread32(&bp->irig_in->ctrl) & IRIG_S_CTRL_ENABLE;
+		val = ioread32(&bp->irig_in->status);
+		src = gpio_map(sma_in, 4, "sma4", "sma3", "----");
+		seq_printf(s, "%7s: %s, error: %d, src: %s\n", "IRIG in",
+			   on ? " ON" : "OFF", val, src);
+	}
+
+	if (bp->dcf_out) {
+		on = ioread32(&bp->dcf_out->ctrl) & DCF_M_CTRL_ENABLE;
+		val = ioread32(&bp->dcf_out->status);
+		gpio_multi_map(buf, sma_out, 5, "sma1", "sma2", "----");
+		seq_printf(s, "%7s: %s, error: %d, out: %s\n", "DCF",
+			   on ? " ON" : "OFF", val, buf);
+	}
+
+	if (bp->dcf_in) {
+		on = ioread32(&bp->dcf_in->ctrl) & DCF_S_CTRL_ENABLE;
+		val = ioread32(&bp->dcf_in->status);
+		src = gpio_map(sma_in, 5, "sma4", "sma3", "----");
+		seq_printf(s, "%7s: %s, error: %d, src: %s\n", "DCF in",
+			   on ? " ON" : "OFF", val, src);
+	}
+
+	src = gpio_map(sma_in, 2, "sma4", "sma3", "GNSS");
+	sprintf(buf, "%s via PPS2", src);
+	seq_printf(s, " MAC PPS src: %s\n", buf);
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
+		if (bp->pps_select) {
+			val = ioread32(&bp->pps_select->gpio1);
+			if (val & 0x01) {
+				src = gpio_map(sma_in, 1,
+					       "sma4", "sma3", "----");
+			} else if (val & 0x02)
+				src = "MAC";
+			else if (val & 0x04)
+				src = "GNSS";
+			else
+				src = "----";
+			sprintf(buf, "%s via PPS1", src);
+		} else {
+			strcpy(buf, "PPS1");
+		}
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
+	if (!ptp_ocp_gettimex(&bp->ptp_info, &ts, NULL))
+		seq_printf(s, "%7s: %lld.%ld == %ptT\n", "PHC",
+			   ts.tv_sec, ts.tv_nsec, &ts);
+
+	free_page((unsigned long)buf);
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(ptp_ocp_summary);
+
+static struct dentry *ptp_ocp_debugfs_root;
+
+static int
+ptp_ocp_debugfs_add_device(struct ptp_ocp *bp)
+{
+	struct dentry *d;
+
+	d = debugfs_create_dir(dev_name(&bp->dev), ptp_ocp_debugfs_root);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+	bp->debug_root = d;
+
+	d = debugfs_create_file("summary", 0444, bp->debug_root,
+				&bp->dev, &ptp_ocp_summary_fops);
+	if (IS_ERR(d))
+		goto fail;
+
+	return 0;
+
+fail:
+	debugfs_remove_recursive(bp->debug_root);
+	bp->debug_root = NULL;
+
+	return PTR_ERR(d);
+}
+
+static void
+ptp_ocp_debugfs_remove_device(struct ptp_ocp *bp)
+{
+	debugfs_remove_recursive(bp->debug_root);
+}
+
+static int
+ptp_ocp_debugfs_init(void)
+{
+	struct dentry *d;
+
+	d = debugfs_create_dir("timecard", NULL);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+
+	ptp_ocp_debugfs_root = d;
+
+	return 0;
+}
+
+static void
+ptp_ocp_debugfs_fini(void)
+{
+	debugfs_remove_recursive(ptp_ocp_debugfs_root);
+}
+#else
+#define ptp_ocp_debugfs_init()			0
+#define ptp_ocp_debugfs_fini()
+#define ptp_ocp_debugfs_add_device(bp)		0
+#define ptp_ocp_debugfs_remove_device(bp)
+#endif
+
 static void
 ptp_ocp_dev_release(struct device *dev)
 {
@@ -1787,6 +2011,9 @@ ptp_ocp_complete(struct ptp_ocp *bp)
 	if (device_add_groups(&bp->dev, timecard_groups))
 		pr_err("device add groups failed\n");
 
+	if (ptp_ocp_debugfs_add_device(bp))
+		pr_err("debugfs add device failed\n");
+
 	return 0;
 }
 
@@ -1827,6 +2054,7 @@ ptp_ocp_detach_sysfs(struct ptp_ocp *bp)
 static void
 ptp_ocp_detach(struct ptp_ocp *bp)
 {
+	ptp_ocp_debugfs_remove_device(bp);
 	ptp_ocp_detach_sysfs(bp);
 	if (timer_pending(&bp->watchdog))
 		del_timer_sync(&bp->watchdog);
@@ -1997,10 +2225,15 @@ ptp_ocp_init(void)
 	const char *what;
 	int err;
 
+	what = "debugfs entry";
+	err = ptp_ocp_debugfs_init();
+	if (err)
+		goto out;
+
 	what = "timecard class";
 	err = class_register(&timecard_class);
 	if (err)
-		goto out;
+		goto out_debug;
 
 	what = "i2c notifier";
 	err = bus_register_notifier(&i2c_bus_type, &ptp_ocp_i2c_notifier);
@@ -2018,6 +2251,8 @@ ptp_ocp_init(void)
 	bus_unregister_notifier(&i2c_bus_type, &ptp_ocp_i2c_notifier);
 out_notifier:
 	class_unregister(&timecard_class);
+out_debug:
+	ptp_ocp_debugfs_fini();
 out:
 	pr_err(KBUILD_MODNAME ": failed to register %s: %d\n", what, err);
 	return err;
@@ -2029,6 +2264,7 @@ ptp_ocp_fini(void)
 	bus_unregister_notifier(&i2c_bus_type, &ptp_ocp_i2c_notifier);
 	pci_unregister_driver(&ptp_ocp_driver);
 	class_unregister(&timecard_class);
+	ptp_ocp_debugfs_fini();
 }
 
 module_init(ptp_ocp_init);
-- 
2.31.1

