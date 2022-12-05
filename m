Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313416422A7
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 06:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiLEFW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 00:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiLEFWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 00:22:54 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73C66256
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 21:22:52 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p23w4-0004GF-Rz; Mon, 05 Dec 2022 06:22:36 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1p23w2-002ONE-9z; Mon, 05 Dec 2022 06:22:35 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1p23w1-00BtJw-V4; Mon, 05 Dec 2022 06:22:33 +0100
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
Subject: [PATCH net-next v7 4/6] net: dsa: microchip: ksz8: add MTU configuration support
Date:   Mon,  5 Dec 2022 06:22:30 +0100
Message-Id: <20221205052232.2834166-5-o.rempel@pengutronix.de>
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

Make MTU configurable on KSZ87xx and KSZ88xx series of switches.

Before this patch, pre-configured behavior was different on different
switch series, due to opposite meaning of the same bit:
- KSZ87xx: Reg 4, Bit 1 - if 1, max frame size is 1532; if 0 - 1514
- KSZ88xx: Reg 4, Bit 1 - if 1, max frame size is 1514; if 0 - 1532

Since the code was telling "... SW_LEGAL_PACKET_DISABLE, true)", I
assume, the idea was to set max frame size to 1532.

With this patch, by setting MTU size 1500, both switch series will be
configured to the 1532 frame limit.

This patch was tested on KSZ8873.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/ksz8.h        |  1 +
 drivers/net/dsa/microchip/ksz8795.c     | 53 ++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz8795_reg.h |  3 ++
 drivers/net/dsa/microchip/ksz_common.c  |  7 ++++
 drivers/net/dsa/microchip/ksz_common.h  |  4 ++
 5 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index 8582b4b67d98..ea05abfbd51d 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -57,5 +57,6 @@ int ksz8_reset_switch(struct ksz_device *dev);
 int ksz8_switch_detect(struct ksz_device *dev);
 int ksz8_switch_init(struct ksz_device *dev);
 void ksz8_switch_exit(struct ksz_device *dev);
+int ksz8_change_mtu(struct ksz_device *dev, int port, int mtu);
 
 #endif
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index bd3b133e7085..d01bfd609130 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -76,6 +76,57 @@ int ksz8_reset_switch(struct ksz_device *dev)
 	return 0;
 }
 
+static int ksz8863_change_mtu(struct ksz_device *dev, int frame_size)
+{
+	u8 ctrl2 = 0;
+
+	if (frame_size <= KSZ8_LEGAL_PACKET_SIZE)
+		ctrl2 |= KSZ8863_LEGAL_PACKET_ENABLE;
+	else if (frame_size > KSZ8863_NORMAL_PACKET_SIZE)
+		ctrl2 |= KSZ8863_HUGE_PACKET_ENABLE;
+
+	return ksz_rmw8(dev, REG_SW_CTRL_2, KSZ8863_LEGAL_PACKET_ENABLE |
+			KSZ8863_HUGE_PACKET_ENABLE, ctrl2);
+}
+
+static int ksz8795_change_mtu(struct ksz_device *dev, int frame_size)
+{
+	u8 ctrl1 = 0, ctrl2 = 0;
+	int ret;
+
+	if (frame_size > KSZ8_LEGAL_PACKET_SIZE)
+		ctrl2 |= SW_LEGAL_PACKET_DISABLE;
+	else if (frame_size > KSZ8863_NORMAL_PACKET_SIZE)
+		ctrl1 |= SW_HUGE_PACKET;
+
+	ret = ksz_rmw8(dev, REG_SW_CTRL_1, SW_HUGE_PACKET, ctrl1);
+	if (ret)
+		return ret;
+
+	return ksz_rmw8(dev, REG_SW_CTRL_2, SW_LEGAL_PACKET_DISABLE, ctrl2);
+}
+
+int ksz8_change_mtu(struct ksz_device *dev, int port, int mtu)
+{
+	u16 frame_size;
+
+	if (!dsa_is_cpu_port(dev->ds, port))
+		return 0;
+
+	frame_size = mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
+
+	switch (dev->chip_id) {
+	case KSZ8795_CHIP_ID:
+	case KSZ8794_CHIP_ID:
+	case KSZ8765_CHIP_ID:
+		return ksz8795_change_mtu(dev, frame_size);
+	case KSZ8830_CHIP_ID:
+		return ksz8863_change_mtu(dev, frame_size);
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static void ksz8795_set_prio_queue(struct ksz_device *dev, int port, int queue)
 {
 	u8 hi, lo;
@@ -1233,8 +1284,6 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
 	masks = dev->info->masks;
 	regs = dev->info->regs;
 
-	/* Switch marks the maximum frame with extra byte as oversize. */
-	ksz_cfg(dev, REG_SW_CTRL_2, SW_LEGAL_PACKET_DISABLE, true);
 	ksz_cfg(dev, regs[S_TAIL_TAG_CTRL], masks[SW_TAIL_TAG_ENABLE], true);
 
 	p = &dev->ports[dev->cpu_port];
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 77487d611824..7a57c6088f80 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -48,6 +48,9 @@
 #define NO_EXC_COLLISION_DROP		BIT(3)
 #define SW_LEGAL_PACKET_DISABLE		BIT(1)
 
+#define KSZ8863_HUGE_PACKET_ENABLE	BIT(2)
+#define KSZ8863_LEGAL_PACKET_ENABLE	BIT(1)
+
 #define REG_SW_CTRL_3			0x05
  #define WEIGHTED_FAIR_QUEUE_ENABLE	BIT(3)
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 49a5a236d958..f39b041765fb 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -172,6 +172,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.reset = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
+	.change_mtu = ksz8_change_mtu,
 };
 
 static void ksz9477_phylink_mac_link_up(struct ksz_device *dev, int port,
@@ -2500,6 +2501,12 @@ static int ksz_max_mtu(struct dsa_switch *ds, int port)
 	struct ksz_device *dev = ds->priv;
 
 	switch (dev->chip_id) {
+	case KSZ8795_CHIP_ID:
+	case KSZ8794_CHIP_ID:
+	case KSZ8765_CHIP_ID:
+		return KSZ8795_HUGE_PACKET_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;
+	case KSZ8830_CHIP_ID:
+		return KSZ8863_HUGE_PACKET_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;
 	case KSZ8563_CHIP_ID:
 	case KSZ9477_CHIP_ID:
 	case KSZ9563_CHIP_ID:
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 5f404a444ce1..cb27f5a180c7 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -591,6 +591,10 @@ static inline int is_lan937x(struct ksz_device *dev)
 
 #define PORT_SRC_PHY_INT		1
 
+#define KSZ8795_HUGE_PACKET_SIZE	2000
+#define KSZ8863_HUGE_PACKET_SIZE	1916
+#define KSZ8863_NORMAL_PACKET_SIZE	1536
+#define KSZ8_LEGAL_PACKET_SIZE		1518
 #define KSZ9477_MAX_FRAME_SIZE		9000
 
 /* Regmap tables generation */
-- 
2.30.2

