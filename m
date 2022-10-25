Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0172060CDFB
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 15:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbiJYNxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 09:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiJYNw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 09:52:59 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCBF112AA8;
        Tue, 25 Oct 2022 06:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1666705977;
  x=1698241977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=51IkYYQzj/DjJ02fpm/wLPje788xVAqGLK/ZhFdLnmE=;
  b=K9brY9stvNRgQGpzu0seiiJedgcNJZzMFYxsS9c79Av/Dhag4D/T3gY7
   oFhW3cr1tm6xJk/dKTfUzJJ9X9f71oXSs877I3iFtVX1BzY0n7b1qMQL+
   ZVXnpbHJIkCl/Ixq3xu/TaHkz1r25n8S33N3t+gsyqlgLAiL8F5m9vPmp
   pEY/Dh/hhF7e8tu5x8Cit9Mtaeawif1oIZfn8kqIypAF/VhONs3alBp8n
   k+mRWqIUX9I8B0o5AxbapN9oNEz92LYwYucuNqd4mwQMHR/Mc0ymzAXip
   Yvas7nAKY6e9Yhum/iAlFxvpRkn06QQiHB2Mxk201XpP3jbTWANJGjZAK
   w==;
From:   Camel Guo <camel.guo@axis.com>
To:     Andrew Lunn <andrew@lunn.ch>, Camel Guo <camel.guo@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Rob Herring <robh@kernel.org>,
        <kernel@axis.com>
Subject: [RFC net-next 2/2] net: dsa: Add driver for Maxlinear GSW1XX switch
Date:   Tue, 25 Oct 2022 15:52:41 +0200
Message-ID: <20221025135243.4038706-3-camel.guo@axis.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221025135243.4038706-1-camel.guo@axis.com>
References: <20221025135243.4038706-1-camel.guo@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,TO_EQ_FM_DIRECT_MX,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add initial framework for Maxlinear's GSW1xx switch and
currently only GSW145 in MDIO managed mode is supported.

Signed-off-by: Camel Guo <camel.guo@axis.com>
---
 MAINTAINERS                   |   3 +
 drivers/net/dsa/Kconfig       |  16 +
 drivers/net/dsa/Makefile      |   2 +
 drivers/net/dsa/gsw1xx.h      |  27 ++
 drivers/net/dsa/gsw1xx_core.c | 823 ++++++++++++++++++++++++++++++++++
 drivers/net/dsa/gsw1xx_mdio.c | 128 ++++++
 6 files changed, 999 insertions(+)
 create mode 100644 drivers/net/dsa/gsw1xx.h
 create mode 100644 drivers/net/dsa/gsw1xx_core.c
 create mode 100644 drivers/net/dsa/gsw1xx_mdio.c

diff --git a/MAINTAINERS b/MAINTAINERS
index df88faabdb53..40371dc9e2dd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12590,6 +12590,9 @@ M:	Camel Guo <camel.guo@axis.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml
+F:	drivers/net/dsa/gsw1xx.h
+F:	drivers/net/dsa/gsw1xx_core.c
+F:	drivers/net/dsa/gsw1xx_mdio.c
 
 MCBA MICROCHIP CAN BUS ANALYZER TOOL DRIVER
 R:	Yasushi SHOJI <yashi@spacecubics.com>
diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 07507b4820d7..af57b92f786a 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -122,4 +122,20 @@ config NET_DSA_VITESSE_VSC73XX_PLATFORM
 	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
 	  and VSC7398 SparX integrated ethernet switches, connected over
 	  a CPU-attached address bus and work in memory-mapped I/O mode.
+
+config NET_DSA_MXL_GSW1XX
+	tristate
+	select REGMAP
+	help
+	  This enables support for the Maxlinear GSW1XX integrated ethernet
+	  switch chips.
+
+config NET_DSA_MXL_GSW1XX_MDIO
+	tristate "MaxLinear GSW1XX ethernet switch in MDIO managed mode"
+	select NET_DSA_MXL_GSW1XX
+	select FIXED_PHY
+	help
+	  This enables access functions if the MaxLinear GSW1XX is configured
+	  for MDIO managed mode.
+
 endmenu
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 16eb879e0cb4..022fc661107b 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -15,6 +15,8 @@ obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) += vitesse-vsc73xx-core.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM) += vitesse-vsc73xx-platform.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_SPI) += vitesse-vsc73xx-spi.o
+obj-$(CONFIG_NET_DSA_MXL_GSW1XX) += gsw1xx_core.o
+obj-$(CONFIG_NET_DSA_MXL_GSW1XX_MDIO) += gsw1xx_mdio.o
 obj-y				+= b53/
 obj-y				+= hirschmann/
 obj-y				+= microchip/
diff --git a/drivers/net/dsa/gsw1xx.h b/drivers/net/dsa/gsw1xx.h
new file mode 100644
index 000000000000..08b2975e1267
--- /dev/null
+++ b/drivers/net/dsa/gsw1xx.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef GSW1XX_H
+#define GSW1XX_H
+
+#include <linux/regmap.h>
+#include <linux/device.h>
+#include <net/dsa.h>
+
+struct gsw1xx_hw_info {
+	int max_ports;
+	int cpu_port;
+};
+
+struct gsw1xx_priv {
+	struct device *dev;
+	struct regmap *regmap;
+	struct dsa_switch *ds;
+	const struct gsw1xx_hw_info *hw_info;
+};
+
+extern const struct regmap_access_table gsw1xx_register_set;
+
+int gsw1xx_probe(struct gsw1xx_priv *priv, struct device *dev);
+void gsw1xx_remove(struct gsw1xx_priv *priv);
+void gsw1xx_shutdown(struct gsw1xx_priv *priv);
+
+#endif /* GSW1XX_H */
diff --git a/drivers/net/dsa/gsw1xx_core.c b/drivers/net/dsa/gsw1xx_core.c
new file mode 100644
index 000000000000..1b3cbee4addc
--- /dev/null
+++ b/drivers/net/dsa/gsw1xx_core.c
@@ -0,0 +1,823 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/delay.h>
+#include <linux/etherdevice.h>
+#include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
+#include <linux/module.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
+#include <linux/of_platform.h>
+#include <linux/phy.h>
+#include <linux/phylink.h>
+#include <linux/regmap.h>
+#include <net/dsa.h>
+
+#include "gsw1xx.h"
+
+/* GSW1XX MDIO Registers */
+#define GSW1XX_MDIO_BASE_ADDR		0xF400
+#define GSW1XX_MDIO_REG_LEN		0x0422
+#define GSW1XX_MDIO_GLOB		0x00
+#define  GSW1XX_MDIO_GLOB_ENABLE	BIT(15)
+#define GSW1XX_MDIO_CTRL		0x08
+#define  GSW1XX_MDIO_CTRL_BUSY		BIT(12)
+#define  GSW1XX_MDIO_CTRL_RD		BIT(11)
+#define  GSW1XX_MDIO_CTRL_WR		BIT(10)
+#define  GSW1XX_MDIO_CTRL_PHYAD_MASK	0x1F
+#define  GSW1XX_MDIO_CTRL_PHYAD_SHIFT	5
+#define  GSW1XX_MDIO_CTRL_REGAD_MASK	0x1F
+#define GSW1XX_MDIO_READ		0x09
+#define GSW1XX_MDIO_WRITE		0x0A
+#define GSW1XX_MDIO_MDC_CFG0		0x0B
+#define GSW1XX_MDIO_PHYp(p)		(0x15 - (p))
+#define  GSW1XX_MDIO_PHY_LINK_MASK	0x6000
+#define  GSW1XX_MDIO_PHY_LINK_AUTO	0x0000
+#define  GSW1XX_MDIO_PHY_LINK_DOWN	0x4000
+#define  GSW1XX_MDIO_PHY_LINK_UP	0x2000
+#define  GSW1XX_MDIO_PHY_SPEED_MASK	0x1800
+#define  GSW1XX_MDIO_PHY_SPEED_AUTO	0x1800
+#define  GSW1XX_MDIO_PHY_SPEED_M10	0x0000
+#define  GSW1XX_MDIO_PHY_SPEED_M100	0x0800
+#define  GSW1XX_MDIO_PHY_SPEED_G1	0x1000
+#define  GSW1XX_MDIO_PHY_FDUP_MASK	0x0600
+#define  GSW1XX_MDIO_PHY_FDUP_AUTO	0x0000
+#define  GSW1XX_MDIO_PHY_FDUP_EN	0x0200
+#define  GSW1XX_MDIO_PHY_FDUP_DIS	0x0600
+#define  GSW1XX_MDIO_PHY_FCONTX_MASK	0x0180
+#define  GSW1XX_MDIO_PHY_FCONTX_AUTO	0x0000
+#define  GSW1XX_MDIO_PHY_FCONTX_EN	0x0100
+#define  GSW1XX_MDIO_PHY_FCONTX_DIS	0x0180
+#define  GSW1XX_MDIO_PHY_FCONRX_MASK	0x0060
+#define  GSW1XX_MDIO_PHY_FCONRX_AUTO	0x0000
+#define  GSW1XX_MDIO_PHY_FCONRX_EN	0x0020
+#define  GSW1XX_MDIO_PHY_FCONRX_DIS	0x0060
+#define  GSW1XX_MDIO_PHY_ADDR_MASK	0x001F
+#define  GSW1XX_MDIO_PHY_MASK		(GSW1XX_MDIO_PHY_ADDR_MASK | \
+					 GSW1XX_MDIO_PHY_FCONRX_MASK | \
+					 GSW1XX_MDIO_PHY_FCONTX_MASK | \
+					 GSW1XX_MDIO_PHY_LINK_MASK | \
+					 GSW1XX_MDIO_PHY_SPEED_MASK | \
+					 GSW1XX_MDIO_PHY_FDUP_MASK)
+
+/* GSW1XX_IP Core Registers */
+#define GSW1XX_IP_BASE_ADDR		0xE000
+#define GSW1XX_IP_REG_LEN		0x0D46
+#define GSW1XX_IP_SWRES			0x000
+#define  GSW1XX_IP_SWRES_R1		BIT(1)	/* Software reset */
+#define  GSW1XX_IP_SWRES_R0		BIT(0)	/* Hardware reset */
+#define GSW1XX_IP_VERSION		0x013
+#define  GSW1XX_IP_VERSION_REV_SHIFT	0
+#define  GSW1XX_IP_VERSION_REV_MASK	GENMASK(7, 0)
+#define  GSW1XX_IP_VERSION_MOD_SHIFT	8
+#define  GSW1XX_IP_VERSION_MOD_MASK	GENMASK(15, 8)
+#define   GSW1XX_IP_VERSION_2_3		0x023
+
+#define GSW1XX_IP_BM_RAM_VAL(x)		(0x043 - (x))
+#define GSW1XX_IP_BM_RAM_ADDR		0x044
+#define GSW1XX_IP_BM_RAM_CTRL		0x045
+#define  GSW1XX_IP_BM_RAM_CTRL_BAS		BIT(15)
+#define  GSW1XX_IP_BM_RAM_CTRL_OPMOD		BIT(5)
+#define  GSW1XX_IP_BM_RAM_CTRL_ADDR_MASK	GENMASK(4, 0)
+#define GSW1XX_IP_BM_QUEUE_GCTRL		0x04A
+#define  GSW1XX_IP_BM_QUEUE_GCTRL_GL_MOD	BIT(10)
+/* buffer management Port Configuration Register */
+#define GSW1XX_IP_BM_PCFGp(p)		(0x080 + ((p) * 2))
+#define  GSW1XX_IP_BM_PCFG_CNTEN	BIT(0)	/* RMON Counter Enable */
+/* PCE */
+#define GSW1XX_IP_PCE_PMAP2		0x454	/* Default Multicast port map */
+#define GSW1XX_IP_PCE_PMAP3		0x455	/* Default Unknown Unicast port map */
+#define GSW1XX_IP_PCE_GCTRL_0		0x456
+#define  GSW1XX_IP_PCE_GCTRL_0_MTFL	BIT(0)  /* MAC Table Flushing */
+#define  GSW1XX_IP_PCE_GCTRL_0_MC_VALID	BIT(3)
+#define GSW1XX_IP_PCE_PCTRL_0p(p)	(0x480 + ((p) * 0xA))
+#define  GSW1XX_IP_PCE_PCTRL_0_PSTATE_LISTEN		0x0
+#define  GSW1XX_IP_PCE_PCTRL_0_PSTATE_RX		0x1
+#define  GSW1XX_IP_PCE_PCTRL_0_PSTATE_TX		0x2
+#define  GSW1XX_IP_PCE_PCTRL_0_PSTATE_LEARNING		0x3
+#define  GSW1XX_IP_PCE_PCTRL_0_PSTATE_FORWARDING	0x7
+#define  GSW1XX_IP_PCE_PCTRL_0_PSTATE_MASK		GENMASK(2, 0)
+
+#define GSW1XX_IP_MAC_FLEN			0x8C5
+#define GSW1XX_IP_MAC_CTRL_0p(p)		(0x903 + ((p) * 0xC))
+#define  GSW1XX_IP_MAC_CTRL_0_PADEN		BIT(8)
+#define  GSW1XX_IP_MAC_CTRL_0_FCS_EN		BIT(7)
+#define  GSW1XX_IP_MAC_CTRL_0_FCON_MASK		0x0070
+#define  GSW1XX_IP_MAC_CTRL_0_FCON_AUTO		0x0000
+#define  GSW1XX_IP_MAC_CTRL_0_FCON_RX		0x0010
+#define  GSW1XX_IP_MAC_CTRL_0_FCON_TX		0x0020
+#define  GSW1XX_IP_MAC_CTRL_0_FCON_RXTX		0x0030
+#define  GSW1XX_IP_MAC_CTRL_0_FCON_NONE		0x0040
+#define  GSW1XX_IP_MAC_CTRL_0_FDUP_MASK		0x000C
+#define  GSW1XX_IP_MAC_CTRL_0_FDUP_AUTO		0x0000
+#define  GSW1XX_IP_MAC_CTRL_0_FDUP_EN		0x0004
+#define  GSW1XX_IP_MAC_CTRL_0_FDUP_DIS		0x000C
+#define  GSW1XX_IP_MAC_CTRL_0_GMII_MASK		0x0003
+#define  GSW1XX_IP_MAC_CTRL_0_GMII_AUTO		0x0000
+#define  GSW1XX_IP_MAC_CTRL_0_GMII_MII		0x0001
+#define  GSW1XX_IP_MAC_CTRL_0_GMII_RGMII	0x0002
+#define GSW1XX_IP_MAC_CTRL_2p(p)		(0x905 + ((p) * 0xC))
+#define GSW1XX_IP_MAC_CTRL_2_MLEN		BIT(3) /* Maximum Untagged Frame Lnegth */
+#define GSW1XX_IP_MAC_CTRL_4p(p)		(0x907 + ((p) * 0xC))
+#define  GSW1XX_IP_MAC_CTRL_4_LPIEN		BIT(7)
+
+/* Ethernet Switch Fetch DMA Port Control Register */
+#define GSW1XX_IP_FDMA_PCTRLp(p)		(0xA80 + ((p) * 0x6))
+#define  GSW1XX_IP_FDMA_PCTRL_EN		BIT(0)	/* FDMA Port Enable */
+
+/* Ethernet Switch Store DMA Port Control Register */
+#define GSW1XX_IP_SDMA_PCTRLp(p)		(0xBC0 + ((p) * 0x6))
+#define  GSW1XX_IP_SDMA_PCTRL_EN		BIT(0)	/* SDMA Port Enable */
+#define  GSW1XX_IP_SDMA_PCTRL_FCEN		BIT(1)	/* Flow Control Enable */
+#define  GSW1XX_IP_SDMA_PCTRL_PAUFWD		BIT(3)	/* Pause Frame Forwarding */
+
+struct gsw1xx_rmon_cnt_desc {
+	unsigned int size;
+	unsigned int offset;
+	const char *name;
+};
+
+#define MIB_DESC(_size, _offset, _name)                                        \
+	{                                                                      \
+		.size = _size, .offset = _offset, .name = _name                \
+	}
+
+static const struct gsw1xx_rmon_cnt_desc gsw1xx_rmon_cnt[] = {
+	/** Receive Packet Count (only packets that are accepted and not discarded). */
+	MIB_DESC(1, 0x1F, "RxGoodPkts"),
+	MIB_DESC(1, 0x23, "RxUnicastPkts"),
+	MIB_DESC(1, 0x22, "RxMulticastPkts"),
+	MIB_DESC(1, 0x21, "RxFCSErrorPkts"),
+	MIB_DESC(1, 0x1D, "RxUnderSizeGoodPkts"),
+	MIB_DESC(1, 0x1E, "RxUnderSizeErrorPkts"),
+	MIB_DESC(1, 0x1B, "RxOversizeGoodPkts"),
+	MIB_DESC(1, 0x1C, "RxOversizeErrorPkts"),
+	MIB_DESC(1, 0x20, "RxGoodPausePkts"),
+	MIB_DESC(1, 0x1A, "RxAlignErrorPkts"),
+	MIB_DESC(1, 0x12, "Rx64BytePkts"),
+	MIB_DESC(1, 0x13, "Rx127BytePkts"),
+	MIB_DESC(1, 0x14, "Rx255BytePkts"),
+	MIB_DESC(1, 0x15, "Rx511BytePkts"),
+	MIB_DESC(1, 0x16, "Rx1023BytePkts"),
+	/** Receive Size 1024-1522 (or more, if configured) Packet Count. */
+	MIB_DESC(1, 0x17, "RxMaxBytePkts"),
+	MIB_DESC(1, 0x18, "RxDroppedPkts"),
+	MIB_DESC(1, 0x19, "RxFilteredPkts"),
+	MIB_DESC(2, 0x24, "RxGoodBytes"),
+	MIB_DESC(2, 0x26, "RxBadBytes"),
+	MIB_DESC(1, 0x11, "TxAcmDroppedPkts"),
+	MIB_DESC(1, 0x0C, "TxGoodPkts"),
+	MIB_DESC(1, 0x06, "TxUnicastPkts"),
+	MIB_DESC(1, 0x07, "TxMulticastPkts"),
+	MIB_DESC(1, 0x00, "Tx64BytePkts"),
+	MIB_DESC(1, 0x01, "Tx127BytePkts"),
+	MIB_DESC(1, 0x02, "Tx255BytePkts"),
+	MIB_DESC(1, 0x03, "Tx511BytePkts"),
+	MIB_DESC(1, 0x04, "Tx1023BytePkts"),
+	/** Transmit Size 1024-1522 (or more, if configured) Packet Count. */
+	MIB_DESC(1, 0x05, "TxMaxBytePkts"),
+	MIB_DESC(1, 0x08, "TxSingleCollCount"),
+	MIB_DESC(1, 0x09, "TxMultCollCount"),
+	MIB_DESC(1, 0x0A, "TxLateCollCount"),
+	MIB_DESC(1, 0x0B, "TxExcessCollCount"),
+	MIB_DESC(1, 0x0D, "TxPauseCount"),
+	MIB_DESC(1, 0x10, "TxDroppedPkts"),
+	MIB_DESC(2, 0x0E, "TxGoodBytes"),
+};
+
+static u32 gsw1xx_switch_r(struct gsw1xx_priv *priv, u32 offset)
+{
+	int ret = 0;
+	u32 val = 0;
+
+	ret = regmap_read(priv->regmap, GSW1XX_IP_BASE_ADDR + offset, &val);
+
+	return ret < 0 ? (u32)ret : val;
+}
+
+static void gsw1xx_switch_w(struct gsw1xx_priv *priv, u32 val, u32 offset)
+{
+	regmap_write(priv->regmap, GSW1XX_IP_BASE_ADDR + offset, val);
+}
+
+static u32 gsw1xx_mdio_r(struct gsw1xx_priv *priv, u32 offset)
+{
+	int ret = 0;
+	u32 val = 0;
+
+	ret = regmap_read(priv->regmap, GSW1XX_MDIO_BASE_ADDR + offset, &val);
+
+	return ret < 0 ? (u32)ret : val;
+}
+
+static void gsw1xx_mdio_w(struct gsw1xx_priv *priv, u32 val, u32 offset)
+{
+	regmap_write(priv->regmap, GSW1XX_MDIO_BASE_ADDR + offset, val);
+}
+
+static void gsw1xx_mdio_mask(struct gsw1xx_priv *priv, u32 clear, u32 set,
+			     u32 offset)
+{
+	u32 val = gsw1xx_mdio_r(priv, offset);
+
+	val &= ~(clear);
+	val |= set;
+	gsw1xx_mdio_w(priv, val, offset);
+}
+
+static void gsw1xx_switch_mask(struct gsw1xx_priv *priv, u32 clear, u32 set,
+			       u32 offset)
+{
+	u32 val = gsw1xx_switch_r(priv, offset);
+
+	val &= ~(clear);
+	val |= set;
+	gsw1xx_switch_w(priv, val, offset);
+}
+
+static u32 gsw1xx_switch_r_timeout(struct gsw1xx_priv *priv, u32 offset,
+				   u32 cleared)
+{
+	u32 val;
+
+	return read_poll_timeout(gsw1xx_switch_r, val, (val & cleared) == 0, 20,
+				 50000, true, priv, offset);
+}
+
+static int gsw1xx_mdio_poll(struct gsw1xx_priv *priv)
+{
+	int cnt = 100;
+
+	while (likely(cnt--)) {
+		u32 ctrl = gsw1xx_mdio_r(priv, GSW1XX_MDIO_CTRL);
+
+		if ((ctrl & GSW1XX_MDIO_CTRL_BUSY) == 0)
+			return 0;
+		usleep_range(20, 40);
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int gsw1xx_mdio_wr(struct mii_bus *bus, int addr, int reg, u16 val)
+{
+	struct gsw1xx_priv *priv = bus->priv;
+	int err;
+
+	err = gsw1xx_mdio_poll(priv);
+	if (err) {
+		dev_err(&bus->dev, "timeout while waiting for MDIO bus\n");
+		return err;
+	}
+
+	gsw1xx_mdio_w(priv, val, GSW1XX_MDIO_WRITE);
+	gsw1xx_mdio_w(priv,
+		      GSW1XX_MDIO_CTRL_WR |
+			      ((addr & GSW1XX_MDIO_CTRL_PHYAD_MASK)
+			       << GSW1XX_MDIO_CTRL_PHYAD_SHIFT) |
+			      (reg & GSW1XX_MDIO_CTRL_REGAD_MASK),
+		      GSW1XX_MDIO_CTRL);
+
+	return 0;
+}
+
+static int gsw1xx_mdio_rd(struct mii_bus *bus, int addr, int reg)
+{
+	struct gsw1xx_priv *priv = bus->priv;
+	int err;
+
+	err = gsw1xx_mdio_poll(priv);
+	if (err) {
+		dev_err(&bus->dev, "timeout while waiting for MDIO bus\n");
+		return err;
+	}
+
+	gsw1xx_mdio_w(priv,
+		      GSW1XX_MDIO_CTRL_RD |
+			      ((addr & GSW1XX_MDIO_CTRL_PHYAD_MASK)
+			       << GSW1XX_MDIO_CTRL_PHYAD_SHIFT) |
+			      (reg & GSW1XX_MDIO_CTRL_REGAD_MASK),
+		      GSW1XX_MDIO_CTRL);
+
+	err = gsw1xx_mdio_poll(priv);
+	if (err) {
+		dev_err(&bus->dev, "timeout while waiting for MDIO bus\n");
+		return err;
+	}
+
+	return gsw1xx_mdio_r(priv, GSW1XX_MDIO_READ);
+}
+
+static int gsw1xx_mdio(struct gsw1xx_priv *priv, struct device_node *mdio_np)
+{
+	struct dsa_switch *ds = priv->ds;
+	int err;
+
+	ds->slave_mii_bus = mdiobus_alloc();
+	if (!ds->slave_mii_bus)
+		return -ENOMEM;
+
+	ds->slave_mii_bus->priv = priv;
+	ds->slave_mii_bus->read = gsw1xx_mdio_rd;
+	ds->slave_mii_bus->write = gsw1xx_mdio_wr;
+	ds->slave_mii_bus->name = "mxl,gsw1xx-mdio";
+	snprintf(ds->slave_mii_bus->id, MII_BUS_ID_SIZE, "%s-mii",
+		 dev_name(priv->dev));
+	ds->slave_mii_bus->parent = priv->dev;
+	ds->slave_mii_bus->phy_mask = ~ds->phys_mii_mask;
+
+	err = of_mdiobus_register(ds->slave_mii_bus, mdio_np);
+	if (err)
+		mdiobus_free(ds->slave_mii_bus);
+
+	return err;
+}
+
+static int gsw1xx_port_enable(struct dsa_switch *ds, int port,
+			      struct phy_device *phydev)
+{
+	struct gsw1xx_priv *priv = ds->priv;
+
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
+	/* RMON Counter Enable for port */
+	gsw1xx_switch_w(priv, GSW1XX_IP_BM_PCFG_CNTEN,
+			GSW1XX_IP_BM_PCFGp(port));
+
+	/* enable port fetch/store dma */
+	gsw1xx_switch_mask(priv, 0, GSW1XX_IP_FDMA_PCTRL_EN,
+			   GSW1XX_IP_FDMA_PCTRLp(port));
+	gsw1xx_switch_mask(priv, 0, GSW1XX_IP_SDMA_PCTRL_EN,
+			   GSW1XX_IP_SDMA_PCTRLp(port));
+
+	if (!dsa_is_cpu_port(ds, port)) {
+		u32 mdio_phy = 0;
+
+		if (phydev)
+			mdio_phy =
+				phydev->mdio.addr & GSW1XX_MDIO_PHY_ADDR_MASK;
+
+		gsw1xx_mdio_mask(priv, GSW1XX_MDIO_PHY_ADDR_MASK, mdio_phy,
+				 GSW1XX_MDIO_PHYp(port));
+	}
+
+	return 0;
+}
+
+static void gsw1xx_port_disable(struct dsa_switch *ds, int port)
+{
+	struct gsw1xx_priv *priv = ds->priv;
+
+	if (!dsa_is_user_port(ds, port))
+		return;
+
+	gsw1xx_switch_mask(priv, GSW1XX_IP_FDMA_PCTRL_EN, 0,
+			   GSW1XX_IP_FDMA_PCTRLp(port));
+	gsw1xx_switch_mask(priv, GSW1XX_IP_SDMA_PCTRL_EN, 0,
+			   GSW1XX_IP_SDMA_PCTRLp(port));
+}
+
+static int gsw1xx_setup(struct dsa_switch *ds)
+{
+	struct gsw1xx_priv *priv = ds->priv;
+	unsigned int cpu_port = priv->hw_info->cpu_port;
+	int i;
+	int err;
+
+	gsw1xx_switch_w(priv, GSW1XX_IP_SWRES_R0, GSW1XX_IP_SWRES);
+	usleep_range(5000, 10000);
+	gsw1xx_switch_w(priv, 0, GSW1XX_IP_SWRES);
+
+	/* disable port fetch/store dma on all ports */
+	for (i = 0; i < priv->hw_info->max_ports; i++)
+		gsw1xx_port_disable(ds, i);
+
+	/* enable Switch */
+	gsw1xx_mdio_mask(priv, 0, GSW1XX_MDIO_GLOB_ENABLE, GSW1XX_MDIO_GLOB);
+
+	gsw1xx_switch_w(priv, 0x7F, GSW1XX_IP_PCE_PMAP2);
+	gsw1xx_switch_w(priv, 0x7F, GSW1XX_IP_PCE_PMAP3);
+
+	/* Deactivate MDIO PHY auto polling since it affects mmd read/write.
+	 */
+	gsw1xx_mdio_w(priv, 0x0, GSW1XX_MDIO_MDC_CFG0);
+
+	gsw1xx_switch_mask(priv, 1, GSW1XX_IP_MAC_CTRL_2_MLEN,
+			   GSW1XX_IP_MAC_CTRL_2p(cpu_port));
+	gsw1xx_switch_mask(priv, 0, GSW1XX_IP_BM_QUEUE_GCTRL_GL_MOD,
+			   GSW1XX_IP_BM_QUEUE_GCTRL);
+
+	/* Flush MAC Table */
+	gsw1xx_switch_mask(priv, 0, GSW1XX_IP_PCE_GCTRL_0_MTFL,
+			   GSW1XX_IP_PCE_GCTRL_0);
+	err = gsw1xx_switch_r_timeout(priv, GSW1XX_IP_PCE_GCTRL_0,
+				      GSW1XX_IP_PCE_GCTRL_0_MTFL);
+	if (err) {
+		dev_err(priv->dev, "MAC flushing didn't finish\n");
+		return err;
+	}
+
+	gsw1xx_port_enable(ds, cpu_port, NULL);
+
+	return 0;
+}
+
+static enum dsa_tag_protocol gsw1xx_get_tag_protocol(struct dsa_switch *ds,
+						     int port,
+						     enum dsa_tag_protocol mp)
+{
+	return DSA_TAG_PROTO_NONE;
+}
+
+static void gsw1xx_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
+{
+	struct gsw1xx_priv *priv = ds->priv;
+	u32 stp_state;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		gsw1xx_switch_mask(priv, GSW1XX_IP_SDMA_PCTRL_EN, 0,
+				   GSW1XX_IP_SDMA_PCTRLp(port));
+		return;
+	case BR_STATE_BLOCKING:
+	case BR_STATE_LISTENING:
+		stp_state = GSW1XX_IP_PCE_PCTRL_0_PSTATE_LISTEN;
+		break;
+	case BR_STATE_LEARNING:
+		stp_state = GSW1XX_IP_PCE_PCTRL_0_PSTATE_LEARNING;
+		break;
+	case BR_STATE_FORWARDING:
+		stp_state = GSW1XX_IP_PCE_PCTRL_0_PSTATE_FORWARDING;
+		break;
+	default:
+		dev_err(priv->dev, "invalid STP state: %d\n", state);
+		return;
+	}
+
+	gsw1xx_switch_mask(priv, 0, GSW1XX_IP_SDMA_PCTRL_EN,
+			   GSW1XX_IP_SDMA_PCTRLp(port));
+	gsw1xx_switch_mask(priv, GSW1XX_IP_PCE_PCTRL_0_PSTATE_MASK, stp_state,
+			   GSW1XX_IP_PCE_PCTRL_0p(port));
+}
+
+static void gsw1xx_port_set_link(struct gsw1xx_priv *priv, int port, bool link)
+{
+	u32 mdio_phy;
+
+	if (link)
+		mdio_phy = GSW1XX_MDIO_PHY_LINK_UP;
+	else
+		mdio_phy = GSW1XX_MDIO_PHY_LINK_DOWN;
+
+	gsw1xx_mdio_mask(priv, GSW1XX_MDIO_PHY_LINK_MASK, mdio_phy,
+			 GSW1XX_MDIO_PHYp(port));
+}
+
+static void gsw1xx_port_set_speed(struct gsw1xx_priv *priv, int port, int speed,
+				  phy_interface_t interface)
+{
+	u32 mdio_phy = 0, mac_ctrl_0 = 0;
+
+	switch (speed) {
+	case SPEED_10:
+		mdio_phy = GSW1XX_MDIO_PHY_SPEED_M10;
+		mac_ctrl_0 = GSW1XX_IP_MAC_CTRL_0_GMII_MII;
+		break;
+
+	case SPEED_100:
+		mdio_phy = GSW1XX_MDIO_PHY_SPEED_M100;
+		mac_ctrl_0 = GSW1XX_IP_MAC_CTRL_0_GMII_MII;
+		break;
+
+	case SPEED_1000:
+		mdio_phy = GSW1XX_MDIO_PHY_SPEED_G1;
+		mac_ctrl_0 = GSW1XX_IP_MAC_CTRL_0_GMII_RGMII;
+		break;
+	}
+
+	gsw1xx_mdio_mask(priv, GSW1XX_MDIO_PHY_SPEED_MASK, mdio_phy,
+			 GSW1XX_MDIO_PHYp(port));
+	gsw1xx_switch_mask(priv, GSW1XX_IP_MAC_CTRL_0_GMII_MASK, mac_ctrl_0,
+			   GSW1XX_IP_MAC_CTRL_0p(port));
+}
+
+static void gsw1xx_port_set_duplex(struct gsw1xx_priv *priv, int port,
+				   int duplex)
+{
+	u32 mac_ctrl_0, mdio_phy;
+
+	if (duplex == DUPLEX_FULL) {
+		mac_ctrl_0 = GSW1XX_IP_MAC_CTRL_0_FDUP_EN;
+		mdio_phy = GSW1XX_MDIO_PHY_FDUP_EN;
+	} else {
+		mac_ctrl_0 = GSW1XX_IP_MAC_CTRL_0_FDUP_DIS;
+		mdio_phy = GSW1XX_MDIO_PHY_FDUP_DIS;
+	}
+
+	gsw1xx_switch_mask(priv, GSW1XX_IP_MAC_CTRL_0_FDUP_MASK, mac_ctrl_0,
+			   GSW1XX_IP_MAC_CTRL_0p(port));
+	gsw1xx_mdio_mask(priv, GSW1XX_MDIO_PHY_FDUP_MASK, mdio_phy,
+			 GSW1XX_MDIO_PHYp(port));
+}
+
+static void gsw1xx_port_set_pause(struct gsw1xx_priv *priv, int port,
+				  bool tx_pause, bool rx_pause)
+{
+	u32 mac_ctrl_0, mdio_phy;
+
+	if (tx_pause && rx_pause) {
+		mac_ctrl_0 = GSW1XX_IP_MAC_CTRL_0_FCON_RXTX;
+		mdio_phy =
+			GSW1XX_MDIO_PHY_FCONTX_EN | GSW1XX_MDIO_PHY_FCONRX_EN;
+	} else if (tx_pause) {
+		mac_ctrl_0 = GSW1XX_IP_MAC_CTRL_0_FCON_TX;
+		mdio_phy =
+			GSW1XX_MDIO_PHY_FCONTX_EN | GSW1XX_MDIO_PHY_FCONRX_DIS;
+	} else if (rx_pause) {
+		mac_ctrl_0 = GSW1XX_IP_MAC_CTRL_0_FCON_RX;
+		mdio_phy =
+			GSW1XX_MDIO_PHY_FCONTX_DIS | GSW1XX_MDIO_PHY_FCONRX_EN;
+	} else {
+		mac_ctrl_0 = GSW1XX_IP_MAC_CTRL_0_FCON_NONE;
+		mdio_phy =
+			GSW1XX_MDIO_PHY_FCONTX_DIS | GSW1XX_MDIO_PHY_FCONRX_DIS;
+	}
+
+	gsw1xx_switch_mask(priv, GSW1XX_IP_MAC_CTRL_0_FCON_MASK, mac_ctrl_0,
+			   GSW1XX_IP_MAC_CTRL_0p(port));
+	gsw1xx_mdio_mask(priv,
+			 GSW1XX_MDIO_PHY_FCONTX_MASK | GSW1XX_MDIO_PHY_FCONRX_MASK,
+			 mdio_phy, GSW1XX_MDIO_PHYp(port));
+}
+
+static void gsw1xx_phylink_mac_link_down(struct dsa_switch *ds, int port,
+					 unsigned int mode,
+					 phy_interface_t interface)
+{
+	struct gsw1xx_priv *priv = ds->priv;
+
+	if (!dsa_is_cpu_port(ds, port))
+		gsw1xx_port_set_link(priv, port, false);
+}
+
+static void gsw1xx_phylink_mac_link_up(struct dsa_switch *ds, int port,
+				       unsigned int mode,
+				       phy_interface_t interface,
+				       struct phy_device *phydev, int speed,
+				       int duplex, bool tx_pause, bool rx_pause)
+{
+	struct gsw1xx_priv *priv = ds->priv;
+
+	if (!dsa_is_cpu_port(ds, port)) {
+		gsw1xx_port_set_link(priv, port, true);
+		gsw1xx_port_set_speed(priv, port, speed, interface);
+		gsw1xx_port_set_duplex(priv, port, duplex);
+		gsw1xx_port_set_pause(priv, port, tx_pause, rx_pause);
+	}
+}
+
+static void gsw1xx_get_strings(struct dsa_switch *ds, int port, u32 stringset,
+			       uint8_t *data)
+{
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(gsw1xx_rmon_cnt); i++)
+		strncpy(data + i * ETH_GSTRING_LEN, gsw1xx_rmon_cnt[i].name,
+			ETH_GSTRING_LEN);
+}
+
+static u32 gsw1xx_bcm_ram_entry_read(struct gsw1xx_priv *priv, u32 port,
+				     u32 index)
+{
+	u32 result;
+	int err;
+
+	gsw1xx_switch_w(priv, index, GSW1XX_IP_BM_RAM_ADDR);
+	gsw1xx_switch_mask(priv,
+			   GSW1XX_IP_BM_RAM_CTRL_ADDR_MASK | GSW1XX_IP_BM_RAM_CTRL_OPMOD,
+			   port | GSW1XX_IP_BM_RAM_CTRL_BAS,
+			   GSW1XX_IP_BM_RAM_CTRL);
+
+	err = gsw1xx_switch_r_timeout(priv, GSW1XX_IP_BM_RAM_CTRL,
+				      GSW1XX_IP_BM_RAM_CTRL_BAS);
+	if (err) {
+		dev_err(priv->dev,
+			"timeout while reading entry: %u from RMON table for port: %u",
+			index, port);
+		return 0;
+	}
+
+	result = gsw1xx_switch_r(priv, GSW1XX_IP_BM_RAM_VAL(0));
+	result |= gsw1xx_switch_r(priv, GSW1XX_IP_BM_RAM_VAL(1)) << 16;
+
+	return result;
+}
+
+static void gsw1xx_get_ethtool_stats(struct dsa_switch *ds, int port,
+				     uint64_t *data)
+{
+	struct gsw1xx_priv *priv = ds->priv;
+	const struct gsw1xx_rmon_cnt_desc *rmon_cnt;
+	int i;
+	u64 high;
+
+	for (i = 0; i < ARRAY_SIZE(gsw1xx_rmon_cnt); i++) {
+		rmon_cnt = &gsw1xx_rmon_cnt[i];
+
+		data[i] =
+			gsw1xx_bcm_ram_entry_read(priv, port, rmon_cnt->offset);
+		if (rmon_cnt->size == 2) {
+			high = gsw1xx_bcm_ram_entry_read(priv, port,
+							 rmon_cnt->offset + 1);
+			data[i] |= high << 32;
+		}
+	}
+}
+
+static int gsw1xx_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	if (sset != ETH_SS_STATS)
+		return 0;
+
+	return ARRAY_SIZE(gsw1xx_rmon_cnt);
+}
+
+static int gsw1xx_get_mac_eee(struct dsa_switch *ds, int port,
+			      struct ethtool_eee *e)
+{
+	struct gsw1xx_priv *priv = (struct gsw1xx_priv *)ds->priv;
+	u32 val = 0;
+
+	val = gsw1xx_switch_r(priv, GSW1XX_IP_MAC_CTRL_4p(port));
+	e->tx_lpi_enabled = !!(val & GSW1XX_IP_MAC_CTRL_4_LPIEN);
+
+	e->tx_lpi_timer = 20;
+
+	return 0;
+}
+
+static int gsw1xx_set_mac_eee(struct dsa_switch *ds, int port,
+			      struct ethtool_eee *e)
+{
+	struct gsw1xx_priv *priv = (struct gsw1xx_priv *)ds->priv;
+
+	if (e->tx_lpi_enabled) {
+		gsw1xx_switch_mask(priv, 0, GSW1XX_IP_MAC_CTRL_4_LPIEN,
+				   GSW1XX_IP_MAC_CTRL_4p(port));
+	} else {
+		gsw1xx_switch_mask(priv, GSW1XX_IP_MAC_CTRL_4_LPIEN, 0,
+				   GSW1XX_IP_MAC_CTRL_4p(port));
+	}
+
+	return 0;
+}
+
+static const struct dsa_switch_ops gsw1xx_switch_ops = {
+	.get_tag_protocol	= gsw1xx_get_tag_protocol,
+	.setup			= gsw1xx_setup,
+	.set_mac_eee		= gsw1xx_set_mac_eee,
+	.get_mac_eee		= gsw1xx_get_mac_eee,
+	.port_enable		= gsw1xx_port_enable,
+	.port_disable		= gsw1xx_port_disable,
+	.port_stp_state_set	= gsw1xx_port_stp_state_set,
+	.phylink_mac_link_down	= gsw1xx_phylink_mac_link_down,
+	.phylink_mac_link_up	= gsw1xx_phylink_mac_link_up,
+	.get_strings		= gsw1xx_get_strings,
+	.get_ethtool_stats	= gsw1xx_get_ethtool_stats,
+	.get_sset_count		= gsw1xx_get_sset_count,
+};
+
+int gsw1xx_probe(struct gsw1xx_priv *priv, struct device *dev)
+{
+	struct device_node *np, *mdio_np;
+	int err;
+	u32 version;
+
+	if (!priv->regmap || IS_ERR(priv->regmap))
+		return -EINVAL;
+
+	priv->hw_info = of_device_get_match_data(dev);
+	if (!priv->hw_info)
+		return -EINVAL;
+
+	priv->ds = devm_kzalloc(dev, sizeof(*priv->ds), GFP_KERNEL);
+	if (!priv->ds)
+		return -ENOMEM;
+
+	priv->ds->dev = dev;
+	priv->ds->num_ports = priv->hw_info->max_ports;
+	priv->ds->priv = priv;
+	priv->ds->ops = &gsw1xx_switch_ops;
+	priv->dev = dev;
+	version = gsw1xx_switch_r(priv, GSW1XX_IP_VERSION);
+
+	np = dev->of_node;
+	switch (version) {
+	case GSW1XX_IP_VERSION_2_3:
+		if (!of_device_is_compatible(np, "mxl,gsw145-mdio"))
+			return -EINVAL;
+		break;
+	default:
+		dev_err(dev, "unknown GSW1XX_IP version: 0x%x", version);
+		return -ENOENT;
+	}
+
+	/* bring up the mdio bus */
+	mdio_np = of_get_child_by_name(np, "mdio");
+	if (!mdio_np) {
+		dev_err(dev, "missing child mdio node\n");
+		return -EINVAL;
+	}
+
+	err = gsw1xx_mdio(priv, mdio_np);
+	if (err) {
+		dev_err(dev, "mdio probe failed\n");
+		goto put_mdio_node;
+	}
+
+	err = dsa_register_switch(priv->ds);
+	if (err) {
+		dev_err(dev, "dsa switch register failed: %i\n", err);
+		goto mdio_bus;
+	}
+	if (!dsa_is_cpu_port(priv->ds, priv->hw_info->cpu_port)) {
+		dev_err(dev,
+			"wrong CPU port defined, HW only supports port: %i",
+			priv->hw_info->cpu_port);
+		err = -EINVAL;
+		goto disable_switch;
+	}
+
+	dev_set_drvdata(dev, priv);
+
+	return 0;
+
+disable_switch:
+	gsw1xx_mdio_mask(priv, GSW1XX_MDIO_GLOB_ENABLE, 0, GSW1XX_MDIO_GLOB);
+	dsa_unregister_switch(priv->ds);
+mdio_bus:
+	if (mdio_np) {
+		mdiobus_unregister(priv->ds->slave_mii_bus);
+		mdiobus_free(priv->ds->slave_mii_bus);
+	}
+put_mdio_node:
+	of_node_put(mdio_np);
+	return err;
+}
+EXPORT_SYMBOL(gsw1xx_probe);
+
+void gsw1xx_remove(struct gsw1xx_priv *priv)
+{
+	if (!priv)
+		return;
+
+	/* disable the switch */
+	gsw1xx_mdio_mask(priv, GSW1XX_MDIO_GLOB_ENABLE, 0, GSW1XX_MDIO_GLOB);
+
+	dsa_unregister_switch(priv->ds);
+
+	if (priv->ds->slave_mii_bus) {
+		mdiobus_unregister(priv->ds->slave_mii_bus);
+		of_node_put(priv->ds->slave_mii_bus->dev.of_node);
+		mdiobus_free(priv->ds->slave_mii_bus);
+	}
+
+	dev_set_drvdata(priv->dev, NULL);
+}
+EXPORT_SYMBOL(gsw1xx_remove);
+
+void gsw1xx_shutdown(struct gsw1xx_priv *priv)
+{
+	if (!priv)
+		return;
+
+	/* disable the switch */
+	gsw1xx_mdio_mask(priv, GSW1XX_MDIO_GLOB_ENABLE, 0, GSW1XX_MDIO_GLOB);
+
+	dsa_switch_shutdown(priv->ds);
+
+	dev_set_drvdata(priv->dev, NULL);
+}
+EXPORT_SYMBOL(gsw1xx_shutdown);
+
+static const struct regmap_range gsw1xx_valid_regs[] = {
+	/* GSWIP Core Registers */
+	regmap_reg_range(GSW1XX_IP_BASE_ADDR,
+			 GSW1XX_IP_BASE_ADDR + GSW1XX_IP_REG_LEN),
+	/* Top Level PDI Registers, MDIO Master Reigsters */
+	regmap_reg_range(GSW1XX_MDIO_BASE_ADDR,
+			 GSW1XX_MDIO_BASE_ADDR + GSW1XX_MDIO_REG_LEN),
+};
+
+const struct regmap_access_table gsw1xx_register_set = {
+	.yes_ranges = gsw1xx_valid_regs,
+	.n_yes_ranges = ARRAY_SIZE(gsw1xx_valid_regs),
+};
+EXPORT_SYMBOL(gsw1xx_register_set);
+
+MODULE_AUTHOR("Camel Guo <camel.guo@axis.com>");
+MODULE_DESCRIPTION("Core Driver for MaxLinear GSM1XX ethernet switch");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/gsw1xx_mdio.c b/drivers/net/dsa/gsw1xx_mdio.c
new file mode 100644
index 000000000000..8328001041ed
--- /dev/null
+++ b/drivers/net/dsa/gsw1xx_mdio.c
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * MaxLinear switch driver for GSW1XX in MDIO managed mode
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mdio.h>
+#include <linux/phy.h>
+#include <linux/of.h>
+
+#include "gsw1xx.h"
+
+#define GSW1XX_SMDIO_TARGET_BASE_ADDR_REG	0x1F
+
+static int gsw1xx_mdio_write(void *ctx, uint32_t reg, uint32_t val)
+{
+	struct mdio_device *mdiodev = (struct mdio_device *)ctx;
+	int ret = 0;
+
+	mutex_lock_nested(&mdiodev->bus->mdio_lock, MDIO_MUTEX_NESTED);
+
+	ret = mdiodev->bus->write(mdiodev->bus, mdiodev->addr,
+				  GSW1XX_SMDIO_TARGET_BASE_ADDR_REG, reg);
+	if (ret < 0)
+		goto out;
+
+	ret = mdiodev->bus->write(mdiodev->bus, mdiodev->addr, 0, val);
+
+out:
+	mutex_unlock(&mdiodev->bus->mdio_lock);
+
+	return ret;
+}
+
+static int gsw1xx_mdio_read(void *ctx, uint32_t reg, uint32_t *val)
+{
+	struct mdio_device *mdiodev = (struct mdio_device *)ctx;
+	int ret = 0;
+
+	mutex_lock_nested(&mdiodev->bus->mdio_lock, MDIO_MUTEX_NESTED);
+
+	ret = mdiodev->bus->write(mdiodev->bus, mdiodev->addr,
+				  GSW1XX_SMDIO_TARGET_BASE_ADDR_REG, reg);
+	if (ret < 0)
+		goto out;
+
+	*val = mdiodev->bus->read(mdiodev->bus, mdiodev->addr, 0);
+
+out:
+	mutex_unlock(&mdiodev->bus->mdio_lock);
+
+	return ret;
+}
+
+static const struct regmap_config gsw1xx_mdio_regmap_config = {
+	.reg_bits = 16,
+	.val_bits = 16,
+	.reg_stride = 1,
+
+	.disable_locking = true,
+
+	.volatile_table = &gsw1xx_register_set,
+	.wr_table = &gsw1xx_register_set,
+	.rd_table = &gsw1xx_register_set,
+
+	.reg_read = gsw1xx_mdio_read,
+	.reg_write = gsw1xx_mdio_write,
+
+	.cache_type = REGCACHE_NONE,
+};
+
+static int gsw1xx_mdio_probe(struct mdio_device *mdiodev)
+{
+	struct gsw1xx_priv *priv;
+	struct device *dev = &mdiodev->dev;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->regmap = devm_regmap_init(dev, NULL, mdiodev,
+					&gsw1xx_mdio_regmap_config);
+	if (IS_ERR(priv->regmap)) {
+		ret = PTR_ERR(priv->regmap);
+		dev_err(dev, "regmap init failed: %d\n", ret);
+		return ret;
+	}
+
+	return gsw1xx_probe(priv, dev);
+}
+
+static void gsw1xx_mdio_remove(struct mdio_device *mdiodev)
+{
+	gsw1xx_remove(dev_get_drvdata(&mdiodev->dev));
+}
+
+static void gsw1xx_mdio_shutdown(struct mdio_device *mdiodev)
+{
+	gsw1xx_shutdown(dev_get_drvdata(&mdiodev->dev));
+}
+
+static const struct gsw1xx_hw_info gsw145_hw_info = {
+	.max_ports = 6,
+	.cpu_port = 5,
+};
+
+static const struct of_device_id gsw1xx_mdio_of_match[] = {
+	{ .compatible = "mxl,gsw145-mdio", .data = &gsw145_hw_info },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, gsw1xx_mdio_of_match);
+
+static struct mdio_driver gsw1xx_mdio_driver = {
+	.probe  = gsw1xx_mdio_probe,
+	.remove = gsw1xx_mdio_remove,
+	.shutdown = gsw1xx_mdio_shutdown,
+	.mdiodrv.driver = {
+		.name = "GSW1XX_MDIO",
+		.of_match_table = of_match_ptr(gsw1xx_mdio_of_match),
+	},
+};
+
+mdio_module_driver(gsw1xx_mdio_driver);
+
+MODULE_AUTHOR("Camel Guo <camel.guo@axis.com>");
+MODULE_DESCRIPTION("Driver for MaxLinear GSM1XX ethernet switch in MDIO managed mode");
+MODULE_LICENSE("GPL");
-- 
2.30.2

