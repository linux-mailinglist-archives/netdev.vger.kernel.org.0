Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 369A918CBDF
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 11:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgCTKlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 06:41:05 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51680 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbgCTKlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 06:41:02 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C0E881A055D;
        Fri, 20 Mar 2020 11:41:00 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 34AAB1A051A;
        Fri, 20 Mar 2020 11:40:54 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 6778A402EE;
        Fri, 20 Mar 2020 18:40:46 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: [PATCH 1/6] ptp: move ocelot ptp clock code out of Ethernet driver
Date:   Fri, 20 Mar 2020 18:37:21 +0800
Message-Id: <20200320103726.32559-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320103726.32559-1-yangbo.lu@nxp.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ocelot PTP clock driver had been embedded into ocelot.c driver.
It had supported basic gettime64/settime64/adjtime/adjfine functions
by now which were used by both Ocelot switch and Felix switch.

This patch is to move current ptp clock code out of ocelot.c driver
maintaining as a single ptp_ocelot.c driver.
For futher new features implementation, the common code could be put
in ptp_ocelot.c driver and the switch specific code should be in
specific switch driver. The interrupt implementation in SoC is different
between Ocelot and Felix.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c                     |   3 +-
 drivers/net/ethernet/mscc/ocelot.c                 | 201 +------------------
 drivers/net/ethernet/mscc/ocelot.h                 |   3 +-
 drivers/net/ethernet/mscc/ocelot_board.c           |   1 +
 drivers/ptp/Kconfig                                |  10 +
 drivers/ptp/Makefile                               |   1 +
 drivers/ptp/ptp_ocelot.c                           | 217 +++++++++++++++++++++
 include/soc/mscc/ocelot.h                          |   1 -
 .../net/ethernet => include/soc}/mscc/ocelot_ptp.h |   1 +
 include/soc/mscc/ptp_ocelot.h                      |  34 ++++
 10 files changed, 271 insertions(+), 201 deletions(-)
 create mode 100644 drivers/ptp/ptp_ocelot.c
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_ptp.h (97%)
 create mode 100644 include/soc/mscc/ptp_ocelot.h

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6954638..9f9efb9 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -8,6 +8,7 @@
 #include <soc/mscc/ocelot_dev.h>
 #include <soc/mscc/ocelot_ana.h>
 #include <soc/mscc/ocelot.h>
+#include <soc/mscc/ptp_ocelot.h>
 #include <linux/packing.h>
 #include <linux/module.h>
 #include <linux/of_net.h>
@@ -576,7 +577,7 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 	struct ocelot *ocelot = ds->priv;
 	u8 *extraction = skb->data - ETH_HLEN - OCELOT_TAG_LEN;
 	u32 tstamp_lo, tstamp_hi;
-	struct timespec64 ts;
+	struct timespec64 ts = {0, 0};
 	u64 tstamp, val;
 
 	ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index dc0e273..b342bbd 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -21,6 +21,7 @@
 #include <net/netevent.h>
 #include <net/rtnetlink.h>
 #include <net/switchdev.h>
+#include <soc/mscc/ptp_ocelot.h>
 
 #include "ocelot.h"
 #include "ocelot_ace.h"
@@ -1989,200 +1990,6 @@ struct notifier_block ocelot_switchdev_blocking_nb __read_mostly = {
 };
 EXPORT_SYMBOL(ocelot_switchdev_blocking_nb);
 
-int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts)
-{
-	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
-	unsigned long flags;
-	time64_t s;
-	u32 val;
-	s64 ns;
-
-	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
-
-	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
-	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
-	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_SAVE);
-	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
-
-	s = ocelot_read_rix(ocelot, PTP_PIN_TOD_SEC_MSB, TOD_ACC_PIN) & 0xffff;
-	s <<= 32;
-	s += ocelot_read_rix(ocelot, PTP_PIN_TOD_SEC_LSB, TOD_ACC_PIN);
-	ns = ocelot_read_rix(ocelot, PTP_PIN_TOD_NSEC, TOD_ACC_PIN);
-
-	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
-
-	/* Deal with negative values */
-	if (ns >= 0x3ffffff0 && ns <= 0x3fffffff) {
-		s--;
-		ns &= 0xf;
-		ns += 999999984;
-	}
-
-	set_normalized_timespec64(ts, s, ns);
-	return 0;
-}
-EXPORT_SYMBOL(ocelot_ptp_gettime64);
-
-static int ocelot_ptp_settime64(struct ptp_clock_info *ptp,
-				const struct timespec64 *ts)
-{
-	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
-	unsigned long flags;
-	u32 val;
-
-	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
-
-	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
-	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
-	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_IDLE);
-
-	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
-
-	ocelot_write_rix(ocelot, lower_32_bits(ts->tv_sec), PTP_PIN_TOD_SEC_LSB,
-			 TOD_ACC_PIN);
-	ocelot_write_rix(ocelot, upper_32_bits(ts->tv_sec), PTP_PIN_TOD_SEC_MSB,
-			 TOD_ACC_PIN);
-	ocelot_write_rix(ocelot, ts->tv_nsec, PTP_PIN_TOD_NSEC, TOD_ACC_PIN);
-
-	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
-	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
-	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_LOAD);
-
-	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
-
-	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
-	return 0;
-}
-
-static int ocelot_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
-{
-	if (delta > -(NSEC_PER_SEC / 2) && delta < (NSEC_PER_SEC / 2)) {
-		struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
-		unsigned long flags;
-		u32 val;
-
-		spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
-
-		val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
-		val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
-		val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_IDLE);
-
-		ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
-
-		ocelot_write_rix(ocelot, 0, PTP_PIN_TOD_SEC_LSB, TOD_ACC_PIN);
-		ocelot_write_rix(ocelot, 0, PTP_PIN_TOD_SEC_MSB, TOD_ACC_PIN);
-		ocelot_write_rix(ocelot, delta, PTP_PIN_TOD_NSEC, TOD_ACC_PIN);
-
-		val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
-		val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
-		val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_DELTA);
-
-		ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
-
-		spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
-	} else {
-		/* Fall back using ocelot_ptp_settime64 which is not exact. */
-		struct timespec64 ts;
-		u64 now;
-
-		ocelot_ptp_gettime64(ptp, &ts);
-
-		now = ktime_to_ns(timespec64_to_ktime(ts));
-		ts = ns_to_timespec64(now + delta);
-
-		ocelot_ptp_settime64(ptp, &ts);
-	}
-	return 0;
-}
-
-static int ocelot_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
-{
-	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
-	u32 unit = 0, direction = 0;
-	unsigned long flags;
-	u64 adj = 0;
-
-	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
-
-	if (!scaled_ppm)
-		goto disable_adj;
-
-	if (scaled_ppm < 0) {
-		direction = PTP_CFG_CLK_ADJ_CFG_DIR;
-		scaled_ppm = -scaled_ppm;
-	}
-
-	adj = PSEC_PER_SEC << 16;
-	do_div(adj, scaled_ppm);
-	do_div(adj, 1000);
-
-	/* If the adjustment value is too large, use ns instead */
-	if (adj >= (1L << 30)) {
-		unit = PTP_CFG_CLK_ADJ_FREQ_NS;
-		do_div(adj, 1000);
-	}
-
-	/* Still too big */
-	if (adj >= (1L << 30))
-		goto disable_adj;
-
-	ocelot_write(ocelot, unit | adj, PTP_CLK_CFG_ADJ_FREQ);
-	ocelot_write(ocelot, PTP_CFG_CLK_ADJ_CFG_ENA | direction,
-		     PTP_CLK_CFG_ADJ_CFG);
-
-	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
-	return 0;
-
-disable_adj:
-	ocelot_write(ocelot, 0, PTP_CLK_CFG_ADJ_CFG);
-
-	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
-	return 0;
-}
-
-static struct ptp_clock_info ocelot_ptp_clock_info = {
-	.owner		= THIS_MODULE,
-	.name		= "ocelot ptp",
-	.max_adj	= 0x7fffffff,
-	.n_alarm	= 0,
-	.n_ext_ts	= 0,
-	.n_per_out	= 0,
-	.n_pins		= 0,
-	.pps		= 0,
-	.gettime64	= ocelot_ptp_gettime64,
-	.settime64	= ocelot_ptp_settime64,
-	.adjtime	= ocelot_ptp_adjtime,
-	.adjfine	= ocelot_ptp_adjfine,
-};
-
-static int ocelot_init_timestamp(struct ocelot *ocelot)
-{
-	struct ptp_clock *ptp_clock;
-
-	ocelot->ptp_info = ocelot_ptp_clock_info;
-	ptp_clock = ptp_clock_register(&ocelot->ptp_info, ocelot->dev);
-	if (IS_ERR(ptp_clock))
-		return PTR_ERR(ptp_clock);
-	/* Check if PHC support is missing at the configuration level */
-	if (!ptp_clock)
-		return 0;
-
-	ocelot->ptp_clock = ptp_clock;
-
-	ocelot_write(ocelot, SYS_PTP_CFG_PTP_STAMP_WID(30), SYS_PTP_CFG);
-	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_LOW);
-	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_HIGH);
-
-	ocelot_write(ocelot, PTP_CFG_MISC_PTP_EN, PTP_CFG_MISC);
-
-	/* There is no device reconfiguration, PTP Rx stamping is always
-	 * enabled.
-	 */
-	ocelot->hwtstamp_config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
-
-	return 0;
-}
-
 /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
  * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
  */
@@ -2507,7 +2314,8 @@ int ocelot_init(struct ocelot *ocelot)
 		ret = ocelot_init_timestamp(ocelot);
 		if (ret) {
 			dev_err(ocelot->dev,
-				"Timestamp initialization failed\n");
+				"Timestamp not enabled or initialization failed\n");
+			ocelot->ptp = 0;
 			return ret;
 		}
 	}
@@ -2524,8 +2332,7 @@ void ocelot_deinit(struct ocelot *ocelot)
 	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
 	mutex_destroy(&ocelot->stats_lock);
-	if (ocelot->ptp_clock)
-		ptp_clock_unregister(ocelot->ptp_clock);
+	ocelot_deinit_timestamp(ocelot);
 
 	for (i = 0; i < ocelot->num_phys_ports; i++) {
 		port = ocelot->ports[i];
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e34ef83..5aa2e45 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -15,18 +15,17 @@
 #include <linux/phy.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
-#include <linux/ptp_clock_kernel.h>
 #include <linux/regmap.h>
 
 #include <soc/mscc/ocelot_qsys.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot_dev.h>
 #include <soc/mscc/ocelot_ana.h>
+#include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot.h>
 #include "ocelot_rew.h"
 #include "ocelot_qs.h"
 #include "ocelot_tc.h"
-#include "ocelot_ptp.h"
 
 #define OCELOT_BUFFER_CELL_SZ 60
 
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 0ac9fbf7..7e59cee 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -14,6 +14,7 @@
 #include <linux/skbuff.h>
 #include <net/switchdev.h>
 
+#include <soc/mscc/ptp_ocelot.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
 
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 86400c7..ac08e9c 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -151,4 +151,14 @@ config PTP_1588_CLOCK_VMW
 	  To compile this driver as a module, choose M here: the module
 	  will be called ptp_vmw.
 
+config PTP_1588_CLOCK_OCELOT
+	bool "Microsemi Ocelot as PTP clock"
+	depends on MSCC_OCELOT_SWITCH || COMPILE_TEST
+	depends on PTP_1588_CLOCK
+	default y
+	help
+	  This driver adds support for using Microsemi Ocelot as a PTP
+	  clock. This clock is only useful if your PTP programs are
+	  getting hardware time stamps on the PTP Ethernet packets using
+	  the SO_TIMESTAMPING API.
 endmenu
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 7aff75f..a0229b3 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -15,3 +15,4 @@ ptp-qoriq-$(CONFIG_DEBUG_FS)		+= ptp_qoriq_debugfs.o
 obj-$(CONFIG_PTP_1588_CLOCK_IDTCM)	+= ptp_clockmatrix.o
 obj-$(CONFIG_PTP_1588_CLOCK_IDT82P33)	+= ptp_idt82p33.o
 obj-$(CONFIG_PTP_1588_CLOCK_VMW)	+= ptp_vmw.o
+obj-$(CONFIG_PTP_1588_CLOCK_OCELOT)	+= ptp_ocelot.o
diff --git a/drivers/ptp/ptp_ocelot.c b/drivers/ptp/ptp_ocelot.c
new file mode 100644
index 0000000..59420a7
--- /dev/null
+++ b/drivers/ptp/ptp_ocelot.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Microsemi Ocelot PTP clock driver
+ *
+ * Copyright (c) 2017 Microsemi Corporation
+ * Copyright 2020 NXP
+ */
+#include <soc/mscc/ocelot_ptp.h>
+#include <soc/mscc/ocelot_sys.h>
+#include <soc/mscc/ocelot.h>
+#include <soc/mscc/ptp_ocelot.h>
+
+int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts)
+{
+	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
+	unsigned long flags;
+	time64_t s;
+	u32 val;
+	s64 ns;
+
+	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+
+	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
+	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
+	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_SAVE);
+	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
+
+	s = ocelot_read_rix(ocelot, PTP_PIN_TOD_SEC_MSB, TOD_ACC_PIN) & 0xffff;
+	s <<= 32;
+	s += ocelot_read_rix(ocelot, PTP_PIN_TOD_SEC_LSB, TOD_ACC_PIN);
+	ns = ocelot_read_rix(ocelot, PTP_PIN_TOD_NSEC, TOD_ACC_PIN);
+
+	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+
+	/* Deal with negative values */
+	if (ns >= 0x3ffffff0 && ns <= 0x3fffffff) {
+		s--;
+		ns &= 0xf;
+		ns += 999999984;
+	}
+
+	set_normalized_timespec64(ts, s, ns);
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_ptp_gettime64);
+
+static int ocelot_ptp_settime64(struct ptp_clock_info *ptp,
+				const struct timespec64 *ts)
+{
+	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+
+	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
+	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
+	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_IDLE);
+
+	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
+
+	ocelot_write_rix(ocelot, lower_32_bits(ts->tv_sec), PTP_PIN_TOD_SEC_LSB,
+			 TOD_ACC_PIN);
+	ocelot_write_rix(ocelot, upper_32_bits(ts->tv_sec), PTP_PIN_TOD_SEC_MSB,
+			 TOD_ACC_PIN);
+	ocelot_write_rix(ocelot, ts->tv_nsec, PTP_PIN_TOD_NSEC, TOD_ACC_PIN);
+
+	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
+	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
+	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_LOAD);
+
+	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
+
+	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+	return 0;
+}
+
+static int ocelot_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	if (delta > -(NSEC_PER_SEC / 2) && delta < (NSEC_PER_SEC / 2)) {
+		struct ocelot *ocelot = container_of(ptp, struct ocelot,
+						     ptp_info);
+		unsigned long flags;
+		u32 val;
+
+		spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+
+		val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
+		val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK |
+			 PTP_PIN_CFG_DOM);
+		val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_IDLE);
+
+		ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
+
+		ocelot_write_rix(ocelot, 0, PTP_PIN_TOD_SEC_LSB, TOD_ACC_PIN);
+		ocelot_write_rix(ocelot, 0, PTP_PIN_TOD_SEC_MSB, TOD_ACC_PIN);
+		ocelot_write_rix(ocelot, delta, PTP_PIN_TOD_NSEC, TOD_ACC_PIN);
+
+		val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
+		val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK |
+			 PTP_PIN_CFG_DOM);
+		val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_DELTA);
+
+		ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
+
+		spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+	} else {
+		/* Fall back using ocelot_ptp_settime64 which is not exact. */
+		struct timespec64 ts;
+		u64 now;
+
+		ocelot_ptp_gettime64(ptp, &ts);
+
+		now = ktime_to_ns(timespec64_to_ktime(ts));
+		ts = ns_to_timespec64(now + delta);
+
+		ocelot_ptp_settime64(ptp, &ts);
+	}
+	return 0;
+}
+
+static int ocelot_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
+	u32 unit = 0, direction = 0;
+	unsigned long flags;
+	u64 adj = 0;
+
+	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+
+	if (!scaled_ppm)
+		goto disable_adj;
+
+	if (scaled_ppm < 0) {
+		direction = PTP_CFG_CLK_ADJ_CFG_DIR;
+		scaled_ppm = -scaled_ppm;
+	}
+
+	adj = PSEC_PER_SEC << 16;
+	do_div(adj, scaled_ppm);
+	do_div(adj, 1000);
+
+	/* If the adjustment value is too large, use ns instead */
+	if (adj >= (1L << 30)) {
+		unit = PTP_CFG_CLK_ADJ_FREQ_NS;
+		do_div(adj, 1000);
+	}
+
+	/* Still too big */
+	if (adj >= (1L << 30))
+		goto disable_adj;
+
+	ocelot_write(ocelot, unit | adj, PTP_CLK_CFG_ADJ_FREQ);
+	ocelot_write(ocelot, PTP_CFG_CLK_ADJ_CFG_ENA | direction,
+		     PTP_CLK_CFG_ADJ_CFG);
+
+	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+	return 0;
+
+disable_adj:
+	ocelot_write(ocelot, 0, PTP_CLK_CFG_ADJ_CFG);
+
+	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+	return 0;
+}
+
+static struct ptp_clock_info ocelot_ptp_clock_info = {
+	.owner		= THIS_MODULE,
+	.name		= "ocelot ptp",
+	.max_adj	= 0x7fffffff,
+	.n_alarm	= 0,
+	.n_ext_ts	= 0,
+	.n_per_out	= 0,
+	.n_pins		= 0,
+	.pps		= 0,
+	.gettime64	= ocelot_ptp_gettime64,
+	.settime64	= ocelot_ptp_settime64,
+	.adjtime	= ocelot_ptp_adjtime,
+	.adjfine	= ocelot_ptp_adjfine,
+};
+
+int ocelot_init_timestamp(struct ocelot *ocelot)
+{
+	struct ptp_clock *ptp_clock;
+
+	ocelot->ptp_info = ocelot_ptp_clock_info;
+	ptp_clock = ptp_clock_register(&ocelot->ptp_info, ocelot->dev);
+	if (IS_ERR(ptp_clock))
+		return PTR_ERR(ptp_clock);
+	/* Check if PHC support is missing at the configuration level */
+	if (!ptp_clock)
+		return 0;
+
+	ocelot->ptp_clock = ptp_clock;
+
+	ocelot_write(ocelot, SYS_PTP_CFG_PTP_STAMP_WID(30), SYS_PTP_CFG);
+	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_LOW);
+	ocelot_write(ocelot, 0xffffffff, ANA_TABLES_PTP_ID_HIGH);
+
+	ocelot_write(ocelot, PTP_CFG_MISC_PTP_EN, PTP_CFG_MISC);
+
+	/* There is no device reconfiguration, PTP Rx stamping is always
+	 * enabled.
+	 */
+	ocelot->hwtstamp_config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_init_timestamp);
+
+int ocelot_deinit_timestamp(struct ocelot *ocelot)
+{
+	if (ocelot->ptp_clock)
+		ptp_clock_unregister(ocelot->ptp_clock);
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_deinit_timestamp);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 007b584..d9bad70 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -607,7 +607,6 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
 int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr);
 int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr);
-int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
 int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
 				 struct sk_buff *skb);
 void ocelot_get_txtstamp(struct ocelot *ocelot);
diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
similarity index 97%
rename from drivers/net/ethernet/mscc/ocelot_ptp.h
rename to include/soc/mscc/ocelot_ptp.h
index 9ede14a..2dd27f0 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.h
+++ b/include/soc/mscc/ocelot_ptp.h
@@ -4,6 +4,7 @@
  *
  * License: Dual MIT/GPL
  * Copyright (c) 2017 Microsemi Corporation
+ * Copyright 2020 NXP
  */
 
 #ifndef _MSCC_OCELOT_PTP_H_
diff --git a/include/soc/mscc/ptp_ocelot.h b/include/soc/mscc/ptp_ocelot.h
new file mode 100644
index 0000000..b8d9c5b
--- /dev/null
+++ b/include/soc/mscc/ptp_ocelot.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Microsemi Ocelot PTP clock driver
+ *
+ * License: Dual MIT/GPL
+ * Copyright 2020 NXP
+ */
+
+#ifndef _PTP_OCELOT_H_
+#define _PTP_OCELOT_H_
+
+#include <soc/mscc/ocelot.h>
+#include <linux/ptp_clock_kernel.h>
+
+#ifdef CONFIG_PTP_1588_CLOCK_OCELOT
+int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
+int ocelot_init_timestamp(struct ocelot *ocelot);
+int ocelot_deinit_timestamp(struct ocelot *ocelot);
+#else
+static inline int ocelot_ptp_gettime64(struct ptp_clock_info *ptp,
+				       struct timespec64 *ts)
+{
+	return -EOPNOTSUPP;
+}
+static inline int ocelot_init_timestamp(struct ocelot *ocelot)
+{
+	return -EOPNOTSUPP;
+}
+static inline int ocelot_deinit_timestamp(struct ocelot *ocelot)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+#endif
-- 
2.7.4

