Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93616422A6
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 06:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiLEFWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 00:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiLEFWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 00:22:54 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081E29FC8
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 21:22:53 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p23w4-0004GE-S1; Mon, 05 Dec 2022 06:22:37 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1p23w2-002ONA-67; Mon, 05 Dec 2022 06:22:34 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1p23w1-00BtJU-TF; Mon, 05 Dec 2022 06:22:33 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v7 1/6] net: dsa: microchip: move max mtu to one location
Date:   Mon,  5 Dec 2022 06:22:27 +0100
Message-Id: <20221205052232.2834166-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221205052232.2834166-1-o.rempel@pengutronix.de>
References: <20221205052232.2834166-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are no HW specific registers, so we can process all of them
in one location.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Tested-by: Arun Ramadoss <arun.ramadoss@microchip.com> (KSZ9893 and LAN937x)
---
 drivers/net/dsa/microchip/ksz9477.c     |  5 -----
 drivers/net/dsa/microchip/ksz9477.h     |  1 -
 drivers/net/dsa/microchip/ksz9477_reg.h |  2 --
 drivers/net/dsa/microchip/ksz_common.c  | 22 +++++++++++++++++-----
 drivers/net/dsa/microchip/ksz_common.h  |  3 ++-
 5 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 0d6b40968657..602d00671bef 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -60,11 +60,6 @@ int ksz9477_change_mtu(struct ksz_device *dev, int port, int mtu)
 				  REG_SW_MTU_MASK, max_frame);
 }
 
-int ksz9477_max_mtu(struct ksz_device *dev, int port)
-{
-	return KSZ9477_MAX_FRAME_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;
-}
-
 static int ksz9477_wait_vlan_ctrl_ready(struct ksz_device *dev)
 {
 	unsigned int val;
diff --git a/drivers/net/dsa/microchip/ksz9477.h b/drivers/net/dsa/microchip/ksz9477.h
index 00862c4cfb7f..7c5bb3032772 100644
--- a/drivers/net/dsa/microchip/ksz9477.h
+++ b/drivers/net/dsa/microchip/ksz9477.h
@@ -50,7 +50,6 @@ int ksz9477_mdb_add(struct ksz_device *dev, int port,
 int ksz9477_mdb_del(struct ksz_device *dev, int port,
 		    const struct switchdev_obj_port_mdb *mdb, struct dsa_db db);
 int ksz9477_change_mtu(struct ksz_device *dev, int port, int mtu);
-int ksz9477_max_mtu(struct ksz_device *dev, int port);
 void ksz9477_config_cpu_port(struct dsa_switch *ds);
 int ksz9477_enable_stp_addr(struct ksz_device *dev);
 int ksz9477_reset_switch(struct ksz_device *dev);
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 53c68d286dd3..cc457fa64939 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1615,6 +1615,4 @@
 #define PTP_TRIG_UNIT_M			(BIT(MAX_TRIG_UNIT) - 1)
 #define PTP_TS_UNIT_M			(BIT(MAX_TIMESTAMP_UNIT) - 1)
 
-#define KSZ9477_MAX_FRAME_SIZE		9000
-
 #endif /* KSZ9477_REGS_H */
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 8c8db315317d..49a5a236d958 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -14,6 +14,7 @@
 #include <linux/phy.h>
 #include <linux/etherdevice.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/of_mdio.h>
@@ -206,7 +207,6 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.mdb_add = ksz9477_mdb_add,
 	.mdb_del = ksz9477_mdb_del,
 	.change_mtu = ksz9477_change_mtu,
-	.max_mtu = ksz9477_max_mtu,
 	.phylink_mac_link_up = ksz9477_phylink_mac_link_up,
 	.config_cpu_port = ksz9477_config_cpu_port,
 	.enable_stp_addr = ksz9477_enable_stp_addr,
@@ -243,7 +243,6 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.mdb_add = ksz9477_mdb_add,
 	.mdb_del = ksz9477_mdb_del,
 	.change_mtu = lan937x_change_mtu,
-	.max_mtu = ksz9477_max_mtu,
 	.phylink_mac_link_up = ksz9477_phylink_mac_link_up,
 	.config_cpu_port = lan937x_config_cpu_port,
 	.enable_stp_addr = ksz9477_enable_stp_addr,
@@ -2500,10 +2499,23 @@ static int ksz_max_mtu(struct dsa_switch *ds, int port)
 {
 	struct ksz_device *dev = ds->priv;
 
-	if (!dev->dev_ops->max_mtu)
-		return -EOPNOTSUPP;
+	switch (dev->chip_id) {
+	case KSZ8563_CHIP_ID:
+	case KSZ9477_CHIP_ID:
+	case KSZ9563_CHIP_ID:
+	case KSZ9567_CHIP_ID:
+	case KSZ9893_CHIP_ID:
+	case KSZ9896_CHIP_ID:
+	case KSZ9897_CHIP_ID:
+	case LAN9370_CHIP_ID:
+	case LAN9371_CHIP_ID:
+	case LAN9372_CHIP_ID:
+	case LAN9373_CHIP_ID:
+	case LAN9374_CHIP_ID:
+		return KSZ9477_MAX_FRAME_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;
+	}
 
-	return dev->dev_ops->max_mtu(dev, port);
+	return -EOPNOTSUPP;
 }
 
 static void ksz_set_xmii(struct ksz_device *dev, int port,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c6726cbd5465..27c26ee15af4 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -322,7 +322,6 @@ struct ksz_dev_ops {
 	void (*get_caps)(struct ksz_device *dev, int port,
 			 struct phylink_config *config);
 	int (*change_mtu)(struct ksz_device *dev, int port, int mtu);
-	int (*max_mtu)(struct ksz_device *dev, int port);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	void (*phylink_mac_config)(struct ksz_device *dev, int port,
@@ -588,6 +587,8 @@ static inline int is_lan937x(struct ksz_device *dev)
 
 #define PORT_SRC_PHY_INT		1
 
+#define KSZ9477_MAX_FRAME_SIZE		9000
+
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2
-- 
2.30.2

