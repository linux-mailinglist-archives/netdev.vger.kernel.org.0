Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE50B611251
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJ1NHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiJ1NGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:06:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E801D6A5A;
        Fri, 28 Oct 2022 06:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666962365; x=1698498365;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XnOykJ3WzojacAhL21M7SkZuv9hexXCU6Rx2oM4MhDM=;
  b=kup7cLb9W4WQOjTFHnjacbr3nKM6VUftxkhSDaH0D3YIkxk5fwlTHs0H
   V+exkxzo2r55kVNcLj+RmM8lvm+cxMkEl9XHmuDJQXsNY66Cn6/fwNHYh
   OOUn8/Wp5nweIBjn17GsYUxD1SqqxAk9ZmFaFvYx72VPYwoxAJXr9zpIw
   tkRc0Pe2OnQ4ojvlCO/Sh30ruXqCwMcYMhl2jjPVo6RQ90jErQidy3Fha
   IoYDMbSerh30UYfJo6YOcTGo0JTylVOuFRhhAzZPvAT8LIlokHypNNDRu
   LSOFhVGUEGPr5u9sssSzgN5TU57I4oFQNzf430tH1fUdZ9CSxeWMDtssO
   g==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="197455671"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2022 06:06:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 28 Oct 2022 06:04:43 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 28 Oct 2022 06:04:39 -0700
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
Subject: [PATCH net-next v5 3/6] net: microchip: sparx5: add support for offloading pcp table
Date:   Fri, 28 Oct 2022 15:14:00 +0200
Message-ID: <20221028131403.1055694-4-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028131403.1055694-1-daniel.machon@microchip.com>
References: <20221028131403.1055694-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new registers and functions to support offload of pcp app entries.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/Kconfig |  10 ++
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +
 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 116 ++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_main.h   |  11 ++
 .../microchip/sparx5/sparx5_main_regs.h       | 127 +++++++++++++++++-
 .../ethernet/microchip/sparx5/sparx5_port.c   |  37 +++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |  17 +++
 .../ethernet/microchip/sparx5/sparx5_qos.c    |   4 +
 8 files changed, 322 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Kconfig b/drivers/net/ethernet/microchip/sparx5/Kconfig
index 98e27530a91f..53b9904b21f7 100644
--- a/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ b/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -12,3 +12,13 @@ config SPARX5_SWITCH
 	select VCAP
 	help
 	  This driver supports the Sparx5 network switch device.
+
+config SPARX5_DCB
+	bool "Data Center Bridging (DCB) support"
+	depends on SPARX5_SWITCH && DCB
+	default y
+	help
+	  Say Y here if you want to use Data Center Bridging (DCB) in the
+	  driver.
+
+	  If unsure, set to Y.
diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index ee2c42f66742..38adf917bc09 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -11,5 +11,7 @@ sparx5-switch-y  := sparx5_main.o sparx5_packet.o \
  sparx5_ptp.o sparx5_pgid.o sparx5_tc.o sparx5_qos.o \
  sparx5_vcap_impl.o sparx5_vcap_ag_api.o sparx5_tc_flower.o
 
+sparx5-switch-$(CONFIG_SPARX5_DCB) += sparx5_dcb.o
+
 # Provide include files
 ccflags-y += -I$(srctree)/drivers/net/ethernet/microchip/vcap
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
new file mode 100644
index 000000000000..2a6e875a5860
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
@@ -0,0 +1,116 @@
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
+
+int sparx5_dcb_init(struct sparx5 *sparx5)
+{
+	struct sparx5_port *port;
+	int i;
+
+	for (i = 0; i < SPX5_PORTS; i++) {
+		port = sparx5->ports[i];
+		if (!port)
+			continue;
+		port->ndev->dcbnl_ops = &sparx5_dcbnl_ops;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 2ab22a7b799e..5985f2087d7f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -359,6 +359,16 @@ int sparx5_config_dsm_calendar(struct sparx5 *sparx5);
 void sparx5_get_stats64(struct net_device *ndev, struct rtnl_link_stats64 *stats);
 int sparx_stats_init(struct sparx5 *sparx5);
 
+/* sparx5_dcb.c */
+#ifdef CONFIG_SPARX5_DCB
+int sparx5_dcb_init(struct sparx5 *sparx5);
+#else
+static inline int sparx5_dcb_init(struct sparx5 *sparx5)
+{
+	return 0;
+}
+#endif
+
 /* sparx5_netdev.c */
 void sparx5_set_port_ifh_timestamp(void *ifh_hdr, u64 timestamp);
 void sparx5_set_port_ifh_rew_op(void *ifh_hdr, u32 rew_op);
@@ -424,6 +434,7 @@ static inline bool sparx5_is_baser(phy_interface_t interface)
 extern const struct phylink_mac_ops sparx5_phylink_mac_ops;
 extern const struct phylink_pcs_ops sparx5_phylink_pcs_ops;
 extern const struct ethtool_ops sparx5_ethtool_ops;
+extern const struct dcbnl_rtnl_ops sparx5_dcbnl_ops;
 
 /* Calculate raw offset */
 static inline __pure int spx5_offset(int id, int tinst, int tcnt,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
index c42195f4ec4d..6c93dd6b01b0 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
@@ -4,8 +4,8 @@
  * Copyright (c) 2021 Microchip Technology Inc.
  */
 
-/* This file is autogenerated by cml-utils 2022-09-12 14:22:42 +0200.
- * Commit ID: 06aecbca4eab6e85d87f665fe6b6348c48146245
+/* This file is autogenerated by cml-utils 2022-09-28 11:17:02 +0200.
+ * Commit ID: 385c8a11d71a9f6a60368d3a3cb648fa257b479a
  */
 
 #ifndef _SPARX5_MAIN_REGS_H_
@@ -750,6 +750,96 @@ enum sparx5_target {
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
 
@@ -762,6 +852,39 @@ enum sparx5_target {
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
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
index 1e79d0ef0cb8..379e540e5e6a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
@@ -389,6 +389,10 @@ int sparx5_qos_init(struct sparx5 *sparx5)
 	if (ret < 0)
 		return ret;
 
+	ret = sparx5_dcb_init(sparx5);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
-- 
2.34.1

