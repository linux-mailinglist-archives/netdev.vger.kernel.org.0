Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DF55FF15C
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 17:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiJNP32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 11:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiJNP3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 11:29:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97D91D3EB5;
        Fri, 14 Oct 2022 08:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1665761363; x=1697297363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GFO5B/TBiuI1kXgFuapjcQD6QaRC4LsZQuzGyAZVNjY=;
  b=2DICIAOWezNlIZwnCJ84LYDEpY9a/8W/LJjSm3siN7S59N23wDrbGfkg
   f2knwcOJHPQbGKNwSZFZ0qgC9a0zsa2fkmTfWrkMxl6mziUKFfy5G44li
   RlnhkfCmQrlCoWGrEtuC4XX0z+J6K5MSqZRksFawvjqPMV0TQa2xiXNpL
   Z1OnrJngqsIrQo9Y3J9o03Fd+KukGgElyPilc7Pc7fO+dlMVilRQDi4KZ
   cn1dga+0Y4hUuA2zPC9Cr7CCzQfNdu1CPjeCW1fGUtnb5lyuDjGlLN/Ew
   JWz0l7Q/b4jn9kZOIlseXwoY1jgQH14cJkws1MFjcwZZwvRc6/4wHeNvj
   A==;
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="178786930"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2022 08:29:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 14 Oct 2022 08:29:21 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 14 Oct 2022 08:29:16 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: [RFC Patch net-next 1/6] net: dsa: microchip: adding the posix clock support
Date:   Fri, 14 Oct 2022 20:58:52 +0530
Message-ID: <20221014152857.32645-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221014152857.32645-1-arun.ramadoss@microchip.com>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implement routines (adjfine, adjtime, gettime and settime)
for manipulating the chip's PTP clock. It registers the ptp caps
to posix clock register.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/Kconfig       |  10 +
 drivers/net/dsa/microchip/Makefile      |   1 +
 drivers/net/dsa/microchip/ksz_common.c  |  14 +-
 drivers/net/dsa/microchip/ksz_common.h  |  17 ++
 drivers/net/dsa/microchip/ksz_ptp.c     | 269 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h     |  43 ++++
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  52 +++++
 7 files changed, 405 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.c
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.h
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp_reg.h

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 06b1efdb5e7d..1e9712ff64e2 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -21,6 +21,16 @@ config NET_DSA_MICROCHIP_KSZ_SPI
 	help
 	  Select to enable support for registering switches configured through SPI.
 
+config NET_DSA_MICROCHIP_KSZ_PTP
+	bool "Support for the PTP clock on the KSZ9563/LAN937x Ethernet Switch"
+	depends on NET_DSA_MICROCHIP_KSZ_COMMON && PTP_1588_CLOCK
+	help
+	  This enables support for timestamping & PTP clock manipulation
+	  in the KSZ9563/LAN937x Ethernet switch
+
+	  Select to enable support for PTP feature for KSZ9563/lan937x series
+	  of switch.
+
 config NET_DSA_MICROCHIP_KSZ8863_SMI
 	tristate "KSZ series SMI connected switch driver"
 	depends on NET_DSA_MICROCHIP_KSZ_COMMON
diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 28873559efc2..29d2d00ea27f 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -6,4 +6,5 @@ ksz_switch-objs += ksz8795.o
 ksz_switch-objs += lan937x_main.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_SPI)		+= ksz_spi.o
+obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)	   	+= ksz_ptp.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index d612181b3226..084563e80660 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -27,6 +27,7 @@
 #include "ksz8.h"
 #include "ksz9477.h"
 #include "lan937x.h"
+#include "ksz_ptp.h"
 
 #define MIB_COUNTER_NUM 0x20
 
@@ -1990,10 +1991,16 @@ static int ksz_setup(struct dsa_switch *ds)
 		}
 	}
 
+	ret = ksz_ptp_clock_register(ds);
+	if (ret) {
+		dev_err(dev->dev, "Failed to register PTP clock: %d\n", ret);
+		goto out_pirq;
+	}
+
 	ret = ksz_mdio_register(dev);
 	if (ret < 0) {
 		dev_err(dev->dev, "failed to register the mdio");
-		goto out_pirq;
+		goto out_ptp_clock_unregister;
 	}
 
 	/* start switch */
@@ -2002,6 +2009,8 @@ static int ksz_setup(struct dsa_switch *ds)
 
 	return 0;
 
+out_ptp_clock_unregister:
+	ksz_ptp_clock_unregister(ds);
 out_pirq:
 	if (dev->irq > 0)
 		dsa_switch_for_each_user_port(dp, dev->ds)
@@ -2018,6 +2027,8 @@ static void ksz_teardown(struct dsa_switch *ds)
 	struct ksz_device *dev = ds->priv;
 	struct dsa_port *dp;
 
+	ksz_ptp_clock_unregister(ds);
+
 	if (dev->irq > 0) {
 		dsa_switch_for_each_user_port(dp, dev->ds)
 			ksz_irq_free(&dev->ports[dp->index].pirq);
@@ -2831,6 +2842,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_pause_stats	= ksz_get_pause_stats,
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
+	.get_ts_info            = ksz_get_ts_info,
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 9cfa179575ce..f936a4100423 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -14,6 +14,9 @@
 #include <linux/regmap.h>
 #include <net/dsa.h>
 #include <linux/irq.h>
+#include <linux/ptp_clock_kernel.h>
+
+#include "ksz_ptp.h"
 
 #define KSZ_MAX_NUM_PORTS 8
 
@@ -141,6 +144,7 @@ struct ksz_device {
 	u16 port_mask;
 	struct mutex lock_irq;		/* IRQ Access */
 	struct ksz_irq girq;
+	struct ksz_ptp_data ptp_data;
 };
 
 /* List of supported models */
@@ -442,6 +446,19 @@ static inline int ksz_write32(struct ksz_device *dev, u32 reg, u32 value)
 	return ret;
 }
 
+static inline int ksz_rmw16(struct ksz_device *dev, u32 reg, u16 mask,
+			    u16 value)
+{
+	int ret;
+
+	ret = regmap_update_bits(dev->regmap[1], reg, mask, value);
+	if (ret)
+		dev_err(dev->dev, "can't rmw 16bit reg: 0x%x %pe\n", reg,
+			ERR_PTR(ret));
+
+	return ret;
+}
+
 static inline int ksz_write64(struct ksz_device *dev, u32 reg, u64 value)
 {
 	u32 val[2];
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
new file mode 100644
index 000000000000..0ead0e097ed5
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -0,0 +1,269 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Microchip LAN937X PTP Implementation
+ * Copyright (C) 2021-2022 Microchip Technology Inc.
+ */
+
+#include <linux/kernel.h>
+#include <linux/ptp_classify.h>
+#include <linux/ptp_clock_kernel.h>
+
+#include "ksz_common.h"
+#include "ksz_ptp.h"
+#include "ksz_ptp_reg.h"
+
+#define ptp_caps_to_data(d) \
+		container_of((d), struct ksz_ptp_data, caps)
+#define ptp_data_to_ksz_dev(d) \
+		container_of((d), struct ksz_device, ptp_data)
+
+#define MAX_DRIFT_CORR 6250000
+
+#define KSZ_PTP_INC_NS 40  /* HW clock is incremented every 40 ns (by 40) */
+#define KSZ_PTP_SUBNS_BITS 32  /* Number of bits in sub-nanoseconds counter */
+
+/* The function is return back the capability of timestamping feature when
+ * requested through ethtool -T <interface> utility
+ */
+int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
+{
+	struct ksz_device *dev	= ds->priv;
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+
+	ts->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+			      SOF_TIMESTAMPING_RX_HARDWARE |
+			      SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	ts->tx_types = (1 << HWTSTAMP_TX_OFF);
+
+	ts->rx_filters = (1 << HWTSTAMP_FILTER_NONE);
+
+	ts->phc_index = ptp_clock_index(ptp_data->clock);
+
+	return 0;
+}
+
+/* These are function related to the ptp clock info */
+static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
+{
+	u32 nanoseconds;
+	u32 seconds;
+	u8 phase;
+	int ret;
+
+	/* Copy current PTP clock into shadow registers */
+	ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_READ_TIME, PTP_READ_TIME);
+	if (ret)
+		return ret;
+
+	/* Read from shadow registers */
+	ret = ksz_read8(dev, REG_PTP_RTC_SUB_NANOSEC__2, &phase);
+	if (ret)
+		return ret;
+
+	ret = ksz_read32(dev, REG_PTP_RTC_NANOSEC, &nanoseconds);
+	if (ret)
+		return ret;
+
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
+static int ksz_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	int ret;
+
+	mutex_lock(&ptp_data->lock);
+	ret = _ksz_ptp_gettime(dev, ts);
+	mutex_unlock(&ptp_data->lock);
+
+	return ret;
+}
+
+static int ksz_ptp_settime(struct ptp_clock_info *ptp,
+			   const struct timespec64 *ts)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	int ret;
+
+	mutex_lock(&ptp_data->lock);
+
+	/* Write to shadow registers */
+
+	/* Write 0 to clock phase */
+	ret = ksz_write16(dev, REG_PTP_RTC_SUB_NANOSEC__2, PTP_RTC_0NS);
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
+	ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_LOAD_TIME, PTP_LOAD_TIME);
+
+error_return:
+	mutex_unlock(&ptp_data->lock);
+
+	return ret;
+}
+
+static int ksz_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	int ret;
+
+	mutex_lock(&ptp_data->lock);
+
+	if (scaled_ppm) {
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
+		data32 &= PTP_SUBNANOSEC_M;
+		if (adj >= 0)
+			data32 |= PTP_RATE_DIR;
+
+		ret = ksz_write32(dev, REG_PTP_SUBNANOSEC_RATE, data32);
+		if (ret)
+			goto error_return;
+
+		ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ADJ_ENABLE,
+				PTP_CLK_ADJ_ENABLE);
+		if (ret)
+			goto error_return;
+	} else {
+		ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ADJ_ENABLE, 0);
+		if (ret)
+			goto error_return;
+	}
+
+error_return:
+	mutex_unlock(&ptp_data->lock);
+	return ret;
+}
+
+static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	s32 sec, nsec;
+	u16 data16;
+	int ret;
+
+	mutex_lock(&ptp_data->lock);
+
+	/* do not use ns_to_timespec64(),
+	 * both sec and nsec are subtracted by hw
+	 */
+	sec = div_s64_rem(delta, NSEC_PER_SEC, &nsec);
+
+	ret = ksz_write32(dev, REG_PTP_RTC_NANOSEC, abs(nsec));
+	if (ret)
+		goto error_return;
+
+	ret = ksz_write32(dev, REG_PTP_RTC_SEC, abs(sec));
+	if (ret)
+		goto error_return;
+
+	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data16);
+	if (ret)
+		goto error_return;
+
+	data16 |= PTP_STEP_ADJ;
+
+	/*PTP_STEP_DIR -- 0: subtract, 1: add */
+	if (delta < 0)
+		data16 &= ~PTP_STEP_DIR;
+	else
+		data16 |= PTP_STEP_DIR;
+
+	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
+
+error_return:
+	mutex_unlock(&ptp_data->lock);
+	return ret;
+}
+
+static int ksz_ptp_start_clock(struct ksz_device *dev)
+{
+	return ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ENABLE, PTP_CLK_ENABLE);
+}
+
+static const struct ptp_clock_info ksz_ptp_caps = {
+	.owner		= THIS_MODULE,
+	.name		= "Microchip Clock",
+	.max_adj	= MAX_DRIFT_CORR,
+	.gettime64	= ksz_ptp_gettime,
+	.settime64	= ksz_ptp_settime,
+	.adjfine	= ksz_ptp_adjfine,
+	.adjtime	= ksz_ptp_adjtime,
+};
+
+int ksz_ptp_clock_register(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+	int ret;
+
+	mutex_init(&ptp_data->lock);
+
+	ptp_data->caps = ksz_ptp_caps;
+
+	/* Start hardware counter */
+	ret = ksz_ptp_start_clock(dev);
+	if (ret)
+		return ret;
+
+	/* Register the PTP Clock */
+	ptp_data->clock = ptp_clock_register(&ptp_data->caps, dev->dev);
+	if (IS_ERR_OR_NULL(ptp_data->clock))
+		return PTR_ERR(ptp_data->clock);
+
+	ret = ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_802_1AS, PTP_802_1AS);
+	if (ret)
+		goto error_unregister_clock;
+
+	return 0;
+
+error_unregister_clock:
+	ptp_clock_unregister(ptp_data->clock);
+	return ret;
+}
+
+void ksz_ptp_clock_unregister(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
+
+	if (IS_ERR_OR_NULL(ptp_data->clock))
+		return;
+
+	ptp_clock_unregister(ptp_data->clock);
+}
+
+MODULE_AUTHOR("Arun Ramadoss <arun.ramadoss@microchip.com>");
+MODULE_DESCRIPTION("PTP support for KSZ switch");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
new file mode 100644
index 000000000000..ac53b0df2733
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip LAN937X PTP Implementation
+ * Copyright (C) 2020-2021 Microchip Technology Inc.
+ */
+
+#ifndef _NET_DSA_DRIVERS_KSZ_PTP_H
+#define _NET_DSA_DRIVERS_KSZ_PTP_H
+
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
+
+struct ksz_ptp_data {
+	struct ptp_clock_info caps;
+	struct ptp_clock *clock;
+	/* Serializes all operations on the PTP hardware clock */
+	struct mutex lock;
+};
+
+int ksz_ptp_clock_register(struct dsa_switch *ds);
+
+void ksz_ptp_clock_unregister(struct dsa_switch *ds);
+
+int ksz_get_ts_info(struct dsa_switch *ds, int port,
+		    struct ethtool_ts_info *ts);
+
+#else
+
+struct ksz_ptp_data {
+	/* Serializes all operations on the PTP hardware clock */
+	struct mutex lock;
+};
+
+static inline int ksz_ptp_clock_register(struct dsa_switch *ds)
+{
+	return 0;
+}
+
+static inline void ksz_ptp_clock_unregister(struct dsa_switch *ds) { }
+
+#define ksz_get_ts_info NULL
+
+#endif	/* End of CONFIG_NET_DSA_MICROCHIOP_KSZ_PTP */
+
+#endif
diff --git a/drivers/net/dsa/microchip/ksz_ptp_reg.h b/drivers/net/dsa/microchip/ksz_ptp_reg.h
new file mode 100644
index 000000000000..2bf8395475b9
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz_ptp_reg.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip KSZ PTP register definitions
+ * Copyright (C) 2019-2021 Microchip Technology Inc.
+ */
+
+/* 5 - PTP Clock */
+#define REG_PTP_CLK_CTRL		0x0500
+
+#define PTP_STEP_ADJ			BIT(6)
+#define PTP_STEP_DIR			BIT(5)
+#define PTP_READ_TIME			BIT(4)
+#define PTP_LOAD_TIME			BIT(3)
+#define PTP_CLK_ADJ_ENABLE		BIT(2)
+#define PTP_CLK_ENABLE			BIT(1)
+#define PTP_CLK_RESET			BIT(0)
+
+#define REG_PTP_RTC_SUB_NANOSEC__2	0x0502
+
+#define PTP_RTC_SUB_NANOSEC_M		0x0007
+#define PTP_RTC_0NS			0x00
+
+#define REG_PTP_RTC_NANOSEC		0x0504
+#define REG_PTP_RTC_NANOSEC_H		0x0504
+#define REG_PTP_RTC_NANOSEC_L		0x0506
+
+#define REG_PTP_RTC_SEC			0x0508
+#define REG_PTP_RTC_SEC_H		0x0508
+#define REG_PTP_RTC_SEC_L		0x050A
+
+#define REG_PTP_SUBNANOSEC_RATE		0x050C
+#define REG_PTP_SUBNANOSEC_RATE_H	0x050C
+#define PTP_SUBNANOSEC_M		0x3FFFFFFF
+
+#define PTP_RATE_DIR			BIT(31)
+#define PTP_TMP_RATE_ENABLE		BIT(30)
+
+#define REG_PTP_SUBNANOSEC_RATE_L	0x050E
+
+#define REG_PTP_RATE_DURATION		0x0510
+#define REG_PTP_RATE_DURATION_H		0x0510
+#define REG_PTP_RATE_DURATION_L		0x0512
+
+#define REG_PTP_MSG_CONF1		0x0514
+
+#define PTP_802_1AS			BIT(7)
+#define PTP_ENABLE			BIT(6)
+#define PTP_ETH_ENABLE			BIT(5)
+#define PTP_IPV4_UDP_ENABLE		BIT(4)
+#define PTP_IPV6_UDP_ENABLE		BIT(3)
+#define PTP_TC_P2P			BIT(2)
+#define PTP_MASTER			BIT(1)
+#define PTP_1STEP			BIT(0)
-- 
2.36.1

