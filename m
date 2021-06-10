Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E1B3A32D7
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhFJSRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:17:41 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:43529 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbhFJSRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:17:39 -0400
Received: by mail-ej1-f47.google.com with SMTP id ci15so576288ejc.10
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JJXuNl0mpU3kgqRdW/K9Rrcey4e6daDaPGYUerHmaWI=;
        b=nL4NX8nyfoxcBiG2a93oqisXX4vJfwXfUFf6+gu3Evoi9yjE7EvczT2iqNKAripc/v
         RDW7qDhEhXY2we6BCx4p6NAFcEX2lRh8DPZPpOkvgQ5DmzTK5O2CmBrOKpSurU49NKKP
         KJ8o1GZU2qFAHHJ3dAlXvpYIeNRlkIIFFCUeOkVxfhonRPkiMTXUwTFqbFQHnaW5X+u+
         C/iz8PC+UybPYGrD7d2Fp6ASDSAfxcMG2rI6N64rzBAxBE8wFt3rrwrueCyEWn/srnd4
         nRb4/LXVXiHAOrGF7inl+4DU3k3VwlnSRfemQwdHO+q8mKG9nM66okAadE4Ny30pqohm
         l8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JJXuNl0mpU3kgqRdW/K9Rrcey4e6daDaPGYUerHmaWI=;
        b=kWFw/t3IM8TgZeFuZLwHuqQI56I4LMNN5q6L6MxWjIjyciQJ+H/C7gaTH94wW+S6ZR
         FYNAQjS4D1bU0oYmxaXYbnXvj0iMjoQZwwpCMKrpQEoTTWQn92yyT/GnCGnGUhHa+ZTi
         O2p/+hYUZr1JaAZPeVl/xu+joh0NgbbSh8oQurkU9DRUIlAu+EnT9lMs8KUbtiPoq1Bt
         rDJovJpaJiPxDPrlRDfapkT7GeIeyp8s8Q6I62PXuZFIZDavUTNSwvxviOieJv4Onp/K
         GQUzjLIv8Ul2z2cq44bkY27xSHW1rq1ungbM+8JFsx/21jqH+Uz9E4AlniRBIT3ivugJ
         2rMA==
X-Gm-Message-State: AOAM533rxAwxn//nprnjlc1lJIVhiWRGF235FX6HySfIgvBpJaVPY/rP
        8iKdFdXL+3O1M2tHJCD6Pbk=
X-Google-Smtp-Source: ABdhPJyqw90AtkR1ga6pkTC9Y+mw4JOocDeGcyhJboEyI9e1f/+WJEhepey5oei35P+H3CjqbTlYoQ==
X-Received: by 2002:a17:906:1982:: with SMTP id g2mr853843ejd.184.1623348882434;
        Thu, 10 Jun 2021 11:14:42 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dh18sm1705660edb.92.2021.06.10.11.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:14:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 07/13] net: pcs: xpcs: add support for NXP SJA1105
Date:   Thu, 10 Jun 2021 21:14:04 +0300
Message-Id: <20210610181410.1886658-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610181410.1886658-1-olteanv@gmail.com>
References: <20210610181410.1886658-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The NXP SJA1105 DSA switch integrates a Synopsys SGMII XPCS on port 4.
The generic code works fine, except there is an integration issue which
needs to be dealt with: in this switch, the XPCS is integrated with a
PMA that has the TX lane polarity inverted by default (PLUS is MINUS,
MINUS is PLUS).

To obtain normal non-inverted behavior, the TX lane polarity must be
inverted in the PCS, via the DIGITAL_CONTROL_2 register.

We introduce a pma_config() method in xpcs_compat which is called by the
phylink_pcs_config() implementation.

Also, the NXP SJA1105 returns all zeroes in the PHY ID registers 2 and 3.
We need to hack up an ad-hoc PHY ID (OUI is zero, device ID is 1) in
order for the XPCS driver to recognize it. This PHY ID is added to the
public include/linux/pcs/pcs-xpcs.h for that reason (for the sja1105
driver to be able to use it in a later patch).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: fix module build (pcs-xpcs-nxp.c is not a different module so
        this means that we need to change the name of pcs-xpcs.ko to
        pcs_xpcs.ko).

 MAINTAINERS                    |  1 +
 drivers/net/pcs/Makefile       |  4 +++-
 drivers/net/pcs/pcs-xpcs-nxp.c | 16 ++++++++++++++++
 drivers/net/pcs/pcs-xpcs.c     | 25 +++++++++++++++++++++++--
 drivers/net/pcs/pcs-xpcs.h     | 10 ++++++++++
 include/linux/pcs/pcs-xpcs.h   |  2 ++
 6 files changed, 55 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/pcs/pcs-xpcs-nxp.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 004c0d1e723d..c0ba005349fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13209,6 +13209,7 @@ M:	Vladimir Oltean <olteanv@gmail.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/net/dsa/sja1105
+F:	drivers/net/pcs/pcs-xpcs-nxp.c
 
 NXP TDA998X DRM DRIVER
 M:	Russell King <linux@armlinux.org.uk>
diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
index c23146755972..0603d469bd57 100644
--- a/drivers/net/pcs/Makefile
+++ b/drivers/net/pcs/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux PCS drivers
 
-obj-$(CONFIG_PCS_XPCS)		+= pcs-xpcs.o
+pcs_xpcs-$(CONFIG_PCS_XPCS)	:= pcs-xpcs.o pcs-xpcs-nxp.o
+
+obj-$(CONFIG_PCS_XPCS)		+= pcs_xpcs.o
 obj-$(CONFIG_PCS_LYNX)		+= pcs-lynx.o
diff --git a/drivers/net/pcs/pcs-xpcs-nxp.c b/drivers/net/pcs/pcs-xpcs-nxp.c
new file mode 100644
index 000000000000..51b2fc7d36a9
--- /dev/null
+++ b/drivers/net/pcs/pcs-xpcs-nxp.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2021 NXP Semiconductors
+ */
+#include <linux/pcs/pcs-xpcs.h>
+#include "pcs-xpcs.h"
+
+/* In NXP SJA1105, the PCS is integrated with a PMA that has the TX lane
+ * polarity inverted by default (PLUS is MINUS, MINUS is PLUS). To obtain
+ * normal non-inverted behavior, the TX lane polarity must be inverted in the
+ * PCS, via the DIGITAL_CONTROL_2 register.
+ */
+int nxp_sja1105_sgmii_pma_config(struct dw_xpcs *xpcs)
+{
+	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL2,
+			  DW_VR_MII_DIG_CTRL2_TX_POL_INV);
+}
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index ecf5011977d3..3b1baacfaf8f 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -117,6 +117,7 @@ struct xpcs_compat {
 	const phy_interface_t *interface;
 	int num_interfaces;
 	int an_mode;
+	int (*pma_config)(struct dw_xpcs *xpcs);
 };
 
 struct xpcs_id {
@@ -168,7 +169,7 @@ static bool __xpcs_linkmode_supported(const struct xpcs_compat *compat,
 #define xpcs_linkmode_supported(compat, mode) \
 	__xpcs_linkmode_supported(compat, ETHTOOL_LINK_MODE_ ## mode ## _BIT)
 
-static int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg)
+int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg)
 {
 	u32 reg_addr = mdiobus_c45_addr(dev, reg);
 	struct mii_bus *bus = xpcs->mdiodev->bus;
@@ -177,7 +178,7 @@ static int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg)
 	return mdiobus_read(bus, addr, reg_addr);
 }
 
-static int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val)
+int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val)
 {
 	u32 reg_addr = mdiobus_c45_addr(dev, reg);
 	struct mii_bus *bus = xpcs->mdiodev->bus;
@@ -788,6 +789,12 @@ static int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 		return -1;
 	}
 
+	if (compat->pma_config) {
+		ret = compat->pma_config(xpcs);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
@@ -1022,11 +1029,25 @@ static const struct xpcs_compat synopsys_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
 	},
 };
 
+static const struct xpcs_compat nxp_sja1105_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
+	[DW_XPCS_SGMII] = {
+		.supported = xpcs_sgmii_features,
+		.interface = xpcs_sgmii_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_sgmii_interfaces),
+		.an_mode = DW_AN_C37_SGMII,
+		.pma_config = nxp_sja1105_sgmii_pma_config,
+	},
+};
+
 static const struct xpcs_id xpcs_id_list[] = {
 	{
 		.id = SYNOPSYS_XPCS_ID,
 		.mask = SYNOPSYS_XPCS_MASK,
 		.compat = synopsys_xpcs_compat,
+	}, {
+		.id = NXP_SJA1105_XPCS_ID,
+		.mask = SYNOPSYS_XPCS_MASK,
+		.compat = nxp_sja1105_xpcs_compat,
 	},
 };
 
diff --git a/drivers/net/pcs/pcs-xpcs.h b/drivers/net/pcs/pcs-xpcs.h
index 867537a68c63..3daf4276a158 100644
--- a/drivers/net/pcs/pcs-xpcs.h
+++ b/drivers/net/pcs/pcs-xpcs.h
@@ -60,10 +60,15 @@
 /* EEE Mode Control Register */
 #define DW_VR_MII_EEE_MCTRL0		0x8006
 #define DW_VR_MII_EEE_MCTRL1		0x800b
+#define DW_VR_MII_DIG_CTRL2		0x80e1
 
 /* VR_MII_DIG_CTRL1 */
 #define DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW		BIT(9)
 
+/* VR_MII_DIG_CTRL2 */
+#define DW_VR_MII_DIG_CTRL2_TX_POL_INV		BIT(4)
+#define DW_VR_MII_DIG_CTRL2_RX_POL_INV		BIT(0)
+
 /* VR_MII_AN_CTRL */
 #define DW_VR_MII_AN_CTRL_TX_CONFIG_SHIFT	3
 #define DW_VR_MII_TX_CONFIG_MASK		BIT(3)
@@ -101,3 +106,8 @@
 
 /* VR MII EEE Control 1 defines */
 #define DW_VR_MII_EEE_TRN_LPI		BIT(0)	/* Transparent Mode Enable */
+
+int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg);
+int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val);
+
+int nxp_sja1105_sgmii_pma_config(struct dw_xpcs *xpcs);
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 4f1cdf6f3d4c..c594f7cdc304 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -10,6 +10,8 @@
 #include <linux/phy.h>
 #include <linux/phylink.h>
 
+#define NXP_SJA1105_XPCS_ID		0x00000010
+
 /* AN mode */
 #define DW_AN_C73			1
 #define DW_AN_C37_SGMII			2
-- 
2.25.1

