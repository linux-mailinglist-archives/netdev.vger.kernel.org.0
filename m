Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D7A4311B
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389390AbfFLUtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:49:19 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:14582 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388615AbfFLUtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:49:18 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x5CKnDTD007736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jun 2019 14:49:14 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x5CKnCV3014125
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 12 Jun 2019 14:49:13 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 1/2] net: dsa: microchip: Add PHY errata workarounds
Date:   Wed, 12 Jun 2019 14:49:05 -0600
Message-Id: <1560372546-3153-2-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560372546-3153-1-git-send-email-hancock@sedsystems.ca>
References: <1560372546-3153-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Silicon Errata and Data Sheet Clarification documents for the
KSZ9477 series of chips describe a number of otherwise undocumented PHY
register settings which are required to work around various chip errata.
Apply these settings when initializing the PHY ports on these chips.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/dsa/microchip/ksz9477.c  | 62 ++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_priv.h |  1 +
 2 files changed, 63 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index c026d15..7be6d84 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1165,6 +1165,62 @@ static phy_interface_t ksz9477_get_interface(struct ksz_device *dev, int port)
 	return interface;
 }
 
+static void ksz9477_port_mmd_write(struct ksz_device *dev, int port,
+				   u8 dev_addr, u16 reg_addr, u16 val)
+{
+	ksz_pwrite16(dev, port, REG_PORT_PHY_MMD_SETUP,
+		     MMD_SETUP(PORT_MMD_OP_INDEX, dev_addr));
+	ksz_pwrite16(dev, port, REG_PORT_PHY_MMD_INDEX_DATA, reg_addr);
+	ksz_pwrite16(dev, port, REG_PORT_PHY_MMD_SETUP,
+		     MMD_SETUP(PORT_MMD_OP_DATA_NO_INCR, dev_addr));
+	ksz_pwrite16(dev, port, REG_PORT_PHY_MMD_INDEX_DATA, val);
+}
+
+static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
+{
+	/* Apply PHY settings to address errata listed in
+	 * KSZ9477, KSZ9897, KSZ9896, KSZ9567, KSZ8565
+	 * Silicon Errata and Data Sheet Clarification documents:
+	 *
+	 * Register settings are needed to improve PHY receive performance
+	 */
+	ksz9477_port_mmd_write(dev, port, 0x01, 0x6f, 0xdd0b);
+	ksz9477_port_mmd_write(dev, port, 0x01, 0x8f, 0x6032);
+	ksz9477_port_mmd_write(dev, port, 0x01, 0x9d, 0x248c);
+	ksz9477_port_mmd_write(dev, port, 0x01, 0x75, 0x0060);
+	ksz9477_port_mmd_write(dev, port, 0x01, 0xd3, 0x7777);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x06, 0x3008);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x08, 0x2001);
+
+	/* Transmit waveform amplitude can be improved
+	 * (1000BASE-T, 100BASE-TX, 10BASE-Te)
+	 */
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x04, 0x00d0);
+
+	/* Energy Efficient Ethernet (EEE) feature select must
+	 * be manually disabled (except on KSZ8565 which is 100Mbit)
+	 */
+	if (dev->features & GBIT_SUPPORT)
+		ksz9477_port_mmd_write(dev, port, 0x07, 0x3c, 0x0000);
+
+	/* Register settings are required to meet data sheet
+	 * supply current specifications
+	 */
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x13, 0x6eff);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x14, 0xe6ff);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x15, 0x6eff);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x16, 0xe6ff);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x17, 0x00ff);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x18, 0x43ff);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x19, 0xc3ff);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1a, 0x6fff);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1b, 0x07ff);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1c, 0x0fff);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1d, 0xe7ff);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1e, 0xefff);
+	ksz9477_port_mmd_write(dev, port, 0x1c, 0x20, 0xeeee);
+}
+
 static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	u8 data8;
@@ -1203,6 +1259,8 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 			     PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
 			     false);
 
+		if (dev->phy_errata_9477)
+			ksz9477_phy_errata_setup(dev, port);
 	} else {
 		/* force flow control */
 		ksz_port_cfg(dev, port, REG_PORT_CTRL_0,
@@ -1474,6 +1532,7 @@ struct ksz_chip_data {
 	int num_statics;
 	int cpu_ports;
 	int port_cnt;
+	bool phy_errata_9477;
 };
 
 static const struct ksz_chip_data ksz9477_switch_chips[] = {
@@ -1485,6 +1544,7 @@ struct ksz_chip_data {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.phy_errata_9477 = true,
 	},
 	{
 		.chip_id = 0x00989700,
@@ -1494,6 +1554,7 @@ struct ksz_chip_data {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.phy_errata_9477 = true,
 	},
 	{
 		.chip_id = 0x00989300,
@@ -1522,6 +1583,7 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 			dev->num_statics = chip->num_statics;
 			dev->port_cnt = chip->port_cnt;
 			dev->cpu_ports = chip->cpu_ports;
+			dev->phy_errata_9477 = chip->phy_errata_9477;
 
 			break;
 		}
diff --git a/drivers/net/dsa/microchip/ksz_priv.h b/drivers/net/dsa/microchip/ksz_priv.h
index b52e5ca..724301d 100644
--- a/drivers/net/dsa/microchip/ksz_priv.h
+++ b/drivers/net/dsa/microchip/ksz_priv.h
@@ -77,6 +77,7 @@ struct ksz_device {
 	int last_port;			/* ports after that not used */
 	phy_interface_t interface;
 	u32 regs_size;
+	bool phy_errata_9477;
 
 	struct vlan_table *vlan_cache;
 
-- 
1.8.3.1

