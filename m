Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C559622FA8
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbiKIQIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiKIQIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:08:34 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCBA26C4;
        Wed,  9 Nov 2022 08:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668010109; x=1699546109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YtdAgAd9/LImbfRhF1NBIAFctvpRNKKdkwWKNXeggUA=;
  b=P80llsIVUqQ6D9YDlVvvgr2tS3i3wpIFqDaPnnpesl8T9R/G7i73pNGx
   TPBjvpCldpadZJygN0vI6T8gC5l3qpSgnVoD5o1poo6jOQ4vYbdHjKJz6
   9TGCrg+ljFyjDu0s9e0Vs2NENalWgKDwDYM/ISkPMQfxd7wTaY0j0OYX6
   A01XvtEbxdcZ7UUF5mE7o35Tpo7Uy9zVMJAhxQz0W6Rb8jFC6eRNjpiAV
   6X6HCiaf2wniiyAhFW/iFyZrIYKl4456R+aRc56UB4h3G6IYrcIrQNxsS
   0pICqXgjiq7SMawoE0HNTzBYTDyi5q0SQ2gj39ilYdg3w/y6Thnr1iw6R
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="186153742"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Nov 2022 09:08:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 9 Nov 2022 09:08:26 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 9 Nov 2022 09:08:20 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>
Subject: [RFC Patch net-next 1/2] net: dsa: microchip: enable port queues for tc mqprio
Date:   Wed, 9 Nov 2022 21:37:56 +0530
Message-ID: <20221109160757.27902-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221109160757.27902-1-arun.ramadoss@microchip.com>
References: <20221109160757.27902-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN937x family of switches has 8 queues per port where all the ksz
switches has 4 queues per port. By default, only one queue per port is
enabled. The queues are configurable in 2, 4 or 8. This patch add 8
number of queues for LAN937x and 4 for other switches.
In the tag_ksz.c file, prioirty of the packet is queried using the skb
buffer and the corresponding value is updated in the tag.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c      |  4 ++++
 drivers/net/dsa/microchip/ksz9477_reg.h  |  5 ++++-
 drivers/net/dsa/microchip/ksz_common.c   | 17 +++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  1 +
 drivers/net/dsa/microchip/lan937x_main.c |  4 ++++
 drivers/net/dsa/microchip/lan937x_reg.h  |  6 +++++-
 net/dsa/tag_ksz.c                        | 15 +++++++++++++++
 7 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 0d6b40968657..65e69a26e8ec 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1000,6 +1000,10 @@ void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		ksz_port_cfg(dev, port, REG_PORT_CTRL_0, PORT_TAIL_TAG_ENABLE,
 			     true);
 
+	/* Enable the Port Queue split */
+	ksz_prmw8(dev, port, REG_PORT_CTRL_0, PORT_QUEUE_SPLIT_MASK,
+		  PORT_FOUR_QUEUE);
+
 	ksz_port_cfg(dev, port, REG_PORT_CTRL_0, PORT_MAC_LOOPBACK, false);
 
 	/* set back pressure */
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 53c68d286dd3..3f08b1bd7ff3 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -850,7 +850,10 @@
 #define PORT_FORCE_TX_FLOW_CTRL		BIT(4)
 #define PORT_FORCE_RX_FLOW_CTRL		BIT(3)
 #define PORT_TAIL_TAG_ENABLE		BIT(2)
-#define PORT_QUEUE_SPLIT_ENABLE		0x3
+#define PORT_QUEUE_SPLIT_MASK		GENMASK(1, 0)
+#define PORT_FOUR_QUEUE			0x2
+#define PORT_TWO_QUEUE			0x1
+#define PORT_SINGLE_QUEUE		0x0
 
 #define REG_PORT_CTRL_1			0x0021
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 8c8db315317d..63e567554548 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1040,6 +1040,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
 		.port_nirqs = 3,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1066,6 +1067,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
+		.num_tx_queues = 4,
 		.ops = &ksz8_dev_ops,
 		.ksz87xx_eee_link_erratum = true,
 		.mib_names = ksz9477_mib_names,
@@ -1104,6 +1106,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
+		.num_tx_queues = 4,
 		.ops = &ksz8_dev_ops,
 		.ksz87xx_eee_link_erratum = true,
 		.mib_names = ksz9477_mib_names,
@@ -1128,6 +1131,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
+		.num_tx_queues = 4,
 		.ops = &ksz8_dev_ops,
 		.ksz87xx_eee_link_erratum = true,
 		.mib_names = ksz9477_mib_names,
@@ -1152,6 +1156,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x4,	/* can be configured as cpu port */
 		.port_cnt = 3,
+		.num_tx_queues = 4,
 		.ops = &ksz8_dev_ops,
 		.mib_names = ksz88xx_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
@@ -1173,6 +1178,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
 		.port_nirqs = 4,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1205,6 +1211,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x3F,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
 		.port_nirqs = 2,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1237,6 +1244,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
 		.port_nirqs = 2,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1267,6 +1275,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
 		.port_nirqs = 2,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1317,6 +1326,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
 		.port_nirqs = 3,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1347,6 +1357,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
 		.port_nirqs = 6,
+		.num_tx_queues = 8,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1371,6 +1382,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
 		.port_nirqs = 6,
+		.num_tx_queues = 8,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1395,6 +1407,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
 		.port_nirqs = 6,
+		.num_tx_queues = 8,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1423,6 +1436,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x38,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
 		.port_nirqs = 6,
+		.num_tx_queues = 8,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1451,6 +1465,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
 		.port_nirqs = 6,
+		.num_tx_queues = 8,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1983,6 +1998,8 @@ static int ksz_setup(struct dsa_switch *ds)
 
 	dev->dev_ops->enable_stp_addr(dev);
 
+	ds->num_tx_queues = dev->info->num_tx_queues;
+
 	regmap_update_bits(dev->regmap[0], regs[S_MULTICAST_CTRL],
 			   MULTICAST_STORM_DISABLE, MULTICAST_STORM_DISABLE);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c6726cbd5465..60706b10cd46 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -46,6 +46,7 @@ struct ksz_chip_data {
 	int cpu_ports;
 	int port_cnt;
 	u8 port_nirqs;
+	u8 num_tx_queues;
 	const struct ksz_dev_ops *ops;
 	bool phy_errata_9477;
 	bool ksz87xx_eee_link_erratum;
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 06d3d0308cba..ffb83225eb95 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -180,6 +180,10 @@ void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		lan937x_port_cfg(dev, port, REG_PORT_CTRL_0,
 				 PORT_TAIL_TAG_ENABLE, true);
 
+	/* Enable the Port Queue split */
+	ksz_prmw8(dev, port, REG_PORT_CTRL_0, PORT_QUEUE_SPLIT_MASK,
+		  PORT_EIGHT_QUEUE);
+
 	/* set back pressure for half duplex */
 	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_1, PORT_BACK_PRESSURE,
 			 true);
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index 5bc16a4c4441..f64e9de6976c 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -143,7 +143,11 @@
 #define PORT_K2L_INSERT_ENABLE		BIT(5)
 #define PORT_K2L_DEBUG_ENABLE		BIT(4)
 #define PORT_TAIL_TAG_ENABLE		BIT(2)
-#define PORT_QUEUE_SPLIT_ENABLE		0x3
+#define PORT_QUEUE_SPLIT_MASK		GENMASK(1, 0)
+#define PORT_EIGHT_QUEUE		0x3
+#define PORT_FOUR_QUEUE			0x2
+#define PORT_TWO_QUEUE			0x1
+#define PORT_SINGLE_QUEUE		0x0
 
 /* 1 - Phy */
 #define REG_PORT_T1_PHY_CTRL_BASE	0x0100
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 38fa19c1e2d5..8fe6ea1d623d 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -106,10 +106,13 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795);
 
 #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
 #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
+#define KSZ9477_TAIL_TAG_PRIO		7
 
 static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 prio = netdev_txq_to_tc(dev, queue_mapping);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	__be16 *tag;
 	u8 *addr;
@@ -124,6 +127,8 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 
 	val = BIT(dp->index);
 
+	val |= (prio << KSZ9477_TAIL_TAG_PRIO);
+
 	if (is_link_local_ether_addr(addr))
 		val |= KSZ9477_TAIL_TAG_OVERRIDE;
 
@@ -159,10 +164,13 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9477);
 
 #define KSZ9893_TAIL_TAG_OVERRIDE	BIT(5)
 #define KSZ9893_TAIL_TAG_LOOKUP		BIT(6)
+#define KSZ9893_TAIL_TAG_PRIO		3
 
 static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 prio = netdev_txq_to_tc(dev, queue_mapping);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u8 *addr;
 	u8 *tag;
@@ -176,6 +184,8 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 
 	*tag = BIT(dp->index);
 
+	*tag |= (prio << KSZ9893_TAIL_TAG_PRIO);
+
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
@@ -212,11 +222,14 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
 #define LAN937X_TAIL_TAG_BLOCKING_OVERRIDE	BIT(11)
 #define LAN937X_TAIL_TAG_LOOKUP			BIT(12)
 #define LAN937X_TAIL_TAG_VALID			BIT(13)
+#define LAN937X_TAIL_TAG_PRIO			8
 #define LAN937X_TAIL_TAG_PORT_MASK		7
 
 static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 prio = netdev_txq_to_tc(dev, queue_mapping);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	const struct ethhdr *hdr = eth_hdr(skb);
 	__be16 *tag;
@@ -229,6 +242,8 @@ static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
 
 	val = BIT(dp->index);
 
+	val |= (prio << LAN937X_TAIL_TAG_PRIO);
+
 	if (is_link_local_ether_addr(hdr->h_dest))
 		val |= LAN937X_TAIL_TAG_BLOCKING_OVERRIDE;
 
-- 
2.36.1

