Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5342B08C9
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgKLPrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:47:37 -0500
Received: from mailout12.rmx.de ([94.199.88.78]:58568 "EHLO mailout12.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbgKLPrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:47:32 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout12.rmx.de (Postfix) with ESMTPS id 4CX5Zh6l2zzRkpl;
        Thu, 12 Nov 2020 16:47:24 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CX5Y80QlQz2xZh;
        Thu, 12 Nov 2020 16:46:04 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.59) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 12 Nov
 2020 16:39:51 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 07/11] net: dsa: microchip: ksz9477: add Posix clock support for chip PTP clock
Date:   Thu, 12 Nov 2020 16:35:33 +0100
Message-ID: <20201112153537.22383-8-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112153537.22383-1-ceggers@arri.de>
References: <20201112153537.22383-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.59]
X-RMX-ID: 20201112-164608-4CX5Y80QlQz2xZh-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement routines (adjfine, adjtime, gettime and settime) for
manipulating the chip's PTP clock.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/net/dsa/microchip/Kconfig        |   9 +
 drivers/net/dsa/microchip/Makefile       |   1 +
 drivers/net/dsa/microchip/ksz9477_i2c.c  |   2 +-
 drivers/net/dsa/microchip/ksz9477_main.c |  17 ++
 drivers/net/dsa/microchip/ksz9477_ptp.c  | 301 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz9477_ptp.h  |  27 ++
 drivers/net/dsa/microchip/ksz9477_spi.c  |   2 +-
 drivers/net/dsa/microchip/ksz_common.h   |   1 +
 include/linux/dsa/ksz_common.h           |   7 +
 9 files changed, 365 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz9477_ptp.c
 create mode 100644 drivers/net/dsa/microchip/ksz9477_ptp.h

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 4ec6a47b7f72..71cc910e5941 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -24,6 +24,15 @@ config NET_DSA_MICROCHIP_KSZ9477_SPI
 	help
 	  Select to enable support for registering switches configured through SPI.
 
+config NET_DSA_MICROCHIP_KSZ9477_PTP
+	bool "PTP support for Microchip KSZ9477 series"
+	default n
+	depends on NET_DSA_MICROCHIP_KSZ9477
+	depends on PTP_1588_CLOCK
+	help
+	  Say Y to enable PTP hardware timestamping on Microchip KSZ switch
+	  chips that support it.
+
 menuconfig NET_DSA_MICROCHIP_KSZ8795
 	tristate "Microchip KSZ8795 series switch support"
 	depends on NET_DSA
diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index c5cc1d5dea06..35c4356bad65 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)	+= ksz_common.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477)		+= ksz9477.o
 ksz9477-objs := ksz9477_main.o
+ksz9477-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)	+= ksz9477_ptp.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795)		+= ksz8795.o
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 4ed1f503044a..315eb24c444d 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -58,7 +58,7 @@ static int ksz9477_i2c_remove(struct i2c_client *i2c)
 {
 	struct ksz_device *dev = i2c_get_clientdata(i2c);
 
-	ksz_switch_remove(dev);
+	ksz9477_switch_remove(dev);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/microchip/ksz9477_main.c b/drivers/net/dsa/microchip/ksz9477_main.c
index 6b5a981fb21f..7d623400139f 100644
--- a/drivers/net/dsa/microchip/ksz9477_main.c
+++ b/drivers/net/dsa/microchip/ksz9477_main.c
@@ -18,6 +18,7 @@
 
 #include "ksz9477_reg.h"
 #include "ksz_common.h"
+#include "ksz9477_ptp.h"
 
 /* Used with variable features to indicate capabilities. */
 #define GBIT_SUPPORT			BIT(0)
@@ -1719,10 +1720,26 @@ int ksz9477_switch_register(struct ksz_device *dev)
 			phy_remove_link_mode(phydev,
 					     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
 	}
+
+	ret = ksz9477_ptp_init(dev);
+	if (ret)
+		goto error_switch_unregister;
+
+	return 0;
+
+error_switch_unregister:
+	ksz_switch_remove(dev);
 	return ret;
 }
 EXPORT_SYMBOL(ksz9477_switch_register);
 
+void ksz9477_switch_remove(struct ksz_device *dev)
+{
+	ksz9477_ptp_deinit(dev);
+	ksz_switch_remove(dev);
+}
+EXPORT_SYMBOL(ksz9477_switch_remove);
+
 MODULE_AUTHOR("Woojung Huh <Woojung.Huh@microchip.com>");
 MODULE_DESCRIPTION("Microchip KSZ9477 Series Switch DSA Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.c b/drivers/net/dsa/microchip/ksz9477_ptp.c
new file mode 100644
index 000000000000..44d7bbdea518
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.c
@@ -0,0 +1,301 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Microchip KSZ9477 switch driver PTP routines
+ *
+ * Author: Christian Eggers <ceggers@arri.de>
+ *
+ * Copyright (c) 2020 ARRI Lighting
+ */
+
+#include <linux/ptp_clock_kernel.h>
+
+#include "ksz_common.h"
+#include "ksz9477_reg.h"
+
+#include "ksz9477_ptp.h"
+
+#define KSZ_PTP_INC_NS 40  /* HW clock is incremented every 40 ns (by 40) */
+#define KSZ_PTP_SUBNS_BITS 32  /* Number of bits in sub-nanoseconds counter */
+
+/* Posix clock support */
+
+static int ksz9477_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
+	u16 data16;
+	int ret;
+
+	if (scaled_ppm) {
+		/* basic calculation:
+		 * s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
+		 * s64 adj = div_s64(((s64)ppb * KSZ_PTP_INC_NS) << KSZ_PTP_SUBNS_BITS,
+		 *                   NSEC_PER_SEC);
+		 */
+
+		/* more precise calculation (avoids shifting out precision) */
+		s64 ppb, adj;
+		u32 data32;
+
+		/* see scaled_ppm_to_ppb() in ptp_clock.c for details */
+		ppb = 1 + scaled_ppm;
+		ppb *= 125;
+		ppb *= KSZ_PTP_INC_NS;
+		ppb <<= KSZ_PTP_SUBNS_BITS - 13;
+		adj = div_s64(ppb, NSEC_PER_SEC);
+
+		data32 = abs(adj);
+		data32 &= BIT_MASK(30) - 1;
+		if (adj >= 0)
+			data32 |= PTP_RATE_DIR;
+
+		ret = ksz_write32(dev, REG_PTP_SUBNANOSEC_RATE, data32);
+		if (ret)
+			return ret;
+	}
+
+	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data16);
+	if (ret)
+		return ret;
+
+	if (scaled_ppm)
+		data16 |= PTP_CLK_ADJ_ENABLE;
+	else
+		data16 &= ~PTP_CLK_ADJ_ENABLE;
+
+	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
+	s32 sec, nsec;
+	u16 data16;
+	int ret;
+
+	mutex_lock(&dev->ptp_mutex);
+
+	/* do not use ns_to_timespec64(), both sec and nsec are subtracted by hw */
+	sec = div_s64_rem(delta, NSEC_PER_SEC, &nsec);
+
+	ret = ksz_write32(dev, REG_PTP_RTC_NANOSEC, abs(nsec));
+	if (ret)
+		goto error_return;
+
+	/* contradictory to the data sheet, seconds are also considered */
+	ret = ksz_write32(dev, REG_PTP_RTC_SEC, abs(sec));
+	if (ret)
+		goto error_return;
+
+	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data16);
+	if (ret)
+		goto error_return;
+
+	data16 |= PTP_STEP_ADJ;
+	if (delta < 0)
+		data16 &= ~PTP_STEP_DIR;  /* 0: subtract */
+	else
+		data16 |= PTP_STEP_DIR;   /* 1: add */
+
+	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
+	if (ret)
+		goto error_return;
+
+error_return:
+	mutex_unlock(&dev->ptp_mutex);
+	return ret;
+}
+
+static int _ksz9477_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
+{
+	u32 nanoseconds;
+	u32 seconds;
+	u16 data16;
+	u8 phase;
+	int ret;
+
+	/* Copy current PTP clock into shadow registers */
+	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data16);
+	if (ret)
+		return ret;
+
+	data16 |= PTP_READ_TIME;
+
+	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
+	if (ret)
+		return ret;
+
+	/* Read from shadow registers */
+	ret = ksz_read8(dev, REG_PTP_RTC_SUB_NANOSEC__2, &phase);
+	if (ret)
+		return ret;
+	ret = ksz_read32(dev, REG_PTP_RTC_NANOSEC, &nanoseconds);
+	if (ret)
+		return ret;
+	ret = ksz_read32(dev, REG_PTP_RTC_SEC, &seconds);
+	if (ret)
+		return ret;
+
+	ts->tv_sec = seconds;
+	ts->tv_nsec = nanoseconds + phase * 8;
+
+	return 0;
+}
+
+static int ksz9477_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
+{
+	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
+	int ret;
+
+	mutex_lock(&dev->ptp_mutex);
+	ret = _ksz9477_ptp_gettime(dev, ts);
+	mutex_unlock(&dev->ptp_mutex);
+
+	return ret;
+}
+
+static int ksz9477_ptp_settime(struct ptp_clock_info *ptp, struct timespec64 const *ts)
+{
+	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
+	u16 data16;
+	int ret;
+
+	mutex_lock(&dev->ptp_mutex);
+
+	/* Write to shadow registers */
+
+	/* clock phase */
+	ret = ksz_read16(dev, REG_PTP_RTC_SUB_NANOSEC__2, &data16);
+	if (ret)
+		goto error_return;
+
+	data16 &= ~PTP_RTC_SUB_NANOSEC_M;
+
+	ret = ksz_write16(dev, REG_PTP_RTC_SUB_NANOSEC__2, data16);
+	if (ret)
+		goto error_return;
+
+	/* nanoseconds */
+	ret = ksz_write32(dev, REG_PTP_RTC_NANOSEC, ts->tv_nsec);
+	if (ret)
+		goto error_return;
+
+	/* seconds */
+	ret = ksz_write32(dev, REG_PTP_RTC_SEC, ts->tv_sec);
+	if (ret)
+		goto error_return;
+
+	/* Load PTP clock from shadow registers */
+	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data16);
+	if (ret)
+		goto error_return;
+
+	data16 |= PTP_LOAD_TIME;
+
+	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
+	if (ret)
+		goto error_return;
+
+error_return:
+	mutex_unlock(&dev->ptp_mutex);
+	return ret;
+}
+
+static int ksz9477_ptp_enable(struct ptp_clock_info *ptp, struct ptp_clock_request *req, int on)
+{
+	return -ENOTTY;
+}
+
+static int ksz9477_ptp_start_clock(struct ksz_device *dev)
+{
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data);
+	if (ret)
+		return ret;
+
+	/* Perform PTP clock reset */
+	data |= PTP_CLK_RESET;
+	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data);
+	if (ret)
+		return ret;
+	data &= ~PTP_CLK_RESET;
+
+	/* Enable PTP clock */
+	data |= PTP_CLK_ENABLE;
+	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_ptp_stop_clock(struct ksz_device *dev)
+{
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data);
+	if (ret)
+		return ret;
+
+	/* Disable PTP clock */
+	data &= ~PTP_CLK_ENABLE;
+	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+int ksz9477_ptp_init(struct ksz_device *dev)
+{
+	int ret;
+
+	mutex_init(&dev->ptp_mutex);
+
+	/* PTP clock properties */
+
+	dev->ptp_caps.owner = THIS_MODULE;
+	snprintf(dev->ptp_caps.name, sizeof(dev->ptp_caps.name), dev_name(dev->dev));
+
+	/* Sub-nanoseconds-adj,max * sub-nanoseconds / 40ns * 1ns
+	 * = (2^30-1) * (2 ^ 32) / 40 ns * 1 ns = 6249999
+	 */
+	dev->ptp_caps.max_adj     = 6249999;
+	dev->ptp_caps.n_alarm     = 0;
+	dev->ptp_caps.n_ext_ts    = 0;  /* currently not implemented */
+	dev->ptp_caps.n_per_out   = 0;
+	dev->ptp_caps.pps         = 0;
+	dev->ptp_caps.adjfine     = ksz9477_ptp_adjfine;
+	dev->ptp_caps.adjtime     = ksz9477_ptp_adjtime;
+	dev->ptp_caps.gettime64   = ksz9477_ptp_gettime;
+	dev->ptp_caps.settime64   = ksz9477_ptp_settime;
+	dev->ptp_caps.enable      = ksz9477_ptp_enable;
+
+	/* Start hardware counter (will overflow after 136 years) */
+	ret = ksz9477_ptp_start_clock(dev);
+	if (ret)
+		return ret;
+
+	dev->ptp_clock = ptp_clock_register(&dev->ptp_caps, dev->dev);
+	if (IS_ERR(dev->ptp_clock)) {
+		ret = PTR_ERR(dev->ptp_clock);
+		goto error_stop_clock;
+	}
+
+	return 0;
+
+error_stop_clock:
+	ksz9477_ptp_stop_clock(dev);
+	return ret;
+}
+
+void ksz9477_ptp_deinit(struct ksz_device *dev)
+{
+	ptp_clock_unregister(dev->ptp_clock);
+	ksz9477_ptp_stop_clock(dev);
+}
diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.h b/drivers/net/dsa/microchip/ksz9477_ptp.h
new file mode 100644
index 000000000000..0076538419fa
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Microchip KSZ9477 switch driver PTP routines
+ *
+ * Author: Christian Eggers <ceggers@arri.de>
+ *
+ * Copyright (c) 2020 ARRI Lighting
+ */
+
+#ifndef DRIVERS_NET_DSA_MICROCHIP_KSZ9477_PTP_H_
+#define DRIVERS_NET_DSA_MICROCHIP_KSZ9477_PTP_H_
+
+#include "ksz_common.h"
+
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
+
+int ksz9477_ptp_init(struct ksz_device *dev);
+void ksz9477_ptp_deinit(struct ksz_device *dev);
+
+#else
+
+static inline int ksz9477_ptp_init(struct ksz_device *dev) { return 0; }
+static inline void ksz9477_ptp_deinit(struct ksz_device *dev) {}
+
+#endif
+
+#endif /* DRIVERS_NET_DSA_MICROCHIP_KSZ9477_PTP_H_ */
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index d2eea9596e53..e49d581547ac 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -66,7 +66,7 @@ static int ksz9477_spi_remove(struct spi_device *spi)
 	struct ksz_device *dev = spi_get_drvdata(spi);
 
 	if (dev)
-		ksz_switch_remove(dev);
+		ksz9477_switch_remove(dev);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 5735374b5bc3..96808d2585d9 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -67,6 +67,7 @@ void ksz_switch_remove(struct ksz_device *dev);
 
 int ksz8795_switch_register(struct ksz_device *dev);
 int ksz9477_switch_register(struct ksz_device *dev);
+void ksz9477_switch_remove(struct ksz_device *dev);
 
 void ksz_update_port_member(struct ksz_device *dev, int port);
 void ksz_init_mib_timer(struct ksz_device *dev);
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index bf57ba4b2132..4d5b6cc9429a 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/phy.h>
+#include <linux/ptp_clock_kernel.h>
 #include <linux/regmap.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
@@ -92,6 +93,12 @@ struct ksz_device {
 	u32 overrides;			/* chip functions set by user */
 	u16 host_mask;
 	u16 port_mask;
+
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_caps;
+	struct mutex ptp_mutex;
+#endif
 };
 
 #endif /* _NET_DSA_KSZ_COMMON_H_ */
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

