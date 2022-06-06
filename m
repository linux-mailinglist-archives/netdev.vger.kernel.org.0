Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1834553E5F2
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbiFFLF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 07:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiFFLFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 07:05:53 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C951AD59C;
        Mon,  6 Jun 2022 04:05:52 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 256B5g5w128234;
        Mon, 6 Jun 2022 06:05:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654513542;
        bh=qXkB1x+MmRagdhLDewmxX7TfEL4AnXfF86Tm40n+KpQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=UAhujj2UGXDRES1N/GY4XGoUUsOUWLqwThs3ottLn2DFnAF+qp5OoZuzOqIOsyfFI
         VXmwLY5jwsEMS5gBotznDwdtQBSzuuuDVlKjdtfHT5SfCT+VsAqeEOcqASUmCn4L2+
         7cQxHtxj0+gEG2sRwPeCWK5wHl+e5zrc0NK/19ds=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 256B5gFR079615
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Jun 2022 06:05:42 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 6
 Jun 2022 06:05:41 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 6 Jun 2022 06:05:41 -0500
Received: from ula0492258.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 256B57G4072083;
        Mon, 6 Jun 2022 06:05:36 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: [PATCH v3 2/3] net: ethernet: ti: am65-cpsw: Add support for J7200 CPSW5G
Date:   Mon, 6 Jun 2022 16:34:42 +0530
Message-ID: <20220606110443.30362-3-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220606110443.30362-1-s-vadapalli@ti.com>
References: <20220606110443.30362-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPSW5G in J7200 supports additional modes like QSGMII and SGMII.
Add new compatible for J7200 and enable QSGMII mode in am65-cpsw driver.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 32 ++++++++++++++++++++++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  2 ++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index fb92d4c1547d..db94e8cdef56 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -74,6 +74,9 @@
 #define AM65_CPSW_PORTN_REG_TS_VLAN_LTYPE_REG	0x318
 #define AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2       0x31C
 
+#define AM65_CPSW_SGMII_CONTROL_REG		0x010
+#define AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE	BIT(0)
+
 #define AM65_CPSW_CTL_VLAN_AWARE		BIT(1)
 #define AM65_CPSW_CTL_P0_ENABLE			BIT(2)
 #define AM65_CPSW_CTL_P0_TX_CRC_REMOVE		BIT(13)
@@ -1409,7 +1412,14 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
 				      const struct phylink_link_state *state)
 {
-	/* Currently not used */
+	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
+							  phylink_config);
+	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
+	struct am65_cpsw_common *common = port->common;
+
+	if (common->pdata.extra_modes & BIT(state->interface))
+		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
+		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
 }
 
 static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned int mode,
@@ -1847,6 +1857,8 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		port->common = common;
 		port->port_base = common->cpsw_base + AM65_CPSW_NU_PORTS_BASE +
 				  AM65_CPSW_NU_PORTS_OFFSET * (port_id);
+		if (common->pdata.extra_modes)
+			port->sgmii_base = common->ss_base + AM65_CPSW_SGMII_BASE * (port_id);
 		port->stat_base = common->cpsw_base + AM65_CPSW_NU_STATS_BASE +
 				  (AM65_CPSW_NU_STATS_PORT_OFFSET * port_id);
 		port->name = of_get_property(port_np, "label", NULL);
@@ -1981,7 +1993,15 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	port->slave.phylink_config.type = PHYLINK_NETDEV;
 	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD;
 
-	phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
+	if (phy_interface_mode_is_rgmii(port->slave.phy_if)) {
+		phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
+	} else if (common->pdata.extra_modes & BIT(port->slave.phy_if)) {
+		__set_bit(PHY_INTERFACE_MODE_QSGMII,
+			  port->slave.phylink_config.supported_interfaces);
+	} else {
+		dev_err(dev, "selected phy-mode is not supported\n");
+		return -EOPNOTSUPP;
+	}
 
 	phylink = phylink_create(&port->slave.phylink_config,
 				 of_node_to_fwnode(port->slave.phy_node),
@@ -2608,10 +2628,18 @@ static const struct am65_cpsw_pdata am64x_cpswxg_pdata = {
 	.fdqring_mode = K3_RINGACC_RING_MODE_RING,
 };
 
+static const struct am65_cpsw_pdata j7200_cpswxg_pdata = {
+	.quirks = 0,
+	.ale_dev_id = "am64-cpswxg",
+	.fdqring_mode = K3_RINGACC_RING_MODE_RING,
+	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII),
+};
+
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
 	{ .compatible = "ti,am654-cpsw-nuss", .data = &am65x_sr1_0},
 	{ .compatible = "ti,j721e-cpsw-nuss", .data = &j721e_pdata},
 	{ .compatible = "ti,am642-cpsw-nuss", .data = &am64x_cpswxg_pdata},
+	{ .compatible = "ti,j7200-cpswxg-nuss", .data = &j7200_cpswxg_pdata},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, am65_cpsw_nuss_of_mtable);
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index ac945631bf2f..2c9850fdfcb6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -46,6 +46,7 @@ struct am65_cpsw_port {
 	const char			*name;
 	u32				port_id;
 	void __iomem			*port_base;
+	void __iomem			*sgmii_base;
 	void __iomem			*stat_base;
 	void __iomem			*fetch_ram_base;
 	bool				disabled;
@@ -88,6 +89,7 @@ struct am65_cpsw_rx_chn {
 
 struct am65_cpsw_pdata {
 	u32	quirks;
+	u64	extra_modes;
 	enum k3_ring_mode fdqring_mode;
 	const char	*ale_dev_id;
 };
-- 
2.36.1

