Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B1A1E26D4
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbgEZQX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:23:27 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:41957 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgEZQX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:23:26 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 475854000B;
        Tue, 26 May 2020 16:23:20 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: [PATCH net-next 3/4] net: phy: mscc-miim: improve waiting logic
Date:   Tue, 26 May 2020 18:22:55 +0200
Message-Id: <20200526162256.466885-4-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526162256.466885-1-antoine.tenart@bootlin.com>
References: <20200526162256.466885-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MSCC MIIM MDIO driver uses a waiting logic to wait for the MDIO bus
to be ready to accept next commands. It does so by polling the BUSY
status bit which indicates the MDIO bus has completed all pending
operations. This can take time, and the controller supports writing the
next command as soon as there are no pending commands (which happens
while the MDIO bus is busy completing its current command).

This patch implements this improved logic by adding an helper to poll
the PENDING status bit, and by adjusting where we should wait for the
bus to not be busy or to not be pending.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mdio-mscc-miim.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio-mscc-miim.c b/drivers/net/phy/mdio-mscc-miim.c
index 42119f661452..aed9afa1e8f1 100644
--- a/drivers/net/phy/mdio-mscc-miim.c
+++ b/drivers/net/phy/mdio-mscc-miim.c
@@ -16,6 +16,7 @@
 #include <linux/of_mdio.h>
 
 #define MSCC_MIIM_REG_STATUS		0x0
+#define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
 #define		MSCC_MIIM_STATUS_STAT_BUSY	BIT(3)
 #define MSCC_MIIM_REG_CMD		0x8
 #define		MSCC_MIIM_CMD_OPR_WRITE		BIT(1)
@@ -47,13 +48,23 @@ static int mscc_miim_wait_ready(struct mii_bus *bus)
 				  !(val & MSCC_MIIM_STATUS_STAT_BUSY), 50, 10000);
 }
 
+static int mscc_miim_wait_pending(struct mii_bus *bus)
+{
+	struct mscc_miim_dev *miim = bus->priv;
+	u32 val;
+
+	return readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
+				  !(val & MSCC_MIIM_STATUS_STAT_PENDING),
+				  50, 10000);
+}
+
 static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 {
 	struct mscc_miim_dev *miim = bus->priv;
 	u32 val;
 	int ret;
 
-	ret = mscc_miim_wait_ready(bus);
+	ret = mscc_miim_wait_pending(bus);
 	if (ret)
 		goto out;
 
@@ -82,7 +93,7 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 	struct mscc_miim_dev *miim = bus->priv;
 	int ret;
 
-	ret = mscc_miim_wait_ready(bus);
+	ret = mscc_miim_wait_pending(bus);
 	if (ret < 0)
 		goto out;
 
-- 
2.26.2

