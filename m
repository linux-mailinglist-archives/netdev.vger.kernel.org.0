Return-Path: <netdev+bounces-2442-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D75701F75
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 22:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93A281C20998
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 20:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E803BA51;
	Sun, 14 May 2023 20:11:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA0DBE63
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 20:11:26 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC6A1B5;
	Sun, 14 May 2023 13:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684095084; x=1715631084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yrb3pDNxvAATlpskUxQrANdNbmpek+fd2b6P+O2IQV0=;
  b=ZqMRPJ5nEJOTCbwLky3dZquxSLWnGnyZtJ27uLZMrO88AAmnNm1a/+Jc
   KPk9qE+vneLkUEMxruwTZe/fLE5UAcUpKZBjsBZYhU6wl5Da1DXGkBFXD
   MMp6bnNm+XZqpCdbX8VyL2dkaCqGnH5/DrhbzesfCkMlGu7G4UmKCmRw9
   9mMGldCIBRfaxooZQUabZ2ob0ShXie7VBua+wAwzZR173f+ogfcCUsQhE
   V42h/QQP2ngmx2z/s9u8kbMzXWkpwywHqVt6fm9An7mkdebW3GLLv7dKi
   ZJ4oYjICKgZr6Omn4mzR8Hwccf/f09/T/yV4g+itqUFbl3LqW5F6rwb04
   g==;
X-IronPort-AV: E=Sophos;i="5.99,274,1677567600"; 
   d="scan'208";a="225253601"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 May 2023 13:11:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 14 May 2023 13:11:23 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Sun, 14 May 2023 13:11:21 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/7] net: lan966x: Add support for offloading pcp table
Date: Sun, 14 May 2023 22:10:24 +0200
Message-ID: <20230514201029.1867738-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
References: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for offloading pcp app entries. Lan966x has 8 priority
queues per port and for each priority it also has a drop precedence.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Kconfig    |  11 ++
 .../net/ethernet/microchip/lan966x/Makefile   |   1 +
 .../ethernet/microchip/lan966x/lan966x_dcb.c  | 104 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |   2 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  25 +++++
 .../ethernet/microchip/lan966x/lan966x_port.c |  30 +++++
 6 files changed, 173 insertions(+)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net/ethernet/microchip/lan966x/Kconfig
index 571e6d4da1e9d..f9ebffc04eb85 100644
--- a/drivers/net/ethernet/microchip/lan966x/Kconfig
+++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
@@ -10,3 +10,14 @@ config LAN966X_SWITCH
 	select VCAP
 	help
 	  This driver supports the Lan966x network switch device.
+
+config LAN966X_DCB
+	bool "Data Center Bridging (DCB) support"
+	depends on LAN966X_SWITCH && DCB
+	default y
+	help
+	  Say Y here if you want to use Data Center Bridging (DCB) in the
+	  driver. This can be used to assign priority to traffic, based on
+	  DSCP and PCP.
+
+	  If unsure, set to Y.
diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 7b0cda4ffa6b5..3b6ac331691d0 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -15,6 +15,7 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_xdp.o lan966x_vcap_impl.o lan966x_vcap_ag_api.o \
 			lan966x_tc_flower.o lan966x_goto.o
 
+lan966x-switch-$(CONFIG_LAN966X_DCB) += lan966x_dcb.o
 lan966x-switch-$(CONFIG_DEBUG_FS) += lan966x_vcap_debugfs.o
 
 # Provide include files
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
new file mode 100644
index 0000000000000..8ec64336abd5f
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+static void lan966x_dcb_app_update(struct net_device *dev, bool enable)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x_port_qos qos = {0};
+	struct dcb_app app_itr;
+
+	/* Get pcp ingress mapping */
+	for (int i = 0; i < ARRAY_SIZE(qos.pcp.map); i++) {
+		app_itr.selector = DCB_APP_SEL_PCP;
+		app_itr.protocol = i;
+		qos.pcp.map[i] = dcb_getapp(dev, &app_itr);
+	}
+
+	qos.pcp.enable = enable;
+	lan966x_port_qos_set(port, &qos);
+}
+
+static int lan966x_dcb_app_validate(struct net_device *dev,
+				    const struct dcb_app *app)
+{
+	int err = 0;
+
+	switch (app->selector) {
+	/* Pcp checks */
+	case DCB_APP_SEL_PCP:
+		if (app->protocol >= LAN966X_PORT_QOS_PCP_DEI_COUNT)
+			err = -EINVAL;
+		else if (app->priority >= NUM_PRIO_QUEUES)
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
+static int lan966x_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
+{
+	int err;
+
+	err = dcb_ieee_delapp(dev, app);
+	if (err < 0)
+		return err;
+
+	lan966x_dcb_app_update(dev, false);
+
+	return 0;
+}
+
+static int lan966x_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
+{
+	struct dcb_app app_itr;
+	int err;
+	u8 prio;
+
+	err = lan966x_dcb_app_validate(dev, app);
+	if (err)
+		goto out;
+
+	/* Delete current mapping, if it exists */
+	prio = dcb_getapp(dev, app);
+	if (prio) {
+		app_itr = *app;
+		app_itr .priority = prio;
+		dcb_ieee_delapp(dev, &app_itr);
+	}
+
+	err = dcb_ieee_setapp(dev, app);
+	if (err)
+		goto out;
+
+	lan966x_dcb_app_update(dev, true);
+
+out:
+	return err;
+}
+
+static const struct dcbnl_rtnl_ops lan966x_dcbnl_ops = {
+	.ieee_setapp = lan966x_dcb_ieee_setapp,
+	.ieee_delapp = lan966x_dcb_ieee_delapp,
+};
+
+void lan966x_dcb_init(struct lan966x *lan966x)
+{
+	for (int p = 0; p < lan966x->num_phys_ports; ++p) {
+		struct lan966x_port *port;
+
+		port = lan966x->ports[p];
+		if (!port)
+			continue;
+
+		port->dev->dcbnl_ops = &lan966x_dcbnl_ops;
+	}
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index ee2698698d71a..f6931dfb3e68e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -1223,6 +1223,8 @@ static int lan966x_probe(struct platform_device *pdev)
 	if (err)
 		goto cleanup_fdma;
 
+	lan966x_dcb_init(lan966x);
+
 	return 0;
 
 cleanup_fdma:
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 882d5a08e7d51..b9ca47ab6e8be 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -104,6 +104,11 @@
 #define LAN966X_VCAP_CID_ES0_L0 VCAP_CID_EGRESS_L0 /* ES0 lookup 0 */
 #define LAN966X_VCAP_CID_ES0_MAX (VCAP_CID_EGRESS_L1 - 1) /* ES0 Max */
 
+#define LAN966X_PORT_QOS_PCP_COUNT	8
+#define LAN966X_PORT_QOS_DEI_COUNT	8
+#define LAN966X_PORT_QOS_PCP_DEI_COUNT \
+	(LAN966X_PORT_QOS_PCP_COUNT + LAN966X_PORT_QOS_DEI_COUNT)
+
 /* MAC table entry types.
  * ENTRYTYPE_NORMAL is subject to aging.
  * ENTRYTYPE_LOCKED is not subject to aging.
@@ -392,6 +397,15 @@ struct lan966x_port_tc {
 	struct flow_stats mirror_stat;
 };
 
+struct lan966x_port_qos_pcp {
+	u8 map[LAN966X_PORT_QOS_PCP_DEI_COUNT];
+	bool enable;
+};
+
+struct lan966x_port_qos {
+	struct lan966x_port_qos_pcp pcp;
+};
+
 struct lan966x_port {
 	struct net_device *dev;
 	struct lan966x *lan966x;
@@ -456,6 +470,9 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
 			 struct lan966x_port_config *config);
 void lan966x_port_init(struct lan966x_port *port);
 
+void lan966x_port_qos_set(struct lan966x_port *port,
+			  struct lan966x_port_qos *qos);
+
 int lan966x_mac_ip_learn(struct lan966x *lan966x,
 			 bool cpu_copy,
 			 const unsigned char mac[ETH_ALEN],
@@ -680,6 +697,14 @@ int lan966x_goto_port_del(struct lan966x_port *port,
 			  unsigned long goto_id,
 			  struct netlink_ext_ack *extack);
 
+#ifdef CONFIG_LAN966X_DCB
+void lan966x_dcb_init(struct lan966x *lan966x);
+#else
+static inline void lan966x_dcb_init(struct lan966x *lan966x)
+{
+}
+#endif
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index 0050fcb988b75..0cee8127c48eb 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -394,6 +394,36 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
 	return 0;
 }
 
+static void lan966x_port_qos_pcp_set(struct lan966x_port *port,
+				     struct lan966x_port_qos_pcp *qos)
+{
+	u8 *pcp_itr = qos->map;
+	u8 pcp, dp;
+
+	lan_rmw(ANA_QOS_CFG_QOS_PCP_ENA_SET(qos->enable),
+		ANA_QOS_CFG_QOS_PCP_ENA,
+		port->lan966x, ANA_QOS_CFG(port->chip_port));
+
+	/* Map PCP and DEI to priority */
+	for (int i = 0; i < ARRAY_SIZE(qos->map); i++) {
+		pcp = *(pcp_itr + i);
+		dp = (i < LAN966X_PORT_QOS_PCP_COUNT) ? 0 : 1;
+
+		lan_rmw(ANA_PCP_DEI_CFG_QOS_PCP_DEI_VAL_SET(pcp) |
+			ANA_PCP_DEI_CFG_DP_PCP_DEI_VAL_SET(dp),
+			ANA_PCP_DEI_CFG_QOS_PCP_DEI_VAL |
+			ANA_PCP_DEI_CFG_DP_PCP_DEI_VAL,
+			port->lan966x,
+			ANA_PCP_DEI_CFG(port->chip_port, i));
+	}
+}
+
+void lan966x_port_qos_set(struct lan966x_port *port,
+			  struct lan966x_port_qos *qos)
+{
+	lan966x_port_qos_pcp_set(port, &qos->pcp);
+}
+
 void lan966x_port_init(struct lan966x_port *port)
 {
 	struct lan966x_port_config *config = &port->config;
-- 
2.38.0


