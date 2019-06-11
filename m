Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCCCF3D09F
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404649AbfFKPTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:19:02 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:45584 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389686AbfFKPTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:19:02 -0400
Received: from mailhost.synopsys.com (unknown [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E574CC5944;
        Tue, 11 Jun 2019 15:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1560266339; bh=mBpV3DPxMu1zOlFHKdZ74vSrOXCkS01TP7DfWxpo6LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=LMnEfbOGZioUaSW06OOpCrAT9xgC1MBxKvrD8Le3ahACfqkZeUXsE5kY3N0juWaAD
         EaIKtjBUy8DbDSJyICWZFa5Y94Zq2dievNKOO3zTz3svOsc0rccciROPao8ZsMc2vr
         b8lwfUsc4cHAqrqUtQOGFbRwOZOp/WqitSn4aNtexgPK5cZ9vwz/mgrO5h5qeLiN8L
         x5JDD9i85vEmDg/wBz9Z8Z1WGjLpeg/j6Yee0g7tiX8clek2G8TBo1+kAMv7STo2Rx
         K1yDp15Y5PZTXWpfLYWBGJzS0XoAE1/yLe+KWXLYDMKnhsA65+16Z8f+vzf418fYTq
         tm1bF57Y6g6Ug==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 33E35A022E;
        Tue, 11 Jun 2019 15:18:58 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 1584D3FDBE;
        Tue, 11 Jun 2019 17:18:58 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 2/3] net: stmmac: Start adding phylink support
Date:   Tue, 11 Jun 2019 17:18:46 +0200
Message-Id: <7daa1ac5cf56152b9d6c969c24603bc82e0b7d55.1560266175.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1560266175.git.joabreu@synopsys.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
In-Reply-To: <cover.1560266175.git.joabreu@synopsys.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start adding the phylink callbacks.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  4 ++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 48 +++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 0b5c8d74c683..cf0c9f4f347a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -4,6 +4,7 @@ config STMMAC_ETH
 	depends on HAS_IOMEM && HAS_DMA
 	select MII
 	select PHYLIB
+	select PHYLINK
 	select CRC32
 	imply PTP_1588_CLOCK
 	select RESET_CONTROLLER
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index a16ada8b8507..b8386778f6c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -25,6 +25,7 @@
 #include <linux/clk.h>
 #include <linux/stmmac.h>
 #include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/pci.h>
 #include "common.h"
 #include <linux/ptp_clock_kernel.h>
@@ -155,6 +156,9 @@ struct stmmac_priv {
 	struct mii_bus *mii;
 	int mii_irq[PHY_MAX_ADDR];
 
+	struct phylink_config phylink_config;
+	struct phylink *phylink;
+
 	struct stmmac_extra_stats xstats ____cacheline_aligned_in_smp;
 	struct stmmac_safety_stats sstats;
 	struct plat_stmmacenet_data *plat;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6a2f072c0ce3..e2e69cb08fef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -45,6 +45,7 @@
 #include <linux/seq_file.h>
 #endif /* CONFIG_DEBUG_FS */
 #include <linux/net_tstamp.h>
+#include <linux/phylink.h>
 #include <net/pkt_cls.h>
 #include "stmmac_ptp.h"
 #include "stmmac.h"
@@ -848,6 +849,39 @@ static void stmmac_mac_flow_ctrl(struct stmmac_priv *priv, u32 duplex)
 			priv->pause, tx_cnt);
 }
 
+static void stmmac_validate(struct phylink_config *config,
+			    unsigned long *supported,
+			    struct phylink_link_state *state)
+{
+	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+	int tx_cnt = priv->plat->tx_queues_to_use;
+	int max_speed = priv->plat->max_speed;
+
+	/* Cut down 1G if asked to */
+	if ((max_speed > 0) && (max_speed < 1000)) {
+		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 1000baseX_Full);
+	}
+
+	/* Half-Duplex can only work with single queue */
+	if (tx_cnt > 1) {
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 1000baseT_Half);
+	}
+
+	bitmap_andnot(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_andnot(state->advertising, state->advertising, mask,
+		      __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static int stmmac_mac_link_state(struct phylink_config *config,
+				 struct phylink_link_state *state)
+{
+	return -EOPNOTSUPP;
+}
+
 static void stmmac_mac_config(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
@@ -900,6 +934,11 @@ static void stmmac_mac_config(struct net_device *dev)
 	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
 }
 
+static void stmmac_mac_an_restart(struct phylink_config *config)
+{
+	/* Not Supported */
+}
+
 static void stmmac_mac_link_down(struct net_device *dev, bool autoneg)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
@@ -914,6 +953,15 @@ static void stmmac_mac_link_up(struct net_device *dev, bool autoneg)
 	stmmac_mac_set(priv, priv->ioaddr, true);
 }
 
+static const struct phylink_mac_ops __maybe_unused stmmac_phylink_mac_ops = {
+	.validate = stmmac_validate,
+	.mac_link_state = stmmac_mac_link_state,
+	.mac_config = NULL, /* TO BE FILLED */
+	.mac_an_restart = stmmac_mac_an_restart,
+	.mac_link_down = NULL, /* TO BE FILLED */
+	.mac_link_up = NULL, /* TO BE FILLED */
+};
+
 /**
  * stmmac_adjust_link - adjusts the link parameters
  * @dev: net device structure
-- 
2.21.0

