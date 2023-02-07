Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8B368DA9C
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjBGOY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbjBGOY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:24:57 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A97415C86;
        Tue,  7 Feb 2023 06:24:47 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pPOtp-0002Ca-1K;
        Tue, 07 Feb 2023 15:24:45 +0100
Date:   Tue, 7 Feb 2023 14:23:08 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: [PATCH v2 09/11] net: pcs: add driver for MediaTek SGMII PCS
Message-ID: <20bcf972bc1b27ad14977a235292ef47443a7043.1675779094.git.daniel@makrotopia.org>
References: <cover.1675779094.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675779094.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SGMII core found in several MediaTek SoCs is identical to what can
also be found in MediaTek's MT7531 Ethernet switch IC.
As this has not always been clear, both drivers developed different
implementations to deal with the PCS.

Add a dedicated driver, mostly by copying the code now found in the
Ethernet driver. The now redundant code will be removed by a follow-up
commit.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 MAINTAINERS                       |   7 +
 drivers/net/pcs/Kconfig           |   8 +
 drivers/net/pcs/Makefile          |   1 +
 drivers/net/pcs/pcs-mtk-lynxi.c   | 315 ++++++++++++++++++++++++++++++
 include/linux/pcs/pcs-mtk-lynxi.h |  13 ++
 5 files changed, 344 insertions(+)
 create mode 100644 drivers/net/pcs/pcs-mtk-lynxi.c
 create mode 100644 include/linux/pcs/pcs-mtk-lynxi.h

diff --git a/MAINTAINERS b/MAINTAINERS
index f76ca2808474..41f4de91a434 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12998,6 +12998,13 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/mediatek/
 
+MEDIATEK ETHERNET PCS DRIVER
+M:	Daniel Golle <daniel@makrotopia.org>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/pcs/pcs-mtk-lynxi.c
+F:	include/linux/pcs/pcs-mtk-lynxi.h
+
 MEDIATEK I2C CONTROLLER DRIVER
 M:	Qii Wang <qii.wang@mediatek.com>
 L:	linux-i2c@vger.kernel.org
diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 6e7e6c346a3e..9b792b61c768 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -18,6 +18,14 @@ config PCS_LYNX
 	  This module provides helpers to phylink for managing the Lynx PCS
 	  which is part of the Layerscape and QorIQ Ethernet SERDES.
 
+config PCS_MTK_LYNXI
+	tristate
+	select PHYLINK
+	select REGMAP
+	help
+	  This module provides helpers to phylink for managing the LynxI PCS
+	  which is part of MediaTek's SoC and Ethernet switch ICs.
+
 config PCS_RZN1_MIIC
 	tristate "Renesas RZ/N1 MII converter"
 	depends on OF && (ARCH_RZN1 || COMPILE_TEST)
diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
index 4c780d8f2e98..9b9afd6b1c22 100644
--- a/drivers/net/pcs/Makefile
+++ b/drivers/net/pcs/Makefile
@@ -5,5 +5,6 @@ pcs_xpcs-$(CONFIG_PCS_XPCS)	:= pcs-xpcs.o pcs-xpcs-nxp.o
 
 obj-$(CONFIG_PCS_XPCS)		+= pcs_xpcs.o
 obj-$(CONFIG_PCS_LYNX)		+= pcs-lynx.o
+obj-$(CONFIG_PCS_MTK_LYNXI)	+= pcs-mtk-lynxi.o
 obj-$(CONFIG_PCS_RZN1_MIIC)	+= pcs-rzn1-miic.o
 obj-$(CONFIG_PCS_ALTERA_TSE)	+= pcs-altera-tse.o
diff --git a/drivers/net/pcs/pcs-mtk-lynxi.c b/drivers/net/pcs/pcs-mtk-lynxi.c
new file mode 100644
index 000000000000..0100def53d45
--- /dev/null
+++ b/drivers/net/pcs/pcs-mtk-lynxi.c
@@ -0,0 +1,315 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2018-2019 MediaTek Inc.
+/* A library for MediaTek SGMII circuit
+ *
+ * Author: Sean Wang <sean.wang@mediatek.com>
+ * Author: Daniel Golle <daniel@makrotopia.org>
+ *
+ */
+#include <linux/mdio.h>
+#include <linux/phylink.h>
+#include <linux/pcs/pcs-mtk-lynxi.h>
+#include <linux/of.h>
+#include <linux/phylink.h>
+#include <linux/regmap.h>
+
+/* SGMII subsystem config registers */
+/* BMCR (low 16) BMSR (high 16) */
+#define SGMSYS_PCS_CONTROL_1		0x0
+#define SGMII_BMCR			GENMASK(15, 0)
+#define SGMII_BMSR			GENMASK(31, 16)
+#define SGMII_AN_RESTART		BIT(9)
+#define SGMII_ISOLATE			BIT(10)
+#define SGMII_AN_ENABLE			BIT(12)
+#define SGMII_LINK_STATYS		BIT(18)
+#define SGMII_AN_ABILITY		BIT(19)
+#define SGMII_AN_COMPLETE		BIT(21)
+#define SGMII_PCS_FAULT			BIT(23)
+#define SGMII_AN_EXPANSION_CLR		BIT(30)
+
+#define SGMSYS_PCS_DEVICE_ID		0x4
+#define SGMII_LYNXI_DEV_ID		0x4d544950
+
+#define SGMSYS_PCS_ADVERTISE		0x8
+#define SGMII_ADVERTISE			GENMASK(15, 0)
+#define SGMII_LPA			GENMASK(31, 16)
+
+#define SGMSYS_PCS_SCRATCH		0x14
+#define SGMII_DEV_VERSION		GENMASK(31, 16)
+
+/* Register to programmable link timer, the unit in 2 * 8ns */
+#define SGMSYS_PCS_LINK_TIMER		0x18
+#define SGMII_LINK_TIMER_MASK		GENMASK(19, 0)
+#define SGMII_LINK_TIMER_DEFAULT	(0x186a0 & SGMII_LINK_TIMER_MASK)
+
+/* Register to control remote fault */
+#define SGMSYS_SGMII_MODE		0x20
+#define SGMII_IF_MODE_SGMII		BIT(0)
+#define SGMII_SPEED_DUPLEX_AN		BIT(1)
+#define SGMII_SPEED_MASK		GENMASK(3, 2)
+#define SGMII_SPEED_10			FIELD_PREP(SGMII_SPEED_MASK, 0)
+#define SGMII_SPEED_100			FIELD_PREP(SGMII_SPEED_MASK, 1)
+#define SGMII_SPEED_1000		FIELD_PREP(SGMII_SPEED_MASK, 2)
+#define SGMII_DUPLEX_HALF		BIT(4)
+#define SGMII_REMOTE_FAULT_DIS		BIT(8)
+#define SGMII_CODE_SYNC_SET_VAL		BIT(9)
+#define SGMII_CODE_SYNC_SET_EN		BIT(10)
+#define SGMII_SEND_AN_ERROR_EN		BIT(11)
+
+/* Register to reset SGMII design */
+#define SGMII_RESERVED_0		0x34
+#define SGMII_SW_RESET			BIT(0)
+
+/* Register to set SGMII speed, ANA RG_ Control Signals III */
+#define SGMSYS_ANA_RG_CS3		0x2028
+#define RG_PHY_SPEED_MASK		(BIT(2) | BIT(3))
+#define RG_PHY_SPEED_1_25G		0x0
+#define RG_PHY_SPEED_3_125G		BIT(2)
+
+/* Register to power up QPHY */
+#define SGMSYS_QPHY_PWR_STATE_CTRL	0xe8
+#define	SGMII_PHYA_PWD			BIT(4)
+
+/* Register to QPHY wrapper control */
+#define SGMSYS_QPHY_WRAP_CTRL		0xec
+#define SGMII_PN_SWAP_MASK		GENMASK(1, 0)
+#define SGMII_PN_SWAP_TX_RX		(BIT(0) | BIT(1))
+
+/* struct mtk_pcs_lynxi -  This structure holds each sgmii regmap andassociated
+ *                         data
+ * @regmap:                The register map pointing at the range used to setup
+ *                         SGMII modes
+ * @dev:                   Pointer to device owning the PCS
+ * @ana_rgc3:              The offset refers to register ANA_RGC3 related to regmap
+ * @interface:             Currently configured interface mode
+ * @pcs:                   Phylink PCS structure
+ * @flags:                 Flags indicating hardware properties
+ */
+struct mtk_pcs_lynxi {
+	struct regmap		*regmap;
+	struct device		*dev;
+	u32			ana_rgc3;
+	phy_interface_t		interface;
+	struct			phylink_pcs pcs;
+	u32			flags;
+};
+
+static struct mtk_pcs_lynxi *pcs_to_mtk_pcs_lynxi(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct mtk_pcs_lynxi, pcs);
+}
+
+static void mtk_pcs_lynxi_get_state(struct phylink_pcs *pcs,
+			      struct phylink_link_state *state)
+{
+	struct mtk_pcs_lynxi *mpcs = pcs_to_mtk_pcs_lynxi(pcs);
+	unsigned int bm, adv;
+
+	/* Read the BMSR and LPA */
+	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
+	regmap_read(mpcs->regmap, SGMSYS_PCS_ADVERTISE, &adv);
+
+	phylink_mii_c22_pcs_decode_state(state, FIELD_GET(SGMII_BMSR, bm),
+					 FIELD_GET(SGMII_LPA, adv));
+}
+
+static int mtk_pcs_lynxi_config(struct phylink_pcs *pcs, unsigned int mode,
+			  phy_interface_t interface,
+			  const unsigned long *advertising,
+			  bool permit_pause_to_mac)
+{
+	struct mtk_pcs_lynxi *mpcs = pcs_to_mtk_pcs_lynxi(pcs);
+	unsigned int rgc3, sgm_mode, bmcr;
+	int advertise, link_timer;
+	bool mode_changed = false, changed, use_an;
+
+	advertise = phylink_mii_c22_pcs_encode_advertisement(interface,
+							     advertising);
+	if (advertise < 0)
+		return advertise;
+
+	/* Clearing IF_MODE_BIT0 switches the PCS to BASE-X mode, and
+	 * we assume that fixes it's speed at bitrate = line rate (in
+	 * other words, 1000Mbps or 2500Mbps).
+	 */
+	if (interface == PHY_INTERFACE_MODE_SGMII) {
+		sgm_mode = SGMII_IF_MODE_SGMII;
+		if (phylink_autoneg_inband(mode)) {
+			sgm_mode |= SGMII_REMOTE_FAULT_DIS |
+				    SGMII_SPEED_DUPLEX_AN;
+			use_an = true;
+		} else {
+			use_an = false;
+		}
+	} else if (phylink_autoneg_inband(mode)) {
+		/* 1000base-X or 2500base-X autoneg */
+		sgm_mode = SGMII_REMOTE_FAULT_DIS;
+		use_an = linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					   advertising);
+	} else {
+		/* 1000base-X or 2500base-X without autoneg */
+		sgm_mode = 0;
+		use_an = false;
+	}
+
+	if (use_an)
+		bmcr = SGMII_AN_ENABLE;
+	else
+		bmcr = 0;
+
+	if (mpcs->interface != interface) {
+		/* PHYA power down */
+		regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
+				   SGMII_PHYA_PWD, SGMII_PHYA_PWD);
+
+		/* Reset SGMII PCS state */
+		regmap_update_bits(mpcs->regmap, SGMII_RESERVED_0,
+				   SGMII_SW_RESET, SGMII_SW_RESET);
+
+		if (mpcs->flags & MTK_SGMII_FLAG_PN_SWAP)
+			regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_WRAP_CTRL,
+					   SGMII_PN_SWAP_MASK,
+					   SGMII_PN_SWAP_TX_RX);
+
+		if (interface == PHY_INTERFACE_MODE_2500BASEX)
+			rgc3 = RG_PHY_SPEED_3_125G;
+		else
+			rgc3 = 0;
+
+		/* Configure the underlying interface speed */
+		regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
+				   RG_PHY_SPEED_MASK, rgc3);
+
+		/* Setup the link timer and QPHY power up inside SGMIISYS */
+		link_timer = phylink_get_link_timer_ns(interface);
+		if (link_timer < 0)
+			return link_timer;
+
+		regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, link_timer / 2 / 8);
+
+		mpcs->interface = interface;
+		mode_changed = true;
+	}
+
+	/* Update the advertisement, noting whether it has changed */
+	regmap_update_bits_check(mpcs->regmap, SGMSYS_PCS_ADVERTISE,
+				 SGMII_ADVERTISE, advertise, &changed);
+
+	/* Update the sgmsys mode register */
+	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
+			   SGMII_REMOTE_FAULT_DIS | SGMII_SPEED_DUPLEX_AN |
+			   SGMII_IF_MODE_SGMII, sgm_mode);
+
+	/* Update the BMCR */
+	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
+			   SGMII_AN_ENABLE, bmcr);
+
+	/* Release PHYA power down state
+	 * Only removing bit SGMII_PHYA_PWD isn't enough.
+	 * There are cases when the SGMII_PHYA_PWD register contains 0x9 which
+	 * prevents SGMII from working. The SGMII still shows link but no traffic
+	 * can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
+	 * taken from a good working state of the SGMII interface.
+	 * Unknown how much the QPHY needs but it is racy without a sleep.
+	 * Tested on mt7622 & mt7986.
+	 */
+	usleep_range(50, 100);
+	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, 0);
+
+	return changed || mode_changed;
+}
+
+static void mtk_pcs_lynxi_restart_an(struct phylink_pcs *pcs)
+{
+	struct mtk_pcs_lynxi *mpcs = pcs_to_mtk_pcs_lynxi(pcs);
+
+	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
+			   SGMII_AN_RESTART, SGMII_AN_RESTART);
+}
+
+static void mtk_pcs_lynxi_link_up(struct phylink_pcs *pcs, unsigned int mode,
+			    phy_interface_t interface, int speed, int duplex)
+{
+	struct mtk_pcs_lynxi *mpcs = pcs_to_mtk_pcs_lynxi(pcs);
+	unsigned int sgm_mode;
+
+	if (!phylink_autoneg_inband(mode)) {
+		/* Force the speed and duplex setting */
+		if (speed == SPEED_10)
+			sgm_mode = SGMII_SPEED_10;
+		else if (speed == SPEED_100)
+			sgm_mode = SGMII_SPEED_100;
+		else
+			sgm_mode = SGMII_SPEED_1000;
+
+		if (duplex != DUPLEX_FULL)
+			sgm_mode |= SGMII_DUPLEX_HALF;
+
+		regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
+				   SGMII_DUPLEX_HALF | SGMII_SPEED_MASK,
+				   sgm_mode);
+	}
+}
+
+static const struct phylink_pcs_ops mtk_pcs_lynxi_ops = {
+	.pcs_get_state = mtk_pcs_lynxi_get_state,
+	.pcs_config = mtk_pcs_lynxi_config,
+	.pcs_an_restart = mtk_pcs_lynxi_restart_an,
+	.pcs_link_up = mtk_pcs_lynxi_link_up,
+};
+
+struct phylink_pcs *mtk_pcs_lynxi_create(struct device *dev, struct regmap *regmap,
+				   u32 ana_rgc3, u32 flags)
+{
+	struct mtk_pcs_lynxi *mpcs;
+	u32 id, ver;
+	int ret;
+
+	ret = regmap_read(regmap, SGMSYS_PCS_DEVICE_ID, &id);
+	if (ret < 0)
+		return NULL;
+
+	if (id != SGMII_LYNXI_DEV_ID) {
+		dev_err(dev, "unknown PCS device id %08x\n", id);
+		return NULL;
+	}
+
+	ret = regmap_read(regmap, SGMSYS_PCS_SCRATCH, &ver);
+	if (ret < 0)
+		return NULL;
+
+	ver = FIELD_GET(SGMII_DEV_VERSION, ver);
+	if (ver != 0x1) {
+		dev_err(dev, "unknown PCS device version %04x\n", ver);
+		return NULL;
+	}
+
+	dev_dbg(dev, "MediaTek LynxI SGMII PCS (id 0x%08x, ver 0x%04x)\n", id,
+		ver);
+
+	mpcs = kzalloc(sizeof(*mpcs), GFP_KERNEL);
+	if (!mpcs)
+		return NULL;
+
+	mpcs->dev = dev;
+	mpcs->ana_rgc3 = ana_rgc3;
+	mpcs->regmap = regmap;
+	mpcs->flags = flags;
+	mpcs->pcs.ops = &mtk_pcs_lynxi_ops;
+	mpcs->pcs.poll = true;
+	mpcs->interface = PHY_INTERFACE_MODE_NA;
+
+	return &mpcs->pcs;
+}
+EXPORT_SYMBOL(mtk_pcs_lynxi_create);
+
+void mtk_pcs_lynxi_destroy(struct phylink_pcs *pcs)
+{
+	if (!pcs)
+		return;
+
+	kfree(pcs_to_mtk_pcs_lynxi(pcs));
+}
+EXPORT_SYMBOL(mtk_pcs_lynxi_destroy);
+
+MODULE_LICENSE("GPL");
diff --git a/include/linux/pcs/pcs-mtk-lynxi.h b/include/linux/pcs/pcs-mtk-lynxi.h
new file mode 100644
index 000000000000..be3b4ab32f4a
--- /dev/null
+++ b/include/linux/pcs/pcs-mtk-lynxi.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_PCS_MTK_LYNXI_H
+#define __LINUX_PCS_MTK_LYNXI_H
+
+#include <linux/phylink.h>
+#include <linux/regmap.h>
+
+#define MTK_SGMII_FLAG_PN_SWAP BIT(0)
+struct phylink_pcs *mtk_pcs_lynxi_create(struct device *dev,
+					 struct regmap *regmap,
+					 u32 ana_rgc3, u32 flags);
+void mtk_pcs_lynxi_destroy(struct phylink_pcs *pcs);
+#endif
-- 
2.39.1

