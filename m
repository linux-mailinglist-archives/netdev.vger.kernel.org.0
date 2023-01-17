Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E770B66E0CA
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbjAQOeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjAQOdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:33:25 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226633C284;
        Tue, 17 Jan 2023 06:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673966000; x=1705502000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nBBJFpi6PVLNOBwNfCs20pNu7QnZ968924gv2JomYPk=;
  b=ive2s+0uiw0WjNOjbv+cfCpDiJ9ye7KjTugKZZ9sqYaiuvoBukJL6rci
   TKzka5oW6lZ6XV6QL8jjnXfRRLqgVXb04QPWYTiuJJI8K55pp8poaemwN
   KGp9zBsjiYVby3W8TOWXLxGVGNb56cWLn+op7S2hqU5mmesUljDRglWtf
   yfB6I8HFx4UAoeZ+C63Ni24TPnCtxckP7yeZyF8NZ0YQStuT7krsMHnEC
   l5hNyh8wnqOMy/qBTetOIxlAkysLhZ0FQ8TOnfVu+RZ8o45U43goel5XB
   RKgavkRJvNRemhvTgtpiZk2zZCHy7CGAyyZSIsuidr7y0hFsbnkuArjnJ
   w==;
X-IronPort-AV: E=Sophos;i="5.97,224,1669100400"; 
   d="scan'208";a="197154666"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 07:33:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 07:33:11 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 07:33:06 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>
Subject: [Patch net-next 1/2] net: dsa: microchip: enable port queues for tc mqprio
Date:   Tue, 17 Jan 2023 20:02:51 +0530
Message-ID: <20230117143252.8339-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230117143252.8339-1-arun.ramadoss@microchip.com>
References: <20230117143252.8339-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN937x family of switches has 8 queues per port where the KSZ switches
has 4 queues per port. By default, only one queue per port is enabled.
The queues are configurable in 2, 4 or 8. This patch add 8 number of
queues for LAN937x and 4 for other switches.
In the tag_ksz.c file, prioirty of the packet is queried using the skb
buffer and the corresponding value is updated in the tag.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c      |  4 ++++
 drivers/net/dsa/microchip/ksz9477_reg.h  |  5 ++++-
 drivers/net/dsa/microchip/ksz_common.c   | 18 ++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  1 +
 drivers/net/dsa/microchip/lan937x_main.c |  4 ++++
 drivers/net/dsa/microchip/lan937x_reg.h  |  6 +++++-
 net/dsa/tag_ksz.c                        | 15 +++++++++++++++
 7 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 47b54ecf2c6f..5a66d0be2876 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -991,6 +991,10 @@ void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		ksz_port_cfg(dev, port, REG_PORT_CTRL_0, PORT_TAIL_TAG_ENABLE,
 			     true);
 
+	/* Enable the Port Queue split */
+	ksz_prmw8(dev, port, REG_PORT_CTRL_0, PORT_QUEUE_SPLIT_MASK,
+		  PORT_FOUR_QUEUE);
+
 	ksz_port_cfg(dev, port, REG_PORT_CTRL_0, PORT_MAC_LOOPBACK, false);
 
 	/* set back pressure */
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index cc457fa64939..4f27dadb4add 100644
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
index 5e1e5bd555d2..fbb107754057 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1080,6 +1080,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
 		.port_nirqs = 3,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1106,6 +1107,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
+		.num_tx_queues = 4,
 		.ops = &ksz8_dev_ops,
 		.ksz87xx_eee_link_erratum = true,
 		.mib_names = ksz9477_mib_names,
@@ -1144,6 +1146,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
+		.num_tx_queues = 4,
 		.ops = &ksz8_dev_ops,
 		.ksz87xx_eee_link_erratum = true,
 		.mib_names = ksz9477_mib_names,
@@ -1168,6 +1171,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
+		.num_tx_queues = 4,
 		.ops = &ksz8_dev_ops,
 		.ksz87xx_eee_link_erratum = true,
 		.mib_names = ksz9477_mib_names,
@@ -1192,6 +1196,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x4,	/* can be configured as cpu port */
 		.port_cnt = 3,
+		.num_tx_queues = 4,
 		.ops = &ksz8_dev_ops,
 		.mib_names = ksz88xx_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
@@ -1213,6 +1218,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
 		.port_nirqs = 4,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1245,6 +1251,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x3F,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
 		.port_nirqs = 2,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1277,6 +1284,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
 		.port_nirqs = 2,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1307,6 +1315,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
 		.port_nirqs = 2,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1332,6 +1341,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
 		.port_nirqs = 3,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1357,6 +1367,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
 		.port_nirqs = 3,
+		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1387,6 +1398,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
 		.port_nirqs = 6,
+		.num_tx_queues = 8,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1411,6 +1423,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
 		.port_nirqs = 6,
+		.num_tx_queues = 8,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1435,6 +1448,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
 		.port_nirqs = 6,
+		.num_tx_queues = 8,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1463,6 +1477,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x38,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
 		.port_nirqs = 6,
+		.num_tx_queues = 8,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1491,6 +1506,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
 		.port_nirqs = 6,
+		.num_tx_queues = 8,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -2071,6 +2087,8 @@ static int ksz_setup(struct dsa_switch *ds)
 
 	dev->dev_ops->enable_stp_addr(dev);
 
+	ds->num_tx_queues = dev->info->num_tx_queues;
+
 	regmap_update_bits(dev->regmap[0], regs[S_MULTICAST_CTRL],
 			   MULTICAST_STORM_DISABLE, MULTICAST_STORM_DISABLE);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 7260528e5c57..1a00143b0345 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -49,6 +49,7 @@ struct ksz_chip_data {
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
index 694478fe07d6..0eb1c7784c3d 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -178,6 +178,7 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
 #define KSZ9477_PTP_TAG_LEN		4
 #define KSZ9477_PTP_TAG_INDICATION	0x80
 
+#define KSZ9477_TAIL_TAG_PRIO		GENMASK(8, 7)
 #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
 #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
 
@@ -269,6 +270,8 @@ static struct sk_buff *ksz_defer_xmit(struct dsa_port *dp, struct sk_buff *skb)
 static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 prio = netdev_txq_to_tc(dev, queue_mapping);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	__be16 *tag;
 	u8 *addr;
@@ -285,6 +288,8 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 
 	val = BIT(dp->index);
 
+	val |= FIELD_PREP(KSZ9477_TAIL_TAG_PRIO, prio);
+
 	if (is_link_local_ether_addr(addr))
 		val |= KSZ9477_TAIL_TAG_OVERRIDE;
 
@@ -322,12 +327,15 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 DSA_TAG_DRIVER(ksz9477_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9477, KSZ9477_NAME);
 
+#define KSZ9893_TAIL_TAG_PRIO		GENMASK(4, 3)
 #define KSZ9893_TAIL_TAG_OVERRIDE	BIT(5)
 #define KSZ9893_TAIL_TAG_LOOKUP		BIT(6)
 
 static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 prio = netdev_txq_to_tc(dev, queue_mapping);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u8 *addr;
 	u8 *tag;
@@ -343,6 +351,8 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 
 	*tag = BIT(dp->index);
 
+	*tag |= FIELD_PREP(KSZ9893_TAIL_TAG_PRIO, prio);
+
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
@@ -384,11 +394,14 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893, KSZ9893_NAME);
 #define LAN937X_TAIL_TAG_BLOCKING_OVERRIDE	BIT(11)
 #define LAN937X_TAIL_TAG_LOOKUP			BIT(12)
 #define LAN937X_TAIL_TAG_VALID			BIT(13)
+#define LAN937X_TAIL_TAG_PRIO			GENMASK(10, 8)
 #define LAN937X_TAIL_TAG_PORT_MASK		7
 
 static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 prio = netdev_txq_to_tc(dev, queue_mapping);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	const struct ethhdr *hdr = eth_hdr(skb);
 	__be16 *tag;
@@ -403,6 +416,8 @@ static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
 
 	val = BIT(dp->index);
 
+	val |= FIELD_PREP(LAN937X_TAIL_TAG_PRIO, prio);
+
 	if (is_link_local_ether_addr(hdr->h_dest))
 		val |= LAN937X_TAIL_TAG_BLOCKING_OVERRIDE;
 
-- 
2.36.1

