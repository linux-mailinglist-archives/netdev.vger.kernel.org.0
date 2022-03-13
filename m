Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99794D73D6
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 09:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbiCMIxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 04:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbiCMIwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 04:52:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA633E5CE
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 00:51:46 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nTJx2-0000Tj-Kp
        for netdev@vger.kernel.org; Sun, 13 Mar 2022 09:51:44 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D03FD49B53
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 08:51:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6999D49B36;
        Sun, 13 Mar 2022 08:51:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6704b588;
        Sun, 13 Mar 2022 08:51:38 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 05/13] can: mcp251xfd: ethtool: add support
Date:   Sun, 13 Mar 2022 09:51:30 +0100
Message-Id: <20220313085138.507062-6-mkl@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds basic ethtool support (to query the current and
maximum ring parameters) to the driver.

Link: https://lore.kernel.org/20220313083640.501791-5-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/Makefile        |  1 +
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    |  2 ++
 .../net/can/spi/mcp251xfd/mcp251xfd-ethtool.c | 35 +++++++++++++++++++
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    |  4 +++
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |  2 ++
 5 files changed, 44 insertions(+)
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c

diff --git a/drivers/net/can/spi/mcp251xfd/Makefile b/drivers/net/can/spi/mcp251xfd/Makefile
index 10c4f886d1f7..94d7de954294 100644
--- a/drivers/net/can/spi/mcp251xfd/Makefile
+++ b/drivers/net/can/spi/mcp251xfd/Makefile
@@ -6,6 +6,7 @@ mcp251xfd-objs :=
 mcp251xfd-objs += mcp251xfd-chip-fifo.o
 mcp251xfd-objs += mcp251xfd-core.o
 mcp251xfd-objs += mcp251xfd-crc16.o
+mcp251xfd-objs += mcp251xfd-ethtool.o
 mcp251xfd-objs += mcp251xfd-ram.o
 mcp251xfd-objs += mcp251xfd-regmap.o
 mcp251xfd-objs += mcp251xfd-ring.o
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 3da17cadbd63..ebb4dc999bac 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1871,6 +1871,8 @@ static int mcp251xfd_register(struct mcp251xfd_priv *priv)
 	if (err)
 		goto out_chip_sleep;
 
+	mcp251xfd_ethtool_init(priv);
+
 	err = register_candev(ndev);
 	if (err)
 		goto out_chip_sleep;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
new file mode 100644
index 000000000000..4131185eaf5a
--- /dev/null
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// mcp251xfd - Microchip MCP251xFD Family CAN controller driver
+//
+// Copyright (c) 2021, 2022 Pengutronix,
+//               Marc Kleine-Budde <kernel@pengutronix.de>
+//
+
+#include <linux/ethtool.h>
+
+#include "mcp251xfd.h"
+
+static void
+mcp251xfd_ring_get_ringparam(struct net_device *ndev,
+			     struct ethtool_ringparam *ring,
+			     struct kernel_ethtool_ringparam *kernel_ring,
+			     struct netlink_ext_ack *extack)
+{
+	const struct mcp251xfd_priv *priv = netdev_priv(ndev);
+
+	ring->rx_max_pending = MCP251XFD_RX_OBJ_NUM_MAX;
+	ring->tx_max_pending = MCP251XFD_TX_OBJ_NUM_MAX;
+
+	ring->rx_pending = priv->rx_obj_num;
+	ring->tx_pending = priv->tx->obj_num;
+}
+
+static const struct ethtool_ops mcp251xfd_ethtool_ops = {
+	.get_ringparam = mcp251xfd_ring_get_ringparam,
+};
+
+void mcp251xfd_ethtool_init(struct mcp251xfd_priv *priv)
+{
+	priv->ndev->ethtool_ops = &mcp251xfd_ethtool_ops;
+}
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index b1c4d9b19347..e540c97b4160 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -304,6 +304,8 @@ int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 		rx_obj_size = sizeof(struct mcp251xfd_hw_rx_obj_can);
 	}
 
+	priv->rx_obj_num = 0;
+
 	tx_ring = priv->tx;
 	tx_ring->obj_num = tx_obj_num;
 	tx_ring->obj_size = tx_obj_size;
@@ -320,6 +322,8 @@ int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 		rx_obj_num = min(1 << (fls(rx_obj_num) - 1),
 				 MCP251XFD_RX_OBJ_NUM_MAX);
 
+		priv->rx_obj_num += rx_obj_num;
+
 		rx_ring = kzalloc(sizeof(*rx_ring) + rx_obj_size * rx_obj_num,
 				  GFP_KERNEL);
 		if (!rx_ring) {
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 87cc13d455c1..5c7a672464b1 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -610,6 +610,7 @@ struct mcp251xfd_priv {
 	struct mcp251xfd_tx_ring tx[MCP251XFD_FIFO_TX_NUM];
 
 	u8 rx_ring_num;
+	u8 rx_obj_num;
 
 	struct mcp251xfd_ecc ecc;
 	struct mcp251xfd_regs_status regs_status;
@@ -891,6 +892,7 @@ int mcp251xfd_chip_fifo_init(const struct mcp251xfd_priv *priv);
 u16 mcp251xfd_crc16_compute2(const void *cmd, size_t cmd_size,
 			     const void *data, size_t data_size);
 u16 mcp251xfd_crc16_compute(const void *data, size_t data_size);
+void mcp251xfd_ethtool_init(struct mcp251xfd_priv *priv);
 int mcp251xfd_regmap_init(struct mcp251xfd_priv *priv);
 int mcp251xfd_ring_init(struct mcp251xfd_priv *priv);
 void mcp251xfd_ring_free(struct mcp251xfd_priv *priv);
-- 
2.35.1


