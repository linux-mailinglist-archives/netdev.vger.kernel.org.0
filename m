Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6B644AAEE
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 10:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245137AbhKIJxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 04:53:54 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34996 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243025AbhKIJxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 04:53:45 -0500
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636451458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QAt7uB7Rq1Gug4mydJ8aonujRo/omdVnLFrGhsNrjT0=;
        b=XsIX2I/53lE8DozkbLMYoS29Zotdh0WH6GHkaY4hqdS+VUGeI8SKoKPRKCqxUJRLCi1wu+
        o5B11JzGvbUocxbw3rXvQecgua3BwkUFJqCbrKefmJK3itNzy60c7T6Cri+6ez5E32xRvv
        plZ23KGKWimF8BeJERyp+Fj65mrtsI1h8Lyk7UNwJvq77X77MiKGXT695mEd9KGBxIsgx9
        Ooebo3eSuOUgb/WJAZSDRx7Nl3bIOkIa3XvZ5cZkyDvQZNEFYYRkjHf3LjKSoQxYtJP4De
        lk4o4D4S7CErwAtXLorOekl1RZL4j7ILa+IShvZmb4P20Pk1hcDFMxP5jaJ5ZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636451458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QAt7uB7Rq1Gug4mydJ8aonujRo/omdVnLFrGhsNrjT0=;
        b=g85ekpsr+HvhAZUkYM07LId2YQ3T8W9NVQkWlZWWgBuKqUplMtqMpOIe7TxfVkg4CwfRMa
        BSs68dk+rP3OGlCQ==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     martin.kaistra@linutronix.de,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 4/7] net: dsa: b53: Add PHC clock support
Date:   Tue,  9 Nov 2021 10:50:06 +0100
Message-Id: <20211109095013.27829-5-martin.kaistra@linutronix.de>
In-Reply-To: <20211109095013.27829-1-martin.kaistra@linutronix.de>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BCM53128 switch has an internal clock, which can be used for
timestamping. Add support for it.

The 32-bit free running clock counts nanoseconds. In order to account
for the wrap-around at 999999999 (0x3B9AC9FF) while using the cycle
counter infrastructure, we need to set a 30bit mask and use the
overflow_point property.

Enable the Broadsync HD timestamping feature in b53_ptp_init() for PTPv2
Ethertype (0x88f7).

Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
---
 drivers/net/dsa/b53/Kconfig      |   8 ++
 drivers/net/dsa/b53/Makefile     |   4 +
 drivers/net/dsa/b53/b53_common.c |  17 +++
 drivers/net/dsa/b53/b53_ptp.c    | 196 +++++++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_ptp.h    |  35 ++++++
 include/linux/dsa/b53.h          |  14 +++
 6 files changed, 274 insertions(+)
 create mode 100644 drivers/net/dsa/b53/b53_ptp.c
 create mode 100644 drivers/net/dsa/b53/b53_ptp.h

diff --git a/drivers/net/dsa/b53/Kconfig b/drivers/net/dsa/b53/Kconfig
index 90b525160b71..71009c93db13 100644
--- a/drivers/net/dsa/b53/Kconfig
+++ b/drivers/net/dsa/b53/Kconfig
@@ -45,3 +45,11 @@ config B53_SERDES
 	default ARCH_BCM_NSP
 	help
 	  Select to enable support for SerDes on e.g: Northstar Plus SoCs.
+
+config B53_PTP
+	bool "B53 PTP support"
+	depends on B53
+	depends on PTP_1588_CLOCK
+	default n
+	help
+	  Select to enable support for PTP
diff --git a/drivers/net/dsa/b53/Makefile b/drivers/net/dsa/b53/Makefile
index b1be13023ae4..07c9ac1ce9e8 100644
--- a/drivers/net/dsa/b53/Makefile
+++ b/drivers/net/dsa/b53/Makefile
@@ -6,3 +6,7 @@ obj-$(CONFIG_B53_MDIO_DRIVER)	+= b53_mdio.o
 obj-$(CONFIG_B53_MMAP_DRIVER)	+= b53_mmap.o
 obj-$(CONFIG_B53_SRAB_DRIVER)	+= b53_srab.o
 obj-$(CONFIG_B53_SERDES)	+= b53_serdes.o
+
+ifdef CONFIG_B53_PTP
+obj-$(CONFIG_B53)		+= b53_ptp.o
+endif
diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index af4761968733..ed590efbd3bf 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -31,6 +31,7 @@
 
 #include "b53_regs.h"
 #include "b53_priv.h"
+#include "b53_ptp.h"
 
 struct b53_mib_desc {
 	u8 size;
@@ -1131,12 +1132,24 @@ static int b53_setup(struct dsa_switch *ds)
 			b53_disable_port(ds, port);
 	}
 
+	if (dev->broadsync_hd) {
+		ret = b53_ptp_init(dev);
+		if (ret) {
+			dev_err(ds->dev, "failed to initialize PTP\n");
+			return ret;
+		}
+	}
+
 	return b53_setup_devlink_resources(ds);
 }
 
 static void b53_teardown(struct dsa_switch *ds)
 {
+	struct b53_device *dev = ds->priv;
+
 	dsa_devlink_resources_unregister(ds);
+	if (dev->broadsync_hd)
+		b53_ptp_exit(ds->priv);
 }
 
 static void b53_force_link(struct b53_device *dev, int port, int link)
@@ -2286,6 +2299,7 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_mdb_del		= b53_mdb_del,
 	.port_max_mtu		= b53_get_max_mtu,
 	.port_change_mtu	= b53_change_mtu,
+	.get_ts_info		= b53_get_ts_info,
 };
 
 struct b53_chip_data {
@@ -2301,6 +2315,7 @@ struct b53_chip_data {
 	u8 duplex_reg;
 	u8 jumbo_pm_reg;
 	u8 jumbo_size_reg;
+	bool broadsync_hd;
 };
 
 #define B53_VTA_REGS	\
@@ -2421,6 +2436,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.broadsync_hd = true,
 	},
 	{
 		.chip_id = BCM63XX_DEVICE_ID,
@@ -2589,6 +2605,7 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->num_vlans = chip->vlans;
 			dev->num_arl_bins = chip->arl_bins;
 			dev->num_arl_buckets = chip->arl_buckets;
+			dev->broadsync_hd = chip->broadsync_hd;
 			break;
 		}
 	}
diff --git a/drivers/net/dsa/b53/b53_ptp.c b/drivers/net/dsa/b53/b53_ptp.c
new file mode 100644
index 000000000000..8629c510b1a0
--- /dev/null
+++ b/drivers/net/dsa/b53/b53_ptp.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: ISC
+/*
+ * B53 switch PTP support
+ *
+ * Author: Martin Kaistra <martin.kaistra@linutronix.de>
+ * Copyright (C) 2021 Linutronix GmbH
+ */
+
+#include "b53_priv.h"
+#include "b53_ptp.h"
+
+static int b53_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
+{
+	struct b53_device *dev =
+		container_of(ptp, struct b53_device, ptp_clock_info);
+	u64 ns;
+
+	mutex_lock(&dev->ptp_mutex);
+	ns = timecounter_read(&dev->tc);
+	mutex_unlock(&dev->ptp_mutex);
+
+	*ts = ns_to_timespec64(ns);
+
+	return 0;
+}
+
+static int b53_ptp_settime(struct ptp_clock_info *ptp,
+			   const struct timespec64 *ts)
+{
+	struct b53_device *dev =
+		container_of(ptp, struct b53_device, ptp_clock_info);
+	u64 ns;
+
+	ns = timespec64_to_ns(ts);
+
+	mutex_lock(&dev->ptp_mutex);
+	timecounter_init(&dev->tc, &dev->cc, ns);
+	mutex_unlock(&dev->ptp_mutex);
+
+	return 0;
+}
+
+static int b53_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct b53_device *dev =
+		container_of(ptp, struct b53_device, ptp_clock_info);
+	u64 adj, diff;
+	u32 mult;
+	bool neg_adj = false;
+
+	if (scaled_ppm < 0) {
+		neg_adj = true;
+		scaled_ppm = -scaled_ppm;
+	}
+
+	mult = (1 << 28);
+	adj = 64;
+	adj *= (u64)scaled_ppm;
+	diff = div_u64(adj, 15625ULL);
+
+	mutex_lock(&dev->ptp_mutex);
+	timecounter_read(&dev->tc);
+	dev->cc.mult = neg_adj ? mult - diff : mult + diff;
+	mutex_unlock(&dev->ptp_mutex);
+
+	return 0;
+}
+
+static int b53_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct b53_device *dev =
+		container_of(ptp, struct b53_device, ptp_clock_info);
+
+	mutex_lock(&dev->ptp_mutex);
+	timecounter_adjtime(&dev->tc, delta);
+	mutex_unlock(&dev->ptp_mutex);
+
+	return 0;
+}
+
+static u64 b53_ptp_read(const struct cyclecounter *cc)
+{
+	struct b53_device *dev = container_of(cc, struct b53_device, cc);
+	u32 ts;
+
+	b53_read32(dev, B53_BROADSYNC_PAGE, B53_BROADSYNC_TIMEBASE, &ts);
+
+	return ts;
+}
+
+static int b53_ptp_enable(struct ptp_clock_info *ptp,
+			  struct ptp_clock_request *rq, int on)
+{
+	return -EOPNOTSUPP;
+}
+
+static long b53_hwtstamp_work(struct ptp_clock_info *ptp)
+{
+	struct b53_device *dev =
+		container_of(ptp, struct b53_device, ptp_clock_info);
+
+	mutex_lock(&dev->ptp_mutex);
+	timecounter_read(&dev->tc);
+	mutex_unlock(&dev->ptp_mutex);
+
+	return B53_PTP_OVERFLOW_PERIOD;
+}
+
+int b53_ptp_init(struct b53_device *dev)
+{
+	mutex_init(&dev->ptp_mutex);
+
+	/* Enable BroadSync HD for all ports */
+	b53_write16(dev, B53_BROADSYNC_PAGE, B53_BROADSYNC_EN_CTRL,
+		    dev->enabled_ports);
+
+	/* Enable BroadSync HD Time Stamping Reporting (Egress) */
+	b53_write8(dev, B53_BROADSYNC_PAGE, B53_BROADSYNC_TS_REPORT_CTRL,
+		   TSRPT_PKT_EN);
+
+	/* Enable BroadSync HD Time Stamping for PTPv2 ingress */
+
+	/* MPORT_CTRL0 | MPORT0_TS_EN */
+	b53_write16(dev, B53_ARLCTRL_PAGE, B53_MPORT_CTRL,
+		    MPORT0_TS_EN |
+			    (MPORT_CTRL_CMP_ETYPE << MPORT_CTRL_SHIFT(0)));
+	/* Forward to IMP port */
+	b53_write32(dev, B53_ARLCTRL_PAGE, B53_MPORT_VCTR(0),
+		    BIT(dev->imp_port));
+	/* PTPv2 Ether Type */
+	b53_write64(dev, B53_ARLCTRL_PAGE, B53_MPORT_ADDR(0),
+		    MPORT_ETYPE(ETH_P_1588));
+
+	/* Setup PTP clock */
+	memset(&dev->ptp_clock_info, 0, sizeof(dev->ptp_clock_info));
+
+	dev->ptp_clock_info.owner = THIS_MODULE;
+	snprintf(dev->ptp_clock_info.name, sizeof(dev->ptp_clock_info.name),
+		 dev_name(dev->dev));
+
+	dev->ptp_clock_info.max_adj = 1000000000ULL;
+	dev->ptp_clock_info.adjfine = b53_ptp_adjfine;
+	dev->ptp_clock_info.adjtime = b53_ptp_adjtime;
+	dev->ptp_clock_info.gettime64 = b53_ptp_gettime;
+	dev->ptp_clock_info.settime64 = b53_ptp_settime;
+	dev->ptp_clock_info.enable = b53_ptp_enable;
+	dev->ptp_clock_info.do_aux_work = b53_hwtstamp_work;
+
+	dev->ptp_clock = ptp_clock_register(&dev->ptp_clock_info, dev->dev);
+	if (IS_ERR(dev->ptp_clock))
+		return PTR_ERR(dev->ptp_clock);
+
+	/* The switch provides a 32 bit free running counter. Use the Linux
+	 * cycle counter infrastructure which is suited for such scenarios.
+	 */
+	dev->cc.read = b53_ptp_read;
+	dev->cc.mask = CYCLECOUNTER_MASK(30);
+	dev->cc.overflow_point = 999999999;
+	dev->cc.mult = (1 << 28);
+	dev->cc.shift = 28;
+
+	timecounter_init(&dev->tc, &dev->cc, ktime_to_ns(ktime_get_real()));
+
+	ptp_schedule_worker(dev->ptp_clock, 0);
+
+	return 0;
+}
+EXPORT_SYMBOL(b53_ptp_init);
+
+int b53_get_ts_info(struct dsa_switch *ds, int port,
+		    struct ethtool_ts_info *info)
+{
+	struct b53_device *dev = ds->priv;
+
+	info->phc_index = dev->ptp_clock ? ptp_clock_index(dev->ptp_clock) : -1;
+	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->tx_types = BIT(HWTSTAMP_TX_OFF);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE);
+
+	return 0;
+}
+EXPORT_SYMBOL(b53_get_ts_info);
+
+void b53_ptp_exit(struct b53_device *dev)
+{
+	if (dev->ptp_clock)
+		ptp_clock_unregister(dev->ptp_clock);
+	dev->ptp_clock = NULL;
+}
+EXPORT_SYMBOL(b53_ptp_exit);
+
+MODULE_AUTHOR("Martin Kaistra <martin.kaistra@linutronix.de>");
+MODULE_DESCRIPTION("B53 Switch PTP support");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/dsa/b53/b53_ptp.h b/drivers/net/dsa/b53/b53_ptp.h
new file mode 100644
index 000000000000..5cd2fd9621a2
--- /dev/null
+++ b/drivers/net/dsa/b53/b53_ptp.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Author: Martin Kaistra <martin.kaistra@linutronix.de>
+ * Copyright (C) 2021 Linutronix GmbH
+ */
+
+#ifndef _B53_PTP_H
+#define _B53_PTP_H
+
+#include "b53_priv.h"
+
+#ifdef CONFIG_B53_PTP
+int b53_ptp_init(struct b53_device *dev);
+void b53_ptp_exit(struct b53_device *dev);
+int b53_get_ts_info(struct dsa_switch *ds, int port,
+		    struct ethtool_ts_info *info);
+#else /* !CONFIG_B53_PTP */
+
+static inline int b53_ptp_init(struct b53_device *dev)
+{
+	return 0;
+}
+
+static inline void b53_ptp_exit(struct b53_device *dev)
+{
+}
+
+static inline int b53_get_ts_info(struct dsa_switch *ds, int port,
+				  struct ethtool_ts_info *info)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif
+#endif
diff --git a/include/linux/dsa/b53.h b/include/linux/dsa/b53.h
index af782a1da362..85aa6d9dc53d 100644
--- a/include/linux/dsa/b53.h
+++ b/include/linux/dsa/b53.h
@@ -1,10 +1,14 @@
 /* SPDX-License-Identifier: ISC */
 /*
  * Copyright (C) 2011-2013 Jonas Gorski <jogo@openwrt.org>
+ * Copyright (C) 2021 Linutronix GmbH
  *
  * Included by drivers/net/dsa/b53/b53_priv.h and net/dsa/tag_brcm.c
  */
 
+#include <linux/ptp_clock_kernel.h>
+#include <linux/timecounter.h>
+#include <linux/workqueue.h>
 #include <net/dsa.h>
 
 struct b53_device;
@@ -97,4 +101,14 @@ struct b53_device {
 	bool vlan_enabled;
 	unsigned int num_ports;
 	struct b53_port *ports;
+
+	/* PTP */
+	bool broadsync_hd;
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_clock_info;
+	struct cyclecounter cc;
+	struct timecounter tc;
+	struct mutex ptp_mutex;
+#define B53_PTP_OVERFLOW_PERIOD (HZ / 2)
+	struct delayed_work overflow_work;
 };
-- 
2.20.1

