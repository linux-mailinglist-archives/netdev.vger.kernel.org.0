Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B33252584B
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359473AbiELX2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359468AbiELX2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:28:23 -0400
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD9C5D641;
        Thu, 12 May 2022 16:28:20 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc15a.ng.seznam.cz (email-smtpc15a.ng.seznam.cz [10.23.11.195])
        id 7e1c5bb19ab0888f7fc1fadf;
        Fri, 13 May 2022 01:28:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1652398095; bh=zhWoLJbzeDQ/F8k1ho9h0e/2udO6tYkBzgIdLoJMInc=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:X-szn-frgn:
         X-szn-frgc;
        b=V6TaqIKT+zPXI8pGUTy6O9vf7qkqDPIOIZ8TJuMKjxD7e5BQpGowflCF1Cfiv/uo4
         EWpdFXc/29bSqbpOrh5M49R3u4L20OtReDqRFAYpsMUaKTobuaoT1GGlac+oY0LREF
         KtR+fs3uKuem43LeVVBuLOUQbWdHzP7tyEu23gTI=
Received: from localhost.localdomain (ip-89-176-234-80.net.upcbroadband.cz [89.176.234.80])
        by email-relay29.ng.seznam.cz (Seznam SMTPD 1.3.136) with ESMTP;
        Fri, 13 May 2022 01:28:07 +0200 (CEST)  
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        pisa@cmp.felk.cvut.cz
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        ondrej.ille@gmail.com, martin.jerabek01@gmail.com,
        matej.vasilevski@seznam.cz
Subject: [RFC PATCH 1/3] can: ctucanfd: add HW timestamps to RX and error CAN frames
Date:   Fri, 13 May 2022 01:27:05 +0200
Message-Id: <20220512232706.24575-2-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
References: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-szn-frgn: <26ded9a1-d1bb-4ea9-8ef4-9d24f7cab50c>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for retrieving hardware timestamps to RX and
error CAN frames for platform devices. It uses timecounter and
cyclecounter structures, because the timestamping counter width depends
on the IP core implementation (it might not always be 64-bit).
To enable HW timestamps, you have to enable it in the kernel config
and provide the following properties in device tree:
- ts-used-bits
- add second clock phandle to 'clocks' property
- create 'clock-names' property and name the second clock 'ts_clk'

Alternatively, you can set property 'ts-frequency' directly with
the timestamping frequency, instead of setting second clock.

Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
---
 drivers/net/can/ctucanfd/Kconfig              |  10 ++
 drivers/net/can/ctucanfd/Makefile             |   2 +-
 drivers/net/can/ctucanfd/ctucanfd.h           |  25 ++++
 drivers/net/can/ctucanfd/ctucanfd_base.c      | 123 +++++++++++++++++-
 drivers/net/can/ctucanfd/ctucanfd_timestamp.c | 113 ++++++++++++++++
 5 files changed, 267 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c

diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/Kconfig
index 48963efc7f19..d75931525ce7 100644
--- a/drivers/net/can/ctucanfd/Kconfig
+++ b/drivers/net/can/ctucanfd/Kconfig
@@ -32,3 +32,13 @@ config CAN_CTUCANFD_PLATFORM
 	  company. FPGA design https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top.
 	  The kit description at the Computer Architectures course pages
 	  https://cw.fel.cvut.cz/wiki/courses/b35apo/documentation/mz_apo/start .
+
+config CAN_CTUCANFD_PLATFORM_ENABLE_HW_TIMESTAMPS
+	bool "CTU CAN-FD IP core platform device hardware timestamps"
+	depends on CAN_CTUCANFD_PLATFORM
+	default n
+	help
+	  Enables reading hardware timestamps from the IP core for platform
+	  devices by default. You will have to provide ts-bit-size and
+	  ts-frequency/timestaping clock in device tree for CTU CAN-FD IP cores,
+	  see device tree bindings for more details.
diff --git a/drivers/net/can/ctucanfd/Makefile b/drivers/net/can/ctucanfd/Makefile
index 8078f1f2c30f..78b7d9830098 100644
--- a/drivers/net/can/ctucanfd/Makefile
+++ b/drivers/net/can/ctucanfd/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_CAN_CTUCANFD) := ctucanfd.o
 ctucanfd-y := ctucanfd_base.o
 
 obj-$(CONFIG_CAN_CTUCANFD_PCI) += ctucanfd_pci.o
-obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) += ctucanfd_platform.o
+obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) += ctucanfd_platform.o ctucanfd_timestamp.o
diff --git a/drivers/net/can/ctucanfd/ctucanfd.h b/drivers/net/can/ctucanfd/ctucanfd.h
index 0e9904f6a05d..5690a85191df 100644
--- a/drivers/net/can/ctucanfd/ctucanfd.h
+++ b/drivers/net/can/ctucanfd/ctucanfd.h
@@ -20,10 +20,19 @@
 #ifndef __CTUCANFD__
 #define __CTUCANFD__
 
+#include "linux/timecounter.h"
+#include "linux/workqueue.h"
 #include <linux/netdevice.h>
 #include <linux/can/dev.h>
 #include <linux/list.h>
 
+#define CTUCANFD_MAX_WORK_DELAY_SEC 86400	/* one day == 24 * 3600 */
+#ifdef CONFIG_CAN_CTUCANFD_PLATFORM_ENABLE_HW_TIMESTAMPS
+	#define CTUCANFD_TIMESTAMPS_ENABLED_BY_DEFAULT true
+#else
+	#define CTUCANFD_TIMESTAMPS_ENABLED_BY_DEFAULT false
+#endif
+
 enum ctu_can_fd_can_registers;
 
 struct ctucan_priv {
@@ -51,6 +60,16 @@ struct ctucan_priv {
 	u32 rxfrm_first_word;
 
 	struct list_head peers_on_pdev;
+
+	struct cyclecounter cc;
+	struct timecounter tc;
+	struct delayed_work timestamp;
+
+	struct clk *timestamp_clk;
+	u32 timestamp_freq;
+	u32 timestamp_bit_size;
+	u32 work_delay_jiffies;
+	bool timestamp_enabled;
 };
 
 /**
@@ -79,4 +98,10 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr,
 int ctucan_suspend(struct device *dev) __maybe_unused;
 int ctucan_resume(struct device *dev) __maybe_unused;
 
+u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv);
+int ctucan_calculate_and_set_work_delay(struct ctucan_priv *priv);
+void ctucan_skb_set_timestamp(struct ctucan_priv *priv, struct sk_buff *skb,
+			      u64 timestamp);
+int ctucan_timestamp_init(struct ctucan_priv *priv);
+void ctucan_timestamp_stop(struct ctucan_priv *priv);
 #endif /*__CTUCANFD__*/
diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index 2ada097d1ede..d568f7a106b2 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -25,6 +25,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/skbuff.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -148,6 +149,27 @@ static void ctucan_write_txt_buf(struct ctucan_priv *priv, enum ctu_can_fd_can_r
 	priv->write_reg(priv, buf_base + offset, val);
 }
 
+static u64 concatenate_two_u32(u32 high, u32 low)
+{
+	return ((u64)high << 32) | ((u64)low);
+}
+
+u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv)
+{
+	u32 ts_low;
+	u32 ts_high;
+	u32 ts_high2;
+
+	ts_high = ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
+	ts_low = ctucan_read32(priv, CTUCANFD_TIMESTAMP_LOW);
+	ts_high2 = ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
+
+	if (ts_high2 != ts_high)
+		ts_low = priv->read_reg(priv, CTUCANFD_TIMESTAMP_LOW);
+
+	return concatenate_two_u32(ts_high2, ts_low) & priv->cc.mask;
+}
+
 #define CTU_CAN_FD_TXTNF(priv) (!!FIELD_GET(REG_STATUS_TXNF, ctucan_read32(priv, CTUCANFD_STATUS)))
 #define CTU_CAN_FD_ENABLED(priv) (!!FIELD_GET(REG_MODE_ENA, ctucan_read32(priv, CTUCANFD_MODE)))
 
@@ -640,12 +662,16 @@ static netdev_tx_t ctucan_start_xmit(struct sk_buff *skb, struct net_device *nde
  * @priv:	Pointer to CTU CAN FD's private data
  * @cf:		Pointer to CAN frame struct
  * @ffw:	Previously read frame format word
+ * @skb:	Pointer to store timestamp
  *
  * Note: Frame format word must be read separately and provided in 'ffw'.
  */
-static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_frame *cf, u32 ffw)
+static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_frame *cf,
+				 u32 ffw, u64 *timestamp)
 {
 	u32 idw;
+	u32 tstamp_high;
+	u32 tstamp_low;
 	unsigned int i;
 	unsigned int wc;
 	unsigned int len;
@@ -682,9 +708,10 @@ static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_frame *c
 	if (unlikely(len > wc * 4))
 		len = wc * 4;
 
-	/* Timestamp - Read and throw away */
-	ctucan_read32(priv, CTUCANFD_RX_DATA);
-	ctucan_read32(priv, CTUCANFD_RX_DATA);
+	/* Timestamp */
+	tstamp_low = ctucan_read32(priv, CTUCANFD_RX_DATA);
+	tstamp_high = ctucan_read32(priv, CTUCANFD_RX_DATA);
+	*timestamp = concatenate_two_u32(tstamp_high, tstamp_low) & priv->cc.mask;
 
 	/* Data */
 	for (i = 0; i < len; i += 4) {
@@ -713,6 +740,7 @@ static int ctucan_rx(struct net_device *ndev)
 	struct net_device_stats *stats = &ndev->stats;
 	struct canfd_frame *cf;
 	struct sk_buff *skb;
+	u64 timestamp;
 	u32 ffw;
 
 	if (test_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags)) {
@@ -736,7 +764,9 @@ static int ctucan_rx(struct net_device *ndev)
 		return 0;
 	}
 
-	ctucan_read_rx_frame(priv, cf, ffw);
+	ctucan_read_rx_frame(priv, cf, ffw, &timestamp);
+	if (priv->timestamp_enabled)
+		ctucan_skb_set_timestamp(priv, skb, timestamp);
 
 	stats->rx_bytes += cf->len;
 	stats->rx_packets++;
@@ -905,6 +935,11 @@ static void ctucan_err_interrupt(struct net_device *ndev, u32 isr)
 	if (skb) {
 		stats->rx_packets++;
 		stats->rx_bytes += cf->can_dlc;
+		if (priv->timestamp_enabled) {
+			u64 tstamp = ctucan_read_timestamp_counter(priv);
+
+			ctucan_skb_set_timestamp(priv, skb, tstamp);
+		}
 		netif_rx(skb);
 	}
 }
@@ -950,6 +985,11 @@ static int ctucan_rx_poll(struct napi_struct *napi, int quota)
 			cf->data[1] |= CAN_ERR_CRTL_RX_OVERFLOW;
 			stats->rx_packets++;
 			stats->rx_bytes += cf->can_dlc;
+			if (priv->timestamp_enabled) {
+				u64 tstamp = ctucan_read_timestamp_counter(priv);
+
+				ctucan_skb_set_timestamp(priv, skb, tstamp);
+			}
 			netif_rx(skb);
 		}
 
@@ -1235,6 +1275,11 @@ static int ctucan_open(struct net_device *ndev)
 		goto err_chip_start;
 	}
 
+	if (priv->timestamp_enabled && (ctucan_timestamp_init(priv) < 0)) {
+		netdev_info(ndev, "Failed to init timestamping, it will be disabled.\n");
+		priv->timestamp_enabled = false;
+	}
+
 	netdev_info(ndev, "ctu_can_fd device registered\n");
 	can_led_event(ndev, CAN_LED_EVENT_OPEN);
 	napi_enable(&priv->napi);
@@ -1268,6 +1313,9 @@ static int ctucan_close(struct net_device *ndev)
 	ctucan_chip_stop(ndev);
 	free_irq(ndev->irq, ndev);
 	close_candev(ndev);
+	if (priv->timestamp_enabled)
+		ctucan_timestamp_stop(priv);
+
 
 	can_led_event(ndev, CAN_LED_EVENT_STOP);
 	pm_runtime_put(priv->dev);
@@ -1340,6 +1388,43 @@ int ctucan_resume(struct device *dev)
 }
 EXPORT_SYMBOL(ctucan_resume);
 
+void ctucan_parse_dt_timestamp_bit_width(struct ctucan_priv *priv)
+{
+	if (of_property_read_u32(priv->dev->of_node, "ts-used-bits", &priv->timestamp_bit_size)) {
+		dev_info(priv->dev, "failed to read ts-used-bits property from device tree\n");
+		priv->timestamp_enabled = false;
+		return;
+	}
+	if (priv->timestamp_bit_size > 64) {
+		dev_info(priv->dev, "ts-used-bits (value: %d) is too large, (max is 64)\n",
+			 priv->timestamp_bit_size);
+			 priv->timestamp_enabled = false;
+	}
+	if (priv->timestamp_bit_size == 0) {
+		dev_info(priv->dev, "ts-used-bits has to be greater than zero\n");
+			 priv->timestamp_enabled = false;
+	}
+}
+
+void ctucan_parse_dt_timestamp_frequency(struct ctucan_priv *priv)
+{
+	struct device *dev = priv->dev;
+
+	if (!IS_ERR_OR_NULL(priv->timestamp_clk)) {
+		priv->timestamp_freq = clk_get_rate(priv->timestamp_clk);
+	} else {
+		if (of_property_read_u32(dev->of_node, "ts-frequency", &priv->timestamp_freq)) {
+			dev_info(dev, "failed to read ts-frequency property from device tree\n");
+			priv->timestamp_enabled = false;
+			return;
+		}
+		if (priv->timestamp_freq == 0) {
+			dev_info(dev, "ts-frequency has to be greater than zero\n");
+			priv->timestamp_enabled = false;
+		}
+	}
+}
+
 int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigned int ntxbufs,
 			unsigned long can_clk_rate, int pm_enable_call,
 			void (*set_drvdata_fnc)(struct device *dev, struct net_device *ndev))
@@ -1396,6 +1481,17 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
 		can_clk_rate = clk_get_rate(priv->can_clk);
 	}
 
+	priv->timestamp_enabled = CTUCANFD_TIMESTAMPS_ENABLED_BY_DEFAULT;
+	priv->timestamp_clk = NULL;
+
+	if (priv->timestamp_enabled) {
+		priv->timestamp_clk = devm_clk_get(dev, "ts_clk");
+		if (IS_ERR(priv->timestamp_clk)) {
+			dev_info(dev, "Timestaping clock ts_clk not found with error %ld, expecting ts-frequency to be defined\n",
+				 PTR_ERR(priv->timestamp_clk));
+		}
+	}
+
 	priv->write_reg = ctucan_write32_le;
 	priv->read_reg = ctucan_read32_le;
 
@@ -1426,6 +1522,23 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
 
 	priv->can.clock.freq = can_clk_rate;
 
+	if (priv->timestamp_enabled && dev->of_node) {
+		ctucan_parse_dt_timestamp_bit_width(priv);
+		ctucan_parse_dt_timestamp_frequency(priv);
+		if (ctucan_calculate_and_set_work_delay(priv) < 0) {
+			dev_info(dev, "Failed to calculate work delay jiffies, disabling timestamps\n");
+			priv->timestamp_enabled = false;
+		}
+	} else {
+		priv->timestamp_enabled = false;
+	}
+
+	if (priv->timestamp_enabled)
+		dev_info(dev, "Timestamping enabled with counter bit width %u, frequency %u, work delay in jiffies %u\n",
+			 priv->timestamp_bit_size, priv->timestamp_freq, priv->work_delay_jiffies);
+	else
+		dev_info(dev, "Timestamping is disabled\n");
+
 	netif_napi_add(ndev, &priv->napi, ctucan_rx_poll, NAPI_POLL_WEIGHT);
 
 	ret = register_candev(ndev);
diff --git a/drivers/net/can/ctucanfd/ctucanfd_timestamp.c b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
new file mode 100644
index 000000000000..63ef2c72510b
--- /dev/null
+++ b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*******************************************************************************
+ *
+ * CTU CAN FD IP Core
+ *
+ * Copyright (C) 2022 Matej Vasilevski <matej.vasilevski@seznam.cz> FEE CTU
+ *
+ * Project advisors:
+ *     Jiri Novak <jnovak@fel.cvut.cz>
+ *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
+ *
+ * Department of Measurement         (http://meas.fel.cvut.cz/)
+ * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
+ * Czech Technical University        (http://www.cvut.cz/)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ******************************************************************************/
+
+#include "asm-generic/bitops/builtin-ffs.h"
+#include "linux/dev_printk.h"
+#include <linux/clocksource.h>
+#include <linux/math64.h>
+#include <linux/timecounter.h>
+#include <linux/workqueue.h>
+
+#include "ctucanfd.h"
+#include "ctucanfd_kregs.h"
+
+static u64 ctucan_timestamp_read(const struct cyclecounter *cc)
+{
+	struct ctucan_priv *priv;
+
+	priv = container_of(cc, struct ctucan_priv, cc);
+	return ctucan_read_timestamp_counter(priv);
+}
+
+static void ctucan_timestamp_work(struct work_struct *work)
+{
+	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct ctucan_priv *priv;
+
+	priv = container_of(delayed_work, struct ctucan_priv, timestamp);
+	timecounter_read(&priv->tc);
+	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
+}
+
+int ctucan_calculate_and_set_work_delay(struct ctucan_priv *priv)
+{
+	u32 jiffies_order = fls(HZ);
+	u32 max_shift_left = 63 - jiffies_order;
+	s32 final_shift = (priv->timestamp_bit_size - 1) - max_shift_left;
+	u64 tmp;
+
+	if (!priv->timestamp_freq || !priv->timestamp_bit_size)
+		return -1;
+
+	/* The formula is work_delay_jiffies = 2**(bit_size - 1) / ts_frequency * HZ
+	 * using (bit_size - 1) instead of full bit_size to read the counter
+	 * roughly twice per period
+	 */
+	tmp = div_u64((u64)HZ << max_shift_left, priv->timestamp_freq);
+
+	if (final_shift > 0)
+		priv->work_delay_jiffies = tmp << final_shift;
+	else
+		priv->work_delay_jiffies = tmp >> -final_shift;
+
+	if (priv->work_delay_jiffies == 0)
+		return -1;
+
+	if (priv->work_delay_jiffies > CTUCANFD_MAX_WORK_DELAY_SEC * HZ)
+		priv->work_delay_jiffies = CTUCANFD_MAX_WORK_DELAY_SEC * HZ;
+	return 0;
+}
+
+void ctucan_skb_set_timestamp(struct ctucan_priv *priv, struct sk_buff *skb, u64 timestamp)
+{
+	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+	u64 ns;
+
+	ns = timecounter_cyc2time(&priv->tc, timestamp);
+	hwtstamps->hwtstamp = ns_to_ktime(ns);
+}
+
+int ctucan_timestamp_init(struct ctucan_priv *priv)
+{
+	struct cyclecounter *cc = &priv->cc;
+
+	cc->read = ctucan_timestamp_read;
+	cc->mask = CYCLECOUNTER_MASK(priv->timestamp_bit_size);
+	cc->shift = 10;
+	cc->mult = clocksource_hz2mult(priv->timestamp_freq, cc->shift);
+
+	timecounter_init(&priv->tc, &priv->cc, 0);
+
+	INIT_DELAYED_WORK(&priv->timestamp, ctucan_timestamp_work);
+	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
+
+	return 0;
+}
+
+void ctucan_timestamp_stop(struct ctucan_priv *priv)
+{
+	cancel_delayed_work_sync(&priv->timestamp);
+}
-- 
2.25.1

