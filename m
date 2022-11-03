Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7488617995
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiKCJOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiKCJNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:13:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2DCF029
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 02:13:19 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oqWHa-0004jI-CN; Thu, 03 Nov 2022 10:13:06 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oqWHY-0022Wt-Od; Thu, 03 Nov 2022 10:13:03 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oqWHX-0076Tw-7h; Thu, 03 Nov 2022 10:13:03 +0100
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
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: add MTU configuration support
Date:   Thu,  3 Nov 2022 10:13:02 +0100
Message-Id: <20221103091302.1693161-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
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
---
 drivers/net/dsa/microchip/ksz8.h        |  2 +
 drivers/net/dsa/microchip/ksz8795.c     | 74 ++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz8795_reg.h |  9 +++
 drivers/net/dsa/microchip/ksz_common.c  |  2 +
 4 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index 8582b4b67d98..027b92f5fa73 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -57,5 +57,7 @@ int ksz8_reset_switch(struct ksz_device *dev);
 int ksz8_switch_detect(struct ksz_device *dev);
 int ksz8_switch_init(struct ksz_device *dev);
 void ksz8_switch_exit(struct ksz_device *dev);
+int ksz8_change_mtu(struct ksz_device *dev, int port, int mtu);
+int ksz8_max_mtu(struct ksz_device *dev, int port);
 
 #endif
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index bd3b133e7085..fd2539aabb2c 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -76,6 +76,78 @@ int ksz8_reset_switch(struct ksz_device *dev)
 	return 0;
 }
 
+static int ksz8863_change_mtu(struct ksz_device *dev, int port, int max_frame)
+{
+	u8 ctrl2 = 0;
+
+	if (max_frame <= KSZ8863_LEGAL_PACKET_SIZE)
+		ctrl2 |= KSZ8863_LEGAL_PACKET_ENABLE;
+	else if (max_frame > KSZ8863_NORMAL_PACKET_SIZE)
+		ctrl2 |= KSZ8863_HUGE_PACKET_ENABLE;
+
+	return regmap_update_bits(dev->regmap[0], REG_SW_CTRL_2,
+				  KSZ8863_LEGAL_PACKET_ENABLE
+				  | KSZ8863_HUGE_PACKET_ENABLE, ctrl2);
+}
+
+static int ksz8795_change_mtu(struct ksz_device *dev, int port, int max_frame)
+{
+	u8 ctrl1 = 0, ctrl2 = 0;
+	int ret;
+
+	if (max_frame > KSZ8863_LEGAL_PACKET_SIZE)
+		ctrl2 |= SW_LEGAL_PACKET_DISABLE;
+	else if (max_frame > KSZ8863_NORMAL_PACKET_SIZE)
+		ctrl1 |= SW_HUGE_PACKET;
+
+	ret = regmap_update_bits(dev->regmap[0], REG_SW_CTRL_1,
+				 SW_HUGE_PACKET, ctrl1);
+	if (ret)
+		return ret;
+
+	return regmap_update_bits(dev->regmap[0], REG_SW_CTRL_2,
+				 SW_LEGAL_PACKET_DISABLE, ctrl2);
+}
+
+int ksz8_change_mtu(struct ksz_device *dev, int port, int mtu)
+{
+	u16 frame_size, max_frame = 0;
+	int i;
+
+	frame_size = mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
+
+	/* Cache the per-port MTU setting */
+	dev->ports[port].max_frame = frame_size;
+
+	for (i = 0; i < dev->info->port_cnt; i++)
+		max_frame = max(max_frame, dev->ports[i].max_frame);
+
+	switch (dev->chip_id) {
+	case KSZ8795_CHIP_ID:
+	case KSZ8794_CHIP_ID:
+	case KSZ8765_CHIP_ID:
+		return ksz8795_change_mtu(dev, port, max_frame);
+	case KSZ8830_CHIP_ID:
+		return ksz8863_change_mtu(dev, port, max_frame);
+	}
+
+	return -EOPNOTSUPP;
+}
+
+int ksz8_max_mtu(struct ksz_device *dev, int port)
+{
+	switch (dev->chip_id) {
+	case KSZ8795_CHIP_ID:
+	case KSZ8794_CHIP_ID:
+	case KSZ8765_CHIP_ID:
+		return KSZ8795_HUGE_PACKET_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;
+	case KSZ8830_CHIP_ID:
+		return KSZ8863_HUGE_PACKET_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static void ksz8795_set_prio_queue(struct ksz_device *dev, int port, int queue)
 {
 	u8 hi, lo;
@@ -1233,8 +1305,6 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
 	masks = dev->info->masks;
 	regs = dev->info->regs;
 
-	/* Switch marks the maximum frame with extra byte as oversize. */
-	ksz_cfg(dev, REG_SW_CTRL_2, SW_LEGAL_PACKET_DISABLE, true);
 	ksz_cfg(dev, regs[S_TAIL_TAG_CTRL], masks[SW_TAIL_TAG_ENABLE], true);
 
 	p = &dev->ports[dev->cpu_port];
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 77487d611824..1419091ef622 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -48,6 +48,15 @@
 #define NO_EXC_COLLISION_DROP		BIT(3)
 #define SW_LEGAL_PACKET_DISABLE		BIT(1)
 
+#define KSZ8863_HUGE_PACKET_ENABLE	BIT(2)
+#define KSZ8863_LEGAL_PACKET_ENABLE	BIT(1)
+
+#define KSZ8795_HUGE_PACKET_SIZE	2000
+
+#define KSZ8863_HUGE_PACKET_SIZE	1916
+#define KSZ8863_NORMAL_PACKET_SIZE	1536
+#define KSZ8863_LEGAL_PACKET_SIZE	1518
+
 #define REG_SW_CTRL_3			0x05
  #define WEIGHTED_FAIR_QUEUE_ENABLE	BIT(3)
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index d612181b3226..40fd78951bf8 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -171,6 +171,8 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.reset = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
+	.change_mtu = ksz8_change_mtu,
+	.max_mtu = ksz8_max_mtu,
 };
 
 static void ksz9477_phylink_mac_link_up(struct ksz_device *dev, int port,
-- 
2.30.2

