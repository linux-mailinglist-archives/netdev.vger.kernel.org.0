Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A941AFFFA
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgDTCv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:51:26 -0400
Received: from inva020.nxp.com ([92.121.34.13]:55756 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgDTCvV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:51:21 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 40D2A1A0645;
        Mon, 20 Apr 2020 04:51:14 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4715E1A0616;
        Mon, 20 Apr 2020 04:51:08 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 14783402BF;
        Mon, 20 Apr 2020 10:51:01 +0800 (SGT)
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
Subject: [v3, 1/7] net: mscc: ocelot: move ocelot ptp clock code out of ocelot.c
Date:   Mon, 20 Apr 2020 10:46:45 +0800
Message-Id: <20200420024651.47353-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420024651.47353-1-yangbo.lu@nxp.com>
References: <20200420024651.47353-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ocelot PTP clock driver had been embedded into ocelot.c driver.
It had supported basic gettime64/settime64/adjtime/adjfine functions
by now which were used by both Ocelot switch and Felix switch.

This patch is to move current ptp clock code out of ocelot.c driver
maintaining as a single ocelot_ptp.c.
For futher new features implementation, the common code could be put
in ocelot_ptp.c and the switch specific code should be in specific
switch driver. The interrupt implementation in SoC is different
between Ocelot and Felix.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Put PTP driver under drivers/net/ethernet/mscc/.
	- Initialized PTP separately in ocelot/felix platforms.
Changes for v3:
	- None.
---
 drivers/net/dsa/ocelot/felix.c                     |  25 +++
 drivers/net/ethernet/mscc/Makefile                 |   2 +-
 drivers/net/ethernet/mscc/ocelot.c                 | 206 ---------------------
 drivers/net/ethernet/mscc/ocelot.h                 |   3 +-
 drivers/net/ethernet/mscc/ocelot_board.c           |  25 +++
 drivers/net/ethernet/mscc/ocelot_ptp.c             | 203 ++++++++++++++++++++
 include/soc/mscc/ocelot.h                          |   1 -
 .../net/ethernet => include/soc}/mscc/ocelot_ptp.h |  11 ++
 8 files changed, 266 insertions(+), 210 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_ptp.c
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_ptp.h (64%)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 79ca3aa..e1573bc 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -7,6 +7,7 @@
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot_dev.h>
 #include <soc/mscc/ocelot_ana.h>
+#include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot.h>
 #include <linux/packing.h>
 #include <linux/module.h>
@@ -497,6 +498,21 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	return 0;
 }
 
+static struct ptp_clock_info ocelot_ptp_clock_info = {
+	.owner		= THIS_MODULE,
+	.name		= "felix ptp",
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
 /* Hardware initialization done here so that we can allocate structures with
  * devm without fear of dsa_register_switch returning -EPROBE_DEFER and causing
  * us to allocate structures twice (leak memory) and map PCI memory twice
@@ -513,6 +529,14 @@ static int felix_setup(struct dsa_switch *ds)
 		return err;
 
 	ocelot_init(ocelot);
+	if (ocelot->ptp) {
+		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
+		if (err) {
+			dev_err(ocelot->dev,
+				"Timestamp initialization failed\n");
+			ocelot->ptp = 0;
+		}
+	}
 
 	for (port = 0; port < ds->num_ports; port++) {
 		ocelot_init_port(ocelot, port);
@@ -551,6 +575,7 @@ static void felix_teardown(struct dsa_switch *ds)
 	if (felix->info->mdio_bus_free)
 		felix->info->mdio_bus_free(ocelot);
 
+	ocelot_deinit_timestamp(ocelot);
 	/* stop workqueue thread */
 	ocelot_deinit(ocelot);
 }
diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 9a36c26..91b33b5 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: (GPL-2.0 OR MIT)
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot_common.o
 mscc_ocelot_common-y := ocelot.o ocelot_io.o
-mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o ocelot_ace.o ocelot_flower.o
+mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o ocelot_ace.o ocelot_flower.o ocelot_ptp.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += ocelot_board.o
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b4731df..6cfd6dc 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/phy.h>
-#include <linux/ptp_clock_kernel.h>
 #include <linux/skbuff.h>
 #include <linux/iopoll.h>
 #include <net/arp.h>
@@ -1989,200 +1988,6 @@ struct notifier_block ocelot_switchdev_blocking_nb __read_mostly = {
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
  * In the special case that it's the NPI port that we're configuring, the
@@ -2528,15 +2333,6 @@ int ocelot_init(struct ocelot *ocelot)
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
 
-	if (ocelot->ptp) {
-		ret = ocelot_init_timestamp(ocelot);
-		if (ret) {
-			dev_err(ocelot->dev,
-				"Timestamp initialization failed\n");
-			return ret;
-		}
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL(ocelot_init);
@@ -2549,8 +2345,6 @@ void ocelot_deinit(struct ocelot *ocelot)
 	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
 	mutex_destroy(&ocelot->stats_lock);
-	if (ocelot->ptp_clock)
-		ptp_clock_unregister(ocelot->ptp_clock);
 
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
index 0ac9fbf7..ee016f7 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -366,6 +366,21 @@ static const struct vcap_props vsc7514_vcap_props[] = {
 	},
 };
 
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
 static int mscc_ocelot_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -469,6 +484,15 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ocelot->vcap = vsc7514_vcap_props;
 
 	ocelot_init(ocelot);
+	if (ocelot->ptp) {
+		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
+		if (err) {
+			dev_err(ocelot->dev,
+				"Timestamp initialization failed\n");
+			ocelot->ptp = 0;
+		}
+	}
+
 	/* No NPI port */
 	ocelot_configure_cpu(ocelot, -1, OCELOT_TAG_PREFIX_NONE,
 			     OCELOT_TAG_PREFIX_NONE);
@@ -574,6 +598,7 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 {
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
 
+	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
 	unregister_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
 	unregister_switchdev_notifier(&ocelot_switchdev_nb);
diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
new file mode 100644
index 0000000..69d4e56
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Microsemi Ocelot PTP clock driver
+ *
+ * Copyright (c) 2017 Microsemi Corporation
+ * Copyright 2020 NXP
+ */
+#include <soc/mscc/ocelot_ptp.h>
+#include <soc/mscc/ocelot_sys.h>
+#include <soc/mscc/ocelot.h>
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
+int ocelot_ptp_settime64(struct ptp_clock_info *ptp,
+			 const struct timespec64 *ts)
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
+EXPORT_SYMBOL(ocelot_ptp_settime64);
+
+int ocelot_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
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
+EXPORT_SYMBOL(ocelot_ptp_adjtime);
+
+int ocelot_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
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
+EXPORT_SYMBOL(ocelot_ptp_adjfine);
+
+int ocelot_init_timestamp(struct ocelot *ocelot, struct ptp_clock_info *info)
+{
+	struct ptp_clock *ptp_clock;
+
+	ocelot->ptp_info = *info;
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
index ebffcb3..fe301794 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -618,7 +618,6 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
 int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr);
 int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr);
-int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
 int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
 				 struct sk_buff *skb);
 void ocelot_get_txtstamp(struct ocelot *ocelot);
diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
similarity index 64%
rename from drivers/net/ethernet/mscc/ocelot_ptp.h
rename to include/soc/mscc/ocelot_ptp.h
index 9ede14a..f01b0ce 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.h
+++ b/include/soc/mscc/ocelot_ptp.h
@@ -4,11 +4,15 @@
  *
  * License: Dual MIT/GPL
  * Copyright (c) 2017 Microsemi Corporation
+ * Copyright 2020 NXP
  */
 
 #ifndef _MSCC_OCELOT_PTP_H_
 #define _MSCC_OCELOT_PTP_H_
 
+#include <linux/ptp_clock_kernel.h>
+#include <soc/mscc/ocelot.h>
+
 #define PTP_PIN_CFG_RSZ			0x20
 #define PTP_PIN_TOD_SEC_MSB_RSZ		PTP_PIN_CFG_RSZ
 #define PTP_PIN_TOD_SEC_LSB_RSZ		PTP_PIN_CFG_RSZ
@@ -38,4 +42,11 @@ enum {
 
 #define PTP_CFG_CLK_ADJ_FREQ_NS		BIT(30)
 
+int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
+int ocelot_ptp_settime64(struct ptp_clock_info *ptp,
+			 const struct timespec64 *ts);
+int ocelot_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta);
+int ocelot_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm);
+int ocelot_init_timestamp(struct ocelot *ocelot, struct ptp_clock_info *info);
+int ocelot_deinit_timestamp(struct ocelot *ocelot);
 #endif
-- 
2.7.4

