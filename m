Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DE666E0CB
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjAQOeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjAQOdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:33:25 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945493C2B4;
        Tue, 17 Jan 2023 06:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673966001; x=1705502001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zbsT+GZQOzJ7cvrCW7fAJJHXJHeu0A81LNNz/mAPWF4=;
  b=XnYsNh4kg8K8n5K8soJ2YA03PaAA6NmrR0KOC1w7n2Avcdeji1vozFhY
   cFdxE7Pd8+3BKs1j3StPqy3g5q6RAxM0NE5KvX2EbfPRvSl6XGATYu6yf
   VP4OxfVKMv+9XRdB4scE2oxTVHIRbF+ohOH58jtwSAoWC6c0C13iBY0tp
   /OEtkUXuLFert4UlZAuA6Ooacoi7lMdr+1Cee2NSHIwly971Y0VkRGf1T
   n2EYYohr/0AYlCMzu8FmYEpflwB/alG0TSZjs51/yW1XSHNG5VbDHFOh8
   qECMBDPRIcbMGLQ7jChgtRqEaN3tODhBAc4ZImblJTfrv5/xaFtEiZxhR
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,224,1669100400"; 
   d="scan'208";a="197154669"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 07:33:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 07:33:17 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 07:33:12 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>
Subject: [Patch net-next 2/2] net: dsa: microchip: add support for credit based shaper
Date:   Tue, 17 Jan 2023 20:02:52 +0530
Message-ID: <20230117143252.8339-3-arun.ramadoss@microchip.com>
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

KSZ9477, KSZ9567, KSZ9563, KSZ8563 and LAN937x supports Credit based
shaper. To differentiate the chip supporting cbs, tc_cbs_supported
flag is introduced in ksz_chip_data.
And KSZ series has 16bit Credit increment registers whereas LAN937x has
24bit register. The value to be programmed in the credit increment is
determined using the successive multiplication method to convert decimal
fraction to hexadecimal fraction.
For example: if idleslope is 10000 and sendslope is -90000, then
bandwidth is 10000 - (-90000) = 100000.
The 10% bandwidth of 100Mbps means 10/100 = 0.1(decimal). This value has
to be converted to hexa.
1) 0.1 * 16 = 1.6  --> fraction 0.6 Carry = 1 (MSB)
2) 0.6 * 16 = 9.6  --> fraction 0.6 Carry = 9
3) 0.6 * 16 = 9.6  --> fraction 0.6 Carry = 9
4) 0.6 * 16 = 9.6  --> fraction 0.6 Carry = 9
5) 0.6 * 16 = 9.6  --> fraction 0.6 Carry = 9
6) 0.6 * 16 = 9.6  --> fraction 0.6 Carry = 9 (LSB)
Now 0.1(decimal) becomes 0.199999(Hex).
If it is LAN937x, 24 bit value will be programmed to Credit Inc
register, 0x199999. For others 16 bit value will be prgrammed, 0x1999.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c      |   7 ++
 drivers/net/dsa/microchip/ksz9477.h      |   1 +
 drivers/net/dsa/microchip/ksz9477_reg.h  |  27 +-----
 drivers/net/dsa/microchip/ksz_common.c   | 105 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  20 +++++
 drivers/net/dsa/microchip/lan937x.h      |   1 +
 drivers/net/dsa/microchip/lan937x_main.c |   5 ++
 drivers/net/dsa/microchip/lan937x_reg.h  |   3 +
 8 files changed, 144 insertions(+), 25 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 5a66d0be2876..f7a6050ddb74 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1170,6 +1170,13 @@ u32 ksz9477_get_port_addr(int port, int offset)
 	return PORT_CTRL_ADDR(port, offset);
 }
 
+int ksz9477_tc_cbs_set_cinc(struct ksz_device *dev, int port, u32 val)
+{
+	val = val >> 8;
+
+	return ksz_pwrite16(dev, port, REG_PORT_MTI_CREDIT_INCREMENT, val);
+}
+
 int ksz9477_switch_init(struct ksz_device *dev)
 {
 	u8 data8;
diff --git a/drivers/net/dsa/microchip/ksz9477.h b/drivers/net/dsa/microchip/ksz9477.h
index 7c5bb3032772..50d82bf0cb59 100644
--- a/drivers/net/dsa/microchip/ksz9477.h
+++ b/drivers/net/dsa/microchip/ksz9477.h
@@ -51,6 +51,7 @@ int ksz9477_mdb_del(struct ksz_device *dev, int port,
 		    const struct switchdev_obj_port_mdb *mdb, struct dsa_db db);
 int ksz9477_change_mtu(struct ksz_device *dev, int port, int mtu);
 void ksz9477_config_cpu_port(struct dsa_switch *ds);
+int ksz9477_tc_cbs_set_cinc(struct ksz_device *dev, int port, u32 val);
 int ksz9477_enable_stp_addr(struct ksz_device *dev);
 int ksz9477_reset_switch(struct ksz_device *dev);
 int ksz9477_dsa_init(struct ksz_device *dev);
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 4f27dadb4add..1656656a0d16 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1483,33 +1483,10 @@
 
 /* 9 - Shaping */
 
-#define REG_PORT_MTI_QUEUE_INDEX__4	0x0900
+#define REG_PORT_MTI_QUEUE_CTRL_0__4   0x0904
 
-#define REG_PORT_MTI_QUEUE_CTRL_0__4	0x0904
+#define MTI_PVID_REPLACE               BIT(0)
 
-#define MTI_PVID_REPLACE		BIT(0)
-
-#define REG_PORT_MTI_QUEUE_CTRL_0	0x0914
-
-#define MTI_SCHEDULE_MODE_M		0x3
-#define MTI_SCHEDULE_MODE_S		6
-#define MTI_SCHEDULE_STRICT_PRIO	0
-#define MTI_SCHEDULE_WRR		2
-#define MTI_SHAPING_M			0x3
-#define MTI_SHAPING_S			4
-#define MTI_SHAPING_OFF			0
-#define MTI_SHAPING_SRP			1
-#define MTI_SHAPING_TIME_AWARE		2
-
-#define REG_PORT_MTI_QUEUE_CTRL_1	0x0915
-
-#define MTI_TX_RATIO_M			(BIT(7) - 1)
-
-#define REG_PORT_MTI_QUEUE_CTRL_2__2	0x0916
-#define REG_PORT_MTI_HI_WATER_MARK	0x0916
-#define REG_PORT_MTI_QUEUE_CTRL_3__2	0x0918
-#define REG_PORT_MTI_LO_WATER_MARK	0x0918
-#define REG_PORT_MTI_QUEUE_CTRL_4__2	0x091A
 #define REG_PORT_MTI_CREDIT_INCREMENT	0x091A
 
 /* A - QM */
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fbb107754057..53f4286a2c22 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -23,6 +23,7 @@
 #include <linux/of_net.h>
 #include <linux/micrel_phy.h>
 #include <net/dsa.h>
+#include <net/pkt_cls.h>
 #include <net/switchdev.h>
 
 #include "ksz_common.h"
@@ -31,6 +32,10 @@
 #include "ksz9477.h"
 #include "lan937x.h"
 
+#define KSZ_CBS_ENABLE ((MTI_SCHEDULE_STRICT_PRIO << MTI_SCHEDULE_MODE_S) | \
+			(MTI_SHAPING_SRP << MTI_SHAPING_S))
+#define KSZ_CBS_DISABLE ((MTI_SCHEDULE_WRR << MTI_SCHEDULE_MODE_S) |\
+			 (MTI_SHAPING_OFF << MTI_SHAPING_S))
 #define MIB_COUNTER_NUM 0x20
 
 struct ksz_stats_raw {
@@ -250,6 +255,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.change_mtu = ksz9477_change_mtu,
 	.phylink_mac_link_up = ksz9477_phylink_mac_link_up,
 	.config_cpu_port = ksz9477_config_cpu_port,
+	.tc_cbs_set_cinc = ksz9477_tc_cbs_set_cinc,
 	.enable_stp_addr = ksz9477_enable_stp_addr,
 	.reset = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
@@ -286,6 +292,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.change_mtu = lan937x_change_mtu,
 	.phylink_mac_link_up = ksz9477_phylink_mac_link_up,
 	.config_cpu_port = lan937x_config_cpu_port,
+	.tc_cbs_set_cinc = lan937x_tc_cbs_set_cinc,
 	.enable_stp_addr = ksz9477_enable_stp_addr,
 	.reset = lan937x_reset_switch,
 	.init = lan937x_switch_init,
@@ -1081,6 +1088,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 3,		/* total port count */
 		.port_nirqs = 3,
 		.num_tx_queues = 4,
+		.tc_cbs_supported = true,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1219,6 +1227,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 7,		/* total physical port count */
 		.port_nirqs = 4,
 		.num_tx_queues = 4,
+		.tc_cbs_supported = true,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1342,6 +1351,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 3,		/* total port count */
 		.port_nirqs = 3,
 		.num_tx_queues = 4,
+		.tc_cbs_supported = true,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1368,6 +1378,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 7,		/* total physical port count */
 		.port_nirqs = 3,
 		.num_tx_queues = 4,
+		.tc_cbs_supported = true,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1399,6 +1410,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 5,		/* total physical port count */
 		.port_nirqs = 6,
 		.num_tx_queues = 8,
+		.tc_cbs_supported = true,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1424,6 +1436,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 6,		/* total physical port count */
 		.port_nirqs = 6,
 		.num_tx_queues = 8,
+		.tc_cbs_supported = true,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1449,6 +1462,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 8,		/* total physical port count */
 		.port_nirqs = 6,
 		.num_tx_queues = 8,
+		.tc_cbs_supported = true,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1478,6 +1492,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 5,		/* total physical port count */
 		.port_nirqs = 6,
 		.num_tx_queues = 8,
+		.tc_cbs_supported = true,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1507,6 +1522,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 8,		/* total physical port count */
 		.port_nirqs = 6,
 		.num_tx_queues = 8,
+		.tc_cbs_supported = true,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -2982,6 +2998,94 @@ static int ksz_switch_detect(struct ksz_device *dev)
 	return 0;
 }
 
+/* Bandwidth is calculated by idle slope/transmission speed. Then the Bandwidth
+ * is converted to Hex-decimal using the successive multiplication method. On
+ * every step, integer part is taken and decimal part is carry forwarded.
+ */
+static int cinc_cal(s32 idle_slope, s32 send_slope)
+{
+	int cinc = 0;
+	u32 txrate;
+	u32 rate;
+	u8 temp;
+	u8 i;
+
+	txrate = idle_slope - send_slope;
+
+	rate = idle_slope;
+
+	/* 24 bit register */
+	for (i = 0; i < 6; i++) {
+		rate = rate * 16;
+
+		temp = rate / txrate;
+
+		rate %= txrate;
+
+		cinc = ((cinc << 4) | temp);
+	}
+
+	return cinc;
+}
+
+static int ksz_setup_tc_cbs(struct dsa_switch *ds, int port,
+			    struct tc_cbs_qopt_offload *qopt)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret;
+	u32 bw;
+
+	if (!dev->info->tc_cbs_supported)
+		return -EOPNOTSUPP;
+
+	if (qopt->queue > dev->info->num_tx_queues)
+		return -EINVAL;
+
+	/* Queue Selection */
+	ret = ksz_pwrite32(dev, port, REG_PORT_MTI_QUEUE_INDEX__4, qopt->queue);
+	if (ret)
+		return ret;
+
+	if (!qopt->enable)
+		return ksz_pwrite8(dev, port, REG_PORT_MTI_QUEUE_CTRL_0,
+				   KSZ_CBS_DISABLE);
+
+	ret = ksz_pwrite8(dev, port, REG_PORT_MTI_QUEUE_CTRL_0, KSZ_CBS_ENABLE);
+	if (ret)
+		return ret;
+
+	/* High Credit */
+	ret = ksz_pwrite16(dev, port, REG_PORT_MTI_HI_WATER_MARK,
+			   qopt->hicredit);
+	if (ret)
+		return ret;
+
+	/* Low Credit */
+	ret = ksz_pwrite16(dev, port, REG_PORT_MTI_LO_WATER_MARK,
+			   qopt->locredit);
+	if (ret)
+		return ret;
+
+	/* Credit Increment Register */
+	bw = cinc_cal(qopt->idleslope, qopt->sendslope);
+
+	if (dev->dev_ops->tc_cbs_set_cinc)
+		ret = dev->dev_ops->tc_cbs_set_cinc(dev, port, bw);
+
+	return ret;
+}
+
+static int ksz_setup_tc(struct dsa_switch *ds, int port,
+			enum tc_setup_type type, void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_CBS:
+		return ksz_setup_tc_cbs(ds, port, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_tag_protocol	= ksz_get_tag_protocol,
 	.connect_tag_protocol   = ksz_connect_tag_protocol,
@@ -3024,6 +3128,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.port_hwtstamp_set	= ksz_hwtstamp_set,
 	.port_txtstamp		= ksz_port_txtstamp,
 	.port_rxtstamp		= ksz_port_rxtstamp,
+	.port_setup_tc		= ksz_setup_tc,
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 1a00143b0345..d2d5761d58e9 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -50,6 +50,7 @@ struct ksz_chip_data {
 	int port_cnt;
 	u8 port_nirqs;
 	u8 num_tx_queues;
+	bool tc_cbs_supported;
 	const struct ksz_dev_ops *ops;
 	bool phy_errata_9477;
 	bool ksz87xx_eee_link_erratum;
@@ -354,6 +355,7 @@ struct ksz_dev_ops {
 				    struct phy_device *phydev, int speed,
 				    int duplex, bool tx_pause, bool rx_pause);
 	void (*setup_rgmii_delay)(struct ksz_device *dev, int port);
+	int (*tc_cbs_set_cinc)(struct ksz_device *dev, int port, u32 val);
 	void (*config_cpu_port)(struct dsa_switch *ds);
 	int (*enable_stp_addr)(struct ksz_device *dev);
 	int (*reset)(struct ksz_device *dev);
@@ -647,6 +649,24 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define KSZ8_LEGAL_PACKET_SIZE		1518
 #define KSZ9477_MAX_FRAME_SIZE		9000
 
+/* CBS related registers */
+#define REG_PORT_MTI_QUEUE_INDEX__4	0x0900
+
+#define REG_PORT_MTI_QUEUE_CTRL_0	0x0914
+
+#define MTI_SCHEDULE_MODE_M		0x3
+#define MTI_SCHEDULE_MODE_S		6
+#define MTI_SCHEDULE_STRICT_PRIO	0
+#define MTI_SCHEDULE_WRR		2
+#define MTI_SHAPING_M			0x3
+#define MTI_SHAPING_S			4
+#define MTI_SHAPING_OFF			0
+#define MTI_SHAPING_SRP			1
+#define MTI_SHAPING_TIME_AWARE		2
+
+#define REG_PORT_MTI_HI_WATER_MARK	0x0916
+#define REG_PORT_MTI_LO_WATER_MARK	0x0918
+
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 8e9e66d6728d..3388d91dbc44 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -20,4 +20,5 @@ void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 			      struct phylink_config *config);
 void lan937x_setup_rgmii_delay(struct ksz_device *dev, int port);
 int lan937x_set_ageing_time(struct ksz_device *dev, unsigned int msecs);
+int lan937x_tc_cbs_set_cinc(struct ksz_device *dev, int port, u32 val);
 #endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index ffb83225eb95..469319d7a644 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -340,6 +340,11 @@ void lan937x_setup_rgmii_delay(struct ksz_device *dev, int port)
 	}
 }
 
+int lan937x_tc_cbs_set_cinc(struct ksz_device *dev, int port, u32 val)
+{
+	return ksz_pwrite32(dev, port, REG_PORT_MTI_CREDIT_INCREMENT, val);
+}
+
 int lan937x_switch_init(struct ksz_device *dev)
 {
 	dev->port_mask = (1 << dev->info->port_cnt) - 1;
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index f64e9de6976c..1be255eec56e 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -189,6 +189,9 @@
 
 #define P_PRIO_CTRL			REG_PORT_MRI_PRIO_CTRL
 
+/* 9 - Shaping */
+#define REG_PORT_MTI_CREDIT_INCREMENT	0x091C
+
 /* The port number as per the datasheet */
 #define RGMII_2_PORT_NUM		5
 #define RGMII_1_PORT_NUM		6
-- 
2.36.1

