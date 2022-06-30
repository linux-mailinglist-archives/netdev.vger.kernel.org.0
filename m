Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4975617B6
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiF3KXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbiF3KWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:22:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F5D45798;
        Thu, 30 Jun 2022 03:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656584535; x=1688120535;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e6aBUPceUYdYXAPG0wlt5sqqPMtdXaJkccxJn3smPpw=;
  b=yriQJPknaOm4VnYcT3+s1vpzFMzbAWnUnxRuhkPkCZzoIBH3Qk8BKgAq
   B56KrHgMD5ku8ZcPWaEjAJmT+aJOFR2LnwBVll8ftSjGz1UH0wejwLtsR
   /k50tGXOtoOQgLl0eoldzVgGQCREQIdv/rxiGgFer7E/4NmFA1YLiqxbc
   T1+M1q9wp5AokDZ6cv4KiRtX+wmdDYlBJrdDhwi8RvJISf/htIbv3Vd24
   hLM7kra8lv+oEJWypyW/SNOwPXeSYl+dxSwJYM1s+jaaOtJLFRChZfCRC
   tEg4ML+LSuuJ6n4q4A/bUWIfYIYt3af165xGUouyilVwHeVblFDubcI8q
   g==;
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="165804805"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 03:22:14 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 03:22:11 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 30 Jun 2022 03:22:03 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [Patch net-next v14 05/13] net: dsa: microchip: add DSA support for microchip LAN937x
Date:   Thu, 30 Jun 2022 15:50:33 +0530
Message-ID: <20220630102041.25555-6-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630102041.25555-1-arun.ramadoss@microchip.com>
References: <20220630102041.25555-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basic DSA driver support for lan937x and the device will be
configured through SPI interface.
It adds the lan937x_dev_ops in ksz_common.c file and tries to reuse the
functionality of ksz9477 series switch.

drivers/net/dsa/microchip/ path is already part of MAINTAINERS &
the new files come under this path. Hence no update needed to the
MAINTAINERS

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/Kconfig        |   2 +-
 drivers/net/dsa/microchip/Makefile       |   1 +
 drivers/net/dsa/microchip/ksz_common.c   |  34 +++++
 drivers/net/dsa/microchip/lan937x.h      |  15 +++
 drivers/net/dsa/microchip/lan937x_main.c | 154 +++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h  | 128 +++++++++++++++++++
 6 files changed, 333 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/microchip/lan937x.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_main.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_reg.h

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 2edb88080790..06b1efdb5e7d 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig NET_DSA_MICROCHIP_KSZ_COMMON
-	tristate "Microchip KSZ8795/KSZ9477 series switch support"
+	tristate "Microchip KSZ8795/KSZ9477/LAN937x series switch support"
 	depends on NET_DSA
 	select NET_DSA_TAG_KSZ
 	help
diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index b2ba7c1bcb93..28873559efc2 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)	+= ksz_switch.o
 ksz_switch-objs := ksz_common.o
 ksz_switch-objs += ksz9477.o
 ksz_switch-objs += ksz8795.o
+ksz_switch-objs += lan937x_main.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_SPI)		+= ksz_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index d631a4bf35ed..83e44598d00c 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -23,6 +23,7 @@
 #include "ksz_common.h"
 #include "ksz8.h"
 #include "ksz9477.h"
+#include "lan937x.h"
 
 #define MIB_COUNTER_NUM 0x20
 
@@ -201,6 +202,34 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.exit = ksz9477_switch_exit,
 };
 
+static const struct ksz_dev_ops lan937x_dev_ops = {
+	.setup = lan937x_setup,
+	.get_port_addr = ksz9477_get_port_addr,
+	.cfg_port_member = ksz9477_cfg_port_member,
+	.port_setup = lan937x_port_setup,
+	.r_mib_cnt = ksz9477_r_mib_cnt,
+	.r_mib_pkt = ksz9477_r_mib_pkt,
+	.r_mib_stat64 = ksz_r_mib_stats64,
+	.freeze_mib = ksz9477_freeze_mib,
+	.port_init_cnt = ksz9477_port_init_cnt,
+	.vlan_filtering = ksz9477_port_vlan_filtering,
+	.vlan_add = ksz9477_port_vlan_add,
+	.vlan_del = ksz9477_port_vlan_del,
+	.mirror_add = ksz9477_port_mirror_add,
+	.mirror_del = ksz9477_port_mirror_del,
+	.fdb_dump = ksz9477_fdb_dump,
+	.fdb_add = ksz9477_fdb_add,
+	.fdb_del = ksz9477_fdb_del,
+	.mdb_add = ksz9477_mdb_add,
+	.mdb_del = ksz9477_mdb_del,
+	.max_mtu = ksz9477_max_mtu,
+	.config_cpu_port = lan937x_config_cpu_port,
+	.enable_stp_addr = ksz9477_enable_stp_addr,
+	.reset = lan937x_reset_switch,
+	.init = lan937x_switch_init,
+	.exit = lan937x_switch_exit,
+};
+
 static const u16 ksz8795_regs[] = {
 	[REG_IND_CTRL_0]		= 0x6E,
 	[REG_IND_DATA_8]		= 0x70,
@@ -542,6 +571,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
+		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -562,6 +592,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
+		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -582,6 +613,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
+		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -606,6 +638,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x38,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
+		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -630,6 +663,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
+		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
new file mode 100644
index 000000000000..534f5a7a1129
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip lan937x dev ops headers
+ * Copyright (C) 2019-2022 Microchip Technology Inc.
+ */
+
+#ifndef __LAN937X_CFG_H
+#define __LAN937X_CFG_H
+
+int lan937x_reset_switch(struct ksz_device *dev);
+int lan937x_setup(struct dsa_switch *ds);
+void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
+void lan937x_config_cpu_port(struct dsa_switch *ds);
+int lan937x_switch_init(struct ksz_device *dev);
+void lan937x_switch_exit(struct ksz_device *dev);
+#endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
new file mode 100644
index 000000000000..e167a0c1ff85
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Microchip LAN937X switch driver main logic
+ * Copyright (C) 2019-2022 Microchip Technology Inc.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/iopoll.h>
+#include <linux/phy.h>
+#include <linux/of_net.h>
+#include <linux/if_bridge.h>
+#include <linux/math.h>
+#include <net/dsa.h>
+#include <net/switchdev.h>
+
+#include "lan937x_reg.h"
+#include "ksz_common.h"
+#include "lan937x.h"
+
+static int lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
+{
+	return regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
+}
+
+static int lan937x_port_cfg(struct ksz_device *dev, int port, int offset,
+			    u8 bits, bool set)
+{
+	return regmap_update_bits(dev->regmap[0], PORT_CTRL_ADDR(port, offset),
+				  bits, set ? bits : 0);
+}
+
+int lan937x_reset_switch(struct ksz_device *dev)
+{
+	u32 data32;
+	int ret;
+
+	/* reset switch */
+	ret = lan937x_cfg(dev, REG_SW_OPERATION, SW_RESET, true);
+	if (ret < 0)
+		return ret;
+
+	/* Enable Auto Aging */
+	ret = lan937x_cfg(dev, REG_SW_LUE_CTRL_1, SW_LINK_AUTO_AGING, true);
+	if (ret < 0)
+		return ret;
+
+	/* disable interrupts */
+	ret = ksz_write32(dev, REG_SW_INT_MASK__4, SWITCH_INT_MASK);
+	if (ret < 0)
+		return ret;
+
+	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0xFF);
+	if (ret < 0)
+		return ret;
+
+	return ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);
+}
+
+void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
+{
+	struct dsa_switch *ds = dev->ds;
+	u8 member;
+
+	/* enable tag tail for host port */
+	if (cpu_port)
+		lan937x_port_cfg(dev, port, REG_PORT_CTRL_0,
+				 PORT_TAIL_TAG_ENABLE, true);
+
+	/* disable frame check length field */
+	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0, PORT_CHECK_LENGTH,
+			 false);
+
+	/* set back pressure for half duplex */
+	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_1, PORT_BACK_PRESSURE,
+			 true);
+
+	/* enable 802.1p priority */
+	lan937x_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_PRIO_ENABLE, true);
+
+	if (!dev->info->internal_phy[port])
+		lan937x_port_cfg(dev, port, REG_PORT_XMII_CTRL_0,
+				 PORT_MII_TX_FLOW_CTRL | PORT_MII_RX_FLOW_CTRL,
+				 true);
+
+	if (cpu_port)
+		member = dsa_user_ports(ds);
+	else
+		member = BIT(dsa_upstream_port(ds, port));
+
+	dev->dev_ops->cfg_port_member(dev, port, member);
+}
+
+void lan937x_config_cpu_port(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+	struct dsa_port *dp;
+
+	dsa_switch_for_each_cpu_port(dp, ds) {
+		if (dev->info->cpu_ports & (1 << dp->index)) {
+			dev->cpu_port = dp->index;
+
+			/* enable cpu port */
+			lan937x_port_setup(dev, dp->index, true);
+		}
+	}
+
+	dsa_switch_for_each_user_port(dp, ds) {
+		ksz_port_stp_state_set(ds, dp->index, BR_STATE_DISABLED);
+	}
+}
+
+int lan937x_setup(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+
+	/* The VLAN aware is a global setting. Mixed vlan
+	 * filterings are not supported.
+	 */
+	ds->vlan_filtering_is_global = true;
+
+	/* Enable aggressive back off for half duplex & UNH mode */
+	lan937x_cfg(dev, REG_SW_MAC_CTRL_0,
+		    (SW_PAUSE_UNH_MODE | SW_NEW_BACKOFF | SW_AGGR_BACKOFF),
+		    true);
+
+	/* If NO_EXC_COLLISION_DROP bit is set, the switch will not drop
+	 * packets when 16 or more collisions occur
+	 */
+	lan937x_cfg(dev, REG_SW_MAC_CTRL_1, NO_EXC_COLLISION_DROP, true);
+
+	/* enable global MIB counter freeze function */
+	lan937x_cfg(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FREEZE, true);
+
+	/* disable CLK125 & CLK25, 1: disable, 0: enable */
+	lan937x_cfg(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
+		    (SW_CLK125_ENB | SW_CLK25_ENB), true);
+
+	return 0;
+}
+
+int lan937x_switch_init(struct ksz_device *dev)
+{
+	dev->port_mask = (1 << dev->info->port_cnt) - 1;
+
+	return 0;
+}
+
+void lan937x_switch_exit(struct ksz_device *dev)
+{
+	lan937x_reset_switch(dev);
+}
+
+MODULE_AUTHOR("Arun Ramadoss <arun.ramadoss@microchip.com>");
+MODULE_DESCRIPTION("Microchip LAN937x Series Switch DSA Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
new file mode 100644
index 000000000000..5e27b2bd2d86
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -0,0 +1,128 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip LAN937X switch register definitions
+ * Copyright (C) 2019-2021 Microchip Technology Inc.
+ */
+#ifndef __LAN937X_REG_H
+#define __LAN937X_REG_H
+
+#define PORT_CTRL_ADDR(port, addr)	((addr) | (((port) + 1)  << 12))
+
+/* 0 - Operation */
+#define REG_SW_INT_STATUS__4		0x0010
+#define REG_SW_INT_MASK__4		0x0014
+
+#define LUE_INT				BIT(31)
+#define TRIG_TS_INT			BIT(30)
+#define APB_TIMEOUT_INT			BIT(29)
+#define OVER_TEMP_INT			BIT(28)
+#define HSR_INT				BIT(27)
+#define PIO_INT				BIT(26)
+#define POR_READY_INT			BIT(25)
+
+#define SWITCH_INT_MASK			\
+	(LUE_INT | TRIG_TS_INT | APB_TIMEOUT_INT | OVER_TEMP_INT | HSR_INT | \
+	 PIO_INT | POR_READY_INT)
+
+#define REG_SW_PORT_INT_STATUS__4	0x0018
+#define REG_SW_PORT_INT_MASK__4		0x001C
+
+/* 1 - Global */
+#define REG_SW_GLOBAL_OUTPUT_CTRL__1	0x0103
+#define SW_CLK125_ENB			BIT(1)
+#define SW_CLK25_ENB			BIT(0)
+
+/* 3 - Operation Control */
+#define REG_SW_OPERATION		0x0300
+
+#define SW_DOUBLE_TAG			BIT(7)
+#define SW_OVER_TEMP_ENABLE		BIT(2)
+#define SW_RESET			BIT(1)
+
+#define REG_SW_LUE_CTRL_0		0x0310
+
+#define SW_VLAN_ENABLE			BIT(7)
+#define SW_DROP_INVALID_VID		BIT(6)
+#define SW_AGE_CNT_M			0x7
+#define SW_AGE_CNT_S			3
+#define SW_RESV_MCAST_ENABLE		BIT(2)
+
+#define REG_SW_LUE_CTRL_1		0x0311
+
+#define UNICAST_LEARN_DISABLE		BIT(7)
+#define SW_FLUSH_STP_TABLE		BIT(5)
+#define SW_FLUSH_MSTP_TABLE		BIT(4)
+#define SW_SRC_ADDR_FILTER		BIT(3)
+#define SW_AGING_ENABLE			BIT(2)
+#define SW_FAST_AGING			BIT(1)
+#define SW_LINK_AUTO_AGING		BIT(0)
+
+#define REG_SW_MAC_CTRL_0		0x0330
+#define SW_NEW_BACKOFF			BIT(7)
+#define SW_PAUSE_UNH_MODE		BIT(1)
+#define SW_AGGR_BACKOFF			BIT(0)
+
+#define REG_SW_MAC_CTRL_1		0x0331
+#define SW_SHORT_IFG			BIT(7)
+#define MULTICAST_STORM_DISABLE		BIT(6)
+#define SW_BACK_PRESSURE		BIT(5)
+#define FAIR_FLOW_CTRL			BIT(4)
+#define NO_EXC_COLLISION_DROP		BIT(3)
+#define SW_LEGAL_PACKET_DISABLE		BIT(1)
+#define SW_PASS_SHORT_FRAME		BIT(0)
+
+#define REG_SW_MAC_CTRL_6		0x0336
+#define SW_MIB_COUNTER_FLUSH		BIT(7)
+#define SW_MIB_COUNTER_FREEZE		BIT(6)
+
+/* 4 - LUE */
+#define REG_SW_ALU_STAT_CTRL__4		0x041C
+
+#define REG_SW_ALU_VAL_B		0x0424
+#define ALU_V_OVERRIDE			BIT(31)
+#define ALU_V_USE_FID			BIT(30)
+#define ALU_V_PORT_MAP			0xFF
+
+/* Port Registers */
+
+/* 0 - Operation */
+#define REG_PORT_CTRL_0			0x0020
+
+#define PORT_MAC_LOOPBACK		BIT(7)
+#define PORT_MAC_REMOTE_LOOPBACK	BIT(6)
+#define PORT_K2L_INSERT_ENABLE		BIT(5)
+#define PORT_K2L_DEBUG_ENABLE		BIT(4)
+#define PORT_TAIL_TAG_ENABLE		BIT(2)
+#define PORT_QUEUE_SPLIT_ENABLE		0x3
+
+/* 3 - xMII */
+#define REG_PORT_XMII_CTRL_0		0x0300
+#define PORT_SGMII_SEL			BIT(7)
+#define PORT_MII_FULL_DUPLEX		BIT(6)
+#define PORT_MII_TX_FLOW_CTRL		BIT(5)
+#define PORT_MII_100MBIT		BIT(4)
+#define PORT_MII_RX_FLOW_CTRL		BIT(3)
+#define PORT_GRXC_ENABLE		BIT(0)
+
+/* 4 - MAC */
+#define REG_PORT_MAC_CTRL_0		0x0400
+#define PORT_CHECK_LENGTH		BIT(2)
+#define PORT_BROADCAST_STORM		BIT(1)
+#define PORT_JUMBO_PACKET		BIT(0)
+
+#define REG_PORT_MAC_CTRL_1		0x0401
+#define PORT_BACK_PRESSURE		BIT(3)
+#define PORT_PASS_ALL			BIT(0)
+
+/* 8 - Classification and Policing */
+#define REG_PORT_MRI_PRIO_CTRL		0x0801
+#define PORT_HIGHEST_PRIO		BIT(7)
+#define PORT_OR_PRIO			BIT(6)
+#define PORT_MAC_PRIO_ENABLE		BIT(4)
+#define PORT_VLAN_PRIO_ENABLE		BIT(3)
+#define PORT_802_1P_PRIO_ENABLE		BIT(2)
+#define PORT_DIFFSERV_PRIO_ENABLE	BIT(1)
+#define PORT_ACL_PRIO_ENABLE		BIT(0)
+
+#define P_PRIO_CTRL			REG_PORT_MRI_PRIO_CTRL
+
+#endif
-- 
2.36.1

