Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D39234E6BC
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhC3LrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbhC3Lqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B98C061764
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpX-0006W8-9u
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:43 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 05300603EC1
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 76338603E36;
        Tue, 30 Mar 2021 11:46:12 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d928a404;
        Tue, 30 Mar 2021 11:46:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 26/39] can: mcp251xfd: add HW timestamp infrastructure
Date:   Tue, 30 Mar 2021 13:45:46 +0200
Message-Id: <20210330114559.1114855-27-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add the HW timestamping infrastructure. The mcp251xfd has a
free running timer of 32 bit width, running at max 40MHz, which wraps
around every 107 seconds. The current timestamp is latched into RX and
TEF objects automatically be the CAN controller.

This patch sets up a cyclecounter, timecounter and delayed worker
infrastructure (which runs every 45 seconds) to convert the timer into
a proper 64 bit based ns timestamp.

Link: https://lore.kernel.org/r/20210304160328.2752293-6-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/Makefile        |  1 +
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    |  3 +
 .../can/spi/mcp251xfd/mcp251xfd-timestamp.c   | 71 +++++++++++++++++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     | 13 ++++
 4 files changed, 88 insertions(+)
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-timestamp.c

diff --git a/drivers/net/can/spi/mcp251xfd/Makefile b/drivers/net/can/spi/mcp251xfd/Makefile
index e87e668a08a0..3cba3b9447ea 100644
--- a/drivers/net/can/spi/mcp251xfd/Makefile
+++ b/drivers/net/can/spi/mcp251xfd/Makefile
@@ -6,5 +6,6 @@ mcp251xfd-objs :=
 mcp251xfd-objs += mcp251xfd-core.o
 mcp251xfd-objs += mcp251xfd-crc16.o
 mcp251xfd-objs += mcp251xfd-regmap.o
+mcp251xfd-objs += mcp251xfd-timestamp.o
 
 mcp251xfd-$(CONFIG_DEV_COREDUMP) += mcp251xfd-dump.o
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 41e322954d9a..6cdc05b02403 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2493,6 +2493,7 @@ static int mcp251xfd_open(struct net_device *ndev)
 	if (err)
 		goto out_transceiver_disable;
 
+	mcp251xfd_timestamp_init(priv);
 	can_rx_offload_enable(&priv->offload);
 
 	err = request_threaded_irq(spi->irq, NULL, mcp251xfd_irq,
@@ -2513,6 +2514,7 @@ static int mcp251xfd_open(struct net_device *ndev)
 	free_irq(spi->irq, priv);
  out_can_rx_offload_disable:
 	can_rx_offload_disable(&priv->offload);
+	mcp251xfd_timestamp_stop(priv);
  out_transceiver_disable:
 	mcp251xfd_transceiver_disable(priv);
  out_mcp251xfd_ring_free:
@@ -2534,6 +2536,7 @@ static int mcp251xfd_stop(struct net_device *ndev)
 	mcp251xfd_chip_interrupts_disable(priv);
 	free_irq(ndev->irq, priv);
 	can_rx_offload_disable(&priv->offload);
+	mcp251xfd_timestamp_stop(priv);
 	mcp251xfd_chip_stop(priv, CAN_STATE_STOPPED);
 	mcp251xfd_transceiver_disable(priv);
 	mcp251xfd_ring_free(priv);
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-timestamp.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-timestamp.c
new file mode 100644
index 000000000000..ed3169274d24
--- /dev/null
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-timestamp.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// mcp251xfd - Microchip MCP251xFD Family CAN controller driver
+//
+// Copyright (c) 2021 Pengutronix,
+//               Marc Kleine-Budde <kernel@pengutronix.de>
+//
+
+#include <linux/clocksource.h>
+#include <linux/workqueue.h>
+
+#include "mcp251xfd.h"
+
+static u64 mcp251xfd_timestamp_read(const struct cyclecounter *cc)
+{
+	struct mcp251xfd_priv *priv;
+	u32 timestamp = 0;
+	int err;
+
+	priv = container_of(cc, struct mcp251xfd_priv, cc);
+	err = mcp251xfd_get_timestamp(priv, &timestamp);
+	if (err)
+		netdev_err(priv->ndev,
+			   "Error %d while reading timestamp. HW timestamps may be inaccurate.",
+			   err);
+
+	return timestamp;
+}
+
+static void mcp251xfd_timestamp_work(struct work_struct *work)
+{
+	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct mcp251xfd_priv *priv;
+
+	priv = container_of(delayed_work, struct mcp251xfd_priv, timestamp);
+	timecounter_read(&priv->tc);
+
+	schedule_delayed_work(&priv->timestamp,
+			      MCP251XFD_TIMESTAMP_WORK_DELAY_SEC * HZ);
+}
+
+void mcp251xfd_skb_set_timestamp(struct mcp251xfd_priv *priv,
+				 struct sk_buff *skb, u32 timestamp)
+{
+	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+	u64 ns;
+
+	ns = timecounter_cyc2time(&priv->tc, timestamp);
+	hwtstamps->hwtstamp = ns_to_ktime(ns);
+}
+
+void mcp251xfd_timestamp_init(struct mcp251xfd_priv *priv)
+{
+	struct cyclecounter *cc = &priv->cc;
+
+	cc->read = mcp251xfd_timestamp_read;
+	cc->mask = CYCLECOUNTER_MASK(32);
+	cc->shift = 1;
+	cc->mult = clocksource_hz2mult(priv->can.clock.freq, cc->shift);
+
+	timecounter_init(&priv->tc, &priv->cc, ktime_get_real_ns());
+
+	INIT_DELAYED_WORK(&priv->timestamp, mcp251xfd_timestamp_work);
+	schedule_delayed_work(&priv->timestamp,
+			      MCP251XFD_TIMESTAMP_WORK_DELAY_SEC * HZ);
+}
+
+void mcp251xfd_timestamp_stop(struct mcp251xfd_priv *priv)
+{
+	cancel_delayed_work_sync(&priv->timestamp);
+}
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 074c5adf9b94..1002f3902ad2 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -19,6 +19,8 @@
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/spi/spi.h>
+#include <linux/timecounter.h>
+#include <linux/workqueue.h>
 
 /* MPC251x registers */
 
@@ -395,6 +397,9 @@
 #define MCP251XFD_SYSCLOCK_HZ_MAX 40000000
 #define MCP251XFD_SYSCLOCK_HZ_MIN 1000000
 #define MCP251XFD_SPICLOCK_HZ_MAX 20000000
+#define MCP251XFD_TIMESTAMP_WORK_DELAY_SEC 45
+static_assert(MCP251XFD_TIMESTAMP_WORK_DELAY_SEC <
+	      CYCLECOUNTER_MASK(32) / MCP251XFD_SYSCLOCK_HZ_MAX / 2);
 #define MCP251XFD_OSC_PLL_MULTIPLIER 10
 #define MCP251XFD_OSC_STAB_SLEEP_US (3 * USEC_PER_MSEC)
 #define MCP251XFD_OSC_STAB_TIMEOUT_US (10 * MCP251XFD_OSC_STAB_SLEEP_US)
@@ -596,6 +601,10 @@ struct mcp251xfd_priv {
 	struct mcp251xfd_ecc ecc;
 	struct mcp251xfd_regs_status regs_status;
 
+	struct cyclecounter cc;
+	struct timecounter tc;
+	struct delayed_work timestamp;
+
 	struct gpio_desc *rx_int;
 	struct clk *clk;
 	struct regulator *reg_vdd;
@@ -844,6 +853,10 @@ int mcp251xfd_regmap_init(struct mcp251xfd_priv *priv);
 u16 mcp251xfd_crc16_compute2(const void *cmd, size_t cmd_size,
 			     const void *data, size_t data_size);
 u16 mcp251xfd_crc16_compute(const void *data, size_t data_size);
+void mcp251xfd_skb_set_timestamp(struct mcp251xfd_priv *priv,
+				 struct sk_buff *skb, u32 timestamp);
+void mcp251xfd_timestamp_init(struct mcp251xfd_priv *priv);
+void mcp251xfd_timestamp_stop(struct mcp251xfd_priv *priv);
 
 #if IS_ENABLED(CONFIG_DEV_COREDUMP)
 void mcp251xfd_dump(const struct mcp251xfd_priv *priv);
-- 
2.30.2


