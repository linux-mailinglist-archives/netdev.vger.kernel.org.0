Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435D71FEB9C
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgFRGlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727853AbgFRGkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:40:46 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824F3C061755;
        Wed, 17 Jun 2020 23:40:46 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=localhost.localdomain)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jloE7-0000xD-1z; Thu, 18 Jun 2020 08:40:43 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 6/9] net: dsa: hellcreek: Add debugging mechanisms
Date:   Thu, 18 Jun 2020 08:40:26 +0200
Message-Id: <20200618064029.32168-7-kurt@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200618064029.32168-1-kurt@linutronix.de>
References: <20200618064029.32168-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch has registers which are useful for debugging issues:

 * Trace registers

   This can be helpful to trace why packets have been filtered or dropped or if
   there any other serious problems.

 * Memory registers

   These registers provide the current switch internal RAM
   utilization. Especially a unexpected workload with an not appropriate queue
   setup packets might be dropped due to memory exhaustion.

Expose that registers via debugfs.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 207 ++++++++++++++++++++++++-
 drivers/net/dsa/hirschmann/hellcreek.h |   1 +
 2 files changed, 205 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 7e678b298f99..a56df65ae486 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/ktime.h>
 #include <linux/time.h>
+#include <linux/debugfs.h>
 #include <net/dsa.h>
 #include <net/pkt_sched.h>
 
@@ -1371,6 +1372,195 @@ static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
 	return hellcreek_port_del_schedule(ds, port);
 }
 
+static ssize_t hellcreek_dbg_swtrc_cfg_write(struct file *filp,
+					     const char __user *buffer,
+					     size_t count, loff_t *ppos)
+{
+	struct hellcreek *hellcreek = filp->private_data;
+	int ret;
+	u16 reg;
+
+	ret = kstrtou16_from_user(buffer, count, 16, &reg);
+	if (ret)
+		return ret;
+
+	hellcreek_write(hellcreek, reg, HR_SWTRC_CFG);
+
+	return count;
+}
+
+static ssize_t hellcreek_dbg_swtrc0_write(struct file *filp,
+					  const char __user *buffer,
+					  size_t count, loff_t *ppos)
+{
+	struct hellcreek *hellcreek = filp->private_data;
+	int ret;
+	u16 reg;
+
+	ret = kstrtou16_from_user(buffer, count, 16, &reg);
+	if (ret)
+		return ret;
+
+	hellcreek_write(hellcreek, reg, HR_SWTRC0);
+
+	return count;
+}
+
+static ssize_t hellcreek_dbg_swtrc1_write(struct file *filp,
+					  const char __user *buffer,
+					  size_t count, loff_t *ppos)
+{
+	struct hellcreek *hellcreek = filp->private_data;
+	int ret;
+	u16 reg;
+
+	ret = kstrtou16_from_user(buffer, count, 16, &reg);
+	if (ret)
+		return ret;
+
+	hellcreek_write(hellcreek, reg, HR_SWTRC1);
+
+	return count;
+}
+
+static ssize_t hellcreek_dbg_swtrc0_read(struct file *filp,
+					 char __user *buffer,
+					 size_t count, loff_t *ppos)
+{
+	struct hellcreek *hellcreek = filp->private_data;
+	char buf[32];
+	ssize_t desc = 0;
+	u16 reg;
+
+	reg = hellcreek_read(hellcreek, HR_SWTRC0);
+
+	desc += snprintf(buf, sizeof(buf), "0x%04x\n", reg);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, desc);
+}
+
+static ssize_t hellcreek_dbg_swtrc1_read(struct file *filp,
+					 char __user *buffer,
+					 size_t count, loff_t *ppos)
+{
+	struct hellcreek *hellcreek = filp->private_data;
+	char buf[32];
+	ssize_t desc = 0;
+	u16 reg;
+
+	reg = hellcreek_read(hellcreek, HR_SWTRC1);
+
+	desc += snprintf(buf, sizeof(buf), "0x%04x\n", reg);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, desc);
+}
+
+static ssize_t hellcreek_dbg_mfree_read(struct file *filp,
+					char __user *buffer,
+					size_t count, loff_t *ppos)
+{
+	struct hellcreek *hellcreek = filp->private_data;
+	char buf[32];
+	ssize_t desc = 0;
+	u16 reg;
+
+	reg = hellcreek_read(hellcreek, HR_MFREE);
+
+	desc += snprintf(buf, sizeof(buf), "0x%04x\n", reg);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, desc);
+}
+
+static ssize_t hellcreek_dbg_pfree_read(struct file *filp,
+					char __user *buffer,
+					size_t count, loff_t *ppos)
+{
+	struct hellcreek *hellcreek = filp->private_data;
+	char buf[32];
+	ssize_t desc = 0;
+	u16 reg;
+
+	reg = hellcreek_read(hellcreek, HR_PFREE);
+
+	desc += snprintf(buf, sizeof(buf), "0x%04x\n", reg);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, desc);
+}
+
+static const struct file_operations hellcreek_dbg_swtrc_cfg_fops = {
+	.owner = THIS_MODULE,
+	.open  = simple_open,
+	.write = hellcreek_dbg_swtrc_cfg_write,
+};
+
+static const struct file_operations hellcreek_dbg_swtrc0_fops = {
+	.owner = THIS_MODULE,
+	.open  = simple_open,
+	.read  = hellcreek_dbg_swtrc0_read,
+	.write = hellcreek_dbg_swtrc0_write,
+};
+
+static const struct file_operations hellcreek_dbg_swtrc1_fops = {
+	.owner = THIS_MODULE,
+	.open  = simple_open,
+	.read  = hellcreek_dbg_swtrc1_read,
+	.write = hellcreek_dbg_swtrc1_write,
+};
+
+static const struct file_operations hellcreek_dbg_pfree_fops = {
+	.owner = THIS_MODULE,
+	.open  = simple_open,
+	.read  = hellcreek_dbg_pfree_read,
+};
+
+static const struct file_operations hellcreek_dbg_mfree_fops = {
+	.owner = THIS_MODULE,
+	.open  = simple_open,
+	.read  = hellcreek_dbg_mfree_read,
+};
+
+static int hellcreek_debugfs_init(struct hellcreek *hellcreek)
+{
+	struct dentry *file;
+
+	hellcreek->debug_dir = debugfs_create_dir(dev_name(hellcreek->dev),
+						  NULL);
+	if (!hellcreek->debug_dir)
+		return -ENOMEM;
+
+	file = debugfs_create_file("swtrc_cfg", 0200, hellcreek->debug_dir,
+				   hellcreek, &hellcreek_dbg_swtrc_cfg_fops);
+	if (!file)
+		return -ENOMEM;
+
+	file = debugfs_create_file("swtrc0", 0600, hellcreek->debug_dir,
+				   hellcreek, &hellcreek_dbg_swtrc0_fops);
+	if (!file)
+		return -ENOMEM;
+
+	file = debugfs_create_file("swtrc1", 0600, hellcreek->debug_dir,
+				   hellcreek, &hellcreek_dbg_swtrc1_fops);
+	if (!file)
+		return -ENOMEM;
+
+	file = debugfs_create_file("pfree", 0400, hellcreek->debug_dir,
+				   hellcreek, &hellcreek_dbg_pfree_fops);
+	if (!file)
+		return -ENOMEM;
+
+	file = debugfs_create_file("mfree", 0400, hellcreek->debug_dir,
+				   hellcreek, &hellcreek_dbg_mfree_fops);
+	if (!file)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void hellcreek_debugfs_exit(struct hellcreek *hellcreek)
+{
+	debugfs_remove_recursive(hellcreek->debug_dir);
+}
+
 static const struct dsa_switch_ops hellcreek_ds_ops = {
 	.get_tag_protocol    = hellcreek_get_tag_protocol,
 	.setup		     = hellcreek_setup,
@@ -1475,9 +1665,17 @@ static int hellcreek_probe(struct platform_device *pdev)
 
 	hellcreek_feature_detect(hellcreek);
 
+	ret = hellcreek_debugfs_init(hellcreek);
+	if (ret) {
+		dev_err(dev, "Failed to initialize debugfs!\n");
+		goto err_debugfs;
+	}
+
 	hellcreek->ds = devm_kzalloc(dev, sizeof(*hellcreek->ds), GFP_KERNEL);
-	if (!hellcreek->ds)
-		return -ENOMEM;
+	if (!hellcreek->ds) {
+		ret = -ENOMEM;
+		goto err_debugfs;
+	}
 
 	hellcreek->ds->dev	     = dev;
 	hellcreek->ds->priv	     = hellcreek;
@@ -1488,7 +1686,7 @@ static int hellcreek_probe(struct platform_device *pdev)
 	ret = dsa_register_switch(hellcreek->ds);
 	if (ret) {
 		dev_err(dev, "Unable to register switch\n");
-		return ret;
+		goto err_debugfs;
 	}
 
 	ret = hellcreek_ptp_setup(hellcreek);
@@ -1511,6 +1709,8 @@ static int hellcreek_probe(struct platform_device *pdev)
 	hellcreek_ptp_free(hellcreek);
 err_ptp_setup:
 	dsa_unregister_switch(hellcreek->ds);
+err_debugfs:
+	hellcreek_debugfs_exit(hellcreek);
 
 	return ret;
 }
@@ -1519,6 +1719,7 @@ static int hellcreek_remove(struct platform_device *pdev)
 {
 	struct hellcreek *hellcreek = platform_get_drvdata(pdev);
 
+	hellcreek_debugfs_exit(hellcreek);
 	hellcreek_hwtstamp_free(hellcreek);
 	hellcreek_ptp_free(hellcreek);
 	dsa_unregister_switch(hellcreek->ds);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index d3d1a1144857..59cc7b59ff2c 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -280,6 +280,7 @@ struct hellcreek {
 	struct ptp_clock_info ptp_clock_info;
 	struct hellcreek_port ports[4];
 	struct delayed_work overflow_work;
+	struct dentry *debug_dir;
 	spinlock_t reg_lock;	/* Switch IP register lock */
 	spinlock_t ptp_lock;	/* PTP IP register lock */
 	void __iomem *base;
-- 
2.20.1

