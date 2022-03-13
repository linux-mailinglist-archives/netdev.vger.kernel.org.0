Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9954D73D0
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 09:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiCMIw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 04:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiCMIww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 04:52:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15616635B
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 00:51:45 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nTJx1-0000S8-6d
        for netdev@vger.kernel.org; Sun, 13 Mar 2022 09:51:43 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 94EC949B40
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 08:51:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 383ED49B26;
        Sun, 13 Mar 2022 08:51:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 35e870bd;
        Sun, 13 Mar 2022 08:51:38 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 03/13] can: mcp251xfd: ram: add helper function for runtime ring size calculation
Date:   Sun, 13 Mar 2022 09:51:28 +0100
Message-Id: <20220313085138.507062-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313085138.507062-1-mkl@pengutronix.de>
References: <20220313085138.507062-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a helper function to calculate the ring configuration
of the controller based on various constraints, like available RAM,
size of RX and TX objects, CAN-mode, number of FIFOs and FIFO depth.

Link: https://lore.kernel.org/20220313083640.501791-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/Makefile        |  1 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c | 97 +++++++++++++++++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h | 57 +++++++++++
 3 files changed, 155 insertions(+)
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h

diff --git a/drivers/net/can/spi/mcp251xfd/Makefile b/drivers/net/can/spi/mcp251xfd/Makefile
index a83d685d64e0..10c4f886d1f7 100644
--- a/drivers/net/can/spi/mcp251xfd/Makefile
+++ b/drivers/net/can/spi/mcp251xfd/Makefile
@@ -6,6 +6,7 @@ mcp251xfd-objs :=
 mcp251xfd-objs += mcp251xfd-chip-fifo.o
 mcp251xfd-objs += mcp251xfd-core.o
 mcp251xfd-objs += mcp251xfd-crc16.o
+mcp251xfd-objs += mcp251xfd-ram.o
 mcp251xfd-objs += mcp251xfd-regmap.o
 mcp251xfd-objs += mcp251xfd-ring.o
 mcp251xfd-objs += mcp251xfd-rx.o
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c
new file mode 100644
index 000000000000..6e7293e50d2c
--- /dev/null
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// mcp251xfd - Microchip MCP251xFD Family CAN controller driver
+//
+// Copyright (c) 2021, 2022 Pengutronix,
+//               Marc Kleine-Budde <kernel@pengutronix.de>
+//
+
+#include "mcp251xfd-ram.h"
+
+static inline u8 can_ram_clamp(const struct can_ram_config *config,
+			       const struct can_ram_obj_config *obj,
+			       u8 val)
+{
+	u8 max;
+
+	max = min_t(u8, obj->max, obj->fifo_num * config->fifo_depth);
+	return clamp(val, obj->min, max);
+}
+
+static u8
+can_ram_rounddown_pow_of_two(const struct can_ram_config *config,
+			     const struct can_ram_obj_config *obj, u8 val)
+{
+	u8 fifo_num = obj->fifo_num;
+	u8 ret = 0, i;
+
+	val = can_ram_clamp(config, obj, val);
+
+	for (i = 0; i < fifo_num && val; i++) {
+		u8 n;
+
+		n = min_t(u8, rounddown_pow_of_two(val),
+			  config->fifo_depth);
+
+		/* skip small FIFOs */
+		if (n < obj->fifo_depth_min)
+			return ret;
+
+		ret += n;
+		val -= n;
+	}
+
+	return ret;
+}
+
+void can_ram_get_layout(struct can_ram_layout *layout,
+			const struct can_ram_config *config,
+			const struct ethtool_ringparam *ring,
+			const bool fd_mode)
+{
+	u8 num_rx, num_tx;
+	u16 ram_free;
+
+	/* default CAN */
+
+	num_tx = config->tx.def[fd_mode];
+	num_tx = can_ram_rounddown_pow_of_two(config, &config->tx, num_tx);
+
+	ram_free = config->size;
+	ram_free -= config->tx.size[fd_mode] * num_tx;
+
+	num_rx = ram_free / config->rx.size[fd_mode];
+
+	layout->default_rx = can_ram_rounddown_pow_of_two(config, &config->rx, num_rx);
+	layout->default_tx = num_tx;
+
+	/* MAX CAN */
+
+	ram_free = config->size;
+	ram_free -= config->tx.size[fd_mode] * config->tx.min;
+	num_rx = ram_free / config->rx.size[fd_mode];
+
+	ram_free = config->size;
+	ram_free -= config->rx.size[fd_mode] * config->rx.min;
+	num_tx = ram_free / config->tx.size[fd_mode];
+
+	layout->max_rx = can_ram_rounddown_pow_of_two(config, &config->rx, num_rx);
+	layout->max_tx = can_ram_rounddown_pow_of_two(config, &config->tx, num_tx);
+
+	/* cur CAN */
+
+	if (ring) {
+		num_rx = can_ram_rounddown_pow_of_two(config, &config->rx, ring->rx_pending);
+
+		ram_free = config->size - config->rx.size[fd_mode] * num_rx;
+		num_tx = ram_free / config->tx.size[fd_mode];
+		num_tx = min_t(u8, ring->tx_pending, num_tx);
+		num_tx = can_ram_rounddown_pow_of_two(config, &config->tx, num_tx);
+
+		layout->cur_rx = num_rx;
+		layout->cur_tx = num_tx;
+	} else {
+		layout->cur_rx = layout->default_rx;
+		layout->cur_tx = layout->default_tx;
+	}
+}
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h
new file mode 100644
index 000000000000..c998a033c9cb
--- /dev/null
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * mcp251xfd - Microchip MCP251xFD Family CAN controller driver
+ *
+ * Copyright (c) 2021, 2022 Pengutronix,
+ *               Marc Kleine-Budde <kernel@pengutronix.de>
+ */
+
+#ifndef _MCP251XFD_RAM_H
+#define _MCP251XFD_RAM_H
+
+#include <linux/ethtool.h>
+
+#define CAN_RAM_NUM_MAX (-1)
+
+enum can_ram_mode {
+	CAN_RAM_MODE_CAN,
+	CAN_RAM_MODE_CANFD,
+	__CAN_RAM_MODE_MAX
+};
+
+struct can_ram_obj_config {
+	u8 size[__CAN_RAM_MODE_MAX];
+
+	u8 def[__CAN_RAM_MODE_MAX];
+	u8 min;
+	u8 max;
+
+	u8 fifo_num;
+	u8 fifo_depth_min;
+};
+
+struct can_ram_config {
+	const struct can_ram_obj_config rx;
+	const struct can_ram_obj_config tx;
+
+	u16 size;
+	u8 fifo_depth;
+};
+
+struct can_ram_layout {
+	u8 default_rx;
+	u8 default_tx;
+
+	u8 max_rx;
+	u8 max_tx;
+
+	u8 cur_rx;
+	u8 cur_tx;
+};
+
+void can_ram_get_layout(struct can_ram_layout *layout,
+			const struct can_ram_config *config,
+			const struct ethtool_ringparam *ring,
+			const bool fd_mode);
+
+#endif
-- 
2.35.1


