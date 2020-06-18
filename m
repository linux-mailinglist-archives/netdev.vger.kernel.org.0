Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85DA1FEB95
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgFRGk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbgFRGkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:40:51 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81630C06174E;
        Wed, 17 Jun 2020 23:40:51 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=localhost.localdomain)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jloE3-0000xD-JV; Thu, 18 Jun 2020 08:40:39 +0200
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
Subject: [RFC PATCH 3/9] net: dsa: hellcreek: Add PTP clock support
Date:   Thu, 18 Jun 2020 08:40:23 +0200
Message-Id: <20200618064029.32168-4-kurt@linutronix.de>
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

From: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>

The switch has internal PTP hardware clocks. Add support for it. There are three
clocks:

 * Synchronized
 * Syntonized
 * Free running

Currently the synchronized clock is exported to user space which is a good
default for the beginning. The free running clock might be exported later
e.g. for implementing 802.1AS-2011/2020 Time Aware Bridges (TAB). The switch
also supports cross time stamping for that purpose.

The implementation adds support setting/getting the time as well as offset and
frequency adjustments. However, the clock only holds a partial timeofday
timestamp. This is why we track the seconds completely in software (see overflow
work and last_ts).

Furthermore, add the PTP multicast addresses into the FDB to forward that
packages only to the CPU port where they are processed by a PTP program.

Signed-off-by: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/Makefile        |   4 +-
 drivers/net/dsa/hirschmann/hellcreek.c     |  72 ++++++
 drivers/net/dsa/hirschmann/hellcreek.h     |   7 +
 drivers/net/dsa/hirschmann/hellcreek_ptp.c | 279 +++++++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek_ptp.h |  69 +++++
 5 files changed, 430 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_ptp.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_ptp.h

diff --git a/drivers/net/dsa/hirschmann/Makefile b/drivers/net/dsa/hirschmann/Makefile
index 0e12e149e40f..39de02a03640 100644
--- a/drivers/net/dsa/hirschmann/Makefile
+++ b/drivers/net/dsa/hirschmann/Makefile
@@ -1,2 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)	+= hellcreek.o
+obj-$(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)	+= hellcreek_sw.o
+hellcreek_sw-objs := hellcreek.o
+hellcreek_sw-objs += hellcreek_ptp.o
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index c5ba52f1ebc8..f6561bf97f56 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -25,6 +25,7 @@
 #include <net/dsa.h>
 
 #include "hellcreek.h"
+#include "hellcreek_ptp.h"
 
 static const struct hellcreek_counter hellcreek_counter[] = {
 	{ 0x00, "RxFiltered", },
@@ -995,6 +996,44 @@ static void hellcreek_setup_tc_identity_mapping(struct hellcreek *hellcreek)
 	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
 }
 
+static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
+{
+	static struct hellcreek_fdb_entry ptp = {
+		/* MAC: 01-1B-19-00-00-00 */
+		.mac	      = { 0x01, 0x1b, 0x19, 0x00, 0x00, 0x00 },
+		.portmask     = 0x03,	/* Management ports */
+		.age	      = 0,
+		.is_obt	      = 0,
+		.pass_blocked = 0,
+		.is_static    = 1,
+		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
+		.reprio_en    = 1,
+	};
+	static struct hellcreek_fdb_entry p2p = {
+		/* MAC: 01-80-C2-00-00-0E */
+		.mac	      = { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x0e },
+		.portmask     = 0x03,	/* Management ports */
+		.age	      = 0,
+		.is_obt	      = 0,
+		.pass_blocked = 0,
+		.is_static    = 1,
+		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
+		.reprio_en    = 1,
+	};
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&hellcreek->reg_lock, flags);
+	ret = __hellcreek_fdb_add(hellcreek, &ptp);
+	if (ret)
+		goto out;
+	ret = __hellcreek_fdb_add(hellcreek, &p2p);
+out:
+	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
+
+	return ret;
+}
+
 static int hellcreek_setup(struct dsa_switch *ds)
 {
 	struct hellcreek *hellcreek = ds->priv;
@@ -1034,6 +1073,14 @@ static int hellcreek_setup(struct dsa_switch *ds)
 	/* Configure PCP <-> TC mapping */
 	hellcreek_setup_tc_identity_mapping(hellcreek);
 
+	/* Intercept _all_ PTP multicast traffic */
+	ret = hellcreek_setup_fdb(hellcreek);
+	if (ret) {
+		dev_err(hellcreek->dev,
+			"Failed to insert static PTP FDB entries\n");
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -1090,6 +1137,7 @@ static int hellcreek_probe(struct platform_device *pdev)
 	}
 
 	spin_lock_init(&hellcreek->reg_lock);
+	spin_lock_init(&hellcreek->ptp_lock);
 
 	hellcreek->dev = dev;
 
@@ -1105,6 +1153,18 @@ static int hellcreek_probe(struct platform_device *pdev)
 		return PTR_ERR(hellcreek->base);
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res) {
+		dev_err(dev, "No PTP memory region provided!\n");
+		return -ENODEV;
+	}
+
+	hellcreek->ptp_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(hellcreek->ptp_base)) {
+		dev_err(dev, "No memory available!\n");
+		return PTR_ERR(hellcreek->ptp_base);
+	}
+
 	ret = hellcreek_detect(hellcreek);
 	if (ret) {
 		dev_err(dev, "No (known) chip found!\n");
@@ -1135,15 +1195,27 @@ static int hellcreek_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = hellcreek_ptp_setup(hellcreek);
+	if (ret) {
+		dev_err(dev, "Failed to setup PTP!\n");
+		goto err_ptp_setup;
+	}
+
 	platform_set_drvdata(pdev, hellcreek);
 
 	return 0;
+
+err_ptp_setup:
+	dsa_unregister_switch(hellcreek->ds);
+
+	return ret;
 }
 
 static int hellcreek_remove(struct platform_device *pdev)
 {
 	struct hellcreek *hellcreek = platform_get_drvdata(pdev);
 
+	hellcreek_ptp_free(hellcreek);
 	dsa_unregister_switch(hellcreek->ds);
 	platform_set_drvdata(pdev, NULL);
 
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index a08a10cb5ab7..2d4422fd2567 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -234,10 +234,17 @@ struct hellcreek_fdb_entry {
 struct hellcreek {
 	struct device *dev;
 	struct dsa_switch *ds;
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_clock_info;
 	struct hellcreek_port ports[4];
+	struct delayed_work overflow_work;
 	spinlock_t reg_lock;	/* Switch IP register lock */
+	spinlock_t ptp_lock;	/* PTP IP register lock */
 	void __iomem *base;
+	void __iomem *ptp_base;
 	u8 *vidmbrcfg;		/* vidmbrcfg shadow */
+	u64 seconds;		/* PTP seconds */
+	u64 last_ts;		/* Used for overflow detection */
 	size_t fdb_entries;
 };
 
diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
new file mode 100644
index 000000000000..0dcfbb1272ff
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
@@ -0,0 +1,279 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * DSA driver for:
+ * Hirschmann Hellcreek TSN switch.
+ *
+ * Copyright (C) 2019,2020 Hochschule Offenburg
+ * Copyright (C) 2019,2020 Linutronix GmbH
+ * Authors: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
+ *	    Kurt Kanzenbach <kurt@linutronix.de>
+ */
+
+#include <linux/ptp_clock_kernel.h>
+#include "hellcreek.h"
+#include "hellcreek_ptp.h"
+
+static u16 hellcreek_ptp_read(struct hellcreek *hellcreek, unsigned int offset)
+{
+	return readw(hellcreek->ptp_base + offset);
+}
+
+static void hellcreek_ptp_write(struct hellcreek *hellcreek, u16 data,
+				unsigned int offset)
+{
+	writew(data, hellcreek->ptp_base + offset);
+}
+
+/* Get nanoseconds from PTP clock */
+static u64 __hellcreek_ptp_clock_read(struct hellcreek *hellcreek)
+{
+	u16 nsl, nsh, secl, secm, sech;
+
+	/* Take a snapshot */
+	hellcreek_ptp_write(hellcreek, PR_COMMAND_C_SS, PR_COMMAND_C);
+
+	/* The time of the day is saved as 96 bits. However, due to hardware
+	 * limitations the seconds are not or only partly kept in the PTP
+	 * core. That's why only the nanoseconds are used and the seconds are
+	 * tracked in software. Anyway due to internal locking all five
+	 * registers should be read.
+	 */
+	sech = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
+	secm = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
+	secl = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
+	nsh  = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
+	nsl  = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
+
+	return (u64)nsl | ((u64)nsh << 16);
+}
+
+static u64 __hellcreek_ptp_gettime(struct hellcreek *hellcreek)
+{
+	u64 ns;
+
+	ns = __hellcreek_ptp_clock_read(hellcreek);
+	if (ns < hellcreek->last_ts)
+		hellcreek->seconds++;
+	hellcreek->last_ts = ns;
+	ns += hellcreek->seconds * NSEC_PER_SEC;
+
+	return ns;
+}
+
+static int hellcreek_ptp_gettime(struct ptp_clock_info *ptp,
+				 struct timespec64 *ts)
+{
+	struct hellcreek *hellcreek = ptp_to_hellcreek(ptp);
+	u64 ns;
+
+	spin_lock(&hellcreek->ptp_lock);
+	ns = __hellcreek_ptp_gettime(hellcreek);
+	spin_unlock(&hellcreek->ptp_lock);
+
+	*ts = ns_to_timespec64(ns);
+
+	return 0;
+}
+
+static int hellcreek_ptp_settime(struct ptp_clock_info *ptp,
+				 const struct timespec64 *ts)
+{
+	struct hellcreek *hellcreek = ptp_to_hellcreek(ptp);
+	u16 secl, nsh, nsl;
+
+	secl = ts->tv_sec & 0xffff;
+	nsh  = ((u32)ts->tv_nsec & 0xffff0000) >> 16;
+	nsl  = ts->tv_nsec & 0xffff;
+
+	spin_lock(&hellcreek->ptp_lock);
+
+	/* Update overflow data structure */
+	hellcreek->seconds = ts->tv_sec;
+	hellcreek->last_ts = ts->tv_nsec;
+
+	/* Set time in clock */
+	hellcreek_ptp_write(hellcreek, 0x00, PR_CLOCK_WRITE_C);
+	hellcreek_ptp_write(hellcreek, 0x00, PR_CLOCK_WRITE_C);
+	hellcreek_ptp_write(hellcreek, secl, PR_CLOCK_WRITE_C);
+	hellcreek_ptp_write(hellcreek, nsh,  PR_CLOCK_WRITE_C);
+	hellcreek_ptp_write(hellcreek, nsl,  PR_CLOCK_WRITE_C);
+
+	spin_unlock(&hellcreek->ptp_lock);
+
+	return 0;
+}
+
+static int hellcreek_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct hellcreek *hellcreek = ptp_to_hellcreek(ptp);
+	u16 negative = 0, addendh, addendl;
+	u32 addend;
+	u64 adj;
+
+	if (scaled_ppm < 0) {
+		negative = 1;
+		scaled_ppm = -scaled_ppm;
+	}
+
+	/* IP-Core adjusts the nominal frequency by adding or subtracting 1 ns
+	 * from the 8 ns (period of the oscillator) every time the accumulator
+	 * register overflows. The value stored in the addend register is added
+	 * to the accumulator register every 8 ns.
+	 *
+	 * addend value = (2^30 * accumulator_overflow_rate) /
+	 *                oscillator_frequency
+	 * where:
+	 *
+	 * oscillator_frequency = 125 MHz
+	 * accumulator_overflow_rate = 125 MHz * scaled_ppm * 2^-16 * 10^-6 * 8
+	 */
+	adj = scaled_ppm;
+	adj <<= 11;
+	addend = (u32)div_u64(adj, 15625);
+
+	addendh = (addend & 0xffff0000) >> 16;
+	addendl = addend & 0xffff;
+
+	negative = (negative << 15) & 0x8000;
+
+	spin_lock(&hellcreek->ptp_lock);
+
+	/* Set drift register */
+	hellcreek_ptp_write(hellcreek, negative, PR_CLOCK_DRIFT_C);
+	hellcreek_ptp_write(hellcreek, 0x00, PR_CLOCK_DRIFT_C);
+	hellcreek_ptp_write(hellcreek, 0x00, PR_CLOCK_DRIFT_C);
+	hellcreek_ptp_write(hellcreek, addendh,  PR_CLOCK_DRIFT_C);
+	hellcreek_ptp_write(hellcreek, addendl,  PR_CLOCK_DRIFT_C);
+
+	spin_unlock(&hellcreek->ptp_lock);
+
+	return 0;
+}
+
+static int hellcreek_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct hellcreek *hellcreek = ptp_to_hellcreek(ptp);
+	u16 negative = 0, counth, countl;
+	u32 count_val;
+
+	/* If the offset is larger than IP-Core slow offset resources. Don't
+	 * concider slow adjustment. Rather, add the offset directly to the
+	 * current time
+	 */
+	if (abs(delta) > MAX_SLOW_OFFSET_ADJ) {
+		struct timespec64 now, then = ns_to_timespec64(delta);
+
+		hellcreek_ptp_gettime(ptp, &now);
+		now = timespec64_add(now, then);
+		hellcreek_ptp_settime(ptp, &now);
+
+		return 0;
+	}
+
+	if (delta < 0) {
+		negative = 1;
+		delta = -delta;
+	}
+
+	/* 'count_val' does not exceed the maximum register size (2^30) */
+	count_val = div_s64(delta, MAX_NS_PER_STEP);
+
+	counth = (count_val & 0xffff0000) >> 16;
+	countl = count_val & 0xffff;
+
+	negative = (negative << 15) & 0x8000;
+
+	spin_lock(&hellcreek->ptp_lock);
+
+	/* Set offset write register */
+	hellcreek_ptp_write(hellcreek, negative, PR_CLOCK_OFFSET_C);
+	hellcreek_ptp_write(hellcreek, MAX_NS_PER_STEP, PR_CLOCK_OFFSET_C);
+	hellcreek_ptp_write(hellcreek, MIN_CLK_CYCLES_BETWEEN_STEPS,
+			    PR_CLOCK_OFFSET_C);
+	hellcreek_ptp_write(hellcreek, countl,  PR_CLOCK_OFFSET_C);
+	hellcreek_ptp_write(hellcreek, counth,  PR_CLOCK_OFFSET_C);
+
+	spin_unlock(&hellcreek->ptp_lock);
+
+	return 0;
+}
+
+static int hellcreek_ptp_enable(struct ptp_clock_info *ptp,
+				struct ptp_clock_request *rq, int on)
+{
+	return -EOPNOTSUPP;
+}
+
+static void hellcreek_ptp_overflow_check(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct hellcreek *hellcreek = dw_overflow_to_hellcreek(dw);
+
+	spin_lock(&hellcreek->ptp_lock);
+	__hellcreek_ptp_gettime(hellcreek);
+	spin_unlock(&hellcreek->ptp_lock);
+
+	schedule_delayed_work(&hellcreek->overflow_work,
+			      HELLCREEK_OVERFLOW_PERIOD);
+}
+
+int hellcreek_ptp_setup(struct hellcreek *hellcreek)
+{
+	u16 status;
+
+	/* Set up the overflow work */
+	INIT_DELAYED_WORK(&hellcreek->overflow_work,
+			  hellcreek_ptp_overflow_check);
+
+	/* Setup PTP clock */
+	hellcreek->ptp_clock_info.owner = THIS_MODULE;
+	snprintf(hellcreek->ptp_clock_info.name,
+		 sizeof(hellcreek->ptp_clock_info.name),
+		 dev_name(hellcreek->dev));
+
+	/* IP-Core can add up to 0.5 ns per 8 ns cycle, which means
+	 * accumulator_overflow_rate shall not exceed 62.5 MHz (which adjusts
+	 * the nominal frequency by 6.25%)
+	 */
+	hellcreek->ptp_clock_info.max_adj   = 62500000;
+	hellcreek->ptp_clock_info.n_alarm   = 0;
+	hellcreek->ptp_clock_info.n_pins    = 0;
+	hellcreek->ptp_clock_info.n_ext_ts  = 0;
+	hellcreek->ptp_clock_info.n_per_out = 0;
+	hellcreek->ptp_clock_info.pps	    = 0;
+	hellcreek->ptp_clock_info.adjfine   = hellcreek_ptp_adjfine;
+	hellcreek->ptp_clock_info.adjtime   = hellcreek_ptp_adjtime;
+	hellcreek->ptp_clock_info.gettime64 = hellcreek_ptp_gettime;
+	hellcreek->ptp_clock_info.settime64 = hellcreek_ptp_settime;
+	hellcreek->ptp_clock_info.enable    = hellcreek_ptp_enable;
+
+	hellcreek->ptp_clock = ptp_clock_register(&hellcreek->ptp_clock_info,
+						  hellcreek->dev);
+	if (IS_ERR(hellcreek->ptp_clock))
+		return PTR_ERR(hellcreek->ptp_clock);
+
+	/* Enable the offset correction process, if no offset correction is
+	 * already taking place
+	 */
+	status = hellcreek_ptp_read(hellcreek, PR_CLOCK_STATUS_C);
+	if (!(status & PR_CLOCK_STATUS_C_OFS_ACT))
+		hellcreek_ptp_write(hellcreek,
+				    status | PR_CLOCK_STATUS_C_ENA_OFS,
+				    PR_CLOCK_STATUS_C);
+
+	/* Enable the drift correction process */
+	hellcreek_ptp_write(hellcreek, status | PR_CLOCK_STATUS_C_ENA_DRIFT,
+			    PR_CLOCK_STATUS_C);
+
+	schedule_delayed_work(&hellcreek->overflow_work,
+			      HELLCREEK_OVERFLOW_PERIOD);
+
+	return 0;
+}
+
+void hellcreek_ptp_free(struct hellcreek *hellcreek)
+{
+	cancel_delayed_work_sync(&hellcreek->overflow_work);
+	ptp_clock_unregister(hellcreek->ptp_clock);
+	hellcreek->ptp_clock = NULL;
+}
diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.h b/drivers/net/dsa/hirschmann/hellcreek_ptp.h
new file mode 100644
index 000000000000..2dd8aaa532d0
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * DSA driver for:
+ * Hirschmann Hellcreek TSN switch.
+ *
+ * Copyright (C) 2019,2020 Hochschule Offenburg
+ * Copyright (C) 2019,2020 Linutronix GmbH
+ * Authors: Kurt Kanzenbach <kurt@linutronix.de>
+ *	    Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
+ */
+
+#ifndef _HELLCREEK_PTP_H_
+#define _HELLCREEK_PTP_H_
+
+#include <linux/bitops.h>
+#include <linux/ptp_clock_kernel.h>
+
+#include "hellcreek.h"
+
+/* Every jump in time is 7 ns */
+#define MAX_NS_PER_STEP			7L
+
+/* Correct offset at every clock cycle */
+#define MIN_CLK_CYCLES_BETWEEN_STEPS	0
+
+/* Maximum available slow offset resources */
+#define MAX_SLOW_OFFSET_ADJ					\
+	((unsigned long long)((1 << 30) - 1) * MAX_NS_PER_STEP)
+
+/* four times a second overflow check */
+#define HELLCREEK_OVERFLOW_PERIOD	(HZ / 4)
+
+/* PTP Register */
+#define PR_SETTINGS_C			(0x09 * 2)
+#define PR_SETTINGS_C_RES3TS		BIT(4)
+#define PR_SETTINGS_C_TS_SRC_TK_SHIFT	8
+#define PR_SETTINGS_C_TS_SRC_TK_MASK	GENMASK(9, 8)
+#define PR_COMMAND_C			(0x0a * 2)
+#define PR_COMMAND_C_SS			BIT(0)
+
+#define PR_CLOCK_STATUS_C		(0x0c * 2)
+#define PR_CLOCK_STATUS_C_ENA_DRIFT	BIT(12)
+#define PR_CLOCK_STATUS_C_OFS_ACT	BIT(13)
+#define PR_CLOCK_STATUS_C_ENA_OFS	BIT(14)
+
+#define PR_CLOCK_READ_C			(0x0d * 2)
+#define PR_CLOCK_WRITE_C		(0x0e * 2)
+#define PR_CLOCK_OFFSET_C		(0x0f * 2)
+#define PR_CLOCK_DRIFT_C		(0x10 * 2)
+
+#define PR_SS_FREE_DATA_C		(0x12 * 2)
+#define PR_SS_SYNT_DATA_C		(0x14 * 2)
+#define PR_SS_SYNC_DATA_C		(0x16 * 2)
+#define PR_SS_DRAC_DATA_C		(0x18 * 2)
+
+#define STATUS_OUT			(0x60 * 2)
+#define STATUS_OUT_SYNC_GOOD		BIT(0)
+#define STATUS_OUT_IS_GM		BIT(1)
+
+int hellcreek_ptp_setup(struct hellcreek *hellcreek);
+void hellcreek_ptp_free(struct hellcreek *hellcreek);
+
+#define ptp_to_hellcreek(ptp)					\
+	container_of(ptp, struct hellcreek, ptp_clock_info)
+
+#define dw_overflow_to_hellcreek(dw)				\
+	container_of(dw, struct hellcreek, overflow_work)
+
+#endif /* _HELLCREEK_PTP_H_ */
-- 
2.20.1

