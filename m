Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4E7C2F06
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 10:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733069AbfJAIlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 04:41:08 -0400
Received: from hermes.aosc.io ([199.195.250.187]:52092 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbfJAIlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 04:41:06 -0400
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: icenowy@aosc.io)
        by hermes.aosc.io (Postfix) with ESMTPSA id 5342182B0F;
        Tue,  1 Oct 2019 08:32:12 +0000 (UTC)
From:   Icenowy Zheng <icenowy@aosc.io>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, Icenowy Zheng <icenowy@aosc.io>
Subject: [PATCH 2/3] net: phy: realtek: add config hack for broken RTL8211E on Pine64+ boards
Date:   Tue,  1 Oct 2019 16:29:11 +0800
Message-Id: <20191001082912.12905-3-icenowy@aosc.io>
In-Reply-To: <20191001082912.12905-1-icenowy@aosc.io>
References: <20191001082912.12905-1-icenowy@aosc.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some RTL8211E chips have broken GbE function, which needs a hack to
fix.

Currently only some Pine64+ boards are known to used this broken batch
of RTL8211E chips.

Enable this hack when a certain device tree property is set.

As this hack is not documented on the datasheet at all, it contains
magic numbers, and could not be revealed. These magic numbers are
received from Realtek via Pine64.

Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
---
 drivers/net/phy/realtek.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 677c45985338..f696f2085368 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -9,6 +9,7 @@
  * Copyright (c) 2004 Freescale Semiconductor, Inc.
  */
 #include <linux/bitops.h>
+#include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/module.h>
 
@@ -32,6 +33,12 @@
 #define RTL8211E_TX_DELAY			BIT(1)
 #define RTL8211E_RX_DELAY			BIT(2)
 #define RTL8211E_MODE_MII_GMII			BIT(3)
+/* The following number resides in the same register with
+ * the delay bits and mode bit above. However, no known
+ * document can explain this, and this value is directly
+ * received from Realtek via Pine64.
+ */
+#define RTL8211E_CONF_MAGIC_PINE64		0xb400
 
 #define RTL8201F_ISR				0x1e
 #define RTL8201F_IER				0x13
@@ -196,6 +203,7 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 {
 	int ret = 0, oldpage;
 	u16 val;
+	struct device_node *of_node = phydev->mdio.dev.of_node;
 
 	/* enable TX/RX delay for rgmii-* modes, and disable them for rgmii. */
 	switch (phydev->interface) {
@@ -234,6 +242,12 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 	ret = __phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
 			   val);
 
+	if (of_node &&
+	    of_property_read_bool(of_node, "realtek,config-magic-for-pine64")) {
+		ret = __phy_modify(phydev, 0x1c, GENMASK(15, 8),
+				   RTL8211E_CONF_MAGIC_PINE64);
+	}
+
 err_restore_page:
 	return phy_restore_page(phydev, oldpage, ret);
 }
-- 
2.21.0

