Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4885EFD38
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 20:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbiI2SnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 14:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbiI2SnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 14:43:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB6214B86D;
        Thu, 29 Sep 2022 11:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664476965; x=1696012965;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/RLFy7g5v+cj6ohYF7SF4BeeL3jkEToKD/iLkzTbLuo=;
  b=T09ykfju4njpMBf3fK24LNNPoHBQc+g2oGyMY11VjN2bJVEzqOU0hfkZ
   TZYWJL2GMAjdPOAKdmYmhJqxcM6JAJYGVzNBD/Nrza/vg1kSb3IXMEvvX
   grv2S+3MZ1buTt466Rz30aXeOBbbKUkaqH2hnFcVLd/K5+BqqHnulKTBc
   IR9g6FWix4nn1sJdznhXYE3YSXgS58sNiU4qTlDasSKuWYuGq56iOasWc
   ztNAuKM4oBS0oaRa5gKRGgT4EOKM5tFdfrxIjmF2BTkeZ+Kutvb+SrvTT
   m2X0ldYt0a3AHmkCUANFulKDFS9n/EtIHHry0nDBcc5fMxkTByfRSUPcj
   A==;
X-IronPort-AV: E=Sophos;i="5.93,356,1654585200"; 
   d="scan'208";a="193094697"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Sep 2022 11:42:42 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 29 Sep 2022 11:42:39 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 29 Sep 2022 11:42:36 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <joe@perches.com>, <linux@armlinux.org.uk>,
        <horatiu.vultur@microchip.com>, <Julia.Lawall@inria.fr>,
        <vladimir.oltean@nxp.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next v2 3/6] net: microchip: sparx5: add support for offloading pcp table
Date:   Thu, 29 Sep 2022 20:52:04 +0200
Message-ID: <20220929185207.2183473-4-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220929185207.2183473-1-daniel.machon@microchip.com>
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new registers and functions to support offload of pcp app entries.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 101 ++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_main.h   |   1 +
 .../microchip/sparx5/sparx5_main_regs.h       | 127 +++++++++++++++++-
 .../ethernet/microchip/sparx5/sparx5_netdev.c |   1 +
 .../ethernet/microchip/sparx5/sparx5_port.c   |  37 +++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |  17 +++
 7 files changed, 283 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index d1c6ad966747..e3460e16f8fc 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
  sparx5_netdev.o sparx5_phylink.o sparx5_port.o sparx5_mactable.o sparx5_vlan.o \
  sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
- sparx5_ptp.o sparx5_pgid.o sparx5_tc.o sparx5_qos.o
+ sparx5_ptp.o sparx5_pgid.o sparx5_tc.o sparx5_qos.o sparx5_dcb.o
\ No newline at end of file
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
new file mode 100644
index 000000000000..db17c124dac8
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <net/dcbnl.h>
+
+#include "sparx5_port.h"
+
+/* Validate app entry.
+ *
+ * Check for valid selectors and valid protocol and priority ranges.
+ */
+static int sparx5_dcb_app_validate(struct net_device *dev,
+				   const struct dcb_app *app)
+{
+	int err = 0;
+
+	switch (app->selector) {
+	/* Pcp checks */
+	case DCB_APP_SEL_PCP:
+		if (app->protocol > 15)
+			err = -EINVAL;
+		else if (app->priority >= SPX5_PRIOS)
+			err = -ERANGE;
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	if (err)
+		netdev_err(dev, "Invalid entry: %d:%d\n", app->protocol,
+			   app->priority);
+
+	return err;
+}
+
+static int sparx5_dcb_app_update(struct net_device *dev)
+{
+	struct dcb_app app_itr = { .selector = DCB_APP_SEL_PCP };
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5_port_qos_pcp_map *pcp_map;
+	struct sparx5_port_qos qos = {0};
+	int i;
+
+	pcp_map = &qos.pcp.map;
+
+	/* Get pcp ingress mapping */
+	for (i = 0; i < ARRAY_SIZE(pcp_map->map); i++) {
+		app_itr.protocol = i;
+		pcp_map->map[i] = dcb_getapp(dev, &app_itr);
+	}
+
+	return sparx5_port_qos_set(port, &qos);
+}
+
+static int sparx5_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
+{
+	struct dcb_app app_itr;
+	int err = 0;
+	u8 prio;
+
+	err = sparx5_dcb_app_validate(dev, app);
+	if (err)
+		goto out;
+
+	/* Delete current mapping, if it exists */
+	prio = dcb_getapp(dev, app);
+	if (prio) {
+		app_itr = *app;
+		app_itr.priority = prio;
+		dcb_ieee_delapp(dev, &app_itr);
+	}
+
+	err = dcb_ieee_setapp(dev, app);
+	if (err)
+		goto out;
+
+	sparx5_dcb_app_update(dev);
+
+out:
+	return err;
+}
+
+static int sparx5_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
+{
+	int err;
+
+	err = dcb_ieee_delapp(dev, app);
+	if (err < 0)
+		return err;
+
+	return sparx5_dcb_app_update(dev);
+}
+
+const struct dcbnl_rtnl_ops sparx5_dcbnl_ops = {
+	.ieee_setapp = sparx5_dcb_ieee_setapp,
+	.ieee_delapp = sparx5_dcb_ieee_delapp,
+};
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 8b42cad0e49c..0d8e04c64584 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -418,6 +418,7 @@ static inline bool sparx5_is_baser(phy_interface_t interface)
 extern const struct phylink_mac_ops sparx5_phylink_mac_ops;
 extern const struct phylink_pcs_ops sparx5_phylink_pcs_ops;
 extern const struct ethtool_ops sparx5_ethtool_ops;
+extern const struct dcbnl_rtnl_ops sparx5_dcbnl_ops;

 /* Calculate raw offset */
 static inline __pure int spx5_offset(int id, int tinst, int tcnt,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
index fa2eb70f487a..e8c3a0d6074f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
@@ -4,8 +4,8 @@
  * Copyright (c) 2021 Microchip Technology Inc.
  */

-/* This file is autogenerated by cml-utils 2022-02-26 14:15:01 +0100.
- * Commit ID: 98bdd3d171cc2a1afd30d241d41a4281d471a48c (dirty)
+/* This file is autogenerated by cml-utils 2022-09-28 11:17:02 +0200.
+ * Commit ID: 385c8a11d71a9f6a60368d3a3cb648fa257b479a
  */

 #ifndef _SPARX5_MAIN_REGS_H_
@@ -426,6 +426,96 @@ enum sparx5_target {
 #define ANA_CL_VLAN_CTRL_2_VLAN_PUSH_CNT_GET(x)\
 	FIELD_GET(ANA_CL_VLAN_CTRL_2_VLAN_PUSH_CNT, x)

+/*      ANA_CL:PORT:PCP_DEI_MAP_CFG */
+#define ANA_CL_PCP_DEI_MAP_CFG(g, r) __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 108, r, 16, 4)
+
+#define ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_DP_VAL    GENMASK(4, 3)
+#define ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_DP_VAL_SET(x)\
+	FIELD_PREP(ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_DP_VAL, x)
+#define ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_DP_VAL_GET(x)\
+	FIELD_GET(ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_DP_VAL, x)
+
+#define ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_QOS_VAL   GENMASK(2, 0)
+#define ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_QOS_VAL_SET(x)\
+	FIELD_PREP(ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_QOS_VAL, x)
+#define ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_QOS_VAL_GET(x)\
+	FIELD_GET(ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_QOS_VAL, x)
+
+/*      ANA_CL:PORT:QOS_CFG */
+#define ANA_CL_QOS_CFG(g)         __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 172, 0, 1, 4)
+
+#define ANA_CL_QOS_CFG_DEFAULT_COSID_ENA         BIT(17)
+#define ANA_CL_QOS_CFG_DEFAULT_COSID_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_CFG_DEFAULT_COSID_ENA, x)
+#define ANA_CL_QOS_CFG_DEFAULT_COSID_ENA_GET(x)\
+	FIELD_GET(ANA_CL_QOS_CFG_DEFAULT_COSID_ENA, x)
+
+#define ANA_CL_QOS_CFG_DEFAULT_COSID_VAL         GENMASK(16, 14)
+#define ANA_CL_QOS_CFG_DEFAULT_COSID_VAL_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_CFG_DEFAULT_COSID_VAL, x)
+#define ANA_CL_QOS_CFG_DEFAULT_COSID_VAL_GET(x)\
+	FIELD_GET(ANA_CL_QOS_CFG_DEFAULT_COSID_VAL, x)
+
+#define ANA_CL_QOS_CFG_DSCP_REWR_MODE_SEL        GENMASK(13, 12)
+#define ANA_CL_QOS_CFG_DSCP_REWR_MODE_SEL_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_CFG_DSCP_REWR_MODE_SEL, x)
+#define ANA_CL_QOS_CFG_DSCP_REWR_MODE_SEL_GET(x)\
+	FIELD_GET(ANA_CL_QOS_CFG_DSCP_REWR_MODE_SEL, x)
+
+#define ANA_CL_QOS_CFG_DSCP_TRANSLATE_ENA        BIT(11)
+#define ANA_CL_QOS_CFG_DSCP_TRANSLATE_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_CFG_DSCP_TRANSLATE_ENA, x)
+#define ANA_CL_QOS_CFG_DSCP_TRANSLATE_ENA_GET(x)\
+	FIELD_GET(ANA_CL_QOS_CFG_DSCP_TRANSLATE_ENA, x)
+
+#define ANA_CL_QOS_CFG_DSCP_KEEP_ENA             BIT(10)
+#define ANA_CL_QOS_CFG_DSCP_KEEP_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_CFG_DSCP_KEEP_ENA, x)
+#define ANA_CL_QOS_CFG_DSCP_KEEP_ENA_GET(x)\
+	FIELD_GET(ANA_CL_QOS_CFG_DSCP_KEEP_ENA, x)
+
+#define ANA_CL_QOS_CFG_KEEP_ENA                  BIT(9)
+#define ANA_CL_QOS_CFG_KEEP_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_CFG_KEEP_ENA, x)
+#define ANA_CL_QOS_CFG_KEEP_ENA_GET(x)\
+	FIELD_GET(ANA_CL_QOS_CFG_KEEP_ENA, x)
+
+#define ANA_CL_QOS_CFG_PCP_DEI_DP_ENA            BIT(8)
+#define ANA_CL_QOS_CFG_PCP_DEI_DP_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_CFG_PCP_DEI_DP_ENA, x)
+#define ANA_CL_QOS_CFG_PCP_DEI_DP_ENA_GET(x)\
+	FIELD_GET(ANA_CL_QOS_CFG_PCP_DEI_DP_ENA, x)
+
+#define ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA           BIT(7)
+#define ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA, x)
+#define ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA_GET(x)\
+	FIELD_GET(ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA, x)
+
+#define ANA_CL_QOS_CFG_DSCP_DP_ENA               BIT(6)
+#define ANA_CL_QOS_CFG_DSCP_DP_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_CFG_DSCP_DP_ENA, x)
+#define ANA_CL_QOS_CFG_DSCP_DP_ENA_GET(x)\
+	FIELD_GET(ANA_CL_QOS_CFG_DSCP_DP_ENA, x)
+
+#define ANA_CL_QOS_CFG_DSCP_QOS_ENA              BIT(5)
+#define ANA_CL_QOS_CFG_DSCP_QOS_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_CFG_DSCP_QOS_ENA, x)
+#define ANA_CL_QOS_CFG_DSCP_QOS_ENA_GET(x)\
+	FIELD_GET(ANA_CL_QOS_CFG_DSCP_QOS_ENA, x)
+
+#define ANA_CL_QOS_CFG_DEFAULT_DP_VAL            GENMASK(4, 3)
+#define ANA_CL_QOS_CFG_DEFAULT_DP_VAL_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_CFG_DEFAULT_DP_VAL, x)
+#define ANA_CL_QOS_CFG_DEFAULT_DP_VAL_GET(x)\
+	FIELD_GET(ANA_CL_QOS_CFG_DEFAULT_DP_VAL, x)
+
+#define ANA_CL_QOS_CFG_DEFAULT_QOS_VAL           GENMASK(2, 0)
+#define ANA_CL_QOS_CFG_DEFAULT_QOS_VAL_SET(x)\
+	FIELD_PREP(ANA_CL_QOS_CFG_DEFAULT_QOS_VAL, x)
+#define ANA_CL_QOS_CFG_DEFAULT_QOS_VAL_GET(x)\
+	FIELD_GET(ANA_CL_QOS_CFG_DEFAULT_QOS_VAL, x)
+
 /*      ANA_CL:PORT:CAPTURE_BPDU_CFG */
 #define ANA_CL_CAPTURE_BPDU_CFG(g) __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 196, 0, 1, 4)

@@ -438,6 +528,39 @@ enum sparx5_target {
 #define ANA_CL_OWN_UPSID_OWN_UPSID_GET(x)\
 	FIELD_GET(ANA_CL_OWN_UPSID_OWN_UPSID, x)

+/*      ANA_CL:COMMON:DSCP_CFG */
+#define ANA_CL_DSCP_CFG(r)        __REG(TARGET_ANA_CL, 0, 1, 166912, 0, 1, 756, 256, r, 64, 4)
+
+#define ANA_CL_DSCP_CFG_DSCP_TRANSLATE_VAL       GENMASK(12, 7)
+#define ANA_CL_DSCP_CFG_DSCP_TRANSLATE_VAL_SET(x)\
+	FIELD_PREP(ANA_CL_DSCP_CFG_DSCP_TRANSLATE_VAL, x)
+#define ANA_CL_DSCP_CFG_DSCP_TRANSLATE_VAL_GET(x)\
+	FIELD_GET(ANA_CL_DSCP_CFG_DSCP_TRANSLATE_VAL, x)
+
+#define ANA_CL_DSCP_CFG_DSCP_QOS_VAL             GENMASK(6, 4)
+#define ANA_CL_DSCP_CFG_DSCP_QOS_VAL_SET(x)\
+	FIELD_PREP(ANA_CL_DSCP_CFG_DSCP_QOS_VAL, x)
+#define ANA_CL_DSCP_CFG_DSCP_QOS_VAL_GET(x)\
+	FIELD_GET(ANA_CL_DSCP_CFG_DSCP_QOS_VAL, x)
+
+#define ANA_CL_DSCP_CFG_DSCP_DP_VAL              GENMASK(3, 2)
+#define ANA_CL_DSCP_CFG_DSCP_DP_VAL_SET(x)\
+	FIELD_PREP(ANA_CL_DSCP_CFG_DSCP_DP_VAL, x)
+#define ANA_CL_DSCP_CFG_DSCP_DP_VAL_GET(x)\
+	FIELD_GET(ANA_CL_DSCP_CFG_DSCP_DP_VAL, x)
+
+#define ANA_CL_DSCP_CFG_DSCP_REWR_ENA            BIT(1)
+#define ANA_CL_DSCP_CFG_DSCP_REWR_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_DSCP_CFG_DSCP_REWR_ENA, x)
+#define ANA_CL_DSCP_CFG_DSCP_REWR_ENA_GET(x)\
+	FIELD_GET(ANA_CL_DSCP_CFG_DSCP_REWR_ENA, x)
+
+#define ANA_CL_DSCP_CFG_DSCP_TRUST_ENA           BIT(0)
+#define ANA_CL_DSCP_CFG_DSCP_TRUST_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_DSCP_CFG_DSCP_TRUST_ENA, x)
+#define ANA_CL_DSCP_CFG_DSCP_TRUST_ENA_GET(x)\
+	FIELD_GET(ANA_CL_DSCP_CFG_DSCP_TRUST_ENA, x)
+
 /*      ANA_L2:COMMON:AUTO_LRN_CFG */
 #define ANA_L2_AUTO_LRN_CFG       __REG(TARGET_ANA_L2, 0, 1, 566024, 0, 1, 700, 24, 0, 1, 4)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 19516ccad533..afe117736e25 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -258,6 +258,7 @@ struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)

 	ndev->netdev_ops = &sparx5_port_netdev_ops;
 	ndev->ethtool_ops = &sparx5_ethtool_ops;
+	ndev->dcbnl_ops = &sparx5_dcbnl_ops;

 	eth_hw_addr_gen(ndev, sparx5->base_mac, portno + 1);

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index 32709d21ab2f..9ffaaf34d196 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -6,6 +6,7 @@

 #include <linux/module.h>
 #include <linux/phy/phy.h>
+#include <net/dcbnl.h>

 #include "sparx5_main_regs.h"
 #include "sparx5_main.h"
@@ -1144,3 +1145,39 @@ void sparx5_port_enable(struct sparx5_port *port, bool enable)
 		 sparx5,
 		 QFWD_SWITCH_PORT_MODE(port->portno));
 }
+
+int sparx5_port_qos_set(struct sparx5_port *port,
+			struct sparx5_port_qos *qos)
+{
+	sparx5_port_qos_pcp_set(port, &qos->pcp);
+
+	return 0;
+}
+
+int sparx5_port_qos_pcp_set(const struct sparx5_port *port,
+			    struct sparx5_port_qos_pcp *qos)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	u8 *pcp_itr = qos->map.map;
+	u8 pcp, dp;
+	int i;
+
+	/* Enable/disable pcp and dp for qos classification. */
+	spx5_rmw(ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA_SET(1) |
+		 ANA_CL_QOS_CFG_PCP_DEI_DP_ENA_SET(1),
+		 ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA | ANA_CL_QOS_CFG_PCP_DEI_DP_ENA,
+		 sparx5, ANA_CL_QOS_CFG(port->portno));
+
+	/* Map each pcp and dei value to priority and dp */
+	for (i = 0; i < ARRAY_SIZE(qos->map.map); i++) {
+		pcp = *(pcp_itr + i);
+		dp = (i <= 7) ? 0 : 1;
+		spx5_rmw(ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_QOS_VAL_SET(pcp) |
+			 ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_DP_VAL_SET(dp),
+			 ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_QOS_VAL |
+			 ANA_CL_PCP_DEI_MAP_CFG_PCP_DEI_DP_VAL, sparx5,
+			 ANA_CL_PCP_DEI_MAP_CFG(port->portno, i));
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
index 2f8043eac71b..9c5fb6b651db 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
@@ -91,4 +91,21 @@ int sparx5_get_port_status(struct sparx5 *sparx5,
 void sparx5_port_enable(struct sparx5_port *port, bool enable);
 int sparx5_port_fwd_urg(struct sparx5 *sparx5, u32 speed);

+struct sparx5_port_qos_pcp_map {
+	u8 map[16];
+};
+
+struct sparx5_port_qos_pcp {
+	struct sparx5_port_qos_pcp_map map;
+};
+
+struct sparx5_port_qos {
+	struct sparx5_port_qos_pcp pcp;
+};
+
+int sparx5_port_qos_set(struct sparx5_port *port, struct sparx5_port_qos *qos);
+
+int sparx5_port_qos_pcp_set(const struct sparx5_port *port,
+			    struct sparx5_port_qos_pcp *qos);
+
 #endif	/* __SPARX5_PORT_H__ */
--
2.34.1

