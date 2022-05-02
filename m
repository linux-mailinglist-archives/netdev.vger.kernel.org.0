Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68138517394
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386208AbiEBQFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386206AbiEBQFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:05:14 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C53311A3E;
        Mon,  2 May 2022 09:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651507272; x=1683043272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZL7OpwFcLxsLhR7g3/qB10ah0RPFKUxQIIxcnn40WpQ=;
  b=WhLTkPAwjERZcPbW0B7lWZyUdtqO4nbkW+lKQE+9mFXQs1jHZkG7qb7R
   MtMu+RCun8oBDCzlZWiIIhAWEVd9x1V9Z442hoB6E12AYqHcPAuWRAvSs
   EyVykpaSafwa2o5QWO2IGJ9S/Zbrty5M4wyJy31FjwQYWkTdlDs+4UfH7
   5mgEzXXaAJnSF63acBxT2xhtIejLS9cbmXW1tGiefjxpSuqwEwREgMYGs
   2O+07q2qesVKo6+VKzxSIELRDEGiJb+bwh+ifVAI/HHbH8T4dWGTUiK8o
   WUVXbbU4kH7UKbRH0L3h6WNqDV2Solv2tcj3kJhm3lAtSeRX7ZpilBY6O
   w==;
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="154543907"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 May 2022 09:01:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 2 May 2022 09:01:08 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 2 May 2022 09:00:50 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [Patch net-next v12 05/13] net: dsa: microchip: add DSA support for microchip LAN937x
Date:   Mon, 2 May 2022 21:28:40 +0530
Message-ID: <20220502155848.30493-6-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220502155848.30493-1-arun.ramadoss@microchip.com>
References: <20220502155848.30493-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

drivers/net/dsa/microchip/ path is already part of MAINTAINERS &
the new files come under this path. Hence no update needed to the
MAINTAINERS

Reused KSZ APIs for port_bridge_join() & port_bridge_leave() and
added support for port_stp_state_set().

RGMII internal delay values for the mac is retrieved from
rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
v3 patch series.
https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/

It supports standard delay 2ns only. If the property is not found, the
value will be forced to 0.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/Kconfig        |  12 +
 drivers/net/dsa/microchip/Makefile       |   4 +
 drivers/net/dsa/microchip/ksz_common.h   |   5 +
 drivers/net/dsa/microchip/lan937x_dev.c  | 251 +++++++++
 drivers/net/dsa/microchip/lan937x_dev.h  |  36 ++
 drivers/net/dsa/microchip/lan937x_main.c | 216 +++++++
 drivers/net/dsa/microchip/lan937x_reg.h  | 688 +++++++++++++++++++++++
 7 files changed, 1212 insertions(+)
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_main.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_reg.h

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index c9e2a8989556..f329cca934ee 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -3,6 +3,18 @@ config NET_DSA_MICROCHIP_KSZ_COMMON
 	select NET_DSA_TAG_KSZ
 	tristate
 
+config NET_DSA_MICROCHIP_LAN937X
+	tristate "Microchip LAN937X series SPI connected switch support"
+	depends on NET_DSA && SPI
+	select NET_DSA_MICROCHIP_KSZ_COMMON
+	select REGMAP_SPI
+	help
+	  This driver adds support for Microchip LAN937X series
+	  switch chips.
+
+	  Select to enable support for registering switches configured
+	  through SPI.
+
 menuconfig NET_DSA_MICROCHIP_KSZ9477
 	tristate "Microchip KSZ9477 series switch support"
 	depends on NET_DSA
diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 2a03b21a3386..d32ff38dc240 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -6,3 +6,7 @@ obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795)		+= ksz8795.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795_SPI)	+= ksz8795_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
+
+obj-$(CONFIG_NET_DSA_MICROCHIP_LAN937X)		+= lan937x.o
+lan937x-objs := lan937x_dev.o
+lan937x-objs += lan937x_main.o
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 28cda79b090f..ebbeb025c468 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -42,6 +42,8 @@ struct ksz_port {
 	struct ksz_port_mib mib;
 	phy_interface_t interface;
 	u16 max_frame;
+	u32 rgmii_tx_val;
+	u32 rgmii_rx_val;
 };
 
 struct ksz_device {
@@ -148,6 +150,9 @@ void ksz_switch_remove(struct ksz_device *dev);
 
 int ksz8_switch_register(struct ksz_device *dev);
 int ksz9477_switch_register(struct ksz_device *dev);
+int lan937x_switch_register(struct ksz_device *dev);
+
+int lan937x_check_device_id(struct ksz_device *dev);
 
 void ksz_update_port_member(struct ksz_device *dev, int port);
 void ksz_init_mib_timer(struct ksz_device *dev);
diff --git a/drivers/net/dsa/microchip/lan937x_dev.c b/drivers/net/dsa/microchip/lan937x_dev.c
new file mode 100644
index 000000000000..c6bd8fac735d
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x_dev.c
@@ -0,0 +1,251 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Microchip lan937x dev ops functions
+ * Copyright (C) 2019-2021 Microchip Technology Inc.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/iopoll.h>
+#include <linux/of_mdio.h>
+#include <linux/platform_data/microchip-ksz.h>
+#include <linux/phy.h>
+#include <linux/if_bridge.h>
+#include <net/dsa.h>
+#include <net/switchdev.h>
+
+#include "lan937x_reg.h"
+#include "ksz_common.h"
+#include "lan937x_dev.h"
+
+int lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
+{
+	return regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
+}
+
+int lan937x_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
+		     bool set)
+{
+	return regmap_update_bits(dev->regmap[0], PORT_CTRL_ADDR(port, offset),
+				  bits, set ? bits : 0);
+}
+
+int lan937x_pread8(struct ksz_device *dev, int port, int offset, u8 *data)
+{
+	return ksz_read8(dev, PORT_CTRL_ADDR(port, offset), data);
+}
+
+int lan937x_pread16(struct ksz_device *dev, int port, int offset, u16 *data)
+{
+	return ksz_read16(dev, PORT_CTRL_ADDR(port, offset), data);
+}
+
+int lan937x_pread32(struct ksz_device *dev, int port, int offset, u32 *data)
+{
+	return ksz_read32(dev, PORT_CTRL_ADDR(port, offset), data);
+}
+
+int lan937x_pwrite8(struct ksz_device *dev, int port, int offset, u8 data)
+{
+	return ksz_write8(dev, PORT_CTRL_ADDR(port, offset), data);
+}
+
+int lan937x_pwrite16(struct ksz_device *dev, int port, int offset, u16 data)
+{
+	return ksz_write16(dev, PORT_CTRL_ADDR(port, offset), data);
+}
+
+int lan937x_pwrite32(struct ksz_device *dev, int port, int offset, u32 data)
+{
+	return ksz_write32(dev, PORT_CTRL_ADDR(port, offset), data);
+}
+
+void lan937x_cfg_port_member(struct ksz_device *dev, int port, u8 member)
+{
+	lan937x_pwrite32(dev, port, REG_PORT_VLAN_MEMBERSHIP__4, member);
+}
+
+int lan937x_reset_switch(struct ksz_device *dev)
+{
+	u32 data32;
+	u8 data8;
+	int ret;
+
+	/* reset switch */
+	ret = lan937x_cfg(dev, REG_SW_OPERATION, SW_RESET, true);
+	if (ret < 0)
+		return ret;
+
+	ret = ksz_read8(dev, REG_SW_LUE_CTRL_1, &data8);
+	if (ret < 0)
+		return ret;
+
+	/* Enable Auto Aging */
+	ret = ksz_write8(dev, REG_SW_LUE_CTRL_1, data8 | SW_LINK_AUTO_AGING);
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
+static int lan937x_switch_detect(struct ksz_device *dev)
+{
+	u32 id32;
+	int ret;
+
+	/* Read Chip ID */
+	ret = ksz_read32(dev, REG_CHIP_ID0__1, &id32);
+	if (ret < 0)
+		return ret;
+
+	if (id32 != 0 && id32 != 0xffffffff) {
+		dev->chip_id = id32;
+		dev_info(dev->dev, "Chip ID: 0x%x", id32);
+		ret = 0;
+	} else {
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static void lan937x_switch_exit(struct ksz_device *dev)
+{
+	lan937x_reset_switch(dev);
+}
+
+static u32 lan937x_get_port_addr(int port, int offset)
+{
+	return PORT_CTRL_ADDR(port, offset);
+}
+
+bool lan937x_is_internal_phy_port(struct ksz_device *dev, int port)
+{
+	/* Check if the port is RGMII */
+	if (port == LAN937X_RGMII_1_PORT || port == LAN937X_RGMII_2_PORT)
+		return false;
+
+	/* Check if the port is SGMII */
+	if (port == LAN937X_SGMII_PORT &&
+	    GET_CHIP_ID_LSB(dev->chip_id) == CHIP_ID_73)
+		return false;
+
+	return true;
+}
+
+bool lan937x_is_rgmii_port(struct ksz_device *dev, int port)
+{
+	/* Check if the port is RGMII */
+	if (port == LAN937X_RGMII_1_PORT || port == LAN937X_RGMII_2_PORT)
+		return true;
+
+	return false;
+}
+
+bool lan937x_is_internal_base_tx_phy_port(struct ksz_device *dev, int port)
+{
+	/* Check if the port is internal tx phy port */
+	if (lan937x_is_internal_phy_port(dev, port) &&
+	    port == LAN937X_TXPHY_PORT)
+		if ((GET_CHIP_ID_LSB(dev->chip_id) == CHIP_ID_71) ||
+		    (GET_CHIP_ID_LSB(dev->chip_id) == CHIP_ID_72))
+			return true;
+
+	return false;
+}
+
+bool lan937x_is_internal_base_t1_phy_port(struct ksz_device *dev, int port)
+{
+	/* Check if the port is internal t1 phy port */
+	if (lan937x_is_internal_phy_port(dev, port) &&
+	    !lan937x_is_internal_base_tx_phy_port(dev, port))
+		return true;
+
+	return false;
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
+	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0, PORT_FR_CHK_LENGTH,
+			 false);
+
+	/* set back pressure for half duplex */
+	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_1, PORT_BACK_PRESSURE,
+			 true);
+
+	/* enable 802.1p priority */
+	lan937x_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_PRIO_ENABLE, true);
+
+	if (!lan937x_is_internal_phy_port(dev, port))
+		lan937x_port_cfg(dev, port, REG_PORT_XMII_CTRL_0,
+				 PORT_TX_FLOW_CTRL | PORT_RX_FLOW_CTRL,
+				 true);
+
+	if (cpu_port)
+		member = dsa_user_ports(ds);
+	else
+		member = BIT(dsa_upstream_port(ds, port));
+
+	lan937x_cfg_port_member(dev, port, member);
+}
+
+static int lan937x_switch_init(struct ksz_device *dev)
+{
+	int ret;
+
+	dev->ds->ops = &lan937x_switch_ops;
+
+	/* Check device tree */
+	ret = lan937x_check_device_id(dev);
+	if (ret < 0)
+		return ret;
+
+	dev->port_mask = (1 << dev->port_cnt) - 1;
+
+	dev->ports = devm_kzalloc(dev->dev,
+				  dev->port_cnt * sizeof(struct ksz_port),
+				  GFP_KERNEL);
+	if (!dev->ports)
+		return -ENOMEM;
+
+	/* set the real number of ports */
+	dev->ds->num_ports = dev->port_cnt;
+	return 0;
+}
+
+static int lan937x_init(struct ksz_device *dev)
+{
+	int ret;
+
+	ret = lan937x_switch_init(dev);
+	if (ret < 0)
+		dev_err(dev->dev, "failed to initialize the switch");
+
+	return ret;
+}
+
+const struct ksz_dev_ops lan937x_dev_ops = {
+	.get_port_addr = lan937x_get_port_addr,
+	.cfg_port_member = lan937x_cfg_port_member,
+	.port_setup = lan937x_port_setup,
+	.shutdown = lan937x_reset_switch,
+	.detect = lan937x_switch_detect,
+	.init = lan937x_init,
+	.exit = lan937x_switch_exit,
+};
diff --git a/drivers/net/dsa/microchip/lan937x_dev.h b/drivers/net/dsa/microchip/lan937x_dev.h
new file mode 100644
index 000000000000..21f4aade0199
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x_dev.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip lan937x dev ops headers
+ * Copyright (C) 2019-2021 Microchip Technology Inc.
+ */
+
+#ifndef __LAN937X_CFG_H
+#define __LAN937X_CFG_H
+
+int lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set);
+int lan937x_port_cfg(struct ksz_device *dev, int port, int offset,
+		     u8 bits, bool set);
+int lan937x_pread8(struct ksz_device *dev, int port, int offset,
+		   u8 *data);
+int lan937x_pread16(struct ksz_device *dev, int port, int offset,
+		    u16 *data);
+int lan937x_pread32(struct ksz_device *dev, int port, int offset,
+		    u32 *data);
+int lan937x_pwrite8(struct ksz_device *dev, int port,
+		    int offset, u8 data);
+int lan937x_pwrite16(struct ksz_device *dev, int port,
+		     int offset, u16 data);
+int lan937x_pwrite32(struct ksz_device *dev, int port,
+		     int offset, u32 data);
+bool lan937x_is_internal_phy_port(struct ksz_device *dev, int port);
+bool lan937x_is_internal_base_tx_phy_port(struct ksz_device *dev, int port);
+bool lan937x_is_internal_base_t1_phy_port(struct ksz_device *dev, int port);
+bool lan937x_is_rgmii_port(struct ksz_device *dev, int port);
+int lan937x_reset_switch(struct ksz_device *dev);
+void lan937x_cfg_port_member(struct ksz_device *dev, int port,
+			     u8 member);
+void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
+
+extern const struct dsa_switch_ops lan937x_switch_ops;
+extern const struct ksz_dev_ops lan937x_dev_ops;
+
+#endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
new file mode 100644
index 000000000000..154d7a0f08ac
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -0,0 +1,216 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Microchip LAN937X switch driver main logic
+ * Copyright (C) 2019-2021 Microchip Technology Inc.
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
+#include "lan937x_dev.h"
+
+static enum dsa_tag_protocol lan937x_get_tag_protocol(struct dsa_switch *ds,
+						      int port,
+						      enum dsa_tag_protocol mp)
+{
+	return DSA_TAG_PROTO_LAN937X_VALUE;
+}
+
+static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
+				       u8 state)
+{
+	ksz_port_stp_state_set(ds, port, state, P_STP_CTRL);
+}
+
+static void lan937x_config_cpu_port(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+	int i;
+
+	ds->num_ports = dev->port_cnt;
+
+	for (i = 0; i < dev->port_cnt; i++) {
+		if (dsa_is_cpu_port(ds, i) && (dev->cpu_ports & (1 << i))) {
+			dev->cpu_port = i;
+
+			/* enable cpu port */
+			lan937x_port_setup(dev, i, true);
+		}
+	}
+
+	for (i = 0; i < dev->port_cnt; i++) {
+		if (i == dev->cpu_port)
+			continue;
+
+		lan937x_port_stp_state_set(ds, i, BR_STATE_DISABLED);
+	}
+}
+
+static int lan937x_set_rgmii_delay(struct ksz_device *dev, int port,
+				   u32 val, bool is_tx)
+{
+	struct ksz_port *p = &dev->ports[port];
+	const char *name[2] = { "rx", "tx" };
+
+	/* alert if delay is out of range */
+	if (val != 0 && val != 2000) {
+		dev_err(dev->dev,
+			"rgmii %s delay %d is out of range for the port %d\n",
+			name[is_tx], val, port);
+		return -EOPNOTSUPP;
+	}
+
+	/* get the valid value & store it for delay calculation */
+	if (is_tx)
+		p->rgmii_tx_val = val;
+	else
+		p->rgmii_rx_val = val;
+
+	return 0;
+}
+
+static int lan937x_parse_dt_rgmii_delay(struct ksz_device *dev)
+{
+	struct device_node *ports, *port;
+	int err, p;
+	u32 val;
+
+	ports = of_get_child_by_name(dev->dev->of_node, "ports");
+	if (!ports)
+		ports = of_get_child_by_name(dev->dev->of_node,
+					     "ethernet-ports");
+	if (!ports) {
+		dev_err(dev->dev, "no ports child node found\n");
+		return -EINVAL;
+	}
+
+	for_each_available_child_of_node(ports, port) {
+		err = of_property_read_u32(port, "reg", &p);
+		if (err) {
+			dev_err(dev->dev, "Port num not defined in the DT, \"reg\" property\n");
+			of_node_put(ports);
+			of_node_put(port);
+			return err;
+		}
+
+		/* Apply only for rgmii port */
+		if (!lan937x_is_rgmii_port(dev, p))
+			continue;
+
+		if (of_property_read_u32(port, "rx-internal-delay-ps", &val))
+			val = 0;
+
+		err = lan937x_set_rgmii_delay(dev, p, val, false);
+		if (err)
+			break;
+
+		if (of_property_read_u32(port, "tx-internal-delay-ps", &val))
+			val = 0;
+
+		err = lan937x_set_rgmii_delay(dev, p, val, true);
+		if (err)
+			break;
+	}
+
+	of_node_put(ports);
+	return err;
+}
+
+static int lan937x_setup(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+	u32 data32;
+	u8 data8;
+	int ret;
+
+	ret = lan937x_reset_switch(dev);
+	if (ret < 0)
+		return ret;
+
+	ret = ksz_read8(dev, REG_SW_LUE_CTRL_1, &data8);
+	if (ret < 0)
+		return ret;
+
+	/* Enable Auto Aging */
+	ret = ksz_write8(dev, REG_SW_LUE_CTRL_1, data8 | SW_LINK_AUTO_AGING);
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
+	/* Read interrupt status register */
+	ret = ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);
+	if (ret < 0)
+		return ret;
+
+	/* Apply rgmii internal delay for the mac based on device tree */
+	ret = lan937x_parse_dt_rgmii_delay(dev);
+	if (ret < 0)
+		return ret;
+
+	/* The VLAN aware is a global setting. Mixed vlan
+	 * filterings are not supported.
+	 */
+	ds->vlan_filtering_is_global = true;
+
+	/* Configure cpu port */
+	lan937x_config_cpu_port(ds);
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
+	/* Enable reserved multicast table */
+	lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_RESV_MCAST_ENABLE, true);
+
+	/* enable global MIB counter freeze function */
+	lan937x_cfg(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FREEZE, true);
+
+	/* disable CLK125 & CLK25, 1: disable, 0: enable */
+	lan937x_cfg(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
+		    (SW_CLK125_ENB | SW_CLK25_ENB), true);
+
+	/* start switch */
+	lan937x_cfg(dev, REG_SW_OPERATION, SW_START, true);
+
+	return 0;
+}
+
+const struct dsa_switch_ops lan937x_switch_ops = {
+	.get_tag_protocol = lan937x_get_tag_protocol,
+	.setup = lan937x_setup,
+	.port_enable = ksz_enable_port,
+	.port_bridge_join = ksz_port_bridge_join,
+	.port_bridge_leave = ksz_port_bridge_leave,
+	.port_stp_state_set = lan937x_port_stp_state_set,
+};
+
+int lan937x_switch_register(struct ksz_device *dev)
+{
+	return ksz_switch_register(dev, &lan937x_dev_ops);
+}
+EXPORT_SYMBOL(lan937x_switch_register);
+
+MODULE_AUTHOR("Prasanna Vengateshan Varadharajan <Prasanna.Vengateshan@microchip.com>");
+MODULE_DESCRIPTION("Microchip LAN937x Series Switch DSA Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
new file mode 100644
index 000000000000..d0de595f6c4e
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -0,0 +1,688 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip LAN937X switch register definitions
+ * Copyright (C) 2019-2021 Microchip Technology Inc.
+ */
+#ifndef __LAN937X_REG_H
+#define __LAN937X_REG_H
+
+/* 0 - Operation */
+#define REG_CHIP_ID0__1			0x0000
+#define REG_CHIP_ID1__1			0x0001
+#define REG_CHIP_ID2__1			0x0002
+
+#define CHIP_ID_74			0x74
+#define CHIP_ID_73			0x73
+#define CHIP_ID_72			0x72
+#define CHIP_ID_71			0x71
+#define CHIP_ID_70			0x70
+
+#define REG_CHIP_ID3__1			0x0003
+
+#define REG_GLOBAL_CTRL_0		0x0007
+
+#define SW_PHY_REG_BLOCK		BIT(7)
+#define SW_FAST_MODE			BIT(3)
+#define SW_FAST_MODE_OVERRIDE		BIT(2)
+
+#define REG_GLOBAL_OPTIONS		0x000F
+
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
+#define REG_SW_GLOBAL_SERIAL_CTRL_0	0x0100
+
+#define SW_LITTLE_ENDIAN		BIT(4)
+#define SPI_AUTO_EDGE_DETECTION		BIT(1)
+#define SPI_CLOCK_OUT_RISING_EDGE	BIT(0)
+
+#define REG_SW_GLOBAL_OUTPUT_CTRL__1	0x0103
+#define SW_CLK125_ENB			BIT(1)
+#define SW_CLK25_ENB			BIT(0)
+
+/* 2 - PHY */
+#define REG_SW_POWER_MANAGEMENT_CTRL	0x0201
+
+/* 3 - Operation Control */
+#define REG_SW_OPERATION		0x0300
+
+#define SW_DOUBLE_TAG			BIT(7)
+#define SW_OVER_TEMP_ENABLE		BIT(2)
+#define SW_RESET			BIT(1)
+#define SW_START			BIT(0)
+
+#define REG_SW_LUE_CTRL_0		0x0310
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
+#define REG_SW_LUE_CTRL_2		0x0312
+
+#define SW_MID_RANGE_AGE		BIT(7)
+#define SW_LINK_DOWN_FLUSH		BIT(6)
+#define SW_EGRESS_VLAN_FILTER_DYN	BIT(5)
+#define SW_EGRESS_VLAN_FILTER_STA	BIT(4)
+#define SW_FLUSH_OPTION_M		0x3
+#define SW_FLUSH_OPTION_S		2
+#define SW_FLUSH_OPTION_DYN_MAC		1
+#define SW_FLUSH_OPTION_STA_MAC		2
+#define SW_FLUSH_OPTION_BOTH		3
+
+#define REG_SW_LUE_CTRL_3		0x0313
+#define REG_SW_AGE_PERIOD__1		0x0313
+
+#define REG_SW_LUE_INT_STATUS__1	0x0314
+#define REG_SW_LUE_INT_MASK__1		0x0315
+
+#define LEARN_FAIL_INT			BIT(2)
+#define WRITE_FAIL_INT			BIT(0)
+
+#define LUE_INT_MASK			(LEARN_FAIL_INT | WRITE_FAIL_INT)
+
+#define REG_SW_LUE_INDEX_0__2		0x0316
+
+#define ENTRY_INDEX_M			0x0FFF
+
+#define REG_SW_LUE_INDEX_1__2		0x0318
+
+#define FAIL_INDEX_M			0x03FF
+
+#define REG_SW_LUE_INDEX_2__2		0x031A
+
+#define REG_SW_STATIC_AVAIL_ENTRY__4	0x031C
+
+#define SW_INGRESS_FILTERING_NO_LEARN	BIT(15)
+#define SW_STATIC_AVAIL_CNT		0x1FF
+
+#define REG_SW_AGE_PERIOD__2		0x0320
+#define SW_AGE_PERIOD_M			0xFFF
+
+#define REG_SW_LUE_UNK_UCAST_CTRL__2	0x0322
+#define REG_SW_LUE_UNK_CTRL_0__4	0x0322
+
+#define SW_UNK_UCAST_ENABLE		BIT(15)
+#define SW_UNK_PORTS_M			0xFF
+
+#define REG_SW_LUE_UNK_MCAST_CTRL__2	0x0324
+#define SW_UNK_MCAST_ENABLE		BIT(15)
+
+#define REG_SW_LUE_UNK_VID_CTRL__2	0x0326
+#define SW_UNK_VID_ENABLE		BIT(15)
+
+#define SW_VLAN_FLUSH_PORTS_M		0xFF
+
+#define REG_SW_STATIC_ENTRY_LIMIT__4	0x032C
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
+#define REG_SW_MAC_CTRL_2		0x0332
+#define SW_REPLACE_VID			BIT(3)
+#define BROADCAST_STORM_RATE_HI		0x07
+
+#define REG_SW_MAC_CTRL_3		0x0333
+#define BROADCAST_STORM_RATE_LO		0xFF
+#define BR_STORM_RATE			0x07FF
+
+#define REG_SW_MAC_CTRL_4		0x0334
+#define SW_PASS_PAUSE			BIT(3)
+
+#define REG_SW_MAC_CTRL_5		0x0335
+#define SW_OUT_RATE_LIMIT_QUEUE_BASED	BIT(3)
+
+#define REG_SW_MAC_CTRL_6		0x0336
+#define SW_MIB_COUNTER_FLUSH		BIT(7)
+#define SW_MIB_COUNTER_FREEZE		BIT(6)
+
+#define REG_SW_MRI_CTRL_0		0x0370
+#define SW_IGMP_SNOOP			BIT(6)
+#define SW_IPV6_MLD_OPTION		BIT(3)
+#define SW_IPV6_MLD_SNOOP		BIT(2)
+#define SW_MIRROR_RX_TX			BIT(0)
+
+#define REG_SW_MRI_CTRL_1__4		0x0374
+#define REG_SW_MRI_CTRL_2__4		0x0378
+#define REG_SW_CLASS_D_IP_CTRL__4	0x0374
+
+#define SW_CLASS_D_IP_ENABLE		BIT(31)
+
+#define REG_SW_MRI_CTRL_8		0x0378
+#define SW_RED_COLOR_S			4
+#define SW_YELLOW_COLOR_S		2
+#define SW_GREEN_COLOR_S		0
+#define SW_COLOR_M			0x3
+
+#define REG_PTP_EVENT_PRIO_CTRL		0x037C
+#define REG_PTP_GENERAL_PRIO_CTRL	0x037D
+#define PTP_PRIO_ENABLE			BIT(7)
+
+#define REG_SW_QM_CTRL__4		0x0390
+#define PRIO_SCHEME_SELECT_M		KS_PRIO_M
+#define PRIO_SCHEME_SELECT_S		6
+#define PRIO_MAP_3_HI			0
+#define PRIO_MAP_2_HI			2
+#define PRIO_MAP_0_LO			3
+#define UNICAST_VLAN_BOUNDARY		BIT(1)
+
+#define REG_SW_EEE_QM_CTRL__2		0x03C0
+#define REG_SW_EEE_TXQ_WAIT_TIME__2	0x03C2
+
+/* 4 - */
+#define REG_SW_VLAN_ENTRY__4		0x0400
+#define VLAN_VALID			BIT(31)
+#define VLAN_FORWARD_OPTION		BIT(27)
+#define VLAN_PRIO_M			KS_PRIO_M
+#define VLAN_PRIO_S			24
+#define VLAN_MSTP_M			0x7
+#define VLAN_MSTP_S			12
+#define VLAN_FID_M			0x7F
+
+#define REG_SW_VLAN_ENTRY_UNTAG__4	0x0404
+#define REG_SW_VLAN_ENTRY_PORTS__4	0x0408
+#define REG_SW_VLAN_ENTRY_INDEX__2	0x040C
+
+#define VLAN_INDEX_M			0x0FFF
+
+#define REG_SW_VLAN_CTRL		0x040E
+#define VLAN_START			BIT(7)
+#define VLAN_ACTION			0x3
+#define VLAN_WRITE			1
+#define VLAN_READ			2
+#define VLAN_CLEAR			3
+
+#define REG_SW_ALU_INDEX_0		0x0410
+#define ALU_FID_INDEX_S			16
+#define ALU_FID_SIZE			127
+#define ALU_MAC_ADDR_HI			0xFFFF
+
+#define REG_SW_ALU_INDEX_1		0x0414
+#define ALU_DIRECT_INDEX_M		(BIT(12) - 1)
+
+#define REG_SW_ALU_CTRL__4		0x0418
+#define REG_SW_ALU_CTRL(num)	(REG_SW_ALU_CTRL__4 + ((num) * 4))
+
+#define ALU_STA_DYN_CNT			2
+#define ALU_VALID_CNT_M			(BIT(14) - 1)
+#define ALU_VALID_CNT_S			16
+#define ALU_START			BIT(7)
+#define ALU_VALID			BIT(6)
+#define ALU_VALID_OR_STOP		BIT(5)
+#define ALU_DIRECT			BIT(2)
+#define ALU_ACTION			0x3
+#define ALU_WRITE			1
+#define ALU_READ			2
+#define ALU_SEARCH			3
+
+#define REG_SW_ALU_STAT_CTRL__4		0x041C
+#define ALU_STAT_VALID_CNT_M		(BIT(9) - 1)
+#define ALU_STAT_VALID_CNT_S		20
+#define ALU_STAT_INDEX_M		(BIT(8) - 1)
+#define ALU_STAT_INDEX_S		8
+#define ALU_RESV_MCAST_INDEX_M		(BIT(6) - 1)
+#define ALU_STAT_START			BIT(7)
+#define ALU_STAT_VALID			BIT(6)
+#define ALU_STAT_VALID_OR_STOP		BIT(5)
+#define ALU_STAT_USE_FID		BIT(4)
+#define ALU_STAT_DIRECT			BIT(3)
+#define ALU_RESV_MCAST_ADDR		BIT(2)
+#define ALU_STAT_ACTION			0x3
+#define ALU_STAT_WRITE			1
+#define ALU_STAT_READ			2
+#define ALU_STAT_SEARCH			3
+
+#define REG_SW_ALU_VAL_A		0x0420
+#define ALU_V_STATIC_VALID		BIT(31)
+#define ALU_V_SRC_FILTER		BIT(30)
+#define ALU_V_DST_FILTER		BIT(29)
+#define ALU_V_PRIO_AGE_CNT_M		(BIT(3) - 1)
+#define ALU_V_PRIO_AGE_CNT_S		26
+#define ALU_V_MSTP_M			0x7
+
+#define REG_SW_ALU_VAL_B		0x0424
+#define ALU_V_OVERRIDE			BIT(31)
+#define ALU_V_USE_FID			BIT(30)
+#define ALU_V_PORT_MAP			0xFF
+
+#define REG_SW_ALU_VAL_C		0x0428
+#define ALU_V_FID_M			(BIT(16) - 1)
+#define ALU_V_FID_S			16
+#define ALU_V_MAC_ADDR_HI		0xFFFF
+
+#define REG_SW_ALU_VAL_D		0x042C
+
+#define PORT_CTRL_ADDR(port, addr)	((addr) | (((port) + 1)  << 12))
+
+#define REG_GLOBAL_RR_INDEX__1		0x0600
+
+/* VPHY */
+#define REG_VPHY_CTRL__2		0x0700
+#define REG_VPHY_STAT__2		0x0704
+#define REG_VPHY_ID_HI__2		0x0708
+#define REG_VPHY_ID_LO__2		0x070C
+#define REG_VPHY_AUTO_NEG__2		0x0710
+#define REG_VPHY_REMOTE_CAP__2		0x0714
+
+#define REG_VPHY_EXPANSION__2		0x0718
+
+#define REG_VPHY_M_CTRL__2		0x0724
+#define REG_VPHY_M_STAT__2		0x0728
+
+#define REG_VPHY_EXT_STAT__2		0x073C
+#define VPHY_EXT_1000_X_FULL		BIT(15)
+#define VPHY_EXT_1000_X_HALF		BIT(14)
+#define VPHY_EXT_1000_T_FULL		BIT(13)
+#define VPHY_EXT_1000_T_HALF		BIT(12)
+
+#define REG_VPHY_DEVAD_0__2		0x0740
+#define REG_VPHY_DEVAD_1__2		0x0744
+#define REG_VPHY_DEVAD_2__2		0x0748
+#define REG_VPHY_DEVAD_3__2		0x074C
+
+#define VPHY_DEVAD_UPDATE		BIT(7)
+#define VPHY_DEVAD_M			0x1F
+#define VPHY_DEVAD_S			8
+
+#define REG_VPHY_SMI_ADDR__2		0x0750
+#define REG_VPHY_SMI_DATA_LO__2		0x0754
+#define REG_VPHY_SMI_DATA_HI__2		0x0758
+
+#define REG_VPHY_IND_ADDR__2		0x075C
+#define REG_VPHY_IND_DATA__2		0x0760
+#define REG_VPHY_IND_CTRL__2		0x0768
+
+#define VPHY_IND_WRITE			BIT(1)
+#define VPHY_IND_BUSY			BIT(0)
+
+#define REG_VPHY_SPECIAL_CTRL__2	0x077C
+#define VPHY_SMI_INDIRECT_ENABLE	BIT(15)
+#define VPHY_SW_LOOPBACK		BIT(14)
+#define VPHY_MDIO_INTERNAL_ENABLE	BIT(13)
+#define VPHY_SPI_INDIRECT_ENABLE	BIT(12)
+#define VPHY_PORT_MODE_M		0x3
+#define VPHY_PORT_MODE_S		8
+#define VPHY_MODE_RGMII			0
+#define VPHY_MODE_MII_PHY		1
+#define VPHY_MODE_SGMII			2
+#define VPHY_MODE_RMII_PHY		3
+#define VPHY_SW_COLLISION_TEST		BIT(7)
+#define VPHY_SPEED_DUPLEX_STAT_M	0x7
+#define VPHY_SPEED_DUPLEX_STAT_S	2
+#define VPHY_SPEED_1000			BIT(4)
+#define VPHY_SPEED_100			BIT(3)
+#define VPHY_FULL_DUPLEX		BIT(2)
+
+/* 0 - Operation */
+#define REG_PORT_DEFAULT_VID		0x0000
+
+#define REG_PORT_CUSTOM_VID		0x0002
+#define REG_PORT_PME_STATUS		0x0013
+
+#define REG_PORT_PME_CTRL		0x0017
+#define PME_WOL_MAGICPKT		BIT(2)
+#define PME_WOL_LINKUP			BIT(1)
+#define PME_WOL_ENERGY			BIT(0)
+
+#define REG_PORT_INT_STATUS		0x001B
+#define REG_PORT_INT_MASK		0x001F
+
+#define PORT_TAS_INT			BIT(5)
+#define PORT_SGMII_INT			BIT(3)
+#define PORT_PTP_INT			BIT(2)
+#define PORT_PHY_INT			BIT(1)
+#define PORT_ACL_INT			BIT(0)
+
+#define PORT_INT_MASK			\
+	(				\
+	PORT_TAS_INT |			\
+	PORT_SGMII_INT | PORT_PTP_INT | PORT_PHY_INT | PORT_ACL_INT)
+
+#define REG_PORT_CTRL_0			0x0020
+
+#define PORT_MAC_LOOPBACK		BIT(7)
+#define PORT_MAC_REMOTE_LOOPBACK	BIT(6)
+#define PORT_K2L_INSERT_ENABLE		BIT(5)
+#define PORT_K2L_DEBUG_ENABLE		BIT(4)
+#define PORT_TAIL_TAG_ENABLE		BIT(2)
+#define PORT_QUEUE_SPLIT_ENABLE		0x3
+
+#define REG_PORT_CTRL_1			0x0021
+#define PORT_SRP_ENABLE			0x3
+
+#define REG_PORT_STATUS_0		0x0030
+#define PORT_INTF_SPEED_M		0x3
+#define PORT_INTF_SPEED_S		3
+#define PORT_INTF_FULL_DUPLEX		BIT(2)
+
+#define REG_PORT_STATUS_1		0x0034
+
+/* 1 - PHY */
+#define REG_VPHY_SMI_ADDR		0x14
+#define REG_VPHY_SMI_DATA_LO		0x15
+#define REG_VPHY_SMI_DATA_HI		0x16
+
+#define REG_VPHY_SPECIAL_CTRL_STAT	0x1F
+
+#define REG_PORT_T1_PHY_CTRL_BASE	0x0100
+#define REG_PORT_TX_PHY_CTRL_BASE	0x0280
+#define REG_TX_PHY_CTRL_BASE		0x0980
+
+#define REG_PORT_PHY_1000_CTRL		0x0112
+#define PORT_AUTO_NEG_MANUAL		BIT(12)
+#define PORT_AUTO_NEG_M			BIT(11)
+#define PORT_AUTO_NEG_M_PREFERRED	BIT(10)
+#define PORT_AUTO_NEG_1000BT_FD		BIT(9)
+#define PORT_AUTO_NEG_1000BT		BIT(8)
+
+#define REG_PORT_PHY_1000_STATUS	0x0114
+
+#define REG_PORT_PHY_RXER_COUNTER	0x012A
+#define REG_PORT_PHY_INT_ENABLE		0x0136
+#define REG_PORT_PHY_INT_STATUS		0x0137
+
+/* Same as PORT_PHY_LOOPBACK */
+#define PORT_PHY_PCS_LOOPBACK		BIT(0)
+
+#define REG_PORT_PHY_DIGITAL_DEBUG_2	0x013A
+
+#define REG_PORT_PHY_DIGITAL_DEBUG_3	0x013C
+#define PORT_100BT_FIXED_LATENCY	BIT(15)
+
+#define REG_PORT_PHY_PHY_CTRL		0x013E
+#define PORT_INT_PIN_HIGH		BIT(14)
+#define PORT_ENABLE_JABBER		BIT(9)
+#define PORT_STAT_SPEED_1000MBIT	BIT(6)
+#define PORT_STAT_SPEED_100MBIT		BIT(5)
+#define PORT_STAT_SPEED_10MBIT		BIT(4)
+#define PORT_STAT_FULL_DUPLEX		BIT(3)
+
+/* Same as PORT_PHY_STAT_M */
+#define PORT_STAT_M		BIT(2)
+#define PORT_RESET			BIT(1)
+#define PORT_LINK_STATUS_FAIL		BIT(0)
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
+#define REG_PORT_XMII_CTRL_1		0x0301
+#define PORT_MII_NOT_1GBIT		BIT(6)
+#define PORT_MII_SEL_EDGE		BIT(5)
+#define PORT_RGMII_ID_IG_ENABLE		BIT(4)
+#define PORT_RGMII_ID_EG_ENABLE		BIT(3)
+#define PORT_MII_MAC_MODE		BIT(2)
+#define PORT_MII_SEL_M			0x3
+#define PORT_RGMII_SEL			0x0
+#define PORT_RMII_SEL			0x1
+#define PORT_MII_SEL			0x2
+
+#define REG_PORT_XMII_CTRL_2		0x0302
+#define PORT_RGMII_RX_STS_ENABLE	BIT(0)
+
+#define REG_PORT_XMII_CTRL_3		0x0303
+#define PORT_DUPLEX_STATUS_FULL		BIT(3)
+
+#define REG_PORT_XMII_CTRL_4		0x0304
+#define PORT_TX_TUNE_ADJ		0x3F80
+
+#define REG_PORT_XMII_CTRL_5		0x0306
+#define PORT_DLL_RESET			BIT(15)
+#define PORT_RX_TUNE_ADJ		0x3F80
+
+#define PORT_TUNE_ADJ			0x3F80
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
+#define REG_PORT_MAC_CTRL_2		0x0402
+#define PORT_100BT_EEE_DISABLE		BIT(7)
+#define PORT_1000BT_EEE_DISABLE		BIT(6)
+
+#define REG_PORT_MAC_IN_RATE_LIMIT	0x0403
+
+#define REG_PORT_MTU__2			0x0404
+#define PORT_RATE_LIMIT_M		(BIT(7) - 1)
+
+/* 5 - MIB Counters */
+#define REG_PORT_MIB_CTRL_STAT		0x0500
+#define MIB_COUNTER_OVERFLOW		BIT(31)
+#define MIB_COUNTER_VALID		BIT(30)
+#define MIB_COUNTER_READ		BIT(25)
+#define MIB_COUNTER_FLUSH_FREEZE	BIT(24)
+#define MIB_COUNTER_INDEX_M		(BIT(8) - 1)
+#define MIB_COUNTER_INDEX_S		16
+#define MIB_COUNTER_DATA_HI_M		0xF
+
+#define REG_PORT_MIB_DATA		0x0504
+
+/* 8 - Classification and Policing */
+#define REG_PORT_MRI_MIRROR_CTRL	0x0800
+#define PORT_MIRROR_RX			BIT(6)
+#define PORT_MIRROR_TX			BIT(5)
+#define PORT_MIRROR_SNIFFER		BIT(1)
+
+#define REG_PORT_MRI_PRIO_CTRL		0x0801
+#define PORT_HIGHEST_PRIO		BIT(7)
+#define PORT_OR_PRIO			BIT(6)
+#define PORT_MAC_PRIO_ENABLE		BIT(4)
+#define PORT_VLAN_PRIO_ENABLE		BIT(3)
+#define PORT_802_1P_PRIO_ENABLE		BIT(2)
+#define PORT_DIFFSERV_PRIO_ENABLE	BIT(1)
+#define PORT_ACL_PRIO_ENABLE		BIT(0)
+
+#define REG_PORT_MRI_MAC_CTRL		0x0802
+#define PORT_USER_PRIO_CEILING		BIT(7)
+#define PORT_DROP_NON_VLAN		BIT(4)
+#define PORT_DROP_TAG			BIT(3)
+#define PORT_BASED_PRIO_M		KS_PRIO_M
+#define PORT_BASED_PRIO_S		0
+
+#define REG_PORT_MRI_TC_MAP__4		0x0808
+
+/* 9 - Shaping */
+#define REG_PORT_MTI_QUEUE_INDEX__4	0x0900
+
+#define REG_PORT_MTI_QUEUE_CTRL_0__4	0x0904
+#define MTI_PVID_REPLACE		BIT(0)
+
+#define REG_PORT_MTI_QUEUE_CTRL_0	0x0914
+
+/* A - QM */
+#define REG_PORT_QM_CTRL__4		0x0A00
+#define PORT_QM_DROP_PRIO_M		0x3
+
+#define REG_PORT_VLAN_MEMBERSHIP__4	0x0A04
+
+#define REG_PORT_QM_QUEUE_INDEX__4	0x0A08
+#define PORT_QM_QUEUE_INDEX_S		24
+#define PORT_QM_BURST_SIZE_S		16
+#define PORT_QM_MIN_RESV_SPACE_M	(BIT(11) - 1)
+
+#define REG_PORT_QM_WATER_MARK__4	0x0A0C
+#define PORT_QM_HI_WATER_MARK_S		16
+#define PORT_QM_LO_WATER_MARK_S		0
+#define PORT_QM_WATER_MARK_M		(BIT(11) - 1)
+
+#define REG_PORT_QM_TX_CNT_0__4		0x0A10
+#define PORT_QM_TX_CNT_USED_S		0
+#define PORT_QM_TX_CNT_M		(BIT(11) - 1)
+
+#define REG_PORT_QM_TX_CNT_1__4		0x0A14
+#define PORT_QM_TX_CNT_CALCULATED_S	16
+#define PORT_QM_TX_CNT_AVAIL_S		0
+
+/* B - LUE */
+#define REG_PORT_LUE_CTRL		0x0B00
+
+#define PORT_VLAN_LOOKUP_VID_0		BIT(7)
+#define PORT_INGRESS_FILTER		BIT(6)
+#define PORT_DISCARD_NON_VID		BIT(5)
+#define PORT_MAC_BASED_802_1X		BIT(4)
+#define PORT_SRC_ADDR_FILTER		BIT(3)
+
+#define REG_PORT_LUE_MSTP_INDEX		0x0B01
+
+#define REG_PORT_LUE_MSTP_STATE		0x0B04
+
+#define PORT_TX_ENABLE			BIT(2)
+#define PORT_RX_ENABLE			BIT(1)
+#define PORT_LEARN_DISABLE		BIT(0)
+
+#define REG_PORT_LUE_LEARN_CNT__2	0x0B08
+
+#define REG_PORT_LUE_UNK_CTL0		0x0B0E
+#define REG_PORT_LUE_UNK_CTL1		0x0B10
+#define REG_PORT_LUE_UNK_VID_CTRL__2	0x0B12
+
+#define PORT_UNK_UCAST_MCAST_ENABLE	BIT(15)
+#define PORT_UCAST_MCAST_MASK		0xFF
+#define PORT_UNK_VID_ENABLE		BIT(15)
+
+#define PRIO_QUEUES			8
+#define RX_PRIO_QUEUES			8
+#define KS_PRIO_IN_REG			2
+#define TOTAL_PORT_NUM			8
+
+#define LAN937X_COUNTER_NUM		0x20
+#define TOTAL_LAN937X_COUNTER_NUM	(LAN937X_COUNTER_NUM + 2 + 2)
+
+#define SWITCH_COUNTER_NUM		LAN937X_COUNTER_NUM
+
+#define P_BCAST_STORM_CTRL		REG_PORT_MAC_CTRL_0
+#define P_PRIO_CTRL			REG_PORT_MRI_PRIO_CTRL
+#define P_MIRROR_CTRL			REG_PORT_MRI_MIRROR_CTRL
+#define P_STP_CTRL			REG_PORT_LUE_MSTP_STATE
+#define P_PHY_CTRL			REG_PORT_PHY_CTRL
+#define P_NEG_RESTART_CTRL		REG_PORT_PHY_CTRL
+#define P_LINK_STATUS			REG_PORT_PHY_STATUS
+#define P_SPEED_STATUS			REG_PORT_PHY_PHY_CTRL
+#define P_RATE_LIMIT_CTRL		REG_PORT_MAC_IN_RATE_LIMIT
+
+#define S_LINK_AGING_CTRL		REG_SW_LUE_CTRL_1
+#define S_MIRROR_CTRL			REG_SW_MRI_CTRL_0
+#define S_REPLACE_VID_CTRL		REG_SW_MAC_CTRL_2
+#define S_802_1P_PRIO_CTRL		REG_SW_MAC_802_1P_MAP_0
+#define S_TOS_PRIO_CTRL			REG_SW_MAC_TOS_PRIO_0
+#define S_FLUSH_TABLE_CTRL		REG_SW_LUE_CTRL_1
+
+#define REG_SWITCH_RESET		REG_RESET_CTRL
+
+#define SW_FLUSH_DYN_MAC_TABLE		SW_FLUSH_MSTP_TABLE
+
+#define MAX_TIMESTAMP_UNIT		2
+#define MAX_TRIG_UNIT			3
+#define MAX_TIMESTAMP_EVENT_UNIT	8
+#define MAX_GPIO			2
+#define MAX_CLOCK			2
+
+#define PTP_TRIG_UNIT_M			(BIT(MAX_TRIG_UNIT) - 1)
+#define PTP_TS_UNIT_M			(BIT(MAX_TIMESTAMP_UNIT) - 1)
+
+#define TAIL_TAG_PTP			BIT(7)
+#define TAIL_TAG_NEXT_CHIP		BIT(6)
+#define TAIL_TAG_K2L			BIT(5)
+#define TAIL_TAG_PTP_1_STEP		BIT(4)
+#define TAIL_TAG_PTP_P2P		BIT(3)
+#define TAIL_TAG_RX_PORTS_M		0x7
+
+/* 148,800 frames * 67 ms / 100 */
+#define BR_STORM_VALUE			9969
+
+#define SW_CHECK_LENGTH			BIT(3)
+
+#define FR_MIN_SIZE		1522
+#define FR_MAX_SIZE		9000
+
+#define PORT_JUMBO_EN			BIT(0)
+#define PORT_FR_CHK_LENGTH		BIT(2)
+#define PORT_MAX_FR_SIZE		0x404
+
+#define FR_SIZE_CPU_PORT		1540
+
+#define REG_PORT_CTRL_0			0x0020
+#define PORT_FULL_DUPLEX		BIT(6)
+#define PORT_TX_FLOW_CTRL		BIT(5)
+#define PORT_RX_FLOW_CTRL		BIT(3)
+#define PORT_MAC_SPEED_100		BIT(4)
+
+#define PORT_QUEUE_SPLIT_ENABLE		0x3
+
+/* Get fid from vid, fid 0 is not used if vid is greater than 127 */
+#define LAN937X_GET_FID(vid)	(((vid) % ALU_FID_SIZE) + 1)
+
+/* Driver set switch broadcast storm protection at 10% rate */
+#define BR_STORM_PROT_RATE	10
+
+#define MII_BMSR_100BASE_TX_FD		BIT(14)
+
+#define PHY_LINK_UP				1
+#define PHY_LINK_DOWN				0
+
+/* The port number as per the datasheet */
+#define RGMII_2_PORT_NUM		5
+#define RGMII_1_PORT_NUM		6
+#define SGMII_PORT_NUM			4
+#define TXPHY_PORT_NUM			4
+
+#define GET_CHIP_ID_LSB(chip_id)	(((chip_id) >> 8) & 0xff)
+#define LAN937X_RGMII_2_PORT		(RGMII_2_PORT_NUM - 1)
+#define LAN937X_RGMII_1_PORT		(RGMII_1_PORT_NUM - 1)
+#define LAN937X_SGMII_PORT		(SGMII_PORT_NUM - 1)
+#define LAN937X_TXPHY_PORT		(TXPHY_PORT_NUM - 1)
+#define LAN937X_TAG_LEN			2
+
+#define RGMII_1_TX_DELAY_2NS		2
+#define RGMII_2_TX_DELAY_2NS		0
+#define RGMII_1_RX_DELAY_2NS		0x1B
+#define RGMII_2_RX_DELAY_2NS		0x14
+
+#endif
-- 
2.33.0

