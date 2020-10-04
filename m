Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2925C282A73
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 13:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgJDLaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 07:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgJDLaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 07:30:17 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD9FC0613CE;
        Sun,  4 Oct 2020 04:30:17 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601811015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G7SFOaaoFD7PexbdxKaWB80B3oxruewf6vKenaH645o=;
        b=UxSqrWjr39y224Rlz8lwRMOL+GjQGo4l1EuF2kl+MVPPemHLXcf+mHj3UP+Bi1XIlHz2Zc
        sMazyu/JiUW6UO5oslbjcbLdd1wV2BywItWUIMyA01w1/NG5mGgojNhf/tgQayiB4ew3VE
        eaOWO9nOOnIPZQ32ShlKVoX6/ne5xQ3XhSH9OklLBh93bKnYaliyZcXobiMwF8VU3dqVUg
        OIyNwSgKjC4Esnzxm+4YEfap5bphzkeSK+m0JrDGdFnDEt5MiB8/Wzo2qf4xXvJrQ2jjGo
        nBstF7KIaW2LYsPoaWLJAEbWfcjnw6KTqmOX3T9czuSCr+ShQq/Fu/DWFuJ9KQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601811015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G7SFOaaoFD7PexbdxKaWB80B3oxruewf6vKenaH645o=;
        b=FDdJYStTYhqYVczH9rdKzLkgqHbr0b0KVeFe76MDm46pbyDtCzdAWeHz/IrpdZwWRgBOa9
        WZHOUwdiFS346bAg==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v6 3/7] net: dsa: hellcreek: Add PTP clock support
Date:   Sun,  4 Oct 2020 13:29:07 +0200
Message-Id: <20201004112911.25085-4-kurt@linutronix.de>
In-Reply-To: <20201004112911.25085-1-kurt@linutronix.de>
References: <20201004112911.25085-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/dsa/hirschmann/Kconfig         |   1 +
 drivers/net/dsa/hirschmann/Makefile        |   4 +-
 drivers/net/dsa/hirschmann/hellcreek.c     |  71 ++++++
 drivers/net/dsa/hirschmann/hellcreek.h     |   8 +
 drivers/net/dsa/hirschmann/hellcreek_ptp.c | 283 +++++++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek_ptp.h |  69 +++++
 6 files changed, 435 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_ptp.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_ptp.h

diff --git a/drivers/net/dsa/hirschmann/Kconfig b/drivers/net/dsa/hirschmann/Kconfig
index 7d189cb936e3..222dd35e2c9d 100644
--- a/drivers/net/dsa/hirschmann/Kconfig
+++ b/drivers/net/dsa/hirschmann/Kconfig
@@ -3,6 +3,7 @@ config NET_DSA_HIRSCHMANN_HELLCREEK
 	tristate "Hirschmann Hellcreek TSN Switch support"
 	depends on HAS_IOMEM
 	depends on NET_DSA
+	depends on PTP_1588_CLOCK
 	select NET_DSA_TAG_HELLCREEK
 	help
 	  This driver adds support for Hirschmann Hellcreek TSN switches.
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
index 2fe080010f8a..3e1040039a96 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -24,6 +24,7 @@
 #include <net/dsa.h>
 
 #include "hellcreek.h"
+#include "hellcreek_ptp.h"
 
 static const struct hellcreek_counter hellcreek_counter[] = {
 	{ 0x00, "RxFiltered", },
@@ -1053,6 +1054,43 @@ static void hellcreek_setup_tc_identity_mapping(struct hellcreek *hellcreek)
 	}
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
+	int ret;
+
+	mutex_lock(&hellcreek->reg_lock);
+	ret = __hellcreek_fdb_add(hellcreek, &ptp);
+	if (ret)
+		goto out;
+	ret = __hellcreek_fdb_add(hellcreek, &p2p);
+out:
+	mutex_unlock(&hellcreek->reg_lock);
+
+	return ret;
+}
+
 static int hellcreek_setup(struct dsa_switch *ds)
 {
 	struct hellcreek *hellcreek = ds->priv;
@@ -1098,6 +1136,14 @@ static int hellcreek_setup(struct dsa_switch *ds)
 	/* Allow VLAN configurations while not filtering */
 	ds->configure_vlan_while_not_filtering = true;
 
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
 
@@ -1192,6 +1238,7 @@ static int hellcreek_probe(struct platform_device *pdev)
 	}
 
 	mutex_init(&hellcreek->reg_lock);
+	mutex_init(&hellcreek->ptp_lock);
 
 	hellcreek->dev = dev;
 
@@ -1207,6 +1254,18 @@ static int hellcreek_probe(struct platform_device *pdev)
 		return PTR_ERR(hellcreek->base);
 	}
 
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ptp");
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
@@ -1237,15 +1296,27 @@ static int hellcreek_probe(struct platform_device *pdev)
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
index d57055aadc6f..0c95577b81ad 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -16,6 +16,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 #include <linux/mutex.h>
+#include <linux/workqueue.h>
 #include <linux/platform_data/hirschmann-hellcreek.h>
 #include <net/dsa.h>
 
@@ -245,10 +246,17 @@ struct hellcreek {
 	const struct hellcreek_platform_data *pdata;
 	struct device *dev;
 	struct dsa_switch *ds;
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_clock_info;
 	struct hellcreek_port *ports;
+	struct delayed_work overflow_work;
 	struct mutex reg_lock;	/* Switch IP register lock */
+	struct mutex ptp_lock;	/* PTP IP register lock */
 	void __iomem *base;
+	void __iomem *ptp_base;
 	u8 *vidmbrcfg;		/* vidmbrcfg shadow */
+	u64 seconds;		/* PTP seconds */
+	u64 last_ts;		/* Used for overflow detection */
 	size_t fdb_entries;
 };
 
diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
new file mode 100644
index 000000000000..856fcb9ba3c6
--- /dev/null
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
@@ -0,0 +1,283 @@
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
+static u64 hellcreek_ptp_clock_read(struct hellcreek *hellcreek)
+{
+	u16 nsl, nsh;
+
+	/* Take a snapshot */
+	hellcreek_ptp_write(hellcreek, PR_COMMAND_C_SS, PR_COMMAND_C);
+
+	/* The time of the day is saved as 96 bits. However, due to hardware
+	 * limitations the seconds are not or only partly kept in the PTP
+	 * core. Currently only three bits for the seconds are available. That's
+	 * why only the nanoseconds are used and the seconds are tracked in
+	 * software. Anyway due to internal locking all five registers should be
+	 * read.
+	 */
+	nsh = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
+	nsh = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
+	nsh = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
+	nsh = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
+	nsl = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
+
+	return (u64)nsl | ((u64)nsh << 16);
+}
+
+static u64 __hellcreek_ptp_gettime(struct hellcreek *hellcreek)
+{
+	u64 ns;
+
+	ns = hellcreek_ptp_clock_read(hellcreek);
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
+	mutex_lock(&hellcreek->ptp_lock);
+	ns = __hellcreek_ptp_gettime(hellcreek);
+	mutex_unlock(&hellcreek->ptp_lock);
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
+	mutex_lock(&hellcreek->ptp_lock);
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
+	mutex_unlock(&hellcreek->ptp_lock);
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
+	mutex_lock(&hellcreek->ptp_lock);
+
+	/* Set drift register */
+	hellcreek_ptp_write(hellcreek, negative, PR_CLOCK_DRIFT_C);
+	hellcreek_ptp_write(hellcreek, 0x00, PR_CLOCK_DRIFT_C);
+	hellcreek_ptp_write(hellcreek, 0x00, PR_CLOCK_DRIFT_C);
+	hellcreek_ptp_write(hellcreek, addendh,  PR_CLOCK_DRIFT_C);
+	hellcreek_ptp_write(hellcreek, addendl,  PR_CLOCK_DRIFT_C);
+
+	mutex_unlock(&hellcreek->ptp_lock);
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
+	 * consider slow adjustment. Rather, add the offset directly to the
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
+	mutex_lock(&hellcreek->ptp_lock);
+
+	/* Set offset write register */
+	hellcreek_ptp_write(hellcreek, negative, PR_CLOCK_OFFSET_C);
+	hellcreek_ptp_write(hellcreek, MAX_NS_PER_STEP, PR_CLOCK_OFFSET_C);
+	hellcreek_ptp_write(hellcreek, MIN_CLK_CYCLES_BETWEEN_STEPS,
+			    PR_CLOCK_OFFSET_C);
+	hellcreek_ptp_write(hellcreek, countl,  PR_CLOCK_OFFSET_C);
+	hellcreek_ptp_write(hellcreek, counth,  PR_CLOCK_OFFSET_C);
+
+	mutex_unlock(&hellcreek->ptp_lock);
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
+	struct hellcreek *hellcreek;
+
+	hellcreek = dw_overflow_to_hellcreek(dw);
+
+	mutex_lock(&hellcreek->ptp_lock);
+	__hellcreek_ptp_gettime(hellcreek);
+	mutex_unlock(&hellcreek->ptp_lock);
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
+	if (hellcreek->ptp_clock)
+		ptp_clock_unregister(hellcreek->ptp_clock);
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

