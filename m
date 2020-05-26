Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9231E26D9
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgEZQXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:23:33 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:47487 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbgEZQX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:23:27 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id DB1491BF20A;
        Tue, 26 May 2020 16:23:24 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: [PATCH net-next 4/4] net: phy: mscc-miim: read poll when high resolution timers are disabled
Date:   Tue, 26 May 2020 18:22:56 +0200
Message-Id: <20200526162256.466885-5-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526162256.466885-1-antoine.tenart@bootlin.com>
References: <20200526162256.466885-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses a read polling mechanism to check the status of the MDIO
bus, to know if it is ready to accept next commands. This polling
mechanism uses usleep_delay() under the hood between reads which is fine
as long as high resolution timers are enabled. Otherwise the delays will
end up to be much longer than expected.

This patch fixes this by using udelay() under the hood when
CONFIG_HIGH_RES_TIMERS isn't enabled. This increases CPU usage.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/Kconfig          |  3 ++-
 drivers/net/phy/mdio-mscc-miim.c | 22 +++++++++++++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 2a32f26ead0b..047c27087b10 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -184,7 +184,8 @@ config MDIO_MSCC_MIIM
 	depends on HAS_IOMEM
 	help
 	  This driver supports the MIIM (MDIO) interface found in the network
-	  switches of the Microsemi SoCs
+	  switches of the Microsemi SoCs; it is recommended to switch on
+	  CONFIG_HIGH_RES_TIMERS
 
 config MDIO_MVUSB
 	tristate "Marvell USB to MDIO Adapter"
diff --git a/drivers/net/phy/mdio-mscc-miim.c b/drivers/net/phy/mdio-mscc-miim.c
index aed9afa1e8f1..11f583fd4611 100644
--- a/drivers/net/phy/mdio-mscc-miim.c
+++ b/drivers/net/phy/mdio-mscc-miim.c
@@ -39,13 +39,25 @@ struct mscc_miim_dev {
 	void __iomem *phy_regs;
 };
 
+/* When high resolution timers aren't built-in: we can't use usleep_range() as
+ * we would sleep way too long. Use udelay() instead.
+ */
+#define mscc_readl_poll_timeout(addr, val, cond, delay_us, timeout_us)	\
+({									\
+	if (!IS_ENABLED(CONFIG_HIGH_RES_TIMERS))			\
+		readl_poll_timeout_atomic(addr, val, cond, delay_us,	\
+					  timeout_us);			\
+	readl_poll_timeout(addr, val, cond, delay_us, timeout_us);	\
+})
+
 static int mscc_miim_wait_ready(struct mii_bus *bus)
 {
 	struct mscc_miim_dev *miim = bus->priv;
 	u32 val;
 
-	return readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
-				  !(val & MSCC_MIIM_STATUS_STAT_BUSY), 50, 10000);
+	return mscc_readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
+				       !(val & MSCC_MIIM_STATUS_STAT_BUSY), 50,
+				       10000);
 }
 
 static int mscc_miim_wait_pending(struct mii_bus *bus)
@@ -53,9 +65,9 @@ static int mscc_miim_wait_pending(struct mii_bus *bus)
 	struct mscc_miim_dev *miim = bus->priv;
 	u32 val;
 
-	return readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
-				  !(val & MSCC_MIIM_STATUS_STAT_PENDING),
-				  50, 10000);
+	return mscc_readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
+				       !(val & MSCC_MIIM_STATUS_STAT_PENDING),
+				       50, 10000);
 }
 
 static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
-- 
2.26.2

